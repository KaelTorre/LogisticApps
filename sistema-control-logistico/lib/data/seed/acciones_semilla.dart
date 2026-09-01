/// Biblioteca semilla de acciones correctoras (CLAUDE.md sección 11):
/// cubre las tres categorías de indicador (costo, servicio, productividad)
/// y las tres magnitudes de respuesta (ajuste menor, replaneación mayor,
/// contingencia), con textos concretos y accionables -- nunca "mejorar la
/// eficiencia".
///
/// [REGLA] (sección 8, M3): al menos una acción de clasificación
/// `replaneacion_mayor` con `categoriaIndicador = 'costo'` debe apuntar a
/// la Unidad 5 (rediseño de red de distribución) en
/// `aplicacionExternaSugerida` -- es la acción `AC-COSTO-REPL-1` de abajo.
///
/// Cada [AccionSemilla] trae sus propios mapeos hacia `regla_accion`
/// (una fila por (reglaDisparada, clasificacion)); el `accionId` real solo
/// se conoce al insertar, así que `sembrar_catalogos.dart` resuelve esa
/// referencia después de crear la fila en `accion_catalogo`.
class MapeoSemilla {
  const MapeoSemilla({required this.reglaDisparada, this.prioridad = 1});

  final String reglaDisparada;
  final int prioridad;
}

class AccionSemilla {
  const AccionSemilla({
    required this.codigo,
    required this.titulo,
    required this.descripcion,
    required this.categoriaIndicador,
    required this.magnitudTipica,
    this.aplicacionExternaSugerida,
    required this.mapeos,
  });

  final String codigo;
  final String titulo;
  final String descripcion;
  final String categoriaIndicador;
  final String magnitudTipica;
  final String? aplicacionExternaSugerida;

  /// Todas mapeadas hacia [categoriaIndicador] + [magnitudTipica] --
  /// una acción de este catálogo no cambia de categoría según la regla
  /// que la disparó.
  final List<MapeoSemilla> mapeos;
}

const _ajusteMenor = [
  MapeoSemilla(reglaDisparada: 'R2'),
  MapeoSemilla(reglaDisparada: 'R3'),
  MapeoSemilla(reglaDisparada: 'R4'),
  MapeoSemilla(reglaDisparada: 'R5'),
];

const _replaneacionMayor = [
  MapeoSemilla(reglaDisparada: 'R2'),
  MapeoSemilla(reglaDisparada: 'R3'),
  MapeoSemilla(reglaDisparada: 'R4'),
];

const _contingencia = [
  MapeoSemilla(reglaDisparada: 'R2'),
  MapeoSemilla(reglaDisparada: 'R3'),
  MapeoSemilla(reglaDisparada: 'R4'),
  MapeoSemilla(reglaDisparada: 'R5'),
  MapeoSemilla(reglaDisparada: 'R6'),
];

