/// M9 — Diagnóstico de estructura organizacional (CLAUDE.md sección 8).
/// Cuestionario ponderado y determinista: las mismas respuestas producen
/// siempre la misma etapa, los mismos ejes, la misma orientación dominante
/// y la misma opción organizacional -- sin ningún elemento aleatorio ni
/// dependiente del momento en que se responde.
///
/// Anclado en el capítulo 15 del curso: la evolución de la organización
/// logística en etapas de integración creciente, los ejes de
/// centralización y de rol asesor-contra-línea, y la orientación dominante
/// entre proceso, mercado e información (sección 8 de
/// `sistema-control-logistico.md`, "Diagnóstico de estructura
/// organizacional").
library;

class OpcionPregunta {
  const OpcionPregunta({required this.valor, required this.etiqueta});

  /// Lo que aporta esta opción al bloque de su pregunta: '1'..'4' para
  /// `etapa`, '0'/'25'/'50'/'75'/'100' para los dos ejes numéricos, o el
  /// código directo ('proceso'/'mercado'/'informacion',
  /// 'funcional'/'matricial'/'por_procesos') para los bloques de voto.
  final String valor;
  final String etiqueta;
}

class PreguntaDiagnostico {
  const PreguntaDiagnostico({
    required this.id,
    required this.bloque,
    required this.texto,
    required this.opciones,
  });

  final String id;

  /// 'etapa' | 'centralizacion' | 'asesorLinea' | 'orientacion' | 'opcion'.
  final String bloque;
  final String texto;
  final List<OpcionPregunta> opciones;
}

