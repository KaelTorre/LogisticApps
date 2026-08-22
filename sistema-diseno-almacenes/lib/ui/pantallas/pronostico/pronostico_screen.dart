import 'package:flutter/material.dart';

import '../../../domain/motor/m1_pronostico.dart';
import '../../widgets/grafica_pronostico.dart';

/// Pantalla 04 de CLAUDE.md sección 10 (parte de "Demanda"): M1, pronóstico
/// de demanda. Independiente del flujo M2/M3 — solo necesita la historia de
/// demanda, no el catálogo. Al elegir "Usar en el cálculo" devuelve
/// (`Navigator.pop`) el valor pronosticado del **último período del
/// horizonte**, nunca el dato histórico más reciente: **[REGLA]** de
/// CLAUDE.md sección 7, M1 — el almacén se dimensiona sobre demanda futura.
class PronosticoScreen extends StatefulWidget {
  const PronosticoScreen({super.key});

  @override
  State<PronosticoScreen> createState() => _PronosticoScreenState();
}

class _PronosticoScreenState extends State<PronosticoScreen> {
  final _formKey = GlobalKey<FormState>();

  final _historicoCtrl = TextEditingController(
    text: '100, 108, 115, 120, 130, 138, 145, 150, 160, 168, 175, 182',
  );
  final _horizonteCtrl = TextEditingController(text: '3');
  final _longitudEstacionalCtrl = TextEditingController(text: '');

  ResultadoM1? _resultado;
  List<double>? _historicoUsado;
  String? _error;

  void _calcular() {
    setState(() => _error = null);
    if (!_formKey.currentState!.validate()) return;

    try {
      final historico = _historicoCtrl.text
          .split(RegExp(r'[,\s]+'))
          .where((s) => s.isNotEmpty)
          .map(double.parse)
          .toList();
      final textoEstacional = _longitudEstacionalCtrl.text.trim();
      final longitudEstacional = textoEstacional.isEmpty ? null : int.parse(textoEstacional);

      setState(() {
        _historicoUsado = historico;
        _resultado = calcularPronostico(
          historico: historico,
          horizonte: int.parse(_horizonteCtrl.text),
          longitudEstacional: longitudEstacional,
        );
      });
    } on FormatException {
      setState(() => _error = 'Revisa que todos los valores sean números válidos.');
    } on ArgumentError catch (e) {
      setState(() => _error = e.message?.toString() ?? 'Entrada inválida.');
    }
  }

  void _usarEnElCalculo() {
    final resultado = _resultado;
    if (resultado == null) return;
    Navigator.of(context).pop(resultado.pronostico.last);
  }

