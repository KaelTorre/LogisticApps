import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_control_logistico/domain/motor/m1_reglas_patron.dart';
import 'package:sistema_control_logistico/domain/motor/m2_clasificador.dart';
import 'package:sistema_control_logistico/domain/motor/m6_contraste_retrospectivo.dart';

/// Fase 6 (CLAUDE.md): Test dorado M (contraste retrospectivo) y Test N
/// (sin mirar el futuro) -- ambos sobre la serie de referencia del Test A
/// (Fase 3).
void main() {
  const meta = 1.20;
  const bandaInferior = 1.104;
  const bandaSuperior = 1.296;
  const serieReferencia = [1.18, 1.33, 1.21, 1.24, 1.26, 1.28, 1.29, 1.29, 1.28, 1.29, 1.31, 1.34];

  const indicador = ConfigIndicadorMotor(
    meta: meta,
    bandaInferior: bandaInferior,
    bandaSuperior: bandaSuperior,
    sentido: 'menor_mejor',
  );

  List<PuntoSerieMotor> serieHasta(int t) {
    return [for (var i = 0; i < t; i++) PuntoSerieMotor(orden: i + 1, valor: serieReferencia[i])];
  }

  final serieCompleta = serieHasta(serieReferencia.length);

  test('Test dorado M — contraste retrospectivo sobre la serie de referencia', () {
    final resultado = contrastarMetodos(serie: serieCompleta, indicador: indicador);

    // Umbral simple: primera detección en el periodo 2, falsa alarma;
    // siguiente detección en el periodo 11.
    final deteccionesUmbral = resultado.umbralSimple.detecciones;
    expect(deteccionesUmbral, hasLength(2));
    expect(deteccionesUmbral[0].periodo, 2);
    expect(deteccionesUmbral[0].esFalsaAlarma, isTrue);
    expect(deteccionesUmbral[1].periodo, 11);
    expect(deteccionesUmbral[1].esFalsaAlarma, isFalse);

    // Reconocimiento de patrones: primera detección en el periodo 7, no
    // marcada como falsa alarma.
    final primeraPatrones = resultado.reconocimientoPatrones.primeraDeteccion;
    expect(primeraPatrones, isNotNull);
    expect(primeraPatrones!.periodo, 7);
    expect(primeraPatrones.esFalsaAlarma, isFalse);

    // Ventaja de detección: cuatro periodos (11 - 7).
    expect(resultado.ventajaDeteccionPeriodos, 4);
  });

  test('Test N — sin mirar el futuro: el veredicto en cada periodo t coincide con evaluar solo hasta t', () {
    final resultado = contrastarMetodos(serie: serieCompleta, indicador: indicador);

    var persistencia = 0;
    for (var t = 1; t <= serieReferencia.length; t++) {
      final serieAislada = serieHasta(t);
      final reglas = evaluarReglasDeSistema(serie: serieAislada, indicador: indicador);
      final clasificacionAislada = clasificar(
        resultadosReglas: reglas,
        puntoActual: serieAislada.last,
        indicador: indicador,
        contexto: ContextoClasificacion(persistenciaPeriodos: persistencia),
      );
      final alarmaAislada = clasificacionAislada.clasificacion != 'ninguna';

      expect(
        resultado.reconocimientoPatrones.alarmaPorPeriodo[t - 1],
        alarmaAislada,
        reason: 'periodo $t: el contraste no debe diferir de una evaluación aislada hasta t',
      );

      persistencia = clasificacionAislada.estado == 'desviacion' ? persistencia + 1 : 0;
    }
  });

  test('Test N (variante) — truncar la serie de entrada no cambia los veredictos ya emitidos', () {
    // Si M6 espiara el futuro, el resultado en los primeros 7 periodos
    // cambiaría según si se le entrega la serie completa (12 periodos) o
    // solo hasta el periodo 7.
    final conFuturo = contrastarMetodos(serie: serieCompleta, indicador: indicador);
    final sinFuturo = contrastarMetodos(serie: serieHasta(7), indicador: indicador);

    for (var i = 0; i < 7; i++) {
      expect(sinFuturo.reconocimientoPatrones.alarmaPorPeriodo[i], conFuturo.reconocimientoPatrones.alarmaPorPeriodo[i]);
      expect(sinFuturo.umbralSimple.alarmaPorPeriodo[i], conFuturo.umbralSimple.alarmaPorPeriodo[i]);
    }
  });
}
