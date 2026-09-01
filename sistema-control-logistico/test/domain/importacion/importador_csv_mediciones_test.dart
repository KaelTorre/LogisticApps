import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_control_logistico/domain/importacion/importador_csv_mediciones.dart';

/// Fase 2 (CLAUDE.md): "Test del importador CSV con separadores distintos y
/// filas malformadas."
void main() {
  test('separador coma, con encabezado', () {
    final resultado = parsearCsvMediciones('orden,valor,nota\n1,1.18,\n2,1.33,pico atípico');

    expect(resultado.errores, isEmpty);
    expect(resultado.filas, hasLength(2));
    expect(resultado.filas[0].orden, 1);
    expect(resultado.filas[0].valor, 1.18);
    expect(resultado.filas[0].nota, isNull);
    expect(resultado.filas[1].nota, 'pico atípico');
  });

  test('separador punto y coma, con encabezado', () {
    final resultado = parsearCsvMediciones('orden;valor\n1;1.18\n2;1.33');

    expect(resultado.errores, isEmpty);
    expect(resultado.filas, hasLength(2));
    expect(resultado.filas[1].valor, 1.33);
  });

  test('separador tabulador, con encabezado', () {
    final resultado = parsearCsvMediciones('orden\tvalor\n1\t1.18\n2\t1.33');

    expect(resultado.errores, isEmpty);
    expect(resultado.filas, hasLength(2));
    expect(resultado.filas[1].valor, 1.33);
  });

  test('sin encabezado: asume el orden fijo orden, valor', () {
    final resultado = parsearCsvMediciones('1,1.18\n2,1.33');

    expect(resultado.errores, isEmpty);
    expect(resultado.filas, hasLength(2));
    expect(resultado.filas[0].orden, 1);
    expect(resultado.filas[0].valor, 1.18);
  });

  test('filas malformadas se rechazan individualmente sin abortar el resto', () {
    final resultado = parsearCsvMediciones(
      'orden,valor\n'
      '1,1.18\n' // válida
      'x,1.20\n' // orden no numérico
      '3,no-es-numero\n' // valor no numérico
      '4\n' // faltan columnas
      '5,1.31', // válida
    );

    expect(resultado.filas.map((f) => f.orden).toList(), [1, 5]);
    expect(resultado.errores, hasLength(3));
    expect(resultado.errores[0], contains('Línea 3'));
    expect(resultado.errores[1], contains('Línea 4'));
    expect(resultado.errores[2], contains('Línea 5'));
  });

  test('orden no positivo se rechaza', () {
    final resultado = parsearCsvMediciones('orden,valor\n0,1.18\n-1,1.20\n1,1.20');

    expect(resultado.filas, hasLength(1));
    expect(resultado.errores, hasLength(2));
  });

  test('acepta coma decimal (formato local) en el valor cuando el separador es punto y coma', () {
    final resultado = parsearCsvMediciones('orden;valor\n1;1,18');

    expect(resultado.errores, isEmpty);
    expect(resultado.filas.single.valor, 1.18);
  });

  test('contenido vacío no produce filas ni errores', () {
    final resultado = parsearCsvMediciones('');
    expect(resultado.filas, isEmpty);
    expect(resultado.errores, isEmpty);
  });
}
