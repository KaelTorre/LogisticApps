import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_control_logistico/data/seed/caso_estudio_generador.dart';
import 'package:sistema_control_logistico/data/seed/caso_estudio_indicadores.dart';
import 'package:sistema_control_logistico/domain/motor/evaluador_serie.dart';
import 'package:sistema_control_logistico/domain/motor/m1_reglas_patron.dart';

/// Fase 9 (CLAUDE.md): Test S (el caso arranca y clasifica) y Test T
/// (coherencia del caso) -- sobre las series generadas por
/// `generarSeriesCasoEstudio`, sin necesidad de base de datos.
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
  final series = generarSeriesCasoEstudio();

  test('genera las nueve series con exactamente 36 periodos cada una', () {
    expect(series.keys.length, 9);
    for (final serie in series.values) {
      expect(serie.length, numeroPeriodosCasoEstudio);
    }
  });

  test('determinismo: misma semilla produce las mismas series', () {
    final otraVez = generarSeriesCasoEstudio();
    for (final codigo in series.keys) {
      expect(otraVez[codigo], series[codigo]);
    }
  });

  test('Test S — el caso arranca y clasifica: al menos un indicador alcanza desviación clasificada', () {
    var alguno = false;
    for (final indicador in indicadoresCasoEstudio) {
      final config = ConfigIndicadorMotor(
        meta: indicador.meta,
        bandaInferior: indicador.bandaInferior,
        bandaSuperior: indicador.bandaSuperior,
        sentido: indicador.sentido,
      );
      final serie = [
        for (var i = 0; i < numeroPeriodosCasoEstudio; i++)
          PuntoSerieMotor(orden: i + 1, valor: series[indicador.codigo]![i]),
      ];
      final estado = evaluarHastaIndice(serie, config, numeroPeriodosCasoEstudio);
      if (estado.clasificacion.estado == 'desviacion' && estado.clasificacion.clasificacion != 'ninguna') {
        alguno = true;
        break;
      }
    }
    expect(alguno, isTrue, reason: 'ningún indicador del caso alcanzó una desviación clasificada en 36 periodos');
  });

  test('CE-T1 (costo de transporte) es el indicador que se deteriora de forma sostenida', () {
    final config = ConfigIndicadorMotor(
      meta: indicadoresCasoEstudio.firstWhere((i) => i.codigo == 'CE-T1').meta,
      bandaInferior: indicadoresCasoEstudio.firstWhere((i) => i.codigo == 'CE-T1').bandaInferior,
      bandaSuperior: indicadoresCasoEstudio.firstWhere((i) => i.codigo == 'CE-T1').bandaSuperior,
      sentido: 'menor_mejor',
    );
    final serie = [
      for (var i = 0; i < numeroPeriodosCasoEstudio; i++)
        PuntoSerieMotor(orden: i + 1, valor: series['CE-T1']![i]),
    ];
    final estado = evaluarHastaIndice(serie, config, numeroPeriodosCasoEstudio);
    expect(estado.clasificacion.estado, 'desviacion');
    expect(estado.clasificacion.clasificacion, isNot('ninguna'));
  });

  test('Test T — coherencia del caso: cada par declarado correlaciona con el signo esperado', () {
    for (final par in paresCorrelacionadosCasoEstudio) {
      final r = _correlacionPearson(series[par.codigoA]!, series[par.codigoB]!);
      if (par.signoEsperado > 0) {
        expect(r, greaterThan(0.3), reason: '${par.codigoA} vs ${par.codigoB} debía correlacionar positivo, dio $r');
      } else {
        expect(r, lessThan(-0.3), reason: '${par.codigoA} vs ${par.codigoB} debía correlacionar negativo, dio $r');
      }
    }
  });
}
