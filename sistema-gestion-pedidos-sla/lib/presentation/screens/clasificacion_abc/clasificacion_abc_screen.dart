import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/constants.dart';
import '../../providers/abc_provider.dart';
import '../../widgets/estado_vacio.dart';
import '../../widgets/paleta_categorica.dart';

/// Clasificación ABC (M3): tabla + gráfico de barras tipo Pareto de los
/// productos ordenados por valor total generado.
class ClasificacionAbcScreen extends StatefulWidget {
  const ClasificacionAbcScreen({super.key});

  @override
  State<ClasificacionAbcScreen> createState() =>
      _ClasificacionAbcScreenState();
}

class _ClasificacionAbcScreenState extends State<ClasificacionAbcScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AbcProvider>().cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clasificación ABC')),
      body: Consumer<AbcProvider>(
        builder: (context, provider, _) {
          if (provider.estado == EstadoAbc.cargando ||
              provider.estado == EstadoAbc.inactivo) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.clasificados.isEmpty) {
            return const EstadoVacio(
              icono: LucideIcons.chartColumn,
              titulo: 'Todavía no hay datos suficientes.',
              descripcion:
                  'Crea pedidos con productos para ver la clasificación ABC.',
            );
          }

          final maxValor = provider.clasificados
              .map((p) => p.valorTotalGenerado)
              .reduce((a, b) => a > b ? a : b);

          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                SizedBox(
                  height: 240,
                  child: BarChart(
                    BarChartData(
                      maxY: maxValor * 1.15,
                      titlesData: const FlTitlesData(
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      barGroups: [
                        for (var i = 0; i < provider.clasificados.length; i++)
                          BarChartGroupData(
                            x: i,
                            barRods: [
                              BarChartRodData(
                                toY: provider.clasificados[i].valorTotalGenerado,
                                color: colorCategoriaAbc(
                                  context,
                                  provider.clasificados[i].categoria,
                                ),
                                width: 14,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 16,
                  children: [
                    for (final categoria in CategoriaAbc.values)
                      _LeyendaCategoria(
                        color: colorCategoriaAbc(context, categoria),
                        etiqueta: 'Categoría ${categoria.etiqueta}',
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                Card(
                  child: Column(
                    children: [
                      for (final p in provider.clasificados)
                        ListTile(
                          leading: Builder(
                            builder: (context) {
                              final fondo = colorCategoriaAbc(
                                context,
                                p.categoria,
                              );
                              return CircleAvatar(
                                backgroundColor: fondo,
                                foregroundColor: colorTextoSobre(fondo),
                                child: Text(p.categoria.etiqueta),
                              );
                            },
                          ),
                          title: Text(
                            provider.productosPorId[p.productoId]?.nombre ??
                                'Producto #${p.productoId}',
                          ),
                          subtitle: Text(
                            '${(p.porcentajeAcumulado * 100).toStringAsFixed(1)}% acumulado',
                          ),
                          trailing: Text(
                            'S/ ${p.valorTotalGenerado.toStringAsFixed(2)}',
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LeyendaCategoria extends StatelessWidget {
  const _LeyendaCategoria({required this.color, required this.etiqueta});

  final Color color;
  final String etiqueta;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(etiqueta, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
