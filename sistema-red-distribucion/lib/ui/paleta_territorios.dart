import 'package:flutter/material.dart';

import 'color_contraste.dart';

/// Paleta categórica para distinguir territorios (almacén abierto + zonas
/// que le asignó M5) en el mapa de resultados — **mismo criterio de
/// contraste que `paleta_rutas.dart` de la Unidad 3** (CLAUDE.md sección 9,
/// Fase 8): paleta base validada, generación por ángulo dorado para lo que
/// excede la base. A diferencia de la Unidad 3 (validada externamente con
/// un skill de dataviz), acá cada tono generado se acepta solo si su ΔE
/// (CIE76, `color_contraste.dart`) contra **todos** los colores ya usados
/// —base y generados antes— supera [umbralContrasteMinimo], porque
/// CLAUDE.md pide esa verificación como test de la fase (Test U), no solo
/// como criterio de diseño. Ver `test/ui/paleta_territorios_test.dart`.
const List<Color> paletaTerritoriosValidada = [
  Color(0xFF1BAF7A), // aqua
  Color(0xFFEDA100), // amarillo
  Color(0xFF008300), // verde
  Color(0xFF4A3AA7), // violeta
  Color(0xFFE34948), // rojo
];

/// Color para una zona sin ningún almacén asignado (capacidad excedida en
/// todos, modo con restricción) — gris neutro, deliberadamente fuera de la
/// paleta categórica para no impersonar un territorio real.
const Color colorSinAsignarTerritorio = Color(0xFF898781);

/// Umbral de contraste (ΔE CIE76) que Test U verifica entre cualquier par
/// de hasta doce territorios — mismo orden de magnitud que el ΔE>12
/// mencionado en `paleta_rutas.dart` de la Unidad 3.
const double umbralContrasteMinimo = 12;

const double _anguloDoradoGrados = 137.508;
const double _huesReservadoInicio = 200;
const double _huesReservadoFin = 250;

/// Color del territorio `indice` (0-based) — hasta
/// [paletaTerritoriosValidada.length] almacenes usa siempre esa paleta ya
/// validada; de ahí en más genera tonos adicionales, cada uno verificado
/// contra todos los anteriores.
Color colorParaTerritorio(int indice) {
  final totalValidados = paletaTerritoriosValidada.length;
  if (indice < totalValidados) return paletaTerritoriosValidada[indice];
  return _secuenciaGenerada(indice).last;
}

/// Recalcula, de forma determinista y pura, la secuencia completa de
/// colores generados desde el primer índice no cubierto por la paleta base
/// hasta `indice` — cada uno se acepta apenas su ΔE contra la base y todo
/// lo generado antes supera el umbral, así nunca hay dos territorios
/// parecidos aunque el ángulo dorado los hubiera hecho colisionar.
List<Color> _secuenciaGenerada(int indice) {
  final ocupados = List<Color>.of(paletaTerritoriosValidada);
  final generados = <Color>[];
  for (var i = paletaTerritoriosValidada.length; i <= indice; i++) {
    final color = _proximoColorLibre(i, ocupados);
    generados.add(color);
    ocupados.add(color);
  }
  return generados;
}

Color _proximoColorLibre(int indice, List<Color> ocupados) {
  final propuesto = (indice * _anguloDoradoGrados) % 360;

  for (var pasos = 0; pasos < 72; pasos++) {
    final hue = (propuesto + pasos * 5) % 360;
    if (hue >= _huesReservadoInicio && hue <= _huesReservadoFin) continue;

    final color = _colorDeHue(hue);
    if (ocupados.every((o) => deltaE(color, o) > umbralContrasteMinimo)) {
      return color;
    }
  }
  // No debería llegar acá con la cantidad de territorios que maneja este
  // proyecto (hasta unas pocas decenas) — de pasar, se devuelve el mejor
  // candidato encontrado (el de mayor contraste mínimo) en vez de fallar.
  return _mejorCandidatoDisponible(propuesto, ocupados);
}

Color _mejorCandidatoDisponible(double propuesto, List<Color> ocupados) {
  Color? mejor;
  var mejorContrasteMinimo = -1.0;
  for (var pasos = 0; pasos < 72; pasos++) {
    final hue = (propuesto + pasos * 5) % 360;
    if (hue >= _huesReservadoInicio && hue <= _huesReservadoFin) continue;
    final color = _colorDeHue(hue);
    final contrasteMinimo = ocupados.map((o) => deltaE(color, o)).reduce((a, b) => a < b ? a : b);
    if (contrasteMinimo > mejorContrasteMinimo) {
      mejorContrasteMinimo = contrasteMinimo;
      mejor = color;
    }
  }
  return mejor!;
}

Color _colorDeHue(double hue) {
  double ajustarLuminosidad(double base, double hueGrados) {
    final distanciaAAmarilloVerde = (hueGrados - 110).abs().clamp(0, 180);
    final ajuste = (distanciaAAmarilloVerde - 90) / 90 * 0.08;
    return (base + ajuste).clamp(0.25, 0.75);
  }

  return HSLColor.fromAHSL(1.0, hue, 0.62, ajustarLuminosidad(0.40, hue)).toColor();
}
