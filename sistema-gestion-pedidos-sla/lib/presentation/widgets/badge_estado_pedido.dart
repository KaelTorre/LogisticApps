import 'package:flutter/material.dart';

import '../../core/constants.dart';

/// Chip de color según el estado del pedido. Usa siempre
/// `Theme.of(context).colorScheme` — nunca colores fijos — para que se vea
/// bien en modo claro y oscuro.
class BadgeEstadoPedido extends StatelessWidget {
  const BadgeEstadoPedido({super.key, required this.estado});

  final EstadoPedido estado;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final (fondo, texto) = switch (estado) {
      EstadoPedido.recibido => (
        colorScheme.surfaceContainerHighest,
        colorScheme.onSurfaceVariant,
      ),
      EstadoPedido.procesando => (
        colorScheme.secondaryContainer,
        colorScheme.onSecondaryContainer,
      ),
      EstadoPedido.preparandoEnvio => (
        colorScheme.tertiaryContainer,
        colorScheme.onTertiaryContainer,
      ),
      EstadoPedido.enTransito => (
        colorScheme.primaryContainer,
        colorScheme.onPrimaryContainer,
      ),
      EstadoPedido.entregado => (colorScheme.primary, colorScheme.onPrimary),
      EstadoPedido.cancelado => (
        colorScheme.errorContainer,
        colorScheme.onErrorContainer,
      ),
    };

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
