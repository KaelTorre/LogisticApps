import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/validadores_formulario.dart';
import '../../../data/models/proyecto.dart';
import '../../../data/repositories/proyecto_repository.dart';

const _monedas = ['PEN', 'USD', 'EUR', 'MXN', 'COP', 'CLP'];
const _unidadesPeso = ['toneladas', 'kilogramos', 'unidades'];

/// Pantalla 2 (CLAUDE.md sección 8): alta y edición de proyecto — nombre,
/// moneda, unidad de peso, horizonte y factor de circuidad.
class ProyectoFormScreen extends StatefulWidget {
  const ProyectoFormScreen({super.key, this.existente});

  final Proyecto? existente;

  @override
  State<ProyectoFormScreen> createState() => _ProyectoFormScreenState();
}

class _ProyectoFormScreenState extends State<ProyectoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _nombreCtrl = TextEditingController(text: widget.existente?.nombre ?? '');
  late final _horizonteCtrl = TextEditingController(
    text: '${widget.existente?.horizonteAnios ?? 5}',
  );
  late final _factorCircuidadCtrl = TextEditingController(
    text: '${widget.existente?.factorCircuidad ?? 1.30}',
  );

  late String _moneda = widget.existente?.moneda ?? 'PEN';
  late String _unidadPeso = widget.existente?.unidadPeso ?? 'toneladas';
  bool _guardando = false;

  bool get _esEdicion => widget.existente != null;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _horizonteCtrl.dispose();
    _factorCircuidadCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);
    final repositorio = context.read<ProyectoRepository>();
    final proyecto = Proyecto(
      id: widget.existente?.id,
      nombre: _nombreCtrl.text.trim(),
      moneda: _moneda,
      unidadPeso: _unidadPeso,
      horizonteAnios: int.parse(_horizonteCtrl.text.trim()),
      factorCircuidad: double.parse(_factorCircuidadCtrl.text.trim()),
      creadoEn: widget.existente?.creadoEn ?? DateTime.now().toIso8601String(),
    );

    int id;
    if (_esEdicion) {
      await repositorio.actualizar(proyecto);
      id = proyecto.id!;
    } else {
      id = await repositorio.crear(proyecto);
    }

    if (!mounted) return;
    Navigator.of(context).pop(proyecto.copyWith(id: id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_esEdicion ? 'Editar proyecto' : 'Nuevo proyecto')),
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
                        labelText: 'Nombre del proyecto',
                        hintText: 'Ej. Red norte 2026',
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (v) => validarObligatorio(v, etiqueta: 'El nombre'),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _moneda,
                            decoration: const InputDecoration(labelText: 'Moneda'),
                            items: _monedas
                                .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                                .toList(),
                            onChanged: (v) => setState(() => _moneda = v!),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _unidadPeso,
                            decoration: const InputDecoration(labelText: 'Unidad de peso'),
                            items: _unidadesPeso
                                .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                                .toList(),
                            onChanged: (v) => setState(() => _unidadPeso = v!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        'Todas las tarifas del proyecto se cargan en esta unidad. '
                        'No hay conversión automática entre proyectos.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _horizonteCtrl,
                      decoration: const InputDecoration(labelText: 'Horizonte (años)'),
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          validarEnteroNoNegativo(v, etiqueta: 'El horizonte'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _factorCircuidadCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Factor de circuidad',
                        helperText: 'Usado como respaldo cuando no hay red ni caché '
                            '(distancia en línea recta × este factor). Default 1.30.',
                        helperMaxLines: 2,
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) =>
                          validarNumeroNoNegativo(v, etiqueta: 'El factor de circuidad'),
                    ),
                    const SizedBox(height: 24),
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
