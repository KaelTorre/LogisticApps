import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/estado/proyecto_activo.dart';
import '../agregacion/agregacion_screen.dart';
import '../auditoria/auditoria_datos_screen.dart';
import '../candidatos/candidatos_screen.dart';
import '../clientes/clientes_screen.dart';
import '../matriz/matriz_screen.dart';
import '../optimizacion/optimizacion_screen.dart';
import '../parametros_costo/parametros_costo_screen.dart';
import '../plantas/plantas_screen.dart';

class _ModuloProyecto {
  const _ModuloProyecto({
    required this.icono,
    required this.titulo,
    required this.descripcion,
    required this.pantalla,
  });

  final IconData icono;
  final String titulo;
  final String descripcion;
  final WidgetBuilder pantalla;
}

final _modulos = [
  _ModuloProyecto(
    icono: LucideIcons.users,
    titulo: 'Clientes',
    descripcion: 'Coordenadas y demanda anual — base de la agregación en zonas.',
    pantalla: (_) => const ClientesScreen(),
  ),
  _ModuloProyecto(
    icono: LucideIcons.mapPinned,
    titulo: 'Sitios candidatos',
    descripcion: 'Ubicaciones posibles para abrir un centro de distribución.',
    pantalla: (_) => const CandidatosScreen(),
  ),
  _ModuloProyecto(
    icono: LucideIcons.factory,
    titulo: 'Plantas',
    descripcion: 'Orígenes de abastecimiento de la red.',
    pantalla: (_) => const PlantasScreen(),
  ),
  _ModuloProyecto(
    icono: LucideIcons.coins,
    titulo: 'Parámetros de costo',
    descripcion: 'Tarifas de transporte, inventario y estándar de servicio.',
    pantalla: (_) => const ParametrosCostoScreen(),
  ),
  _ModuloProyecto(
    icono: LucideIcons.shieldAlert,
    titulo: 'Auditoría de datos',
    descripcion: 'Hallazgos de calidad antes de calcular.',
    pantalla: (_) => const AuditoriaDatosScreen(),
  ),
  _ModuloProyecto(
    icono: LucideIcons.group,
    titulo: 'Agregación',
    descripcion: 'Agrupa clientes en zonas de demanda (M1).',
    pantalla: (_) => const AgregacionScreen(),
  ),
  _ModuloProyecto(
    icono: LucideIcons.route,
    titulo: 'Matriz de distancias',
    descripcion: 'Distancias reales por carretera entre orígenes y zonas (M3).',
    pantalla: (_) => const MatrizScreen(),
  ),
  _ModuloProyecto(
    icono: LucideIcons.play,
    titulo: 'Optimización',
    descripcion: 'Decide qué almacenes abrir (M6: ADD, DROP, intercambio, recocido).',
    pantalla: (_) => const OptimizacionScreen(),
  ),
];

/// Home del proyecto activo (parte de la Pantalla 1 de CLAUDE.md: tarjetas
/// de acceso a los módulos de datos construidos en la Fase 2). Los módulos
/// de agregación, matriz y optimización se agregan en las fases
/// siguientes.
class ProyectoDashboardScreen extends StatelessWidget {
  const ProyectoDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final proyecto = context.watch<ProyectoActivo>().proyecto;

    return Scaffold(
      appBar: AppBar(title: Text(proyecto?.nombre ?? 'Proyecto')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final columnas = (constraints.maxWidth / 280).floor().clamp(1, 3);
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columnas,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                mainAxisExtent: 128,
              ),
              itemCount: _modulos.length,
              itemBuilder: (context, index) {
                final modulo = _modulos[index];
                return _TarjetaModulo(modulo: modulo);
              },
            );
          },
        ),
      ),
    );
  }
}

class _TarjetaModulo extends StatelessWidget {
  const _TarjetaModulo({required this.modulo});

  final _ModuloProyecto modulo;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: modulo.pantalla)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(modulo.icono, color: colorScheme.onPrimaryContainer),
              ),
              const SizedBox(height: 10),
              Text(modulo.titulo, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 4),
              Expanded(
                child: Text(
                  modulo.descripcion,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
