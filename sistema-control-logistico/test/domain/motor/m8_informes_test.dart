import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_control_logistico/domain/motor/m8_informes.dart';

/// Fase 5 (CLAUDE.md): "Test de suma" y "Test de variación presupuestal".
void main() {
  group('Test de suma — el costo total es exactamente la suma de sus actividades', () {
    test('costoTotal coincide con la suma manual de los componentes', () {
      const informe = InformeCostoServicio(
        componentes: [
          ComponenteCosto(proceso: 'Transporte', indicadorNombre: 'Costo de transporte', monto: 1200.50),
          ComponenteCosto(proceso: 'Almacenamiento', indicadorNombre: 'Costo de almacenaje', monto: 800.25),
          ComponenteCosto(proceso: 'Transporte', indicadorNombre: 'Costo de combustible', monto: 300.00),
        ],
        servicio: [],
      );

      expect(informe.costoTotal, closeTo(1200.50 + 800.25 + 300.00, 1e-9));
    });

    test('sin componentes, el costo total es cero', () {
      const informe = InformeCostoServicio(componentes: [], servicio: []);
      expect(informe.costoTotal, 0);
    });

    test('el peso relativo de cada componente suma exactamente 1', () {
      const informe = InformeCostoServicio(
        componentes: [
          ComponenteCosto(proceso: 'Transporte', indicadorNombre: 'A', monto: 250),
          ComponenteCosto(proceso: 'Almacenamiento', indicadorNombre: 'B', monto: 750),
        ],
        servicio: [],
      );

      final sumaPesos = informe.componentes.map(informe.pesoRelativo).reduce((a, b) => a + b);
      expect(sumaPesos, closeTo(1.0, 1e-9));
    });

    test('el precio de transferencia por proceso agrupa correctamente y suma el total', () {
      const informe = InformeCostoServicio(
        componentes: [
          ComponenteCosto(proceso: 'Transporte', indicadorNombre: 'A', monto: 100),
          ComponenteCosto(proceso: 'Transporte', indicadorNombre: 'B', monto: 50),
          ComponenteCosto(proceso: 'Almacenamiento', indicadorNombre: 'C', monto: 200),
        ],
        servicio: [],
      );

      final precios = informe.precioTransferenciaPorProceso;
      expect(precios['Transporte'], 150);
      expect(precios['Almacenamiento'], 200);
      expect(precios.values.reduce((a, b) => a + b), informe.costoTotal);
    });
  });

  group('Test de variación presupuestal — signo correcto para sobregasto y ahorro', () {
    test('sobregasto (real > presupuestado) da variación positiva', () {
      const variacion = VariacionPresupuestal(
        rubro: 'Transporte',
        presupuestadoCent: 100000,
        realCent: 125000,
      );

      expect(variacion.diferenciaCent, 25000);
      expect(variacion.porcentajeVariacion, closeTo(25.0, 1e-9));
      expect(variacion.porcentajeVariacion!, greaterThan(0));
    });

    test('ahorro (real < presupuestado) da variación negativa', () {
      const variacion = VariacionPresupuestal(
        rubro: 'Almacenamiento',
        presupuestadoCent: 100000,
        realCent: 80000,
      );

      expect(variacion.diferenciaCent, -20000);
      expect(variacion.porcentajeVariacion, closeTo(-20.0, 1e-9));
      expect(variacion.porcentajeVariacion!, lessThan(0));
    });

    test('exactamente lo presupuestado da variación cero', () {
      const variacion = VariacionPresupuestal(
        rubro: 'Inventario',
        presupuestadoCent: 50000,
        realCent: 50000,
      );

      expect(variacion.diferenciaCent, 0);
      expect(variacion.porcentajeVariacion, 0);
    });

    test('sin presupuesto asignado, el porcentaje es null en vez de dividir entre cero', () {
      const variacion = VariacionPresupuestal(rubro: 'Nuevo rubro', presupuestadoCent: 0, realCent: 500);
      expect(variacion.porcentajeVariacion, isNull);
    });
  });
}
