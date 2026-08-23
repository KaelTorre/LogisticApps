import 'fila_memoria.dart';
import 'tarifa_publica.dart';

enum EscenarioConstruccion { todoAhora, porEtapas, basePublico }

extension on EscenarioConstruccion {
  String get nombre => switch (this) {
    EscenarioConstruccion.todoAhora => 'Todo ahora',
    EscenarioConstruccion.porEtapas => 'Por etapas',
    EscenarioConstruccion.basePublico => 'Base + público',
  };
}

class PuntoCostoAnio {
  const PuntoCostoAnio({required this.anio, required this.costo, required this.costoDescontado});

  final int anio;
  final double costo;
  final double costoDescontado;
}

class ResultadoEscenario {
  const ResultadoEscenario({
    required this.escenario,
    required this.costoPresenteTotal,
    required this.curvaCostoAcumulado,
  });

  final EscenarioConstruccion escenario;

  /// Suma de todos los costos descontados a valor presente — el criterio de
  /// comparación (CLAUDE.md sección 7, M5: "evaluación por valor presente
  /// neto").
  final double costoPresenteTotal;
  final List<PuntoCostoAnio> curvaCostoAcumulado;
}

class ResultadoM5 {
  const ResultadoM5({
    required this.mejorEscenario,
    required this.escenarios,
    required this.demandaPorAnio,
    required this.memoria,
  });

  final EscenarioConstruccion mejorEscenario;

  /// Ordenados por costo presente ascendente.
  final List<ResultadoEscenario> escenarios;
  final List<int> demandaPorAnio;
  final List<FilaMemoria> memoria;
}

