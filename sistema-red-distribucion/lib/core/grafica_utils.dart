import 'dart:math' as math;

/// Redondea [valor] hacia arriba al siguiente "número lindo" (1, 2 o 5 × una
/// potencia de 10) — mismo criterio que usan la mayoría de librerías de
/// gráficos para el techo del eje Y. Sin esto (por ejemplo con
/// `maxY: maximo * 1.15` tal cual), el eje termina con una marca automática
/// pegada al borde (p. ej. "11.4M" encima de "10M") porque el tope no cae en
/// un múltiplo del intervalo que `fl_chart` calcula solo.
double techoLindoGrafica(double valor) {
  if (valor <= 0) return 1;
  final exponente = (math.log(valor) / math.ln10).floor();
  final potencia = math.pow(10, exponente).toDouble();
  final mantisa = valor / potencia;
  final mantisaLinda = mantisa <= 1 ? 1 : (mantisa <= 2 ? 2 : (mantisa <= 5 ? 5 : 10));
  return mantisaLinda * potencia;
}
