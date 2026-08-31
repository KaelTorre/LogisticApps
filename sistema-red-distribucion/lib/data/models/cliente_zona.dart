/// Asignación cliente → zona, resultado de M1 (agregación, Fase 3). Fila
/// sin datos propios más allá del vínculo — se borra y se recalcula
/// completa cada vez que corre la agregación.
class ClienteZona {
  const ClienteZona({this.id, required this.clienteId, required this.zonaId});

  final int? id;
  final int clienteId;
  final int zonaId;
}
