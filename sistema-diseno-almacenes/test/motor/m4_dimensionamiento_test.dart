import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_diseno_almacenes/domain/motor/m4_dimensionamiento_sin_tendencia.dart';
import 'package:sistema_diseno_almacenes/domain/motor/tarifa_publica.dart';

void main() {
  group('TarifaPublica — las 3 formas de cotización', () {
    test('TarifaPorManejo cobra entrada + salida por unidad desbordada', () {
      const tarifa = TarifaPorManejo(cargoEntradaPorUnidad: 2, cargoSalidaPorUnidad: 3);
      expect(tarifa.costoMensual(10), 50); // 10 * (2+3)
    });

    test('TarifaPorEspacio cobra por posición-mes', () {
      const tarifa = TarifaPorEspacio(tarifaPorPosicionMes: 15);
      expect(tarifa.costoMensual(10), 150);
    });

    test('TarifaPorArrendamiento cobra el fijo completo si hay cualquier desborde', () {
      const tarifa = TarifaPorArrendamiento(costoFijoMensual: 5000);
      expect(tarifa.costoMensual(1), 5000);
      expect(tarifa.costoMensual(500), 5000);
      expect(tarifa.costoMensual(0), 0);
    });
  });

  group('calcularDimensionamientoSinTendencia', () {
    test('demanda plana: la capacidad óptima es exactamente la demanda (sin desborde, sin ocio)', () {
      final r = calcularDimensionamientoSinTendencia(
        requerimientosMensuales: List.filled(12, 100),
        costoAnualPropioPorPosicion: 50,
        tarifaPublica: const TarifaPorEspacio(tarifaPorPosicionMes: 10),
      );
      expect(r.capacidadOptima, 100);
    });

    test('demanda estacional: la óptima queda entre el mínimo y el máximo mensual', () {
      final r = calcularDimensionamientoSinTendencia(
        requerimientosMensuales: [100, 100, 100, 150, 200, 250, 250, 200, 150, 100, 100, 100],
        costoAnualPropioPorPosicion: 50,
        tarifaPublica: const TarifaPorEspacio(tarifaPorPosicionMes: 10),
      );
      expect(r.capacidadOptima, greaterThanOrEqualTo(100));
      expect(r.capacidadOptima, lessThanOrEqualTo(250));
    });

    test('tarifa pública muy barata empuja la capacidad óptima hacia abajo', () {
      final requerimientos = [100, 100, 100, 150, 200, 250, 250, 200, 150, 100, 100, 100];
      final rTarifaCara = calcularDimensionamientoSinTendencia(
        requerimientosMensuales: requerimientos,
        costoAnualPropioPorPosicion: 50,
        tarifaPublica: const TarifaPorEspacio(tarifaPorPosicionMes: 1000),
      );
      final rTarifaBarata = calcularDimensionamientoSinTendencia(
        requerimientosMensuales: requerimientos,
        costoAnualPropioPorPosicion: 50,
        tarifaPublica: const TarifaPorEspacio(tarifaPorPosicionMes: 0.01),
      );
      expect(rTarifaBarata.capacidadOptima, lessThanOrEqualTo(rTarifaCara.capacidadOptima));
    });

    test('costo propio muy caro empuja la capacidad óptima hacia abajo', () {
      final requerimientos = [100, 100, 100, 150, 200, 250, 250, 200, 150, 100, 100, 100];
      final rPropioCaro = calcularDimensionamientoSinTendencia(
        requerimientosMensuales: requerimientos,
        costoAnualPropioPorPosicion: 10000,
        tarifaPublica: const TarifaPorEspacio(tarifaPorPosicionMes: 10),
      );
      final rPropioBarato = calcularDimensionamientoSinTendencia(
        requerimientosMensuales: requerimientos,
        costoAnualPropioPorPosicion: 0.01,
        tarifaPublica: const TarifaPorEspacio(tarifaPorPosicionMes: 10),
      );
      expect(rPropioCaro.capacidadOptima, lessThanOrEqualTo(rPropioBarato.capacidadOptima));
    });

    test('la curva trae un punto por cada valor distinto de requerimiento mensual', () {
      final r = calcularDimensionamientoSinTendencia(
        requerimientosMensuales: [100, 100, 150, 200],
        costoAnualPropioPorPosicion: 50,
        tarifaPublica: const TarifaPorEspacio(tarifaPorPosicionMes: 10),
      );
      expect(r.curva.map((p) => p.capacidad).toSet(), {100, 150, 200});
    });

    test('rechaza lista de requerimientos vacía', () {
      expect(
        () => calcularDimensionamientoSinTendencia(
          requerimientosMensuales: [],
          costoAnualPropioPorPosicion: 50,
          tarifaPublica: const TarifaPorEspacio(tarifaPorPosicionMes: 10),
        ),
        throwsArgumentError,
      );
    });

    test('rechaza requerimiento negativo', () {
      expect(
        () => calcularDimensionamientoSinTendencia(
          requerimientosMensuales: [100, -5],
          costoAnualPropioPorPosicion: 50,
          tarifaPublica: const TarifaPorEspacio(tarifaPorPosicionMes: 10),
        ),
        throwsArgumentError,
      );
    });
  });
}
