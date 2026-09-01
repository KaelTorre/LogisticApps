import 'package:drift/drift.dart' show Value;

import '../local/database.dart';
import '../models/presupuesto.dart';

class PresupuestoRepository {
  PresupuestoRepository(this._database);

  final AppDatabase _database;

  Future<List<Presupuesto>> obtenerPorOrganizacion(int organizacionId) async {
    final filas =
        await (_database.select(_database.presupuestoTable)
              ..where((t) => t.organizacionId.equals(organizacionId)))
            .get();
    return filas.map(_aDominio).toList();
  }

  Future<int> crear(Presupuesto presupuesto) {
    return _database
        .into(_database.presupuestoTable)
        .insert(
          PresupuestoTableCompanion.insert(
            organizacionId: presupuesto.organizacionId,
            rubro: presupuesto.rubro,
            periodoId: presupuesto.periodoId,
            montoPresupuestadoCent: presupuesto.montoPresupuestadoCent,
            montoRealCent: presupuesto.montoRealCent,
          ),
        );
  }

  Future<void> actualizar(Presupuesto presupuesto) async {
    await (_database.update(
      _database.presupuestoTable,
    )..where((t) => t.id.equals(presupuesto.id!))).write(
      PresupuestoTableCompanion(
        montoPresupuestadoCent: Value(presupuesto.montoPresupuestadoCent),
        montoRealCent: Value(presupuesto.montoRealCent),
      ),
    );
  }

  Future<void> eliminar(int id) async {
    await (_database.delete(_database.presupuestoTable)..where((t) => t.id.equals(id))).go();
  }

  Presupuesto _aDominio(PresupuestoTableData fila) => Presupuesto(
    id: fila.id,
    organizacionId: fila.organizacionId,
    rubro: fila.rubro,
    periodoId: fila.periodoId,
    montoPresupuestadoCent: fila.montoPresupuestadoCent,
    montoRealCent: fila.montoRealCent,
  );
}
