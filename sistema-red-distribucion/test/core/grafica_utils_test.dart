import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_red_distribucion/core/grafica_utils.dart';

void main() {
  group('techoLindoGrafica', () {
    test('redondea hacia arriba al siguiente 1/2/5 × potencia de 10', () {
      expect(techoLindoGrafica(9880000), 10000000);
      expect(techoLindoGrafica(11360000), 20000000);
      expect(techoLindoGrafica(3), 5);
      expect(techoLindoGrafica(1), 1);
      expect(techoLindoGrafica(0.7), 1);
    });

    test('un valor ya "lindo" queda igual', () {
      expect(techoLindoGrafica(5000), 5000);
      expect(techoLindoGrafica(20), 20);
    });

    test('el resultado siempre es >= el valor de entrada', () {
      for (final valor in [1, 4, 17, 250, 999, 100000, 987654]) {
        expect(techoLindoGrafica(valor.toDouble()), greaterThanOrEqualTo(valor));
      }
    });

    test('valor cero o negativo devuelve 1 (evita romper maxY del gráfico)', () {
      expect(techoLindoGrafica(0), 1);
      expect(techoLindoGrafica(-5), 1);
    });
  });
}
