class RutaResultado {
  final int? id;
  final int escenarioId;
  final int vehiculoId;
  final List<int> secuenciaParadas;
  final double? distanciaTotalKm;
  final double? tiempoTotalSegundos;
  final String? geometriaPolyline;

  const RutaResultado({
    this.id,
    required this.escenarioId,
    required this.vehiculoId,
    required this.secuenciaParadas,
    this.distanciaTotalKm,
    this.tiempoTotalSegundos,
    this.geometriaPolyline,
  });
}
