import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Placeholder para listas/vistas sin datos todavía — evita pantallas en
/// blanco (CLAUDE.md §11: "Base de datos vacía... mostrar estados vacíos").
class EstadoVacio extends StatelessWidget {
  const EstadoVacio({
    super.key,
    required this.icono,
    required this.titulo,
    this.descripcion,
    this.accion,
  });

  final IconData icono;
  final String titulo;
  final String? descripcion;
  final Widget? accion;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, size: 56, color: colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: textTheme.titleMedium,
            ),
            if (descripcion != null) ...[
              const SizedBox(height: 8),
              Text(
                descripcion!,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (accion != null) ...[
              const SizedBox(height: 20),
              accion!,
            ],
          ],
        ).animate().fadeIn(duration: 250.ms),
      ),
    );
  }
}
