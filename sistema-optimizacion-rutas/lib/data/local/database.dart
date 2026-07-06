import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

class DepositoTable extends Table {
  @override
  String get tableName => 'deposito';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
  RealColumn get latitud => real()();
  RealColumn get longitud => real()();
}

class PuntoEntregaTable extends Table {
  @override
  String get tableName => 'punto_entrega';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
  RealColumn get latitud => real()();
  RealColumn get longitud => real()();
  RealColumn get demanda => real().withDefault(const Constant(0))();
  TextColumn get ventanaInicio => text().nullable()();
  TextColumn get ventanaFin => text().nullable()();
}

class VehiculoTable extends Table {
  @override
  String get tableName => 'vehiculo';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
  RealColumn get capacidadMaxima => real()();
  RealColumn get costoEstimadoPorKm => real().nullable()();
  TextColumn get tipoFlota => text().nullable()();
}

// Reemplaza escenario_optimizacion/escenario_punto/escenario_vehiculo/
// ruta_resultado (CLAUDE.md §5.1), que nunca se implementaron y usaban FKs
// en vivo hacia punto_entrega/vehiculo/deposito — incompatible con que el
// historial sea un snapshot inmutable (si el usuario edita o borra un punto
// o vehículo desde su CRUD, una entrada del historial no debe romperse ni
// cambiar). Por eso cada fila de historial_ruta guarda una copia
// desnormalizada (JSON) de los datos relevantes en vez de referenciarlos.
class HistorialCalculoTable extends Table {
  @override
  String get tableName => 'historial_calculo';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get fechaCalculo => text()(); // DateTime.toIso8601String()
  TextColumn get metodo => text()(); // 'ahorros' | 'barrido'
  TextColumn get depositoNombre => text()();
  RealColumn get depositoLatitud => real()();
  RealColumn get depositoLongitud => real()();
  IntColumn get vehiculosFaltantes =>
      integer().withDefault(const Constant(0))();
  RealColumn get distanciaTotalMetros =>
      real().withDefault(const Constant(0))();
  IntColumn get cantidadRutas => integer().withDefault(const Constant(0))();
}

class HistorialRutaTable extends Table {
  @override
  String get tableName => 'historial_ruta';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get historialId =>
      integer().references(HistorialCalculoTable, #id)();
  IntColumn get orden => integer()(); // posición original en la lista de rutas
  TextColumn get vehiculoNombre => text().nullable()();
  RealColumn get vehiculoCapacidadMaxima => real().nullable()();
  RealColumn get vehiculoCostoEstimadoPorKm => real().nullable()();
  TextColumn get vehiculoTipoFlota => text().nullable()();
  TextColumn get paradasJson =>
      text()(); // JSON: [{nombre,latitud,longitud,demanda}, ...]
  RealColumn get distanciaMetros => real().nullable()();
  RealColumn get duracionSegundos => real().nullable()();
  TextColumn get distanciasPorTramoMetros =>
      text()(); // JSON: [double, ...], largo == paradas.length + 1
  TextColumn get geometriaPolyline => text().nullable()();
}

class CacheOsrmTable extends Table {
  @override
  String get tableName => 'cache_osrm';

  TextColumn get hashConsulta => text()();
  TextColumn get tipo => text()();
  TextColumn get respuestaJson => text()();
  TextColumn get fechaConsulta => text()();

  @override
  Set<Column> get primaryKey => {hashConsulta};
}

@DriftDatabase(tables: [
  DepositoTable,
  PuntoEntregaTable,
  VehiculoTable,
  HistorialCalculoTable,
  HistorialRutaTable,
  CacheOsrmTable,
])
class AppDatabase extends _$AppDatabase {
  /// [executor] permite inyectar una base en memoria en tests
  /// (`NativeDatabase.memory()`); en la app se usa siempre `driftDatabase`.
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _abrirConexion());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        // Tablas nunca usadas (ver comentario sobre HistorialCalculoTable
        // más arriba) — se borran antes de crear su reemplazo.
        await m.deleteTable('escenario_punto');
        await m.deleteTable('escenario_vehiculo');
        await m.deleteTable('ruta_resultado');
        await m.deleteTable('escenario_optimizacion');
        await m.createTable(historialCalculoTable);
        await m.createTable(historialRutaTable);
      }
    },
  );

  static QueryExecutor _abrirConexion() {
    return driftDatabase(name: 'sistema_optimizacion_rutas');
  }
}
