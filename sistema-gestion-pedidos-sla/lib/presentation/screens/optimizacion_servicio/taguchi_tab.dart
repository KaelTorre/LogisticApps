import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../providers/taguchi_provider.dart';

/// Calculadora de función de pérdida de Taguchi (M5, CLAUDE.md §6.5).
class TaguchiTab extends StatefulWidget {
  const TaguchiTab({super.key});

  @override
  State<TaguchiTab> createState() => _TaguchiTabState();
}

class _TaguchiTabState extends State<TaguchiTab> {
  final _kCtrl = TextEditingController();
  final _yCtrl = TextEditingController();
  final _mCtrl = TextEditingController();
  bool _controladoresInicializados = false;

  @override
  void dispose() {
    _kCtrl.dispose();
    _yCtrl.dispose();
    _mCtrl.dispose();
    super.dispose();
  }

  Future<void> _calcular(TaguchiProvider provider) async {
    final k = double.tryParse(_kCtrl.text.trim());
    final y = double.tryParse(_yCtrl.text.trim());
    final m = double.tryParse(_mCtrl.text.trim());
    if (k == null || y == null || m == null) return;
    await provider.calcular(k: k, y: y, m: m);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaguchiProvider>(
      builder: (context, provider, _) {
        if (!provider.cargado) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!_controladoresInicializados) {
          _kCtrl.text = provider.constanteK?.toString() ?? '';
          _mCtrl.text = provider.valorObjetivoM?.toString() ?? '';
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
                    'L = k · (y − m)² — penalización de costo por desviarse del objetivo.',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _kCtrl,
                    decoration: const InputDecoration(labelText: 'Constante (k)'),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _yCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Valor observado (y)',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _mCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Valor objetivo (m)',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => _calcular(provider),
                    icon: const Icon(LucideIcons.calculator),
                    label: const Text('Calcular'),
                  ),
                  const SizedBox(height: 24),
                  if (provider.resultadoPerdida != null)
                    Card(
                      color: colorScheme.tertiaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'L = ${provider.resultadoPerdida!.toStringAsFixed(4)}',
                          textAlign: TextAlign.center,
                          style: textTheme.headlineSmall?.copyWith(
                            color: colorScheme.onTertiaryContainer,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
