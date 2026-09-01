import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../data/models/indicador.dart';
import '../../data/models/periodo.dart';

/// Serie temporal de un indicador con su banda de tolerancia sombreada
/// (Pantalla 7, CLAUDE.md sección 9). El eje horizontal es `periodo.orden`
/// -- nunca la fecha -- para que la gráfica quede coherente con la regla
/// fundamental de la sección 4.
///
/// La banda se dibuja siempre en `[bandaInferior, bandaSuperior]` tal cual
/// están guardadas -- el `sentido` del indicador (menor_mejor/mayor_mejor)
/// decide qué lado es adverso para el motor de evaluación (Fase 3), pero
/// **no** cambia dónde se pinta la banda en el eje Y. Pintarla distinto
/// según el sentido sería el bug exacto que ya se corrigió una vez en
/// `sistema-red-distribucion` (eje mal escalado) pero al revés: acá el
/// riesgo es invertir o desplazar la banda, no la escala.
class GraficaSerieBanda extends StatelessWidget {
  const GraficaSerieBanda({
    super.key,
    required this.indicador,
    required this.periodos,
    required this.valoresPorPeriodoId,
  });

  final Indicador indicador;

  /// Ordenados por `orden` -- responsabilidad de quien arma esta lista,
  /// no de este widget (mismo patrón que `PeriodoRepository`, que ya
  /// devuelve todo ordenado).
  final List<Periodo> periodos;
  final Map<int, double> valoresPorPeriodoId;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final spots = <FlSpot>[
      for (final periodo in periodos)
        if (valoresPorPeriodoId[periodo.id] != null)
          FlSpot(periodo.orden.toDouble(), valoresPorPeriodoId[periodo.id]!),
    ];

    final valoresConsiderados = [
      indicador.bandaInferior,
      indicador.bandaSuperior,
      indicador.meta,
      ...spots.map((s) => s.y),
    ];
    final minY = valoresConsiderados.reduce((a, b) => a < b ? a : b);
    final maxY = valoresConsiderados.reduce((a, b) => a > b ? a : b);
    final margen = (maxY - minY) * 0.1;

    return LineChart(
      LineChartData(
        minY: minY - margen,
        maxY: maxY + margen,
        rangeAnnotations: RangeAnnotations(
          horizontalRangeAnnotations: [
            HorizontalRangeAnnotation(
              y1: indicador.bandaInferior,
              y2: indicador.bandaSuperior,
              color: colorScheme.primary.withValues(alpha: 0.12),
            ),
          ],
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            color: colorScheme.primary,
            barWidth: 3,
            dotData: const FlDotData(show: true),
          ),
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 28, interval: 1),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 56)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: true),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}
