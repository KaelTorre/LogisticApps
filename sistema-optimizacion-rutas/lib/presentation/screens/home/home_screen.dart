import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../depositos/depositos_screen.dart';
import '../historial/historial_screen.dart';
import '../optimizacion/optimizacion_screen.dart';
import '../puntos_entrega/puntos_entrega_screen.dart';
import '../vehiculos/vehiculos_screen.dart';

/// Color de acento del ícono de cada tarjeta del dashboard (no aplica a
/// [_ModuloInicio.destacado], que usa su propio tratamiento sólido).
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

  /// La tarjeta de Optimización es la acción principal de la app — se
  /// destaca con fondo sólido (`colorScheme.primary`) en vez del acento
  /// tenue de las demás, igual que el tile "central" de una pantalla táctil
  /// de auto.
  final bool destacado;
}

final _moduloDepositos = _ModuloInicio(
  icono: LucideIcons.warehouse,
  titulo: 'Depósitos',
  descripcion: 'Puntos de partida de las rutas — se puede tener varios.',
  pantalla: (_) => const DepositosScreen(),
  acento: _AcentoModulo.primario,
);
final _moduloPuntosEntrega = _ModuloInicio(
  icono: LucideIcons.mapPin,
  titulo: 'Puntos de entrega',
  descripcion: 'Catálogo de clientes y destinos de reparto.',
  pantalla: (_) => const PuntosEntregaScreen(),
  acento: _AcentoModulo.secundario,
);
final _moduloVehiculos = _ModuloInicio(
  icono: LucideIcons.truck,
  titulo: 'Vehículos',
  descripcion: 'Flota disponible, capacidad y costo por km.',
  pantalla: (_) => const VehiculosScreen(),
  acento: _AcentoModulo.terciario,
);
final _moduloHistorial = _ModuloInicio(
  icono: LucideIcons.history,
  titulo: 'Historial',
  descripcion: 'Cálculos anteriores, guardados automáticamente.',
  pantalla: (_) => const HistorialScreen(),
  acento: _AcentoModulo.neutral,
);
final _moduloOptimizacion = _ModuloInicio(
  icono: LucideIcons.route,
  titulo: 'Optimización',
  descripcion: 'Calcular rutas con Ahorros o Barrido.',
  pantalla: (_) => const OptimizacionScreen(),
  destacado: true,
);

final List<_ModuloInicio> _modulos = [
  _moduloDepositos,
  _moduloPuntosEntrega,
  _moduloVehiculos,
  _moduloOptimizacion,
  _moduloHistorial,
];

/// A partir de este ancho se usa la grilla fija de 3 columnas / 2 filas
/// pensada para tablet/escritorio; por debajo, una grilla adaptativa normal
/// (pantallas de celular, donde no entran 3 columnas cómodas).
const double _anchoBreakpointTablet = 700;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Optimización de Rutas VRP')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final esAncho = constraints.maxWidth >= _anchoBreakpointTablet;
            return Padding(
              padding: const EdgeInsets.all(24),
              child: esAncho
                  ? const _GridTabletEscritorio()
                  : const _GridAngosto(),
            );
          },
        ),
      ),
    );
  }
}

/// Grilla de 3 columnas / 2 filas para tablet/escritorio: Depósitos y
/// Vehículos en la primera columna, Puntos de entrega e Historial en la
/// segunda, y Optimización ocupando toda la tercera columna (las dos filas)
/// como acción destacada — a pedido explícito del usuario.
class _GridTabletEscritorio extends StatelessWidget {
  const _GridTabletEscritorio();

  static const _espacio = 20.0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 980),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Se adapta a la altura disponible (con un piso y un techo)
            // para no desbordar en ventanas bajas ni verse minúsculo en
            // pantallas muy altas.
            final alturaFila = ((constraints.maxHeight - _espacio) / 2).clamp(
              160.0,
              240.0,
            );
            return SizedBox(
              height: alturaFila * 2 + _espacio,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: _TarjetaModulo(modulo: _moduloDepositos)
                              .animate()
                              .fadeIn(duration: 250.ms)
                              .slideY(
                                begin: 0.08,
                                end: 0,
                                curve: Curves.easeOut,
                              ),
                        ),
                        const SizedBox(height: _espacio),
                        Expanded(
                          child: _TarjetaModulo(modulo: _moduloVehiculos)
                              .animate()
                              .fadeIn(delay: 60.ms, duration: 250.ms)
                              .slideY(
                                begin: 0.08,
                                end: 0,
                                curve: Curves.easeOut,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: _espacio),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: _TarjetaModulo(modulo: _moduloPuntosEntrega)
                              .animate()
                              .fadeIn(delay: 120.ms, duration: 250.ms)
                              .slideY(
                                begin: 0.08,
                                end: 0,
                                curve: Curves.easeOut,
                              ),
                        ),
                        const SizedBox(height: _espacio),
                        Expanded(
                          child: _TarjetaModulo(modulo: _moduloHistorial)
                              .animate()
                              .fadeIn(delay: 180.ms, duration: 250.ms)
                              .slideY(
                                begin: 0.08,
                                end: 0,
                                curve: Curves.easeOut,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: _espacio),
                  Expanded(
                    child: _TarjetaModulo(modulo: _moduloOptimizacion)
                        .animate()
                        .fadeIn(delay: 240.ms, duration: 250.ms)
                        .slideY(begin: 0.08, end: 0, curve: Curves.easeOut),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Grilla adaptativa simple para celular (1-2 columnas según ancho).
class _GridAngosto extends StatelessWidget {
  const _GridAngosto();

  static const double _anchoColumnaReferencia = 260;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columnas = (constraints.maxWidth / _anchoColumnaReferencia)
            .floor()
            .clamp(1, 2);

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columnas,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            mainAxisExtent: 224,
          ),
          itemCount: _modulos.length,
          itemBuilder: (context, index) {
            final modulo = _modulos[index];
            return _TarjetaModulo(modulo: modulo)
                .animate()
                .fadeIn(delay: (index * 60).ms, duration: 250.ms)
                .slideY(begin: 0.08, end: 0, curve: Curves.easeOut);
          },
        );
      },
    );
  }
}

/// Tarjeta de un módulo del dashboard — ícono grande y centrado, estilo
/// "tile" táctil (pensado para tocarse fácil desde una pantalla de auto o
/// tablet). [_ModuloInicio.destacado] cambia todo el tratamiento de color a
/// sólido (`colorScheme.primary`) en vez del acento tenue de las demás.
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

    // La tarjeta destacada suele tener bastante más alto disponible (ocupa
    // las dos filas), así que un ícono más grande la llena mejor.
    final escala = destacado ? 1.35 : 1.0;
    final tamanioIcono = 32.0 * escala;
    final tamanioContenedorIcono = 64.0 * escala;

    return Card(
      color: destacado ? colorScheme.primary : null,
      elevation: destacado ? 1 : 0,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: modulo.pantalla));
        },
        child: Padding(
          padding: EdgeInsets.all(20 * escala),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: tamanioContenedorIcono,
                height: tamanioContenedorIcono,
                decoration: BoxDecoration(
                  color: colorFondoIcono,
                  borderRadius: BorderRadius.circular(18 * escala),
                ),
                child: Icon(modulo.icono, size: tamanioIcono, color: colorIcono),
              ),
              SizedBox(height: 14 * escala),
              Text(
                modulo.titulo,
                textAlign: TextAlign.center,
                style: (destacado ? textTheme.titleLarge : textTheme.titleMedium)
                    ?.copyWith(color: colorTitulo, fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                modulo.descripcion,
                textAlign: TextAlign.center,
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
