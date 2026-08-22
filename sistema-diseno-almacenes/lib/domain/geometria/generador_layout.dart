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

  // Bloques de la sección transversal, en orden de muro cercano a muro
  // lejano: cada bloque es `1` (fila simple) o `2` (fila doble/espalda con
  // espalda). Las filas contra un muro perimetral SIEMPRE van simples — una
  // fila doble en el borde dejaría una de sus dos filas sin pasillo de
  // acceso por ningún lado (inaccesible en la práctica, el muro no sirve de
  // pasillo). Solo se emparejan las filas interiores, que ya quedan
  // flanqueadas por pasillos por construcción; eso además maximiza el
  // ratio de superficie sin sacrificar accesibilidad, porque cada fila
  // interior que se logra emparejar ahorra un pasillo completo a cambio de
  // solo `separacionEspaldaMm` de separación de espalda.
  final bloques = <int>[
    if (filas == 1)
      1
    else ...[
      1,
      for (var i = 0; i < (filas - 2) ~/ 2; i++) 2,
      if ((filas - 2).isOdd) 1,
      1,
    ],
  ];
  final numPares = bloques.where((b) => b == 2).length;
  final numSimples = bloques.where((b) => b == 1).length;

  final rectangulos = <Rectangulo>[];
  var cursorY = holguraMuroMm;
  var supRacksMm2 = 0;
  var supPasillosMm2 = 0;

  for (var i = 0; i < bloques.length; i++) {
    final esPar = bloques[i] == 2;
    rectangulos.add(
      Rectangulo(
        xMm: holguraMuroMm,
        yMm: cursorY,
        anchoMm: anchoRacksMm,
        largoMm: fondoBastidorMm,
        tipo: 'reserva',
      ),
    );
    if (esPar) {
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
      cursorY += 2 * fondoBastidorMm + separacionEspaldaMm;
    } else {
      supRacksMm2 += anchoRacksMm * fondoBastidorMm;
      cursorY += fondoBastidorMm;
    }

    final esUltimo = i == bloques.length - 1;
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
      formula: 'las filas contra un muro van simples; solo se emparejan las '
          'filas interiores (siempre flanqueadas por pasillo)',
      entradas: {'filas': filas},
      valor: '$numPares pares${numSimples > 0 ? " + $numSimples fila(s) simple(s)" : ""}',
      unidad: 'grupos',
    ),
    FilaMemoria(
      orden: 2,
      modulo: 'M3',
      concepto: 'Superficie de pasillos',
      formula: 'sup_pasillos = Σ ancho_racks × ancho_pasillo (uno entre cada par de bloques)',
      entradas: {
        'ancho_racks_mm': anchoRacksMm,
        'ancho_pasillo_mm': anchoPasilloMm,
        'numero_de_pasillos': bloques.length - 1,
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
