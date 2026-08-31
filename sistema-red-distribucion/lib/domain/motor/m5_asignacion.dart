import 'dart:convert';

import '../../data/models/celda_matriz.dart';
import '../../data/models/parametros_costo.dart';
import '../../data/models/sitio_candidato.dart';
import '../../data/models/zona_demanda.dart';
import 'fila_memoria.dart';
import 'tarifas.dart';

/// Resultado de M5. `asignacion` cubre toda zona que consiguió un almacén
/// (incluidas las que superan el estándar de servicio: esas **no
/// desaparecen**, solo quedan además en `zonasNoCubiertas` — CLAUDE.md
/// sección 7, `[REGLA]`). `zonasSinAsignar` son las que ningún almacén
/// abierto pudo recibir por capacidad (modo con restricción).
class ResultadoAsignacion {
  const ResultadoAsignacion({
    required this.asignacion,
    required this.zonasNoCubiertas,
    required this.zonasSinAsignar,
    required this.memoria,
  });

  final Map<int, int> asignacion; // zonaId -> candidatoId
  final Set<int> zonasNoCubiertas;
  final Set<int> zonasSinAsignar;
  final List<FilaMemoria> memoria;
}

/// M5 — asignación de zonas a almacenes (CLAUDE.md sección 7).
///
/// Sin restricción de capacidad: cada zona va al almacén abierto que
/// minimiza `costo_salida + costo_manejo`. Con restricción: heurística
/// **golosa por costo de oportunidad** (no óptima, así se documenta en la
/// memoria de cálculo, `[REGLA]`) — ordena las zonas por la diferencia de
/// costo entre su mejor y su segundo mejor almacén (de mayor a menor "lo
/// que pierde si no consigue su primera opción") y asigna en ese orden al
/// mejor almacén que todavía tenga capacidad.
ResultadoAsignacion asignarZonas({
  required List<int> abiertos,
  required List<ZonaDemanda> zonas,
  required Map<int, SitioCandidato> candidatosPorId,
  required Map<(int, int), CeldaMatriz> distanciaZonaCandidato,
  required ParametrosCosto params,
  required bool conRestriccionCapacidad,
}) {
  final memoria = <FilaMemoria>[];

  double costoParcial(ZonaDemanda zona, int candidatoId) {
    final candidato = candidatosPorId[candidatoId]!;
    final celda = distanciaZonaCandidato[(zona.id!, candidatoId)]!;
    final costoSalida = zona.demandaAgregada *
        tarifaTransporte(
          distanciaMetros: celda.distanciaMetros,
          tarifaFijaCent: params.tarifaSalidaFijaCent,
          tarifaCentPorKmTon: params.tarifaSalidaCentPorKmTon,
        );
    final costoManejo = zona.demandaAgregada * candidato.costoVariableManejoCentPorUnidad;
    return costoSalida + costoManejo;
  }

  bool excedeEstandar(ZonaDemanda zona, int candidatoId) {
    final celda = distanciaZonaCandidato[(zona.id!, candidatoId)]!;
    final valor = params.tipoEstandar == 'distancia' ? celda.distanciaMetros : celda.duracionSegundos;
    return valor > params.estandarServicioValor;
  }

  final asignacion = <int, int>{};
  final noCubiertas = <int>{};
  final sinAsignar = <int>{};

  if (!conRestriccionCapacidad) {
    for (final zona in zonas) {
      var mejor = abiertos.first;
      var mejorCosto = costoParcial(zona, mejor);
      for (final candidatoId in abiertos.skip(1)) {
        final costo = costoParcial(zona, candidatoId);
        if (costo < mejorCosto) {
          mejorCosto = costo;
          mejor = candidatoId;
        }
      }
      asignacion[zona.id!] = mejor;
      if (excedeEstandar(zona, mejor)) noCubiertas.add(zona.id!);
    }

    memoria.add(
      FilaMemoria(
        modulo: 'M5',
        formula: 'candidato = argmin(demanda_zona × tarifa_salida(distancia) + '
            'demanda_zona × costo_variable_manejo), sin restricción de capacidad',
        entradasJson: jsonEncode({'zonas': zonas.length, 'candidatos_abiertos': abiertos.length}),
        salida: '${asignacion.length} zona(s) asignada(s), ${noCubiertas.length} fuera del estándar',
        unidad: 'zonas',
      ),
    );

    return ResultadoAsignacion(
      asignacion: asignacion,
      zonasNoCubiertas: noCubiertas,
      zonasSinAsignar: sinAsignar,
      memoria: memoria,
    );
  }

  // Modo con restricción de capacidad: heurística golosa por costo de
  // oportunidad ("regret") — CLAUDE.md `[REGLA]`, no es óptima.
  final costoOrdenado = <int, List<int>>{}; // zonaId -> candidatoIds ordenados por costo ascendente
  final regretPorZona = <int, double>{};
  for (final zona in zonas) {
    final ordenados = List<int>.of(abiertos)
      ..sort((a, b) => costoParcial(zona, a).compareTo(costoParcial(zona, b)));
    costoOrdenado[zona.id!] = ordenados;
    regretPorZona[zona.id!] = ordenados.length > 1
        ? costoParcial(zona, ordenados[1]) - costoParcial(zona, ordenados[0])
        : 0;
  }

  final zonasOrdenadas = List<ZonaDemanda>.of(zonas)
    ..sort((a, b) => regretPorZona[b.id!]!.compareTo(regretPorZona[a.id!]!));

  final capacidadRestante = {for (final id in abiertos) id: candidatosPorId[id]!.capacidadAnual};

  for (final zona in zonasOrdenadas) {
    int? elegido;
    for (final candidatoId in costoOrdenado[zona.id!]!) {
      if (capacidadRestante[candidatoId]! >= zona.demandaAgregada) {
        elegido = candidatoId;
        break;
      }
    }
    if (elegido == null) {
      sinAsignar.add(zona.id!);
      continue;
    }
    asignacion[zona.id!] = elegido;
    capacidadRestante[elegido] = capacidadRestante[elegido]! - zona.demandaAgregada;
    if (excedeEstandar(zona, elegido)) noCubiertas.add(zona.id!);
  }

  memoria.add(
    FilaMemoria(
      modulo: 'M5',
      formula: 'zonas ordenadas por (costo del mejor almacén − costo del segundo mejor), '
          'descendente; asignación golosa al mejor con capacidad disponible',
      entradasJson: jsonEncode({'zonas': zonas.length, 'candidatos_abiertos': abiertos.length}),
      salida: '${asignacion.length} zona(s) asignada(s), ${sinAsignar.length} sin capacidad disponible, '
          '${noCubiertas.length} fuera del estándar',
      unidad: 'zonas',
    ),
  );

  return ResultadoAsignacion(
    asignacion: asignacion,
    zonasNoCubiertas: noCubiertas,
    zonasSinAsignar: sinAsignar,
    memoria: memoria,
  );
}
