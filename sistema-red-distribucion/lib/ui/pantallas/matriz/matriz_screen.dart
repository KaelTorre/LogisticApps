import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:paquete_geo_logistica/paquete_geo_logistica.dart';
import 'package:provider/provider.dart';

import '../../../core/constantes.dart';
import '../../../core/estado/proyecto_activo.dart';
import '../../../data/models/celda_matriz.dart';
import '../../../data/repositories/celda_matriz_repository.dart';
import '../../../data/repositories/planta_repository.dart';
import '../../../data/repositories/sitio_candidato_repository.dart';
import '../../../data/repositories/zona_demanda_repository.dart';
import '../../../domain/motor/m3_matriz_distancias.dart';

/// Pantalla 9 (CLAUDE.md sección 8): estado de la matriz, progreso de
/// construcción y proporción de celdas por fuente (`osrm` vs `haversine`).
///
/// Construye dos matrices bajo el mismo botón, con el mismo motor
/// (`construirMatriz`, Fase 4): candidatos/plantas → zonas (lo que ya
/// pedía la Fase 4) y, agregado en la Fase 5, plantas → candidatos — M4
/// necesita esa segunda distancia para el rubro de transporte de entrada,
/// y la Fase 4 solo había cubierto distancias hacia zonas (ver decisión
/// documentada en el README del proyecto).
class MatrizScreen extends StatefulWidget {
  const MatrizScreen({super.key});

  @override
  State<MatrizScreen> createState() => _MatrizScreenState();
}

class _MatrizScreenState extends State<MatrizScreen> {
  bool _cargando = true;
  int _numCandidatos = 0;
  int _numPlantas = 0;
  int _numDestinos = 0;
  List<CeldaMatriz> _celdas = [];
  bool _sinConexion = false;
  bool _construyendo = false;
  ProgresoMatriz? _progreso;
  String? _error;

