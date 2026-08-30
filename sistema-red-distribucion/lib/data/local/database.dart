import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

// Invariante monetaria (CLAUDE.md sección 6, [REGLA]): todo importe se
// guarda en céntimos enteros (columnas *Cent), toda distancia en metros
// enteros, toda duración en segundos enteros. Los `double` (RealColumn)
// solo aparecen en coordenadas, pesos/demanda y factores.

// ─── Proyecto ───

class ProyectoTable extends Table {
  @override
  String get tableName => 'proyecto';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
  TextColumn get moneda => text().withDefault(const Constant('PEN'))();
  // toneladas | kilogramos | unidades — sin conversión automática entre
  // proyectos (CLAUDE.md sección 10: si el usuario mezcla unidades, el
  // sistema no puede detectarlo, así que se fija una sola por proyecto).
  TextColumn get unidadPeso =>
      text().withDefault(const Constant('toneladas'))();
  IntColumn get horizonteAnios => integer().withDefault(const Constant(5))();
  // Respaldo en línea recta cuando no hay red ni caché (CLAUDE.md
  // sección 5.3c). Default 1.30, calibrable por el usuario.
  RealColumn get factorCircuidad => real().withDefault(const Constant(1.30))();
  TextColumn get creadoEn => text()();
}

// ─── Demanda ───

