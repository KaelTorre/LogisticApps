import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_diseno_almacenes/data/local/database.dart';
import 'package:sistema_diseno_almacenes/domain/export/proyecto_portable.dart';

const _tarima = CatalogoTarima(
  id: 1,
  codigo: 'EPAL',
  largoMm: 1200,
  anchoMm: 800,
  altoMm: 144,
  taraG: 25000,
  cargaDinG: 1500000,
  cargaEstG: 4000000,
  region: 'EU',
  fuente: 'EN 13698',
  esSemilla: true,
);

const _bastidor = CatalogoBastidore(
  id: 2,
  codigo: 'BAST-914',
  fondoMm: 914,
  alturaMm: 6000,
  perfilAnchoMm: 100,
  perfilFondoMm: 100,
  fuente: 'Mecalux',
  esSemilla: true,
);

const _viga = CatalogoViga(
  id: 3,
  codigo: 'VIGA-1825',
  largoMm: 1825,
  peralteMm: 120,
  capacidadParG: null,
  fuente: 'Mecalux',
  esSemilla: true,
);

const _equipo = CatalogoEquipo(
  id: 4,
  codigo: 'TRILATERAL-VNA-300',
  tipo: 'trilateral',
  claseEn: '300A',
  pasilloMinMm: 1800,
  pasilloMaxMm: 2200,
  elevacionMaxMm: 15945,
  alturaMastilMm: null,
  requiereGuiado: true,
  costoUnitarioCent: null,
  fuente: 'Hyster',
  esSemilla: true,
);

const _camion = CatalogoCamione(
  id: 5,
  codigo: 'C2',
  largoMm: 12500,
  anchoMm: 2600,
  patioMinMm: 18000,
  fuente: 'RNV Perú',
  esSemilla: true,
);

ProyectoPortable _proyecto() => ProyectoPortable(
  version: ProyectoPortable.versionActual,
  nombre: 'Caso de prueba',
  demandaAnual: 12000,
  rotacionAnual: 12,
  unidadesPorTarima: 40,
  factorHoneycomb: 0.20,
  altoCargaMm: 1200,
  alturaLibreMm: 8000,
  reservaTechoMm: 450,
  largoDisponibleMm: 30000,
  camionesHoraPico: 4,
  tiempoServicioMinutos: 30,
  esperaObjetivoMinutos: 15,
  espaciamientoPuertaMm: 3600,
  areaStagingM2: 15,
  tarima: _tarima,
  bastidor: _bastidor,
  viga: _viga,
  equipo: _equipo,
  camion: _camion,
);

void main() {
  group('ProyectoPortable — round trip', () {
    test('toJsonString → fromJsonString preserva todos los campos numéricos', () {
      final original = _proyecto();
      final restaurado = ProyectoPortable.fromJsonString(original.toJsonString());

      expect(restaurado.nombre, original.nombre);
      expect(restaurado.demandaAnual, original.demandaAnual);
      expect(restaurado.rotacionAnual, original.rotacionAnual);
      expect(restaurado.unidadesPorTarima, original.unidadesPorTarima);
      expect(restaurado.factorHoneycomb, original.factorHoneycomb);
      expect(restaurado.altoCargaMm, original.altoCargaMm);
      expect(restaurado.alturaLibreMm, original.alturaLibreMm);
      expect(restaurado.reservaTechoMm, original.reservaTechoMm);
      expect(restaurado.largoDisponibleMm, original.largoDisponibleMm);
      expect(restaurado.camionesHoraPico, original.camionesHoraPico);
      expect(restaurado.tiempoServicioMinutos, original.tiempoServicioMinutos);
      expect(restaurado.esperaObjetivoMinutos, original.esperaObjetivoMinutos);
      expect(restaurado.espaciamientoPuertaMm, original.espaciamientoPuertaMm);
      expect(restaurado.areaStagingM2, original.areaStagingM2);
    });

    test('preserva las filas de catálogo completas (valores, no solo el id)', () {
      final restaurado = ProyectoPortable.fromJsonString(_proyecto().toJsonString());

      expect(restaurado.tarima.codigo, 'EPAL');
      expect(restaurado.tarima.largoMm, 1200);
      expect(restaurado.tarima.anchoMm, 800);
      expect(restaurado.tarima.fuente, 'EN 13698');

      expect(restaurado.bastidor.codigo, 'BAST-914');
      expect(restaurado.bastidor.fondoMm, 914);

      expect(restaurado.viga.codigo, 'VIGA-1825');
      expect(restaurado.viga.largoMm, 1825);
      expect(restaurado.viga.capacidadParG, isNull);

      expect(restaurado.equipo.codigo, 'TRILATERAL-VNA-300');
      expect(restaurado.equipo.elevacionMaxMm, 15945);
      expect(restaurado.equipo.requiereGuiado, isTrue);

      expect(restaurado.camion.codigo, 'C2');
      expect(restaurado.camion.patioMinMm, 18000);
    });
  });

  group('ProyectoPortable — validación de versión y forma', () {
    test('rechaza un archivo de una versión más nueva que la soportada', () {
      final json = _proyecto().toJsonString().replaceFirst(
        '"version": ${ProyectoPortable.versionActual}',
        '"version": ${ProyectoPortable.versionActual + 1}',
      );
      expect(() => ProyectoPortable.fromJsonString(json), throwsFormatException);
    });

    test('rechaza JSON inválido', () {
      expect(() => ProyectoPortable.fromJsonString('esto no es json'), throwsFormatException);
    });

    test('rechaza un JSON sin campo "version"', () {
      expect(() => ProyectoPortable.fromJsonString('{"nombre": "x"}'), throwsFormatException);
    });

    test('rechaza un JSON con forma de proyecto pero campos faltantes', () {
      expect(
        () => ProyectoPortable.fromJsonString('{"version": 1, "nombre": "x"}'),
        throwsFormatException,
      );
    });
  });
}
