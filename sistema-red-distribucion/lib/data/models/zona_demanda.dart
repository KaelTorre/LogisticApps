class ZonaDemanda {
  const ZonaDemanda({
    this.id,
    required this.proyectoId,
    required this.etiqueta,
    required this.latitud,
    required this.longitud,
    required this.demandaAgregada,
    required this.pedidosAgregados,
    required this.numeroClientes,
    required this.errorAgregacionMetros,
  });

  final int? id;
  final int proyectoId;
  final String etiqueta;
  final double latitud; // centroide ponderado
  final double longitud;
  final double demandaAgregada;
  final int pedidosAgregados;
  final int numeroClientes;
  final int errorAgregacionMetros;

  ZonaDemanda copyWith({
    int? id,
    int? proyectoId,
    String? etiqueta,
    double? latitud,
    double? longitud,
    double? demandaAgregada,
    int? pedidosAgregados,
    int? numeroClientes,
    int? errorAgregacionMetros,
  }) {
    return ZonaDemanda(
      id: id ?? this.id,
      proyectoId: proyectoId ?? this.proyectoId,
      etiqueta: etiqueta ?? this.etiqueta,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      demandaAgregada: demandaAgregada ?? this.demandaAgregada,
      pedidosAgregados: pedidosAgregados ?? this.pedidosAgregados,
      numeroClientes: numeroClientes ?? this.numeroClientes,
      errorAgregacionMetros:
          errorAgregacionMetros ?? this.errorAgregacionMetros,
    );
  }
}
