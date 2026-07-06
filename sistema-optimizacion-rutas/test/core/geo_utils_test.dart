import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
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

  group('rumboEntrePuntos', () {
    test('hacia el norte da ~0°', () {
      final rumbo = rumboEntrePuntos(lat1: 0, lon1: 0, lat2: 1, lon2: 0);
      expect(rumbo, closeTo(0, 0.1));
    });

    test('hacia el este da ~90°', () {
      final rumbo = rumboEntrePuntos(lat1: 0, lon1: 0, lat2: 0, lon2: 1);
      expect(rumbo, closeTo(90, 0.1));
    });

    test('hacia el sur da ~180°', () {
      final rumbo = rumboEntrePuntos(lat1: 1, lon1: 0, lat2: 0, lon2: 0);
      expect(rumbo, closeTo(180, 0.1));
    });

    test('hacia el oeste da ~270°', () {
      final rumbo = rumboEntrePuntos(lat1: 0, lon1: 1, lat2: 0, lon2: 0);
      expect(rumbo, closeTo(270, 0.1));
    });
  });

  group('muestrearFlechasEnRuta', () {
    test('con menos de 2 puntos, no hay flechas', () {
      expect(muestrearFlechasEnRuta(const [LatLng(0, 0)]), isEmpty);
      expect(muestrearFlechasEnRuta(const []), isEmpty);
    });

    test('con todos los puntos iguales (largo cero), no hay flechas', () {
      final puntos = List.filled(5, const LatLng(-8.37, -74.55));
      expect(muestrearFlechasEnRuta(puntos), isEmpty);
    });

    test('una línea recta hacia el este da flechas con rumbo ~90°', () {
      final puntos = List.generate(6, (i) => LatLng(0, i * 0.02));

      final flechas = muestrearFlechasEnRuta(puntos);

      expect(flechas, isNotEmpty);
      expect(flechas.length, lessThanOrEqualTo(20));
      for (final flecha in flechas) {
        expect(flecha.rumboGrados, closeTo(90, 0.5));
      }
    });

    test('la cantidad de flechas respeta el mínimo y el máximo', () {
      // Ruta muy corta (unos pocos metros): al menos `minimo`.
      final rutaCorta = [const LatLng(0, 0), const LatLng(0.0001, 0.0001)];
      expect(
        muestrearFlechasEnRuta(rutaCorta, minimo: 3, maximo: 20).length,
        3,
      );

      // Ruta muy larga: no más de `maximo`.
      final rutaLarga = List.generate(200, (i) => LatLng(0, i * 0.05));
      expect(
        muestrearFlechasEnRuta(rutaLarga, minimo: 3, maximo: 20).length,
        20,
      );
    });
  });
}
