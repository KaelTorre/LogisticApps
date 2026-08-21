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
      appBar: AppBar(
        title: const Text('Plano 2D'),
        actions: [
          Tooltip(
            message: 'Pellizca o usa la rueda del mouse para acercar. Arrastra para mover.',
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Icon(Icons.pinch_outlined, color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _leyenda(Plano2D.colorRacks, 'Racks'),
                const SizedBox(width: 16),
                _leyenda(Plano2D.colorPasillo, 'Pasillo', bordeado: true),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Plano2D(layout: layout),
            ),
          ),
        ],
      ),
    );
  }

  Widget _leyenda(Color color, String etiqueta, {bool bordeado = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            border: bordeado ? Border.all(color: Colors.black26) : null,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(etiqueta, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
