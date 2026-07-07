import 'package:drift/drift.dart' show Value;

import '../../core/constants.dart';
import '../local/database.dart';
import '../models/producto.dart';

class ProductoRepository {
  ProductoRepository(this._database);

  final AppDatabase _database;

  Future<List<Producto>> obtenerTodos() async {
    final filas = await _database.select(_database.productoTable).get();
    return filas.map(_aDominio).toList();
  }

  Future<Producto?> obtenerPorId(int id) async {
    final fila = await (_database.select(
      _database.productoTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return fila == null ? null : _aDominio(fila);
  }

  Future<int> crear(Producto producto) {
    return _database.into(_database.productoTable).insert(
          ProductoTableCompanion.insert(
            nombre: producto.nombre,
            categoria: producto.categoria.valorDb,
            peso: Value(producto.peso),
            volumen: Value(producto.volumen),
            valorUnitario: producto.valorUnitario,
            metodoFijacionPrecio: Value(producto.metodoFijacionPrecio),
            etapaCicloVida: Value(producto.etapaCicloVida?.valorDb),
          ),
        );
  }

  Future<void> actualizar(Producto producto) async {
    await (_database.update(
      _database.productoTable,
    )..where((t) => t.id.equals(producto.id!))).write(
      ProductoTableCompanion(
        nombre: Value(producto.nombre),
        categoria: Value(producto.categoria.valorDb),
        peso: Value(producto.peso),
        volumen: Value(producto.volumen),
        valorUnitario: Value(producto.valorUnitario),
        metodoFijacionPrecio: Value(producto.metodoFijacionPrecio),
        etapaCicloVida: Value(producto.etapaCicloVida?.valorDb),
      ),
    );
  }

  Future<void> eliminar(int id) async {
    await (_database.delete(
      _database.productoTable,
    )..where((t) => t.id.equals(id))).go();
  }

  /// `true` si el producto tiene al menos un `pedido_item` asociado —
  /// bloquea el botón "Eliminar" en la UI antes de que la FK real rechace
  /// el borrado.
  Future<bool> tieneItemsAsociados(int id) async {
    final fila = await (_database.select(
      _database.pedidoItemTable,
    )..where((t) => t.productoId.equals(id))).getSingleOrNull();
    return fila != null;
  }

  Producto _aDominio(ProductoTableData fila) => Producto(
        id: fila.id,
        nombre: fila.nombre,
        categoria: CategoriaProducto.desdeDb(fila.categoria),
        peso: fila.peso,
        volumen: fila.volumen,
        valorUnitario: fila.valorUnitario,
        metodoFijacionPrecio: fila.metodoFijacionPrecio,
        etapaCicloVida: fila.etapaCicloVida == null
            ? null
            : EtapaCicloVida.desdeDb(fila.etapaCicloVida!),
      );
}
