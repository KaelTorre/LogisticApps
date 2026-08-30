import 'package:drift/drift.dart' show Value;

import '../local/database.dart';
import '../models/zona_demanda.dart';

class ZonaDemandaRepository {
  ZonaDemandaRepository(this._database);

  final AppDatabase _database;

  Future<List<ZonaDemanda>> obtenerPorProyecto(int proyectoId) async {
    final filas =
        await (_database.select(_database.zonaDemandaTable)
              ..where((t) => t.proyectoId.equals(proyectoId)))
            .get();
    return filas.map(_aDominio).toList();
  }

  Future<int> crear(ZonaDemanda zona) {
    return _database
        .into(_database.zonaDemandaTable)
        .insert(
          ZonaDemandaTableCompanion.insert(
            proyectoId: zona.proyectoId,
            etiqueta: zona.etiqueta,
            latitud: zona.latitud,
            longitud: zona.longitud,
            demandaAgregada: zona.demandaAgregada,
            pedidosAgregados: zona.pedidosAgregados,
            numeroClientes: zona.numeroClientes,
            errorAgregacionMetros: zona.errorAgregacionMetros,
          ),
        );
  }

  Future<void> actualizar(ZonaDemanda zona) async {
    await (_database.update(
      _database.zonaDemandaTable,
    )..where((t) => t.id.equals(zona.id!))).write(
      ZonaDemandaTableCompanion(
        etiqueta: Value(zona.etiqueta),
        latitud: Value(zona.latitud),
        longitud: Value(zona.longitud),
        demandaAgregada: Value(zona.demandaAgregada),
        pedidosAgregados: Value(zona.pedidosAgregados),
        numeroClientes: Value(zona.numeroClientes),
        errorAgregacionMetros: Value(zona.errorAgregacionMetros),
      ),
    );
  }

  Future<void> eliminar(int id) async {
    await (_database.delete(
      _database.zonaDemandaTable,
    )..where((t) => t.id.equals(id))).go();
  }

  /// Borra todas las zonas (y, en cascada, `cliente_zona`) de un proyecto —
  /// M1 (Fase 3) recalcula la agregación completa en vez de editarla fila
  /// por fila.
  Future<void> eliminarPorProyecto(int proyectoId) async {
    await (_database.delete(
      _database.zonaDemandaTable,
    )..where((t) => t.proyectoId.equals(proyectoId))).go();
  }

  ZonaDemanda _aDominio(ZonaDemandaTableData fila) => ZonaDemanda(
    id: fila.id,
    proyectoId: fila.proyectoId,
    etiqueta: fila.etiqueta,
    latitud: fila.latitud,
    longitud: fila.longitud,
    demandaAgregada: fila.demandaAgregada,
    pedidosAgregados: fila.pedidosAgregados,
    numeroClientes: fila.numeroClientes,
    errorAgregacionMetros: fila.errorAgregacionMetros,
  );
}
