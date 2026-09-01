import 'package:flutter_test/flutter_test.dart';

import 'package:sistema_control_logistico/main.dart';
import 'package:sistema_control_logistico/ui/pantallas/inicio/inicio_screen.dart';

void main() {
  testWidgets('Test de humo: la app arranca y muestra la pantalla de inicio', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SistemaControlLogisticoApp());
    await tester.pumpAndSettle();

    expect(find.byType(InicioScreen), findsOneWidget);
    expect(find.text('Control logístico'), findsOneWidget);
  });
}
