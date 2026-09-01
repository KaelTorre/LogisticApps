import 'package:drift/drift.dart' show Value;

import '../local/database.dart';
import '../models/verificacion_accion.dart';

class VerificacionAccionRepository {
  VerificacionAccionRepository(this._database);

  final AppDatabase _database;

  Future<List<VerificacionAccion>> obtenerPorAccionTomada(int accionTomadaId) async {
    final filas =
        await (_database.select(_database.verificacionAccionTable)
              ..where((t) => t.accionTomadaId.equals(accionTomadaId)))
            .get();
    return filas.map(_aDominio).toList();
  }

  Future<int> crear(VerificacionAccion verificacion) {
    return _database
        .into(_database.verificacionAccionTable)
        .insert(
          VerificacionAccionTableCompanion.insert(
            accionTomadaId: verificacion.accionTomadaId,
            periodoVerificacionId: verificacion.periodoVerificacionId,
            resultado: verificacion.resultado,
            valorObservado: verificacion.valorObservado,
            comentario: Value(verificacion.comentario),
            confirmadoPorUsuario: Value(verificacion.confirmadoPorUsuario),
          ),
        );
  }

  /// El usuario confirma o corrige la propuesta de M4 -- nunca se cierra la
  /// acción sola (CLAUDE.md sección 8, [REGLA]).
  Future<void> confirmar(int id, {required String resultado}) async {
    await (_database.update(
      _database.verificacionAccionTable,
    )..where((t) => t.id.equals(id))).write(
      VerificacionAccionTableCompanion(
        resultado: Value(resultado),
        confirmadoPorUsuario: const Value(true),
      ),
    );
  }

  Future<void> eliminar(int id) async {
    await (_database.delete(
      _database.verificacionAccionTable,
    )..where((t) => t.id.equals(id))).go();
  }

  VerificacionAccion _aDominio(VerificacionAccionTableData fila) => VerificacionAccion(
    id: fila.id,
    accionTomadaId: fila.accionTomadaId,
    periodoVerificacionId: fila.periodoVerificacionId,
    resultado: fila.resultado,
    valorObservado: fila.valorObservado,
    comentario: fila.comentario,
    confirmadoPorUsuario: fila.confirmadoPorUsuario,
  );
}
