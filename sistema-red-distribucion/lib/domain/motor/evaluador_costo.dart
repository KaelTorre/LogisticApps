import '../../data/models/celda_matriz.dart';
import '../../data/models/parametros_costo.dart';
import '../../data/models/planta.dart';
import '../../data/models/sitio_candidato.dart';
import '../../data/models/zona_demanda.dart';
import 'm4_costo_total.dart';
import 'm5_asignacion.dart';

/// Empaqueta todos los datos que M5 (asignación) y M4 (costo) necesitan
/// para evaluar **una configuración candidata** (un subconjunto de sitios
/// abiertos) — M6 (Fase 6) llama esto cientos o miles de veces por
/// búsqueda, así que todo se carga una sola vez en memoria antes de
/// empezar (CLAUDE.md sección 10, `[REGLA]`: "ninguna consulta a drift
/// dentro de un bucle de optimización").
class EvaluadorCosto {
  const EvaluadorCosto({
    required this.zonas,
    required this.candidatosPorId,
    required this.plantas,
    required this.distanciaZonaCandidato,
    required this.distanciaPlantaCandidato,
    required this.params,
    required this.conRestriccionCapacidad,
  });

  final List<ZonaDemanda> zonas;
  final Map<int, SitioCandidato> candidatosPorId;
  final List<Planta> plantas;
  final Map<(int, int), CeldaMatriz> distanciaZonaCandidato;
  final Map<(int, int), CeldaMatriz> distanciaPlantaCandidato;
  final ParametrosCosto params;
  final bool conRestriccionCapacidad;

  /// Costo total (M4) de abrir exactamente `abiertos`, asignando zonas con
  /// M5 primero. Un conjunto vacío no es una red válida — se evalúa como
  /// [costoInfinito] para que ninguna búsqueda lo prefiera nunca.
  int costoDe(Set<int> abiertos) {
    if (abiertos.isEmpty) return costoInfinito;

    final lista = abiertos.toList();
    final asignacion = asignarZonas(
      abiertos: lista,
      zonas: zonas,
      candidatosPorId: candidatosPorId,
      distanciaZonaCandidato: distanciaZonaCandidato,
      params: params,
      conRestriccionCapacidad: conRestriccionCapacidad,
    );

    final costo = calcularCostoTotal(
      abiertos: lista,
      candidatosPorId: candidatosPorId,
      plantas: plantas,
      zonas: zonas,
      asignacionZonaCandidato: asignacion.asignacion,
      distanciaZonaCandidato: distanciaZonaCandidato,
      distanciaPlantaCandidato: distanciaPlantaCandidato,
      params: params,
    );

    return costo.costoTotalCent;
  }
}

/// Centinela para "esta configuración no es válida" (conjunto vacío) — más
/// grande que cualquier costo real posible en céntimos dentro del alcance
/// de este proyecto, para que las comparaciones `<` de las heurísticas
/// nunca lo prefieran.
const int costoInfinito = 1 << 62;
