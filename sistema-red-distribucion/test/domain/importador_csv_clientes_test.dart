import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_red_distribucion/domain/importacion/importador_csv_clientes.dart';

void main() {
  group('separadores', () {
    test('CSV separado por comas, con encabezado', () {
      const csv =
          'nombre,latitud,longitud,demanda_anual,pedidos_anuales\n'
          'Cliente A,-8.37,-74.55,120.5,52\n'
          'Cliente B,-8.39,-74.57,80,30\n';

      final resultado = parsearCsvClientes(csv);

      expect(resultado.errores, isEmpty);
      expect(resultado.filas, hasLength(2));
      expect(resultado.filas[0].nombre, 'Cliente A');
      expect(resultado.filas[0].demandaAnual, 120.5);
      expect(resultado.filas[1].pedidosAnuales, 30);
    });

    test('CSV separado por punto y coma, con encabezado', () {
      const csv =
          'nombre;latitud;longitud;demanda_anual;pedidos_anuales\n'
          'Cliente A;-8.37;-74.55;120.5;52\n';

      final resultado = parsearCsvClientes(csv);

      expect(resultado.errores, isEmpty);
      expect(resultado.filas, hasLength(1));
      expect(resultado.filas.first.nombre, 'Cliente A');
    });

    test('CSV separado por tabulador, con encabezado', () {
      const csv =
          'nombre\tlatitud\tlongitud\tdemanda_anual\tpedidos_anuales\n'
          'Cliente A\t-8.37\t-74.55\t120.5\t52\n';

      final resultado = parsearCsvClientes(csv);

      expect(resultado.errores, isEmpty);
      expect(resultado.filas, hasLength(1));
      expect(resultado.filas.first.nombre, 'Cliente A');
    });
  });

  group('encabezado', () {
    test('con encabezado, mapea columnas aunque estén en otro orden', () {
      const csv =
          'demanda_anual,nombre,pedidos_anuales,longitud,latitud\n'
          '120.5,Cliente A,52,-74.55,-8.37\n';

      final resultado = parsearCsvClientes(csv);

      expect(resultado.errores, isEmpty);
      expect(resultado.filas, hasLength(1));
      final fila = resultado.filas.first;
      expect(fila.nombre, 'Cliente A');
      expect(fila.latitud, -8.37);
      expect(fila.longitud, -74.55);
      expect(fila.demandaAnual, 120.5);
      expect(fila.pedidosAnuales, 52);
    });

    test('sin encabezado, asume el orden fijo nombre,lat,lon,demanda,pedidos', () {
      const csv = 'Cliente A,-8.37,-74.55,120.5,52\nCliente B,-8.39,-74.57,80,30\n';

      final resultado = parsearCsvClientes(csv);

      expect(resultado.errores, isEmpty);
      expect(resultado.filas, hasLength(2));
      expect(resultado.filas[0].nombre, 'Cliente A');
      expect(resultado.filas[1].nombre, 'Cliente B');
    });
  });

  group('filas malformadas', () {
    test('una fila con columnas de más/menos se rechaza sin abortar las demás', () {
      const csv =
          'nombre,latitud,longitud,demanda_anual,pedidos_anuales\n'
          'Cliente A,-8.37,-74.55,120.5,52\n'
          'Fila incompleta,-8.37,-74.55\n'
          'Cliente C,-8.39,-74.57,80,30\n';

      final resultado = parsearCsvClientes(csv);

      expect(resultado.filas, hasLength(2));
      expect(resultado.filas[0].nombre, 'Cliente A');
      expect(resultado.filas[1].nombre, 'Cliente C');
      expect(resultado.errores, hasLength(1));
      expect(resultado.errores.first, contains('Línea 3'));
    });

    test('una fila con coordenada no numérica se rechaza sin abortar las demás', () {
      const csv =
          'nombre,latitud,longitud,demanda_anual,pedidos_anuales\n'
          'Cliente A,-8.37,-74.55,120.5,52\n'
          'Cliente Roto,no-es-numero,-74.55,120.5,52\n'
          'Cliente C,-8.39,-74.57,80,30\n';

      final resultado = parsearCsvClientes(csv);

      expect(resultado.filas, hasLength(2));
      expect(resultado.errores, hasLength(1));
      expect(resultado.errores.first, contains('Línea 3'));
    });

    test('una fila con coordenada fuera de rango se rechaza sin abortar las demás', () {
      const csv =
          'nombre,latitud,longitud,demanda_anual,pedidos_anuales\n'
          'Cliente A,-8.37,-74.55,120.5,52\n'
          'Cliente Fuera de rango,91,-74.55,120.5,52\n';

      final resultado = parsearCsvClientes(csv);

      expect(resultado.filas, hasLength(1));
      expect(resultado.errores, hasLength(1));
      expect(resultado.errores.first, contains('fuera de rango'));
    });

    test('un CSV vacío no produce filas ni errores', () {
      final resultado = parsearCsvClientes('');
      expect(resultado.filas, isEmpty);
      expect(resultado.errores, isEmpty);
    });
  });
}
