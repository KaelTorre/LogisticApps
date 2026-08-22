import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_diseno_almacenes/domain/export/dxf_writer.dart';
import 'package:sistema_diseno_almacenes/domain/geometria/generador_layout.dart';

/// Un lector de DXF mínimo, solo para verificar en los tests que el texto
/// que escribimos a mano tiene la estructura correcta de pares
/// código/valor — no es un parser DXF general, solo lo que necesitan estas
/// aserciones. La prueba de humo real (abrir en LibreCAD y medir con la
/// herramienta de cota, CLAUDE.md sección 12) es manual y queda fuera de
/// este archivo.
class _Entidad {
  _Entidad(this.tipo, this.pares);
  final String tipo;
  final List<MapEntry<int, String>> pares;

  String get capa => pares.firstWhere((p) => p.key == 8).value;

  List<num> valoresNum(int codigo) =>
      pares.where((p) => p.key == codigo).map((p) => num.parse(p.value)).toList();

  /// Vértices de una LWPOLYLINE, en orden, como pares (x, y).
  List<(num, num)> get vertices {
    final xs = valoresNum(10);
    final ys = valoresNum(20);
    return [for (var i = 0; i < xs.length; i++) (xs[i], ys[i])];
  }
}

List<_Entidad> _parseEntidades(String dxf) {
  final lineas = dxf.split('\n').where((l) => l.isNotEmpty).toList();
  final pares = <MapEntry<int, String>>[
    for (var i = 0; i + 1 < lineas.length; i += 2) MapEntry(int.parse(lineas[i]), lineas[i + 1]),
  ];

  final inicioEntidades = pares.indexWhere((p) => p.key == 2 && p.value == 'ENTITIES');
  final finEntidades = pares.indexWhere(
    (p) => p.key == 0 && p.value == 'ENDSEC',
    inicioEntidades,
  );
  final seccion = pares.sublist(inicioEntidades + 1, finEntidades);

  final entidades = <_Entidad>[];
  List<MapEntry<int, String>>? actual;
  String? tipoActual;
  for (final p in seccion) {
    if (p.key == 0) {
      if (actual != null) entidades.add(_Entidad(tipoActual!, actual));
      tipoActual = p.value;
      actual = [];
    } else {
      actual!.add(p);
    }
  }
  if (actual != null) entidades.add(_Entidad(tipoActual!, actual));
  return entidades;
}

String? _valorHeader(String dxf, String variable) {
  final lineas = dxf.split('\n').where((l) => l.isNotEmpty).toList();
  final i = lineas.indexOf(variable);
  if (i == -1 || i + 2 >= lineas.length) return null;
  return lineas[i + 2];
}

