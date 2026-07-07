import 'dart:math' as math;

class CoeficienteCostoInvalido implements Exception {
  const CoeficienteCostoInvalido();
  @override
  String toString() => 'El coeficiente de costo (b) debe ser mayor a cero.';
}

class ResultadoOptimizacionServicio {
  final double slOptimo;
  final double pEnOptimo;

  const ResultadoOptimizacionServicio({
    required this.slOptimo,
    required this.pEnOptimo,
  });
}

/// Resuelve el nivel de servicio óptimo `SL*` a partir de la fórmula
/// cerrada de CLAUDE.md §6.4, derivada de `P(SL) = a·√SL − b·SL²`:
///
/// ```
/// SL* = (a / (4b)) ^ (2/3)
/// ```
///
/// [b] igual o menor a cero produce una división por cero / una base no
/// válida para la potencia fraccionaria — se rechaza explícitamente en vez
/// de devolver `NaN`.
ResultadoOptimizacionServicio calcularNivelServicioOptimo({
  required double a,
  required double b,
}) {
  if (b <= 0) throw const CoeficienteCostoInvalido();

  final slOptimo = math.pow(a / (4 * b), 2 / 3).toDouble();
  final pEnOptimo = a * math.sqrt(slOptimo) - b * math.pow(slOptimo, 2);

  return ResultadoOptimizacionServicio(
    slOptimo: slOptimo,
    pEnOptimo: pEnOptimo,
  );
}
