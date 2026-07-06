import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/exportar_google_maps.dart';
import '../../../core/exportar_visor_web.dart';
import '../../../core/paleta_rutas.dart';
import '../../../core/utils/geo_utils.dart';
import '../../../data/models/deposito.dart';
import '../../providers/escenario_provider.dart';

/// Pantalla de Resultado en mapa (sección 8 de CLAUDE.md): depósito, puntos
/// de entrega y las rutas resultantes dibujadas con la geometría real de
/// OSRM — no líneas rectas entre puntos.
///
/// El color de cada ruta se recalcula acá (no en `EscenarioProvider`): cada
/// ruta tiene su propia "posición" en la paleta, independiente de las demás
/// — el control "cambiar color" de su tarjeta solo avanza esa posición y
/// repinta, sin volver a pedirle nada a OSRM ni afectar el color de otras
/// rutas.
class MapaResultadoScreen extends StatefulWidget {
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
  State<MapaResultadoScreen> createState() => _MapaResultadoScreenState();
}

class _MapaResultadoScreenState extends State<MapaResultadoScreen> {
  // Por defecto, la ruta `i` arranca en la posición `i` de la paleta (todas
  // distintas entre sí); cada una se puede mover independientemente después.
  late final List<int> _posicionColorPorRuta = List.generate(
    widget.rutas.length,
    (i) => i,
  );

  void _cambiarColorDeRuta(int indice) {
    setState(() => _posicionColorPorRuta[indice]++);
  }

