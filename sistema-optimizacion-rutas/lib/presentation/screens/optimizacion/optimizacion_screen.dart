import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../data/models/escenario_optimizacion.dart';
import '../../../data/models/punto_entrega.dart';
import '../../../data/models/vehiculo.dart';
import '../../providers/escenario_provider.dart';
import '../mapa_resultado/mapa_resultado_screen.dart';

/// Pantalla de Optimización (sección 8 de CLAUDE.md): elegir depósito,
/// método, puntos de entrega y vehículos, y disparar el cálculo.
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
              historialRepository: context.read(),
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
    return Consumer<EscenarioProvider>(
      builder: (context, provider, _) {
        if (provider.cargandoDatosIniciales) {
          return Scaffold(
            appBar: AppBar(title: const Text('Optimización')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (provider.depositoSeleccionado == null) {
          final colorScheme = Theme.of(context).colorScheme;
          return Scaffold(
            appBar: AppBar(title: const Text('Optimización')),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.warehouse,
                      size: 40,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No hay ningún depósito configurado todavía. Ve a '
                      'Depósitos para crear uno.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final calculando = provider.estado == EstadoCalculo.cargando;

        return Scaffold(
          appBar: AppBar(title: const Text('Optimización')),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                children: [
                  _SeccionDeposito(provider: provider)
                      .animate()
                      .fadeIn(duration: 250.ms)
                      .slideY(begin: 0.06, end: 0, curve: Curves.easeOut),
                  const SizedBox(height: 20),
                  _SeccionMetodo(provider: provider)
                      .animate()
                      .fadeIn(delay: 60.ms, duration: 250.ms)
                      .slideY(begin: 0.06, end: 0, curve: Curves.easeOut),
                  const SizedBox(height: 20),
                  _SeccionSeleccionable<PuntoEntrega>(
                        icono: LucideIcons.mapPin,
                        titulo: 'Puntos de entrega',
                        items: provider.puntosDisponibles,
                        idDe: (p) => p.id!,
                        etiquetaDe: (p) => p.nombre,
                        subtituloDe: (p) =>
                            '${p.demanda.toStringAsFixed(0)} kg',
                        seleccionados: provider.puntosSeleccionadosIds,
                        alTocar: provider.alternarPunto,
                      )
                      .animate()
                      .fadeIn(delay: 120.ms, duration: 250.ms)
                      .slideY(begin: 0.06, end: 0, curve: Curves.easeOut),
                  const SizedBox(height: 20),
                  _SeccionSeleccionable<Vehiculo>(
                        icono: LucideIcons.truck,
                        titulo: 'Vehículos',
                        items: provider.vehiculosDisponibles,
                        idDe: (v) => v.id!,
                        etiquetaDe: (v) => v.nombre,
                        subtituloDe: (v) =>
                            '${v.capacidadMaxima.toStringAsFixed(0)} kg'
                            '${v.tipoFlota != null ? ' · ${v.tipoFlota}' : ''}',
                        seleccionados: provider.vehiculosSeleccionadosIds,
                        alTocar: provider.alternarVehiculo,
                      )
                      .animate()
                      .fadeIn(delay: 180.ms, duration: 250.ms)
                      .slideY(begin: 0.06, end: 0, curve: Curves.easeOut),
                  // Banner de error: va en el body scrollable para que nunca
                  // empuje el botón Calcular fuera de pantalla en Android.
                  if (provider.estado == EstadoCalculo.error &&
                      provider.mensajeError != null) ...
                    [
                      const SizedBox(height: 20),
                      _BannerError(mensaje: provider.mensajeError!)
                          .animate()
                          .fadeIn(duration: 200.ms)
                          .slideY(begin: 0.1, end: 0, curve: Curves.easeOut),
                    ],
                  // Deja lugar para no quedar tapado por la barra inferior.
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          bottomNavigationBar: _BarraResumenYAccion(
            provider: provider,
            calculando: calculando,
            onCalcular: () => _calcularYNavegar(context, provider),
          ),
        );
      },
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
            deposito: provider.depositoSeleccionado!,
            rutas: provider.rutas,
            vehiculosFaltantes: provider.vehiculosFaltantes,
            metodo: provider.metodo,
          ),
        ),
      );
    }
  }
}

/// Contenedor de ícono redondeado reutilizado por los encabezados de
/// sección y las filas seleccionables — mismo lenguaje visual que las
/// tarjetas del Home (`home_screen.dart`).
class _AvatarIcono extends StatelessWidget {
  const _AvatarIcono({
    required this.icono,
    required this.colorFondo,
    required this.colorIcono,
    this.tamanio = 44,
    this.tamanioIcono = 22,
  });

  final IconData icono;
  final Color colorFondo;
  final Color colorIcono;
  final double tamanio;
  final double tamanioIcono;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tamanio,
      height: tamanio,
      decoration: BoxDecoration(
        color: colorFondo,
        borderRadius: BorderRadius.circular(tamanio * 0.32),
      ),
      child: Icon(icono, size: tamanioIcono, color: colorIcono),
    );
  }
}

