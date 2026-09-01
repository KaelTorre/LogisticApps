import 'm1_reglas_patron.dart';

/// M7 — Calibrador de banda (CLAUDE.md sección 8). Función pura: dado un
/// histórico y los periodos que el usuario marcó como "esto sí era un
/// problema real", barre anchos de banda candidatos (como porcentaje de
/// la meta, igual que la banda ±8 % del resto del sistema) y propone el
/// más angosto que **no pierde ninguna detección real** y, entre esos,
/// el que menos falsas alarmas produce -- "maximiza detecciones reales y
/// minimiza falsas alarmas" (CLAUDE.md sección 8), en ese orden de
/// prioridad: nunca se propone una banda que deje pasar un problema real
/// solo para ganar en falsas alarmas.
///
/// Sin pseudocódigo propio en el documento (a diferencia de M5 y M6) --
/// el criterio de "detección" aquí es deliberadamente el más simple
/// posible (punto fuera de banda, igual que R1/umbral simple): calibrar
/// la banda es, por definición, calibrar el umbral que R1 usa.
class ResultadoCalibracion {
  const ResultadoCalibracion({
    required this.porcentajeAnchoBanda,
    required this.bandaInferior,
    required this.bandaSuperior,
    required this.periodosDetectados,
    required this.detectadosReales,
    required this.totalReales,
    required this.falsasAlarmas,
  });

  final double porcentajeAnchoBanda;
  final double bandaInferior;
  final double bandaSuperior;
  final Set<int> periodosDetectados;
  final int detectadosReales;
  final int totalReales;
  final int falsasAlarmas;

  bool get pierdeAlgunaDeteccionReal => detectadosReales < totalReales;
}

ResultadoCalibracion calibrarBanda({
  required List<PuntoSerieMotor> serie,
  required double meta,
  required Set<int> periodosReales,
  double porcentajeMinimo = 0.02,
  double porcentajeMaximo = 0.30,
  double paso = 0.01,
}) {
  ResultadoCalibracion? mejor;

  // Ascendente: el barrido prueba primero las bandas más angostas, así
  // que "el primer candidato sin pérdidas" ya es, por construcción, el
  // más angosto de los que no pierden ninguna detección real.
  for (var pct = porcentajeMinimo; pct <= porcentajeMaximo + 1e-9; pct += paso) {
    final candidato = _evaluarCandidato(serie, meta, periodosReales, pct);
    if (candidato.pierdeAlgunaDeteccionReal) continue;
    if (mejor == null || candidato.falsasAlarmas < mejor.falsasAlarmas) {
      mejor = candidato;
    }
  }

  // Si ningún ancho evitó perder detecciones reales (histórico
  // imposible de calibrar sin más datos), se propone el más ancho del
  // barrido -- el que menos probablemente pierde algo, documentado como
  // tal en vez de fallar en silencio.
  return mejor ?? _evaluarCandidato(serie, meta, periodosReales, porcentajeMaximo);
}

ResultadoCalibracion _evaluarCandidato(
  List<PuntoSerieMotor> serie,
  double meta,
  Set<int> periodosReales,
  double porcentaje,
) {
  final bandaInferior = meta * (1 - porcentaje);
  final bandaSuperior = meta * (1 + porcentaje);

  final periodosDetectados = <int>{
    for (final punto in serie)
      if (punto.valor < bandaInferior || punto.valor > bandaSuperior) punto.orden,
  };

  final detectadosReales = periodosReales.where(periodosDetectados.contains).length;
  final falsasAlarmas = periodosDetectados.length - detectadosReales;

  return ResultadoCalibracion(
    porcentajeAnchoBanda: porcentaje,
    bandaInferior: bandaInferior,
    bandaSuperior: bandaSuperior,
    periodosDetectados: periodosDetectados,
    detectadosReales: detectadosReales,
    totalReales: periodosReales.length,
    falsasAlarmas: falsasAlarmas,
  );
}
