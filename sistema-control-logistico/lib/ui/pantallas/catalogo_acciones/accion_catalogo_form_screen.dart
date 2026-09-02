import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/accion_catalogo.dart';
import '../../../data/models/regla_accion.dart';
import '../../../data/repositories/accion_catalogo_repository.dart';
import '../../../data/repositories/regla_accion_repository.dart';

const _categorias = ['costo', 'servicio', 'productividad'];
const _etiquetasCategoria = {
  'costo': 'Costo',
  'servicio': 'Servicio',
  'productividad': 'Productividad',
};

const _magnitudes = ['ajuste_menor', 'replaneacion_mayor', 'contingencia'];
const _etiquetasMagnitud = {
  'ajuste_menor': 'Ajuste menor',
  'replaneacion_mayor': 'Replaneación mayor',
  'contingencia': 'Contingencia',
};

const _reglas = ['R1', 'R2', 'R3', 'R4', 'R5', 'R6'];
const _etiquetasRegla = {
  'R1': 'R1 · Punto fuera de banda',
  'R2': 'R2 · Racha en el lado adverso',
  'R3': 'R3 · Corrimiento de media',
  'R4': 'R4 · Tendencia sostenida',
  'R5': 'R5 · Deterioro brusco',
  'R6': 'R6 · Dispersión creciente',
};

/// Alta/edición de una acción del catálogo (`accion_catalogo`) y sus
/// reglas disparadoras (`regla_accion`). Categoría y magnitud definen el
/// escenario al que responde -- cada regla marcada agrega una fila de
/// `regla_accion` con esa misma categoría/magnitud, que es lo que M3
/// (`emparejarAcciones`) consulta en tiempo real. Al guardar se
/// reescriben todos los mapeos de esta acción de una vez, nunca se
/// difieren -- más simple que comparar cuáles cambiaron y evita dejar
/// mapeos huérfanos con una categoría/magnitud vieja si se editan.
class AccionCatalogoFormScreen extends StatefulWidget {
  const AccionCatalogoFormScreen({
    super.key,
    this.existente,
    this.categoriaInicial,
    this.magnitudInicial,
    this.reglasIniciales = const {},
    this.prioridadInicial = 1,
  });

  final AccionCatalogo? existente;
  final String? categoriaInicial;
  final String? magnitudInicial;
  final Set<String> reglasIniciales;
  final int prioridadInicial;

  @override
  State<AccionCatalogoFormScreen> createState() => _AccionCatalogoFormScreenState();
}

