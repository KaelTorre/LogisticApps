import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../domain/motor/m5_dimensionamiento_con_tendencia.dart';

/// Curva de costo acumulado por escenario (CLAUDE.md sección 7, M5: "tabla
/// comparativa + curva de costo acumulado por escenario"). Comparar solo 3
/// números de VPN sueltos no deja ver la pregunta real detrás de la
/// comparación: en qué año una estrategia empieza a costar más que otra.
///
/// Cada [ResultadoEscenario] trae su costo POR año en `curvaCostoAcumulado`
/// (a pesar del nombre, no viene acumulado) — este widget hace la suma
/// corrida para dibujar la curva que sí se acumula año a año.
class GraficaCostoAcumulado extends StatelessWidget {
  const GraficaCostoAcumulado({super.key, required this.escenarios, this.resaltado});

  final List<ResultadoEscenario> escenarios;

  /// Si no es null, ese escenario se dibuja opaco y el resto atenuado —
  /// conecta visualmente una tarjeta de escenario con su línea al tocarla.
  final EscenarioConstruccion? resaltado;

  static const colores = {
    EscenarioConstruccion.todoAhora: Color(0xFF1E88E5),
    EscenarioConstruccion.porEtapas: Color(0xFFFB8C00),
    EscenarioConstruccion.basePublico: Color(0xFF43A047),
  };

  @override
  Widget build(BuildContext context) {
    final series = <EscenarioConstruccion, List<FlSpot>>{};
    var maxY = 0.0;
    for (final e in escenarios) {
      var acumulado = 0.0;
      final puntos = <FlSpot>[];
      for (final p in e.curvaCostoAcumulado) {
        acumulado += p.costoDescontado;
        puntos.add(FlSpot(p.anio.toDouble(), acumulado));
      }
      series[e.escenario] = puntos;
      // La curva solo suma (los costos nunca son negativos), así que el
      // máximo de cada serie es siempre su último punto.
      if (acumulado > maxY) maxY = acumulado;
    }
    final maxYRedondeado = maxY <= 0 ? 1.0 : (maxY * 1.15 / 1000).ceil() * 1000.0;
    // Explícito por la misma razón que el interval:1 de bottomTitles en
    // GraficaRequerimientoMensual: sin esto fl_chart elige su propio
    // intervalo automático para el eje Y, que para un maxY como 206000 deja
    // la última etiqueta pegada al borde, superpuesta con la anterior
    // (ej. "206K" sobre "200K").
    final intervaloY = maxYRedondeado / 4;

    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: maxYRedondeado,
          gridData: const FlGridData(show: true, drawVerticalLine: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) =>
                    Text('${value.toInt()}', style: const TextStyle(fontSize: 11)),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 52,
                interval: intervaloY,
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (spots) => spots
                  .map(
                    (s) => LineTooltipItem(
                      s.y.toStringAsFixed(0),
                      const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  )
                  .toList(),
            ),
          ),
          lineBarsData: [
            for (final e in escenarios)
              LineChartBarData(
                spots: series[e.escenario]!,
                isCurved: false,
                color: colores[e.escenario]!.withValues(
                  alpha: resaltado == null || resaltado == e.escenario ? 1.0 : 0.25,
                ),
                barWidth: resaltado == e.escenario ? 3 : 2,
                dotData: const FlDotData(show: true),
              ),
          ],
        ),
      ),
    );
  }
}