  @override
  Widget build(BuildContext context) {
    final puntoDeposito = LatLng(
      widget.deposito.latitud,
      widget.deposito.longitud,
    );
    final todosLosPuntos = [
      puntoDeposito,
      for (final ruta in widget.rutas) ...ruta.puntosRuta,
    ];
    final colores = [
      for (var i = 0; i < widget.rutas.length; i++)
        widget.rutas[i].rutaAsignada.vehiculo != null
            ? colorParaRuta(_posicionColorPorRuta[i])
            : colorSinAsignar,
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Resultado en mapa')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final mapa = _Mapa(
            puntoDeposito: puntoDeposito,
            todosLosPuntos: todosLosPuntos,
            rutas: widget.rutas,
            colores: colores,
          );
          final panel = _PanelRutas(
            deposito: widget.deposito,
            rutas: widget.rutas,
            colores: colores,
            vehiculosFaltantes: widget.vehiculosFaltantes,
            onCambiarColor: _cambiarColorDeRuta,
          );

          if (constraints.maxWidth >= 900) {
            return Row(
              children: [
                Expanded(flex: 2, child: mapa),
                SizedBox(
                  width: 340,
                  child: Material(elevation: 1, child: panel),
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
    required this.colores,
  });

  final LatLng puntoDeposito;
  final List<LatLng> todosLosPuntos;
  final List<RutaConGeometria> rutas;
  final List<ColorRuta> colores;

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
            for (final (i, ruta) in rutas.indexed)
              if (ruta.puntosRuta.isNotEmpty)
                Polyline(
                  points: ruta.puntosRuta,
                  color: colores[i].resolver(brightness),
                  strokeWidth: 4,
                ),
          ],
        ),
        MarkerLayer(
          markers: [
            for (final (i, ruta) in rutas.indexed)
              if (ruta.puntosRuta.isNotEmpty)
                for (final flecha in muestrearFlechasEnRuta(ruta.puntosRuta))
                  Marker(
                    point: flecha.punto,
                    width: 22,
                    height: 22,
                    child: _MarcadorFlecha(
                      rumboGrados: flecha.rumboGrados,
                      color: colores[i].resolver(brightness),
                    ),
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
            for (final (i, ruta) in rutas.indexed)
              for (final entrada in ruta.rutaAsignada.paradas.indexed)
                Marker(
                  point: LatLng(entrada.$2.latitud, entrada.$2.longitud),
                  width: 26,
                  height: 26,
                  child: _MarcadorParada(
                    numero: entrada.$1 + 1,
                    color: colores[i].resolver(brightness),
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
  const _MarcadorParada({required this.numero, required this.color});

  final int numero;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Text(
        '$numero',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          height: 1,
        ),
      ),
    );
  }
}

/// Flecha de dirección sobre un tramo de la ruta — sin esto, una polyline se
/// ve como una línea plana sin indicar hacia dónde avanza el vehículo.
///
/// Se dibuja un triángulo propio (no un ícono de Lucide) porque necesitamos
/// una forma cuya orientación "sin rotar" sea exactamente hacia arriba
/// (0°=norte); el ícono `LucideIcons.navigation` en realidad apunta de
/// fábrica hacia el noreste (~46°), lo que producía flechas todas rotadas
/// con el mismo desfase, sin reflejar el rumbo real de cada tramo.
class _MarcadorFlecha extends StatelessWidget {
  const _MarcadorFlecha({required this.rumboGrados, required this.color});

  final double rumboGrados;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rumboGrados * (math.pi / 180),
      child: CustomPaint(
        size: const Size(14, 14),
        painter: _TrianguloPainter(color: color),
      ),
    );
  }
}

/// Triángulo isósceles simple con la punta hacia arriba (0°) — ver
/// [_MarcadorFlecha]. Con borde blanco para que se lea sobre cualquier color
/// de fondo del mapa (agua, parques, calles).
class _TrianguloPainter extends CustomPainter {
  const _TrianguloPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, Paint()..color = color);
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(covariant _TrianguloPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _PanelRutas extends StatelessWidget {
  const _PanelRutas({
    required this.deposito,
    required this.rutas,
    required this.colores,
    required this.vehiculosFaltantes,
    required this.onCambiarColor,
  });

  final Deposito deposito;
  final List<RutaConGeometria> rutas;
  final List<ColorRuta> colores;
  final int vehiculosFaltantes;
  final void Function(int indice) onCambiarColor;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (vehiculosFaltantes > 0) ...[
          _BannerFlotaInsuficiente(vehiculosFaltantes: vehiculosFaltantes),
          const SizedBox(height: 16),
        ],
        for (final (i, ruta) in rutas.indexed) ...[
          _TarjetaRuta(
            deposito: deposito,
            ruta: ruta,
            color: colores[i],
            onCambiarColor: () => onCambiarColor(i),
          ),
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
  const _TarjetaRuta({
    required this.deposito,
    required this.ruta,
    required this.color,
    required this.onCambiarColor,
  });

  final Deposito deposito;
  final RutaConGeometria ruta;
  final ColorRuta color;
  final VoidCallback onCambiarColor;

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
    final colorResuelto = color.resolver(brightness);

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
                    color: colorResuelto,
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
                if (vehiculo != null)
                  IconButton(
                    tooltip: 'Cambiar el color de esta ruta',
                    icon: const Icon(LucideIcons.palette, size: 20),
                    onPressed: onCambiarColor,
                  ),
                IconButton(
                  tooltip:
                      'Exportar a Google Maps (máx. $limiteWaypointsGoogleMaps paradas)',
                  icon: const Icon(LucideIcons.externalLink, size: 20),
                  onPressed: () => _exportarAGoogleMaps(context),
                ),
                IconButton(
                  tooltip: 'Compartir link completo (sin límite de paradas)',
                  icon: const Icon(LucideIcons.link, size: 20),
                  onPressed: () => _compartirLinkCompleto(context),
                ),
              ],
            ),
            const SizedBox(height: 4),
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
            const SizedBox(height: 12),
            for (final entrada in ruta.rutaAsignada.paradas.indexed)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colorResuelto,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${entrada.$1 + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entrada.$2.nombre,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: colorScheme.onSurface),
                          ),
                          if (entrada.$1 < ruta.distanciasPorTramoMetros.length)
                            Text(
                              '${(ruta.distanciasPorTramoMetros[entrada.$1] / 1000).toStringAsFixed(1)} km '
                              '${entrada.$1 == 0 ? 'desde el depósito' : 'desde la parada anterior'}',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(color: colorScheme.onSurfaceVariant),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportarAGoogleMaps(BuildContext context) async {
    final paradas = ruta.rutaAsignada.paradas
        .map((p) => LatLng(p.latitud, p.longitud))
        .toList();

    if (paradas.length > limiteWaypointsGoogleMaps) {
      final continuar = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Ruta con muchas paradas'),
          content: Text(
            'Esta ruta tiene ${paradas.length} paradas. Google Maps solo '
            'admite hasta $limiteWaypointsGoogleMaps en computadoras (y '
            'apenas $limiteWaypointsGoogleMapsMovil si el link se abre en el '
            'navegador de un celular, aunque la app de Google Maps suele '
            'admitir más). Se exportarán solo las primeras '
            '$limiteWaypointsGoogleMaps; el resto no aparecerá.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Exportar de todas formas'),
            ),
          ],
        ),
      );
      if (continuar != true) return;
    }

    final uri = construirUrlGoogleMaps(
      deposito: LatLng(deposito.latitud, deposito.longitud),
      paradas: paradas,
    );
    final abierto = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!context.mounted || abierto) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No se pudo abrir Google Maps.')),
    );
  }

  Future<void> _compartirLinkCompleto(BuildContext context) async {
    final uri = construirUrlVisorWeb(
      deposito: deposito,
      paradas: ruta.rutaAsignada.paradas,
      color: color.resolver(Theme.of(context).brightness),
      vehiculoNombre: ruta.rutaAsignada.vehiculo?.nombre,
    );

    await Clipboard.setData(ClipboardData(text: uri.toString()));

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Link copiado — pégalo en WhatsApp, correo, etc.'),
        action: SnackBarAction(
          label: 'Abrir',
          onPressed: () => launchUrl(uri, mode: LaunchMode.externalApplication),
        ),
      ),
    );
  }
}
