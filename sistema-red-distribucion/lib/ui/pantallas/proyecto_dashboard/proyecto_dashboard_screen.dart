import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/estado/proyecto_activo.dart';
import '../agregacion/agregacion_screen.dart';
import '../auditoria/auditoria_datos_screen.dart';
import '../candidatos/candidatos_screen.dart';
import '../clientes/clientes_screen.dart';
import '../comparador/comparador_escenarios_screen.dart';
import '../curva/curva_screen.dart';
import '../exportacion/exportacion_screen.dart';
import '../matriz/matriz_screen.dart';
import '../optimizacion/optimizacion_screen.dart';
import '../parametros_costo/parametros_costo_screen.dart';
import '../plantas/plantas_screen.dart';
import '../resultado_costos/resultado_costos_screen.dart';
import '../resultado_mapa/resultado_mapa_screen.dart';

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
    descripcion: 'Agrupa clientes en zonas de demanda.',
    pantalla: (_) => const AgregacionScreen(),
  ),
  _ModuloProyecto(
    icono: LucideIcons.route,
    titulo: 'Matriz de distancias',
    descripcion: 'Distancias reales por carretera entre orígenes y zonas.',
    pantalla: (_) => const MatrizScreen(),
  ),
  _ModuloProyecto(
    icono: LucideIcons.play,
    titulo: 'Optimización',
    descripcion: 'Decide qué almacenes abrir (ADD, DROP, intercambio, recocido, barrido).',
    pantalla: (_) => const OptimizacionScreen(),
  ),
  _ModuloProyecto(
    icono: LucideIcons.map,
    titulo: 'Resultado — mapa',
    descripcion: 'Territorios coloreados, almacenes abiertos y zonas no cubiertas.',
    pantalla: (_) => const ResultadoMapaScreen(),
  ),
  _ModuloProyecto(
    icono: LucideIcons.chartColumn,
    titulo: 'Resultado — costos',
    descripcion: 'Desglose por rubro de un escenario y comparación con la red actual.',
    pantalla: (_) => const ResultadoCostosScreen(),
  ),
  _ModuloProyecto(
    icono: LucideIcons.chartLine,
    titulo: 'Curva',
    descripcion: 'Costo total contra número de almacenes (escenarios de barrido).',
    pantalla: (_) => const CurvaScreen(),
  ),
  _ModuloProyecto(
    icono: LucideIcons.gitCompare,
    titulo: 'Comparador de escenarios',
    descripcion: 'Dos escenarios lado a lado: ahorro, almacenes y zonas que cambian.',
    pantalla: (_) => const ComparadorEscenariosScreen(),
  ),
  _ModuloProyecto(
    icono: LucideIcons.share2,
    titulo: 'Exportación',
    descripcion: 'Ficha técnica en PDF, CSV, proyecto portable y enlace del visor web.',
    pantalla: (_) => const ExportacionScreen(),
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
