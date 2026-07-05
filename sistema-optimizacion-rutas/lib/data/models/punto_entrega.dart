class PuntoEntrega {
  final int? id;
  final String nombre;
  final double latitud;
  final double longitud;
  final double demanda;
  final String? ventanaInicio;
  final String? ventanaFin;

  const PuntoEntrega({
    this.id,
    required this.nombre,
    required this.latitud,
    required this.longitud,
    this.demanda = 0,
    this.ventanaInicio,
    this.ventanaFin,
  });

  PuntoEntrega copyWith({
    int? id,
    String? nombre,
    double? latitud,
    double? longitud,
    double? demanda,
    String? ventanaInicio,
    String? ventanaFin,
  }) {
    return PuntoEntrega(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      demanda: demanda ?? this.demanda,
      ventanaInicio: ventanaInicio ?? this.ventanaInicio,
      ventanaFin: ventanaFin ?? this.ventanaFin,
    );
  }
}
