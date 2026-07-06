import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_optimizacion_rutas/core/utils/geo_utils.dart';

void main() {
  test('decodificarPolyline — ejemplo canónico del algoritmo de Google', () {
    // https://developers.google.com/maps/documentation/utilities/polylinealgorithm
    final puntos = decodificarPolyline(r'_p~iF~ps|U_ulLnnqC_mqNvxq`@');

    expect(puntos, hasLength(3));
    expect(puntos[0].latitude, closeTo(38.5, 0.0001));
    expect(puntos[0].longitude, closeTo(-120.2, 0.0001));
    expect(puntos[1].latitude, closeTo(40.7, 0.0001));
    expect(puntos[1].longitude, closeTo(-120.95, 0.0001));
    expect(puntos[2].latitude, closeTo(43.252, 0.0001));
    expect(puntos[2].longitude, closeTo(-126.453, 0.0001));
  });

  test('decodificarPolyline — string vacío da lista vacía', () {
    expect(decodificarPolyline(''), isEmpty);
  });
}
