class PedidoItem {
  final int? id;
  final int pedidoId;
  final int productoId;
  final int cantidad;
  final double precioAplicado; // snapshot del precio al momento del pedido

  const PedidoItem({
    this.id,
    required this.pedidoId,
    required this.productoId,
    required this.cantidad,
    required this.precioAplicado,
  });

  double get subtotal => cantidad * precioAplicado;

  PedidoItem copyWith({
    int? id,
    int? pedidoId,
    int? productoId,
    int? cantidad,
    double? precioAplicado,
  }) {
    return PedidoItem(
      id: id ?? this.id,
      pedidoId: pedidoId ?? this.pedidoId,
      productoId: productoId ?? this.productoId,
      cantidad: cantidad ?? this.cantidad,
      precioAplicado: precioAplicado ?? this.precioAplicado,
    );
  }
}
