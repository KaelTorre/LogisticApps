import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_optimizacion_rutas/data/models/deposito.dart';
import 'package:sistema_optimizacion_rutas/data/models/punto_entrega.dart';
import 'package:sistema_optimizacion_rutas/data/models/vehiculo.dart';
import 'package:sistema_optimizacion_rutas/domain/algoritmo_barrido.dart';
import 'package:sistema_optimizacion_rutas/domain/asignacion_vehiculos.dart';

// Caso calculado a mano (ver CLAUDE.md sección 7.2): depósito en (0,0), 3
// puntos al noreste (ángulo polar positivo, entre ~26° y ~63°) y 2 puntos al
// suroeste (ángulo negativo, ~-135° / ~-117°). Las demandas se eligieron para
// que el corte de capacidad (20) caiga justo en el límite entre sectores:
// SO (10+10=20) se cierra antes de que empiece NE (10+5+5=20).
const _deposito = Deposito(nombre: 'Oficina', latitud: 0, longitud: 0);

const _pNorEste1 = PuntoEntrega(
  nombre: 'NE-1',
  latitud: 1,
  longitud: 1,
  demanda: 5,
); // ángulo ~45°
const _pNorEste2 = PuntoEntrega(
  nombre: 'NE-2',
  latitud: 1,
  longitud: 2,
  demanda: 10,
); // ángulo ~26.6° (el más bajo del sector NE)
const _pNorEste3 = PuntoEntrega(
  nombre: 'NE-3',
  latitud: 2,
  longitud: 1,
  demanda: 5,
); // ángulo ~63.4°
const _pSurOeste1 = PuntoEntrega(
  nombre: 'SO-1',
  latitud: -1,
  longitud: -1,
  demanda: 10,
); // ángulo ~-135°
const _pSurOeste2 = PuntoEntrega(
  nombre: 'SO-2',
  latitud: -2,
  longitud: -1,
  demanda: 10,
); // ángulo ~-116.6°

// Puntos en el orden en que se declaran aquí (índices 0..4), usado para
// construir la matriz de distancias euclidianas (unidades sintéticas, no
// metros reales — el test no valida el orden interno de cada ruta, solo el
// agrupamiento por sector angular).
const _puntosEntrega = [
  _pNorEste1,
  _pNorEste2,
  _pNorEste3,
  _pSurOeste1,
  _pSurOeste2,
];

const _matrizDistancias = [
  // dep,   NE1,   NE2,   NE3,   SO1,   SO2
  [0.0, 1.414, 2.236, 2.236, 1.414, 2.236],
  [1.414, 0.0, 1.0, 1.0, 2.828, 3.606],
  [2.236, 1.0, 0.0, 1.414, 3.606, 4.243],
  [2.236, 1.0, 1.414, 0.0, 3.606, 4.472],
  [1.414, 2.828, 3.606, 3.606, 0.0, 1.0],
  [2.236, 3.606, 4.243, 4.472, 1.0, 0.0],
];

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
  test(
    'agrupa en la misma ruta los puntos de un mismo sector angular '
    '(CLAUDE.md 7.2)',
    () {
      final resultado = calcularRutasBarrido(
        deposito: _deposito,
        puntosEntrega: _puntosEntrega,
        matrizDistancias: _matrizDistancias,
        vehiculosDisponibles: const [
          Vehiculo(nombre: 'V1', capacidadMaxima: 20),
          Vehiculo(nombre: 'V2', capacidadMaxima: 20),
        ],
      );

      expect(resultado.rutas, hasLength(2));

      final rutaNorEste = _rutaQueContiene(resultado, _pNorEste1)!;
      final rutaSurOeste = _rutaQueContiene(resultado, _pSurOeste1)!;

      expect(
        rutaNorEste,
        containsAll([_pNorEste1, _pNorEste2, _pNorEste3]),
        reason: 'los 3 puntos al noreste deben quedar en la misma ruta',
      );
      expect(
        rutaSurOeste,
        containsAll([_pSurOeste1, _pSurOeste2]),
        reason: 'los 2 puntos al suroeste deben quedar en la misma ruta',
      );
      expect(rutaNorEste, isNot(contains(_pSurOeste1)));
      expect(rutaSurOeste, isNot(contains(_pNorEste1)));

      expect(resultado.flotaInsuficiente, isFalse);
    },
  );

  test('respeta la capacidad máxima en cada ruta formada', () {
    final resultado = calcularRutasBarrido(
      deposito: _deposito,
      puntosEntrega: _puntosEntrega,
      matrizDistancias: _matrizDistancias,
      vehiculosDisponibles: const [
        Vehiculo(nombre: 'V1', capacidadMaxima: 20),
        Vehiculo(nombre: 'V2', capacidadMaxima: 20),
      ],
    );

    for (final ruta in resultado.rutas) {
      expect(ruta.demandaTotal, lessThanOrEqualTo(20));
    }
  });
}
