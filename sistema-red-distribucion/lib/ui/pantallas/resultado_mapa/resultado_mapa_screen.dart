import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/constantes.dart';
import '../../../core/estado/proyecto_activo.dart';
import '../../../data/models/escenario.dart';
import '../../../data/models/sitio_candidato.dart';
import '../../../data/models/zona_demanda.dart';
import '../../../data/repositories/escenario_almacen_repository.dart';
import '../../../data/repositories/escenario_asignacion_repository.dart';
import '../../../data/repositories/escenario_repository.dart';
import '../../../data/repositories/parametros_costo_repository.dart';
import '../../../data/repositories/sitio_candidato_repository.dart';
import '../../../data/repositories/zona_demanda_repository.dart';
import '../../../domain/export/exportar_visor_red.dart';
import '../../paleta_territorios.dart';
import '../../widgets/selector_escenario.dart';

class _Territorio {
  const _Territorio({required this.candidato, required this.color, required this.indice});

  final SitioCandidato candidato;
  final Color color;
  final int indice;
}

class _ZonaResultado {
  const _ZonaResultado({
    required this.zona,
    required this.territorio,
    required this.cumpleEstandar,
  });

  final ZonaDemanda zona;
  final _Territorio? territorio; // null = sin asignar
  final bool cumpleEstandar;
}

/// Pantalla 11 (CLAUDE.md sección 8): territorios coloreados, almacenes
/// abiertos y zonas no cubiertas destacadas — misma paleta con contraste
/// validado que `paleta_territorios.dart` (Fase 8), y un botón para
/// compartir el mismo resultado como un enlace del visor web (`visor-red/`,
/// sin necesidad de la app).
class ResultadoMapaScreen extends StatefulWidget {
  const ResultadoMapaScreen({super.key});

  @override
  State<ResultadoMapaScreen> createState() => _ResultadoMapaScreenState();
}

class _ResultadoMapaScreenState extends State<ResultadoMapaScreen> {
  bool _cargando = true;
  List<Escenario> _escenarios = [];
  Escenario? _seleccionado;
  List<_Territorio> _territorios = [];
  List<_ZonaResultado> _zonas = [];

  int get _proyectoId => context.read<ProyectoActivo>().proyecto!.id!;

  @override
  void initState() {
    super.initState();
    _cargarEscenarios();
  }

  Future<void> _cargarEscenarios() async {
    setState(() => _cargando = true);
    final escenarios = await context.read<EscenarioRepository>().obtenerPorProyecto(_proyectoId);
    if (!mounted) return;
    setState(() {
      _escenarios = escenarios;
      _cargando = false;
    });
    if (escenarios.isNotEmpty) await _seleccionar(escenarios.last);
  }

  Future<void> _seleccionar(Escenario escenario) async {
    final proyectoId = _proyectoId;
    final almacenRepo = context.read<EscenarioAlmacenRepository>();
    final asignacionRepo = context.read<EscenarioAsignacionRepository>();
    final candidatoRepo = context.read<SitioCandidatoRepository>();
    final zonaRepo = context.read<ZonaDemandaRepository>();
    final parametrosRepo = context.read<ParametrosCostoRepository>();

    final almacenes = await almacenRepo.obtenerPorEscenario(escenario.id!);
    final asignaciones = await asignacionRepo.obtenerPorEscenario(escenario.id!);
    final candidatos = await candidatoRepo.obtenerPorProyecto(proyectoId);
    final zonas = await zonaRepo.obtenerPorProyecto(proyectoId);
    final params = await parametrosRepo.obtenerPorProyecto(proyectoId);

    final candidatosPorId = {for (final c in candidatos) c.id!: c};
    final territorios = <int, _Territorio>{};
    for (var i = 0; i < almacenes.length; i++) {
      final candidato = candidatosPorId[almacenes[i].sitioCandidatoId];
      if (candidato == null) continue;
      territorios[candidato.id!] = _Territorio(
        candidato: candidato,
        color: colorParaTerritorio(i),
        indice: i,
      );
    }

    final asignacionPorZona = {for (final a in asignaciones) a.zonaId: a};
    final zonasResultado = zonas.map((zona) {
      final asignacion = asignacionPorZona[zona.id];
      if (asignacion == null) {
        return _ZonaResultado(zona: zona, territorio: null, cumpleEstandar: false);
      }
      final territorio = territorios[asignacion.sitioCandidatoId];
      final valor = params?.tipoEstandar == 'tiempo' ? asignacion.duracionSegundos : asignacion.distanciaMetros;
      final cumple = params == null || valor <= params.estandarServicioValor;
      return _ZonaResultado(zona: zona, territorio: territorio, cumpleEstandar: cumple);
    }).toList();

    if (!mounted) return;
    setState(() {
      _seleccionado = escenario;
      _territorios = territorios.values.toList()..sort((a, b) => a.indice.compareTo(b.indice));
      _zonas = zonasResultado;
    });
  }

