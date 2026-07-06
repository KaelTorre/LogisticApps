import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../data/models/vehiculo.dart';
import '../../../data/repositories/vehiculo_repository.dart';
import '../_shared/validadores_formulario.dart';

/// Formulario de creación/edición de un vehículo (sección 8 de CLAUDE.md):
/// nombre, capacidad máxima, costo por km (opcional) y tipo de flota
/// (informativo).
class VehiculoFormScreen extends StatefulWidget {
  const VehiculoFormScreen({super.key, this.existente});

  final Vehiculo? existente;

  @override
  State<VehiculoFormScreen> createState() => _VehiculoFormScreenState();
}

class _VehiculoFormScreenState extends State<VehiculoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _nombreCtrl = TextEditingController(
    text: widget.existente?.nombre ?? '',
  );
  late final _capacidadCtrl = TextEditingController(
    text: widget.existente?.capacidadMaxima.toString() ?? '',
  );
  late final _costoCtrl = TextEditingController(
    text: widget.existente?.costoEstimadoPorKm?.toString() ?? '',
  );
  String? _tipoFlota;

  bool _guardando = false;

  bool get _esEdicion => widget.existente != null;

  @override
  void initState() {
    super.initState();
    _tipoFlota = widget.existente?.tipoFlota;
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _capacidadCtrl.dispose();
    _costoCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);
    final repositorio = context.read<VehiculoRepository>();
    final costoTexto = _costoCtrl.text.trim();
    final vehiculo = Vehiculo(
      id: widget.existente?.id,
      nombre: _nombreCtrl.text.trim(),
      capacidadMaxima: double.parse(_capacidadCtrl.text.trim()),
      costoEstimadoPorKm: costoTexto.isEmpty ? null : double.parse(costoTexto),
      tipoFlota: _tipoFlota,
    );

    if (_esEdicion) {
      await repositorio.actualizar(vehiculo);
    } else {
      await repositorio.crear(vehiculo);
    }

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_esEdicion ? 'Editar vehículo' : 'Nuevo vehículo'),
      ),
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
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                        hintText: 'Ej. Camioneta 1',
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (valor) =>
                          validarObligatorio(valor, etiqueta: 'El nombre'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _capacidadCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Capacidad máxima (kg)',
                        hintText: 'Ej. 1500',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (valor) => validarNumeroNoNegativo(
                        valor,
                        etiqueta: 'La capacidad máxima',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _costoCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Costo estimado por km (S/) — opcional',
                        hintText: 'Ej. 1.8',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (valor) => validarNumeroNoNegativo(
                        valor,
                        etiqueta: 'El costo por km',
                        requerido: false,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String?>(
                      initialValue: _tipoFlota,
                      decoration: const InputDecoration(
                        labelText: 'Tipo de flota — opcional',
                      ),
                      items: const [
                        DropdownMenuItem(value: null, child: Text('Sin especificar')),
                        DropdownMenuItem(value: 'propia', child: Text('Propia')),
                        DropdownMenuItem(
                          value: 'tercerizada',
                          child: Text('Tercerizada'),
                        ),
                      ],
                      onChanged: (valor) => setState(() => _tipoFlota = valor),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _guardando ? null : _guardar,
                      icon: _guardando
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(LucideIcons.save),
                      label: Text(_guardando ? 'Guardando...' : 'Guardar'),
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
