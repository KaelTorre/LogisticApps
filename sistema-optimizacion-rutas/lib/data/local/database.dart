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

class EscenarioOptimizacionTable extends Table {
  @override
  String get tableName => 'escenario_optimizacion';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get depositoId => integer().references(DepositoTable, #id)();
  TextColumn get fechaCreacion => text()();
  TextColumn get metodoUsado => text()();
}

class EscenarioPuntoTable extends Table {
  @override
  String get tableName => 'escenario_punto';

  IntColumn get escenarioId =>
      integer().references(EscenarioOptimizacionTable, #id)();
  IntColumn get puntoEntregaId =>
      integer().references(PuntoEntregaTable, #id)();
}

class EscenarioVehiculoTable extends Table {
  @override
  String get tableName => 'escenario_vehiculo';

  IntColumn get escenarioId =>
      integer().references(EscenarioOptimizacionTable, #id)();
  IntColumn get vehiculoId => integer().references(VehiculoTable, #id)();
}

class RutaResultadoTable extends Table {
  @override
  String get tableName => 'ruta_resultado';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get escenarioId =>
      integer().references(EscenarioOptimizacionTable, #id)();
  IntColumn get vehiculoId => integer().references(VehiculoTable, #id)();
  TextColumn get secuenciaParadas => text()();
  RealColumn get distanciaTotalKm => real().nullable()();
  RealColumn get tiempoTotalSegundos => real().nullable()();
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
  EscenarioOptimizacionTable,
  EscenarioPuntoTable,
  EscenarioVehiculoTable,
  RutaResultadoTable,
  CacheOsrmTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_abrirConexion());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _abrirConexion() {
    return driftDatabase(name: 'sistema_optimizacion_rutas');
  }
}
