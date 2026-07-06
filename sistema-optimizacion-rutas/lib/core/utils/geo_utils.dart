import 'dart:math';

import 'package:latlong2/latlong.dart';

/// Radio medio de la Tierra en kilómetros, usado por [distanciaHaversineKm].
const double _radioTierraKm = 6371.0;

/// Ángulo polar (en radianes) de un punto respecto a un origen, usado por el
/// método de Barrido (sección 7.2 de CLAUDE.md) para ordenar los puntos de
/// entrega alrededor del depósito.
double anguloPolar({
  required double latOrigen,
  required double lonOrigen,
  required double latPunto,
  required double lonPunto,
}) {
  return atan2(latPunto - latOrigen, lonPunto - lonOrigen);
}

/// Distancia en línea recta (fórmula de Haversine) entre dos coordenadas, en
/// kilómetros. Sirve como respaldo cuando no hay una distancia real de OSRM
/// disponible (por ejemplo, sin conexión y sin caché previa).
double distanciaHaversineKm({
  required double lat1,
  required double lon1,
  required double lat2,
  required double lon2,
}) {
  final dLat = _gradosARadianes(lat2 - lat1);
  final dLon = _gradosARadianes(lon2 - lon1);
  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_gradosARadianes(lat1)) *
          cos(_gradosARadianes(lat2)) *
          sin(dLon / 2) *
          sin(dLon / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return _radioTierraKm * c;
}

double _gradosARadianes(double grados) => grados * pi / 180.0;

/// Decodifica el string de polyline codificado que devuelve OSRM en
/// `/route/` (algoritmo estándar de Google, precisión 5 — ver CLAUDE.md
/// sección 6.2) a una lista de puntos consumible por `flutter_map`.
List<LatLng> decodificarPolyline(String codificado) {
  final puntos = <LatLng>[];
  var indice = 0;
  var lat = 0;
  var lon = 0;

  int leerDelta() {
    var resultado = 0;
    var desplazamiento = 0;
    int byte;
    do {
      byte = codificado.codeUnitAt(indice++) - 63;
      resultado |= (byte & 0x1f) << desplazamiento;
      desplazamiento += 5;
    } while (byte >= 0x20);
    return (resultado & 1) != 0 ? ~(resultado >> 1) : (resultado >> 1);
  }

  while (indice < codificado.length) {
    lat += leerDelta();
    lon += leerDelta();
    puntos.add(LatLng(lat / 1e5, lon / 1e5));
  }

  return puntos;
}

/// Rumbo inicial (en grados, 0=norte, sentido horario) desde `(lat1,lon1)`
/// hacia `(lat2,lon2)` — fórmula estándar de rumbo entre dos coordenadas.
/// Usado para orientar las flechas de dirección sobre una polyline.
double rumboEntrePuntos({
  required double lat1,
  required double lon1,
  required double lat2,
  required double lon2,
}) {
  final phi1 = _gradosARadianes(lat1);
  final phi2 = _gradosARadianes(lat2);
  final deltaLambda = _gradosARadianes(lon2 - lon1);
  final y = sin(deltaLambda) * cos(phi2);
  final x = cos(phi1) * sin(phi2) - sin(phi1) * cos(phi2) * cos(deltaLambda);
  final theta = atan2(y, x);
  return (theta * 180 / pi + 360) % 360;
}

/// Un punto sobre una ruta con el rumbo (dirección) hacia el que avanza en
/// ese tramo, para dibujar una flecha orientada.
class PuntoConRumbo {
  const PuntoConRumbo({required this.punto, required this.rumboGrados});

  final LatLng punto;
  final double rumboGrados;
}

/// Muestrea puntos espaciados uniformemente a lo largo de [puntosRuta] (la
/// polyline ya decodificada) para dibujar flechas de dirección — sin esto,
/// una polyline se ve como una línea plana sin indicar hacia dónde avanza el
/// vehículo (pedido explícito de UX). La cantidad de flechas escala con la
/// longitud real de la ruta: ~1 cada [intervaloKm] km, entre [minimo] y
/// [maximo].
List<PuntoConRumbo> muestrearFlechasEnRuta(
  List<LatLng> puntosRuta, {
  double intervaloKm = 2.0,
  int minimo = 3,
  int maximo = 20,
}) {
  if (puntosRuta.length < 2) return const [];

  final distanciasAcumuladas = <double>[0];
  for (var i = 1; i < puntosRuta.length; i++) {
    final anterior = puntosRuta[i - 1];
    final actual = puntosRuta[i];
    distanciasAcumuladas.add(
      distanciasAcumuladas.last +
          distanciaHaversineKm(
            lat1: anterior.latitude,
            lon1: anterior.longitude,
            lat2: actual.latitude,
            lon2: actual.longitude,
          ),
    );
  }

  final largoTotalKm = distanciasAcumuladas.last;
  if (largoTotalKm <= 0) return const [];

  final cantidad = (largoTotalKm / intervaloKm).round().clamp(minimo, maximo);
  final resultado = <PuntoConRumbo>[];
  var indiceSegmento = 0;

  for (var k = 1; k <= cantidad; k++) {
    final objetivo = largoTotalKm * k / (cantidad + 1);
    while (indiceSegmento < distanciasAcumuladas.length - 2 &&
        distanciasAcumuladas[indiceSegmento + 1] < objetivo) {
      indiceSegmento++;
    }

    final p0 = puntosRuta[indiceSegmento];
    final p1 = puntosRuta[indiceSegmento + 1];
    final d0 = distanciasAcumuladas[indiceSegmento];
    final d1 = distanciasAcumuladas[indiceSegmento + 1];
    final t = d1 > d0 ? ((objetivo - d0) / (d1 - d0)).clamp(0.0, 1.0) : 0.0;

    resultado.add(
      PuntoConRumbo(
        punto: LatLng(
          p0.latitude + (p1.latitude - p0.latitude) * t,
          p0.longitude + (p1.longitude - p0.longitude) * t,
        ),
        rumboGrados: rumboEntrePuntos(
          lat1: p0.latitude,
          lon1: p0.longitude,
          lat2: p1.latitude,
          lon2: p1.longitude,
        ),
      ),
    );
  }

  return resultado;
}
