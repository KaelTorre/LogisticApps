class VerificacionAccion {
  const VerificacionAccion({
    this.id,
    required this.accionTomadaId,
    required this.periodoVerificacionId,
    required this.resultado,
    required this.valorObservado,
    this.comentario,
    this.confirmadoPorUsuario = false,
  });

  final int? id;
  final int accionTomadaId;
  final int periodoVerificacionId;
  final String resultado;
  final double valorObservado;
  final String? comentario;
  final bool confirmadoPorUsuario;

  VerificacionAccion copyWith({
    int? id,
    int? accionTomadaId,
    int? periodoVerificacionId,
    String? resultado,
    double? valorObservado,
    String? comentario,
    bool? confirmadoPorUsuario,
  }) {
    return VerificacionAccion(
      id: id ?? this.id,
      accionTomadaId: accionTomadaId ?? this.accionTomadaId,
      periodoVerificacionId: periodoVerificacionId ?? this.periodoVerificacionId,
      resultado: resultado ?? this.resultado,
      valorObservado: valorObservado ?? this.valorObservado,
      comentario: comentario ?? this.comentario,
      confirmadoPorUsuario: confirmadoPorUsuario ?? this.confirmadoPorUsuario,
    );
  }
}
