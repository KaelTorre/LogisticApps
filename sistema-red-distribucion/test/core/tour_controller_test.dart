import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistema_red_distribucion/core/tour/tour_controller.dart';

void main() {
  group('TourController', () {
    test('yaVisto es false si nunca se marcó', () async {
      SharedPreferences.setMockInitialValues({});
      final tour = TourController(await SharedPreferences.getInstance());
      expect(tour.yaVisto, isFalse);
    });

    test('yaVisto es true si la bandera ya estaba guardada', () async {
      SharedPreferences.setMockInitialValues({'induccion_guiada_vista': true});
      final tour = TourController(await SharedPreferences.getInstance());
      expect(tour.yaVisto, isTrue);
    });

    test('marcarVisto persiste la bandera', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final tour = TourController(prefs);

      expect(tour.yaVisto, isFalse);
      await tour.marcarVisto();
      expect(tour.yaVisto, isTrue);
      expect(prefs.getBool('induccion_guiada_vista'), isTrue);
    });
  });
}