  Future<void> _compartirEnlace() async {
    final resultado = construirUrlVisorRed(
      nombreEscenario: _seleccionado!.nombre,
      almacenes: _territorios
          .map(
            (t) => AlmacenParaVisor(
              nombre: t.candidato.nombre,
              latitud: t.candidato.latitud,
              longitud: t.candidato.longitud,
              color: t.color,
            ),
          )
          .toList(),
      zonas: _zonas
          .map(
            (z) => ZonaParaVisor(
              etiqueta: z.zona.etiqueta,
              latitud: z.zona.latitud,
              longitud: z.zona.longitud,
              indiceAlmacen: z.territorio?.indice,
              cumpleEstandar: z.cumpleEstandar,
            ),
          )
          .toList(),
    );

    if (!mounted) return;
    if (resultado.excedeLimite) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'Este escenario tiene demasiados almacenes y zonas para compartir en un '
              'solo enlace — prueba con un escenario más chico.',
            ),
          ),
        );
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enlace del visor'),
        content: SelectableText(resultado.uri!.toString()),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: resultado.uri!.toString()));
              Navigator.of(context).pop();
            },
            child: const Text('Copiar'),
          ),
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cerrar')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado — mapa'),
        actions: [
          if (_seleccionado != null)
            IconButton(
              onPressed: _compartirEnlace,
              icon: const Icon(LucideIcons.share2),
              tooltip: 'Compartir enlace del visor',
            ),
        ],
      ),
      body: _escenarios.isEmpty
          ? const _SinEscenarios()
          : SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: SelectorEscenario(
                      escenarios: _escenarios,
                      seleccionado: _seleccionado,
                      onCambiar: (e) => e == null ? null : _seleccionar(e),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: _LeyendaMapa(),
                  ),
                  Expanded(child: _MapaTerritorios(territorios: _territorios, zonas: _zonas)),
                ],
              ),
            ),
    );
  }
}

/// Explica los tres elementos del mapa — sin esto, dos puntos y una línea
/// sin contexto no se entienden solos (confirmado por el usuario).
class _LeyendaMapa extends StatelessWidget {
  const _LeyendaMapa();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final estiloTexto = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Wrap(
          spacing: 20,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.warehouse, size: 16, color: colorScheme.onSurfaceVariant),
                const SizedBox(width: 6),
                Text('Almacén abierto', style: estiloTexto),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant,
                    shape: BoxShape.circle,
                    border: Border.all(color: colorScheme.surface, width: 1.5),
                  ),
                ),
                const SizedBox(width: 6),
                Text('Zona — el color indica su almacén asignado', style: estiloTexto),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(color: colorSinAsignarTerritorio, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Text('Gris: zona sin ningún almacén asignado', style: estiloTexto),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.red, width: 3),
                  ),
                ),
                const SizedBox(width: 6),
                Text('Borde rojo: fuera del estándar de servicio', style: estiloTexto),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 16, height: 2, color: colorScheme.onSurfaceVariant),
                const SizedBox(width: 6),
                Text('Línea: qué almacén atiende a esa zona', style: estiloTexto),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MapaTerritorios extends StatelessWidget {
  const _MapaTerritorios({required this.territorios, required this.zonas});

  final List<_Territorio> territorios;
  final List<_ZonaResultado> zonas;

  @override
  Widget build(BuildContext context) {
    final centro = territorios.isNotEmpty
        ? LatLng(territorios.first.candidato.latitud, territorios.first.candidato.longitud)
        : centroMapaPorDefecto;

    return FlutterMap(
      options: MapOptions(initialCenter: centro, initialZoom: 11),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.logisticapps.sistema_red_distribucion',
        ),
        PolylineLayer(
          polylines: [
            for (final z in zonas)
              if (z.territorio != null)
                Polyline(
                  points: [
                    LatLng(z.zona.latitud, z.zona.longitud),
                    LatLng(z.territorio!.candidato.latitud, z.territorio!.candidato.longitud),
                  ],
                  color: z.territorio!.color.withValues(alpha: 0.5),
                  strokeWidth: 2,
                ),
          ],
        ),
        MarkerLayer(
          markers: [
            for (final z in zonas)
              Marker(
                point: LatLng(z.zona.latitud, z.zona.longitud),
                width: 22,
                height: 22,
                child: _MarcadorZona(zona: z),
              ),
          ],
        ),
        MarkerLayer(
          markers: [
            for (final t in territorios)
              Marker(
                point: LatLng(t.candidato.latitud, t.candidato.longitud),
                width: 34,
                height: 34,
                child: Icon(LucideIcons.warehouse, color: t.color, size: 30),
              ),
          ],
        ),
      ],
    );
  }
}

class _MarcadorZona extends StatelessWidget {
  const _MarcadorZona({required this.zona});

  final _ZonaResultado zona;

  @override
  Widget build(BuildContext context) {
    final color = zona.territorio?.color ?? colorSinAsignarTerritorio;

    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: zona.cumpleEstandar ? Colors.white : Colors.red,
          width: zona.cumpleEstandar ? 1.5 : 3,
        ),
      ),
    );
  }
}

class _SinEscenarios extends StatelessWidget {
  const _SinEscenarios();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Todavía no hay ningún escenario calculado — corre una optimización primero.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
