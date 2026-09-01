import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../data/models/evaluacion.dart';
import '../../../data/models/indicador.dart';
import '../../../data/models/memoria_evaluacion.dart';
import '../../../data/models/periodo.dart';
import '../../../data/models/regla_patron.dart';
import '../../../data/repositories/evaluacion_repository.dart';
import '../../../data/repositories/indicador_repository.dart';
import '../../../data/repositories/medicion_repository.dart';
import '../../../data/repositories/memoria_evaluacion_repository.dart';
import '../../../data/repositories/periodo_repository.dart';
import '../../../data/repositories/regla_patron_repository.dart';
import '../../../domain/motor/m1_reglas_patron.dart';
import '../../../domain/motor/m2_clasificador.dart';
import '../../../domain/motor/orquestador_evaluacion.dart';

const _etiquetasEstado = {'normal': 'Normal', 'observacion': 'Observación', 'desviacion': 'Desviación'};
const _etiquetasClasificacion = {
  'ninguna': 'Ninguna',
  'ajuste_menor': 'Ajuste menor',
  'replaneacion_mayor': 'Replaneación mayor',
  'contingencia': 'Contingencia',
};
const _etiquetasResultadoRegla = {
  resultadoDisparada: 'Disparada',
  resultadoNoDisparada: 'No disparada',
  resultadoNoEvaluable: 'No evaluable',
};

Color _colorEstado(BuildContext context, String estado) {
  final colorScheme = Theme.of(context).colorScheme;
  return switch (estado) {
    'desviacion' => colorScheme.error,
    'observacion' => Colors.amber.shade700,
    _ => colorScheme.primary,
  };
}

/// Pantalla 8 (CLAUDE.md sección 9): corre M1 + M2 (vía
/// `evaluarPeriodoCompleto`) sobre todos los indicadores activos de la
/// organización para el periodo elegido, persiste `evaluacion` +
/// `memoria_evaluacion`, y muestra el veredicto de cada uno con sus
/// reglas disparadas y su explicación.
class EvaluacionPeriodoScreen extends StatefulWidget {
  const EvaluacionPeriodoScreen({super.key, required this.organizacionId});

  final int organizacionId;

  @override
  State<EvaluacionPeriodoScreen> createState() => _EvaluacionPeriodoScreenState();
}

class _EvaluacionPeriodoScreenState extends State<EvaluacionPeriodoScreen> {
  bool _cargando = true;
  bool _evaluando = false;
  List<Periodo> _periodos = [];
  Periodo? _seleccionado;
  List<Indicador> _indicadores = [];
  Map<int, ResultadoEvaluacionIndicador> _resultados = {};

  @override
  void initState() {
    super.initState();
    _cargarCatalogo();
  }

  Future<void> _cargarCatalogo() async {
    setState(() => _cargando = true);
    final periodoRepo = context.read<PeriodoRepository>();
    final indicadorRepo = context.read<IndicadorRepository>();
    final periodos = await periodoRepo.obtenerPorOrganizacion(widget.organizacionId);
    final indicadores = await indicadorRepo.obtenerPorOrganizacion(widget.organizacionId);
    if (!mounted) return;
    setState(() {
      _periodos = periodos;
      _indicadores = indicadores.where((i) => i.activo).toList();
      _seleccionado = periodos.isEmpty ? null : periodos.last;
      _cargando = false;
    });
    if (_seleccionado != null) await _cargarEvaluacionesExistentes();
  }

  Future<void> _cargarEvaluacionesExistentes() async {
    final periodo = _seleccionado;
    if (periodo == null) return;
    final evaluacionRepo = context.read<EvaluacionRepository>();
    final memoriaRepo = context.read<MemoriaEvaluacionRepository>();
    final reglaPatronRepo = context.read<ReglaPatronRepository>();
    final reglasPorId = {for (final r in await reglaPatronRepo.obtenerTodas()) r.id!: r};

    final resultados = <int, ResultadoEvaluacionIndicador>{};
    for (final indicador in _indicadores) {
      final evaluacion = await evaluacionRepo.obtenerPorIndicadorYPeriodo(indicador.id!, periodo.id!);
      if (evaluacion == null) continue;
      final memoria = await memoriaRepo.obtenerPorEvaluacion(evaluacion.id!);
      resultados[indicador.id!] = _aResultadoEvaluacionIndicador(indicador.id!, evaluacion, memoria, reglasPorId);
    }
    if (!mounted) return;
    setState(() => _resultados = resultados);
  }

