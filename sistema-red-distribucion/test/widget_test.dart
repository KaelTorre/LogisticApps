import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_red_distribucion/main.dart';

void main() {
  testWidgets('la app arranca y muestra el título', (WidgetTester tester) async {
    await tester.pumpWidget(const SistemaRedDistribucionApp());

    expect(find.text('Sistema de Red de Distribución'), findsOneWidget);
  });
}
