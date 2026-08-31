import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/estado/proyecto_activo.dart';
import '../../../data/models/escenario.dart';
import '../../../data/repositories/escenario_asignacion_repository.dart';
import '../../../data/repositories/escenario_costo_repository.dart';
import '../../../data/repositories/escenario_repository.dart';
import '../../../data/repositories/parametros_costo_repository.dart';
import '../../../domain/motor/m9_comparador.dart';
import '../../estilos_rubro.dart';
import '../../widgets/selector_escenario.dart';

/// Pantalla 15 (CLAUDE.md sección 8): dos escenarios lado a lado — M9
/// (Fase 7) calcula la diferencia de costo por rubro, qué almacenes abren y
/// cierran, qué zonas cambian de asignación, el ahorro anual y la
/// variación del cumplimiento del estándar de servicio.
class ComparadorEscenariosScreen extends StatefulWidget {
  const ComparadorEscenariosScreen({super.key});

  @override
  State<ComparadorEscenariosScreen> createState() => _ComparadorEscenariosScreenState();
}

class _ComparadorEscenariosScreenState extends State<ComparadorEscenariosScreen> {
  bool _cargando = true;
  List<Escenario> _escenarios = [];
  Escenario? _base;
  Escenario? _comparado;
  ResultadoComparacion? _resultado;

  int get _proyectoId => context.read<ProyectoActivo>().proyecto!.id!;

  @override
  void initState() {
    super.initState();
    _cargarEscenarios();
  }

  Future<void> _cargarEscenarios() async {
    setState(() => _cargando = true);
    final escenarios = await context.read<EscenarioRepository>().obtenerPorProyecto(_proyectoId);
    if (!mounted) return;
    setState(() {
      _escenarios = escenarios;
      _cargando = false;
      if (escenarios.length >= 2) {
        _base = escenarios[escenarios.length - 2];
        _comparado = escenarios.last;
      }
    });
    if (_base != null && _comparado != null) await _comparar();
  }

  Future<EscenarioDatos> _datosDe(Escenario escenario) async {
    final costoRepo = context.read<EscenarioCostoRepository>();
    final asignacionRepo = context.read<EscenarioAsignacionRepository>();

    final costos = await costoRepo.obtenerPorEscenario(escenario.id!);
    final asignaciones = await asignacionRepo.obtenerPorEscenario(escenario.id!);

    return EscenarioDatos(
      costoTotalCent: escenario.costoTotalCent,
      porRubro: {for (final c in costos) c.rubro: c.montoCent},
      almacenesAbiertos: asignaciones.map((a) => a.sitioCandidatoId).toSet(),
      asignacionZonaCandidato: {for (final a in asignaciones) a.zonaId: a.sitioCandidatoId},
      distanciaZonaAsignada: {for (final a in asignaciones) a.zonaId: (a.distanciaMetros, a.duracionSegundos)},
    );
  }

  Future<void> _comparar() async {
    final base = _base;
    final comparado = _comparado;
    if (base == null || comparado == null) {
      setState(() => _resultado = null);
      return;
    }

    final params = await context.read<ParametrosCostoRepository>().obtenerPorProyecto(_proyectoId);
    if (params == null) return;

    final datosBase = await _datosDe(base);
    final datosComparado = await _datosDe(comparado);

    if (!mounted) return;
    setState(() {
      _resultado = compararEscenarios(base: datosBase, comparado: datosComparado, params: params);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_escenarios.length < 2) {
      return Scaffold(
        appBar: AppBar(title: const Text('Comparador de escenarios')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Necesitas al menos dos escenarios calculados para comparar. '
              'Corre otra optimización desde Optimización.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Comparador de escenarios')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SelectorEscenario(
                    escenarios: _escenarios,
                    seleccionado: _base,
                    etiqueta: 'Base',
                    onCambiar: (e) {
                      setState(() => _base = e);
                      _comparar();
                    },
                  ),
                  const SizedBox(height: 12),
                  SelectorEscenario(
                    escenarios: _escenarios,
                    seleccionado: _comparado,
                    etiqueta: 'Comparado',
                    onCambiar: (e) {
                      setState(() => _comparado = e);
                      _comparar();
                    },
                  ),
                  const SizedBox(height: 24),
                  if (_resultado != null) _PanelResultado(resultado: _resultado!),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PanelResultado extends StatelessWidget {
  const _PanelResultado({required this.resultado});

  final ResultadoComparacion resultado;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final ahorra = resultado.ahorroAnualCent >= 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          color: ahorra ? colorScheme.primaryContainer : colorScheme.errorContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '${ahorra ? "Ahorro" : "Sobrecosto"} anual del comparado sobre la base: '
              '${(resultado.ahorroAnualCent.abs() / 100).toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text('Diferencia por rubro (comparado − base)', style: Theme.of(context).textTheme.titleSmall),
        for (final rubro in etiquetasRubro.keys)
          if (resultado.diferenciaPorRubro.containsKey(rubro))
            ListTile(
              dense: true,
              leading: CircleAvatar(backgroundColor: coloresRubro[rubro], radius: 8),
              title: Text(etiquetasRubro[rubro]!),
              trailing: Text(
                (resultado.diferenciaPorRubro[rubro]! / 100).toStringAsFixed(2),
                style: TextStyle(
                  color: resultado.diferenciaPorRubro[rubro]! <= 0 ? Colors.green.shade700 : Colors.red.shade700,
                ),
              ),
            ),
        const Divider(height: 32),
        _FilaResumen(etiqueta: 'Almacenes que abren', valor: '${resultado.almacenesQueAbren.length}'),
        _FilaResumen(etiqueta: 'Almacenes que cierran', valor: '${resultado.almacenesQueCierran.length}'),
        _FilaResumen(
          etiqueta: 'Zonas que cambian de asignación',
          valor: '${resultado.zonasQueCambianAsignacion.length}',
        ),
        _FilaResumen(etiqueta: 'Zonas fuera del estándar — base', valor: '${resultado.zonasNoCubiertasBase}'),
        _FilaResumen(
          etiqueta: 'Zonas fuera del estándar — comparado',
          valor: '${resultado.zonasNoCubiertasComparado}',
        ),
      ],
    );
  }
}

class _FilaResumen extends StatelessWidget {
  const _FilaResumen({required this.etiqueta, required this.valor});

  final String etiqueta;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(etiqueta), Text(valor, style: const TextStyle(fontWeight: FontWeight.w600))],
      ),
    );
  }
}
