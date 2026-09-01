import 'package:drift/drift.dart';

import '../local/database.dart';
import '../models/periodo.dart';

class PeriodoRepository {
  PeriodoRepository(this._database);

  final AppDatabase _database;

  /// Siempre ordenado por `orden`, la clave real del sistema (CLAUDE.md
  /// sección 4) -- nunca por `fechaInicio`, que es solo metadato.
  Future<List<Periodo>> obtenerPorOrganizacion(int organizacionId) async {
    final filas =
        await (_database.select(_database.periodoTable)
              ..where((t) => t.organizacionId.equals(organizacionId))
              ..orderBy([(t) => OrderingTerm.asc(t.orden)]))
            .get();
    return filas.map(_aDominio).toList();
  }

  Future<Periodo?> obtenerPorId(int id) async {
    final fila = await (_database.select(
      _database.periodoTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return fila == null ? null : _aDominio(fila);
  }

  Future<int> crear(Periodo periodo) {
    return _database
        .into(_database.periodoTable)
        .insert(
          PeriodoTableCompanion.insert(
            organizacionId: periodo.organizacionId,
            orden: periodo.orden,
            etiqueta: periodo.etiqueta,
            fechaInicio: periodo.fechaInicio,
            fechaFin: periodo.fechaFin,
            granularidad: periodo.granularidad,
            esSimulado: Value(periodo.esSimulado),
          ),
        );
  }

  Future<void> actualizar(Periodo periodo) async {
    await (_database.update(
      _database.periodoTable,
    )..where((t) => t.id.equals(periodo.id!))).write(
      PeriodoTableCompanion(
        orden: Value(periodo.orden),
        etiqueta: Value(periodo.etiqueta),
        fechaInicio: Value(periodo.fechaInicio),
        fechaFin: Value(periodo.fechaFin),
        granularidad: Value(periodo.granularidad),
        esSimulado: Value(periodo.esSimulado),
      ),
    );
  }

  Future<void> eliminar(int id) async {
    await (_database.delete(_database.periodoTable)..where((t) => t.id.equals(id))).go();
  }

  Periodo _aDominio(PeriodoTableData fila) => Periodo(
    id: fila.id,
    organizacionId: fila.organizacionId,
    orden: fila.orden,
    etiqueta: fila.etiqueta,
    fechaInicio: fila.fechaInicio,
    fechaFin: fila.fechaFin,
    granularidad: fila.granularidad,
    esSimulado: fila.esSimulado,
  );
}
