// ignore_for_file: prefer_initializing_formals (campos privados, parámetros
// públicos con nombre propio; ver mismo caso en osrm_client.dart)
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

import '../../core/paleta_rutas.dart';
import '../../core/utils/geo_utils.dart';
import '../../data/models/deposito.dart';
import '../../data/models/escenario_optimizacion.dart';
import '../../data/models/punto_entrega.dart';
import '../../data/models/vehiculo.dart';
import '../../data/remote/osrm_client.dart';
import '../../data/repositories/deposito_repository.dart';
import '../../data/repositories/punto_entrega_repository.dart';
import '../../data/repositories/vehiculo_repository.dart';
import '../../domain/algoritmo_ahorros.dart';
import '../../domain/algoritmo_barrido.dart';
import '../../domain/asignacion_vehiculos.dart';

enum EstadoCalculo { inactivo, cargando, listo, error }

/// Una ruta ya resuelta por Ahorros/Barrido, con su geometría real (decodificada
/// desde OSRM `/route/`) y el color con el que se dibuja en el mapa.
class RutaConGeometria {
  const RutaConGeometria({
    required this.rutaAsignada,
    required this.puntosRuta,
    required this.distanciaMetros,
    required this.duracionSegundos,
    required this.color,
  });

  final RutaAsignada rutaAsignada;
  final List<LatLng> puntosRuta;
  final double? distanciaMetros;
  final double? duracionSegundos;
  final ColorRuta color;
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
  }) : _depositoRepository = depositoRepository,
       _puntoEntregaRepository = puntoEntregaRepository,
       _vehiculoRepository = vehiculoRepository,
       _osrmClient = osrmClient;

  final DepositoRepository _depositoRepository;
  final PuntoEntregaRepository _puntoEntregaRepository;
  final VehiculoRepository _vehiculoRepository;
  final OsrmClient _osrmClient;

  bool cargandoDatosIniciales = true;
  Deposito? deposito;
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
    final depositos = await _depositoRepository.obtenerTodos();
    deposito = depositos.isNotEmpty ? depositos.first : null;
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

  Future<void> calcular() async {
    final deposito = this.deposito;
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
            color: ruta.vehiculo != null
                ? colorParaRuta(i)
                : colorSinAsignar,
          ),
        );
      }

      rutas = rutasConGeometria;
      vehiculosFaltantes = resultado.vehiculosFaltantes;
      estado = EstadoCalculo.listo;
      notifyListeners();
    } on OsrmException catch (e) {
      _fallarCon(e.mensaje);
    }
  }

  void _fallarCon(String mensaje) {
    estado = EstadoCalculo.error;
    mensajeError = mensaje;
    notifyListeners();
  }
}
