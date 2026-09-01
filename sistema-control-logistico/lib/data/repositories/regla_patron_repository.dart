import 'package:drift/drift.dart';

import '../local/database.dart';
import '../models/regla_patron.dart';

class ReglaPatronRepository {
  ReglaPatronRepository(this._database);

  final AppDatabase _database;

  Future<List<ReglaPatron>> obtenerTodas() async {
    final filas = await _database.select(_database.reglaPatronTable).get();
    return filas.map(_aDominio).toList();
  }

  /// Reglas globales (`indicadorId` nulo) más los overrides propios del
  /// indicador -- las dos fuentes que M1 debe combinar (CLAUDE.md sección
  /// 8: "puede ser global o por indicador").
  Future<List<ReglaPatron>> obtenerAplicables(int indicadorId) async {
    final filas = await (_database.select(
      _database.reglaPatronTable,
    )..where((t) => t.indicadorId.isNull() | t.indicadorId.equals(indicadorId))).get();
    return filas.map(_aDominio).toList();
  }

  Future<int> crear(ReglaPatron regla) {
    return _database
        .into(_database.reglaPatronTable)
        .insert(
          ReglaPatronTableCompanion.insert(
            codigo: regla.codigo,
            nombre: regla.nombre,
            descripcion: regla.descripcion,
            parametrosJson: regla.parametrosJson,
            periodosMinimos: regla.periodosMinimos,
            severidadBase: regla.severidadBase,
            activa: Value(regla.activa),
            indicadorId: Value(regla.indicadorId),
          ),
        );
  }

  Future<void> actualizar(ReglaPatron regla) async {
    await (_database.update(
      _database.reglaPatronTable,
    )..where((t) => t.id.equals(regla.id!))).write(
      ReglaPatronTableCompanion(
        nombre: Value(regla.nombre),
        descripcion: Value(regla.descripcion),
        parametrosJson: Value(regla.parametrosJson),
        periodosMinimos: Value(regla.periodosMinimos),
        severidadBase: Value(regla.severidadBase),
        activa: Value(regla.activa),
      ),
    );
  }

  Future<void> eliminar(int id) async {
    await (_database.delete(_database.reglaPatronTable)..where((t) => t.id.equals(id))).go();
  }

  ReglaPatron _aDominio(ReglaPatronTableData fila) => ReglaPatron(
    id: fila.id,
    codigo: fila.codigo,
    nombre: fila.nombre,
    descripcion: fila.descripcion,
    parametrosJson: fila.parametrosJson,
    periodosMinimos: fila.periodosMinimos,
    severidadBase: fila.severidadBase,
    activa: fila.activa,
    indicadorId: fila.indicadorId,
  );
}
