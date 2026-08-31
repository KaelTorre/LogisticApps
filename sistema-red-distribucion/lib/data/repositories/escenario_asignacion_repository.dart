import '../local/database.dart';
import '../models/escenario_asignacion.dart';

class EscenarioAsignacionRepository {
  EscenarioAsignacionRepository(this._database);

  final AppDatabase _database;

  Future<List<EscenarioAsignacion>> obtenerPorEscenario(
    int escenarioId,
  ) async {
    final filas =
        await (_database.select(_database.escenarioAsignacionTable)
              ..where((t) => t.escenarioId.equals(escenarioId)))
            .get();
    return filas.map(_aDominio).toList();
  }

  Future<void> insertarTodas(List<EscenarioAsignacion> asignaciones) async {
    await _database.batch((batch) {
      batch.insertAll(
        _database.escenarioAsignacionTable,
        asignaciones
            .map(
              (a) => EscenarioAsignacionTableCompanion.insert(
                escenarioId: a.escenarioId,
                zonaId: a.zonaId,
                sitioCandidatoId: a.sitioCandidatoId,
                distanciaMetros: a.distanciaMetros,
                duracionSegundos: a.duracionSegundos,
                costoSalidaCent: a.costoSalidaCent,
              ),
            )
            .toList(),
      );
    });
  }

  EscenarioAsignacion _aDominio(EscenarioAsignacionTableData fila) =>
      EscenarioAsignacion(
        id: fila.id,
        escenarioId: fila.escenarioId,
        zonaId: fila.zonaId,
        sitioCandidatoId: fila.sitioCandidatoId,
        distanciaMetros: fila.distanciaMetros,
        duracionSegundos: fila.duracionSegundos,
        costoSalidaCent: fila.costoSalidaCent,
      );
}
