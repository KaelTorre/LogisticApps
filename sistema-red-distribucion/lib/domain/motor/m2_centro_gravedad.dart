import 'dart:math';

import 'package:paquete_geo_logistica/paquete_geo_logistica.dart';

import '../../data/models/zona_demanda.dart';

/// Un punto candidato sugerido por M2 — no lleva más datos porque el
/// resultado **no es una decisión** (CLAUDE.md sección 7): quien llama lo
/// inserta como `sitio_candidato` con `origen = 'centro_gravedad'` y el
/// costo fijo/capacidad los completa el usuario.
class PuntoGravedad {
  const PuntoGravedad({required this.latitud, required this.longitud});

  final double latitud;
  final double longitud;
}

/// M2 — centro de gravedad exacto (Weiszfeld) de un conjunto de zonas de
/// demanda, ponderado por `V_i · R_i` (volumen de la zona por la tarifa de
/// salida). Si la tarifa es la misma para todas las zonas — el único caso
/// que este proyecto modela hoy, `parametros_costo` es una fila por
/// proyecto — el factor se cancela algebraicamente en la fórmula y el
/// resultado equivale a ponderar solo por volumen; se deja el parámetro
/// igual para que la fórmula quede idéntica a la de CLAUDE.md sección 7 y
/// sea trivial de extender el día que haya tarifas por zona.
///
/// [REGLA] Distancias con haversine, nunca el servicio de ruteo (mismo
/// motivo que M1: es una sugerencia continua, no una consulta puntual).
PuntoGravedad centroGravedadExacto({
  required List<ZonaDemanda> zonas,
  required double tarifaCentPorKmTon,
  double toleranciaKm = 1e-6,
  int maxIteraciones = 500,
}) {
  assert(zonas.isNotEmpty, 'centroGravedadExacto necesita al menos una zona');

  // Centro de gravedad simple (promedio ponderado por V·R) como arranque.
  final inicial = _centroGravedadSimple(zonas, tarifaCentPorKmTon);
  var x = inicial.$1;
  var y = inicial.$2;

  for (var iteracion = 0; iteracion < maxIteraciones; iteracion++) {
    var sumaPesoX = 0.0;
    var sumaPesoY = 0.0;
    var sumaPeso = 0.0;

    for (final zona in zonas) {
      var distanciaKm = distanciaHaversineKm(lat1: x, lon1: y, lat2: zona.latitud, lon2: zona.longitud);
      if (distanciaKm == 0) distanciaKm = 1e-9; // evitar división por cero

      final peso = (zona.demandaAgregada * tarifaCentPorKmTon) / distanciaKm;
      sumaPesoX += peso * zona.latitud;
      sumaPesoY += peso * zona.longitud;
      sumaPeso += peso;
    }

    final nuevoX = sumaPesoX / sumaPeso;
    final nuevoY = sumaPesoY / sumaPeso;
    final desplazamientoKm = distanciaHaversineKm(lat1: x, lon1: y, lat2: nuevoX, lon2: nuevoY);

    x = nuevoX;
    y = nuevoY;

    if (desplazamientoKm < toleranciaKm) break;
  }

  return PuntoGravedad(latitud: x, longitud: y);
}

(double, double) _centroGravedadSimple(List<ZonaDemanda> zonas, double tarifa) {
  var sumaPesoX = 0.0;
  var sumaPesoY = 0.0;
  var sumaPeso = 0.0;
  for (final zona in zonas) {
    final peso = zona.demandaAgregada * tarifa;
    sumaPesoX += peso * zona.latitud;
    sumaPesoY += peso * zona.longitud;
    sumaPeso += peso;
  }
  return (sumaPesoX / sumaPeso, sumaPesoY / sumaPeso);
}

