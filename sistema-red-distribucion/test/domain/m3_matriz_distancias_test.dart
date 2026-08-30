import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:paquete_geo_logistica/paquete_geo_logistica.dart';
import 'package:sistema_red_distribucion/data/models/celda_matriz.dart';
import 'package:sistema_red_distribucion/domain/motor/m3_matriz_distancias.dart';

/// Implementación mínima de [CacheRuteo] en memoria para los tests — mismo
/// patrón que `CacheRuteoEnMemoria` del paquete (que es privada a sus
/// propios tests, no exportada).
class _CacheEnMemoria implements CacheRuteo {
  final Map<String, String> _almacen = {};

  @override
  Future<String?> leer(String hashConsulta) async => _almacen[hashConsulta];

  @override
  Future<void> guardar(String hashConsulta, String tipo, String respuestaJson) async {
    _almacen[hashConsulta] = respuestaJson;
  }
}

/// Servidor OSRM falso: responde con distancia/duración = producto de las
/// latitudes de origen y destino (que en los fixtures de este archivo
/// codifican el índice global 0..n-1) — así se puede verificar que
/// `construirMatriz` ensambla la matriz global correctamente a partir de
/// las respuestas por bloque, sin importar dónde caiga cada bloque.
class _ServidorFalso {
  int peticiones = 0;

  Future<http.Response> responder(http.Request request) async {
    peticiones++;
    final coordsSegment = request.url.pathSegments.last;
    final lats = coordsSegment.split(';').map((par) => double.parse(par.split(',')[1])).toList();
    final sources = request.url.queryParameters['sources']!.split(';').map(int.parse).toList();
    final destinations = request.url.queryParameters['destinations']!.split(';').map(int.parse).toList();

    final distancias = [
      for (final si in sources) [for (final di in destinations) lats[si] * lats[di]],
    ];
    final duraciones = [
      for (final fila in distancias) [for (final _ in fila) 0.0],
    ];

    return http.Response(jsonEncode({'code': 'Ok', 'distances': distancias, 'durations': duraciones}), 200);
  }
}

List<OrigenMatriz> _origenes(int n) =>
    List.generate(n, (i) => OrigenMatriz(tipo: 'candidato', id: i, latitud: i.toDouble(), longitud: 0));

List<DestinoMatriz> _destinos(int n) =>
    List.generate(n, (j) => DestinoMatriz(id: j, latitud: j.toDouble(), longitud: 0));

