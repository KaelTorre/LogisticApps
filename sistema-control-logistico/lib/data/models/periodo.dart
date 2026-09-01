class Periodo {
  const Periodo({
    this.id,
    required this.organizacionId,
    required this.orden,
    required this.etiqueta,
    required this.fechaInicio,
    required this.fechaFin,
    required this.granularidad,
    this.esSimulado = false,
  });

  final int? id;
  final int organizacionId;
  final int orden;
  final String etiqueta;
  final String fechaInicio;
  final String fechaFin;
  final String granularidad;
  final bool esSimulado;

  Periodo copyWith({
    int? id,
    int? organizacionId,
    int? orden,
    String? etiqueta,
    String? fechaInicio,
    String? fechaFin,
    String? granularidad,
    bool? esSimulado,
  }) {
    return Periodo(
      id: id ?? this.id,
      organizacionId: organizacionId ?? this.organizacionId,
      orden: orden ?? this.orden,
      etiqueta: etiqueta ?? this.etiqueta,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      granularidad: granularidad ?? this.granularidad,
      esSimulado: esSimulado ?? this.esSimulado,
    );
  }
}
