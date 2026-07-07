import '../../core/constants.dart';

class HistorialEstado {
  final int? id;
  final int pedidoId;
  final EstadoPedido estado;
  final DateTime timestamp;
  final String? nota;

  const HistorialEstado({
    this.id,
    required this.pedidoId,
    required this.estado,
    required this.timestamp,
    this.nota,
  });

  HistorialEstado copyWith({
    int? id,
    int? pedidoId,
    EstadoPedido? estado,
    DateTime? timestamp,
    String? nota,
  }) {
    return HistorialEstado(
      id: id ?? this.id,
      pedidoId: pedidoId ?? this.pedidoId,
      estado: estado ?? this.estado,
      timestamp: timestamp ?? this.timestamp,
      nota: nota ?? this.nota,
    );
  }
}
