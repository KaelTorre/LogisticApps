import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/estado/organizacion_activa.dart';
import '../../../core/tour/induccion_screen.dart';
import '../../../core/tour/tour_controller.dart';
import '../../../data/local/database.dart';
import '../../../data/models/organizacion.dart';
import '../../../data/repositories/indicador_repository.dart';
import '../../../data/repositories/organizacion_repository.dart';
import '../../../data/repositories/periodo_repository.dart';
import '../../../data/seed/caso_estudio_semilla.dart';
import '../acciones/acciones_screen.dart';
import '../auditoria_facturas/auditoria_facturas_screen.dart';
import '../captura/captura_screen.dart';
import '../catalogo_acciones/catalogo_acciones_screen.dart';
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
  bool _cargandoCaso = false;
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
    setState(() => _cargandoCaso = true);
    try {
      await sembrarCasoEstudio(context.read<AppDatabase>());
      await _cargar();
    } catch (error) {
      if (!mounted) return;
      setState(() => _cargandoCaso = false);
      final mensaje = error is YaExisteOrganizacionException
          ? 'Ya existe una organización cargada; elimínala primero si quieres reemplazarla por el caso de estudio.'
          : 'No se pudo cargar el caso de estudio. Vuelve a intentarlo.';
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(showCloseIcon: true, content: Text(mensaje)));
    }
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
              cargandoCaso: _cargandoCaso,
            )
          : _Dashboard(organizacion: organizacion),
    );
  }
}

class _EstadoSinOrganizacion extends StatelessWidget {
  const _EstadoSinOrganizacion({
    required this.onCrear,
    required this.onCargarCaso,
    required this.onImportar,
    required this.cargandoCaso,
  });

  final VoidCallback onCrear;
  final VoidCallback onCargarCaso;
  final VoidCallback onImportar;
  final bool cargandoCaso;

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
              onPressed: cargandoCaso ? null : onCargarCaso,
              icon: cargandoCaso
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(LucideIcons.flaskConical),
              label: Text(cargandoCaso ? 'Cargando caso de estudio…' : 'Cargar caso de estudio de ejemplo'),
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

/// El tablero se organiza como el flujo real de uso, no como una lista
/// plana de pantallas: primero la configuración que se hace una sola vez,
/// luego el ciclo que se repite cada periodo (numerado del 1 al 4, porque
/// ahí el orden sí importa), y por último los informes y módulos que se
/// consultan cuando hace falta. Sin esto, 17 accesos sueltos obligan a
/// adivinar por dónde empezar.
class _Dashboard extends StatefulWidget {
  const _Dashboard({required this.organizacion});

  final Organizacion organizacion;

