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
    final colores = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Comparador de configuraciones')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colores.secondaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 18, color: colores.onSecondaryContainer),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Ordenadas por distancia esperada de recorrido. No incluye '
                    'costo de manejo anual (requiere movimientos/día, aún sin '
                    'calcular).',
                    style: TextStyle(color: colores.onSecondaryContainer, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                const DataColumn(label: Text('Filas')),
                const DataColumn(label: Text('Módulos/fila')),
                const DataColumn(label: Text('Patrón')),
                const DataColumn(label: Text('Ancho (m)')),
                const DataColumn(label: Text('Profundidad (m)')),
                DataColumn(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Relación'),
                      const SizedBox(width: 4),
                      Tooltip(
                        message: 'Lado largo ÷ lado corto de la huella. Se descartan '
                            'las geometrías por encima de 3:1.',
                        child: Icon(Icons.info_outline, size: 14, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                const DataColumn(label: Text('Distancia esperada (m)')),
              ],
              rows: [
                for (final c in mostradas)
                  DataRow(
                    color: c == mostradas.first
                        ? WidgetStateProperty.all(Colors.green.withValues(alpha: 0.1))
                        : null,
                    cells: [
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (c == mostradas.first)
                              const Tooltip(
                                message: 'Mejor opción por distancia esperada',
                                child: Icon(Icons.star, size: 16, color: Colors.amber),
                              ),
                            if (c == mostradas.first) const SizedBox(width: 4),
                            Text('${c.filas}'),
                          ],
                        ),
                      ),
                      DataCell(Text('${c.modulosPorFila}')),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_iconoPatron(c.patronFlujo), size: 16, color: colores.primary),
                            const SizedBox(width: 6),
                            Text(_nombrePatron(c.patronFlujo)),
                          ],
                        ),
                      ),
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
              child: Row(
                children: [
                  Icon(Icons.more_horiz, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text('$ocultas configuraciones más, no mostradas'),
                ],
              ),
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

  IconData _iconoPatron(PatronFlujo p) => switch (p) {
    PatronFlujo.u => Icons.u_turn_left,
    PatronFlujo.pasante => Icons.compare_arrows,
    PatronFlujo.l => Icons.turn_right,
  };
}
