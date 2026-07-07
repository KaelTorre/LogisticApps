import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

class ClienteTable extends Table {
  @override
  String get tableName => 'cliente';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
  TextColumn get contacto => text().nullable()();
  TextColumn get notas => text().nullable()();
}

class ProductoTable extends Table {
  @override
  String get tableName => 'producto';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
  TextColumn get categoria => text()(); // CategoriaProducto.valorDb
  RealColumn get peso => real().nullable()();
  RealColumn get volumen => real().nullable()();
  RealColumn get valorUnitario => real()();
  TextColumn get metodoFijacionPrecio => text().nullable()();
  TextColumn get etapaCicloVida => text().nullable()(); // EtapaCicloVida.valorDb
}

class PedidoTable extends Table {
  @override
  String get tableName => 'pedido';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get clienteId => integer().references(ClienteTable, #id)();
  TextColumn get fechaCreacion => text()(); // ISO 8601
  TextColumn get estadoActual => text()(); // EstadoPedido.valorDb, cache del último historial
  IntColumn get prioridad => integer().withDefault(const Constant(0))();
}

class PedidoItemTable extends Table {
  @override
  String get tableName => 'pedido_item';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get pedidoId => integer().references(PedidoTable, #id)();
  IntColumn get productoId => integer().references(ProductoTable, #id)();
  IntColumn get cantidad => integer()();
  RealColumn get precioAplicado => real()(); // snapshot del precio al momento del pedido
}

/// FK viva a `pedido` (no snapshot desnormalizado): a diferencia de un
/// catálogo editable, `pedido` no tiene UPDATE/DELETE en esta app — solo se
/// crea y se avanza de estado dentro de la misma transacción que inserta
/// esta fila, así que no hay drift posible entre ambos.
class HistorialEstadoTable extends Table {
  @override
  String get tableName => 'historial_estado';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get pedidoId => integer().references(PedidoTable, #id)();
  TextColumn get estado => text()(); // EstadoPedido.valorDb
  TextColumn get timestamp => text()(); // ISO 8601, generado por el dispositivo
  TextColumn get nota => text().nullable()();
}

/// Singleton lógico: se mantiene una única fila, gestionada por
/// `ConfiguracionRepository.obtenerOCrearPorDefecto()`.
class ConfiguracionSlaTable extends Table {
  @override
  String get tableName => 'configuracion_sla';

  IntColumn get id => integer().autoIncrement()();
  RealColumn get coeficienteIngreso =>
      real().withDefault(const Constant(0.5))(); // 'a' en P = a·√SL − b·SL²
  RealColumn get coeficienteCosto =>
      real().withDefault(const Constant(0.00055))(); // 'b'
  RealColumn get valorObjetivoM => real().nullable()(); // 'm' para Taguchi
  RealColumn get constanteK => real().nullable()(); // 'k' para Taguchi
}

@DriftDatabase(tables: [
  ClienteTable,
  ProductoTable,
  PedidoTable,
  PedidoItemTable,
  HistorialEstadoTable,
  ConfiguracionSlaTable,
])
class AppDatabase extends _$AppDatabase {
  /// [executor] permite inyectar una base en memoria en tests
  /// (`NativeDatabase.memory()`); en la app se usa siempre `driftDatabase`.
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _abrirConexion());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  static QueryExecutor _abrirConexion() {
    return driftDatabase(name: 'sistema_gestion_pedidos_sla');
  }
}
