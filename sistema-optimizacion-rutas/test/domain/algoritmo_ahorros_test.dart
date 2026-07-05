import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_optimizacion_rutas/data/models/punto_entrega.dart';
import 'package:sistema_optimizacion_rutas/data/models/vehiculo.dart';
import 'package:sistema_optimizacion_rutas/domain/algoritmo_ahorros.dart';
import 'package:sistema_optimizacion_rutas/domain/asignacion_vehiculos.dart';

// Caso calculado a mano (ver CLAUDE.md sección 7.1): depósito + 4 puntos
// A, B, C, D con demanda 10 cada uno.
//
// Matriz de distancias (índices: 0=depósito, 1=A, 2=B, 3=C, 4=D):
//   dep-A=10  dep-B=10  dep-C=15  dep-D=15
//   A-B=5 (cercanos)   C-D=5 (cercanos)   el resto de pares cruzados = 20
//
// Ahorros:
//   s(A,B) = 10+10-5  = 15
//   s(C,D) = 15+15-5  = 25   <- el mayor, se fusiona primero
//   s(A,C) = s(A,D) = s(B,C) = s(B,D) = 10+15-20 = 5
//
// Con capacidad de vehículo = 25 (exactamente 2 puntos de demanda 10 cada
// uno, no alcanza para 3): se espera que A-B queden en una ruta y C-D en
// otra, y que NO se fusionen entre sí (demanda combinada 40 > 25).
const _matrizDistancias = [
  [0.0, 10.0, 10.0, 15.0, 15.0],
  [10.0, 0.0, 5.0, 20.0, 20.0],
  [10.0, 5.0, 0.0, 20.0, 20.0],
  [15.0, 20.0, 20.0, 0.0, 5.0],
  [15.0, 20.0, 20.0, 5.0, 0.0],
];

const _puntoA = PuntoEntrega(nombre: 'A', latitud: 0, longitud: 0, demanda: 10);
const _puntoB = PuntoEntrega(nombre: 'B', latitud: 0, longitud: 0, demanda: 10);
const _puntoC = PuntoEntrega(nombre: 'C', latitud: 0, longitud: 0, demanda: 10);
const _puntoD = PuntoEntrega(nombre: 'D', latitud: 0, longitud: 0, demanda: 10);

const _puntosEntrega = [_puntoA, _puntoB, _puntoC, _puntoD];

List<PuntoEntrega>? _rutaQueContiene(
  ResultadoOptimizacion resultado,
  PuntoEntrega punto,
) {
  for (final ruta in resultado.rutas) {
    if (ruta.paradas.contains(punto)) return ruta.paradas;
  }
  return null;
}

void main() {
  group('calcularRutasAhorros — caso calculado a mano (CLAUDE.md 7.1)', () {
    test('fusiona A-B y C-D en rutas separadas, sin fusionarlas entre sí', () {
      final resultado = calcularRutasAhorros(
        matrizDistancias: _matrizDistancias,
        puntosEntrega: _puntosEntrega,
        vehiculosDisponibles: const [
          Vehiculo(nombre: 'V1', capacidadMaxima: 25),
          Vehiculo(nombre: 'V2', capacidadMaxima: 25),
        ],
      );

      expect(resultado.rutas, hasLength(2));

      final rutaDeA = _rutaQueContiene(resultado, _puntoA)!;
      final rutaDeC = _rutaQueContiene(resultado, _puntoC)!;

      expect(rutaDeA, containsAll([_puntoA, _puntoB]));
      expect(rutaDeA, hasLength(2));
      expect(rutaDeC, containsAll([_puntoC, _puntoD]));
      expect(rutaDeC, hasLength(2));

      // Las dos rutas fusionadas quedan separadas entre sí.
      expect(rutaDeA, isNot(contains(_puntoC)));
      expect(rutaDeC, isNot(contains(_puntoA)));
    });

    test('respeta la capacidad: con 25 no fusiona las dos rutas de a 2', () {
      final resultado = calcularRutasAhorros(
        matrizDistancias: _matrizDistancias,
        puntosEntrega: _puntosEntrega,
        vehiculosDisponibles: const [
          Vehiculo(nombre: 'V1', capacidadMaxima: 25),
          Vehiculo(nombre: 'V2', capacidadMaxima: 25),
        ],
      );

      for (final ruta in resultado.rutas) {
        expect(ruta.demandaTotal, lessThanOrEqualTo(25));
      }
    });

    test('marca flota insuficiente si hay menos vehículos que rutas', () {
      final resultado = calcularRutasAhorros(
        matrizDistancias: _matrizDistancias,
        puntosEntrega: _puntosEntrega,
        vehiculosDisponibles: const [
          Vehiculo(nombre: 'V1', capacidadMaxima: 25),
        ],
      );

      expect(resultado.rutas, hasLength(2));
      expect(resultado.flotaInsuficiente, isTrue);
      expect(resultado.vehiculosFaltantes, 1);
    });
  });
}
