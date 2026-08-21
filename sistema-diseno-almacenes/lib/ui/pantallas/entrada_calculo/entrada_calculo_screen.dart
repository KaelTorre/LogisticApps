import 'package:drift/drift.dart' hide Column;
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
/// de proyectos ni de escenarios todavía, eso es de fases posteriores. La
/// simplicidad es de alcance funcional, no de terminado visual.
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
  bool _calculando = false;

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

      if (!mounted) return;
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
    } finally {
      if (mounted) setState(() => _calculando = false);
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
      appBar: AppBar(title: const Text('Nuevo cálculo')),
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
                ),
                _campoNumerico(
                  'Rotación anual',
                  _rotacionAnualCtrl,
                  ayuda: 'Veces que se repone el inventario al año',
                ),
                _campoNumerico(
                  'Unidades por tarima',
                  _unidadesPorTarimaCtrl,
                  entero: true,
                  ayuda: 'Cuántas unidades caben en una tarima',
                ),
                _campoNumerico(
                  'Factor honeycomb',
                  _factorHoneycombCtrl,
                  ayuda: 'Ej. 0.20 = 20% de capacidad perdida',
                  tooltip:
                      'Posiciones que existen pero no se pueden usar por reglas '
                      'de acomodo (huecos parciales). Típico: 0.15–0.30.',
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
                ),
                _dropdown(
                  'Bastidor',
                  Icons.view_column_outlined,
                  _bastidores,
                  _bastidorSeleccionado,
                  (b) => '${b.codigo} · fondo ${b.fondoMm} mm',
                  (v) => setState(() => _bastidorSeleccionado = v),
                ),
                _dropdown(
                  'Viga',
                  Icons.straighten,
                  _vigas,
                  _vigaSeleccionada,
                  (v) => '${v.codigo} · ${v.largoMm} mm',
                  (v) => setState(() => _vigaSeleccionada = v),
                ),
                _dropdown(
                  'Equipo',
                  Icons.precision_manufacturing_outlined,
                  _equipos,
                  _equipoSeleccionado,
                  (e) => '${e.codigo} · eleva ${e.elevacionMaxMm} mm',
                  (v) => setState(() => _equipoSeleccionado = v),
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
                ),
                _campoNumerico(
                  'Altura libre',
                  _alturaLibreCtrl,
                  entero: true,
                  ayuda: 'Altura libre bajo techo del almacén',
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
    void Function(T?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
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
    );
  }
}
