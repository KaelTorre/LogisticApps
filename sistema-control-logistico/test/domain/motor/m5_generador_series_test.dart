import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_control_logistico/domain/motor/m5_generador_series.dart';

/// Fase 6 (CLAUDE.md): Test K (determinismo) y Test L (el patrón está
/// presente). El coeficiente de correlación de Pearson es solo una
/// herramienta de este archivo de test, no parte de M5.
double _correlacionPearson(List<double> x, List<double> y) {
  final n = x.length;
  final mediaX = x.reduce((a, b) => a + b) / n;
  final mediaY = y.reduce((a, b) => a + b) / n;
  var covarianza = 0.0;
  var varianzaX = 0.0;
  var varianzaY = 0.0;
  for (var i = 0; i < n; i++) {
    final dx = x[i] - mediaX;
    final dy = y[i] - mediaY;
    covarianza += dx * dy;
    varianzaX += dx * dx;
    varianzaY += dy * dy;
  }
  if (varianzaX == 0 || varianzaY == 0) return 0;
  return covarianza / sqrt(varianzaX * varianzaY);
}

void main() {
  group('Test K — determinismo del generador', () {
    test('misma semilla y parámetros producen serie idéntica en dos ejecuciones', () {
      const params = ParametrosSerieSintetica(sigma: 2.5, pendiente: 0.5, tInicio: 3);

      final primera = generarSerieSintetica(
        patron: 'tendencia',
        params: params,
        semilla: 42,
        numeroPeriodos: 24,
        meta: 100,
      );
      final segunda = generarSerieSintetica(
        patron: 'tendencia',
        params: params,
        semilla: 42,
        numeroPeriodos: 24,
        meta: 100,
      );

      expect(segunda, primera);
    });

    test('semillas distintas producen series distintas (con ruido)', () {
      const params = ParametrosSerieSintetica(sigma: 5);

      final serieA = generarSerieSintetica(
        patron: 'estable',
        params: params,
        semilla: 1,
        numeroPeriodos: 12,
        meta: 100,
      );
      final serieB = generarSerieSintetica(
        patron: 'estable',
        params: params,
        semilla: 2,
        numeroPeriodos: 12,
        meta: 100,
      );

      expect(serieA, isNot(serieB));
    });
  });

  group('Test L — el patrón está presente', () {
    test('tendencia con pendiente positiva: correlación positiva significativa entre orden y valor', () {
      final serie = generarSerieSintetica(
        patron: 'tendencia',
        params: const ParametrosSerieSintetica(sigma: 0.5, pendiente: 2.0, tInicio: 0),
        semilla: 7,
        numeroPeriodos: 30,
        meta: 100,
      );

      final ordenes = [for (var t = 1; t <= serie.length; t++) t.toDouble()];
      final r = _correlacionPearson(ordenes, serie);

      expect(r, greaterThan(0.9), reason: 'r=$r debería ser fuertemente positivo');
    });

    test('serie estable: sin correlación significativa entre orden y valor', () {
      final serie = generarSerieSintetica(
        patron: 'estable',
        params: const ParametrosSerieSintetica(sigma: 3.0),
        semilla: 7,
        numeroPeriodos: 30,
        meta: 100,
      );

      final ordenes = [for (var t = 1; t <= serie.length; t++) t.toDouble()];
      final r = _correlacionPearson(ordenes, serie);

      expect(r.abs(), lessThan(0.4), reason: 'r=$r no debería mostrar una tendencia real');
    });
  });

  group('Los seis patrones obligatorios', () {
    test('cada patrón listado en patronesDisponibles genera sin lanzar excepción', () {
      for (final patron in patronesDisponibles) {
        final serie = generarSerieSintetica(
          patron: patron,
          params: const ParametrosSerieSintetica(
            sigma: 0,
            tEvento: 5,
            magnitud: 10,
            pendiente: 1,
            tInicio: 0,
            salto: 5,
            amplitud: 3,
            ciclo: 4,
          ),
          semilla: 1,
          numeroPeriodos: 10,
          meta: 50,
        );
        expect(serie, hasLength(10), reason: 'patrón "$patron"');
      }
    });

    test('punto_aislado solo desplaza el periodo del evento', () {
      final serie = generarSerieSintetica(
        patron: 'punto_aislado',
        params: const ParametrosSerieSintetica(sigma: 0, tEvento: 4, magnitud: 20),
        semilla: 1,
        numeroPeriodos: 6,
        meta: 100,
      );

      expect(serie[0], 100);
      expect(serie[2], 100);
      expect(serie[3], 120); // periodo 4, índice 3
      expect(serie[4], 100);
    });

    test('corrimiento mantiene el salto desde t_evento en adelante', () {
      final serie = generarSerieSintetica(
        patron: 'corrimiento',
        params: const ParametrosSerieSintetica(sigma: 0, tEvento: 4, salto: 15),
        semilla: 1,
        numeroPeriodos: 6,
        meta: 100,
      );

      expect(serie[2], 100); // periodo 3, antes del evento
      expect(serie[3], 115); // periodo 4, en el evento
      expect(serie[5], 115); // periodo 6, se mantiene
    });

    test('deterioro_brusco crece linealmente después de t_evento', () {
      final serie = generarSerieSintetica(
        patron: 'deterioro_brusco',
        params: const ParametrosSerieSintetica(sigma: 0, tEvento: 3, salto: 10),
        semilla: 1,
        numeroPeriodos: 6,
        meta: 100,
      );

      expect(serie[1], 100); // periodo 2, antes
      expect(serie[2], 100); // periodo 3, t == t_evento -> (3-3)*10 = 0
      expect(serie[3], 110); // periodo 4 -> (4-3)*10
      expect(serie[5], 130); // periodo 6 -> (6-3)*10
    });
  });
}
