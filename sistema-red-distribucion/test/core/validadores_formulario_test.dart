import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_red_distribucion/core/validadores_formulario.dart';

void main() {
  group('validarObligatorio', () {
    test('rechaza vacío o nulo', () {
      expect(validarObligatorio(null), isNotNull);
      expect(validarObligatorio(''), isNotNull);
      expect(validarObligatorio('   '), isNotNull);
    });
    test('acepta un valor no vacío', () {
      expect(validarObligatorio('algo'), isNull);
    });
    test('concuerda en masculino singular por defecto', () {
      expect(validarObligatorio('', etiqueta: 'El nombre'), 'El nombre es obligatorio.');
    });
    test('concuerda en femenino singular', () {
      expect(
        validarObligatorio('', etiqueta: 'La demanda anual', femenino: true),
        'La demanda anual es obligatoria.',
      );
    });
    test('concuerda en plural', () {
      expect(
        validarObligatorio('', etiqueta: 'Los pedidos anuales', plural: true),
        'Los pedidos anuales son obligatorios.',
      );
    });
    test('concuerda en femenino plural', () {
      expect(
        validarObligatorio('', etiqueta: 'Las tarifas', femenino: true, plural: true),
        'Las tarifas son obligatorias.',
      );
    });
  });

  group('validarNumeroNoNegativo', () {
    test('acepta cero', () => expect(validarNumeroNoNegativo('0', etiqueta: 'X'), isNull));
    test('acepta positivo', () => expect(validarNumeroNoNegativo('12.5', etiqueta: 'X'), isNull));
    test('rechaza negativo', () => expect(validarNumeroNoNegativo('-1', etiqueta: 'X'), isNotNull));
    test('rechaza no numérico', () => expect(validarNumeroNoNegativo('abc', etiqueta: 'X'), isNotNull));
    test('requerido rechaza vacío', () => expect(validarNumeroNoNegativo('', etiqueta: 'X'), isNotNull));
    test('no requerido acepta vacío', () {
      expect(validarNumeroNoNegativo('', etiqueta: 'X', requerido: false), isNull);
    });
    test('mensaje de negativo concuerda en femenino', () {
      expect(
        validarNumeroNoNegativo('-1', etiqueta: 'La capacidad anual', femenino: true),
        'La capacidad anual no puede ser negativa.',
      );
    });
    test('mensaje de obligatorio concuerda en plural', () {
      expect(
        validarNumeroNoNegativo('', etiqueta: 'Los pedidos anuales', plural: true),
        'Los pedidos anuales son obligatorios.',
      );
    });
  });

  group('validarNumeroPositivo', () {
    test('rechaza cero', () => expect(validarNumeroPositivo('0', etiqueta: 'X'), isNotNull));
    test('rechaza negativo', () => expect(validarNumeroPositivo('-1', etiqueta: 'X'), isNotNull));
    test('acepta positivo', () => expect(validarNumeroPositivo('1.3', etiqueta: 'X'), isNull));
    test('rechaza no numérico', () => expect(validarNumeroPositivo('abc', etiqueta: 'X'), isNotNull));
  });

  group('validarEnteroNoNegativo', () {
    test('acepta cero', () => expect(validarEnteroNoNegativo('0', etiqueta: 'X'), isNull));
    test('rechaza negativo', () => expect(validarEnteroNoNegativo('-1', etiqueta: 'X'), isNotNull));
    test('rechaza decimal', () => expect(validarEnteroNoNegativo('1.5', etiqueta: 'X'), isNotNull));
  });

  group('validarEnteroPositivo', () {
    test('rechaza cero', () => expect(validarEnteroPositivo('0', etiqueta: 'X'), isNotNull));
    test('rechaza negativo', () => expect(validarEnteroPositivo('-3', etiqueta: 'X'), isNotNull));
    test('acepta positivo', () => expect(validarEnteroPositivo('5', etiqueta: 'X'), isNull));
    test('rechaza decimal', () => expect(validarEnteroPositivo('5.5', etiqueta: 'X'), isNotNull));
  });

  group('validarLatitud', () {
    test('rechaza fuera de rango', () {
      expect(validarLatitud('91'), isNotNull);
      expect(validarLatitud('-91'), isNotNull);
    });
    test('acepta límites exactos', () {
      expect(validarLatitud('90'), isNull);
      expect(validarLatitud('-90'), isNull);
    });
    test('rechaza vacío', () => expect(validarLatitud(''), isNotNull));
  });

  group('validarLongitud', () {
    test('rechaza fuera de rango', () {
      expect(validarLongitud('181'), isNotNull);
      expect(validarLongitud('-181'), isNotNull);
    });
    test('acepta límites exactos', () {
      expect(validarLongitud('180'), isNull);
      expect(validarLongitud('-180'), isNull);
    });
    test('rechaza vacío', () => expect(validarLongitud(''), isNotNull));
  });
}
