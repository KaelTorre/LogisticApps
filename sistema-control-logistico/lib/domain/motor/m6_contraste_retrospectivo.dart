import 'm1_reglas_patron.dart';
import 'm2_clasificador.dart';

/// M6 — Contraste retrospectivo (CLAUDE.md sección 8). Función pura:
/// recorre la serie completa dos veces, una por método, y en cada paso `t`
/// solo mira `serie[1..t]` -- [REGLA] "el contraste evaluado en el periodo
/// t produce el mismo veredicto que una evaluación normal sobre una base
/// que contenga solo hasta t. Si difiere, el motor está espiando periodos
/// futuros."
///
/// **Umbral simple**: el método que este sistema está criticando --
/// alarma en cuanto el punto queda fuera de banda, sin mirar el patrón.
/// **Reconocimiento de patrones**: M1 + M2, alarma solo cuando la
/// clasificación deja de ser `ninguna` -- por eso un R1 solitario nunca
/// cuenta como alarma para este método, igual que en M2.
///
/// Una alarma es **falsa** cuando, empezando en el propio periodo de la
/// alarma, el mismo método no se mantiene disparado durante al menos
/// [persistencia] periodos consecutivos -- "el mismo método" importa:
/// para umbral simple eso significa seguir fuera de banda; para
/// reconocimiento de patrones, seguir clasificando.

class DeteccionM6 {
  const DeteccionM6({required this.periodo, required this.esFalsaAlarma});

  final int periodo;
  final bool esFalsaAlarma;
}

class ResultadoMetodoM6 {
  const ResultadoMetodoM6({required this.alarmaPorPeriodo, required this.detecciones});

  /// Una entrada por periodo de la serie evaluada, en el mismo orden --
  /// `true` si el método está en alarma en ese periodo. Expuesto para
  /// poder comparar contra una evaluación aislada (Test N) y para
  /// dibujar la línea de tiempo en la Pantalla 14.
  final List<bool> alarmaPorPeriodo;
  final List<DeteccionM6> detecciones;

  DeteccionM6? get primeraDeteccion => detecciones.isEmpty ? null : detecciones.first;

  DeteccionM6? get primeraDeteccionReal {
    for (final d in detecciones) {
      if (!d.esFalsaAlarma) return d;
    }
    return null;
  }

  int get numeroFalsasAlarmas => detecciones.where((d) => d.esFalsaAlarma).length;
}

class ResultadoContrasteM6 {
  const ResultadoContrasteM6({required this.umbralSimple, required this.reconocimientoPatrones});

  final ResultadoMetodoM6 umbralSimple;
  final ResultadoMetodoM6 reconocimientoPatrones;

  /// Periodos de ventaja de reconocimiento de patrones sobre umbral
  /// simple, comparando la primera detección **real** (no falsa) de cada
  /// uno. Positivo = reconocimiento de patrones detectó antes. `null` si
  /// alguno de los dos nunca tuvo una detección real.
  int? get ventajaDeteccionPeriodos {
    final umbral = umbralSimple.primeraDeteccionReal?.periodo;
    final patrones = reconocimientoPatrones.primeraDeteccionReal?.periodo;
    if (umbral == null || patrones == null) return null;
    return umbral - patrones;
  }
}

ResultadoContrasteM6 contrastarMetodos({
  required List<PuntoSerieMotor> serie,
  required ConfigIndicadorMotor indicador,
  int persistencia = 2,
}) {
  final alarmaUmbral = <bool>[];
  for (final punto in serie) {
    alarmaUmbral.add(punto.valor < indicador.bandaInferior || punto.valor > indicador.bandaSuperior);
  }

  final alarmaPatrones = <bool>[];
  var persistenciaClasificador = 0;
  for (var t = 1; t <= serie.length; t++) {
    final subserie = serie.sublist(0, t);
    final reglas = evaluarReglasDeSistema(serie: subserie, indicador: indicador);
    final resultado = clasificar(
      resultadosReglas: reglas,
      puntoActual: subserie.last,
      indicador: indicador,
      contexto: ContextoClasificacion(persistenciaPeriodos: persistenciaClasificador),
    );
    alarmaPatrones.add(resultado.clasificacion != 'ninguna');
    persistenciaClasificador = resultado.estado == 'desviacion' ? persistenciaClasificador + 1 : 0;
  }

  return ResultadoContrasteM6(
    umbralSimple: ResultadoMetodoM6(
      alarmaPorPeriodo: alarmaUmbral,
      detecciones: _detectarEventos(alarmaUmbral, persistencia),
    ),
    reconocimientoPatrones: ResultadoMetodoM6(
      alarmaPorPeriodo: alarmaPatrones,
      detecciones: _detectarEventos(alarmaPatrones, persistencia),
    ),
  );
}

/// Un "evento de detección" empieza en cada flanco de subida (el método
/// pasa de no alarmar a alarmar) y se marca falso cuando la alarma no se
/// sostiene al menos [persistencia] periodos seguidos desde ahí.
List<DeteccionM6> _detectarEventos(List<bool> alarmaPorPeriodo, int persistencia) {
  final eventos = <DeteccionM6>[];
  for (var i = 0; i < alarmaPorPeriodo.length; i++) {
    final esFlancoDeSubida = alarmaPorPeriodo[i] && (i == 0 || !alarmaPorPeriodo[i - 1]);
    if (!esFlancoDeSubida) continue;

    var sostenida = true;
    for (var j = i; j < i + persistencia; j++) {
      if (j >= alarmaPorPeriodo.length || !alarmaPorPeriodo[j]) {
        sostenida = false;
        break;
      }
    }
    eventos.add(DeteccionM6(periodo: i + 1, esFalsaAlarma: !sostenida));
  }
  return eventos;
}
