import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/indicador.dart';
import '../../../data/models/periodo.dart';
import '../../../data/repositories/medicion_repository.dart';
import '../../../data/repositories/periodo_repository.dart';
import '../../widgets/grafica_serie_banda.dart';

/// Pantalla 7 (CLAUDE.md sección 9): serie temporal del indicador con banda
/// sombreada. El estado por periodo (normal/observación/desviación) llega
/// en la Fase 3, cuando exista M1 -- acá todavía es solo la serie cruda
/// contra la banda, a propósito.
class DetalleIndicadorScreen extends StatefulWidget {
  const DetalleIndicadorScreen({super.key, required this.indicador});

  final Indicador indicador;

  @override
  State<DetalleIndicadorScreen> createState() => _DetalleIndicadorScreenState();
}

class _DetalleIndicadorScreenState extends State<DetalleIndicadorScreen> {
  bool _cargando = true;
  List<Periodo> _periodos = [];
  Map<int, double> _valoresPorPeriodoId = {};

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _cargando = true);
    final periodoRepo = context.read<PeriodoRepository>();
    final medicionRepo = context.read<MedicionRepository>();
    final periodos = await periodoRepo.obtenerPorOrganizacion(widget.indicador.organizacionId);
    final mediciones = await medicionRepo.obtenerPorIndicador(widget.indicador.id!);
    if (!mounted) return;
    setState(() {
      _periodos = periodos;
      _valoresPorPeriodoId = {for (final m in mediciones) m.periodoId: m.valor};
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final indicador = widget.indicador;
    return Scaffold(
      appBar: AppBar(title: Text(indicador.nombre)),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _valoresPorPeriodoId.isEmpty
          ? const _SinMediciones()
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    spacing: 16,
                    runSpacing: 4,
                    children: [
                      Text(
                        'Meta: ${indicador.meta.toStringAsFixed(indicador.decimales)} ${indicador.unidad}',
                      ),
                      Text(
                        'Banda: ${indicador.bandaInferior.toStringAsFixed(indicador.decimales)} – '
                        '${indicador.bandaSuperior.toStringAsFixed(indicador.decimales)} ${indicador.unidad}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GraficaSerieBanda(
                      indicador: indicador,
                      periodos: _periodos,
                      valoresPorPeriodoId: _valoresPorPeriodoId,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _SinMediciones extends StatelessWidget {
  const _SinMediciones();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Este indicador todavía no tiene mediciones -- captúralas desde Captura.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
