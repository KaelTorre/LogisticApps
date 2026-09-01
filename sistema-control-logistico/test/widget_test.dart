import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sistema_control_logistico/core/estado/organizacion_activa.dart';
import 'package:sistema_control_logistico/data/local/database.dart';
import 'package:sistema_control_logistico/data/repositories/organizacion_repository.dart';
import 'package:sistema_control_logistico/main.dart';
import 'package:sistema_control_logistico/ui/pantallas/inicio/inicio_screen.dart';

void main() {
  testWidgets('Test de humo: la app arranca y muestra la pantalla de inicio', (
    WidgetTester tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<OrganizacionRepository>(create: (_) => OrganizacionRepository(database)),
          ChangeNotifierProvider<OrganizacionActiva>(create: (_) => OrganizacionActiva()),
        ],
        child: const SistemaControlLogisticoApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(InicioScreen), findsOneWidget);
    expect(find.text('Crear organización'), findsOneWidget);
  });
}
