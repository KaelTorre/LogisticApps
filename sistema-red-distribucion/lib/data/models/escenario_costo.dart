class EscenarioCosto {
  const EscenarioCosto({
    this.id,
    required this.escenarioId,
    required this.rubro,
    required this.montoCent,
  });

  final int? id;
  final int escenarioId;
  // produccion | entrada | salida | fijo | manejo | inventario | pedidos
  final String rubro;
  final int montoCent;
}
