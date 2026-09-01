class MemoriaEvaluacion {
  const MemoriaEvaluacion({
    this.id,
    required this.evaluacionId,
    required this.reglaId,
    required this.resultado,
    required this.valoresEntradaJson,
    required this.explicacion,
  });

  final int? id;
  final int evaluacionId;
  final int reglaId;
  final String resultado;
  final String valoresEntradaJson;
  final String explicacion;

  MemoriaEvaluacion copyWith({
    int? id,
    int? evaluacionId,
    int? reglaId,
    String? resultado,
    String? valoresEntradaJson,
    String? explicacion,
  }) {
    return MemoriaEvaluacion(
      id: id ?? this.id,
      evaluacionId: evaluacionId ?? this.evaluacionId,
      reglaId: reglaId ?? this.reglaId,
      resultado: resultado ?? this.resultado,
      valoresEntradaJson: valoresEntradaJson ?? this.valoresEntradaJson,
      explicacion: explicacion ?? this.explicacion,
    );
  }
}
