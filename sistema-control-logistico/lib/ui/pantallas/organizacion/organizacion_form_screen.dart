import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/organizacion.dart';
import '../../../data/repositories/organizacion_repository.dart';

const _tiposEmpresa = ['extractiva', 'manufacturera', 'servicios', 'marketing'];

const _etiquetasTipoEmpresa = {
  'extractiva': 'Extractiva',
  'manufacturera': 'Manufacturera',
  'servicios': 'De servicios',
  'marketing': 'De marketing',
};

/// Pantalla 2 (CLAUDE.md sección 9): datos de la organización, tipo de
/// empresa y moneda. Sin lista -- este sistema opera sobre una sola
/// organización por instalación, así que esta pantalla es siempre
/// crear-o-editar, nunca un CRUD de varias filas.
class OrganizacionFormScreen extends StatefulWidget {
  const OrganizacionFormScreen({super.key, this.existente});

  final Organizacion? existente;

  @override
  State<OrganizacionFormScreen> createState() => _OrganizacionFormScreenState();
}

class _OrganizacionFormScreenState extends State<OrganizacionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _monedaCtrl;
  late final TextEditingController _notasCtrl;
  late String _tipoEmpresa;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    final existente = widget.existente;
    _nombreCtrl = TextEditingController(text: existente?.nombre ?? '');
    _monedaCtrl = TextEditingController(text: existente?.moneda ?? 'PEN');
    _notasCtrl = TextEditingController(text: existente?.notas ?? '');
    _tipoEmpresa = existente?.tipoEmpresa ?? _tiposEmpresa.first;
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _monedaCtrl.dispose();
    _notasCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);

    final repositorio = context.read<OrganizacionRepository>();
    final notas = _notasCtrl.text.trim();
    final organizacion = Organizacion(
      id: widget.existente?.id,
      nombre: _nombreCtrl.text.trim(),
      moneda: _monedaCtrl.text.trim().toUpperCase(),
      tipoEmpresa: _tipoEmpresa,
      notas: notas.isEmpty ? null : notas,
    );

    late final Organizacion guardada;
    if (organizacion.id == null) {
      final id = await repositorio.crear(organizacion);
      guardada = organizacion.copyWith(id: id);
    } else {
      await repositorio.actualizar(organizacion);
      guardada = organizacion;
    }

    if (!mounted) return;
    Navigator.of(context).pop(guardada);
  }

  @override
  Widget build(BuildContext context) {
    final esNueva = widget.existente == null;
    return Scaffold(
      appBar: AppBar(title: Text(esNueva ? 'Nueva organización' : 'Editar organización')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nombreCtrl,
              decoration: const InputDecoration(labelText: 'Nombre de la organización'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa un nombre' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _tipoEmpresa,
              decoration: const InputDecoration(
                labelText: 'Tipo de empresa',
                helperText: 'El rubro de la organización, como referencia',
              ),
              items: [
                for (final tipo in _tiposEmpresa)
                  DropdownMenuItem(value: tipo, child: Text(_etiquetasTipoEmpresa[tipo]!)),
              ],
              onChanged: (v) => setState(() => _tipoEmpresa = v!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _monedaCtrl,
              decoration: const InputDecoration(
                labelText: 'Moneda',
                helperText: 'Código de tres letras, ej. PEN, USD',
              ),
              textCapitalization: TextCapitalization.characters,
              validator: (v) {
                final texto = v?.trim() ?? '';
                if (texto.length != 3) return 'Usa un código de tres letras';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notasCtrl,
              decoration: const InputDecoration(labelText: 'Notas (opcional)'),
              maxLines: 3,
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
