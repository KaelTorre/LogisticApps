import 'dart:math';

/// M5 — Generador de series sintéticas (CLAUDE.md sección 8). Función
/// pura: recibe un patrón, sus parámetros, una semilla y el número de
/// periodos, y devuelve una serie de valores con `origen = 'sintetico'`
/// (quien persiste decide ese literal; este módulo solo calcula números).
///
/// [REGLA] "El generador es determinista con semilla. Misma semilla y
/// mismos parámetros producen la misma serie, siempre" -- `Random(semilla)`
/// de Dart ya garantiza esto por sí solo, y el ruido usa Box-Muller sobre
/// esa misma fuente, sin ningún otro origen de aleatoriedad.

/// Los seis patrones obligatorios de la sección 8.
const patronesDisponibles = [
  'estable',
  'punto_aislado',
  'tendencia',
  'corrimiento',
  'estacional',
  'deterioro_brusco',
];

/// Parámetros de un patrón -- cada patrón solo usa un subconjunto (ver
/// [generarSerieSintetica]); los que no aplican se ignoran.
class ParametrosSerieSintetica {
  const ParametrosSerieSintetica({
    this.sigma = 0,
    this.tEvento,
    this.magnitud,
    this.pendiente,
    this.tInicio,
    this.salto,
    this.amplitud,
    this.ciclo,
  });

  /// Desviación estándar del ruido gaussiano agregado a cada punto.
  final double sigma;

  /// `punto_aislado`, `corrimiento`, `deterioro_brusco`: el periodo en el
  /// que ocurre el evento.
  final int? tEvento;

  /// `punto_aislado`: cuánto se desplaza ese único punto.
  final double? magnitud;

  /// `tendencia`: pendiente por periodo.
  final double? pendiente;

  /// `tendencia`: periodo en el que empieza a acumularse la pendiente.
  final int? tInicio;

  /// `corrimiento`, `deterioro_brusco`: tamaño del salto.
  final double? salto;

  /// `estacional`: amplitud de la oscilación.
  final double? amplitud;

  /// `estacional`: longitud del ciclo, en periodos.
  final int? ciclo;
}

/// Genera `numeroPeriodos` valores según [patron], siguiendo exactamente
/// el pseudocódigo de CLAUDE.md sección 8 (M5): `valor[t] = meta +
/// componente(patron, t) + ruido`.
List<double> generarSerieSintetica({
  required String patron,
  required ParametrosSerieSintetica params,
  required int semilla,
  required int numeroPeriodos,
  required double meta,
}) {
  final rng = Random(semilla);
  final valores = <double>[];

  for (var t = 1; t <= numeroPeriodos; t++) {
    final ruido = _ruidoNormal(rng, params.sigma);
    final componente = switch (patron) {
      'estable' => 0.0,
      'punto_aislado' => t == params.tEvento ? (params.magnitud ?? 0) : 0.0,
      'tendencia' => (params.pendiente ?? 0) * max(0, t - (params.tInicio ?? 0)),
      'corrimiento' => t >= (params.tEvento ?? 0) ? (params.salto ?? 0) : 0.0,
      'estacional' => (params.amplitud ?? 0) * sin(2 * pi * t / (params.ciclo ?? 1)),
      'deterioro_brusco' =>
        t >= (params.tEvento ?? 0) ? (params.salto ?? 0) * (t - (params.tEvento ?? 0)) : 0.0,
      _ => throw ArgumentError('Patrón desconocido: "$patron". Válidos: $patronesDisponibles'),
    };
    valores.add(meta + componente + ruido);
  }

  return valores;
}

/// Transformación de Box-Muller sobre la misma fuente semillada -- sin
/// esto, `sigma > 0` introduciría una segunda fuente de aleatoriedad no
/// controlada por la semilla.
double _ruidoNormal(Random rng, double sigma) {
  if (sigma == 0) return 0;
  final u1 = rng.nextDouble().clamp(1e-12, 1.0);
  final u2 = rng.nextDouble();
  final z0 = sqrt(-2 * log(u1)) * cos(2 * pi * u2);
  return z0 * sigma;
}
