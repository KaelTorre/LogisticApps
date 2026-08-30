import 'package:drift/drift.dart' show Value;

import '../local/database.dart';
import '../models/proyecto.dart';

class ProyectoRepository {
  ProyectoRepository(this._database);

  final AppDatabase _database;

  Future<List<Proyecto>> obtenerTodos() async {
    final filas = await _database.select(_database.proyectoTable).get();
    return filas.map(_aDominio).toList();
  }

  Future<Proyecto?> obtenerPorId(int id) async {
    final fila =
        await (_database.select(_database.proyectoTable)
              ..where((t) => t.id.equals(id)))
            .getSingleOrNull();
    return fila == null ? null : _aDominio(fila);
  }

  Future<int> crear(Proyecto proyecto) {
    return _database
        .into(_database.proyectoTable)
        .insert(
          ProyectoTableCompanion.insert(
            nombre: proyecto.nombre,
            moneda: Value(proyecto.moneda),
            unidadPeso: Value(proyecto.unidadPeso),
            horizonteAnios: Value(proyecto.horizonteAnios),
            factorCircuidad: Value(proyecto.factorCircuidad),
            creadoEn: proyecto.creadoEn,
          ),
        );
  }

  Future<void> actualizar(Proyecto proyecto) async {
    await (_database.update(
      _database.proyectoTable,
    )..where((t) => t.id.equals(proyecto.id!))).write(
      ProyectoTableCompanion(
        nombre: Value(proyecto.nombre),
        moneda: Value(proyecto.moneda),
        unidadPeso: Value(proyecto.unidadPeso),
        horizonteAnios: Value(proyecto.horizonteAnios),
        factorCircuidad: Value(proyecto.factorCircuidad),
      ),
    );
  }

  /// Borra el proyecto y, en cascada (`PRAGMA foreign_keys = ON`), todos
  /// sus clientes, zonas, sitios candidatos, plantas, parámetros de costo,
  /// celdas de matriz y escenarios (que a su vez arrastran su propia
  /// memoria de cálculo).
  Future<void> eliminar(int id) async {
    await (_database.delete(
      _database.proyectoTable,
    )..where((t) => t.id.equals(id))).go();
  }

  Proyecto _aDominio(ProyectoTableData fila) => Proyecto(
    id: fila.id,
    nombre: fila.nombre,
    moneda: fila.moneda,
    unidadPeso: fila.unidadPeso,
    horizonteAnios: fila.horizonteAnios,
    factorCircuidad: fila.factorCircuidad,
    creadoEn: fila.creadoEn,
  );
}
