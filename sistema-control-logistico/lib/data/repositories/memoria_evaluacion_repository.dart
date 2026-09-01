import '../local/database.dart';
import '../models/memoria_evaluacion.dart';

class MemoriaEvaluacionRepository {
  MemoriaEvaluacionRepository(this._database);

  final AppDatabase _database;

  Future<List<MemoriaEvaluacion>> obtenerPorEvaluacion(int evaluacionId) async {
    final filas =
        await (_database.select(_database.memoriaEvaluacionTable)
              ..where((t) => t.evaluacionId.equals(evaluacionId)))
            .get();
    return filas.map(_aDominio).toList();
  }

  Future<int> crear(MemoriaEvaluacion memoria) {
    return _database
        .into(_database.memoriaEvaluacionTable)
        .insert(
          MemoriaEvaluacionTableCompanion.insert(
            evaluacionId: memoria.evaluacionId,
            reglaId: memoria.reglaId,
            resultado: memoria.resultado,
            valoresEntradaJson: memoria.valoresEntradaJson,
            explicacion: memoria.explicacion,
          ),
        );
  }

  Future<void> eliminar(int id) async {
    await (_database.delete(_database.memoriaEvaluacionTable)..where((t) => t.id.equals(id))).go();
  }

  MemoriaEvaluacion _aDominio(MemoriaEvaluacionTableData fila) => MemoriaEvaluacion(
    id: fila.id,
    evaluacionId: fila.evaluacionId,
    reglaId: fila.reglaId,
    resultado: fila.resultado,
    valoresEntradaJson: fila.valoresEntradaJson,
    explicacion: fila.explicacion,
  );
}
