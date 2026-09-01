// M3 — Emparejador de acciones (CLAUDE.md sección 8). Función pura sobre
// el catálogo de mapeos `regla_accion` ya cargado por quien llama (el
// motor no toca base de datos): dado el indicador (categoría), las
// reglas que dispararon y la clasificación resultante, devuelve los ids
// de `accion_catalogo` candidatos, ordenados por prioridad y sin
// duplicados.

/// Espejo en memoria de una fila de `regla_accion`
/// (`lib/data/local/database.dart`).
class MapeoAccion {
  const MapeoAccion({
    required this.categoriaIndicador,
    required this.reglaDisparada,
    required this.clasificacion,
    required this.accionId,
    required this.prioridad,
  });

  final String categoriaIndicador;
  final String reglaDisparada;
  final String clasificacion;
  final int accionId;
  final int prioridad;
}

/// Devuelve los ids de `accion_catalogo` cuyo mapeo coincide con
/// [categoriaIndicador] + [clasificacion] + alguna de [reglasDisparadas],
/// ordenados por prioridad ascendente (1 = primera). Una misma acción
/// puede estar mapeada desde más de una regla disparada -- aparece una
/// sola vez, en la posición de su mejor prioridad.
List<int> emparejarAcciones({
  required String categoriaIndicador,
  required Set<String> reglasDisparadas,
  required String clasificacion,
  required List<MapeoAccion> catalogoMapeos,
}) {
  final candidatos =
      catalogoMapeos
          .where(
            (m) =>
                m.categoriaIndicador == categoriaIndicador &&
                m.clasificacion == clasificacion &&
                reglasDisparadas.contains(m.reglaDisparada),
          )
          .toList()
        ..sort((a, b) => a.prioridad.compareTo(b.prioridad));

  final vistos = <int>{};
  final resultado = <int>[];
  for (final mapeo in candidatos) {
    if (vistos.add(mapeo.accionId)) resultado.add(mapeo.accionId);
  }
  return resultado;
}
