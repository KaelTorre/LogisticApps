import '../geometria/generador_layout.dart';
import 'fila_memoria.dart';
import 'm2_posiciones.dart';
import 'm3_superficie.dart';
import 'm6_configuracion.dart';
import 'm7_anden.dart';

/// Etiqueta de accesibilidad por tipo de sistema — CLAUDE.md sección 6.5.
/// **[REGLA]** el comparador debe mostrar siempre el costo de la densidad,
/// no solo la ganancia de posiciones: esta etiqueta va pegada a cada fila
/// del resultado, nunca se resume aparte del número de posiciones.
const accesibilidadPorTipoSistema = <String, String>{
  'selectivo': 'Total: cada tarima es accesible directamente.',
  'doble_fondo': 'Parcial: 2 posiciones de fondo, LIFO.',
  'push_back': 'Limitada: LIFO, 2 a 6 posiciones de fondo por canal.',
  'drive_in': 'Limitada: LIFO, canal completo por referencia.',
  'dinamico': 'Limitada: FIFO por gravedad, un canal por referencia.',
  'lanzadera': 'Limitada: según profundidad de canal, servida por lanzadera.',
};

/// Un escenario a comparar: la misma demanda del proyecto, resuelta con una
/// combinación distinta de sistema de racking, equipo y bastidor/viga
/// (CLAUDE.md sección 5, tabla `escenarios`).
class EntradaEscenarioM8 {
  const EntradaEscenarioM8({
    required this.nombre,
    required this.tipoSistema,
    required this.factorFondo,
    required this.factorHoneycomb,
    required this.anchoTarimaMm,
    required this.altoTarimaMm,
    required this.altoCargaMm,
    required this.largoVigaMm,
    required this.peralteVigaMm,
    required this.fondoBastidorMm,
    required this.perfilAnchoBastidorMm,
    required this.holguraXMm,
    required this.holguraXMinimaNormaMm,
    required this.holguraYMm,
    required this.holguraYMinimaNormaMm,
    required this.pasoAjustePuntalMm,
    required this.alturaLibreMm,
    required this.reservaTechoMm,
    required this.elevacionMaxEquipoMm,
    required this.largoDisponibleMm,
    required this.anchoPasilloMm,
    required this.separacionEspaldaMm,
    required this.holguraMuroMm,
    required this.costoConstruccionPorM2,
    required this.costoEquipos,
  });

  final String nombre;

  /// selectivo | doble_fondo | drive_in | push_back | dinamico | lanzadera
  /// (CLAUDE.md sección 5) — determina la etiqueta de accesibilidad, no
  /// afecta el cálculo geométrico directamente (eso lo hace factorFondo).
  final String tipoSistema;

  /// 1 selectivo, 2 doble fondo, k drive-in/push-back (CLAUDE.md sección 7 M3).
  final int factorFondo;
  final double factorHoneycomb;

  final int anchoTarimaMm;
  final int altoTarimaMm;
  final int altoCargaMm;
  final int largoVigaMm;
  final int peralteVigaMm;
  final int fondoBastidorMm;
  final int perfilAnchoBastidorMm;
  final int holguraXMm;
  final int holguraXMinimaNormaMm;
  final int holguraYMm;
  final int holguraYMinimaNormaMm;
  final int pasoAjustePuntalMm;
  final int alturaLibreMm;
  final int reservaTechoMm;
  final int elevacionMaxEquipoMm;
  final int largoDisponibleMm;

  /// Del equipo elegido para este escenario (CLAUDE.md sección 6.4).
  final int anchoPasilloMm;
  final int separacionEspaldaMm;
  final int holguraMuroMm;

  /// Moneda del proyecto por m² construido — capex de obra.
  final double costoConstruccionPorM2;

  /// Moneda del proyecto, costo total de la flota de equipo de este
  /// escenario (suma directa, no se deriva cantidad de equipos: eso
  /// requeriría un análisis de throughput que ningún módulo hace todavía).
  final double costoEquipos;
}

/// Los campos de [EntradaEscenarioM8] que la mayoría de escenarios de un
/// mismo proyecto comparten (misma tarima, mismo terreno, mismo equipo
/// base): evita repetir 20 campos por cada preset en la UI del comparador.
/// Solo lo que realmente distingue un escenario — sistema, factor de fondo,
/// honeycomb y costos — se pasa a [con].
class BaseEscenarioM8 {
  const BaseEscenarioM8({
    required this.anchoTarimaMm,
    required this.altoTarimaMm,
    required this.altoCargaMm,
    required this.largoVigaMm,
    required this.peralteVigaMm,
    required this.fondoBastidorMm,
    required this.perfilAnchoBastidorMm,
    required this.holguraXMm,
    required this.holguraXMinimaNormaMm,
    required this.holguraYMm,
    required this.holguraYMinimaNormaMm,
    required this.pasoAjustePuntalMm,
    required this.alturaLibreMm,
    required this.reservaTechoMm,
    required this.elevacionMaxEquipoMm,
    required this.largoDisponibleMm,
    required this.anchoPasilloMm,
    required this.separacionEspaldaMm,
    required this.holguraMuroMm,
  });

