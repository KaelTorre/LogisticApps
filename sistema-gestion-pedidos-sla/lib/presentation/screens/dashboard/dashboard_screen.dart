import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/constants.dart';
import '../../../core/utils/date_utils.dart';
import '../../providers/dashboard_provider.dart';
import '../../widgets/estado_vacio.dart';
import '../../widgets/paleta_categorica.dart';
import '../clasificacion_abc/clasificacion_abc_screen.dart';
import '../optimizacion_servicio/optimizacion_servicio_screen.dart';
import '../pedidos/pedido_list_screen.dart';

/// A partir de este ancho la grilla de KPIs y las secciones de abajo se
/// acomodan lado a lado (desktop/tablet apaisado); por debajo, todo se
/// apila en una sola columna (celular/tablet vertical).
const double _anchoBreakpointEscritorio = 900;

/// Dashboard consolidado (M6): KPIs principales, distribución ABC y
/// pipeline de pedidos por estado, siempre con datos reales — sin valores
/// hardcodeados. Interactivo: se puede refrescar, tocar cualquier tarjeta
/// para ir al detalle correspondiente, y explorar el gráfico ABC tocando
/// cada porción.
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
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.refreshCw),
            tooltip: 'Actualizar',
            onPressed: () => context.read<DashboardProvider>().cargar(),
          ),
        ],
      ),
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

          return RefreshIndicator(
            onRefresh: provider.cargar,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final esEscritorio =
                    constraints.maxWidth >= _anchoBreakpointEscritorio;
                final secciones = [
                  _SeccionAbc(provider: provider),
                  _SeccionEstados(provider: provider),
                ];

                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(esEscritorio ? 32 : 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Resumen general',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Estado actual del sistema, con datos en vivo.',
                        style: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 20),
                      _GrillaKpis(provider: provider),
                      const SizedBox(height: 28),
                      if (esEscritorio)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 3, child: secciones[0]),
                            const SizedBox(width: 24),
                            Expanded(flex: 2, child: secciones[1]),
                          ],
                        )
                      else
                        Column(
                          children: [
                            secciones[0],
                            const SizedBox(height: 20),
                            secciones[1],
                          ],
                        ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

/// Grilla de KPIs auto-adaptable: en vez de una cantidad fija de columnas,
/// cada tarjeta ocupa como máximo 280px de ancho y la grilla acomoda tantas
/// por fila como entren — 1 en celular, 2-3 en tablet, hasta 4+ en
/// escritorio, sin lógica de breakpoints manual.
class _GrillaKpis extends StatelessWidget {
  const _GrillaKpis({required this.provider});

  final DashboardProvider provider;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // `.floor()` (no `.ceil()`) para que en anchos intermedios prefiera
        // menos columnas más anchas antes que columnas angostas donde el
        // valor del KPI queda cortado — mismo criterio que la grilla de
        // módulos de Home.
        final columnas = (constraints.maxWidth / 260).floor().clamp(1, 4);
        return GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columnas,
            mainAxisExtent: 152,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          children: _construirTarjetas(context),
        );
      },
    );
  }

  List<Widget> _construirTarjetas(BuildContext context) {
    return [
        _TarjetaKpi(
          icono: LucideIcons.hourglass,
          color: Theme.of(context).colorScheme.primary,
          valor: provider.tcpPromedio != null
              ? formatearDuracion(provider.tcpPromedio!)
              : 'Sin datos',
          titulo: 'TCP promedio',
          onTap: () => _irAPedidos(context, EstadoPedido.entregado),
        ),
        _TarjetaKpi(
          icono: LucideIcons.clockCheck,
          color: Theme.of(context).colorScheme.primary,
          valor:
              '${provider.cantidadPedidosEntregados} / ${provider.cantidadPedidosTotal}',
          titulo: 'Pedidos entregados',
          onTap: () => _irAPedidos(context, EstadoPedido.entregado),
        ),
        _TarjetaKpi(
          icono: LucideIcons.truck,
          color: colorCategoricoVioleta,
          valor: '${provider.pedidosActivos}',
          titulo: 'Pedidos en curso',
          onTap: () => _irAPedidos(context, null),
        ),
        _TarjetaKpi(
          icono: LucideIcons.xCircle,
          color: Theme.of(context).colorScheme.error,
          valor: '${provider.pedidosCancelados}',
          titulo: 'Pedidos cancelados',
          onTap: () => _irAPedidos(context, EstadoPedido.cancelado),
        ),
        _TarjetaKpi(
          icono: LucideIcons.wallet,
          color: colorCategoricoAmbar,
          valor: 'S/ ${provider.valorTotalPedidos.toStringAsFixed(2)}',
          titulo: 'Valor total en pedidos',
          onTap: () => _irAPedidos(context, null),
        ),
        _TarjetaKpi(
          icono: LucideIcons.gauge,
          color: colorCategoricoAzul,
          valor: provider.optimoActual != null
              ? '${provider.optimoActual!.slOptimo.toStringAsFixed(1)}%'
              : 'No configurado',
          titulo: 'Nivel de servicio óptimo',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const OptimizacionServicioScreen(),
            ),
          ),
        ),
    ];
  }

  void _irAPedidos(BuildContext context, EstadoPedido? filtro) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PedidoListScreen(filtroInicial: filtro),
      ),
    );
  }
}

