import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_diseno_almacenes/data/local/database.dart';
import 'package:sistema_diseno_almacenes/data/seed/catalogo_seed_loader.dart';
import 'package:sistema_diseno_almacenes/ui/pantallas/entrada_calculo/entrada_calculo_screen.dart';

void main() {
  testWidgets('la pantalla de entrada carga el catálogo, calcula y navega a la ficha', (
    tester,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());
    await CatalogoSeedLoader(db).cargar();

    await tester.pumpWidget(MaterialApp(home: EntradaCalculoScreen(db: db)));
    await tester.pumpAndSettle();

    expect(find.text('Cálculo rápido — M2 + M3'), findsOneWidget);

    // El formulario es más alto que el viewport: hay que hacer scroll para
    // que el botón exista en el árbol (el ListView es un sliver, solo
    // construye lo que cae dentro del viewport + cache extent). Cada
    // TextField trae su propio Scrollable interno, así que no sirve
    // buscarlo por tipo — se arrastra el ListView directamente.
    for (var intentos = 0; intentos < 10 && find.text('Calcular').evaluate().isEmpty; intentos++) {
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pump();
    }
    expect(find.text('Calcular'), findsOneWidget);

    await tester.tap(find.text('Calcular'));
    await tester.pumpAndSettle();

    expect(find.text('Ficha técnica'), findsOneWidget);
    expect(find.text('Resumen'), findsOneWidget);
    expect(find.text('Memoria de cálculo'), findsOneWidget);

    await db.close();
  });
}