  @override
  State<_Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<_Dashboard> {
  bool _cargando = true;
  int _numPeriodos = 0;
  int _numIndicadores = 0;

  @override
  void initState() {
    super.initState();
    _cargarResumen();
  }

  Future<void> _cargarResumen() async {
    final periodos = await context.read<PeriodoRepository>().obtenerPorOrganizacion(
      widget.organizacion.id!,
    );
    if (!mounted) return;
    final indicadores = await context.read<IndicadorRepository>().obtenerPorOrganizacion(
      widget.organizacion.id!,
    );
    if (!mounted) return;
    setState(() {
      _numPeriodos = periodos.length;
      _numIndicadores = indicadores.length;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final organizacion = widget.organizacion;
    if (_cargando) {
      return const Center(child: CircularProgressIndicator());
    }
    final faltaConfiguracion = _numPeriodos == 0 || _numIndicadores == 0;

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
        if (faltaConfiguracion) ...[
          const SizedBox(height: 16),
          _TarjetaPrimerosPasos(
            numPeriodos: _numPeriodos,
            numIndicadores: _numIndicadores,
            onIrAPeriodos: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => PeriodosScreen(organizacionId: organizacion.id!)),
              );
              await _cargarResumen();
            },
            onIrAIndicadores: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => IndicadoresScreen(organizacionId: organizacion.id!)),
              );
              await _cargarResumen();
            },
          ),
        ],
        const SizedBox(height: 20),
        _Seccion(
          titulo: 'Configuración',
          descripcion: 'Se hace una sola vez, antes de empezar a registrar mediciones.',
          tarjetas: [
            _TarjetaAcceso(
              icono: LucideIcons.calendarRange,
              titulo: 'Periodos',
              subtitulo: 'Calendario de periodos de medición',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => PeriodosScreen(organizacionId: organizacion.id!)),
              ),
            ),
            _TarjetaAcceso(
              icono: LucideIcons.gauge,
              titulo: 'Indicadores',
              subtitulo: 'Catálogo con meta, banda y sentido de mejora',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => IndicadoresScreen(organizacionId: organizacion.id!)),
              ),
            ),
          ],
        ),
        _Seccion(
          titulo: 'Ciclo de control',
          descripcion: 'Repite estos cuatro pasos, en orden, cada vez que cierre un periodo.',
          tarjetas: [
            _TarjetaAcceso(
              numero: 1,
              icono: LucideIcons.clipboardList,
              titulo: 'Captura',
              subtitulo: 'Ingresa las mediciones del periodo, con importación CSV',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => CapturaScreen(organizacionId: organizacion.id!)),
              ),
            ),
            _TarjetaAcceso(
              numero: 2,
              icono: LucideIcons.scanSearch,
              titulo: 'Evaluación del periodo',
              subtitulo: 'Corre las reglas de patrón y clasifica cada desviación',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => EvaluacionPeriodoScreen(organizacionId: organizacion.id!)),
              ),
            ),
            _TarjetaAcceso(
              numero: 3,
              icono: LucideIcons.listChecks,
              titulo: 'Acciones',
              subtitulo: 'Registra qué acción correctora se tomó y quién responde',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => AccionesScreen(organizacionId: organizacion.id!)),
              ),
            ),
            _TarjetaAcceso(
              numero: 4,
              icono: LucideIcons.badgeCheck,
              titulo: 'Verificación',
              subtitulo: 'Confirma si la acción corrigió la desviación en el periodo siguiente',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => VerificacionScreen(organizacionId: organizacion.id!)),
              ),
            ),
          ],
        ),
        _Seccion(
          titulo: 'Informes y análisis',
          descripcion: 'Para revisar el desempeño acumulado cuando lo necesites.',
          tarjetas: [
            _TarjetaAcceso(
              icono: LucideIcons.tableProperties,
              titulo: 'Tabla de desempeño',
              subtitulo: 'Matriz de indicadores por periodo con semáforo',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => TablaDesempenoScreen(organizacion: organizacion)),
              ),
            ),
            _TarjetaAcceso(
              icono: LucideIcons.circleDollarSign,
              titulo: 'Costo y servicio',
              subtitulo: 'Desglose por proceso, peso relativo y centro de utilidades',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => InformeCostoServicioScreen(organizacion: organizacion)),
              ),
            ),
            _TarjetaAcceso(
              icono: LucideIcons.gauge,
              titulo: 'Productividad',
              subtitulo: 'Índices de productividad contra su meta',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => InformeProductividadScreen(organizacion: organizacion)),
              ),
            ),
            _TarjetaAcceso(
              icono: LucideIcons.wallet,
              titulo: 'Presupuesto',
              subtitulo: 'Presupuestado contra real y variaciones',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => PresupuestoScreen(organizacion: organizacion)),
              ),
            ),
          ],
        ),
        _Seccion(
          titulo: 'Laboratorio de escenarios',
          descripcion: 'Herramientas opcionales para practicar con datos sintéticos, sin tocar mediciones reales.',
          tarjetas: [
            _TarjetaAcceso(
              icono: LucideIcons.flaskConical,
              titulo: 'Generador',
              subtitulo: 'Series sintéticas por patrón, con semilla reproducible',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => LaboratorioGeneradorScreen(organizacionId: organizacion.id!),
                ),
              ),
            ),
            _TarjetaAcceso(
              icono: LucideIcons.clock,
              titulo: 'Simulación',
              subtitulo: 'Reloj de periodos: avanzar, retroceder, estado en vivo',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => RelojSimulacionScreen(organizacionId: organizacion.id!)),
              ),
            ),
            _TarjetaAcceso(
              icono: LucideIcons.gitCompare,
              titulo: 'Contraste',
              subtitulo: 'Umbral simple contra reconocimiento de patrones',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => LaboratorioContrasteScreen(organizacionId: organizacion.id!),
                ),
              ),
            ),
            _TarjetaAcceso(
              icono: LucideIcons.slidersHorizontal,
              titulo: 'Calibrador',
              subtitulo: 'Propuesta de banda óptima a partir de eventos marcados',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => LaboratorioCalibradorScreen(organizacionId: organizacion.id!),
                ),
              ),
            ),
          ],
        ),
        _Seccion(
          titulo: 'Otros módulos',
          descripcion: 'Herramientas independientes del ciclo de control periodo a periodo.',
          tarjetas: [
            _TarjetaAcceso(
              icono: LucideIcons.radar,
              titulo: 'Diagnóstico organizacional',
              subtitulo: 'Etapa de desarrollo, ejes y orientación dominante',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => DiagnosticoOrganizacionalScreen(organizacionId: organizacion.id!),
                ),
              ),
            ),
            _TarjetaAcceso(
              icono: LucideIcons.receipt,
              titulo: 'Auditoría de facturas',
              subtitulo: 'Recálculo contra el tarifario y monto recuperable',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => AuditoriaFacturasScreen(organizacion: organizacion)),
              ),
            ),
            _TarjetaAcceso(
              icono: LucideIcons.listTree,
              titulo: 'Catálogo de acciones',
              subtitulo: 'Qué acción proponer para cada categoría, magnitud y regla disparada',
              onTap: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const CatalogoAccionesScreen())),
            ),
          ],
        ),
        _Seccion(
          titulo: 'Exportar',
          descripcion: 'Respalda o comparte los datos de la organización.',
          tarjetas: [
            _TarjetaAcceso(
              icono: LucideIcons.fileJson,
              titulo: 'Exportación',
              subtitulo: 'Respaldo de la organización completa en un archivo JSON',
              onTap: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => ExportacionScreen(organizacion: organizacion))),
            ),
          ],
        ),
      ],
    );
  }
}

