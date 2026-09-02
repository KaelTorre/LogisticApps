import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../data/models/indicador.dart';
import '../../../data/repositories/indicador_repository.dart';
import '../../../data/repositories/medicion_repository.dart';
import '../../../data/repositories/periodo_repository.dart';
import '../../../domain/motor/m1_reglas_patron.dart';
import '../../../domain/motor/m6_contraste_retrospectivo.dart';

/// Pantalla 14 (CLAUDE.md sección 9): tabla comparativa entre umbral
/// simple y reconocimiento de patrones (M6), sobre la serie real de un
/// indicador -- el argumento central de la sustentación (documento de
/// contexto, sección 4): "detecta antes y molesta menos".
class LaboratorioContrasteScreen extends StatefulWidget {
  const LaboratorioContrasteScreen({super.key, required this.organizacionId});

  final int organizacionId;

  @override
  State<LaboratorioContrasteScreen> createState() => _LaboratorioContrasteScreenState();
}

class _LaboratorioContrasteScreenState extends State<LaboratorioContrasteScreen> {
  bool _cargando = true;
  List<Indicador> _indicadores = [];
  Indicador? _seleccionado;
  ResultadoContrasteM6? _resultado;
  int _numeroPeriodos = 0;

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
    if (_seleccionado != null) await _contrastar();
  }

  Future<void> _contrastar() async {
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

    if (serie.isEmpty) {
      if (!mounted) return;
      setState(() {
        _resultado = null;
        _numeroPeriodos = 0;
      });
      return;
    }

    final config = ConfigIndicadorMotor(
      meta: indicador.meta,
      bandaInferior: indicador.bandaInferior,
      bandaSuperior: indicador.bandaSuperior,
      sentido: indicador.sentido,
    );

    if (!mounted) return;
    setState(() {
      _resultado = contrastarMetodos(serie: serie, indicador: config);
      _numeroPeriodos = serie.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final resultado = _resultado;
    return Scaffold(
      appBar: AppBar(title: const Text('Laboratorio — contraste')),
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
                      _contrastar();
                    },
                  ),
                ),
                Expanded(
                  child: resultado == null
                      ? Center(
                          child: Text(
                            'Este indicador todavía no tiene mediciones.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          children: [
                            Text(
                              'Serie de $_numeroPeriodos ${_numeroPeriodos == 1 ? 'periodo' : 'periodos'}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 12),
                            _TarjetaMetodo(titulo: 'Umbral simple', resultado: resultado.umbralSimple),
                            const SizedBox(height: 12),
                            _TarjetaMetodo(
                              titulo: 'Reconocimiento de patrones',
                              resultado: resultado.reconocimientoPatrones,
                            ),
                            const SizedBox(height: 16),
                            Card(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    const Icon(LucideIcons.zap),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        resultado.ventajaDeteccionPeriodos == null
                                            ? 'Sin suficientes detecciones reales para comparar todavía.'
                                            : 'Reconocimiento de patrones detectó '
                                                  '${resultado.ventajaDeteccionPeriodos} '
                                                  '${resultado.ventajaDeteccionPeriodos == 1 ? 'periodo' : 'periodos'} '
                                                  'antes que el umbral simple.',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                ),
              ],
            ),
    );
  }
}

class _TarjetaMetodo extends StatelessWidget {
  const _TarjetaMetodo({required this.titulo, required this.resultado});

  final String titulo;
  final ResultadoMetodoM6 resultado;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            if (resultado.detecciones.isEmpty)
              const Text('Sin detecciones.')
            else
              for (final d in resultado.detecciones)
                Row(
                  children: [
                    Icon(
                      d.esFalsaAlarma ? LucideIcons.circleAlert : LucideIcons.circleCheck,
                      size: 16,
                      color: d.esFalsaAlarma ? Colors.amber.shade700 : Colors.green,
                    ),
                    const SizedBox(width: 8),
                    Text('Periodo ${d.periodo} — ${d.esFalsaAlarma ? 'falsa alarma' : 'detección real'}'),
                  ],
                ),
            const SizedBox(height: 8),
            Text(
              '${resultado.numeroFalsasAlarmas} '
              '${resultado.numeroFalsasAlarmas == 1 ? 'falsa alarma' : 'falsas alarmas'} de '
              '${resultado.detecciones.length} '
              '${resultado.detecciones.length == 1 ? 'detección' : 'detecciones'}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
