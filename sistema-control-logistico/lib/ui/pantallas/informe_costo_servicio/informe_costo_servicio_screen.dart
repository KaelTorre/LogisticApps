import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';

import '../../../core/formato_moneda.dart';
import '../../../core/plataforma/abrir_carpeta.dart';
import '../../../data/models/organizacion.dart';
import '../../../data/models/periodo.dart';
import '../../../data/repositories/indicador_repository.dart';
import '../../../data/repositories/medicion_repository.dart';
import '../../../data/repositories/periodo_repository.dart';
import '../../../domain/export/pdf_builder_informes.dart';
import '../../../domain/motor/m8_informes.dart';

/// Pantalla 16 (CLAUDE.md sección 9): desglose de costo por proceso y peso
/// relativo, más el centro de utilidades (precio de transferencia
/// sugerido por proceso, M8) y los indicadores de servicio del mismo
/// periodo, con exportación a PDF.
class InformeCostoServicioScreen extends StatefulWidget {
  const InformeCostoServicioScreen({super.key, required this.organizacion});

  final Organizacion organizacion;

  @override
  State<InformeCostoServicioScreen> createState() => _InformeCostoServicioScreenState();
}

class _InformeCostoServicioScreenState extends State<InformeCostoServicioScreen> {
  bool _cargando = true;
  bool _exportando = false;
  List<Periodo> _periodos = [];
  Periodo? _seleccionado;
  InformeCostoServicio? _informe;

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
    if (_seleccionado != null) await _calcularInforme();
  }

  Future<void> _calcularInforme() async {
    final periodo = _seleccionado;
    if (periodo == null) return;
    final indicadorRepo = context.read<IndicadorRepository>();
    final medicionRepo = context.read<MedicionRepository>();

    final indicadores = await indicadorRepo.obtenerPorOrganizacion(widget.organizacion.id!);
    final componentes = <ComponenteCosto>[];
    final servicio = <ResumenServicio>[];

    for (final indicador in indicadores.where((i) => i.activo)) {
      final medicion = await medicionRepo.obtenerPorIndicadorYPeriodo(indicador.id!, periodo.id!);
      if (medicion == null) continue;
      if (indicador.categoria == 'costo') {
        componentes.add(
          ComponenteCosto(proceso: indicador.proceso, indicadorNombre: indicador.nombre, monto: medicion.valor),
        );
      } else if (indicador.categoria == 'servicio') {
        servicio.add(
          ResumenServicio(
            indicadorNombre: indicador.nombre,
            valor: medicion.valor,
            meta: indicador.meta,
            unidad: indicador.unidad,
          ),
        );
      }
    }

    if (!mounted) return;
    setState(() {
      _informe = InformeCostoServicio(componentes: componentes, servicio: servicio);
    });
  }

  Future<void> _exportarPdf() async {
    final periodo = _seleccionado;
    final informe = _informe;
    if (periodo == null || informe == null) return;
    setState(() => _exportando = true);

    final fuenteRegular = pw.Font.ttf(await rootBundle.load('assets/fonts/DejaVuSans.ttf'));
    final fuenteNegrita = pw.Font.ttf(await rootBundle.load('assets/fonts/DejaVuSans-Bold.ttf'));

    final precioTransferencia = informe.precioTransferenciaPorProceso;

    final bytes = await generarInformePdf(
      titulo: 'Informe de costo y servicio - ${widget.organizacion.nombre} - ${periodo.etiqueta}',
      resumen: [
        MapEntry(
          'Costo logístico total',
          formatearMoneda(informe.costoTotal, widget.organizacion.moneda),
        ),
        MapEntry('Periodo', periodo.etiqueta),
      ],
      secciones: [
        SeccionInformePdf(
          titulo: 'Costo por proceso',
          encabezados: const ['Proceso', 'Indicador', 'Monto', 'Peso relativo'],
          filas: [
            for (final c in informe.componentes)
              [
                c.proceso,
                c.indicadorNombre,
                c.monto.toStringAsFixed(2),
                '${(informe.pesoRelativo(c) * 100).toStringAsFixed(1)}%',
              ],
          ],
        ),
        SeccionInformePdf(
          titulo: 'Centro de utilidades — precio de transferencia sugerido',
          encabezados: const ['Proceso', 'Precio de transferencia'],
          filas: [
            for (final entrada in precioTransferencia.entries) [entrada.key, entrada.value.toStringAsFixed(2)],
          ],
        ),
        if (informe.servicio.isNotEmpty)
          SeccionInformePdf(
            titulo: 'Servicio',
            encabezados: const ['Indicador', 'Valor', 'Meta'],
            filas: [
              for (final s in informe.servicio)
                [s.indicadorNombre, '${s.valor} ${s.unidad}', '${s.meta} ${s.unidad}'],
            ],
          ),
      ],
      fuenteRegular: fuenteRegular,
      fuenteNegrita: fuenteNegrita,
    );

    final directorio = await directorioExportacion();
    final nombreArchivo =
        'costo_servicio_${periodo.etiqueta.replaceAll(' ', '_')}_'
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
    final informe = _informe;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Costo y servicio'),
        actions: [
          if (informe != null)
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
          ? const _SinPeriodos()
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
                      _calcularInforme();
                    },
                  ),
                ),
                Expanded(
                  child: informe == null || (informe.componentes.isEmpty && informe.servicio.isEmpty)
                      ? Center(
                          child: Text(
                            'Sin mediciones de costo ni de servicio en este periodo.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          children: [
                            Card(
                              child: ListTile(
                                leading: const Icon(LucideIcons.circleDollarSign),
                                title: Text(
                                  formatearMoneda(informe.costoTotal, widget.organizacion.moneda),
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                subtitle: const Text('Costo logístico total'),
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (informe.componentes.isNotEmpty) ...[
                              Text('Por proceso', style: Theme.of(context).textTheme.titleSmall),
                              const SizedBox(height: 8),
                              for (final c in informe.componentes)
                                ListTile(
                                  title: Text(c.indicadorNombre),
                                  subtitle: Text(c.proceso),
                                  trailing: Text(
                                    '${c.monto.toStringAsFixed(2)}\n'
                                    '${(informe.pesoRelativo(c) * 100).toStringAsFixed(1)}%',
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              const SizedBox(height: 16),
                              Text('Centro de utilidades', style: Theme.of(context).textTheme.titleSmall),
                              Text(
                                'Precio de transferencia sugerido por proceso',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 8),
                              for (final entrada in informe.precioTransferenciaPorProceso.entries)
                                ListTile(
                                  title: Text(entrada.key),
                                  trailing: Text(entrada.value.toStringAsFixed(2)),
                                ),
                              const SizedBox(height: 16),
                            ],
                            if (informe.servicio.isNotEmpty) ...[
                              Text('Servicio', style: Theme.of(context).textTheme.titleSmall),
                              const SizedBox(height: 8),
                              for (final s in informe.servicio)
                                ListTile(
                                  title: Text(s.indicadorNombre),
                                  trailing: Text('${s.valor} ${s.unidad}\nmeta ${s.meta}', textAlign: TextAlign.right),
                                ),
                            ],
                            const SizedBox(height: 24),
                          ],
                        ),
                ),
              ],
            ),
    );
  }
}

class _SinPeriodos extends StatelessWidget {
  const _SinPeriodos();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Todavía no hay periodos. Crea uno primero desde Periodos.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
