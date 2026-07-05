import 'package:flutter_test/flutter_test.dart';

import 'package:sistema_optimizacion_rutas/main.dart';

void main() {
  testWidgets('La app arranca y muestra la pantalla de inicio',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SistemaOptimizacionRutasApp());
    await tester.pumpAndSettle();

    expect(find.text('Optimización de Rutas VRP'), findsOneWidget);
  });
}
