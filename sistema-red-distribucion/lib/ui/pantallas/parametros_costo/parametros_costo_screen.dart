import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/dinero_utils.dart';
import '../../../core/estado/proyecto_activo.dart';
import '../../../core/validadores_formulario.dart';
import '../../../data/models/parametros_costo.dart';
import '../../../data/repositories/parametros_costo_repository.dart';

/// Pantalla 8 (CLAUDE.md sección 8): los siete rubros de costo y el
/// estándar de servicio. Una sola fila por proyecto (`uniqueKeys` en
/// `ParametrosCostoTable`), así que esta pantalla es alta y edición a la
/// vez — "Guardar" reemplaza la fila existente si ya había una.
class ParametrosCostoScreen extends StatefulWidget {
  const ParametrosCostoScreen({super.key});

  @override
  State<ParametrosCostoScreen> createState() => _ParametrosCostoScreenState();
}

class _ParametrosCostoScreenState extends State<ParametrosCostoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tarifaEntradaFijaCtrl = TextEditingController();
  final _tarifaEntradaKmTonCtrl = TextEditingController();
  final _tarifaSalidaFijaCtrl = TextEditingController();
  final _tarifaSalidaKmTonCtrl = TextEditingController();
  final _tasaManejoInventarioCtrl = TextEditingController();
  final _valorPorUnidadCtrl = TextEditingController();
  final _inventarioBaseCtrl = TextEditingController();
  final _costoPorPedidoCtrl = TextEditingController();
  final _estandarServicioCtrl = TextEditingController();

  String _tipoEstandar = 'distancia';
  bool _cargando = true;
  bool _guardando = false;

  int get _proyectoId => context.read<ProyectoActivo>().proyecto!.id!;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  @override
  void dispose() {
    _tarifaEntradaFijaCtrl.dispose();
    _tarifaEntradaKmTonCtrl.dispose();
    _tarifaSalidaFijaCtrl.dispose();
    _tarifaSalidaKmTonCtrl.dispose();
    _tasaManejoInventarioCtrl.dispose();
    _valorPorUnidadCtrl.dispose();
    _inventarioBaseCtrl.dispose();
    _costoPorPedidoCtrl.dispose();
    _estandarServicioCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargar() async {
    final existentes = await context
        .read<ParametrosCostoRepository>()
        .obtenerPorProyecto(_proyectoId);
    if (!mounted) return;
    if (existentes != null) {
      _tarifaEntradaFijaCtrl.text = centimosATexto(existentes.tarifaEntradaFijaCent);
      _tarifaEntradaKmTonCtrl.text = centimosATexto(existentes.tarifaEntradaCentPorKmTon);
      _tarifaSalidaFijaCtrl.text = centimosATexto(existentes.tarifaSalidaFijaCent);
      _tarifaSalidaKmTonCtrl.text = centimosATexto(existentes.tarifaSalidaCentPorKmTon);
      _tasaManejoInventarioCtrl.text = '${existentes.tasaManejoInventarioAnual * 100}';
      _valorPorUnidadCtrl.text = centimosATexto(existentes.valorPorUnidadCent);
      _inventarioBaseCtrl.text = '${existentes.inventarioBaseUnaUbicacion}';
      _costoPorPedidoCtrl.text = centimosATexto(existentes.costoPorPedidoCent);
      _tipoEstandar = existentes.tipoEstandar;
      _estandarServicioCtrl.text = _tipoEstandar == 'distancia'
          ? '${existentes.estandarServicioValor / 1000}'
          : '${existentes.estandarServicioValor / 60}';
    }
    setState(() => _cargando = false);
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);
    final estandarValorUsuario = double.parse(_estandarServicioCtrl.text.trim());
    final estandarServicioValor = _tipoEstandar == 'distancia'
        ? (estandarValorUsuario * 1000).round() // km -> metros
        : (estandarValorUsuario * 60).round(); // minutos -> segundos

    final parametros = ParametrosCosto(
      proyectoId: _proyectoId,
      tarifaEntradaFijaCent: aCentimos(_tarifaEntradaFijaCtrl.text),
      tarifaEntradaCentPorKmTon: aCentimos(_tarifaEntradaKmTonCtrl.text),
      tarifaSalidaFijaCent: aCentimos(_tarifaSalidaFijaCtrl.text),
      tarifaSalidaCentPorKmTon: aCentimos(_tarifaSalidaKmTonCtrl.text),
      tasaManejoInventarioAnual: double.parse(_tasaManejoInventarioCtrl.text.trim()) / 100,
      valorPorUnidadCent: aCentimos(_valorPorUnidadCtrl.text),
      inventarioBaseUnaUbicacion: double.parse(_inventarioBaseCtrl.text.trim()),
      costoPorPedidoCent: aCentimos(_costoPorPedidoCtrl.text),
      tipoEstandar: _tipoEstandar,
      estandarServicioValor: estandarServicioValor,
    );

    await context.read<ParametrosCostoRepository>().guardar(parametros);

    if (!mounted) return;
    setState(() => _guardando = false);
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(const SnackBar(content: Text('Parámetros de costo guardados.')));
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Parámetros de costo')),
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
                    Text('Transporte de entrada (planta → almacén)',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _tarifaEntradaFijaCtrl,
                      decoration: const InputDecoration(labelText: 'Tarifa fija'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) =>
                          validarNumeroNoNegativo(v, etiqueta: 'La tarifa fija', femenino: true),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _tarifaEntradaKmTonCtrl,
                      decoration: const InputDecoration(labelText: 'Tarifa por km-tonelada'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) =>
                          validarNumeroNoNegativo(v, etiqueta: 'La tarifa por km-tonelada', femenino: true),
                    ),
                    const SizedBox(height: 20),
                    Text('Transporte de salida (almacén → zona de demanda)',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _tarifaSalidaFijaCtrl,
                      decoration: const InputDecoration(labelText: 'Tarifa fija'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) =>
                          validarNumeroNoNegativo(v, etiqueta: 'La tarifa fija', femenino: true),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _tarifaSalidaKmTonCtrl,
                      decoration: const InputDecoration(labelText: 'Tarifa por km-tonelada'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) =>
                          validarNumeroNoNegativo(v, etiqueta: 'La tarifa por km-tonelada', femenino: true),
                    ),
                    const SizedBox(height: 20),
                    Text('Inventario y pedidos', style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _tasaManejoInventarioCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Tasa anual de manejo de inventario (%)',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) => validarNumeroNoNegativo(v, etiqueta: 'La tasa', femenino: true),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _valorPorUnidadCtrl,
                      decoration: const InputDecoration(labelText: 'Valor por unidad'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) => validarNumeroNoNegativo(v, etiqueta: 'El valor por unidad'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _inventarioBaseCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Inventario base de una ubicación',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) => validarNumeroNoNegativo(v, etiqueta: 'El inventario base'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _costoPorPedidoCtrl,
                      decoration: const InputDecoration(labelText: 'Costo por pedido'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) => validarNumeroNoNegativo(v, etiqueta: 'El costo por pedido'),
                    ),
                    const SizedBox(height: 20),
                    Text('Estándar de servicio', style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _tipoEstandar,
                            decoration: const InputDecoration(labelText: 'Tipo'),
                            items: const [
                              DropdownMenuItem(value: 'distancia', child: Text('Distancia (km)')),
                              DropdownMenuItem(value: 'tiempo', child: Text('Tiempo (min)')),
                            ],
                            onChanged: (v) => setState(() => _tipoEstandar = v!),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _estandarServicioCtrl,
                            decoration: InputDecoration(
                              labelText: _tipoEstandar == 'distancia' ? 'Máximo (km)' : 'Máximo (min)',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            validator: (v) =>
                                validarNumeroNoNegativo(v, etiqueta: 'El estándar de servicio'),
                          ),
                        ),
                      ],
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
