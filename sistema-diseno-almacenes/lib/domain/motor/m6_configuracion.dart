import '../geometria/generador_layout.dart';
import 'fila_memoria.dart';

/// U (recepción y despacho comparten lado, congestiona), pasante (flujo
/// limpio, duplica fachada de andén), L. CLAUDE.md sección 7, M6.
enum PatronFlujo { u, pasante, l }

extension on PatronFlujo {
  String get codigo => switch (this) {
    PatronFlujo.u => 'U',
    PatronFlujo.pasante => 'pasante',
    PatronFlujo.l => 'L',
  };
}

class ConfiguracionCandidata {
  const ConfiguracionCandidata({
    required this.filas,
    required this.modulosPorFila,
    required this.patronFlujo,
    required this.layout,
    required this.distanciaEsperadaMm,
  });

  final int filas;
  final int modulosPorFila;
  final PatronFlujo patronFlujo;
  final ResultadoLayout layout;
  final int distanciaEsperadaMm;
}

class ResultadoM6 {
  const ResultadoM6({required this.configuraciones, required this.memoria});

  /// Ordenadas por distancia esperada ascendente (CLAUDE.md sección 7,
  /// M6: "la salida debe ser una tabla... no un dibujo").
  final List<ConfiguracionCandidata> configuraciones;
  final List<FilaMemoria> memoria;
}

/// M6 — Configuración de la instalación (CLAUDE.md sección 7).
///
/// Barre relaciones largo/ancho candidatas entre 1:1 y 3:1 repartiendo
/// `modulos` en distintas combinaciones (filas × módulos por fila), y para
/// cada geometría válida evalúa los 3 patrones de flujo por distancia
/// esperada de recorrido. **No evalúa "costo de manejo anual"** en dinero:
/// eso requeriría movimientos/día y costo por viaje que ningún módulo
/// anterior calcula todavía — se deja pendiente en vez de inventar un
/// multiplicador. Con distribución uniforme entre filas (CLAUDE.md: "sin
/// perfil ABC, uniforme" — M2 no calcula clases A/B/C todavía).
///
/// Función pura: sin acceso a base de datos, sin estado.
ResultadoM6 evaluarConfiguraciones({
  required int modulos,
  required int largoVigaMm,
  required int perfilAnchoBastidorMm,
  required int fondoBastidorMm,
  required int anchoPasilloMm,
  required int separacionEspaldaMm,
  required int holguraMuroMm,
  double relacionMaxima = 3.0,
}) {
  if (modulos <= 0) {
    throw ArgumentError.value(modulos, 'modulos', 'Debe ser mayor que cero.');
  }

  final candidatos = <ConfiguracionCandidata>[];

  for (var filas = 1; filas <= modulos; filas++) {
    final modulosPorFila = (modulos / filas).ceil();
    final layout = generarLayout(
      filas: filas,
      modulosPorFila: modulosPorFila,
      largoVigaMm: largoVigaMm,
      perfilAnchoBastidorMm: perfilAnchoBastidorMm,
      fondoBastidorMm: fondoBastidorMm,
      anchoPasilloMm: anchoPasilloMm,
      separacionEspaldaMm: separacionEspaldaMm,
      holguraMuroMm: holguraMuroMm,
    );

    final ladoLargo = layout.anchoTotalMm > layout.largoTotalMm
        ? layout.anchoTotalMm
        : layout.largoTotalMm;
    final ladoCorto = layout.anchoTotalMm > layout.largoTotalMm
        ? layout.largoTotalMm
        : layout.anchoTotalMm;
    final relacion = ladoLargo / ladoCorto;
    if (relacion > relacionMaxima) continue;

    for (final patron in PatronFlujo.values) {
      candidatos.add(
        ConfiguracionCandidata(
          filas: filas,
          modulosPorFila: modulosPorFila,
          patronFlujo: patron,
          layout: layout,
          distanciaEsperadaMm: _distanciaEsperadaMm(layout, patron),
        ),
      );
    }
  }

  if (candidatos.isEmpty) {
    throw ArgumentError(
      'Ninguna combinación de filas/módulos por fila da una relación '
      'largo/ancho ≤ $relacionMaxima:1 para $modulos módulos.',
    );
  }

  candidatos.sort((a, b) => a.distanciaEsperadaMm.compareTo(b.distanciaEsperadaMm));

  final memoria = [
    FilaMemoria(
      orden: 1,
      modulo: 'M6',
      concepto: 'Barrido de configuraciones',
      formula: 'Se prueba cada número de filas posible (Módulos por fila = '
          'redondeo hacia arriba de Módulos ÷ Filas) y se descartan las '
          'combinaciones cuya relación largo/ancho supere $relacionMaxima:1',
      entradas: {'Módulos': modulos, 'Relación largo/ancho máxima permitida': relacionMaxima},
      valor: '${candidatos.length ~/ PatronFlujo.values.length} geometrías × ${PatronFlujo.values.length} patrones de flujo',
      unidad: 'configuraciones',
    ),
    FilaMemoria(
      orden: 2,
      modulo: 'M6',
      concepto: 'Mejor configuración por distancia esperada',
      formula:
          'Distancia esperada = suma, para cada fila, de la probabilidad de '
          'visitarla × la distancia de ida y vuelta al punto de origen del '
          'patrón de flujo (probabilidad de visita uniforme entre filas, '
          'sin perfil ABC)',
      entradas: {
        'Filas': candidatos.first.filas,
        'Módulos por fila': candidatos.first.modulosPorFila,
        'Patrón de flujo': candidatos.first.patronFlujo.codigo,
      },
      valor: '${candidatos.first.distanciaEsperadaMm}',
      unidad: 'mm',
      fuente: 'No incluye costo de manejo anual: requiere movimientos/día y costo '
          'por viaje que ningún módulo anterior calcula todavía',
    ),
  ];

  return ResultadoM6(configuraciones: candidatos, memoria: memoria);
}

int _distanciaEsperadaMm(ResultadoLayout layout, PatronFlujo patron) {
  final filasRack = layout.rectangulos.where((r) => r.tipo == 'reserva').toList();
  final probabilidad = 1 / filasRack.length;

  final (double, double) origenRecepcion = (layout.anchoTotalMm / 2, 0.0);
  final (double, double) origenDespacho = (layout.anchoTotalMm / 2, layout.largoTotalMm.toDouble());
  final (double, double) origenEsquina = (0.0, 0.0);

  var acumulado = 0.0;
  for (final rect in filasRack) {
    final centroX = rect.xMm + rect.anchoMm / 2;
    final centroY = rect.yMm + rect.largoMm / 2;

    final distancia = switch (patron) {
      PatronFlujo.u => _rectilinea(centroX, centroY, origenRecepcion),
      PatronFlujo.l => _rectilinea(centroX, centroY, origenEsquina),
      // Pasante: recepción y despacho en lados opuestos: cada ubicación
      // viaja al más cercano de los dos (CLAUDE.md: "duplica fachada de
      // andén" -- el flujo se reparte entre ambos frentes).
      PatronFlujo.pasante => [
        _rectilinea(centroX, centroY, origenRecepcion),
        _rectilinea(centroX, centroY, origenDespacho),
      ].reduce((a, b) => a < b ? a : b),
    };

    acumulado += probabilidad * distancia * 2;
  }
  return acumulado.round();
}

double _rectilinea(double x, double y, (double, double) origen) {
  return (x - origen.$1).abs() + (y - origen.$2).abs();
}