/// Múltiples centros de gravedad (CLAUDE.md sección 7): asigna zonas al
/// centro más cercano, recalcula cada centro con Weiszfeld sobre sus zonas,
/// repite hasta que las asignaciones no cambien. `p` es la cantidad de
/// candidatos a generar. Determinista vía [semilla] (mismo patrón que M1).
List<PuntoGravedad> generarCandidatosPorCentroGravedad({
  required List<ZonaDemanda> zonas,
  required double tarifaCentPorKmTon,
  required int p,
  int semilla = 42,
  int maxIteracionesAsignacion = 100,
}) {
  assert(zonas.isNotEmpty, 'generarCandidatosPorCentroGravedad necesita al menos una zona');

  if (p <= 1 || zonas.length <= p) {
    if (zonas.length <= p) {
      return zonas
          .map((z) => PuntoGravedad(latitud: z.latitud, longitud: z.longitud))
          .toList();
    }
    return [centroGravedadExacto(zonas: zonas, tarifaCentPorKmTon: tarifaCentPorKmTon)];
  }

  final random = Random(semilla);
  var centros = _inicializarCentros(zonas, p, random);
  var asignacionAnterior = List<int>.filled(zonas.length, -1);

  for (var iteracion = 0; iteracion < maxIteracionesAsignacion; iteracion++) {
    final asignacion = [
      for (final zona in zonas) _centroMasCercano(zona, centros),
    ];

    if (iteracion > 0 && _listasIguales(asignacion, asignacionAnterior)) break;
    asignacionAnterior = asignacion;

    centros = [
      for (var c = 0; c < p; c++)
        _recalcularCentro(zonas, asignacion, c, centros[c], tarifaCentPorKmTon),
    ];
  }

  return centros.map((c) => PuntoGravedad(latitud: c.$1, longitud: c.$2)).toList();
}

List<(double, double)> _inicializarCentros(List<ZonaDemanda> zonas, int p, Random random) {
  final centros = <(double, double)>[];
  final primera = zonas[random.nextInt(zonas.length)];
  centros.add((primera.latitud, primera.longitud));

  while (centros.length < p) {
    final distanciasCuadrado = zonas.map((zona) {
      var minima = double.infinity;
      for (final centro in centros) {
        final d = distanciaHaversineKm(lat1: zona.latitud, lon1: zona.longitud, lat2: centro.$1, lon2: centro.$2);
        if (d < minima) minima = d;
      }
      return minima * minima;
    }).toList();

    final sumaTotal = distanciasCuadrado.fold(0.0, (s, d) => s + d);
    if (sumaTotal <= 0) {
      final elegida = zonas[random.nextInt(zonas.length)];
      centros.add((elegida.latitud, elegida.longitud));
      continue;
    }

    var objetivo = random.nextDouble() * sumaTotal;
    var elegidoIndice = zonas.length - 1;
    for (var i = 0; i < distanciasCuadrado.length; i++) {
      objetivo -= distanciasCuadrado[i];
      if (objetivo <= 0) {
        elegidoIndice = i;
        break;
      }
    }
    centros.add((zonas[elegidoIndice].latitud, zonas[elegidoIndice].longitud));
  }

  return centros;
}

int _centroMasCercano(ZonaDemanda zona, List<(double, double)> centros) {
  var mejorIndice = 0;
  var mejorDistancia = double.infinity;
  for (var i = 0; i < centros.length; i++) {
    final d = distanciaHaversineKm(lat1: zona.latitud, lon1: zona.longitud, lat2: centros[i].$1, lon2: centros[i].$2);
    if (d < mejorDistancia) {
      mejorDistancia = d;
      mejorIndice = i;
    }
  }
  return mejorIndice;
}

(double, double) _recalcularCentro(
  List<ZonaDemanda> zonas,
  List<int> asignacion,
  int indiceCentro,
  (double, double) centroAnterior,
  double tarifa,
) {
  final miembros = [
    for (var i = 0; i < zonas.length; i++)
      if (asignacion[i] == indiceCentro) zonas[i],
  ];
  if (miembros.isEmpty) return centroAnterior;
  final punto = centroGravedadExacto(zonas: miembros, tarifaCentPorKmTon: tarifa);
  return (punto.latitud, punto.longitud);
}

bool _listasIguales(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
