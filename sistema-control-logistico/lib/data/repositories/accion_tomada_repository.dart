import 'package:drift/drift.dart' show Value;

import '../local/database.dart';
import '../models/accion_tomada.dart';

class AccionTomadaRepository {
  AccionTomadaRepository(this._database);

  final AppDatabase _database;

  Future<List<AccionTomada>> obtenerPorEvaluacion(int evaluacionId) async {
    final filas =
        await (_database.select(_database.accionTomadaTable)
              ..where((t) => t.evaluacionId.equals(evaluacionId)))
            .get();
    return filas.map(_aDominio).toList();
  }

  Future<List<AccionTomada>> obtenerAbiertas() async {
    final filas = await (_database.select(
      _database.accionTomadaTable,
    )..where((t) => t.estado.equals('abierta'))).get();
    return filas.map(_aDominio).toList();
  }

  Future<int> crear(AccionTomada accion) {
    return _database
        .into(_database.accionTomadaTable)
        .insert(
          AccionTomadaTableCompanion.insert(
            evaluacionId: accion.evaluacionId,
            accionCatalogoId: accion.accionCatalogoId,
            responsable: accion.responsable,
            fechaCompromiso: accion.fechaCompromiso,
            estado: Value(accion.estado),
            notas: Value(accion.notas),
            fechaRegistro: accion.fechaRegistro,
          ),
        );
  }

  Future<void> actualizar(AccionTomada accion) async {
    await (_database.update(
      _database.accionTomadaTable,
    )..where((t) => t.id.equals(accion.id!))).write(
      AccionTomadaTableCompanion(
        responsable: Value(accion.responsable),
        fechaCompromiso: Value(accion.fechaCompromiso),
        estado: Value(accion.estado),
        notas: Value(accion.notas),
      ),
    );
  }

  Future<void> eliminar(int id) async {
    await (_database.delete(_database.accionTomadaTable)..where((t) => t.id.equals(id))).go();
  }

  AccionTomada _aDominio(AccionTomadaTableData fila) => AccionTomada(
    id: fila.id,
    evaluacionId: fila.evaluacionId,
    accionCatalogoId: fila.accionCatalogoId,
    responsable: fila.responsable,
    fechaCompromiso: fila.fechaCompromiso,
    estado: fila.estado,
    notas: fila.notas,
    fechaRegistro: fila.fechaRegistro,
  );
}
