import 'package:drift/drift.dart';

import '../local/database.dart';
import '../models/regla_accion.dart';

class ReglaAccionRepository {
  ReglaAccionRepository(this._database);

  final AppDatabase _database;

  Future<List<ReglaAccion>> obtenerTodas() async {
    final filas = await _database.select(_database.reglaAccionTable).get();
    return filas.map(_aDominio).toList();
  }

  /// Lo que consulta M3: candidatas para una (categoría, regla disparada,
  /// clasificación), ordenadas por prioridad ascendente.
  Future<List<ReglaAccion>> obtenerCandidatas({
    required String categoriaIndicador,
    required String reglaDisparada,
    required String clasificacion,
  }) async {
    final filas =
        await (_database.select(_database.reglaAccionTable)
              ..where(
                (t) =>
                    t.categoriaIndicador.equals(categoriaIndicador) &
                    t.reglaDisparada.equals(reglaDisparada) &
                    t.clasificacion.equals(clasificacion),
              )
              ..orderBy([(t) => OrderingTerm.asc(t.prioridad)]))
            .get();
    return filas.map(_aDominio).toList();
  }

  Future<int> crear(ReglaAccion reglaAccion) {
    return _database
        .into(_database.reglaAccionTable)
        .insert(
          ReglaAccionTableCompanion.insert(
            categoriaIndicador: reglaAccion.categoriaIndicador,
            reglaDisparada: reglaAccion.reglaDisparada,
            clasificacion: reglaAccion.clasificacion,
            accionId: reglaAccion.accionId,
            prioridad: reglaAccion.prioridad,
          ),
        );
  }

  Future<void> eliminar(int id) async {
    await (_database.delete(_database.reglaAccionTable)..where((t) => t.id.equals(id))).go();
  }

  ReglaAccion _aDominio(ReglaAccionTableData fila) => ReglaAccion(
    id: fila.id,
    categoriaIndicador: fila.categoriaIndicador,
    reglaDisparada: fila.reglaDisparada,
    clasificacion: fila.clasificacion,
    accionId: fila.accionId,
    prioridad: fila.prioridad,
  );
}
