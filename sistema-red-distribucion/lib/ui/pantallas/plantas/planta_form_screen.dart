import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constantes.dart';
import '../../../core/dinero_utils.dart';
import '../../../core/validadores_formulario.dart';
import '../../../data/models/planta.dart';
import '../../../data/repositories/planta_repository.dart';
import '../../widgets/selector_ubicacion_campo.dart';

/// Pantalla 7 (CLAUDE.md sección 8), formulario: alta/edición de planta.
class PlantaFormScreen extends StatefulWidget {
  const PlantaFormScreen({super.key, required this.proyectoId, this.existente});

  final int proyectoId;
  final Planta? existente;

  @override
  State<PlantaFormScreen> createState() => _PlantaFormScreenState();
}

class _PlantaFormScreenState extends State<PlantaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _nombreCtrl = TextEditingController(text: widget.existente?.nombre ?? '');
  late final _latitudCtrl = TextEditingController(
    text: widget.existente != null ? '${widget.existente!.latitud}' : '',
  );
  late final _longitudCtrl = TextEditingController(
    text: widget.existente != null ? '${widget.existente!.longitud}' : '',
  );
  late final _capacidadCtrl = TextEditingController(
    text: widget.existente != null ? '${widget.existente!.capacidadAnual}' : '',
  );
  late final _costoProduccionCtrl = TextEditingController(
    text: widget.existente != null
        ? centimosATexto(widget.existente!.costoProduccionCentPorUnidad)
        : '',
  );
  bool _guardando = false;

  bool get _esEdicion => widget.existente != null;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _latitudCtrl.dispose();
    _longitudCtrl.dispose();
    _capacidadCtrl.dispose();
    _costoProduccionCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);
    final repositorio = context.read<PlantaRepository>();
    final planta = Planta(
      id: widget.existente?.id,
      proyectoId: widget.proyectoId,
      nombre: _nombreCtrl.text.trim(),
      latitud: double.parse(_latitudCtrl.text.trim()),
      longitud: double.parse(_longitudCtrl.text.trim()),
      capacidadAnual: double.parse(_capacidadCtrl.text.trim()),
      costoProduccionCentPorUnidad: aCentimos(_costoProduccionCtrl.text),
    );

    if (_esEdicion) {
      await repositorio.actualizar(planta);
    } else {
      await repositorio.crear(planta);
    }

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_esEdicion ? 'Editar planta' : 'Nueva planta')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nombreCtrl,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                      textInputAction: TextInputAction.next,
                      validator: (v) => validarObligatorio(v, etiqueta: 'El nombre'),
                    ),
                    const SizedBox(height: 16),
                    SelectorUbicacionCampo(
                      latitudCtrl: _latitudCtrl,
                      longitudCtrl: _longitudCtrl,
                      centroPorDefecto: centroMapaPorDefecto,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _capacidadCtrl,
                      decoration: const InputDecoration(labelText: 'Capacidad anual'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) =>
                          validarNumeroNoNegativo(v, etiqueta: 'La capacidad anual', femenino: true),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _costoProduccionCtrl,
                      decoration: const InputDecoration(labelText: 'Costo de producción por unidad'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) =>
                          validarNumeroNoNegativo(v, etiqueta: 'El costo de producción'),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _guardando ? null : _guardar,
                      child: Text(_guardando ? 'Guardando...' : 'Guardar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
