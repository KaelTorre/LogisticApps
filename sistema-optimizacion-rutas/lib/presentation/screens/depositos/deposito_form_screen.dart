import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../data/models/deposito.dart';
import '../../../data/repositories/deposito_repository.dart';
import '../_shared/selector_ubicacion_campo.dart';
import '../_shared/validadores_formulario.dart';

/// Formulario de creación/edición de un depósito. Si [existente] es `null`
/// crea uno nuevo; si no, actualiza ese registro. La app admite varios
/// depósitos — el usuario elige de cuál sale la mercadería en cada cálculo
/// (`presentation/screens/optimizacion/optimizacion_screen.dart`).
///
/// La ubicación se elige tocando el mapa (`SelectorUbicacionCampo`), no
/// escribiendo latitud/longitud a mano.
class DepositoFormScreen extends StatefulWidget {
  const DepositoFormScreen({super.key, this.existente});

  final Deposito? existente;

  @override
  State<DepositoFormScreen> createState() => _DepositoFormScreenState();
}

class _DepositoFormScreenState extends State<DepositoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _nombreCtrl = TextEditingController(
    text: widget.existente?.nombre ?? '',
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
    super.dispose();
  }

  Future<void> _guardar() async {
    final ubicacion = _ubicacion;
    final formValido = _formKey.currentState!.validate();
    setState(() => _mostrarErrorUbicacion = ubicacion == null);
    if (!formValido || ubicacion == null) return;

    setState(() => _guardando = true);
    final repositorio = context.read<DepositoRepository>();
    final deposito = Deposito(
      id: widget.existente?.id,
      nombre: _nombreCtrl.text.trim(),
      latitud: ubicacion.latitude,
      longitud: ubicacion.longitude,
    );

    if (_esEdicion) {
      await repositorio.actualizar(deposito);
    } else {
      await repositorio.crear(deposito);
    }

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_esEdicion ? 'Editar depósito' : 'Nuevo depósito'),
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
                        hintText: 'Ej. Oficina principal',
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
