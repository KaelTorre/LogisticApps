import 'package:drift/drift.dart' show Value;

import '../local/database.dart';
import '../models/planta.dart';

class PlantaRepository {
  PlantaRepository(this._database);

  final AppDatabase _database;

  Future<List<Planta>> obtenerPorProyecto(int proyectoId) async {
    final filas =
        await (_database.select(_database.plantaTable)
              ..where((t) => t.proyectoId.equals(proyectoId)))
            .get();
    return filas.map(_aDominio).toList();
  }

  Future<int> crear(Planta planta) {
    return _database
        .into(_database.plantaTable)
        .insert(
          PlantaTableCompanion.insert(
            proyectoId: planta.proyectoId,
            nombre: planta.nombre,
            latitud: planta.latitud,
            longitud: planta.longitud,
            capacidadAnual: planta.capacidadAnual,
            costoProduccionCentPorUnidad: planta.costoProduccionCentPorUnidad,
          ),
        );
  }

  Future<void> actualizar(Planta planta) async {
    await (_database.update(
      _database.plantaTable,
    )..where((t) => t.id.equals(planta.id!))).write(
      PlantaTableCompanion(
        nombre: Value(planta.nombre),
        latitud: Value(planta.latitud),
        longitud: Value(planta.longitud),
        capacidadAnual: Value(planta.capacidadAnual),
        costoProduccionCentPorUnidad: Value(
          planta.costoProduccionCentPorUnidad,
        ),
      ),
    );
  }

  Future<void> eliminar(int id) async {
    await (_database.delete(
      _database.plantaTable,
    )..where((t) => t.id.equals(id))).go();
  }

  Planta _aDominio(PlantaTableData fila) => Planta(
    id: fila.id,
    proyectoId: fila.proyectoId,
    nombre: fila.nombre,
    latitud: fila.latitud,
    longitud: fila.longitud,
    capacidadAnual: fila.capacidadAnual,
    costoProduccionCentPorUnidad: fila.costoProduccionCentPorUnidad,
  );
}
