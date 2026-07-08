import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/constants.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/cliente.dart';
import '../../../data/models/pedido.dart';
import '../../../data/repositories/cliente_repository.dart';
import '../../../data/repositories/pedido_repository.dart';
import '../../widgets/badge_estado_pedido.dart';
import '../../widgets/estado_vacio.dart';
import 'pedido_detalle_screen.dart';
import 'pedido_form_screen.dart';

/// Lista de pedidos con filtro por estado y por cliente (CLAUDE.md §6.1).
/// Sin provider propio: es solo consulta y filtrado, sin lógica de negocio.
class PedidoListScreen extends StatefulWidget {
  const PedidoListScreen({super.key, this.filtroInicial});

  /// Filtro de estado con el que se abre la lista (ej. al llegar desde una
  /// tarjeta del dashboard) — el usuario puede cambiarlo o quitarlo después
  /// como cualquier otro filtro.
  final EstadoPedido? filtroInicial;

  @override
  State<PedidoListScreen> createState() => _PedidoListScreenState();
}

class _PedidoListScreenState extends State<PedidoListScreen> {
  List<Pedido> _pedidos = [];
  Map<int, Cliente> _clientesPorId = {};
  bool _cargando = true;

  late EstadoPedido? _filtroEstado = widget.filtroInicial;
  int? _filtroClienteId;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _cargando = true);
    final pedidoRepository = context.read<PedidoRepository>();
    final clienteRepository = context.read<ClienteRepository>();
    final pedidos = await pedidoRepository.obtenerTodos();
    final clientes = await clienteRepository.obtenerTodos();
    if (!mounted) return;
    setState(() {
      _pedidos = pedidos;
      _clientesPorId = {for (final c in clientes) c.id!: c};
      _cargando = false;
    });
  }

  List<Pedido> get _pedidosFiltrados {
    return _pedidos.where((p) {
      if (_filtroEstado != null && p.estadoActual != _filtroEstado) {
        return false;
      }
      if (_filtroClienteId != null && p.clienteId != _filtroClienteId) {
        return false;
      }
      return true;
    }).toList()
      ..sort((a, b) => b.fechaCreacion.compareTo(a.fechaCreacion));
  }

  Future<void> _abrirNuevoPedido() async {
    final creado = await Navigator.of(
      context,
    ).push<bool>(MaterialPageRoute(builder: (_) => const PedidoFormScreen()));
    if (creado == true) await _cargar();
  }

  Future<void> _abrirDetalle(Pedido pedido) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PedidoDetalleScreen(pedidoId: pedido.id!),
      ),
    );
    await _cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pedidos')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirNuevoPedido,
        icon: const Icon(LucideIcons.plus),
        label: const Text('Nuevo pedido'),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  _BarraFiltros(
                    clientes: _clientesPorId.values.toList(),
                    filtroEstado: _filtroEstado,
                    filtroClienteId: _filtroClienteId,
                    onEstadoCambiado: (v) =>
                        setState(() => _filtroEstado = v),
                    onClienteCambiado: (v) =>
                        setState(() => _filtroClienteId = v),
                  ),
                  Expanded(
                    child: _pedidosFiltrados.isEmpty
                        ? EstadoVacio(
                            icono: LucideIcons.clipboardList,
                            titulo: _pedidos.isEmpty
                                ? 'Todavía no tienes pedidos.'
                                : 'Ningún pedido coincide con el filtro.',
                            descripcion: _pedidos.isEmpty
                                ? 'Crea el primero para empezar a medir el nivel de servicio.'
                                : null,
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(
                              16,
                              8,
                              16,
                              96,
                            ),
                            itemCount: _pedidosFiltrados.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final pedido = _pedidosFiltrados[index];
                              final cliente = _clientesPorId[pedido.clienteId];
                              return _TarjetaPedido(
                                pedido: pedido,
                                nombreCliente: cliente?.nombre ?? '—',
                                onTap: () => _abrirDetalle(pedido),
                              ).animate().fadeIn(
                                delay: (index * 30).ms,
                                duration: 200.ms,
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _BarraFiltros extends StatelessWidget {
  const _BarraFiltros({
    required this.clientes,
    required this.filtroEstado,
    required this.filtroClienteId,
    required this.onEstadoCambiado,
    required this.onClienteCambiado,
  });

  final List<Cliente> clientes;
  final EstadoPedido? filtroEstado;
  final int? filtroClienteId;
  final ValueChanged<EstadoPedido?> onEstadoCambiado;
  final ValueChanged<int?> onClienteCambiado;

  @override
  Widget build(BuildContext context) {
    final dropdownEstado = DropdownButtonFormField<EstadoPedido?>(
      initialValue: filtroEstado,
      decoration: const InputDecoration(labelText: 'Estado', isDense: true),
      items: [
        const DropdownMenuItem(value: null, child: Text('Todos')),
        for (final estado in EstadoPedido.values)
          DropdownMenuItem(value: estado, child: Text(estado.etiqueta)),
      ],
      onChanged: onEstadoCambiado,
    );
    final dropdownCliente = DropdownButtonFormField<int?>(
      initialValue: filtroClienteId,
      decoration: const InputDecoration(labelText: 'Cliente', isDense: true),
      items: [
        const DropdownMenuItem(value: null, child: Text('Todos')),
        for (final cliente in clientes)
          DropdownMenuItem(
            value: cliente.id,
            child: Text(cliente.nombre, overflow: TextOverflow.ellipsis),
          ),
      ],
      onChanged: onClienteCambiado,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Dos dropdowns con label + flecha no entran cómodos por debajo
          // de ~480px de ancho (celular en vertical) — se apilan en vez de
          // recortarse.
          if (constraints.maxWidth < 480) {
            return Column(
              children: [
                dropdownEstado,
                const SizedBox(height: 12),
                dropdownCliente,
              ],
            );
          }
          return Row(
            children: [
              Expanded(child: dropdownEstado),
              const SizedBox(width: 12),
              Expanded(child: dropdownCliente),
            ],
          );
        },
      ),
    );
  }
}

class _TarjetaPedido extends StatelessWidget {
  const _TarjetaPedido({
    required this.pedido,
    required this.nombreCliente,
    required this.onTap,
  });

  final Pedido pedido;
  final String nombreCliente;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Pedido #${pedido.id} · $nombreCliente',
                      style: textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatearFecha(pedido.fechaCreacion),
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              BadgeEstadoPedido(estado: pedido.estadoActual),
            ],
          ),
        ),
      ),
    );
  }
}