  final int anchoTarimaMm;
  final int altoTarimaMm;
  final int altoCargaMm;
  final int largoVigaMm;
  final int peralteVigaMm;
  final int fondoBastidorMm;
  final int perfilAnchoBastidorMm;
  final int holguraXMm;
  final int holguraXMinimaNormaMm;
  final int holguraYMm;
  final int holguraYMinimaNormaMm;
  final int pasoAjustePuntalMm;
  final int alturaLibreMm;
  final int reservaTechoMm;
  final int elevacionMaxEquipoMm;
  final int largoDisponibleMm;
  final int anchoPasilloMm;
  final int separacionEspaldaMm;
  final int holguraMuroMm;

  EntradaEscenarioM8 con({
    required String nombre,
    required String tipoSistema,
    required int factorFondo,
    required double factorHoneycomb,
    required double costoConstruccionPorM2,
    required double costoEquipos,
  }) {
    return EntradaEscenarioM8(
      nombre: nombre,
      tipoSistema: tipoSistema,
      factorFondo: factorFondo,
      factorHoneycomb: factorHoneycomb,
      costoConstruccionPorM2: costoConstruccionPorM2,
      costoEquipos: costoEquipos,
      anchoTarimaMm: anchoTarimaMm,
      altoTarimaMm: altoTarimaMm,
      altoCargaMm: altoCargaMm,
      largoVigaMm: largoVigaMm,
      peralteVigaMm: peralteVigaMm,
      fondoBastidorMm: fondoBastidorMm,
      perfilAnchoBastidorMm: perfilAnchoBastidorMm,
      holguraXMm: holguraXMm,
      holguraXMinimaNormaMm: holguraXMinimaNormaMm,
      holguraYMm: holguraYMm,
      holguraYMinimaNormaMm: holguraYMinimaNormaMm,
      pasoAjustePuntalMm: pasoAjustePuntalMm,
      alturaLibreMm: alturaLibreMm,
      reservaTechoMm: reservaTechoMm,
      elevacionMaxEquipoMm: elevacionMaxEquipoMm,
      largoDisponibleMm: largoDisponibleMm,
      anchoPasilloMm: anchoPasilloMm,
      separacionEspaldaMm: separacionEspaldaMm,
      holguraMuroMm: holguraMuroMm,
    );
  }
}

class ResultadoEscenarioM8 {
  const ResultadoEscenarioM8({
    required this.nombre,
    required this.tipoSistema,
    required this.posicionesInstaladas,
    required this.supConstruidaMm2,
    required this.relacionSuperficie,
    required this.distanciaEsperadaMm,
    required this.inversionEstimada,
    required this.costoPorPosicion,
    required this.accesibilidad,
    required this.resultadoM2,
    required this.resultadoM3,
    required this.layout,
    required this.resultadoM7,
    required this.memoria,
  });

  final String nombre;
  final String tipoSistema;
  final int posicionesInstaladas;
  final int supConstruidaMm2;
  final double relacionSuperficie;
  final int distanciaEsperadaMm;
  final double inversionEstimada;
  final double costoPorPosicion;

  /// CLAUDE.md sección 6.5 y 7 (M8): el costo oculto de la densidad, nunca
  /// se separa de las demás métricas al presentar el resultado.
  final String accesibilidad;

  final ResultadoM2 resultadoM2;
  final ResultadoM3 resultadoM3;
  final ResultadoLayout layout;
  final ResultadoM7 resultadoM7;
  final List<FilaMemoria> memoria;
}

class ResultadoM8 {
  const ResultadoM8({required this.escenarios, required this.memoria});

  /// Ordenados por costo por posición ascendente. El orden es solo una
  /// referencia de comparabilidad — la accesibilidad va en cada fila, así
  /// que ordenar por costo no puede esconder el costo de la densidad.
  final List<ResultadoEscenarioM8> escenarios;
  final List<FilaMemoria> memoria;
}

