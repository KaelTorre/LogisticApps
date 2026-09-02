import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/indicador.dart';
import '../../../data/repositories/indicador_repository.dart';

const _categorias = ['costo', 'servicio', 'productividad'];
const _etiquetasCategoria = {
  'costo': 'Costo',
  'servicio': 'Servicio',
  'productividad': 'Productividad',
};

const _granularidades = ['diario', 'semanal', 'mensual', 'trimestral'];
const _etiquetasGranularidad = {
  'diario': 'Diario',
  'semanal': 'Semanal',
  'mensual': 'Mensual',
  'trimestral': 'Trimestral',
};

const _sentidos = ['menor_mejor', 'mayor_mejor'];
const _etiquetasSentido = {
  'menor_mejor': 'Menor es mejor',
  'mayor_mejor': 'Mayor es mejor',
};

/// Formulario de alta/edición de un indicador (Pantalla 4). `sentido`
/// define qué lado de la banda es adverso -- el corazón de M1 (CLAUDE.md
/// sección 8: "toda regla se escribe en términos de 'adverso', nunca de
/// 'mayor'"), así que se pide con las dos opciones en lenguaje llano, no
/// como los literales internos.
class IndicadorFormScreen extends StatefulWidget {
  const IndicadorFormScreen({super.key, required this.organizacionId, this.existente});

  final int organizacionId;
  final Indicador? existente;

  @override
  State<IndicadorFormScreen> createState() => _IndicadorFormScreenState();
}

