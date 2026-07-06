import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../data/models/deposito.dart';
import '../../../data/repositories/deposito_repository.dart';
import '../_shared/validadores_formulario.dart';

/// Pantalla de Depósito (sección 8 de CLAUDE.md): formulario para definir o
/// editar el único depósito activo. No es una lista — el MVP asume un solo
/// depósito a la vez.
class DepositoScreen extends StatefulWidget {
  const DepositoScreen({super.key});

  @override
  State<DepositoScreen> createState() => _DepositoScreenState();
}

class _DepositoScreenState extends State<DepositoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _latitudCtrl = TextEditingController();
  final _longitudCtrl = TextEditingController();

  Deposito? _depositoActual;
  bool _cargando = true;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _latitudCtrl.dispose();
    _longitudCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargar() async {
    final repositorio = context.read<DepositoRepository>();
    final existentes = await repositorio.obtenerTodos();
    if (!mounted) return;
    setState(() {
      _depositoActual = existentes.isNotEmpty ? existentes.first : null;
      _nombreCtrl.text = _depositoActual?.nombre ?? '';
      _latitudCtrl.text = _depositoActual?.latitud.toString() ?? '';
      _longitudCtrl.text = _depositoActual?.longitud.toString() ?? '';
      _cargando = false;
    });
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);
    final repositorio = context.read<DepositoRepository>();
    await repositorio.guardarUnico(
      Deposito(
        id: _depositoActual?.id,
        nombre: _nombreCtrl.text.trim(),
        latitud: double.parse(_latitudCtrl.text.trim()),
        longitud: double.parse(_longitudCtrl.text.trim()),
      ),
    );
    if (!mounted) return;
    setState(() => _guardando = false);
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        const SnackBar(
          showCloseIcon: true,
          content: Text('Depósito guardado.'),
        ),
      );
    await _cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Depósito')),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
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
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  LucideIcons.warehouse,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _depositoActual == null
                                      ? 'Todavía no hay un depósito configurado.'
                                      : 'Punto de partida de todas las rutas.',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
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
                          TextFormField(
                            controller: _latitudCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Latitud',
                              hintText: 'Ej. -8.379',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              signed: true,
                              decimal: true,
                            ),
                            textInputAction: TextInputAction.next,
                            validator: validarLatitud,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _longitudCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Longitud',
                              hintText: 'Ej. -74.556',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              signed: true,
                              decimal: true,
                            ),
                            textInputAction: TextInputAction.done,
                            validator: validarLongitud,
                          ),
                          const SizedBox(height: 24),
                          FilledButton.icon(
                            onPressed: _guardando ? null : _guardar,
                            icon: _guardando
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(LucideIcons.save),
                            label: Text(
                              _guardando ? 'Guardando...' : 'Guardar',
                            ),
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
