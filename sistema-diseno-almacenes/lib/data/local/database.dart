import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

// ─── Catálogo (semilla precargada, editable por el usuario) ───

class CatalogoTarimas extends Table {
  @override
  String get tableName => 'catalogo_tarimas';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get codigo => text().unique()();
  IntColumn get largoMm => integer()();
  IntColumn get anchoMm => integer()();
  IntColumn get altoMm => integer()();
  IntColumn get taraG => integer()();
  IntColumn get cargaDinG => integer().nullable()();
  IntColumn get cargaEstG => integer().nullable()();
  TextColumn get region => text().nullable()();
  TextColumn get fuente => text()();
  BoolColumn get esSemilla => boolean().withDefault(const Constant(true))();
}

class CatalogoBastidores extends Table {
  @override
  String get tableName => 'catalogo_bastidores';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get codigo => text().unique()();
  IntColumn get fondoMm => integer()();
  IntColumn get alturaMm => integer()();
  IntColumn get perfilAnchoMm => integer()();
  IntColumn get perfilFondoMm => integer()();
  TextColumn get fuente => text()();
  BoolColumn get esSemilla => boolean().withDefault(const Constant(true))();
}

class CatalogoVigas extends Table {
  @override
  String get tableName => 'catalogo_vigas';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get codigo => text().unique()();
  IntColumn get largoMm => integer()();
  IntColumn get peralteMm => integer()();
  // NULL a propósito: la capacidad admisible depende del cálculo estructural
  // del perfil (área, inercia, deflexión L/180) que este proyecto no hace
  // (CLAUDE.md sección 1 — no es un certificador estructural). Solo se llena
  // cuando hay ficha técnica real de un producto comercial concreto.
  IntColumn get capacidadParG => integer().nullable()();
  TextColumn get fuente => text()();
  BoolColumn get esSemilla => boolean().withDefault(const Constant(true))();
}

class CatalogoEquipos extends Table {
  @override
  String get tableName => 'catalogo_equipos';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get codigo => text().unique()();
  // transpaleta | apilador | contrabalanceado | retractil | trilateral | transelevador
  TextColumn get tipo => text()();
  TextColumn get claseEn => text().nullable()();
  IntColumn get pasilloMinMm => integer()();
  IntColumn get pasilloMaxMm => integer()();
  IntColumn get elevacionMaxMm => integer()();
  IntColumn get alturaMastilMm => integer().nullable()();
  BoolColumn get requiereGuiado =>
      boolean().withDefault(const Constant(false))();
  IntColumn get costoUnitarioCent => integer().nullable()();
  TextColumn get fuente => text()();
  BoolColumn get esSemilla => boolean().withDefault(const Constant(true))();
}

class CatalogoCamiones extends Table {
  @override
  String get tableName => 'catalogo_camiones';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get codigo => text().unique()();
  IntColumn get largoMm => integer()();
  IntColumn get anchoMm => integer()();
  IntColumn get patioMinMm => integer()();
  TextColumn get fuente => text()();
  BoolColumn get esSemilla => boolean().withDefault(const Constant(true))();
}

class ParametrosNorma extends Table {
  @override
  String get tableName => 'parametros_norma';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get norma => text()(); // EN | RMI
  TextColumn get clave => text()(); // holgura_x_mm, holgura_y_mm, ...
  IntColumn get valor => integer()();
  TextColumn get clase => text().nullable()();
  TextColumn get fuente => text()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {norma, clave, clase},
  ];
}

// ─── Proyecto ───

class Proyectos extends Table {
  @override
  String get tableName => 'proyectos';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
  TextColumn get norma => text().withDefault(const Constant('EN'))();
  TextColumn get moneda => text().withDefault(const Constant('PEN'))();
  IntColumn get horizonteAnios => integer().withDefault(const Constant(5))();
  IntColumn get alturaLibreMm => integer().nullable()();
  IntColumn get reservaTechoMm => integer().withDefault(const Constant(450))();
  TextColumn get creadoEn => text()();
}