  int get _proyectoId => context.read<ProyectoActivo>().proyecto!.id!;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _cargando = true);
    final proyectoId = _proyectoId;
    final candidatoRepository = context.read<SitioCandidatoRepository>();
    final plantaRepository = context.read<PlantaRepository>();
    final zonaRepository = context.read<ZonaDemandaRepository>();
    final celdaRepository = context.read<CeldaMatrizRepository>();

    final candidatos = await candidatoRepository.obtenerPorProyecto(proyectoId);
    final plantas = await plantaRepository.obtenerPorProyecto(proyectoId);
    final zonas = await zonaRepository.obtenerPorProyecto(proyectoId);
    final celdas = await celdaRepository.obtenerPorProyecto(proyectoId);

    if (!mounted) return;
    setState(() {
      _numCandidatos = candidatos.length;
      _numPlantas = plantas.length;
      _numDestinos = zonas.length;
      _celdas = celdas;
      _cargando = false;
    });
  }

  Future<void> _construir() async {
    final proyecto = context.read<ProyectoActivo>().proyecto!;
    final proyectoId = proyecto.id!;
    final candidatoRepository = context.read<SitioCandidatoRepository>();
    final plantaRepository = context.read<PlantaRepository>();
    final zonaRepository = context.read<ZonaDemandaRepository>();
    final celdaRepository = context.read<CeldaMatrizRepository>();
    final osrmClient = context.read<OsrmClient>();

    setState(() {
      _construyendo = true;
      _error = null;
      _progreso = null;
    });

    try {
      final candidatos = await candidatoRepository.obtenerPorProyecto(proyectoId);
      final plantas = await plantaRepository.obtenerPorProyecto(proyectoId);
      final zonas = await zonaRepository.obtenerPorProyecto(proyectoId);
      final celdasExistentes = await celdaRepository.obtenerPorProyecto(proyectoId);

      final origenesAZonas = [
        ...candidatos.map(
          (c) => OrigenMatriz(tipo: 'candidato', id: c.id!, latitud: c.latitud, longitud: c.longitud),
        ),
        ...plantas.map(
          (p) => OrigenMatriz(tipo: 'planta', id: p.id!, latitud: p.latitud, longitud: p.longitud),
        ),
      ];
      final destinosZonas = zonas
          .map((z) => DestinoMatriz(id: z.id!, latitud: z.latitud, longitud: z.longitud))
          .toList();

      final nuevasAZonas = await construirMatriz(
        proyectoId: proyectoId,
        origenes: origenesAZonas,
        destinos: destinosZonas,
        celdasExistentes: celdasExistentes,
        factorCircuidad: proyecto.factorCircuidad,
        cliente: _sinConexion ? null : osrmClient,
        maxCoordenadasPorConsulta: maxCoordenadasPorConsulta,
        onProgreso: (progreso) {
          if (!mounted) return;
          setState(() => _progreso = progreso);
        },
      );

      // Planta → candidato (Fase 5, M4 la necesita para el transporte de
      // entrada) — mismo motor, `celdasExistentes` ya sirve para las dos
      // llamadas porque las claves (tipoOrigen+origenId+tipoDestino+
      // destinoId) de una y otra matriz nunca se pisan.
      final origenesPlantas = plantas
          .map((p) => OrigenMatriz(tipo: 'planta', id: p.id!, latitud: p.latitud, longitud: p.longitud))
          .toList();
      final destinosCandidatos = candidatos
          .map(
            (c) => DestinoMatriz(id: c.id!, latitud: c.latitud, longitud: c.longitud, tipo: 'candidato'),
          )
          .toList();

      final nuevasPlantaCandidato = await construirMatriz(
        proyectoId: proyectoId,
        origenes: origenesPlantas,
        destinos: destinosCandidatos,
        celdasExistentes: celdasExistentes,
        factorCircuidad: proyecto.factorCircuidad,
        cliente: _sinConexion ? null : osrmClient,
        maxCoordenadasPorConsulta: maxCoordenadasPorConsulta,
        onProgreso: (progreso) {
          if (!mounted) return;
          setState(() => _progreso = progreso);
        },
      );

      final nuevas = [...nuevasAZonas, ...nuevasPlantaCandidato];
      if (nuevas.isNotEmpty) {
        await celdaRepository.insertarTodas(nuevas);
      }

      if (!mounted) return;
      await _cargar();
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(
              nuevas.isEmpty
                  ? 'La matriz ya estaba completa, no hubo celdas nuevas.'
                  : '${nuevas.length} celda(s) calculada(s).',
            ),
          ),
        );
    } on OsrmException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.mensaje);
    } finally {
      if (mounted) {
        setState(() {
          _construyendo = false;
          _progreso = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final numOrigenes = _numCandidatos + _numPlantas;
    final celdasAZonas = _celdas.where((c) => c.tipoDestino == 'zona').toList();
    final celdasPlantaCandidato = _celdas.where((c) => c.tipoDestino == 'candidato').toList();
    final totalEsperadoZonas = numOrigenes * _numDestinos;
    final totalEsperadoPlantaCandidato = _numPlantas * _numCandidatos;
    final deOsrm = celdasAZonas.where((c) => c.fuente == 'osrm').length;
    final deHaversine = celdasAZonas.where((c) => c.fuente == 'haversine').length;

    return Scaffold(
      appBar: AppBar(title: const Text('Matriz de distancias')),
      body: SafeArea(
        child: (numOrigenes == 0 || _numDestinos == 0)
            ? _EstadoIncompleto(sinOrigenes: numOrigenes == 0, sinDestinos: _numDestinos == 0)
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Distancias a zonas de demanda', style: Theme.of(context).textTheme.titleSmall),
                            const SizedBox(height: 8),
                            Text('$numOrigenes origen(es) (candidatos + plantas) × $_numDestinos zona(s) '
                                '= $totalEsperadoZonas celda(s) esperadas.'),
                            const SizedBox(height: 4),
                            Text('${celdasAZonas.length} celda(s) calculada(s) hasta ahora.'),
                            if (celdasAZonas.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              _BarraProporcion(deOsrm: deOsrm, deHaversine: deHaversine),
                              const SizedBox(height: 4),
                              Text(
                                '$deOsrm de OSRM (ruta real) · $deHaversine en línea recta (aproximado)',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                            if (_numPlantas > 0 && _numCandidatos > 0) ...[
                              const Divider(height: 24),
                              Text(
                                'Distancias planta → sitio candidato',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '$_numPlantas planta(s) × $_numCandidatos candidato(s) = '
                                '$totalEsperadoPlantaCandidato celda(s) esperadas — usadas por el costo de '
                                'transporte de entrada.',
                              ),
                              const SizedBox(height: 4),
                              Text('${celdasPlantaCandidato.length} celda(s) calculada(s) hasta ahora.'),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Modo sin conexión'),
                      subtitle: const Text(
                        'Usa siempre distancia en línea recta × factor de circuidad, '
                        'sin intentar consultar OSRM.',
                      ),
                      value: _sinConexion,
                      onChanged: _construyendo ? null : (v) => setState(() => _sinConexion = v),
                    ),
                    const SizedBox(height: 8),
                    FilledButton.icon(
                      onPressed: _construyendo ? null : _construir,
                      icon: _construyendo
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(LucideIcons.route),
                      label: Text(_construyendo ? 'Construyendo...' : 'Construir / actualizar matriz'),
                    ),
                    if (_progreso != null) ...[
                      const SizedBox(height: 16),
                      _PanelProgreso(progreso: _progreso!),
                    ],
                    if (_error != null) ...[
                      const SizedBox(height: 16),
                      _BannerError(mensaje: _error!),
                    ],
                  ],
                ),
              ),
      ),
    );
  }
}

class _BarraProporcion extends StatelessWidget {
  const _BarraProporcion({required this.deOsrm, required this.deHaversine});

  final int deOsrm;
  final int deHaversine;

  @override
  Widget build(BuildContext context) {
    final total = deOsrm + deHaversine;
    final proporcionOsrm = total == 0 ? 0.0 : deOsrm / total;
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        height: 12,
        child: Row(
          children: [
            Expanded(
              flex: (proporcionOsrm * 1000).round().clamp(0, 1000),
              child: Container(color: colorScheme.primary),
            ),
            Expanded(
              flex: ((1 - proporcionOsrm) * 1000).round().clamp(0, 1000),
              child: Container(color: colorScheme.tertiary),
            ),
          ],
        ),
      ),
    );
  }
}

