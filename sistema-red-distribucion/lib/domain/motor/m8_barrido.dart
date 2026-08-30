import 'dart:convert';

import '../../data/models/sitio_candidato.dart';
import 'evaluador_costo.dart';
import 'fila_memoria.dart';
import 'm4_costo_total.dart';
import 'm5_asignacion.dart';
import 'm6_heuristicas.dart';

/// Un punto de la curva ya calculado: costo total y desglose para exactamente
/// `numeroAlmacenes` almacenes abiertos (la mejor configuración de ese
/// tamaño que encontró el barrido).
class PuntoCurvaResultado {
  const PuntoCurvaResultado({
    required this.numeroAlmacenes,
    required this.abiertos,
    required this.costoTotalCent,
    required this.porRubro,
    required this.viableSegunServicio,
  });

  final int numeroAlmacenes;
  final Set<int> abiertos;
  final int costoTotalCent;
  final Map<String, int> porRubro;
  final bool viableSegunServicio;
}

class ResultadoBarrido {
  const ResultadoBarrido({required this.curva, required this.indiceOptimo, required this.memoria});

  final List<PuntoCurvaResultado> curva; // curva[i].numeroAlmacenes == i+1
  final int indiceOptimo; // índice en `curva` del menor costo total
  final List<FilaMemoria> memoria;

  PuntoCurvaResultado get optimo => curva[indiceOptimo];
}

/// M8 — barrido sobre el número de almacenes (CLAUDE.md sección 7). Para
/// cada `p` de 1 a `pMax`, obtiene la mejor configuración de tamaño `p`
/// (enumeración exhaustiva si `candidatosDisponibles.length <= 14` — óptimo
/// exacto en cada punto, necesario para que el rubro de salida sea
/// monótono no creciente; ADD hasta `p` seguido de intercambio si hay más
/// candidatos) y calcula su costo total con desglose. El mínimo de la
/// curva es la recomendación del sistema (`[REGLA]` antipatrones: nunca se
/// escribe el número óptimo a mano, siempre sale de este mínimo).
Future<ResultadoBarrido> barrerNumeroAlmacenes({
  required List<int> candidatosDisponibles,
  required Map<int, SitioCandidato> candidatosPorId,
  required EvaluadorCosto evaluador,
  int? pMax,
  TokenCancelacion? cancelacion,
  void Function(int p, int pMax)? onProgreso,
}) async {
  final limite = (pMax ?? candidatosDisponibles.length).clamp(1, candidatosDisponibles.length);
  final usarExhaustiva = candidatosDisponibles.length <= 14;

  final curva = <PuntoCurvaResultado>[];

  for (var p = 1; p <= limite; p++) {
    Set<int> abiertos;
    if (usarExhaustiva) {
      final resultado = await enumeracionExhaustiva(
        candidatos: candidatosDisponibles,
        evaluador: evaluador,
        pFijo: p,
        cancelacion: cancelacion,
      );
      abiertos = resultado.abiertos;
    } else {
      final add = await heuristicaAdd(
        candidatosDisponibles: candidatosDisponibles,
        pMax: p,
        evaluador: evaluador,
        cancelacion: cancelacion,
      );
      final refinado = await intercambioTeitzBart(
        abiertosInicial: add.abiertos,
        candidatosDisponibles: candidatosDisponibles,
        evaluador: evaluador,
        cancelacion: cancelacion,
      );
      abiertos = refinado.abiertos;
    }

    final asignacion = asignarZonas(
      abiertos: abiertos.toList(),
      zonas: evaluador.zonas,
      candidatosPorId: evaluador.candidatosPorId,
      distanciaZonaCandidato: evaluador.distanciaZonaCandidato,
      params: evaluador.params,
      conRestriccionCapacidad: evaluador.conRestriccionCapacidad,
    );
    final costo = calcularCostoTotal(
      abiertos: abiertos.toList(),
      candidatosPorId: evaluador.candidatosPorId,
      plantas: evaluador.plantas,
      zonas: evaluador.zonas,
      asignacionZonaCandidato: asignacion.asignacion,
      distanciaZonaCandidato: evaluador.distanciaZonaCandidato,
      distanciaPlantaCandidato: evaluador.distanciaPlantaCandidato,
      params: evaluador.params,
    );

    curva.add(
      PuntoCurvaResultado(
        numeroAlmacenes: p,
        abiertos: abiertos,
        costoTotalCent: costo.costoTotalCent,
        porRubro: costo.porRubro,
        viableSegunServicio: asignacion.zonasNoCubiertas.isEmpty && asignacion.zonasSinAsignar.isEmpty,
      ),
    );
    onProgreso?.call(p, limite);
  }

  var indiceOptimo = 0;
  for (var i = 1; i < curva.length; i++) {
    if (curva[i].costoTotalCent < curva[indiceOptimo].costoTotalCent) indiceOptimo = i;
  }

  return ResultadoBarrido(
    curva: curva,
    indiceOptimo: indiceOptimo,
    memoria: [
      FilaMemoria(
        modulo: 'M8',
        formula: 'Para p=1..$limite: mejor configuración de tamaño p '
            '(${usarExhaustiva ? "enumeración exhaustiva" : "ADD + intercambio"}), costo total y '
            'desglose; se recomienda el p de menor costo',
        entradasJson: jsonEncode({'p_max': limite, 'metodo_por_punto': usarExhaustiva ? 'exhaustiva' : 'add_intercambio'}),
        salida: 'óptimo en p=${curva[indiceOptimo].numeroAlmacenes}, '
            'costo ${curva[indiceOptimo].costoTotalCent}',
        unidad: 'centavos',
      ),
    ],
  );
}
