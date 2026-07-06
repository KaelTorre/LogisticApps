import 'package:drift/drift.dart' show Value;

import '../local/database.dart';
import '../models/deposito.dart';

/// Repositorio de depósito: catálogo editable de depósitos (Fase avanzada:
/// la app admite varios, el usuario elige de cuál sale la mercadería en
/// cada cálculo — ver `EscenarioProvider.depositosDisponibles`).
class DepositoRepository {
  DepositoRepository(this._database);

  final AppDatabase _database;

  Future<List<Deposito>> obtenerTodos() async {
    final filas = await _database.select(_database.depositoTable).get();
    return filas.map(_aDominio).toList();
  }

  Future<int> crear(Deposito deposito) {
    return _database
        .into(_database.depositoTable)
        .insert(
          DepositoTableCompanion.insert(
            nombre: deposito.nombre,
            latitud: deposito.latitud,
            longitud: deposito.longitud,
          ),
        );
  }

  Future<void> actualizar(Deposito deposito) async {
    await (_database.update(
      _database.depositoTable,
    )..where((t) => t.id.equals(deposito.id!))).write(
      DepositoTableCompanion(
        nombre: Value(deposito.nombre),
        latitud: Value(deposito.latitud),
        longitud: Value(deposito.longitud),
      ),
    );
  }

  Future<void> eliminar(int id) async {
    await (_database.delete(
      _database.depositoTable,
    )..where((t) => t.id.equals(id))).go();
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
