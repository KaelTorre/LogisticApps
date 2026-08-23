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
        formula: 'Inventario promedio = Demanda anual ÷ Rotación anual',
        entradas: {'Demanda anual': f.demandaAnual, 'Rotación anual': f.rotacionAnual},
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
        formula: 'Inventario pico = Inventario promedio × Factor pico',
        entradas: {'Inventario promedio': inventarioPromedio, 'Factor pico': f.factorPico},
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
        formula: 'Tarimas = redondeo hacia arriba de (Inventario pico ÷ Unidades por tarima)',
        entradas: {
          'Inventario pico': inventarioPico,
          'Unidades por tarima': f.unidadesPorTarima,
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
      formula: 'Posiciones requeridas = redondeo hacia arriba de '
          '(Total de tarimas ÷ (1 − Factor honeycomb))',
      entradas: {'Total de tarimas (todas las familias)': sumaTarimas, 'Factor honeycomb': factorHoneycomb},
      valor: '$posicionesRequeridas',
      unidad: 'posiciones',
    ),
  );

  return ResultadoM2(posicionesRequeridas: posicionesRequeridas, memoria: memoria);
}
