import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_red_distribucion/ui/color_contraste.dart';
import 'package:sistema_red_distribucion/ui/paleta_territorios.dart';

void main() {
  test(
    'Test U — con hasta doce almacenes, dos territorios nunca reciben colores con '
    'ΔE por debajo del umbral definido',
    () {
      final colores = List.generate(12, colorParaTerritorio);

      for (var i = 0; i < colores.length; i++) {
        for (var j = i + 1; j < colores.length; j++) {
          final contraste = deltaE(colores[i], colores[j]);
          expect(
            contraste,
            greaterThan(umbralContrasteMinimo),
            reason: 'territorios $i y $j: ΔE=$contraste, por debajo del umbral',
          );
        }
      }
    },
  );

  test('es determinístico: el mismo índice siempre da el mismo color', () {
    expect(colorParaTerritorio(7), colorParaTerritorio(7));
    expect(colorParaTerritorio(1), colorParaTerritorio(1));
  });

  test('los primeros 5 territorios usan siempre la paleta base validada, sin generar nada', () {
    for (var i = 0; i < paletaTerritoriosValidada.length; i++) {
      expect(colorParaTerritorio(i), paletaTerritoriosValidada[i]);
    }
  });

  test('colorSinAsignarTerritorio es un gris neutro fijo, fuera de la paleta categórica', () {
    expect(colorSinAsignarTerritorio, const Color(0xFF898781));
    expect(paletaTerritoriosValidada, isNot(contains(colorSinAsignarTerritorio)));
  });
}
