class Evaluacion {
  const Evaluacion({
    this.id,
    required this.indicadorId,
    required this.periodoId,
    required this.estado,
    required this.clasificacion,
    required this.reglasDisparadasJson,
    required this.severidadCalculada,
  });

  final int? id;
  final int indicadorId;
  final int periodoId;
  final String estado;
  final String clasificacion;
  final String reglasDisparadasJson;
  final double severidadCalculada;

  Evaluacion copyWith({
    int? id,
    int? indicadorId,
    int? periodoId,
    String? estado,
    String? clasificacion,
    String? reglasDisparadasJson,
    double? severidadCalculada,
  }) {
    return Evaluacion(
      id: id ?? this.id,
      indicadorId: indicadorId ?? this.indicadorId,
      periodoId: periodoId ?? this.periodoId,
      estado: estado ?? this.estado,
      clasificacion: clasificacion ?? this.clasificacion,
      reglasDisparadasJson: reglasDisparadasJson ?? this.reglasDisparadasJson,
      severidadCalculada: severidadCalculada ?? this.severidadCalculada,
    );
  }
}
