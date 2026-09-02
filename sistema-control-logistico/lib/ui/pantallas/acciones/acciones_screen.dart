import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../data/models/accion_catalogo.dart';
import '../../../data/models/accion_tomada.dart';
import '../../../data/models/evaluacion.dart';
import '../../../data/models/indicador.dart';
import '../../../data/models/periodo.dart';
import '../../../data/repositories/accion_catalogo_repository.dart';
import '../../../data/repositories/accion_tomada_repository.dart';
import '../../../data/repositories/evaluacion_repository.dart';
import '../../../data/repositories/indicador_repository.dart';
import '../../../data/repositories/periodo_repository.dart';
import '../../../data/repositories/regla_accion_repository.dart';
import '../../../domain/motor/m3_emparejador_acciones.dart';
import '../catalogo_acciones/catalogo_acciones_screen.dart';

const _etiquetasClasificacion = {
  'ajuste_menor': 'Ajuste menor',
  'replaneacion_mayor': 'Replaneación mayor',
  'contingencia': 'Contingencia',
};

const _etiquetasEstadoAccion = {'abierta': 'Abierta', 'cerrada': 'Cerrada', 'descartada': 'Descartada'};

/// Un veredicto (`evaluacion`) que sí clasificó, junto con el indicador y
/// el periodo al que pertenece -- lo que se necesita para ofrecer
/// proponer una acción o para listar una ya tomada.
class _VeredictoConContexto {
  const _VeredictoConContexto({required this.evaluacion, required this.indicador, required this.periodo});

  final Evaluacion evaluacion;
  final Indicador indicador;
  final Periodo periodo;
}

/// Pantalla 9 (CLAUDE.md sección 9): propuestas de acción (vía M3, sobre
/// las evaluaciones que sí clasificaron) y seguimiento de las acciones ya
/// registradas.
class AccionesScreen extends StatefulWidget {
  const AccionesScreen({super.key, required this.organizacionId});

  final int organizacionId;

  @override
  State<AccionesScreen> createState() => _AccionesScreenState();
}

