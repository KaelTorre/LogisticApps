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
