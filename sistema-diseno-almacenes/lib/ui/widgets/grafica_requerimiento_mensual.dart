import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// "Salida obligatoria" de M4 (CLAUDE.md sección 7): requerimiento mensual
/// con la línea de capacidad propia y el área de desbordamiento sombreada.
/// Es la lámina que se lleva a gerencia — no un gráfico decorativo.
class GraficaRequerimientoMensual extends StatelessWidget {
  const GraficaRequerimientoMensual({
    super.key,
    required this.requerimientosMensuales,
    required this.capacidadPropia,
  });

  final List<int> requerimientosMensuales;
  final int capacidadPropia;

  static const _colorRequerimiento = Color(0xFF3949AB);
  static const _colorDesborde = Color(0xFFE53935);
  static const _colorCapacidad = Color(0xFF43A047);

  @override
  Widget build(BuildContext context) {
    final maxY =
        [...requerimientosMensuales, capacidadPropia].reduce((a, b) => a > b ? a : b) * 1.15;

    return SizedBox(
      height: 260,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: maxY,
          gridData: const FlGridData(show: true, drawVerticalLine: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const meses = ['E', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
                  final i = value.toInt();
                  if (i < 0 || i >= meses.length) return const SizedBox.shrink();
                  return Text(meses[i], style: const TextStyle(fontSize: 11));
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
            ),
          ),
          borderData: FlBorderData(show: false),
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: capacidadPropia.toDouble(),
                color: _colorCapacidad,
                strokeWidth: 2,
                dashArray: [6, 4],
                label: HorizontalLineLabel(
                  show: true,
                  labelResolver: (_) => 'Capacidad propia',
                  style: const TextStyle(color: _colorCapacidad, fontSize: 11),
                  alignment: Alignment.topRight,
                ),
              ),
            ],
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (spots) => spots
                  .map(
                    (s) => LineTooltipItem(
                      '${s.y.round()}',
                      const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  )
                  .toList(),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (var i = 0; i < requerimientosMensuales.length; i++)
                  FlSpot(i.toDouble(), requerimientosMensuales[i].toDouble()),
              ],
              isCurved: false,
              color: _colorRequerimiento,
              barWidth: 2,
              dotData: const FlDotData(show: true),
              // Sombrea SOLO la parte de la curva que queda por encima de
              // la capacidad propia — el área de desbordamiento que pide
              // CLAUDE.md, no todo el área bajo la curva. `belowBarData`
              // rellena hacia abajo desde la línea; con cutOffY solo queda
              // una región positiva donde la línea está por encima del
              // corte (aboveBarData hacía lo contrario: una franja fija
              // sin relación con la forma real de la curva).
              belowBarData: BarAreaData(
                show: true,
                color: _colorDesborde.withValues(alpha: 0.25),
                cutOffY: capacidadPropia.toDouble(),
                applyCutOffY: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
