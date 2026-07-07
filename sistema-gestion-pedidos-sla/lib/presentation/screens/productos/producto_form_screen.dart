import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/constants.dart';
import '../../../data/models/producto.dart';
import '../../../data/repositories/producto_repository.dart';
import '../_shared/validadores_formulario.dart';

/// Formulario de creación/edición de producto. Si [existente] es `null`
/// crea uno nuevo; si no, actualiza ese registro.
class ProductoFormScreen extends StatefulWidget {
  const ProductoFormScreen({super.key, this.existente});

  final Producto? existente;

  @override
  State<ProductoFormScreen> createState() => _ProductoFormScreenState();
}

class _ProductoFormScreenState extends State<ProductoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _nombreCtrl = TextEditingController(
    text: widget.existente?.nombre ?? '',
  );
  late final _pesoCtrl = TextEditingController(
    text: widget.existente?.peso?.toString() ?? '',
  );
  late final _volumenCtrl = TextEditingController(
    text: widget.existente?.volumen?.toString() ?? '',
  );
  late final _valorUnitarioCtrl = TextEditingController(
    text: widget.existente?.valorUnitario.toString() ?? '',
  );
  late final _metodoFijacionCtrl = TextEditingController(
    text: widget.existente?.metodoFijacionPrecio ?? '',
  );

  late CategoriaProducto _categoria =
      widget.existente?.categoria ?? CategoriaProducto.conveniencia;
  late EtapaCicloVida? _etapaCicloVida = widget.existente?.etapaCicloVida;

  bool _guardando = false;

  bool get _esEdicion => widget.existente != null;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _pesoCtrl.dispose();
    _volumenCtrl.dispose();
    _valorUnitarioCtrl.dispose();
    _metodoFijacionCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);
    final repositorio = context.read<ProductoRepository>();
    final producto = Producto(
      id: widget.existente?.id,
      nombre: _nombreCtrl.text.trim(),
      categoria: _categoria,
      peso: _pesoCtrl.text.trim().isEmpty
          ? null
          : double.parse(_pesoCtrl.text.trim()),
      volumen: _volumenCtrl.text.trim().isEmpty
          ? null
          : double.parse(_volumenCtrl.text.trim()),
      valorUnitario: double.parse(_valorUnitarioCtrl.text.trim()),
      metodoFijacionPrecio: _metodoFijacionCtrl.text.trim().isEmpty
          ? null
          : _metodoFijacionCtrl.text.trim(),
      etapaCicloVida: _etapaCicloVida,
    );

    if (_esEdicion) {
      await repositorio.actualizar(producto);
    } else {
      await repositorio.crear(producto);
    }

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_esEdicion ? 'Editar producto' : 'Nuevo producto'),
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
                      decoration: const InputDecoration(labelText: 'Nombre'),
                      textInputAction: TextInputAction.next,
                      validator: (valor) =>
                          validarObligatorio(valor, etiqueta: 'El nombre'),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<CategoriaProducto>(
                      initialValue: _categoria,
                      decoration: const InputDecoration(labelText: 'Categoría'),
                      items: [
                        for (final categoria in CategoriaProducto.values)
                          DropdownMenuItem(
                            value: categoria,
                            child: Text(categoria.etiqueta),
                          ),
                      ],
                      onChanged: (valor) =>
                          setState(() => _categoria = valor!),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _valorUnitarioCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Valor unitario',
                        prefixText: 'S/ ',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (valor) => validarNumeroNoNegativo(
                        valor,
                        etiqueta: 'El valor unitario',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _pesoCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Peso (opcional)',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            validator: (valor) => validarNumeroNoNegativo(
                              valor,
                              etiqueta: 'El peso',
                              requerido: false,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _volumenCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Volumen (opcional)',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            validator: (valor) => validarNumeroNoNegativo(
                              valor,
                              etiqueta: 'El volumen',
                              requerido: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _metodoFijacionCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Método de fijación de precio (opcional)',
                        hintText: 'Ej. LAB en planta',
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<EtapaCicloVida?>(
                      initialValue: _etapaCicloVida,
                      decoration: const InputDecoration(
                        labelText: 'Etapa de ciclo de vida (opcional)',
                      ),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('—')),
                        for (final etapa in EtapaCicloVida.values)
                          DropdownMenuItem(
                            value: etapa,
                            child: Text(etapa.etiqueta),
                          ),
                      ],
                      onChanged: (valor) =>
                          setState(() => _etapaCicloVida = valor),
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
