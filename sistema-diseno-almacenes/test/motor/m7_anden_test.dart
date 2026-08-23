import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_diseno_almacenes/domain/motor/m7_anden.dart';

EntradaM7 _entradaBase({
  double camionesHoraPico = 3,
  double tiempoMedioServicioHoras = 0.5,
  double esperaObjetivoHoras = 0.25,
  int espaciamientoPuertaMm = 3600,
}) {
  return EntradaM7(
    camionesHoraPico: camionesHoraPico,
    tiempoMedioServicioHoras: tiempoMedioServicioHoras,
    esperaObjetivoHoras: esperaObjetivoHoras,
    espaciamientoPuertaMm: espaciamientoPuertaMm,
    patioMinMm: 25000,
    areaStagingPorPuertaMm2: 20000000, // 20 m²
  );
}

void main() {
  group('validación de Erlang C contra la fórmula clásica M/M/1', () {
    test('con 1 puerta, Wq coincide con Wq(M/M/1) = λ / (μ(μ−λ))', () {
      // λ=2 camiones/h, tiempo medio de servicio 0.2h -> μ=5, ρ=0.4 (< 0.85)
      const lambda = 2.0;
      const tiempoMedioServicio = 0.2;
      const mu = 1 / tiempoMedioServicio;

      final r = calcularAnden(
        EntradaM7(
          camionesHoraPico: lambda,
          tiempoMedioServicioHoras: tiempoMedioServicio,
          esperaObjetivoHoras: 10, // objetivo laxo: fuerza a que gane con 1 puerta
          espaciamientoPuertaMm: 3600,
          patioMinMm: 25000,
          areaStagingPorPuertaMm2: 20000000,
        ),
      );

      expect(r.puertas, 1);
      final wqEsperado = lambda / (mu * (mu - lambda));
      expect(r.esperaHoras, closeTo(wqEsperado, 1e-9));
    });
  });

  group('calcularAnden', () {
    test('elige el menor número de puertas que cumple ρ y Wq', () {
      final r = calcularAnden(_entradaBase());
      expect(r.puertas, greaterThanOrEqualTo(1));
      expect(r.rho, lessThan(0.85));
      expect(r.esperaHoras, lessThanOrEqualTo(0.25));
    });

    test('frente de andén = puertas × espaciamiento', () {
      final r = calcularAnden(_entradaBase(espaciamientoPuertaMm: 3600));
      expect(r.frenteAndenMm, r.puertas * 3600);
    });

    test('más camiones en hora pico nunca reduce el número de puertas necesarias', () {
      final rBajo = calcularAnden(_entradaBase(camionesHoraPico: 2));
      final rAlto = calcularAnden(_entradaBase(camionesHoraPico: 6));
      expect(rAlto.puertas, greaterThanOrEqualTo(rBajo.puertas));
    });

    test('rechaza espaciamiento de puerta por debajo de 3000mm, no lo ajusta', () {
      expect(
        () => calcularAnden(_entradaBase(espaciamientoPuertaMm: 2500)),
        throwsA(isA<EspaciamientoPuertaInvalidoException>()),
      );
    });

    test('rechaza camiones_hora_pico <= 0', () {
      expect(() => calcularAnden(_entradaBase(camionesHoraPico: 0)), throwsArgumentError);
    });

    test('demanda pico imposible de atender lanza explícito, no una respuesta silenciosa', () {
      expect(
        () => calcularAnden(
          _entradaBase(camionesHoraPico: 1000, esperaObjetivoHoras: 0.01),
        ),
        throwsA(isA<PuertasInsuficientesException>()),
      );
    });

    test('memoria de cálculo trae los 5 pasos del pseudocódigo', () {
      final r = calcularAnden(_entradaBase());
      expect(r.memoria.map((f) => f.modulo), everyElement('M7'));
      expect(r.memoria, hasLength(5));
    });
  });
}
