import 'package:drift/drift.dart' show Value;

import '../local/database.dart';
import '../models/punto_entrega.dart';

/// Repositorio de puntos de entrega: catálogo editable de clientes/destinos.
class PuntoEntregaRepository {
  PuntoEntregaRepository(this._database);

  final AppDatabase _database;

  Future<List<PuntoEntrega>> obtenerTodos() async {
    final filas = await _database.select(_database.puntoEntregaTable).get();
    return filas.map(_aDominio).toList();
  }

  Future<int> crear(PuntoEntrega punto) {
    return _database
        .into(_database.puntoEntregaTable)
        .insert(
          PuntoEntregaTableCompanion.insert(
            nombre: punto.nombre,
            latitud: punto.latitud,
            longitud: punto.longitud,
            demanda: Value(punto.demanda),
            ventanaInicio: Value(punto.ventanaInicio),
            ventanaFin: Value(punto.ventanaFin),
          ),
        );
  }

  Future<void> actualizar(PuntoEntrega punto) async {
    await (_database.update(
      _database.puntoEntregaTable,
    )..where((t) => t.id.equals(punto.id!))).write(
      PuntoEntregaTableCompanion(
        nombre: Value(punto.nombre),
        latitud: Value(punto.latitud),
        longitud: Value(punto.longitud),
        demanda: Value(punto.demanda),
        ventanaInicio: Value(punto.ventanaInicio),
        ventanaFin: Value(punto.ventanaFin),
      ),
    );
  }

  Future<void> eliminar(int id) async {
    await (_database.delete(
      _database.puntoEntregaTable,
    )..where((t) => t.id.equals(id))).go();
  }

  /// Inserta [puntos] solo si la tabla todavía está vacía (precarga del
  /// dataset de prueba en el primer arranque).
  Future<void> sembrarSiVacio(List<PuntoEntrega> puntos) async {
    final existentes = await _database
        .select(_database.puntoEntregaTable)
        .get();
    if (existentes.isNotEmpty) return;

    for (final punto in puntos) {
      await _database
          .into(_database.puntoEntregaTable)
          .insert(
            PuntoEntregaTableCompanion.insert(
              nombre: punto.nombre,
              latitud: punto.latitud,
              longitud: punto.longitud,
              demanda: Value(punto.demanda),
            ),
          );
    }
  }

  PuntoEntrega _aDominio(PuntoEntregaTableData fila) => PuntoEntrega(
    id: fila.id,
    nombre: fila.nombre,
    latitud: fila.latitud,
    longitud: fila.longitud,
    demanda: fila.demanda,
    ventanaInicio: fila.ventanaInicio,
    ventanaFin: fila.ventanaFin,
  );
}
