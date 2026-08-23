import 'fila_memoria.dart';

/// Se lanza cuando una holgura pedida está por debajo del mínimo de la
/// norma seleccionada. CLAUDE.md sección 6.3: **[REGLA]** el motor debe
/// rechazar, no ajustar en silencio.
class HolguraInvalidaException implements Exception {
  HolguraInvalidaException(this.message);
  final String message;

  @override
  String toString() => 'HolguraInvalidaException: $message';
}

/// Se lanza cuando la altura útil o el equipo no alcanzan ni para un nivel.
/// CLAUDE.md sección 12: "Ningún resultado... con `niveles = 0` sin mensaje
/// explícito" — esto es ese mensaje explícito, no un resultado silencioso.
class NivelesInsuficientesException implements Exception {
  NivelesInsuficientesException(this.message);
  final String message;

  @override
  String toString() => 'NivelesInsuficientesException: $message';
}

/// Se lanza cuando el largo disponible no alcanza ni para un módulo por fila.
class LayoutInvalidoException implements Exception {
  LayoutInvalidoException(this.message);
  final String message;

  @override
  String toString() => 'LayoutInvalidoException: $message';
}

/// `largo_viga_min = n × ancho_tarima + (n + 1) × holgura_x` — verificación
/// inversa de CLAUDE.md sección 7 M3 paso 1, para proponer una viga desde la
/// tarima en vez de partir de un catálogo de vigas ya fijo.
int calcularLargoVigaMinimo({
  required int tarimasPorNivel,
  required int anchoTarimaMm,
  required int holguraXMm,
}) {
  return tarimasPorNivel * anchoTarimaMm + (tarimasPorNivel + 1) * holguraXMm;
}

/// `fondo_bastidor = fondo_tarima − 2 × voladizo` — CLAUDE.md sección 6.2.
/// Válido para rack selectivo. El resultado exacto rara vez coincide con un
/// fondo comercial: normalmente se redondea al fondo de catálogo más
/// cercano con [seleccionarBastidorComercial].
int calcularFondoBastidor({required int fondoTarimaMm, required int voladizoMm}) {
  return fondoTarimaMm - 2 * voladizoMm;
}

/// De una lista de fondos comerciales disponibles, elige el más cercano al
/// fondo calculado por [calcularFondoBastidor]. Por ejemplo, para una
/// tarima GMA (fondo 1219mm, voladizo 75mm) el cálculo exacto da 1069mm,
/// pero el bastidor comercial más cercano es el de 1067mm (42″) — de ahí el
/// "≈" del caso dorado de CLAUDE.md sección 12.
int seleccionarBastidorComercial(int fondoCalculadoMm, List<int> fondosComercialesMm) {
  if (fondosComercialesMm.isEmpty) {
    throw ArgumentError('No hay fondos comerciales para elegir.');
  }
  return fondosComercialesMm.reduce(
    (mejor, candidato) =>
        (candidato - fondoCalculadoMm).abs() < (mejor - fondoCalculadoMm).abs() ? candidato : mejor,
  );
}

int _redondearAlAlza(int valor, int multiplo) {
  if (multiplo <= 0) return valor;
  final resto = valor % multiplo;
  return resto == 0 ? valor : valor + (multiplo - resto);
}

class EntradaM3 {
  const EntradaM3({
    required this.posicionesRequeridas,
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
    this.factorFondo = 1,
  });

  final int posicionesRequeridas;
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

  /// 50mm en norma métrica, 2″ en imperial (CLAUDE.md sección 7, M3 paso 2).
  final int pasoAjustePuntalMm;
  final int alturaLibreMm;
  final int reservaTechoMm;
  final int elevacionMaxEquipoMm;
  final int largoDisponibleMm;

  /// 1 selectivo, 2 doble fondo, k drive-in/push-back.
  final int factorFondo;
}

class ResultadoM3 {
  const ResultadoM3({
    required this.tarimasPorNivel,
    required this.pasoNivelMm,
    required this.niveles,
    required this.posicionesModulo,
    required this.modulos,
    required this.modulosPorFila,
    required this.filas,
    required this.posicionesInstaladas,
    required this.supAlmacenamientoMm2,
    required this.memoria,
  });

  final int tarimasPorNivel;
  final int pasoNivelMm;
  final int niveles;
  final int posicionesModulo;
  final int modulos;
  final int modulosPorFila;
  final int filas;
  final int posicionesInstaladas;

