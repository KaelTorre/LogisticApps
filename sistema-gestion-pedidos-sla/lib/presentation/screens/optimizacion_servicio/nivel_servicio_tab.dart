import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../domain/optimizacion_nivel_servicio.dart';
import '../../providers/optimizacion_servicio_provider.dart';
import '../_shared/campo_con_ayuda.dart';
import '../_shared/tarjeta_explicacion.dart';

/// Calculadora de nivel de servicio óptimo (M4, CLAUDE.md §6.4).
class NivelServicioTab extends StatefulWidget {
  const NivelServicioTab({super.key});

  @override
  State<NivelServicioTab> createState() => _NivelServicioTabState();
}

class _NivelServicioTabState extends State<NivelServicioTab> {
  final _aCtrl = TextEditingController();
  final _bCtrl = TextEditingController();
  bool _controladoresInicializados = false;

  @override
  void dispose() {
    _aCtrl.dispose();
    _bCtrl.dispose();
    super.dispose();
  }

  Future<void> _calcular(OptimizacionServicioProvider provider) async {
    final a = double.tryParse(_aCtrl.text.trim());
    final b = double.tryParse(_bCtrl.text.trim());
    if (a == null || b == null) return;
    await provider.calcular(a: a, b: b);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OptimizacionServicioProvider>(
      builder: (context, provider, _) {
        if (!provider.cargado) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!_controladoresInicializados) {
          _aCtrl.text = provider.coeficienteIngreso.toString();
          _bCtrl.text = provider.coeficienteCosto.toString();
          _controladoresInicializados = true;
        }

        final colorScheme = Theme.of(context).colorScheme;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const TarjetaExplicacion(
                    titulo: '¿Qué calcula esto?',
                    cuerpo:
                        'Mejorar el nivel de servicio (entregar más rápido, tener '
                        'menos quiebres de stock, menos errores) aumenta tus '
                        'ventas, pero también aumenta tus costos — y ese costo '
                        'crece cada vez más rápido cuanto más cerca del 100% '
                        'querés estar. Esta calculadora encuentra el punto exacto '
                        '(SL*) donde ganar un poco más de servicio ya no '
                        'compensa lo que cuesta lograrlo: el nivel de servicio '
                        'que te deja la mayor utilidad posible, no el más alto '
                        'posible.',
                  ),
                  const SizedBox(height: 20),
                  CampoConAyuda(
                    controller: _aCtrl,
                    etiqueta: 'Coeficiente de ingreso (a)',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    tituloAyuda: '¿Qué es el coeficiente de ingreso (a)?',
                    descripcionAyuda:
                        'Mide qué tan rápido crecen tus ingresos cuando subís el '
                        'nivel de servicio. En la fórmula acompaña a √SL: el '
                        'ingreso crece rápido al principio y luego se '
                        'desacelera (las primeras mejoras de servicio traen '
                        'más ventas nuevas que las últimas). Se estima '
                        'comparando ventas históricas contra el nivel de '
                        'servicio que tenías en ese momento (distintos '
                        'periodos, sucursales, o el dato que te dé el caso de '
                        'estudio).',
                    ejemplo:
                        'a = 0.5 es el valor del caso del PDF del curso. Cuanto '
                        'más alto sea "a", más te conviene invertir en mejorar '
                        'el servicio porque el impacto en tus ventas es mayor.',
                  ),
                  const SizedBox(height: 16),
                  CampoConAyuda(
                    controller: _bCtrl,
                    etiqueta: 'Coeficiente de costo (b)',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    tituloAyuda: '¿Qué es el coeficiente de costo (b)?',
                    descripcionAyuda:
                        'Mide qué tan rápido crece el costo de sostener ese '
                        'nivel de servicio. A diferencia del ingreso, en la '
                        'fórmula acompaña a SL² (crece cada vez más rápido): '
                        'cada punto adicional cerca del 100% es '
                        'desproporcionadamente más caro que el anterior (más '
                        'inventario de seguridad, envíos urgentes, personal '
                        'extra). Se estima con tus costos logísticos '
                        'históricos a distintos niveles de servicio.',
                    ejemplo:
                        'b = 0.00055 es el valor del caso del PDF del curso. Si '
                        'tus costos son muy sensibles al nivel de servicio (por '
                        'ejemplo, porque dependés de tercerizar envíos '
                        'urgentes), tu "b" real sería más alto.',
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'P(SL) = a·√SL − b·SL² — el nivel de servicio (SL) se '
                      'expresa en porcentaje, de 0 a 100.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: () => _calcular(provider),
                    icon: const Icon(LucideIcons.calculator),
                    label: const Text('Calcular'),
                  ),
                  const SizedBox(height: 24),
                  if (provider.estado == EstadoOptimizacion.error)
                    Text(
                      provider.mensajeError ?? '',
                      style: TextStyle(color: colorScheme.error),
                    ),
                  if (provider.resultado != null)
                    _TarjetaResultado(resultado: provider.resultado!),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TarjetaResultado extends StatelessWidget {
  const _TarjetaResultado({required this.resultado});

  final ResultadoOptimizacionServicio resultado;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'SL* = ${resultado.slOptimo.toStringAsFixed(2)}%',
              style: textTheme.headlineSmall?.copyWith(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Nivel de servicio óptimo — el que maximiza tu utilidad',
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'P(SL*) = ${resultado.pEnOptimo.toStringAsFixed(4)}',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Utilidad estimada al operar en ese punto óptimo',
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
