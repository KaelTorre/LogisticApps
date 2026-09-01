import 'm1_reglas_patron.dart';

/// M2 — Clasificador de magnitud (CLAUDE.md sección 8). Función pura:
/// recibe lo que M1 ya evaluó y decide una de cuatro clasificaciones más
/// el `estado` del periodo para este indicador.
///
/// [REGLA] "R1 aislada no clasifica. Produce estado observación. Este es
/// el corazón conceptual del sistema" -- por eso el chequeo de "solo R1"
/// va primero y corta antes que cualquier otra condición, incluida la de
/// contingencia: ni la peor racha de otros indicadores hace que un R1
/// solitario se convierta en una acción.

/// Los tres umbrales configurables del clasificador (CLAUDE.md sección 8,
/// [REGLA]: "ninguno queda escrito dentro de una condición sin poder
/// cambiarse"). Viven como parámetros con default, no como literales
/// dentro de `clasificar`.
class UmbralesClasificador {
  const UmbralesClasificador({
    this.umbralContingenciaProcesos = 3,
    this.umbralDesviacionRelativaMayor = 1.0,
    this.umbralPersistenciaMayor = 4,
    this.incrementoSeveridadPorPersistencia = 0.1,
  });

  final int umbralContingenciaProcesos;
  final double umbralDesviacionRelativaMayor;
  final int umbralPersistenciaMayor;
  final double incrementoSeveridadPorPersistencia;
}

/// Lo que M2 necesita saber del resto de la organización para decidir si
/// escala a contingencia y qué tan persistente es la desviación de este
/// indicador -- ambos números los calcula quien orquesta la evaluación del
/// periodo completo (ver `orquestador_evaluacion.dart`), nunca M2 mismo:
/// M2 no conoce otros indicadores ni la base de datos.
class ContextoClasificacion {
  const ContextoClasificacion({this.procesosAfectados = 0, this.persistenciaPeriodos = 0});

  /// Cuántos indicadores del mismo proceso (incluido este) están en
  /// `estado = desviacion` en el periodo que se está evaluando.
  final int procesosAfectados;

  /// Cuántos periodos consecutivos *anteriores* a este, este mismo
  /// indicador ya estaba en `estado = desviacion`.
  final int persistenciaPeriodos;
}

class ResultadoClasificacion {
  const ResultadoClasificacion({
    required this.clasificacion,
    required this.estado,
    required this.desviacionRelativa,
    required this.severidadCalculada,
  });

  /// 'ninguna' | 'ajuste_menor' | 'replaneacion_mayor' | 'contingencia'.
  final String clasificacion;

  /// 'normal' | 'observacion' | 'desviacion'.
  final String estado;
  final double desviacionRelativa;

  /// Función explícita de la desviación relativa y la persistencia
  /// (CLAUDE.md sección 11: "no se inventa una escala de uno a diez... es
  /// auditable en la memoria de evaluación") -- 0 cuando no hay
  /// clasificación, para no sugerir severidad donde no hay acción.
  final double severidadCalculada;
}

ResultadoClasificacion clasificar({
  required List<ResultadoRegla> resultadosReglas,
  required PuntoSerieMotor puntoActual,
  required ConfigIndicadorMotor indicador,
  required ContextoClasificacion contexto,
  UmbralesClasificador umbrales = const UmbralesClasificador(),
}) {
  final disparadas = resultadosReglas.where((r) => r.disparada).map((r) => r.codigo).toSet();
  final anchoBanda = indicador.bandaSuperior - indicador.bandaInferior;
  final desviacionRelativa = (puntoActual.valor - indicador.meta).abs() / anchoBanda;

  final String clasificacion;
  if (disparadas.isEmpty) {
    clasificacion = 'ninguna';
  } else if (disparadas.length == 1 && disparadas.contains('R1')) {
    // [REGLA]: R1 sola nunca clasifica, sin excepción -- ver arriba.
    clasificacion = 'ninguna';
  } else if (contexto.procesosAfectados >= umbrales.umbralContingenciaProcesos ||
      (disparadas.contains('R6') && (disparadas.contains('R2') || disparadas.contains('R3')))) {
    clasificacion = 'contingencia';
  } else if ((disparadas.contains('R2') || disparadas.contains('R3') || disparadas.contains('R4')) &&
      (desviacionRelativa > umbrales.umbralDesviacionRelativaMayor ||
          contexto.persistenciaPeriodos >= umbrales.umbralPersistenciaMayor)) {
    clasificacion = 'replaneacion_mayor';
  } else if (disparadas.contains('R2') ||
      disparadas.contains('R3') ||
      disparadas.contains('R4') ||
      disparadas.contains('R5')) {
    clasificacion = 'ajuste_menor';
  } else {
    clasificacion = 'ninguna';
  }

  // 'normal' cuando ninguna regla dispara; 'observacion' cuando algo
  // disparó pero no llegó a clasificar (el caso de R1 sola, y cualquier
  // otro que caiga en la rama "ninguna" de arriba); 'desviacion' en las
  // tres clasificaciones que sí son una acción.
  final estado = disparadas.isEmpty
      ? 'normal'
      : (clasificacion == 'ninguna' ? 'observacion' : 'desviacion');

  final severidadCalculada = clasificacion == 'ninguna'
      ? 0.0
      : desviacionRelativa * (1 + contexto.persistenciaPeriodos * umbrales.incrementoSeveridadPorPersistencia);

  return ResultadoClasificacion(
    clasificacion: clasificacion,
    estado: estado,
    desviacionRelativa: desviacionRelativa,
    severidadCalculada: severidadCalculada,
  );
}
