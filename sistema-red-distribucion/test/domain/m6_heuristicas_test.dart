import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:paquete_geo_logistica/paquete_geo_logistica.dart';
import 'package:sistema_red_distribucion/data/models/celda_matriz.dart';
import 'package:sistema_red_distribucion/data/models/parametros_costo.dart';
import 'package:sistema_red_distribucion/data/models/sitio_candidato.dart';
import 'package:sistema_red_distribucion/data/models/zona_demanda.dart';
import 'package:sistema_red_distribucion/domain/motor/evaluador_costo.dart';
import 'package:sistema_red_distribucion/domain/motor/m6_heuristicas.dart';

/// Genera una instancia sintética de ubicación de almacenes: candidatos y
/// zonas dispersos al azar (semilla fija), sin plantas (M4 no las necesita
/// para que el costo varíe con la configuración — entrada/producción
/// quedan en cero, el resto de los rubros sí compite entre candidatos).
EvaluadorCosto _generarInstancia(int semilla, {int nCandidatos = 10, int nZonas = 6}) {
  final random = Random(semilla);
  final posCandidatos = List.generate(nCandidatos, (_) => (random.nextDouble(), random.nextDouble()));
  final posZonas = List.generate(nZonas, (_) => (random.nextDouble(), random.nextDouble()));

  final candidatosPorId = <int, SitioCandidato>{
    for (var i = 0; i < nCandidatos; i++)
      i + 1: SitioCandidato(
        id: i + 1,
        proyectoId: 1,
        nombre: 'C${i + 1}',
        latitud: posCandidatos[i].$1,
        longitud: posCandidatos[i].$2,
        costoFijoAnualCent: 50000 + random.nextInt(50000),
        capacidadAnual: 1e9,
        costoVariableManejoCentPorUnidad: 10 + random.nextInt(20),
        origen: 'manual',
      ),
  };

  final zonas = <ZonaDemanda>[
    for (var j = 0; j < nZonas; j++)
      ZonaDemanda(
        id: j + 1,
        proyectoId: 1,
        etiqueta: 'Z${j + 1}',
        latitud: posZonas[j].$1,
        longitud: posZonas[j].$2,
        demandaAgregada: 10.0 + random.nextInt(90),
        pedidosAgregados: 5 + random.nextInt(20),
        numeroClientes: 1,
        errorAgregacionMetros: 0,
      ),
  ];

  final distanciaZonaCandidato = <(int, int), CeldaMatriz>{};
  for (var j = 0; j < nZonas; j++) {
    for (var i = 0; i < nCandidatos; i++) {
      final distanciaMetros = (distanciaHaversineKm(
                lat1: posCandidatos[i].$1,
                lon1: posCandidatos[i].$2,
                lat2: posZonas[j].$1,
                lon2: posZonas[j].$2,
              ) *
              1000)
          .round();
      distanciaZonaCandidato[(j + 1, i + 1)] = CeldaMatriz(
        proyectoId: 1,
        tipoOrigen: 'candidato',
        origenId: i + 1,
        tipoDestino: 'zona',
        destinoId: j + 1,
        distanciaMetros: distanciaMetros,
        duracionSegundos: distanciaMetros ~/ 10,
        fuente: 'osrm',
      );
    }
  }

  const params = ParametrosCosto(
    proyectoId: 1,
    tarifaEntradaFijaCent: 0,
    tarifaEntradaCentPorKmTon: 0,
    tarifaSalidaFijaCent: 20,
    tarifaSalidaCentPorKmTon: 5,
    tasaManejoInventarioAnual: 0.15,
    valorPorUnidadCent: 500,
    inventarioBaseUnaUbicacion: 20,
    costoPorPedidoCent: 30,
    tipoEstandar: 'distancia',
    estandarServicioValor: 1000000000, // no limita nada en estos tests
  );

  return EvaluadorCosto(
    zonas: zonas,
    candidatosPorId: candidatosPorId,
    plantas: const [],
    distanciaZonaCandidato: distanciaZonaCandidato,
    distanciaPlantaCandidato: const {},
    params: params,
    conRestriccionCapacidad: false,
  );
}

