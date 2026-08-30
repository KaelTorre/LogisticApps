/// Tarifa de transporte (CLAUDE.md sección 7): componente fijo + variable
/// por distancia. Devuelve céntimos por unidad (tonelada, o la unidad de
/// peso que use el proyecto) — compartida por M4 (costo) y M5 (asignación),
/// que necesitan la misma fórmula para decidir y para valorizar.
double tarifaTransporte({
  required int distanciaMetros,
  required int tarifaFijaCent,
  required int tarifaCentPorKmTon,
}) {
  return tarifaFijaCent + tarifaCentPorKmTon * (distanciaMetros / 1000);
}
