// ignore_for_file: avoid_print
// Script temporal, no automatizado: verifica conectividad real contra el
// servidor demo de OSRM con puntos reales de Pucallpa (Fase 0 de CLAUDE.md).
// No es parte de la suite de tests (esos no deben golpear la red real) —
// se corre a mano con `flutter test tool/probar_osrm_real.dart` porque
// `AppDatabase` depende de `drift_flutter`, que a su vez depende de Flutter
// (`dart:ui`), así que no puede correrse con el Dart VM puro (`dart run`).
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_optimizacion_rutas/core/pucallpa_dataset.dart';
import 'package:sistema_optimizacion_rutas/data/local/database.dart';
import 'package:sistema_optimizacion_rutas/data/remote/osrm_client.dart';

void main() {
  test('conectividad real con OSRM usando puntos de Pucallpa', () async {
    final db = AppDatabase(NativeDatabase.memory());
    final client = OsrmClient(database: db);

    final puntos = puntosEntregaSemillaPucallpa.take(4).toList();
    final coords = [
      OsrmCoordenada(
        lat: depositoSemillaOficina.latitud,
        lon: depositoSemillaOficina.longitud,
      ),
      ...puntos.map((p) => OsrmCoordenada(lat: p.latitud, lon: p.longitud)),
    ];

    print('Puntos consultados (depósito + ${puntos.length}):');
    print('  Oficina (depósito)');
    for (final p in puntos) {
      print('  ${p.nombre}');
    }

    print('\n1) Consultando OSRM real (sin caché)...');
    final sw1 = Stopwatch()..start();
    final resp1 = await client.obtenerMatriz(coords);
    sw1.stop();
    print('   code: ${resp1.code} — ${sw1.elapsedMilliseconds}ms');
    print('   distancias (m), fila por punto:');
    for (final fila in resp1.distanciasMetros!) {
      print('     $fila');
    }

    print('\n2) Repitiendo la misma consulta (debería salir de cache_osrm)...');
    final sw2 = Stopwatch()..start();
    final resp2 = await client.obtenerMatriz(coords);
    sw2.stop();
    print('   code: ${resp2.code} — ${sw2.elapsedMilliseconds}ms');

    final filasCache = await db.select(db.cacheOsrmTable).get();
    print('\nFilas en cache_osrm: ${filasCache.length}');

    expect(resp1.code, 'Ok');
    expect(resp2.code, 'Ok');
    expect(filasCache.length, 1);
    expect(sw2.elapsedMilliseconds, lessThan(sw1.elapsedMilliseconds));

    client.dispose();
    await db.close();
  });
}
