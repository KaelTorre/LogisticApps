import '../motor/fila_memoria.dart';

/// Un rectángulo del plano, en mm, origen arriba-izquierda.
class Rectangulo {
  const Rectangulo({
    required this.xMm,
    required this.yMm,
    required this.anchoMm,
    required this.largoMm,
    required this.tipo,
  });

  final int xMm;
  final int yMm;
  final int anchoMm;

  /// Alto del rectángulo en el eje Y (profundidad), no "largo" en el
  /// sentido coloquial — se llama así para calzar con `zonas.largo_mm`
  /// de CLAUDE.md sección 5.
  final int largoMm;

  /// reserva (racks) | circulacion (pasillo). Vocabulario de `zonas.tipo`
  /// (CLAUDE.md sección 5) — no se inventan tipos nuevos.
  final String tipo;

  int get areaMm2 => anchoMm * largoMm;
}

class ResultadoLayout {
  const ResultadoLayout({
    required this.rectangulos,
    required this.anchoTotalMm,
    required this.largoTotalMm,
    required this.supRacksMm2,
    required this.supPasillosMm2,
    required this.supConstruidaMm2,
    required this.memoria,
  });

  final List<Rectangulo> rectangulos;
  final int anchoTotalMm;
  final int largoTotalMm;
  final int supRacksMm2;
  final int supPasillosMm2;
  final int supConstruidaMm2;
  final List<FilaMemoria> memoria;
}

/// Generador de layout (Fase 2 de CLAUDE.md): de los `filas`/`modulosPorFila`
/// que entrega M3 a coordenadas concretas, agrupando las filas en **fila
/// doble** (espalda con espalda, CLAUDE.md sección 1) — es la única forma de
/// llegar al ratio sup_almacenamiento/sup_construida de 0.45-0.60 que el
/// propio CLAUDE.md sección 7 (M3) exige como prueba de humo: con fila
/// simple (pasillo completo en cada fila) el ratio nunca supera
/// fondo/(fondo+pasillo), que para dimensiones típicas ronda 0.28, sin
/// importar la escala.
///
/// Función pura: sin acceso a base de datos, sin estado.
ResultadoLayout generarLayout({
  required int filas,
  required int modulosPorFila,
  required int largoVigaMm,
  required int perfilAnchoBastidorMm,
  required int fondoBastidorMm,
  required int anchoPasilloMm,
  required int separacionEspaldaMm,
  required int holguraMuroMm,
}) {
  if (filas <= 0) {
    throw ArgumentError.value(filas, 'filas', 'Debe ser mayor que cero.');
  }
  if (modulosPorFila <= 0) {
    throw ArgumentError.value(modulosPorFila, 'modulosPorFila', 'Debe ser mayor que cero.');
  }

  final anchoRacksMm = modulosPorFila * (largoVigaMm + perfilAnchoBastidorMm);

  // Agrupar filas en pares (fila doble). Si sobra una, queda sola contra
  // el muro del otro extremo.
  final numPares = filas ~/ 2;
  final filaImparSuelta = filas.isOdd;
  final profundidadesGrupo = <int>[
    for (var i = 0; i < numPares; i++) 2 * fondoBastidorMm + separacionEspaldaMm,
    if (filaImparSuelta) fondoBastidorMm,
  ];

  final rectangulos = <Rectangulo>[];
  var cursorY = holguraMuroMm;
  var supRacksMm2 = 0;
  var supPasillosMm2 = 0;

  for (var i = 0; i < profundidadesGrupo.length; i++) {
    final esPar = i < numPares;
    if (esPar) {
      rectangulos.add(
        Rectangulo(
          xMm: holguraMuroMm,
          yMm: cursorY,
          anchoMm: anchoRacksMm,
          largoMm: fondoBastidorMm,
          tipo: 'reserva',
        ),
      );
      rectangulos.add(
        Rectangulo(
          xMm: holguraMuroMm,
          yMm: cursorY + fondoBastidorMm + separacionEspaldaMm,
          anchoMm: anchoRacksMm,
          largoMm: fondoBastidorMm,
          tipo: 'reserva',
        ),
      );
      supRacksMm2 += 2 * anchoRacksMm * fondoBastidorMm;
    } else {
      rectangulos.add(
        Rectangulo(
          xMm: holguraMuroMm,
          yMm: cursorY,
          anchoMm: anchoRacksMm,
          largoMm: fondoBastidorMm,
          tipo: 'reserva',
        ),
      );
      supRacksMm2 += anchoRacksMm * fondoBastidorMm;
    }
    cursorY += profundidadesGrupo[i];

    final esUltimo = i == profundidadesGrupo.length - 1;
    if (!esUltimo) {
      rectangulos.add(
        Rectangulo(
          xMm: holguraMuroMm,
          yMm: cursorY,
          anchoMm: anchoRacksMm,
          largoMm: anchoPasilloMm,
          tipo: 'circulacion',
        ),
      );
      supPasillosMm2 += anchoRacksMm * anchoPasilloMm;
      cursorY += anchoPasilloMm;
    }
  }

  final anchoTotalMm = anchoRacksMm + 2 * holguraMuroMm;
  final largoTotalMm = cursorY + holguraMuroMm;
  final supConstruidaMm2 = anchoTotalMm * largoTotalMm;

  final memoria = [
    FilaMemoria(
      orden: 1,
      modulo: 'M3',
      concepto: 'Agrupación en fila doble',
      formula: 'pares = filas ~/ 2; sobra 1 fila simple si filas es impar',
      entradas: {'filas': filas},
      valor: '$numPares pares${filaImparSuelta ? " + 1 fila simple" : ""}',
      unidad: 'grupos',
    ),
    FilaMemoria(
      orden: 2,
      modulo: 'M3',
      concepto: 'Superficie de pasillos',
      formula: 'sup_pasillos = Σ ancho_racks × ancho_pasillo (uno por cada par de grupos)',
      entradas: {
        'ancho_racks_mm': anchoRacksMm,
        'ancho_pasillo_mm': anchoPasilloMm,
        'numero_de_pasillos': profundidadesGrupo.length - 1,
      },
      valor: '$supPasillosMm2',
      unidad: 'mm²',
    ),
    FilaMemoria(
      orden: 3,
      modulo: 'M3',
      concepto: 'Superficie construida (huella total del edificio)',
      formula: 'sup_construida = (ancho_racks + 2×holgura_muro) × (profundidad_total + 2×holgura_muro)',
      entradas: {
        'ancho_racks_mm': anchoRacksMm,
        'profundidad_total_mm': largoTotalMm - 2 * holguraMuroMm,
        'holgura_muro_mm': holguraMuroMm,
      },
      valor: '$supConstruidaMm2',
      unidad: 'mm²',
    ),
    FilaMemoria(
      orden: 4,
      modulo: 'M3',
      concepto: 'Relación de superficie (indicador de calidad, sección 7)',
      formula: 'sup_almacenamiento / sup_construida',
      entradas: {'sup_racks_mm2': supRacksMm2, 'sup_construida_mm2': supConstruidaMm2},
      valor: (supRacksMm2 / supConstruidaMm2).toStringAsFixed(3),
      unidad: 'ratio',
    ),
  ];

  return ResultadoLayout(
    rectangulos: rectangulos,
    anchoTotalMm: anchoTotalMm,
    largoTotalMm: largoTotalMm,
    supRacksMm2: supRacksMm2,
    supPasillosMm2: supPasillosMm2,
    supConstruidaMm2: supConstruidaMm2,
    memoria: memoria,
  );
}
