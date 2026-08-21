import 'fila_memoria.dart';

/// CLAUDE.md sección 6/7: 3000mm es el mínimo, no una sugerencia — se
/// rechaza, no se ajusta en silencio (mismo criterio que las holguras de
/// racks en M3).
class EspaciamientoPuertaInvalidoException implements Exception {
  EspaciamientoPuertaInvalidoException(this.message);
  final String message;

  @override
  String toString() => 'EspaciamientoPuertaInvalidoException: $message';
}

/// Se lanza cuando ninguna cantidad de puertas dentro del rango de búsqueda
/// cumple ρ < rho_maximo y espera ≤ objetivo. CLAUDE.md sección 12: ningún
/// resultado sin mensaje explícito.
class PuertasInsuficientesException implements Exception {
  PuertasInsuficientesException(this.message);
  final String message;

  @override
  String toString() => 'PuertasInsuficientesException: $message';
}

class EntradaM7 {
  const EntradaM7({
    required this.camionesHoraPico,
    required this.tiempoMedioServicioHoras,
    required this.esperaObjetivoHoras,
    required this.espaciamientoPuertaMm,
    required this.patioMinMm,
    required this.areaStagingPorPuertaMm2,
    this.rhoMaximo = 0.85,
    this.puertasMaximasBusqueda = 50,
  });

  /// λ — camiones por hora en la **hora pico**, nunca el promedio diario
  /// (CLAUDE.md sección 7, M7: **[REGLA]**).
  final double camionesHoraPico;

  /// 1/μ.
  final double tiempoMedioServicioHoras;

  /// Wq máxima aceptable.
  final double esperaObjetivoHoras;
  final int espaciamientoPuertaMm;
  final int patioMinMm;
  final int areaStagingPorPuertaMm2;
  final double rhoMaximo;
  final int puertasMaximasBusqueda;
}

class ResultadoM7 {
  const ResultadoM7({
    required this.puertas,
    required this.rho,
    required this.esperaHoras,
    required this.frenteAndenMm,
    required this.patioProfundidadMm,
    required this.supPreparacionMm2,
    required this.memoria,
  });

  /// c — número de puertas de andén.
  final int puertas;
  final double rho;
  final double esperaHoras;
  final int frenteAndenMm;
  final int patioProfundidadMm;
  final int supPreparacionMm2;
  final List<FilaMemoria> memoria;
}

