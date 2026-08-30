/// Fila de trazabilidad: un valor visible en la interfaz, con la fórmula,
/// entradas y unidad que lo respaldan (CLAUDE.md sección 6).
class MemoriaCalculo {
  const MemoriaCalculo({
    this.id,
    required this.escenarioId,
    required this.orden,
    required this.modulo,
    required this.formula,
    required this.entradasJson,
    required this.salida,
    required this.unidad,
  });

  final int? id;
  final int escenarioId;
  final int orden; // paso
  final String modulo; // M1..M9
  final String formula; // legible por humano
  final String entradasJson; // JSON
  final String salida;
  final String unidad;
}
