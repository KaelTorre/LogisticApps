import '../../core/constants.dart';

class Pedido {
  final int? id;
  final int clienteId;
  final DateTime fechaCreacion;
  final EstadoPedido estadoActual;
  final int prioridad;

  const Pedido({
    this.id,
    required this.clienteId,
    required this.fechaCreacion,
    required this.estadoActual,
    this.prioridad = 0,
  });

  Pedido copyWith({
    int? id,
    int? clienteId,
    DateTime? fechaCreacion,
    EstadoPedido? estadoActual,
    int? prioridad,
  }) {
    return Pedido(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      estadoActual: estadoActual ?? this.estadoActual,
      prioridad: prioridad ?? this.prioridad,
    );
  }
}
