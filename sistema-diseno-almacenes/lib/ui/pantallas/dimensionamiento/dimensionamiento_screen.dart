import 'package:flutter/material.dart';

import '../../../domain/motor/m4_dimensionamiento_sin_tendencia.dart';
import '../../../domain/motor/m5_dimensionamiento_con_tendencia.dart';
import '../../../domain/motor/tarifa_publica.dart';
import '../../widgets/grafica_requerimiento_mensual.dart';

enum _TipoTarifa { porManejo, porEspacio, arrendamiento }

/// Pantalla 09 de CLAUDE.md sección 10: M4 (sin tendencia) y M5 (con
/// tendencia). Independiente del flujo M2/M3/M6/M7 — el requerimiento
/// mensual y la demanda con tendencia no dependen de qué bastidor o viga
/// se eligió, así que no hace falta pasar por el catálogo para usarla.
class DimensionamientoScreen extends StatefulWidget {
  const DimensionamientoScreen({super.key});

  @override
  State<DimensionamientoScreen> createState() => _DimensionamientoScreenState();
}

class _DimensionamientoScreenState extends State<DimensionamientoScreen> {
  static const _mesesCortos = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
  static const _requerimientoDefault = [100, 100, 100, 120, 140, 160, 180, 160, 140, 120, 100, 100];

  final _formKeyM4 = GlobalKey<FormState>();
  final _formKeyM5 = GlobalKey<FormState>();

  late final List<TextEditingController> _mesesCtrl = [
    for (final v in _requerimientoDefault) TextEditingController(text: '$v'),
  ];
  final _costoAnualPropioCtrl = TextEditingController(text: '50');

  _TipoTarifa _tipoTarifa = _TipoTarifa.porEspacio;
  final _cargoEntradaCtrl = TextEditingController(text: '2');
  final _cargoSalidaCtrl = TextEditingController(text: '2');
  final _tarifaEspacioCtrl = TextEditingController(text: '15');
  final _costoFijoArrendamientoCtrl = TextEditingController(text: '3000');

  final _demandaInicialCtrl = TextEditingController(text: '100');
  final _tasaCrecimientoCtrl = TextEditingController(text: '0.10');
  final _horizonteCtrl = TextEditingController(text: '5');
  final _costoConstruccionCtrl = TextEditingController(text: '1000');
  final _tasaDescuentoCtrl = TextEditingController(text: '0.08');
  final _anioEtapaCtrl = TextEditingController(text: '2');

  ResultadoM4? _resultadoM4;
  ResultadoM5? _resultadoM5;
  String? _errorM4;
  String? _errorM5;

  TarifaPublica _construirTarifa() {
    return switch (_tipoTarifa) {
      _TipoTarifa.porManejo => TarifaPorManejo(
        cargoEntradaPorUnidad: double.parse(_cargoEntradaCtrl.text),
        cargoSalidaPorUnidad: double.parse(_cargoSalidaCtrl.text),
      ),
      _TipoTarifa.porEspacio => TarifaPorEspacio(
        tarifaPorPosicionMes: double.parse(_tarifaEspacioCtrl.text),
      ),
      _TipoTarifa.arrendamiento => TarifaPorArrendamiento(
        costoFijoMensual: double.parse(_costoFijoArrendamientoCtrl.text),
      ),
    };
  }

  void _calcularM4() {
    setState(() => _errorM4 = null);
    if (!_formKeyM4.currentState!.validate()) return;
    try {
      setState(() {
        _resultadoM4 = calcularDimensionamientoSinTendencia(
          requerimientosMensuales: _mesesCtrl.map((c) => int.parse(c.text)).toList(),
          costoAnualPropioPorPosicion: double.parse(_costoAnualPropioCtrl.text),
          tarifaPublica: _construirTarifa(),
        );
      });
    } on FormatException {
      setState(() => _errorM4 = 'Revisa que todos los campos numéricos tengan un valor válido.');
    } on ArgumentError catch (e) {
      setState(() => _errorM4 = e.message?.toString() ?? 'Entrada inválida.');
    }
  }

