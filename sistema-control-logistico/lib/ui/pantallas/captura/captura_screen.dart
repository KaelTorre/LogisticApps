import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../data/models/indicador.dart';
import '../../../data/models/medicion.dart';
import '../../../data/models/periodo.dart';
import '../../../data/repositories/indicador_repository.dart';
import '../../../data/repositories/medicion_repository.dart';
import '../../../data/repositories/periodo_repository.dart';
import '../../../domain/importacion/importador_csv_mediciones.dart';

const _etiquetasOrigen = {
  'manual': 'Manual',
  'importado': 'Importado',
  'derivado': 'Derivado',
  'sintetico': 'Sintético',
};

/// Pantalla 6 (CLAUDE.md sección 9): ingreso de mediciones del periodo,
/// con importación CSV. Un indicador a la vez -- la fila de cada periodo
/// muestra su medición actual (si existe) y se edita tocándola.
class CapturaScreen extends StatefulWidget {
  const CapturaScreen({super.key, required this.organizacionId});

  final int organizacionId;

  @override
  State<CapturaScreen> createState() => _CapturaScreenState();
}

class _CapturaScreenState extends State<CapturaScreen> {
  bool _cargando = true;
  List<Indicador> _indicadores = [];
  List<Periodo> _periodos = [];
  Indicador? _seleccionado;
  Map<int, Medicion> _medicionesPorPeriodo = {};

  @override
  void initState() {
    super.initState();
    _cargarCatalogo();
  }

  Future<void> _cargarCatalogo() async {
    setState(() => _cargando = true);
    final indicadorRepo = context.read<IndicadorRepository>();
    final periodoRepo = context.read<PeriodoRepository>();
    final indicadores = await indicadorRepo.obtenerPorOrganizacion(widget.organizacionId);
    final periodos = await periodoRepo.obtenerPorOrganizacion(widget.organizacionId);
    if (!mounted) return;
    setState(() {
      _indicadores = indicadores;
      _periodos = periodos;
      _seleccionado = indicadores.isEmpty ? null : indicadores.first;
      _cargando = false;
    });
    if (_seleccionado != null) await _cargarMediciones();
  }

  Future<void> _cargarMediciones() async {
    final seleccionado = _seleccionado;
    if (seleccionado == null) return;
    final mediciones = await context.read<MedicionRepository>().obtenerPorIndicador(
      seleccionado.id!,
    );
    if (!mounted) return;
    setState(() {
      _medicionesPorPeriodo = {for (final m in mediciones) m.periodoId: m};
    });
  }

  Future<void> _editarValor(Periodo periodo) async {
    final indicador = _seleccionado!;
    final existente = _medicionesPorPeriodo[periodo.id];
    final valorCtrl = TextEditingController(text: existente?.valor.toString() ?? '');
    final notaCtrl = TextEditingController(text: existente?.nota ?? '');

    final guardar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(periodo.etiqueta),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: valorCtrl,
              decoration: InputDecoration(labelText: 'Valor (${indicador.unidad})'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
              autofocus: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: notaCtrl,
              decoration: const InputDecoration(labelText: 'Nota (opcional)'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Guardar')),
        ],
      ),
    );
    if (guardar != true || !mounted) return;

