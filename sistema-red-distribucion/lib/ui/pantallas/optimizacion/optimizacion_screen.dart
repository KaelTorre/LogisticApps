import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/estado/proyecto_activo.dart';
import '../../../data/models/celda_matriz.dart';
import '../../../data/models/escenario.dart';
import '../../../data/models/escenario_almacen.dart';
import '../../../data/models/escenario_asignacion.dart';
import '../../../data/models/escenario_costo.dart';
import '../../../data/models/memoria_calculo.dart';
import '../../../data/models/punto_curva.dart';
import '../../../data/repositories/celda_matriz_repository.dart';
import '../../../data/repositories/escenario_almacen_repository.dart';
import '../../../data/repositories/escenario_asignacion_repository.dart';
import '../../../data/repositories/escenario_costo_repository.dart';
import '../../../data/repositories/escenario_repository.dart';
import '../../../data/repositories/memoria_calculo_repository.dart';
import '../../../data/repositories/parametros_costo_repository.dart';
import '../../../data/repositories/planta_repository.dart';
import '../../../data/repositories/punto_curva_repository.dart';
import '../../../data/repositories/sitio_candidato_repository.dart';
import '../../../data/repositories/zona_demanda_repository.dart';
import '../../../domain/motor/evaluador_costo.dart';
import '../../../domain/motor/fila_memoria.dart';
import '../../../domain/motor/m4_costo_total.dart';
import '../../../domain/motor/m5_asignacion.dart';
import '../../../domain/motor/m6_heuristicas.dart';
import '../../../domain/motor/m8_barrido.dart';
import '../../../domain/motor/tarifas.dart';

const _metodos = [
  ('add', 'ADD'),
  ('drop', 'DROP'),
  ('intercambio', 'Intercambio (Teitz y Bart)'),
  ('recocido', 'Recocido simulado'),
  ('enumeracion', 'Enumeración exhaustiva (óptimo exacto)'),
  ('barrido', 'Barrido (curva de costo)'),
];

const _limiteEnumeracion = 14;

/// Pantalla 10 (CLAUDE.md sección 8): selección de método, `p` fijo o
/// libre, ejecución con progreso y cancelación (Fase 6). Al terminar con
/// éxito, persiste un `Escenario` completo (almacenes, asignaciones, costo
/// por rubro, memoria de cálculo) — una cancelación o un error nunca deja
/// nada a medias, porque toda la persistencia ocurre después de que la
/// búsqueda ya terminó bien.
class OptimizacionScreen extends StatefulWidget {
  const OptimizacionScreen({super.key});

  @override
  State<OptimizacionScreen> createState() => _OptimizacionScreenState();
}

class _OptimizacionScreenState extends State<OptimizacionScreen> {
  final _nombreCtrl = TextEditingController();
  final _pFijoCtrl = TextEditingController();
  final _semillaCtrl = TextEditingController(text: '42');

  String _metodo = 'add';
  bool _conRestriccionCapacidad = false;
  bool _ejecutando = false;
  String? _progresoTexto;
  String? _error;
  String? _resumen;
  TokenCancelacion? _tokenActual;
  int _numCandidatos = 0;
  bool _cargando = true;

  int get _proyectoId => context.read<ProyectoActivo>().proyecto!.id!;

