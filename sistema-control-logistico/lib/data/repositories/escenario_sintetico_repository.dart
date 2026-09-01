import '../local/database.dart';
import '../models/escenario_sintetico.dart';

class EscenarioSinteticoRepository {
  EscenarioSinteticoRepository(this._database);

  final AppDatabase _database;

  Future<List<EscenarioSintetico>> obtenerTodos() async {
    final filas = await _database.select(_database.escenarioSinteticoTable).get();
    return filas.map(_aDominio).toList();
  }

  Future<int> crear(EscenarioSintetico escenario) {
    return _database
        .into(_database.escenarioSinteticoTable)
        .insert(
          EscenarioSinteticoTableCompanion.insert(
            nombre: escenario.nombre,
            indicadorBaseId: escenario.indicadorBaseId,
            patron: escenario.patron,
            parametrosJson: escenario.parametrosJson,
            semilla: escenario.semilla,
            numeroPeriodos: escenario.numeroPeriodos,
          ),
        );
  }

  Future<void> eliminar(int id) async {
    await (_database.delete(
      _database.escenarioSinteticoTable,
    )..where((t) => t.id.equals(id))).go();
  }

  EscenarioSintetico _aDominio(EscenarioSinteticoTableData fila) => EscenarioSintetico(
    id: fila.id,
    nombre: fila.nombre,
    indicadorBaseId: fila.indicadorBaseId,
    patron: fila.patron,
    parametrosJson: fila.parametrosJson,
    semilla: fila.semilla,
    numeroPeriodos: fila.numeroPeriodos,
  );
}
