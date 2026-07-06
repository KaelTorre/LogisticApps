import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../data/models/vehiculo.dart';
import '../../../data/repositories/vehiculo_repository.dart';
import 'vehiculo_form_screen.dart';

/// Pantalla de Vehículos (sección 8 de CLAUDE.md): CRUD simple sobre la
/// flota disponible (nombre, capacidad máxima, costo por km, tipo de flota).
class VehiculosScreen extends StatefulWidget {
  const VehiculosScreen({super.key});

  @override
  State<VehiculosScreen> createState() => _VehiculosScreenState();
}

class _VehiculosScreenState extends State<VehiculosScreen> {
  List<Vehiculo> _vehiculos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _cargando = true);
    final vehiculos = await context.read<VehiculoRepository>().obtenerTodos();
    if (!mounted) return;
    setState(() {
      _vehiculos = vehiculos;
      _cargando = false;
    });
  }

  Future<void> _abrirFormulario({Vehiculo? existente}) async {
    final guardado = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => VehiculoFormScreen(existente: existente),
      ),
    );
    if (guardado == true) await _cargar();
  }

  Future<void> _confirmarEliminar(Vehiculo vehiculo) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar vehículo'),
        content: Text(
          '¿Eliminar "${vehiculo.nombre}"? Esta acción no se puede deshacer.',
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

    await context.read<VehiculoRepository>().eliminar(vehiculo.id!);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          showCloseIcon: true,
          content: Text('"${vehiculo.nombre}" eliminado.'),
        ),
      );
    await _cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vehículos')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        icon: const Icon(LucideIcons.plus),
        label: const Text('Agregar'),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _vehiculos.isEmpty
          ? _EstadoVacio(alAgregar: () => _abrirFormulario())
          : SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final columnas = (constraints.maxWidth / 340)
                      .floor()
                      .clamp(1, 3);
                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columnas,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      mainAxisExtent: 108,
                    ),
                    itemCount: _vehiculos.length,
                    itemBuilder: (context, index) {
                      final vehiculo = _vehiculos[index];
                      return _TarjetaVehiculo(
                        vehiculo: vehiculo,
                        alEditar: () => _abrirFormulario(existente: vehiculo),
                        alEliminar: () => _confirmarEliminar(vehiculo),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}

class _TarjetaVehiculo extends StatelessWidget {
  const _TarjetaVehiculo({
    required this.vehiculo,
    required this.alEditar,
    required this.alEliminar,
  });

  final Vehiculo vehiculo;
  final VoidCallback alEditar;
  final VoidCallback alEliminar;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final detalle = StringBuffer('${vehiculo.capacidadMaxima.toStringAsFixed(0)} kg');
    if (vehiculo.costoEstimadoPorKm != null) {
      detalle.write(' · S/${vehiculo.costoEstimadoPorKm!.toStringAsFixed(2)}/km');
    }
    if (vehiculo.tipoFlota != null) {
      detalle.write(' · ${vehiculo.tipoFlota}');
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: alEditar,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  LucideIcons.truck,
                  color: colorScheme.onTertiaryContainer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      vehiculo.nombre,
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      detalle.toString(),
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
  const _EstadoVacio({required this.alAgregar});

  final VoidCallback alAgregar;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.truck,
              size: 40,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              'Todavía no hay vehículos.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: alAgregar,
              icon: const Icon(LucideIcons.plus),
              label: const Text('Agregar el primero'),
            ),
          ],
        ),
      ),
    );
  }
}
