import '../data/models/punto_entrega.dart';
import '../data/models/vehiculo.dart';
import 'asignacion_vehiculos.dart';

/// M3 — Algoritmo de Ahorros (Clarke-Wright Savings). Ver CLAUDE.md
/// sección 7.1 para el pseudocódigo exacto que implementa esta función.
///
/// [matrizDistancias] incluye el depósito en el índice `0`; `puntosEntrega[i]`
/// corresponde a la fila/columna `i + 1` de la matriz (misma convención que
/// `OsrmClient.obtenerMatriz`, que siempre envía el depósito primero).
///
/// La capacidad usada para decidir si dos rutas pueden fusionarse es la
/// mayor capacidad disponible en la flota (aún no se sabe qué vehículo
/// específico atenderá cada ruta resultante); la asignación final de
/// vehículo a cada ruta ocurre después, en [asignarVehiculos].
ResultadoOptimizacion calcularRutasAhorros({
  required List<List<double>> matrizDistancias,
  required List<PuntoEntrega> puntosEntrega,
  required List<Vehiculo> vehiculosDisponibles,
}) {
  if (vehiculosDisponibles.isEmpty) {
    throw ArgumentError('Se requiere al menos un vehículo disponible.');
  }

  final n = puntosEntrega.length;
  final capacidadMaxDisponible = vehiculosDisponibles
      .map((v) => v.capacidadMaxima)
      .reduce((a, b) => a > b ? a : b);

  // 1. Cada punto arranca en su propia ruta trivial: depósito -> i -> depósito.
  final rutaDePunto = List<int>.generate(n, (i) => i);
  final rutasPorId = <int, List<int>>{for (var i = 0; i < n; i++) i: [i]};

  double demandaDe(List<int> ruta) =>
      ruta.fold(0.0, (s, idx) => s + puntosEntrega[idx].demanda);

  // 2. Ahorro de cada par (i, j): ahorro = D[dep][i] + D[dep][j] - D[i][j].
  final ahorros = <_ParConAhorro>[];
  for (var i = 0; i < n; i++) {
    for (var j = 0; j < n; j++) {
      if (i == j) continue;
      final ahorro =
          matrizDistancias[0][i + 1] +
          matrizDistancias[0][j + 1] -
          matrizDistancias[i + 1][j + 1];
      ahorros.add(_ParConAhorro(i, j, ahorro));
    }
  }

  // 3. Ordenar por ahorro descendente.
  ahorros.sort((a, b) => b.ahorro.compareTo(a.ahorro));

  // 4-5. Fusionar rutas mientras la fusión sea válida (un solo recorrido de
  // la lista ordenada basta: una vez fusionados, i/j dejan de ser extremos
  // "libres" y las repeticiones posteriores del mismo par se descartan por
  // pertenecer ya a la misma ruta).
  for (final par in ahorros) {
    final rutaIId = rutaDePunto[par.i];
    final rutaJId = rutaDePunto[par.j];
    if (rutaIId == rutaJId) continue;

    final rutaI = rutasPorId[rutaIId]!;
    final rutaJ = rutasPorId[rutaJId]!;

    final iEsFinDeRuta = rutaI.last == par.i;
    final jEsInicioDeRuta = rutaJ.first == par.j;
    if (!iEsFinDeRuta || !jEsInicioDeRuta) continue;

    if (demandaDe(rutaI) + demandaDe(rutaJ) > capacidadMaxDisponible) {
      continue;
    }

    final fusion = [...rutaI, ...rutaJ];
    rutasPorId[rutaIId] = fusion;
    rutasPorId.remove(rutaJId);
    for (final idx in fusion) {
      rutaDePunto[idx] = rutaIId;
    }
  }

  final rutas = rutasPorId.values
      .map((indices) => indices.map((i) => puntosEntrega[i]).toList())
      .toList();

  // 6. Asignar las rutas resultantes a los vehículos disponibles.
  return asignarVehiculos(rutas, vehiculosDisponibles);
}

class _ParConAhorro {
  const _ParConAhorro(this.i, this.j, this.ahorro);

  final int i;
  final int j;
  final double ahorro;
}
