import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/escenario_sintetico.dart';
import '../../../data/models/indicador.dart';
import '../../../data/models/periodo.dart';
import '../../../data/repositories/escenario_sintetico_repository.dart';
import '../../../data/repositories/indicador_repository.dart';
import '../../../domain/motor/m5_generador_series.dart';
import '../../widgets/grafica_serie_banda.dart';

const _etiquetasPatron = {
  'estable': 'Estable',
  'punto_aislado': 'Punto aislado',
  'tendencia': 'Tendencia',
  'corrimiento': 'Corrimiento',
  'estacional': 'Estacional',
  'deterioro_brusco': 'Deterioro brusco',
};

/// Pantalla 12 (CLAUDE.md sección 9): elección de patrón, parámetros,
/// semilla y previsualización -- M5 puro, sin tocar mediciones reales. Se
/// puede guardar como fila de `escenario_sintetico` para reproducirlo
/// después (misma semilla, misma serie, [REGLA] sección 8).
class LaboratorioGeneradorScreen extends StatefulWidget {
  const LaboratorioGeneradorScreen({super.key, required this.organizacionId});

  final int organizacionId;

  @override
  State<LaboratorioGeneradorScreen> createState() => _LaboratorioGeneradorScreenState();
}

class _LaboratorioGeneradorScreenState extends State<LaboratorioGeneradorScreen> {
  bool _cargando = true;
  List<Indicador> _indicadores = [];
  Indicador? _indicadorBase;

  String _patron = patronesDisponibles.first;
  final _semillaCtrl = TextEditingController(text: '42');
  final _numeroPeriodosCtrl = TextEditingController(text: '24');
  final _sigmaCtrl = TextEditingController(text: '0');
  final _tEventoCtrl = TextEditingController(text: '10');
  final _magnitudCtrl = TextEditingController(text: '10');
  final _pendienteCtrl = TextEditingController(text: '1');
  final _tInicioCtrl = TextEditingController(text: '0');
  final _saltoCtrl = TextEditingController(text: '10');
  final _amplitudCtrl = TextEditingController(text: '5');
  final _cicloCtrl = TextEditingController(text: '12');

  List<double>? _serieGenerada;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  @override
  void dispose() {
    _semillaCtrl.dispose();
    _numeroPeriodosCtrl.dispose();
    _sigmaCtrl.dispose();
    _tEventoCtrl.dispose();
    _magnitudCtrl.dispose();
    _pendienteCtrl.dispose();
    _tInicioCtrl.dispose();
    _saltoCtrl.dispose();
    _amplitudCtrl.dispose();
    _cicloCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargar() async {
    setState(() => _cargando = true);
    final indicadores = await context.read<IndicadorRepository>().obtenerPorOrganizacion(
      widget.organizacionId,
    );
    if (!mounted) return;
    setState(() {
      _indicadores = indicadores;
      _indicadorBase = indicadores.isEmpty ? null : indicadores.first;
      _cargando = false;
    });
  }

  double? _num(TextEditingController c) => double.tryParse(c.text.trim());
  int? _entero(TextEditingController c) => int.tryParse(c.text.trim());

  ParametrosSerieSintetica _parametrosActuales() {
    return ParametrosSerieSintetica(
      sigma: _num(_sigmaCtrl) ?? 0,
      tEvento: _entero(_tEventoCtrl),
      magnitud: _num(_magnitudCtrl),
      pendiente: _num(_pendienteCtrl),
      tInicio: _entero(_tInicioCtrl),
      salto: _num(_saltoCtrl),
      amplitud: _num(_amplitudCtrl),
      ciclo: _entero(_cicloCtrl),
    );
  }

  void _generar() {
    final indicador = _indicadorBase;
    final semilla = _entero(_semillaCtrl);
    final numeroPeriodos = _entero(_numeroPeriodosCtrl);
    if (indicador == null || semilla == null || numeroPeriodos == null || numeroPeriodos < 1) return;

    setState(() {
      _serieGenerada = generarSerieSintetica(
        patron: _patron,
        params: _parametrosActuales(),
        semilla: semilla,
        numeroPeriodos: numeroPeriodos,
        meta: indicador.meta,
      );
    });
  }

  Future<void> _guardarComoEscenario() async {
    final indicador = _indicadorBase;
    final serie = _serieGenerada;
    final semilla = _entero(_semillaCtrl);
    final numeroPeriodos = _entero(_numeroPeriodosCtrl);
    if (indicador == null || serie == null || semilla == null || numeroPeriodos == null) return;

    final params = _parametrosActuales();
    final parametrosJson = jsonEncode({
      'sigma': params.sigma,
      if (params.tEvento != null) 'tEvento': params.tEvento,
      if (params.magnitud != null) 'magnitud': params.magnitud,
      if (params.pendiente != null) 'pendiente': params.pendiente,
      if (params.tInicio != null) 'tInicio': params.tInicio,
      if (params.salto != null) 'salto': params.salto,
      if (params.amplitud != null) 'amplitud': params.amplitud,
      if (params.ciclo != null) 'ciclo': params.ciclo,
    });

    await context.read<EscenarioSinteticoRepository>().crear(
      EscenarioSintetico(
        nombre: '${_etiquetasPatron[_patron]} — ${indicador.nombre} (semilla $semilla)',
        indicadorBaseId: indicador.id!,
        patron: _patron,
        parametrosJson: parametrosJson,
        semilla: semilla,
        numeroPeriodos: numeroPeriodos,
      ),
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(const SnackBar(showCloseIcon: true, content: Text('Escenario sintético guardado.')));
  }

  Widget _campo(String etiqueta, TextEditingController controlador, {String? ayuda}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controlador,
        decoration: InputDecoration(labelText: etiqueta, helperText: ayuda, helperMaxLines: 2),
        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
      ),
    );
  }

