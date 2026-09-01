import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';

import '../../../core/plataforma/abrir_carpeta.dart';
import '../../../data/models/indicador.dart';
import '../../../data/models/medicion.dart';
import '../../../data/models/organizacion.dart';
import '../../../data/models/periodo.dart';
import '../../../data/repositories/indicador_repository.dart';
import '../../../data/repositories/medicion_repository.dart';
import '../../../data/repositories/periodo_repository.dart';
import '../../../domain/export/pdf_builder_informes.dart';
import '../../../domain/motor/m1_reglas_patron.dart' show esAdverso, ConfigIndicadorMotor;

/// Pantalla 17 (CLAUDE.md sección 9): los índices de productividad del
/// periodo elegido, cada uno contra su meta.
class InformeProductividadScreen extends StatefulWidget {
  const InformeProductividadScreen({super.key, required this.organizacion});

  final Organizacion organizacion;

  @override
  State<InformeProductividadScreen> createState() => _InformeProductividadScreenState();
}

class _InformeProductividadScreenState extends State<InformeProductividadScreen> {
  bool _cargando = true;
  bool _exportando = false;
  List<Periodo> _periodos = [];
  Periodo? _seleccionado;
  List<(Indicador, Medicion)> _indices = [];

  @override
  void initState() {
    super.initState();
    _cargarPeriodos();
  }

  Future<void> _cargarPeriodos() async {
    setState(() => _cargando = true);
    final periodos = await context.read<PeriodoRepository>().obtenerPorOrganizacion(
      widget.organizacion.id!,
    );
    if (!mounted) return;
    setState(() {
      _periodos = periodos;
      _seleccionado = periodos.isEmpty ? null : periodos.last;
      _cargando = false;
    });
    if (_seleccionado != null) await _calcular();
  }

  Future<void> _calcular() async {
    final periodo = _seleccionado;
    if (periodo == null) return;
    final indicadorRepo = context.read<IndicadorRepository>();
    final medicionRepo = context.read<MedicionRepository>();

    final indicadores = await indicadorRepo.obtenerPorOrganizacion(widget.organizacion.id!);
    final indices = <(Indicador, Medicion)>[];
    for (final indicador in indicadores.where((i) => i.activo && i.categoria == 'productividad')) {
      final medicion = await medicionRepo.obtenerPorIndicadorYPeriodo(indicador.id!, periodo.id!);
      if (medicion != null) indices.add((indicador, medicion));
    }

    if (!mounted) return;
    setState(() => _indices = indices);
  }

  bool _cumpleMeta(Indicador indicador, Medicion medicion) {
    final config = ConfigIndicadorMotor(
      meta: indicador.meta,
      bandaInferior: indicador.bandaInferior,
      bandaSuperior: indicador.bandaSuperior,
      sentido: indicador.sentido,
    );
    return !esAdverso(medicion.valor, config);
  }

  Future<void> _exportarPdf() async {
    final periodo = _seleccionado;
    if (periodo == null || _indices.isEmpty) return;
    setState(() => _exportando = true);

    final fuenteRegular = pw.Font.ttf(await rootBundle.load('assets/fonts/DejaVuSans.ttf'));
    final fuenteNegrita = pw.Font.ttf(await rootBundle.load('assets/fonts/DejaVuSans-Bold.ttf'));

    final bytes = await generarInformePdf(
      titulo: 'Informe de productividad - ${widget.organizacion.nombre} - ${periodo.etiqueta}',
      resumen: [MapEntry('Periodo', periodo.etiqueta)],
      secciones: [
        SeccionInformePdf(
          titulo: 'Índices de productividad',
          encabezados: const ['Indicador', 'Proceso', 'Valor', 'Meta', 'Cumple'],
          filas: [
            for (final (indicador, medicion) in _indices)
              [
                indicador.nombre,
                indicador.proceso,
                '${medicion.valor} ${indicador.unidad}',
                '${indicador.meta} ${indicador.unidad}',
                _cumpleMeta(indicador, medicion) ? 'Sí' : 'No',
              ],
          ],
        ),
      ],
      fuenteRegular: fuenteRegular,
      fuenteNegrita: fuenteNegrita,
    );

    final directorio = await directorioExportacion();
    final nombreArchivo =
        'productividad_${periodo.etiqueta.replaceAll(' ', '_')}_'
        '${DateTime.now().millisecondsSinceEpoch}.pdf';
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
        title: const Text('Productividad'),
        actions: [
          if (_indices.isNotEmpty)
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
          : _periodos.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Todavía no hay periodos. Crea uno primero desde Periodos.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: DropdownButtonFormField<Periodo>(
                    initialValue: _seleccionado,
                    decoration: const InputDecoration(labelText: 'Periodo'),
                    items: [
                      for (final p in _periodos) DropdownMenuItem(value: p, child: Text(p.etiqueta)),
                    ],
                    onChanged: (v) {
                      setState(() => _seleccionado = v);
                      _calcular();
                    },
                  ),
                ),
                Expanded(
                  child: _indices.isEmpty
                      ? Center(
                          child: Text(
                            'Sin indicadores de productividad medidos en este periodo.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          children: [
                            for (final (indicador, medicion) in _indices)
                              ListTile(
                                leading: Icon(
                                  _cumpleMeta(indicador, medicion) ? LucideIcons.circleCheck : LucideIcons.circleX,
                                  color: _cumpleMeta(indicador, medicion)
                                      ? Colors.green
                                      : Theme.of(context).colorScheme.error,
                                ),
                                title: Text(indicador.nombre),
                                subtitle: Text(indicador.proceso),
                                trailing: Text(
                                  '${medicion.valor.toStringAsFixed(indicador.decimales)} ${indicador.unidad}\n'
                                  'meta ${indicador.meta.toStringAsFixed(indicador.decimales)}',
                                  textAlign: TextAlign.right,
                                ),
                              ),
                          ],
                        ),
                ),
              ],
            ),
    );
  }
}
