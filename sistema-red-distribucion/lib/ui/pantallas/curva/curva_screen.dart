import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/estado/proyecto_activo.dart';
import '../../../data/models/escenario.dart';
import '../../../data/models/punto_curva.dart';
import '../../../data/repositories/escenario_repository.dart';
import '../../../data/repositories/punto_curva_repository.dart';
import '../../estilos_rubro.dart';
import '../../widgets/selector_escenario.dart';

/// Pantalla 13 (CLAUDE.md sección 8): costo total contra número de
/// almacenes, barras apiladas por rubro, mínimo marcado. Solo tiene datos
/// para escenarios generados con el método "Barrido" (M8, Fase 7) — para
/// los demás, `punto_curva` queda vacío a propósito (esos métodos evalúan
/// una sola configuración, no un barrido completo).
class CurvaScreen extends StatefulWidget {
  const CurvaScreen({super.key});

  @override
  State<CurvaScreen> createState() => _CurvaScreenState();
}

class _CurvaScreenState extends State<CurvaScreen> {
  bool _cargando = true;
  List<Escenario> _escenarios = [];
  Escenario? _seleccionado;
  List<PuntoCurva> _puntos = [];

  int get _proyectoId => context.read<ProyectoActivo>().proyecto!.id!;

  @override
  void initState() {
    super.initState();
    _cargarEscenarios();
  }

  Future<void> _cargarEscenarios() async {
    setState(() => _cargando = true);
    final todos = await context.read<EscenarioRepository>().obtenerPorProyecto(_proyectoId);
    final deBarrido = todos.where((e) => e.metodo == 'barrido').toList();
    if (!mounted) return;
    setState(() {
      _escenarios = deBarrido;
      _cargando = false;
    });
    if (deBarrido.isNotEmpty) await _seleccionar(deBarrido.last);
  }

  Future<void> _seleccionar(Escenario escenario) async {
    final puntos = await context.read<PuntoCurvaRepository>().obtenerPorEscenario(escenario.id!);
    puntos.sort((a, b) => a.numeroAlmacenes.compareTo(b.numeroAlmacenes));
    if (!mounted) return;
    setState(() {
      _seleccionado = escenario;
      _puntos = puntos;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Curva de costo')),
      body: SafeArea(
        child: _escenarios.isEmpty
            ? const _SinBarridos()
            : Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SelectorEscenario(
                          escenarios: _escenarios,
                          seleccionado: _seleccionado,
                          onCambiar: (e) => e == null ? null : _seleccionar(e),
                          etiqueta: 'Escenario (barrido)',
                        ),
                        const SizedBox(height: 16),
                        if (_puntos.isNotEmpty) ...[
                          Text('Costo total contra número de almacenes', style: Theme.of(context).textTheme.titleSmall),
                          const SizedBox(height: 8),
                          SizedBox(height: 260, child: _LineaCosto(puntos: _puntos)),
                          const SizedBox(height: 24),
                          Text('Desglose por rubro en cada punto', style: Theme.of(context).textTheme.titleSmall),
                          const SizedBox(height: 8),
                          SizedBox(height: 260, child: _BarrasApiladas(puntos: _puntos)),
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

class _LineaCosto extends StatelessWidget {
  const _LineaCosto({required this.puntos});

  final List<PuntoCurva> puntos;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    var indiceMinimo = 0;
    for (var i = 1; i < puntos.length; i++) {
      if (puntos[i].costoTotalCent < puntos[indiceMinimo].costoTotalCent) indiceMinimo = i;
    }

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (var i = 0; i < puntos.length; i++)
                FlSpot(puntos[i].numeroAlmacenes.toDouble(), puntos[i].costoTotalCent / 100),
            ],
            color: colorScheme.primary,
            barWidth: 3,
            dotData: FlDotData(
              getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
                radius: index == indiceMinimo ? 7 : 3,
                color: index == indiceMinimo ? colorScheme.error : colorScheme.primary,
                strokeWidth: 0,
              ),
            ),
          ),
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 28, interval: 1),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 56)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: true),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}

class _BarrasApiladas extends StatelessWidget {
  const _BarrasApiladas({required this.puntos});

  final List<PuntoCurva> puntos;

  @override
  Widget build(BuildContext context) {
    final desgloses = [
      for (final p in puntos) Map<String, int>.from(jsonDecode(p.costoPorRubroJson) as Map),
    ];
    final maximo = puntos.isEmpty ? 1 : puntos.map((p) => p.costoTotalCent).reduce((a, b) => a > b ? a : b);

    return BarChart(
      BarChartData(
        maxY: maximo * 1.1,
        barGroups: [
          for (var i = 0; i < puntos.length; i++) _grupoApilado(i, puntos[i], desgloses[i]),
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (valor, meta) {
                final indice = valor.toInt();
                if (indice < 0 || indice >= puntos.length) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text('${puntos[indice].numeroAlmacenes}', style: const TextStyle(fontSize: 11)),
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 56)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  BarChartGroupData _grupoApilado(int x, PuntoCurva punto, Map<String, int> desglose) {
    var acumulado = 0.0;
    final items = <BarChartRodStackItem>[];
    for (final rubro in etiquetasRubro.keys) {
      final valor = (desglose[rubro] ?? 0).toDouble();
      items.add(BarChartRodStackItem(acumulado, acumulado + valor, coloresRubro[rubro]!));
      acumulado += valor;
    }
    return BarChartGroupData(
      x: x,
      barRods: [BarChartRodData(toY: acumulado, rodStackItems: items, width: 18)],
    );
  }
}

class _SinBarridos extends StatelessWidget {
  const _SinBarridos();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Todavía no hay ningún escenario generado con el método "Barrido" — '
          'corré uno desde Optimización para ver la curva de costo.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
