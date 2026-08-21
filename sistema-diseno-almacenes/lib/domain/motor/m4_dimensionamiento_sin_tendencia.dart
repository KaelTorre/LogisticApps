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
      formula: 'elegir C que minimiza costo(C) = costo_anual_propio(C) + '
          'Σ_meses max(0, requerimiento[mes] − C) × tarifa_publica',
      entradas: {
        'candidatos_evaluados': candidatos.length,
        'costo_anual_propio_por_posicion': costoAnualPropioPorPosicion,
      },
      valor: '${optimo.capacidad}',
      unidad: 'posiciones',
    ),
    FilaMemoria(
      orden: 2,
      modulo: 'M4',
      concepto: 'Costo anual en el óptimo',
      formula: 'costo(C*) = costo_propio(C*) + costo_público(C*)',
      entradas: {'capacidad_optima': optimo.capacidad},
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