/// Las quince preguntas del cuestionario: 4 de etapa, 3 de centralización,
/// 3 de rol asesor-contra-línea, 3 de orientación dominante y 2 de opción
/// organizacional. Cada pregunta se responde de forma independiente; el
/// orden de las opciones dentro de cada pregunta ya está pensado para que
/// la etiqueta 'a' sea la lectura más favorable a ese eje y 'e'/'d' la
/// menos, pero lo que realmente puntúa es siempre `valor`, nunca la
/// posición.
const List<PreguntaDiagnostico> preguntasDiagnostico = [
  PreguntaDiagnostico(
    id: 'etapa-1',
    bloque: 'etapa',
    texto:
        '¿Cómo están hoy repartidas las actividades de transporte, '
        'almacenamiento e inventario dentro de la organización?',
    opciones: [
      OpcionPregunta(
        valor: '1',
        etiqueta: 'Cada una depende de un área distinta, sin ninguna coordinación formal entre ellas.',
      ),
      OpcionPregunta(
        valor: '2',
        etiqueta:
            'Algunas están agrupadas bajo una misma gerencia (por ejemplo, transporte y almacenamiento juntos), pero no todas.',
      ),
      OpcionPregunta(valor: '3', etiqueta: 'Todas dependen de una sola gerencia o dirección logística.'),
      OpcionPregunta(
        valor: '4',
        etiqueta:
            'Dependen de una dirección logística que además coordina formalmente con compras, producción y marketing.',
      ),
    ],
  ),
  PreguntaDiagnostico(
    id: 'etapa-2',
    bloque: 'etapa',
    texto:
        'Cuando hay que decidir entre bajar el costo de transporte y mejorar el '
        'nivel de servicio al cliente, ¿quién resuelve el conflicto?',
    opciones: [
      OpcionPregunta(
        valor: '1',
        etiqueta: 'Cada área defiende su propio indicador; el conflicto casi nunca se resuelve formalmente.',
      ),
      OpcionPregunta(
        valor: '2',
        etiqueta: 'Se resuelve dentro del grupo que ya comparte gerencia.',
      ),
      OpcionPregunta(valor: '3', etiqueta: 'Lo resuelve la dirección logística, viendo el costo total del sistema.'),
      OpcionPregunta(
        valor: '4',
        etiqueta: 'Se resuelve en conjunto con marketing y producción, viendo el impacto en toda la cadena.',
      ),
    ],
  ),
  PreguntaDiagnostico(
    id: 'etapa-3',
    bloque: 'etapa',
    texto: '¿Existe un presupuesto logístico único, o cada actividad tiene el suyo dentro de su propia área?',
    opciones: [
      OpcionPregunta(valor: '1', etiqueta: 'Cada actividad logística tiene su presupuesto dentro de un área distinta.'),
      OpcionPregunta(valor: '2', etiqueta: 'Hay presupuestos agrupados para algunas actividades relacionadas, no para todas.'),
      OpcionPregunta(valor: '3', etiqueta: 'Hay un presupuesto logístico único.'),
      OpcionPregunta(
        valor: '4',
        etiqueta: 'Hay un presupuesto logístico único, integrado con el de la cadena de suministro completa.',
      ),
    ],
  ),
  PreguntaDiagnostico(
    id: 'etapa-4',
    bloque: 'etapa',
    texto:
        '¿Con qué frecuencia logística participa desde el inicio en decisiones de otras '
        'áreas (por ejemplo, un lanzamiento de marketing o un cambio en producción)?',
    opciones: [
      OpcionPregunta(valor: '1', etiqueta: 'Nunca; se entera cuando ya hay que ejecutar.'),
      OpcionPregunta(valor: '2', etiqueta: 'A veces, si la otra área lo pide.'),
      OpcionPregunta(valor: '3', etiqueta: 'Siempre que la decisión afecta directamente a logística.'),
      OpcionPregunta(valor: '4', etiqueta: 'Siempre, como parte de un proceso formal de planeación conjunta.'),
    ],
  ),
  PreguntaDiagnostico(
    id: 'central-1',
    bloque: 'centralizacion',
    texto: '¿Dónde se toman las decisiones operativas del día a día (por ejemplo, elegir transportista para un envío puntual)?',
    opciones: [
      OpcionPregunta(valor: '100', etiqueta: 'Siempre en la oficina central.'),
      OpcionPregunta(valor: '75', etiqueta: 'Casi siempre en la oficina central.'),
      OpcionPregunta(valor: '50', etiqueta: 'Depende del caso.'),
      OpcionPregunta(valor: '25', etiqueta: 'Casi siempre en cada punto o sucursal.'),
      OpcionPregunta(valor: '0', etiqueta: 'Siempre en cada punto o sucursal.'),
    ],
  ),
  PreguntaDiagnostico(
    id: 'central-2',
    bloque: 'centralizacion',
    texto: '¿Quién define la meta y la banda de tolerancia de un indicador logístico?',
    opciones: [
      OpcionPregunta(valor: '100', etiqueta: 'Solo la dirección central.'),
      OpcionPregunta(valor: '75', etiqueta: 'La dirección central, con algo de consulta.'),
      OpcionPregunta(valor: '50', etiqueta: 'Se define en conjunto.'),
      OpcionPregunta(valor: '25', etiqueta: 'Cada sucursal o planta, con algo de consulta.'),
      OpcionPregunta(valor: '0', etiqueta: 'Cada sucursal o planta, de forma independiente.'),
    ],
  ),
  PreguntaDiagnostico(
    id: 'central-3',
    bloque: 'centralizacion',
    texto: '¿Cómo se maneja el presupuesto logístico de cada sucursal o planta?',
    opciones: [
      OpcionPregunta(valor: '100', etiqueta: 'Lo define y controla completamente la oficina central.'),
      OpcionPregunta(valor: '75', etiqueta: 'La oficina central lo define, la sucursal lo ejecuta.'),
      OpcionPregunta(valor: '50', etiqueta: 'Se negocia entre ambas.'),
      OpcionPregunta(valor: '25', etiqueta: 'La sucursal propone, la central solo aprueba.'),
      OpcionPregunta(valor: '0', etiqueta: 'Cada sucursal lo maneja con autonomía total.'),
    ],
  ),
  PreguntaDiagnostico(
    id: 'asesor-1',
    bloque: 'asesorLinea',
    texto: 'Cuando el área de logística detecta un problema, ¿qué puede hacer al respecto?',
    opciones: [
      OpcionPregunta(valor: '0', etiqueta: 'Solo puede recomendar, sin ninguna autoridad para exigir el cambio.'),
      OpcionPregunta(valor: '25', etiqueta: 'Recomienda, y la decisión final es de otra área.'),
      OpcionPregunta(valor: '50', etiqueta: 'Recomienda y participa en la decisión final junto con otras áreas.'),
      OpcionPregunta(valor: '75', etiqueta: 'Decide, pero necesita el visto bueno de otra área.'),
      OpcionPregunta(valor: '100', etiqueta: 'Decide y ejecuta directamente, con autoridad propia.'),
    ],
  ),
  PreguntaDiagnostico(
    id: 'asesor-2',
    bloque: 'asesorLinea',
    texto: '¿El responsable de logística puede aprobar gastos de su área sin pedir permiso a otra gerencia?',
    opciones: [
      OpcionPregunta(valor: '0', etiqueta: 'No, todo gasto lo aprueba otra área.'),
      OpcionPregunta(valor: '25', etiqueta: 'Solo gastos muy pequeños.'),
      OpcionPregunta(valor: '50', etiqueta: 'Los gastos rutinarios sí, los grandes no.'),
      OpcionPregunta(valor: '75', etiqueta: 'La mayoría, salvo los excepcionales.'),
      OpcionPregunta(valor: '100', etiqueta: 'Sí, tiene autoridad total sobre el presupuesto de su área.'),
    ],
  ),
  PreguntaDiagnostico(
    id: 'asesor-3',
    bloque: 'asesorLinea',
    texto:
        'Si logística y otra área (por ejemplo ventas) no se ponen de acuerdo sobre una '
        'entrega urgente, ¿quién tiene la última palabra?',
    opciones: [
      OpcionPregunta(valor: '0', etiqueta: 'Siempre la otra área.'),
      OpcionPregunta(valor: '25', etiqueta: 'Casi siempre la otra área.'),
      OpcionPregunta(valor: '50', etiqueta: 'Se negocia caso por caso.'),
      OpcionPregunta(valor: '75', etiqueta: 'Casi siempre logística.'),
      OpcionPregunta(valor: '100', etiqueta: 'Siempre logística, si la decisión es sobre su propia operación.'),
    ],
  ),
  PreguntaDiagnostico(
    id: 'orient-1',
    bloque: 'orientacion',
    texto: 'Cuando se organiza el trabajo de logística, ¿alrededor de qué se agrupan las tareas?',
    opciones: [
      OpcionPregunta(valor: 'proceso', etiqueta: 'Alrededor del flujo completo del pedido, de punta a punta.'),
      OpcionPregunta(valor: 'mercado', etiqueta: 'Alrededor de cada mercado, canal o tipo de cliente atendido.'),
      OpcionPregunta(valor: 'informacion', etiqueta: 'Alrededor de los sistemas y los datos que hay que mantener actualizados.'),
    ],
  ),
  PreguntaDiagnostico(
    id: 'orient-2',
    bloque: 'orientacion',
    texto: '¿Qué se revisa primero cuando algo sale mal?',
    opciones: [
      OpcionPregunta(valor: 'proceso', etiqueta: 'En qué paso del proceso se rompió el flujo.'),
      OpcionPregunta(valor: 'mercado', etiqueta: 'Qué cliente o mercado se vio afectado.'),
      OpcionPregunta(valor: 'informacion', etiqueta: 'Si el dato que llegó al sistema era correcto.'),
    ],
  ),
  PreguntaDiagnostico(
    id: 'orient-3',
    bloque: 'orientacion',
    texto: '¿Qué se prioriza al diseñar un nuevo indicador o reporte?',
    opciones: [
      OpcionPregunta(valor: 'proceso', etiqueta: 'Que muestre el desempeño de principio a fin del proceso logístico.'),
      OpcionPregunta(valor: 'mercado', etiqueta: 'Que muestre el desempeño por mercado o segmento de cliente.'),
      OpcionPregunta(valor: 'informacion', etiqueta: 'Que sea fácil de generar automáticamente desde los sistemas existentes.'),
    ],
  ),
  PreguntaDiagnostico(
    id: 'opcion-1',
    bloque: 'opcion',
    texto: '¿Cómo están definidos los puestos dentro de logística?',
    opciones: [
      OpcionPregunta(
        valor: 'funcional',
        etiqueta: 'Por función: un área de transporte, otra de almacén, otra de inventarios, cada una con su propio jefe.',
      ),
      OpcionPregunta(
        valor: 'matricial',
        etiqueta:
            'Por proyecto o cliente: cada responsable coordina transporte, almacén e inventario para su propio grupo, reportando también a los jefes funcionales.',
      ),
      OpcionPregunta(
        valor: 'por_procesos',
        etiqueta: 'Por proceso: un responsable de punta a punta del flujo del pedido, sin dividir por función.',
      ),
    ],
  ),
  PreguntaDiagnostico(
    id: 'opcion-2',
    bloque: 'opcion',
    texto: 'Cuando una persona de transporte trabaja en un proyecto especial, ¿a quién reporta?',
    opciones: [
      OpcionPregunta(valor: 'funcional', etiqueta: 'Solo a su jefe de transporte.'),
      OpcionPregunta(valor: 'matricial', etiqueta: 'A su jefe de transporte y también al líder del proyecto, al mismo tiempo.'),
      OpcionPregunta(
        valor: 'por_procesos',
        etiqueta: 'Al responsable del proceso completo al que fue asignada, no a un jefe por función.',
      ),
    ],
  ),
];

