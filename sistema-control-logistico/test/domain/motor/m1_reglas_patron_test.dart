import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_control_logistico/domain/motor/m1_reglas_patron.dart';

/// Fase 3 (CLAUDE.md): "estas son las [pruebas] que definen el producto."
void main() {
  // Serie de referencia del Test dorado A. Meta 1.20, banda ±8 %
  // (1.104 a 1.296).
  const meta = 1.20;
  const bandaInferior = 1.104;
  const bandaSuperior = 1.296;
  const serieReferencia = [1.18, 1.33, 1.21, 1.24, 1.26, 1.28, 1.29, 1.29, 1.28, 1.29, 1.31, 1.34];

  const indicadorMenorMejor = ConfigIndicadorMotor(
    meta: meta,
    bandaInferior: bandaInferior,
    bandaSuperior: bandaSuperior,
    sentido: 'menor_mejor',
  );

  /// La serie de referencia truncada hasta el periodo [t] (1-indexado),
  /// exactamente la forma en que M6 (Fase 6) también verá "solo el
  /// pasado": `serie[1..t]`.
  List<PuntoSerieMotor> serieHasta(int t, {List<double> serie = serieReferencia}) {
    return [for (var i = 0; i < t; i++) PuntoSerieMotor(orden: i + 1, valor: serie[i])];
  }

  group('Test dorado A — la serie de referencia', () {
    test('en el periodo 2, R1 dispara y ninguna otra regla lo hace', () {
      final resultados = evaluarReglasDeSistema(
        serie: serieHasta(2),
        indicador: indicadorMenorMejor,
      );

      final r1 = resultados.firstWhere((r) => r.codigo == 'R1');
      expect(r1.disparada, isTrue);
      for (final r in resultados.where((r) => r.codigo != 'R1')) {
        expect(r.disparada, isFalse, reason: '${r.codigo} no debería disparar en el periodo 2');
      }
    });

    test('en los periodos 3 a 6, ninguna regla dispara', () {
      for (var t = 3; t <= 6; t++) {
        final resultados = evaluarReglasDeSistema(
          serie: serieHasta(t),
          indicador: indicadorMenorMejor,
        );
        for (final r in resultados) {
          expect(r.disparada, isFalse, reason: '${r.codigo} no debería disparar en el periodo $t');
        }
      }
    });

    test('en el periodo 7, R4 dispara y R1 no dispara', () {
      final resultados = evaluarReglasDeSistema(
        serie: serieHasta(7),
        indicador: indicadorMenorMejor,
      );

      final r4 = resultados.firstWhere((r) => r.codigo == 'R4');
      expect(r4.disparada, isTrue);

      final r1 = resultados.firstWhere((r) => r.codigo == 'R1');
      expect(r1.disparada, isFalse, reason: '1.29 está dentro de la banda [1.104, 1.296]');
    });

    test('en el periodo 11, R1 vuelve a disparar', () {
      final resultados = evaluarReglasDeSistema(
        serie: serieHasta(11),
        indicador: indicadorMenorMejor,
      );

      final r1 = resultados.firstWhere((r) => r.codigo == 'R1');
      expect(r1.disparada, isTrue);
    });
  });

  test('Test B — sentido invertido produce exactamente los mismos disparos', () {
    // Serie reflejada alrededor de la meta: v' = 2*meta - v. Como la banda
    // ya es simétrica respecto a la meta, sus límites no cambian.
    final serieReflejada = serieReferencia.map((v) => 2 * meta - v).toList();
    const indicadorMayorMejor = ConfigIndicadorMotor(
      meta: meta,
      bandaInferior: bandaInferior,
      bandaSuperior: bandaSuperior,
      sentido: 'mayor_mejor',
    );

    for (var t = 1; t <= serieReferencia.length; t++) {
      final original = evaluarReglasDeSistema(
        serie: serieHasta(t),
        indicador: indicadorMenorMejor,
      );
      final reflejado = evaluarReglasDeSistema(
        serie: serieHasta(t, serie: serieReflejada),
        indicador: indicadorMayorMejor,
      );

      for (var i = 0; i < original.length; i++) {
        expect(
          reflejado[i].resultado,
          original[i].resultado,
          reason:
              '${original[i].codigo} en el periodo $t: menor_mejor dio '
              '${original[i].resultado}, mayor_mejor (reflejado) dio ${reflejado[i].resultado}',
        );
      }
    }
  });

  test('Test C — no evaluable: con solo tres periodos, R4 da "faltan 2", nunca normal', () {
    final resultado = evaluarR4(serieHasta(3), indicadorMenorMejor);

    expect(resultado.resultado, resultadoNoEvaluable);
    expect(resultado.periodosFaltantes, 2);
  });

  test('Test D — estacionalidad no dispara R4 (no confunde ciclo con deterioro)', () {
    // Fórmula "estacional" que M5 implementará en la Fase 6 (CLAUDE.md
    // sección 8): valor = meta + amplitud * sin(2*pi*t / ciclo). Ciclo
    // corto (4) a propósito: la corrida monótona más larga que puede dar
    // una sinusoide muestreada con ciclo 4 es de 2-3 puntos, muy por
    // debajo de los 5 que exige R4 -- si R4 disparara igual, estaría
    // confundiendo el ciclo con una tendencia real.
    const metaEstacional = 100.0;
    const bandaEstacionalInferior = 92.0; // ±8 %
    const bandaEstacionalSuperior = 108.0;
    const amplitud = 5.0; // dentro de la banda, nunca la toca
    const ciclo = 4;
    const numeroPeriodos = 24;

    final serieEstacional = [
      for (var t = 1; t <= numeroPeriodos; t++)
        metaEstacional + amplitud * sin(2 * pi * t / ciclo),
    ];

    const indicadorEstacional = ConfigIndicadorMotor(
      meta: metaEstacional,
      bandaInferior: bandaEstacionalInferior,
      bandaSuperior: bandaEstacionalSuperior,
      sentido: 'menor_mejor',
    );

    for (var t = 1; t <= numeroPeriodos; t++) {
      final serie = [
        for (var i = 0; i < t; i++) PuntoSerieMotor(orden: i + 1, valor: serieEstacional[i]),
      ];
      final r4 = evaluarR4(serie, indicadorEstacional);
      expect(
        r4.disparada,
        isFalse,
        reason: 'R4 disparó en el periodo $t de una serie puramente estacional',
      );
    }
  });

  group('Test E — memoria: cada regla disparada trae sus valores de entrada', () {
    test('R1 disparada en el periodo 2 trae el valor y la banda', () {
      final r1 = evaluarR1(serieHasta(2), indicadorMenorMejor);

      expect(r1.disparada, isTrue);
      expect(r1.valoresEntrada, isNotEmpty);
      expect(r1.valoresEntrada['valor'], 1.33);
      expect(r1.valoresEntrada['bandaInferior'], bandaInferior);
      expect(r1.valoresEntrada['bandaSuperior'], bandaSuperior);
      expect(r1.explicacion, isNotEmpty);
    });

    test('R4 disparada en el periodo 7 trae la ventana de valores', () {
      final r4 = evaluarR4(serieHasta(7), indicadorMenorMejor);

      expect(r4.disparada, isTrue);
      expect(r4.valoresEntrada, isNotEmpty);
      expect(r4.valoresEntrada['valores'], [1.21, 1.24, 1.26, 1.28, 1.29]);
      expect(r4.explicacion, isNotEmpty);
    });

    test('una regla no evaluable también deja constancia (periodos mínimos, faltantes)', () {
      final r4 = evaluarR4(serieHasta(3), indicadorMenorMejor);

      expect(r4.disparada, isFalse);
      expect(r4.valoresEntrada, isNotEmpty);
      expect(r4.valoresEntrada['periodosDisponibles'], 3);
      expect(r4.valoresEntrada['periodosMinimos'], 5);
    });
  });
}
