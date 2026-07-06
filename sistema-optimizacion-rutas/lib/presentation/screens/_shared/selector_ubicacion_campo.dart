import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'selector_ubicacion_screen.dart';

/// Campo de formulario que abre [SelectorUbicacionScreen] para elegir la
/// ubicación tocando el mapa, en vez de escribir latitud/longitud a mano.
/// Muestra un error propio (no es un `TextFormField`, así que no participa
/// del `Form.validate()` normal) cuando [mostrarError] es `true`.
class SelectorUbicacionCampo extends StatelessWidget {
  const SelectorUbicacionCampo({
    super.key,
    required this.ubicacion,
    required this.onElegir,
    this.mostrarError = false,
  });

  final LatLng? ubicacion;
  final ValueChanged<LatLng> onElegir;
  final bool mostrarError;

  Future<void> _abrirSelector(BuildContext context) async {
    final elegido = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (_) => SelectorUbicacionScreen(inicial: ubicacion),
      ),
    );
    if (elegido != null) onElegir(elegido);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ubicación', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        Material(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _abrirSelector(context),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: mostrarError
                    ? Border.all(color: colorScheme.error)
                    : null,
              ),
              child: Row(
                children: [
                  Icon(LucideIcons.mapPin, color: colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      ubicacion != null
                          ? '${ubicacion!.latitude.toStringAsFixed(6)}, '
                                '${ubicacion!.longitude.toStringAsFixed(6)}'
                          : 'Toca para elegir en el mapa',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Icon(LucideIcons.pencil, color: colorScheme.onSurfaceVariant),
                ],
              ),
            ),
          ),
        ),
        if (mostrarError)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 12),
            child: Text(
              'Elige la ubicación en el mapa.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: colorScheme.error),
            ),
          ),
      ],
    );
  }
}