class FamiliasProducto extends Table {
  @override
  String get tableName => 'familias_producto';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get proyectoId =>
      integer().references(Proyectos, #id, onDelete: KeyAction.cascade)();
  TextColumn get nombre => text()();
  IntColumn get tarimaId => integer().references(CatalogoTarimas, #id)();
  IntColumn get altoCargaMm => integer()(); // SIN la tarima
  IntColumn get pesoCargaG => integer()();
  IntColumn get unidadesPorTarima => integer()();
  IntColumn get apilableNiveles => integer().withDefault(const Constant(1))();
  RealColumn get rotacionAnual => real().nullable()(); // veces/año
  TextColumn get claseAbc => text().nullable()(); // A | B | C
}

class DemandaPeriodos extends Table {
  @override
  String get tableName => 'demanda_periodos';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get familiaId => integer()
      .references(FamiliasProducto, #id, onDelete: KeyAction.cascade)();
  TextColumn get periodo => text()(); // 'YYYY-MM'
  RealColumn get demanda => real()();
  BoolColumn get esPronostico =>
      boolean().withDefault(const Constant(false))();
}

class Escenarios extends Table {
  @override
  String get tableName => 'escenarios';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get proyectoId =>
      integer().references(Proyectos, #id, onDelete: KeyAction.cascade)();
  TextColumn get nombre => text()();
  // selectivo | doble_fondo | drive_in | push_back | dinamico | lanzadera
  TextColumn get tipoSistema => text()();
  IntColumn get equipoId => integer().references(CatalogoEquipos, #id)();
  IntColumn get bastidorId =>
      integer().nullable().references(CatalogoBastidores, #id)();
  IntColumn get vigaId =>
      integer().nullable().references(CatalogoVigas, #id)();
  IntColumn get tarimasPorNivel => integer().nullable()(); // NULL = lo decide el motor
  TextColumn get patronFlujo =>
      text().withDefault(const Constant('U'))(); // U | pasante | L
  RealColumn get factorHoneycomb =>
      real().withDefault(const Constant(0.20))();
  BoolColumn get esBase => boolean().withDefault(const Constant(false))();
}

class Resultados extends Table {
  @override
  String get tableName => 'resultados';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get escenarioId =>
      integer().references(Escenarios, #id, onDelete: KeyAction.cascade)();
  TextColumn get calculadoEn => text()();
  IntColumn get posicionesRequeridas => integer()();
  IntColumn get posicionesInstaladas => integer()();
  IntColumn get modulos => integer()();
  IntColumn get filas => integer()();
  IntColumn get niveles => integer()();
  IntColumn get supAlmacenamientoMm2 => integer()();
  IntColumn get supConstruidaMm2 => integer()();
  IntColumn get puertasAnden => integer()();
  IntColumn get patioProfundidadMm => integer()();
  IntColumn get distanciaEsperadaMm => integer().nullable()(); // M6
  IntColumn get inversionCent => integer().nullable()();
}

class Zonas extends Table {
  @override
  String get tableName => 'zonas';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get resultadoId =>
      integer().references(Resultados, #id, onDelete: KeyAction.cascade)();
  // reserva | picking | recepcion | despacho | preparacion | devoluciones
  // | oficinas | carga_baterias | circulacion | anden
  TextColumn get tipo => text()();
  IntColumn get xMm => integer()();
  IntColumn get yMm => integer()();
  IntColumn get anchoMm => integer()();
  IntColumn get largoMm => integer()();
}

// ─── Trazabilidad ───

class MemoriaCalculo extends Table {
  @override
  String get tableName => 'memoria_calculo';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get resultadoId =>
      integer().references(Resultados, #id, onDelete: KeyAction.cascade)();
  IntColumn get orden => integer()();
  TextColumn get modulo => text()(); // M1..M8
  TextColumn get concepto => text()();
  TextColumn get formula => text()(); // legible por humano
  TextColumn get entradas => text()(); // JSON
  TextColumn get valor => text()();
  TextColumn get unidad => text()();
  TextColumn get fuente => text().nullable()(); // norma o supuesto que lo respalda
}

@DriftDatabase(
  tables: [
    CatalogoTarimas,
    CatalogoBastidores,
    CatalogoVigas,
    CatalogoEquipos,
    CatalogoCamiones,
    ParametrosNorma,
    Proyectos,
    FamiliasProducto,
    DemandaPeriodos,
    Escenarios,
    Resultados,
    Zonas,
    MemoriaCalculo,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// [executor] permite inyectar una base en memoria en tests
  /// (`NativeDatabase.memory()`); en la app se usa siempre `driftDatabase`.
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _abrirConexion());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    // SQLite trae la aplicación de foreign keys apagada por conexión salvo
    // que se pida explícitamente — sin esto, ON DELETE CASCADE no se dispara.
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  static QueryExecutor _abrirConexion() {
    return driftDatabase(name: 'sistema_diseno_almacenes');
  }
}
