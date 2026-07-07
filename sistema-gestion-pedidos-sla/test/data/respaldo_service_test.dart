import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_gestion_pedidos_sla/core/constants.dart';
import 'package:sistema_gestion_pedidos_sla/data/local/database.dart';
import 'package:sistema_gestion_pedidos_sla/data/local/respaldo_service.dart';
import 'package:sistema_gestion_pedidos_sla/data/models/cliente.dart';
import 'package:sistema_gestion_pedidos_sla/data/models/pedido_item.dart';
import 'package:sistema_gestion_pedidos_sla/data/models/producto.dart';
import 'package:sistema_gestion_pedidos_sla/data/repositories/cliente_repository.dart';
import 'package:sistema_gestion_pedidos_sla/data/repositories/pedido_repository.dart';
import 'package:sistema_gestion_pedidos_sla/data/repositories/producto_repository.dart';

void main() {
  test('export -> import round-trip reproduce los datos idénticos', () async {
    final origen = AppDatabase(NativeDatabase.memory());
    final clientesOrigen = ClienteRepository(origen);
    final productosOrigen = ProductoRepository(origen);
    final pedidosOrigen = PedidoRepository(origen);

    final clienteId = await clientesOrigen.crear(
      const Cliente(nombre: 'Cliente A', contacto: 'a@ejemplo.com'),
    );
    final productoId = await productosOrigen.crear(
      const Producto(
        nombre: 'Producto A',
        categoria: CategoriaProducto.industrial,
        valorUnitario: 25.5,
      ),
    );
    final pedidoId = await pedidosOrigen.crear(
      clienteId: clienteId,
      prioridad: 2,
      items: [
        PedidoItem(
          pedidoId: 0,
          productoId: productoId,
          cantidad: 4,
          precioAplicado: 25.5,
        ),
      ],
    );
    await pedidosOrigen.avanzarEstado(pedidoId);

    final json = await RespaldoService(origen).exportarComoJson();
    await origen.close();

    final destino = AppDatabase(NativeDatabase.memory());
    await RespaldoService(destino).importarDesdeJson(json);

    final clientesDestino = await ClienteRepository(destino).obtenerTodos();
    final productosDestino = await ProductoRepository(destino).obtenerTodos();
    final pedidosDestino = PedidoRepository(destino);
    final pedidoRestaurado = await pedidosDestino.obtenerPorId(pedidoId);
    final itemsRestaurados = await pedidosDestino.obtenerItems(pedidoId);
    final historialRestaurado = await pedidosDestino.obtenerHistorial(
      pedidoId,
    );

    expect(clientesDestino, hasLength(1));
    expect(clientesDestino.first.nombre, 'Cliente A');
    expect(clientesDestino.first.contacto, 'a@ejemplo.com');

    expect(productosDestino, hasLength(1));
    expect(productosDestino.first.nombre, 'Producto A');
    expect(productosDestino.first.valorUnitario, 25.5);

    expect(pedidoRestaurado, isNotNull);
    expect(pedidoRestaurado!.clienteId, clienteId);
    expect(pedidoRestaurado.prioridad, 2);
    expect(pedidoRestaurado.estadoActual, EstadoPedido.procesando);

    expect(itemsRestaurados, hasLength(1));
    expect(itemsRestaurados.first.cantidad, 4);
    expect(itemsRestaurados.first.productoId, productoId);

    expect(historialRestaurado, hasLength(2));
    expect(historialRestaurado.first.estado, EstadoPedido.recibido);
    expect(historialRestaurado.last.estado, EstadoPedido.procesando);

    await destino.close();
  });

  test('importar con versión no compatible lanza RespaldoInvalido', () async {
    final destino = AppDatabase(NativeDatabase.memory());

    expect(
      () => RespaldoService(
        destino,
      ).importarDesdeJson('{"version": 999, "cliente": []}'),
      throwsA(isA<RespaldoInvalido>()),
    );

    await destino.close();
  });

  test('importar un JSON inválido lanza RespaldoInvalido', () async {
    final destino = AppDatabase(NativeDatabase.memory());

    expect(
      () => RespaldoService(destino).importarDesdeJson('esto no es json'),
      throwsA(isA<RespaldoInvalido>()),
    );

    await destino.close();
  });
}
