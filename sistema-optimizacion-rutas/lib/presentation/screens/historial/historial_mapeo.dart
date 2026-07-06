import '../../../core/utils/geo_utils.dart';
import '../../../data/models/deposito.dart';
import '../../../data/models/historial_calculo.dart';
import '../../../data/models/punto_entrega.dart';
import '../../../data/models/vehiculo.dart';
import '../../../domain/asignacion_vehiculos.dart';
import '../../providers/escenario_provider.dart';
import '../mapa_resultado/mapa_resultado_screen.dart';

/// Reconstruye un [MapaResultadoScreen] a partir de una entrada del
/// historial (con su detalle ya cargado, `obtenerDetalle`), reutilizando
/// toda la UI existente (colores, color por tramo, distancias por nodo,
/// tramo de regreso, botón de compartir) sin una pantalla de mapa nueva —
/// `MapaResultadoScreen` no depende de ningún repositorio, solo de sus
/// parámetros.
///
/// `id: null` en el depósito/puntos/vehículo sintéticos es seguro porque
/// esos modelos ya tienen `id` nullable — no representan registros reales
/// de la base, solo la copia ("snapshot") guardada en el historial.
MapaResultadoScreen mapaResultadoDesdeHistorial(HistorialCalculo calculo) {
  final deposito = Deposito(
    nombre: calculo.depositoNombre,
    latitud: calculo.depositoLatitud,
    longitud: calculo.depositoLongitud,
  );

  final rutas = [
    for (final ruta in calculo.rutas)
      RutaConGeometria(
        rutaAsignada: RutaAsignada(
          paradas: [
            for (final parada in ruta.paradas)
              PuntoEntrega(
                nombre: parada.nombre,
                latitud: parada.latitud,
                longitud: parada.longitud,
                demanda: parada.demanda,
              ),
          ],
          vehiculo: ruta.vehiculoNombre != null
              ? Vehiculo(
                  nombre: ruta.vehiculoNombre!,
                  capacidadMaxima: ruta.vehiculoCapacidadMaxima ?? 0,
                  costoEstimadoPorKm: ruta.vehiculoCostoEstimadoPorKm,
                  tipoFlota: ruta.vehiculoTipoFlota,
                )
              : null,
        ),
        puntosRuta: ruta.geometriaPolyline != null
            ? decodificarPolyline(ruta.geometriaPolyline!)
            : const [],
        distanciaMetros: ruta.distanciaMetros,
        duracionSegundos: ruta.duracionSegundos,
        distanciasPorTramoMetros: ruta.distanciasPorTramoMetros,
        geometriaPolyline: ruta.geometriaPolyline,
      ),
  ];

  return MapaResultadoScreen(
    deposito: deposito,
    rutas: rutas,
    vehiculosFaltantes: calculo.vehiculosFaltantes,
    metodo: calculo.metodo,
  );
}
