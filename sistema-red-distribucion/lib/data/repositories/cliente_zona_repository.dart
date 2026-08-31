import '../local/database.dart';
import '../models/cliente_zona.dart';

/// Asignación cliente → zona escrita por M1 (agregación, Fase 3). Sin
/// `actualizar`: se borra y se reinserta completa, nunca se edita fila por
/// fila (ver comentario de `ClienteZonaTable`).
class ClienteZonaRepository {
  ClienteZonaRepository(this._database);

  final AppDatabase _database;

  Future<List<ClienteZona>> obtenerPorZona(int zonaId) async {
    final filas =
        await (_database.select(_database.clienteZonaTable)
              ..where((t) => t.zonaId.equals(zonaId)))
            .get();
    return filas.map(_aDominio).toList();
  }

  Future<void> insertarTodas(List<ClienteZona> asignaciones) async {
    await _database.batch((batch) {
      batch.insertAll(
        _database.clienteZonaTable,
        asignaciones
            .map(
              (a) => ClienteZonaTableCompanion.insert(
                clienteId: a.clienteId,
                zonaId: a.zonaId,
              ),
            )
            .toList(),
      );
    });
  }

  ClienteZona _aDominio(ClienteZonaTableData fila) =>
      ClienteZona(id: fila.id, clienteId: fila.clienteId, zonaId: fila.zonaId);
}
