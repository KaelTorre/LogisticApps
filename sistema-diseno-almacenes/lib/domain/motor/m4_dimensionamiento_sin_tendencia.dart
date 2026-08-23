import 'fila_memoria.dart';
import 'tarifa_publica.dart';

class PuntoCostoCapacidad {
  const PuntoCostoCapacidad({
    required this.capacidad,
    required this.costoPropio,
    required this.costoPublico,
    required this.costoTotal,
  });

  final int capacidad;
  final double costoPropio;
  final double costoPublico;
  final double costoTotal;
}

class ResultadoM4 {
  const ResultadoM4({
    required this.capacidadOptima,
    required this.costoOptimo,
    required this.curva,
    required this.requerimientosMensuales,
    required this.memoria,
  });

  final int capacidadOptima;
  final double costoOptimo;

  /// Un punto por cada capacidad candidata evaluada — la gráfica de
  /// requerimiento mensual con la línea de capacidad propia que pide
  /// CLAUDE.md sección 7, M4, se arma sobre esto.
  final List<PuntoCostoCapacidad> curva;
  final List<int> requerimientosMensuales;
  final List<FilaMemoria> memoria;
}

/// M4 — Dimensionamiento sin tendencia (CLAUDE.md sección 7). Demanda
/// estable pero estacional: decide cuánta capacidad propia construir y
/// cuánto cubrir con almacén público, barriendo las capacidades candidatas
/// (los propios valores de requerimiento mensual, CLAUDE.md: "Candidatos =
/// valores distintos de requerimiento mensual") y minimizando el costo
/// anual total.
///
/// Función pura: sin acceso a base de datos, sin estado.
ResultadoM4 calcularDimensionamientoSinTendencia({
  required List<int> requerimientosMensuales,
  required double costoAnualPropioPorPosicion,
  required TarifaPublica tarifaPublica,
}) {
  if (requerimientosMensuales.isEmpty) {
    throw ArgumentError('Se necesita al menos un mes de requerimiento.');
  }
  for (final r in requerimientosMensuales) {
    if (r < 0) {
      throw ArgumentError.value(r, 'requerimientosMensuales', 'No puede ser negativo.');
    }
  }
  if (costoAnualPropioPorPosicion < 0) {
    throw ArgumentError.value(
      costoAnualPropioPorPosicion,
      'costoAnualPropioPorPosicion',
      'No puede ser negativo.',
    );
  }

  final candidatos = requerimientosMensuales.toSet().toList()..sort();

  final curva = <PuntoCostoCapacidad>[];
  for (final c in candidatos) {
    final costoPropio = c * costoAnualPropioPorPosicion;
    var costoPublico = 0.0;
    for (final r in requerimientosMensuales) {
      final desborde = r - c;
      if (desborde > 0) costoPublico += tarifaPublica.costoMensual(desborde);
    }
    curva.add(
      PuntoCostoCapacidad(
        capacidad: c,
        costoPropio: costoPropio,
        costoPublico: costoPublico,
        costoTotal: costoPropio + costoPublico,
      ),
    );
  }

  final optimo = curva.reduce((a, b) => b.costoTotal < a.costoTotal ? b : a);

  final memoria = [
    FilaMemoria(
      orden: 1,
      modulo: 'M4',
      concepto: 'Capacidad propia óptima',
      formula: 'Se prueba cada capacidad candidata y se elige la de menor costo total: '
          'Costo total = Costo anual propio + suma del costo mensual de cubrir '
          'con almacén público lo que exceda esa capacidad',
      entradas: {
        'Capacidades candidatas evaluadas': candidatos.length,
        'Costo anual propio por posición': costoAnualPropioPorPosicion,
      },
      valor: '${optimo.capacidad}',
      unidad: 'posiciones',
    ),
    FilaMemoria(
      orden: 2,
      modulo: 'M4',
      concepto: 'Costo anual en el óptimo',
      formula: 'Costo total = Costo propio + Costo de almacén público, '
          'evaluados en la capacidad óptima',
      entradas: {'Capacidad óptima': optimo.capacidad},
      valor:
          'propio=${optimo.costoPropio.toStringAsFixed(2)}, '
          'público=${optimo.costoPublico.toStringAsFixed(2)}, '
          'total=${optimo.costoTotal.toStringAsFixed(2)}',
      unidad: 'moneda del proyecto',
    ),
  ];

  return ResultadoM4(
    capacidadOptima: optimo.capacidad,
    costoOptimo: optimo.costoTotal,
    curva: curva,
    requerimientosMensuales: requerimientosMensuales,
    memoria: memoria,
  );
}
