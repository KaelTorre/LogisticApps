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

    // Ni el color de la línea (colorScheme.primary, ya usado para el valor
    // medido) ni colorScheme.tertiary (probado y resultó casi invisible
    // sobre este tema oscuro) sirven acá -- tampoco verde/ámbar/rojo,
    // reservados a los estados normal/observación/desviación en el resto
    // de la app, para no sugerir un estado que la meta no tiene. onSurface
    // se adapta solo entre tema claro y oscuro, a diferencia de un blanco
    // fijo que desaparecería en tema claro.
    final colorMeta = colorScheme.onSurface.withValues(alpha: 0.6);

    return Column(
      children: [
        Expanded(
          child: LineChart(
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
              extraLinesData: ExtraLinesData(
                horizontalLines: [
                  HorizontalLine(
                    y: indicador.meta,
                    color: colorMeta,
                    strokeWidth: 2,
                    dashArray: [6, 4],
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
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          runSpacing: 4,
          children: [
            _ItemLeyenda(color: colorScheme.primary, texto: 'Valor medido', esLinea: true),
            _ItemLeyenda(color: colorMeta, texto: 'Meta', esLinea: true, punteada: true),
            _ItemLeyenda(color: colorScheme.primary.withValues(alpha: 0.25), texto: 'Banda de tolerancia'),
          ],
        ),
      ],
    );
  }
}

class _ItemLeyenda extends StatelessWidget {
  const _ItemLeyenda({
    required this.color,
    required this.texto,
    this.esLinea = false,
    this.punteada = false,
  });

  final Color color;
  final String texto;
  final bool esLinea;
  final bool punteada;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 16,
          height: 12,
          child: esLinea
              ? CustomPaint(painter: _LineaLeyendaPainter(color: color, punteada: punteada))
              : DecoratedBox(decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        ),
        const SizedBox(width: 4),
        Text(texto, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _LineaLeyendaPainter extends CustomPainter {
  const _LineaLeyendaPainter({required this.color, required this.punteada});

  final Color color;
  final bool punteada;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;
    final y = size.height / 2;
    if (!punteada) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
      return;
    }
    const anchoGuion = 4.0;
    const espacio = 3.0;
    var x = 0.0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, y), Offset((x + anchoGuion).clamp(0, size.width), y), paint);
      x += anchoGuion + espacio;
    }
  }

  @override
  bool shouldRepaint(covariant _LineaLeyendaPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.punteada != punteada;
}
