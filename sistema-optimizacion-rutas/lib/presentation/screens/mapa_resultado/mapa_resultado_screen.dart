import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../data/models/deposito.dart';
import '../../providers/escenario_provider.dart';

/// Pantalla de Resultado en mapa (sección 8 de CLAUDE.md): depósito, puntos
/// de entrega y las rutas resultantes dibujadas con la geometría real de
/// OSRM — no líneas rectas entre puntos.
class MapaResultadoScreen extends StatelessWidget {
  const MapaResultadoScreen({
    super.key,
    required this.deposito,
    required this.rutas,
    required this.vehiculosFaltantes,
  });

  final Deposito deposito;
  final List<RutaConGeometria> rutas;
  final int vehiculosFaltantes;

  @override
  Widget build(BuildContext context) {
    final puntoDeposito = LatLng(deposito.latitud, deposito.longitud);
    final todosLosPuntos = [
      puntoDeposito,
      for (final ruta in rutas) ...ruta.puntosRuta,
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Resultado en mapa')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final mapa = _Mapa(
            puntoDeposito: puntoDeposito,
            todosLosPuntos: todosLosPuntos,
            rutas: rutas,
          );
          final panel = _PanelRutas(
            rutas: rutas,
            vehiculosFaltantes: vehiculosFaltantes,
          );

          if (constraints.maxWidth >= 900) {
            return Row(
              children: [
                Expanded(flex: 2, child: mapa),
                SizedBox(
                  width: 340,
                  child: Material(
                    elevation: 1,
                    child: panel,
                  ),
                ),
              ],
            );
          }

          return Column(
            children: [
              Expanded(flex: 3, child: mapa),
              Expanded(flex: 2, child: panel),
            ],
          );
        },
      ),
    );
  }
}

class _Mapa extends StatelessWidget {
  const _Mapa({
    required this.puntoDeposito,
    required this.todosLosPuntos,
    required this.rutas,
  });

  final LatLng puntoDeposito;
  final List<LatLng> todosLosPuntos;
  final List<RutaConGeometria> rutas;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colorScheme = Theme.of(context).colorScheme;

    return FlutterMap(
      options: MapOptions(
        initialCameraFit: CameraFit.bounds(
          bounds: LatLngBounds.fromPoints(todosLosPuntos),
          padding: const EdgeInsets.all(48),
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.logisticapps.sistema_optimizacion_rutas',
        ),
        PolylineLayer(
          polylines: [
            for (final ruta in rutas)
              if (ruta.puntosRuta.isNotEmpty)
                Polyline(
                  points: ruta.puntosRuta,
                  color: ruta.color.resolver(brightness),
                  strokeWidth: 4,
                ),
          ],
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: puntoDeposito,
              width: 36,
              height: 36,
              child: _MarcadorDeposito(color: colorScheme.primary),
            ),
            for (final ruta in rutas)
              for (final parada in ruta.rutaAsignada.paradas)
                Marker(
                  point: LatLng(parada.latitud, parada.longitud),
                  width: 28,
                  height: 28,
                  child: _MarcadorParada(
                    color: ruta.color.resolver(brightness),
                  ),
                ),
          ],
        ),
      ],
    );
  }
}

class _MarcadorDeposito extends StatelessWidget {
  const _MarcadorDeposito({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: const Icon(LucideIcons.warehouse, color: Colors.white, size: 18),
    );
  }
}

class _MarcadorParada extends StatelessWidget {
  const _MarcadorParada({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }
}

class _PanelRutas extends StatelessWidget {
  const _PanelRutas({required this.rutas, required this.vehiculosFaltantes});

  final List<RutaConGeometria> rutas;
  final int vehiculosFaltantes;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (vehiculosFaltantes > 0) ...[
          _BannerFlotaInsuficiente(vehiculosFaltantes: vehiculosFaltantes),
          const SizedBox(height: 16),
        ],
        for (final ruta in rutas) ...[
          _TarjetaRuta(ruta: ruta),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _BannerFlotaInsuficiente extends StatelessWidget {
  const _BannerFlotaInsuficiente({required this.vehiculosFaltantes});

  final int vehiculosFaltantes;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.triangleAlert, color: colorScheme.onErrorContainer),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Flota insuficiente: hacen falta $vehiculosFaltantes '
              'vehículo(s) más para cubrir todas las rutas.',
              style: TextStyle(color: colorScheme.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaRuta extends StatelessWidget {
  const _TarjetaRuta({required this.ruta});

  final RutaConGeometria ruta;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colorScheme = Theme.of(context).colorScheme;
    final vehiculo = ruta.rutaAsignada.vehiculo;
    final distanciaKm = (ruta.distanciaMetros ?? 0) / 1000;
    final duracionMin = (ruta.duracionSegundos ?? 0) / 60;
    final costo = vehiculo?.costoEstimadoPorKm != null
        ? distanciaKm * vehiculo!.costoEstimadoPorKm!
        : null;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: ruta.color.resolver(brightness),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    vehiculo?.nombre ?? 'Sin vehículo asignado',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 4,
              children: [
                Text('${distanciaKm.toStringAsFixed(1)} km'),
                Text('${duracionMin.toStringAsFixed(0)} min'),
                if (costo != null) Text('S/ ${costo.toStringAsFixed(2)}'),
                Text('${ruta.rutaAsignada.demandaTotal.toStringAsFixed(0)} kg'),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              ruta.rutaAsignada.paradas.map((p) => p.nombre).join(' → '),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
