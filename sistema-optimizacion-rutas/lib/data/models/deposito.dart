class Deposito {
  final int? id;
  final String nombre;
  final double latitud;
  final double longitud;

  const Deposito({
    this.id,
    required this.nombre,
    required this.latitud,
    required this.longitud,
  });

  Deposito copyWith({
    int? id,
    String? nombre,
    double? latitud,
    double? longitud,
  }) {
    return Deposito(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
    );
  }
}
