import 'm1_reglas_patron.dart';
import 'm2_clasificador.dart';

/// Reevalúa M1 + M2 para un único indicador, punto por punto desde el
/// principio de la serie, acumulando la persistencia real -- la misma
/// "sin mirar el futuro" que exige M6 (CLAUDE.md sección 8), factorizada
/// acá porque tanto el contraste retrospectivo (Fase 6) como el reloj de
/// simulación (Fase 7) necesitan exactamente este cálculo.
class EstadoEnPeriodo {
  const EstadoEnPeriodo({required this.periodo, required this.reglas, required this.clasificacion});

  final int periodo;
  final List<ResultadoRegla> reglas;
  final ResultadoClasificacion clasificacion;
}

/// Evalúa hasta el índice [indice] (1-indexado sobre la posición en
/// [serie], no sobre `orden`) recorriendo la serie completa desde el
/// principio -- barato: "evaluar treinta y seis periodos por ocho
/// indicadores es trivial" (CLAUDE.md sección 11), y es lo único que
/// garantiza que avanzar y luego retroceder produzca exactamente el mismo
/// resultado que nunca haberse movido (Fase 7, Test P).
EstadoEnPeriodo evaluarHastaIndice(
  List<PuntoSerieMotor> serie,
  ConfigIndicadorMotor indicador,
  int indice,
) {
  var persistencia = 0;
  List<ResultadoRegla> reglas = const [];
  ResultadoClasificacion? clasificacion;

  for (var i = 1; i <= indice; i++) {
    final subserie = serie.sublist(0, i);
    reglas = evaluarReglasDeSistema(serie: subserie, indicador: indicador);
    clasificacion = clasificar(
      resultadosReglas: reglas,
      puntoActual: subserie.last,
      indicador: indicador,
      contexto: ContextoClasificacion(persistenciaPeriodos: persistencia),
    );
    persistencia = clasificacion.estado == 'desviacion' ? persistencia + 1 : 0;
  }

  return EstadoEnPeriodo(periodo: serie[indice - 1].orden, reglas: reglas, clasificacion: clasificacion!);
}