class _SeccionDeposito extends StatelessWidget {
  const _SeccionDeposito({required this.provider});

  final EscenarioProvider provider;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            _AvatarIcono(
              icono: LucideIcons.warehouse,
              colorFondo: colorScheme.primaryContainer,
              colorIcono: colorScheme.onPrimaryContainer,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<int>(
                initialValue: provider.depositoSeleccionado!.id,
                decoration: const InputDecoration(
                  labelText: 'Depósito',
                  border: InputBorder.none,
                  isDense: true,
                ),
                items: [
                  for (final deposito in provider.depositosDisponibles)
                    DropdownMenuItem(
                      value: deposito.id,
                      child: Text(deposito.nombre),
                    ),
                ],
                onChanged: (id) => provider.elegirDeposito(id!),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SeccionMetodo extends StatelessWidget {
  const _SeccionMetodo({required this.provider});

  final EscenarioProvider provider;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TarjetaMetodo(
            icono: LucideIcons.gitMerge,
            titulo: 'Ahorros',
            descripcion: 'Fusiona rutas cercanas entre sí.',
            seleccionado: provider.metodo == MetodoOptimizacion.ahorros,
            onTap: () => provider.elegirMetodo(MetodoOptimizacion.ahorros),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _TarjetaMetodo(
            icono: LucideIcons.radar,
            titulo: 'Barrido',
            descripcion: 'Agrupa por sector angular.',
            seleccionado: provider.metodo == MetodoOptimizacion.barrido,
            onTap: () => provider.elegirMetodo(MetodoOptimizacion.barrido),
          ),
        ),
      ],
    );
  }
}

class _TarjetaMetodo extends StatelessWidget {
  const _TarjetaMetodo({
    required this.icono,
    required this.titulo,
    required this.descripcion,
    required this.seleccionado,
    required this.onTap,
  });

