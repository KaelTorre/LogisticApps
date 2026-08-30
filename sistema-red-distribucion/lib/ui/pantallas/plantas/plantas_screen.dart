import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/dinero_utils.dart';
import '../../../core/estado/proyecto_activo.dart';
import '../../../data/models/planta.dart';
import '../../../data/repositories/planta_repository.dart';
import 'planta_form_screen.dart';

/// Pantalla 7 (CLAUDE.md sección 8), lista: plantas del proyecto activo.
class PlantasScreen extends StatefulWidget {
  const PlantasScreen({super.key});

  @override
  State<PlantasScreen> createState() => _PlantasScreenState();
}

class _PlantasScreenState extends State<PlantasScreen> {
  List<Planta> _plantas = [];
  bool _cargando = true;

  int get _proyectoId => context.read<ProyectoActivo>().proyecto!.id!;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _cargando = true);
    final plantas = await context.read<PlantaRepository>().obtenerPorProyecto(_proyectoId);
    if (!mounted) return;
    setState(() {
      _plantas = plantas;
      _cargando = false;
    });
  }

  Future<void> _abrirFormulario({Planta? existente}) async {
    final guardado = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => PlantaFormScreen(proyectoId: _proyectoId, existente: existente),
      ),
    );
    if (guardado == true) await _cargar();
  }

  Future<void> _confirmarEliminar(Planta planta) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar planta'),
        content: Text('¿Eliminar "${planta.nombre}"? Esta acción no se puede deshacer.'),
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

    await context.read<PlantaRepository>().eliminar(planta.id!);
    if (!mounted) return;
    await _cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plantas')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        icon: const Icon(LucideIcons.plus),
        label: const Text('Agregar'),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _plantas.isEmpty
          ? _EstadoVacio(alAgregar: () => _abrirFormulario())
          : SafeArea(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                itemCount: _plantas.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final planta = _plantas[index];
                  return _TarjetaPlanta(
                    planta: planta,
                    alEditar: () => _abrirFormulario(existente: planta),
                    alEliminar: () => _confirmarEliminar(planta),
                  );
                },
              ),
            ),
    );
  }
}

class _TarjetaPlanta extends StatelessWidget {
  const _TarjetaPlanta({required this.planta, required this.alEditar, required this.alEliminar});

  final Planta planta;
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
          backgroundColor: colorScheme.secondaryContainer,
          child: Icon(LucideIcons.factory, color: colorScheme.onSecondaryContainer),
        ),
        title: Text(planta.nombre),
        subtitle: Text(
          'Capacidad ${planta.capacidadAnual} · producción '
          '${centimosATexto(planta.costoProduccionCentPorUnidad)}/unidad',
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
              LucideIcons.factory,
              size: 40,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              'Todavía no hay plantas.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: alAgregar,
              icon: const Icon(LucideIcons.plus),
              label: const Text('Agregar la primera'),
            ),
          ],
        ),
      ),
    );
  }
}
