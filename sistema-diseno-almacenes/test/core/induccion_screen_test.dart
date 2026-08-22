import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistema_diseno_almacenes/core/tour/induccion_screen.dart';
import 'package:sistema_diseno_almacenes/core/tour/tour_controller.dart';

void main() {
  Future<TourController> tourVacio() async {
    SharedPreferences.setMockInitialValues({});
    return TourController(await SharedPreferences.getInstance());
  }

  testWidgets('empieza en el paso 1 y "Siguiente" avanza sin romperse', (tester) async {
    final tour = await tourVacio();
    await tester.pumpWidget(MaterialApp(home: InduccionScreen(tour: tour)));
    await tester.pumpAndSettle();

    expect(find.textContaining('paso 1 de'), findsOneWidget);
    expect(find.text('Bienvenido al Sistema de Diseño de Almacenes'), findsOneWidget);
    // El primer paso no tiene botón "Atrás".
    expect(find.text('Atrás'), findsNothing);

    await tester.tap(find.text('Siguiente'));
    await tester.pumpAndSettle();

    expect(find.textContaining('paso 2 de'), findsOneWidget);
    expect(find.text('La pantalla de entrada'), findsOneWidget);
    expect(find.text('Atrás'), findsOneWidget);
  });

  testWidgets('"Atrás" retrocede sin perder el estado', (tester) async {
    final tour = await tourVacio();
    await tester.pumpWidget(MaterialApp(home: InduccionScreen(tour: tour)));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Siguiente'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Siguiente'));
    await tester.pumpAndSettle();
    expect(find.textContaining('paso 3 de'), findsOneWidget);

    await tester.tap(find.text('Atrás'));
    await tester.pumpAndSettle();
    expect(find.textContaining('paso 2 de'), findsOneWidget);
    expect(find.text('La pantalla de entrada'), findsOneWidget);
  });

  testWidgets('"Saltar" cierra la pantalla y marca la inducción como vista', (tester) async {
    final tour = await tourVacio();
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: FilledButton(
                onPressed: () => Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => InduccionScreen(tour: tour))),
                child: const Text('abrir'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();

    expect(tour.yaVisto, isFalse);
    await tester.tap(find.text('Saltar'));
    await tester.pumpAndSettle();

    expect(tour.yaVisto, isTrue);
    expect(find.byType(InduccionScreen), findsNothing);
  });

  testWidgets('recorre los 24 pasos hasta el final sin excepciones, y "Terminar" marca vista', (
    tester,
  ) async {
    final tour = await tourVacio();
    await tester.pumpWidget(MaterialApp(home: InduccionScreen(tour: tour)));
    await tester.pumpAndSettle();

    // Bound generoso: si algún día se agregan pasos, este límite evita un
    // bucle infinito por error de programación en vez de fallar con una
    // pista clara.
    for (var i = 0; i < 40; i++) {
      final esUltimo = find.text('Terminar').evaluate().isNotEmpty;
      if (esUltimo) break;
      await tester.tap(find.text('Siguiente'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }

    expect(find.text('Terminar'), findsOneWidget);
    expect(find.text('Listo'), findsOneWidget);

    await tester.tap(find.text('Terminar'));
    await tester.pumpAndSettle();
    expect(tour.yaVisto, isTrue);
  });
}