class _AccionesScreenState extends State<AccionesScreen> {
  bool _cargando = true;
  List<_VeredictoConContexto> _pendientes = [];
  List<AccionTomada> _tomadas = [];
  Map<int, _VeredictoConContexto> _contextoPorEvaluacionId = {};
  Map<int, AccionCatalogo> _catalogoPorId = {};

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _cargando = true);
    final indicadorRepo = context.read<IndicadorRepository>();
    final periodoRepo = context.read<PeriodoRepository>();
    final evaluacionRepo = context.read<EvaluacionRepository>();
    final accionTomadaRepo = context.read<AccionTomadaRepository>();
    final accionCatalogoRepo = context.read<AccionCatalogoRepository>();

    final indicadores = await indicadorRepo.obtenerPorOrganizacion(widget.organizacionId);
    final periodos = await periodoRepo.obtenerPorOrganizacion(widget.organizacionId);
    final periodosPorId = {for (final p in periodos) p.id!: p};
    final catalogo = await accionCatalogoRepo.obtenerTodas();
    final catalogoPorId = {for (final a in catalogo) a.id!: a};

    final conContexto = <_VeredictoConContexto>[];
    for (final indicador in indicadores) {
      for (final evaluacion in await evaluacionRepo.obtenerPorIndicador(indicador.id!)) {
        if (evaluacion.clasificacion == 'ninguna') continue;
        final periodo = periodosPorId[evaluacion.periodoId];
        if (periodo == null) continue;
        conContexto.add(_VeredictoConContexto(evaluacion: evaluacion, indicador: indicador, periodo: periodo));
      }
    }

    final tomadas = <AccionTomada>[];
    for (final v in conContexto) {
      tomadas.addAll(await accionTomadaRepo.obtenerPorEvaluacion(v.evaluacion.id!));
    }
    final evaluacionesConAccion = tomadas.map((a) => a.evaluacionId).toSet();

    conContexto.sort(
      (a, b) => periodosPorId[b.evaluacion.periodoId]!.orden.compareTo(
        periodosPorId[a.evaluacion.periodoId]!.orden,
      ),
    );

    if (!mounted) return;
    setState(() {
      _pendientes = conContexto.where((v) => !evaluacionesConAccion.contains(v.evaluacion.id)).toList();
      _tomadas = tomadas;
      _contextoPorEvaluacionId = {for (final v in conContexto) v.evaluacion.id!: v};
      _catalogoPorId = catalogoPorId;
      _cargando = false;
    });
  }

  Future<void> _proponerAccion(_VeredictoConContexto contexto) async {
    final reglaAccionRepo = context.read<ReglaAccionRepository>();
    final mapeos = (await reglaAccionRepo.obtenerTodas())
        .map(
          (m) => MapeoAccion(
            categoriaIndicador: m.categoriaIndicador,
            reglaDisparada: m.reglaDisparada,
            clasificacion: m.clasificacion,
            accionId: m.accionId,
            prioridad: m.prioridad,
          ),
        )
        .toList();

    final reglasDisparadas = (jsonDecode(contexto.evaluacion.reglasDisparadasJson) as List)
        .cast<String>()
        .toSet();
    final candidatasIds = emparejarAcciones(
      categoriaIndicador: contexto.indicador.categoria,
      reglasDisparadas: reglasDisparadas,
      clasificacion: contexto.evaluacion.clasificacion,
      catalogoMapeos: mapeos,
    );
    final candidatas = candidatasIds.map((id) => _catalogoPorId[id]).whereType<AccionCatalogo>().toList();

    if (!mounted) return;
    if (candidatas.isEmpty) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            showCloseIcon: true,
            content: const Text('No hay ninguna acción del catálogo mapeada para este caso.'),
            action: SnackBarAction(
              label: 'Configurar',
              onPressed: () => _irACatalogo(
                categoria: contexto.indicador.categoria,
                magnitud: contexto.evaluacion.clasificacion,
              ),
            ),
          ),
        );
      return;
    }

    final elegida = await showModalBottomSheet<AccionCatalogo>(
      context: context,
      builder: (context) => ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Acciones propuestas', style: Theme.of(context).textTheme.titleMedium),
          ),
          const SizedBox(height: 8),
          for (final accion in candidatas)
            ListTile(
              title: Text(accion.titulo),
              subtitle: Text(accion.descripcion),
              onTap: () => Navigator.of(context).pop(accion),
            ),
        ],
      ),
    );
    if (elegida == null || !mounted) return;

    final guardada = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => _FormularioAccionTomada(evaluacionId: contexto.evaluacion.id!, accion: elegida),
      ),
    );
    if (guardada == true) await _cargar();
  }

  Future<void> _irACatalogo({String? categoria, String? magnitud}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CatalogoAccionesScreen(categoriaInicial: categoria, magnitudInicial: magnitud),
      ),
    );
    if (!mounted) return;
    await _cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acciones'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.listTree),
            tooltip: 'Catálogo de acciones',
            onPressed: () => _irACatalogo(),
          ),
        ],
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                InkWell(
                  onTap: () => _irACatalogo(),
                  child: Row(
                    children: [
                      Icon(LucideIcons.info, size: 14, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          '¿Faltan acciones por proponer? Configúralas en el catálogo de acciones.',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text('Pendientes de proponer acción', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                if (_pendientes.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'No hay evaluaciones clasificadas sin acción registrada.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  )
                else
                  for (final v in _pendientes)
                    Card(
                      child: ListTile(
                        leading: const Icon(LucideIcons.triangleAlert),
                        title: Text(v.indicador.nombre),
                        subtitle: Text(
                          '${v.periodo.etiqueta} · ${_etiquetasClasificacion[v.evaluacion.clasificacion]}',
                        ),
                        trailing: FilledButton(
                          onPressed: () => _proponerAccion(v),
                          child: const Text('Proponer'),
                        ),
                      ),
                    ),
                const SizedBox(height: 24),
                Text('Acciones tomadas', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                if (_tomadas.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Todavía no se ha registrado ninguna acción.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  )
                else
                  for (final accion in _tomadas)
                    Card(
                      child: ListTile(
                        leading: Icon(
                          switch (accion.estado) {
                            'cerrada' => LucideIcons.circleCheck,
                            'descartada' => LucideIcons.circleX,
                            _ => LucideIcons.circleDot,
                          },
                        ),
                        title: Text(_catalogoPorId[accion.accionCatalogoId]?.titulo ?? 'Acción'),
                        subtitle: Text(
                          '${_contextoPorEvaluacionId[accion.evaluacionId]?.indicador.nombre ?? ''} · '
                          '${_etiquetasEstadoAccion[accion.estado]} · Responsable: ${accion.responsable} · '
                          'Compromiso: ${accion.fechaCompromiso}',
                        ),
                      ),
                    ),
              ],
            ),
    );
  }
}

class _FormularioAccionTomada extends StatefulWidget {
  const _FormularioAccionTomada({required this.evaluacionId, required this.accion});

  final int evaluacionId;
  final AccionCatalogo accion;

  @override
  State<_FormularioAccionTomada> createState() => _FormularioAccionTomadaState();
}

class _FormularioAccionTomadaState extends State<_FormularioAccionTomada> {
  final _formKey = GlobalKey<FormState>();
  final _responsableCtrl = TextEditingController();
  final _fechaCompromisoCtrl = TextEditingController();
  final _notasCtrl = TextEditingController();
  bool _guardando = false;

  @override
  void dispose() {
    _responsableCtrl.dispose();
    _fechaCompromisoCtrl.dispose();
    _notasCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);

    final repo = context.read<AccionTomadaRepository>();
    await repo.crear(
      AccionTomada(
        evaluacionId: widget.evaluacionId,
        accionCatalogoId: widget.accion.id!,
        responsable: _responsableCtrl.text.trim(),
        fechaCompromiso: _fechaCompromisoCtrl.text.trim(),
        notas: _notasCtrl.text.trim().isEmpty ? null : _notasCtrl.text.trim(),
        // Sello de auditoría -- uno de los dos únicos usos permitidos de
        // DateTime.now() (CLAUDE.md sección 4), fuera de lib/domain/motor/.
        fechaRegistro: DateTime.now().toIso8601String(),
      ),
    );

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar acción')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.accion.titulo, style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 4),
                    Text(widget.accion.descripcion),
                    if (widget.accion.aplicacionExternaSugerida != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        widget.accion.aplicacionExternaSugerida!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _responsableCtrl,
              decoration: const InputDecoration(labelText: 'Responsable'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa un responsable' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _fechaCompromisoCtrl,
              decoration: const InputDecoration(
                labelText: 'Fecha de compromiso',
                helperText: 'Ej. 2026-03-15',
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa una fecha' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notasCtrl,
              decoration: const InputDecoration(labelText: 'Notas (opcional)'),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _guardando ? null : _guardar,
              child: _guardando
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
