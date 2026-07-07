/// Función de pérdida de Taguchi (CLAUDE.md §6.5): `L = k · (y − m)²`,
/// donde [y] es el valor observado de la variable de calidad y [m] el
/// valor objetivo.
double calcularPerdidaTaguchi({
  required double k,
  required double y,
  required double m,
}) {
  final desviacion = y - m;
  return k * desviacion * desviacion;
}
