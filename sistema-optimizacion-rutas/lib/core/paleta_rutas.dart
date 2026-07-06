import 'package:flutter/material.dart';

/// Paleta categórica para distinguir rutas/vehículos en el mapa (marcadores y
/// polylines). Validada con el validador de contraste/CVD del skill de
/// dataviz (ΔE adyacente > 12 en ambos modos). Se reserva el azul (color
/// primario del tema `shadBlue`) exclusivamente para la UI y el marcador del
/// depósito, para que una ruta nunca se confunda con un elemento de
/// navegación seleccionado/activo.
///
/// Dos de estos tonos caen por debajo de 3:1 de contraste sobre superficies
/// claras — por eso el color nunca es la única señal: siempre va acompañado
/// de una etiqueta visible (nombre del vehículo) en la leyenda/detalle de
/// ruta, nunca solo el trazo de color (ver CLAUDE.md sección 3.1,
/// accesibilidad).
class ColorRuta {
  const ColorRuta({required this.claro, required this.oscuro});

  final Color claro;
  final Color oscuro;

  Color resolver(Brightness brightness) =>
      brightness == Brightness.dark ? oscuro : claro;
}

const List<ColorRuta> paletaRutas = [
  ColorRuta(claro: Color(0xFF1BAF7A), oscuro: Color(0xFF199E70)), // aqua
  ColorRuta(claro: Color(0xFFEDA100), oscuro: Color(0xFFC98500)), // amarillo
  ColorRuta(claro: Color(0xFF008300), oscuro: Color(0xFF008300)), // verde
  ColorRuta(claro: Color(0xFF4A3AA7), oscuro: Color(0xFF9085E9)), // violeta
  ColorRuta(claro: Color(0xFFE34948), oscuro: Color(0xFFE66767)), // rojo
];

/// Color para una ruta sin vehículo asignado ("flota insuficiente") — gris
/// neutro, deliberadamente fuera de la paleta categórica para no impersonar
/// una ruta real.
const ColorRuta colorSinAsignar = ColorRuta(
  claro: Color(0xFF898781),
  oscuro: Color(0xFF898781),
);

/// Devuelve el color para la ruta en la posición [indice] (cíclico si hay
/// más rutas que colores en la paleta — en la práctica no debería pasar con
/// una flota pequeña de 3-5 vehículos).
ColorRuta colorParaRuta(int indice) => paletaRutas[indice % paletaRutas.length];
