import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';

import '../../../core/estado/proyecto_activo.dart';
import '../../../core/plataforma/abrir_carpeta.dart';
import '../../../data/local/database.dart';
import '../../../data/repositories/cliente_repository.dart';
import '../../../data/repositories/escenario_almacen_repository.dart';
import '../../../data/repositories/escenario_repository.dart';
import '../../../data/repositories/memoria_calculo_repository.dart';
import '../../../data/repositories/planta_repository.dart';
import '../../../data/repositories/proyecto_repository.dart';
import '../../../data/repositories/sitio_candidato_repository.dart';
import '../../../data/repositories/zona_demanda_repository.dart';
import '../../../data/models/escenario.dart';
import '../../../data/repositories/escenario_asignacion_repository.dart';
import '../../../data/repositories/parametros_costo_repository.dart';
import '../../../domain/export/exportar_csv.dart';
import '../../../domain/export/exportar_importar_proyecto.dart';
import '../../../domain/export/exportar_visor_red.dart';
import '../../../domain/export/exportar_volumen_unidad4.dart';
import '../../../domain/export/pdf_builder_red.dart';
import '../../../domain/export/proyecto_red_portable.dart';
import '../../../domain/motor/fila_memoria.dart';
import '../../paleta_territorios.dart';
import '../../widgets/selector_escenario.dart';
import '../importar_proyecto/importar_proyecto_screen.dart';

/// Pantalla 16 (CLAUDE.md sección 8): ficha técnica PDF, exportación CSV y
/// JSON, volumen por centro para la Unidad 4, y el enlace del visor web
/// (mismo mecanismo de la Fase 8, Pantalla 11) — todo detrás de un
/// selector de escenario cuando la exportación depende de uno.
class ExportacionScreen extends StatefulWidget {
  const ExportacionScreen({super.key});

  @override
  State<ExportacionScreen> createState() => _ExportacionScreenState();
}

class _ExportacionScreenState extends State<ExportacionScreen> {
  bool _cargando = true;
  List<Escenario> _escenarios = [];
  Escenario? _seleccionado;
  bool _procesando = false;

