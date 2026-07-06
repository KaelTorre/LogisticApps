import 'package:drift/drift.dart' show Value;

import '../local/database.dart';
import '../models/punto_entrega.dart';

/// Repositorio de puntos de entrega. Por ahora solo lectura + siembra del
/// dataset de prueba — el CRUD editable llega en una fase posterior.
class PuntoEntregaRepository {
  PuntoEntregaRepository(this._database);

  final AppDatabase _database;

  Future<List<PuntoEntrega>> obtenerTodos() async {
    final filas = await _database.select(_database.puntoEntregaTable).get();
    return filas.map(_aDominio).toList();
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
