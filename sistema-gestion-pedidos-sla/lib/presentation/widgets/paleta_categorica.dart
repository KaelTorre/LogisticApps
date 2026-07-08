import 'package:flutter/material.dart';

import '../../core/constants.dart';

/// Paleta cualitativa (categórica), para datos sin relación de orden entre
/// sí (categorías ABC, estados de un pedido) donde lo que importa es que
/// cada valor se distinga de un vistazo — no una rampa de un solo color,
/// que en el esquema `shadGreen` resulta casi indistinguible entre tonos
/// oscuros. Es la única excepción deliberada a "siempre
/// `Theme.of(context).colorScheme`": son colores de datos, no de UI.
const Color colorCategoricoAmbar = Color(0xFFE8A33D);
const Color colorCategoricoAzul = Color(0xFF5B8DEF);
const Color colorCategoricoVioleta = Color(0xFFA78BFA);

/// Color por categoría ABC (M3): tres tonos con distinta tonalidad
/// (verde/ámbar/azul) en vez de tres intensidades del mismo color.
Color colorCategoriaAbc(BuildContext context, CategoriaAbc categoria) {
  final colorScheme = Theme.of(context).colorScheme;
  return switch (categoria) {
    CategoriaAbc.a => colorScheme.primary,
    CategoriaAbc.b => colorCategoricoAmbar,
    CategoriaAbc.c => colorCategoricoAzul,
  };
}

/// Color de fondo/texto por estado del pedido: los dos estados terminales
/// (`entregado`/`cancelado`) usan un color sólido de tema (éxito/error),
/// los estados intermedios usan un tono cualitativo distinto cada uno para
/// que la máquina de estados se pueda "leer" de un vistazo en una lista o
/// un gráfico.
(Color fondo, Color texto) colorEstadoPedido(
  BuildContext context,
  EstadoPedido estado,
) {
  final colorScheme = Theme.of(context).colorScheme;
  return switch (estado) {
    EstadoPedido.recibido => (
      colorScheme.surfaceContainerHighest,
      colorScheme.onSurfaceVariant,
    ),
    EstadoPedido.procesando => (
      colorCategoricoAzul,
      colorTextoSobre(colorCategoricoAzul),
    ),
    EstadoPedido.preparandoEnvio => (
      colorCategoricoAmbar,
      colorTextoSobre(colorCategoricoAmbar),
    ),
    EstadoPedido.enTransito => (
      colorCategoricoVioleta,
      colorTextoSobre(colorCategoricoVioleta),
    ),
    EstadoPedido.entregado => (colorScheme.primary, colorScheme.onPrimary),
    EstadoPedido.cancelado => (colorScheme.error, colorScheme.onError),
  };
}

/// Color de texto/ícono legible sobre [fondo], calculado por contraste en
/// vez de asumir siempre un mismo color de texto — los tonos cualitativos
/// de esta paleta no vienen con un "on-color" del tema.
Color colorTextoSobre(Color fondo) {
  return ThemeData.estimateBrightnessForColor(fondo) == Brightness.dark
      ? Colors.white
      : Colors.black;
}
