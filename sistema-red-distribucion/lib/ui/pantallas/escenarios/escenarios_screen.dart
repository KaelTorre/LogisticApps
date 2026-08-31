import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/dinero_utils.dart';
import '../../../core/estado/proyecto_activo.dart';
import '../../../data/models/escenario.dart';
import '../../../data/repositories/escenario_repository.dart';

const _etiquetasMetodo = {
  'add': 'ADD',
  'drop': 'DROP',
  'intercambio': 'Intercambio (Teitz y Bart)',
  'recocido': 'Recocido simulado',
  'enumeracion': 'Enumeración exhaustiva',
  'barrido': 'Barrido (curva de costo)',
};

/// Lista de escenarios calculados del proyecto activo, con la opción de
/// eliminarlos. Un escenario guardado bloquea el borrado de cualquier
/// candidato o zona que use (ver comentario en `database.dart` sobre
/// `escenario_almacen`/`escenario_asignacion` sin cascada) — esta pantalla
/// es la única forma de liberar esos candidatos/zonas para poder editarlos
/// o recalcularlos.
class EscenariosScreen extends StatefulWidget {
  const EscenariosScreen({super.key});

  @override
  State<EscenariosScreen> createState() => _EscenariosScreenState();
}

class _EscenariosScreenState extends State<EscenariosScreen> {
  List<Escenario> _escenarios = [];
  bool _cargando = true;

  int get _proyectoId => context.read<ProyectoActivo>().proyecto!.id!;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _cargando = true);
    final escenarios = await context.read<EscenarioRepository>().obtenerPorProyecto(_proyectoId);
    escenarios.sort((a, b) => b.fecha.compareTo(a.fecha));
    if (!mounted) return;
    setState(() {
      _escenarios = escenarios;
      _cargando = false;
    });
  }

  Future<void> _confirmarEliminar(Escenario escenario) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar escenario'),
        content: Text(
          '¿Eliminar "${escenario.nombre}"? Se borran también sus almacenes abiertos, '
          'asignaciones, desglose de costos y memoria de cálculo. Los candidatos y zonas '
          'que usaba quedan libres para editar. Esta acción no se puede deshacer.',
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

    await context.read<EscenarioRepository>().eliminar(escenario.id!);
    if (!mounted) return;
    await _cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escenarios')),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _escenarios.isEmpty
          ? const _EstadoVacio()
          : SafeArea(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _escenarios.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final escenario = _escenarios[index];
                  return _TarjetaEscenario(
                    escenario: escenario,
                    alEliminar: () => _confirmarEliminar(escenario),
                  );
                },
              ),
            ),
    );
  }
}

class _TarjetaEscenario extends StatelessWidget {
  const _TarjetaEscenario({required this.escenario, required this.alEliminar});

  final Escenario escenario;
  final VoidCallback alEliminar;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final fecha = DateTime.tryParse(escenario.fecha);
    final fechaTexto = fecha == null
        ? escenario.fecha
        : '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';

    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.secondaryContainer,
          child: Icon(LucideIcons.history, color: colorScheme.onSecondaryContainer),
        ),
        title: Text(escenario.nombre),
        subtitle: Text(
          '${_etiquetasMetodo[escenario.metodo] ?? escenario.metodo} · '
          '${centimosATexto(escenario.costoTotalCent)} · $fechaTexto'
          '${escenario.restriccionCapacidadActiva ? ' · con restricción de capacidad' : ''}',
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
  const _EstadoVacio();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.history,
              size: 40,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              'Todavía no hay ningún escenario calculado — corre una optimización primero.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
