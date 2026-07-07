import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../data/models/cliente.dart';
import '../../../data/repositories/cliente_repository.dart';
import '../_shared/validadores_formulario.dart';

/// Formulario de creación/edición de cliente. Si [existente] es `null`
/// crea uno nuevo; si no, actualiza ese registro.
class ClienteFormScreen extends StatefulWidget {
  const ClienteFormScreen({super.key, this.existente});

  final Cliente? existente;

  @override
  State<ClienteFormScreen> createState() => _ClienteFormScreenState();
}

class _ClienteFormScreenState extends State<ClienteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _nombreCtrl = TextEditingController(
    text: widget.existente?.nombre ?? '',
  );
  late final _contactoCtrl = TextEditingController(
    text: widget.existente?.contacto ?? '',
  );
  late final _notasCtrl = TextEditingController(
    text: widget.existente?.notas ?? '',
  );

  bool _guardando = false;

  bool get _esEdicion => widget.existente != null;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _contactoCtrl.dispose();
    _notasCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);
    final repositorio = context.read<ClienteRepository>();
    final cliente = Cliente(
      id: widget.existente?.id,
      nombre: _nombreCtrl.text.trim(),
      contacto: _contactoCtrl.text.trim().isEmpty
          ? null
          : _contactoCtrl.text.trim(),
      notas: _notasCtrl.text.trim().isEmpty ? null : _notasCtrl.text.trim(),
    );

    if (_esEdicion) {
      await repositorio.actualizar(cliente);
    } else {
      await repositorio.crear(cliente);
    }

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_esEdicion ? 'Editar cliente' : 'Nuevo cliente'),
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
                        hintText: 'Ej. Distribuidora Andina S.A.C.',
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (valor) =>
                          validarObligatorio(valor, etiqueta: 'El nombre'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _contactoCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Contacto (opcional)',
                        hintText: 'Teléfono, correo, etc.',
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _notasCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Notas (opcional)',
                      ),
                      maxLines: 3,
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
