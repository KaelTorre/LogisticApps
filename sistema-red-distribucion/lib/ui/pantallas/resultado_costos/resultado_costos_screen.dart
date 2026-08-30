import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/estado/proyecto_activo.dart';
import '../../../data/models/celda_matriz.dart';
import '../../../data/models/escenario.dart';
import '../../../data/repositories/escenario_asignacion_repository.dart';
import '../../../data/repositories/escenario_costo_repository.dart';
import '../../../data/repositories/escenario_repository.dart';
import '../../../data/repositories/celda_matriz_repository.dart';
import '../../../data/repositories/parametros_costo_repository.dart';
import '../../../data/repositories/planta_repository.dart';
import '../../../data/repositories/sitio_candidato_repository.dart';
import '../../../data/repositories/zona_demanda_repository.dart';
import '../../../domain/motor/m4_costo_total.dart';
import '../../../domain/motor/m5_asignacion.dart';
import '../../../domain/motor/m9_comparador.dart';
import '../../estilos_rubro.dart';
import '../../widgets/selector_escenario.dart';

/// Pantalla 12 (CLAUDE.md sección 8): desglose de costo por rubro de un
/// escenario, y comparación contra la red actual (sitios candidatos
/// marcados `esRedActual`) — si no hay ninguno marcado, se avisa en vez de
/// forzar una comparación sin sentido.
class ResultadoCostosScreen extends StatefulWidget {
  const ResultadoCostosScreen({super.key});

  @override
  State<ResultadoCostosScreen> createState() => _ResultadoCostosScreenState();
}

class _ResultadoCostosScreenState extends State<ResultadoCostosScreen> {
  bool _cargando = true;
  List<Escenario> _escenarios = [];
  Escenario? _seleccionado;
  Map<String, int> _porRubro = {};
  ResultadoComparacion? _comparacion;
  String? _avisoComparacion;

  int get _proyectoId => context.read<ProyectoActivo>().proyecto!.id!;

  @override
  void initState() {
    super.initState();
    _cargarEscenarios();
  }

  Future<void> _cargarEscenarios() async {
    setState(() => _cargando = true);
    final escenarios = await context.read<EscenarioRepository>().obtenerPorProyecto(_proyectoId);
    if (!mounted) return;
    setState(() {
      _escenarios = escenarios;
      _cargando = false;
    });
    if (escenarios.isNotEmpty) await _seleccionar(escenarios.last);
  }

