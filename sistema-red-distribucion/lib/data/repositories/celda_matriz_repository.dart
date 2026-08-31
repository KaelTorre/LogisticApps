import 'package:drift/drift.dart' show InsertMode;

import '../local/database.dart';
import '../models/celda_matriz.dart';

/// Matriz de distancias, poblada por M3 (Fase 4). Sin `actualizar`: una
/// celda se recalcula borrándola e insertándola de nuevo, nunca se edita.
class CeldaMatrizRepository {
  CeldaMatrizRepository(this._database);

  final AppDatabase _database;

  Future<List<CeldaMatriz>> obtenerPorProyecto(int proyectoId) async {
    final filas =
        await (_database.select(_database.celdaMatrizTable)
              ..where((t) => t.proyectoId.equals(proyectoId)))
            .get();
    return filas.map(_aDominio).toList();
  }

  /// Inserción en bloque con upsert sobre el `UNIQUE` de la tabla (proyecto,
  /// origen, destino) vía `INSERT OR REPLACE` — M3 (Fase 4) rehace un
  /// bloque entero de la matriz cuando cualquiera de sus celdas falta (ver
  /// `construirMatriz`), lo que puede reenviar celdas que ya estaban
  /// cacheadas con el mismo valor; `insertOrReplace` las pisa sin violar el
  /// `UNIQUE` en vez de fallar.
  Future<void> insertarTodas(List<CeldaMatriz> celdas) async {
    await _database.batch((batch) {
      batch.insertAll(
        _database.celdaMatrizTable,
        celdas
            .map(
              (c) => CeldaMatrizTableCompanion.insert(
                proyectoId: c.proyectoId,
                tipoOrigen: c.tipoOrigen,
                origenId: c.origenId,
                tipoDestino: c.tipoDestino,
                destinoId: c.destinoId,
                distanciaMetros: c.distanciaMetros,
                duracionSegundos: c.duracionSegundos,
                fuente: c.fuente,
              ),
            )
            .toList(),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  Future<void> eliminarPorProyecto(int proyectoId) async {
    await (_database.delete(
      _database.celdaMatrizTable,
    )..where((t) => t.proyectoId.equals(proyectoId))).go();
  }

  CeldaMatriz _aDominio(CeldaMatrizTableData fila) => CeldaMatriz(
    id: fila.id,
    proyectoId: fila.proyectoId,
    tipoOrigen: fila.tipoOrigen,
    origenId: fila.origenId,
    tipoDestino: fila.tipoDestino,
    destinoId: fila.destinoId,
    distanciaMetros: fila.distanciaMetros,
    duracionSegundos: fila.duracionSegundos,
    fuente: fila.fuente,
  );
}
