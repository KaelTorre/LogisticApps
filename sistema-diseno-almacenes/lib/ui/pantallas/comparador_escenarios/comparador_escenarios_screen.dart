import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';

import '../../../data/local/database.dart';
import '../../../domain/motor/m2_posiciones.dart';
import '../../../domain/motor/m7_anden.dart';
import '../../../domain/motor/m8_comparador.dart';

class _PresetEscenario {
  _PresetEscenario({
    required this.nombre,
    required this.tipoSistema,
    required this.icono,
    required int factorFondoDefault,
    required double factorHoneycombDefault,
  }) : factorFondoCtrl = TextEditingController(text: '$factorFondoDefault'),
       factorHoneycombCtrl = TextEditingController(text: '$factorHoneycombDefault'),
       costoConstruccionCtrl = TextEditingController(text: '500'),
       costoEquiposCtrl = TextEditingController(text: '80000');

  final String nombre;
  final String tipoSistema;
  final IconData icono;
  final TextEditingController factorFondoCtrl;
  final TextEditingController factorHoneycombCtrl;
  final TextEditingController costoConstruccionCtrl;
  final TextEditingController costoEquiposCtrl;

  void dispose() {
    factorFondoCtrl.dispose();
    factorHoneycombCtrl.dispose();
    costoConstruccionCtrl.dispose();
    costoEquiposCtrl.dispose();
  }
}

/// Pantalla 11 de CLAUDE.md sección 10: M8, comparador de escenarios.
/// Independiente del flujo M2/M3/M6/M7 de `EntradaCalculoScreen` — carga su
/// propio catálogo, porque comparar sistemas de racking exige poder variar
/// el factor de fondo y el honeycomb de cada uno, algo que la pantalla de
/// un solo escenario no expone.
///
/// **[REGLA]** (sección 6.5): el equipo y el pasillo se mantienen iguales
/// entre los 3 presets — es una simplificación declarada, no una omisión:
/// derivar un equipo distinto por escenario exigiría un análisis de
/// throughput que ningún módulo del sistema calcula todavía.
class ComparadorEscenariosScreen extends StatefulWidget {
  const ComparadorEscenariosScreen({super.key, required this.db});

  final AppDatabase db;

  @override
  State<ComparadorEscenariosScreen> createState() => _ComparadorEscenariosScreenState();
}

class _ComparadorEscenariosScreenState extends State<ComparadorEscenariosScreen> {
  final _formKey = GlobalKey<FormState>();

  List<CatalogoTarima> _tarimas = [];
  List<CatalogoBastidore> _bastidores = [];
  List<CatalogoViga> _vigas = [];
  List<CatalogoEquipo> _equipos = [];
  List<CatalogoCamione> _camiones = [];
  int? _holguraXMinimaMm;
  int? _holguraYMinimaMm;
  int? _separacionEspaldaMm;
  int? _holguraMuroMm;
  bool _cargando = true;

  CatalogoTarima? _tarima;
  CatalogoBastidore? _bastidor;
  CatalogoViga? _viga;
  CatalogoEquipo? _equipo;
  CatalogoCamione? _camion;

  final _demandaAnualCtrl = TextEditingController(text: '12000');
  final _rotacionAnualCtrl = TextEditingController(text: '12');
  final _unidadesPorTarimaCtrl = TextEditingController(text: '40');
  final _altoCargaCtrl = TextEditingController(text: '1200');
  final _alturaLibreCtrl = TextEditingController(text: '8000');
  final _reservaTechoCtrl = TextEditingController(text: '450');
  final _largoDisponibleCtrl = TextEditingController(text: '30000');

  final _camionesHoraPicoCtrl = TextEditingController(text: '4');
  final _tiempoServicioMinCtrl = TextEditingController(text: '30');
  final _esperaObjetivoMinCtrl = TextEditingController(text: '15');
  final _espaciamientoPuertaCtrl = TextEditingController(text: '3600');
  final _areaStagingCtrl = TextEditingController(text: '15');