class _TarjetaPrimerosPasos extends StatelessWidget {
  const _TarjetaPrimerosPasos({
    required this.numPeriodos,
    required this.numIndicadores,
    required this.onIrAPeriodos,
    required this.onIrAIndicadores,
  });

  final int numPeriodos;
  final int numIndicadores;
  final VoidCallback onIrAPeriodos;
  final VoidCallback onIrAIndicadores;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(LucideIcons.rocket, color: colorScheme.onPrimaryContainer),
                const SizedBox(width: 8),
                Text(
                  'Primeros pasos',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(color: colorScheme.onPrimaryContainer),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Antes de registrar mediciones, esta organización necesita al menos un periodo y un indicador.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.onPrimaryContainer),
            ),
            const SizedBox(height: 12),
            _FilaPaso(
              hecho: numPeriodos > 0,
              texto: numPeriodos == 0
                  ? 'Crea al menos un periodo'
                  : '$numPeriodos ${numPeriodos == 1 ? 'periodo creado' : 'periodos creados'}',
              onTap: onIrAPeriodos,
            ),
            _FilaPaso(
              hecho: numIndicadores > 0,
              texto: numIndicadores == 0
                  ? 'Crea al menos un indicador'
                  : '$numIndicadores ${numIndicadores == 1 ? 'indicador creado' : 'indicadores creados'}',
              onTap: onIrAIndicadores,
            ),
          ],
        ),
      ),
    );
  }
}

class _FilaPaso extends StatelessWidget {
  const _FilaPaso({required this.hecho, required this.texto, required this.onTap});

  final bool hecho;
  final String texto;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(
              hecho ? LucideIcons.circleCheck : LucideIcons.circle,
              size: 18,
              color: hecho ? Colors.green : colorScheme.onPrimaryContainer,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(texto, style: TextStyle(color: colorScheme.onPrimaryContainer)),
            ),
            if (!hecho) Icon(LucideIcons.chevronRight, size: 18, color: colorScheme.onPrimaryContainer),
          ],
        ),
      ),
    );
  }
}

class _Seccion extends StatelessWidget {
  const _Seccion({required this.titulo, required this.descripcion, required this.tarjetas});

  final String titulo;
  final String descripcion;
  final List<_TarjetaAcceso> tarjetas;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 2),
          Text(
            descripcion,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 10),
          for (final tarjeta in tarjetas) Padding(padding: const EdgeInsets.only(bottom: 8), child: tarjeta),
        ],
      ),
    );
  }
}

class _TarjetaAcceso extends StatelessWidget {
  const _TarjetaAcceso({
    required this.icono,
    required this.titulo,
    required this.subtitulo,
    required this.onTap,
    this.numero,
  });

  final IconData icono;
  final String titulo;
  final String subtitulo;
  final VoidCallback onTap;
  final int? numero;

  @override
  Widget build(BuildContext context) {
    final numero = this.numero;
    return Card(
      child: ListTile(
        leading: numero != null
            ? CircleAvatar(
                radius: 14,
                child: Text('$numero', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              )
            : Icon(icono, color: Theme.of(context).colorScheme.primary),
        title: Text(titulo),
        subtitle: Text(subtitulo),
        trailing: const Icon(LucideIcons.chevronRight),
        onTap: onTap,
      ),
    );
  }
}
