class Escenario {
  const Escenario({
    this.id,
    required this.proyectoId,
    required this.nombre,
    required this.metodo,
    this.pFijo,
    this.restriccionCapacidadActiva = false,
    required this.costoTotalCent,
    required this.fecha,
    this.notas,
  });

  final int? id;
  final int proyectoId;
  final String nombre;
  final String metodo; // add | drop | intercambio | recocido | enumeracion
  final int? pFijo; // null = p libre (barrido)
  final bool restriccionCapacidadActiva;
  final int costoTotalCent;
  final String fecha; // DateTime.toIso8601String()
  final String? notas;
}
