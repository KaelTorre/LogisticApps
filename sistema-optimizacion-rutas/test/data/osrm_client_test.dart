import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:sistema_optimizacion_rutas/data/local/database.dart';
import 'package:sistema_optimizacion_rutas/data/remote/osrm_client.dart';

const _coordenadasA = [
  OsrmCoordenada(lat: -8.375482, lon: -74.556342), // depósito
  OsrmCoordenada(lat: -8.394832, lon: -74.577328),
];

const _coordenadasB = [
  OsrmCoordenada(lat: -8.375482, lon: -74.556342), // depósito
  OsrmCoordenada(lat: -8.385646, lon: -74.574080),
];

const _tablaOk = '''
{
  "code": "Ok",
  "distances": [[0, 2500.0], [2500.0, 0]],
  "durations": [[0, 340.5], [340.5, 0]]
}
''';

const _tablaNoRoute = '{"code": "NoRoute"}';

const _rutaOk = '''
{
  "code": "Ok",
  "routes": [
    {"distance": 5230.4, "duration": 612.1, "geometry": "encoded_polyline"}
  ]
}
''';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('parsea correctamente una respuesta /table válida', () async {
    final client = OsrmClient(
      database: database,
      httpClient: MockClient((request) async => http.Response(_tablaOk, 200)),
    );

    final respuesta = await client.obtenerMatriz(_coordenadasA);

    expect(respuesta.code, 'Ok');
    expect(respuesta.distanciasMetros, [
      [0, 2500.0],
      [2500.0, 0],
    ]);
    expect(respuesta.duracionesSegundos, [
      [0, 340.5],
      [340.5, 0],
    ]);
    client.dispose();
  });

  test('parsea correctamente una respuesta /route válida', () async {
    final client = OsrmClient(
      database: database,
      httpClient: MockClient((request) async => http.Response(_rutaOk, 200)),
    );

    final respuesta = await client.obtenerRuta(_coordenadasA);

    expect(respuesta.code, 'Ok');
    expect(respuesta.distanciaMetros, 5230.4);
    expect(respuesta.duracionSegundos, 612.1);
    expect(respuesta.geometriaPolyline, 'encoded_polyline');
    client.dispose();
  });

  test('usa el orden longitud,latitud en la URL (sección 6.1)', () async {
    Uri? uriCapturada;
    final client = OsrmClient(
      database: database,
      httpClient: MockClient((request) async {
        uriCapturada = request.url;
        return http.Response(_tablaOk, 200);
      }),
    );

    await client.obtenerMatriz(_coordenadasA);

    expect(
      uriCapturada!.path,
      contains('-74.556342,-8.375482;-74.577328,-8.394832'),
    );
    client.dispose();
  });

  test('code "NoRoute" lanza OsrmException con mensaje claro, sin crashear', () async {
    final client = OsrmClient(
      database: database,
      httpClient: MockClient(
        (request) async => http.Response(_tablaNoRoute, 200),
      ),
    );

    await expectLater(
      client.obtenerMatriz(_coordenadasA),
      throwsA(
        isA<OsrmException>().having(
          (e) => e.mensaje,
          'mensaje',
          contains('no encontró una ruta'),
        ),
      ),
    );
    client.dispose();
  });

  test('un fallo de red se traduce en OsrmException, no en una excepción cruda', () async {
    final client = OsrmClient(
      database: database,
      httpClient: MockClient((request) async => throw const SocketExceptionFake()),
    );

    await expectLater(
      client.obtenerMatriz(_coordenadasA),
      throwsA(isA<OsrmException>()),
    );
    client.dispose();
  });

  test('reintenta con backoff ante un 429 y termina resolviendo', () async {
    var intentos = 0;
    final client = OsrmClient(
      database: database,
      httpClient: MockClient((request) async {
        intentos++;
        if (intentos < 3) return http.Response('rate limited', 429);
        return http.Response(_tablaOk, 200);
      }),
    );

    final respuesta = await client.obtenerMatriz(_coordenadasA);

    expect(respuesta.code, 'Ok');
    expect(intentos, 3);
    client.dispose();
  });

  test('una segunda consulta idéntica se resuelve desde caché, sin nueva petición HTTP', () async {
    var llamadasHttp = 0;
    final client = OsrmClient(
      database: database,
      httpClient: MockClient((request) async {
        llamadasHttp++;
        return http.Response(_tablaOk, 200);
      }),
    );

    await client.obtenerMatriz(_coordenadasA);
    await client.obtenerMatriz(_coordenadasA);

    expect(llamadasHttp, 1);
    client.dispose();
  });

  test(
    'respeta ~1 req/seg entre consultas nuevas (no cacheadas)',
    () async {
      final client = OsrmClient(
        database: database,
        httpClient: MockClient(
          (request) async => http.Response(_tablaOk, 200),
        ),
      );

      final cronometro = Stopwatch()..start();
      await client.obtenerMatriz(_coordenadasA);
      await client.obtenerMatriz(_coordenadasB); // distinta -> no cacheada
      cronometro.stop();

      expect(cronometro.elapsed, greaterThanOrEqualTo(const Duration(milliseconds: 900)));
      client.dispose();
    },
    timeout: const Timeout(Duration(seconds: 5)),
  );
}

/// Simula un fallo de conexión (ej. sin internet) sin depender de dart:io.
class SocketExceptionFake implements Exception {
  const SocketExceptionFake();
}
