import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Centro por defecto cuando todavía no hay ninguna coordenada elegida (la
/// oficina/depósito semilla en Pucallpa, ver `core/pucallpa_dataset.dart`) —
/// solo para que el mapa arranque en una zona con calles reales, no un punto
/// mágico ni una coordenada inventada para el registro en sí.
const _centroPorDefecto = LatLng(-8.375482, -74.556342);

/// Pantalla de mapa a pantalla completa para elegir una ubicación tocando el
/// punto exacto — reemplaza el ingreso manual de latitud/longitud en los
/// formularios de Depósito y Punto de entrega. No hace geocodificación de
/// direcciones (fuera de alcance, ver CLAUDE.md sección 11): el usuario elige
/// visualmente el punto sobre el mapa, no busca una dirección de texto.
class SelectorUbicacionScreen extends StatefulWidget {
  const SelectorUbicacionScreen({super.key, this.inicial});

  /// Ubicación ya elegida (modo edición) — si se da, el mapa arranca
  /// centrado ahí con el marcador ya puesto.
  final LatLng? inicial;

  @override
  State<SelectorUbicacionScreen> createState() =>
      _SelectorUbicacionScreenState();
}

class _SelectorUbicacionScreenState extends State<SelectorUbicacionScreen> {
  LatLng? _elegido;

  @override
  void initState() {
    super.initState();
    _elegido = widget.inicial;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Elegir ubicación'),
        actions: [
          TextButton(
            onPressed: _elegido == null
                ? null
                : () => Navigator.of(context).pop(_elegido),
            child: const Text('Confirmar'),
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: widget.inicial ?? _centroPorDefecto,
              initialZoom: 14,
              onTap: (_, punto) => setState(() => _elegido = punto),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName:
                    'com.logisticapps.sistema_optimizacion_rutas',
              ),
              if (_elegido != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _elegido!,
                      width: 40,
                      height: 40,
                      alignment: Alignment.topCenter,
                      child: Icon(
                        LucideIcons.mapPin,
                        size: 40,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(LucideIcons.mapPin, color: colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _elegido != null
                            ? '${_elegido!.latitude.toStringAsFixed(6)}, '
                                  '${_elegido!.longitude.toStringAsFixed(6)}'
                            : 'Toca el mapa para elegir la ubicación',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
