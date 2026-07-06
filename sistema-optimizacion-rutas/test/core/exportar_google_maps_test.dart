import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:sistema_optimizacion_rutas/core/exportar_google_maps.dart';

void main() {
  const deposito = LatLng(-8.375482, -74.556342);

  test('arma origin/destination en el depósito (ida y vuelta)', () {
    final uri = construirUrlGoogleMaps(deposito: deposito, paradas: const []);

    expect(uri.host, 'www.google.com');
    expect(uri.path, '/maps/dir/');
    expect(uri.queryParameters['api'], '1');
    expect(uri.queryParameters['origin'], '-8.375482,-74.556342');
    expect(uri.queryParameters['destination'], '-8.375482,-74.556342');
    expect(uri.queryParameters['travelmode'], 'driving');
  });

  test('codifica los waypoints separados por | (queda como %7C en la URL)', () {
    final uri = construirUrlGoogleMaps(
      deposito: deposito,
      paradas: const [LatLng(-8.39, -74.57), LatLng(-8.38, -74.56)],
    );

    expect(
      uri.queryParameters['waypoints'],
      '-8.39,-74.57|-8.38,-74.56',
    );
    expect(uri.toString(), contains('%7C'));
  });

  test(
    'recorta a $limiteWaypointsGoogleMaps waypoints si hay más '
    '(límite real de Google Maps URLs)',
    () {
      final paradas = List.generate(15, (i) => LatLng(-8.0 - i, -74.0 - i));

      final uri = construirUrlGoogleMaps(
        deposito: deposito,
        paradas: paradas,
      );

      final waypoints = uri.queryParameters['waypoints']!.split('|');
      expect(waypoints, hasLength(limiteWaypointsGoogleMaps));
    },
  );
}
