import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/estado/proyecto_activo.dart';
import '../../../data/models/cliente.dart';
import '../../../data/repositories/cliente_repository.dart';
import 'cliente_form_screen.dart';
import 'importar_clientes_csv_screen.dart';

/// Pantalla 3 (CLAUDE.md sección 8), lista: clientes del proyecto activo,
/// con alta manual, edición, borrado e importación CSV.
class ClientesScreen extends StatefulWidget {
  const ClientesScreen({super.key});

  @override
  State<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  List<Cliente> _clientes = [];
  bool _cargando = true;

  int get _proyectoId => context.read<ProyectoActivo>().proyecto!.id!;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _cargando = true);
    final clientes = await context.read<ClienteRepository>().obtenerPorProyecto(_proyectoId);
    if (!mounted) return;
    setState(() {
      _clientes = clientes;
      _cargando = false;
    });
  }

  Future<void> _abrirFormulario({Cliente? existente}) async {
    final guardado = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ClienteFormScreen(proyectoId: _proyectoId, existente: existente),
      ),
    );
    if (guardado == true) await _cargar();
  }

  Future<void> _abrirImportador() async {
    final importado = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ImportarClientesCsvScreen(proyectoId: _proyectoId),
      ),
    );
    if (importado == true) await _cargar();
  }

  Future<void> _confirmarEliminar(Cliente cliente) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar cliente'),
        content: Text('¿Eliminar "${cliente.nombre}"? Esta acción no se puede deshacer.'),
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

    await context.read<ClienteRepository>().eliminar(cliente.id!);
    if (!mounted) return;
    await _cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        actions: [
          IconButton(
            onPressed: _abrirImportador,
            icon: const Icon(LucideIcons.fileUp),
            tooltip: 'Importar CSV',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        icon: const Icon(LucideIcons.plus),
        label: const Text('Agregar'),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _clientes.isEmpty
          ? _EstadoVacio(alAgregar: () => _abrirFormulario(), alImportar: _abrirImportador)
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
                  );
                },
              ),
            ),
    );
  }
}

class _TarjetaCliente extends StatelessWidget {
  const _TarjetaCliente({required this.cliente, required this.alEditar, required this.alEliminar});

  final Cliente cliente;
  final VoidCallback alEditar;
  final VoidCallback alEliminar;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: alEditar,
        leading: CircleAvatar(
          backgroundColor: cliente.activo
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerHighest,
          child: Icon(
            LucideIcons.mapPin,
            color: cliente.activo ? colorScheme.onPrimaryContainer : colorScheme.onSurfaceVariant,
          ),
        ),
        title: Text(cliente.nombre),
        subtitle: Text(
          'Demanda ${cliente.demandaAnual} · ${cliente.pedidosAnuales} pedidos/año'
          '${cliente.activo ? '' : ' · inactivo'}',
        ),
        trailing: IconButton(
          onPressed: alEliminar,
          icon: const Icon(LucideIcons.trash2),
          tooltip: 'Eliminar',
        ),
      ),
    );
  }
}

class _EstadoVacio extends StatelessWidget {
  const _EstadoVacio({required this.alAgregar, required this.alImportar});

  final VoidCallback alAgregar;
  final VoidCallback alImportar;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.users,
              size: 40,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              'Todavía no hay clientes.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              alignment: WrapAlignment.center,
              children: [
                FilledButton.icon(
                  onPressed: alAgregar,
                  icon: const Icon(LucideIcons.plus),
                  label: const Text('Agregar uno'),
                ),
                OutlinedButton.icon(
                  onPressed: alImportar,
                  icon: const Icon(LucideIcons.fileUp),
                  label: const Text('Importar CSV'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