class _IndicadorFormScreenState extends State<IndicadorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codigoCtrl;
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _unidadCtrl;
  late final TextEditingController _decimalesCtrl;
  late final TextEditingController _metaCtrl;
  late final TextEditingController _bandaInferiorCtrl;
  late final TextEditingController _bandaSuperiorCtrl;
  late final TextEditingController _procesoCtrl;
  late String _categoria;
  late String _granularidad;
  late String _sentido;
  late bool _activo;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    final existente = widget.existente;
    _codigoCtrl = TextEditingController(text: existente?.codigo ?? '');
    _nombreCtrl = TextEditingController(text: existente?.nombre ?? '');
    _unidadCtrl = TextEditingController(text: existente?.unidad ?? '');
    _decimalesCtrl = TextEditingController(text: (existente?.decimales ?? 2).toString());
    _metaCtrl = TextEditingController(text: existente?.meta.toString() ?? '');
    _bandaInferiorCtrl = TextEditingController(text: existente?.bandaInferior.toString() ?? '');
    _bandaSuperiorCtrl = TextEditingController(text: existente?.bandaSuperior.toString() ?? '');
    _procesoCtrl = TextEditingController(text: existente?.proceso ?? '');
    _categoria = existente?.categoria ?? _categorias.first;
    _granularidad = existente?.granularidad ?? _granularidades[2];
    _sentido = existente?.sentido ?? _sentidos.first;
    _activo = existente?.activo ?? true;
  }

  @override
  void dispose() {
    _codigoCtrl.dispose();
    _nombreCtrl.dispose();
    _unidadCtrl.dispose();
    _decimalesCtrl.dispose();
    _metaCtrl.dispose();
    _bandaInferiorCtrl.dispose();
    _bandaSuperiorCtrl.dispose();
    _procesoCtrl.dispose();
    super.dispose();
  }

  double? _num(String texto) => double.tryParse(texto.trim());

  String? _validarBanda() {
    final inferior = _num(_bandaInferiorCtrl.text);
    final superior = _num(_bandaSuperiorCtrl.text);
    if (inferior == null || superior == null) return null;
    if (superior <= inferior) return 'La banda superior debe ser mayor que la inferior';
    return null;
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    final errorBanda = _validarBanda();
    if (errorBanda != null) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(showCloseIcon: true, content: Text(errorBanda)));
      return;
    }
    setState(() => _guardando = true);

    final repositorio = context.read<IndicadorRepository>();
    final indicador = Indicador(
      id: widget.existente?.id,
      organizacionId: widget.organizacionId,
      codigo: _codigoCtrl.text.trim(),
      nombre: _nombreCtrl.text.trim(),
      categoria: _categoria,
      unidad: _unidadCtrl.text.trim(),
      decimales: int.parse(_decimalesCtrl.text.trim()),
      sentido: _sentido,
      meta: _num(_metaCtrl.text)!,
      bandaInferior: _num(_bandaInferiorCtrl.text)!,
      bandaSuperior: _num(_bandaSuperiorCtrl.text)!,
      granularidad: _granularidad,
      proceso: _procesoCtrl.text.trim(),
      activo: _activo,
    );

    try {
      if (indicador.id == null) {
        await repositorio.crear(indicador);
      } else {
        await repositorio.actualizar(indicador);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _guardando = false);
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            showCloseIcon: true,
            content: Text('Ya existe un indicador con el código "${indicador.codigo}" en esta organización.'),
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
      appBar: AppBar(title: Text(esNuevo ? 'Nuevo indicador' : 'Editar indicador')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _codigoCtrl,
              decoration: const InputDecoration(
                labelText: 'Código',
                helperText: 'Identificador corto, ej. "COSTO-TRANS"',
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa un código' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nombreCtrl,
              decoration: const InputDecoration(labelText: 'Nombre'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa un nombre' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _categoria,
              decoration: const InputDecoration(
                labelText: 'Categoría',
                helperText: 'Determina en qué informe aparece: Costo y servicio, o Productividad',
              ),
              items: [
                for (final c in _categorias)
                  DropdownMenuItem(value: c, child: Text(_etiquetasCategoria[c]!)),
              ],
              onChanged: (v) => setState(() => _categoria = v!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _procesoCtrl,
              decoration: const InputDecoration(
                labelText: 'Proceso',
                helperText: 'Ej. "Transporte", "Almacenamiento"',
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa un proceso' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _unidadCtrl,
                    decoration: const InputDecoration(labelText: 'Unidad', helperText: 'Ej. "S/ / ton"'),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa una unidad' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _decimalesCtrl,
                    decoration: const InputDecoration(labelText: 'Decimales'),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      final n = int.tryParse(v?.trim() ?? '');
                      if (n == null || n < 0) return 'Entero ≥ 0';
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _sentido,
              decoration: const InputDecoration(
                labelText: 'Sentido de mejora',
                helperText: 'Si un valor alto es un problema (ej. costos) elige "Menor es mejor"; '
                    'si un valor alto es bueno (ej. cumplimiento) elige "Mayor es mejor"',
                helperMaxLines: 2,
              ),
              items: [
                for (final s in _sentidos) DropdownMenuItem(value: s, child: Text(_etiquetasSentido[s]!)),
              ],
              onChanged: (v) => setState(() => _sentido = v!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _metaCtrl,
              decoration: const InputDecoration(
                labelText: 'Meta',
                helperText: 'El valor esperado de este indicador en condiciones normales',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
              validator: (v) => _num(v ?? '') == null ? 'Ingresa un número' : null,
            ),
            const SizedBox(height: 16),
            Text(
              'Banda de tolerancia: el rango alrededor de la meta que todavía se considera normal. '
              'Un valor fuera de este rango se marca como desviación.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _bandaInferiorCtrl,
                    decoration: const InputDecoration(labelText: 'Banda inferior'),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                    validator: (v) => _num(v ?? '') == null ? 'Ingresa un número' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _bandaSuperiorCtrl,
                    decoration: const InputDecoration(labelText: 'Banda superior'),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                    validator: (v) => _num(v ?? '') == null ? 'Ingresa un número' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _granularidad,
              decoration: const InputDecoration(
                labelText: 'Granularidad',
                helperText: 'Con qué frecuencia se mide este indicador',
              ),
              items: [
                for (final g in _granularidades)
                  DropdownMenuItem(value: g, child: Text(_etiquetasGranularidad[g]!)),
              ],
              onChanged: (v) => setState(() => _granularidad = v!),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Activo'),
              subtitle: const Text('Los indicadores inactivos no se evalúan'),
              value: _activo,
              onChanged: (v) => setState(() => _activo = v),
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
