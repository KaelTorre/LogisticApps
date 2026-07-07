import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/constants.dart';
import '../../../core/utils/date_utils.dart';
import '../../providers/dashboard_provider.dart';
import '../../widgets/color_categoria_abc.dart';
import '../../widgets/estado_vacio.dart';

/// Dashboard consolidado (M6): TCP promedio, distribución ABC y nivel de
/// servicio óptimo, siempre con datos reales — sin valores hardcodeados.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardProvider>().cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Consumer<DashboardProvider>(
        builder: (context, provider, _) {
          if (provider.estado == EstadoDashboard.cargando ||
              provider.estado == EstadoDashboard.inactivo) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.cantidadPedidosTotal == 0) {
            return const EstadoVacio(
              icono: LucideIcons.layoutDashboard,
              titulo: 'Todavía no hay datos.',
              descripcion: 'Crea pedidos para ver los indicadores acá.',
            );
          }

          final totalValorAbc = provider.valorAbc.values.fold(
            0.0,
            (s, v) => s + v,
          );

          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _TarjetaKpi(
                      icono: LucideIcons.hourglass,
                      titulo: 'TCP promedio',
                      valor: provider.tcpPromedio != null
                          ? formatearDuracion(provider.tcpPromedio!)
                          : 'Sin datos',
                    ),
                    _TarjetaKpi(
                      icono: LucideIcons.clockCheck,
                      titulo: 'Pedidos entregados',
                      valor:
                          '${provider.cantidadPedidosEntregados} / ${provider.cantidadPedidosTotal}',
                    ),
                    _TarjetaKpi(
                      icono: LucideIcons.gauge,
                      titulo: 'Nivel de servicio óptimo',
                      valor: provider.optimoActual != null
                          ? '${provider.optimoActual!.slOptimo.toStringAsFixed(1)}%'
                          : 'No configurado',
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  'Distribución ABC',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                if (totalValorAbc == 0)
                  Text(
                    'Todavía no hay productos con ventas registradas.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                else ...[
                  SizedBox(
                    height: 180,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 3,
                        centerSpaceRadius: 40,
                        sections: [
                          for (final categoria in CategoriaAbc.values)
                            if (provider.valorAbc[categoria]! > 0)
                              PieChartSectionData(
                                value: provider.valorAbc[categoria],
                                color: colorCategoriaAbc(context, categoria),
                                title: categoria.etiqueta,
                                radius: 50,
                                titleStyle: TextStyle(
                                  color: colorTextoSobre(
                                    colorCategoriaAbc(context, categoria),
                                  ),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  for (final categoria in CategoriaAbc.values)
                    _FilaCategoriaAbc(
                      color: colorCategoriaAbc(context, categoria),
                      categoria: categoria,
                      conteo: provider.conteoAbc[categoria] ?? 0,
                      porcentajeValor: totalValorAbc == 0
                          ? 0
                          : (provider.valorAbc[categoria] ?? 0) /
                                totalValorAbc,
                    ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TarjetaKpi extends StatelessWidget {
  const _TarjetaKpi({
    required this.icono,
    required this.titulo,
    required this.valor,
  });

  final IconData icono;
  final String titulo;
  final String valor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, color: colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              valor,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              titulo,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilaCategoriaAbc extends StatelessWidget {
  const _FilaCategoriaAbc({
    required this.color,
    required this.categoria,
    required this.conteo,
    required this.porcentajeValor,
  });

  final Color color;
  final CategoriaAbc categoria;
  final int conteo;
  final double porcentajeValor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text('Categoría ${categoria.etiqueta}', style: textTheme.bodyMedium),
          ),
          Text(
            '$conteo productos',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${(porcentajeValor * 100).toStringAsFixed(1)}% del valor',
            style: textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
