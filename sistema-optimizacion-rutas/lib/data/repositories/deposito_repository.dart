import 'package:drift/drift.dart' show Value;

import '../local/database.dart';
import '../models/deposito.dart';

/// Repositorio de depósito. El MVP asume un único depósito activo a la vez
/// (sección 8 de CLAUDE.md), por eso [guardarUnico] actualiza el existente
/// en vez de permitir crear varios.
class DepositoRepository {
  DepositoRepository(this._database);

  final AppDatabase _database;

  Future<List<Deposito>> obtenerTodos() async {
    final filas = await _database.select(_database.depositoTable).get();
    return filas.map(_aDominio).toList();
  }

  /// Crea el depósito si todavía no hay ninguno, o actualiza el existente
  /// (siempre hay a lo sumo uno solo activo).
  Future<void> guardarUnico(Deposito deposito) async {
    final existentes = await obtenerTodos();
    if (existentes.isEmpty) {
      await _database
          .into(_database.depositoTable)
          .insert(
            DepositoTableCompanion.insert(
              nombre: deposito.nombre,
              latitud: deposito.latitud,
              longitud: deposito.longitud,
            ),
          );
      return;
    }

    final id = existentes.first.id!;
    await (_database.update(
      _database.depositoTable,
    )..where((t) => t.id.equals(id))).write(
      DepositoTableCompanion(
        nombre: Value(deposito.nombre),
        latitud: Value(deposito.latitud),
        longitud: Value(deposito.longitud),
      ),
    );
  }

  /// Inserta [deposito] solo si todavía no hay ninguno guardado (pensado
  /// para precargar el dataset de prueba en el primer arranque, sin pisar
  /// datos que el usuario ya haya creado).
  Future<void> sembrarSiVacio(Deposito deposito) async {
    final existentes = await _database.select(_database.depositoTable).get();
    if (existentes.isNotEmpty) return;

    await _database
        .into(_database.depositoTable)
        .insert(
          DepositoTableCompanion.insert(
            nombre: deposito.nombre,
            latitud: deposito.latitud,
            longitud: deposito.longitud,
          ),
        );
  }

  Deposito _aDominio(DepositoTableData fila) => Deposito(
    id: fila.id,
    nombre: fila.nombre,
    latitud: fila.latitud,
    longitud: fila.longitud,
  );
}
