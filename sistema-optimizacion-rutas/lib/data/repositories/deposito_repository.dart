import '../local/database.dart';
import '../models/deposito.dart';

/// Repositorio de depósito. Por ahora solo lectura + siembra del dataset de
/// prueba — el CRUD editable (crear/editar/eliminar) llega en una fase
/// posterior.
class DepositoRepository {
  DepositoRepository(this._database);

  final AppDatabase _database;

  Future<List<Deposito>> obtenerTodos() async {
    final filas = await _database.select(_database.depositoTable).get();
    return filas.map(_aDominio).toList();
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
