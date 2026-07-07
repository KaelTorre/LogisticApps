import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../data/models/cliente.dart';
import '../../../data/repositories/cliente_repository.dart';
import '../../widgets/estado_vacio.dart';
import 'cliente_form_screen.dart';

class ClienteListScreen extends StatefulWidget {
  const ClienteListScreen({super.key});

  @override
  State<ClienteListScreen> createState() => _ClienteListScreenState();
}

class _ClienteListScreenState extends State<ClienteListScreen> {
  List<Cliente> _clientes = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _cargando = true);
    final clientes = await context.read<ClienteRepository>().obtenerTodos();
    if (!mounted) return;
    setState(() {
      _clientes = clientes;
      _cargando = false;
    });
  }

  Future<void> _abrirFormulario({Cliente? existente}) async {
    final guardado = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ClienteFormScreen(existente: existente),
      ),
    );
    if (guardado == true) await _cargar();
  }

  Future<void> _confirmarEliminar(Cliente cliente) async {
    final repositorio = context.read<ClienteRepository>();
    final tienePedidos = await repositorio.tienePedidosAsociados(cliente.id!);
    if (!mounted) return;

    if (tienePedidos) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            showCloseIcon: true,
            content: Text(
              'No se puede eliminar "${cliente.nombre}": tiene pedidos asociados.',
            ),
          ),
        );
      return;
    }

    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar cliente'),
        content: Text(
          '¿Eliminar "${cliente.nombre}"? Esta acción no se puede deshacer.',
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

    await repositorio.eliminar(cliente.id!);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(showCloseIcon: true, content: Text('"${cliente.nombre}" eliminado.')),
      );
    await _cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clientes')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        icon: const Icon(LucideIcons.plus),
        label: const Text('Agregar'),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _clientes.isEmpty
          ? EstadoVacio(
              icono: LucideIcons.users,
              titulo: 'Todavía no tienes clientes.',
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
                itemCount: _clientes.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final cliente = _clientes[index];
                  return _TarjetaCliente(
                    cliente: cliente,
                    alEditar: () => _abrirFormulario(existente: cliente),
                    alEliminar: () => _confirmarEliminar(cliente),
                  ).animate().fadeIn(delay: (index * 30).ms, duration: 200.ms);
                },
              ),
            ),
    );
  }
}

class _TarjetaCliente extends StatelessWidget {
  const _TarjetaCliente({
    required this.cliente,
    required this.alEditar,
    required this.alEliminar,
  });

  final Cliente cliente;
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
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  LucideIcons.user,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      cliente.nombre,
                      style: textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (cliente.contacto != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        cliente.contacto!,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
