import 'dart:math';

/// M7 — efecto de agrupación de riesgos (CLAUDE.md sección 7, cap. 9 de
/// Ballou): regla de la raíz cuadrada. El inventario total no crece
/// proporcional al número de ubicaciones, sino con su raíz cuadrada.
double inventarioTotal(int nUbicaciones, double inventarioBaseUnaUbicacion) {
  return inventarioBaseUnaUbicacion * sqrt(nUbicaciones);
}