  @override
  void dispose() {
    _historicoCtrl.dispose();
    _horizonteCtrl.dispose();
    _longitudEstacionalCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resultado = _resultado;
    final colores = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Pronóstico de demanda')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colores.secondaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lightbulb_outline, size: 18, color: colores.onSecondaryContainer),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Este paso es opcional. Sirve para estimar cuánta demanda vas a '
                      'tener en el futuro (no cuánta tienes hoy) a partir de tu historial '
                      'de ventas o despachos. Pruébalo con varios modelos estadísticos y '
                      'te dice cuál se ajusta mejor a tus datos. Al terminar, el botón '
                      '"Usar en el cálculo" manda ese número a la pantalla anterior — si '
                      'ya sabes tu demanda futura, puedes saltarte esta pantalla '
                      'directamente.',
                      style: TextStyle(color: colores.onSecondaryContainer, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            _tarjeta(
              context,
              icono: Icons.timeline_outlined,
              titulo: 'Historia de demanda',
              children: [
                TextFormField(
                  controller: _historicoCtrl,
                  minLines: 2,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Períodos históricos',
                    helperText: 'Separados por coma o espacio, en orden cronológico',
                    helperMaxLines: 2,
                    isDense: true,
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: _campo(
                        'Horizonte a pronosticar',
                        _horizonteCtrl,
                        entero: true,
                        ayuda: 'Cuántos períodos futuros proyectar',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _campo(
                        'Longitud estacional (opcional)',
                        _longitudEstacionalCtrl,
                        entero: true,
                        requerido: false,
                        ayuda: 'Ej. 12 si es mensual con patrón anual',
                        tooltip:
                            'Habilita Winters y descomposición clásica. Necesita al '
                            'menos 2 ciclos completos de historia (ej. 24 meses para '
                            'estacionalidad de 12).',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_error != null) _bannerError(context, _error!),
                if (_error != null) const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: _calcular,
                  icon: const Icon(Icons.calculate_outlined),
                  label: const Text('Calcular pronóstico'),
                ),
              ],
            ),
            if (resultado != null) ...[
              const SizedBox(height: 16),
              _tarjeta(
                context,
                icono: Icons.model_training_outlined,
                titulo: 'Modelos evaluados',
                subtitulo: 'Se elige el de menor MAPE',
                children: [
                  for (final modelo in resultado.modelosEvaluados)
                    _filaModelo(context, modelo, esElegido: modelo == resultado.modeloElegido),
                ],
              ),
              const SizedBox(height: 16),
              _tarjeta(
                context,
                icono: Icons.show_chart,
                titulo: 'Pronóstico',
                subtitulo: 'Modelo elegido: ${resultado.modeloElegido.nombre}',
                children: [
                  GraficaPronostico(
                    historico: _historicoUsado!,
                    pronostico: resultado.pronostico,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Valores: ${resultado.pronostico.map((v) => v.toStringAsFixed(1)).join(', ')}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colores.secondaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.flag_outlined, size: 18, color: colores.onSecondaryContainer),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'El almacén se dimensiona con el último período del '
                            'horizonte (${resultado.pronostico.last.toStringAsFixed(1)}), '
                            'no con la demanda actual.',
                            style: TextStyle(color: colores.onSecondaryContainer, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: _usarEnElCalculo,
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Usar en el cálculo'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _filaModelo(BuildContext context, ResultadoModeloPronostico m, {required bool esElegido}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: esElegido ? Colors.green.withValues(alpha: 0.08) : null,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          if (esElegido)
            const Tooltip(
              message: 'Modelo elegido: menor MAPE',
              child: Icon(Icons.star, size: 16, color: Colors.amber),
            )
          else
            const SizedBox(width: 16),
          const SizedBox(width: 6),
          Expanded(
            child: Text(m.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Text('MAPE ${m.mape.toStringAsFixed(1)}%'),
          const SizedBox(width: 10),
          Text('MAD ${m.mad.toStringAsFixed(1)}', style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _tarjeta(
    BuildContext context, {
    required IconData icono,
    required String titulo,
    String? subtitulo,
    required List<Widget> children,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icono, size: 20, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(titulo, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            if (subtitulo != null) ...[
              const SizedBox(height: 2),
              Text(subtitulo, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _campo(
    String etiqueta,
    TextEditingController ctrl, {
    bool entero = false,
    bool requerido = true,
    String? ayuda,
    String? tooltip,
  }) {
    return TextFormField(
      controller: ctrl,
      decoration: InputDecoration(
        labelText: etiqueta,
        helperText: ayuda,
        helperMaxLines: 2,
        isDense: true,
        suffixIcon: tooltip != null
            ? Tooltip(message: tooltip, child: const Icon(Icons.info_outline, size: 18))
            : null,
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: !entero),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return requerido ? 'Requerido' : null;
        final parsed = entero ? int.tryParse(v) : double.tryParse(v);
        if (parsed == null) return 'Número inválido';
        return null;
      },
    );
  }

  Widget _bannerError(BuildContext context, String mensaje) {
    final colores = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: colores.errorContainer, borderRadius: BorderRadius.circular(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, color: colores.onErrorContainer, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(mensaje, style: TextStyle(color: colores.onErrorContainer))),
        ],
      ),
    );
  }
}
