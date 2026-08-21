import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

import '../../../data/local/database.dart';
import '../../../domain/geometria/generador_layout.dart';
import '../../../domain/motor/m2_posiciones.dart';
import '../../../domain/motor/m3_superficie.dart';
import '../../../domain/motor/m6_configuracion.dart';
import '../ficha_resultado/ficha_resultado_screen.dart';

/// Pantalla de entrada de la Fase 1: una familia de producto, un escenario
/// selectivo simple, tomando bastidor/viga/equipo del catálogo semilla ya
/// cargado. CLAUDE.md pide "sin UI elaborada" para esta fase — no hay CRUD
/// de proyectos ni de escenarios todavía, eso es de fases posteriores.
class EntradaCalculoScreen extends StatefulWidget {
  const EntradaCalculoScreen({super.key, required this.db});

  final AppDatabase db;

  @override
  State<EntradaCalculoScreen> createState() => _EntradaCalculoScreenState();
}

class _EntradaCalculoScreenState extends State<EntradaCalculoScreen> {
  final _formKey = GlobalKey<FormState>();

  List<CatalogoTarima> _tarimas = [];
  List<CatalogoBastidore> _bastidores = [];
  List<CatalogoViga> _vigas = [];
  List<CatalogoEquipo> _equipos = [];
  int? _holguraXMinimaMm;
  int? _holguraYMinimaMm;
  int? _separacionEspaldaMm;
  int? _holguraMuroMm;
  bool _cargando = true;

  CatalogoTarima? _tarimaSeleccionada;
  CatalogoBastidore? _bastidorSeleccionado;
  CatalogoViga? _vigaSeleccionada;
  CatalogoEquipo? _equipoSeleccionado;

  final _demandaAnualCtrl = TextEditingController(text: '12000');
  final _rotacionAnualCtrl = TextEditingController(text: '12');
  final _unidadesPorTarimaCtrl = TextEditingController(text: '40');
  final _altoCargaCtrl = TextEditingController(text: '1200');
  final _factorHoneycombCtrl = TextEditingController(text: '0.20');
  final _alturaLibreCtrl = TextEditingController(text: '8000');
  final _reservaTechoCtrl = TextEditingController(text: '450');
  final _largoDisponibleCtrl = TextEditingController(text: '30000');

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

  void _calcular() {
    setState(() => _error = null);
    if (!_formKey.currentState!.validate()) return;

    final tarima = _tarimaSeleccionada!;
    final bastidor = _bastidorSeleccionado!;
    final viga = _vigaSeleccionada!;
    final equipo = _equipoSeleccionado!;

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

      final resultadoM6 = evaluarConfiguraciones(
        modulos: resultadoM3.modulos,
        largoVigaMm: viga.largoMm,
        perfilAnchoBastidorMm: bastidor.perfilAnchoMm,
        fondoBastidorMm: bastidor.fondoMm,
        anchoPasilloMm: equipo.pasilloMinMm,
        separacionEspaldaMm: _separacionEspaldaMm!,
        holguraMuroMm: _holguraMuroMm!,
      );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => FichaResultadoScreen(
            resultadoM2: resultadoM2,
            resultadoM3: resultadoM3,
            resultadoLayout: resultadoLayout,
            resultadoM6: resultadoM6,
          ),
        ),
      );
    } on HolguraInvalidaException catch (e) {
      setState(() => _error = e.message);
    } on NivelesInsuficientesException catch (e) {
      setState(() => _error = e.message);
    } on LayoutInvalidoException catch (e) {
      setState(() => _error = e.message);
    } on ArgumentError catch (e) {
      setState(() => _error = e.message?.toString() ?? 'Entrada inválida.');
    } on FormatException {
      setState(() => _error = 'Revisa que todos los campos numéricos tengan un valor válido.');
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_tarimas.isEmpty || _bastidores.isEmpty || _vigas.isEmpty || _equipos.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('El catálogo semilla no cargó. Revisa CatalogoSeedLoader.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Cálculo rápido — M2 + M3')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Demanda', style: Theme.of(context).textTheme.titleMedium),
            _campoNumerico('Demanda anual (unidades/año)', _demandaAnualCtrl),
            _campoNumerico('Rotación anual (veces/año)', _rotacionAnualCtrl),
            _campoNumerico('Unidades por tarima', _unidadesPorTarimaCtrl, entero: true),
            _campoNumerico('Factor honeycomb (0 a 1)', _factorHoneycombCtrl),
            const Divider(height: 32),
            Text('Catálogo', style: Theme.of(context).textTheme.titleMedium),
            _dropdown('Tarima', _tarimas, _tarimaSeleccionada, (t) => t.codigo, (v) {
              setState(() => _tarimaSeleccionada = v);
            }),
            _dropdown('Bastidor', _bastidores, _bastidorSeleccionado, (b) => b.codigo, (v) {
              setState(() => _bastidorSeleccionado = v);
            }),
            _dropdown('Viga', _vigas, _vigaSeleccionada, (v) => v.codigo, (v) {
              setState(() => _vigaSeleccionada = v);
            }),
            _dropdown('Equipo', _equipos, _equipoSeleccionado, (eq) => eq.codigo, (v) {
              setState(() => _equipoSeleccionado = v);
            }),
            const Divider(height: 32),
            Text('Instalación', style: Theme.of(context).textTheme.titleMedium),
            _campoNumerico('Alto de carga (mm, sin la tarima)', _altoCargaCtrl, entero: true),
            _campoNumerico('Altura libre (mm)', _alturaLibreCtrl, entero: true),
            _campoNumerico('Reserva de techo (mm)', _reservaTechoCtrl, entero: true),
            _campoNumerico('Largo disponible para filas (mm)', _largoDisponibleCtrl, entero: true),
            const SizedBox(height: 24),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
            FilledButton(onPressed: _calcular, child: const Text('Calcular')),
          ],
        ),
      ),
    );
  }

  Widget _campoNumerico(String etiqueta, TextEditingController ctrl, {bool entero = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        controller: ctrl,
        decoration: InputDecoration(labelText: etiqueta),
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
    void Function(T?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: DropdownButtonFormField<T>(
        initialValue: seleccionado,
        decoration: InputDecoration(labelText: etiqueta),
        items: opciones
            .map((o) => DropdownMenuItem(value: o, child: Text(etiquetaDe(o))))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