class _AccionCatalogoFormScreenState extends State<AccionCatalogoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codigoCtrl;
  late final TextEditingController _tituloCtrl;
  late final TextEditingController _descripcionCtrl;
  late final TextEditingController _aplicacionExternaCtrl;
  late final TextEditingController _prioridadCtrl;
  late String _categoria;
  late String _magnitud;
  late Set<String> _reglasSeleccionadas;
  bool _guardando = false;
  bool _eliminando = false;
  String? _errorReglas;

  @override
  void initState() {
    super.initState();
    final existente = widget.existente;
    _codigoCtrl = TextEditingController(text: existente?.codigo ?? '');
    _tituloCtrl = TextEditingController(text: existente?.titulo ?? '');
    _descripcionCtrl = TextEditingController(text: existente?.descripcion ?? '');
    _aplicacionExternaCtrl = TextEditingController(text: existente?.aplicacionExternaSugerida ?? '');
    _prioridadCtrl = TextEditingController(text: widget.prioridadInicial.toString());
    _categoria = existente?.categoriaIndicador ?? widget.categoriaInicial ?? _categorias.first;
    _magnitud = existente?.magnitudTipica ?? widget.magnitudInicial ?? _magnitudes.first;
    _reglasSeleccionadas = {...widget.reglasIniciales};
  }

  @override
  void dispose() {
    _codigoCtrl.dispose();
    _tituloCtrl.dispose();
    _descripcionCtrl.dispose();
    _aplicacionExternaCtrl.dispose();
    _prioridadCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    final formValida = _formKey.currentState!.validate();
    final reglasValidas = _reglasSeleccionadas.isNotEmpty;
    setState(() => _errorReglas = reglasValidas ? null : 'Marca al menos una regla');
    if (!formValida || !reglasValidas) return;

    final accionRepo = context.read<AccionCatalogoRepository>();
    final reglaAccionRepo = context.read<ReglaAccionRepository>();
    final codigo = _codigoCtrl.text.trim();

    final existentes = await accionRepo.obtenerTodas();
    final yaExiste = existentes.any(
      (a) => a.id != widget.existente?.id && a.codigo.toLowerCase() == codigo.toLowerCase(),
    );
    if (!mounted) return;
    if (yaExiste) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(showCloseIcon: true, content: Text('Ya existe una acción con el código "$codigo".')),
        );
      return;
    }

    setState(() => _guardando = true);

    final prioridad = int.parse(_prioridadCtrl.text.trim());
    final aplicacionExterna = _aplicacionExternaCtrl.text.trim();
    final accion = AccionCatalogo(
      id: widget.existente?.id,
      codigo: codigo,
      titulo: _tituloCtrl.text.trim(),
      descripcion: _descripcionCtrl.text.trim(),
      categoriaIndicador: _categoria,
      magnitudTipica: _magnitud,
      esDeSistema: widget.existente?.esDeSistema ?? false,
      aplicacionExternaSugerida: aplicacionExterna.isEmpty ? null : aplicacionExterna,
    );

    final int accionId;
    if (accion.id == null) {
      accionId = await accionRepo.crear(accion);
    } else {
      accionId = accion.id!;
      await accionRepo.actualizar(accion);
      for (final mapeo in await reglaAccionRepo.obtenerTodas()) {
        if (mapeo.accionId == accionId) await reglaAccionRepo.eliminar(mapeo.id!);
      }
    }
    for (final regla in _reglasSeleccionadas) {
      await reglaAccionRepo.crear(
        ReglaAccion(
          categoriaIndicador: _categoria,
          reglaDisparada: regla,
          clasificacion: _magnitud,
          accionId: accionId,
          prioridad: prioridad,
        ),
      );
    }

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  Future<void> _eliminar() async {
    final existente = widget.existente;
    if (existente == null) return;
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar acción'),
        content: Text(
          '¿Eliminar "${existente.titulo}" del catálogo? Dejará de proponerse para cualquier escenario. '
          'Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancelar')),
          FilledButton.tonal(onPressed: () => Navigator.of(context).pop(true), child: const Text('Eliminar')),
        ],
      ),
    );
    if (confirmado != true || !mounted) return;

    setState(() => _eliminando = true);
    try {
      await context.read<AccionCatalogoRepository>().eliminar(existente.id!);
    } catch (_) {
      if (!mounted) return;
      setState(() => _eliminando = false);
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            showCloseIcon: true,
            content: Text('No se puede eliminar: ya hay acciones tomadas que la usan.'),
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
      appBar: AppBar(
        title: Text(esNuevo ? 'Nueva acción' : 'Editar acción'),
        actions: [
          if (!esNuevo)
            IconButton(
              icon: _eliminando
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.delete_outline),
              tooltip: 'Eliminar',
              onPressed: _eliminando ? null : _eliminar,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _codigoCtrl,
              enabled: esNuevo,
              decoration: InputDecoration(
                labelText: 'Código',
                helperText: esNuevo
                    ? 'Identificador corto, ej. "AC-COSTO-AJUS-2"'
                    : 'No se puede cambiar después de crearla',
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa un código' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _tituloCtrl,
              decoration: const InputDecoration(
                labelText: 'Título',
                helperText: 'Una instrucción concreta, ej. "Renegociar la tarifa del transportista X"',
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa un título' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descripcionCtrl,
              decoration: const InputDecoration(labelText: 'Descripción'),
              maxLines: 3,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa una descripción' : null,
            ),
            const SizedBox(height: 16),
            Text(
              'Escenario: para qué combinación de categoría y magnitud se propone esta acción.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _categoria,
                    decoration: const InputDecoration(labelText: 'Categoría'),
                    items: [
                      for (final c in _categorias)
                        DropdownMenuItem(value: c, child: Text(_etiquetasCategoria[c]!)),
                    ],
                    onChanged: (v) => setState(() => _categoria = v!),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _magnitud,
                    decoration: const InputDecoration(labelText: 'Magnitud'),
                    items: [
                      for (final m in _magnitudes)
                        DropdownMenuItem(value: m, child: Text(_etiquetasMagnitud[m]!)),
                    ],
                    onChanged: (v) => setState(() => _magnitud = v!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Reglas que la disparan: si alguna de las marcadas es de las que dispararon la '
              'evaluación, esta acción aparece como propuesta.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final regla in _reglas)
                  FilterChip(
                    label: Text(_etiquetasRegla[regla]!),
                    selected: _reglasSeleccionadas.contains(regla),
                    onSelected: (marcado) => setState(() {
                      if (marcado) {
                        _reglasSeleccionadas.add(regla);
                      } else {
                        _reglasSeleccionadas.remove(regla);
                      }
                      _errorReglas = null;
                    }),
                  ),
              ],
            ),
            if (_errorReglas != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  _errorReglas!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
                ),
              ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _prioridadCtrl,
              decoration: const InputDecoration(
                labelText: 'Prioridad',
                helperText: 'Si varias acciones aplican al mismo escenario, la de número más bajo se '
                    'ofrece primero',
              ),
              keyboardType: TextInputType.number,
              validator: (v) {
                final n = int.tryParse(v?.trim() ?? '');
                if (n == null || n < 1) return 'Entero ≥ 1';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _aplicacionExternaCtrl,
              decoration: const InputDecoration(
                labelText: 'Aplicación externa sugerida (opcional)',
                helperText: 'Si esta acción apunta a otro sistema del repositorio, descríbelo acá',
              ),
              maxLines: 2,
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