class _TarjetaKpi extends StatelessWidget {
  const _TarjetaKpi({
    required this.icono,
    required this.color,
    required this.valor,
    required this.titulo,
    this.onTap,
  });

  final IconData icono;
  final Color color;
  final String valor;
  final String titulo;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icono, color: color, size: 22),
                  ),
                  if (onTap != null)
                    Icon(
                      LucideIcons.arrowUpRight,
                      size: 18,
                      color: colorScheme.onSurfaceVariant,
                    ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    valor,
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    titulo,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Distribución ABC con gráfico de dona interactivo: tocar una porción la
/// agranda y muestra su detalle en el centro; tocar cualquier fila de la
/// leyenda lleva al detalle completo de Clasificación ABC.
class _SeccionAbc extends StatefulWidget {
  const _SeccionAbc({required this.provider});

  final DashboardProvider provider;

  @override
  State<_SeccionAbc> createState() => _SeccionAbcState();
}

class _SeccionAbcState extends State<_SeccionAbc> {
  int? _indiceTocado;

  @override
  Widget build(BuildContext context) {
    final provider = widget.provider;
    final textTheme = Theme.of(context).textTheme;
    final totalValorAbc = provider.valorAbc.values.fold(
      0.0,
      (s, v) => s + v,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Distribución ABC',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ClasificacionAbcScreen(),
                    ),
                  ),
                  icon: const Icon(LucideIcons.arrowUpRight, size: 18),
                  label: const Text('Ver detalle'),
                ),
              ],
            ),
            if (totalValorAbc == 0)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'Todavía no hay productos con ventas registradas.',
                  style: textTheme.bodyMedium,
                ),
              )
            else ...[
              const SizedBox(height: 12),
              Builder(
                builder: (context) {
                  // Lista fija con solo las categorías que tienen valor —
                  // el índice que reporta el touch de fl_chart es la
                  // posición dentro de las secciones realmente dibujadas,
                  // no dentro de `CategoriaAbc.values` (que puede incluir
                  // categorías con 0 que no se dibujan). Usar la misma
                  // lista para dibujar y para mapear el índice tocado
                  // evita que ambas cosas queden desalineadas.
                  final categoriasConValor = [
                    for (final c in CategoriaAbc.values)
                      if ((provider.valorAbc[c] ?? 0) > 0) c,
                  ];

                  return Column(
                    children: [
                      SizedBox(
                        height: 220,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            PieChart(
                              PieChartData(
                                sectionsSpace: 4,
                                centerSpaceRadius: 56,
                                pieTouchData: PieTouchData(
                                  touchCallback: (event, respuesta) {
                                    final tocado = respuesta?.touchedSection;
                                    // `touchedSectionIndex` puede venir en
                                    // -1 (sentinel de fl_chart para "nada
                                    // tocado", ej. el mouse pasando sobre
                                    // el hueco central o saliendo del
                                    // gráfico) — sin este chequeo,
                                    // indexar la lista revienta con un
                                    // RangeError.
                                    final indice = tocado?.touchedSectionIndex;
                                    final indiceValido =
                                        event.isInterestedForInteractions &&
                                        indice != null &&
                                        indice >= 0 &&
                                        indice < categoriasConValor.length;
                                    setState(() {
                                      _indiceTocado = indiceValido
                                          ? indice
                                          : null;
                                    });
                                  },
                                ),
                                sections: [
                                  for (
                                    var i = 0;
                                    i < categoriasConValor.length;
                                    i++
                                  )
                                    PieChartSectionData(
                                      value:
                                          provider
                                              .valorAbc[categoriasConValor[i]],
                                      color: colorCategoriaAbc(
                                        context,
                                        categoriasConValor[i],
                                      ),
                                      title: categoriasConValor[i].etiqueta,
                                      radius: _indiceTocado == i ? 62 : 52,
                                      titleStyle: TextStyle(
                                        fontSize: _indiceTocado == i
                                            ? 20
                                            : 16,
                                        fontWeight: FontWeight.w800,
                                        color: colorTextoSobre(
                                          colorCategoriaAbc(
                                            context,
                                            categoriasConValor[i],
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            _CentroDona(
                              provider: provider,
                              totalValorAbc: totalValorAbc,
                              categoriaTocada: _indiceTocado != null
                                  ? categoriasConValor[_indiceTocado!]
                                  : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      for (final categoria in CategoriaAbc.values)
                        _FilaCategoriaAbc(
                          color: colorCategoriaAbc(context, categoria),
                          categoria: categoria,
                          conteo: provider.conteoAbc[categoria] ?? 0,
                          porcentajeValor: totalValorAbc == 0
                              ? 0
                              : (provider.valorAbc[categoria] ?? 0) /
                                    totalValorAbc,
                          seleccionada:
                              _indiceTocado != null &&
                              _indiceTocado! < categoriasConValor.length &&
                              categoriasConValor[_indiceTocado!] == categoria,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ClasificacionAbcScreen(),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CentroDona extends StatelessWidget {
  const _CentroDona({
    required this.provider,
    required this.totalValorAbc,
    required this.categoriaTocada,
  });

  final DashboardProvider provider;
  final double totalValorAbc;
  final CategoriaAbc? categoriaTocada;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final categoria = categoriaTocada;

    if (categoria == null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'S/ ${totalValorAbc.toStringAsFixed(0)}',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          Text(
            'Valor total',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      );
    }

    final valor = provider.valorAbc[categoria] ?? 0;
    final porcentaje = totalValorAbc == 0 ? 0 : valor / totalValorAbc * 100;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${porcentaje.toStringAsFixed(1)}%',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        Text(
          'Categoría ${categoria.etiqueta} · S/ ${valor.toStringAsFixed(0)}',
          textAlign: TextAlign.center,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _FilaCategoriaAbc extends StatelessWidget {
  const _FilaCategoriaAbc({
    required this.color,
    required this.categoria,
    required this.conteo,
    required this.porcentajeValor,
    required this.onTap,
    this.seleccionada = false,
  });

  final Color color;
  final CategoriaAbc categoria;
  final int conteo;
  final double porcentajeValor;
  final bool seleccionada;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final punto = Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
    final etiqueta = Text(
      'Categoría ${categoria.etiqueta}',
      style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
    );
    final conteoTexto = Text(
      '$conteo · ${(porcentajeValor * 100).toStringAsFixed(0)}%',
      style: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
    );
    final barra = ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LinearProgressIndicator(
        value: porcentajeValor.clamp(0, 1),
        minHeight: 8,
        backgroundColor: colorScheme.surfaceContainerLow,
        valueColor: AlwaysStoppedAnimation(color),
      ),
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: seleccionada
              ? color.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // La fila de una sola línea (etiqueta + barra + conteo) queda
            // apretada por debajo de ~340px — se apila en dos líneas.
            if (constraints.maxWidth < 340) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      punto,
                      const SizedBox(width: 10),
                      Expanded(child: etiqueta),
                      conteoTexto,
                    ],
                  ),
                  const SizedBox(height: 8),
                  barra,
                ],
              );
            }
            return Row(
              children: [
                punto,
                const SizedBox(width: 10),
                Expanded(flex: 2, child: etiqueta),
                Expanded(flex: 3, child: barra),
                const SizedBox(width: 12),
                SizedBox(
                  width: 90,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: conteoTexto,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Pipeline de pedidos por estado: cuántos pedidos hay en cada paso de la
/// máquina de estados, de un vistazo. Tocar una fila abre la lista de
/// pedidos ya filtrada por ese estado.
class _SeccionEstados extends StatelessWidget {
  const _SeccionEstados({required this.provider});

  final DashboardProvider provider;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final maxConteo = provider.conteoPorEstado.values.isEmpty
        ? 0
        : provider.conteoPorEstado.values.reduce((a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pedidos por estado',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            for (final estado in EstadoPedido.values)
              _FilaEstado(
                estado: estado,
                conteo: provider.conteoPorEstado[estado] ?? 0,
                maxConteo: maxConteo,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PedidoListScreen(filtroInicial: estado),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FilaEstado extends StatelessWidget {
  const _FilaEstado({
    required this.estado,
    required this.conteo,
    required this.maxConteo,
    required this.onTap,
  });

  final EstadoPedido estado;
  final int conteo;
  final int maxConteo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final (color, _) = colorEstadoPedido(context, estado);
    final proporcion = maxConteo == 0 ? 0.0 : conteo / maxConteo;

    return InkWell(
      onTap: conteo == 0 ? null : onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            SizedBox(
              width: 130,
              child: Text(
                estado.etiqueta,
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: proporcion,
                  minHeight: 10,
                  backgroundColor: colorScheme.surfaceContainerLow,
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 28,
              child: Text(
                '$conteo',
                textAlign: TextAlign.end,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
