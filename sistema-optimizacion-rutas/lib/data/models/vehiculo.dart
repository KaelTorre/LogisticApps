class Vehiculo {
  final int? id;
  final String nombre;
  final double capacidadMaxima;
  final double? costoEstimadoPorKm;
  final String? tipoFlota;

  const Vehiculo({
    this.id,
    required this.nombre,
    required this.capacidadMaxima,
    this.costoEstimadoPorKm,
    this.tipoFlota,
  });

  Vehiculo copyWith({
    int? id,
    String? nombre,
    double? capacidadMaxima,
    double? costoEstimadoPorKm,
    String? tipoFlota,
  }) {
    return Vehiculo(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      capacidadMaxima: capacidadMaxima ?? this.capacidadMaxima,
      costoEstimadoPorKm: costoEstimadoPorKm ?? this.costoEstimadoPorKm,
      tipoFlota: tipoFlota ?? this.tipoFlota,
    );
  }
}
