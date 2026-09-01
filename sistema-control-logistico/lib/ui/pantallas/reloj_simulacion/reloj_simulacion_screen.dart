import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../data/models/indicador.dart';
import '../../../data/models/periodo.dart' as modelo;
import '../../../data/repositories/indicador_repository.dart';
import '../../../data/repositories/medicion_repository.dart';
import '../../../data/repositories/periodo_repository.dart';
import '../../../domain/motor/m1_reglas_patron.dart';
import '../../../domain/motor/reloj_simulacion.dart';
import '../../widgets/grafica_serie_banda.dart';

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
    _ => Colors.green,
  };
}

IconData _iconoEstado(String estado) {
  return switch (estado) {
    'desviacion' => LucideIcons.circleAlert,
    'observacion' => LucideIcons.eye,
    _ => LucideIcons.check,
  };
}

/// Pantalla 13 (CLAUDE.md sección 9): reloj de periodos con avanzar,
/// retroceder y reiniciar, recalculando el estado en cada paso -- "el
/// momento de la sustentación" (sección 11): el semáforo cambia de color,
/// la tarjeta de clasificación aparece, y se explica qué regla disparó y
/// por qué. La serie se carga **una sola vez** al elegir el indicador; de
/// ahí en adelante el reloj solo trabaja en memoria, nunca vuelve a
/// consultar la base de datos (sección 11, "sobre el rendimiento") y
/// nunca escribe en ella (Fase 7, Test R).
class RelojSimulacionScreen extends StatefulWidget {
  const RelojSimulacionScreen({super.key, required this.organizacionId});

  final int organizacionId;

  @override
  State<RelojSimulacionScreen> createState() => _RelojSimulacionScreenState();
}

class _RelojSimulacionScreenState extends State<RelojSimulacionScreen> {
  bool _cargando = true;
  List<Indicador> _indicadores = [];
  Indicador? _seleccionado;
  RelojSimulacion? _reloj;

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

    final config = ConfigIndicadorMotor(
      meta: indicador.meta,
      bandaInferior: indicador.bandaInferior,
      bandaSuperior: indicador.bandaSuperior,
      sentido: indicador.sentido,
    );

    if (!mounted) return;
    setState(() {
      _reloj = serie.isEmpty ? null : RelojSimulacion(serie: serie, indicador: config);
    });
  }

  @override
  Widget build(BuildContext context) {
    final reloj = _reloj;
    final indicador = _seleccionado;
    return Scaffold(
      appBar: AppBar(title: const Text('Laboratorio — simulación')),
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
                Expanded(
                  child: reloj == null || indicador == null
                      ? Center(
                          child: Text(
                            'Este indicador todavía no tiene mediciones.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        )
                      : _CuerpoReloj(reloj: reloj, indicador: indicador, onCambio: () => setState(() {})),
                ),
              ],
            ),
    );
  }
}

class _CuerpoReloj extends StatelessWidget {
  const _CuerpoReloj({required this.reloj, required this.indicador, required this.onCambio});

  final RelojSimulacion reloj;
  final Indicador indicador;
  final VoidCallback onCambio;

  @override
  Widget build(BuildContext context) {
    final estado = reloj.estadoActual;
    final color = _colorEstado(context, estado.clasificacion.estado);
    final claveAnimacion = ValueKey(reloj.indiceActual);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      children: [
        Center(
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOut,
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.15),
                  border: Border.all(color: color, width: 3),
                ),
                child: Icon(_iconoEstado(estado.clasificacion.estado), color: color, size: 48),
              ),
              const SizedBox(height: 12),
              Text('Periodo ${estado.periodo}', style: Theme.of(context).textTheme.titleLarge),
              Text(
                _etiquetasEstado[estado.clasificacion.estado]!,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        if (estado.clasificacion.clasificacion != 'ninguna')
          Card(
                color: color.withValues(alpha: 0.12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(LucideIcons.triangleAlert, color: color),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _etiquetasClasificacion[estado.clasificacion.clasificacion]!,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: color),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .animate(key: claveAnimacion)
              .fadeIn(duration: 300.ms)
              .slideY(begin: 0.15, end: 0, curve: Curves.easeOut)
        else
          const SizedBox.shrink(),
        const SizedBox(height: 16),
        Text('Reglas disparadas', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        if (estado.reglas.where((r) => r.disparada).isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text('Ninguna regla dispara en este periodo.', style: Theme.of(context).textTheme.bodySmall),
          )
        else
          for (final regla in estado.reglas.where((r) => r.disparada))
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                dense: true,
                leading: Icon(LucideIcons.zap, color: color, size: 18),
                title: Text('${regla.codigo} · ${_etiquetasResultadoRegla[regla.resultado]}'),
                subtitle: Text(regla.explicacion),
              ),
            ).animate(key: ValueKey('${regla.codigo}-${reloj.indiceActual}')).fadeIn(duration: 300.ms),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: GraficaSerieBanda(
            indicador: indicador,
            periodos: [
              for (var t = 1; t <= reloj.indiceActual; t++)
                modelo.Periodo(
                  id: t,
                  organizacionId: indicador.organizacionId,
                  orden: reloj.serie[t - 1].orden,
                  etiqueta: 't=${reloj.serie[t - 1].orden}',
                  fechaInicio: '',
                  fechaFin: '',
                  granularidad: indicador.granularidad,
                ),
            ],
            valoresPorPeriodoId: {
              for (var t = 1; t <= reloj.indiceActual; t++) t: reloj.serie[t - 1].valor,
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton.filledTonal(
              onPressed: () {
                reloj.reiniciar();
                onCambio();
              },
              icon: const Icon(LucideIcons.rotateCcw),
              tooltip: 'Reiniciar',
            ),
            const SizedBox(width: 16),
            IconButton.filledTonal(
              onPressed: reloj.puedeRetroceder
                  ? () {
                      reloj.retroceder();
                      onCambio();
                    }
                  : null,
              icon: const Icon(LucideIcons.chevronLeft),
              tooltip: 'Retroceder',
            ),
            const SizedBox(width: 16),
            Text(
              '${reloj.indiceActual} / ${reloj.totalPeriodos}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(width: 16),
            FilledButton.icon(
              onPressed: reloj.puedeAvanzar
                  ? () {
                      reloj.avanzar();
                      onCambio();
                    }
                  : null,
              icon: const Icon(LucideIcons.chevronRight),
              label: const Text('Avanzar'),
            ),
          ],
        ),
      ],
    );
  }
}