void main() {
  test(
    'Test de troceado: 25 orígenes × 30 destinos con maxCoordenadasPorConsulta=10 '
    'genera el número correcto de bloques y ensambla una matriz 25×30 sin celdas vacías',
    () async {
      final servidor = _ServidorFalso();
      final cliente = OsrmClient(cache: _CacheEnMemoria(), httpClient: MockClient(servidor.responder));

      final resultado = await construirMatriz(
        proyectoId: 1,
        origenes: _origenes(25),
        destinos: _destinos(30),
        celdasExistentes: const [],
        factorCircuidad: 1.3,
        cliente: cliente,
        maxCoordenadasPorConsulta: 10,
      );
      cliente.dispose();

      // tamañoBloque = 10/2 = 5 -> 25/5=5 bloques de origen, 30/5=6 de destino.
      expect(servidor.peticiones, 5 * 6);
      expect(resultado, hasLength(25 * 30));

      final porClave = {for (final c in resultado) '${c.origenId}:${c.destinoId}': c};
      for (var i = 0; i < 25; i++) {
        for (var j = 0; j < 30; j++) {
          final celda = porClave['$i:$j'];
          expect(celda, isNotNull, reason: 'falta la celda origen=$i destino=$j');
          expect(celda!.distanciaMetros, i * j);
          expect(celda.fuente, 'osrm');
        }
      }
    },
  );

  test('Test de caché: la segunda construcción de la misma matriz no hace ninguna petición HTTP', () async {
    final servidor = _ServidorFalso();
    final cliente = OsrmClient(cache: _CacheEnMemoria(), httpClient: MockClient(servidor.responder));

    final primeraVez = await construirMatriz(
      proyectoId: 1,
      origenes: _origenes(6),
      destinos: _destinos(4),
      celdasExistentes: const [],
      factorCircuidad: 1.3,
      cliente: cliente,
      maxCoordenadasPorConsulta: 10,
    );
    final peticionesTrasPrimeraVez = servidor.peticiones;
    expect(peticionesTrasPrimeraVez, greaterThan(0));

    final segundaVez = await construirMatriz(
      proyectoId: 1,
      origenes: _origenes(6),
      destinos: _destinos(4),
      celdasExistentes: primeraVez,
      factorCircuidad: 1.3,
      cliente: cliente,
      maxCoordenadasPorConsulta: 10,
    );
    cliente.dispose();

    expect(servidor.peticiones, peticionesTrasPrimeraVez);
    expect(segundaVez, isEmpty);
  });

  test(
    'Test de caché parcial: agregar un candidato dispara únicamente las peticiones '
    'de los bloques que lo contienen',
    () async {
      final servidor = _ServidorFalso();
      final cliente = OsrmClient(cache: _CacheEnMemoria(), httpClient: MockClient(servidor.responder));

      // Simula que ya había 24 orígenes × 30 destinos cacheados (sin pasar
      // por construirMatriz, para no contaminar el conteo de peticiones).
      final celdasExistentes = [
        for (var i = 0; i < 24; i++)
          for (var j = 0; j < 30; j++)
            CeldaMatriz(
              proyectoId: 1,
              tipoOrigen: 'candidato',
              origenId: i,
              tipoDestino: 'zona',
              destinoId: j,
              distanciaMetros: i * j,
              duracionSegundos: 0,
              fuente: 'osrm',
            ),
      ];

      final resultado = await construirMatriz(
        proyectoId: 1,
        origenes: _origenes(25), // un candidato nuevo: índice 24
        destinos: _destinos(30),
        celdasExistentes: celdasExistentes,
        factorCircuidad: 1.3,
        cliente: cliente,
        maxCoordenadasPorConsulta: 10,
      );
      cliente.dispose();

      // Bloques de origen de tamaño 5: [0-4][5-9][10-14][15-19][20-24].
      // Solo el último bloque contiene al candidato nuevo (índice 24) ->
      // solo ese bloque de origen, contra los 6 bloques de destino.
      expect(servidor.peticiones, 6);
      // Y el resultado cubre exactamente ese bloque completo (5 orígenes ×
      // 30 destinos), incluyendo el candidato nuevo.
      expect(resultado, hasLength(5 * 30));
      expect(resultado.map((c) => c.origenId).toSet(), {20, 21, 22, 23, 24});
      expect(resultado.any((c) => c.origenId == 24), isTrue);
    },
  );

  test(
    'Test de respaldo: sin red, todas las celdas quedan con fuente=haversine y '
    'distancia exactamente haversine × factor_circuidad',
    () async {
      final origenes = [const OrigenMatriz(tipo: 'candidato', id: 1, latitud: -8.37, longitud: -74.55)];
      final destinos = [const DestinoMatriz(id: 1, latitud: -8.39, longitud: -74.57)];
      const factorCircuidad = 1.3;

      final resultado = await construirMatriz(
        proyectoId: 1,
        origenes: origenes,
        destinos: destinos,
        celdasExistentes: const [],
        factorCircuidad: factorCircuidad,
        cliente: null, // sin red, explícito
        maxCoordenadasPorConsulta: 100,
      );

      expect(resultado, hasLength(1));
      final celda = resultado.single;
      expect(celda.fuente, 'haversine');

      final distanciaHaversineMetros =
          distanciaHaversineKm(
            lat1: origenes.first.latitud,
            lon1: origenes.first.longitud,
            lat2: destinos.first.latitud,
            lon2: destinos.first.longitud,
          ) *
          1000;
      expect(celda.distanciaMetros, (distanciaHaversineMetros * factorCircuidad).round());
    },
  );

  test(
    'Test de propagación de error: un HTTP 429 persistente produce OsrmException, '
    'nunca un crash ni una matriz devuelta a medias',
    () async {
      final cliente = OsrmClient(
        cache: _CacheEnMemoria(),
        httpClient: MockClient((request) async => http.Response('rate limited', 429)),
      );

      // construirMatriz nunca escribe a la base de datos por sí misma (ver
      // su doc comment) — si lanza, no hay nada que "quedó a medias": quien
      // orquesta (la Pantalla 9) solo llama a insertarTodas() si esta
      // función termina con éxito.
      await expectLater(
        construirMatriz(
          proyectoId: 1,
          origenes: _origenes(2),
          destinos: _destinos(2),
          celdasExistentes: const [],
          factorCircuidad: 1.3,
          cliente: cliente,
          maxCoordenadasPorConsulta: 10,
        ),
        throwsA(isA<OsrmException>().having((e) => e.causa, 'causa', CausaOsrmException.limitePeticiones)),
      );
      cliente.dispose();
    },
    timeout: const Timeout(Duration(seconds: 15)),
  );

  test('sin orígenes o sin destinos, devuelve lista vacía sin llamar a la red', () async {
    final servidor = _ServidorFalso();
    final cliente = OsrmClient(cache: _CacheEnMemoria(), httpClient: MockClient(servidor.responder));

    final resultado = await construirMatriz(
      proyectoId: 1,
      origenes: const [],
      destinos: _destinos(3),
      celdasExistentes: const [],
      factorCircuidad: 1.3,
      cliente: cliente,
      maxCoordenadasPorConsulta: 10,
    );
    cliente.dispose();

    expect(resultado, isEmpty);
    expect(servidor.peticiones, 0);
  });
}
