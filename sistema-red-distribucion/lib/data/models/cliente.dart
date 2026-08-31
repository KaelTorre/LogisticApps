class Cliente {
  const Cliente({
    this.id,
    required this.proyectoId,
    required this.nombre,
    required this.latitud,
    required this.longitud,
    required this.demandaAnual,
    required this.pedidosAnuales,
    this.activo = true,
  });

  final int? id;
  final int proyectoId;
  final String nombre;
  final double latitud;
  final double longitud;
  final double demandaAnual;
  final int pedidosAnuales;
  final bool activo;

  Cliente copyWith({
    int? id,
    int? proyectoId,
    String? nombre,
    double? latitud,
    double? longitud,
    double? demandaAnual,
    int? pedidosAnuales,
    bool? activo,
  }) {
    return Cliente(
      id: id ?? this.id,
      proyectoId: proyectoId ?? this.proyectoId,
      nombre: nombre ?? this.nombre,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      demandaAnual: demandaAnual ?? this.demandaAnual,
      pedidosAnuales: pedidosAnuales ?? this.pedidosAnuales,
      activo: activo ?? this.activo,
    );
  }
}
