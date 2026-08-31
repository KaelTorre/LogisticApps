import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/constantes.dart';
import '../../../core/estado/proyecto_activo.dart';
import '../../../data/models/cliente.dart';
import '../../../data/models/cliente_zona.dart';
import '../../../data/models/zona_demanda.dart';
import '../../../data/repositories/cliente_repository.dart';
import '../../../data/repositories/cliente_zona_repository.dart';
import '../../../data/repositories/planta_repository.dart';
import '../../../data/repositories/sitio_candidato_repository.dart';
import '../../../data/repositories/zona_demanda_repository.dart';
import '../../../domain/motor/m1_agregacion.dart';

const _paletaZonas = [
  Color(0xFF2563EB),
  Color(0xFFDC2626),
  Color(0xFF16A34A),
  Color(0xFFCA8A04),
  Color(0xFF9333EA),
  Color(0xFFDB2777),
  Color(0xFF0891B2),
  Color(0xFFEA580C),
];

/// Pantalla 5 (CLAUDE.md sección 8): control de `k`, mapa de zonas
/// resultantes y error de agregación. Corre M1 (`agregarEnZonas`) y
/// reemplaza por completo las zonas del proyecto — no se editan a mano
/// (ver comentario de `ZonaDemandaTable`).
class AgregacionScreen extends StatefulWidget {
  const AgregacionScreen({super.key});

  @override
  State<AgregacionScreen> createState() => _AgregacionScreenState();
}

class _AgregacionScreenState extends State<AgregacionScreen> {
  List<Cliente> _clientes = [];
  List<ZonaDemanda> _zonas = [];
  int _k = 1;
  bool _cargando = true;
  bool _recalculando = false;

  int get _proyectoId => context.read<ProyectoActivo>().proyecto!.id!;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _cargando = true);
    final proyectoId = _proyectoId;
    final clienteRepository = context.read<ClienteRepository>();
    final zonaRepository = context.read<ZonaDemandaRepository>();
    final candidatoRepository = context.read<SitioCandidatoRepository>();
    final plantaRepository = context.read<PlantaRepository>();

    final clientes = await clienteRepository.obtenerPorProyecto(proyectoId);
    final zonas = await zonaRepository.obtenerPorProyecto(proyectoId);
    final candidatos = await candidatoRepository.obtenerPorProyecto(proyectoId);
    final plantas = await plantaRepository.obtenerPorProyecto(proyectoId);

    if (!mounted) return;
    setState(() {
      _clientes = clientes.where((c) => c.activo).toList();
      _zonas = zonas;
      _k = zonas.isNotEmpty
          ? zonas.length
          : proponerK(
              nClientes: _clientes.length,
              maxCoordenadasPorConsulta: maxCoordenadasPorConsulta,
              reservaCandidatos: candidatos.length + plantas.length,
            ).clamp(1, _clientes.isEmpty ? 1 : _clientes.length);
      _cargando = false;
    });
  }

  Future<void> _recalcular() async {
    if (_clientes.isEmpty) return;

    setState(() => _recalculando = true);
    final proyectoId = _proyectoId;
    final zonaRepository = context.read<ZonaDemandaRepository>();
    final clienteZonaRepository = context.read<ClienteZonaRepository>();

    final zonasCalculadas = agregarEnZonas(clientes: _clientes, k: _k);

    await zonaRepository.eliminarPorProyecto(proyectoId);
    final zonasGuardadas = <ZonaDemanda>[];
    final asignaciones = <ClienteZona>[];
    for (var i = 0; i < zonasCalculadas.length; i++) {
      final calculada = zonasCalculadas[i];
      final id = await zonaRepository.crear(
        ZonaDemanda(
          proyectoId: proyectoId,
          etiqueta: 'Zona ${i + 1}',
          latitud: calculada.latitud,
          longitud: calculada.longitud,
          demandaAgregada: calculada.demandaAgregada,
          pedidosAgregados: calculada.pedidosAgregados,
          numeroClientes: calculada.numeroClientes,
          errorAgregacionMetros: calculada.errorAgregacionMetros,
        ),
      );
      zonasGuardadas.add(
        ZonaDemanda(
          id: id,
          proyectoId: proyectoId,
          etiqueta: 'Zona ${i + 1}',
          latitud: calculada.latitud,
          longitud: calculada.longitud,
          demandaAgregada: calculada.demandaAgregada,
          pedidosAgregados: calculada.pedidosAgregados,
          numeroClientes: calculada.numeroClientes,
          errorAgregacionMetros: calculada.errorAgregacionMetros,
        ),
      );
      for (final clienteId in calculada.clienteIds) {
        asignaciones.add(ClienteZona(clienteId: clienteId, zonaId: id));
      }
    }
    await clienteZonaRepository.insertarTodas(asignaciones);

    if (!mounted) return;
    setState(() {
      _zonas = zonasGuardadas;
      _recalculando = false;
    });
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text('${zonasGuardadas.length} zona(s) generada(s).')));
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Agregación en zonas de demanda')),
      body: _clientes.isEmpty
          ? _SinClientes()
          : SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final anchoAmplio = constraints.maxWidth >= 900;
                  final panelControl = _PanelControl(
                    k: _k,
                    nClientes: _clientes.length,
                    recalculando: _recalculando,
                    onKCambiado: (v) => setState(() => _k = v),
                    onRecalcular: _recalcular,
                    zonas: _zonas,
                  );
                  final mapa = _MapaZonas(clientes: _clientes, zonas: _zonas);

                  if (anchoAmplio) {
                    return Row(
                      children: [
                        SizedBox(width: 360, child: panelControl),
                        const VerticalDivider(width: 1),
                        Expanded(child: mapa),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      SizedBox(height: 320, child: mapa),
                      const Divider(height: 1),
                      Expanded(child: panelControl),
                    ],
                  );
                },
              ),
            ),
    );
  }
}

