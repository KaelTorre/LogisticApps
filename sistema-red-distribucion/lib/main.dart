import 'package:flutter/material.dart';

void main() {
  runApp(const SistemaRedDistribucionApp());
}

/// Punto de entrada — placeholder de Fase 0 (andamiaje). El flujo real
/// (proyecto activo, pantallas de datos, optimización) se arma en las fases
/// siguientes según `CLAUDE.md`.
class SistemaRedDistribucionApp extends StatelessWidget {
  const SistemaRedDistribucionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema de Red de Distribución',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal)),
      home: const _PantallaInicioProvisional(),
    );
  }
}

class _PantallaInicioProvisional extends StatelessWidget {
  const _PantallaInicioProvisional();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sistema de Red de Distribución')),
      body: const Center(
        child: Text('Fase 0 — andamiaje. Pantallas pendientes de las fases siguientes.'),
      ),
    );
  }
}
