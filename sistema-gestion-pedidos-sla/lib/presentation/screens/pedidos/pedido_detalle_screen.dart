import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/date_utils.dart';
import '../../../data/models/producto.dart';
import '../../../data/repositories/producto_repository.dart';
import '../../providers/pedido_provider.dart';
import '../../widgets/badge_estado_pedido.dart';

/// Detalle de un pedido: items, tabla de TCP por etapa (M2) y control de la
/// máquina de estados (M1, §6.1/§6.2 de CLAUDE.md).
class PedidoDetalleScreen extends StatefulWidget {
  const PedidoDetalleScreen({super.key, required this.pedidoId});

  final int pedidoId;

  @override
  State<PedidoDetalleScreen> createState() => _PedidoDetalleScreenState();
}

class _PedidoDetalleScreenState extends State<PedidoDetalleScreen> {
  Map<int, Producto> _productosPorId = {};

  @override
  void initState() {
    super.initState();
    context.read<PedidoProvider>().cargarDetalle(widget.pedidoId);
    _cargarProductos();
  }

  Future<void> _cargarProductos() async {
    final productos = await context.read<ProductoRepository>().obtenerTodos();
    if (!mounted) return;
    setState(() => _productosPorId = {for (final p in productos) p.id!: p});
  }

  Future<void> _avanzar() async {
    final provider = context.read<PedidoProvider>();
    final ok = await provider.avanzarEstado(widget.pedidoId);
    if (!mounted || ok) return;
    _mostrarError(provider.mensajeError ?? 'No se pudo avanzar el estado.');
  }

  Future<void> _cancelar() async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar pedido'),
        content: const Text(
          '¿Cancelar este pedido? Esta acción queda registrada en el historial y no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sí, cancelar'),
          ),
        ],
      ),
    );
    if (confirmado != true || !mounted) return;

    final provider = context.read<PedidoProvider>();
    final ok = await provider.cancelar(widget.pedidoId);
    if (!mounted || ok) return;
    _mostrarError(provider.mensajeError ?? 'No se pudo cancelar el pedido.');
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(showCloseIcon: true, content: Text(mensaje)));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PedidoProvider>(
      builder: (context, provider, _) {
        final detalle = provider.detalle;
        final cargando = detalle == null || detalle.pedido.id != widget.pedidoId;

        if (cargando) {
          return Scaffold(
            appBar: AppBar(title: const Text('Pedido')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final pedido = detalle.pedido;
        final estado = pedido.estadoActual;
        final colorScheme = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;

        return Scaffold(
          appBar: AppBar(
            title: Text('Pedido #${pedido.id}'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(child: BadgeEstadoPedido(estado: estado)),
              ),
            ],
          ),
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    Text('Creado: ${formatearFecha(pedido.fechaCreacion)}'),
                    if (pedido.prioridad > 0)
                      Text('Prioridad: ${pedido.prioridad}'),
                    const SizedBox(height: 24),
                    Text('Productos', style: textTheme.titleSmall),
                    const SizedBox(height: 8),
                    Card(
                      child: Column(
                        children: [
                          for (final item in detalle.items)
                            ListTile(
                              title: Text(
                                _productosPorId[item.productoId]?.nombre ??
                                    'Producto #${item.productoId}',
                              ),
                              subtitle: Text(
                                '${item.cantidad} × S/ ${item.precioAplicado.toStringAsFixed(2)}',
                              ),
                              trailing: Text(
                                'S/ ${item.subtotal.toStringAsFixed(2)}',
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Tiempo de Ciclo del Pedido (TCP)',
                      style: textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (final etapa in detalle.tcp.etapas)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${etapa.desde.etiqueta} → ${etapa.hasta.etiqueta}',
                                        style: textTheme.bodyMedium,
                                      ),
                                    ),
                                    Text(formatearDuracion(etapa.duracion)),
                                  ],
                                ),
                              ),
                            if (detalle.tcp.etapas.isNotEmpty)
                              const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('TCP total', style: textTheme.titleSmall),
                                Text(
                                  detalle.tcp.tcpTotal != null
                                      ? formatearDuracion(
                                          detalle.tcp.tcpTotal!,
                                        )
                                      : 'En curso',
                                  style: textTheme.titleSmall?.copyWith(
                                    color: detalle.tcp.tcpTotal == null
                                        ? colorScheme.onSurfaceVariant
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (estado.puedeAvanzar)
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _avanzar,
                          icon: const Icon(LucideIcons.arrowRight),
                          label: Text(
                            'Avanzar a "${estado.siguienteEstado!.etiqueta}"',
                          ),
                        ),
                      ),
                    if (estado.puedeCancelar) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _cancelar,
                          icon: const Icon(LucideIcons.x),
                          label: const Text('Cancelar pedido'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
