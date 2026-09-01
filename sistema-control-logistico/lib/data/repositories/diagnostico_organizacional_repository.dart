import '../local/database.dart';
import '../models/diagnostico_organizacional.dart';

class DiagnosticoOrganizacionalRepository {
  DiagnosticoOrganizacionalRepository(this._database);

  final AppDatabase _database;

  Future<List<DiagnosticoOrganizacional>> obtenerPorOrganizacion(int organizacionId) async {
    final filas =
        await (_database.select(_database.diagnosticoOrganizacionalTable)
              ..where((t) => t.organizacionId.equals(organizacionId)))
            .get();
    return filas.map(_aDominio).toList();
  }

  Future<int> crear(DiagnosticoOrganizacional diagnostico) {
    return _database
        .into(_database.diagnosticoOrganizacionalTable)
        .insert(
          DiagnosticoOrganizacionalTableCompanion.insert(
            organizacionId: diagnostico.organizacionId,
            fecha: diagnostico.fecha,
            respuestasJson: diagnostico.respuestasJson,
            etapaResultante: diagnostico.etapaResultante,
            opcionOrganizacional: diagnostico.opcionOrganizacional,
            ejesJson: diagnostico.ejesJson,
            orientacionDominante: diagnostico.orientacionDominante,
          ),
        );
  }

  Future<void> eliminar(int id) async {
    await (_database.delete(
      _database.diagnosticoOrganizacionalTable,
    )..where((t) => t.id.equals(id))).go();
  }

  DiagnosticoOrganizacional _aDominio(DiagnosticoOrganizacionalTableData fila) =>
      DiagnosticoOrganizacional(
        id: fila.id,
        organizacionId: fila.organizacionId,
        fecha: fila.fecha,
        respuestasJson: fila.respuestasJson,
        etapaResultante: fila.etapaResultante,
        opcionOrganizacional: fila.opcionOrganizacional,
        ejesJson: fila.ejesJson,
        orientacionDominante: fila.orientacionDominante,
      );
}