  final IconData icono;
  final String titulo;
  final String descripcion;
  final bool seleccionado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      color: seleccionado ? colorScheme.primaryContainer : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: seleccionado ? colorScheme.primary : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    icono,
                    color: seleccionado
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSurfaceVariant,
                  ),
                  Icon(
                    seleccionado
                        ? LucideIcons.circleCheck
                        : LucideIcons.circle,
                    size: 18,
                    color: seleccionado
                        ? colorScheme.primary
                        : colorScheme.outline,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                titulo,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: seleccionado ? colorScheme.onPrimaryContainer : null,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                descripcion,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: seleccionado
                      ? colorScheme.onPrimaryContainer.withValues(alpha: 0.8)
                      : colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SeccionSeleccionable<T> extends StatelessWidget {
  const _SeccionSeleccionable({
    required this.icono,
    required this.titulo,
    required this.items,
    required this.idDe,
    required this.etiquetaDe,
    required this.subtituloDe,
    required this.seleccionados,
    required this.alTocar,
  });

  final IconData icono;
  final String titulo;
  final List<T> items;
  final int Function(T) idDe;
  final String Function(T) etiquetaDe;
  final String Function(T) subtituloDe;
  final Set<int> seleccionados;
  final void Function(int id) alTocar;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _AvatarIcono(
                  icono: icono,
                  colorFondo: colorScheme.secondaryContainer,
                  colorIcono: colorScheme.onSecondaryContainer,
                  tamanio: 36,
                  tamanioIcono: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    titulo,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${seleccionados.length}/${items.length}',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    for (final item in items) {
                      if (!seleccionados.contains(idDe(item))) {
                        alTocar(idDe(item));
                      }
                    }
                  },
                  icon: const Icon(LucideIcons.checkCheck, size: 16),
                  label: const Text('Todos'),
                ),
                TextButton.icon(
                  onPressed: () {
                    for (final item in items) {
                      if (seleccionados.contains(idDe(item))) {
                        alTocar(idDe(item));
                      }
                    }
                  },
                  icon: const Icon(LucideIcons.x, size: 16),
                  label: const Text('Ninguno'),
                ),
              ],
            ),
            for (final item in items)
              _FilaSeleccionable(
                icono: icono,
                titulo: etiquetaDe(item),
                subtitulo: subtituloDe(item),
                seleccionado: seleccionados.contains(idDe(item)),
                onTap: () => alTocar(idDe(item)),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _FilaSeleccionable extends StatelessWidget {
  const _FilaSeleccionable({
    required this.icono,
    required this.titulo,
    required this.subtitulo,
    required this.seleccionado,
    required this.onTap,
  });

  final IconData icono;
  final String titulo;
  final String subtitulo;
  final bool seleccionado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Material(
        color: seleccionado
            ? colorScheme.primaryContainer.withValues(alpha: 0.35)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                _AvatarIcono(
                  icono: icono,
                  colorFondo: colorScheme.surfaceContainerHighest,
                  colorIcono: colorScheme.onSurfaceVariant,
                  tamanio: 36,
                  tamanioIcono: 18,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        titulo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        subtitulo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  seleccionado ? LucideIcons.circleCheck : LucideIcons.circle,
                  size: 20,
                  color: seleccionado
                      ? colorScheme.primary
                      : colorScheme.outline,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BarraResumenYAccion extends StatelessWidget {
  const _BarraResumenYAccion({
    required this.provider,
    required this.calculando,
    required this.onCalcular,
  });

  final EscenarioProvider provider;
  final bool calculando;
  final VoidCallback onCalcular;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final metodoLabel = provider.metodo == MetodoOptimizacion.ahorros
        ? 'Ahorros'
        : 'Barrido';

    return Material(
      color: colorScheme.surface,
      elevation: 4,
      child: SafeArea(
        top: false,
        // `Row` en vez de `Center`/`Align`: estos últimos se expanden a la
        // altura máxima que Scaffold le ofrezca al bottomNavigationBar (que
        // puede ser casi toda la pantalla), empujando el body a un espacio
        // mínimo. `Row` centra horizontalmente sin reclamar más alto que el
        // de su contenido.
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        _EstadisticaResumen(
                          icono: LucideIcons.mapPin,
                          texto:
                              '${provider.puntosSeleccionadosIds.length}/'
                              '${provider.puntosDisponibles.length}',
                        ),
                        const SizedBox(width: 16),
                        _EstadisticaResumen(
                          icono: LucideIcons.truck,
                          texto:
                              '${provider.vehiculosSeleccionadosIds.length}/'
                              '${provider.vehiculosDisponibles.length}',
                        ),
                        const Spacer(),
                        _EstadisticaResumen(
                          icono: provider.metodo == MetodoOptimizacion.ahorros
                              ? LucideIcons.gitMerge
                              : LucideIcons.radar,
                          texto: metodoLabel,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton.icon(
                        onPressed: calculando ? null : onCalcular,
                        icon: calculando
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(LucideIcons.play),
                        label: Text(
                          calculando ? 'Calculando...' : 'Calcular ruta',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EstadisticaResumen extends StatelessWidget {
  const _EstadisticaResumen({required this.icono, required this.texto});

  final IconData icono;
  final String texto;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icono, size: 16, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Text(texto, style: Theme.of(context).textTheme.bodyMedium),
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
