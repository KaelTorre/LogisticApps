/// Una fila de trazabilidad todavía sin `escenarioId`/`orden` — los motores
/// (M4, M5, ...) no conocen el escenario que los va a guardar, ni en qué
/// paso quedan dentro de la ejecución completa; quien orquesta les asigna
/// ambos al persistir con `MemoriaCalculoRepository`.
class FilaMemoria {
  const FilaMemoria({
    required this.modulo,
    required this.formula,
    required this.entradasJson,
    required this.salida,
    required this.unidad,
  });

  final String modulo; // M1..M9
  final String formula;
  final String entradasJson;
  final String salida;
  final String unidad;
}
