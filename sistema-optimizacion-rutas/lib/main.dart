import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/pucallpa_dataset.dart';
import 'core/theme.dart';
import 'data/local/database.dart';
import 'data/remote/osrm_client.dart';
import 'data/repositories/deposito_repository.dart';
import 'data/repositories/historial_repository.dart';
import 'data/repositories/punto_entrega_repository.dart';
import 'data/repositories/vehiculo_repository.dart';
import 'presentation/screens/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase();
  final depositoRepository = DepositoRepository(database);
  final puntoEntregaRepository = PuntoEntregaRepository(database);
  final vehiculoRepository = VehiculoRepository(database);
  final historialRepository = HistorialRepository(database);

  // Siembra el dataset de prueba/precargado (sección 9, Fase 0 de CLAUDE.md)
  // solo si la base está vacía — nunca pisa datos que el usuario ya creó.
  await depositoRepository.sembrarSiVacio(depositoSemillaOficina);
  await puntoEntregaRepository.sembrarSiVacio(puntosEntregaSemillaPucallpa);
  await vehiculoRepository.sembrarSiVacio(vehiculosSemillaFlotaPequena);

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: database),
        Provider<DepositoRepository>.value(value: depositoRepository),
        Provider<PuntoEntregaRepository>.value(value: puntoEntregaRepository),
        Provider<VehiculoRepository>.value(value: vehiculoRepository),
        Provider<HistorialRepository>.value(value: historialRepository),
        Provider<OsrmClient>(
          create: (_) => OsrmClient(database: database),
          dispose: (_, cliente) => cliente.dispose(),
        ),
      ],
      child: const SistemaOptimizacionRutasApp(),
    ),
  );
}

class SistemaOptimizacionRutasApp extends StatelessWidget {
  const SistemaOptimizacionRutasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Optimización de Rutas VRP',
      // El banner de "DEBUG" tapaba botones reales del AppBar (ej. el de
      // color por ruta en Mapa resultado); no aporta nada en una demo.
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
