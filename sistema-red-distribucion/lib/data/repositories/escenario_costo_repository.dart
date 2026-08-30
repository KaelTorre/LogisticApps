import '../local/database.dart';
import '../models/escenario_costo.dart';

class EscenarioCostoRepository {
  EscenarioCostoRepository(this._database);

  final AppDatabase _database;

  Future<List<EscenarioCosto>> obtenerPorEscenario(int escenarioId) async {
    final filas =
        await (_database.select(_database.escenarioCostoTable)
              ..where((t) => t.escenarioId.equals(escenarioId)))
            .get();
    return filas.map(_aDominio).toList();
  }

  Future<void> insertarTodos(List<EscenarioCosto> costos) async {
    await _database.batch((batch) {
      batch.insertAll(
        _database.escenarioCostoTable,
        costos
            .map(
              (c) => EscenarioCostoTableCompanion.insert(
                escenarioId: c.escenarioId,
                rubro: c.rubro,
                montoCent: c.montoCent,
              ),
            )
            .toList(),
      );
    });
  }

  EscenarioCosto _aDominio(EscenarioCostoTableData fila) => EscenarioCosto(
    id: fila.id,
    escenarioId: fila.escenarioId,
    rubro: fila.rubro,
    montoCent: fila.montoCent,
  );
}
