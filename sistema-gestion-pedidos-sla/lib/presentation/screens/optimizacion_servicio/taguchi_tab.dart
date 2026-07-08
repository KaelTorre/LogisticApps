import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../providers/taguchi_provider.dart';
import '../_shared/campo_con_ayuda.dart';
import '../_shared/tarjeta_explicacion.dart';

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
                        'No alcanza con estar "dentro del rango aceptable": '
                        'cuanto más se aleja un resultado real de tu objetivo, '
                        'más te cuesta (reclamos, reprocesos, clientes '
                        'insatisfechos) — y ese costo crece cada vez más '
                        'rápido, no de forma pareja. Esta calculadora te da un '
                        'número concreto de esa pérdida, útil para comparar '
                        'escenarios o justificar cuánto vale la pena invertir '
                        'en reducir la variabilidad del servicio (no solo en '
                        'mejorar el promedio).',
                  ),
                  const SizedBox(height: 20),
                  CampoConAyuda(
                    controller: _kCtrl,
                    etiqueta: 'Constante (k)',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    tituloAyuda: '¿Qué es la constante k?',
                    descripcionAyuda:
                        'Es el "precio" de una unidad de desviación al '
                        'cuadrado: convierte la distancia entre lo real y lo '
                        'esperado en un costo. Una forma común de estimarla: '
                        'dividí el costo de una falla grave (perder un '
                        'cliente, una devolución, una penalidad) entre el '
                        'cuadrado de la tolerancia máxima que estarías '
                        'dispuesto a aceptar antes de que ocurra esa falla — '
                        'k = costo de la falla ÷ tolerancia².',
                    ejemplo:
                        'Si una entrega que se atrasa más de 4 horas te genera '
                        'en promedio un reclamo que cuesta S/ 8,000 en '
                        'compensaciones y reputación: k = 8000 / 4² = 500.',
                  ),
                  const SizedBox(height: 16),
                  CampoConAyuda(
                    controller: _yCtrl,
                    etiqueta: 'Valor observado (y)',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    tituloAyuda: '¿Qué es el valor observado (y)?',
                    descripcionAyuda:
                        'Es el dato real que mediste en un caso puntual — '
                        'cuánto tardó realmente un pedido en entregarse, '
                        'cuántas unidades llegaron realmente, etc. No se '
                        'guarda entre cálculos: es para simular "¿qué pasa si '
                        'en este caso concreto el resultado fue este?".',
                    ejemplo:
                        'Prometiste entregar en 10 horas y esta vez el pedido '
                        'tardó 12 horas reales → y = 12.',
                  ),
                  const SizedBox(height: 16),
                  CampoConAyuda(
                    controller: _mCtrl,
                    etiqueta: 'Valor objetivo (m)',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    tituloAyuda: '¿Qué es el valor objetivo (m)?',
                    descripcionAyuda:
                        'Es la meta o el valor ideal que deberías haber '
                        'alcanzado: el tiempo prometido, la cantidad exacta '
                        'pedida, etc. A diferencia de "y", sí se guarda entre '
                        'cálculos — normalmente tu objetivo no cambia de un '
                        'caso a otro.',
                    ejemplo:
                        'Si tu SLA promete entregar en 10 horas, m = 10, sin '
                        'importar cuánto haya tardado cada pedido individual.',
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'L = k · (y − m)² — penalización de costo por desviarse '
                      'del objetivo.',
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
                  if (provider.resultadoPerdida != null)
                    Card(
                      color: colorScheme.tertiaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              'L = ${provider.resultadoPerdida!.toStringAsFixed(4)}',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    color: colorScheme.onTertiaryContainer,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            Text(
                              'Pérdida estimada por desviarte del objetivo — '
                              '0 es dar justo en el blanco',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: colorScheme.onTertiaryContainer,
                                  ),
                            ),
                          ],
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
