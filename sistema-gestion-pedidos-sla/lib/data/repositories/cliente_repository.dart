import 'package:drift/drift.dart' show Value;

import '../local/database.dart';
import '../models/cliente.dart';

class ClienteRepository {
  ClienteRepository(this._database);

  final AppDatabase _database;

  Future<List<Cliente>> obtenerTodos() async {
    final filas = await _database.select(_database.clienteTable).get();
    return filas.map(_aDominio).toList();
  }

  Future<Cliente?> obtenerPorId(int id) async {
    final fila = await (_database.select(
      _database.clienteTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return fila == null ? null : _aDominio(fila);
  }

  Future<int> crear(Cliente cliente) {
    return _database.into(_database.clienteTable).insert(
          ClienteTableCompanion.insert(
            nombre: cliente.nombre,
            contacto: Value(cliente.contacto),
            notas: Value(cliente.notas),
          ),
        );
  }

  Future<void> actualizar(Cliente cliente) async {
    await (_database.update(
      _database.clienteTable,
    )..where((t) => t.id.equals(cliente.id!))).write(
      ClienteTableCompanion(
        nombre: Value(cliente.nombre),
        contacto: Value(cliente.contacto),
        notas: Value(cliente.notas),
      ),
    );
  }

  Future<void> eliminar(int id) async {
    await (_database.delete(
      _database.clienteTable,
    )..where((t) => t.id.equals(id))).go();
  }

  /// `true` si el cliente tiene al menos un pedido asociado — bloquea el
  /// botón "Eliminar" en la UI antes de que la FK real rechace el borrado.
  Future<bool> tienePedidosAsociados(int id) async {
    final fila = await (_database.select(
      _database.pedidoTable,
    )..where((t) => t.clienteId.equals(id))).getSingleOrNull();
    return fila != null;
  }

  Cliente _aDominio(ClienteTableData fila) => Cliente(
        id: fila.id,
        nombre: fila.nombre,
        contacto: fila.contacto,
        notas: fila.notas,
      );
}
