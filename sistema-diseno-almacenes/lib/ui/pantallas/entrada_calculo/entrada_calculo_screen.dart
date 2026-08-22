import 'dart:io';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/tour/induccion_screen.dart';
import '../../../core/tour/tour_controller.dart';
import '../../../data/local/database.dart';
import '../../../domain/export/proyecto_portable.dart';
import '../../../domain/geometria/generador_layout.dart';
import '../../../domain/geometria/generador_prismas_3d.dart';
import '../../../domain/motor/m2_posiciones.dart';
import '../../../domain/motor/m3_superficie.dart';
import '../../../domain/motor/m6_configuracion.dart';
import '../../../domain/motor/m7_anden.dart';
import '../comparador_escenarios/comparador_escenarios_screen.dart';
import '../ficha_resultado/ficha_resultado_screen.dart';
import '../importar_proyecto/importar_proyecto_screen.dart';
import '../pronostico/pronostico_screen.dart';

/// Pantalla de entrada de la Fase 1: una familia de producto, un escenario
/// selectivo simple, tomando bastidor/viga/equipo del catálogo semilla ya
/// cargado. CLAUDE.md pide "sin UI elaborada" para esta fase — no hay CRUD
/// de proyectos ni de escenarios todavía, eso es de fases posteriores. La
/// simplicidad es de alcance funcional, no de terminado visual.
class EntradaCalculoScreen extends StatefulWidget {
  const EntradaCalculoScreen({super.key, required this.db, required this.tour});

  final AppDatabase db;
  final TourController tour;

  @override
  State<EntradaCalculoScreen> createState() => _EntradaCalculoScreenState();
}

class _EntradaCalculoScreenState extends State<EntradaCalculoScreen> {
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

  CatalogoTarima? _tarimaSeleccionada;
  CatalogoBastidore? _bastidorSeleccionado;
  CatalogoViga? _vigaSeleccionada;
  CatalogoEquipo? _equipoSeleccionado;
  CatalogoCamione? _camionSeleccionado;

  final _demandaAnualCtrl = TextEditingController(text: '12000');
  final _rotacionAnualCtrl = TextEditingController(text: '12');
  final _unidadesPorTarimaCtrl = TextEditingController(text: '40');
  final _altoCargaCtrl = TextEditingController(text: '1200');
  final _factorHoneycombCtrl = TextEditingController(text: '0.20');
  final _alturaLibreCtrl = TextEditingController(text: '8000');
  final _reservaTechoCtrl = TextEditingController(text: '450');
  final _largoDisponibleCtrl = TextEditingController(text: '30000');

  final _camionesHoraPicoCtrl = TextEditingController(text: '4');
  final _tiempoServicioMinCtrl = TextEditingController(text: '30');
  final _esperaObjetivoMinCtrl = TextEditingController(text: '15');
  final _espaciamientoPuertaCtrl = TextEditingController(text: '3600');
  final _areaStagingCtrl = TextEditingController(text: '15');

  String? _error;
  bool _calculando = false;

