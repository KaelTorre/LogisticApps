import 'package:drift/drift.dart' show Value;

import '../local/database.dart';
import '../models/escenario.dart';

class EscenarioRepository {
  EscenarioRepository(this._database);

  final AppDatabase _database;

  Future<List<Escenario>> obtenerPorProyecto(int proyectoId) async {
    final filas =
        await (_database.select(_database.escenarioTable)
              ..where((t) => t.proyectoId.equals(proyectoId)))
            .get();
    return filas.map(_aDominio).toList();
  }

  Future<Escenario?> obtenerPorId(int id) async {
    final fila =
        await (_database.select(_database.escenarioTable)
              ..where((t) => t.id.equals(id)))
            .getSingleOrNull();
    return fila == null ? null : _aDominio(fila);
  }

  Future<int> crear(Escenario escenario) {
    return _database
        .into(_database.escenarioTable)
        .insert(
          EscenarioTableCompanion.insert(
            proyectoId: escenario.proyectoId,
            nombre: escenario.nombre,
            metodo: escenario.metodo,
            pFijo: Value(escenario.pFijo),
            restriccionCapacidadActiva: Value(
              escenario.restriccionCapacidadActiva,
            ),
            costoTotalCent: escenario.costoTotalCent,
            fecha: escenario.fecha,
            notas: Value(escenario.notas),
          ),
        );
  }

  /// Borra el escenario y, en cascada, sus almacenes/asignaciones/costos,
  /// puntos de curva y memoria de cálculo.
  Future<void> eliminar(int id) async {
    await (_database.delete(
      _database.escenarioTable,
    )..where((t) => t.id.equals(id))).go();
  }

  Escenario _aDominio(EscenarioTableData fila) => Escenario(
    id: fila.id,
    proyectoId: fila.proyectoId,
    nombre: fila.nombre,
    metodo: fila.metodo,
    pFijo: fila.pFijo,
    restriccionCapacidadActiva: fila.restriccionCapacidadActiva,
    costoTotalCent: fila.costoTotalCent,
    fecha: fila.fecha,
    notas: fila.notas,
  );
}
