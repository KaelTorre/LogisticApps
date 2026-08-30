import '../../data/models/parametros_costo.dart';

/// Todo lo que M9 necesita de **un** escenario ya calculado (persistido o
/// sintetizado en memoria, ej. "la red actual" en la Pantalla 12) — sin
/// depender de cómo se obtuvo, para poder comparar un `Escenario` real
/// contra una red actual que nunca se guardó como tal.
class EscenarioDatos {
  const EscenarioDatos({
    required this.costoTotalCent,
    required this.porRubro,
    required this.almacenesAbiertos,
    required this.asignacionZonaCandidato,
    required this.distanciaZonaAsignada,
  });

  final int costoTotalCent;
  final Map<String, int> porRubro;
  final Set<int> almacenesAbiertos;
  final Map<int, int> asignacionZonaCandidato; // zonaId -> sitioCandidatoId
  final Map<int, (int distanciaMetros, int duracionSegundos)> distanciaZonaAsignada; // zonaId -> su celda
}

class ResultadoComparacion {
  const ResultadoComparacion({
    required this.diferenciaPorRubro,
    required this.ahorroAnualCent,
    required this.almacenesQueAbren,
    required this.almacenesQueCierran,
    required this.zonasQueCambianAsignacion,
    required this.zonasNoCubiertasBase,
    required this.zonasNoCubiertasComparado,
  });

  /// `comparado.rubro − base.rubro` (negativo = el rubro bajó).
  final Map<String, int> diferenciaPorRubro;

  /// `base.costoTotal − comparado.costoTotal` (positivo = comparado ahorra).
  final int ahorroAnualCent;

  final Set<int> almacenesQueAbren; // en comparado, no en base
  final Set<int> almacenesQueCierran; // en base, no en comparado
  final Set<int> zonasQueCambianAsignacion;
  final int zonasNoCubiertasBase;
  final int zonasNoCubiertasComparado;
}

/// M9 — comparador de escenarios (CLAUDE.md sección 7): diferencia de
/// costo por rubro, almacenes que se abren/cierran, zonas que cambian de
/// asignación, ahorro anual y variación del cumplimiento del estándar de
/// servicio entre `base` (ej. la red actual, o un escenario anterior) y
/// `comparado` (ej. el escenario optimizado).
ResultadoComparacion compararEscenarios({
  required EscenarioDatos base,
  required EscenarioDatos comparado,
  required ParametrosCosto params,
}) {
  final rubros = {...base.porRubro.keys, ...comparado.porRubro.keys};
  final diferenciaPorRubro = {
    for (final rubro in rubros) rubro: (comparado.porRubro[rubro] ?? 0) - (base.porRubro[rubro] ?? 0),
  };

  final zonasQueCambian = <int>{};
  for (final zonaId in {...base.asignacionZonaCandidato.keys, ...comparado.asignacionZonaCandidato.keys}) {
    if (base.asignacionZonaCandidato[zonaId] != comparado.asignacionZonaCandidato[zonaId]) {
      zonasQueCambian.add(zonaId);
    }
  }

  int contarNoCubiertas(EscenarioDatos escenario) {
    var contador = 0;
    for (final celda in escenario.distanciaZonaAsignada.values) {
      final valor = params.tipoEstandar == 'distancia' ? celda.$1 : celda.$2;
      if (valor > params.estandarServicioValor) contador++;
    }
    return contador;
  }

  return ResultadoComparacion(
    diferenciaPorRubro: diferenciaPorRubro,
    ahorroAnualCent: base.costoTotalCent - comparado.costoTotalCent,
    almacenesQueAbren: comparado.almacenesAbiertos.difference(base.almacenesAbiertos),
    almacenesQueCierran: base.almacenesAbiertos.difference(comparado.almacenesAbiertos),
    zonasQueCambianAsignacion: zonasQueCambian,
    zonasNoCubiertasBase: contarNoCubiertas(base),
    zonasNoCubiertasComparado: contarNoCubiertas(comparado),
  );
}
