import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_diseno_almacenes/domain/geometria/generador_layout.dart';
import 'package:sistema_diseno_almacenes/domain/geometria/generador_prismas_3d.dart';
import 'package:sistema_diseno_almacenes/domain/geometria/prisma_3d.dart';

void main() {
  group('generarPrismas3D', () {
    late var layout = generarLayout(
      filas: 1,
      modulosPorFila: 2,
      largoVigaMm: 1825,
      perfilAnchoBastidorMm: 80,
      fondoBastidorMm: 1100,
      anchoPasilloMm: 2850,
      separacionEspaldaMm: 200,
      holguraMuroMm: 200,
    );

    List<Prisma3D> generar({int niveles = 2}) => generarPrismas3D(
      layout: layout,
      modulosPorFila: 2,
      niveles: niveles,
      pasoNivelMm: 1500,
      largoVigaMm: 1825,
      peralteVigaMm: 110,
      perfilAnchoBastidorMm: 80,
      perfilFondoBastidorMm: 50,
      fondoBastidorMm: 1100,
    );

    test('cantidad de puntales: 2 × (modulosPorFila + 1) por fila', () {
      final prismas = generar();
      final puntales = prismas.where((p) => p.tipo == 'puntal');
      expect(puntales.length, 2 * (2 + 1)); // 1 fila
    });

    test('cantidad de vigas: 2 × modulosPorFila × niveles por fila', () {
      final prismas = generar(niveles: 3);
      final vigas = prismas.where((p) => p.tipo == 'viga');
      expect(vigas.length, 2 * 2 * 3);
    });

    test('el bastidor del extremo derecho queda exactamente en el borde de la fila', () {
      final prismas = generar();
      final rectFila = layout.rectangulos.firstWhere((r) => r.tipo == 'reserva');
      final puntales = prismas.where((p) => p.tipo == 'puntal').toList();
      final xMaximo = puntales.map((p) => p.xMm).reduce((a, b) => a > b ? a : b);
      expect(xMaximo, rectFila.xMm + rectFila.anchoMm);
    });

    test('la primera viga empieza justo después del primer bastidor', () {
      final prismas = generar();
      final rectFila = layout.rectangulos.firstWhere((r) => r.tipo == 'reserva');
      final primeraViga = prismas.firstWhere((p) => p.tipo == 'viga');
      expect(primeraViga.xMm, rectFila.xMm + 80); // + perfilAnchoBastidorMm
    });

    test('puntal frontal y trasero quedan dentro de la profundidad de la fila', () {
      final prismas = generar();
      final rectFila = layout.rectangulos.firstWhere((r) => r.tipo == 'reserva');
      for (final p in prismas.where((p) => p.tipo == 'puntal')) {
        expect(p.yMm, greaterThanOrEqualTo(rectFila.yMm));
        expect(p.yMm + p.dyMm, lessThanOrEqualTo(rectFila.yMm + rectFila.largoMm));
      }
    });

    test('la altura de los puntales es niveles × pasoNivelMm', () {
      final prismas = generar(niveles: 4);
      for (final p in prismas.where((p) => p.tipo == 'puntal')) {
        expect(p.dzMm, 4 * 1500);
      }
    });

    test('las vigas del último nivel quedan a la altura correcta', () {
      final prismas = generar(niveles: 3);
      final vigas = prismas.where((p) => p.tipo == 'viga');
      final zMaximo = vigas.map((v) => v.zMm).reduce((a, b) => a > b ? a : b);
      expect(zMaximo, 3 * 1500);
    });

    test('rechaza modulosPorFila o niveles <= 0', () {
      expect(
        () => generarPrismas3D(
          layout: layout,
          modulosPorFila: 0,
          niveles: 2,
          pasoNivelMm: 1500,
          largoVigaMm: 1825,
          peralteVigaMm: 110,
          perfilAnchoBastidorMm: 80,
          perfilFondoBastidorMm: 50,
          fondoBastidorMm: 1100,
        ),
        throwsArgumentError,
      );
    });
  });
}