class ClienteTable extends Table {
  @override
  String get tableName => 'cliente';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get proyectoId =>
      integer().references(ProyectoTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get nombre => text()();
  RealColumn get latitud => real()();
  RealColumn get longitud => real()();
  RealColumn get demandaAnual => real()();
  IntColumn get pedidosAnuales => integer()();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
}

class ZonaDemandaTable extends Table {
  @override
  String get tableName => 'zona_demanda';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get proyectoId =>
      integer().references(ProyectoTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get etiqueta => text()();
  RealColumn get latitud => real()(); // centroide ponderado
  RealColumn get longitud => real()();
  RealColumn get demandaAgregada => real()();
  IntColumn get pedidosAgregados => integer()();
  IntColumn get numeroClientes => integer()();
  IntColumn get errorAgregacionMetros => integer()();
}

// Asignación cliente → zona, resultado de M1 (agregación, Fase 3). Sin
// datos propios más allá del vínculo: se borra y se recalcula completa
// cada vez que corre la agregación, nunca se edita fila por fila.
class ClienteZonaTable extends Table {
  @override
  String get tableName => 'cliente_zona';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get clienteId =>
      integer().references(ClienteTable, #id, onDelete: KeyAction.cascade)();
  IntColumn get zonaId => integer()
      .references(ZonaDemandaTable, #id, onDelete: KeyAction.cascade)();
}

// ─── Oferta ───

class SitioCandidatoTable extends Table {
  @override
  String get tableName => 'sitio_candidato';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get proyectoId =>
      integer().references(ProyectoTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get nombre => text()();
  RealColumn get latitud => real()();
  RealColumn get longitud => real()();
  IntColumn get costoFijoAnualCent => integer()();
  RealColumn get capacidadAnual => real()();
  IntColumn get costoVariableManejoCentPorUnidad => integer()();
  // manual | centro_gravedad (M2, Fase 3) — CLAUDE.md sección 7: un
  // candidato de centro_gravedad es una sugerencia, nunca una decisión.
  TextColumn get origen => text()();
  BoolColumn get esRedActual =>
      boolean().withDefault(const Constant(false))();
}

class PlantaTable extends Table {
  @override
  String get tableName => 'planta';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get proyectoId =>
      integer().references(ProyectoTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get nombre => text()();
  RealColumn get latitud => real()();
  RealColumn get longitud => real()();
  RealColumn get capacidadAnual => real()();
  IntColumn get costoProduccionCentPorUnidad => integer()();
}

// Un registro por proyecto (uniqueKeys abajo) — los siete rubros de costo
// que arma M4 (CLAUDE.md sección 7).
class ParametrosCostoTable extends Table {
  @override
  String get tableName => 'parametros_costo';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get proyectoId =>
      integer().references(ProyectoTable, #id, onDelete: KeyAction.cascade)();
  IntColumn get tarifaEntradaFijaCent => integer()();
  IntColumn get tarifaEntradaCentPorKmTon => integer()();
  IntColumn get tarifaSalidaFijaCent => integer()();
  IntColumn get tarifaSalidaCentPorKmTon => integer()();
  RealColumn get tasaManejoInventarioAnual => real()(); // fracción, ej. 0.25
  IntColumn get valorPorUnidadCent => integer()();
  RealColumn get inventarioBaseUnaUbicacion => real()(); // peso
  IntColumn get costoPorPedidoCent => integer()();
  // distancia | tiempo — determina si estandarServicioValor son metros o
  // segundos (ambos se guardan como entero, ver invariante arriba).
  TextColumn get tipoEstandar => text()();
  IntColumn get estandarServicioValor => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {proyectoId},
  ];
}

// ─── Matriz de distancias (poblada en Fase 4, M3) ───

class CeldaMatrizTable extends Table {
  @override
  String get tableName => 'celda_matriz';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get proyectoId =>
      integer().references(ProyectoTable, #id, onDelete: KeyAction.cascade)();
  // planta | candidato — el id real vive en origenId, sin FK real porque
  // apunta a una de dos tablas distintas según este valor.
  TextColumn get tipoOrigen => text()();
  IntColumn get origenId => integer()();
  // Hoy siempre 'zona' (M3 solo consulta candidatos/plantas → zonas), pero
  // se declara igual de genérico que tipoOrigen por si un futuro módulo
  // agrega otro tipo de destino.
  TextColumn get tipoDestino => text()();
  IntColumn get destinoId => integer()();
  IntColumn get distanciaMetros => integer()();
  IntColumn get duracionSegundos => integer()();
  TextColumn get fuente => text()(); // osrm | haversine

  @override
  List<Set<Column>> get uniqueKeys => [
    {proyectoId, tipoOrigen, origenId, tipoDestino, destinoId},
  ];
}

// Backing de CacheRuteo (paquete_geo_logistica) — mismo shape que
// cache_osrm en sistema-optimizacion-rutas. Global, no por proyecto: una
// respuesta de OSRM para las mismas coordenadas sirve para cualquier
// proyecto que las vuelva a consultar.
class CacheRuteoTable extends Table {
  @override
  String get tableName => 'cache_ruteo';

  TextColumn get hashConsulta => text()();
  TextColumn get tipo => text()();
  TextColumn get respuestaJson => text()();
  TextColumn get fechaConsulta => text()();

  @override
  Set<Column> get primaryKey => {hashConsulta};
}

// ─── Escenarios (resultado de las heurísticas de ubicación, Fases 5-7) ───

class EscenarioTable extends Table {
  @override
  String get tableName => 'escenario';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get proyectoId =>
      integer().references(ProyectoTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get nombre => text()();
  // add | drop | intercambio | recocido | enumeracion (CLAUDE.md M6)
  TextColumn get metodo => text()();
  IntColumn get pFijo => integer().nullable()(); // null = p libre (barrido)
  BoolColumn get restriccionCapacidadActiva =>
      boolean().withDefault(const Constant(false))();
  IntColumn get costoTotalCent => integer()();
  TextColumn get fecha => text()();
  TextColumn get notas => text().nullable()();
}

// Resultado, no verdad — se borra y se recalcula (mismo patrón que
// `resultados` en sistema-diseno-almacenes). Sin cascade hacia
// sitio_candidato/zona_demanda: no se puede borrar un candidato o zona
// mientras un escenario ya calculado lo referencia.

class EscenarioAlmacenTable extends Table {
  @override
  String get tableName => 'escenario_almacen';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get escenarioId => integer()
      .references(EscenarioTable, #id, onDelete: KeyAction.cascade)();
  IntColumn get sitioCandidatoId =>
      integer().references(SitioCandidatoTable, #id)();
  RealColumn get volumenAsignado => real()();
  IntColumn get costoFijoCent => integer()();
  IntColumn get costoManejoCent => integer()();
}

class EscenarioAsignacionTable extends Table {
  @override
  String get tableName => 'escenario_asignacion';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get escenarioId => integer()
      .references(EscenarioTable, #id, onDelete: KeyAction.cascade)();
  IntColumn get zonaId => integer().references(ZonaDemandaTable, #id)();
  IntColumn get sitioCandidatoId =>
      integer().references(SitioCandidatoTable, #id)();
  IntColumn get distanciaMetros => integer()();
  IntColumn get duracionSegundos => integer()();
  IntColumn get costoSalidaCent => integer()();
}

// Desglose por los siete rubros de M4 (CLAUDE.md sección 7).
class EscenarioCostoTable extends Table {
  @override
  String get tableName => 'escenario_costo';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get escenarioId => integer()
      .references(EscenarioTable, #id, onDelete: KeyAction.cascade)();
  // produccion | entrada | salida | fijo | manejo | inventario | pedidos
  TextColumn get rubro => text()();
  IntColumn get montoCent => integer()();
}

// Un punto de la curva de costo total contra número de almacenes (M8,
// Fase 7). `escenarioId` es el escenario padre del barrido.
class PuntoCurvaTable extends Table {
  @override
  String get tableName => 'punto_curva';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get escenarioId => integer()
      .references(EscenarioTable, #id, onDelete: KeyAction.cascade)();
  IntColumn get numeroAlmacenes => integer()();
  IntColumn get costoTotalCent => integer()();
  TextColumn get costoPorRubroJson => text()(); // JSON: {rubro: centavos}
  BoolColumn get viableSegunServicio => boolean()();
}

// ─── Trazabilidad ───

// Réplica del patrón de memoria de cálculo de la Unidad 4 — obligatorio
// (CLAUDE.md sección 6): todo número visible en la interfaz debe poder
// abrirse y mostrar de dónde salió.
class MemoriaCalculoTable extends Table {
  @override
  String get tableName => 'memoria_calculo';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get escenarioId => integer()
      .references(EscenarioTable, #id, onDelete: KeyAction.cascade)();
  IntColumn get orden => integer()(); // paso
  TextColumn get modulo => text()(); // M1..M9
  TextColumn get formula => text()(); // legible por humano
  TextColumn get entradasJson => text()(); // JSON
  TextColumn get salida => text()();
  TextColumn get unidad => text()();
}

@DriftDatabase(
  tables: [
    ProyectoTable,
    ClienteTable,
    ZonaDemandaTable,
    ClienteZonaTable,
    SitioCandidatoTable,
    PlantaTable,
    ParametrosCostoTable,
    CeldaMatrizTable,
    CacheRuteoTable,
    EscenarioTable,
    EscenarioAlmacenTable,
    EscenarioAsignacionTable,
    EscenarioCostoTable,
    PuntoCurvaTable,
    MemoriaCalculoTable,
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
    // que se pida explícitamente — sin esto, ON DELETE CASCADE no se
    // dispara (y tampoco se bloquean las referencias sin cascade).
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  static QueryExecutor _abrirConexion() {
    return driftDatabase(name: 'sistema_red_distribucion');
  }
}
