import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistema_diseno_almacenes/core/tour/tour_controller.dart';

void main() {
  group('TourController', () {
    test('iniciarSiEsPrimeraVez activa el recorrido si nunca se vio', () async {
      SharedPreferences.setMockInitialValues({});
      final tour = TourController(await SharedPreferences.getInstance());

      expect(tour.yaVisto, isFalse);
      tour.iniciarSiEsPrimeraVez();
      expect(tour.activo, isTrue);
      expect(tour.pasoActual, PasoTour.entrada);
    });

    test('iniciarSiEsPrimeraVez no hace nada si ya se vio antes', () async {
      SharedPreferences.setMockInitialValues({'induccion_guiada_vista': true});
      final tour = TourController(await SharedPreferences.getInstance());

      tour.iniciarSiEsPrimeraVez();
      expect(tour.activo, isFalse);
    });

    test('irA solo cambia el paso mientras el recorrido está activo', () async {
      SharedPreferences.setMockInitialValues({});
      final tour = TourController(await SharedPreferences.getInstance());

      // Inactivo: irA no debe tener efecto.
      tour.irA(PasoTour.ficha);
      expect(tour.pasoActual, PasoTour.entrada);

      tour.iniciar();
      tour.irA(PasoTour.ficha);
      expect(tour.pasoActual, PasoTour.ficha);

      tour.irA(PasoTour.plano);
      expect(tour.pasoActual, PasoTour.plano);
    });

    test('terminar desactiva el recorrido y persiste que ya se vio', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final tour = TourController(prefs);

      tour.iniciar();
      expect(tour.activo, isTrue);

      tour.terminar();
      expect(tour.activo, isFalse);
      expect(tour.yaVisto, isTrue);
      expect(prefs.getBool('induccion_guiada_vista'), isTrue);
    });

    test('iniciar (el botón de ayuda) reactiva el recorrido aunque ya se haya visto', () async {
      SharedPreferences.setMockInitialValues({'induccion_guiada_vista': true});
      final tour = TourController(await SharedPreferences.getInstance());

      expect(tour.yaVisto, isTrue);
      tour.iniciar();
      expect(tour.activo, isTrue);
      expect(tour.pasoActual, PasoTour.entrada);
    });

    test('notifica a los listeners en cada cambio de estado', () async {
      SharedPreferences.setMockInitialValues({});
      final tour = TourController(await SharedPreferences.getInstance());

      var notificaciones = 0;
      tour.addListener(() => notificaciones++);

      tour.iniciar();
      tour.irA(PasoTour.ficha);
      tour.terminar();

      expect(notificaciones, 3);
    });
  });
}
