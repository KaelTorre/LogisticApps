import 'package:flutter/material.dart';

import '../../../domain/motor/m6_configuracion.dart';

/// M6 (CLAUDE.md sección 7): tabla de configuraciones ordenada por
/// distancia esperada, no un dibujo — **[REGLA]** de la propia sección.
class ComparadorConfiguracionesScreen extends StatelessWidget {
  const ComparadorConfiguracionesScreen({super.key, required this.resultado});

  final ResultadoM6 resultado;

  static const _maxFilasMostradas = 15;

  @override
  Widget build(BuildContext context) {
    final mostradas = resultado.configuraciones.take(_maxFilasMostradas).toList();
    final ocultas = resultado.configuraciones.length - mostradas.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Comparador de configuraciones')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Ordenadas por distancia esperada de recorrido — no incluye '
            'costo de manejo anual (requiere movimientos/día, no calculados '
            'todavía).',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Filas')),
                DataColumn(label: Text('Módulos/fila')),
                DataColumn(label: Text('Patrón')),
                DataColumn(label: Text('Ancho (m)')),
                DataColumn(label: Text('Profundidad (m)')),
                DataColumn(label: Text('Relación')),
                DataColumn(label: Text('Distancia esperada (m)')),
              ],
              rows: [
                for (final c in mostradas)
                  DataRow(
                    color: c == mostradas.first
                        ? WidgetStateProperty.all(Colors.green.withValues(alpha: 0.1))
                        : null,
                    cells: [
                      DataCell(Text('${c.filas}')),
                      DataCell(Text('${c.modulosPorFila}')),
                      DataCell(Text(_nombrePatron(c.patronFlujo))),
                      DataCell(Text((c.layout.anchoTotalMm / 1000).toStringAsFixed(1))),
                      DataCell(Text((c.layout.largoTotalMm / 1000).toStringAsFixed(1))),
                      DataCell(
                        Text(
                          (c.layout.anchoTotalMm > c.layout.largoTotalMm
                                  ? c.layout.anchoTotalMm / c.layout.largoTotalMm
                                  : c.layout.largoTotalMm / c.layout.anchoTotalMm)
                              .toStringAsFixed(2),
                        ),
                      ),
                      DataCell(Text((c.distanciaEsperadaMm / 1000).toStringAsFixed(1))),
                    ],
                  ),
              ],
            ),
          ),
          if (ocultas > 0)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text('... y $ocultas configuraciones más, no mostradas.'),
            ),
        ],
      ),
    );
  }

  String _nombrePatron(PatronFlujo p) => switch (p) {
    PatronFlujo.u => 'U',
    PatronFlujo.pasante => 'Pasante',
    PatronFlujo.l => 'L',
  };
}
