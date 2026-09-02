import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../data/models/indicador.dart';
import '../../../data/repositories/indicador_repository.dart';
import '../detalle_indicador/detalle_indicador_screen.dart';
import 'indicador_form_screen.dart';

const _etiquetasCategoria = {
  'costo': 'Costo',
  'servicio': 'Servicio',
  'productividad': 'Productividad',
};

const _iconosCategoria = {
  'costo': LucideIcons.circleDollarSign,
  'servicio': LucideIcons.badgeCheck,
  'productividad': LucideIcons.gauge,
};

/// Pantalla 4 (CLAUDE.md sección 9): catálogo de indicadores de la
/// organización activa, con meta, banda, sentido y proceso.
class IndicadoresScreen extends StatefulWidget {
  const IndicadoresScreen({super.key, required this.organizacionId});

  final int organizacionId;

  @override
  State<IndicadoresScreen> createState() => _IndicadoresScreenState();
}

class _IndicadoresScreenState extends State<IndicadoresScreen> {
  List<Indicador> _indicadores = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _cargando = true);
    final indicadores = await context.read<IndicadorRepository>().obtenerPorOrganizacion(
      widget.organizacionId,
    );
    if (!mounted) return;
    setState(() {
      _indicadores = indicadores;
      _cargando = false;
    });
  }

  Future<void> _abrirFormulario({Indicador? existente}) async {
    final guardado = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => IndicadorFormScreen(organizacionId: widget.organizacionId, existente: existente),
      ),
    );
    if (guardado == true) await _cargar();
  }

  Future<void> _confirmarEliminar(Indicador indicador) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar indicador'),
        content: Text(
          '¿Eliminar "${indicador.nombre}"? Se borran también sus mediciones, '
          'evaluaciones y memoria asociadas. Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancelar')),
          FilledButton.tonal(onPressed: () => Navigator.of(context).pop(true), child: const Text('Eliminar')),
        ],
      ),
    );
    if (confirmado != true || !mounted) return;

    await context.read<IndicadorRepository>().eliminar(indicador.id!);
    if (!mounted) return;
    await _cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Indicadores')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        icon: const Icon(LucideIcons.plus),
        label: const Text('Nuevo indicador'),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _indicadores.isEmpty
          ? const _EstadoVacio()
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 88),
              itemCount: _indicadores.length,
              itemBuilder: (context, index) {
                final indicador = _indicadores[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Icon(_iconosCategoria[indicador.categoria] ?? LucideIcons.gauge, size: 18),
                  ),
                  title: Text(indicador.nombre),
                  subtitle: Text(
                    '${_etiquetasCategoria[indicador.categoria]} · ${indicador.proceso} · '
                    'meta ${indicador.meta.toStringAsFixed(indicador.decimales)} ${indicador.unidad}'
                    '${indicador.activo ? '' : ' · inactivo'}',
                  ),
                  onTap: () => _abrirFormulario(existente: indicador),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(LucideIcons.chartLine),
                        tooltip: 'Ver serie',
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => DetalleIndicadorScreen(indicador: indicador),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(LucideIcons.trash2),
                        tooltip: 'Eliminar',
                        onPressed: () => _confirmarEliminar(indicador),
                      ),
                    ],
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
            Icon(LucideIcons.gauge, size: 48, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            Text(
              'Todavía no hay indicadores. Crea el primero con su meta y banda de tolerancia.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
