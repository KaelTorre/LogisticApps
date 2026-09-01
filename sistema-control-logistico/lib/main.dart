import 'package:flutter/material.dart';

import 'core/theme.dart';
import 'ui/pantallas/inicio/inicio_screen.dart';

void main() {
  runApp(const SistemaControlLogisticoApp());
}

class SistemaControlLogisticoApp extends StatelessWidget {
  const SistemaControlLogisticoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema de Control Logístico',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: ThemeMode.system,
      home: const InicioScreen(),
    );
  }
}
