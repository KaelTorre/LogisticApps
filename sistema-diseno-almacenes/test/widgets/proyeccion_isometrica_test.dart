import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_diseno_almacenes/domain/geometria/prisma_3d.dart';
import 'package:sistema_diseno_almacenes/ui/widgets/proyeccion_isometrica.dart';

void main() {
  group('iso — fórmula exacta de CLAUDE.md sección 8.2', () {
    test('el origen se proyecta en el punto origen', () {
      final p = iso(0, 0, 0, 10, Offset.zero);
      expect(p.dx, closeTo(0, 1e-9));
      expect(p.dy, closeTo(0, 1e-9));
    });

    test('avanzar en +X se proyecta hacia abajo-derecha', () {
      final p = iso(1, 0, 0, 10, Offset.zero);
      expect(p.dx, closeTo(8.660254, 1e-6));
      expect(p.dy, closeTo(5.0, 1e-6));
    });

    test('avanzar en +Z (subir) se proyecta directo hacia arriba en pantalla', () {
      final p = iso(0, 0, 1, 10, Offset.zero);
      expect(p.dx, closeTo(0, 1e-9));
      expect(p.dy, closeTo(-10, 1e-9));
    });

    test('el origen desplazado se traslada correctamente', () {
      final p = iso(0, 0, 0, 10, const Offset(100, 200));
      expect(p, const Offset(100, 200));
    });
  });

  group('rotarXY — 4 ángulos, sin cámara libre', () {
    test('ángulo 0 no cambia nada', () {
      expect(rotarXY(3, 5, 0), (3, 5));
    });

    test('cada 90° intercambia y niega ejes', () {
      expect(rotarXY(3, 5, 1), (-5, 3));
      expect(rotarXY(3, 5, 2), (-3, -5));
      expect(rotarXY(3, 5, 3), (5, -3));
    });

    test('4 rotaciones de 90° vuelven al punto original', () {
      expect(rotarXY(3, 5, 4), rotarXY(3, 5, 0));
    });
  });

  group('ordenarParaPintar — algoritmo del pintor', () {
    const a = Prisma3D(xMm: 0, yMm: 0, zMm: 0, dxMm: 1, dyMm: 1, dzMm: 1, tipo: 'puntal');
    const b = Prisma3D(xMm: 10, yMm: 0, zMm: 0, dxMm: 1, dyMm: 1, dzMm: 1, tipo: 'puntal');
    const c = Prisma3D(xMm: 0, yMm: 20, zMm: 0, dxMm: 1, dyMm: 1, dzMm: 1, tipo: 'puntal');

    test('ordena por x+y+z ascendente en el ángulo 0', () {
      final orden = ordenarParaPintar([c, a, b], 0);
      expect(orden, [a, b, c]);
    });

    test('rotar antes de ordenar puede cambiar el orden de pintado', () {
      // Con ángulo 1, (x,y) -> (-y,x): b=(10,0)->(0,10) suma=10;
      // c=(0,20)->(-20,0) suma=-20. c pasa a pintarse antes que b.
      final orden = ordenarParaPintar([b, c], 1);
      expect(orden, [c, b]);
    });
  });
}
