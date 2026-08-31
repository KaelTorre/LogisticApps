import 'package:drift/drift.dart' show OrderingTerm;

import '../local/database.dart';
import '../models/memoria_calculo.dart';

class MemoriaCalculoRepository {
  MemoriaCalculoRepository(this._database);

  final AppDatabase _database;

  Future<List<MemoriaCalculo>> obtenerPorEscenario(int escenarioId) async {
    final filas =
        await (_database.select(_database.memoriaCalculoTable)
              ..where((t) => t.escenarioId.equals(escenarioId))
              ..orderBy([(t) => OrderingTerm.asc(t.orden)]))
            .get();
    return filas.map(_aDominio).toList();
  }

  Future<int> crear(MemoriaCalculo fila) {
    return _database
        .into(_database.memoriaCalculoTable)
        .insert(
          MemoriaCalculoTableCompanion.insert(
            escenarioId: fila.escenarioId,
            orden: fila.orden,
            modulo: fila.modulo,
            formula: fila.formula,
            entradasJson: fila.entradasJson,
            salida: fila.salida,
            unidad: fila.unidad,
          ),
        );
  }

  Future<void> insertarTodas(List<MemoriaCalculo> filas) async {
    await _database.batch((batch) {
      batch.insertAll(
        _database.memoriaCalculoTable,
        filas
            .map(
              (f) => MemoriaCalculoTableCompanion.insert(
                escenarioId: f.escenarioId,
                orden: f.orden,
                modulo: f.modulo,
                formula: f.formula,
                entradasJson: f.entradasJson,
                salida: f.salida,
                unidad: f.unidad,
              ),
            )
            .toList(),
      );
    });
  }

  MemoriaCalculo _aDominio(MemoriaCalculoTableData fila) => MemoriaCalculo(
    id: fila.id,
    escenarioId: fila.escenarioId,
    orden: fila.orden,
    modulo: fila.modulo,
    formula: fila.formula,
    entradasJson: fila.entradasJson,
    salida: fila.salida,
    unidad: fila.unidad,
  );
}
