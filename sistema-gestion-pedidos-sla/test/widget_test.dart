import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sistema_gestion_pedidos_sla/core/theme.dart';
import 'package:sistema_gestion_pedidos_sla/data/local/database.dart';
import 'package:sistema_gestion_pedidos_sla/data/repositories/cliente_repository.dart';
import 'package:sistema_gestion_pedidos_sla/data/repositories/pedido_repository.dart';
import 'package:sistema_gestion_pedidos_sla/data/repositories/producto_repository.dart';
import 'package:sistema_gestion_pedidos_sla/presentation/providers/pedido_provider.dart';
import 'package:sistema_gestion_pedidos_sla/presentation/screens/home/home_screen.dart';

/// Smoke test: con la base de datos vacía, Home muestra los módulos y
/// entrar a Pedidos muestra el estado vacío ("Aún no tienes pedidos") en
/// vez de una pantalla en blanco o un error (CLAUDE.md §11).
void main() {
  testWidgets('Home carga y Pedidos muestra el estado vacío', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    final pedidoRepository = PedidoRepository(database);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<AppDatabase>.value(value: database),
          Provider<ClienteRepository>.value(value: ClienteRepository(database)),
          Provider<ProductoRepository>.value(
            value: ProductoRepository(database),
          ),
          Provider<PedidoRepository>.value(value: pedidoRepository),
          ChangeNotifierProvider(
            create: (_) => PedidoProvider(pedidoRepository),
          ),
        ],
        child: MaterialApp(
          theme: buildLightTheme(),
          home: const HomeScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Pedidos'), findsOneWidget);

    await tester.tap(find.text('Pedidos'));
    await tester.pumpAndSettle();

    expect(find.text('Todavía no tienes pedidos.'), findsOneWidget);
  });
}
