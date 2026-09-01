import 'package:drift/drift.dart';

import '../local/database.dart';
import '../models/medicion.dart';

class MedicionRepository {
  MedicionRepository(this._database);

  final AppDatabase _database;

  /// Siempre ordenado por `periodo.orden` -- nunca por fecha ni por el id
  /// de la medición -- porque `orden` es la única clave de tiempo que el
  /// motor de evaluación reconoce (CLAUDE.md sección 4).
  Future<List<Medicion>> obtenerPorIndicador(int indicadorId) async {
    final consulta =
        _database.select(_database.medicionTable).join([
            innerJoin(
              _database.periodoTable,
              _database.periodoTable.id.equalsExp(_database.medicionTable.periodoId),
            ),
          ])
          ..where(_database.medicionTable.indicadorId.equals(indicadorId))
          ..orderBy([OrderingTerm.asc(_database.periodoTable.orden)]);
    final filas = await consulta.get();
    return filas.map((fila) => _aDominio(fila.readTable(_database.medicionTable))).toList();
  }

  Future<Medicion?> obtenerPorIndicadorYPeriodo(int indicadorId, int periodoId) async {
    final fila = await (_database.select(_database.medicionTable)..where(
          (t) => t.indicadorId.equals(indicadorId) & t.periodoId.equals(periodoId),
        ))
        .getSingleOrNull();
    return fila == null ? null : _aDominio(fila);
  }

  Future<int> crear(Medicion medicion) {
    return _database
        .into(_database.medicionTable)
        .insert(
          MedicionTableCompanion.insert(
            indicadorId: medicion.indicadorId,
            periodoId: medicion.periodoId,
            valor: medicion.valor,
            origen: medicion.origen,
            nota: Value(medicion.nota),
          ),
        );
  }

  Future<void> actualizar(Medicion medicion) async {
    await (_database.update(
      _database.medicionTable,
    )..where((t) => t.id.equals(medicion.id!))).write(
      MedicionTableCompanion(
        valor: Value(medicion.valor),
        origen: Value(medicion.origen),
        nota: Value(medicion.nota),
      ),
    );
  }

  Future<void> eliminar(int id) async {
    await (_database.delete(_database.medicionTable)..where((t) => t.id.equals(id))).go();
  }

  Medicion _aDominio(MedicionTableData fila) => Medicion(
    id: fila.id,
    indicadorId: fila.indicadorId,
    periodoId: fila.periodoId,
    valor: fila.valor,
    origen: fila.origen,
    nota: fila.nota,
  );
}
