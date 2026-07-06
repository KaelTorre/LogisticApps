import 'package:latlong2/latlong.dart';

/// Límites reales documentados por Google para "Maps URLs" (`api=1`, sin
/// API key): https://developers.google.com/maps/documentation/urls/get-started
/// "up to three waypoints supported on mobile browsers, and a maximum of
/// nine waypoints supported otherwise". No hay forma de saber en tiempo de
/// build en qué contexto se abrirá el link, así que se usa el techo de
/// escritorio (9) y se advierte del caso móvil por separado.
const int limiteWaypointsGoogleMaps = 9;
const int limiteWaypointsGoogleMapsMovil = 3;

/// Arma el link de Google Maps (ida y vuelta al depósito, pasando por
/// [paradas] en orden) usando el esquema público "Maps URLs" — no requiere
/// API key. Si hay más de [limiteWaypointsGoogleMaps] paradas, se recortan a
/// las primeras (Google Maps ignora o falla con más).
Uri construirUrlGoogleMaps({
  required LatLng deposito,
  required List<LatLng> paradas,
}) {
  final paradasIncluidas = paradas.take(limiteWaypointsGoogleMaps).toList();
  final origenDestino = '${deposito.latitude},${deposito.longitude}';

  return Uri.https('www.google.com', '/maps/dir/', {
    'api': '1',
    'origin': origenDestino,
    'destination': origenDestino,
    if (paradasIncluidas.isNotEmpty)
      'waypoints': paradasIncluidas
          .map((p) => '${p.latitude},${p.longitude}')
          .join('|'),
    'travelmode': 'driving',
  });
}