/// M7 — Andén y patio de maniobras (CLAUDE.md sección 7). Cola M/M/c sobre
/// las puertas, vía la fórmula de Erlang C. Función pura: sin acceso a base
/// de datos, sin estado.
ResultadoM7 calcularAnden(EntradaM7 e) {
  if (e.camionesHoraPico <= 0) {
    throw ArgumentError.value(e.camionesHoraPico, 'camionesHoraPico', 'Debe ser mayor que cero.');
  }
  if (e.tiempoMedioServicioHoras <= 0) {
    throw ArgumentError.value(
      e.tiempoMedioServicioHoras,
      'tiempoMedioServicioHoras',
      'Debe ser mayor que cero.',
    );
  }
  if (e.espaciamientoPuertaMm < 3000) {
    throw EspaciamientoPuertaInvalidoException(
      'espaciamiento_puerta_mm = ${e.espaciamientoPuertaMm} está por debajo '
      'del mínimo de 3000mm. No se ajusta en silencio: corrige el valor.',
    );
  }

  final mu = 1 / e.tiempoMedioServicioHoras;
  final a = e.camionesHoraPico / mu; // carga ofrecida, en Erlangs

  int? puertasElegidas;
  double rhoElegido = 0;
  double esperaElegida = 0;

  for (var c = 1; c <= e.puertasMaximasBusqueda; c++) {
    final rho = a / c;
    if (rho >= e.rhoMaximo) continue;

    final espera = _esperaEnColaHoras(a: a, c: c, rho: rho, tiempoMedioServicioHoras: e.tiempoMedioServicioHoras);
    if (espera <= e.esperaObjetivoHoras) {
      puertasElegidas = c;
      rhoElegido = rho;
      esperaElegida = espera;
      break;
    }
  }

  if (puertasElegidas == null) {
    throw PuertasInsuficientesException(
      'Ninguna cantidad de puertas hasta ${e.puertasMaximasBusqueda} cumple '
      'ρ < ${e.rhoMaximo} y espera ≤ ${e.esperaObjetivoHoras}h con '
      '${e.camionesHoraPico} camiones/hora pico. Revisa la demanda pico o '
      'el objetivo de espera.',
    );
  }

  final frenteAndenMm = puertasElegidas * e.espaciamientoPuertaMm;
  final supPreparacionMm2 = puertasElegidas * e.areaStagingPorPuertaMm2;

  final memoria = [
    FilaMemoria(
      orden: 1,
      modulo: 'M7',
      concepto: 'Menor número de puertas que cumple el objetivo',
      formula: 'buscar menor c tal que ρ = λ/(c·μ) < ${e.rhoMaximo} y Wq ≤ '
          '${e.esperaObjetivoHoras}h (Erlang C)',
      entradas: {
        'camiones_hora_pico': e.camionesHoraPico,
        'tiempo_medio_servicio_horas': e.tiempoMedioServicioHoras,
        'espera_objetivo_horas': e.esperaObjetivoHoras,
        'rho_maximo': e.rhoMaximo,
      },
      valor: '$puertasElegidas',
      unidad: 'puertas',
    ),
    FilaMemoria(
      orden: 2,
      modulo: 'M7',
      concepto: 'Utilización (ρ) y espera en cola (Wq)',
      formula: 'ρ = λ/(c·μ); Wq = P_espera(Erlang C) × tiempo_medio_servicio / (c·(1−ρ))',
      entradas: {'puertas': puertasElegidas, 'lambda': e.camionesHoraPico, 'mu': mu},
      valor: 'ρ=${rhoElegido.toStringAsFixed(3)}, Wq=${esperaElegida.toStringAsFixed(3)}',
      unidad: 'ρ adimensional, Wq en horas',
    ),
    FilaMemoria(
      orden: 3,
      modulo: 'M7',
      concepto: 'Frente de andén',
      formula: 'frente_anden = c × espaciamiento_puerta',
      entradas: {'puertas': puertasElegidas, 'espaciamiento_puerta_mm': e.espaciamientoPuertaMm},
      valor: '$frenteAndenMm',
      unidad: 'mm',
    ),
    FilaMemoria(
      orden: 4,
      modulo: 'M7',
      concepto: 'Profundidad de patio',
      formula: 'patio_profundidad = camion.patio_min_mm',
      entradas: {'patio_min_mm': e.patioMinMm},
      valor: '${e.patioMinMm}',
      unidad: 'mm',
      fuente: 'Catálogo de camiones, ver docs/fuentes_catalogo.md',
    ),
    FilaMemoria(
      orden: 5,
      modulo: 'M7',
      concepto: 'Superficie de preparación',
      formula: 'sup_preparacion = c × area_staging_por_puerta',
      entradas: {
        'puertas': puertasElegidas,
        'area_staging_por_puerta_mm2': e.areaStagingPorPuertaMm2,
      },
      valor: '$supPreparacionMm2',
      unidad: 'mm²',
    ),
  ];

  return ResultadoM7(
    puertas: puertasElegidas,
    rho: rhoElegido,
    esperaHoras: esperaElegida,
    frenteAndenMm: frenteAndenMm,
    patioProfundidadMm: e.patioMinMm,
    supPreparacionMm2: supPreparacionMm2,
    memoria: memoria,
  );
}

/// Wq de una cola M/M/c vía la fórmula de Erlang C.
double _esperaEnColaHoras({
  required double a,
  required int c,
  required double rho,
  required double tiempoMedioServicioHoras,
}) {
  final pEspera = _erlangC(a: a, c: c, rho: rho);
  return pEspera * tiempoMedioServicioHoras / (c * (1 - rho));
}

/// Probabilidad de que un camión que llega tenga que esperar (fórmula C de
/// Erlang), calculada con el algoritmo recursivo estándar para evitar
/// desbordes de `factorial`/`pow` con c grande.
double _erlangC({required double a, required int c, required double rho}) {
  var terminoN = 1.0; // a^0 / 0!
  var sumaTerminos = 1.0;
  for (var n = 1; n < c; n++) {
    terminoN *= a / n;
    sumaTerminos += terminoN;
  }
  final terminoC = terminoN * (a / c); // a^c / c!
  final numerador = terminoC / (1 - rho);
  final p0 = 1 / (sumaTerminos + numerador);
  return numerador * p0;
}
