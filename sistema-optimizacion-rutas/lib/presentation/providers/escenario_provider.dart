// ignore_for_file: prefer_initializing_formals (campos privados, parámetros
// públicos con nombre propio; ver mismo caso en osrm_client.dart)
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

import '../../core/utils/geo_utils.dart';
import '../../data/models/deposito.dart';
import '../../data/models/escenario_optimizacion.dart';
import '../../data/models/historial_calculo.dart';
import '../../data/models/punto_entrega.dart';
import '../../data/models/vehiculo.dart';
import '../../data/remote/osrm_client.dart';
import '../../data/repositories/deposito_repository.dart';
import '../../data/repositories/historial_repository.dart';
import '../../data/repositories/punto_entrega_repository.dart';
import '../../data/repositories/vehiculo_repository.dart';
import '../../domain/algoritmo_ahorros.dart';
import '../../domain/algoritmo_barrido.dart';
import '../../domain/asignacion_vehiculos.dart';

enum EstadoCalculo { inactivo, cargando, listo, error }

/// Una ruta ya resuelta por Ahorros/Barrido, con su geometría real
/// (decodificada desde OSRM `/route/`). El color con el que se dibuja lo
/// decide la pantalla de Mapa (`colorParaRuta`), no el provider — así el
/// control de color por ruta puede recalcularlo sin volver a pedirle nada a
/// OSRM.
class RutaConGeometria {
  const RutaConGeometria({
    required this.rutaAsignada,
    required this.puntosRuta,
    required this.distanciaMetros,
    required this.duracionSegundos,
    this.distanciasPorTramoMetros = const [],
    this.geometriaPolyline,
  });

  final RutaAsignada rutaAsignada;
  final List<LatLng> puntosRuta;
  final double? distanciaMetros;
  final double? duracionSegundos;

  /// Distancia de cada tramo entre paradas consecutivas (`[i]` es el tramo
  /// que termina en la parada `i + 1`: depósito→parada 1 es `[0]`,
  /// parada 1→parada 2 es `[1]`, etc.) — para mostrar "cuánto falta hasta
  /// aquí" en el detalle de ruta.
  final List<double> distanciasPorTramoMetros;

  /// String de la polyline codificada tal como la devolvió OSRM (antes de
  /// decodificarla en [puntosRuta]) — se guarda para no tener que
  /// recodificarla al persistir esta ruta en el historial.
  final String? geometriaPolyline;
}

/// Estado y lógica de la pantalla de Optimización: selección de puntos y
/// vehículos, método elegido, y el cálculo end-to-end (OSRM + algoritmo +
/// geometría real) para la pantalla de Mapa.
class EscenarioProvider extends ChangeNotifier {
  EscenarioProvider({
    required DepositoRepository depositoRepository,
    required PuntoEntregaRepository puntoEntregaRepository,
    required VehiculoRepository vehiculoRepository,
    required OsrmClient osrmClient,
    required HistorialRepository historialRepository,
  }) : _depositoRepository = depositoRepository,
       _puntoEntregaRepository = puntoEntregaRepository,
       _vehiculoRepository = vehiculoRepository,
       _osrmClient = osrmClient,
       _historialRepository = historialRepository;

  final DepositoRepository _depositoRepository;
  final PuntoEntregaRepository _puntoEntregaRepository;
  final VehiculoRepository _vehiculoRepository;
  final OsrmClient _osrmClient;
  final HistorialRepository _historialRepository;

  bool cargandoDatosIniciales = true;
  List<Deposito> depositosDisponibles = [];
  Deposito? depositoSeleccionado;
  List<PuntoEntrega> puntosDisponibles = [];
  List<Vehiculo> vehiculosDisponibles = [];

  final Set<int> puntosSeleccionadosIds = {};
  final Set<int> vehiculosSeleccionadosIds = {};
  MetodoOptimizacion metodo = MetodoOptimizacion.ahorros;

  EstadoCalculo estado = EstadoCalculo.inactivo;
  String? mensajeError;
  List<RutaConGeometria> rutas = [];
  int vehiculosFaltantes = 0;

  Future<void> cargarDatosIniciales() async {
    depositosDisponibles = await _depositoRepository.obtenerTodos();
    depositoSeleccionado = depositosDisponibles.isNotEmpty
        ? depositosDisponibles.first
        : null;
    puntosDisponibles = await _puntoEntregaRepository.obtenerTodos();
    vehiculosDisponibles = await _vehiculoRepository.obtenerTodos();

    // Por defecto, todo seleccionado — el usuario puede desmarcar.
    puntosSeleccionadosIds.addAll(puntosDisponibles.map((p) => p.id!));
    vehiculosSeleccionadosIds.addAll(vehiculosDisponibles.map((v) => v.id!));

    cargandoDatosIniciales = false;
    notifyListeners();
  }

  void alternarPunto(int id) {
    if (!puntosSeleccionadosIds.remove(id)) puntosSeleccionadosIds.add(id);
    notifyListeners();
  }

  void alternarVehiculo(int id) {
    if (!vehiculosSeleccionadosIds.remove(id)) {
      vehiculosSeleccionadosIds.add(id);
    }
    notifyListeners();
  }

  void elegirMetodo(MetodoOptimizacion nuevoMetodo) {
    metodo = nuevoMetodo;
    notifyListeners();
  }

  void elegirDeposito(int id) {
    depositoSeleccionado = depositosDisponibles.firstWhere(
      (d) => d.id == id,
    );
    notifyListeners();
  }

