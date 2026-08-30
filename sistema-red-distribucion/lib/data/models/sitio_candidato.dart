class SitioCandidato {
  const SitioCandidato({
    this.id,
    required this.proyectoId,
    required this.nombre,
    required this.latitud,
    required this.longitud,
    required this.costoFijoAnualCent,
    required this.capacidadAnual,
    required this.costoVariableManejoCentPorUnidad,
    required this.origen,
    this.esRedActual = false,
  });

  final int? id;
  final int proyectoId;
  final String nombre;
  final double latitud;
  final double longitud;
  final int costoFijoAnualCent;
  final double capacidadAnual;
  final int costoVariableManejoCentPorUnidad;
  final String origen; // manual | centro_gravedad
  final bool esRedActual;

  SitioCandidato copyWith({
    int? id,
    int? proyectoId,
    String? nombre,
    double? latitud,
    double? longitud,
    int? costoFijoAnualCent,
    double? capacidadAnual,
    int? costoVariableManejoCentPorUnidad,
    String? origen,
    bool? esRedActual,
  }) {
    return SitioCandidato(
      id: id ?? this.id,
      proyectoId: proyectoId ?? this.proyectoId,
      nombre: nombre ?? this.nombre,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      costoFijoAnualCent: costoFijoAnualCent ?? this.costoFijoAnualCent,
      capacidadAnual: capacidadAnual ?? this.capacidadAnual,
      costoVariableManejoCentPorUnidad:
          costoVariableManejoCentPorUnidad ??
          this.costoVariableManejoCentPorUnidad,
      origen: origen ?? this.origen,
      esRedActual: esRedActual ?? this.esRedActual,
    );
  }
}
