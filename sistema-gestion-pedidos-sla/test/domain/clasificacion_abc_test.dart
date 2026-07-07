import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_gestion_pedidos_sla/core/constants.dart';
import 'package:sistema_gestion_pedidos_sla/domain/clasificacion_abc.dart';

void main() {
  group('clasificarAbc', () {
    test('10 productos: A=20% (2), B=30% (3), C=50% (5)', () {
      // productoId == su rango de valor (10 el más valioso, 1 el menor).
      final valores = {
        for (var id = 1; id <= 10; id++) id: id.toDouble(),
      };

      final resultado = clasificarAbc(valores);

      expect(resultado, hasLength(10));
      expect(resultado[0].productoId, 10); // mayor valor primero
      final categorias = resultado.map((p) => p.categoria).toList();
      expect(categorias.sublist(0, 2), everyElement(CategoriaAbc.a));
      expect(categorias.sublist(2, 5), everyElement(CategoriaAbc.b));
      expect(categorias.sublist(5, 10), everyElement(CategoriaAbc.c));
    });

    test('menos de 5 productos: la categoría A puede quedar vacía', () {
      final valores = {1: 100.0};

      final resultado = clasificarAbc(valores);

      expect(resultado, hasLength(1));
      expect(resultado.first.categoria, CategoriaAbc.c);
      expect(
        resultado.where((p) => p.categoria == CategoriaAbc.a),
        isEmpty,
      );
    });

    test('0 productos: lista vacía sin excepción', () {
      expect(clasificarAbc({}), isEmpty);
    });

    test('empates de valor mantienen un orden estable', () {
      final valores = {1: 50.0, 2: 50.0, 3: 50.0};

      final resultadoA = clasificarAbc(valores);
      final resultadoB = clasificarAbc(valores);

      expect(
        resultadoA.map((p) => p.productoId).toList(),
        resultadoB.map((p) => p.productoId).toList(),
      );
    });

    test('porcentaje acumulado llega a 1.0 en el último producto', () {
      final valores = {1: 30.0, 2: 20.0, 3: 50.0};

      final resultado = clasificarAbc(valores);

      expect(resultado.last.porcentajeAcumulado, closeTo(1.0, 1e-9));
    });
  });
}