/// M5 — Dimensionamiento con tendencia (CLAUDE.md sección 7). Demanda
/// creciente sobre el horizonte: compara construir todo ahora, por etapas,
/// o solo la base y desbordar siempre a público, por valor presente de
/// costos (tasa de descuento del proyecto).
///
/// La trayectoria de demanda se deriva de un crecimiento compuesto simple
/// (`demandaInicial × (1+tasaCrecimiento)^año`) — el pronóstico real (M1,
/// suavización/Holt/Winters) es de la Fase 7; hasta entonces esta es la
/// aproximación declarada, no un pronóstico estadístico.
///
/// El "costo de obra mayor por etapa, más disrupción operativa" de la
/// construcción por etapas se modela como un multiplicador sobre el costo
/// de construir la capacidad adicional en la segunda fase — CLAUDE.md no
/// da una fórmula exacta para ese premium, así que queda como parámetro
/// explícito, no un número inventado y escondido.
///
/// Función pura: sin acceso a base de datos, sin estado.
ResultadoM5 calcularDimensionamientoConTendencia({
  required int demandaInicial,
  required double tasaCrecimientoAnual,
  required int horizonteAnios,
  required double costoConstruccionPorPosicion,
  required double costoAnualPropioPorPosicion,
  required TarifaPublica tarifaPublica,
  required double tasaDescuentoAnual,
  required int anioEtapa,
  double factorPremiumExpansion = 1.3,
}) {
  if (demandaInicial <= 0) {
    throw ArgumentError.value(demandaInicial, 'demandaInicial', 'Debe ser mayor que cero.');
  }
  if (horizonteAnios <= 1) {
    throw ArgumentError.value(horizonteAnios, 'horizonteAnios', 'Debe ser mayor que 1.');
  }
  if (anioEtapa <= 0 || anioEtapa >= horizonteAnios) {
    throw ArgumentError.value(
      anioEtapa,
      'anioEtapa',
      'Debe estar entre 1 y ${horizonteAnios - 1} (el horizonte de '
          '$horizonteAnios años, menos 1).',
    );
  }
  if (tasaDescuentoAnual < 0) {
    throw ArgumentError.value(tasaDescuentoAnual, 'tasaDescuentoAnual', 'No puede ser negativa.');
  }

  final demandaPorAnio = [
    for (var anio = 1; anio <= horizonteAnios; anio++)
      // -1e-6 antes de ceil(): el crecimiento compuesto en punto flotante
      // puede dar 110.00000000000001 en vez de 110 exacto, y sin esta
      // tolerancia ceil() lo empuja a 111 — una posición de más que nadie
      // pidió.
      (demandaInicial * pow1p(tasaCrecimientoAnual, anio - 1) - 1e-6).ceil(),
  ];
  final capacidadFinal = demandaPorAnio.last;

  double descontar(double valor, int anio) => valor / _potencia(1 + tasaDescuentoAnual, anio);

  ResultadoEscenario evaluarTodoAhora() {
    final curva = <PuntoCostoAnio>[
      PuntoCostoAnio(anio: 0, costo: costoConstruccionPorPosicion * capacidadFinal, costoDescontado: costoConstruccionPorPosicion * capacidadFinal),
    ];
    for (var anio = 1; anio <= horizonteAnios; anio++) {
      final costo = costoAnualPropioPorPosicion * capacidadFinal;
      curva.add(PuntoCostoAnio(anio: anio, costo: costo, costoDescontado: descontar(costo, anio)));
    }
    return ResultadoEscenario(
      escenario: EscenarioConstruccion.todoAhora,
      costoPresenteTotal: curva.fold(0, (acc, p) => acc + p.costoDescontado),
      curvaCostoAcumulado: curva,
    );
  }

  ResultadoEscenario evaluarPorEtapas() {
    final capacidadEtapa1 = demandaPorAnio[anioEtapa - 1];
    final curva = <PuntoCostoAnio>[
      PuntoCostoAnio(anio: 0, costo: costoConstruccionPorPosicion * capacidadEtapa1, costoDescontado: costoConstruccionPorPosicion * capacidadEtapa1),
    ];
    for (var anio = 1; anio <= horizonteAnios; anio++) {
      final capacidadDelAnio = anio < anioEtapa ? capacidadEtapa1 : capacidadFinal;
      var costo = costoAnualPropioPorPosicion * capacidadDelAnio;
      if (anio == anioEtapa) {
        costo +=
            costoConstruccionPorPosicion * (capacidadFinal - capacidadEtapa1) * factorPremiumExpansion;
      }
      curva.add(PuntoCostoAnio(anio: anio, costo: costo, costoDescontado: descontar(costo, anio)));
    }
    return ResultadoEscenario(
      escenario: EscenarioConstruccion.porEtapas,
      costoPresenteTotal: curva.fold(0, (acc, p) => acc + p.costoDescontado),
      curvaCostoAcumulado: curva,
    );
  }

  ResultadoEscenario evaluarBasePublico() {
    final capacidadBase = demandaPorAnio.first;
    final curva = <PuntoCostoAnio>[
      PuntoCostoAnio(anio: 0, costo: costoConstruccionPorPosicion * capacidadBase, costoDescontado: costoConstruccionPorPosicion * capacidadBase),
    ];
    for (var anio = 1; anio <= horizonteAnios; anio++) {
      final desborde = demandaPorAnio[anio - 1] - capacidadBase;
      // La tarifa pública está pensada por mes (M4); acá se asume que el
      // desborde de ese año se sostiene los 12 meses — simplificación
      // declarada, no un cálculo mensual real (eso pide una trayectoria
      // mensual completa por año, fuera de alcance de esta fase).
      final costoDesborde = desborde > 0 ? tarifaPublica.costoMensual(desborde) * 12 : 0.0;
      final costo = costoAnualPropioPorPosicion * capacidadBase + costoDesborde;
      curva.add(PuntoCostoAnio(anio: anio, costo: costo, costoDescontado: descontar(costo, anio)));
    }
    return ResultadoEscenario(
      escenario: EscenarioConstruccion.basePublico,
      costoPresenteTotal: curva.fold(0, (acc, p) => acc + p.costoDescontado),
      curvaCostoAcumulado: curva,
    );
  }

  final escenarios = [evaluarTodoAhora(), evaluarPorEtapas(), evaluarBasePublico()]
    ..sort((a, b) => a.costoPresenteTotal.compareTo(b.costoPresenteTotal));

  final memoria = [
    FilaMemoria(
      orden: 1,
      modulo: 'M5',
      concepto: 'Trayectoria de demanda',
      formula: 'demanda[año] = demanda_inicial × (1+tasa_crecimiento)^(año−1)',
      entradas: {
        'demanda_inicial': demandaInicial,
        'tasa_crecimiento_anual': tasaCrecimientoAnual,
        'horizonte_anios': horizonteAnios,
      },
      valor: demandaPorAnio.join(', '),
      unidad: 'posiciones/año',
    ),
    FilaMemoria(
      orden: 2,
      modulo: 'M5',
      concepto: 'Mejor escenario por valor presente de costos',
      formula: 'VPN(escenario) = Σ_año costo[año] / (1+tasa_descuento)^año; elegir el menor',
      entradas: {'tasa_descuento_anual': tasaDescuentoAnual},
      valor: '${escenarios.first.escenario.nombre} '
          '(VPN ${escenarios.first.costoPresenteTotal.toStringAsFixed(2)})',
      unidad: 'moneda del proyecto',
    ),
  ];

  return ResultadoM5(
    mejorEscenario: escenarios.first.escenario,
    escenarios: escenarios,
    demandaPorAnio: demandaPorAnio,
    memoria: memoria,
  );
}

double pow1p(double tasa, int exponente) => _potencia(1 + tasa, exponente);

double _potencia(double base, int exponente) {
  var resultado = 1.0;
  for (var i = 0; i < exponente; i++) {
    resultado *= base;
  }
  return resultado;
}
