import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constantes.dart';
import '../../../core/dinero_utils.dart';
import '../../../core/validadores_formulario.dart';
import '../../../data/models/sitio_candidato.dart';
import '../../../data/repositories/sitio_candidato_repository.dart';
import '../../widgets/selector_ubicacion_campo.dart';

/// Pantalla 6 (CLAUDE.md sección 8), formulario: alta/edición de sitio
/// candidato. La generación automática por centro de gravedad (M2) vive en
/// `CandidatosScreen` y solo se activa desde la Fase 3, cuando existen
/// zonas de demanda que agregar — acá siempre se completa a mano.
class CandidatoFormScreen extends StatefulWidget {
  const CandidatoFormScreen({super.key, required this.proyectoId, this.existente});

  final int proyectoId;
  final SitioCandidato? existente;

  @override
  State<CandidatoFormScreen> createState() => _CandidatoFormScreenState();
}

class _CandidatoFormScreenState extends State<CandidatoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _nombreCtrl = TextEditingController(text: widget.existente?.nombre ?? '');
  late final _latitudCtrl = TextEditingController(
    text: widget.existente != null ? '${widget.existente!.latitud}' : '',
  );
  late final _longitudCtrl = TextEditingController(
    text: widget.existente != null ? '${widget.existente!.longitud}' : '',
  );
  late final _costoFijoCtrl = TextEditingController(
    text: widget.existente != null ? centimosATexto(widget.existente!.costoFijoAnualCent) : '',
  );
  late final _capacidadCtrl = TextEditingController(
    text: widget.existente != null ? '${widget.existente!.capacidadAnual}' : '',
  );
  late final _costoVariableCtrl = TextEditingController(
    text: widget.existente != null
        ? centimosATexto(widget.existente!.costoVariableManejoCentPorUnidad)
        : '',
  );
  late bool _esRedActual = widget.existente?.esRedActual ?? false;
  bool _guardando = false;

  bool get _esEdicion => widget.existente != null;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _latitudCtrl.dispose();
    _longitudCtrl.dispose();
    _costoFijoCtrl.dispose();
    _capacidadCtrl.dispose();
    _costoVariableCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);
    final repositorio = context.read<SitioCandidatoRepository>();
    final candidato = SitioCandidato(
      id: widget.existente?.id,
      proyectoId: widget.proyectoId,
      nombre: _nombreCtrl.text.trim(),
      latitud: double.parse(_latitudCtrl.text.trim()),
      longitud: double.parse(_longitudCtrl.text.trim()),
      costoFijoAnualCent: aCentimos(_costoFijoCtrl.text),
      capacidadAnual: double.parse(_capacidadCtrl.text.trim()),
      costoVariableManejoCentPorUnidad: aCentimos(_costoVariableCtrl.text),
      origen: widget.existente?.origen ?? 'manual',
      esRedActual: _esRedActual,
    );

    if (_esEdicion) {
      await repositorio.actualizar(candidato);
    } else {
      await repositorio.crear(candidato);
    }

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final esGeneradoPorCentroGravedad = widget.existente?.origen == 'centro_gravedad';

    return Scaffold(
      appBar: AppBar(
        title: Text(_esEdicion ? 'Editar sitio candidato' : 'Nuevo sitio candidato'),
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
                    if (esGeneradoPorCentroGravedad)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Card(
                          color: Theme.of(context).colorScheme.secondaryContainer,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              'Este punto fue sugerido por el algoritmo de centro de '
                              'gravedad — puede caer en un lugar no edificable. '
                              'Verificalo antes de tomarlo como decisión final.',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSecondaryContainer,
                              ),
                            ),
                          ),
                        ),
                      ),
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
                      controller: _costoFijoCtrl,
                      decoration: const InputDecoration(labelText: 'Costo fijo anual'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) => validarNumeroNoNegativo(v, etiqueta: 'El costo fijo anual'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _capacidadCtrl,
                      decoration: const InputDecoration(labelText: 'Capacidad anual'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) => validarNumeroNoNegativo(v, etiqueta: 'La capacidad anual'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _costoVariableCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Costo variable de manejo por unidad',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) =>
                          validarNumeroNoNegativo(v, etiqueta: 'El costo variable de manejo'),
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Es parte de la red actual'),
                      subtitle: const Text('Marca los sitios que ya operan hoy, para comparar '
                          'contra la red propuesta.'),
                      value: _esRedActual,
                      onChanged: (v) => setState(() => _esRedActual = v),
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
