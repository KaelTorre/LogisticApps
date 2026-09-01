class Medicion {
  const Medicion({
    this.id,
    required this.indicadorId,
    required this.periodoId,
    required this.valor,
    required this.origen,
    this.nota,
  });

  final int? id;
  final int indicadorId;
  final int periodoId;
  final double valor;
  final String origen;
  final String? nota;

  Medicion copyWith({
    int? id,
    int? indicadorId,
    int? periodoId,
    double? valor,
    String? origen,
    String? nota,
  }) {
    return Medicion(
      id: id ?? this.id,
      indicadorId: indicadorId ?? this.indicadorId,
      periodoId: periodoId ?? this.periodoId,
      valor: valor ?? this.valor,
      origen: origen ?? this.origen,
      nota: nota ?? this.nota,
    );
  }
}
