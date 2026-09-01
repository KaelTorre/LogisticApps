import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_control_logistico/domain/motor/m1_reglas_patron.dart';
import 'package:sistema_control_logistico/domain/motor/m7_calibrador_banda.dart';

/// Fase 6 (CLAUDE.md): "Test O — calibrador: con un histórico y eventos
/// marcados, la banda propuesta reduce las falsas alarmas respecto a la
/// banda inicial sin perder ninguna detección marcada como real."
void main() {
  const meta = 100.0;

  // Histórico construido a propósito: ruido normal pequeño alrededor de
  // la meta (nunca marcado como problema real) más un evento grande y
  // sostenido en los periodos 15-17 (marcado como real). Con una banda
  // inicial angosta (±5 %), varios puntos de ruido ya quedan fuera de
  // banda -- falsas alarmas de sobra. El calibrador debe encontrar una
  // banda más ancha que deje de marcarlos sin dejar de detectar el
  // evento real.
  final serie = [
    for (var t = 1; t <= 24; t++)
      PuntoSerieMotor(
        orden: t,
        valor: (t >= 15 && t <= 17) ? 140.0 : (meta + (t.isEven ? 6.5 : -6.0)),
      ),
  ];
  final periodosReales = {15, 16, 17};

  const porcentajeInicial = 0.05; // banda inicial ±5 %, la que se calibra

  test('la banda inicial (±5 %) genera falsas alarmas de ruido', () {
    final bandaInferior = meta * (1 - porcentajeInicial);
    final bandaSuperior = meta * (1 + porcentajeInicial);
    final falsasConBandaInicial = serie
        .where((p) => !periodosReales.contains(p.orden))
        .where((p) => p.valor < bandaInferior || p.valor > bandaSuperior)
        .length;

    expect(falsasConBandaInicial, greaterThan(0), reason: 'el escenario de prueba debe partir con falsas alarmas');
  });

  test('Test O — la banda propuesta reduce las falsas alarmas sin perder ninguna detección real', () {
    final resultado = calibrarBanda(serie: serie, meta: meta, periodosReales: periodosReales);

    // No debe perder ninguna de las tres detecciones reales.
    expect(resultado.pierdeAlgunaDeteccionReal, isFalse);
    expect(resultado.detectadosReales, periodosReales.length);

    // Debe mejorar (o al menos igualar) las falsas alarmas de la banda
    // inicial, y en este escenario construido a propósito debe mejorar
    // estrictamente.
    final bandaInferiorInicial = meta * (1 - porcentajeInicial);
    final bandaSuperiorInicial = meta * (1 + porcentajeInicial);
    final falsasConBandaInicial = serie
        .where((p) => !periodosReales.contains(p.orden))
        .where((p) => p.valor < bandaInferiorInicial || p.valor > bandaSuperiorInicial)
        .length;

    expect(resultado.falsasAlarmas, lessThan(falsasConBandaInicial));
  });

  test('la banda propuesta sigue marcando los tres periodos reales como fuera de banda', () {
    final resultado = calibrarBanda(serie: serie, meta: meta, periodosReales: periodosReales);

    for (final periodo in periodosReales) {
      expect(resultado.periodosDetectados, contains(periodo));
    }
  });

  test('sin eventos reales marcados, propone la banda más angosta del barrido sin falsas alarmas', () {
    final serieEstable = [for (var t = 1; t <= 12; t++) PuntoSerieMotor(orden: t, valor: meta)];

    final resultado = calibrarBanda(serie: serieEstable, meta: meta, periodosReales: const {});

    expect(resultado.falsasAlarmas, 0);
    expect(resultado.pierdeAlgunaDeteccionReal, isFalse);
  });
}
