import 'package:drift/drift.dart' show Value;

import '../local/database.dart';
import '../models/vehiculo.dart';

/// Repositorio de vehículos: catálogo editable de la flota disponible.
class VehiculoRepository {
  VehiculoRepository(this._database);

  final AppDatabase _database;

  Future<List<Vehiculo>> obtenerTodos() async {
    final filas = await _database.select(_database.vehiculoTable).get();
    return filas.map(_aDominio).toList();
  }

  Future<int> crear(Vehiculo vehiculo) {
    return _database
        .into(_database.vehiculoTable)
        .insert(
          VehiculoTableCompanion.insert(
            nombre: vehiculo.nombre,
            capacidadMaxima: vehiculo.capacidadMaxima,
            costoEstimadoPorKm: Value(vehiculo.costoEstimadoPorKm),
            tipoFlota: Value(vehiculo.tipoFlota),
          ),
        );
  }

  Future<void> actualizar(Vehiculo vehiculo) async {
    await (_database.update(
      _database.vehiculoTable,
    )..where((t) => t.id.equals(vehiculo.id!))).write(
      VehiculoTableCompanion(
        nombre: Value(vehiculo.nombre),
        capacidadMaxima: Value(vehiculo.capacidadMaxima),
        costoEstimadoPorKm: Value(vehiculo.costoEstimadoPorKm),
        tipoFlota: Value(vehiculo.tipoFlota),
      ),
    );
  }

  Future<void> eliminar(int id) async {
    await (_database.delete(
      _database.vehiculoTable,
    )..where((t) => t.id.equals(id))).go();
  }

  /// Inserta [vehiculos] solo si la tabla todavía está vacía (precarga del
  /// dataset de prueba en el primer arranque).
  Future<void> sembrarSiVacio(List<Vehiculo> vehiculos) async {
    final existentes = await _database.select(_database.vehiculoTable).get();
    if (existentes.isNotEmpty) return;

    for (final vehiculo in vehiculos) {
      await _database
          .into(_database.vehiculoTable)
          .insert(
            VehiculoTableCompanion.insert(
              nombre: vehiculo.nombre,
              capacidadMaxima: vehiculo.capacidadMaxima,
              costoEstimadoPorKm: Value(vehiculo.costoEstimadoPorKm),
              tipoFlota: Value(vehiculo.tipoFlota),
            ),
          );
    }
  }

  Vehiculo _aDominio(VehiculoTableData fila) => Vehiculo(
    id: fila.id,
    nombre: fila.nombre,
    capacidadMaxima: fila.capacidadMaxima,
    costoEstimadoPorKm: fila.costoEstimadoPorKm,
    tipoFlota: fila.tipoFlota,
  );
}
