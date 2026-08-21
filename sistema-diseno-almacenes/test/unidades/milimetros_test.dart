import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_diseno_almacenes/core/unidades/milimetros.dart';

void main() {
  group('Milimetros.desdePulgadas', () {
    test('42 pulgadas redondea a 1067 mm (caso dorado bastidor GMA)', () {
      // 42 * 25.4 = 1066.8 -> redondea a 1067, no se trunca.
      expect(Milimetros.desdePulgadas(42).valor, 1067);
    });

    test('1 pulgada es 25 mm redondeando hacia abajo (25.4 -> 25)', () {
      expect(Milimetros.desdePulgadas(1).valor, 25);
    });

    test('0 pulgadas es 0 mm', () {
      expect(Milimetros.desdePulgadas(0).valor, 0);
    });
  });

  group('Milimetros.desdePies', () {
    test('1 pie es 305 mm', () {
      expect(Milimetros.desdePies(1).valor, 305);
    });

    test('12 pies es 3658 mm (altura libre típica de almacén)', () {
      expect(Milimetros.desdePies(12).valor, 3658);
    });
  });

  group('Milimetros.desdeMetros', () {
    test('1 metro es 1000 mm', () {
      expect(Milimetros.desdeMetros(1).valor, 1000);
    });

    test('1.2 metros es 1200 mm (fondo de tarima EPAL)', () {
      expect(Milimetros.desdeMetros(1.2).valor, 1200);
    });
  });

  group('Milimetros.enPulgadas / enPies / enMetros', () {
    test('1067 mm es aproximadamente 42 pulgadas', () {
      expect(const Milimetros(1067).enPulgadas, closeTo(42.0, 0.01));
    });

    test('3658 mm es aproximadamente 12 pies', () {
      expect(const Milimetros(3658).enPies, closeTo(12.0, 0.01));
    });

    test('1200 mm es 1.2 metros exactos', () {
      expect(const Milimetros(1200).enMetros, 1.2);
    });
  });

  group('round-trip', () {
    test('convertir a pulgadas y volver no se aleja más de 1 mm', () {
      for (final mm in [75, 800, 1067, 1200, 1219, 3658]) {
        final vuelta = Milimetros.desdePulgadas(Milimetros(mm).enPulgadas);
        expect((vuelta.valor - mm).abs(), lessThanOrEqualTo(1));
      }
    });
  });
}
