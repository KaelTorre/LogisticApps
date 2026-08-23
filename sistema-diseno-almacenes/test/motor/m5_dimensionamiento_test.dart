import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_diseno_almacenes/domain/motor/m5_dimensionamiento_con_tendencia.dart';
import 'package:sistema_diseno_almacenes/domain/motor/tarifa_publica.dart';

ResultadoM5 _resultadoBase({
  int demandaInicial = 100,
  double tasaCrecimientoAnual = 0.10,
  int horizonteAnios = 5,
  double costoConstruccionPorPosicion = 1000,
  double costoAnualPropioPorPosicion = 50,
  double tasaDescuentoAnual = 0.08,
  int anioEtapa = 2,
}) {
  return calcularDimensionamientoConTendencia(
    demandaInicial: demandaInicial,
    tasaCrecimientoAnual: tasaCrecimientoAnual,
    horizonteAnios: horizonteAnios,
    costoConstruccionPorPosicion: costoConstruccionPorPosicion,
    costoAnualPropioPorPosicion: costoAnualPropioPorPosicion,
    tarifaPublica: const TarifaPorEspacio(tarifaPorPosicionMes: 20),
    tasaDescuentoAnual: tasaDescuentoAnual,
    anioEtapa: anioEtapa,
  );
}

void main() {
  group('calcularDimensionamientoConTendencia', () {
    test('la demanda crece por interés compuesto', () {
      final r = _resultadoBase(demandaInicial: 100, tasaCrecimientoAnual: 0.10, horizonteAnios: 3);
      // año1=100, año2=ceil(110)=110, año3=ceil(121)=121
      expect(r.demandaPorAnio, [100, 110, 121]);
    });

    test('evalúa los 3 escenarios y los ordena por menor VPN', () {
      final r = _resultadoBase();
      expect(r.escenarios, hasLength(3));
      for (var i = 1; i < r.escenarios.length; i++) {
        expect(
          r.escenarios[i].costoPresenteTotal,
          greaterThanOrEqualTo(r.escenarios[i - 1].costoPresenteTotal),
        );
      }
      expect(r.mejorEscenario, r.escenarios.first.escenario);
    });

    test('"base + público" nunca construye más que la demanda del año 1', () {
      final r = _resultadoBase(demandaInicial: 100, tasaCrecimientoAnual: 0.20, horizonteAnios: 6);
      final basePublico = r.escenarios.firstWhere(
        (e) => e.escenario == EscenarioConstruccion.basePublico,
      );
      // El costo del año 0 (construcción) es capacidadBase × costoConstrucción = 100 × 1000
      expect(basePublico.curvaCostoAcumulado.first.costo, 100 * 1000);
    });

    test('"todo ahora" construye la capacidad del último año desde el año 0', () {
      final r = _resultadoBase(demandaInicial: 100, tasaCrecimientoAnual: 0.10, horizonteAnios: 3);
      final todoAhora = r.escenarios.firstWhere(
        (e) => e.escenario == EscenarioConstruccion.todoAhora,
      );
      // demanda año 3 = 121 (ver test de arriba)
      expect(todoAhora.curvaCostoAcumulado.first.costo, 121 * 1000);
    });

    test('con crecimiento muy alto y tarifa pública muy cara, "todo ahora" tiende a ganar', () {
      final r = calcularDimensionamientoConTendencia(
        demandaInicial: 100,
        tasaCrecimientoAnual: 0.50,
        horizonteAnios: 5,
        costoConstruccionPorPosicion: 100,
        costoAnualPropioPorPosicion: 5,
        tarifaPublica: const TarifaPorEspacio(tarifaPorPosicionMes: 10000),
        tasaDescuentoAnual: 0.05,
        anioEtapa: 2,
      );
      expect(r.mejorEscenario, isNot(EscenarioConstruccion.basePublico));
    });

    test('con crecimiento nulo y construcción muy cara, "base + público" tiende a ganar', () {
      final r = calcularDimensionamientoConTendencia(
        demandaInicial: 100,
        tasaCrecimientoAnual: 0.02,
        horizonteAnios: 5,
        costoConstruccionPorPosicion: 100000,
        costoAnualPropioPorPosicion: 5000,
        tarifaPublica: const TarifaPorEspacio(tarifaPorPosicionMes: 0.5),
        tasaDescuentoAnual: 0.08,
        anioEtapa: 2,
      );
      expect(r.mejorEscenario, EscenarioConstruccion.basePublico);
    });

    test('rechaza horizonte <= 1', () {
      expect(() => _resultadoBase(horizonteAnios: 1), throwsArgumentError);
    });

    test('rechaza año de etapa fuera de [1, horizonte)', () {
      expect(() => _resultadoBase(horizonteAnios: 5, anioEtapa: 5), throwsArgumentError);
      expect(() => _resultadoBase(horizonteAnios: 5, anioEtapa: 0), throwsArgumentError);
    });

    test('rechaza demanda inicial <= 0', () {
      expect(() => _resultadoBase(demandaInicial: 0), throwsArgumentError);
    });
  });
}