  Future<void> _seleccionar(Escenario escenario) async {
    setState(() {
      _seleccionado = escenario;
      _porRubro = {};
      _comparacion = null;
      _avisoComparacion = null;
    });

    final proyectoId = _proyectoId;
    final costoRepo = context.read<EscenarioCostoRepository>();
    final asignacionRepo = context.read<EscenarioAsignacionRepository>();
    final candidatoRepo = context.read<SitioCandidatoRepository>();
    final plantaRepo = context.read<PlantaRepository>();
    final zonaRepo = context.read<ZonaDemandaRepository>();
    final celdaRepo = context.read<CeldaMatrizRepository>();
    final parametrosRepo = context.read<ParametrosCostoRepository>();

    final costos = await costoRepo.obtenerPorEscenario(escenario.id!);
    final asignaciones = await asignacionRepo.obtenerPorEscenario(escenario.id!);
    final candidatos = await candidatoRepo.obtenerPorProyecto(proyectoId);
    final params = await parametrosRepo.obtenerPorProyecto(proyectoId);

    if (!mounted) return;
    final porRubro = {for (final c in costos) c.rubro: c.montoCent};
    setState(() => _porRubro = porRubro);

    final redActualIds = candidatos.where((c) => c.esRedActual).map((c) => c.id!).toSet();
    if (redActualIds.isEmpty) {
      setState(() => _avisoComparacion = 'Ningún sitio candidato está marcado como "red actual" — '
          'no hay con qué comparar. Marcalo desde Sitios candidatos.');
      return;
    }
    if (params == null) return;

    final plantas = await plantaRepo.obtenerPorProyecto(proyectoId);
    final zonas = await zonaRepo.obtenerPorProyecto(proyectoId);
    final celdas = await celdaRepo.obtenerPorProyecto(proyectoId);
    final candidatosPorId = {for (final c in candidatos) c.id!: c};
    final distanciaZonaCandidato = <(int, int), CeldaMatriz>{
      for (final c in celdas)
        if (c.tipoOrigen == 'candidato' && c.tipoDestino == 'zona') (c.destinoId, c.origenId): c,
    };
    final distanciaPlantaCandidato = <(int, int), CeldaMatriz>{
      for (final c in celdas)
        if (c.tipoOrigen == 'planta' && c.tipoDestino == 'candidato') (c.origenId, c.destinoId): c,
    };

    final faltaCobertura = zonas.any(
      (z) => redActualIds.any((id) => !distanciaZonaCandidato.containsKey((z.id!, id))),
    );
    if (faltaCobertura) {
      if (!mounted) return;
      setState(() => _avisoComparacion = 'Falta la matriz de distancias para algún sitio de la red '
          'actual — construila en Matriz de distancias.');
      return;
    }

    final asignacionRedActual = asignarZonas(
      abiertos: redActualIds.toList(),
      zonas: zonas,
      candidatosPorId: candidatosPorId,
      distanciaZonaCandidato: distanciaZonaCandidato,
      params: params,
      conRestriccionCapacidad: false,
    );
    final costoRedActual = calcularCostoTotal(
      abiertos: redActualIds.toList(),
      candidatosPorId: candidatosPorId,
      plantas: plantas,
      zonas: zonas,
      asignacionZonaCandidato: asignacionRedActual.asignacion,
      distanciaZonaCandidato: distanciaZonaCandidato,
      distanciaPlantaCandidato: distanciaPlantaCandidato,
      params: params,
    );

    final baseDatos = EscenarioDatos(
      costoTotalCent: costoRedActual.costoTotalCent,
      porRubro: costoRedActual.porRubro,
      almacenesAbiertos: redActualIds,
      asignacionZonaCandidato: asignacionRedActual.asignacion,
      distanciaZonaAsignada: {
        for (final entrada in asignacionRedActual.asignacion.entries)
          entrada.key: (
            distanciaZonaCandidato[(entrada.key, entrada.value)]!.distanciaMetros,
            distanciaZonaCandidato[(entrada.key, entrada.value)]!.duracionSegundos,
          ),
      },
    );
    final comparadoDatos = EscenarioDatos(
      costoTotalCent: escenario.costoTotalCent,
      porRubro: porRubro,
      almacenesAbiertos: asignaciones.map((a) => a.sitioCandidatoId).toSet(),
      asignacionZonaCandidato: {for (final a in asignaciones) a.zonaId: a.sitioCandidatoId},
      distanciaZonaAsignada: {for (final a in asignaciones) a.zonaId: (a.distanciaMetros, a.duracionSegundos)},
    );

    if (!mounted) return;
    setState(() {
      _comparacion = compararEscenarios(base: baseDatos, comparado: comparadoDatos, params: params);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Resultado — costos')),
      body: SafeArea(
        child: _escenarios.isEmpty
            ? const _SinEscenarios()
            : Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SelectorEscenario(
                          escenarios: _escenarios,
                          seleccionado: _seleccionado,
                          onCambiar: (e) => e == null ? null : _seleccionar(e),
                        ),
                        const SizedBox(height: 16),
                        if (_seleccionado != null) ...[
                          Text(
                            'Costo total: ${(_seleccionado!.costoTotalCent / 100).toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(height: 240, child: _GraficoRubros(porRubro: _porRubro)),
                          const SizedBox(height: 16),
                          for (final rubro in etiquetasRubro.keys)
                            if (_porRubro.containsKey(rubro))
                              ListTile(
                                dense: true,
                                leading: CircleAvatar(backgroundColor: coloresRubro[rubro], radius: 8),
                                title: Text(etiquetasRubro[rubro]!),
                                trailing: Text(((_porRubro[rubro] ?? 0) / 100).toStringAsFixed(2)),
                              ),
                          const Divider(height: 32),
                          Text('Comparación contra la red actual', style: Theme.of(context).textTheme.titleSmall),
                          const SizedBox(height: 8),
                          if (_avisoComparacion != null)
                            Text(_avisoComparacion!, style: Theme.of(context).textTheme.bodySmall)
                          else if (_comparacion != null)
                            _PanelComparacion(comparacion: _comparacion!),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class _GraficoRubros extends StatelessWidget {
  const _GraficoRubros({required this.porRubro});

  final Map<String, int> porRubro;

  @override
  Widget build(BuildContext context) {
    final rubros = etiquetasRubro.keys.where((r) => porRubro.containsKey(r)).toList();
    final maximo = rubros.fold<int>(0, (m, r) => porRubro[r]! > m ? porRubro[r]! : m);

    return BarChart(
      BarChartData(
        maxY: maximo == 0 ? 1 : maximo * 1.15,
        barGroups: [
          for (var i = 0; i < rubros.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: (porRubro[rubros[i]] ?? 0).toDouble(),
                  color: coloresRubro[rubros[i]],
                  width: 22,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ],
            ),
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (valor, meta) {
                final indice = valor.toInt();
                if (indice < 0 || indice >= rubros.length) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    etiquetasRubro[rubros[indice]]!.split(' ').first,
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}

class _PanelComparacion extends StatelessWidget {
  const _PanelComparacion({required this.comparacion});

  final ResultadoComparacion comparacion;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final ahorra = comparacion.ahorroAnualCent >= 0;

    return Card(
      color: ahorra ? colorScheme.primaryContainer : colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${ahorra ? "Ahorro" : "Sobrecosto"} anual: '
              '${(comparacion.ahorroAnualCent.abs() / 100).toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text('Almacenes que abren: ${comparacion.almacenesQueAbren.length}'),
            Text('Almacenes que cierran: ${comparacion.almacenesQueCierran.length}'),
            Text('Zonas que cambian de asignación: ${comparacion.zonasQueCambianAsignacion.length}'),
            Text('Zonas fuera del estándar — red actual: ${comparacion.zonasNoCubiertasBase}'),
            Text('Zonas fuera del estándar — este escenario: ${comparacion.zonasNoCubiertasComparado}'),
          ],
        ),
      ),
    );
  }
}

class _SinEscenarios extends StatelessWidget {
  const _SinEscenarios();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Todavía no hay ningún escenario calculado — corré una optimización primero.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
