import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../data/models/diagnostico_organizacional.dart';
import '../../../data/repositories/diagnostico_organizacional_repository.dart';
import '../../../domain/motor/m9_diagnostico_organizacional.dart';

const _etiquetasEtapa = {
  1: 'Etapa 1 — Fragmentada',
  2: 'Etapa 2 — Agrupación parcial',
  3: 'Etapa 3 — Logística unificada',
  4: 'Etapa 4 — Integrada con la cadena de suministro',
};
const _etiquetasOpcion = {'funcional': 'Funcional', 'matricial': 'Matricial', 'por_procesos': 'Por procesos'};
const _etiquetasOrientacion = {'proceso': 'Proceso', 'mercado': 'Mercado', 'informacion': 'Información'};
const _bloques = [
  ('etapa', 'Etapa de desarrollo'),
  ('centralizacion', 'Centralización'),
  ('asesorLinea', 'Rol asesor o de línea'),
  ('orientacion', 'Orientación dominante'),
  ('opcion', 'Opción organizacional'),
];

/// Pantalla 20 (CLAUDE.md sección 9): cuestionario de M9, lista de
/// diagnósticos previos de la organización y su resultado (etapa, opción
/// organizacional, ejes y orientación dominante) con radar e informe de
/// brechas.
class DiagnosticoOrganizacionalScreen extends StatefulWidget {
  const DiagnosticoOrganizacionalScreen({super.key, required this.organizacionId});

  final int organizacionId;

  @override
  State<DiagnosticoOrganizacionalScreen> createState() => _DiagnosticoOrganizacionalScreenState();
}

class _DiagnosticoOrganizacionalScreenState extends State<DiagnosticoOrganizacionalScreen> {
  bool _cargando = true;
  List<DiagnosticoOrganizacional> _diagnosticos = [];

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _cargando = true);
    final todos = await context.read<DiagnosticoOrganizacionalRepository>().obtenerPorOrganizacion(
      widget.organizacionId,
    );
    todos.sort((a, b) => b.fecha.compareTo(a.fecha));
    if (!mounted) return;
    setState(() {
      _diagnosticos = todos;
      _cargando = false;
    });
  }

  Future<void> _nuevoDiagnostico() async {
    final creado = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => _CuestionarioDiagnosticoScreen(organizacionId: widget.organizacionId)),
    );
    if (creado == true) await _cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diagnóstico organizacional')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _nuevoDiagnostico,
        icon: const Icon(LucideIcons.plus),
        label: const Text('Nuevo diagnóstico'),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _diagnosticos.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Todavía no hay ningún diagnóstico. Responde el cuestionario para ubicar a la '
                  'organización en su etapa de desarrollo, su orientación dominante y su opción organizacional.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 88),
              itemCount: _diagnosticos.length,
              itemBuilder: (context, index) {
                final d = _diagnosticos[index];
                return ListTile(
                  leading: const Icon(LucideIcons.radar),
                  title: Text(_etiquetasEtapa[int.parse(d.etapaResultante)] ?? 'Etapa ${d.etapaResultante}'),
                  subtitle: Text(
                    '${_etiquetasOpcion[d.opcionOrganizacional] ?? d.opcionOrganizacional} · '
                    'Orientación a ${_etiquetasOrientacion[d.orientacionDominante] ?? d.orientacionDominante} · '
                    '${d.fecha.split('T').first}',
                  ),
                  trailing: const Icon(LucideIcons.chevronRight),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => _ResultadoDiagnosticoScreen(diagnostico: d)),
                  ),
                );
              },
            ),
    );
  }
}

class _CuestionarioDiagnosticoScreen extends StatefulWidget {
  const _CuestionarioDiagnosticoScreen({required this.organizacionId});

  final int organizacionId;

  @override
  State<_CuestionarioDiagnosticoScreen> createState() => _CuestionarioDiagnosticoScreenState();
}

class _CuestionarioDiagnosticoScreenState extends State<_CuestionarioDiagnosticoScreen> {
  final Map<String, String> _respuestas = {};
  bool _guardando = false;

  bool get _completo => _respuestas.length == preguntasDiagnostico.length;