class _PanelProgreso extends StatelessWidget {
  const _PanelProgreso({required this.progreso});

  final ProgresoMatriz progreso;

  @override
  Widget build(BuildContext context) {
    final proporcion = progreso.bloquesTotales == 0
        ? 0.0
        : progreso.bloquesCompletados / progreso.bloquesTotales;
    final minutos = progreso.tiempoRestanteEstimado.inSeconds / 60;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LinearProgressIndicator(value: proporcion),
        const SizedBox(height: 4),
        Text(
          'Bloque ${progreso.bloquesCompletados} de ${progreso.bloquesTotales}'
          '${minutos > 0 ? ' · ~${minutos.toStringAsFixed(1)} min restantes' : ''}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _BannerError extends StatelessWidget {
  const _BannerError({required this.mensaje});

  final String mensaje;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: colorScheme.errorContainer, borderRadius: BorderRadius.circular(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(LucideIcons.circleAlert, color: colorScheme.onErrorContainer),
          const SizedBox(width: 8),
          Expanded(child: Text(mensaje, style: TextStyle(color: colorScheme.onErrorContainer))),
        ],
      ),
    );
  }
}

class _EstadoIncompleto extends StatelessWidget {
  const _EstadoIncompleto({required this.sinOrigenes, required this.sinDestinos});

  final bool sinOrigenes;
  final bool sinDestinos;

  @override
  Widget build(BuildContext context) {
    final faltantes = [
      if (sinOrigenes) 'al menos un sitio candidato o planta',
      if (sinDestinos) 'zonas de demanda (calcúlalas en Agregación)',
    ].join(' y ');

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.route, size: 40, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(height: 12),
            Text(
              'Falta cargar $faltantes antes de construir la matriz.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
