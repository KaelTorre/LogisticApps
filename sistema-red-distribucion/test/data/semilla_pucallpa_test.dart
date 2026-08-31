import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:paquete_geo_logistica/paquete_geo_logistica.dart';
import 'package:sistema_red_distribucion/data/local/database.dart';
import 'package:sistema_red_distribucion/data/models/celda_matriz.dart';
import 'package:sistema_red_distribucion/data/repositories/celda_matriz_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/parametros_costo_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/planta_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/sitio_candidato_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/zona_demanda_repository.dart';
import 'package:sistema_red_distribucion/domain/export/exportar_importar_proyecto.dart';
import 'package:sistema_red_distribucion/domain/export/proyecto_red_portable.dart';
import 'package:sistema_red_distribucion/domain/motor/evaluador_costo.dart';
import 'package:sistema_red_distribucion/domain/motor/m3_matriz_distancias.dart';
import 'package:sistema_red_distribucion/domain/motor/m6_heuristicas.dart';

/// Cliente HTTP que lanza ante cualquier petición — usado para demostrar
/// que, con el caso de estudio ya sembrado, nada en el camino de M3 llega
/// siquiera a intentar una petición real.
class _HttpClienteQueLanza extends http.BaseClient {
  int llamadas = 0;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    llamadas++;
    throw StateError('No debería haber ninguna petición de red: $request');
  }
}

/// Caché que lanza ante cualquier lectura/escritura — mismo propósito que
/// `_HttpClienteQueLanza`, para la otra mitad de lo que `OsrmClient`
/// necesitaría si de verdad tuviera que consultar la red.
class _CacheQueLanza implements CacheRuteo {
  @override
  Future<String?> leer(String hashConsulta) => throw StateError('No debería leerse la caché de ruteo.');

  @override
  Future<void> guardar(String hashConsulta, String tipo, String respuestaJson) =>
      throw StateError('No debería escribirse la caché de ruteo.');
}

/// Test Z (CLAUDE.md Fase 9): "al iniciar con base vacía, el caso se
/// siembra completo y la optimización corre de principio a fin sin
/// realizar ninguna petición de red."
///
/// No pasa por `sembrarCasoEstudioSiVacio` (que usa `rootBundle`, atado al
/// binding de Flutter) — lee el mismo archivo estático directo del disco,
/// igual que ya hace `pdf_builder_red_test.dart` con las fuentes, para
/// poder correr como test de Dart puro.
void main() {
  test('el caso de estudio sembrado permite optimizar sin ninguna petición de red', () async {
    final json = File('assets/seed/semilla_pucallpa.json').readAsStringSync();
    final portable = ProyectoRedPortable.fromJsonString(json);

    final database = AppDatabase(NativeDatabase.memory());
    final proyectoId = await importarProyecto(portable, database);

    final candidatos = await SitioCandidatoRepository(database).obtenerPorProyecto(proyectoId);
    final plantas = await PlantaRepository(database).obtenerPorProyecto(proyectoId);
    final zonas = await ZonaDemandaRepository(database).obtenerPorProyecto(proyectoId);
    final celdas = await CeldaMatrizRepository(database).obtenerPorProyecto(proyectoId);
    final params = await ParametrosCostoRepository(database).obtenerPorProyecto(proyectoId);

    expect(candidatos, isNotEmpty);
    expect(plantas, isNotEmpty);
    expect(zonas, isNotEmpty);
    expect(params, isNotNull);

    // Cliente/caché envenenados: si algo intentara construir la matriz de
    // nuevo (en vez de usar la ya sembrada), esto lanzaría inmediatamente.
    final httpEnvenenado = _HttpClienteQueLanza();
    final osrmEnvenenado = OsrmClient(cache: _CacheQueLanza(), httpClient: httpEnvenenado);

    final celdasPlantaCandidato = await construirMatriz(
      proyectoId: proyectoId,
      origenes: plantas.map((p) => OrigenMatriz(tipo: 'planta', id: p.id!, latitud: p.latitud, longitud: p.longitud)).toList(),
      destinos: candidatos
          .map((c) => DestinoMatriz(id: c.id!, latitud: c.latitud, longitud: c.longitud, tipo: 'candidato'))
          .toList(),
      celdasExistentes: celdas,
      factorCircuidad: 1.30,
      cliente: osrmEnvenenado,
      maxCoordenadasPorConsulta: 100,
    );
    final celdasCandidatoZona = await construirMatriz(
      proyectoId: proyectoId,
      origenes: candidatos.map((c) => OrigenMatriz(tipo: 'candidato', id: c.id!, latitud: c.latitud, longitud: c.longitud)).toList(),
      destinos: zonas.map((z) => DestinoMatriz(id: z.id!, latitud: z.latitud, longitud: z.longitud)).toList(),
      celdasExistentes: celdas,
      factorCircuidad: 1.30,
      cliente: osrmEnvenenado,
      maxCoordenadasPorConsulta: 100,
    );

    // La matriz sembrada ya cubre todos los pares — construirMatriz no
    // encuentra nada faltante y nunca llega a llamar al cliente envenenado.
    expect(celdasPlantaCandidato, isEmpty);
    expect(celdasCandidatoZona, isEmpty);
    expect(httpEnvenenado.llamadas, 0);

    // Todas las celdas sembradas son de OSRM real, no respaldo haversine —
    // si esto fallara significaría que la semilla se generó con la red
    // caída a mitad de camino.
    expect(celdas.every((c) => c.fuente == 'osrm'), isTrue);

    // La optimización de verdad: mismo camino que la Pantalla 10
    // (`optimizacion_screen.dart`), construido sobre los datos ya en
    // memoria — ninguna consulta a drift ni a la red dentro del bucle.
    final candidatosPorId = {for (final c in candidatos) c.id!: c};
    final distanciaZonaCandidato = <(int, int), CeldaMatriz>{
      for (final c in celdas)
        if (c.tipoOrigen == 'candidato' && c.tipoDestino == 'zona') (c.destinoId, c.origenId): c,
    };
    final distanciaPlantaCandidato = <(int, int), CeldaMatriz>{
      for (final c in celdas)
        if (c.tipoOrigen == 'planta' && c.tipoDestino == 'candidato') (c.origenId, c.destinoId): c,
    };

    final evaluador = EvaluadorCosto(
      zonas: zonas,
      candidatosPorId: candidatosPorId,
      plantas: plantas,
      distanciaZonaCandidato: distanciaZonaCandidato,
      distanciaPlantaCandidato: distanciaPlantaCandidato,
      params: params!,
      conRestriccionCapacidad: false,
    );

    final resultado = await heuristicaAdd(
      candidatosDisponibles: candidatos.map((c) => c.id!).toList(),
      pMax: candidatos.length,
      evaluador: evaluador,
    );

    expect(resultado.abiertos, isNotEmpty);
    expect(resultado.costoTotalCent, lessThan(costoInfinito));
    expect(httpEnvenenado.llamadas, 0);

    await database.close();
  });
}
