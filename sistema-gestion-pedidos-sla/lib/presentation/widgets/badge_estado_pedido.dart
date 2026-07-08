import 'package:flutter/material.dart';

import '../../core/constants.dart';
import 'paleta_categorica.dart';

/// Chip de color según el estado del pedido — ver [colorEstadoPedido] para
/// la paleta (estados terminales en color sólido de tema, intermedios en
/// tonos cualitativos distintos entre sí).
class BadgeEstadoPedido extends StatelessWidget {
  const BadgeEstadoPedido({super.key, required this.estado});

  final EstadoPedido estado;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final (fondo, texto) = colorEstadoPedido(context, estado);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        estado.etiqueta,
        style: textTheme.labelSmall?.copyWith(
          color: texto,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
