import 'package:flutter/material.dart';

import '../../../domain/motor/fila_memoria.dart';
import '../../../domain/motor/m2_posiciones.dart';
import '../../../domain/motor/m3_superficie.dart';

/// Ficha de salida de la Fase 1: resultado crudo de M2 + M3, con la memoria
/// de cálculo completa. Sin plano, sin isométrico, sin exportación — eso es
/// de fases posteriores. Es la pantalla que valida si el proyecto tiene
/// sentido (CLAUDE.md, Fase 1).
class FichaResultadoScreen extends StatelessWidget {
  const FichaResultadoScreen({
    super.key,
    required this.resultadoM2,
    required this.resultadoM3,
  });

  final ResultadoM2 resultadoM2;
  final ResultadoM3 resultadoM3;

  @override
  Widget build(BuildContext context) {
    final memoriaCompleta = [...resultadoM2.memoria, ...resultadoM3.memoria];
    final supAlmacenamientoM2 = resultadoM3.supAlmacenamientoMm2 / 1000000;

    return Scaffold(
      appBar: AppBar(title: const Text('Ficha técnica')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Resumen', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          _filaResumen('Posiciones requeridas', '${resultadoM2.posicionesRequeridas}'),
          _filaResumen('Tarimas por nivel', '${resultadoM3.tarimasPorNivel}'),
          _filaResumen('Paso de nivel', '${resultadoM3.pasoNivelMm} mm'),
          _filaResumen('Niveles', '${resultadoM3.niveles}'),
          _filaResumen('Módulos', '${resultadoM3.modulos}'),
          _filaResumen('Módulos por fila', '${resultadoM3.modulosPorFila}'),
          _filaResumen('Filas', '${resultadoM3.filas}'),
          _filaResumen('Posiciones instaladas', '${resultadoM3.posicionesInstaladas}'),
          _filaResumen(
            'Superficie de almacenamiento',
            '${supAlmacenamientoM2.toStringAsFixed(1)} m²',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'La superficie construida (con pasillos, zonas y circulación) '
              'no está calculada todavía — depende del generador de layout '
              'de la Fase 2.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          const Divider(height: 32),
          Text('Memoria de cálculo', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...memoriaCompleta.map(_filaMemoria),
        ],
      ),
    );
  }

  Widget _filaResumen(String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(etiqueta),
          Text(valor, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _filaMemoria(FilaMemoria fila) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${fila.modulo} · ${fila.concepto}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(fila.formula, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
            const SizedBox(height: 4),
            Text('${fila.valor} ${fila.unidad}'),
            if (fila.fuente != null) ...[
              const SizedBox(height: 2),
              Text(
                'Fuente: ${fila.fuente}',
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
