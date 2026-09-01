import '../../domain/motor/m5_generador_series.dart';

/// Genera las series de 36 periodos del caso de estudio precargado.
///
/// [REGLA] "Si el costo de transporte sube en un periodo, la utilización
/// de flota debe bajar en ese mismo periodo. Un caso con indicadores que
/// se contradicen resta credibilidad y es un defecto, no un detalle."
/// Acá esa coherencia no queda librada al azar: cada par declarado en
/// [paresCorrelacionadosCasoEstudio] se construye de forma estructural
/// (un indicador es función lineal de la desviación del otro, más ruido),
/// así que el signo de la correlación queda garantizado por el diseño de
/// la fórmula, no por esperanza estadística. El ruido de cada serie sí
/// sale de M5 (`generarSerieSintetica`), que ya es determinista con
/// semilla -- esto no agrega ninguna otra fuente de aleatoriedad.
///
/// El indicador `CE-T1` (costo de transporte) es el único con un patrón de
/// deterioro real: estable hasta el periodo 24, con una tendencia
/// sostenida hacia el lado adverso desde ahí -- es lo que garantiza que
/// el caso alcance una desviación clasificada dentro de los 36 periodos.
class ParCorrelacionadoCasoEstudio {
  const ParCorrelacionadoCasoEstudio({
    required this.codigoA,
    required this.codigoB,
    required this.signoEsperado,
  });

  final String codigoA;
  final String codigoB;

  /// 1 (positiva) o -1 (negativa).
  final int signoEsperado;
}

const paresCorrelacionadosCasoEstudio = [
  ParCorrelacionadoCasoEstudio(codigoA: 'CE-T1', codigoB: 'CE-T2', signoEsperado: -1),
  ParCorrelacionadoCasoEstudio(codigoA: 'CE-A2', codigoB: 'CE-A1', signoEsperado: -1),
  ParCorrelacionadoCasoEstudio(codigoA: 'CE-E3', codigoB: 'CE-E2', signoEsperado: 1),
];

const numeroPeriodosCasoEstudio = 36;

Map<String, List<double>> generarSeriesCasoEstudio({int semilla = 20260901}) {
  const n = numeroPeriodosCasoEstudio;

  // CE-T1: estable hasta el periodo 24, deterioro sostenido después.
  final t1 = generarSerieSintetica(
    patron: 'tendencia',
    params: const ParametrosSerieSintetica(sigma: 0.008, pendiente: 0.014, tInicio: 24),
    semilla: semilla,
    numeroPeriodos: n,
    meta: 1.20,
  );

  // CE-T2: se mueve en sentido contrario a la desviación de CE-T1.
  final ruidoT2 = _ruido(semilla: semilla + 1, n: n, sigma: 1.5);
  final t2 = [for (var i = 0; i < n; i++) 82.0 - 25.0 * (t1[i] - 1.20) + ruidoT2[i]];

  // CE-T3: independiente, sin patrón especial.
  final t3 = generarSerieSintetica(
    patron: 'estable',
    params: const ParametrosSerieSintetica(sigma: 1.0),
    semilla: semilla + 2,
    numeroPeriodos: n,
    meta: 18,
  );

  // CE-A2: mejora gradual (curva de aprendizaje), sin evento de deterioro.
  final a2 = generarSerieSintetica(
    patron: 'tendencia',
    params: const ParametrosSerieSintetica(sigma: 1.5, pendiente: 0.15, tInicio: 0),
    semilla: semilla + 3,
    numeroPeriodos: n,
    meta: 45,
  );

  // CE-A1: se mueve en sentido contrario a la desviación de CE-A2.
  final ruidoA1 = _ruido(semilla: semilla + 4, n: n, sigma: 0.03);
  final a1 = [for (var i = 0; i < n; i++) 0.85 - 0.02 * (a2[i] - 45.0) + ruidoA1[i]];

  // CE-A3: independiente, sin patrón especial.
  final a3 = generarSerieSintetica(
    patron: 'estable',
    params: const ParametrosSerieSintetica(sigma: 0.8),
    semilla: semilla + 5,
    numeroPeriodos: n,
    meta: 97,
  );

  // CE-E3: independiente, sin patrón especial.
  final e3 = generarSerieSintetica(
    patron: 'estable',
    params: const ParametrosSerieSintetica(sigma: 1.0),
    semilla: semilla + 6,
    numeroPeriodos: n,
    meta: 14,
  );

  // CE-E2: se mueve en el mismo sentido que la desviación de CE-E3.
  final ruidoE2 = _ruido(semilla: semilla + 7, n: n, sigma: 1.5);
  final e2 = [for (var i = 0; i < n; i++) 93.0 + 1.2 * (e3[i] - 14.0) + ruidoE2[i]];

  // CE-E1: independiente, sin patrón especial.
  final e1 = generarSerieSintetica(
    patron: 'estable',
    params: const ParametrosSerieSintetica(sigma: 0.35),
    semilla: semilla + 8,
    numeroPeriodos: n,
    meta: 6.50,
  );

  return {
    'CE-T1': t1,
    'CE-T2': t2,
    'CE-T3': t3,
    'CE-A1': a1,
    'CE-A2': a2,
    'CE-A3': a3,
    'CE-E1': e1,
    'CE-E2': e2,
    'CE-E3': e3,
  };
}

/// Ruido gaussiano puro reusando M5 con `meta = 0` y patrón `estable` --
/// evita duplicar la transformación de Box-Muller acá.
List<double> _ruido({required int semilla, required int n, required double sigma}) {
  return generarSerieSintetica(
    patron: 'estable',
    params: ParametrosSerieSintetica(sigma: sigma),
    semilla: semilla,
    numeroPeriodos: n,
    meta: 0,
  );
}
