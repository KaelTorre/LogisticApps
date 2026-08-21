import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_diseno_almacenes/domain/motor/m2_posiciones.dart';

void main() {
  group('calcularPosicionesRequeridas', () {
    test('una familia sin estacionalidad ni honeycomb', () {
      final r = calcularPosicionesRequeridas(
        familias: const [
          DemandaFamilia(
            nombre: 'A',
            demandaAnual: 12000,
            rotacionAnual: 12,
            unidadesPorTarima: 40,
          ),
        ],
        factorHoneycomb: 0,
      );
      // inventario_promedio = 12000/12 = 1000; tarimas = ceil(1000/40) = 25
      expect(r.posicionesRequeridas, 25);
      expect(r.memoria, isNotEmpty);
      expect(r.memoria.last.concepto, contains('Posiciones requeridas'));
    });

    test('el honeycomb sube las posiciones requeridas', () {
      final r = calcularPosicionesRequeridas(
        familias: const [
          DemandaFamilia(
            nombre: 'A',
            demandaAnual: 12000,
            rotacionAnual: 12,
            unidadesPorTarima: 40,
          ),
        ],
        factorHoneycomb: 0.2,
      );
      // 25 / (1 - 0.2) = 31.25 -> ceil = 32
      expect(r.posicionesRequeridas, 32);
    });

    test('varias familias se suman antes de aplicar honeycomb', () {
      final r = calcularPosicionesRequeridas(
        familias: const [
          DemandaFamilia(nombre: 'A', demandaAnual: 12000, rotacionAnual: 12, unidadesPorTarima: 40),
          DemandaFamilia(nombre: 'B', demandaAnual: 6000, rotacionAnual: 6, unidadesPorTarima: 50),
        ],
        factorHoneycomb: 0,
      );
      // A: 25 tarimas, B: ceil(1000/50)=20 tarimas -> 45
      expect(r.posicionesRequeridas, 45);
    });

    test('factor_pico eleva el inventario pico', () {
      final r = calcularPosicionesRequeridas(
        familias: const [
          DemandaFamilia(
            nombre: 'A',
            demandaAnual: 12000,
            rotacionAnual: 12,
            unidadesPorTarima: 40,
            factorPico: 1.5,
          ),
        ],
        factorHoneycomb: 0,
      );
      // inventario_promedio=1000, pico=1500, tarimas=ceil(1500/40)=38
      expect(r.posicionesRequeridas, 38);
    });

    test('rechaza lista de familias vacía', () {
      expect(
        () => calcularPosicionesRequeridas(familias: const [], factorHoneycomb: 0),
        throwsArgumentError,
      );
    });

    test('rechaza factor_honeycomb fuera de [0, 1)', () {
      final familias = [
        const DemandaFamilia(nombre: 'A', demandaAnual: 100, rotacionAnual: 1, unidadesPorTarima: 1),
      ];
      expect(
        () => calcularPosicionesRequeridas(familias: familias, factorHoneycomb: 1.0),
        throwsArgumentError,
      );
      expect(
        () => calcularPosicionesRequeridas(familias: familias, factorHoneycomb: -0.1),
        throwsArgumentError,
      );
    });

    test('rechaza rotación anual cero o negativa (división por cero)', () {
      final familias = [
        const DemandaFamilia(nombre: 'A', demandaAnual: 100, rotacionAnual: 0, unidadesPorTarima: 1),
      ];
      expect(
        () => calcularPosicionesRequeridas(familias: familias, factorHoneycomb: 0),
        throwsArgumentError,
      );
    });
  });
}
