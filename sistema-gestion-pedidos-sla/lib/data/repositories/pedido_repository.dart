import 'package:drift/drift.dart';

import '../../core/constants.dart';
import '../local/database.dart';
import '../models/historial_estado.dart';
import '../models/pedido.dart';
import '../models/pedido_item.dart';

class TransicionEstadoInvalida implements Exception {
  final String mensaje;
  const TransicionEstadoInvalida(this.mensaje);
  @override
  String toString() => mensaje;
}

class PedidoSinItems implements Exception {
  const PedidoSinItems();
  @override
  String toString() => 'El pedido debe tener al menos un producto.';
}

class PedidoRepository {
  PedidoRepository(this._database);

  final AppDatabase _database;

  Future<List<Pedido>> obtenerTodos() async {
    final filas = await _database.select(_database.pedidoTable).get();
    return filas.map(_pedidoADominio).toList();
  }

  Future<List<Pedido>> obtenerPorEstado(EstadoPedido estado) async {
    final filas = await (_database.select(
      _database.pedidoTable,
    )..where((t) => t.estadoActual.equals(estado.valorDb))).get();
    return filas.map(_pedidoADominio).toList();
  }

  Future<List<Pedido>> obtenerPorCliente(int clienteId) async {
    final filas = await (_database.select(
      _database.pedidoTable,
    )..where((t) => t.clienteId.equals(clienteId))).get();
    return filas.map(_pedidoADominio).toList();
  }

  Future<Pedido?> obtenerPorId(int id) async {
    final fila = await (_database.select(
      _database.pedidoTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return fila == null ? null : _pedidoADominio(fila);
  }

  Future<List<PedidoItem>> obtenerItems(int pedidoId) async {
    final filas = await (_database.select(
      _database.pedidoItemTable,
    )..where((t) => t.pedidoId.equals(pedidoId))).get();
    return filas.map(_itemADominio).toList();
  }

  Future<List<HistorialEstado>> obtenerHistorial(int pedidoId) async {
    final filas = await (_database.select(_database.historialEstadoTable)
          ..where((t) => t.pedidoId.equals(pedidoId))
          ..orderBy([(t) => OrderingTerm.asc(t.timestamp)]))
        .get();
    return filas.map(_historialADominio).toList();
  }

  /// Crea el pedido, sus items y la primera fila de `historial_estado`
  /// (`recibido`) en una única transacción — este es el punto de partida
  /// del TCP (CLAUDE.md §6.1).
  Future<int> crear({
    required int clienteId,
    required int prioridad,
    required List<PedidoItem> items,
  }) async {
    if (items.isEmpty) throw const PedidoSinItems();

    return _database.transaction(() async {
      final ahora = DateTime.now();
      final pedidoId = await _database.into(_database.pedidoTable).insert(
            PedidoTableCompanion.insert(
              clienteId: clienteId,
              fechaCreacion: ahora.toIso8601String(),
              estadoActual: EstadoPedido.recibido.valorDb,
              prioridad: Value(prioridad),
            ),
          );

      for (final item in items) {
        await _database.into(_database.pedidoItemTable).insert(
              PedidoItemTableCompanion.insert(
                pedidoId: pedidoId,
                productoId: item.productoId,
                cantidad: item.cantidad,
                precioAplicado: item.precioAplicado,
              ),
            );
      }

      await _database.into(_database.historialEstadoTable).insert(
            HistorialEstadoTableCompanion.insert(
              pedidoId: pedidoId,
              estado: EstadoPedido.recibido.valorDb,
              timestamp: ahora.toIso8601String(),
            ),
          );

      return pedidoId;
    });
  }

  /// Avanza el pedido al siguiente estado de la secuencia normal. Rechaza
  /// la operación si el pedido ya está en un estado terminal
  /// (`entregado`/`cancelado`) — se valida acá, a nivel de repositorio, no
  /// solo en la UI.
  Future<void> avanzarEstado(int pedidoId) async {
    await _database.transaction(() async {
      final pedido = await _obtenerPedidoOFallar(pedidoId);
      final actual = EstadoPedido.desdeDb(pedido.estadoActual);
      final siguiente = actual.siguienteEstado;
      if (siguiente == null) {
        throw TransicionEstadoInvalida(
          'El pedido ya está en estado "${actual.etiqueta}" y no se puede avanzar.',
        );
      }
      await _registrarTransicion(pedidoId, siguiente);
    });
  }

  /// Marca el pedido como `cancelado`. Alcanzable desde cualquier estado
  /// excepto `entregado` (CLAUDE.md §5.2).
  Future<void> cancelar(int pedidoId) async {
    await _database.transaction(() async {
      final pedido = await _obtenerPedidoOFallar(pedidoId);
      final actual = EstadoPedido.desdeDb(pedido.estadoActual);
      if (!actual.puedeCancelar) {
        throw TransicionEstadoInvalida(
          'Un pedido "${actual.etiqueta}" ya no se puede cancelar.',
        );
      }
      await _registrarTransicion(pedidoId, EstadoPedido.cancelado);
    });
  }

  Future<void> _registrarTransicion(
    int pedidoId,
    EstadoPedido nuevoEstado,
  ) async {
    final ahora = DateTime.now();
    await _database.into(_database.historialEstadoTable).insert(
          HistorialEstadoTableCompanion.insert(
            pedidoId: pedidoId,
            estado: nuevoEstado.valorDb,
            timestamp: ahora.toIso8601String(),
          ),
        );
    await (_database.update(
      _database.pedidoTable,
    )..where((t) => t.id.equals(pedidoId))).write(
      PedidoTableCompanion(estadoActual: Value(nuevoEstado.valorDb)),
    );
  }

  Future<PedidoTableData> _obtenerPedidoOFallar(int pedidoId) async {
    final fila = await (_database.select(
      _database.pedidoTable,
    )..where((t) => t.id.equals(pedidoId))).getSingleOrNull();
    if (fila == null) {
      throw TransicionEstadoInvalida('El pedido $pedidoId no existe.');
    }
    return fila;
  }

  /// Valor total generado por producto (Σ cantidad × precio_aplicado de
  /// todos sus items en todos los pedidos), insumo del módulo M3 (ABC).
  Future<Map<int, double>> valorTotalGeneradoPorProducto() async {
    final filas = await _database.select(_database.pedidoItemTable).get();
    final totales = <int, double>{};
    for (final fila in filas) {
      totales.update(
        fila.productoId,
        (valor) => valor + fila.cantidad * fila.precioAplicado,
        ifAbsent: () => fila.cantidad * fila.precioAplicado,
      );
    }
    return totales;
  }

  Pedido _pedidoADominio(PedidoTableData fila) => Pedido(
        id: fila.id,
        clienteId: fila.clienteId,
        fechaCreacion: DateTime.parse(fila.fechaCreacion),
        estadoActual: EstadoPedido.desdeDb(fila.estadoActual),
        prioridad: fila.prioridad,
      );

  PedidoItem _itemADominio(PedidoItemTableData fila) => PedidoItem(
        id: fila.id,
        pedidoId: fila.pedidoId,
        productoId: fila.productoId,
        cantidad: fila.cantidad,
        precioAplicado: fila.precioAplicado,
      );

  HistorialEstado _historialADominio(HistorialEstadoTableData fila) =>
      HistorialEstado(
        id: fila.id,
        pedidoId: fila.pedidoId,
        estado: EstadoPedido.desdeDb(fila.estado),
        timestamp: DateTime.parse(fila.timestamp),
        nota: fila.nota,
      );
}
