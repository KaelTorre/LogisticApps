import 'package:drift/drift.dart' show Value;

import '../local/database.dart';
import '../models/vehiculo.dart';

/// Repositorio de vehículos. Por ahora solo lectura + siembra del dataset de
/// prueba — el CRUD editable llega en una fase posterior.
class VehiculoRepository {
  VehiculoRepository(this._database);

  final AppDatabase _database;

  Future<List<Vehiculo>> obtenerTodos() async {
    final filas = await _database.select(_database.vehiculoTable).get();
    return filas.map(_aDominio).toList();
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
