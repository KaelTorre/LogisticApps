import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme.dart';
import 'data/local/database.dart';
import 'data/local/respaldo_service.dart';
import 'data/repositories/cliente_repository.dart';
import 'data/repositories/configuracion_repository.dart';
import 'data/repositories/pedido_repository.dart';
import 'data/repositories/producto_repository.dart';
import 'presentation/providers/abc_provider.dart';
import 'presentation/providers/dashboard_provider.dart';
import 'presentation/providers/optimizacion_servicio_provider.dart';
import 'presentation/providers/pedido_provider.dart';
import 'presentation/providers/respaldo_provider.dart';
import 'presentation/providers/taguchi_provider.dart';
import 'presentation/screens/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase();
  final clienteRepository = ClienteRepository(database);
  final productoRepository = ProductoRepository(database);
  final pedidoRepository = PedidoRepository(database);
  final configuracionRepository = ConfiguracionRepository(database);
  final respaldoService = RespaldoService(database);

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: database),
        Provider<ClienteRepository>.value(value: clienteRepository),
        Provider<ProductoRepository>.value(value: productoRepository),
        Provider<PedidoRepository>.value(value: pedidoRepository),
        Provider<ConfiguracionRepository>.value(value: configuracionRepository),
        Provider<RespaldoService>.value(value: respaldoService),
        ChangeNotifierProvider(
          create: (_) => PedidoProvider(pedidoRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => AbcProvider(
            pedidoRepository: pedidoRepository,
            productoRepository: productoRepository,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              OptimizacionServicioProvider(configuracionRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => TaguchiProvider(configuracionRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => DashboardProvider(
            pedidoRepository: pedidoRepository,
            configuracionRepository: configuracionRepository,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => RespaldoProvider(respaldoService),
        ),
      ],
      child: const SistemaGestionPedidosSlaApp(),
    ),
  );
}

class SistemaGestionPedidosSlaApp extends StatelessWidget {
  const SistemaGestionPedidosSlaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema de Gestión de Pedidos con Nivel de Servicio',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
