import '../local/database.dart';
import '../models/escenario_almacen.dart';

class EscenarioAlmacenRepository {
  EscenarioAlmacenRepository(this._database);

  final AppDatabase _database;

  Future<List<EscenarioAlmacen>> obtenerPorEscenario(int escenarioId) async {
    final filas =
        await (_database.select(_database.escenarioAlmacenTable)
              ..where((t) => t.escenarioId.equals(escenarioId)))
            .get();
    return filas.map(_aDominio).toList();
  }

  Future<void> insertarTodos(List<EscenarioAlmacen> almacenes) async {
    await _database.batch((batch) {
      batch.insertAll(
        _database.escenarioAlmacenTable,
        almacenes
            .map(
              (a) => EscenarioAlmacenTableCompanion.insert(
                escenarioId: a.escenarioId,
                sitioCandidatoId: a.sitioCandidatoId,
                volumenAsignado: a.volumenAsignado,
                costoFijoCent: a.costoFijoCent,
                costoManejoCent: a.costoManejoCent,
              ),
            )
            .toList(),
      );
    });
  }

  EscenarioAlmacen _aDominio(EscenarioAlmacenTableData fila) =>
      EscenarioAlmacen(
        id: fila.id,
        escenarioId: fila.escenarioId,
        sitioCandidatoId: fila.sitioCandidatoId,
        volumenAsignado: fila.volumenAsignado,
        costoFijoCent: fila.costoFijoCent,
        costoManejoCent: fila.costoManejoCent,
      );
}
