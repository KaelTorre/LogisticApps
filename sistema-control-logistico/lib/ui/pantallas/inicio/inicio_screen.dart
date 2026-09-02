import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/estado/organizacion_activa.dart';
import '../../../core/tour/induccion_screen.dart';
import '../../../core/tour/tour_controller.dart';
import '../../../data/local/database.dart';
import '../../../data/models/organizacion.dart';
import '../../../data/repositories/organizacion_repository.dart';
import '../../../data/seed/caso_estudio_semilla.dart';
import '../acciones/acciones_screen.dart';
import '../auditoria_facturas/auditoria_facturas_screen.dart';
import '../captura/captura_screen.dart';
import '../diagnostico_organizacional/diagnostico_organizacional_screen.dart';
import '../evaluacion/evaluacion_periodo_screen.dart';
import '../exportacion/exportacion_screen.dart';
import '../exportacion/importar_organizacion_screen.dart';
import '../indicadores/indicadores_screen.dart';
import '../informe_costo_servicio/informe_costo_servicio_screen.dart';
import '../informe_productividad/informe_productividad_screen.dart';
import '../laboratorio_calibrador/laboratorio_calibrador_screen.dart';
import '../laboratorio_contraste/laboratorio_contraste_screen.dart';
import '../laboratorio_generador/laboratorio_generador_screen.dart';
import '../organizacion/organizacion_form_screen.dart';
import '../periodos/periodos_screen.dart';
import '../presupuesto/presupuesto_screen.dart';
import '../reloj_simulacion/reloj_simulacion_screen.dart';
import '../tabla_desempeno/tabla_desempeno_screen.dart';
import '../verificacion/verificacion_screen.dart';

const _etiquetasTipoEmpresa = {
  'extractiva': 'Extractiva',
  'manufacturera': 'Manufacturera',
  'servicios': 'De servicios',
  'marketing': 'De marketing',
};

/// Pantalla 1 (CLAUDE.md sección 9). Este sistema opera sobre una sola
/// organización por instalación (Pantalla 2 no es una lista, es un
/// formulario) -- así que Inicio se fusiona con esa alta, mismo criterio
/// que "Proyectos" en `sistema-red-distribucion`: sin organización creada
/// todavía, Inicio ES el formulario de alta -- o, alternativamente, el
/// punto de entrada para cargar el caso de estudio de ejemplo o importar
/// una organización ya exportada.
class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  bool _cargando = true;
  Organizacion? _organizacion;

  @override
  void initState() {
    super.initState();
    _cargar();
    final tour = context.read<TourController>();
    if (!tour.yaVisto) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _abrirInduccion());
    }
  }

  Future<void> _cargar() async {
    setState(() => _cargando = true);
    final todas = await context.read<OrganizacionRepository>().obtenerTodas();
    if (!mounted) return;
    final organizacion = todas.isEmpty ? null : todas.first;
    if (organizacion != null) {
      context.read<OrganizacionActiva>().seleccionar(organizacion);
    }
    setState(() {
      _organizacion = organizacion;
      _cargando = false;
    });
  }

  Future<void> _abrirInduccion() async {
    if (!mounted) return;
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => InduccionScreen(tour: context.read<TourController>())));
  }

  Future<void> _abrirFormularioOrganizacion() async {
    final guardada = await Navigator.of(context).push<Organizacion>(
      MaterialPageRoute(builder: (_) => OrganizacionFormScreen(existente: _organizacion)),
    );
    if (guardada != null) await _cargar();
  }

  Future<void> _cargarCasoDeEstudio() async {
    await sembrarCasoEstudio(context.read<AppDatabase>());
    await _cargar();
  }

  Future<void> _importarOrganizacion() async {
    final importada = await Navigator.of(
      context,
    ).push<bool>(MaterialPageRoute(builder: (_) => const ImportarOrganizacionScreen()));
    if (importada == true) await _cargar();
  }

  Future<void> _eliminarOrganizacion() async {
    final organizacion = _organizacion;
    if (organizacion == null) return;
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('¿Eliminar esta organización?'),
        content: Text(
          'Se borrarán de forma permanente todos los datos de '
          '"${organizacion.nombre}": periodos, indicadores, mediciones, '
          'evaluaciones, acciones, presupuesto, diagnósticos y facturas. '
          'Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Theme.of(dialogContext).colorScheme.error),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmar != true || !mounted) return;

    await context.read<OrganizacionRepository>().eliminar(organizacion.id!);
    if (!mounted) return;
    context.read<OrganizacionActiva>().limpiar();
    await _cargar();
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final organizacion = _organizacion;
    return Scaffold(
      appBar: AppBar(
        title: Text(organizacion?.nombre ?? 'Control logístico'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.circleHelp),
            tooltip: 'Ver introducción',
            onPressed: _abrirInduccion,
          ),
          if (organizacion != null) ...[
            IconButton(
              icon: const Icon(LucideIcons.pencil),
              tooltip: 'Editar organización',
              onPressed: _abrirFormularioOrganizacion,
            ),
            IconButton(
              icon: const Icon(LucideIcons.trash2),
              tooltip: 'Eliminar organización',
              onPressed: _eliminarOrganizacion,
            ),
          ],
        ],
      ),
      body: organizacion == null
          ? _EstadoSinOrganizacion(
              onCrear: _abrirFormularioOrganizacion,
              onCargarCaso: _cargarCasoDeEstudio,
              onImportar: _importarOrganizacion,
            )
          : _Dashboard(organizacion: organizacion),
    );
  }
}