  @override
  void initState() {
    super.initState();
    _cargarCatalogo();
    if (!widget.tour.yaVisto) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _abrirInduccion());
    }
  }

  Future<void> _abrirInduccion() async {
    if (!mounted) return;
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => InduccionScreen(tour: widget.tour)));
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
      _camionSeleccionado = camiones.isNotEmpty ? camiones.first : null;
      _holguraXMinimaMm = holguraX?.valor;
      _holguraYMinimaMm = holguraY?.valor;
      _separacionEspaldaMm = separacionEspalda?.valor;
      _holguraMuroMm = holguraMuro?.valor;
      _tarimaSeleccionada = tarimas.isNotEmpty ? tarimas.first : null;
      _bastidorSeleccionado = bastidores.isNotEmpty ? bastidores.first : null;
      _vigaSeleccionada = vigas.isNotEmpty ? vigas.first : null;
      // Por defecto, el equipo con mayor elevación: el primero del catálogo
      // por orden de inserción suele ser una transpaleta manual (apenas
      // ~200mm de elevación), que con cualquier altura libre razonable no
      // alcanza ni para un nivel — mala selección inicial para alguien que
      // solo quiere probar la pantalla.
      _equipoSeleccionado = equipos.isNotEmpty
          ? equipos.reduce((a, b) => a.elevacionMaxMm >= b.elevacionMaxMm ? a : b)
          : null;
      _cargando = false;
    });
  }

  Future<void> _exportarProyecto() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      final proyecto = ProyectoPortable(
        version: ProyectoPortable.versionActual,
        nombre: 'Proyecto',
        demandaAnual: double.parse(_demandaAnualCtrl.text),
        rotacionAnual: double.parse(_rotacionAnualCtrl.text),
        unidadesPorTarima: int.parse(_unidadesPorTarimaCtrl.text),
        factorHoneycomb: double.parse(_factorHoneycombCtrl.text),
        altoCargaMm: int.parse(_altoCargaCtrl.text),
        alturaLibreMm: int.parse(_alturaLibreCtrl.text),
        reservaTechoMm: int.parse(_reservaTechoCtrl.text),
        largoDisponibleMm: int.parse(_largoDisponibleCtrl.text),
        camionesHoraPico: double.parse(_camionesHoraPicoCtrl.text),
        tiempoServicioMinutos: double.parse(_tiempoServicioMinCtrl.text),
        esperaObjetivoMinutos: double.parse(_esperaObjetivoMinCtrl.text),
        espaciamientoPuertaMm: int.parse(_espaciamientoPuertaCtrl.text),
        areaStagingM2: double.parse(_areaStagingCtrl.text),
        tarima: _tarimaSeleccionada!,
        bastidor: _bastidorSeleccionado!,
        viga: _vigaSeleccionada!,
        equipo: _equipoSeleccionado!,
        camion: _camionSeleccionado!,
      );

      final directorio = await getApplicationDocumentsDirectory();
      final marca = DateTime.now().toIso8601String().replaceAll(RegExp(r'[:.]'), '-');
      final archivo = File('${directorio.path}/proyecto_$marca.json');
      await archivo.writeAsString(proyecto.toJsonString());

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Proyecto exportado en ${archivo.path}'),
          duration: const Duration(seconds: 6),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No se pudo exportar: $e')));
    }
  }

  Future<void> _importarProyecto() async {
    final archivo = await Navigator.of(
      context,
    ).push<File>(MaterialPageRoute(builder: (_) => const ImportarProyectoScreen()));
    if (archivo == null) return;

    try {
      final proyecto = ProyectoPortable.fromJsonString(await archivo.readAsString());

      final tarima = await _resolverTarima(widget.db, proyecto.tarima);
      final bastidor = await _resolverBastidor(widget.db, proyecto.bastidor);
      final viga = await _resolverViga(widget.db, proyecto.viga);
      final equipo = await _resolverEquipo(widget.db, proyecto.equipo);
      final camion = await _resolverCamion(widget.db, proyecto.camion);

      await _cargarCatalogo();
      if (!mounted) return;
      setState(() {
        _tarimaSeleccionada = tarima;
        _bastidorSeleccionado = bastidor;
        _vigaSeleccionada = viga;
        _equipoSeleccionado = equipo;
        _camionSeleccionado = camion;
        _demandaAnualCtrl.text = _formatearNumero(proyecto.demandaAnual);
        _rotacionAnualCtrl.text = _formatearNumero(proyecto.rotacionAnual);
        _unidadesPorTarimaCtrl.text = '${proyecto.unidadesPorTarima}';
        _altoCargaCtrl.text = '${proyecto.altoCargaMm}';
        _factorHoneycombCtrl.text = _formatearNumero(proyecto.factorHoneycomb);
        _alturaLibreCtrl.text = '${proyecto.alturaLibreMm}';
        _reservaTechoCtrl.text = '${proyecto.reservaTechoMm}';
        _largoDisponibleCtrl.text = '${proyecto.largoDisponibleMm}';
        _camionesHoraPicoCtrl.text = _formatearNumero(proyecto.camionesHoraPico);
        _tiempoServicioMinCtrl.text = _formatearNumero(proyecto.tiempoServicioMinutos);
        _esperaObjetivoMinCtrl.text = _formatearNumero(proyecto.esperaObjetivoMinutos);
        _espaciamientoPuertaCtrl.text = '${proyecto.espaciamientoPuertaMm}';
        _areaStagingCtrl.text = _formatearNumero(proyecto.areaStagingM2);
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Proyecto importado.')));
    } on FormatException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Archivo inválido: ${e.message}')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No se pudo importar: $e')));
    }
  }

  String _formatearNumero(double v) => v == v.roundToDouble() ? '${v.toInt()}' : '$v';

  Future<void> _calcular() async {
    setState(() => _error = null);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _calculando = true);
    // Deja pintar el spinner del botón antes de bloquear el hilo de UI con
    // el cálculo (instantáneo en la práctica, pero así queda listo el
    // patrón para cuando la Fase 4+ agregue cálculos más pesados).
    await Future.delayed(Duration.zero);

    final tarima = _tarimaSeleccionada!;
    final bastidor = _bastidorSeleccionado!;
    final viga = _vigaSeleccionada!;
    final equipo = _equipoSeleccionado!;
    final camion = _camionSeleccionado!;

    try {
      final resultadoM2 = calcularPosicionesRequeridas(
        familias: [
          DemandaFamilia(
            nombre: 'Familia A',
            demandaAnual: double.parse(_demandaAnualCtrl.text),
            rotacionAnual: double.parse(_rotacionAnualCtrl.text),
            unidadesPorTarima: int.parse(_unidadesPorTarimaCtrl.text),
          ),
        ],
        factorHoneycomb: double.parse(_factorHoneycombCtrl.text),
      );

      final resultadoM3 = calcularSuperficie(
        EntradaM3(
          posicionesRequeridas: resultadoM2.posicionesRequeridas,
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
        ),
      );

      final resultadoLayout = generarLayout(
        filas: resultadoM3.filas,
        modulosPorFila: resultadoM3.modulosPorFila,
        largoVigaMm: viga.largoMm,
        perfilAnchoBastidorMm: bastidor.perfilAnchoMm,
        fondoBastidorMm: bastidor.fondoMm,
        anchoPasilloMm: equipo.pasilloMinMm,
        separacionEspaldaMm: _separacionEspaldaMm!,
        holguraMuroMm: _holguraMuroMm!,
      );

      final prismas3D = generarPrismas3D(
        layout: resultadoLayout,
        modulosPorFila: resultadoM3.modulosPorFila,
        niveles: resultadoM3.niveles,
        pasoNivelMm: resultadoM3.pasoNivelMm,
        largoVigaMm: viga.largoMm,
        peralteVigaMm: viga.peralteMm,
        perfilAnchoBastidorMm: bastidor.perfilAnchoMm,
        perfilFondoBastidorMm: bastidor.perfilFondoMm,
        fondoBastidorMm: bastidor.fondoMm,
      );

      final resultadoM6 = evaluarConfiguraciones(
        modulos: resultadoM3.modulos,
        largoVigaMm: viga.largoMm,
        perfilAnchoBastidorMm: bastidor.perfilAnchoMm,
        fondoBastidorMm: bastidor.fondoMm,
        anchoPasilloMm: equipo.pasilloMinMm,
        separacionEspaldaMm: _separacionEspaldaMm!,
        holguraMuroMm: _holguraMuroMm!,
      );

      final resultadoM7 = calcularAnden(
        EntradaM7(
          camionesHoraPico: double.parse(_camionesHoraPicoCtrl.text),
          tiempoMedioServicioHoras: double.parse(_tiempoServicioMinCtrl.text) / 60,
          esperaObjetivoHoras: double.parse(_esperaObjetivoMinCtrl.text) / 60,
          espaciamientoPuertaMm: int.parse(_espaciamientoPuertaCtrl.text),
          patioMinMm: camion.patioMinMm,
          areaStagingPorPuertaMm2: (double.parse(_areaStagingCtrl.text) * 1000000).round(),
        ),
      );

      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => FichaResultadoScreen(
            resultadoM2: resultadoM2,
            resultadoM3: resultadoM3,
            resultadoLayout: resultadoLayout,
            resultadoM6: resultadoM6,
            resultadoM7: resultadoM7,
            prismas3D: prismas3D,
          ),
        ),
      );
    } on HolguraInvalidaException catch (e) {
      setState(() => _error = e.message);
    } on NivelesInsuficientesException catch (e) {
      setState(() => _error = e.message);
    } on LayoutInvalidoException catch (e) {
      setState(() => _error = e.message);
    } on EspaciamientoPuertaInvalidoException catch (e) {
      setState(() => _error = e.message);
    } on PuertasInsuficientesException catch (e) {
      setState(() => _error = e.message);
    } on ArgumentError catch (e) {
      setState(() => _error = e.message?.toString() ?? 'Entrada inválida.');
    } on FormatException {
      setState(() => _error = 'Revisa que todos los campos numéricos tengan un valor válido.');
    } finally {
      if (mounted) setState(() => _calculando = false);
    }
  }

  Future<void> _abrirPronostico() async {
    final valor = await Navigator.of(
      context,
    ).push<double>(MaterialPageRoute(builder: (_) => const PronosticoScreen()));
    if (valor != null) {
      setState(() => _demandaAnualCtrl.text = valor.toStringAsFixed(1));
    }
  }

  @override
  void dispose() {
    _demandaAnualCtrl.dispose();
    _rotacionAnualCtrl.dispose();
    _unidadesPorTarimaCtrl.dispose();
    _altoCargaCtrl.dispose();
    _factorHoneycombCtrl.dispose();
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
    if (_tarimas.isEmpty ||
        _bastidores.isEmpty ||
        _vigas.isEmpty ||
        _equipos.isEmpty ||
        _camiones.isEmpty) {
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
      appBar: AppBar(
        title: const Text('Nuevo cálculo'),
        actions: [
          Tooltip(
            message: 'Ver la inducción guiada de nuevo',
            child: IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: _abrirInduccion,
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _seccion(
              context,
              icono: Icons.trending_up,
              titulo: 'Demanda',
              children: [
                _campoNumerico(
                  'Demanda anual',
                  _demandaAnualCtrl,
                  ayuda: 'Unidades despachadas por año',
                  tooltip:
                      'Súmala de tus reportes de ventas o despachos del último '
                      'año. Si no tienes ese historial a mano, usa "Pronosticar '
                      'demanda" abajo con los datos que sí tengas.',
                ),
                _campoNumerico(
                  'Rotación anual',
                  _rotacionAnualCtrl,
                  ayuda: 'Veces que se repone el inventario al año',
                  tooltip:
                      'rotación = demanda anual ÷ inventario promedio. Si no la '
                      'tienes calculada, pregúntale a inventarios o al ERP; una '
                      'rotación de 12 significa que el inventario completo se '
                      'renueva una vez al mes en promedio.',
                ),
                _campoNumerico(
                  'Unidades por tarima',
                  _unidadesPorTarimaCtrl,
                  entero: true,
                  ayuda: 'Cuántas unidades caben en una tarima',
                  tooltip:
                      'Cajas por capa × capas por tarima, para tu forma real de '
                      'paletizar. Quien arma las tarimas en el almacén lo sabe de '
                      'memoria.',
                ),
                _campoNumerico(
                  'Factor honeycomb',
                  _factorHoneycombCtrl,
                  ayuda: 'Ej. 0.20 = 20% de capacidad perdida',
                  tooltip:
                      'Posiciones que existen pero no se pueden usar por reglas '
                      'de acomodo (huecos parciales). Típico: 0.15–0.30.',
                ),
                const SizedBox(height: 4),
                OutlinedButton.icon(
                  onPressed: _abrirPronostico,
                  icon: const Icon(Icons.timeline_outlined),
                  label: const Text('Pronosticar demanda (M1)'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _seccion(
              context,
              icono: Icons.inventory_2_outlined,
              titulo: 'Catálogo',
              children: [
                _dropdown(
                  'Tarima',
                  Icons.inventory_2_outlined,
                  _tarimas,
                  _tarimaSeleccionada,
                  (t) => '${t.codigo} · ${t.largoMm}×${t.anchoMm} mm',
                  (v) => setState(() => _tarimaSeleccionada = v),
                  tooltip:
                      'La tarima que realmente usas. Si no está en la lista, '
                      'agrégala en Catálogo con las medidas reales de tu '
                      'proveedor — no te acerques con la más parecida.',
                ),
                _dropdown(
                  'Bastidor',
                  Icons.view_column_outlined,
                  _bastidores,
                  _bastidorSeleccionado,
                  (b) => '${b.codigo} · fondo ${b.fondoMm} mm',
                  (v) => setState(() => _bastidorSeleccionado = v),
                  tooltip:
                      'El bastidor de tu proveedor de racks. Pídele la ficha '
                      'técnica con el fondo y los perfiles — son los que entran '
                      'directo al cálculo de niveles y superficie.',
                ),
                _dropdown(
                  'Viga',
                  Icons.straighten,
                  _vigas,
                  _vigaSeleccionada,
                  (v) => '${v.codigo} · ${v.largoMm} mm',
                  (v) => setState(() => _vigaSeleccionada = v),
                  tooltip:
                      'El largo se mide entre caras internas de puntales, no de '
                      'extremo a extremo — es el error más común al medir una '
                      'viga en campo.',
                ),
                _dropdown(
                  'Equipo',
                  Icons.precision_manufacturing_outlined,
                  _equipos,
                  _equipoSeleccionado,
                  (e) => '${e.codigo} · eleva ${e.elevacionMaxMm} mm',
                  (v) => setState(() => _equipoSeleccionado = v),
                  tooltip:
                      'El montacargas o equipo de manejo que de verdad vas a '
                      'operar: su elevación limita los niveles y su pasillo '
                      'mínimo entra en la superficie construida.',
                ),
              ],
            ),
            const SizedBox(height: 16),
            _seccion(
              context,
              icono: Icons.warehouse_outlined,
              titulo: 'Instalación',
              children: [
                _campoNumerico(
                  'Alto de carga',
                  _altoCargaCtrl,
                  entero: true,
                  ayuda: 'Altura de la carga, sin contar la tarima',
                  tooltip:
                      'Mide tu producto ya paletizado, sin la tarima. Si varía '
                      'entre productos, usa el más alto que vaya a ese rack.',
                ),
                _campoNumerico(
                  'Altura libre',
                  _alturaLibreCtrl,
                  entero: true,
                  ayuda: 'Altura libre bajo techo del almacén',
                  tooltip:
                      'Del piso a lo más bajo de la estructura de techo (viga, '
                      'ducto o luminaria), no hasta el domo si hay tragaluces. '
                      'Para un edificio existente, mídelo; para uno nuevo, es una '
                      'decisión del proyecto.',
                ),
                _campoNumerico(
                  'Reserva de techo',
                  _reservaTechoCtrl,
                  entero: true,
                  ayuda: 'Espacio para rociadores y luminarias',
                  tooltip: 'Se resta de la altura libre antes de calcular niveles.',
                ),
                _campoNumerico(
                  'Largo disponible',
                  _largoDisponibleCtrl,
                  entero: true,
                  ayuda: 'Longitud del terreno para colocar las filas',
                  tooltip:
                      'El largo real del área para racks, ya descontando '
                      'oficinas u otras zonas fijas del terreno o nave.',
                ),
              ],
            ),
            const SizedBox(height: 16),
            _seccion(
              context,
              icono: Icons.local_shipping_outlined,
              titulo: 'Andén',
              children: [
                _dropdown(
                  'Camión de diseño',
                  Icons.local_shipping_outlined,
                  _camiones,
                  _camionSeleccionado,
                  (c) => '${c.codigo} · patio ${c.patioMinMm} mm',
                  (v) => setState(() => _camionSeleccionado = v),
                  tooltip:
                      'El camión más grande que normalmente recibes o '
                      'despachas — no el promedio, el más exigente en patio de '
                      'maniobras.',
                ),
                _campoNumerico(
                  'Camiones en hora pico',
                  _camionesHoraPicoCtrl,
                  ayuda: 'La hora con más llegadas, no el promedio diario',
                  tooltip:
                      'El andén se dimensiona con la hora pico, no con el '
                      'promedio del día: un almacén con 40 camiones en 8 horas '
                      'pero 15 entre las 7 y las 9 necesita puertas para las 7.',
                ),
                _campoNumerico(
                  'Tiempo de servicio (minutos)',
                  _tiempoServicioMinCtrl,
                  ayuda: 'Cuánto tarda un camión en cargar o descargar',
                  tooltip:
                      'Cronometra unos cuantos camiones típicos, desde que se '
                      'estacionan hasta que salen, o pregúntale al jefe de andén.',
                ),
                _campoNumerico(
                  'Espera objetivo (minutos)',
                  _esperaObjetivoMinCtrl,
                  ayuda: 'Máximo tiempo aceptable en cola antes de entrar',
                  tooltip:
                      'No es un dato medido, es una decisión de servicio: '
                      '¿cuánto tiempo de espera le vas a tolerar a un '
                      'transportista antes de que se queje o te cobre demora?',
                ),
                _campoNumerico(
                  'Espaciamiento entre puertas',
                  _espaciamientoPuertaCtrl,
                  entero: true,
                  ayuda: 'Mínimo normativo 3000mm, típico 3600mm',
                  tooltip:
                      'Distancia entre el centro de una puerta y la siguiente. '
                      'El sistema rechaza valores por debajo de 3000mm.',
                ),
                _campoNumerico(
                  'Área de preparación por puerta (m²)',
                  _areaStagingCtrl,
                  ayuda: 'Espacio de staging frente a cada puerta',
                  tooltip:
                      'El espacio frente a cada puerta para acomodar tarimas '
                      'mientras se carga o descarga. Si no lo has medido, '
                      '15–20 m² por puerta es un punto de partida razonable.',
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_error != null) _bannerError(context, _error!),
            if (_error != null) const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _calculando ? null : _calcular,
              icon: _calculando
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.calculate_outlined),
              label: Text(_calculando ? 'Calculando…' : 'Calcular'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ComparadorEscenariosScreen(db: widget.db)),
                );
              },
              icon: const Icon(Icons.compare_arrows_outlined),
              label: const Text('Comparar escenarios de racking (M8)'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _exportarProyecto,
                    icon: const Icon(Icons.upload_file_outlined),
                    label: const Text('Exportar proyecto'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _importarProyecto,
                    icon: const Icon(Icons.download_outlined),
                    label: const Text('Importar proyecto'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _seccion(
    BuildContext context, {
    required IconData icono,
    required String titulo,
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
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _bannerError(BuildContext context, String mensaje) {
    final colores = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colores.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, color: colores.onErrorContainer, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(mensaje, style: TextStyle(color: colores.onErrorContainer)),
          ),
        ],
      ),
    );
  }

  Widget _campoNumerico(
    String etiqueta,
    TextEditingController ctrl, {
    bool entero = false,
    String? ayuda,
    String? tooltip,
  }) {
    final campo = TextFormField(
      controller: ctrl,
      decoration: InputDecoration(
        labelText: etiqueta,
        helperText: ayuda,
        helperMaxLines: 2,
        isDense: true,
        suffixIcon: tooltip != null
            ? Tooltip(
                message: tooltip,
                child: const Icon(Icons.info_outline, size: 18),
              )
            : null,
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: !entero),
      validator: (v) {
        if (v == null || v.isEmpty) return 'Requerido';
        final parsed = entero ? int.tryParse(v) : double.tryParse(v);
        if (parsed == null) return 'Número inválido';
        return null;
      },
    );
    return Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: campo);
  }

  Widget _dropdown<T>(
    String etiqueta,
    IconData icono,
    List<T> opciones,
    T? seleccionado,
    String Function(T) etiquetaDe,
    void Function(T?) onChanged, {
    String? tooltip,
  }) {
    // El tooltip va afuera del campo, no como `suffixIcon`: el propio
    // DropdownButtonFormField ya usa ese espacio para su flecha — ponerle un
    // suffixIcon la tapa y el campo deja de verse como desplegable.
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: DropdownButtonFormField<T>(
              initialValue: seleccionado,
              decoration: InputDecoration(
                labelText: etiqueta,
                isDense: true,
                prefixIcon: Icon(icono, size: 20),
              ),
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
}

/// Busca una fila de catálogo por `codigo` (la clave de negocio, no el id
/// local); si no existe la inserta como fila del usuario (`es_semilla =
/// false`) con los valores importados. Es lo que hace que "abrir en otra
/// máquina" (CLAUDE.md sección 9) funcione de verdad aunque el catálogo
/// semilla de esa máquina no tenga ese código todavía.
Future<CatalogoTarima> _resolverTarima(AppDatabase db, CatalogoTarima importada) async {
  final existente = await (db.select(
    db.catalogoTarimas,
  )..where((t) => t.codigo.equals(importada.codigo))).getSingleOrNull();
  if (existente != null) return existente;
  final id = await db
      .into(db.catalogoTarimas)
      .insert(
        CatalogoTarimasCompanion.insert(
          codigo: importada.codigo,
          largoMm: importada.largoMm,
          anchoMm: importada.anchoMm,
          altoMm: importada.altoMm,
          taraG: importada.taraG,
          cargaDinG: Value(importada.cargaDinG),
          cargaEstG: Value(importada.cargaEstG),
          region: Value(importada.region),
          fuente: importada.fuente,
          esSemilla: const Value(false),
        ),
      );
  // Se relee de la BD en vez de copyWith(id: id) sobre `importada`: la fila
  // insertada tiene esSemilla=false, y `importada` (del JSON) puede traer
  // esSemilla=true — copyWith habría devuelto un valor que no es igual, por
  // `==`, a ninguna fila de la lista recién recargada, y
  // DropdownButtonFormField exige exactamente una coincidencia.
  return (db.select(
    db.catalogoTarimas,
  )..where((t) => t.id.equals(id))).getSingle();
}

Future<CatalogoBastidore> _resolverBastidor(AppDatabase db, CatalogoBastidore importada) async {
  final existente = await (db.select(
    db.catalogoBastidores,
  )..where((b) => b.codigo.equals(importada.codigo))).getSingleOrNull();
  if (existente != null) return existente;
  final id = await db
      .into(db.catalogoBastidores)
      .insert(
        CatalogoBastidoresCompanion.insert(
          codigo: importada.codigo,
          fondoMm: importada.fondoMm,
          alturaMm: importada.alturaMm,
          perfilAnchoMm: importada.perfilAnchoMm,
          perfilFondoMm: importada.perfilFondoMm,
          fuente: importada.fuente,
          esSemilla: const Value(false),
        ),
      );
  return (db.select(
    db.catalogoBastidores,
  )..where((b) => b.id.equals(id))).getSingle();
}

Future<CatalogoViga> _resolverViga(AppDatabase db, CatalogoViga importada) async {
  final existente = await (db.select(
    db.catalogoVigas,
  )..where((v) => v.codigo.equals(importada.codigo))).getSingleOrNull();
  if (existente != null) return existente;
  final id = await db
      .into(db.catalogoVigas)
      .insert(
        CatalogoVigasCompanion.insert(
          codigo: importada.codigo,
          largoMm: importada.largoMm,
          peralteMm: importada.peralteMm,
          capacidadParG: Value(importada.capacidadParG),
          fuente: importada.fuente,
          esSemilla: const Value(false),
        ),
      );
  return (db.select(db.catalogoVigas)..where((v) => v.id.equals(id))).getSingle();
}

Future<CatalogoEquipo> _resolverEquipo(AppDatabase db, CatalogoEquipo importada) async {
  final existente = await (db.select(
    db.catalogoEquipos,
  )..where((e) => e.codigo.equals(importada.codigo))).getSingleOrNull();
  if (existente != null) return existente;
  final id = await db
      .into(db.catalogoEquipos)
      .insert(
        CatalogoEquiposCompanion.insert(
          codigo: importada.codigo,
          tipo: importada.tipo,
          claseEn: Value(importada.claseEn),
          pasilloMinMm: importada.pasilloMinMm,
          pasilloMaxMm: importada.pasilloMaxMm,
          elevacionMaxMm: importada.elevacionMaxMm,
          alturaMastilMm: Value(importada.alturaMastilMm),
          requiereGuiado: Value(importada.requiereGuiado),
          costoUnitarioCent: Value(importada.costoUnitarioCent),
          fuente: importada.fuente,
          esSemilla: const Value(false),
        ),
      );
  return (db.select(
    db.catalogoEquipos,
  )..where((e) => e.id.equals(id))).getSingle();
}

Future<CatalogoCamione> _resolverCamion(AppDatabase db, CatalogoCamione importada) async {
  final existente = await (db.select(
    db.catalogoCamiones,
  )..where((c) => c.codigo.equals(importada.codigo))).getSingleOrNull();
  if (existente != null) return existente;
  final id = await db
      .into(db.catalogoCamiones)
      .insert(
        CatalogoCamionesCompanion.insert(
          codigo: importada.codigo,
          largoMm: importada.largoMm,
          anchoMm: importada.anchoMm,
          patioMinMm: importada.patioMinMm,
          fuente: importada.fuente,
          esSemilla: const Value(false),
        ),
      );
  return (db.select(
    db.catalogoCamiones,
  )..where((c) => c.id.equals(id))).getSingle();
}