  Future<void> _guardar() async {
    if (!_completo) return;
    setState(() => _guardando = true);

    final resultado = evaluarDiagnostico(_respuestas);
    final diagnostico = DiagnosticoOrganizacional(
      organizacionId: widget.organizacionId,
      // Sello de auditoría de cuándo se respondió el cuestionario, fuera
      // de lib/domain/motor/ -- permitido explícitamente por la regla
      // fundamental (CLAUDE.md sección 4).
      fecha: DateTime.now().toIso8601String(),
      respuestasJson: jsonEncode(_respuestas),
      etapaResultante: resultado.etapaResultante.toString(),
      opcionOrganizacional: resultado.opcionOrganizacional,
      ejesJson: jsonEncode(resultado.ejes.aMapa()),
      orientacionDominante: resultado.orientacionDominante,
    );
    await context.read<DiagnosticoOrganizacionalRepository>().crear(diagnostico);

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo diagnóstico')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: [
          for (final (bloque, titulo) in _bloques) ...[
            Text(titulo, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            for (final pregunta in preguntasDiagnostico.where((p) => p.bloque == bloque))
              Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(pregunta.texto, style: Theme.of(context).textTheme.bodyLarge),
                      ),
                      RadioGroup<String>(
                        groupValue: _respuestas[pregunta.id],
                        onChanged: (v) => setState(() => _respuestas[pregunta.id] = v!),
                        child: Column(
                          children: [
                            for (final opcion in pregunta.opciones)
                              RadioListTile<String>(
                                dense: true,
                                value: opcion.valor,
                                title: Text(opcion.etiqueta, style: Theme.of(context).textTheme.bodyMedium),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 8),
          ],
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: _completo && !_guardando ? _guardar : null,
            icon: _guardando
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(LucideIcons.check),
            label: Text(
              _completo
                  ? 'Calcular resultado'
                  : 'Responde las ${preguntasDiagnostico.length - _respuestas.length} preguntas restantes',
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultadoDiagnosticoScreen extends StatelessWidget {
  const _ResultadoDiagnosticoScreen({required this.diagnostico});

  final DiagnosticoOrganizacional diagnostico;

  static const _etiquetasCortasRadar = ['Etapa', 'Central.', 'Línea', 'Proceso', 'Mercado', 'Info.'];

  double _valorRadar(BrechaEje b) => b.eje == 'etapa' ? b.actual / 4 * 100 : b.actual;
  double _objetivoRadar(BrechaEje b) => b.eje == 'etapa' ? b.objetivo / 4 * 100 : b.objetivo;

  @override
  Widget build(BuildContext context) {
    final ejes = EjesOrganizacionales.deMapa(jsonDecode(diagnostico.ejesJson) as Map<String, dynamic>);
    final resultado = ResultadoDiagnostico(
      etapaResultante: int.parse(diagnostico.etapaResultante),
      opcionOrganizacional: diagnostico.opcionOrganizacional,
      orientacionDominante: diagnostico.orientacionDominante,
      ejes: ejes,
    );
    final brechas = calcularBrechas(resultado);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Resultado del diagnóstico')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Text(
                    _etiquetasEtapa[resultado.etapaResultante] ?? 'Etapa ${resultado.etapaResultante}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text('Opción organizacional: ${_etiquetasOpcion[resultado.opcionOrganizacional]}'),
                  Text('Orientación dominante: ${_etiquetasOrientacion[resultado.orientacionDominante]}'),
                  Text(
                    'Respondido el ${diagnostico.fecha.split('T').first}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 24,
            children: [
              _LeyendaRadar(color: colorScheme.primary, texto: 'Organización actual'),
              _LeyendaRadar(color: colorScheme.outline, texto: 'Perfil de referencia'),
            ],
          ),
          SizedBox(
            height: 280,
            child: RadarChart(
              RadarChartData(
                radarShape: RadarShape.polygon,
                tickCount: 4,
                titlePositionPercentageOffset: 0.18,
                titleTextStyle: Theme.of(context).textTheme.bodySmall,
                ticksTextStyle: const TextStyle(color: Colors.transparent),
                radarBorderData: BorderSide(color: colorScheme.outlineVariant),
                gridBorderData: BorderSide(color: colorScheme.outlineVariant),
                getTitle: (index, angle) => RadarChartTitle(text: _etiquetasCortasRadar[index]),
                dataSets: [
                  RadarDataSet(
                    dataEntries: brechas.map((b) => RadarEntry(value: _valorRadar(b))).toList(),
                    fillColor: colorScheme.primary.withValues(alpha: 0.25),
                    borderColor: colorScheme.primary,
                    borderWidth: 2,
                    entryRadius: 3,
                  ),
                  RadarDataSet(
                    dataEntries: brechas.map((b) => RadarEntry(value: _objetivoRadar(b))).toList(),
                    fillColor: Colors.transparent,
                    borderColor: colorScheme.outline,
                    borderWidth: 1.5,
                    entryRadius: 0,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Informe de brechas', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          for (final b in brechas)
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                dense: true,
                title: Text(b.etiqueta),
                subtitle: Text(
                  'Actual ${b.actual.toStringAsFixed(b.eje == 'etapa' ? 0 : 1)} · '
                  'Objetivo ${b.objetivo.toStringAsFixed(b.eje == 'etapa' ? 0 : 1)}',
                ),
                trailing: Text(
                  b.brecha <= 0 ? 'Cumplido' : '+${b.brecha.toStringAsFixed(1)}',
                  style: TextStyle(
                    color: b.brecha <= 0 ? Colors.green : Colors.amber.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _LeyendaRadar extends StatelessWidget {
  const _LeyendaRadar({required this.color, required this.texto});

  final Color color;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(texto, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
