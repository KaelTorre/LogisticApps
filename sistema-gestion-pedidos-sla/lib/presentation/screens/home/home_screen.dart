import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/cliente_repository.dart';
import '../../../data/repositories/pedido_repository.dart';
import '../../../data/repositories/producto_repository.dart';
import '../../../data/seed/dataset_ejemplo.dart';
import '../clasificacion_abc/clasificacion_abc_screen.dart';
import '../clientes/cliente_list_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../optimizacion_servicio/optimizacion_servicio_screen.dart';
import '../pedidos/pedido_list_screen.dart';
import '../productos/producto_list_screen.dart';
import '../respaldo/respaldo_screen.dart';

enum _AcentoModulo { primario, secundario, terciario, neutral }

class _ModuloInicio {
  const _ModuloInicio({
    required this.icono,
    required this.titulo,
    required this.descripcion,
    required this.pantalla,
    this.acento = _AcentoModulo.primario,
    this.destacado = false,
  });

  final IconData icono;
  final String titulo;
  final String descripcion;
  final WidgetBuilder pantalla;
  final _AcentoModulo acento;

  /// Pedidos es el flujo central de la app — se destaca con fondo sólido en
  /// vez del acento tenue de las demás.
  final bool destacado;
}

final _modulos = [
  _ModuloInicio(
    icono: LucideIcons.clipboardList,
    titulo: 'Pedidos',
    descripcion: 'Ciclo de vida completo y Tiempo de Ciclo del Pedido.',
    pantalla: (_) => const PedidoListScreen(),
    destacado: true,
  ),
  _ModuloInicio(
    icono: LucideIcons.users,
    titulo: 'Clientes',
    descripcion: 'Catálogo de clientes de la empresa.',
    pantalla: (_) => const ClienteListScreen(),
    acento: _AcentoModulo.primario,
  ),
  _ModuloInicio(
    icono: LucideIcons.package,
    titulo: 'Productos',
    descripcion: 'Catálogo de productos y su valor unitario.',
    pantalla: (_) => const ProductoListScreen(),
    acento: _AcentoModulo.secundario,
  ),
  _ModuloInicio(
    icono: LucideIcons.chartColumn,
    titulo: 'Clasificación ABC',
    descripcion: 'Curva 80-20 de productos según valor generado.',
    pantalla: (_) => const ClasificacionAbcScreen(),
    acento: _AcentoModulo.terciario,
  ),
  _ModuloInicio(
    icono: LucideIcons.calculator,
    titulo: 'Optimización del servicio',
    descripcion: 'Nivel de servicio óptimo y función de Taguchi.',
    pantalla: (_) => const OptimizacionServicioScreen(),
    acento: _AcentoModulo.neutral,
  ),
  _ModuloInicio(
    icono: LucideIcons.layoutDashboard,
    titulo: 'Dashboard',
    descripcion: 'Indicadores consolidados de nivel de servicio.',
    pantalla: (_) => const DashboardScreen(),
    acento: _AcentoModulo.primario,
  ),
  _ModuloInicio(
    icono: LucideIcons.databaseBackup,
    titulo: 'Respaldo',
    descripcion: 'Exportar o restaurar un archivo de respaldo local.',
    pantalla: (_) => const RespaldoScreen(),
    acento: _AcentoModulo.secundario,
  ),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _cargandoDataset = false;

  Future<void> _cargarDatasetEjemplo() async {
    setState(() => _cargandoDataset = true);
    final cargado = await cargarDatasetEjemplo(
      clienteRepository: context.read<ClienteRepository>(),
      productoRepository: context.read<ProductoRepository>(),
      pedidoRepository: context.read<PedidoRepository>(),
    );
    if (!mounted) return;
    setState(() => _cargandoDataset = false);
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          showCloseIcon: true,
          content: Text(
            cargado
                ? 'Datos de ejemplo cargados. Explora los módulos para verlos.'
                : 'Ya tienes clientes o productos registrados: no se sobrescribió nada.',
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistema de Gestión de Pedidos'),
        actions: [
          IconButton(
            onPressed: _cargandoDataset ? null : _cargarDatasetEjemplo,
            icon: _cargandoDataset
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(LucideIcons.sparkles),
            tooltip: 'Cargar datos de ejemplo',
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final columnas = (constraints.maxWidth / 280).floor().clamp(1, 4);
            return GridView.builder(
              padding: const EdgeInsets.all(24),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columnas,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                mainAxisExtent: 192,
              ),
              itemCount: _modulos.length,
              itemBuilder: (context, index) {
                final modulo = _modulos[index];
                return _TarjetaModulo(modulo: modulo)
                    .animate()
                    .fadeIn(delay: (index * 50).ms, duration: 250.ms)
                    .slideY(begin: 0.08, end: 0, curve: Curves.easeOut);
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

  final _ModuloInicio modulo;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final destacado = modulo.destacado;

    final (colorFondoIcono, colorIcono) = destacado
        ? (colorScheme.onPrimary.withValues(alpha: 0.16), colorScheme.onPrimary)
        : switch (modulo.acento) {
            _AcentoModulo.primario => (
              colorScheme.primaryContainer,
              colorScheme.onPrimaryContainer,
            ),
            _AcentoModulo.secundario => (
              colorScheme.secondaryContainer,
              colorScheme.onSecondaryContainer,
            ),
            _AcentoModulo.terciario => (
              colorScheme.tertiaryContainer,
              colorScheme.onTertiaryContainer,
            ),
            _AcentoModulo.neutral => (
              colorScheme.surfaceContainerHighest,
              colorScheme.onSurfaceVariant,
            ),
          };

    final colorTitulo = destacado ? colorScheme.onPrimary : colorScheme.onSurface;
    final colorDescripcion = destacado
        ? colorScheme.onPrimary.withValues(alpha: 0.85)
        : colorScheme.onSurfaceVariant;

    return Card(
      color: destacado ? colorScheme.primary : null,
      elevation: destacado ? 1 : 0,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: modulo.pantalla));
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: colorFondoIcono,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(modulo.icono, size: 26, color: colorIcono),
              ),
              const SizedBox(height: 14),
              Text(
                modulo.titulo,
                style: textTheme.titleMedium?.copyWith(
                  color: colorTitulo,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                modulo.descripcion,
                style: textTheme.bodySmall?.copyWith(color: colorDescripcion),
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