  /// Solo la huella de los racks (`sup_racks` del pseudocódigo). La
  /// superficie construida completa (+ pasillos + zonas + circulación) se
  /// arma en la Fase 2 con el generador de layout, que decide el patrón de
  /// pasillos — M3 por sí solo no tiene con qué calcularla todavía.
  final int supAlmacenamientoMm2;

  final List<FilaMemoria> memoria;
}

/// M3 — Posiciones → superficie (CLAUDE.md sección 7). El corazón del
/// sistema. Función pura: sin acceso a base de datos, sin estado.
ResultadoM3 calcularSuperficie(EntradaM3 e) {
  if (e.posicionesRequeridas <= 0) {
    throw ArgumentError.value(e.posicionesRequeridas, 'posicionesRequeridas', 'Debe ser mayor que cero.');
  }
  if (e.holguraXMm < e.holguraXMinimaNormaMm) {
    throw HolguraInvalidaException(
      'holgura_x_mm = ${e.holguraXMm} está por debajo del mínimo normativo '
      '(${e.holguraXMinimaNormaMm}mm). No se ajusta en silencio: corrige la '
      'holgura o cambia de norma.',
    );
  }
  if (e.holguraYMm < e.holguraYMinimaNormaMm) {
    throw HolguraInvalidaException(
      'holgura_y_mm = ${e.holguraYMm} está por debajo del mínimo normativo '
      '(${e.holguraYMinimaNormaMm}mm). No se ajusta en silencio: corrige la '
      'holgura o cambia de norma.',
    );
  }

  final memoria = <FilaMemoria>[];
  var orden = 1;

  // 1. Tarimas por nivel
  final claroUtil = e.largoVigaMm - 2 * e.holguraXMm;
  final tarimasPorNivel = ((claroUtil + e.holguraXMm) / (e.anchoTarimaMm + e.holguraXMm)).floor();
  memoria.add(
    FilaMemoria(
      orden: orden++,
      modulo: 'M3',
      concepto: 'Tarimas por nivel',
      formula: 'Tarimas por nivel = redondeo hacia abajo de '
          '((Claro útil + Holgura X) ÷ (Ancho de tarima + Holgura X))',
      entradas: {
        'Largo de viga': e.largoVigaMm,
        'Holgura X': e.holguraXMm,
        'Ancho de tarima': e.anchoTarimaMm,
      },
      valor: '$tarimasPorNivel',
      unidad: 'tarimas/nivel',
    ),
  );
  if (tarimasPorNivel <= 0) {
    throw LayoutInvalidoException(
      'La viga de ${e.largoVigaMm}mm con holgura ${e.holguraXMm}mm no alcanza '
      'para ni una tarima de ${e.anchoTarimaMm}mm de ancho.',
    );
  }

  // 2. Paso de nivel
  final pasoSinRedondear = e.altoTarimaMm + e.altoCargaMm + e.holguraYMm + e.peralteVigaMm;
  final pasoNivelMm = _redondearAlAlza(pasoSinRedondear, e.pasoAjustePuntalMm);
  memoria.add(
    FilaMemoria(
      orden: orden++,
      modulo: 'M3',
      concepto: 'Paso de nivel',
      formula:
          'Paso de nivel = (Alto de tarima + Alto de carga + Holgura Y + '
          'Peralte de viga), redondeado hacia arriba al paso de ajuste del puntal',
      entradas: {
        'Alto de tarima': e.altoTarimaMm,
        'Alto de carga': e.altoCargaMm,
        'Holgura Y': e.holguraYMm,
        'Peralte de viga': e.peralteVigaMm,
        'Paso de ajuste del puntal': e.pasoAjustePuntalMm,
      },
      valor: '$pasoNivelMm',
      unidad: 'mm',
    ),
  );

  // 3. Niveles — el equipo limita.
  final alturaUtil = e.alturaLibreMm - e.reservaTechoMm;
  final nivelesPorAltura = (alturaUtil / pasoNivelMm).floor();
  final nivelesPorEquipo = (e.elevacionMaxEquipoMm / pasoNivelMm).floor();
  final niveles = nivelesPorAltura < nivelesPorEquipo ? nivelesPorAltura : nivelesPorEquipo;
  final equipoEsRestriccionActiva = nivelesPorEquipo < nivelesPorAltura;
  memoria.add(
    FilaMemoria(
      orden: orden++,
      modulo: 'M3',
      concepto: 'Niveles',
      formula: 'Niveles = el menor entre '
          '(redondeo hacia abajo de (Altura libre − Reserva de techo) ÷ Paso de nivel) y '
          '(redondeo hacia abajo de Elevación máxima del equipo ÷ Paso de nivel)'
          '${equipoEsRestriccionActiva ? " — el EQUIPO es la restricción activa, no la altura del edificio" : ""}',
      entradas: {
        'Altura libre': e.alturaLibreMm,
        'Reserva de techo': e.reservaTechoMm,
        'Elevación máxima del equipo': e.elevacionMaxEquipoMm,
        'Paso de nivel': pasoNivelMm,
        'Niveles según la altura del edificio': nivelesPorAltura,
        'Niveles según el equipo': nivelesPorEquipo,
      },
      valor: '$niveles',
      unidad: 'niveles',
    ),
  );
  if (niveles <= 0) {
    throw NivelesInsuficientesException(
      'Con altura útil de $alturaUtil mm y paso de nivel de $pasoNivelMm mm '
      'no cabe ni un nivel de racks (niveles calculados: $niveles).',
    );
  }

  // 4. Capacidad del módulo
  final posicionesModulo = tarimasPorNivel * niveles * e.factorFondo;
  memoria.add(
    FilaMemoria(
      orden: orden++,
      modulo: 'M3',
      concepto: 'Capacidad del módulo',
      formula: 'Posiciones por módulo = Tarimas por nivel × Niveles × Factor de fondo',
      entradas: {
        'Tarimas por nivel': tarimasPorNivel,
        'Niveles': niveles,
        'Factor de fondo': e.factorFondo,
      },
      valor: '$posicionesModulo',
      unidad: 'posiciones',
    ),
  );

  // 5. Módulos y filas
  final modulos = (e.posicionesRequeridas / posicionesModulo).ceil();
  final modulosPorFila = (e.largoDisponibleMm / (e.largoVigaMm + e.perfilAnchoBastidorMm)).floor();
  if (modulosPorFila <= 0) {
    throw LayoutInvalidoException(
      'El largo disponible (${e.largoDisponibleMm}mm) no alcanza ni para un '
      'módulo de ${e.largoVigaMm + e.perfilAnchoBastidorMm}mm por fila.',
    );
  }
  final filas = (modulos / modulosPorFila).ceil();
  memoria.add(
    FilaMemoria(
      orden: orden++,
      modulo: 'M3',
      concepto: 'Módulos y filas',
      formula: 'Módulos = redondeo hacia arriba de (Posiciones requeridas ÷ Posiciones por módulo); '
          'Módulos por fila = redondeo hacia abajo de (Largo disponible ÷ (Largo de viga + Perfil ancho del bastidor)); '
          'Filas = redondeo hacia arriba de (Módulos ÷ Módulos por fila)',
      entradas: {
        'Posiciones requeridas': e.posicionesRequeridas,
        'Posiciones por módulo': posicionesModulo,
        'Largo disponible': e.largoDisponibleMm,
        'Largo de viga': e.largoVigaMm,
        'Perfil ancho del bastidor': e.perfilAnchoBastidorMm,
      },
      valor: '$modulos módulos, $modulosPorFila por fila, $filas filas',
      unidad: 'módulos/filas',
    ),
  );

  final posicionesInstaladas = filas * modulosPorFila * posicionesModulo;

  // 6. Superficie — solo sup_racks. Pasillos/zonas: Fase 2.
  final supAlmacenamientoMm2 =
      filas * modulosPorFila * (e.largoVigaMm + e.perfilAnchoBastidorMm) * e.fondoBastidorMm;
  memoria.add(
    FilaMemoria(
      orden: orden++,
      modulo: 'M3',
      concepto: 'Superficie de almacenamiento (huella de racks)',
      formula: 'Superficie de racks = Filas × Módulos por fila × '
          '(Largo de viga + Perfil ancho del bastidor) × Fondo de bastidor',
      entradas: {
        'Filas': filas,
        'Módulos por fila': modulosPorFila,
        'Largo de viga': e.largoVigaMm,
        'Perfil ancho del bastidor': e.perfilAnchoBastidorMm,
        'Fondo de bastidor': e.fondoBastidorMm,
      },
      valor: '$supAlmacenamientoMm2',
      unidad: 'mm²',
    ),
  );

  return ResultadoM3(
    tarimasPorNivel: tarimasPorNivel,
    pasoNivelMm: pasoNivelMm,
    niveles: niveles,
    posicionesModulo: posicionesModulo,
    modulos: modulos,
    modulosPorFila: modulosPorFila,
    filas: filas,
    posicionesInstaladas: posicionesInstaladas,
    supAlmacenamientoMm2: supAlmacenamientoMm2,
    memoria: memoria,
  );
}
