import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_red_distribucion/domain/verificacion/buscador_limite.dart';

void main() {
  test('encuentra el máximo exacto con pocas llamadas (crecimiento + binaria)', () async {
    var llamadas = 0;
    final resultado = await buscarMaximoAceptado(
      probar: (n) async {
        llamadas++;
        return n <= 137;
      },
    );

    expect(resultado, 137);
    // log2(137/10) ≈ 3.8 dobles + búsqueda binaria en un rango de ~128 ≈ 7
    // pasos — muy por debajo de probar cada valor entre 1 y 2000.
    expect(llamadas, lessThan(20));
  });

  test('si nunca falla hasta el techo, devuelve el techo', () async {
    final resultado = await buscarMaximoAceptado(
      probar: (n) async => true,
      maximoAbsoluto: 500,
    );

    expect(resultado, 500);
  });

  test('si falla desde el primer intento, devuelve 0', () async {
    final resultado = await buscarMaximoAceptado(probar: (n) async => false);

    expect(resultado, 0);
  });

  test('encuentra el límite exacto incluso cuando cae justo en el punto de partida', () async {
    final resultado = await buscarMaximoAceptado(
      probar: (n) async => n <= 10,
      inicio: 10,
    );

    expect(resultado, 10);
  });

  test('funciona con un límite grande sin exceder el techo absoluto', () async {
    final resultado = await buscarMaximoAceptado(
      probar: (n) async => n <= 1999,
      maximoAbsoluto: 2000,
    );

    expect(resultado, 1999);
  });
}
