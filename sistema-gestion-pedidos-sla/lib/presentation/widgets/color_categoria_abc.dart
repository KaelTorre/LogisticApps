import 'package:flutter/material.dart';

import '../../core/constants.dart';

/// Color por categoría ABC, como una rampa secuencial sobre
/// `colorScheme.primary` (A = color pleno, C = casi fundido con la
/// superficie) en vez de tres tonos (`secondary`/`tertiary`) que en el
/// esquema `shadGreen` resultan casi indistinguibles entre sí en modo
/// oscuro. Sigue siendo 100% derivado del tema, sin colores fijos.
Color colorCategoriaAbc(BuildContext context, CategoriaAbc categoria) {
  final colorScheme = Theme.of(context).colorScheme;
  return switch (categoria) {
    CategoriaAbc.a => colorScheme.primary,
    CategoriaAbc.b => Color.lerp(colorScheme.primary, colorScheme.surface, 0.45)!,
    CategoriaAbc.c => Color.lerp(colorScheme.primary, colorScheme.surface, 0.75)!,
  };
}

/// Color de texto/ícono legible sobre [fondo], calculado por contraste en
/// vez de asumir siempre texto oscuro (la rampa de [colorCategoriaAbc] va
/// de un verde claro a un tono casi negro).
Color colorTextoSobre(Color fondo) {
  return ThemeData.estimateBrightnessForColor(fondo) == Brightness.dark
      ? Colors.white
      : Colors.black;
}
