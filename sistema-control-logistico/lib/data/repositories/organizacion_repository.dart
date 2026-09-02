import 'package:drift/drift.dart' show OrderingTerm, Value;

import '../local/database.dart';
import '../models/organizacion.dart';

class OrganizacionRepository {
  OrganizacionRepository(this._database);

  final AppDatabase _database;

  Future<List<Organizacion>> obtenerTodas() async {
    final filas = await (_database.select(
      _database.organizacionTable,
    )..orderBy([(t) => OrderingTerm.asc(t.id)])).get();
    return filas.map(_aDominio).toList();
  }

  Future<Organizacion?> obtenerPorId(int id) async {
    final fila = await (_database.select(
      _database.organizacionTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return fila == null ? null : _aDominio(fila);
  }

  Future<int> crear(Organizacion organizacion) {
    return _database
        .into(_database.organizacionTable)
        .insert(
          OrganizacionTableCompanion.insert(
            nombre: organizacion.nombre,
            moneda: Value(organizacion.moneda),
            tipoEmpresa: organizacion.tipoEmpresa,
            notas: Value(organizacion.notas),
          ),
        );
  }

  Future<void> actualizar(Organizacion organizacion) async {
    await (_database.update(
      _database.organizacionTable,
    )..where((t) => t.id.equals(organizacion.id!))).write(
      OrganizacionTableCompanion(
        nombre: Value(organizacion.nombre),
        moneda: Value(organizacion.moneda),
        tipoEmpresa: Value(organizacion.tipoEmpresa),
        notas: Value(organizacion.notas),
      ),
    );
  }

  Future<void> eliminar(int id) async {
    await (_database.delete(_database.organizacionTable)..where((t) => t.id.equals(id))).go();
  }

  Organizacion _aDominio(OrganizacionTableData fila) => Organizacion(
    id: fila.id,
    nombre: fila.nombre,
    moneda: fila.moneda,
    tipoEmpresa: fila.tipoEmpresa,
    notas: fila.notas,
  );
}
