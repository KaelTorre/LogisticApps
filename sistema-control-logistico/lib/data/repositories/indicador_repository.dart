import 'package:drift/drift.dart' show Value;

import '../local/database.dart';
import '../models/indicador.dart';

class IndicadorRepository {
  IndicadorRepository(this._database);

  final AppDatabase _database;

  Future<List<Indicador>> obtenerPorOrganizacion(int organizacionId) async {
    final filas =
        await (_database.select(_database.indicadorTable)
              ..where((t) => t.organizacionId.equals(organizacionId)))
            .get();
    return filas.map(_aDominio).toList();
  }

  Future<Indicador?> obtenerPorId(int id) async {
    final fila = await (_database.select(
      _database.indicadorTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return fila == null ? null : _aDominio(fila);
  }

  Future<int> crear(Indicador indicador) {
    return _database
        .into(_database.indicadorTable)
        .insert(
          IndicadorTableCompanion.insert(
            organizacionId: indicador.organizacionId,
            codigo: indicador.codigo,
            nombre: indicador.nombre,
            categoria: indicador.categoria,
            unidad: indicador.unidad,
            decimales: Value(indicador.decimales),
            sentido: indicador.sentido,
            meta: indicador.meta,
            bandaInferior: indicador.bandaInferior,
            bandaSuperior: indicador.bandaSuperior,
            granularidad: indicador.granularidad,
            proceso: indicador.proceso,
            activo: Value(indicador.activo),
          ),
        );
  }

  Future<void> actualizar(Indicador indicador) async {
    await (_database.update(
      _database.indicadorTable,
    )..where((t) => t.id.equals(indicador.id!))).write(
      IndicadorTableCompanion(
        codigo: Value(indicador.codigo),
        nombre: Value(indicador.nombre),
        categoria: Value(indicador.categoria),
        unidad: Value(indicador.unidad),
        decimales: Value(indicador.decimales),
        sentido: Value(indicador.sentido),
        meta: Value(indicador.meta),
        bandaInferior: Value(indicador.bandaInferior),
        bandaSuperior: Value(indicador.bandaSuperior),
        granularidad: Value(indicador.granularidad),
        proceso: Value(indicador.proceso),
        activo: Value(indicador.activo),
      ),
    );
  }

  Future<void> eliminar(int id) async {
    await (_database.delete(_database.indicadorTable)..where((t) => t.id.equals(id))).go();
  }

  Indicador _aDominio(IndicadorTableData fila) => Indicador(
    id: fila.id,
    organizacionId: fila.organizacionId,
    codigo: fila.codigo,
    nombre: fila.nombre,
    categoria: fila.categoria,
    unidad: fila.unidad,
    decimales: fila.decimales,
    sentido: fila.sentido,
    meta: fila.meta,
    bandaInferior: fila.bandaInferior,
    bandaSuperior: fila.bandaSuperior,
    granularidad: fila.granularidad,
    proceso: fila.proceso,
    activo: fila.activo,
  );
}