  late final List<_PresetEscenario> _presets = [
    _PresetEscenario(
      nombre: 'Selectivo',
      tipoSistema: 'selectivo',
      icono: Icons.view_column_outlined,
      factorFondoDefault: 1,
      factorHoneycombDefault: 0.20,
    ),
    _PresetEscenario(
      nombre: 'Doble fondo',
      tipoSistema: 'doble_fondo',
      icono: Icons.view_agenda_outlined,
      factorFondoDefault: 2,
      factorHoneycombDefault: 0.30,
    ),
    _PresetEscenario(
      nombre: 'Drive-in',
      tipoSistema: 'drive_in',
      icono: Icons.garage_outlined,
      factorFondoDefault: 4,
      factorHoneycombDefault: 0.35,
    ),
  ];

  ResultadoM8? _resultado;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarCatalogo();
  }

  Future<void> _cargarCatalogo() async {
    final tarimas = await widget.db.select(widget.db.catalogoTarimas).get();
    final bastidores = await widget.db.select(widget.db.catalogoBastidores).get();
    final vigas = await widget.db.select(widget.db.catalogoVigas).get();
    final equipos = await widget.db.select(widget.db.catalogoEquipos).get();
    final camiones = await widget.db.select(widget.db.catalogoCamiones).get();
    final holguraX = await (widget.db.select(
      widget.db.parametrosNorma,
    )..where((p) => p.clave.equals('holgura_x_mm') & p.norma.equals('EN'))).getSingleOrNull();
    final holguraY = await (widget.db.select(
      widget.db.parametrosNorma,
    )..where((p) => p.clave.equals('holgura_y_mm') & p.norma.equals('EN'))).getSingleOrNull();
    final separacionEspalda = await (widget.db.select(
      widget.db.parametrosNorma,
    )..where((p) => p.clave.equals('separacion_espalda_mm') & p.norma.equals('EN'))).getSingleOrNull();
    final holguraMuro = await (widget.db.select(
      widget.db.parametrosNorma,
    )..where((p) => p.clave.equals('holgura_muro_mm') & p.norma.equals('EN'))).getSingleOrNull();

    setState(() {
      _tarimas = tarimas;
      _bastidores = bastidores;
      _vigas = vigas;
      _equipos = equipos;
      _camiones = camiones;
      _holguraXMinimaMm = holguraX?.valor;
      _holguraYMinimaMm = holguraY?.valor;
      _separacionEspaldaMm = separacionEspalda?.valor;
      _holguraMuroMm = holguraMuro?.valor;
      _tarima = tarimas.isNotEmpty ? tarimas.first : null;
      _bastidor = bastidores.isNotEmpty ? bastidores.first : null;
      _viga = vigas.isNotEmpty ? vigas.first : null;
      _equipo = equipos.isNotEmpty
          ? equipos.reduce((a, b) => a.elevacionMaxMm >= b.elevacionMaxMm ? a : b)
          : null;
      _camion = camiones.isNotEmpty ? camiones.first : null;
      _cargando = false;
    });
  }

  void _comparar() {
    setState(() => _error = null);
    if (!_formKey.currentState!.validate()) return;

    final tarima = _tarima!;
    final bastidor = _bastidor!;
    final viga = _viga!;
    final equipo = _equipo!;
    final camion = _camion!;

    try {
      final base = BaseEscenarioM8(
        anchoTarimaMm: tarima.anchoMm,
        altoTarimaMm: tarima.altoMm,
        altoCargaMm: int.parse(_altoCargaCtrl.text),
        largoVigaMm: viga.largoMm,
        peralteVigaMm: viga.peralteMm,
        fondoBastidorMm: bastidor.fondoMm,
        perfilAnchoBastidorMm: bastidor.perfilAnchoMm,
        holguraXMm: _holguraXMinimaMm!,
        holguraXMinimaNormaMm: _holguraXMinimaMm!,
        holguraYMm: _holguraYMinimaMm!,
        holguraYMinimaNormaMm: _holguraYMinimaMm!,
        pasoAjustePuntalMm: 50,
        alturaLibreMm: int.parse(_alturaLibreCtrl.text),
        reservaTechoMm: int.parse(_reservaTechoCtrl.text),
        elevacionMaxEquipoMm: equipo.elevacionMaxMm,
        largoDisponibleMm: int.parse(_largoDisponibleCtrl.text),
        anchoPasilloMm: equipo.pasilloMinMm,
        separacionEspaldaMm: _separacionEspaldaMm!,
        holguraMuroMm: _holguraMuroMm!,
      );

      final escenarios = [
        for (final p in _presets)
          base.con(
            nombre: p.nombre,
            tipoSistema: p.tipoSistema,
            factorFondo: int.parse(p.factorFondoCtrl.text),
            factorHoneycomb: double.parse(p.factorHoneycombCtrl.text),
            costoConstruccionPorM2: double.parse(p.costoConstruccionCtrl.text),
            costoEquipos: double.parse(p.costoEquiposCtrl.text),
          ),
      ];

      setState(() {
        _resultado = compararEscenarios(
          familias: [
            DemandaFamilia(
              nombre: 'Familia A',
              demandaAnual: double.parse(_demandaAnualCtrl.text),
              rotacionAnual: double.parse(_rotacionAnualCtrl.text),
              unidadesPorTarima: int.parse(_unidadesPorTarimaCtrl.text),
            ),
          ],
          escenarios: escenarios,
          entradaAnden: EntradaM7(
            camionesHoraPico: double.parse(_camionesHoraPicoCtrl.text),
            tiempoMedioServicioHoras: double.parse(_tiempoServicioMinCtrl.text) / 60,
            esperaObjetivoHoras: double.parse(_esperaObjetivoMinCtrl.text) / 60,
            espaciamientoPuertaMm: int.parse(_espaciamientoPuertaCtrl.text),
            patioMinMm: camion.patioMinMm,
            areaStagingPorPuertaMm2: (double.parse(_areaStagingCtrl.text) * 1000000).round(),
          ),
        );
      });
    } on FormatException {
      setState(() => _error = 'Revisa que todos los campos numéricos tengan un valor válido.');
    } on ArgumentError catch (e) {
      setState(() => _error = e.message?.toString() ?? 'Entrada inválida.');
    } on Exception catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  void dispose() {
    for (final p in _presets) {
      p.dispose();
    }
    _demandaAnualCtrl.dispose();
    _rotacionAnualCtrl.dispose();
    _unidadesPorTarimaCtrl.dispose();
    _altoCargaCtrl.dispose();
    _alturaLibreCtrl.dispose();
    _reservaTechoCtrl.dispose();
    _largoDisponibleCtrl.dispose();
    _camionesHoraPicoCtrl.dispose();
    _tiempoServicioMinCtrl.dispose();
    _esperaObjetivoMinCtrl.dispose();
    _espaciamientoPuertaCtrl.dispose();
    _areaStagingCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_tarimas.isEmpty || _bastidores.isEmpty || _vigas.isEmpty || _equipos.isEmpty || _camiones.isEmpty) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: 40, color: Theme.of(context).colorScheme.error),
                const SizedBox(height: 12),
                const Text('El catálogo semilla no cargó. Revisa CatalogoSeedLoader.'),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Comparador de escenarios')),
      body: Form(
        key: _formKey,
        child: ListView(
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
                      'Compara 3 formas de guardar la misma demanda: selectivo '
                      '(cada tarima accesible), doble fondo y drive-in (más '
                      'densos, pero con menos acceso directo). Los datos de abajo '
                      'son compartidos; solo el factor de fondo, el honeycomb y '
                      'los costos cambian por escenario.',
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
              icono: Icons.inventory_2_outlined,
              titulo: 'Catálogo y terreno',
              subtitulo: 'Compartido por los 3 escenarios',
              children: [
                _dropdown(
                  'Tarima',
                  _tarimas,
                  _tarima,
                  (t) => '${t.codigo} · ${t.largoMm}×${t.anchoMm} mm',
                  (v) => setState(() => _tarima = v),
                  tooltip: 'La tarima que realmente usas en este proyecto.',
                ),
                _dropdown(
                  'Bastidor',
                  _bastidores,
                  _bastidor,
                  (b) => '${b.codigo} · fondo ${b.fondoMm} mm',
                  (v) => setState(() => _bastidor = v),
                  tooltip: 'De la ficha técnica de tu proveedor de racks.',
                ),
                _dropdown(
                  'Viga',
                  _vigas,
                  _viga,
                  (v) => '${v.codigo} · ${v.largoMm} mm',
                  (v) => setState(() => _viga = v),
                  tooltip: 'Largo medido entre caras internas de puntales.',
                ),
                _dropdown(
                  'Equipo',
                  _equipos,
                  _equipo,
                  (e) => '${e.codigo} · eleva ${e.elevacionMaxMm} mm',
                  (v) => setState(() => _equipo = v),
                  tooltip:
                      'Se usa igual en los 3 escenarios (simplificación '
                      'declarada): comparar equipos distintos por escenario '
                      'exigiría un análisis de throughput que el sistema no hace.',
                ),
                _campo(
                  'Alto de carga',
                  _altoCargaCtrl,
                  entero: true,
                  tooltip: 'Altura de la carga ya paletizada, sin la tarima.',
                ),
                _campo(
                  'Altura libre',
                  _alturaLibreCtrl,
                  entero: true,
                  tooltip: 'Del piso a lo más bajo de la estructura de techo.',
                ),
                _campo(
                  'Reserva de techo',
                  _reservaTechoCtrl,
                  entero: true,
                  tooltip: 'Espacio para rociadores y luminarias; se resta antes de calcular niveles.',
                ),
                _campo(
                  'Largo disponible',
                  _largoDisponibleCtrl,
                  entero: true,
                  tooltip: 'Longitud real del terreno para colocar las filas.',
                ),
              ],
            ),
            const SizedBox(height: 16),
            _tarjeta(
              context,
              icono: Icons.trending_up,
              titulo: 'Demanda y andén',
              subtitulo: 'Compartidos por los 3 escenarios',
              children: [
                _campo(
                  'Demanda anual',
                  _demandaAnualCtrl,
                  tooltip: 'De tus reportes de ventas o despachos del último año.',
                ),
                _campo(
                  'Rotación anual',
                  _rotacionAnualCtrl,
                  tooltip: 'demanda anual ÷ inventario promedio.',
                ),
                _campo('Unidades por tarima', _unidadesPorTarimaCtrl, entero: true),
                _dropdown(
                  'Camión de diseño',
                  _camiones,
                  _camion,
                  (c) => '${c.codigo} · patio ${c.patioMinMm} mm',
                  (v) => setState(() => _camion = v),
                  tooltip: 'El camión más grande que normalmente atiendes, no el promedio.',
                ),
                _campo(
                  'Camiones en hora pico',
                  _camionesHoraPicoCtrl,
                  tooltip: 'La hora con más llegadas, no el promedio diario.',
                ),
                _campo('Tiempo de servicio (min)', _tiempoServicioMinCtrl),
                _campo('Espera objetivo (min)', _esperaObjetivoMinCtrl),
                _campo('Espaciamiento entre puertas', _espaciamientoPuertaCtrl, entero: true),
                _campo('Área de preparación por puerta (m²)', _areaStagingCtrl),
              ],
            ),
            const SizedBox(height: 16),
            for (final p in _presets) ...[
              _tarjetaEscenario(context, p),
              const SizedBox(height: 12),
            ],
            if (_error != null) _bannerError(context, _error!),
            if (_error != null) const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _comparar,
              icon: const Icon(Icons.compare_arrows_outlined),
              label: const Text('Comparar'),
            ),
            if (_resultado != null) ...[
              const SizedBox(height: 16),
              _tablaResultado(context, _resultado!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _tarjetaEscenario(BuildContext context, _PresetEscenario p) {
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
                Icon(p.icono, size: 20, color: colores.primary),
                const SizedBox(width: 8),
                Text(p.nombre, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(width: 6),
                Tooltip(
                  message: accesibilidadPorTipoSistema[p.tipoSistema] ?? '',
                  child: Icon(Icons.info_outline, size: 15, color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _campo(
                    'Factor de fondo',
                    p.factorFondoCtrl,
                    entero: true,
                    tooltip: '1 selectivo, 2 doble fondo, más para drive-in/push-back.',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _campo(
                    'Factor honeycomb',
                    p.factorHoneycombCtrl,
                    tooltip: 'Capacidad perdida por reglas de acomodo. Sube con la densidad.',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(child: _campo('Costo construcción / m²', p.costoConstruccionCtrl)),
                const SizedBox(width: 8),
                Expanded(child: _campo('Costo de equipos', p.costoEquiposCtrl)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tablaResultado(BuildContext context, ResultadoM8 resultado) {
    final colores = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colores.secondaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, size: 18, color: colores.onSecondaryContainer),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Ordenados por costo por posición. La accesibilidad va siempre '
                  'junto al costo: más densidad no es gratis.',
                  style: TextStyle(color: colores.onSecondaryContainer, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Escenario')),
              DataColumn(label: Text('Posiciones')),
              DataColumn(label: Text('Sup. construida (m²)')),
              DataColumn(label: Text('Relación sup.')),
              DataColumn(label: Text('Distancia (m)')),
              DataColumn(label: Text('Inversión')),
              DataColumn(label: Text('Costo/posición')),
              DataColumn(label: Text('Accesibilidad')),
            ],
            rows: [
              for (final e in resultado.escenarios)
                DataRow(
                  color: e == resultado.escenarios.first
                      ? WidgetStateProperty.all(Colors.green.withValues(alpha: 0.1))
                      : null,
                  cells: [
                    DataCell(Text(e.nombre)),
                    DataCell(Text('${e.posicionesInstaladas}')),
                    DataCell(Text((e.supConstruidaMm2 / 1000000).toStringAsFixed(1))),
                    DataCell(Text('${(e.relacionSuperficie * 100).toStringAsFixed(0)}%')),
                    DataCell(Text((e.distanciaEsperadaMm / 1000).toStringAsFixed(1))),
                    DataCell(Text(e.inversionEstimada.toStringAsFixed(0))),
                    DataCell(Text(e.costoPorPosicion.toStringAsFixed(2))),
                    DataCell(
                      SizedBox(
                        width: 220,
                        child: Text(e.accesibilidad, style: const TextStyle(fontSize: 12)),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
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
    String? tooltip,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: etiqueta,
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

  Widget _dropdown<T>(
    String etiqueta,
    List<T> opciones,
    T? seleccionado,
    String Function(T) etiquetaDe,
    void Function(T?) onChanged, {
    String? tooltip,
  }) {
    // El tooltip va afuera del campo, no como `suffixIcon`: ese espacio ya
    // lo usa la flecha propia del DropdownButtonFormField, y un suffixIcon
    // la tapa.
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: DropdownButtonFormField<T>(
              initialValue: seleccionado,
              decoration: InputDecoration(labelText: etiqueta, isDense: true),
              items: opciones
                  .map((o) => DropdownMenuItem(value: o, child: Text(etiquetaDe(o))))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
          if (tooltip != null) ...[
            const SizedBox(width: 4),
            Tooltip(message: tooltip, child: const Icon(Icons.info_outline, size: 18)),
          ],
        ],
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
}
