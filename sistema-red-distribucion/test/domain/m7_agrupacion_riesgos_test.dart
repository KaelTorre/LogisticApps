import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_red_distribucion/domain/motor/m7_agrupacion_riesgos.dart';

void main() {
  test('Test G — inventario(4)/inventario(1) es exactamente 2', () {
    final base = 37.5;
    final razon = inventarioTotal(4, base) / inventarioTotal(1, base);
    expect(razon, 2.0);
  });

  test('Test G — inventario(9)/inventario(1) es exactamente 3', () {
    final base = 37.5;
    final razon = inventarioTotal(9, base) / inventarioTotal(1, base);
    expect(razon, 3.0);
  });

  test('inventario(1) es exactamente la base (raíz de 1 es 1)', () {
    expect(inventarioTotal(1, 42.0), 42.0);
  });
}
