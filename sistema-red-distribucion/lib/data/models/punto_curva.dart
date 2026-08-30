class PuntoCurva {
  const PuntoCurva({
    this.id,
    required this.escenarioId,
    required this.numeroAlmacenes,
    required this.costoTotalCent,
    required this.costoPorRubroJson,
    required this.viableSegunServicio,
  });

  final int? id;
  final int escenarioId; // escenario padre del barrido
  final int numeroAlmacenes;
  final int costoTotalCent;
  final String costoPorRubroJson; // JSON: {rubro: centavos}
  final bool viableSegunServicio;
}
