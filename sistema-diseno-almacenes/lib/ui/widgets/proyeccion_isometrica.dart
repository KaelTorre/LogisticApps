import 'dart:ui';

import '../../domain/geometria/prisma_3d.dart';

/// Proyección isométrica directa, CLAUDE.md sección 8.2 — fórmula exacta,
/// sin motor 3D.
Offset iso(int x, int y, int z, double s, Offset o) {
  return Offset(o.dx + (x - y) * 0.8660254 * s, o.dy + (x + y) * 0.5 * s - z * s);
}

/// Rotación en 4 ángulos (intercambiar y negar ejes X/Y, CLAUDE.md sección
/// 8.2) — nunca cámara libre. `angulo` en 0..3, pasos de 90° alrededor del
/// eje Z.
(int, int) rotarXY(int x, int y, int angulo) {
  return switch (angulo % 4) {
    0 => (x, y),
    1 => (-y, x),
    2 => (-x, -y),
    _ => (y, -x),
  };
}

/// Orden del algoritmo del pintor (CLAUDE.md sección 8.2): por x+y+z
/// ascendente, sin z-buffer. Se ordena sobre las coordenadas YA rotadas,
/// para que el orden de pintado sea correcto en cualquiera de los 4
/// ángulos.
List<Prisma3D> ordenarParaPintar(List<Prisma3D> prismas, int angulo) {
  final copia = [...prismas];
  copia.sort((a, b) {
    final (xa, ya) = rotarXY(a.xMm, a.yMm, angulo);
    final (xb, yb) = rotarXY(b.xMm, b.yMm, angulo);
    return (xa + ya + a.zMm).compareTo(xb + yb + b.zMm);
  });
  return copia;
}
