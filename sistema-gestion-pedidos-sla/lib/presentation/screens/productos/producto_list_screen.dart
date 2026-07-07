import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../data/models/producto.dart';
import '../../../data/repositories/producto_repository.dart';
import '../../widgets/estado_vacio.dart';
import 'producto_form_screen.dart';

class ProductoListScreen extends StatefulWidget {
  const ProductoListScreen({super.key});

  @override
  State<ProductoListScreen> createState() => _ProductoListScreenState();
}

class _ProductoListScreenState extends State<ProductoListScreen> {
  List<Producto> _productos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _cargando = true);
    final productos = await context.read<ProductoRepository>().obtenerTodos();
    if (!mounted) return;
    setState(() {
      _productos = productos;
      _cargando = false;
    });
  }

  Future<void> _abrirFormulario({Producto? existente}) async {
    final guardado = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ProductoFormScreen(existente: existente),
      ),
    );
    if (guardado == true) await _cargar();
  }

  Future<void> _confirmarEliminar(Producto producto) async {
    final repositorio = context.read<ProductoRepository>();
    final tieneItems = await repositorio.tieneItemsAsociados(producto.id!);
    if (!mounted) return;

    if (tieneItems) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            showCloseIcon: true,
            content: Text(
              'No se puede eliminar "${producto.nombre}": tiene pedidos asociados.',
            ),
          ),
        );
      return;
    }

    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: Text(
          '¿Eliminar "${producto.nombre}"? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmado != true || !mounted) return;

    await repositorio.eliminar(producto.id!);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          showCloseIcon: true,
          content: Text('"${producto.nombre}" eliminado.'),
        ),
      );
    await _cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Productos')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        icon: const Icon(LucideIcons.plus),
        label: const Text('Agregar'),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _productos.isEmpty
          ? EstadoVacio(
              icono: LucideIcons.package,
              titulo: 'Todavía no tienes productos.',
              descripcion: 'Agrega el primero para poder crear pedidos.',
              accion: FilledButton.icon(
                onPressed: () => _abrirFormulario(),
                icon: const Icon(LucideIcons.plus),
                label: const Text('Agregar el primero'),
              ),
            )
          : SafeArea(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                itemCount: _productos.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final producto = _productos[index];
                  return _TarjetaProducto(
                    producto: producto,
                    alEditar: () => _abrirFormulario(existente: producto),
                    alEliminar: () => _confirmarEliminar(producto),
                  ).animate().fadeIn(delay: (index * 30).ms, duration: 200.ms);
                },
              ),
            ),
    );
  }
}

class _TarjetaProducto extends StatelessWidget {
  const _TarjetaProducto({
    required this.producto,
    required this.alEditar,
    required this.alEliminar,
  });

  final Producto producto;
  final VoidCallback alEditar;
  final VoidCallback alEliminar;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: alEditar,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  LucideIcons.package,
                  color: colorScheme.onSecondaryContainer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      producto.nombre,
                      style: textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${producto.categoria.etiqueta} · S/ ${producto.valorUnitario.toStringAsFixed(2)}',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: alEliminar,
                icon: const Icon(LucideIcons.trash2),
                tooltip: 'Eliminar',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
