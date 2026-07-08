import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Tarjeta plegable con la explicación general de una calculadora: qué
/// resuelve y por qué sirve, en lenguaje llano. Va siempre visible por
/// default (a diferencia de un tooltip, que hay que saber que existe para
/// abrirlo) — se puede colapsar una vez que ya se entendió, para no
/// ocupar espacio en usos repetidos.
class TarjetaExplicacion extends StatelessWidget {
  const TarjetaExplicacion({
    super.key,
    required this.titulo,
    required this.cuerpo,
  });

  final String titulo;
  final String cuerpo;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.surfaceContainerHigh,
      margin: EdgeInsets.zero,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          leading: Icon(LucideIcons.lightbulb, color: colorScheme.primary),
          title: Text(
            titulo,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cuerpo,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
