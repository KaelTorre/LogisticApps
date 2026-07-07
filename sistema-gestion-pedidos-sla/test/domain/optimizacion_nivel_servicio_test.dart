import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_gestion_pedidos_sla/domain/optimizacion_nivel_servicio.dart';

void main() {
  group('calcularNivelServicioOptimo', () {
    test('caso obligatorio del PDF del curso: a=0.5, b=0.00055', () {
      final resultado = calcularNivelServicioOptimo(a: 0.5, b: 0.00055);

      // SL* = (a / (4b))^(2/3), P(SL*) = a·√SL* − b·SL*²
      expect(resultado.slOptimo, closeTo(37.2419, 0.001));
      expect(resultado.pEnOptimo, closeTo(2.2885, 0.001));
    });

    test('b = 0 lanza CoeficienteCostoInvalido en vez de crashear', () {
      expect(
        () => calcularNivelServicioOptimo(a: 0.5, b: 0),
        throwsA(isA<CoeficienteCostoInvalido>()),
      );
    });

    test('b negativo también se rechaza', () {
      expect(
        () => calcularNivelServicioOptimo(a: 0.5, b: -0.001),
        throwsA(isA<CoeficienteCostoInvalido>()),
      );
    });
  });
}
