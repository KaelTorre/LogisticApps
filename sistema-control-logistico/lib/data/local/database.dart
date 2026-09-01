import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

// Invariante monetaria (CLAUDE.md sección 7, [REGLA]): todo importe se
// guarda en céntimos enteros (columnas *Cent). Los valores de indicador
// (meta, banda, medición) se guardan como `double` porque pueden ser
// porcentajes, ratios o tiempos, no siempre dinero — siempre acompañados de
// su `unidad`/`decimales` de presentación en `indicador`.

// ─── Organización y periodos ───

class OrganizacionTable extends Table {
  @override
  String get tableName => 'organizacion';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
  TextColumn get moneda => text().withDefault(const Constant('PEN'))();
  // extractiva | manufacturera | servicios | marketing (CLAUDE.md sección 7)
  TextColumn get tipoEmpresa => text()();
  TextColumn get notas => text().nullable()();
}

// `orden` es la clave real del sistema (CLAUDE.md sección 4: el periodo es
// un dato, no el reloj). `fechaInicio`/`fechaFin` son metadatos de
// presentación -- el motor de evaluación nunca los lee para decidir orden.
class PeriodoTable extends Table {
  @override
  String get tableName => 'periodo';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get organizacionId =>
      integer().references(OrganizacionTable, #id, onDelete: KeyAction.cascade)();
  IntColumn get orden => integer()();
  TextColumn get etiqueta => text()();
  TextColumn get fechaInicio => text()();
  TextColumn get fechaFin => text()();
  // diario | semanal | mensual | trimestral
  TextColumn get granularidad => text()();
  BoolColumn get esSimulado => boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column>> get uniqueKeys => [
    {organizacionId, orden},
  ];
}

// ─── Indicadores y mediciones ───

class IndicadorTable extends Table {
  @override
  String get tableName => 'indicador';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get organizacionId =>
      integer().references(OrganizacionTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get codigo => text()();
  TextColumn get nombre => text()();
  // costo | servicio | productividad
  TextColumn get categoria => text()();
  TextColumn get unidad => text()();
  IntColumn get decimales => integer().withDefault(const Constant(2))();
  // menor_mejor | mayor_mejor -- define qué lado de la banda es adverso
  // (CLAUDE.md sección 8, M1: "toda regla se escribe en términos de
  // 'adverso', nunca de 'mayor'").
  TextColumn get sentido => text()();
  RealColumn get meta => real()();
  RealColumn get bandaInferior => real()();
  RealColumn get bandaSuperior => real()();
  TextColumn get granularidad => text()();
  TextColumn get proceso => text()();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();

  @override
  List<Set<Column>> get uniqueKeys => [
    {organizacionId, codigo},
  ];
}

class MedicionTable extends Table {
  @override
  String get tableName => 'medicion';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get indicadorId =>
      integer().references(IndicadorTable, #id, onDelete: KeyAction.cascade)();
  IntColumn get periodoId => integer().references(PeriodoTable, #id, onDelete: KeyAction.cascade)();
  RealColumn get valor => real()();
  // manual | importado | derivado | sintetico
  TextColumn get origen => text()();
  TextColumn get nota => text().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {indicadorId, periodoId},
  ];
}

// ─── Reglas de patrón (M1) ───

// Catálogo de reglas, de sistema (R1..R6) o agregadas por el usuario.
// `indicadorId` nulo = regla global, aplicable a cualquier indicador; no
// nulo = override específico de ese indicador (CLAUDE.md sección 8: "puede
// ser global o por indicador").
class ReglaPatronTable extends Table {
  @override
  String get tableName => 'regla_patron';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get codigo => text()();
  TextColumn get nombre => text()();
  TextColumn get descripcion => text()();
  TextColumn get parametrosJson => text()();
  IntColumn get periodosMinimos => integer()();
  RealColumn get severidadBase => real()();
  BoolColumn get activa => boolean().withDefault(const Constant(true))();
  IntColumn get indicadorId =>
      integer().nullable().references(IndicadorTable, #id, onDelete: KeyAction.cascade)();
}

// ─── Evaluación y memoria ───

class EvaluacionTable extends Table {
  @override
  String get tableName => 'evaluacion';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get indicadorId =>
      integer().references(IndicadorTable, #id, onDelete: KeyAction.cascade)();
  IntColumn get periodoId => integer().references(PeriodoTable, #id, onDelete: KeyAction.cascade)();
  // normal | observacion | desviacion
  TextColumn get estado => text()();
  // ninguna | ajuste_menor | replaneacion_mayor | contingencia
  TextColumn get clasificacion => text()();
  TextColumn get reglasDisparadasJson => text()();
  RealColumn get severidadCalculada => real()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {indicadorId, periodoId},
  ];
}

// Trazabilidad obligatoria del motor (mismo criterio que `memoria_calculo`
// en las Unidades 4 y 5): toda regla evaluada -- disparada, no disparada o
// no evaluable -- deja una fila aquí con sus valores de entrada, para que
// el veredicto sea auditable.
class MemoriaEvaluacionTable extends Table {
  @override
  String get tableName => 'memoria_evaluacion';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get evaluacionId =>
      integer().references(EvaluacionTable, #id, onDelete: KeyAction.cascade)();
  IntColumn get reglaId => integer().references(ReglaPatronTable, #id)();
  // disparada | no_disparada | no_evaluable
  TextColumn get resultado => text()();
  TextColumn get valoresEntradaJson => text()();
  TextColumn get explicacion => text()();
}

// ─── Biblioteca de acciones correctoras (M3) ───

class AccionCatalogoTable extends Table {
  @override
  String get tableName => 'accion_catalogo';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get codigo => text()();
  TextColumn get titulo => text()();
  TextColumn get descripcion => text()();
  // costo | servicio | productividad
  TextColumn get categoriaIndicador => text()();
  // ajuste_menor | replaneacion_mayor | contingencia
  TextColumn get magnitudTipica => text()();
  BoolColumn get esDeSistema => boolean().withDefault(const Constant(true))();
  TextColumn get aplicacionExternaSugerida => text().nullable()();
}

// Mapeo (categoría + regla disparada + clasificación) → acciones candidatas
// que consulta M3, con prioridad de orden.
class ReglaAccionTable extends Table {
  @override
  String get tableName => 'regla_accion';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get categoriaIndicador => text()();
  TextColumn get reglaDisparada => text()();
  TextColumn get clasificacion => text()();
  IntColumn get accionId =>
      integer().references(AccionCatalogoTable, #id, onDelete: KeyAction.cascade)();
  IntColumn get prioridad => integer()();
}

// ─── Acciones tomadas y verificación (M4) ───

class AccionTomadaTable extends Table {
  @override
  String get tableName => 'accion_tomada';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get evaluacionId =>
      integer().references(EvaluacionTable, #id, onDelete: KeyAction.cascade)();
  IntColumn get accionCatalogoId => integer().references(AccionCatalogoTable, #id)();
  TextColumn get responsable => text()();
  TextColumn get fechaCompromiso => text()();
  // abierta | cerrada | descartada -- [REGLA] nunca se cierra sola, solo el
  // usuario la confirma vía verificacion_accion.confirmado.
  TextColumn get estado => text().withDefault(const Constant('abierta'))();
  TextColumn get notas => text().nullable()();
  // Sello de auditoría -- uno de los dos únicos usos permitidos de
  // DateTime.now() en todo el proyecto (CLAUDE.md sección 4), y vive fuera
  // de lib/domain/motor/.
  TextColumn get fechaRegistro => text()();
}

class VerificacionAccionTable extends Table {
  @override
  String get tableName => 'verificacion_accion';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get accionTomadaId =>
      integer().references(AccionTomadaTable, #id, onDelete: KeyAction.cascade)();
  IntColumn get periodoVerificacionId =>
      integer().references(PeriodoTable, #id, onDelete: KeyAction.cascade)();
  // corrigio | no_corrigio | parcial -- lo que M4 propone.
  TextColumn get resultado => text()();
  RealColumn get valorObservado => real()();
  TextColumn get comentario => text().nullable()();
  // [REGLA] "El sistema propone, el usuario confirma. No se cierra una
  // acción automáticamente." -- mientras esto sea falso, `resultado` es una
  // propuesta, no un veredicto, y accion_tomada.estado sigue en 'abierta'.
  BoolColumn get confirmadoPorUsuario => boolean().withDefault(const Constant(false))();
}

// ─── Presupuesto ───

class PresupuestoTable extends Table {
  @override
  String get tableName => 'presupuesto';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get organizacionId =>
      integer().references(OrganizacionTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get rubro => text()();
  IntColumn get periodoId => integer().references(PeriodoTable, #id, onDelete: KeyAction.cascade)();
  IntColumn get montoPresupuestadoCent => integer()();
  IntColumn get montoRealCent => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {organizacionId, rubro, periodoId},
  ];
}

// ─── Laboratorio de escenarios (M5) ───

class EscenarioSinteticoTable extends Table {
  @override
  String get tableName => 'escenario_sintetico';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
  IntColumn get indicadorBaseId =>
      integer().references(IndicadorTable, #id, onDelete: KeyAction.cascade)();
  // estable | punto_aislado | tendencia | corrimiento | estacional |
  // deterioro_brusco
  TextColumn get patron => text()();
  TextColumn get parametrosJson => text()();
  IntColumn get semilla => integer()();
  IntColumn get numeroPeriodos => integer()();
}

// ─── Módulos complementarios (M9, M10) ───

class DiagnosticoOrganizacionalTable extends Table {
  @override
  String get tableName => 'diagnostico_organizacional';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get organizacionId =>
      integer().references(OrganizacionTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get fecha => text()();
  TextColumn get respuestasJson => text()();
  TextColumn get etapaResultante => text()();
  TextColumn get opcionOrganizacional => text()();
  TextColumn get ejesJson => text()();
  TextColumn get orientacionDominante => text()();
}

class FacturaTransporteTable extends Table {
  @override
  String get tableName => 'factura_transporte';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get organizacionId =>
      integer().references(OrganizacionTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get numero => text()();
  TextColumn get transportista => text()();
  RealColumn get peso => real()();
  TextColumn get ruta => text()();
  IntColumn get tarifaAplicadaCent => integer()();
  IntColumn get tarifaContratadaCent => integer()();
  // tarifa | peso | ruta | descripcion | duplicado | cargo_accesorio | null
  // (sin discrepancia)
  TextColumn get discrepanciaTipo => text().nullable()();
  IntColumn get montoRecuperableCent => integer().withDefault(const Constant(0))();
  // pendiente | recuperado | descartado
  TextColumn get estado => text().withDefault(const Constant('pendiente'))();
}

@DriftDatabase(
  tables: [
    OrganizacionTable,
    PeriodoTable,
    IndicadorTable,
    MedicionTable,
    ReglaPatronTable,
    EvaluacionTable,
    MemoriaEvaluacionTable,
    AccionCatalogoTable,
    ReglaAccionTable,
    AccionTomadaTable,
    VerificacionAccionTable,
    PresupuestoTable,
    EscenarioSinteticoTable,
    DiagnosticoOrganizacionalTable,
    FacturaTransporteTable,
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
    // que se pida explícitamente -- sin esto, ON DELETE CASCADE no se
    // dispara.
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  static QueryExecutor _abrirConexion() {
    return driftDatabase(name: 'sistema_control_logistico');
  }
}
