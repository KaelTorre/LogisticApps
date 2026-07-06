import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Centro por defecto cuando todavía no hay ninguna coordenada elegida (la
/// oficina/depósito semilla en Pucallpa, ver `core/pucallpa_dataset.dart`) —
/// solo para que el mapa arranque en una zona con calles reales, no un punto
/// mágico ni una coordenada inventada para el registro en sí.
const _centroPorDefecto = LatLng(-8.375482, -74.556342);

const _tamanioIcono = 40.0;

/// Pantalla de mapa a pantalla completa para elegir una ubicación tocando el
/// punto exacto — reemplaza el ingreso manual de latitud/longitud en los
/// formularios de Depósito y Punto de entrega. No hace geocodificación de
/// direcciones (fuera de alcance, ver CLAUDE.md sección 11): el usuario elige
/// visualmente el punto sobre el mapa, no busca una dirección de texto.
///
/// Dos marcadores con roles distintos, para que se entienda de un vistazo
/// cuál es cuál:
/// - **Azul** (`_CursorMarcador`), solo con mouse: sigue el puntero en vivo,
///   sin fijarse en el mapa — "estás apuntando acá".
/// - **Rojo** (`_elegido`): el punto ya elegido/confirmado, fijo sobre el
///   mapa (se mueve con el pan/zoom porque está anclado a su coordenada) —
///   "esto ya está seleccionado". En pantallas táctiles (sin mouse) solo
///   existe este marcador, ya que no hay hover para el cursor azul.
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
  Offset? _posicionCursor;

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
          MouseRegion(
            cursor: SystemMouseCursors.none,
            onHover: (evento) =>
                setState(() => _posicionCursor = evento.localPosition),
            onExit: (_) => setState(() => _posicionCursor = null),
            child: FlutterMap(
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
                        width: _tamanioIcono,
                        height: _tamanioIcono,
                        alignment: Alignment.topCenter,
                        child: Icon(
                          LucideIcons.mapPin,
                          size: _tamanioIcono,
                          color: colorScheme.error,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          if (_posicionCursor != null)
            Positioned(
              left: _posicionCursor!.dx - _tamanioIcono / 2,
              top: _posicionCursor!.dy - _tamanioIcono,
              child: IgnorePointer(
                child: Icon(
                  LucideIcons.mapPin,
                  size: _tamanioIcono,
                  color: colorScheme.primary,
                ),
              ),
            ),
          Positioned(
            left: 16,
            right: 16,
            top: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(LucideIcons.info, color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Movete por el mapa y hacé clic (o tocá) en el punto '
                        'exacto para elegir la ubicación.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_elegido != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(LucideIcons.mapPin, color: colorScheme.error),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${_elegido!.latitude.toStringAsFixed(6)}, '
                          '${_elegido!.longitude.toStringAsFixed(6)}',
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
