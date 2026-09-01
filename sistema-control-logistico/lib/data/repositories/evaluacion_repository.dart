import 'package:drift/drift.dart';

import '../local/database.dart';
import '../models/evaluacion.dart';

class EvaluacionRepository {
  EvaluacionRepository(this._database);

  final AppDatabase _database;

  Future<List<Evaluacion>> obtenerPorIndicador(int indicadorId) async {
    final filas =
        await (_database.select(_database.evaluacionTable)
              ..where((t) => t.indicadorId.equals(indicadorId)))
            .get();
    return filas.map(_aDominio).toList();
  }

  Future<Evaluacion?> obtenerPorIndicadorYPeriodo(int indicadorId, int periodoId) async {
    final fila = await (_database.select(_database.evaluacionTable)..where(
          (t) => t.indicadorId.equals(indicadorId) & t.periodoId.equals(periodoId),
        ))
        .getSingleOrNull();
    return fila == null ? null : _aDominio(fila);
  }

  Future<int> crear(Evaluacion evaluacion) {
    return _database
        .into(_database.evaluacionTable)
        .insert(
          EvaluacionTableCompanion.insert(
            indicadorId: evaluacion.indicadorId,
            periodoId: evaluacion.periodoId,
            estado: evaluacion.estado,
            clasificacion: evaluacion.clasificacion,
            reglasDisparadasJson: evaluacion.reglasDisparadasJson,
            severidadCalculada: evaluacion.severidadCalculada,
          ),
        );
  }

  Future<void> actualizar(Evaluacion evaluacion) async {
    await (_database.update(
      _database.evaluacionTable,
    )..where((t) => t.id.equals(evaluacion.id!))).write(
      EvaluacionTableCompanion(
        estado: Value(evaluacion.estado),
        clasificacion: Value(evaluacion.clasificacion),
        reglasDisparadasJson: Value(evaluacion.reglasDisparadasJson),
        severidadCalculada: Value(evaluacion.severidadCalculada),
      ),
    );
  }

  Future<void> eliminar(int id) async {
    await (_database.delete(_database.evaluacionTable)..where((t) => t.id.equals(id))).go();
  }

  Evaluacion _aDominio(EvaluacionTableData fila) => Evaluacion(
    id: fila.id,
    indicadorId: fila.indicadorId,
    periodoId: fila.periodoId,
    estado: fila.estado,
    clasificacion: fila.clasificacion,
    reglasDisparadasJson: fila.reglasDisparadasJson,
    severidadCalculada: fila.severidadCalculada,
  );
}
