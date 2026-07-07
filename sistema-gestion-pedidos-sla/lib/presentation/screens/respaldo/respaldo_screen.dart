import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../providers/respaldo_provider.dart';

/// Exportar/importar respaldo local (M7): portabilidad de archivo, no
/// sincronización en la nube.
class RespaldoScreen extends StatelessWidget {
  const RespaldoScreen({super.key});

  Future<void> _confirmarImportar(
    BuildContext context,
    RespaldoProvider provider,
  ) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Importar respaldo'),
        content: const Text(
          'Esto reemplaza todos los datos actuales de la app por los del '
          'archivo elegido. Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
    if (confirmado == true) await provider.importar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Respaldo')),
      body: Consumer<RespaldoProvider>(
        builder: (context, provider, _) {
          final colorScheme = Theme.of(context).colorScheme;
          final textTheme = Theme.of(context).textTheme;
          final ocupado =
              provider.estado == EstadoRespaldo.exportando ||
              provider.estado == EstadoRespaldo.importando;

          return SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.databaseBackup,
                        size: 48,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Todos los datos viven en este dispositivo. Usa esta '
                        'sección para guardar un archivo de respaldo o '
                        'restaurar uno guardado antes.',
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: ocupado ? null : provider.exportar,
                          icon: const Icon(LucideIcons.fileDown),
                          label: const Text('Exportar respaldo'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: ocupado
                              ? null
                              : () => _confirmarImportar(context, provider),
                          icon: const Icon(LucideIcons.fileUp),
                          label: const Text('Importar respaldo'),
                        ),
                      ),
                      if (ocupado) ...[
                        const SizedBox(height: 24),
                        const CircularProgressIndicator(),
                      ],
                      if (provider.mensaje != null) ...[
                        const SizedBox(height: 24),
                        Text(
                          provider.mensaje!,
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium?.copyWith(
                            color: provider.estado == EstadoRespaldo.error
                                ? colorScheme.error
                                : colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
