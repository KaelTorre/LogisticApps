import 'package:flutter/material.dart';

import '../../../domain/motor/m4_dimensionamiento_sin_tendencia.dart';
import '../../../domain/motor/m5_dimensionamiento_con_tendencia.dart';
import '../../../domain/motor/tarifa_publica.dart';
import '../../widgets/grafica_costo_acumulado.dart';
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

  /// Qué escenario de M5 está tocado, para resaltar su línea en
  /// [GraficaCostoAcumulado] — null = ninguno, se ven las 3 parejo.
  EscenarioConstruccion? _escenarioResaltado;

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
    setState(() {
      _errorM5 = null;
      _escenarioResaltado = null;
    });
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
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 18,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Decide cuánto espacio te conviene poseer y cuánto cubrir con '
                    'almacén público. "Sin tendencia" (M4) es para demanda estable '
                    'pero estacional, mes a mes; "Con tendencia" (M5) es para '
                    'demanda que crece año a año. Pídele la tarifa a 2-3 operadores '
                    'de almacén público de tu zona para la sección de abajo.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _tarjeta(
            context,
            paso: 1,
            icono: Icons.calendar_view_month_outlined,
            titulo: 'Tarifa de almacén público',
            subtitulo: 'Se usa en los dos cálculos de abajo (M4 y M5)',
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: DropdownButtonFormField<_TipoTarifa>(
                      initialValue: _tipoTarifa,
                      decoration: const InputDecoration(
                        labelText: 'Forma de cotización',
                        isDense: true,
                      ),
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
                  ),
                  const SizedBox(width: 4),
                  const Tooltip(
                    message:
                        'Las 3 formas de cotización más comunes: por manejo '
                        '(cobran por unidad que entra y sale), por espacio '
                        '(cobran por posición-mes ocupada) o arrendamiento fijo '
                        '(cobran lo mismo aunque uses poco).',
                    child: Icon(Icons.info_outline, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              if (_tipoTarifa == _TipoTarifa.porManejo) ...[
                _campo(
                  'Cargo por entrada (por posición)',
                  _cargoEntradaCtrl,
                  tooltip: 'Lo que cobra el operador público por cada posición que entra.',
                ),
                _campo(
                  'Cargo por salida (por posición)',
                  _cargoSalidaCtrl,
                  tooltip: 'Lo que cobra el operador público por cada posición que sale.',
                ),
              ] else if (_tipoTarifa == _TipoTarifa.porEspacio)
                _campo(
                  'Tarifa por posición-mes',
                  _tarifaEspacioCtrl,
                  tooltip: 'Costo por cada posición ocupada, por mes, cotizado por el operador.',
                )
              else
                _campo(
                  'Costo fijo mensual del arriendo',
                  _costoFijoArrendamientoCtrl,
                  tooltip: 'Se cobra completo en cualquier mes con desborde, sin importar cuánto.',
                ),
            ],
          ),
          const SizedBox(height: 16),
          Form(
            key: _formKeyM4,
            child: _tarjeta(
              context,
              paso: 2,
              icono: Icons.show_chart,
              titulo: 'Sin tendencia (M4)',
              subtitulo: 'Cuánto poseer vs. cuánto cubrir con público, mes a mes',
              children: [
                Row(
                  children: [
                    Text('Requerimiento mensual', style: Theme.of(context).textTheme.labelMedium),
                    const SizedBox(width: 6),
                    Tooltip(
                      message:
                          'Posiciones que necesitas cada mes. Sácalo de tu '
                          'historial de inventario máximo mensual, o del '
                          'pronóstico si tu demanda es estacional.',
                      child: Icon(Icons.info_outline, size: 14, color: Colors.grey.shade600),
                    ),
                  ],
                ),
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
                  _encabezadoResultado(context, 'RESULTADO'),
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
                    // Del resultado ya calculado, no de los controllers en
                    // vivo: si el usuario borra o deja a medio editar un mes
                    // después de calcular, los controllers pueden tener texto
                    // no numérico en cualquier momento — leerlos aquí, en
                    // build(), reventaba la pantalla entera con una
                    // FormatException sin poder recuperarse (ni "Atrás" volvía
                    // a funcionar, porque build() vuelve a tronar en cada
                    // repintado). El resultado guardado es inmutable y ya
                    // pasó por la validación de calcularDimensionamientoSinTendencia.
                    requerimientosMensuales: _resultadoM4!.requerimientosMensuales,
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
              paso: 3,
              icono: Icons.trending_up,
              titulo: 'Con tendencia (M5)',
              subtitulo: 'Todo ahora vs. por etapas vs. base + público',
              children: [
                _campo(
                  'Demanda inicial (posiciones, año 1)',
                  _demandaInicialCtrl,
                  entero: true,
                  tooltip: 'Las posiciones que necesitas hoy, el año 1 del horizonte.',
                ),
                _campo(
                  'Tasa de crecimiento anual',
                  _tasaCrecimientoCtrl,
                  ayuda: 'Ej. 0.10 = 10% anual',
                  tooltip:
                      'De cuánto creció tu demanda en los últimos años, o la '
                      'meta de crecimiento del negocio si es un proyecto nuevo.',
                ),
                _campo(
                  'Horizonte (años)',
                  _horizonteCtrl,
                  entero: true,
                  tooltip: 'Cuántos años a futuro planeas — 5 años es un horizonte típico.',
                ),
                _campo(
                  'Costo de construcción por posición',
                  _costoConstruccionCtrl,
                  tooltip:
                      'Costo total de obra (terreno, estructura, racks, equipo) '
                      'dividido entre las posiciones que vas a construir. '
                      'Pídele una cotización preliminar a un constructor si no '
                      'la tienes.',
                ),
                _campo(
                  'Tasa de descuento anual',
                  _tasaDescuentoCtrl,
                  ayuda: 'Para traer los costos a valor presente',
                  tooltip:
                      'El costo de oportunidad del capital de tu empresa — '
                      'pregúntale a finanzas, o usa la tasa de un préstamo '
                      'similar si no tienes una definida.',
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
                  _encabezadoResultado(
                    context,
                    'RESULTADO',
                    tooltip:
                        'VPN = Valor Presente Neto: todos los costos de '
                        'ese escenario a lo largo del horizonte, traídos a '
                        'valor de hoy con la tasa de descuento. Menor es '
                        'mejor.',
                  ),
                  Text(
                    'Demanda proyectada: ${_resultadoM5!.demandaPorAnio.join(' → ')}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Toca un escenario para resaltar su curva en la gráfica de abajo',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 4),
                  ..._resultadoM5!.escenarios.map(
                    (e) => _filaEscenario(
                      context,
                      e,
                      esGanador: e == _resultadoM5!.escenarios.first,
                      seleccionado: _escenarioResaltado == e.escenario,
                      onTap: () => setState(() {
                        _escenarioResaltado = _escenarioResaltado == e.escenario ? null : e.escenario;
                      }),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GraficaCostoAcumulado(
                    escenarios: _resultadoM5!.escenarios,
                    resaltado: _escenarioResaltado,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// `paso` numera las 3 tarjetas de la pantalla (Tarifa → M4 → M5) para
  /// que el orden de lectura de arriba hacia abajo se lea como una
  /// secuencia de pasos, no como 3 formularios sueltos sin relación.
  Widget _tarjeta(
    BuildContext context, {
    required int paso,
    required IconData icono,
    required String titulo,
    String? subtitulo,
    required List<Widget> children,
  }) {
    final colores = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: colores.primary, shape: BoxShape.circle),
                  child: Text(
                    '$paso',
                    style: TextStyle(
                      color: colores.onPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Icon(icono, size: 20, color: colores.primary),
                const SizedBox(width: 8),
                Text(titulo, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            if (subtitulo != null) ...[
              const SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: Text(subtitulo, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ),
            ],
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  /// Separa visualmente "lo que ingresaste" de "lo que te devolvió el
  /// cálculo" dentro de una misma tarjeta — antes todo eran filas seguidas
  /// sin ningún quiebre, y no quedaba claro dónde terminaba el formulario y
  /// empezaba el resultado.
  Widget _encabezadoResultado(BuildContext context, String texto, {String? tooltip}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.insights_outlined, size: 16, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 6),
          Text(
            texto,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.4,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          if (tooltip != null) ...[
            const Spacer(),
            Tooltip(
              message: tooltip,
              child: Icon(Icons.info_outline, size: 16, color: Colors.grey.shade600),
            ),
          ],
        ],
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

  Widget _filaEscenario(
    BuildContext context,
    ResultadoEscenario e, {
    required bool esGanador,
    required bool seleccionado,
    required VoidCallback onTap,
  }) {
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
    final colorSerie = GraficaCostoAcumulado.colores[e.escenario]!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: esGanador ? Colors.green.withValues(alpha: 0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: seleccionado ? colorSerie : Colors.black12,
                width: seleccionado ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(color: colorSerie, shape: BoxShape.circle),
                ),
                const SizedBox(width: 10),
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
          ),
        ),
      ),
    );
  }
}