  void _calcularM5() {
    setState(() => _errorM5 = null);
    if (!_formKeyM5.currentState!.validate()) return;
    try {
      setState(() {
        _resultadoM5 = calcularDimensionamientoConTendencia(
          demandaInicial: int.parse(_demandaInicialCtrl.text),
          tasaCrecimientoAnual: double.parse(_tasaCrecimientoCtrl.text),
          horizonteAnios: int.parse(_horizonteCtrl.text),
          costoConstruccionPorPosicion: double.parse(_costoConstruccionCtrl.text),
          costoAnualPropioPorPosicion: double.parse(_costoAnualPropioCtrl.text),
          tarifaPublica: _construirTarifa(),
          tasaDescuentoAnual: double.parse(_tasaDescuentoCtrl.text),
          anioEtapa: int.parse(_anioEtapaCtrl.text),
        );
      });
    } on FormatException {
      setState(() => _errorM5 = 'Revisa que todos los campos numéricos tengan un valor válido.');
    } on ArgumentError catch (e) {
      setState(() => _errorM5 = e.message?.toString() ?? 'Entrada inválida.');
    }
  }

  @override
  void dispose() {
    for (final c in _mesesCtrl) {
      c.dispose();
    }
    _costoAnualPropioCtrl.dispose();
    _cargoEntradaCtrl.dispose();
    _cargoSalidaCtrl.dispose();
    _tarifaEspacioCtrl.dispose();
    _costoFijoArrendamientoCtrl.dispose();
    _demandaInicialCtrl.dispose();
    _tasaCrecimientoCtrl.dispose();
    _horizonteCtrl.dispose();
    _costoConstruccionCtrl.dispose();
    _tasaDescuentoCtrl.dispose();
    _anioEtapaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dimensionamiento')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _tarjeta(
            context,
            icono: Icons.calendar_view_month_outlined,
            titulo: 'Tarifa de almacén público',
            children: [
              DropdownButtonFormField<_TipoTarifa>(
                initialValue: _tipoTarifa,
                decoration: const InputDecoration(labelText: 'Forma de cotización', isDense: true),
                items: const [
                  DropdownMenuItem(
                    value: _TipoTarifa.porManejo,
                    child: Text('Por manejo (entrada + salida)'),
                  ),
                  DropdownMenuItem(
                    value: _TipoTarifa.porEspacio,
                    child: Text('Por espacio ocupado'),
                  ),
                  DropdownMenuItem(
                    value: _TipoTarifa.arrendamiento,
                    child: Text('Arrendamiento + personal'),
                  ),
                ],
                onChanged: (v) => setState(() => _tipoTarifa = v!),
              ),
              const SizedBox(height: 6),
              if (_tipoTarifa == _TipoTarifa.porManejo) ...[
                _campo('Cargo por entrada (por posición)', _cargoEntradaCtrl),
                _campo('Cargo por salida (por posición)', _cargoSalidaCtrl),
              ] else if (_tipoTarifa == _TipoTarifa.porEspacio)
                _campo('Tarifa por posición-mes', _tarifaEspacioCtrl)
              else
                _campo('Costo fijo mensual del arriendo', _costoFijoArrendamientoCtrl),
            ],
          ),
          const SizedBox(height: 16),
          Form(
            key: _formKeyM4,
            child: _tarjeta(
              context,
              icono: Icons.show_chart,
              titulo: 'Sin tendencia (M4)',
              subtitulo: 'Cuánto poseer vs. cuánto cubrir con público, mes a mes',
              children: [
                Text('Requerimiento mensual', style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    for (var i = 0; i < 12; i++)
                      SizedBox(
                        width: 80,
                        child: TextFormField(
                          controller: _mesesCtrl[i],
                          decoration: InputDecoration(labelText: _mesesCortos[i], isDense: true),
                          keyboardType: TextInputType.number,
                          validator: (v) => int.tryParse(v ?? '') == null ? '' : null,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                _campo(
                  'Costo anual propio por posición',
                  _costoAnualPropioCtrl,
                  tooltip: 'Amortización de obra, terreno, equipo, mantenimiento y costo de '
                      'oportunidad del capital, resumidos en un costo anual por posición.',
                ),
                const SizedBox(height: 12),
                if (_errorM4 != null) _bannerError(context, _errorM4!),
                if (_errorM4 != null) const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: _calcularM4,
                  icon: const Icon(Icons.calculate_outlined),
                  label: const Text('Calcular M4'),
                ),
                if (_resultadoM4 != null) ...[
                  const Divider(height: 32),
                  _filaResumen(
                    Icons.inventory_2_outlined,
                    'Capacidad propia óptima',
                    '${_resultadoM4!.capacidadOptima} posiciones',
                  ),
                  _filaResumen(
                    Icons.payments_outlined,
                    'Costo anual total',
                    _resultadoM4!.costoOptimo.toStringAsFixed(2),
                  ),
                  const SizedBox(height: 12),
                  GraficaRequerimientoMensual(
                    requerimientosMensuales: _mesesCtrl.map((c) => int.parse(c.text)).toList(),
                    capacidadPropia: _resultadoM4!.capacidadOptima,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          Form(
            key: _formKeyM5,
            child: _tarjeta(
              context,
              icono: Icons.trending_up,
              titulo: 'Con tendencia (M5)',
              subtitulo: 'Todo ahora vs. por etapas vs. base + público',
              children: [
                _campo('Demanda inicial (posiciones, año 1)', _demandaInicialCtrl, entero: true),
                _campo(
                  'Tasa de crecimiento anual',
                  _tasaCrecimientoCtrl,
                  ayuda: 'Ej. 0.10 = 10% anual',
                ),
                _campo('Horizonte (años)', _horizonteCtrl, entero: true),
                _campo('Costo de construcción por posición', _costoConstruccionCtrl),
                _campo(
                  'Tasa de descuento anual',
                  _tasaDescuentoCtrl,
                  ayuda: 'Para traer los costos a valor presente',
                ),
                _campo(
                  'Año de la etapa',
                  _anioEtapaCtrl,
                  entero: true,
                  tooltip: 'En qué año se amplía, para el escenario "por etapas".',
                ),
                const SizedBox(height: 8),
                if (_errorM5 != null) _bannerError(context, _errorM5!),
                if (_errorM5 != null) const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: _calcularM5,
                  icon: const Icon(Icons.calculate_outlined),
                  label: const Text('Calcular M5'),
                ),
                if (_resultadoM5 != null) ...[
                  const Divider(height: 32),
                  Text(
                    'Demanda proyectada: ${_resultadoM5!.demandaPorAnio.join(' → ')}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  ..._resultadoM5!.escenarios.map(
                    (e) => _filaEscenario(context, e, esGanador: e == _resultadoM5!.escenarios.first),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarjeta(
    BuildContext context, {
    required IconData icono,
    required String titulo,
    String? subtitulo,
    required List<Widget> children,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icono, size: 20, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(titulo, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            if (subtitulo != null) ...[
              const SizedBox(height: 2),
              Text(subtitulo, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _campo(
    String etiqueta,
    TextEditingController ctrl, {
    bool entero = false,
    String? ayuda,
    String? tooltip,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: etiqueta,
          helperText: ayuda,
          isDense: true,
          suffixIcon: tooltip != null
              ? Tooltip(message: tooltip, child: const Icon(Icons.info_outline, size: 18))
              : null,
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: !entero),
        validator: (v) {
          if (v == null || v.isEmpty) return 'Requerido';
          final parsed = entero ? int.tryParse(v) : double.tryParse(v);
          if (parsed == null) return 'Número inválido';
          return null;
        },
      ),
    );
  }

  Widget _bannerError(BuildContext context, String mensaje) {
    final colores = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: colores.errorContainer, borderRadius: BorderRadius.circular(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, color: colores.onErrorContainer, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(mensaje, style: TextStyle(color: colores.onErrorContainer))),
        ],
      ),
    );
  }

  Widget _filaResumen(IconData icono, String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icono, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Expanded(child: Text(etiqueta)),
          Text(valor, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _filaEscenario(BuildContext context, ResultadoEscenario e, {required bool esGanador}) {
    final nombre = switch (e.escenario) {
      EscenarioConstruccion.todoAhora => 'Todo ahora',
      EscenarioConstruccion.porEtapas => 'Por etapas',
      EscenarioConstruccion.basePublico => 'Base + público',
    };
    final icono = switch (e.escenario) {
      EscenarioConstruccion.todoAhora => Icons.rocket_launch_outlined,
      EscenarioConstruccion.porEtapas => Icons.stairs_outlined,
      EscenarioConstruccion.basePublico => Icons.compress_outlined,
    };
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: esGanador ? Colors.green.withValues(alpha: 0.08) : null,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icono, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Row(
              children: [
                Text(nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                if (esGanador) ...[
                  const SizedBox(width: 6),
                  const Tooltip(
                    message: 'Menor valor presente de costos',
                    child: Icon(Icons.star, size: 16, color: Colors.amber),
                  ),
                ],
              ],
            ),
          ),
          Text('VPN ${e.costoPresenteTotal.toStringAsFixed(0)}'),
        ],
      ),
    );
  }
}
