import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/periodo.dart';
import '../../../data/repositories/periodo_repository.dart';

const _granularidades = ['diario', 'semanal', 'mensual', 'trimestral'];

const _etiquetasGranularidad = {
  'diario': 'Diario',
  'semanal': 'Semanal',
  'mensual': 'Mensual',
  'trimestral': 'Trimestral',
};

/// Formulario de alta/edición de un periodo (Pantalla 3). `orden` es el
/// único campo que el motor de evaluación lee para saber la secuencia
/// temporal (CLAUDE.md sección 4) -- las fechas son solo para que la
/// persona lea la etiqueta del periodo, nunca para ordenar nada.
class PeriodoFormScreen extends StatefulWidget {
  const PeriodoFormScreen({super.key, required this.organizacionId, this.existente, this.siguienteOrden});

  final int organizacionId;
  final Periodo? existente;
  final int? siguienteOrden;

  @override
  State<PeriodoFormScreen> createState() => _PeriodoFormScreenState();
}

class _PeriodoFormScreenState extends State<PeriodoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _ordenCtrl;
  late final TextEditingController _etiquetaCtrl;
  late final TextEditingController _fechaInicioCtrl;
  late final TextEditingController _fechaFinCtrl;
  late String _granularidad;
  late bool _esSimulado;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    final existente = widget.existente;
    _ordenCtrl = TextEditingController(
      text: (existente?.orden ?? widget.siguienteOrden ?? 1).toString(),
    );
    _etiquetaCtrl = TextEditingController(text: existente?.etiqueta ?? '');
    _fechaInicioCtrl = TextEditingController(text: existente?.fechaInicio ?? '');
    _fechaFinCtrl = TextEditingController(text: existente?.fechaFin ?? '');
    _granularidad = existente?.granularidad ?? _granularidades[2];
    _esSimulado = existente?.esSimulado ?? false;
  }

  @override
  void dispose() {
    _ordenCtrl.dispose();
    _etiquetaCtrl.dispose();
    _fechaInicioCtrl.dispose();
    _fechaFinCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);

    final repositorio = context.read<PeriodoRepository>();
    final periodo = Periodo(
      id: widget.existente?.id,
      organizacionId: widget.organizacionId,
      orden: int.parse(_ordenCtrl.text.trim()),
      etiqueta: _etiquetaCtrl.text.trim(),
      fechaInicio: _fechaInicioCtrl.text.trim(),
      fechaFin: _fechaFinCtrl.text.trim(),
      granularidad: _granularidad,
      esSimulado: _esSimulado,
    );

    try {
      if (periodo.id == null) {
        await repositorio.crear(periodo);
      } else {
        await repositorio.actualizar(periodo);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _guardando = false);
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            showCloseIcon: true,
            content: Text('Ya existe un periodo con el orden ${periodo.orden} en esta organización.'),
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
      appBar: AppBar(title: Text(esNuevo ? 'Nuevo periodo' : 'Editar periodo')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _ordenCtrl,
              decoration: const InputDecoration(
                labelText: 'Orden',
                helperText: 'Posición del periodo en la secuencia -- 1, 2, 3...',
              ),
              keyboardType: TextInputType.number,
              validator: (v) {
                final n = int.tryParse(v?.trim() ?? '');
                if (n == null || n < 1) return 'Ingresa un entero positivo';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _etiquetaCtrl,
              decoration: const InputDecoration(
                labelText: 'Etiqueta',
                helperText: 'Ej. "Enero 2026", "Semana 12"',
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa una etiqueta' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _granularidad,
              decoration: const InputDecoration(labelText: 'Granularidad'),
              items: [
                for (final g in _granularidades)
                  DropdownMenuItem(value: g, child: Text(_etiquetasGranularidad[g]!)),
              ],
              onChanged: (v) => setState(() => _granularidad = v!),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _fechaInicioCtrl,
                    decoration: const InputDecoration(labelText: 'Fecha de inicio (opcional)'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _fechaFinCtrl,
                    decoration: const InputDecoration(labelText: 'Fecha de fin (opcional)'),
                  ),
                ),
              ],
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Periodo simulado'),
              subtitle: const Text('Generado por el laboratorio de escenarios, no operación real'),
              value: _esSimulado,
              onChanged: (v) => setState(() => _esSimulado = v),
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
