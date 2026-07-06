import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/fecha_utils.dart';
import '../../../data/models/escenario_optimizacion.dart';
import '../../../data/models/historial_calculo.dart';
import '../../../data/repositories/historial_repository.dart';
import 'historial_mapeo.dart';

/// Pantalla de Historial: registro de cálculos anteriores, guardados
/// automáticamente al terminar cada uno con éxito (`EscenarioProvider`).
/// Sin FAB — las entradas se crean solas, no manualmente.
class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  List<HistorialCalculo> _calculos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _cargando = true);
    final calculos = await context
        .read<HistorialRepository>()
        .listarResumenes();
    if (!mounted) return;
    setState(() {
      _calculos = calculos;
      _cargando = false;
    });
  }

  Future<void> _abrirDetalle(HistorialCalculo resumen) async {
    final detalle = await context.read<HistorialRepository>().obtenerDetalle(
      resumen.id!,
    );
    if (!mounted || detalle == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => mapaResultadoDesdeHistorial(detalle)),
    );
  }

  Future<void> _confirmarEliminar(HistorialCalculo resumen) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar del historial'),
        content: Text(
          '¿Eliminar el cálculo del ${formatearFecha(resumen.fechaCalculo)}? '
          'Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmado != true || !mounted) return;

    await context.read<HistorialRepository>().eliminar(resumen.id!);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        const SnackBar(
          showCloseIcon: true,
          content: Text('Entrada del historial eliminada.'),
        ),
      );
    await _cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historial')),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _calculos.isEmpty
          ? const _EstadoVacio()
          : SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final columnas = (constraints.maxWidth / 340)
                      .floor()
                      .clamp(1, 3);
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columnas,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      mainAxisExtent: 122,
                    ),
                    itemCount: _calculos.length,
                    itemBuilder: (context, index) {
                      final calculo = _calculos[index];
                      return _TarjetaHistorial(
                        calculo: calculo,
                        alAbrir: () => _abrirDetalle(calculo),
                        alEliminar: () => _confirmarEliminar(calculo),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}

class _TarjetaHistorial extends StatelessWidget {
  const _TarjetaHistorial({
    required this.calculo,
    required this.alAbrir,
    required this.alEliminar,
  });

  final HistorialCalculo calculo;
  final VoidCallback alAbrir;
  final VoidCallback alEliminar;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final metodoLabel = calculo.metodo == MetodoOptimizacion.ahorros
        ? 'Ahorros'
        : 'Barrido';

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: alAbrir,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  LucideIcons.history,
                  color: colorScheme.onSecondaryContainer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      formatearFecha(calculo.fechaCalculo),
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${calculo.depositoNombre} · $metodoLabel',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${(calculo.distanciaTotalMetros / 1000).toStringAsFixed(1)} km · '
                      '${calculo.cantidadRutas} ruta(s)',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: alEliminar,
                icon: const Icon(LucideIcons.trash2),
                tooltip: 'Eliminar',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EstadoVacio extends StatelessWidget {
  const _EstadoVacio();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.history,
              size: 40,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              'Todavía no hay cálculos guardados. Se registran solos al '
              'calcular una ruta en Optimización.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