class _EstadoSinOrganizacion extends StatelessWidget {
  const _EstadoSinOrganizacion({required this.onCrear, required this.onCargarCaso, required this.onImportar});

  final VoidCallback onCrear;
  final VoidCallback onCargarCaso;
  final VoidCallback onImportar;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.building2, size: 48, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'Sistema de control logístico de lazo cerrado',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Crea tu organización para empezar a definir periodos e indicadores, '
              'o explora el sistema con el caso de estudio de ejemplo.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onCrear,
              icon: const Icon(LucideIcons.plus),
              label: const Text('Crear organización'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onCargarCaso,
              icon: const Icon(LucideIcons.flaskConical),
              label: const Text('Cargar caso de estudio de ejemplo'),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: onImportar,
              icon: const Icon(LucideIcons.fileUp),
              label: const Text('Importar una organización ya exportada'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dashboard extends StatelessWidget {
  const _Dashboard({required this.organizacion});

  final Organizacion organizacion;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(LucideIcons.building2),
            title: Text(organizacion.nombre),
            subtitle: Text(
              '${_etiquetasTipoEmpresa[organizacion.tipoEmpresa] ?? organizacion.tipoEmpresa} · '
              '${organizacion.moneda}',
            ),
          ),
        ),
        const SizedBox(height: 16),
        _TarjetaAcceso(
          icono: LucideIcons.calendarRange,
          titulo: 'Periodos',
          subtitulo: 'Calendario de periodos de medición',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => PeriodosScreen(organizacionId: organizacion.id!)),
          ),
        ),
        const SizedBox(height: 12),
        _TarjetaAcceso(
          icono: LucideIcons.gauge,
          titulo: 'Indicadores',
          subtitulo: 'Catálogo con meta, banda y sentido de mejora',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => IndicadoresScreen(organizacionId: organizacion.id!)),
          ),
        ),
        const SizedBox(height: 12),
        _TarjetaAcceso(
          icono: LucideIcons.clipboardList,
          titulo: 'Captura',
          subtitulo: 'Ingreso de mediciones por periodo, con importación CSV',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => CapturaScreen(organizacionId: organizacion.id!)),
          ),
        ),
        const SizedBox(height: 12),
        _TarjetaAcceso(
          icono: LucideIcons.scanSearch,
          titulo: 'Evaluación del periodo',
          subtitulo: 'Veredictos, clasificación y reglas disparadas',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => EvaluacionPeriodoScreen(organizacionId: organizacion.id!)),
          ),
        ),
        const SizedBox(height: 12),
        _TarjetaAcceso(
          icono: LucideIcons.listChecks,
          titulo: 'Acciones',
          subtitulo: 'Propuestas del sistema y seguimiento de lo registrado',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => AccionesScreen(organizacionId: organizacion.id!)),
          ),
        ),
        const SizedBox(height: 12),
        _TarjetaAcceso(
          icono: LucideIcons.badgeCheck,
          titulo: 'Verificación',
          subtitulo: 'Confirmar si las acciones tomadas corrigieron la desviación',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => VerificacionScreen(organizacionId: organizacion.id!)),
          ),
        ),
        const SizedBox(height: 12),
        _TarjetaAcceso(
          icono: LucideIcons.circleDollarSign,
          titulo: 'Costo y servicio',
          subtitulo: 'Desglose por proceso, peso relativo y centro de utilidades',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => InformeCostoServicioScreen(organizacion: organizacion)),
          ),
        ),
        const SizedBox(height: 12),
        _TarjetaAcceso(
          icono: LucideIcons.gauge,
          titulo: 'Productividad',
          subtitulo: 'Índices de productividad contra su meta',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => InformeProductividadScreen(organizacion: organizacion)),
          ),
        ),
        const SizedBox(height: 12),
        _TarjetaAcceso(
          icono: LucideIcons.tableProperties,
          titulo: 'Tabla de desempeño',
          subtitulo: 'Matriz de indicadores por periodo con semáforo',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => TablaDesempenoScreen(organizacion: organizacion)),
          ),
        ),
        const SizedBox(height: 12),
        _TarjetaAcceso(
          icono: LucideIcons.wallet,
          titulo: 'Presupuesto',
          subtitulo: 'Presupuestado contra real y variaciones',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => PresupuestoScreen(organizacion: organizacion)),
          ),
        ),
        const SizedBox(height: 12),
        _TarjetaAcceso(
          icono: LucideIcons.flaskConical,
          titulo: 'Laboratorio — generador',
          subtitulo: 'Series sintéticas por patrón, con semilla reproducible',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => LaboratorioGeneradorScreen(organizacionId: organizacion.id!)),
          ),
        ),
        const SizedBox(height: 12),
        _TarjetaAcceso(
          icono: LucideIcons.clock,
          titulo: 'Laboratorio — simulación',
          subtitulo: 'Reloj de periodos: avanzar, retroceder, estado en vivo',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => RelojSimulacionScreen(organizacionId: organizacion.id!)),
          ),
        ),
        const SizedBox(height: 12),
        _TarjetaAcceso(
          icono: LucideIcons.radar,
          titulo: 'Diagnóstico organizacional',
          subtitulo: 'Etapa de desarrollo, ejes y orientación dominante',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => DiagnosticoOrganizacionalScreen(organizacionId: organizacion.id!)),
          ),
        ),
        const SizedBox(height: 12),
        _TarjetaAcceso(
          icono: LucideIcons.receipt,
          titulo: 'Auditoría de facturas',
          subtitulo: 'Recálculo contra el tarifario y monto recuperable',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => AuditoriaFacturasScreen(organizacion: organizacion)),
          ),
        ),
        const SizedBox(height: 12),
        _TarjetaAcceso(
          icono: LucideIcons.gitCompare,
          titulo: 'Laboratorio — contraste',
          subtitulo: 'Umbral simple contra reconocimiento de patrones',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => LaboratorioContrasteScreen(organizacionId: organizacion.id!)),
          ),
        ),
        const SizedBox(height: 12),
        _TarjetaAcceso(
          icono: LucideIcons.slidersHorizontal,
          titulo: 'Laboratorio — calibrador',
          subtitulo: 'Propuesta de banda óptima a partir de eventos marcados',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => LaboratorioCalibradorScreen(organizacionId: organizacion.id!)),
          ),
        ),
        const SizedBox(height: 12),
        _TarjetaAcceso(
          icono: LucideIcons.fileJson,
          titulo: 'Exportación',
          subtitulo: 'Respaldo de la organización completa en un archivo JSON',
          onTap: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => ExportacionScreen(organizacion: organizacion))),
        ),
      ],
    );
  }
}

class _TarjetaAcceso extends StatelessWidget {
  const _TarjetaAcceso({
    required this.icono,
    required this.titulo,
    required this.subtitulo,
    required this.onTap,
  });

  final IconData icono;
  final String titulo;
  final String subtitulo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icono, color: Theme.of(context).colorScheme.primary),
        title: Text(titulo),
        subtitle: Text(subtitulo),
        trailing: const Icon(LucideIcons.chevronRight),
        onTap: onTap,
      ),
    );
  }
}
