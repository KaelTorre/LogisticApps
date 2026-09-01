import 'm1_reglas_patron.dart';
import 'm2_clasificador.dart';

/// Orquesta M1 + M2 sobre **todos** los indicadores de una organización
/// para un mismo periodo -- función pura, igual que los módulos que
/// combina: no toca base de datos, quien la llama ya cargó las series y le
/// entrega todo resuelto.
///
/// Existe porque `procesos_afectados` (CLAUDE.md sección 8, M2) depende de
/// cuántos indicadores del mismo proceso terminan en `estado = desviacion`
/// **en este mismo periodo** -- un dato que ningún indicador puede conocer
/// evaluándose solo. Se resuelve en dos pasadas:
///
/// 1. Clasificar cada indicador con `procesosAfectados = 0` (todavía no se
///    sabe cuántos hay) para averiguar su `estado` preliminar.
/// 2. Contar cuántos, por proceso, quedaron en `desviacion`, y volver a
///    clasificar a cada uno con el conteo real -- ahí es donde algunos
///    pueden escalar a `contingencia`.

/// Lo que el orquestador necesita de un indicador para evaluarlo: su
/// configuración, la serie de mediciones hasta el periodo que se está
/// evaluando (`serie.last` es el punto actual), y cuántos periodos
/// consecutivos *anteriores* ya estaba en desviación (lo calcula quien
/// llama, a partir de evaluaciones ya persistidas de periodos previos).
class IndicadorParaEvaluar {
  const IndicadorParaEvaluar({
    required this.indicadorId,
    required this.proceso,
    required this.config,
    required this.serie,
    this.persistenciaPeriodosPrevios = 0,
  });

  final int indicadorId;
  final String proceso;
  final ConfigIndicadorMotor config;
  final List<PuntoSerieMotor> serie;
  final int persistenciaPeriodosPrevios;
}

class ResultadoEvaluacionIndicador {
  const ResultadoEvaluacionIndicador({
    required this.indicadorId,
    required this.reglas,
    required this.clasificacion,
  });

  final int indicadorId;
  final List<ResultadoRegla> reglas;
  final ResultadoClasificacion clasificacion;
}

Map<int, ResultadoEvaluacionIndicador> evaluarPeriodoCompleto(
  List<IndicadorParaEvaluar> indicadores, {
  UmbralesClasificador umbrales = const UmbralesClasificador(),
}) {
  final reglasPorIndicador = <int, List<ResultadoRegla>>{};
  final preliminarPorIndicador = <int, ResultadoClasificacion>{};

  for (final ind in indicadores) {
    final reglas = evaluarReglasDeSistema(serie: ind.serie, indicador: ind.config);
    reglasPorIndicador[ind.indicadorId] = reglas;
    preliminarPorIndicador[ind.indicadorId] = clasificar(
      resultadosReglas: reglas,
      puntoActual: ind.serie.last,
      indicador: ind.config,
      contexto: ContextoClasificacion(
        procesosAfectados: 0,
        persistenciaPeriodos: ind.persistenciaPeriodosPrevios,
      ),
      umbrales: umbrales,
    );
  }

  final procesosAfectadosPorProceso = <String, int>{};
  for (final ind in indicadores) {
    if (preliminarPorIndicador[ind.indicadorId]!.estado == 'desviacion') {
      procesosAfectadosPorProceso[ind.proceso] = (procesosAfectadosPorProceso[ind.proceso] ?? 0) + 1;
    }
  }

  final resultado = <int, ResultadoEvaluacionIndicador>{};
  for (final ind in indicadores) {
    final clasificacionFinal = clasificar(
      resultadosReglas: reglasPorIndicador[ind.indicadorId]!,
      puntoActual: ind.serie.last,
      indicador: ind.config,
      contexto: ContextoClasificacion(
        procesosAfectados: procesosAfectadosPorProceso[ind.proceso] ?? 0,
        persistenciaPeriodos: ind.persistenciaPeriodosPrevios,
      ),
      umbrales: umbrales,
    );
    resultado[ind.indicadorId] = ResultadoEvaluacionIndicador(
      indicadorId: ind.indicadorId,
      reglas: reglasPorIndicador[ind.indicadorId]!,
      clasificacion: clasificacionFinal,
    );
  }
  return resultado;
}
