import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sistema_red_distribucion/data/local/database.dart';
import 'package:sistema_red_distribucion/data/models/proyecto.dart';
import 'package:sistema_red_distribucion/data/repositories/cliente_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/proyecto_repository.dart';
import 'package:sistema_red_distribucion/ui/pantallas/clientes/cliente_form_screen.dart';

Widget _envolver(Widget hijo, AppDatabase database) {
  return MultiProvider(
    providers: [
      Provider<ClienteRepository>(create: (_) => ClienteRepository(database)),
    ],
    child: MaterialApp(home: hijo),
  );
}

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  testWidgets('rechaza una latitud de 91 (fuera de rango)', (tester) async {
    await tester.pumpWidget(
      _envolver(const ClienteFormScreen(proyectoId: 1), database),
    );

    await tester.enterText(find.byKey(const Key('campo_latitud')), '91');
    await tester.enterText(find.byKey(const Key('campo_longitud')), '0');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(find.text('Debe estar entre -90 y 90.'), findsOneWidget);
    // No debe haber navegado (el guardado exitoso hace pop de la pantalla).
    expect(find.byType(ClienteFormScreen), findsOneWidget);
  });

  testWidgets('rechaza una longitud de -181 (fuera de rango)', (tester) async {
    await tester.pumpWidget(
      _envolver(const ClienteFormScreen(proyectoId: 1), database),
    );

    await tester.enterText(find.byKey(const Key('campo_latitud')), '0');
    await tester.enterText(find.byKey(const Key('campo_longitud')), '-181');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(find.text('Debe estar entre -180 y 180.'), findsOneWidget);
    expect(find.byType(ClienteFormScreen), findsOneWidget);
  });

  testWidgets('acepta coordenadas dentro de rango y guarda el cliente', (tester) async {
    final proyectoId = await ProyectoRepository(database).crear(
      Proyecto(nombre: 'P', creadoEn: DateTime(2026, 1, 1).toIso8601String()),
    );

    await tester.pumpWidget(
      _envolver(ClienteFormScreen(proyectoId: proyectoId), database),
    );

    await tester.enterText(find.byKey(const Key('campo_latitud')), '-8.37');
    await tester.enterText(find.byKey(const Key('campo_longitud')), '-74.55');
    await tester.enterText(find.byType(TextFormField).first, 'Cliente de prueba');
    await tester.enterText(find.widgetWithText(TextFormField, 'Demanda anual'), '100');
    await tester.enterText(find.widgetWithText(TextFormField, 'Pedidos anuales'), '10');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    final clientes = await ClienteRepository(database).obtenerPorProyecto(proyectoId);
    expect(clientes, hasLength(1));
    expect(clientes.first.latitud, -8.37);
    expect(clientes.first.longitud, -74.55);
  });
}
