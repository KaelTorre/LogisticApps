import 'package:drift/drift.dart' show Value;

import '../local/database.dart';
import '../models/accion_catalogo.dart';

class AccionCatalogoRepository {
  AccionCatalogoRepository(this._database);

  final AppDatabase _database;

  Future<List<AccionCatalogo>> obtenerTodas() async {
    final filas = await _database.select(_database.accionCatalogoTable).get();
    return filas.map(_aDominio).toList();
  }

  Future<int> crear(AccionCatalogo accion) {
    return _database
        .into(_database.accionCatalogoTable)
        .insert(
          AccionCatalogoTableCompanion.insert(
            codigo: accion.codigo,
            titulo: accion.titulo,
            descripcion: accion.descripcion,
            categoriaIndicador: accion.categoriaIndicador,
            magnitudTipica: accion.magnitudTipica,
            esDeSistema: Value(accion.esDeSistema),
            aplicacionExternaSugerida: Value(accion.aplicacionExternaSugerida),
          ),
        );
  }

  Future<void> actualizar(AccionCatalogo accion) async {
    await (_database.update(
      _database.accionCatalogoTable,
    )..where((t) => t.id.equals(accion.id!))).write(
      AccionCatalogoTableCompanion(
        titulo: Value(accion.titulo),
        descripcion: Value(accion.descripcion),
        categoriaIndicador: Value(accion.categoriaIndicador),
        magnitudTipica: Value(accion.magnitudTipica),
        aplicacionExternaSugerida: Value(accion.aplicacionExternaSugerida),
      ),
    );
  }

  Future<void> eliminar(int id) async {
    await (_database.delete(_database.accionCatalogoTable)..where((t) => t.id.equals(id))).go();
  }

  AccionCatalogo _aDominio(AccionCatalogoTableData fila) => AccionCatalogo(
    id: fila.id,
    codigo: fila.codigo,
    titulo: fila.titulo,
    descripcion: fila.descripcion,
    categoriaIndicador: fila.categoriaIndicador,
    magnitudTipica: fila.magnitudTipica,
    esDeSistema: fila.esDeSistema,
    aplicacionExternaSugerida: fila.aplicacionExternaSugerida,
  );
}
