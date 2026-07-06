import 'package:flutter/material.dart';

/// Paleta categórica para distinguir rutas/vehículos en el mapa (marcadores,
/// flechas de dirección y polylines). Validada con el validador de
/// contraste/CVD del skill de dataviz (ΔE adyacente > 12 en ambos modos). Se
/// reserva el azul (color primario del tema `shadBlue`) exclusivamente para
/// la UI y el marcador del depósito, para que una ruta nunca se confunda con
/// un elemento de navegación seleccionado/activo.
///
/// Dos de estos tonos caen por debajo de 3:1 de contraste sobre superficies
/// claras — por eso el color nunca es la única señal: siempre va acompañado
/// de una etiqueta visible (nombre del vehículo, número de parada) en la
/// leyenda/detalle de ruta, nunca solo el trazo de color (ver CLAUDE.md
/// sección 3.1, accesibilidad).
class ColorRuta {
  const ColorRuta({required this.claro, required this.oscuro});

  final Color claro;
  final Color oscuro;

  Color resolver(Brightness brightness) =>
      brightness == Brightness.dark ? oscuro : claro;
}

const List<ColorRuta> _paletaValidada = [
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

/// Ángulo dorado (~137.508°): reparte tonos alrededor del círculo de color
/// de la forma más separada posible entre sí sin conocer de antemano cuántos
/// hacen falta — es el mismo truco que usan generadores de paletas
/// categóricas de N arbitrario.
const double _anguloDoradoGrados = 137.508;

/// Banda de tonos reservada para el azul de la UI (evita que una ruta
/// generada se confunda con el color primario del tema o el marcador del
/// depósito).
const double _huesReservadoInicio = 200;
const double _huesReservadoFin = 250;

/// Motor de colores por ruta.
///
/// Para hasta [_paletaValidada.length] rutas simultáneas (el caso normal:
/// pocos vehículos) usa siempre esa paleta ya validada, sin generar nada.
/// Si hay más rutas que colores validados (caso raro, con muchos vehículos a
/// la vez), genera tonos adicionales con el ángulo dorado — sin la
/// validación exhaustiva de la paleta base, pero muy por encima de repetir
/// colores o ciclar la misma paleta corta.
///
/// [semilla] permuta qué color le toca a cada índice — la usa el botón
/// "barajar colores" de la pantalla de Mapa, para separar mejor rutas
/// vecinas si la asignación por defecto no se lee bien contra el mapa.
ColorRuta colorParaRuta(int indice, {int semilla = 0}) {
  final totalValidados = _paletaValidada.length;
  if (indice < totalValidados) {
    return _paletaValidada[(indice + semilla) % totalValidados];
  }
  return _generarColor(indice + semilla);
}

ColorRuta _generarColor(int indice) {
  var hue = (indice * _anguloDoradoGrados) % 360;
  if (hue >= _huesReservadoInicio && hue <= _huesReservadoFin) {
    hue = (hue + (_huesReservadoFin - _huesReservadoInicio) + 15) % 360;
  }

  // Corrección gruesa de luminosidad percibida: a igual "lightness" de HSL,
  // los amarillos/verdes se ven más claros y los azules/violetas más
  // oscuros que el resto. Sin esto, algunos tonos generados quedarían
  // ilegibles (muy pálidos o casi negros) mientras otros se ven bien.
  double ajustarLuminosidad(double base, double hueGrados) {
    final distanciaAAmarilloVerde = (hueGrados - 110).abs().clamp(0, 180);
    final ajuste = (distanciaAAmarilloVerde - 90) / 90 * 0.08;
    return (base + ajuste).clamp(0.25, 0.75);
  }

  final claro = HSLColor.fromAHSL(
    1.0,
    hue,
    0.62,
    ajustarLuminosidad(0.40, hue),
  ).toColor();
  final oscuro = HSLColor.fromAHSL(
    1.0,
    hue,
    0.55,
    ajustarLuminosidad(0.56, hue),
  ).toColor();

  return ColorRuta(claro: claro, oscuro: oscuro);
}
