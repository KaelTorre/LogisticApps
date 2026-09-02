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
import '../../../data/models/presupuesto.dart';
import '../../../data/repositories/periodo_repository.dart';
import '../../../data/repositories/presupuesto_repository.dart';
import '../../../domain/export/pdf_builder_informes.dart';
import '../../../domain/motor/m8_informes.dart';

/// Pantalla 19 (CLAUDE.md sección 9): presupuestado contra real y
/// variaciones. Como no hay otra pantalla asignada a dar de alta el
/// presupuesto, esta misma lo hace (mismo criterio que Pantalla 6 con las
/// mediciones).
class PresupuestoScreen extends StatefulWidget {
  const PresupuestoScreen({super.key, required this.organizacion});

  final Organizacion organizacion;

  @override
  State<PresupuestoScreen> createState() => _PresupuestoScreenState();
}

class _PresupuestoScreenState extends State<PresupuestoScreen> {
  bool _cargando = true;
  bool _exportando = false;
  List<Periodo> _periodos = [];
  Periodo? _seleccionado;
  List<Presupuesto> _presupuestos = [];

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
    if (_seleccionado != null) await _cargarPresupuestos();
  }

  Future<void> _cargarPresupuestos() async {
    final todos = await context.read<PresupuestoRepository>().obtenerPorOrganizacion(
      widget.organizacion.id!,
    );
    if (!mounted) return;
    setState(() {
      _presupuestos = todos.where((p) => p.periodoId == _seleccionado!.id).toList();
    });
  }

  Future<void> _abrirFormulario({Presupuesto? existente}) async {
    final periodo = _seleccionado;
    if (periodo == null) return;
    final guardado = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => _FormularioPresupuesto(
          organizacionId: widget.organizacion.id!,
          periodoId: periodo.id!,
          moneda: widget.organizacion.moneda,
          existente: existente,
        ),
      ),
    );
    if (guardado == true) await _cargarPresupuestos();
  }

  Future<void> _eliminar(Presupuesto presupuesto) async {
    await context.read<PresupuestoRepository>().eliminar(presupuesto.id!);
    await _cargarPresupuestos();
  }

  Future<void> _exportarPdf() async {
    final periodo = _seleccionado;
    if (periodo == null || _presupuestos.isEmpty) return;
    setState(() => _exportando = true);

    final fuenteRegular = pw.Font.ttf(await rootBundle.load('assets/fonts/DejaVuSans.ttf'));
    final fuenteNegrita = pw.Font.ttf(await rootBundle.load('assets/fonts/DejaVuSans-Bold.ttf'));

    final variaciones = _presupuestos
        .map(
          (p) => VariacionPresupuestal(
            rubro: p.rubro,
            presupuestadoCent: p.montoPresupuestadoCent,
            realCent: p.montoRealCent,
          ),
        )
        .toList();

    final bytes = await generarInformePdf(
      titulo: 'Presupuesto - ${widget.organizacion.nombre} - ${periodo.etiqueta}',
      resumen: [MapEntry('Periodo', periodo.etiqueta)],
      secciones: [
        SeccionInformePdf(
          titulo: 'Presupuestado contra real',
          encabezados: const ['Rubro', 'Presupuestado', 'Real', 'Variación'],
          filas: [
            for (final v in variaciones)
              [
                v.rubro,
                (v.presupuestadoCent / 100).toStringAsFixed(2),
                (v.realCent / 100).toStringAsFixed(2),
                v.porcentajeVariacion == null
                    ? '—'
                    : '${v.porcentajeVariacion! >= 0 ? '+' : ''}${v.porcentajeVariacion!.toStringAsFixed(1)}%',
              ],
          ],
        ),
      ],
      fuenteRegular: fuenteRegular,
      fuenteNegrita: fuenteNegrita,
    );

    final directorio = await directorioExportacion();
    final nombreArchivo =
        'presupuesto_${periodo.etiqueta.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf';
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
        title: const Text('Presupuesto'),
        actions: [
          if (_presupuestos.isNotEmpty)
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
      floatingActionButton: _seleccionado == null
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _abrirFormulario(),
              icon: const Icon(LucideIcons.plus),
              label: const Text('Nuevo rubro'),
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
                      _cargarPresupuestos();
                    },
                  ),
                ),
                Expanded(
                  child: _presupuestos.isEmpty
                      ? Center(
                          child: Text(
                            'Sin rubros presupuestales en este periodo.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 88),
                          itemCount: _presupuestos.length,
                          itemBuilder: (context, index) {
                            final p = _presupuestos[index];
                            final variacion = VariacionPresupuestal(
                              rubro: p.rubro,
                              presupuestadoCent: p.montoPresupuestadoCent,
                              realCent: p.montoRealCent,
                            );
                            final porcentaje = variacion.porcentajeVariacion;
                            final esSobregasto = (porcentaje ?? 0) > 0;
                            return ListTile(
                              title: Text(p.rubro),
                              subtitle: Text(
                                'Presupuestado ${formatearMoneda(p.montoPresupuestadoCent / 100, widget.organizacion.moneda)} · '
                                'Real ${formatearMoneda(p.montoRealCent / 100, widget.organizacion.moneda)}',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    porcentaje == null
                                        ? '—'
                                        : '${porcentaje >= 0 ? '+' : ''}${porcentaje.toStringAsFixed(1)}%',
                                    style: TextStyle(
                                      color: porcentaje == null
                                          ? null
                                          : (esSobregasto ? Theme.of(context).colorScheme.error : Colors.green),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(LucideIcons.pencil, size: 18),
                                    onPressed: () => _abrirFormulario(existente: p),
                                  ),
                                  IconButton(
                                    icon: const Icon(LucideIcons.trash2, size: 18),
                                    onPressed: () => _eliminar(p),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

class _FormularioPresupuesto extends StatefulWidget {
  const _FormularioPresupuesto({
    required this.organizacionId,
    required this.periodoId,
    required this.moneda,
    this.existente,
  });

  final int organizacionId;
  final int periodoId;
  final String moneda;
  final Presupuesto? existente;

  @override
  State<_FormularioPresupuesto> createState() => _FormularioPresupuestoState();
}

class _FormularioPresupuestoState extends State<_FormularioPresupuesto> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _rubroCtrl;
  late final TextEditingController _presupuestadoCtrl;
  late final TextEditingController _realCtrl;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    final existente = widget.existente;
    _rubroCtrl = TextEditingController(text: existente?.rubro ?? '');
    _presupuestadoCtrl = TextEditingController(
      text: existente == null ? '' : (existente.montoPresupuestadoCent / 100).toStringAsFixed(2),
    );
    _realCtrl = TextEditingController(
      text: existente == null ? '' : (existente.montoRealCent / 100).toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _rubroCtrl.dispose();
    _presupuestadoCtrl.dispose();
    _realCtrl.dispose();
    super.dispose();
  }

  int? _aCentimos(String texto) {
    final valor = double.tryParse(texto.trim().replaceAll(',', '.'));
    if (valor == null) return null;
    return (valor * 100).round();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    final presupuestadoCent = _aCentimos(_presupuestadoCtrl.text)!;
    final realCent = _aCentimos(_realCtrl.text)!;
    setState(() => _guardando = true);

    final repo = context.read<PresupuestoRepository>();
    final presupuesto = Presupuesto(
      id: widget.existente?.id,
      organizacionId: widget.organizacionId,
      rubro: _rubroCtrl.text.trim(),
      periodoId: widget.periodoId,
      montoPresupuestadoCent: presupuestadoCent,
      montoRealCent: realCent,
    );

    try {
      if (presupuesto.id == null) {
        await repo.crear(presupuesto);
      } else {
        await repo.actualizar(presupuesto);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _guardando = false);
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            showCloseIcon: true,
            content: Text('Ya existe el rubro "${presupuesto.rubro}" en este periodo.'),
          ),
        );
      return;
    }

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final esNuevo = widget.existente == null;
    return Scaffold(
      appBar: AppBar(title: Text(esNuevo ? 'Nuevo rubro presupuestal' : 'Editar rubro presupuestal')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _rubroCtrl,
              decoration: const InputDecoration(labelText: 'Rubro', helperText: 'Ej. "Transporte"'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa un rubro' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _presupuestadoCtrl,
              decoration: InputDecoration(labelText: 'Monto presupuestado', prefixText: simboloMoneda(widget.moneda)),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => _aCentimos(v ?? '') == null ? 'Ingresa un monto válido' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _realCtrl,
              decoration: InputDecoration(labelText: 'Monto real', prefixText: simboloMoneda(widget.moneda)),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => _aCentimos(v ?? '') == null ? 'Ingresa un monto válido' : null,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _guardando ? null : _guardar,
              child: _guardando
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
