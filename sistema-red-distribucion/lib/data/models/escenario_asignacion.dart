class EscenarioAsignacion {
  const EscenarioAsignacion({
    this.id,
    required this.escenarioId,
    required this.zonaId,
    required this.sitioCandidatoId,
    required this.distanciaMetros,
    required this.duracionSegundos,
    required this.costoSalidaCent,
  });

  final int? id;
  final int escenarioId;
  final int zonaId;
  final int sitioCandidatoId;
  final int distanciaMetros;
  final int duracionSegundos;
  final int costoSalidaCent;
}
