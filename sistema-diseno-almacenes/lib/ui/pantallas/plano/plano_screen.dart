import 'package:flutter/material.dart';

import '../../../domain/geometria/generador_layout.dart';
import '../../widgets/plano_2d.dart';

/// Pantalla 07 de CLAUDE.md sección 10 (versión inicial, Fase 2): vista
/// cenital acotada, con zonas coloreadas. Cotas de superficie total y de
/// pasillo; zonas funcionales (recepción, despacho, etc.) llegan en una
/// fase posterior, cuando el usuario pueda declararlas.
class PlanoScreen extends StatelessWidget {
  const PlanoScreen({super.key, required this.layout});

  final ResultadoLayout layout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plano 2D')),
      body: Padding(padding: const EdgeInsets.all(24), child: Plano2D(layout: layout)),
    );
  }
}
