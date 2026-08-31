import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistema_red_distribucion/core/tour/tour_controller.dart';
import 'package:sistema_red_distribucion/data/local/database.dart';
import 'package:sistema_red_distribucion/data/repositories/proyecto_repository.dart';
import 'package:sistema_red_distribucion/main.dart';

void main() {
  testWidgets('la app arranca y muestra la pantalla de proyectos', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    // Inducción ya vista: si no, el primer arranque la abriría automáticamente
    // (ver ProyectosScreen.initState) y taparía la pantalla que este test
    // quiere comprobar.
    SharedPreferences.setMockInitialValues({'induccion_guiada_vista': true});
    final tour = TourController(await SharedPreferences.getInstance());

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<ProyectoRepository>(create: (_) => ProyectoRepository(database)),
          Provider<TourController>.value(value: tour),
        ],
        child: const SistemaRedDistribucionApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sistema de Red de Distribución'), findsOneWidget);
    expect(find.text('Todavía no hay proyectos.'), findsOneWidget);
  });
}
