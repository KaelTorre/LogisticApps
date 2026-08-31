import 'dart:math';

import 'package:flutter/material.dart';

/// Diferencia perceptual CIE76 (ΔE*ab) entre dos colores — conversión
/// sRGB → XYZ (D65) → CIE Lab, distancia euclídea en el espacio Lab.
/// Usado por [paleta_territorios] para comprobar numéricamente que la
/// paleta mantiene contraste suficiente entre territorios (CLAUDE.md,
/// Fase 8, Test U) — a diferencia de un ΔE validado a mano/externamente,
/// este se calcula y se verifica en el propio código.
double deltaE(Color a, Color b) {
  final labA = _aLab(a);
  final labB = _aLab(b);
  return sqrt(
    pow(labA.$1 - labB.$1, 2) + pow(labA.$2 - labB.$2, 2) + pow(labA.$3 - labB.$3, 2),
  );
}

(double, double, double) _aLab(Color color) {
  double linealizar(double canal) {
    return canal <= 0.04045 ? canal / 12.92 : pow((canal + 0.055) / 1.055, 2.4).toDouble();
  }

  final r = linealizar(color.r);
  final g = linealizar(color.g);
  final b = linealizar(color.b);

  // sRGB (D65) -> XYZ.
  final x = r * 0.4124 + g * 0.3576 + b * 0.1805;
  final y = r * 0.2126 + g * 0.7152 + b * 0.0722;
  final z = r * 0.0193 + g * 0.1192 + b * 0.9505;

  // Blanco de referencia D65.
  const xn = 0.95047, yn = 1.0, zn = 1.08883;

  double f(double t) => t > 0.008856 ? pow(t, 1 / 3).toDouble() : (7.787 * t) + (16 / 116);

  final fx = f(x / xn);
  final fy = f(y / yn);
  final fz = f(z / zn);

  final l = (116 * fy) - 16;
  final aStar = 500 * (fx - fy);
  final bStar = 200 * (fy - fz);
  return (l, aStar, bStar);
}
