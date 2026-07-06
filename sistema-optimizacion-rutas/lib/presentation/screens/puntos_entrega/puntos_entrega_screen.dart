import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../data/models/punto_entrega.dart';
import '../../../data/repositories/punto_entrega_repository.dart';
import 'punto_entrega_form_screen.dart';

/// Pantalla de Puntos de entrega (sección 8 de CLAUDE.md): CRUD completo
/// (crear, editar, eliminar) sobre el catálogo de clientes/destinos.
class PuntosEntregaScreen extends StatefulWidget {
  const PuntosEntregaScreen({super.key});

  @override
  State<PuntosEntregaScreen> createState() => _PuntosEntregaScreenState();
}

class _PuntosEntregaScreenState extends State<PuntosEntregaScreen> {
  List<PuntoEntrega> _puntos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _cargando = true);
    final puntos = await context.read<PuntoEntregaRepository>().obtenerTodos();
    if (!mounted) return;
    setState(() {
      _puntos = puntos;
      _cargando = false;
    });
  }

  Future<void> _abrirFormulario({PuntoEntrega? existente}) async {
    final guardado = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => PuntoEntregaFormScreen(existente: existente),
      ),
    );
    if (guardado == true) await _cargar();
  }

  Future<void> _confirmarEliminar(PuntoEntrega punto) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar punto de entrega'),
        content: Text('¿Eliminar "${punto.nombre}"? Esta acción no se puede deshacer.'),
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

    await context.read<PuntoEntregaRepository>().eliminar(punto.id!);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          showCloseIcon: true,
          content: Text('"${punto.nombre}" eliminado.'),
        ),
      );
    await _cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Puntos de entrega')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        icon: const Icon(LucideIcons.plus),
        label: const Text('Agregar'),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _puntos.isEmpty
          ? _EstadoVacio(alAgregar: () => _abrirFormulario())
          : SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final columnas = (constraints.maxWidth / 340)
                      .floor()
                      .clamp(1, 3);
                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columnas,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      mainAxisExtent: 108,
                    ),
                    itemCount: _puntos.length,
                    itemBuilder: (context, index) {
                      final punto = _puntos[index];
                      return _TarjetaPunto(
                        punto: punto,
                        alEditar: () => _abrirFormulario(existente: punto),
                        alEliminar: () => _confirmarEliminar(punto),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}

class _TarjetaPunto extends StatelessWidget {
  const _TarjetaPunto({
    required this.punto,
    required this.alEditar,
    required this.alEliminar,
  });

  final PuntoEntrega punto;
  final VoidCallback alEditar;
  final VoidCallback alEliminar;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
                  LucideIcons.mapPin,
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
                      punto.nombre,
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${punto.demanda.toStringAsFixed(0)} kg · '
                      '${punto.latitud.toStringAsFixed(3)}, '
                      '${punto.longitud.toStringAsFixed(3)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
              LucideIcons.mapPin,
              size: 40,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              'Todavía no hay puntos de entrega.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: alAgregar,
              icon: const Icon(LucideIcons.plus),
              label: const Text('Agregar el primero'),
            ),
          ],
        ),
      ),
    );
  }
}
