import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_red_distribucion/domain/export/legibilidad_memoria.dart';

/// La memoria de cálculo se guarda pensada para trazabilidad interna
/// (código de módulo, nombres de variable, céntimos crudos) — este archivo
/// prueba que la traducción a un reporte legible no pierda ni tergiverse
/// ningún valor real, solo lo re-etiquete y reformatee.
void main() {
  group('moduloLegible', () {
    test('antepone el nombre completo al código conocido', () {
      expect(moduloLegible('M4'), 'Modelo de costo (M4)');
    });

    test('un código desconocido se muestra tal cual, sin inventar nombre', () {
      expect(moduloLegible('M99'), 'M99');
    });
  });

  group('entradasLegibles', () {
    test('traduce una clave conocida a su etiqueta', () {
      expect(entradasLegibles('{"zonas_asignadas": 4}'), 'Zonas asignadas: 4');
    });

    test('una clave con sufijo _cent se convierte de céntimos a texto', () {
      expect(entradasLegibles('{"valor_por_unidad_cent": 250000}'), 'Valor por unidad: 2500.00');
    });

    test('las claves de porRubro (sin sufijo _cent) también se convierten de céntimos', () {
      expect(entradasLegibles('{"fijo": 100000, "manejo": 5000}'), 'Costo fijo: 1000.00 · Manejo: 50.00');
    });

    test('una tasa anual se expresa como porcentaje', () {
      expect(entradasLegibles('{"tasa_manejo_inventario_anual": 0.25}'), 'Tasa anual de manejo de inventario: 25%');
    });

    test('metodo_por_punto usa la etiqueta del método, no el valor interno', () {
      expect(entradasLegibles('{"metodo_por_punto": "exhaustiva"}'), 'Método usado en cada punto: Enumeración exhaustiva');
    });

    test('un p_fijo nulo se explica como libre, no como "null"', () {
      expect(entradasLegibles('{"p_fijo": null}'), 'Cantidad fija de almacenes (p): libre (sin fijar)');
    });

    test('una clave que no está en el diccionario se muestra igual, con guiones bajos como espacios', () {
      expect(entradasLegibles('{"clave_futura": 7}'), 'clave futura: 7');
    });

    test('un objeto vacío no deja la celda en blanco', () {
      expect(entradasLegibles('{}'), '—');
    });

    test('varias entradas se separan con " · "', () {
      expect(entradasLegibles('{"zonas": 4, "candidatos_abiertos": 1}'), 'Zonas de demanda: 4 · Candidatos abiertos: 1');
    });
  });

  group('salidaLegible', () {
    test('un entero puro en céntimos se convierte completo', () {
      expect(salidaLegible('630057343', 'centavos'), '6300573.43');
    });

    test('una frase que termina en un monto solo reformatea ese número final', () {
      expect(
        salidaLegible('4 almacén(es) abierto(s), costo 630057343', 'centavos'),
        '4 almacén(es) abierto(s), costo 6300573.43',
      );
    });

    test('un número que no es el monto (ej. "p=2") no se toca si no es céntimos', () {
      expect(salidaLegible('4 zona(s) asignada(s), 0 fuera del estándar', 'zonas'), '4 zona(s) asignada(s), 0 fuera del estándar');
    });

    test('con varios números y unidad céntimos, solo se reformatea el último', () {
      expect(salidaLegible('óptimo en p=2, costo 630057343', 'centavos'), 'óptimo en p=2, costo 6300573.43');
    });
  });

  group('unidadLegible', () {
    test('centavos se resume a un rótulo corto, no la palabra "centavos"', () {
      expect(unidadLegible('centavos'), isNot('centavos'));
    });

    test('una unidad sin traducción conocida se muestra igual', () {
      expect(unidadLegible('metros'), 'metros');
    });
  });
}
