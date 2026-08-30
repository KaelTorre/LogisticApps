import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_red_distribucion/data/models/celda_matriz.dart';
import 'package:sistema_red_distribucion/data/models/parametros_costo.dart';
import 'package:sistema_red_distribucion/data/models/sitio_candidato.dart';
import 'package:sistema_red_distribucion/data/models/zona_demanda.dart';
import 'package:sistema_red_distribucion/domain/motor/m5_asignacion.dart';

SitioCandidato _candidato(int id, {double capacidad = 100000}) => SitioCandidato(
  id: id,
  proyectoId: 1,
  nombre: 'C$id',
  latitud: 0,
  longitud: 0,
  costoFijoAnualCent: 1000,
  capacidadAnual: capacidad,
  costoVariableManejoCentPorUnidad: 10,
  origen: 'manual',
);

ZonaDemanda _zona(int id, {double demanda = 10}) => ZonaDemanda(
  id: id,
  proyectoId: 1,
  etiqueta: 'Z$id',
  latitud: 0,
  longitud: 0,
  demandaAgregada: demanda,
  pedidosAgregados: 1,
  numeroClientes: 1,
  errorAgregacionMetros: 0,
);

CeldaMatriz _celda({required int candidatoId, required int zonaId, required int distanciaMetros}) => CeldaMatriz(
  proyectoId: 1,
  tipoOrigen: 'candidato',
  origenId: candidatoId,
  tipoDestino: 'zona',
  destinoId: zonaId,
  distanciaMetros: distanciaMetros,
  duracionSegundos: distanciaMetros ~/ 10,
  fuente: 'osrm',
);

const _paramsBase = ParametrosCosto(
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
  estandarServicioValor: 1000000, // muy holgado, no lo alcanza nada en estos tests salvo el de Test J
);

void main() {
  test('Test H — sin restricción de capacidad, cada zona va al almacén de menor costo', () {
    final zona1 = _zona(1);
    final zona2 = _zona(2);
    final candidatoCercano = _candidato(1);
    final candidatoLejano = _candidato(2);

    final resultado = asignarZonas(
      abiertos: [1, 2],
      zonas: [zona1, zona2],
      candidatosPorId: {1: candidatoCercano, 2: candidatoLejano},
      distanciaZonaCandidato: {
        (1, 1): _celda(candidatoId: 1, zonaId: 1, distanciaMetros: 1000), // Z1 más cerca de C1
        (1, 2): _celda(candidatoId: 2, zonaId: 1, distanciaMetros: 9000),
        (2, 1): _celda(candidatoId: 1, zonaId: 2, distanciaMetros: 8000),
        (2, 2): _celda(candidatoId: 2, zonaId: 2, distanciaMetros: 500), // Z2 más cerca de C2
      },
      params: _paramsBase,
      conRestriccionCapacidad: false,
    );

    expect(resultado.asignacion[1], 1);
    expect(resultado.asignacion[2], 2);
    expect(resultado.zonasSinAsignar, isEmpty);
  });

  test(
    'Test I — con capacidad insuficiente, ninguna zona queda asignada a un almacén '
    'excedido, y las no asignadas se reportan explícitamente',
    () {
      // Un solo almacén con capacidad para una sola de las dos zonas.
      final zona1 = _zona(1, demanda: 60);
      final zona2 = _zona(2, demanda: 60);
      final candidato = _candidato(1, capacidad: 60);

      final resultado = asignarZonas(
        abiertos: [1],
        zonas: [zona1, zona2],
        candidatosPorId: {1: candidato},
        distanciaZonaCandidato: {
          (1, 1): _celda(candidatoId: 1, zonaId: 1, distanciaMetros: 1000),
          (2, 1): _celda(candidatoId: 1, zonaId: 2, distanciaMetros: 1000),
        },
        params: _paramsBase,
        conRestriccionCapacidad: true,
      );

      // Solo una de las dos zonas consigue el almacén; la otra queda
      // explícitamente reportada como sin asignar, no desaparece.
      expect(resultado.asignacion.length, 1);
      expect(resultado.zonasSinAsignar.length, 1);
      final zonaAsignada = resultado.asignacion.keys.first;
      final zonaSinAsignar = resultado.zonasSinAsignar.first;
      expect({zonaAsignada, zonaSinAsignar}, {1, 2});

      // La demanda de la zona asignada nunca excede la capacidad del único
      // almacén (60 == 60, exactamente al límite, no por encima).
      final demandaAsignada = zonaAsignada == 1 ? zona1.demandaAgregada : zona2.demandaAgregada;
      expect(demandaAsignada, lessThanOrEqualTo(candidato.capacidadAnual));
    },
  );

  test(
    'Test J — una zona más lejana que el estándar se marca como no cubierta '
    'y no desaparece silenciosamente',
    () {
      final zonaCubierta = _zona(1);
      final zonaLejana = _zona(2);
      final candidato = _candidato(1);
      const params = ParametrosCosto(
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
        estandarServicioValor: 5000, // 5 km
      );

      final resultado = asignarZonas(
        abiertos: [1],
        zonas: [zonaCubierta, zonaLejana],
        candidatosPorId: {1: candidato},
        distanciaZonaCandidato: {
          (1, 1): _celda(candidatoId: 1, zonaId: 1, distanciaMetros: 3000), // dentro del estándar
          (2, 1): _celda(candidatoId: 1, zonaId: 2, distanciaMetros: 8000), // fuera del estándar
        },
        params: params,
        conRestriccionCapacidad: false,
      );

      // La zona lejana SIGUE asignada (no desaparece)...
      expect(resultado.asignacion.containsKey(2), isTrue);
      expect(resultado.asignacion[2], 1);
      // ...pero queda marcada como no cubierta.
      expect(resultado.zonasNoCubiertas, contains(2));
      // La zona cercana no se marca.
      expect(resultado.zonasNoCubiertas, isNot(contains(1)));
    },
  );
}