  Future<void> calcular() async {
    final deposito = depositoSeleccionado;
    if (deposito == null) {
      _fallarCon('No hay un depósito configurado.');
      return;
    }

    final puntos = puntosDisponibles
        .where((p) => puntosSeleccionadosIds.contains(p.id))
        .toList();
    final vehiculos = vehiculosDisponibles
        .where((v) => vehiculosSeleccionadosIds.contains(v.id))
        .toList();

    if (puntos.isEmpty) {
      _fallarCon('Selecciona al menos un punto de entrega.');
      return;
    }
    if (vehiculos.isEmpty) {
      _fallarCon('Selecciona al menos un vehículo.');
      return;
    }

    estado = EstadoCalculo.cargando;
    mensajeError = null;
    notifyListeners();

    try {
      final coordenadasDeposito = OsrmCoordenada(
        lat: deposito.latitud,
        lon: deposito.longitud,
      );
      final coordenadas = [
        coordenadasDeposito,
        ...puntos.map((p) => OsrmCoordenada(lat: p.latitud, lon: p.longitud)),
      ];

      final matriz = await _osrmClient.obtenerMatriz(coordenadas);
      final distancias = matriz.distanciasMetros;
      if (distancias == null) {
        _fallarCon('OSRM no devolvió una matriz de distancias válida.');
        return;
      }

      final resultado = metodo == MetodoOptimizacion.ahorros
          ? calcularRutasAhorros(
              matrizDistancias: distancias,
              puntosEntrega: puntos,
              vehiculosDisponibles: vehiculos,
            )
          : calcularRutasBarrido(
              deposito: deposito,
              puntosEntrega: puntos,
              matrizDistancias: distancias,
              vehiculosDisponibles: vehiculos,
            );

      final rutasConGeometria = <RutaConGeometria>[];
      for (var i = 0; i < resultado.rutas.length; i++) {
        final ruta = resultado.rutas[i];
        final coordenadasRuta = [
          coordenadasDeposito,
          ...ruta.paradas.map(
            (p) => OsrmCoordenada(lat: p.latitud, lon: p.longitud),
          ),
          coordenadasDeposito,
        ];
        final respuestaRuta = await _osrmClient.obtenerRuta(coordenadasRuta);
        final geometria = respuestaRuta.geometriaPolyline;

        rutasConGeometria.add(
          RutaConGeometria(
            rutaAsignada: ruta,
            puntosRuta: geometria != null
                ? decodificarPolyline(geometria)
                : const [],
            distanciaMetros: respuestaRuta.distanciaMetros,
            duracionSegundos: respuestaRuta.duracionSegundos,
            distanciasPorTramoMetros: respuestaRuta.tramos
                .map((t) => t.distanciaMetros)
                .toList(),
            geometriaPolyline: geometria,
          ),
        );
      }

      rutas = rutasConGeometria;
      vehiculosFaltantes = resultado.vehiculosFaltantes;
      estado = EstadoCalculo.listo;
      notifyListeners();

      await _guardarEnHistorial(
        deposito: deposito,
        rutasConGeometria: rutasConGeometria,
        vehiculosFaltantes: resultado.vehiculosFaltantes,
      );
    } on OsrmException catch (e) {
      _fallarCon(e.mensaje);
    }
  }

  /// Guarda automáticamente un snapshot del cálculo recién resuelto (ver
  /// CLAUDE.md: historial inmutable, no debe depender de datos en vivo). Un
  /// fallo acá nunca debe convertir un cálculo exitoso en un error visible
  /// para el usuario — solo se registra en consola.
  Future<void> _guardarEnHistorial({
    required Deposito deposito,
    required List<RutaConGeometria> rutasConGeometria,
    required int vehiculosFaltantes,
  }) async {
    try {
      await _historialRepository.guardar(
        HistorialCalculo(
          fechaCalculo: DateTime.now(),
          metodo: metodo,
          depositoNombre: deposito.nombre,
          depositoLatitud: deposito.latitud,
          depositoLongitud: deposito.longitud,
          vehiculosFaltantes: vehiculosFaltantes,
          distanciaTotalMetros: rutasConGeometria.fold(
            0.0,
            (suma, r) => suma + (r.distanciaMetros ?? 0),
          ),
          cantidadRutas: rutasConGeometria.length,
          rutas: [
            for (var i = 0; i < rutasConGeometria.length; i++)
              HistorialRuta(
                orden: i,
                vehiculoNombre: rutasConGeometria[i].rutaAsignada.vehiculo?.nombre,
                vehiculoCapacidadMaxima:
                    rutasConGeometria[i].rutaAsignada.vehiculo?.capacidadMaxima,
                vehiculoCostoEstimadoPorKm: rutasConGeometria[i]
                    .rutaAsignada
                    .vehiculo
                    ?.costoEstimadoPorKm,
                vehiculoTipoFlota:
                    rutasConGeometria[i].rutaAsignada.vehiculo?.tipoFlota,
                paradas: [
                  for (final p in rutasConGeometria[i].rutaAsignada.paradas)
                    ParadaSnapshot(
                      nombre: p.nombre,
                      latitud: p.latitud,
                      longitud: p.longitud,
                      demanda: p.demanda,
                    ),
                ],
                distanciaMetros: rutasConGeometria[i].distanciaMetros,
                duracionSegundos: rutasConGeometria[i].duracionSegundos,
                distanciasPorTramoMetros:
                    rutasConGeometria[i].distanciasPorTramoMetros,
                geometriaPolyline: rutasConGeometria[i].geometriaPolyline,
              ),
          ],
        ),
      );
    } catch (e) {
      debugPrint('No se pudo guardar el cálculo en el historial: $e');
    }
  }

  void _fallarCon(String mensaje) {
    estado = EstadoCalculo.error;
    mensajeError = mensaje;
    notifyListeners();
  }
}
