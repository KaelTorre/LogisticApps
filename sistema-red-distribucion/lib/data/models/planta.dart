class Planta {
  const Planta({
    this.id,
    required this.proyectoId,
    required this.nombre,
    required this.latitud,
    required this.longitud,
    required this.capacidadAnual,
    required this.costoProduccionCentPorUnidad,
  });

  final int? id;
  final int proyectoId;
  final String nombre;
  final double latitud;
  final double longitud;
  final double capacidadAnual;
  final int costoProduccionCentPorUnidad;

  Planta copyWith({
    int? id,
    int? proyectoId,
    String? nombre,
    double? latitud,
    double? longitud,
    double? capacidadAnual,
    int? costoProduccionCentPorUnidad,
  }) {
    return Planta(
      id: id ?? this.id,
      proyectoId: proyectoId ?? this.proyectoId,
      nombre: nombre ?? this.nombre,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      capacidadAnual: capacidadAnual ?? this.capacidadAnual,
      costoProduccionCentPorUnidad:
          costoProduccionCentPorUnidad ?? this.costoProduccionCentPorUnidad,
    );
  }
}
