import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../data/models/periodo.dart';
import '../../../data/repositories/periodo_repository.dart';
import 'periodo_form_screen.dart';

/// Pantalla 3 (CLAUDE.md sección 9): calendario de periodos de la
/// organización activa, siempre listado por `orden` -- la clave real del
/// sistema, nunca por fecha.
class PeriodosScreen extends StatefulWidget {
  const PeriodosScreen({super.key, required this.organizacionId});

  final int organizacionId;

  @override
  State<PeriodosScreen> createState() => _PeriodosScreenState();
}

class _PeriodosScreenState extends State<PeriodosScreen> {
  List<Periodo> _periodos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _cargando = true);
    final periodos = await context.read<PeriodoRepository>().obtenerPorOrganizacion(
      widget.organizacionId,
    );
    if (!mounted) return;
    setState(() {
      _periodos = periodos;
      _cargando = false;
    });
  }

  Future<void> _abrirFormulario({Periodo? existente}) async {
    final siguienteOrden = _periodos.isEmpty
        ? 1
        : _periodos.map((p) => p.orden).reduce((a, b) => a > b ? a : b) + 1;
    final guardado = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => PeriodoFormScreen(
          organizacionId: widget.organizacionId,
          existente: existente,
          siguienteOrden: siguienteOrden,
        ),
      ),
    );
    if (guardado == true) await _cargar();
  }

  Future<void> _confirmarEliminar(Periodo periodo) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar periodo'),
        content: Text(
          '¿Eliminar "${periodo.etiqueta}"? Se borran también sus mediciones, '
          'evaluaciones y verificaciones de acciones. Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancelar')),
          FilledButton.tonal(onPressed: () => Navigator.of(context).pop(true), child: const Text('Eliminar')),
        ],
      ),
    );
    if (confirmado != true || !mounted) return;

    await context.read<PeriodoRepository>().eliminar(periodo.id!);
    if (!mounted) return;
    await _cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Periodos')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        icon: const Icon(LucideIcons.plus),
        label: const Text('Nuevo periodo'),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _periodos.isEmpty
          ? const _EstadoVacio()
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 88),
              itemCount: _periodos.length,
              itemBuilder: (context, index) {
                final periodo = _periodos[index];
                return ListTile(
                  leading: CircleAvatar(child: Text('${periodo.orden}')),
                  title: Text(periodo.etiqueta),
                  subtitle: Text(
                    [
                      periodo.granularidad,
                      if (periodo.esSimulado) 'simulado',
                    ].join(' · '),
                  ),
                  onTap: () => _abrirFormulario(existente: periodo),
                  trailing: IconButton(
                    icon: const Icon(LucideIcons.trash2),
                    tooltip: 'Eliminar',
                    onPressed: () => _confirmarEliminar(periodo),
                  ),
                );
              },
            ),
    );
  }
}

class _EstadoVacio extends StatelessWidget {
  const _EstadoVacio();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.calendarRange, size: 48, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            Text(
              'Todavía no hay periodos. Crea el primero para empezar a registrar mediciones.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
