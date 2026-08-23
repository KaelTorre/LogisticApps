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

  /// Un color fijo por escenario (por índice en [_presets]), reutilizado en
  /// la tarjeta de entrada y en la tarjeta de resultado del mismo escenario
  /// — es el hilo visual que conecta "lo que configuré" con "lo que dio".
  static const _coloresPreset = [Color(0xFF1E88E5), Color(0xFFFB8C00), Color(0xFF00897B)];

  Color _colorDe(String tipoSistema) {
    final i = _presets.indexWhere((p) => p.tipoSistema == tipoSistema);
    return i >= 0 ? _coloresPreset[i % _coloresPreset.length] : Colors.grey;
  }

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
                      'Con el mismo terreno y la misma demanda, ¿qué sistema de '
                      'racking conviene? Se calcula el almacén 3 veces — una por '
                      'cada sistema de la sección "Escenarios a comparar" más '
                      'abajo — y se comparan lado a lado. El catálogo, el '
                      'terreno y el andén de arriba son iguales en los 3; solo '
                      'cambia el sistema, así que la comparación es justa.',
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
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(
                  Icons.compare_arrows_outlined,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  'ESCENARIOS A COMPARAR',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.4,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 2, bottom: 8),
              child: Text(
                'Estos 3 sistemas son las opciones que se comparan abajo. Ajusta '
                'cómo se construye y opera cada uno si tus números reales son otros.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
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
              _resultadoComparacion(context, _resultado!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _tarjetaEscenario(BuildContext context, _PresetEscenario p) {
    final color = _colorDe(p.tipoSistema);
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withValues(alpha: 0.4), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Icon(p.icono, size: 20, color: color),
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

  /// Reemplaza la tabla ancha de antes (con scroll horizontal, donde la
  /// columna de accesibilidad quedaba cortada fuera de vista — justo la
  /// columna que CLAUDE.md sección 6.5 exige mostrar siempre junto al
  /// costo). Una tarjeta por escenario deja cada métrica en una fila
  /// legible, sin scroll, y el color de cada tarjeta es el mismo que su
  /// tarjeta de entrada de arriba.
  Widget _resultadoComparacion(BuildContext context, ResultadoM8 resultado) {
    final colores = Theme.of(context).colorScheme;
    final masBarato = resultado.escenarios.first;
    final masCaro = resultado.escenarios.last;
    final ahorroPorc = masCaro.costoPorPosicion == 0
        ? 0.0
        : (1 - masBarato.costoPorPosicion / masCaro.costoPorPosicion) * 100;

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
              Icon(Icons.emoji_events_outlined, size: 18, color: colores.onSecondaryContainer),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  resultado.escenarios.length > 1 && masCaro != masBarato
                      ? '${masBarato.nombre} sale más barato por posición: '
                            '${_formatoMoneda(masBarato.costoPorPosicion, decimales: 2)} vs '
                            '${_formatoMoneda(masCaro.costoPorPosicion, decimales: 2)} de '
                            '${masCaro.nombre} (${ahorroPorc.toStringAsFixed(0)}% menos). Pero '
                            'mira su accesibilidad abajo antes de decidir: más densidad casi '
                            'siempre cuesta algo en cómo se opera el almacén.'
                      : '${masBarato.nombre}: ${_formatoMoneda(masBarato.costoPorPosicion, decimales: 2)} por posición.',
                  style: TextStyle(color: colores.onSecondaryContainer, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        for (final e in resultado.escenarios) ...[
          _tarjetaResultadoEscenario(context, e, esGanador: e == masBarato),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _tarjetaResultadoEscenario(
    BuildContext context,
    ResultadoEscenarioM8 e, {
    required bool esGanador,
  }) {
    final color = _colorDe(e.tipoSistema);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: esGanador ? Colors.green.withValues(alpha: 0.06) : null,
        border: Border.all(
          color: esGanador ? Colors.green : color.withValues(alpha: 0.35),
          width: esGanador ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                e.nombre,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              if (esGanador) ...[
                const SizedBox(width: 6),
                const Tooltip(
                  message: 'Menor costo por posición instalada',
                  child: Icon(Icons.star, size: 16, color: Colors.amber),
                ),
              ],
              const Spacer(),
              Text(
                '${_formatoMoneda(e.costoPorPosicion, decimales: 2)} / posición',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: esGanador ? Colors.green.shade800 : null,
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          _filaResumenComparador(
            Icons.inventory_2_outlined,
            'Posiciones instaladas',
            '${e.posicionesInstaladas}',
          ),
          _filaResumenComparador(
            Icons.crop_free_outlined,
            'Superficie construida',
            '${(e.supConstruidaMm2 / 1000000).toStringAsFixed(1)} m²',
          ),
          _filaResumenComparador(
            Icons.percent,
            'Almacenamiento / construida',
            '${(e.relacionSuperficie * 100).toStringAsFixed(0)}%',
          ),
          _filaResumenComparador(
            Icons.route_outlined,
            'Distancia esperada de recorrido',
            '${(e.distanciaEsperadaMm / 1000).toStringAsFixed(1)} m',
          ),
          _filaResumenComparador(
            Icons.payments_outlined,
            'Inversión estimada',
            _formatoMoneda(e.inversionEstimada),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.accessibility_new_outlined, size: 16, color: Colors.grey.shade700),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    e.accesibilidad,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filaResumenComparador(IconData icono, String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(icono, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Expanded(child: Text(etiqueta, style: const TextStyle(fontSize: 13))),
          Text(valor, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }

  /// Miles separados por coma, sin depender del paquete `intl` — una
  /// justificación de dependencia no vale la pena por un separador de
  /// miles (CLAUDE.md: "ninguna dependencia nueva sin justificarla").
  String _formatoMoneda(double valor, {int decimales = 0}) {
    final texto = valor.toStringAsFixed(decimales);
    final partes = texto.split('.');
    final negativo = partes[0].startsWith('-');
    final enteros = negativo ? partes[0].substring(1) : partes[0];
    final buffer = StringBuffer();
    for (var i = 0; i < enteros.length; i++) {
      if (i > 0 && (enteros.length - i) % 3 == 0) buffer.write(',');
      buffer.write(enteros[i]);
    }
    final decimalTexto = partes.length > 1 ? '.${partes[1]}' : '';
    return '${negativo ? '-' : ''}$buffer$decimalTexto';
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
