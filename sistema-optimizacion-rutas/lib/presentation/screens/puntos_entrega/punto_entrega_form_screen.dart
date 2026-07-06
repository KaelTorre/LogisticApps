import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../data/models/punto_entrega.dart';
import '../../../data/repositories/punto_entrega_repository.dart';
import '../_shared/selector_ubicacion_campo.dart';
import '../_shared/validadores_formulario.dart';

/// Formulario de creación/edición de un punto de entrega. Si [existente] es
/// `null` crea uno nuevo; si no, actualiza ese registro. La ubicación se
/// elige tocando el mapa (`SelectorUbicacionCampo`) — sin geocodificación de
/// direcciones (sección 11 de CLAUDE.md, fuera de alcance de este proyecto).
class PuntoEntregaFormScreen extends StatefulWidget {
  const PuntoEntregaFormScreen({super.key, this.existente});

  final PuntoEntrega? existente;

  @override
  State<PuntoEntregaFormScreen> createState() =>
      _PuntoEntregaFormScreenState();
}

class _PuntoEntregaFormScreenState extends State<PuntoEntregaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _nombreCtrl = TextEditingController(
    text: widget.existente?.nombre ?? '',
  );
  late final _demandaCtrl = TextEditingController(
    text: widget.existente != null
        ? widget.existente!.demanda.toString()
        : '0',
  );

  LatLng? _ubicacion;
  bool _mostrarErrorUbicacion = false;
  bool _guardando = false;

  bool get _esEdicion => widget.existente != null;

  @override
  void initState() {
    super.initState();
    final existente = widget.existente;
    if (existente != null) {
      _ubicacion = LatLng(existente.latitud, existente.longitud);
    }
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _demandaCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    final ubicacion = _ubicacion;
    final formValido = _formKey.currentState!.validate();
    setState(() => _mostrarErrorUbicacion = ubicacion == null);
    if (!formValido || ubicacion == null) return;

    setState(() => _guardando = true);
    final repositorio = context.read<PuntoEntregaRepository>();
    final punto = PuntoEntrega(
      id: widget.existente?.id,
      nombre: _nombreCtrl.text.trim(),
      latitud: ubicacion.latitude,
      longitud: ubicacion.longitude,
      demanda: double.parse(_demandaCtrl.text.trim()),
      ventanaInicio: widget.existente?.ventanaInicio,
      ventanaFin: widget.existente?.ventanaFin,
    );

    if (_esEdicion) {
      await repositorio.actualizar(punto);
    } else {
      await repositorio.crear(punto);
    }

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_esEdicion ? 'Editar punto de entrega' : 'Nuevo punto de entrega'),
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
                        hintText: 'Ej. Bodega San Martín',
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (valor) =>
                          validarObligatorio(valor, etiqueta: 'El nombre'),
                    ),
                    const SizedBox(height: 16),
                    SelectorUbicacionCampo(
                      ubicacion: _ubicacion,
                      mostrarError: _mostrarErrorUbicacion,
                      onElegir: (elegido) => setState(() {
                        _ubicacion = elegido;
                        _mostrarErrorUbicacion = false;
                      }),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _demandaCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Demanda (kg)',
                        hintText: 'Ej. 120',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textInputAction: TextInputAction.done,
                      validator: (valor) => validarNumeroNoNegativo(
                        valor,
                        etiqueta: 'La demanda',
                      ),
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
