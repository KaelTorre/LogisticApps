import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';

import '../../../core/plataforma/abrir_carpeta.dart';
import '../../../data/models/indicador.dart';
import '../../../data/models/organizacion.dart';
import '../../../data/models/periodo.dart';
import '../../../data/repositories/evaluacion_repository.dart';
import '../../../data/repositories/indicador_repository.dart';
import '../../../data/repositories/periodo_repository.dart';
import '../../../domain/export/pdf_builder_informes.dart';

const _etiquetasEstado = {'normal': 'Normal', 'observacion': 'Observación', 'desviacion': 'Desviación'};

Color _colorEstado(BuildContext context, String? estado) {
  final colorScheme = Theme.of(context).colorScheme;
  return switch (estado) {
    'desviacion' => colorScheme.error,
    'observacion' => Colors.amber.shade700,
    'normal' => Colors.green,
    _ => colorScheme.outlineVariant,
  };
}

/// Pantalla 18 (CLAUDE.md sección 9): matriz de indicadores por periodo
/// con semáforo -- el estado por periodo que ya calculó y guardó la
/// Pantalla 8, solo reordenado para verlo de un vistazo.
class TablaDesempenoScreen extends StatefulWidget {
  const TablaDesempenoScreen({super.key, required this.organizacion});

  final Organizacion organizacion;

  @override
  State<TablaDesempenoScreen> createState() => _TablaDesempenoScreenState();
}

class _TablaDesempenoScreenState extends State<TablaDesempenoScreen> {
  bool _cargando = true;
  bool _exportando = false;
  List<Periodo> _periodos = [];
  List<Indicador> _indicadores = [];
  Map<(int, int), String> _estadoPorCelda = {};

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _cargando = true);
    final periodoRepo = context.read<PeriodoRepository>();
    final indicadorRepo = context.read<IndicadorRepository>();
    final evaluacionRepo = context.read<EvaluacionRepository>();

    final periodos = await periodoRepo.obtenerPorOrganizacion(widget.organizacion.id!);
    final indicadores = (await indicadorRepo.obtenerPorOrganizacion(
      widget.organizacion.id!,
    )).where((i) => i.activo).toList();

    final estadoPorCelda = <(int, int), String>{};
    for (final indicador in indicadores) {
      for (final evaluacion in await evaluacionRepo.obtenerPorIndicador(indicador.id!)) {
        estadoPorCelda[(indicador.id!, evaluacion.periodoId)] = evaluacion.estado;
      }
    }

    if (!mounted) return;
    setState(() {
      _periodos = periodos;
      _indicadores = indicadores;
      _estadoPorCelda = estadoPorCelda;
      _cargando = false;
    });
  }

  Future<void> _exportarPdf() async {
    setState(() => _exportando = true);
    final fuenteRegular = pw.Font.ttf(await rootBundle.load('assets/fonts/DejaVuSans.ttf'));
    final fuenteNegrita = pw.Font.ttf(await rootBundle.load('assets/fonts/DejaVuSans-Bold.ttf'));

    final bytes = await generarInformePdf(
      titulo: 'Tabla de desempeño - ${widget.organizacion.nombre}',
      resumen: const [],
      secciones: [
        SeccionInformePdf(
          titulo: 'Estado por indicador y periodo',
          encabezados: ['Indicador', ..._periodos.map((p) => p.etiqueta)],
          filas: [
            for (final indicador in _indicadores)
              [
                indicador.nombre,
                for (final periodo in _periodos)
                  _etiquetasEstado[_estadoPorCelda[(indicador.id!, periodo.id!)]] ?? '—',
              ],
          ],
        ),
      ],
      fuenteRegular: fuenteRegular,
      fuenteNegrita: fuenteNegrita,
    );

    final directorio = await directorioExportacion();
    final nombreArchivo = 'tabla_desempeno_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final archivo = File('${directorio.path}${Platform.pathSeparator}$nombreArchivo');
    await archivo.writeAsBytes(bytes);

    if (!mounted) return;
    setState(() => _exportando = false);
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        snackBarArchivoExportado(mensaje: 'PDF exportado: $nombreArchivo', rutaArchivo: archivo.path),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabla de desempeño'),
        actions: [
          if (_indicadores.isNotEmpty && _periodos.isNotEmpty)
            IconButton(
              icon: _exportando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(LucideIcons.fileText),
              tooltip: 'Exportar PDF',
              onPressed: _exportando ? null : _exportarPdf,
            ),
        ],
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _indicadores.isEmpty || _periodos.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Hace falta al menos un indicador y un periodo evaluado.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            )
          // Los nombres de indicador van en su propia tabla, fuera del
          // scroll horizontal -- con hasta treinta y seis periodos, sin
          // esto se pierde de vista qué fila es cuál apenas se desplaza la
          // tabla hacia la derecha. El scroll vertical (para cuando hay
          // muchos indicadores) envuelve a las dos tablas juntas, para que
          // se desplacen siempre a la par.
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DataTable(
                    columns: const [DataColumn(label: Text('Indicador'))],
                    rows: [
                      for (final indicador in _indicadores)
                        DataRow(
                          cells: [
                            DataCell(
                              SizedBox(
                                width: 220,
                                child: Tooltip(
                                  message: indicador.nombre,
                                  child: Text(
                                    indicador.nombre,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: [for (final p in _periodos) DataColumn(label: Text(p.etiqueta))],
                        rows: [
                          for (final indicador in _indicadores)
                            DataRow(
                              cells: [
                                for (final periodo in _periodos)
                                  DataCell(
                                    Tooltip(
                                      message:
                                          _etiquetasEstado[_estadoPorCelda[(indicador.id!, periodo.id!)]] ??
                                          'Sin evaluar',
                                      child: Icon(
                                        LucideIcons.circle,
                                        size: 16,
                                        color: _colorEstado(
                                          context,
                                          _estadoPorCelda[(indicador.id!, periodo.id!)],
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
