import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Pantalla 1 (CLAUDE.md sección 9). Placeholder de la Fase 0: el semáforo
/// por categoría, las acciones abiertas y el selector de periodo activo se
/// construyen en la Fase 1 en adelante, sobre el esquema real.
class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Control logístico')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.activity, size: 48, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text('Sistema de control logístico de lazo cerrado', style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
