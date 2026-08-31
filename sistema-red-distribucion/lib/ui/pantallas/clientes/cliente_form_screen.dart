import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constantes.dart';
import '../../../core/validadores_formulario.dart';
import '../../../data/models/cliente.dart';
import '../../../data/repositories/cliente_repository.dart';
import '../../widgets/selector_ubicacion_campo.dart';

/// Pantalla 3 (CLAUDE.md sección 8), formulario: alta/edición de cliente.
class ClienteFormScreen extends StatefulWidget {
  const ClienteFormScreen({super.key, required this.proyectoId, this.existente});

  final int proyectoId;
  final Cliente? existente;

  @override
  State<ClienteFormScreen> createState() => _ClienteFormScreenState();
}

class _ClienteFormScreenState extends State<ClienteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _nombreCtrl = TextEditingController(text: widget.existente?.nombre ?? '');
  late final _latitudCtrl = TextEditingController(
    text: widget.existente != null ? '${widget.existente!.latitud}' : '',
  );
  late final _longitudCtrl = TextEditingController(
    text: widget.existente != null ? '${widget.existente!.longitud}' : '',
  );
  late final _demandaCtrl = TextEditingController(
    text: widget.existente != null ? '${widget.existente!.demandaAnual}' : '',
  );
  late final _pedidosCtrl = TextEditingController(
    text: widget.existente != null ? '${widget.existente!.pedidosAnuales}' : '',
  );
  late bool _activo = widget.existente?.activo ?? true;
  bool _guardando = false;

  bool get _esEdicion => widget.existente != null;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _latitudCtrl.dispose();
    _longitudCtrl.dispose();
    _demandaCtrl.dispose();
    _pedidosCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);
    final repositorio = context.read<ClienteRepository>();
    final cliente = Cliente(
      id: widget.existente?.id,
      proyectoId: widget.proyectoId,
      nombre: _nombreCtrl.text.trim(),
      latitud: double.parse(_latitudCtrl.text.trim()),
      longitud: double.parse(_longitudCtrl.text.trim()),
      demandaAnual: double.parse(_demandaCtrl.text.trim()),
      pedidosAnuales: int.parse(_pedidosCtrl.text.trim()),
      activo: _activo,
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
      appBar: AppBar(title: Text(_esEdicion ? 'Editar cliente' : 'Nuevo cliente')),
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
                      controller: _demandaCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Demanda anual',
                        helperText: 'Cuánto compra o consume este cliente en un año, en la unidad del proyecto.',
                        helperMaxLines: 2,
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) =>
                          validarNumeroNoNegativo(v, etiqueta: 'La demanda anual', femenino: true),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _pedidosCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Pedidos anuales',
                        helperText: 'Cuántos pedidos separados hace este cliente en un año (no el volumen).',
                        helperMaxLines: 2,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          validarEnteroNoNegativo(v, etiqueta: 'Los pedidos anuales', plural: true),
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Activo'),
                      subtitle: const Text('Los clientes inactivos no entran en la agregación.'),
                      value: _activo,
                      onChanged: (v) => setState(() => _activo = v),
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
