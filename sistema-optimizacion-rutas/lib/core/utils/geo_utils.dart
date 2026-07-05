import 'dart:math';

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
