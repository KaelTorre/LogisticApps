class DiagnosticoOrganizacional {
  const DiagnosticoOrganizacional({
    this.id,
    required this.organizacionId,
    required this.fecha,
    required this.respuestasJson,
    required this.etapaResultante,
    required this.opcionOrganizacional,
    required this.ejesJson,
    required this.orientacionDominante,
  });

  final int? id;
  final int organizacionId;
  final String fecha;
  final String respuestasJson;
  final String etapaResultante;
  final String opcionOrganizacional;
  final String ejesJson;
  final String orientacionDominante;

  DiagnosticoOrganizacional copyWith({
    int? id,
    int? organizacionId,
    String? fecha,
    String? respuestasJson,
    String? etapaResultante,
    String? opcionOrganizacional,
    String? ejesJson,
    String? orientacionDominante,
  }) {
    return DiagnosticoOrganizacional(
      id: id ?? this.id,
      organizacionId: organizacionId ?? this.organizacionId,
      fecha: fecha ?? this.fecha,
      respuestasJson: respuestasJson ?? this.respuestasJson,
      etapaResultante: etapaResultante ?? this.etapaResultante,
      opcionOrganizacional: opcionOrganizacional ?? this.opcionOrganizacional,
      ejesJson: ejesJson ?? this.ejesJson,
      orientacionDominante: orientacionDominante ?? this.orientacionDominante,
    );
  }
}
