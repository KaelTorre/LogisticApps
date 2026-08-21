import 'fila_memoria.dart';

/// Demanda de una familia de producto para M2. `factorPico` sale del perfil
/// estacional de M1 (aún no implementado) o es 1.0 si la demanda es plana
/// (CLAUDE.md sección 7, M2).
class DemandaFamilia {
  const DemandaFamilia({
    required this.nombre,
    required this.demandaAnual,
    required this.rotacionAnual,
    required this.unidadesPorTarima,
    this.factorPico = 1.0,
  });

  final String nombre;
  final double demandaAnual;
  final double rotacionAnual;
  final int unidadesPorTarima;
  final double factorPico;
}

class ResultadoM2 {
  const ResultadoM2({required this.posicionesRequeridas, required this.memoria});

  final int posicionesRequeridas;
  final List<FilaMemoria> memoria;
}

/// M2 — Demanda → posiciones de tarima (CLAUDE.md sección 7).
///
/// Función pura: sin acceso a base de datos, sin estado. El honeycombing se
/// aplica sobre posiciones, no sobre superficie — es capacidad que existe
/// pero no se puede usar.
ResultadoM2 calcularPosicionesRequeridas({
  required List<DemandaFamilia> familias,
  required double factorHoneycomb,
}) {
  if (familias.isEmpty) {
    throw ArgumentError('M2 necesita al menos una familia de producto.');
  }
  for (final f in familias) {
    if (f.demandaAnual < 0) {
      throw ArgumentError.value(f.demandaAnual, 'demandaAnual (${f.nombre})', 'No puede ser negativa.');
    }
    if (f.rotacionAnual <= 0) {
      throw ArgumentError.value(f.rotacionAnual, 'rotacionAnual (${f.nombre})', 'Debe ser mayor que cero.');
    }
    if (f.unidadesPorTarima <= 0) {
      throw ArgumentError.value(
        f.unidadesPorTarima,
        'unidadesPorTarima (${f.nombre})',
        'Debe ser mayor que cero.',
      );
    }
  }
  if (factorHoneycomb < 0 || factorHoneycomb >= 1) {
    throw ArgumentError.value(
      factorHoneycomb,
      'factorHoneycomb',
      'Debe estar en [0, 1) — 1 o más implica capacidad infinita perdida.',
    );
  }

  final memoria = <FilaMemoria>[];
  var orden = 1;
  var sumaTarimas = 0;

  for (final f in familias) {
    final inventarioPromedio = f.demandaAnual / f.rotacionAnual;
    memoria.add(
      FilaMemoria(
        orden: orden++,
        modulo: 'M2',
        concepto: 'Inventario promedio — ${f.nombre}',
        formula: 'inventario_promedio = demanda_anual / rotacion_anual',
        entradas: {'demanda_anual': f.demandaAnual, 'rotacion_anual': f.rotacionAnual},
        valor: inventarioPromedio.toStringAsFixed(2),
        unidad: 'unidades',
      ),
    );

    final inventarioPico = inventarioPromedio * f.factorPico;
    memoria.add(
      FilaMemoria(
        orden: orden++,
        modulo: 'M2',
        concepto: 'Inventario pico — ${f.nombre}',
        formula: 'inventario_pico = inventario_promedio × factor_pico',
        entradas: {'inventario_promedio': inventarioPromedio, 'factor_pico': f.factorPico},
        valor: inventarioPico.toStringAsFixed(2),
        unidad: 'unidades',
      ),
    );

    final tarimas = (inventarioPico / f.unidadesPorTarima).ceil();
    memoria.add(
      FilaMemoria(
        orden: orden++,
        modulo: 'M2',
        concepto: 'Tarimas requeridas — ${f.nombre}',
        formula: 'tarimas = ceil(inventario_pico / unidades_por_tarima)',
        entradas: {
          'inventario_pico': inventarioPico,
          'unidades_por_tarima': f.unidadesPorTarima,
        },
        valor: '$tarimas',
        unidad: 'tarimas',
      ),
    );

    sumaTarimas += tarimas;
  }

  final posicionesRequeridas = (sumaTarimas / (1 - factorHoneycomb)).ceil();
  memoria.add(
    FilaMemoria(
      orden: orden++,
      modulo: 'M2',
      concepto: 'Posiciones requeridas (total)',
      formula: 'posiciones_requeridas = ceil(Σ tarimas / (1 − factor_honeycomb))',
      entradas: {'suma_tarimas': sumaTarimas, 'factor_honeycomb': factorHoneycomb},
      valor: '$posicionesRequeridas',
      unidad: 'posiciones',
    ),
  );

  return ResultadoM2(posicionesRequeridas: posicionesRequeridas, memoria: memoria);
}
