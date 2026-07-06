import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_optimizacion_rutas/data/models/punto_entrega.dart';
import 'package:sistema_optimizacion_rutas/domain/validador_capacidad.dart';

void main() {
  group('rutaExcedeCapacidad', () {
    test('retorna false cuando la demanda total no excede la capacidad', () {
      final puntos = [
        const PuntoEntrega(nombre: 'A', latitud: 0, longitud: 0, demanda: 40),
        const PuntoEntrega(nombre: 'B', latitud: 0, longitud: 0, demanda: 30),
      ];

      expect(rutaExcedeCapacidad(puntos, 100), isFalse);
    });

    test('retorna true cuando la demanda total excede la capacidad', () {
      final puntos = [
        const PuntoEntrega(nombre: 'A', latitud: 0, longitud: 0, demanda: 60),
        const PuntoEntrega(nombre: 'B', latitud: 0, longitud: 0, demanda: 50),
      ];

      expect(rutaExcedeCapacidad(puntos, 100), isTrue);
    });

    test('la demanda igual a la capacidad no se considera un exceso', () {
      final puntos = [
        const PuntoEntrega(nombre: 'A', latitud: 0, longitud: 0, demanda: 100),
      ];

      expect(rutaExcedeCapacidad(puntos, 100), isFalse);
    });
  });
}
