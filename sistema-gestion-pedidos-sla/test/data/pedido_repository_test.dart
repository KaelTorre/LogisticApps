import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_gestion_pedidos_sla/core/constants.dart';
import 'package:sistema_gestion_pedidos_sla/data/local/database.dart';
import 'package:sistema_gestion_pedidos_sla/data/models/cliente.dart';
import 'package:sistema_gestion_pedidos_sla/data/models/pedido_item.dart';
import 'package:sistema_gestion_pedidos_sla/data/models/producto.dart';
import 'package:sistema_gestion_pedidos_sla/data/repositories/cliente_repository.dart';
import 'package:sistema_gestion_pedidos_sla/data/repositories/pedido_repository.dart';
import 'package:sistema_gestion_pedidos_sla/data/repositories/producto_repository.dart';

void main() {
  late AppDatabase database;
  late PedidoRepository pedidos;
  late int clienteId;
  late int productoId;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    pedidos = PedidoRepository(database);

    final clientes = ClienteRepository(database);
    final productos = ProductoRepository(database);
    clienteId = await clientes.crear(const Cliente(nombre: 'Cliente de prueba'));
    productoId = await productos.crear(
      const Producto(
        nombre: 'Producto de prueba',
        categoria: CategoriaProducto.conveniencia,
        valorUnitario: 10,
      ),
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('crear inserta el pedido, sus items y el primer historial_estado', () async {
    final pedidoId = await pedidos.crear(
      clienteId: clienteId,
      prioridad: 0,
      items: [
        PedidoItem(
          pedidoId: 0,
          productoId: productoId,
          cantidad: 2,
          precioAplicado: 10,
        ),
      ],
    );

    final pedido = await pedidos.obtenerPorId(pedidoId);
    final historial = await pedidos.obtenerHistorial(pedidoId);
    final items = await pedidos.obtenerItems(pedidoId);

    expect(pedido!.estadoActual, EstadoPedido.recibido);
    expect(historial, hasLength(1));
    expect(historial.first.estado, EstadoPedido.recibido);
    expect(items, hasLength(1));
    expect(items.first.cantidad, 2);
  });

  test('crear sin items lanza PedidoSinItems', () async {
    expect(
      () => pedidos.crear(clienteId: clienteId, prioridad: 0, items: []),
      throwsA(isA<PedidoSinItems>()),
    );
  });

  test('avanzarEstado recorre la secuencia e inserta historial en cada paso', () async {
    final pedidoId = await pedidos.crear(
      clienteId: clienteId,
      prioridad: 0,
      items: [
        PedidoItem(
          pedidoId: 0,
          productoId: productoId,
          cantidad: 1,
          precioAplicado: 10,
        ),
      ],
    );

    await pedidos.avanzarEstado(pedidoId); // -> procesando
    await pedidos.avanzarEstado(pedidoId); // -> preparando_envio
    await pedidos.avanzarEstado(pedidoId); // -> en_transito
    await pedidos.avanzarEstado(pedidoId); // -> entregado

    final pedido = await pedidos.obtenerPorId(pedidoId);
    final historial = await pedidos.obtenerHistorial(pedidoId);

    expect(pedido!.estadoActual, EstadoPedido.entregado);
    expect(historial, hasLength(5));
    expect(historial.last.estado, EstadoPedido.entregado);
  });

  test('avanzarEstado sobre un pedido ya entregado se rechaza a nivel de BD', () async {
    final pedidoId = await pedidos.crear(
      clienteId: clienteId,
      prioridad: 0,
      items: [
        PedidoItem(
          pedidoId: 0,
          productoId: productoId,
          cantidad: 1,
          precioAplicado: 10,
        ),
      ],
    );
    for (var i = 0; i < 4; i++) {
      await pedidos.avanzarEstado(pedidoId);
    }

    expect(
      () => pedidos.avanzarEstado(pedidoId),
      throwsA(isA<TransicionEstadoInvalida>()),
    );
  });

  test('cancelar es rechazado si el pedido ya fue entregado', () async {
    final pedidoId = await pedidos.crear(
      clienteId: clienteId,
      prioridad: 0,
      items: [
        PedidoItem(
          pedidoId: 0,
          productoId: productoId,
          cantidad: 1,
          precioAplicado: 10,
        ),
      ],
    );
    for (var i = 0; i < 4; i++) {
      await pedidos.avanzarEstado(pedidoId);
    }

    expect(
      () => pedidos.cancelar(pedidoId),
      throwsA(isA<TransicionEstadoInvalida>()),
    );
  });

  test('cancelar funciona desde un estado intermedio', () async {
    final pedidoId = await pedidos.crear(
      clienteId: clienteId,
      prioridad: 0,
      items: [
        PedidoItem(
          pedidoId: 0,
          productoId: productoId,
          cantidad: 1,
          precioAplicado: 10,
        ),
      ],
    );
    await pedidos.avanzarEstado(pedidoId);
    await pedidos.cancelar(pedidoId);

    final pedido = await pedidos.obtenerPorId(pedidoId);
    expect(pedido!.estadoActual, EstadoPedido.cancelado);
  });

  test('valorTotalGeneradoPorProducto agrega cantidad * precio de todos los pedidos', () async {
    await pedidos.crear(
      clienteId: clienteId,
      prioridad: 0,
      items: [
        PedidoItem(
          pedidoId: 0,
          productoId: productoId,
          cantidad: 3,
          precioAplicado: 10,
        ),
      ],
    );
    await pedidos.crear(
      clienteId: clienteId,
      prioridad: 0,
      items: [
        PedidoItem(
          pedidoId: 0,
          productoId: productoId,
          cantidad: 2,
          precioAplicado: 10,
        ),
      ],
    );

    final totales = await pedidos.valorTotalGeneradoPorProducto();

    expect(totales[productoId], 50);
  });
}