/// Los cinco ejes numéricos que alimentan el radar (CLAUDE.md sección 8:
/// "salida en radar más informe de brechas"). `orientacionProceso` +
/// `orientacionMercado` + `orientacionInformacion` suman siempre 100: son
/// el porcentaje de las tres preguntas de orientación que votaron por
/// cada una.
class EjesOrganizacionales {
  const EjesOrganizacionales({
    required this.centralizacion,
    required this.asesorLinea,
    required this.orientacionProceso,
    required this.orientacionMercado,
    required this.orientacionInformacion,
  });

  final double centralizacion;
  final double asesorLinea;
  final double orientacionProceso;
  final double orientacionMercado;
  final double orientacionInformacion;

  Map<String, double> aMapa() => {
    'centralizacion': centralizacion,
    'asesorLinea': asesorLinea,
    'orientacionProceso': orientacionProceso,
    'orientacionMercado': orientacionMercado,
    'orientacionInformacion': orientacionInformacion,
  };

  factory EjesOrganizacionales.deMapa(Map<String, dynamic> mapa) => EjesOrganizacionales(
    centralizacion: (mapa['centralizacion'] as num).toDouble(),
    asesorLinea: (mapa['asesorLinea'] as num).toDouble(),
    orientacionProceso: (mapa['orientacionProceso'] as num).toDouble(),
    orientacionMercado: (mapa['orientacionMercado'] as num).toDouble(),
    orientacionInformacion: (mapa['orientacionInformacion'] as num).toDouble(),
  );
}