class _PanelControl extends StatelessWidget {
  const _PanelControl({
    required this.k,
    required this.nClientes,
    required this.recalculando,
    required this.onKCambiado,
    required this.onRecalcular,
    required this.zonas,
  });

  final int k;
  final int nClientes;
  final bool recalculando;
  final ValueChanged<int> onKCambiado;
  final VoidCallback onRecalcular;
  final List<ZonaDemanda> zonas;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Número de zonas (k)', style: Theme.of(context).textTheme.titleSmall),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: k.toDouble(),
                  min: 1,
                  max: nClientes.toDouble(),
                  divisions: nClientes > 1 ? nClientes - 1 : null,
                  label: '$k',
                  onChanged: (v) => onKCambiado(v.round()),
                ),
              ),
              SizedBox(width: 40, child: Text('$k', textAlign: TextAlign.center)),
            ],
          ),
          Text(
            'Máximo $nClientes (un cliente por zona).',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: recalculando ? null : onRecalcular,
            icon: const Icon(LucideIcons.refreshCw),
            label: Text(recalculando ? 'Calculando...' : 'Recalcular zonas'),
          ),
          const SizedBox(height: 16),
          if (zonas.isNotEmpty) ...[
            Text('Zonas actuales', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: zonas.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, i) => _TarjetaZona(zona: zonas[i], color: _paletaZonas[i % _paletaZonas.length]),
              ),
            ),
          ] else
            Expanded(
              child: Center(
                child: Text(
                  'Todavía no se calcularon zonas para este proyecto.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TarjetaZona extends StatelessWidget {
  const _TarjetaZona({required this.zona, required this.color});

  final ZonaDemanda zona;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color, radius: 8),
        title: Text(zona.etiqueta),
        subtitle: Text(
          '${zona.numeroClientes} cliente(s) · demanda ${zona.demandaAgregada.toStringAsFixed(1)} · '
          'error de agregación ${zona.errorAgregacionMetros} m',
        ),
        dense: true,
      ),
    );
  }
}

class _MapaZonas extends StatelessWidget {
  const _MapaZonas({required this.clientes, required this.zonas});

  final List<Cliente> clientes;
  final List<ZonaDemanda> zonas;

  @override
  Widget build(BuildContext context) {
    final centro = clientes.isNotEmpty
        ? LatLng(clientes.first.latitud, clientes.first.longitud)
        : centroMapaPorDefecto;

    return FlutterMap(
      options: MapOptions(initialCenter: centro, initialZoom: 12),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.logisticapps.sistema_red_distribucion',
        ),
        MarkerLayer(
          markers: clientes
              .map(
                (c) => Marker(
                  point: LatLng(c.latitud, c.longitud),
                  width: 10,
                  height: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade600,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        MarkerLayer(
          markers: [
            for (var i = 0; i < zonas.length; i++)
              Marker(
                point: LatLng(zonas[i].latitud, zonas[i].longitud),
                width: 28,
                height: 28,
                child: Icon(
                  LucideIcons.mapPin,
                  color: _paletaZonas[i % _paletaZonas.length],
                  size: 28,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _SinClientes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.users, size: 40, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(height: 12),
            Text(
              'Carga clientes activos antes de calcular la agregación en zonas.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
