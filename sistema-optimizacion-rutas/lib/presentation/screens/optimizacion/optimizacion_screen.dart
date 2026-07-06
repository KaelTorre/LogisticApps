import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../data/models/escenario_optimizacion.dart';
import '../../../data/models/punto_entrega.dart';
import '../../../data/models/vehiculo.dart';
import '../../providers/escenario_provider.dart';
import '../mapa_resultado/mapa_resultado_screen.dart';

/// Pantalla de Optimización (sección 8 de CLAUDE.md): elegir puntos de
/// entrega, vehículos disponibles y método, y disparar el cálculo.
class OptimizacionScreen extends StatelessWidget {
  const OptimizacionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EscenarioProvider>(
      create: (context) =>
          EscenarioProvider(
              depositoRepository: context.read(),
              puntoEntregaRepository: context.read(),
              vehiculoRepository: context.read(),
              osrmClient: context.read(),
            )
            ..cargarDatosIniciales(),
      child: const _OptimizacionBody(),
    );
  }
}

class _OptimizacionBody extends StatelessWidget {
  const _OptimizacionBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Optimización')),
      body: Consumer<EscenarioProvider>(
        builder: (context, provider, _) {
          if (provider.cargandoDatosIniciales) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.deposito == null) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No hay un depósito configurado todavía.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final calculando = provider.estado == EstadoCalculo.cargando;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Método', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              SegmentedButton<MetodoOptimizacion>(
                segments: const [
                  ButtonSegment(
                    value: MetodoOptimizacion.ahorros,
                    label: Text('Ahorros'),
                    icon: Icon(LucideIcons.gitMerge),
                  ),
                  ButtonSegment(
                    value: MetodoOptimizacion.barrido,
                    label: Text('Barrido'),
                    icon: Icon(LucideIcons.radar),
                  ),
                ],
                selected: {provider.metodo},
                onSelectionChanged: (seleccion) =>
                    provider.elegirMetodo(seleccion.first),
              ),
              const SizedBox(height: 24),
              _SeccionSeleccion<PuntoEntrega>(
                titulo: 'Puntos de entrega',
                items: provider.puntosDisponibles,
                idDe: (p) => p.id!,
                etiquetaDe: (p) => p.nombre,
                subtituloDe: (p) => '${p.demanda.toStringAsFixed(0)} kg',
                seleccionados: provider.puntosSeleccionadosIds,
                alTocar: provider.alternarPunto,
              ),
              const SizedBox(height: 24),
              _SeccionSeleccion<Vehiculo>(
                titulo: 'Vehículos',
                items: provider.vehiculosDisponibles,
                idDe: (v) => v.id!,
                etiquetaDe: (v) => v.nombre,
                subtituloDe: (v) =>
                    '${v.capacidadMaxima.toStringAsFixed(0)} kg'
                    '${v.tipoFlota != null ? ' · ${v.tipoFlota}' : ''}',
                seleccionados: provider.vehiculosSeleccionadosIds,
                alTocar: provider.alternarVehiculo,
              ),
              const SizedBox(height: 24),
              if (provider.estado == EstadoCalculo.error &&
                  provider.mensajeError != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _BannerError(mensaje: provider.mensajeError!),
                ),
              FilledButton.icon(
                onPressed: calculando
                    ? null
                    : () => _calcularYNavegar(context, provider),
                icon: calculando
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(LucideIcons.play),
                label: Text(calculando ? 'Calculando...' : 'Calcular ruta'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _calcularYNavegar(
    BuildContext context,
    EscenarioProvider provider,
  ) async {
    await provider.calcular();
    if (!context.mounted) return;
    if (provider.estado == EstadoCalculo.listo) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => MapaResultadoScreen(
            deposito: provider.deposito!,
            rutas: provider.rutas,
            vehiculosFaltantes: provider.vehiculosFaltantes,
          ),
        ),
      );
    }
  }
}

class _SeccionSeleccion<T> extends StatelessWidget {
  const _SeccionSeleccion({
    required this.titulo,
    required this.items,
    required this.idDe,
    required this.etiquetaDe,
    required this.subtituloDe,
    required this.seleccionados,
    required this.alTocar,
  });

  final String titulo;
  final List<T> items;
  final int Function(T) idDe;
  final String Function(T) etiquetaDe;
  final String Function(T) subtituloDe;
  final Set<int> seleccionados;
  final void Function(int id) alTocar;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$titulo (${seleccionados.length}/${items.length})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    for (final item in items) {
                      if (!seleccionados.contains(idDe(item))) {
                        alTocar(idDe(item));
                      }
                    }
                  },
                  child: const Text('Todos'),
                ),
                TextButton(
                  onPressed: () {
                    for (final item in items) {
                      if (seleccionados.contains(idDe(item))) {
                        alTocar(idDe(item));
                      }
                    }
                  },
                  child: const Text('Ninguno'),
                ),
              ],
            ),
          ],
        ),
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: items
                .map(
                  (item) => CheckboxListTile(
                    value: seleccionados.contains(idDe(item)),
                    onChanged: (_) => alTocar(idDe(item)),
                    title: Text(etiquetaDe(item)),
                    subtitle: Text(subtituloDe(item)),
                    dense: true,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _BannerError extends StatelessWidget {
  const _BannerError({required this.mensaje});

  final String mensaje;

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
          Icon(LucideIcons.circleAlert, color: colorScheme.onErrorContainer),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              mensaje,
              style: TextStyle(color: colorScheme.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }
}