class ResultadoDiagnostico {
  const ResultadoDiagnostico({
    required this.etapaResultante,
    required this.opcionOrganizacional,
    required this.orientacionDominante,
    required this.ejes,
  });

  /// 1..4.
  final int etapaResultante;

  /// 'funcional' | 'matricial' | 'por_procesos'.
  final String opcionOrganizacional;

  /// 'proceso' | 'mercado' | 'informacion'.
  final String orientacionDominante;
  final EjesOrganizacionales ejes;
}

/// Evalúa el cuestionario completo. Función pura: mismas [respuestas],
/// mismo resultado siempre -- ninguna rama depende del reloj del sistema
/// ni de ningún otro estado externo.
///
/// [REGLA] de empate, documentada porque el desempate no está en el texto
/// del curso y hay que fijar un criterio reproducible: en `etapa` gana la
/// etapa más baja (postura conservadora, no se asume más integración de
/// la que las respuestas confirman sin ambigüedad); en `orientacion` y en
/// `opcion` se ordena alfabéticamente por el código de la opción -- una
/// regla arbitraria pero determinista, elegida por no favorecer ninguna
/// lectura en particular.
ResultadoDiagnostico evaluarDiagnostico(Map<String, String> respuestas) {
  final porBloque = <String, List<String>>{};
  for (final pregunta in preguntasDiagnostico) {
    final valor = respuestas[pregunta.id];
    if (valor == null) continue;
    porBloque.putIfAbsent(pregunta.bloque, () => []).add(valor);
  }

  final etapaResultante = _ganadorPorConteo(
    porBloque['etapa'] ?? const [],
    ordenDesempate: const ['1', '2', '3', '4'],
  );
  final opcionOrganizacional = _ganadorPorConteo(
    porBloque['opcion'] ?? const [],
    ordenDesempate: const ['funcional', 'matricial', 'por_procesos'],
  );
  final orientacionVotos = porBloque['orientacion'] ?? const [];
  final orientacionDominante = _ganadorPorConteo(
    orientacionVotos,
    ordenDesempate: const ['informacion', 'mercado', 'proceso'],
  );

  final totalOrientacion = orientacionVotos.length;
  double porcentajeVotos(String opcion) =>
      totalOrientacion == 0 ? 0 : orientacionVotos.where((v) => v == opcion).length / totalOrientacion * 100;

  return ResultadoDiagnostico(
    etapaResultante: int.parse(etapaResultante.isEmpty ? '1' : etapaResultante),
    opcionOrganizacional: opcionOrganizacional.isEmpty ? 'funcional' : opcionOrganizacional,
    orientacionDominante: orientacionDominante.isEmpty ? 'proceso' : orientacionDominante,
    ejes: EjesOrganizacionales(
      centralizacion: _promedio(porBloque['centralizacion'] ?? const []),
      asesorLinea: _promedio(porBloque['asesorLinea'] ?? const []),
      orientacionProceso: porcentajeVotos('proceso'),
      orientacionMercado: porcentajeVotos('mercado'),
      orientacionInformacion: porcentajeVotos('informacion'),
    ),
  );
}