/// M8 — Comparador de escenarios (CLAUDE.md sección 7). Ejecuta M2 a M7
/// sobre cada escenario, con la misma demanda del proyecto y el mismo
/// perfil de andén, y tabula las métricas de la sección 7.
///
/// Función pura: sin acceso a base de datos, sin estado.
ResultadoM8 compararEscenarios({
  required List<DemandaFamilia> familias,
  required List<EntradaEscenarioM8> escenarios,
  required EntradaM7 entradaAnden,
  double relacionMaximaGeometria = 3.0,
}) {
  if (escenarios.isEmpty) {
    throw ArgumentError('M8 necesita al menos un escenario para comparar.');
  }

  final resultados = <ResultadoEscenarioM8>[];
  for (final esc in escenarios) {
    final resultadoM2 = calcularPosicionesRequeridas(
      familias: familias,
      factorHoneycomb: esc.factorHoneycomb,
    );

    final resultadoM3 = calcularSuperficie(
      EntradaM3(
        posicionesRequeridas: resultadoM2.posicionesRequeridas,
        anchoTarimaMm: esc.anchoTarimaMm,
        altoTarimaMm: esc.altoTarimaMm,
        altoCargaMm: esc.altoCargaMm,
        largoVigaMm: esc.largoVigaMm,
        peralteVigaMm: esc.peralteVigaMm,
        fondoBastidorMm: esc.fondoBastidorMm,
        perfilAnchoBastidorMm: esc.perfilAnchoBastidorMm,
        holguraXMm: esc.holguraXMm,
        holguraXMinimaNormaMm: esc.holguraXMinimaNormaMm,
        holguraYMm: esc.holguraYMm,
        holguraYMinimaNormaMm: esc.holguraYMinimaNormaMm,
        pasoAjustePuntalMm: esc.pasoAjustePuntalMm,
        alturaLibreMm: esc.alturaLibreMm,
        reservaTechoMm: esc.reservaTechoMm,
        elevacionMaxEquipoMm: esc.elevacionMaxEquipoMm,
        largoDisponibleMm: esc.largoDisponibleMm,
        factorFondo: esc.factorFondo,
      ),
    );

    final resultadoM6 = evaluarConfiguraciones(
      modulos: resultadoM3.modulos,
      largoVigaMm: esc.largoVigaMm,
      perfilAnchoBastidorMm: esc.perfilAnchoBastidorMm,
      fondoBastidorMm: esc.fondoBastidorMm,
      anchoPasilloMm: esc.anchoPasilloMm,
      separacionEspaldaMm: esc.separacionEspaldaMm,
      holguraMuroMm: esc.holguraMuroMm,
      relacionMaxima: relacionMaximaGeometria,
    );
    final mejorConfig = resultadoM6.configuraciones.first;
    final layout = mejorConfig.layout;

    final posicionesInstaladas =
        mejorConfig.filas * mejorConfig.modulosPorFila * resultadoM3.posicionesModulo;
    final relacionSuperficie = layout.supRacksMm2 / layout.supConstruidaMm2;

    final resultadoM7 = calcularAnden(entradaAnden);

    final supConstruidaM2 = layout.supConstruidaMm2 / 1000000;
    final inversionEstimada = supConstruidaM2 * esc.costoConstruccionPorM2 + esc.costoEquipos;
    final costoPorPosicion = inversionEstimada / posicionesInstaladas;
    final accesibilidad = accesibilidadPorTipoSistema[esc.tipoSistema] ??
        'Accesibilidad no documentada para "${esc.tipoSistema}".';

    final memoriaEscenario = [
      ...resultadoM2.memoria,
      ...resultadoM3.memoria,
      ...layout.memoria,
      ...resultadoM7.memoria,
      FilaMemoria(
        orden: 1,
        modulo: 'M8',
        concepto: 'Inversión estimada — ${esc.nombre}',
        formula: 'inversion = (sup_construida en m²) × costo_construccion_m2 + costo_equipos',
        entradas: {
          'sup_construida_m2': supConstruidaM2,
          'costo_construccion_por_m2': esc.costoConstruccionPorM2,
          'costo_equipos': esc.costoEquipos,
        },
        valor: inversionEstimada.toStringAsFixed(2),
        unidad: 'moneda del proyecto',
      ),
      FilaMemoria(
        orden: 2,
        modulo: 'M8',
        concepto: 'Accesibilidad — ${esc.nombre}',
        formula: 'etiqueta por tipo_sistema, CLAUDE.md sección 6.5',
        entradas: {'tipo_sistema': esc.tipoSistema},
        valor: accesibilidad,
        unidad: 'descripción',
        fuente: 'CLAUDE.md sección 6.5 — el costo de la densidad se declara siempre, no solo la ganancia',
      ),
    ];

    resultados.add(
      ResultadoEscenarioM8(
        nombre: esc.nombre,
        tipoSistema: esc.tipoSistema,
        posicionesInstaladas: posicionesInstaladas,
        supConstruidaMm2: layout.supConstruidaMm2,
        relacionSuperficie: relacionSuperficie,
        distanciaEsperadaMm: mejorConfig.distanciaEsperadaMm,
        inversionEstimada: inversionEstimada,
        costoPorPosicion: costoPorPosicion,
        accesibilidad: accesibilidad,
        resultadoM2: resultadoM2,
        resultadoM3: resultadoM3,
        layout: layout,
        resultadoM7: resultadoM7,
        memoria: memoriaEscenario,
      ),
    );
  }

  resultados.sort((a, b) => a.costoPorPosicion.compareTo(b.costoPorPosicion));

  final memoria = [
    FilaMemoria(
      orden: 1,
      modulo: 'M8',
      concepto: 'Escenarios comparados',
      formula: 'ejecutar M2 a M7 por cada escenario, misma demanda y perfil de andén',
      entradas: {'escenarios': resultados.map((r) => r.nombre).join(', ')},
      valor: '${resultados.length}',
      unidad: 'escenarios',
      fuente: 'CLAUDE.md sección 6.5 — mostrar siempre el costo de la densidad junto a la ganancia',
    ),
  ];

  return ResultadoM8(escenarios: resultados, memoria: memoria);
}
