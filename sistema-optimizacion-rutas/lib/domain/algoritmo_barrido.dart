import '../core/utils/geo_utils.dart';
import '../data/models/deposito.dart';
import '../data/models/punto_entrega.dart';
import '../data/models/vehiculo.dart';
import 'asignacion_vehiculos.dart';

/// M4 — Algoritmo de Barrido (Sweep). Ver CLAUDE.md sección 7.2 para el
/// pseudocódigo exacto que implementa esta función.
///
/// [matrizDistancias] incluye el depósito en el índice `0`; `puntosEntrega[i]`
/// corresponde a la fila/columna `i + 1` de la matriz (misma convención que
/// [calcularRutasAhorros]).
ResultadoOptimizacion calcularRutasBarrido({
  required Deposito deposito,
  required List<PuntoEntrega> puntosEntrega,
  required List<List<double>> matrizDistancias,
  required List<Vehiculo> vehiculosDisponibles,
}) {
  if (vehiculosDisponibles.isEmpty) {
    throw ArgumentError('Se requiere al menos un vehículo disponible.');
  }

  final capacidadMaxDisponible = vehiculosDisponibles
      .map((v) => v.capacidadMaxima)
      .reduce((a, b) => a > b ? a : b);

  // 1-2. Ángulo polar de cada punto respecto al depósito, orden ascendente.
  final indicesOrdenados = List<int>.generate(puntosEntrega.length, (i) => i)
    ..sort((a, b) {
      final anguloA = anguloPolar(
        latOrigen: deposito.latitud,
        lonOrigen: deposito.longitud,
        latPunto: puntosEntrega[a].latitud,
        lonPunto: puntosEntrega[a].longitud,
      );
      final anguloB = anguloPolar(
        latOrigen: deposito.latitud,
        lonOrigen: deposito.longitud,
        latPunto: puntosEntrega[b].latitud,
        lonPunto: puntosEntrega[b].longitud,
      );
      return anguloA.compareTo(anguloB);
    });

  // 3. Acumular puntos en clusters respetando la capacidad máxima disponible.
  final clusters = <List<int>>[];
  var clusterActual = <int>[];
  var demandaActual = 0.0;
  for (final idx in indicesOrdenados) {
    final demandaPunto = puntosEntrega[idx].demanda;
    if (clusterActual.isNotEmpty &&
        demandaActual + demandaPunto > capacidadMaxDisponible) {
      clusters.add(clusterActual);
      clusterActual = [];
      demandaActual = 0;
    }
    clusterActual.add(idx);
    demandaActual += demandaPunto;
  }
  if (clusterActual.isNotEmpty) clusters.add(clusterActual);

  // 4. Dentro de cada cluster, ordenar las paradas por vecino más cercano.
  final rutas = clusters
      .map(
        (cluster) => _ordenarPorVecinoMasCercano(cluster, matrizDistancias),
      )
      .map((indices) => indices.map((i) => puntosEntrega[i]).toList())
      .toList();

  // 5. Asignar cada ruta resultante a un vehículo disponible.
  return asignarVehiculos(rutas, vehiculosDisponibles);
}

/// Heurística simple de vecino más cercano sobre la submatriz de distancias
/// correspondiente a los puntos de [cluster] (índices 0-based sobre la lista
/// original de puntos de entrega, no sobre la matriz).
List<int> _ordenarPorVecinoMasCercano(
  List<int> cluster,
  List<List<double>> matrizDistancias,
) {
  if (cluster.length <= 1) return List<int>.from(cluster);

  final pendientes = [...cluster];

  int extraerMasCercanoA(int filaDesde) {
    var mejorPos = 0;
    for (var k = 1; k < pendientes.length; k++) {
      final distanciaCandidato = matrizDistancias[filaDesde][pendientes[k] + 1];
      final distanciaMejor = matrizDistancias[filaDesde][pendientes[mejorPos] + 1];
      if (distanciaCandidato < distanciaMejor) mejorPos = k;
    }
    return pendientes.removeAt(mejorPos);
  }

  final ruta = <int>[];
  // Primera parada: la más cercana al depósito (fila 0 de la matriz).
  ruta.add(extraerMasCercanoA(0));
  while (pendientes.isNotEmpty) {
    ruta.add(extraerMasCercanoA(ruta.last + 1));
  }
  return ruta;
}
