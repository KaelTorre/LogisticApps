import 'package:flutter/material.dart';

import '../../../domain/geometria/generador_layout.dart';
import '../../../domain/motor/fila_memoria.dart';
import '../../../domain/motor/m2_posiciones.dart';
import '../../../domain/motor/m3_superficie.dart';
import '../../../domain/motor/m6_configuracion.dart';
import '../../../domain/motor/m7_anden.dart';
import '../comparador_configuraciones/comparador_configuraciones_screen.dart';
import '../plano/plano_screen.dart';

/// Ficha de salida: resultado de M2 + M3 + el generador de layout de la
/// Fase 2, con la memoria de cálculo completa. Sin isométrico ni
/// exportación todavía — eso es de fases posteriores.
class FichaResultadoScreen extends StatelessWidget {
  const FichaResultadoScreen({
    super.key,
    required this.resultadoM2,
    required this.resultadoM3,
    required this.resultadoLayout,
    required this.resultadoM6,
    required this.resultadoM7,
  });

  final ResultadoM2 resultadoM2;
  final ResultadoM3 resultadoM3;
  final ResultadoLayout resultadoLayout;
  final ResultadoM6 resultadoM6;
  final ResultadoM7 resultadoM7;

  @override
  Widget build(BuildContext context) {
    final memoriaCompleta = [
      ...resultadoM2.memoria,
      ...resultadoM3.memoria,
      ...resultadoLayout.memoria,
      ...resultadoM6.memoria,
      ...resultadoM7.memoria,
    ];
    final supAlmacenamientoM2 = resultadoLayout.supRacksMm2 / 1000000;
    final supConstruidaM2 = resultadoLayout.supConstruidaMm2 / 1000000;
    final ratio = resultadoLayout.supRacksMm2 / resultadoLayout.supConstruidaMm2;

    return Scaffold(
      appBar: AppBar(title: const Text('Ficha técnica')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.summarize_outlined, size: 20, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Text('Resumen', style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _filaResumen(
                    Icons.inventory_2_outlined,
                    'Posiciones requeridas',
                    '${resultadoM2.posicionesRequeridas}',
                  ),
                  _filaResumen(
                    Icons.view_agenda_outlined,
                    'Tarimas por nivel',
                    '${resultadoM3.tarimasPorNivel}',
                  ),
                  _filaResumen(Icons.height, 'Paso de nivel', '${resultadoM3.pasoNivelMm} mm'),
                  _filaResumen(Icons.layers_outlined, 'Niveles', '${resultadoM3.niveles}'),
                  _filaResumen(Icons.grid_view_outlined, 'Módulos', '${resultadoM3.modulos}'),
                  _filaResumen(
                    Icons.view_column_outlined,
                    'Módulos por fila',
                    '${resultadoM3.modulosPorFila}',
                  ),
                  _filaResumen(Icons.view_week_outlined, 'Filas', '${resultadoM3.filas}'),
                  _filaResumen(
                    Icons.inventory_outlined,
                    'Posiciones instaladas',
                    '${resultadoM3.posicionesInstaladas}',
                  ),
                  _filaResumen(
                    Icons.square_foot_outlined,
                    'Superficie de almacenamiento',
                    '${supAlmacenamientoM2.toStringAsFixed(1)} m²',
                  ),
                  _filaResumen(
                    Icons.crop_free,
                    'Superficie construida',
                    '${supConstruidaM2.toStringAsFixed(1)} m²',
                  ),
                  _filaRatio(context, ratio),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.local_shipping_outlined,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text('Andén', style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _filaResumen(Icons.door_sliding_outlined, 'Puertas', '${resultadoM7.puertas}'),
                  _filaResumen(
                    Icons.straighten,
                    'Frente de andén',
                    '${resultadoM7.frenteAndenMm} mm',
                  ),
                  _filaResumen(
                    Icons.height,
                    'Profundidad de patio',
                    '${resultadoM7.patioProfundidadMm} mm',
                  ),
                  _filaResumen(
                    Icons.square_foot_outlined,
                    'Superficie de preparación',
                    '${(resultadoM7.supPreparacionMm2 / 1000000).toStringAsFixed(1)} m²',
                  ),
                  _filaResumen(
                    Icons.hourglass_bottom_outlined,
                    'Espera en cola',
                    '${(resultadoM7.esperaHoras * 60).toStringAsFixed(1)} min',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (_) => PlanoScreen(layout: resultadoLayout)));
                  },
                  icon: const Icon(Icons.map_outlined),
                  label: const Text('Ver plano 2D'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ComparadorConfiguracionesScreen(resultado: resultadoM6),
                      ),
                    );
                  },
                  icon: const Icon(Icons.table_chart_outlined),
                  label: const Text('Comparar'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            margin: EdgeInsets.zero,
            clipBehavior: Clip.antiAlias,
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading: const Icon(Icons.receipt_long_outlined),
                title: const Text('Memoria de cálculo'),
                subtitle: Text('${memoriaCompleta.length} pasos, con fórmula y fuente'),
                childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                children: memoriaCompleta.map(_filaMemoria).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filaResumen(IconData icono, String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icono, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Expanded(child: Text(etiqueta)),
          Text(valor, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _filaRatio(BuildContext context, double ratio) {
    // CLAUDE.md sección 7: en selectivo + retráctil, la relación típica cae
    // entre 0.45 y 0.60 — es la "prueba de humo" del sistema. Fuera de ese
    // rango no es necesariamente un error (depende del tipo de sistema),
    // así que solo se marca como referencia visual, no como validación dura.
    final dentroDelRangoTipico = ratio >= 0.45 && ratio <= 0.60;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.percent, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          const Expanded(child: Text('Relación almacenamiento/construida')),
          Text('${(ratio * 100).toStringAsFixed(1)} %', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 4),
          Tooltip(
            message: dentroDelRangoTipico
                ? 'Dentro del rango típico de selectivo + retráctil (45–60%).'
                : 'Fuera del rango típico de selectivo + retráctil (45–60%). '
                      'No es necesariamente un error: depende del tipo de sistema '
                      'y de cuántas filas se pudieron parear.',
            child: Icon(
              dentroDelRangoTipico ? Icons.check_circle_outline : Icons.info_outline,
              size: 16,
              color: dentroDelRangoTipico ? Colors.green : Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _filaMemoria(FilaMemoria fila) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Chip(
                label: Text(fila.modulo, style: const TextStyle(fontSize: 11)),
                padding: EdgeInsets.zero,
                labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(fila.concepto, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(fila.formula, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
          const SizedBox(height: 4),
          Text('${fila.valor} ${fila.unidad}'),
          if (fila.fuente != null) ...[
            const SizedBox(height: 2),
            Text(
              'Fuente: ${fila.fuente}',
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
          const Divider(height: 16),
        ],
      ),
    );
  }
}
