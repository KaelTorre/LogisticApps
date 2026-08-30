import 'package:flutter_test/flutter_test.dart';
import 'package:paquete_geo_logistica/paquete_geo_logistica.dart';
import 'package:sistema_red_distribucion/data/models/zona_demanda.dart';
import 'package:sistema_red_distribucion/domain/motor/m2_centro_gravedad.dart';

ZonaDemanda _zona({
  required int id,
  required double lat,
  required double lon,
  double demanda = 1,
}) => ZonaDemanda(
  id: id,
  proyectoId: 1,
  etiqueta: 'Zona $id',
  latitud: lat,
  longitud: lon,
  demandaAgregada: demanda,
  pedidosAgregados: 1,
  numeroClientes: 1,
  errorAgregacionMetros: 0,
);

void main() {
  group('centroGravedadExacto', () {
    test('con una sola zona, el resultado es exactamente esa zona (punto fijo)', () {
      final zona = _zona(id: 1, lat: -8.37, lon: -74.55);
      final resultado = centroGravedadExacto(zonas: [zona], tarifaCentPorKmTon: 100);

      expect(resultado.latitud, closeTo(-8.37, 1e-9));
      expect(resultado.longitud, closeTo(-74.55, 1e-9));
    });

    test('con demanda igual en las cuatro esquinas de un cuadrado, cae en el centro', () {
      final zonas = [
        _zona(id: 1, lat: 0, lon: 0),
        _zona(id: 2, lat: 0, lon: 0.01),
        _zona(id: 3, lat: 0.01, lon: 0),
        _zona(id: 4, lat: 0.01, lon: 0.01),
      ];

      final resultado = centroGravedadExacto(zonas: zonas, tarifaCentPorKmTon: 100);

      final distanciaAlCentroMetros =
          distanciaHaversineKm(lat1: resultado.latitud, lon1: resultado.longitud, lat2: 0.005, lon2: 0.005) * 1000;
      expect(distanciaAlCentroMetros, lessThan(1.0));
    });

    test('se desplaza hacia la zona con más demanda', () {
      final pesada = _zona(id: 1, lat: 0, lon: 0, demanda: 100);
      final zonas = [
        pesada,
        _zona(id: 2, lat: 0, lon: 0.01, demanda: 1),
        _zona(id: 3, lat: 0.01, lon: 0, demanda: 1),
        _zona(id: 4, lat: 0.01, lon: 0.01, demanda: 1),
      ];

      final resultado = centroGravedadExacto(zonas: zonas, tarifaCentPorKmTon: 50);

      final distanciaResultadoAPesada = distanciaHaversineKm(
        lat1: resultado.latitud,
        lon1: resultado.longitud,
        lat2: pesada.latitud,
        lon2: pesada.longitud,
      );
      final distanciaCentroAPesada = distanciaHaversineKm(lat1: 0.005, lon1: 0.005, lat2: 0, lon2: 0);

      expect(distanciaResultadoAPesada, lessThan(distanciaCentroAPesada / 2));
    });

    test('una tarifa uniforme no cambia el resultado (se cancela algebraicamente)', () {
      final zonas = [
        _zona(id: 1, lat: 0, lon: 0, demanda: 30),
        _zona(id: 2, lat: 0.02, lon: 0.01, demanda: 10),
        _zona(id: 3, lat: -0.01, lon: 0.03, demanda: 5),
      ];

      final conTarifaBaja = centroGravedadExacto(zonas: zonas, tarifaCentPorKmTon: 10);
      final conTarifaAlta = centroGravedadExacto(zonas: zonas, tarifaCentPorKmTon: 9999);

      expect(conTarifaBaja.latitud, closeTo(conTarifaAlta.latitud, 1e-9));
      expect(conTarifaBaja.longitud, closeTo(conTarifaAlta.longitud, 1e-9));
    });
  });

  group('generarCandidatosPorCentroGravedad', () {
    test('con p >= número de zonas, cada zona es su propio candidato', () {
      final zonas = [
        _zona(id: 1, lat: 0, lon: 0),
        _zona(id: 2, lat: 1, lon: 1),
      ];

      final candidatos = generarCandidatosPorCentroGravedad(
        zonas: zonas,
        tarifaCentPorKmTon: 50,
        p: 5,
      );

      expect(candidatos, hasLength(2));
    });

    test('con p=2 y dos grupos bien separados, cada candidato queda cerca de un grupo', () {
      final grupoNorte = [
        _zona(id: 1, lat: 10, lon: 10),
        _zona(id: 2, lat: 10.01, lon: 10.01),
        _zona(id: 3, lat: 10.02, lon: 10),
      ];
      final grupoSur = [
        _zona(id: 4, lat: -10, lon: -10),
        _zona(id: 5, lat: -10.01, lon: -10.01),
        _zona(id: 6, lat: -10.02, lon: -10),
      ];

      final candidatos = generarCandidatosPorCentroGravedad(
        zonas: [...grupoNorte, ...grupoSur],
        tarifaCentPorKmTon: 50,
        p: 2,
        semilla: 3,
      );

      expect(candidatos, hasLength(2));
      // Cada candidato debe quedar mucho más cerca de un grupo que del otro
      // (separación de ~3100km entre los dos grupos).
      for (final candidato in candidatos) {
        final distanciaANorte = distanciaHaversineKm(
          lat1: candidato.latitud,
          lon1: candidato.longitud,
          lat2: 10,
          lon2: 10,
        );
        final distanciaASur = distanciaHaversineKm(
          lat1: candidato.latitud,
          lon1: candidato.longitud,
          lat2: -10,
          lon2: -10,
        );
        final cercaDeAlguno = distanciaANorte < 50 || distanciaASur < 50;
        expect(cercaDeAlguno, isTrue);
      }
    });

    test('es determinista con semilla fija', () {
      final zonas = [
        _zona(id: 1, lat: 0, lon: 0, demanda: 5),
        _zona(id: 2, lat: 1, lon: 1, demanda: 10),
        _zona(id: 3, lat: 2, lon: -1, demanda: 3),
        _zona(id: 4, lat: -1, lon: 2, demanda: 7),
        _zona(id: 5, lat: 3, lon: 3, demanda: 6),
      ];

      final primeraEjecucion = generarCandidatosPorCentroGravedad(
        zonas: zonas,
        tarifaCentPorKmTon: 20,
        p: 2,
        semilla: 11,
      );
      final segundaEjecucion = generarCandidatosPorCentroGravedad(
        zonas: zonas,
        tarifaCentPorKmTon: 20,
        p: 2,
        semilla: 11,
      );

      expect(primeraEjecucion.length, segundaEjecucion.length);
      for (var i = 0; i < primeraEjecucion.length; i++) {
        expect(primeraEjecucion[i].latitud, segundaEjecucion[i].latitud);
        expect(primeraEjecucion[i].longitud, segundaEjecucion[i].longitud);
      }
    });
  });
}