  ResultadoEvaluacionIndicador _aResultadoEvaluacionIndicador(
    int indicadorId,
    Evaluacion evaluacion,
    List<MemoriaEvaluacion> memoria,
    Map<int, ReglaPatron> reglasPorId,
  ) {
    final reglas = memoria.map((m) {
      final regla = reglasPorId[m.reglaId];
      final entrada = (jsonDecode(m.valoresEntradaJson) as Map).cast<String, Object?>();
      return ResultadoRegla(
        codigo: regla?.codigo ?? '?',
        resultado: m.resultado,
        valoresEntrada: entrada,
        explicacion: m.explicacion,
      );
    }).toList();

    return ResultadoEvaluacionIndicador(
      indicadorId: indicadorId,
      reglas: reglas,
      // desviacionRelativa no se persiste como columna propia -- no hace
      // falta para mostrar el veredicto ya guardado, así que se reconstruye
      // en 0 en vez de volver a calcularla.
      clasificacion: ResultadoClasificacion(
        clasificacion: evaluacion.clasificacion,
        estado: evaluacion.estado,
        desviacionRelativa: 0,
        severidadCalculada: evaluacion.severidadCalculada,
      ),
    );
  }

  Future<void> _evaluar() async {
    final periodo = _seleccionado;
    if (periodo == null || _indicadores.isEmpty) return;
    setState(() => _evaluando = true);

    final medicionRepo = context.read<MedicionRepository>();
    final evaluacionRepo = context.read<EvaluacionRepository>();
    final memoriaRepo = context.read<MemoriaEvaluacionRepository>();
    final reglaPatronRepo = context.read<ReglaPatronRepository>();

    final periodosPorId = {for (final p in _periodos) p.id!: p};
    final reglasSistema = await reglaPatronRepo.obtenerTodas();
    final idReglaPorCodigo = {
      for (final r in reglasSistema.where((r) => r.indicadorId == null)) r.codigo: r.id!,
    };

    final indicadoresParaEvaluar = <IndicadorParaEvaluar>[];
    final omitidos = <String>[];
    for (final indicador in _indicadores) {
      final mediciones = await medicionRepo.obtenerPorIndicador(indicador.id!);
      final serieCompleta = [
        for (final m in mediciones)
          PuntoSerieMotor(orden: periodosPorId[m.periodoId]!.orden, valor: m.valor),
      ]..sort((a, b) => a.orden.compareTo(b.orden));

      final serie = serieCompleta.where((p) => p.orden <= periodo.orden).toList();
      if (serie.isEmpty || serie.last.orden != periodo.orden) {
        omitidos.add(indicador.nombre);
        continue;
      }

      final persistencia = await _persistenciaPeriodosPrevios(indicador.id!, periodo.orden);
      indicadoresParaEvaluar.add(
        IndicadorParaEvaluar(
          indicadorId: indicador.id!,
          proceso: indicador.proceso,
          config: ConfigIndicadorMotor(
            meta: indicador.meta,
            bandaInferior: indicador.bandaInferior,
            bandaSuperior: indicador.bandaSuperior,
            sentido: indicador.sentido,
          ),
          serie: serie,
          persistenciaPeriodosPrevios: persistencia,
        ),
      );
    }

    final resultados = evaluarPeriodoCompleto(indicadoresParaEvaluar);

    for (final entrada in resultados.entries) {
      final resultado = entrada.value;
      final existente = await evaluacionRepo.obtenerPorIndicadorYPeriodo(entrada.key, periodo.id!);
      final reglasDisparadasJson = jsonEncode(
        resultado.reglas.where((r) => r.disparada).map((r) => r.codigo).toList(),
      );

      final int evaluacionId;
      if (existente == null) {
        evaluacionId = await evaluacionRepo.crear(
          Evaluacion(
            indicadorId: entrada.key,
            periodoId: periodo.id!,
            estado: resultado.clasificacion.estado,
            clasificacion: resultado.clasificacion.clasificacion,
            reglasDisparadasJson: reglasDisparadasJson,
            severidadCalculada: resultado.clasificacion.severidadCalculada,
          ),
        );
      } else {
        evaluacionId = existente.id!;
        await evaluacionRepo.actualizar(
          existente.copyWith(
            estado: resultado.clasificacion.estado,
            clasificacion: resultado.clasificacion.clasificacion,
            reglasDisparadasJson: reglasDisparadasJson,
            severidadCalculada: resultado.clasificacion.severidadCalculada,
          ),
        );
        // Se reescribe la memoria completa -- una reevaluación no debe
        // acumular filas viejas junto a las nuevas.
        for (final vieja in await memoriaRepo.obtenerPorEvaluacion(evaluacionId)) {
          await memoriaRepo.eliminar(vieja.id!);
        }
      }

      for (final regla in resultado.reglas) {
        final reglaId = idReglaPorCodigo[regla.codigo];
        if (reglaId == null) continue; // regla de sistema no sembrada -- no debería pasar
        await memoriaRepo.crear(
          MemoriaEvaluacion(
            evaluacionId: evaluacionId,
            reglaId: reglaId,
            resultado: regla.resultado,
            valoresEntradaJson: jsonEncode(regla.valoresEntrada),
            explicacion: regla.explicacion,
          ),
        );
      }
    }

    if (!mounted) return;
    setState(() => _evaluando = false);
    await _cargarEvaluacionesExistentes();
    if (!mounted) return;

    final mensaje = omitidos.isEmpty
        ? '${resultados.length} indicador(es) evaluados.'
        : '${resultados.length} indicador(es) evaluados. Sin medición este periodo: ${omitidos.join(', ')}.';
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(showCloseIcon: true, content: Text(mensaje)));
  }

  /// Cuenta los periodos consecutivos *anteriores* a [ordenActual] en los
  /// que este indicador ya venía en `estado = desviacion`, a partir de las
  /// evaluaciones ya persistidas (CLAUDE.md sección 8, M2: `persistencia`).
  Future<int> _persistenciaPeriodosPrevios(int indicadorId, int ordenActual) async {
    final evaluacionRepo = context.read<EvaluacionRepository>();
    final evaluaciones = await evaluacionRepo.obtenerPorIndicador(indicadorId);
    final periodosPorId = {for (final p in _periodos) p.id!: p};

    final anteriores =
        evaluaciones.where((e) => (periodosPorId[e.periodoId]?.orden ?? 0) < ordenActual).toList()
          ..sort((a, b) => periodosPorId[b.periodoId]!.orden.compareTo(periodosPorId[a.periodoId]!.orden));

    var persistencia = 0;
    for (final evaluacion in anteriores) {
      if (evaluacion.estado != 'desviacion') break;
      persistencia++;
    }
    return persistencia;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Evaluación del periodo')),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _periodos.isEmpty || _indicadores.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  _periodos.isEmpty
                      ? 'Todavía no hay periodos. Crea uno primero desde Periodos.'
                      : 'Todavía no hay indicadores activos. Crea uno primero desde Indicadores.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<Periodo>(
                          initialValue: _seleccionado,
                          decoration: const InputDecoration(labelText: 'Periodo'),
                          items: [
                            for (final p in _periodos)
                              DropdownMenuItem(value: p, child: Text(p.etiqueta)),
                          ],
                          onChanged: (v) {
                            setState(() => _seleccionado = v);
                            _cargarEvaluacionesExistentes();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      FilledButton.icon(
                        onPressed: _evaluando ? null : _evaluar,
                        icon: _evaluando
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(LucideIcons.play),
                        label: const Text('Evaluar'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _resultados.isEmpty
                      ? Center(
                          child: Text(
                            'Sin evaluar. Pulsa "Evaluar" para correr el motor sobre este periodo.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          children: [
                            for (final indicador in _indicadores)
                              if (_resultados[indicador.id] case final r?)
                                _TarjetaVeredicto(indicador: indicador, resultado: r),
                          ],
                        ),
                ),
              ],
            ),
    );
  }
}

class _TarjetaVeredicto extends StatelessWidget {
  const _TarjetaVeredicto({required this.indicador, required this.resultado});

  final Indicador indicador;
  final ResultadoEvaluacionIndicador resultado;

  @override
  Widget build(BuildContext context) {
    final clasificacion = resultado.clasificacion;
    final color = _colorEstado(context, clasificacion.estado);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        leading: Icon(LucideIcons.circleAlert, color: color),
        title: Text(indicador.nombre),
        subtitle: Text(
          '${_etiquetasEstado[clasificacion.estado]} · ${_etiquetasClasificacion[clasificacion.clasificacion]}',
        ),
        children: [
          for (final regla in resultado.reglas)
            ListTile(
              dense: true,
              leading: Icon(
                regla.disparada ? LucideIcons.zap : LucideIcons.minus,
                size: 18,
                color: regla.disparada ? color : Theme.of(context).colorScheme.outline,
              ),
              title: Text('${regla.codigo} · ${_etiquetasResultadoRegla[regla.resultado]}'),
              subtitle: Text(regla.explicacion),
            ),
        ],
      ),
    );
  }
}
