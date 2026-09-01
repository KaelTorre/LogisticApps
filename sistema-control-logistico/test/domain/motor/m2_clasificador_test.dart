import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_control_logistico/domain/motor/m1_reglas_patron.dart';
import 'package:sistema_control_logistico/domain/motor/m2_clasificador.dart';

/// Fase 4 (CLAUDE.md): "estas son las pruebas que definen el producto" --
/// Test F es, en palabras del propio documento, "el test más importante
/// del sistema".
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

  test('Test dorado F — R1 aislada no clasifica: ninguna + observacion', () {
    final serie = serieHasta(2);
    final reglas = evaluarReglasDeSistema(serie: serie, indicador: indicador);

    final resultado = clasificar(
      resultadosReglas: reglas,
      puntoActual: serie.last,
      indicador: indicador,
      contexto: const ContextoClasificacion(),
    );

    expect(resultado.clasificacion, 'ninguna');
    expect(resultado.estado, 'observacion');
  });

  test('Test G — clasificación determinista en el periodo 7 (R4 sola)', () {
    final serie = serieHasta(7);
    final reglas = evaluarReglasDeSistema(serie: serie, indicador: indicador);

    // R4 es la única disparada en el periodo 7 (confirmado en la Fase 3).
    final disparadas = reglas.where((r) => r.disparada).map((r) => r.codigo).toSet();
    expect(disparadas, {'R4'});

    final resultado = clasificar(
      resultadosReglas: reglas,
      puntoActual: serie.last,
      indicador: indicador,
      contexto: const ContextoClasificacion(procesosAfectados: 0, persistenciaPeriodos: 0),
    );

    // desviacion_relativa = |1.29 - 1.20| / (1.296 - 1.104) = 0.09 / 0.192
    const desviacionRelativaEsperada = 0.09 / 0.192;
    expect(resultado.desviacionRelativa, closeTo(desviacionRelativaEsperada, 1e-9));

    // R4 dispara, pero desviacion_relativa (0.469) no supera 1.0 y la
    // persistencia es 0 (< 4) -> no llega a replaneación mayor, se queda
    // en ajuste menor (fórmula de M2, CLAUDE.md sección 8).
    expect(resultado.clasificacion, 'ajuste_menor');
    expect(resultado.estado, 'desviacion');
    expect(resultado.severidadCalculada, closeTo(desviacionRelativaEsperada, 1e-9));
  });

  test('Test G (continuación) — con persistencia o desviación mayores, sube a replaneación mayor', () {
    final serie = serieHasta(7);
    final reglas = evaluarReglasDeSistema(serie: serie, indicador: indicador);

    final porPersistencia = clasificar(
      resultadosReglas: reglas,
      puntoActual: serie.last,
      indicador: indicador,
      contexto: const ContextoClasificacion(persistenciaPeriodos: 4),
    );
    expect(porPersistencia.clasificacion, 'replaneacion_mayor');

    final porDesviacion = clasificar(
      resultadosReglas: reglas,
      puntoActual: const PuntoSerieMotor(orden: 7, valor: 2.0), // desviación relativa muy alta
      indicador: indicador,
      contexto: const ContextoClasificacion(),
    );
    expect(porDesviacion.clasificacion, 'replaneacion_mayor');
  });

  test('Test H — contingencia: tres indicadores del mismo proceso en desviación simultánea', () {
    final serie = serieHasta(7);
    final reglas = evaluarReglasDeSistema(serie: serie, indicador: indicador);

    for (var i = 0; i < 3; i++) {
      final resultado = clasificar(
        resultadosReglas: reglas,
        puntoActual: serie.last,
        indicador: indicador,
        contexto: const ContextoClasificacion(procesosAfectados: 3),
      );
      expect(resultado.clasificacion, 'contingencia');
      expect(resultado.estado, 'desviacion');
    }
  });

  test('R6 junto con R2 o R3 también escala a contingencia, sin depender de otros procesos', () {
    const reglasSimuladas = [
      ResultadoRegla(codigo: 'R1', resultado: resultadoNoDisparada, valoresEntrada: {}, explicacion: ''),
      ResultadoRegla(codigo: 'R2', resultado: resultadoDisparada, valoresEntrada: {}, explicacion: ''),
      ResultadoRegla(codigo: 'R3', resultado: resultadoNoDisparada, valoresEntrada: {}, explicacion: ''),
      ResultadoRegla(codigo: 'R4', resultado: resultadoNoDisparada, valoresEntrada: {}, explicacion: ''),
      ResultadoRegla(codigo: 'R5', resultado: resultadoNoDisparada, valoresEntrada: {}, explicacion: ''),
      ResultadoRegla(codigo: 'R6', resultado: resultadoDisparada, valoresEntrada: {}, explicacion: ''),
    ];

    final resultado = clasificar(
      resultadosReglas: reglasSimuladas,
      puntoActual: const PuntoSerieMotor(orden: 20, valor: 1.30),
      indicador: indicador,
      contexto: const ContextoClasificacion(procesosAfectados: 0),
    );

    expect(resultado.clasificacion, 'contingencia');
  });

  test('sin ninguna regla disparada, la clasificación es ninguna y el estado normal', () {
    final resultado = clasificar(
      resultadosReglas: evaluarReglasDeSistema(serie: serieHasta(4), indicador: indicador),
      puntoActual: serieHasta(4).last,
      indicador: indicador,
      contexto: const ContextoClasificacion(),
    );

    expect(resultado.clasificacion, 'ninguna');
    expect(resultado.estado, 'normal');
    expect(resultado.severidadCalculada, 0.0);
  });
}