  int get _proyectoId => context.read<ProyectoActivo>().proyecto!.id!;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _cargando = true);
    final escenarios = await context.read<EscenarioRepository>().obtenerPorProyecto(_proyectoId);
    if (!mounted) return;
    setState(() {
      _escenarios = escenarios;
      _seleccionado = escenarios.isEmpty ? null : escenarios.last;
      _cargando = false;
    });
  }

  Future<void> _conProgreso(Future<void> Function() accion, {String mensajeError = 'No se pudo exportar'}) async {
    setState(() => _procesando = true);
    try {
      await accion();
    } on FormatException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text('$mensajeError: ${e.message}')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text('$mensajeError: $e')));
    } finally {
      if (mounted) setState(() => _procesando = false);
    }
  }

  Future<void> _mostrarExportado(String mensaje, String ruta) async {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(snackBarArchivoExportado(mensaje: mensaje, rutaArchivo: ruta));
  }

  Future<File> _escribir(String nombreArchivo, String contenido) async {
    final directorio = await directorioExportacion();
    final archivo = File('${directorio.path}${Platform.pathSeparator}$nombreArchivo');
    await archivo.writeAsString(contenido);
    return archivo;
  }

  String _marcaDeTiempo() => DateTime.now().toIso8601String().replaceAll(RegExp(r'[:.]'), '-');

  Future<void> _exportarPdf() async {
    final escenario = _seleccionado;
    if (escenario == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Necesitas al menos un escenario calculado.')));
      return;
    }
    final proyectoRepo = context.read<ProyectoRepository>();
    final almacenRepo = context.read<EscenarioAlmacenRepository>();
    final zonaRepo = context.read<ZonaDemandaRepository>();
    final memoriaRepo = context.read<MemoriaCalculoRepository>();
    await _conProgreso(() async {
      final proyecto = await proyectoRepo.obtenerPorId(_proyectoId);
      final almacenes = await almacenRepo.obtenerPorEscenario(escenario.id!);
      final zonas = await zonaRepo.obtenerPorProyecto(_proyectoId);
      final memoria = await memoriaRepo.obtenerPorEscenario(escenario.id!);

      final fuenteRegular = pw.Font.ttf(await rootBundle.load('assets/fonts/DejaVuSans.ttf'));
      final fuenteNegrita = pw.Font.ttf(await rootBundle.load('assets/fonts/DejaVuSans-Bold.ttf'));

      final bytes = await generarFichaPdfRed(
        titulo: 'Ficha técnica — ${proyecto!.nombre}',
        resumen: [
          MapEntry('Escenario', '${escenario.nombre} (${escenario.metodo})'),
          MapEntry('Costo total', '${(escenario.costoTotalCent / 100).toStringAsFixed(2)} ${proyecto.moneda}'),
          MapEntry('Almacenes abiertos', '${almacenes.length}'),
          MapEntry('Zonas de demanda', '${zonas.length}'),
        ],
        memoria: memoria
            .map(
              (m) => FilaMemoria(
                modulo: m.modulo,
                formula: m.formula,
                entradasJson: m.entradasJson,
                salida: m.salida,
                unidad: m.unidad,
              ),
            )
            .toList(),
        fuenteRegular: fuenteRegular,
        fuenteNegrita: fuenteNegrita,
      );

      final directorio = await directorioExportacion();
      final archivo = File('${directorio.path}${Platform.pathSeparator}ficha_tecnica_${_marcaDeTiempo()}.pdf');
      await archivo.writeAsBytes(bytes);
      await _mostrarExportado('PDF exportado en ${archivo.path}', archivo.path);
    });
  }

  Future<void> _exportarCsvClientes() async {
    await _conProgreso(() async {
      final clientes = await context.read<ClienteRepository>().obtenerPorProyecto(_proyectoId);
      final archivo = await _escribir('clientes_${_marcaDeTiempo()}.csv', exportarClientesCsv(clientes));
      await _mostrarExportado('CSV de clientes exportado en ${archivo.path}', archivo.path);
    });
  }

  Future<void> _exportarCsvZonas() async {
    await _conProgreso(() async {
      final zonas = await context.read<ZonaDemandaRepository>().obtenerPorProyecto(_proyectoId);
      final archivo = await _escribir('zonas_${_marcaDeTiempo()}.csv', exportarZonasCsv(zonas));
      await _mostrarExportado('CSV de zonas exportado en ${archivo.path}', archivo.path);
    });
  }

  Future<void> _exportarCsvCandidatosYPlantas() async {
    final candidatoRepo = context.read<SitioCandidatoRepository>();
    final plantaRepo = context.read<PlantaRepository>();
    await _conProgreso(() async {
      final candidatos = await candidatoRepo.obtenerPorProyecto(_proyectoId);
      final plantas = await plantaRepo.obtenerPorProyecto(_proyectoId);
      final archivoCandidatos = await _escribir(
        'sitios_candidatos_${_marcaDeTiempo()}.csv',
        exportarCandidatosCsv(candidatos),
      );
      await _escribir('plantas_${_marcaDeTiempo()}.csv', exportarPlantasCsv(plantas));
      await _mostrarExportado('CSV de candidatos y plantas exportados en ${archivoCandidatos.parent.path}', archivoCandidatos.path);
    });
  }

  Future<void> _exportarJson() async {
    await _conProgreso(() async {
      final database = context.read<AppDatabase>();
      final portable = await exportarProyecto(_proyectoId, database);
      final archivo = await _escribir('proyecto_${_marcaDeTiempo()}.json', portable.toJsonString());
      await _mostrarExportado('Proyecto exportado en ${archivo.path}', archivo.path);
    });
  }

  Future<void> _importarJson() async {
    final database = context.read<AppDatabase>();
    final archivo = await Navigator.of(context).push<File>(
      MaterialPageRoute(builder: (_) => const ImportarProyectoScreen()),
    );
    if (archivo == null) return;
    await _conProgreso(() async {
      final contenido = await archivo.readAsString();
      final portable = ProyectoRedPortable.fromJsonString(contenido);
      await importarProyecto(portable, database);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text('"${portable.nombre}" importado como proyecto nuevo.')));
    }, mensajeError: 'No se pudo importar');
  }

  Future<void> _exportarVolumenUnidad4() async {
    final escenario = _seleccionado;
    if (escenario == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Necesitas al menos un escenario calculado.')));
      return;
    }
    final almacenRepo = context.read<EscenarioAlmacenRepository>();
    final candidatoRepo = context.read<SitioCandidatoRepository>();
    await _conProgreso(() async {
      final almacenes = await almacenRepo.obtenerPorEscenario(escenario.id!);
      final candidatos = await candidatoRepo.obtenerPorProyecto(_proyectoId);
      final nombrePorId = {for (final c in candidatos) c.id!: c.nombre};

      final archivos = exportarVolumenPorCentro(
        almacenesAbiertos: [
          for (final a in almacenes)
            (
              sitioCandidatoId: a.sitioCandidatoId,
              nombre: nombrePorId[a.sitioCandidatoId] ?? 'Almacén ${a.sitioCandidatoId}',
              volumenAnual: a.volumenAsignado,
            ),
        ],
      );

      File? ultimo;
      for (final a in archivos) {
        ultimo = await _escribir('volumen_unidad4_${a.nombreAlmacen}_${_marcaDeTiempo()}.json', a.contenidoJson);
      }
      if (ultimo == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(const SnackBar(content: Text('El escenario elegido no tiene almacenes abiertos.')));
        return;
      }
      await _mostrarExportado('${archivos.length} archivo(s) de volumen exportado(s) en ${ultimo.parent.path}', ultimo.path);
    });
  }

  Future<void> _compartirEnlaceVisor() async {
    final escenario = _seleccionado;
    if (escenario == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Necesitas al menos un escenario calculado.')));
      return;
    }
    final candidatoRepo = context.read<SitioCandidatoRepository>();
    final almacenRepo = context.read<EscenarioAlmacenRepository>();
    final zonaRepo = context.read<ZonaDemandaRepository>();
    final asignacionRepo = context.read<EscenarioAsignacionRepository>();
    final parametrosRepo = context.read<ParametrosCostoRepository>();
    await _conProgreso(() async {
      final candidatos = await candidatoRepo.obtenerPorProyecto(_proyectoId);
      final almacenes = await almacenRepo.obtenerPorEscenario(escenario.id!);
      final zonas = await zonaRepo.obtenerPorProyecto(_proyectoId);
      final asignaciones = await asignacionRepo.obtenerPorEscenario(escenario.id!);
      final params = await parametrosRepo.obtenerPorProyecto(_proyectoId);

      final candidatosPorId = {for (final c in candidatos) c.id!: c};
      final indicePorCandidatoId = {for (var i = 0; i < almacenes.length; i++) almacenes[i].sitioCandidatoId: i};
      final asignacionPorZona = {for (final a in asignaciones) a.zonaId: a};

      // Mismo criterio que la Pantalla 11 (`resultado_mapa_screen.dart`,
      // Fase 8): "no cubierta"/"sin asignar" no se guardan en la tabla, se
      // recalculan acá contra el estándar de servicio vigente.
      final resultado = construirUrlVisorRed(
        nombreEscenario: escenario.nombre,
        almacenes: [
          for (final a in almacenes)
            if (candidatosPorId[a.sitioCandidatoId] != null)
              AlmacenParaVisor(
                nombre: candidatosPorId[a.sitioCandidatoId]!.nombre,
                latitud: candidatosPorId[a.sitioCandidatoId]!.latitud,
                longitud: candidatosPorId[a.sitioCandidatoId]!.longitud,
                color: colorParaTerritorio(indicePorCandidatoId[a.sitioCandidatoId]!),
              ),
        ],
        zonas: [
          for (final z in zonas)
            ZonaParaVisor(
              etiqueta: z.etiqueta,
              latitud: z.latitud,
              longitud: z.longitud,
              indiceAlmacen: indicePorCandidatoId[asignacionPorZona[z.id]?.sitioCandidatoId],
              cumpleEstandar: asignacionPorZona[z.id] == null || params == null
                  ? false
                  : (params.tipoEstandar == 'tiempo'
                            ? asignacionPorZona[z.id]!.duracionSegundos
                            : asignacionPorZona[z.id]!.distanciaMetros) <=
                        params.estandarServicioValor,
            ),
        ],
      );

      if (!mounted) return;
      if (resultado.excedeLimite || resultado.uri == null) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            const SnackBar(content: Text('Este escenario es demasiado grande para compartir en un solo enlace.')),
          );
        return;
      }
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Enlace del visor'),
          content: SelectableText(resultado.uri!.toString()),
          actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cerrar'))],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exportación')),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (_escenarios.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: SelectorEscenario(
                        escenarios: _escenarios,
                        seleccionado: _seleccionado,
                        onCambiar: (e) => setState(() => _seleccionado = e),
                      ),
                    ),
                  _SeccionExportacion(
                    titulo: 'Ficha técnica',
                    descripcion: 'PDF con el resumen y la memoria de cálculo completa del escenario elegido.',
                    icono: Icons.picture_as_pdf_outlined,
                    habilitado: !_procesando && _seleccionado != null,
                    onPressed: _exportarPdf,
                  ),
                  _SeccionExportacion(
                    titulo: 'Clientes (CSV)',
                    descripcion: 'Todos los clientes del proyecto.',
                    icono: Icons.table_chart_outlined,
                    habilitado: !_procesando,
                    onPressed: _exportarCsvClientes,
                  ),
                  _SeccionExportacion(
                    titulo: 'Zonas de demanda (CSV)',
                    descripcion: 'Las zonas ya agregadas del proyecto.',
                    icono: Icons.table_chart_outlined,
                    habilitado: !_procesando,
                    onPressed: _exportarCsvZonas,
                  ),
                  _SeccionExportacion(
                    titulo: 'Candidatos y plantas (CSV)',
                    descripcion: 'Sitios candidatos y plantas del proyecto, en dos archivos.',
                    icono: Icons.table_chart_outlined,
                    habilitado: !_procesando,
                    onPressed: _exportarCsvCandidatosYPlantas,
                  ),
                  _SeccionExportacion(
                    titulo: 'Proyecto completo (JSON)',
                    descripcion: 'Exporta el proyecto para abrirlo en otra máquina, o importa uno.',
                    icono: Icons.data_object_outlined,
                    habilitado: !_procesando,
                    onPressed: _exportarJson,
                    accionSecundaria: ('Importar', _importarJson),
                  ),
                  _SeccionExportacion(
                    titulo: 'Volumen por centro',
                    descripcion:
                        'Un archivo por almacén abierto, con su volumen anual, listo para importar en el '
                        'Sistema de Diseño de Almacenes.',
                    icono: Icons.warehouse_outlined,
                    habilitado: !_procesando && _seleccionado != null,
                    onPressed: _exportarVolumenUnidad4,
                  ),
                  _SeccionExportacion(
                    titulo: 'Enlace del visor web',
                    descripcion: 'Comparte el mapa de resultados sin que la otra persona instale la app.',
                    icono: Icons.share_outlined,
                    habilitado: !_procesando && _seleccionado != null,
                    onPressed: _compartirEnlaceVisor,
                  ),
                ],
              ),
            ),
    );
  }
}

class _SeccionExportacion extends StatelessWidget {
  const _SeccionExportacion({
    required this.titulo,
    required this.descripcion,
    required this.icono,
    required this.habilitado,
    required this.onPressed,
    this.accionSecundaria,
  });

  final String titulo;
  final String descripcion;
  final IconData icono;
  final bool habilitado;
  final VoidCallback onPressed;
  final (String, VoidCallback)? accionSecundaria;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: colorScheme.primaryContainer, borderRadius: BorderRadius.circular(12)),
              child: Icon(icono, color: colorScheme.onPrimaryContainer),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo, style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 4),
                  Text(descripcion, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                FilledButton.tonal(onPressed: habilitado ? onPressed : null, child: const Text('Exportar')),
                if (accionSecundaria != null)
                  TextButton(onPressed: habilitado ? accionSecundaria!.$2 : null, child: Text(accionSecundaria!.$1)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
