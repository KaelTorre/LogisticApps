import 'package:flutter/material.dart';

import '../../../domain/geometria/prisma_3d.dart';
import '../../widgets/vista_isometrica.dart';

/// Pantalla 08 de CLAUDE.md sección 10: rotación en 4 ángulos, corte por
/// nivel. Nunca cámara libre — la Fase 6 no agrega controles que CLAUDE.md
/// no pida.
class VistaIsometricaScreen extends StatefulWidget {
  const VistaIsometricaScreen({super.key, required this.prismas, required this.niveles, required this.pasoNivelMm});

  final List<Prisma3D> prismas;
  final int niveles;
  final int pasoNivelMm;

  @override
  State<VistaIsometricaScreen> createState() => _VistaIsometricaScreenState();
}

class _VistaIsometricaScreenState extends State<VistaIsometricaScreen> {
  int _angulo = 0;
  // Empieza en el nivel 1, no en el más alto: con un almacén grande,
  // arrancar mostrando todos los niveles a la vez es ilegible de entrada
  // (demasiados prismas encimados). Nivel 1 da una vista que se entiende
  // de un vistazo, y desde ahí el usuario sube con el control.
  int _nivelCorte = 1;

  static const _nombresAngulo = ['0°', '90°', '180°', '270°'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vista isométrica')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Tooltip(
                  message: 'Rotar 90°',
                  child: IconButton(
                    icon: const Icon(Icons.rotate_right_outlined),
                    onPressed: () => setState(() => _angulo = (_angulo + 1) % 4),
                  ),
                ),
                Text('Ángulo: ${_nombresAngulo[_angulo]}'),
                const SizedBox(width: 24),
                Icon(Icons.layers_outlined, size: 18, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Text('Corte: nivel $_nivelCorte de ${widget.niveles}'),
                Expanded(
                  child: Slider(
                    value: _nivelCorte.toDouble(),
                    min: 1,
                    max: widget.niveles.toDouble(),
                    divisions: widget.niveles > 1 ? widget.niveles - 1 : null,
                    onChanged: (v) => setState(() => _nivelCorte = v.round()),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: VistaIsometrica(
                prismas: widget.prismas,
                angulo: _angulo,
                nivelCorte: _nivelCorte,
                pasoNivelMm: widget.pasoNivelMm,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
