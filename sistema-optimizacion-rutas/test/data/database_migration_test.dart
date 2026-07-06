import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_optimizacion_rutas/data/local/database.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite3;

// Esquema v1 exacto (CLAUDE.md sección 5.1 / database.dart antes de la
// migración a historial) — usado para simular una base real ya en uso antes
// de este cambio, y confirmar que la migración a v2 no le hace nada a los
// datos del usuario.
const _esquemaV1 = '''
CREATE TABLE deposito (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nombre TEXT NOT NULL,
  latitud REAL NOT NULL,
  longitud REAL NOT NULL
);

CREATE TABLE punto_entrega (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nombre TEXT NOT NULL,
  latitud REAL NOT NULL,
  longitud REAL NOT NULL,
  demanda REAL NOT NULL DEFAULT 0,
  ventana_inicio TEXT,
  ventana_fin TEXT
);

CREATE TABLE vehiculo (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nombre TEXT NOT NULL,
  capacidad_maxima REAL NOT NULL,
  costo_estimado_por_km REAL,
  tipo_flota TEXT
);

CREATE TABLE escenario_optimizacion (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  deposito_id INTEGER NOT NULL REFERENCES deposito(id),
  fecha_creacion TEXT NOT NULL,
  metodo_usado TEXT NOT NULL
);

CREATE TABLE escenario_punto (
  escenario_id INTEGER NOT NULL REFERENCES escenario_optimizacion(id),
  punto_entrega_id INTEGER NOT NULL REFERENCES punto_entrega(id)
);

CREATE TABLE escenario_vehiculo (
  escenario_id INTEGER NOT NULL REFERENCES escenario_optimizacion(id),
  vehiculo_id INTEGER NOT NULL REFERENCES vehiculo(id)
);

CREATE TABLE ruta_resultado (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  escenario_id INTEGER NOT NULL REFERENCES escenario_optimizacion(id),
  vehiculo_id INTEGER NOT NULL REFERENCES vehiculo(id),
  secuencia_paradas TEXT NOT NULL,
  distancia_total_km REAL,
  tiempo_total_segundos REAL,
  geometria_polyline TEXT
);

CREATE TABLE cache_osrm (
  hash_consulta TEXT NOT NULL,
  tipo TEXT NOT NULL,
  respuesta_json TEXT NOT NULL,
  fecha_consulta TEXT NOT NULL,
  PRIMARY KEY (hash_consulta)
);
''';

List<String> _nombresDeTablas(sqlite3.Database db) {
  final filas = db.select(
    "SELECT name FROM sqlite_master WHERE type = 'table'",
  );
  return filas.map((f) => f['name'] as String).toList();
}

void main() {
  test(
    'la migración v1→v2 borra las 4 tablas muertas, crea el historial, '
    'y no toca los datos reales del usuario',
    () async {
      final rawDb = sqlite3.sqlite3.openInMemory();
      rawDb.execute(_esquemaV1);
      rawDb.execute('''
        INSERT INTO deposito (nombre, latitud, longitud)
        VALUES ('Oficina', -8.375482, -74.556342);
      ''');
      rawDb.execute('''
        INSERT INTO punto_entrega (nombre, latitud, longitud, demanda)
        VALUES ('Cliente A', -8.394832, -74.577328, 45);
      ''');
      rawDb.execute('''
        INSERT INTO vehiculo (nombre, capacidad_maxima)
        VALUES ('Camión 1', 1200);
      ''');
      rawDb.execute('''
        INSERT INTO cache_osrm (hash_consulta, tipo, respuesta_json, fecha_consulta)
        VALUES ('abc', 'matriz', '{}', '2026-01-01');
      ''');
      rawDb.userVersion = 1;

      final database = AppDatabase(NativeDatabase.opened(rawDb));
      addTearDown(database.close);

      // Cualquier consulta fuerza la apertura y por lo tanto la migración.
      final depositos = await database.select(database.depositoTable).get();

      final tablas = _nombresDeTablas(rawDb);

      // Datos reales del usuario intactos.
      expect(depositos, hasLength(1));
      expect(depositos.single.nombre, 'Oficina');
      expect(
        await database.select(database.puntoEntregaTable).get(),
        hasLength(1),
      );
      expect(
        await database.select(database.vehiculoTable).get(),
        hasLength(1),
      );
      expect(
        await database.select(database.cacheOsrmTable).get(),
        hasLength(1),
      );

      // Tablas muertas eliminadas.
      expect(tablas, isNot(contains('escenario_optimizacion')));
      expect(tablas, isNot(contains('escenario_punto')));
      expect(tablas, isNot(contains('escenario_vehiculo')));
      expect(tablas, isNot(contains('ruta_resultado')));

      // Tablas nuevas creadas y vacías.
      expect(tablas, contains('historial_calculo'));
      expect(tablas, contains('historial_ruta'));
      expect(
        await database.select(database.historialCalculoTable).get(),
        isEmpty,
      );
    },
  );
}
