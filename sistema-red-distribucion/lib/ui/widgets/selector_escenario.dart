import 'package:flutter/material.dart';

import '../../data/models/escenario.dart';

/// Selector de escenario reutilizado por las Pantallas 12, 13 y 15 — todas
/// necesitan que el usuario elija sobre cuál de los escenarios ya
/// calculados del proyecto quiere ver el resultado.
class SelectorEscenario extends StatelessWidget {
  const SelectorEscenario({
    super.key,
    required this.escenarios,
    required this.seleccionado,
    required this.onCambiar,
    this.etiqueta = 'Escenario',
  });

  final List<Escenario> escenarios;
  final Escenario? seleccionado;
  final ValueChanged<Escenario?> onCambiar;
  final String etiqueta;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      initialValue: seleccionado?.id,
      decoration: InputDecoration(labelText: etiqueta),
      items: [
        for (final escenario in escenarios)
          DropdownMenuItem(
            value: escenario.id,
            child: Text(
              '${escenario.nombre} (${escenario.metodo})',
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
      onChanged: (id) => onCambiar(escenarios.where((e) => e.id == id).firstOrNull),
    );
  }
}
