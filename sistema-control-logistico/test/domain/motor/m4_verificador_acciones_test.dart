import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_control_logistico/domain/motor/m1_reglas_patron.dart';
import 'package:sistema_control_logistico/domain/motor/m4_verificador_acciones.dart';

/// Fase 4 (CLAUDE.md): "Test J — verificación: una acción abierta en el
/// periodo 7, con el valor del periodo 8 dentro de banda y por debajo de
/// la meta, produce propuesta de verificación corrigio, pero la acción
/// sigue abierta hasta que el usuario confirma."
void main() {
  const indicador = ConfigIndicadorMotor(
    meta: 1.20,
    bandaInferior: 1.104,
    bandaSuperior: 1.296,
    sentido: 'menor_mejor',
  );

  test('Test J — valor del periodo 8 dentro de banda y bajo la meta propone "corrigio"', () {
    final resultado = proponerResultadoVerificacion(
      valorPeriodoDesviacion: 1.29, // periodo 7, el que disparó R4
      valorObservado: 1.15, // periodo 8: dentro de banda y por debajo de la meta
      indicador: indicador,
    );

    expect(resultado, 'corrigio');
    // La propuesta es solo eso -- una propuesta. Cerrar la acción exige
    // una confirmación explícita del usuario (VerificacionAccionRepository
    // .confirmar), nunca ocurre como efecto secundario de proponer.
  });

  test('mejora pero sigue fuera de banda propone "parcial"', () {
    final resultado = proponerResultadoVerificacion(
      valorPeriodoDesviacion: 1.40,
      valorObservado: 1.32, // se acercó a la meta pero 1.32 > 1.296, sigue fuera
      indicador: indicador,
    );

    expect(resultado, 'parcial');
  });

  test('no mejora (o empeora) propone "no_corrigio"', () {
    final resultado = proponerResultadoVerificacion(
      valorPeriodoDesviacion: 1.29,
      valorObservado: 1.35, // peor que antes, sigue fuera de banda
      indicador: indicador,
    );

    expect(resultado, 'no_corrigio');
  });

  test('quedarse exactamente igual, fuera de banda, propone "no_corrigio"', () {
    final resultado = proponerResultadoVerificacion(
      valorPeriodoDesviacion: 1.33,
      valorObservado: 1.33,
      indicador: indicador,
    );

    expect(resultado, 'no_corrigio');
  });
}
