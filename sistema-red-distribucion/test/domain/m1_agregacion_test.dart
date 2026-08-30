import 'package:flutter_test/flutter_test.dart';
import 'package:paquete_geo_logistica/paquete_geo_logistica.dart';
import 'package:sistema_red_distribucion/data/models/cliente.dart';
import 'package:sistema_red_distribucion/domain/motor/m1_agregacion.dart';

Cliente _cliente({
  required int id,
  required double lat,
  required double lon,
  double demanda = 1,
  int pedidos = 1,
}) => Cliente(
  id: id,
  proyectoId: 1,
  nombre: 'Cliente $id',
  latitud: lat,
  longitud: lon,
  demandaAnual: demanda,
  pedidosAnuales: pedidos,
);

// Cuadrado de ~1.1km de lado cerca del ecuador (0.01° ≈ 1.11km), para poder
// razonar la posición esperada del centroide en coordenadas simples.
final _esquinaA = _cliente(id: 1, lat: 0, lon: 0); // A
final _esquinaB = _cliente(id: 2, lat: 0, lon: 0.01); // B
final _esquinaC = _cliente(id: 3, lat: 0.01, lon: 0); // C
final _esquinaD = _cliente(id: 4, lat: 0.01, lon: 0.01); // D
const _centroCuadrado = (0.005, 0.005);

void main() {
  test('Test dorado A — demanda igual, k=1: el centroide cae en el centro del cuadrado (±1m)', () {
    final zonas = agregarEnZonas(
      clientes: [_esquinaA, _esquinaB, _esquinaC, _esquinaD],
      k: 1,
    );

    expect(zonas, hasLength(1));
    final distanciaAlCentroMetros =
        distanciaHaversineKm(
          lat1: zonas.first.latitud,
          lon1: zonas.first.longitud,
          lat2: _centroCuadrado.$1,
          lon2: _centroCuadrado.$2,
        ) *
        1000;
    expect(distanciaAlCentroMetros, lessThan(1.0));
  });

  test(
    'Test dorado B — demanda 10,1,1,1: el centroide se desplaza hacia el cliente '
    'pesado y queda a menos de la mitad de la distancia al centro',
    () {
      final pesado = _cliente(id: 1, lat: 0, lon: 0, demanda: 10);
      final zonas = agregarEnZonas(
        clientes: [
          pesado,
          _cliente(id: 2, lat: 0, lon: 0.01, demanda: 1),
          _cliente(id: 3, lat: 0.01, lon: 0, demanda: 1),
          _cliente(id: 4, lat: 0.01, lon: 0.01, demanda: 1),
        ],
        k: 1,
      );

      final centroide = zonas.first;
      final distanciaCentroideAPesado = distanciaHaversineKm(
        lat1: centroide.latitud,
        lon1: centroide.longitud,
        lat2: pesado.latitud,
        lon2: pesado.longitud,
      );
      final distanciaCentroGeometricoAPesado = distanciaHaversineKm(
        lat1: _centroCuadrado.$1,
        lon1: _centroCuadrado.$2,
        lat2: pesado.latitud,
        lon2: pesado.longitud,
      );

      expect(
        distanciaCentroideAPesado,
        lessThan(distanciaCentroGeometricoAPesado / 2),
      );
    },
  );

  test('Test C — k = nClientes: cada cliente es su propia zona y el error es cero', () {
    final clientes = [_esquinaA, _esquinaB, _esquinaC, _esquinaD];
    final zonas = agregarEnZonas(clientes: clientes, k: clientes.length);

    expect(zonas, hasLength(4));
    for (final zona in zonas) {
      expect(zona.numeroClientes, 1);
      expect(zona.errorAgregacionMetros, 0);
    }
  });

  test('Test D — la demanda total de las zonas iguala exactamente la demanda total de los clientes', () {
    final clientes = [
      _cliente(id: 1, lat: 0, lon: 0, demanda: 37.5),
      _cliente(id: 2, lat: 0.02, lon: 0.01, demanda: 12.25),
      _cliente(id: 3, lat: -0.03, lon: 0.05, demanda: 8),
      _cliente(id: 4, lat: 0.1, lon: -0.02, demanda: 91.1),
      _cliente(id: 5, lat: 0.05, lon: 0.05, demanda: 4),
      _cliente(id: 6, lat: -0.01, lon: -0.04, demanda: 60),
    ];
    final demandaTotalClientes = clientes.fold(0.0, (s, c) => s + c.demandaAnual);

    final zonas = agregarEnZonas(clientes: clientes, k: 3);
    final demandaTotalZonas = zonas.fold(0.0, (s, z) => s + z.demandaAgregada);

    expect(demandaTotalZonas, closeTo(demandaTotalClientes, 1e-9));
  });

  test('Test E — determinista con semilla fija: dos ejecuciones producen zonas idénticas', () {
    final clientes = [
      _cliente(id: 1, lat: 0, lon: 0, demanda: 10),
      _cliente(id: 2, lat: 0.02, lon: 0.01, demanda: 5),
      _cliente(id: 3, lat: -0.03, lon: 0.05, demanda: 8),
      _cliente(id: 4, lat: 0.1, lon: -0.02, demanda: 20),
      _cliente(id: 5, lat: 0.05, lon: 0.05, demanda: 4),
      _cliente(id: 6, lat: -0.01, lon: -0.04, demanda: 15),
      _cliente(id: 7, lat: 0.07, lon: 0.03, demanda: 9),
      _cliente(id: 8, lat: -0.05, lon: -0.01, demanda: 11),
    ];

    final primeraEjecucion = agregarEnZonas(clientes: clientes, k: 3, semilla: 7);
    final segundaEjecucion = agregarEnZonas(clientes: clientes, k: 3, semilla: 7);

    expect(primeraEjecucion.length, segundaEjecucion.length);
    for (var i = 0; i < primeraEjecucion.length; i++) {
      expect(primeraEjecucion[i].latitud, segundaEjecucion[i].latitud);
      expect(primeraEjecucion[i].longitud, segundaEjecucion[i].longitud);
      expect(primeraEjecucion[i].clienteIds, segundaEjecucion[i].clienteIds);
      expect(primeraEjecucion[i].demandaAgregada, segundaEjecucion[i].demandaAgregada);
      expect(primeraEjecucion[i].errorAgregacionMetros, segundaEjecucion[i].errorAgregacionMetros);
    }
  });

  group('proponerK', () {
    test('propone el límite de una consulta menos la reserva, si es menor que nClientes', () {
      final k = proponerK(nClientes: 500, maxCoordenadasPorConsulta: 100, reservaCandidatos: 10);
      expect(k, 90);
    });

    test('nunca propone más zonas que clientes hay', () {
      final k = proponerK(nClientes: 5, maxCoordenadasPorConsulta: 100, reservaCandidatos: 10);
      expect(k, 5);
    });

    test('nunca propone menos de 1', () {
      final k = proponerK(nClientes: 500, maxCoordenadasPorConsulta: 10, reservaCandidatos: 50);
      expect(k, 1);
    });
  });
}