void main() {
  // Layout de prueba con coordenadas conocidas a mano (ver comentario en
  // cada aserción para la cuenta): 4 filas — la 1ª y la 4ª van simples
  // contra su muro (necesitan su propio pasillo), y las 2 interiores se
  // emparejan en fila doble (separación entre filas 200mm). Pasillo de
  // 2800mm.
  final layout = generarLayout(
    filas: 4,
    modulosPorFila: 3,
    largoVigaMm: 1825,
    perfilAnchoBastidorMm: 100,
    fondoBastidorMm: 1100,
    anchoPasilloMm: 2800,
    separacionEspaldaMm: 200,
    holguraMuroMm: 200,
  );

  group('generarDxf — estructura', () {
    test(r'$INSUNITS = 4 (milímetros)', () {
      final dxf = generarDxf(layout: layout, frenteAndenMm: 3600, patioProfundidadMm: 18000);
      expect(_valorHeader(dxf, r'$INSUNITS'), '4');
    });

    test('declara las 6 capas obligatorias de la sección 9', () {
      final dxf = generarDxf(layout: layout, frenteAndenMm: 3600, patioProfundidadMm: 18000);
      for (final capa in ['RACKS', 'PASILLOS', 'ZONAS', 'ANDEN', 'COTAS', 'TEXTO']) {
        expect(dxf.contains('\n$capa\n'), isTrue, reason: 'falta la capa $capa');
      }
    });

    test('termina con EOF', () {
      final dxf = generarDxf(layout: layout, frenteAndenMm: 3600, patioProfundidadMm: 18000);
      expect(dxf.trim().endsWith('0\nEOF'), isTrue);
    });
  });

  group('generarDxf — geometría', () {
    test('una LWPOLYLINE en RACKS por cada rectángulo reserva, con vértices exactos', () {
      final dxf = generarDxf(layout: layout, frenteAndenMm: 3600, patioProfundidadMm: 18000);
      final entidades = _parseEntidades(dxf);
      final racks = entidades.where((e) => e.tipo == 'LWPOLYLINE' && e.capa == 'RACKS').toList();

      final reservas = layout.rectangulos.where((r) => r.tipo == 'reserva').toList();
      expect(racks, hasLength(reservas.length));

      // Primer rectángulo reserva: (200, 200, 5775×1100) por construcción
      // del layout (holgura_muro=200, ancho_racks=3×1925=5775).
      expect(racks.first.vertices, [
        (200, 200),
        (200 + 5775, 200),
        (200 + 5775, 200 + 1100),
        (200, 200 + 1100),
      ]);
    });

    test('una LWPOLYLINE en PASILLOS por cada rectángulo de circulación', () {
      final dxf = generarDxf(layout: layout, frenteAndenMm: 3600, patioProfundidadMm: 18000);
      final entidades = _parseEntidades(dxf);
      final pasillos = entidades.where((e) => e.tipo == 'LWPOLYLINE' && e.capa == 'PASILLOS').toList();
      final circulaciones = layout.rectangulos.where((r) => r.tipo == 'circulacion').toList();
      expect(pasillos, hasLength(circulaciones.length));
      expect(pasillos.first.vertices.first, (200, 1300));
    });

    test('dibuja el andén centrado, del tamaño de frente × patio', () {
      final dxf = generarDxf(layout: layout, frenteAndenMm: 3600, patioProfundidadMm: 18000);
      final entidades = _parseEntidades(dxf);
      final anden = entidades.singleWhere((e) => e.tipo == 'LWPOLYLINE' && e.capa == 'ANDEN');
      // x centrado: (6175 - 3600) / 2 = 1287 (división entera).
      expect(anden.vertices.first, (1287, 10600));
      expect(anden.vertices[1].$1 - anden.vertices.first.$1, 3600);
      expect(anden.vertices[2].$2 - anden.vertices.first.$2, 18000);
    });

    test('una etiqueta TEXT por cada rectángulo más una para el andén', () {
      final dxf = generarDxf(layout: layout, frenteAndenMm: 3600, patioProfundidadMm: 18000);
      final entidades = _parseEntidades(dxf);
      final textos = entidades.where((e) => e.tipo == 'TEXT' && e.capa == 'TEXTO').toList();
      expect(textos, hasLength(layout.rectangulos.length + 1));
    });
  });

  group('generarDxf — cotas (CLAUDE.md sección 8.3, exactamente 4 + andén)', () {
    late String dxf;
    late List<_Entidad> textosCota;

    setUp(() {
      dxf = generarDxf(layout: layout, frenteAndenMm: 3600, patioProfundidadMm: 18000);
      textosCota = _parseEntidades(
        dxf,
      ).where((e) => e.tipo == 'TEXT' && e.capa == 'COTAS').toList();
    });

    String valorTexto(_Entidad e) => e.pares.firstWhere((p) => p.key == 1).value;

    test('ancho total, profundidad total, ancho de pasillo, separación entre filas y frente de andén', () {
      final valores = textosCota.map(valorTexto).toSet();
      expect(valores, {
        '6175 mm', // ancho total
        '10600 mm', // profundidad total
        '2800 mm', // ancho de pasillo (= anchoPasilloMm)
        '200 mm', // separación entre filas (= separacionEspaldaMm)
        '3600 mm', // frente de andén
      });
    });
  });

  group('generarDxf — casos límite', () {
    test('sin rectángulo de circulación (una sola fila) no revienta y omite esa cota', () {
      final layoutSinPasillo = generarLayout(
        filas: 1,
        modulosPorFila: 2,
        largoVigaMm: 1825,
        perfilAnchoBastidorMm: 100,
        fondoBastidorMm: 1100,
        anchoPasilloMm: 2800,
        separacionEspaldaMm: 200,
        holguraMuroMm: 200,
      );
      final dxf = generarDxf(layout: layoutSinPasillo, frenteAndenMm: 3600, patioProfundidadMm: 18000);
      final entidades = _parseEntidades(dxf);
      expect(entidades.where((e) => e.capa == 'PASILLOS'), isEmpty);
    });
  });
}
