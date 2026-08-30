class EscenarioAlmacen {
  const EscenarioAlmacen({
    this.id,
    required this.escenarioId,
    required this.sitioCandidatoId,
    required this.volumenAsignado,
    required this.costoFijoCent,
    required this.costoManejoCent,
  });

  final int? id;
  final int escenarioId;
  final int sitioCandidatoId;
  final double volumenAsignado;
  final int costoFijoCent;
  final int costoManejoCent;
}
