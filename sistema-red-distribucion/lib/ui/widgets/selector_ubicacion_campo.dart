import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:paquete_geo_logistica/paquete_geo_logistica.dart';

import '../../core/validadores_formulario.dart';

/// Campo de latitud/longitud usado por los formularios de Cliente, Sitio
/// candidato y Planta: dos campos de texto editables (CLAUDE.md exige poder
/// rechazar una latitud/longitud fuera de rango escrita a mano, ver
/// `test/ui/cliente_form_screen_test.dart`) más un botón que abre
/// `SelectorUbicacionScreen` del paquete compartido para elegir el punto
/// tocando el mapa y precargar ambos campos.
class SelectorUbicacionCampo extends StatelessWidget {
  const SelectorUbicacionCampo({
    super.key,
    required this.latitudCtrl,
    required this.longitudCtrl,
    required this.centroPorDefecto,
  });

  final TextEditingController latitudCtrl;
  final TextEditingController longitudCtrl;
  final LatLng centroPorDefecto;

  Future<void> _elegirEnMapa(BuildContext context) async {
    final latActual = double.tryParse(latitudCtrl.text.trim());
    final lonActual = double.tryParse(longitudCtrl.text.trim());
    final inicial = (latActual != null && lonActual != null)
        ? LatLng(latActual, lonActual)
        : null;

    final elegido = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (_) => SelectorUbicacionScreen(
          inicial: inicial,
          centroPorDefecto: centroPorDefecto,
          userAgentPackageName: 'com.logisticapps.sistema_red_distribucion',
        ),
      ),
    );
    if (elegido != null) {
      latitudCtrl.text = elegido.latitude.toStringAsFixed(6);
      longitudCtrl.text = elegido.longitude.toStringAsFixed(6);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                key: const Key('campo_latitud'),
                controller: latitudCtrl,
                decoration: const InputDecoration(
                  labelText: 'Latitud',
                  helperText: 'Entre -90 y 90.',
                  helperMaxLines: 2,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  signed: true,
                  decimal: true,
                ),
                validator: validarLatitud,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                key: const Key('campo_longitud'),
                controller: longitudCtrl,
                decoration: const InputDecoration(
                  labelText: 'Longitud',
                  helperText: 'Entre -180 y 180.',
                  helperMaxLines: 2,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  signed: true,
                  decimal: true,
                ),
                validator: validarLongitud,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => _elegirEnMapa(context),
          icon: const Icon(LucideIcons.mapPin),
          label: const Text('Elegir en el mapa'),
        ),
      ],
    );
  }
}
