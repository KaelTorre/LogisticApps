import '../../core/constants.dart';
import '../models/cliente.dart';
import '../models/pedido_item.dart';
import '../models/producto.dart';
import '../repositories/cliente_repository.dart';
import '../repositories/pedido_repository.dart';
import '../repositories/producto_repository.dart';

/// Dataset de demo para la sustentación: 3 clientes, 12 productos con
/// valores variados (para que la regla 20/30/50 de M3 tenga sentido) y 7
/// pedidos en distintos estados, incluidos uno `entregado` completo (con
/// todo su historial, para que el TCP tenga datos) y uno `cancelado`.
///
/// Se dispara solo por acción explícita del usuario (botón en Home), nunca
/// automáticamente en `main()` — así el estado vacío real (CLAUDE.md §11)
/// sigue siendo demostrable si se quiere mostrar ese caso límite.
///
/// Devuelve `false` sin insertar nada si ya hay clientes o productos
/// registrados (no pisa datos que el usuario ya haya creado).
Future<bool> cargarDatasetEjemplo({
  required ClienteRepository clienteRepository,
  required ProductoRepository productoRepository,
  required PedidoRepository pedidoRepository,
}) async {
  final clientesExistentes = await clienteRepository.obtenerTodos();
  final productosExistentes = await productoRepository.obtenerTodos();
  if (clientesExistentes.isNotEmpty || productosExistentes.isNotEmpty) {
    return false;
  }

  final clientesIds = [
    for (final nombre in [
      'Distribuidora Andina S.A.C.',
      'Comercial Rímac E.I.R.L.',
      'Bodega San Martín',
    ])
      await clienteRepository.crear(Cliente(nombre: nombre)),
  ];

  const catalogo = [
    ('Arroz superior 5kg', CategoriaProducto.conveniencia, 18.50),
    ('Aceite vegetal 1L', CategoriaProducto.conveniencia, 9.90),
    ('Papel higiénico x12', CategoriaProducto.conveniencia, 22.90),
    ('Detergente en polvo 3kg', CategoriaProducto.seleccion, 24.00),
    ('Set de ollas x5', CategoriaProducto.seleccion, 189.00),
    ('Taladro percutor 700W', CategoriaProducto.seleccion, 245.00),
    ('Televisor LED 43"', CategoriaProducto.especializado, 899.00),
    ('Laptop 14" Core i5', CategoriaProducto.especializado, 2450.00),
    ('Refrigeradora 300L', CategoriaProducto.especializado, 1650.00),
    ('Motor eléctrico industrial 2HP', CategoriaProducto.industrial, 1200.00),
    ('Cemento Portland 42.5kg', CategoriaProducto.industrial, 32.50),
    ('Guantes de seguridad (par)', CategoriaProducto.industrial, 6.50),
  ];
  final productosIds = [
    for (final (nombre, categoria, precio) in catalogo)
      await productoRepository.crear(
        Producto(nombre: nombre, categoria: categoria, valorUnitario: precio),
      ),
  ];

  Future<int> crearPedido(int clienteIndice, List<(int, int)> itemsIndiceCantidad) {
    return pedidoRepository.crear(
      clienteId: clientesIds[clienteIndice],
      prioridad: 0,
      items: [
        for (final (indice, cantidad) in itemsIndiceCantidad)
          PedidoItem(
            pedidoId: 0,
            productoId: productosIds[indice],
            cantidad: cantidad,
            precioAplicado: catalogo[indice].$3,
          ),
      ],
    );
  }

  Future<void> avanzar(int pedidoId, int veces) async {
    for (var i = 0; i < veces; i++) {
      await pedidoRepository.avanzarEstado(pedidoId);
    }
  }

  // Entregado, con laptop y televisor: valor alto -> candidato a categoría A.
  final pedido1 = await crearPedido(0, [(7, 3), (6, 5)]);
  await avanzar(pedido1, 4);

  // Entregado, motor + cemento: también valor alto.
  final pedido2 = await crearPedido(1, [(9, 4), (10, 10)]);
  await avanzar(pedido2, 4);

  // Entregado, refrigeradora + taladro.
  final pedido3 = await crearPedido(2, [(8, 2), (5, 6)]);
  await avanzar(pedido3, 4);

  // En tránsito.
  final pedido4 = await crearPedido(0, [(4, 3), (3, 8)]);
  await avanzar(pedido4, 3);

  // Preparando envío.
  final pedido5 = await crearPedido(1, [(0, 30), (1, 20)]);
  await avanzar(pedido5, 2);

  // Recién recibido, sin avanzar.
  await crearPedido(2, [(2, 15), (11, 40)]);

  // Cancelado a mitad de camino.
  final pedido7 = await crearPedido(0, [(0, 5)]);
  await avanzar(pedido7, 1);
  await pedidoRepository.cancelar(pedido7);

  return true;
}
