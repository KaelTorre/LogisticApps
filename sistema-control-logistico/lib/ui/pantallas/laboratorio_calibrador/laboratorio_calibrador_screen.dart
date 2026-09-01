import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../data/models/indicador.dart';
import '../../../data/repositories/indicador_repository.dart';
import '../../../data/repositories/medicion_repository.dart';
import '../../../data/repositories/periodo_repository.dart';
import '../../../domain/motor/m1_reglas_patron.dart';
import '../../../domain/motor/m7_calibrador_banda.dart';

/// Pantalla 15 (CLAUDE.md sección 9): propuesta de banda óptima (M7). El
/// usuario marca qué periodos fueron, en su criterio, un problema real; el
/// calibrador barre anchos de banda y propone el más angosto que no deja
/// pasar ninguno de esos periodos.
class LaboratorioCalibradorScreen extends StatefulWidget {
  const LaboratorioCalibradorScreen({super.key, required this.organizacionId});

  final int organizacionId;

  @override
  State<LaboratorioCalibradorScreen> createState() => _LaboratorioCalibradorScreenState();
}

class _LaboratorioCalibradorScreenState extends State<LaboratorioCalibradorScreen> {
  bool _cargando = true;
  List<Indicador> _indicadores = [];
  Indicador? _seleccionado;
  List<PuntoSerieMotor> _serie = [];
  final Set<int> _periodosReales = {};
  ResultadoCalibracion? _resultado;

  @override
  void initState() {
    super.initState();
    _cargarIndicadores();
  }

  Future<void> _cargarIndicadores() async {
    setState(() => _cargando = true);
    final indicadores = await context.read<IndicadorRepository>().obtenerPorOrganizacion(
      widget.organizacionId,
    );
    if (!mounted) return;
    setState(() {
      _indicadores = indicadores;
      _seleccionado = indicadores.isEmpty ? null : indicadores.first;
      _cargando = false;
    });
    if (_seleccionado != null) await _cargarSerie();
  }

  Future<void> _cargarSerie() async {
    final indicador = _seleccionado;
    if (indicador == null) return;
    final periodoRepo = context.read<PeriodoRepository>();
    final medicionRepo = context.read<MedicionRepository>();

    final periodos = {
      for (final p in await periodoRepo.obtenerPorOrganizacion(widget.organizacionId)) p.id!: p.orden,
    };
    final mediciones = await medicionRepo.obtenerPorIndicador(indicador.id!);
    final serie = [
      for (final m in mediciones) PuntoSerieMotor(orden: periodos[m.periodoId]!, valor: m.valor),
    ]..sort((a, b) => a.orden.compareTo(b.orden));

    if (!mounted) return;
    setState(() {
      _serie = serie;
      _periodosReales.clear();
      _resultado = null;
    });
  }

  void _calibrar() {
    final indicador = _seleccionado;
    if (indicador == null || _serie.isEmpty) return;
    setState(() {
      _resultado = calibrarBanda(serie: _serie, meta: indicador.meta, periodosReales: _periodosReales);
    });
  }

  @override
  Widget build(BuildContext context) {
    final indicador = _seleccionado;
    final resultado = _resultado;
    return Scaffold(
      appBar: AppBar(title: const Text('Laboratorio — calibrador')),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _indicadores.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Crea un indicador con mediciones primero.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: DropdownButtonFormField<Indicador>(
                    initialValue: _seleccionado,
                    decoration: const InputDecoration(labelText: 'Indicador'),
                    items: [
                      for (final i in _indicadores) DropdownMenuItem(value: i, child: Text(i.nombre)),
                    ],
                    onChanged: (v) {
                      setState(() => _seleccionado = v);
                      _cargarSerie();
                    },
                  ),
                ),
                if (_serie.isEmpty)
                  Expanded(
                    child: Center(
                      child: Text(
                        'Este indicador todavía no tiene mediciones.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  )
                else ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Marca los periodos que sí fueron un problema real:',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        for (final punto in _serie)
                          CheckboxListTile(
                            value: _periodosReales.contains(punto.orden),
                            title: Text('Periodo ${punto.orden}'),
                            subtitle: Text('${punto.valor.toStringAsFixed(indicador!.decimales)} ${indicador.unidad}'),
                            onChanged: (marcado) => setState(() {
                              if (marcado == true) {
                                _periodosReales.add(punto.orden);
                              } else {
                                _periodosReales.remove(punto.orden);
                              }
                            }),
                          ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: _calibrar,
                          icon: const Icon(LucideIcons.slidersHorizontal),
                          label: const Text('Calibrar banda'),
                        ),
                        if (resultado != null) ...[
                          const SizedBox(height: 16),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Banda actual', style: Theme.of(context).textTheme.titleSmall),
                                  Text(
                                    '${indicador!.bandaInferior.toStringAsFixed(2)} – '
                                    '${indicador.bandaSuperior.toStringAsFixed(2)}',
                                  ),
                                  const Divider(height: 24),
                                  Text('Banda propuesta', style: Theme.of(context).textTheme.titleSmall),
                                  Text(
                                    '${resultado.bandaInferior.toStringAsFixed(2)} – '
                                    '${resultado.bandaSuperior.toStringAsFixed(2)} '
                                    '(±${(resultado.porcentajeAnchoBanda * 100).toStringAsFixed(1)}%)',
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Detecta ${resultado.detectadosReales} de ${resultado.totalReales} '
                                    'periodo(s) marcados como reales, con ${resultado.falsasAlarmas} '
                                    'falsa(s) alarma(s).',
                                  ),
                                  if (resultado.pierdeAlgunaDeteccionReal)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        'Ningún ancho del barrido detecta todos los periodos marcados -- '
                                        'esta es la propuesta más ancha disponible.',
                                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}
