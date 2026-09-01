class AccionTomada {
  const AccionTomada({
    this.id,
    required this.evaluacionId,
    required this.accionCatalogoId,
    required this.responsable,
    required this.fechaCompromiso,
    this.estado = 'abierta',
    this.notas,
    required this.fechaRegistro,
  });

  final int? id;
  final int evaluacionId;
  final int accionCatalogoId;
  final String responsable;
  final String fechaCompromiso;
  final String estado;
  final String? notas;
  final String fechaRegistro;

  AccionTomada copyWith({
    int? id,
    int? evaluacionId,
    int? accionCatalogoId,
    String? responsable,
    String? fechaCompromiso,
    String? estado,
    String? notas,
    String? fechaRegistro,
  }) {
    return AccionTomada(
      id: id ?? this.id,
      evaluacionId: evaluacionId ?? this.evaluacionId,
      accionCatalogoId: accionCatalogoId ?? this.accionCatalogoId,
      responsable: responsable ?? this.responsable,
      fechaCompromiso: fechaCompromiso ?? this.fechaCompromiso,
      estado: estado ?? this.estado,
      notas: notas ?? this.notas,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
    );
  }
}