final accionesDeSistemaSemilla = <AccionSemilla>[
  // ─── Costo ───
  const AccionSemilla(
    codigo: 'AC-COSTO-AJUS-1',
    titulo: 'Revisar el factor de carga de los embarques de la ruta afectada',
    descripcion:
        'Consolidar envíos para mejorar el factor de carga y renegociar la '
        'tarifa vigente con el transportista de esa ruta específica.',
    categoriaIndicador: 'costo',
    magnitudTipica: 'ajuste_menor',
    mapeos: _ajusteMenor,
  ),
  const AccionSemilla(
    codigo: 'AC-COSTO-REPL-1',
    titulo: 'Rediseñar la red de distribución',
    descripcion:
        'La geografía de la demanda cambió de forma sostenida: el costo de '
        'transporte ya no se corrige ajustando la operación actual.',
    categoriaIndicador: 'costo',
    magnitudTipica: 'replaneacion_mayor',
    aplicacionExternaSugerida:
        'Sistema de Optimización de Red de Distribución (Unidad 5, '
        'sistema-red-distribucion): cargar la demanda actual por zona y '
        'volver a correr la optimización de ubicación de centros para '
        'decidir si hay que abrir, cerrar o reubicar almacenes.',
    mapeos: _replaneacionMayor,
  ),
  const AccionSemilla(
    codigo: 'AC-COSTO-CONT-1',
    titulo: 'Reevaluar completamente la estructura de costos logísticos',
    descripcion:
        'Varios indicadores de costo se deterioran a la vez, lo que sugiere '
        'una causa común (combustible, tipo de cambio, un proveedor). '
        'Convocar una revisión conjunta con los responsables de cada '
        'proceso de costo afectado antes de tomar acciones puntuales.',
    categoriaIndicador: 'costo',
    magnitudTipica: 'contingencia',
    mapeos: _contingencia,
  ),

  // ─── Servicio ───
  const AccionSemilla(
    codigo: 'AC-SERV-AJUS-1',
    titulo: 'Revisar la asignación de rutas de la zona con caída de cumplimiento',
    descripcion:
        'Redistribuir pedidos entre transportistas o ajustar las ventanas '
        'horarias de entrega en la zona específica afectada.',
    categoriaIndicador: 'servicio',
    magnitudTipica: 'ajuste_menor',
    mapeos: _ajusteMenor,
  ),
  const AccionSemilla(
    codigo: 'AC-SERV-REPL-1',
    titulo: 'Renegociar el nivel de servicio o replantear la cobertura de almacenes',
    descripcion:
        'Una caída sostenida de cumplimiento puede requerir un nuevo '
        'acuerdo de nivel de servicio con los transportistas de la zona, o '
        'evaluar si la red actual de almacenes alcanza a cubrirla a tiempo.',
    categoriaIndicador: 'servicio',
    magnitudTipica: 'replaneacion_mayor',
    mapeos: _replaneacionMayor,
  ),
  const AccionSemilla(
    codigo: 'AC-SERV-CONT-1',
    titulo: 'Auditar el proceso completo de cumplimiento de pedidos',
    descripcion:
        'Convocar a compras, transporte y almacén para revisar juntos en '
        'qué punto de la cadena se está rompiendo el cumplimiento.',
    categoriaIndicador: 'servicio',
    magnitudTipica: 'contingencia',
    mapeos: _contingencia,
  ),

  // ─── Productividad ───
  const AccionSemilla(
    codigo: 'AC-PROD-AJUS-1',
    titulo: 'Revisar la programación de turnos del proceso con caída de productividad',
    descripcion:
        'Ajustar la asignación de personal o el método de trabajo en el '
        'proceso puntual afectado, sin tocar el resto del centro.',
    categoriaIndicador: 'productividad',
    magnitudTipica: 'ajuste_menor',
    mapeos: _ajusteMenor,
  ),
  const AccionSemilla(
    codigo: 'AC-PROD-REPL-1',
    titulo: 'Rediseñar el dimensionamiento del almacén o del proceso',
    descripcion:
        'Una caída sostenida de productividad puede deberse a un layout o '
        'dimensionamiento insuficiente para el volumen actual.',
    categoriaIndicador: 'productividad',
    magnitudTipica: 'replaneacion_mayor',
    aplicacionExternaSugerida:
        'Sistema de Diseño y Dimensionamiento de Almacenes (Unidad 4, '
        'sistema-diseno-almacenes): recalcular posiciones de tarima, rack '
        'y superficie con la demanda actual.',
    mapeos: _replaneacionMayor,
  ),
  const AccionSemilla(
    codigo: 'AC-PROD-CONT-1',
    titulo: 'Revisar la dotación de personal y el plan de capacitación del centro',
    descripcion:
        'Una caída simultánea en varios procesos de productividad sugiere '
        'un problema estructural de dotación o capacitación, no un ajuste '
        'local a un solo proceso.',
    categoriaIndicador: 'productividad',
    magnitudTipica: 'contingencia',
    mapeos: _contingencia,
  ),
];
