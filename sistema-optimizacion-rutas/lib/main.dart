import 'package:flutter/material.dart';

import 'core/theme.dart';
import 'presentation/screens/home/home_screen.dart';

void main() {
  runApp(const SistemaOptimizacionRutasApp());
}

class SistemaOptimizacionRutasApp extends StatelessWidget {
  const SistemaOptimizacionRutasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Optimización de Rutas VRP',
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
