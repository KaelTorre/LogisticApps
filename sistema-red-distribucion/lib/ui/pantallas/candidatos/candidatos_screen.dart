import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/dinero_utils.dart';
import '../../../core/estado/proyecto_activo.dart';
import '../../../data/models/sitio_candidato.dart';
import '../../../data/repositories/parametros_costo_repository.dart';
import '../../../data/repositories/sitio_candidato_repository.dart';
import '../../../data/repositories/zona_demanda_repository.dart';
import '../../../domain/motor/m2_centro_gravedad.dart';
import 'candidato_form_screen.dart';

/// Pantalla 6 (CLAUDE.md sección 8), lista: sitios candidatos del proyecto
/// activo, con generación automática por centro de gravedad (M2, CLAUDE.md
/// sección 7) sobre las zonas de demanda que produjo M1 (Pantalla 5).
class CandidatosScreen extends StatefulWidget {
  const CandidatosScreen({super.key});

  @override
  State<CandidatosScreen> createState() => _CandidatosScreenState();
}

class _CandidatosScreenState extends State<CandidatosScreen> {
  List<SitioCandidato> _candidatos = [];
  bool _cargando = true;

  int get _proyectoId => context.read<ProyectoActivo>().proyecto!.id!;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _cargando = true);
    final candidatos = await context
        .read<SitioCandidatoRepository>()
        .obtenerPorProyecto(_proyectoId);
    if (!mounted) return;
    setState(() {
      _candidatos = candidatos;
      _cargando = false;
    });
  }

  Future<void> _abrirFormulario({SitioCandidato? existente}) async {
    final guardado = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => CandidatoFormScreen(proyectoId: _proyectoId, existente: existente),
      ),
    );
    if (guardado == true) await _cargar();
  }

  Future<void> _confirmarEliminar(SitioCandidato candidato) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar sitio candidato'),
        content: Text('¿Eliminar "${candidato.nombre}"? Esta acción no se puede deshacer.'),
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

    try {
      await context.read<SitioCandidatoRepository>().eliminar(candidato.id!);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(
              'No se puede eliminar: "${candidato.nombre}" ya forma parte de un '
              'escenario de optimización guardado.',
            ),
          ),
        );
      return;
    }
    if (!mounted) return;
    await _cargar();
  }

  Future<void> _generarPorCentroGravedad() async {
    final proyectoId = _proyectoId;
    final zonaRepository = context.read<ZonaDemandaRepository>();
    final parametrosRepository = context.read<ParametrosCostoRepository>();
    final candidatoRepository = context.read<SitioCandidatoRepository>();
    final messenger = ScaffoldMessenger.of(context);

    final zonas = await zonaRepository.obtenerPorProyecto(proyectoId);
    if (zonas.isEmpty) {
      messenger
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text('Primero calcula las zonas de demanda en Agregación.'),
          ),
        );
      return;
    }

    final parametros = await parametrosRepository.obtenerPorProyecto(proyectoId);
    if (parametros == null) {
      messenger
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text('Primero completa Parámetros de costo (tarifa de salida).'),
          ),
        );
      return;
    }

    if (!mounted) return;
    final p = await showDialog<int>(
      context: context,
      builder: (context) => _DialogoCantidadCandidatos(maximo: zonas.length),
    );
    if (p == null) return;

    final sugerencias = generarCandidatosPorCentroGravedad(
      zonas: zonas,
      tarifaCentPorKmTon: parametros.tarifaSalidaCentPorKmTon.toDouble(),
      p: p,
    );

    for (var i = 0; i < sugerencias.length; i++) {
      await candidatoRepository.crear(
        SitioCandidato(
          proyectoId: proyectoId,
          nombre: 'Candidato sugerido ${i + 1}',
          latitud: sugerencias[i].latitud,
          longitud: sugerencias[i].longitud,
          costoFijoAnualCent: 0,
          capacidadAnual: 0,
          costoVariableManejoCentPorUnidad: 0,
          origen: 'centro_gravedad',
        ),
      );
    }

    if (!mounted) return;
    messenger
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(
            '${sugerencias.length} candidato(s) sugerido(s) — completa costo fijo, '
            'capacidad y verifica que el punto sea edificable.',
          ),
        ),
      );
    await _cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sitios candidatos'),
        actions: [
          IconButton(
            onPressed: _generarPorCentroGravedad,
            icon: const Icon(LucideIcons.sparkles),
            tooltip: 'Generar por centro de gravedad',
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
          : _candidatos.isEmpty
          ? _EstadoVacio(alAgregar: () => _abrirFormulario())
          : SafeArea(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                itemCount: _candidatos.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final candidato = _candidatos[index];
                  return _TarjetaCandidato(
                    candidato: candidato,
                    alEditar: () => _abrirFormulario(existente: candidato),
                    alEliminar: () => _confirmarEliminar(candidato),
                  );
                },
              ),
            ),
    );
  }
}

class _TarjetaCandidato extends StatelessWidget {
  const _TarjetaCandidato({required this.candidato, required this.alEditar, required this.alEliminar});

  final SitioCandidato candidato;
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
          backgroundColor: colorScheme.tertiaryContainer,
          child: Icon(LucideIcons.mapPinned, color: colorScheme.onTertiaryContainer),
        ),
        title: Text(candidato.nombre),
        subtitle: Text(
          'Costo fijo ${centimosATexto(candidato.costoFijoAnualCent)} · '
          'capacidad ${candidato.capacidadAnual}'
          '${candidato.esRedActual ? ' · red actual' : ''}'
          '${candidato.origen == 'centro_gravedad' ? ' · sugerido' : ''}',
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

class _DialogoCantidadCandidatos extends StatefulWidget {
  const _DialogoCantidadCandidatos({required this.maximo});

  final int maximo;

  @override
  State<_DialogoCantidadCandidatos> createState() => _DialogoCantidadCandidatosState();
}

class _DialogoCantidadCandidatosState extends State<_DialogoCantidadCandidatos> {
  late int _p = 1;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Generar por centro de gravedad'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cada punto sugerido es un candidato a verificar, no una decisión: '
            'puede caer en un lugar no edificable.',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Cantidad de candidatos:'),
              const Spacer(),
              DropdownButton<int>(
                value: _p,
                items: [
                  for (var i = 1; i <= widget.maximo; i++)
                    DropdownMenuItem(value: i, child: Text('$i')),
                ],
                onChanged: (v) => setState(() => _p = v!),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_p),
          child: const Text('Generar'),
        ),
      ],
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
              LucideIcons.mapPinned,
              size: 40,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              'Todavía no hay sitios candidatos.',
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
