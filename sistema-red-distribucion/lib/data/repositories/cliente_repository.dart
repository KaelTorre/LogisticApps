import 'package:drift/drift.dart' show Value;

import '../local/database.dart';
import '../models/cliente.dart';

class ClienteRepository {
  ClienteRepository(this._database);

  final AppDatabase _database;

  Future<List<Cliente>> obtenerPorProyecto(int proyectoId) async {
    final filas =
        await (_database.select(_database.clienteTable)
              ..where((t) => t.proyectoId.equals(proyectoId)))
            .get();
    return filas.map(_aDominio).toList();
  }

  Future<int> crear(Cliente cliente) {
    return _database
        .into(_database.clienteTable)
        .insert(
          ClienteTableCompanion.insert(
            proyectoId: cliente.proyectoId,
            nombre: cliente.nombre,
            latitud: cliente.latitud,
            longitud: cliente.longitud,
            demandaAnual: cliente.demandaAnual,
            pedidosAnuales: cliente.pedidosAnuales,
            activo: Value(cliente.activo),
          ),
        );
  }

  Future<void> actualizar(Cliente cliente) async {
    await (_database.update(
      _database.clienteTable,
    )..where((t) => t.id.equals(cliente.id!))).write(
      ClienteTableCompanion(
        nombre: Value(cliente.nombre),
        latitud: Value(cliente.latitud),
        longitud: Value(cliente.longitud),
        demandaAnual: Value(cliente.demandaAnual),
        pedidosAnuales: Value(cliente.pedidosAnuales),
        activo: Value(cliente.activo),
      ),
    );
  }

  Future<void> eliminar(int id) async {
    await (_database.delete(
      _database.clienteTable,
    )..where((t) => t.id.equals(id))).go();
  }

  Cliente _aDominio(ClienteTableData fila) => Cliente(
    id: fila.id,
    proyectoId: fila.proyectoId,
    nombre: fila.nombre,
    latitud: fila.latitud,
    longitud: fila.longitud,
    demandaAnual: fila.demandaAnual,
    pedidosAnuales: fila.pedidosAnuales,
    activo: fila.activo,
  );
}