    final valor = double.tryParse(valorCtrl.text.trim().replaceAll(',', '.'));
    if (valor == null) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(const SnackBar(showCloseIcon: true, content: Text('Ingresa un valor numérico válido.')));
      return;
    }

    final nota = notaCtrl.text.trim();
    final repo = context.read<MedicionRepository>();
    if (existente == null) {
      await repo.crear(
        Medicion(
          indicadorId: indicador.id!,
          periodoId: periodo.id!,
          valor: valor,
          origen: 'manual',
          nota: nota.isEmpty ? null : nota,
        ),
      );
    } else {
      await repo.actualizar(
        existente.copyWith(valor: valor, origen: 'manual', nota: nota.isEmpty ? null : nota),
      );
    }
    if (!mounted) return;
    await _cargarMediciones();
  }

  Future<void> _importarCsv() async {
    final controlador = TextEditingController();
    final texto = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Importar mediciones (CSV)'),
        content: SizedBox(
          width: 480,
          child: TextField(
            controller: controlador,
            maxLines: 10,
            decoration: const InputDecoration(
              hintText: 'orden,valor,nota\n1,1.18,\n2,1.33,pico atípico',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controlador.text),
            child: const Text('Importar'),
          ),
        ],
      ),
    );
    if (texto == null || texto.trim().isEmpty || !mounted) return;

    final resultado = parsearCsvMediciones(texto);
    final errores = List<String>.from(resultado.errores);
    final indicador = _seleccionado!;
    final repo = context.read<MedicionRepository>();
    var importadas = 0;

    for (final fila in resultado.filas) {
      final periodo = _periodos.where((p) => p.orden == fila.orden).firstOrNull;
      if (periodo == null) {
        errores.add('Orden ${fila.orden}: no existe un periodo con ese orden en esta organización.');
        continue;
      }
      final existente = _medicionesPorPeriodo[periodo.id];
      if (existente == null) {
        await repo.crear(
          Medicion(
            indicadorId: indicador.id!,
            periodoId: periodo.id!,
            valor: fila.valor,
            origen: 'importado',
            nota: fila.nota,
          ),
        );
      } else {
        await repo.actualizar(
          existente.copyWith(valor: fila.valor, origen: 'importado', nota: fila.nota),
        );
      }
      importadas++;
    }

    if (!mounted) return;
    await _cargarMediciones();
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Importación de mediciones'),
        content: SizedBox(
          width: 480,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                importadas == 1 ? '1 medición importada.' : '$importadas mediciones importadas.',
              ),
              if (errores.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  errores.length == 1 ? '1 fila rechazada:' : '${errores.length} filas rechazadas:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                ...errores.map((e) => Text('• $e', style: Theme.of(context).textTheme.bodySmall)),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cerrar')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Captura de mediciones'),
        actions: [
          if (_seleccionado != null)
            IconButton(
              icon: const Icon(LucideIcons.upload),
              tooltip: 'Importar CSV',
              onPressed: _importarCsv,
            ),
        ],
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _indicadores.isEmpty
          ? const _SinIndicadores()
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: DropdownButtonFormField<Indicador>(
                    initialValue: _seleccionado,
                    decoration: const InputDecoration(labelText: 'Indicador'),
                    items: [
                      for (final i in _indicadores) DropdownMenuItem(value: i, child: Text(i.nombre)),
                    ],
                    onChanged: (v) {
                      setState(() => _seleccionado = v);
                      _cargarMediciones();
                    },
                  ),
                ),
                Expanded(
                  child: _periodos.isEmpty
                      ? const _SinPeriodos()
                      : ListView.builder(
                          itemCount: _periodos.length,
                          itemBuilder: (context, index) {
                            final periodo = _periodos[index];
                            final medicion = _medicionesPorPeriodo[periodo.id];
                            final indicador = _seleccionado!;
                            return ListTile(
                              leading: CircleAvatar(child: Text('${periodo.orden}')),
                              title: Text(periodo.etiqueta),
                              subtitle: medicion == null
                                  ? const Text('Sin medición')
                                  : Text(
                                      '${medicion.valor.toStringAsFixed(indicador.decimales)} '
                                      '${indicador.unidad} · ${_etiquetasOrigen[medicion.origen] ?? medicion.origen}',
                                    ),
                              trailing: const Icon(LucideIcons.pencil, size: 18),
                              onTap: () => _editarValor(periodo),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

class _SinIndicadores extends StatelessWidget {
  const _SinIndicadores();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Todavía no hay indicadores. Crea uno primero desde Indicadores.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}

class _SinPeriodos extends StatelessWidget {
  const _SinPeriodos();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Todavía no hay periodos. Crea uno primero desde Periodos.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
