import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_gestion_pedidos_sla/domain/funcion_taguchi.dart';

void main() {
  group('calcularPerdidaTaguchi', () {
    test('y == m: pérdida cero, sin importar k', () {
      expect(calcularPerdidaTaguchi(k: 500, y: 10, m: 10), 0);
    });

    test('caso calculado a mano: k=500, y=12, m=10 -> L=2000', () {
      // L = 500 * (12 - 10)^2 = 500 * 4 = 2000
      expect(calcularPerdidaTaguchi(k: 500, y: 12, m: 10), 2000);
    });

    test('k = 0: pérdida siempre cero', () {
      expect(calcularPerdidaTaguchi(k: 0, y: 100, m: 10), 0);
    });

    test('la desviación negativa también penaliza (se eleva al cuadrado)', () {
      expect(calcularPerdidaTaguchi(k: 10, y: 8, m: 10), 40);
    });
  });
}
