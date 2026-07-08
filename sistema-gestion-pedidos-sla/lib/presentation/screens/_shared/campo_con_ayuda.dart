import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Campo de texto con un botón de ayuda (ícono ⓘ) que abre un diálogo con
/// una explicación en lenguaje llano de qué representa el valor, de dónde
/// suele salir, y un ejemplo numérico concreto. Pensado para las
/// calculadoras de M4/M5, donde los nombres de las variables (`a`, `b`,
/// `k`, `m`) no dicen nada por sí solos la primera vez que se ven.
class CampoConAyuda extends StatelessWidget {
  const CampoConAyuda({
    super.key,
    required this.controller,
    required this.etiqueta,
    required this.tituloAyuda,
    required this.descripcionAyuda,
    this.ejemplo,
    this.keyboardType,
    this.prefixText,
  });

  final TextEditingController controller;
  final String etiqueta;
  final String tituloAyuda;
  final String descripcionAyuda;
  final String? ejemplo;
  final TextInputType? keyboardType;
  final String? prefixText;

  void _mostrarAyuda(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(LucideIcons.info, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 10),
            Expanded(child: Text(tituloAyuda)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(descripcionAyuda),
              if (ejemplo != null) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ejemplo',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(ejemplo!),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: etiqueta,
        prefixText: prefixText,
        suffixIcon: IconButton(
          icon: const Icon(LucideIcons.info, size: 20),
          tooltip: 'Qué significa este valor',
          onPressed: () => _mostrarAyuda(context),
        ),
      ),
    );
  }
}
