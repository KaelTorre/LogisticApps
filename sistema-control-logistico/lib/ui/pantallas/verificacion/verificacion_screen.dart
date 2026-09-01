import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../data/models/accion_tomada.dart';
import '../../../data/models/evaluacion.dart';
import '../../../data/models/indicador.dart';
import '../../../data/models/periodo.dart';
import '../../../data/models/verificacion_accion.dart';
import '../../../data/repositories/accion_catalogo_repository.dart';
import '../../../data/repositories/accion_tomada_repository.dart';
import '../../../data/repositories/evaluacion_repository.dart';
import '../../../data/repositories/indicador_repository.dart';
import '../../../data/repositories/medicion_repository.dart';
import '../../../data/repositories/periodo_repository.dart';
import '../../../data/repositories/verificacion_accion_repository.dart';
import '../../../domain/motor/m1_reglas_patron.dart';
import '../../../domain/motor/m4_verificador_acciones.dart';

const _etiquetasResultado = {'corrigio': 'Corrigió', 'no_corrigio': 'No corrigió', 'parcial': 'Parcial'};

/// Una acción abierta lista para intentar verificar, con todo el contexto
/// que M4 necesita: el indicador, el periodo donde se detectó la
/// desviación y su valor, y -- si ya existe -- el periodo siguiente con su
/// valor observado.
class _AccionPendiente {
  const _AccionPendiente({
    required this.accion,
    required this.indicador,
    required this.periodoDesviacion,
    required this.valorPeriodoDesviacion,
    this.periodoSiguiente,
    this.valorObservado,
  });

  final AccionTomada accion;
  final Indicador indicador;
  final Periodo periodoDesviacion;
  final double valorPeriodoDesviacion;
  final Periodo? periodoSiguiente;
  final double? valorObservado;

  bool get listaParaVerificar => periodoSiguiente != null && valorObservado != null;
}

/// Pantalla 10 (CLAUDE.md sección 9): M4 propone un resultado de
/// verificación en cuanto existe medición del periodo siguiente al de la
/// desviación; el usuario lo confirma o lo corrige -- [REGLA] nunca se
/// cierra una acción sola.
class VerificacionScreen extends StatefulWidget {
  const VerificacionScreen({super.key, required this.organizacionId});

  final int organizacionId;

  @override
  State<VerificacionScreen> createState() => _VerificacionScreenState();
}

class _VerificacionScreenState extends State<VerificacionScreen> {
  bool _cargando = true;
  List<_AccionPendiente> _pendientes = [];
  Map<int, String> _titulosAccion = {};

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
    final medicionRepo = context.read<MedicionRepository>();
    final accionCatalogoRepo = context.read<AccionCatalogoRepository>();

    final indicadores = await indicadorRepo.obtenerPorOrganizacion(widget.organizacionId);
    final periodos = await periodoRepo.obtenerPorOrganizacion(widget.organizacionId);
    final periodosPorId = {for (final p in periodos) p.id!: p};
    final periodosPorOrden = {for (final p in periodos) p.orden: p};
    final catalogo = {for (final a in await accionCatalogoRepo.obtenerTodas()) a.id!: a.titulo};

    final pendientes = <_AccionPendiente>[];
    for (final indicador in indicadores) {
      final evaluaciones = <int, Evaluacion>{
        for (final e in await evaluacionRepo.obtenerPorIndicador(indicador.id!)) e.id!: e,
      };
      final mediciones = {
        for (final m in await medicionRepo.obtenerPorIndicador(indicador.id!)) m.periodoId: m.valor,
      };
      final acciones = <AccionTomada>[];
      for (final evaluacion in evaluaciones.values) {
        acciones.addAll(await accionTomadaRepo.obtenerPorEvaluacion(evaluacion.id!));
      }

      for (final accion in acciones.where((a) => a.estado == 'abierta')) {
        final evaluacion = evaluaciones[accion.evaluacionId];
        final periodoDesviacion = periodosPorId[evaluacion?.periodoId];
        final valorDesviacion = mediciones[evaluacion?.periodoId];
        if (evaluacion == null || periodoDesviacion == null || valorDesviacion == null) continue;

        final periodoSiguiente = periodosPorOrden[periodoDesviacion.orden + 1];
        final valorObservado = periodoSiguiente == null ? null : mediciones[periodoSiguiente.id];

        pendientes.add(
          _AccionPendiente(
            accion: accion,
            indicador: indicador,
            periodoDesviacion: periodoDesviacion,
            valorPeriodoDesviacion: valorDesviacion,
            periodoSiguiente: periodoSiguiente,
            valorObservado: valorObservado,
          ),
        );
      }
    }