String _ganadorPorConteo(List<String> votos, {required List<String> ordenDesempate}) {
  if (votos.isEmpty) return '';
  final conteo = <String, int>{};
  for (final v in votos) {
    conteo[v] = (conteo[v] ?? 0) + 1;
  }
  final maximo = conteo.values.reduce((a, b) => a > b ? a : b);
  final empatados = conteo.entries.where((e) => e.value == maximo).map((e) => e.key).toSet();
  for (final candidato in ordenDesempate) {
    if (empatados.contains(candidato)) return candidato;
  }
  return empatados.first;
}

double _promedio(List<String> valores) {
  if (valores.isEmpty) return 0;
  final suma = valores.map(double.parse).reduce((a, b) => a + b);
  return suma / valores.length;
}

/// Perfil objetivo para el informe de brechas: el que el curso describe
/// como el destino de la evolución organizacional -- etapa 4, con rol de
/// línea (no meramente asesor), una centralización moderada-baja (basta
/// coordinación central, no control operativo total) y orientación
/// fuerte en las tres dimensiones, ligeramente mayor en proceso porque es
/// la que mejor sostiene un lazo de control como el de este sistema.
/// [REGLA]: es un perfil de referencia fijo, no una meta que la
/// organización deba alcanzar a toda costa -- el informe de brechas
/// describe distancia, no exige una acción.
const perfilObjetivoDiagnostico = (
  etapa: 4,
  ejes: EjesOrganizacionales(
    centralizacion: 40,
    asesorLinea: 70,
    orientacionProceso: 45,
    orientacionMercado: 30,
    orientacionInformacion: 25,
  ),
);

class BrechaEje {
  const BrechaEje({required this.eje, required this.etiqueta, required this.actual, required this.objetivo});

  final String eje;
  final String etiqueta;
  final double actual;
  final double objetivo;

  /// Positivo: falta camino por recorrer en este eje. Negativo: la
  /// organización ya está más allá del perfil de referencia en este eje.
  double get brecha => objetivo - actual;
}

/// Informe de brechas (CLAUDE.md sección 8): compara el resultado actual
/// contra [perfilObjetivoDiagnostico], eje por eje.
List<BrechaEje> calcularBrechas(ResultadoDiagnostico resultado) {
  final objetivo = perfilObjetivoDiagnostico.ejes;
  return [
    BrechaEje(
      eje: 'etapa',
      etiqueta: 'Etapa de desarrollo',
      actual: resultado.etapaResultante.toDouble(),
      objetivo: perfilObjetivoDiagnostico.etapa.toDouble(),
    ),
    BrechaEje(
      eje: 'centralizacion',
      etiqueta: 'Centralización',
      actual: resultado.ejes.centralizacion,
      objetivo: objetivo.centralizacion,
    ),
    BrechaEje(
      eje: 'asesorLinea',
      etiqueta: 'Rol de línea (contra asesor)',
      actual: resultado.ejes.asesorLinea,
      objetivo: objetivo.asesorLinea,
    ),
    BrechaEje(
      eje: 'orientacionProceso',
      etiqueta: 'Orientación a proceso',
      actual: resultado.ejes.orientacionProceso,
      objetivo: objetivo.orientacionProceso,
    ),
    BrechaEje(
      eje: 'orientacionMercado',
      etiqueta: 'Orientación a mercado',
      actual: resultado.ejes.orientacionMercado,
      objetivo: objetivo.orientacionMercado,
    ),
    BrechaEje(
      eje: 'orientacionInformacion',
      etiqueta: 'Orientación a información',
      actual: resultado.ejes.orientacionInformacion,
      objetivo: objetivo.orientacionInformacion,
    ),
  ];
}
