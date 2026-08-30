import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_red_distribucion/data/models/parametros_costo.dart';
import 'package:sistema_red_distribucion/domain/motor/m4_costo_total.dart';
import 'package:sistema_red_distribucion/domain/motor/m9_comparador.dart';

const _params = ParametrosCosto(
  proyectoId: 1,
  tarifaEntradaFijaCent: 0,
  tarifaEntradaCentPorKmTon: 0,
  tarifaSalidaFijaCent: 0,
  tarifaSalidaCentPorKmTon: 10,
  tasaManejoInventarioAnual: 0.1,
  valorPorUnidadCent: 100,
  inventarioBaseUnaUbicacion: 10,
  costoPorPedidoCent: 50,
  tipoEstandar: 'distancia',
  estandarServicioValor: 5000,
);

void main() {
  test('Test T — el ahorro reportado es exactamente la diferencia de costos totales', () {
    final base = EscenarioDatos(
      costoTotalCent: 1000000,
      porRubro: {
        rubroProduccion: 100000,
        rubroEntrada: 50000,
        rubroSalida: 300000,
        rubroFijo: 400000,
        rubroManejo: 100000,
        rubroInventario: 40000,
        rubroPedidos: 10000,
      },
      almacenesAbiertos: {1, 2},
      asignacionZonaCandidato: {10: 1, 11: 2},
      distanciaZonaAsignada: {10: (3000, 200), 11: (4000, 250)},
    );
    final comparado = EscenarioDatos(
      costoTotalCent: 780000,
      porRubro: {
        rubroProduccion: 100000,
        rubroEntrada: 50000,
        rubroSalida: 150000,
        rubroFijo: 400000,
        rubroManejo: 70000,
        rubroInventario: 0,
        rubroPedidos: 10000,
      },
      almacenesAbiertos: {2},
      asignacionZonaCandidato: {10: 2, 11: 2},
      distanciaZonaAsignada: {10: (6000, 400), 11: (4000, 250)},
    );

    final resultado = compararEscenarios(base: base, comparado: comparado, params: _params);

    expect(resultado.ahorroAnualCent, base.costoTotalCent - comparado.costoTotalCent);
    expect(resultado.ahorroAnualCent, 220000);
  });

  test('detecta almacenes que abren y que cierran', () {
    final base = EscenarioDatos(
      costoTotalCent: 100,
      porRubro: const {},
      almacenesAbiertos: {1, 2},
      asignacionZonaCandidato: const {},
      distanciaZonaAsignada: const {},
    );
    final comparado = EscenarioDatos(
      costoTotalCent: 90,
      porRubro: const {},
      almacenesAbiertos: {2, 3},
      asignacionZonaCandidato: const {},
      distanciaZonaAsignada: const {},
    );

    final resultado = compararEscenarios(base: base, comparado: comparado, params: _params);

    expect(resultado.almacenesQueAbren, {3});
    expect(resultado.almacenesQueCierran, {1});
  });

  test('detecta zonas que cambian de asignación', () {
    final base = EscenarioDatos(
      costoTotalCent: 100,
      porRubro: const {},
      almacenesAbiertos: {1, 2},
      asignacionZonaCandidato: {10: 1, 11: 2, 12: 1},
      distanciaZonaAsignada: {10: (1000, 60), 11: (1000, 60), 12: (1000, 60)},
    );
    final comparado = EscenarioDatos(
      costoTotalCent: 90,
      porRubro: const {},
      almacenesAbiertos: {1, 2},
      asignacionZonaCandidato: {10: 2, 11: 2, 12: 1},
      distanciaZonaAsignada: {10: (1000, 60), 11: (1000, 60), 12: (1000, 60)},
    );

    final resultado = compararEscenarios(base: base, comparado: comparado, params: _params);

    expect(resultado.zonasQueCambianAsignacion, {10});
  });

  test('detecta variación en el cumplimiento del estándar de servicio', () {
    final base = EscenarioDatos(
      costoTotalCent: 100,
      porRubro: const {},
      almacenesAbiertos: {1},
      asignacionZonaCandidato: {10: 1, 11: 1},
      distanciaZonaAsignada: {10: (3000, 100), 11: (8000, 100)}, // 11 fuera del estándar (5000)
    );
    final comparado = EscenarioDatos(
      costoTotalCent: 90,
      porRubro: const {},
      almacenesAbiertos: {1, 2},
      asignacionZonaCandidato: {10: 1, 11: 2},
      distanciaZonaAsignada: {10: (3000, 100), 11: (2000, 100)}, // ahora las dos cumplen
    );

    final resultado = compararEscenarios(base: base, comparado: comparado, params: _params);

    expect(resultado.zonasNoCubiertasBase, 1);
    expect(resultado.zonasNoCubiertasComparado, 0);
  });

  test('la diferencia por rubro es comparado − base', () {
    final base = EscenarioDatos(
      costoTotalCent: 100,
      porRubro: {rubroFijo: 500},
      almacenesAbiertos: const {},
      asignacionZonaCandidato: const {},
      distanciaZonaAsignada: const {},
    );
    final comparado = EscenarioDatos(
      costoTotalCent: 90,
      porRubro: {rubroFijo: 300},
      almacenesAbiertos: const {},
      asignacionZonaCandidato: const {},
      distanciaZonaAsignada: const {},
    );

    final resultado = compararEscenarios(base: base, comparado: comparado, params: _params);

    expect(resultado.diferenciaPorRubro[rubroFijo], -200);
  });
}