    if (!mounted) return;
    setState(() {
      _pendientes = pendientes;
      _titulosAccion = catalogo;
      _cargando = false;
    });
  }

  Future<void> _abrirVerificacion(_AccionPendiente pendiente) async {
    final indicador = pendiente.indicador;
    final config = ConfigIndicadorMotor(
      meta: indicador.meta,
      bandaInferior: indicador.bandaInferior,
      bandaSuperior: indicador.bandaSuperior,
      sentido: indicador.sentido,
    );
    final propuesta = proponerResultadoVerificacion(
      valorPeriodoDesviacion: pendiente.valorPeriodoDesviacion,
      valorObservado: pendiente.valorObservado!,
      indicador: config,
    );

    final confirmado = await showDialog<String>(
      context: context,
      builder: (context) => _DialogoVerificacion(pendiente: pendiente, propuesta: propuesta),
    );
    if (confirmado == null || !mounted) return;

    final verificacionRepo = context.read<VerificacionAccionRepository>();
    final accionTomadaRepo = context.read<AccionTomadaRepository>();

    final id = await verificacionRepo.crear(
      VerificacionAccion(
        accionTomadaId: pendiente.accion.id!,
        periodoVerificacionId: pendiente.periodoSiguiente!.id!,
        resultado: confirmado,
        valorObservado: pendiente.valorObservado!,
      ),
    );
    await verificacionRepo.confirmar(id, resultado: confirmado);

    // [REGLA] El sistema propone, el usuario confirma -- y solo cuando
    // confirma que sí corrigió, la acción se cierra. Cualquier otro
    // resultado confirmado deja la acción abierta a propósito: todavía
    // necesita atención.
    if (confirmado == 'corrigio') {
      await accionTomadaRepo.actualizar(pendiente.accion.copyWith(estado: 'cerrada'));
    }

    if (!mounted) return;
    await _cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verificación')),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _pendientes.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'No hay acciones abiertas pendientes de verificar.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _pendientes.length,
              itemBuilder: (context, index) {
                final p = _pendientes[index];
                return Card(
                  child: ListTile(
                    leading: Icon(p.listaParaVerificar ? LucideIcons.clipboardCheck : LucideIcons.clock),
                    title: Text(_titulosAccion[p.accion.accionCatalogoId] ?? 'Acción'),
                    subtitle: Text(
                      '${p.indicador.nombre} · desviación en ${p.periodoDesviacion.etiqueta}\n'
                      '${p.listaParaVerificar ? 'Listo para verificar contra ${p.periodoSiguiente!.etiqueta}' : 'Esperando medición del periodo siguiente'}',
                    ),
                    isThreeLine: true,
                    trailing: p.listaParaVerificar
                        ? FilledButton(
                            onPressed: () => _abrirVerificacion(p),
                            child: const Text('Verificar'),
                          )
                        : null,
                  ),
                );
              },
            ),
    );
  }
}

class _DialogoVerificacion extends StatefulWidget {
  const _DialogoVerificacion({required this.pendiente, required this.propuesta});

  final _AccionPendiente pendiente;
  final String propuesta;

  @override
  State<_DialogoVerificacion> createState() => _DialogoVerificacionState();
}

class _DialogoVerificacionState extends State<_DialogoVerificacion> {
  late String _resultado = widget.propuesta;

  @override
  Widget build(BuildContext context) {
    final p = widget.pendiente;
    return AlertDialog(
      title: const Text('Verificar acción'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${p.indicador.nombre}: ${p.valorPeriodoDesviacion} (${p.periodoDesviacion.etiqueta}) → '
            '${p.valorObservado} (${p.periodoSiguiente!.etiqueta})',
          ),
          const SizedBox(height: 16),
          Text('Propuesta del sistema: ${_etiquetasResultado[widget.propuesta]}'),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _resultado,
            decoration: const InputDecoration(labelText: 'Resultado a confirmar'),
            items: [
              for (final r in _etiquetasResultado.entries) DropdownMenuItem(value: r.key, child: Text(r.value)),
            ],
            onChanged: (v) => setState(() => _resultado = v!),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar')),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_resultado),
          child: const Text('Confirmar'),
        ),
      ],
    );
  }
}
