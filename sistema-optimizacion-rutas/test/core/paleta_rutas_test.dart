import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_optimizacion_rutas/core/paleta_rutas.dart';

void main() {
  group('colorParaRuta — caso normal (hasta 5 rutas)', () {
    test('sin semilla, cada índice 0..4 da un color distinto', () {
      final colores = List.generate(5, (i) => colorParaRuta(i).claro);
      expect(colores.toSet(), hasLength(5));
    });

    test('con semilla, sigue siendo una permutación (todos distintos)', () {
      final colores = List.generate(5, (i) => colorParaRuta(i, semilla: 2).claro);
      expect(colores.toSet(), hasLength(5));
    });

    test('la semilla rota la asignación (no es la identidad)', () {
      final sinSemilla = List.generate(5, (i) => colorParaRuta(i).claro);
      final conSemilla = List.generate(
        5,
        (i) => colorParaRuta(i, semilla: 1).claro,
      );
      expect(conSemilla, isNot(equals(sinSemilla)));
      // Pero sigue siendo el mismo conjunto de colores, solo reordenado.
      expect(conSemilla.toSet(), sinSemilla.toSet());
    });

    test('es determinístico: mismo índice y semilla, mismo color', () {
      expect(colorParaRuta(2, semilla: 3).claro, colorParaRuta(2, semilla: 3).claro);
    });
  });

  group('colorParaRuta — más rutas que colores validados', () {
    test('índices 5+ generan colores distintos entre sí y de los validados', () {
      final generados = List.generate(6, (i) => colorParaRuta(5 + i).claro);
      final validados = List.generate(5, (i) => colorParaRuta(i).claro);

      expect(generados.toSet(), hasLength(6));
      for (final color in generados) {
        expect(validados, isNot(contains(color)));
      }
    });
  });

  test('colorSinAsignar es un gris neutro fijo', () {
    expect(colorSinAsignar.claro, const Color(0xFF898781));
    expect(colorSinAsignar.oscuro, const Color(0xFF898781));
  });
}
