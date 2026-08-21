import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_diseno_almacenes/domain/geometria/generador_layout.dart';

void main() {
  group('caso dorado — CLAUDE.md sección 12: relación de superficie', () {
    test('selectivo + retráctil típico: sup_alm / sup_constr entre 0.45 y 0.60', () {
      final r = generarLayout(
        filas: 6,
        modulosPorFila: 10,
        largoVigaMm: 2700,
        perfilAnchoBastidorMm: 80,
        fondoBastidorMm: 1100,
        anchoPasilloMm: 2850, // retráctil, EN clase 400
        separacionEspaldaMm: 200,
        holguraMuroMm: 200,
      );

      final ratio = r.supRacksMm2 / r.supConstruidaMm2;
      expect(ratio, inInclusiveRange(0.45, 0.60));
    });

    test('con fila simple (sin parear) el ratio NUNCA llega a 0.45 — por eso Fase 2 usa fila doble', () {
      // Réplica manual del cálculo de fila simple (un pasillo por cada
      // fila, sin parear) para documentar por qué la Fase 1 sola no
      // alcanzaba el caso dorado.
      const fondo = 1100;
      const pasillo = 2850;
      final ratioAsintotico = fondo / (fondo + pasillo);
      expect(ratioAsintotico, lessThan(0.45));
    });
  });

  group('propiedades', () {
    test('sup_construida siempre > sup_almacenamiento', () {
      for (final filas in [1, 2, 3, 4, 5, 10, 23]) {
        final r = generarLayout(
          filas: filas,
          modulosPorFila: 8,
          largoVigaMm: 1825,
          perfilAnchoBastidorMm: 80,
          fondoBastidorMm: 1100,
          anchoPasilloMm: 2850,
          separacionEspaldaMm: 200,
          holguraMuroMm: 200,
        );
        expect(r.supConstruidaMm2, greaterThan(r.supRacksMm2), reason: 'con filas=$filas');
      }
    });

    test('la suma de áreas de los rectángulos de racks coincide con sup_racks', () {
      final r = generarLayout(
        filas: 5,
        modulosPorFila: 6,
        largoVigaMm: 1825,
        perfilAnchoBastidorMm: 80,
        fondoBastidorMm: 1100,
        anchoPasilloMm: 2850,
        separacionEspaldaMm: 200,
        holguraMuroMm: 200,
      );
      final sumaReserva = r.rectangulos
          .where((rect) => rect.tipo == 'reserva')
          .fold(0, (acc, rect) => acc + rect.areaMm2);
      expect(sumaReserva, r.supRacksMm2);

      final sumaCirculacion = r.rectangulos
          .where((rect) => rect.tipo == 'circulacion')
          .fold(0, (acc, rect) => acc + rect.areaMm2);
      expect(sumaCirculacion, r.supPasillosMm2);
    });

    test('cantidad de filas de racks generadas coincide con el parámetro filas', () {
      for (final filas in [1, 2, 3, 4, 7]) {
        final r = generarLayout(
          filas: filas,
          modulosPorFila: 6,
          largoVigaMm: 1825,
          perfilAnchoBastidorMm: 80,
          fondoBastidorMm: 1100,
          anchoPasilloMm: 2850,
          separacionEspaldaMm: 200,
          holguraMuroMm: 200,
        );
        final filasDeRacks = r.rectangulos.where((rect) => rect.tipo == 'reserva').length;
        expect(filasDeRacks, filas, reason: 'con filas=$filas');
      }
    });

    test('1 sola fila no genera pasillo interior (solo margen de muro)', () {
      final r = generarLayout(
        filas: 1,
        modulosPorFila: 6,
        largoVigaMm: 1825,
        perfilAnchoBastidorMm: 80,
        fondoBastidorMm: 1100,
        anchoPasilloMm: 2850,
        separacionEspaldaMm: 200,
        holguraMuroMm: 200,
      );
      expect(r.rectangulos.where((rect) => rect.tipo == 'circulacion'), isEmpty);
      expect(r.supPasillosMm2, 0);
    });

    test('2 filas forman una fila doble sin pasillo interior (solo separación de espalda)', () {
      final r = generarLayout(
        filas: 2,
        modulosPorFila: 6,
        largoVigaMm: 1825,
        perfilAnchoBastidorMm: 80,
        fondoBastidorMm: 1100,
        anchoPasilloMm: 2850,
        separacionEspaldaMm: 200,
        holguraMuroMm: 200,
      );
      expect(r.rectangulos.where((rect) => rect.tipo == 'circulacion'), isEmpty);
    });

    test('rechaza filas o modulosPorFila <= 0', () {
      expect(
        () => generarLayout(
          filas: 0,
          modulosPorFila: 6,
          largoVigaMm: 1825,
          perfilAnchoBastidorMm: 80,
          fondoBastidorMm: 1100,
          anchoPasilloMm: 2850,
          separacionEspaldaMm: 200,
          holguraMuroMm: 200,
        ),
        throwsArgumentError,
      );
    });
  });
}
