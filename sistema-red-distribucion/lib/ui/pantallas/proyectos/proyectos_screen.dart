import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/estado/proyecto_activo.dart';
import '../../../data/models/proyecto.dart';
import '../../../data/repositories/proyecto_repository.dart';
import '../proyecto_dashboard/proyecto_dashboard_screen.dart';
import 'proyecto_form_screen.dart';

/// Punto de entrada de la app: lista de proyectos, con alta/edición/borrado
/// y selección del proyecto activo (Pantalla 1 "Inicio" de CLAUDE.md,
/// fusionada con el CRUD de Pantalla 2 ya que ambas operan sobre la misma
/// entidad).
class ProyectosScreen extends StatefulWidget {
  const ProyectosScreen({super.key});

  @override
  State<ProyectosScreen> createState() => _ProyectosScreenState();
}

class _ProyectosScreenState extends State<ProyectosScreen> {
  List<Proyecto> _proyectos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _cargando = true);
    final proyectos = await context.read<ProyectoRepository>().obtenerTodos();
    if (!mounted) return;
    setState(() {
      _proyectos = proyectos;
      _cargando = false;
    });
  }

  Future<void> _abrirFormulario({Proyecto? existente}) async {
    final guardado = await Navigator.of(context).push<Proyecto>(
      MaterialPageRoute(builder: (_) => ProyectoFormScreen(existente: existente)),
    );
    if (guardado != null) await _cargar();
  }

  void _abrirProyecto(Proyecto proyecto) {
    context.read<ProyectoActivo>().seleccionar(proyecto);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ProyectoDashboardScreen()),
    );
  }

  Future<void> _confirmarEliminar(Proyecto proyecto) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar proyecto'),
        content: Text(
          '¿Eliminar "${proyecto.nombre}"? Se borran también sus clientes, '
          'zonas, sitios candidatos, plantas, matriz de distancias y '
          'escenarios. Esta acción no se puede deshacer.',
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

    await context.read<ProyectoRepository>().eliminar(proyecto.id!);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(showCloseIcon: true, content: Text('"${proyecto.nombre}" eliminado.')),
      );
    await _cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sistema de Red de Distribución')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        icon: const Icon(LucideIcons.plus),
        label: const Text('Nuevo proyecto'),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _proyectos.isEmpty
          ? _EstadoVacio(alAgregar: () => _abrirFormulario())
          : SafeArea(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                itemCount: _proyectos.length,
                itemBuilder: (context, index) {
                  final proyecto = _proyectos[index];
                  return _TarjetaProyecto(
                    proyecto: proyecto,
                    alAbrir: () => _abrirProyecto(proyecto),
                    alEditar: () => _abrirFormulario(existente: proyecto),
                    alEliminar: () => _confirmarEliminar(proyecto),
                  );
                },
              ),
            ),
    );
  }
}

class _TarjetaProyecto extends StatelessWidget {
  const _TarjetaProyecto({
    required this.proyecto,
    required this.alAbrir,
    required this.alEditar,
    required this.alEliminar,
  });

  final Proyecto proyecto;
  final VoidCallback alAbrir;
  final VoidCallback alEditar;
  final VoidCallback alEliminar;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: alAbrir,
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
                child: Icon(LucideIcons.network, color: colorScheme.onPrimaryContainer),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      proyecto.nombre,
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${proyecto.moneda} · ${proyecto.unidadPeso} · '
                      'horizonte ${proyecto.horizonteAnios} años',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: alEditar,
                icon: const Icon(LucideIcons.pencil),
                tooltip: 'Editar',
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

class _EstadoVacio extends StatelessWidget {
  const _EstadoVacio({required this.alAgregar});

  final VoidCallback alAgregar;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.network,
              size: 40,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              'Todavía no hay proyectos.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: alAgregar,
              icon: const Icon(LucideIcons.plus),
              label: const Text('Crear el primero'),
            ),
          ],
        ),
      ),
    );
  }
}
