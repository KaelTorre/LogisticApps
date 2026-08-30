import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_red_distribucion/data/local/cache_ruteo_drift.dart';
import 'package:sistema_red_distribucion/data/local/database.dart';

void main() {
  late AppDatabase database;
  late CacheRuteoDrift cache;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    cache = CacheRuteoDrift(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('leer sin acierto devuelve null', () async {
    expect(await cache.leer('hash-inexistente'), isNull);
  });

  test('guardar + leer devuelve exactamente el JSON guardado', () async {
    await cache.guardar('hash-1', 'matriz', '{"code":"Ok"}');

    expect(await cache.leer('hash-1'), '{"code":"Ok"}');
  });

  test('guardar dos veces con el mismo hash actualiza en vez de duplicar', () async {
    await cache.guardar('hash-1', 'matriz', '{"v":1}');
    await cache.guardar('hash-1', 'matriz', '{"v":2}');

    expect(await cache.leer('hash-1'), '{"v":2}');
    final filas = await database.select(database.cacheRuteoTable).get();
    expect(filas, hasLength(1));
  });
}