void main() {
  // 5 instancias con semilla fija, 8 a 12 candidatos (CLAUDE.md, Fase 6).
  final semillas = [1, 2, 3, 4, 5];
  final tamanios = [8, 9, 10, 11, 12];

  test(
    'Test dorado L — ADD seguido de intercambio iguala (o queda a menos del 2% de) '
    'el óptimo de la enumeración exhaustiva, en cinco instancias con semilla fija',
    () async {
      final brechas = <double>[];

      for (var i = 0; i < semillas.length; i++) {
        final evaluador = _generarInstancia(semillas[i], nCandidatos: tamanios[i]);
        final candidatos = evaluador.candidatosPorId.keys.toList();

        final optimo = await enumeracionExhaustiva(candidatos: candidatos, evaluador: evaluador);

        final add = await heuristicaAdd(
          candidatosDisponibles: candidatos,
          pMax: candidatos.length,
          evaluador: evaluador,
        );
        final conIntercambio = await intercambioTeitzBart(
          abiertosInicial: add.abiertos,
          candidatosDisponibles: candidatos,
          evaluador: evaluador,
        );

        final brecha = (conIntercambio.costoTotalCent - optimo.costoTotalCent) / optimo.costoTotalCent;
        brechas.add(brecha * 100);

        expect(
          brecha,
          lessThan(0.02),
          reason:
              'instancia semilla=${semillas[i]}: heurística=${conIntercambio.costoTotalCent}, '
              'óptimo=${optimo.costoTotalCent}, brecha=${(brecha * 100).toStringAsFixed(3)}%',
        );
      }
    },
  );

  test(
    'Test M — DROP también converge al óptimo (o dentro del 2%) en las mismas instancias',
    () async {
      for (var i = 0; i < semillas.length; i++) {
        final evaluador = _generarInstancia(semillas[i], nCandidatos: tamanios[i]);
        final candidatos = evaluador.candidatosPorId.keys.toList();

        final optimo = await enumeracionExhaustiva(candidatos: candidatos, evaluador: evaluador);
        final drop = await heuristicaDrop(todosCandidatos: candidatos, evaluador: evaluador);

        final brecha = (drop.costoTotalCent - optimo.costoTotalCent) / optimo.costoTotalCent;

        expect(
          brecha,
          lessThan(0.02),
          reason:
              'instancia semilla=${semillas[i]}: DROP=${drop.costoTotalCent}, '
              'óptimo=${optimo.costoTotalCent}, brecha=${(brecha * 100).toStringAsFixed(3)}%',
        );
      }
    },
  );

  test('Test N — el recocido simulado con la misma semilla produce el mismo conjunto de almacenes', () async {
    final evaluador = _generarInstancia(42, nCandidatos: 10, nZonas: 6);
    final candidatos = evaluador.candidatosPorId.keys.toList();

    final primeraEjecucion = await recocidoSimulado(
      candidatosDisponibles: candidatos,
      evaluador: evaluador,
      semilla: 7,
      iteracionesSinMejoraParaParar: 30,
    );
    final segundaEjecucion = await recocidoSimulado(
      candidatosDisponibles: candidatos,
      evaluador: evaluador,
      semilla: 7,
      iteracionesSinMejoraParaParar: 30,
    );

    expect(primeraEjecucion.abiertos, segundaEjecucion.abiertos);
    expect(primeraEjecucion.costoTotalCent, segundaEjecucion.costoTotalCent);
  });

  test('Test O — el costo registrado en cada paso de ADD es estrictamente decreciente', () async {
    final evaluador = _generarInstancia(99, nCandidatos: 10, nZonas: 6);
    final candidatos = evaluador.candidatosPorId.keys.toList();

    final resultado = await heuristicaAdd(
      candidatosDisponibles: candidatos,
      pMax: candidatos.length,
      evaluador: evaluador,
    );

    expect(resultado.curva, isNotEmpty);
    for (var i = 1; i < resultado.curva.length; i++) {
      expect(
        resultado.curva[i].costoTotalCent,
        lessThan(resultado.curva[i - 1].costoTotalCent),
        reason: 'el costo debe bajar estrictamente en cada paso de ADD',
      );
    }
  });

  test(
    'Test P — una ejecución cancelada lanza BusquedaCancelada, sin devolver ningún resultado '
    '(quien orquesta nunca llega a persistir nada a medias)',
    () async {
      final evaluador = _generarInstancia(5, nCandidatos: 12, nZonas: 8);
      final candidatos = evaluador.candidatosPorId.keys.toList();
      final token = TokenCancelacion();

      final futuro = recocidoSimulado(
        candidatosDisponibles: candidatos,
        evaluador: evaluador,
        semilla: 1,
        iteracionesSinMejoraParaParar: 100000, // no terminaría sola en el tiempo del test
        cancelacion: token,
      );

      // Cancela apenas el event loop tiene un hueco — la búsqueda ya debe
      // estar corriendo (los primeros puntos de control ceden el control
      // cada 20 iteraciones).
      await Future<void>.delayed(const Duration(milliseconds: 5));
      token.cancelar();

      await expectLater(futuro, throwsA(isA<BusquedaCancelada>()));
    },
  );

  test('la enumeración exhaustiva respeta p fijo cuando se pide', () async {
    final evaluador = _generarInstancia(3, nCandidatos: 8, nZonas: 5);
    final candidatos = evaluador.candidatosPorId.keys.toList();

    final resultado = await enumeracionExhaustiva(candidatos: candidatos, evaluador: evaluador, pFijo: 3);

    expect(resultado.abiertos, hasLength(3));
  });
}
