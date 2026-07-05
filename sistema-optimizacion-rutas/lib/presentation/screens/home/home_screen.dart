import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class _ModuloInicio {
  const _ModuloInicio({
    required this.icono,
    required this.titulo,
    required this.descripcion,
  });

  final IconData icono;
  final String titulo;
  final String descripcion;
}

const List<_ModuloInicio> _modulos = [
  _ModuloInicio(
    icono: LucideIcons.warehouse,
    titulo: 'Depósito',
    descripcion: 'Ubicación del punto de partida de las rutas.',
  ),
  _ModuloInicio(
    icono: LucideIcons.mapPin,
    titulo: 'Puntos de entrega',
    descripcion: 'Catálogo de clientes y destinos de reparto.',
  ),
  _ModuloInicio(
    icono: LucideIcons.truck,
    titulo: 'Vehículos',
    descripcion: 'Flota disponible, capacidad y costo por km.',
  ),
  _ModuloInicio(
    icono: LucideIcons.route,
    titulo: 'Optimización',
    descripcion: 'Calcular rutas con Ahorros o Barrido.',
  ),
  _ModuloInicio(
    icono: LucideIcons.map,
    titulo: 'Resultado en mapa',
    descripcion: 'Rutas reales sobre calles, vía OSRM.',
  ),
];

/// Ancho de columna de referencia para el grid responsive del dashboard.
const double _anchoColumnaReferencia = 260;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Optimización de Rutas VRP'),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final columnas = (constraints.maxWidth / _anchoColumnaReferencia)
                .floor()
                .clamp(1, 4);

            return Padding(
              padding: const EdgeInsets.all(24),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columnas,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  mainAxisExtent: 172,
                ),
                itemCount: _modulos.length,
                itemBuilder: (context, index) {
                  final modulo = _modulos[index];
                  return _TarjetaModulo(modulo: modulo)
                      .animate()
                      .fadeIn(delay: (index * 60).ms, duration: 250.ms)
                      .slideY(begin: 0.08, end: 0, curve: Curves.easeOut);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TarjetaModulo extends StatelessWidget {
  const _TarjetaModulo({required this.modulo});

  final _ModuloInicio modulo;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${modulo.titulo}: próximamente')),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(modulo.icono, color: colorScheme.onPrimaryContainer),
              ),
              const SizedBox(height: 16),
              Text(
                modulo.titulo,
                style: Theme.of(context).textTheme.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                modulo.descripcion,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
