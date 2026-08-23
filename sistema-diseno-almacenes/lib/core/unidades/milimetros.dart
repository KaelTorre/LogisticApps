/// Conversión mm ↔ pulgadas/pies/metros para la capa de presentación.
///
/// El dominio y el motor de cálculo (M1-M8) trabajan siempre en `int`
/// milímetros crudo (CLAUDE.md sección 4) — este tipo NO se usa ahí. Solo
/// sirve para mostrarle al usuario un valor en el sistema de unidades que
/// eligió, sin que la conversión contamine el modelo ni el cálculo.
extension type const Milimetros(int valor) {
  static const _mmPorPulgada = 25.4;
  static const _mmPorPie = 304.8;

  double get enPulgadas => valor / _mmPorPulgada;
  double get enPies => valor / _mmPorPie;
  double get enMetros => valor / 1000;

  static Milimetros desdePulgadas(double pulgadas) =>
      Milimetros((pulgadas * _mmPorPulgada).round());

  static Milimetros desdePies(double pies) =>
      Milimetros((pies * _mmPorPie).round());

  static Milimetros desdeMetros(double metros) =>
      Milimetros((metros * 1000).round());
}
