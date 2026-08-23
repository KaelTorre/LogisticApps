import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_diseno_almacenes/domain/motor/m1_pronostico.dart';

void main() {
  group('M1 — suavización exponencial simple (verificado a mano)', () {
    test('S_1=y_1, S_t=α·y_t+(1-α)·S_(t-1), α=0.5', () {
      final resultado = calcularPronostico(historico: [10, 12, 14], horizonte: 2, alpha: 0.5);
      final ses = resultado.modelosEvaluados.firstWhere((m) => m.nombre == 'Suavización exponencial simple');
      // s0=10, s1=0.5*12+0.5*10=11, s2=0.5*14+0.5*11=12.5
      // fcast[1]=s0=10 (error 2), fcast[2]=s1=11 (error 3)
      expect(ses.mad, closeTo(2.5, 1e-9));
      expect(ses.mse, closeTo(6.5, 1e-9));
      expect(ses.mape, closeTo(19.047619, 1e-4));
      expect(ses.pronostico, [closeTo(12.5, 1e-9), closeTo(12.5, 1e-9)]);
    });
  });

  group('M1 — Holt (verificado a mano, serie perfectamente lineal)', () {
    test('tendencia +2/período, α=0.5 β=0.5: ajuste perfecto, error cero', () {
      final resultado = calcularPronostico(
        historico: [10, 12, 14, 16],
        horizonte: 2,
        alpha: 0.5,
        beta: 0.5,
      );
      final holt = resultado.modelosEvaluados.firstWhere((m) => m.nombre == 'Holt (con tendencia)');
      expect(holt.mad, closeTo(0, 1e-9));
      expect(holt.mse, closeTo(0, 1e-9));
      expect(holt.mape, closeTo(0, 1e-9));
      // l3=16, t3=2 -> pronostico h=1:18, h=2:20
      expect(holt.pronostico, [closeTo(18, 1e-9), closeTo(20, 1e-9)]);
    });

    test('elige Holt sobre suavización simple cuando hay tendencia fuerte y limpia', () {
      final resultado = calcularPronostico(
        historico: [10, 12, 14, 16, 18, 20],
        horizonte: 3,
        alpha: 0.5,
        beta: 0.5,
      );
      expect(resultado.modeloElegido.nombre, 'Holt (con tendencia)');
      expect(resultado.pronostico.length, 3);
    });
  });

  group('M1 — selección de modelo y memoria', () {
    test('sin longitudEstacional solo evalúa 2 modelos (simple y holt)', () {
      final resultado = calcularPronostico(historico: [5, 6, 7, 8, 9], horizonte: 1);
      expect(resultado.modelosEvaluados.map((m) => m.nombre), ['Suavización exponencial simple', 'Holt (con tendencia)']);
    });

    test('con longitudEstacional pero historia insuficiente, tampoco incluye estacionales', () {
      final resultado = calcularPronostico(
        historico: [5, 6, 7, 8, 9],
        horizonte: 1,
        longitudEstacional: 4, // necesita 2*4=8 períodos, solo hay 5
      );
      expect(resultado.modelosEvaluados.map((m) => m.nombre), ['Suavización exponencial simple', 'Holt (con tendencia)']);
    });

    test('con historia estacional suficiente, evalúa los 4 modelos', () {
      const m = 4;
      final historico = [
        for (var ciclo = 0; ciclo < 3; ciclo++)
          for (final base in [100.0, 140.0, 90.0, 120.0]) base + ciclo * 10,
      ];
      final resultado = calcularPronostico(
        historico: historico,
        horizonte: 4,
        longitudEstacional: m,
      );
      expect(resultado.modelosEvaluados.map((mo) => mo.nombre), [
        'Suavización exponencial simple',
        'Holt (con tendencia)',
        'Winters (tendencia y estacionalidad)',
        'Descomposición clásica',
      ]);
      for (final modelo in resultado.modelosEvaluados) {
        expect(modelo.mad, greaterThanOrEqualTo(0));
        expect(modelo.mse, greaterThanOrEqualTo(0));
        expect(modelo.mape, greaterThanOrEqualTo(0));
        expect(modelo.pronostico.length, 4);
        for (final v in modelo.pronostico) {
          expect(v.isFinite, isTrue);
        }
      }
      expect(resultado.modeloElegido.mape, resultado.modelosEvaluados.map((m) => m.mape).reduce((a, b) => a < b ? a : b));
    });

    test('declara el modelo elegido y el pronóstico en la memoria de cálculo', () {
      final resultado = calcularPronostico(historico: [10, 12, 14, 16], horizonte: 2);
      expect(resultado.memoria, isNotEmpty);
      expect(resultado.memoria.first.modulo, 'M1');
      expect(resultado.memoria.first.valor, resultado.modeloElegido.nombre);
    });
  });

  group('M1 — validación de entradas', () {
    test('rechaza historia con menos de 2 períodos', () {
      expect(() => calcularPronostico(historico: [10], horizonte: 1), throwsArgumentError);
    });

    test('rechaza horizonte <= 0', () {
      expect(
        () => calcularPronostico(historico: [10, 12], horizonte: 0),
        throwsArgumentError,
      );
    });
  });
}