  @override
  void initState() {
    super.initState();
    _cargarConteoCandidatos();
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _pFijoCtrl.dispose();
    _semillaCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargarConteoCandidatos() async {
    final candidatos = await context.read<SitioCandidatoRepository>().obtenerPorProyecto(_proyectoId);
    if (!mounted) return;
    setState(() {
      _numCandidatos = candidatos.length;
      _cargando = false;
    });
  }

  void _cancelar() => _tokenActual?.cancelar();

  Future<void> _ejecutar() async {
    final proyectoId = _proyectoId;
    final candidatoRepo = context.read<SitioCandidatoRepository>();
    final plantaRepo = context.read<PlantaRepository>();
    final zonaRepo = context.read<ZonaDemandaRepository>();
    final celdaRepo = context.read<CeldaMatrizRepository>();
    final parametrosRepo = context.read<ParametrosCostoRepository>();
    final escenarioRepo = context.read<EscenarioRepository>();
    final escenarioAlmacenRepo = context.read<EscenarioAlmacenRepository>();
    final escenarioAsignacionRepo = context.read<EscenarioAsignacionRepository>();
    final escenarioCostoRepo = context.read<EscenarioCostoRepository>();
    final puntoCurvaRepo = context.read<PuntoCurvaRepository>();
    final memoriaRepo = context.read<MemoriaCalculoRepository>();

    setState(() {
      _ejecutando = true;
      _progresoTexto = null;
      _error = null;
      _resumen = null;
    });
    final token = TokenCancelacion();
    _tokenActual = token;

    try {
      final candidatos = await candidatoRepo.obtenerPorProyecto(proyectoId);
      final plantas = await plantaRepo.obtenerPorProyecto(proyectoId);
      final zonas = await zonaRepo.obtenerPorProyecto(proyectoId);
      final celdas = await celdaRepo.obtenerPorProyecto(proyectoId);
      final params = await parametrosRepo.obtenerPorProyecto(proyectoId);

      if (params == null) {
        throw StateError('Completa Parámetros de costo antes de optimizar.');
      }
      if (candidatos.isEmpty || zonas.isEmpty) {
        throw StateError('Necesitas al menos un sitio candidato y una zona de demanda.');
      }

      final candidatosPorId = {for (final c in candidatos) c.id!: c};
      final distanciaZonaCandidato = <(int, int), CeldaMatriz>{
        for (final c in celdas)
          if (c.tipoOrigen == 'candidato' && c.tipoDestino == 'zona') (c.destinoId, c.origenId): c,
      };
      final distanciaPlantaCandidato = <(int, int), CeldaMatriz>{
        for (final c in celdas)
          if (c.tipoOrigen == 'planta' && c.tipoDestino == 'candidato') (c.origenId, c.destinoId): c,
      };

      for (final z in zonas) {
        for (final c in candidatos) {
          if (!distanciaZonaCandidato.containsKey((z.id!, c.id!))) {
            throw StateError(
              'Falta la distancia de "${c.nombre}" a "${z.etiqueta}" — construye la matriz primero.',
            );
          }
        }
      }

      final evaluador = EvaluadorCosto(
        zonas: zonas,
        candidatosPorId: candidatosPorId,
        plantas: plantas,
        distanciaZonaCandidato: distanciaZonaCandidato,
        distanciaPlantaCandidato: distanciaPlantaCandidato,
        params: params,
        conRestriccionCapacidad: _conRestriccionCapacidad,
      );

      final candidatosIds = candidatos.map((c) => c.id!).toList();
      final pFijo = int.tryParse(_pFijoCtrl.text.trim());
      final semilla = int.tryParse(_semillaCtrl.text.trim()) ?? 42;

      Set<int> abiertosGanadores;
      List<FilaMemoria> memoriaMetodo;
      List<PuntoCurvaResultado>? curvaParaPersistir;

      if (_metodo == 'barrido') {
        final resultado = await barrerNumeroAlmacenes(
          candidatosDisponibles: candidatosIds,
          candidatosPorId: candidatosPorId,
          evaluador: evaluador,
          pMax: pFijo,
          cancelacion: token,
          onProgreso: (p, pMaxBarrido) => _actualizarProgreso('Evaluando p=$p de $pMaxBarrido'),
        );
        abiertosGanadores = resultado.optimo.abiertos;
        memoriaMetodo = resultado.memoria;
        curvaParaPersistir = resultado.curva;
      } else {
        final resultado = await _ejecutarMetodo(
          metodo: _metodo,
          candidatosIds: candidatosIds,
          evaluador: evaluador,
          pFijo: pFijo,
          semilla: semilla,
          cancelacion: token,
        );
        abiertosGanadores = resultado.abiertos;
        memoriaMetodo = resultado.memoria;
      }

      // Reconstruye el detalle completo de la configuración ganadora para
      // persistirlo (el evaluador solo devuelve el costo total agregado).
      final asignacionFinal = asignarZonas(
        abiertos: abiertosGanadores.toList(),
        zonas: zonas,
        candidatosPorId: candidatosPorId,
        distanciaZonaCandidato: distanciaZonaCandidato,
        params: params,
        conRestriccionCapacidad: _conRestriccionCapacidad,
      );
      final costoFinal = calcularCostoTotal(
        abiertos: abiertosGanadores.toList(),
        candidatosPorId: candidatosPorId,
        plantas: plantas,
        zonas: zonas,
        asignacionZonaCandidato: asignacionFinal.asignacion,
        distanciaZonaCandidato: distanciaZonaCandidato,
        distanciaPlantaCandidato: distanciaPlantaCandidato,
        params: params,
      );

      final nombre = _nombreCtrl.text.trim().isEmpty
          ? '${_metodo.toUpperCase()} ${DateTime.now().toIso8601String()}'
          : _nombreCtrl.text.trim();

      final escenarioId = await escenarioRepo.crear(
        Escenario(
          proyectoId: proyectoId,
          nombre: nombre,
          metodo: _metodo,
          pFijo: pFijo,
          restriccionCapacidadActiva: _conRestriccionCapacidad,
          costoTotalCent: costoFinal.costoTotalCent,
          fecha: DateTime.now().toIso8601String(),
        ),
      );

      final volumenPorCandidato = <int, double>{for (final id in abiertosGanadores) id: 0};
      final zonasPorId = {for (final z in zonas) z.id!: z};
      for (final entrada in asignacionFinal.asignacion.entries) {
        final zona = zonasPorId[entrada.key]!;
        volumenPorCandidato[entrada.value] = (volumenPorCandidato[entrada.value] ?? 0) + zona.demandaAgregada;
      }

      await escenarioAlmacenRepo.insertarTodos([
        for (final candidatoId in abiertosGanadores)
          EscenarioAlmacen(
            escenarioId: escenarioId,
            sitioCandidatoId: candidatoId,
            volumenAsignado: volumenPorCandidato[candidatoId] ?? 0,
            costoFijoCent: candidatosPorId[candidatoId]!.costoFijoAnualCent,
            costoManejoCent: ((volumenPorCandidato[candidatoId] ?? 0) *
                    candidatosPorId[candidatoId]!.costoVariableManejoCentPorUnidad)
                .round(),
          ),
      ]);

      await escenarioAsignacionRepo.insertarTodas([
        for (final entrada in asignacionFinal.asignacion.entries)
          EscenarioAsignacion(
            escenarioId: escenarioId,
            zonaId: entrada.key,
            sitioCandidatoId: entrada.value,
            distanciaMetros: distanciaZonaCandidato[(entrada.key, entrada.value)]!.distanciaMetros,
            duracionSegundos: distanciaZonaCandidato[(entrada.key, entrada.value)]!.duracionSegundos,
            costoSalidaCent: (zonasPorId[entrada.key]!.demandaAgregada *
                    tarifaTransporte(
                      distanciaMetros: distanciaZonaCandidato[(entrada.key, entrada.value)]!.distanciaMetros,
                      tarifaFijaCent: params.tarifaSalidaFijaCent,
                      tarifaCentPorKmTon: params.tarifaSalidaCentPorKmTon,
                    ))
                .round(),
          ),
      ]);

      await escenarioCostoRepo.insertarTodos([
        for (final entrada in costoFinal.porRubro.entries)
          EscenarioCosto(escenarioId: escenarioId, rubro: entrada.key, montoCent: entrada.value),
      ]);

      final todaLaMemoria = [...memoriaMetodo, ...asignacionFinal.memoria, ...costoFinal.memoria];
      await memoriaRepo.insertarTodas([
        for (var i = 0; i < todaLaMemoria.length; i++)
          MemoriaCalculo(
            escenarioId: escenarioId,
            orden: i + 1,
            modulo: todaLaMemoria[i].modulo,
            formula: todaLaMemoria[i].formula,
            entradasJson: todaLaMemoria[i].entradasJson,
            salida: todaLaMemoria[i].salida,
            unidad: todaLaMemoria[i].unidad,
          ),
      ]);

      // M8 (barrido): un punto_curva por p evaluado, para la Pantalla 13.
      if (curvaParaPersistir != null) {
        await puntoCurvaRepo.insertarTodos([
          for (final punto in curvaParaPersistir)
            PuntoCurva(
              escenarioId: escenarioId,
              numeroAlmacenes: punto.numeroAlmacenes,
              costoTotalCent: punto.costoTotalCent,
              costoPorRubroJson: jsonEncode(punto.porRubro),
              viableSegunServicio: punto.viableSegunServicio,
            ),
        ]);
      }

      if (!mounted) return;
      setState(() {
        _resumen = '"$nombre" guardado: ${abiertosGanadores.length} almacén(es) abierto(s), '
            'costo total ${(costoFinal.costoTotalCent / 100).toStringAsFixed(2)}'
            '${asignacionFinal.zonasNoCubiertas.isNotEmpty ? ' · ${asignacionFinal.zonasNoCubiertas.length} zona(s) fuera del estándar de servicio' : ''}'
            '${asignacionFinal.zonasSinAsignar.isNotEmpty ? ' · ${asignacionFinal.zonasSinAsignar.length} zona(s) sin capacidad disponible' : ''}';
      });
    } on BusquedaCancelada {
      if (!mounted) return;
      setState(() => _error = 'Ejecución cancelada — no se guardó ningún escenario.');
    } on StateError catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = '$e');
    } finally {
      _tokenActual = null;
      if (mounted) {
        setState(() {
          _ejecutando = false;
          _progresoTexto = null;
        });
      }
    }
  }

  Future<ResultadoBusqueda> _ejecutarMetodo({
    required String metodo,
    required List<int> candidatosIds,
    required EvaluadorCosto evaluador,
    required int? pFijo,
    required int semilla,
    required TokenCancelacion cancelacion,
  }) {
    switch (metodo) {
      case 'add':
        return heuristicaAdd(
          candidatosDisponibles: candidatosIds,
          pMax: pFijo ?? candidatosIds.length,
          evaluador: evaluador,
          cancelacion: cancelacion,
          onProgreso: (a, b) => _actualizarProgreso('Abriendo almacén $a de $b'),
        );
      case 'drop':
        return heuristicaDrop(
          todosCandidatos: candidatosIds,
          evaluador: evaluador,
          cancelacion: cancelacion,
          onProgreso: (a) => _actualizarProgreso('$a almacén(es) abierto(s)'),
        );
      case 'intercambio':
        final pInicial = (pFijo ?? (candidatosIds.length / 2).round()).clamp(1, candidatosIds.length);
        final inicial = (List<int>.of(candidatosIds)..shuffle(Random(semilla))).take(pInicial).toSet();
        return intercambioTeitzBart(
          abiertosInicial: inicial,
          candidatosDisponibles: candidatosIds,
          evaluador: evaluador,
          cancelacion: cancelacion,
          onProgreso: (i) => _actualizarProgreso('Ronda de intercambio $i'),
        );
      case 'recocido':
        return recocidoSimulado(
          candidatosDisponibles: candidatosIds,
          evaluador: evaluador,
          semilla: semilla,
          pFijo: pFijo,
          cancelacion: cancelacion,
          onProgreso: (i, t, c) => _actualizarProgreso(
            'Iteración $i · temperatura ${t.toStringAsFixed(1)} · costo ${(c / 100).toStringAsFixed(2)}',
          ),
        );
      case 'enumeracion':
        return enumeracionExhaustiva(
          candidatos: candidatosIds,
          evaluador: evaluador,
          pFijo: pFijo,
          cancelacion: cancelacion,
          onProgreso: (a, b) => _actualizarProgreso('Configuración $a de $b'),
        );
      default:
        throw StateError('Método desconocido: $metodo');
    }
  }

  void _actualizarProgreso(String texto) {
    if (!mounted) return;
    setState(() => _progresoTexto = texto);
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final metodosDisponibles = _metodo == 'enumeracion' && _numCandidatos > _limiteEnumeracion
        ? _metodos.where((m) => m.$1 != 'enumeracion').toList()
        : _metodos;

    return Scaffold(
      appBar: AppBar(title: const Text('Optimización')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _nombreCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del escenario',
                      hintText: 'Opcional — se genera uno si lo dejas vacío',
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _metodo,
                    decoration: const InputDecoration(labelText: 'Método'),
                    items: [
                      for (final (valor, etiqueta) in metodosDisponibles)
                        DropdownMenuItem(value: valor, child: Text(etiqueta)),
                    ],
                    onChanged: _ejecutando ? null : (v) => setState(() => _metodo = v!),
                  ),
                  if (_metodo == 'enumeracion' && _numCandidatos > _limiteEnumeracion)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'La enumeración exhaustiva solo es viable hasta $_limiteEnumeracion candidatos '
                        '($_numCandidatos cargados) — elige otro método.',
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),
                    ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _pFijoCtrl,
                    enabled: !_ejecutando && _metodo != 'drop',
                    decoration: InputDecoration(
                      labelText: 'p (cantidad de almacenes)',
                      hintText: _metodo == 'intercambio' ? 'Requerido' : 'Vacío = libre',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  if (_metodo == 'recocido' || _metodo == 'intercambio') ...[
                    const SizedBox(height: 16),
                    TextField(
                      controller: _semillaCtrl,
                      enabled: !_ejecutando,
                      decoration: const InputDecoration(
                        labelText: 'Semilla',
                        helperText: 'Misma semilla, mismas entradas → mismo resultado.',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Con restricción de capacidad'),
                    subtitle: const Text(
                      'Ninguna zona se asigna a un almacén sin capacidad disponible.',
                    ),
                    value: _conRestriccionCapacidad,
                    onChanged: _ejecutando ? null : (v) => setState(() => _conRestriccionCapacidad = v),
                  ),
                  const SizedBox(height: 16),
                  if (!_ejecutando)
                    FilledButton.icon(
                      onPressed: _ejecutar,
                      icon: const Icon(LucideIcons.play),
                      label: const Text('Ejecutar'),
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const LinearProgressIndicator(),
                        const SizedBox(height: 8),
                        Text(
                          _progresoTexto ?? 'Calculando...',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: _cancelar,
                          icon: const Icon(LucideIcons.x),
                          label: const Text('Cancelar'),
                        ),
                      ],
                    ),
                  if (_resumen != null) ...[
                    const SizedBox(height: 16),
                    Card(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          _resumen!,
                          style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
                        ),
                      ),
                    ),
                  ],
                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    Card(
                      color: Theme.of(context).colorScheme.errorContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          _error!,
                          style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
