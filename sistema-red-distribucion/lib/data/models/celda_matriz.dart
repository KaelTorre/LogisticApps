class CeldaMatriz {
  const CeldaMatriz({
    this.id,
    required this.proyectoId,
    required this.tipoOrigen,
    required this.origenId,
    required this.tipoDestino,
    required this.destinoId,
    required this.distanciaMetros,
    required this.duracionSegundos,
    required this.fuente,
  });

  final int? id;
  final int proyectoId;
  final String tipoOrigen; // planta | candidato
  final int origenId;
  final String tipoDestino; // candidato | zona
  final int destinoId;
  final int distanciaMetros;
  final int duracionSegundos;
  final String fuente; // osrm | haversine
}
