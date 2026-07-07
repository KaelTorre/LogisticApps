import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../domain/optimizacion_nivel_servicio.dart';
import '../../providers/optimizacion_servicio_provider.dart';

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
        final textTheme = Theme.of(context).textTheme;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'P(SL) = a·√SL − b·SL² — nivel de servicio (SL) en porcentaje, 0 a 100.',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _aCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Coeficiente de ingreso (a)',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _bCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Coeficiente de costo (b)',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                  const SizedBox(height: 24),
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
            const SizedBox(height: 8),
            Text(
              'P(SL*) = ${resultado.pEnOptimo.toStringAsFixed(4)}',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
