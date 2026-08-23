import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Historia + pronóstico de M1 en una sola curva: sólida hasta el último
/// dato real, punteada en el horizonte futuro — para que nunca se confunda
/// un dato observado con uno proyectado.
class GraficaPronostico extends StatelessWidget {
  const GraficaPronostico({super.key, required this.historico, required this.pronostico});

  final List<double> historico;
  final List<double> pronostico;

  static const _colorHistorico = Color(0xFF3949AB);
  static const _colorPronostico = Color(0xFFEF6C00);

  @override
  Widget build(BuildContext context) {
    final todos = [...historico, ...pronostico];
    // Redondeado al alza a una decena: evita etiquetas de eje con decimales
    // largos (ej. "236.6") que se salen del ancho reservado y se superponen
    // con el encabezado de la tarjeta.
    final maxY = (todos.reduce((a, b) => a > b ? a : b) * 1.15 / 10).ceil() * 10;
    final n = historico.length;

    return SizedBox(
      height: 240,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: maxY.toDouble(),
          gridData: const FlGridData(show: true, drawVerticalLine: false),
          titlesData: const FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 22, interval: 1),
            ),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 48)),
          ),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (spots) => spots
                  .map(
                    (s) => LineTooltipItem(
                      s.y.toStringAsFixed(1),
                      const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  )
                  .toList(),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [for (var i = 0; i < n; i++) FlSpot(i.toDouble(), historico[i])],
              isCurved: false,
              color: _colorHistorico,
              barWidth: 2,
              dotData: const FlDotData(show: true),
            ),
            LineChartBarData(
              // Empieza en el último dato real para que la curva punteada
              // no quede visualmente desconectada de la histórica.
              spots: [
                FlSpot((n - 1).toDouble(), historico.last),
                for (var i = 0; i < pronostico.length; i++)
                  FlSpot((n + i).toDouble(), pronostico[i]),
              ],
              isCurved: false,
              color: _colorPronostico,
              barWidth: 2,
              dashArray: [6, 4],
              dotData: const FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }
}
