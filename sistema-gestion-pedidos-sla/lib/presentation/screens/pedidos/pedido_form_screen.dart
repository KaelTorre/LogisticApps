import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../data/models/cliente.dart';
import '../../../data/models/pedido_item.dart';
import '../../../data/models/producto.dart';
import '../../../data/repositories/cliente_repository.dart';
import '../../../data/repositories/producto_repository.dart';
import '../../providers/pedido_provider.dart';
import '../_shared/validadores_formulario.dart';

class _ItemBorrador {
  _ItemBorrador({required this.producto, required this.cantidad});
  final Producto producto;
  final int cantidad;
  double get subtotal => producto.valorUnitario * cantidad;
}

/// Formulario de creación de pedido: selección de cliente, productos +
/// cantidad (subtotal automático) y prioridad opcional (CLAUDE.md §6.1).
class PedidoFormScreen extends StatefulWidget {
  const PedidoFormScreen({super.key});

  @override
  State<PedidoFormScreen> createState() => _PedidoFormScreenState();
}

class _PedidoFormScreenState extends State<PedidoFormScreen> {
  bool _cargandoDatos = true;
  List<Cliente> _clientes = [];
  List<Producto> _productos = [];

  int? _clienteId;
  int _prioridad = 0;
  final List<_ItemBorrador> _items = [];
  bool _mostrarErrorSinItems = false;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final clienteRepository = context.read<ClienteRepository>();
    final productoRepository = context.read<ProductoRepository>();
    final clientes = await clienteRepository.obtenerTodos();
    final productos = await productoRepository.obtenerTodos();
    if (!mounted) return;
    setState(() {
      _clientes = clientes;
      _productos = productos;
      _clienteId = clientes.isNotEmpty ? clientes.first.id : null;
      _cargandoDatos = false;
    });
  }

  double get _total => _items.fold(0, (suma, item) => suma + item.subtotal);

  Future<void> _agregarItem() async {
    if (_productos.isEmpty) return;
    final agregado = await showDialog<_ItemBorrador>(
      context: context,
      builder: (_) => _DialogoAgregarItem(productos: _productos),
    );
    if (agregado == null) return;
    setState(() {
      _items.add(agregado);
      _mostrarErrorSinItems = false;
    });
  }

  Future<void> _guardar() async {
    final clienteId = _clienteId;
    if (clienteId == null) return;
    if (_items.isEmpty) {
      setState(() => _mostrarErrorSinItems = true);
      return;
    }

    final provider = context.read<PedidoProvider>();
    final ok = await provider.crear(
      clienteId: clienteId,
      prioridad: _prioridad,
      items: [
        for (final item in _items)
          PedidoItem(
            pedidoId: 0,
            productoId: item.producto.id!,
            cantidad: item.cantidad,
            precioAplicado: item.producto.valorUnitario,
          ),
      ],
    );

    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            showCloseIcon: true,
            content: Text(provider.mensajeError ?? 'No se pudo crear el pedido.'),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cargandoDatos) {
      return Scaffold(
        appBar: AppBar(title: const Text('Nuevo pedido')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_clientes.isEmpty || _productos.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Nuevo pedido')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              _clientes.isEmpty
                  ? 'Registra al menos un cliente antes de crear un pedido.'
                  : 'Registra al menos un producto antes de crear un pedido.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo pedido')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      DropdownButtonFormField<int>(
                        initialValue: _clienteId,
                        decoration: const InputDecoration(labelText: 'Cliente'),
                        items: [
                          for (final cliente in _clientes)
                            DropdownMenuItem(
                              value: cliente.id,
                              child: Text(cliente.nombre),
                            ),
                        ],
                        onChanged: (valor) =>
                            setState(() => _clienteId = valor),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: '0',
                        decoration: const InputDecoration(
                          labelText: 'Prioridad (opcional)',
                          hintText: '0 = normal, mayor número = mayor prioridad',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (valor) => validarNumeroNoNegativo(
                          valor,
                          etiqueta: 'La prioridad',
                          requerido: false,
                        ),
                        onChanged: (valor) => _prioridad =
                            int.tryParse(valor.trim()) ?? 0,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Productos',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          TextButton.icon(
                            onPressed: _agregarItem,
                            icon: const Icon(LucideIcons.plus, size: 18),
                            label: const Text('Agregar'),
                          ),
                        ],
                      ),
                      if (_items.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'Todavía no agregaste productos.',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: _mostrarErrorSinItems
                                      ? Theme.of(context).colorScheme.error
                                      : Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        )
                      else
                        ...List.generate(_items.length, (index) {
                          final item = _items[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(item.producto.nombre),
                            subtitle: Text(
                              '${item.cantidad} × S/ ${item.producto.valorUnitario.toStringAsFixed(2)}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'S/ ${item.subtotal.toStringAsFixed(2)}',
                                ),
                                IconButton(
                                  icon: const Icon(LucideIcons.x, size: 18),
                                  onPressed: () =>
                                      setState(() => _items.removeAt(index)),
                                ),
                              ],
                            ),
                          );
                        }),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            'S/ ${_total.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _guardar,
                      icon: const Icon(LucideIcons.save),
                      label: const Text('Crear pedido'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DialogoAgregarItem extends StatefulWidget {
  const _DialogoAgregarItem({required this.productos});
  final List<Producto> productos;

  @override
  State<_DialogoAgregarItem> createState() => _DialogoAgregarItemState();
}

class _DialogoAgregarItemState extends State<_DialogoAgregarItem> {
  late Producto _producto = widget.productos.first;
  final _cantidadCtrl = TextEditingController(text: '1');

  @override
  void dispose() {
    _cantidadCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Agregar producto'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<Producto>(
            initialValue: _producto,
            decoration: const InputDecoration(labelText: 'Producto'),
            items: [
              for (final producto in widget.productos)
                DropdownMenuItem(value: producto, child: Text(producto.nombre)),
            ],
            onChanged: (valor) => setState(() => _producto = valor!),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _cantidadCtrl,
            decoration: const InputDecoration(labelText: 'Cantidad'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            final cantidad = int.tryParse(_cantidadCtrl.text.trim());
            if (cantidad == null || cantidad <= 0) return;
            Navigator.of(context).pop(
              _ItemBorrador(producto: _producto, cantidad: cantidad),
            );
          },
          child: const Text('Agregar'),
        ),
      ],
    );
  }
}
