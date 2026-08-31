import '../local/database.dart';
import '../models/punto_curva.dart';

class PuntoCurvaRepository {
  PuntoCurvaRepository(this._database);

  final AppDatabase _database;

  Future<List<PuntoCurva>> obtenerPorEscenario(int escenarioId) async {
    final filas =
        await (_database.select(_database.puntoCurvaTable)
              ..where((t) => t.escenarioId.equals(escenarioId)))
            .get();
    return filas.map(_aDominio).toList();
  }

  Future<void> insertarTodos(List<PuntoCurva> puntos) async {
    await _database.batch((batch) {
      batch.insertAll(
        _database.puntoCurvaTable,
        puntos
            .map(
              (p) => PuntoCurvaTableCompanion.insert(
                escenarioId: p.escenarioId,
                numeroAlmacenes: p.numeroAlmacenes,
                costoTotalCent: p.costoTotalCent,
                costoPorRubroJson: p.costoPorRubroJson,
                viableSegunServicio: p.viableSegunServicio,
              ),
            )
            .toList(),
      );
    });
  }

  PuntoCurva _aDominio(PuntoCurvaTableData fila) => PuntoCurva(
    id: fila.id,
    escenarioId: fila.escenarioId,
    numeroAlmacenes: fila.numeroAlmacenes,
    costoTotalCent: fila.costoTotalCent,
    costoPorRubroJson: fila.costoPorRubroJson,
    viableSegunServicio: fila.viableSegunServicio,
  );
}