  List<Widget> _camposDelPatron() {
    switch (_patron) {
      case 'punto_aislado':
        return [_campo('Periodo del evento', _tEventoCtrl), _campo('Magnitud', _magnitudCtrl)];
      case 'tendencia':
        return [_campo('Pendiente por periodo', _pendienteCtrl), _campo('Periodo de inicio', _tInicioCtrl)];
      case 'corrimiento':
        return [_campo('Periodo del evento', _tEventoCtrl), _campo('Tamaño del salto', _saltoCtrl)];
      case 'estacional':
        return [_campo('Amplitud', _amplitudCtrl), _campo('Longitud del ciclo', _cicloCtrl)];
      case 'deterioro_brusco':
        return [_campo('Periodo del evento', _tEventoCtrl), _campo('Salto por periodo', _saltoCtrl)];
      default: // estable
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final indicador = _indicadorBase;
    return Scaffold(
      appBar: AppBar(title: const Text('Laboratorio — generador')),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _indicadores.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Crea un indicador primero -- el generador usa su meta como base de la serie.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                DropdownButtonFormField<Indicador>(
                  initialValue: indicador,
                  decoration: const InputDecoration(labelText: 'Indicador base (meta)'),
                  items: [
                    for (final i in _indicadores) DropdownMenuItem(value: i, child: Text(i.nombre)),
                  ],
                  onChanged: (v) => setState(() => _indicadorBase = v),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _patron,
                  decoration: const InputDecoration(labelText: 'Patrón'),
                  items: [
                    for (final p in patronesDisponibles)
                      DropdownMenuItem(value: p, child: Text(_etiquetasPatron[p]!)),
                  ],
                  onChanged: (v) => setState(() => _patron = v!),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _campo(
                        'Semilla',
                        _semillaCtrl,
                        ayuda: 'Un número cualquiera; el mismo número siempre genera la misma serie',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: _campo('Número de periodos', _numeroPeriodosCtrl)),
                  ],
                ),
                _campo(
                  'Ruido (sigma)',
                  _sigmaCtrl,
                  ayuda: 'Qué tanto varían los valores al azar; 0 deja la serie sin variación aleatoria',
                ),
                ..._camposDelPatron(),
                FilledButton.icon(
                  onPressed: _generar,
                  icon: const Icon(Icons.auto_graph),
                  label: const Text('Generar'),
                ),
                if (_serieGenerada != null && indicador != null) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 260,
                    child: GraficaSerieBanda(
                      indicador: indicador,
                      periodos: [
                        for (var t = 1; t <= _serieGenerada!.length; t++)
                          Periodo(
                            id: t,
                            organizacionId: widget.organizacionId,
                            orden: t,
                            etiqueta: 't=$t',
                            fechaInicio: '',
                            fechaFin: '',
                            granularidad: indicador.granularidad,
                            esSimulado: true,
                          ),
                      ],
                      valoresPorPeriodoId: {
                        for (var t = 1; t <= _serieGenerada!.length; t++) t: _serieGenerada![t - 1],
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _guardarComoEscenario,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Guardar como escenario sintético'),
                  ),
                ],
              ],
            ),
    );
  }
}
