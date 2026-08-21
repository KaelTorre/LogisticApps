import '../geometria/generador_layout.dart';

/// DXF ASCII escrito a mano (CLAUDE.md sección 9): sin librería, formato
/// AC1015 (AutoCAD 2000) porque es la primera versión que soporta
/// `LWPOLYLINE` — la R12 clásica solo tiene `POLYLINE`/`VERTEX`/`SEQEND`, más
/// verboso para lo que se necesita aquí.
///
/// Seis capas obligatorias: `RACKS`, `PASILLOS`, `ZONAS`, `ANDEN`, `COTAS`,
/// `TEXTO`. `ZONAS` se declara en la tabla de capas pero queda sin entidades
/// — el sistema todavía no genera zonas funcionales (recepción, despacho,
/// preparación); es un hueco documentado, no una omisión silenciosa (ver
/// README "Pendiente: zonas funcionales").
///
/// Cotas incluidas (CLAUDE.md sección 8.3, exactamente esas cuatro): ancho y
/// profundidad totales (superficie), ancho de pasillo, frente de andén y
/// separación entre filas. La separación entre filas no es un parámetro de
/// entrada: se mide directamente entre el primer par de rectángulos
/// `reserva` consecutivos del layout, que es el mismo dato que
/// `generarLayout` ya usó para construirlos — medirlo de vuelta en vez de
/// repetirlo como argumento evita que ambos números se puedan desincronizar.
///
/// Unidades: milímetros enteros en todas las coordenadas ($INSUNITS = 4),
/// coherente con el modelo interno — cero conversión, cero riesgo de arrastre
/// de decimales entre el cálculo y el plano.
String generarDxf({
  required ResultadoLayout layout,
  required int frenteAndenMm,
  required int patioProfundidadMm,
}) {
  final w = _DxfWriter();

  for (final r in layout.rectangulos) {
    final capa = r.tipo == 'reserva' ? 'RACKS' : 'PASILLOS';
    w.rectangulo(r.xMm, r.yMm, r.anchoMm, r.largoMm, capa);
    w.texto(
      r.xMm + r.anchoMm / 2,
      r.yMm + r.largoMm / 2,
      r.tipo == 'reserva' ? 'RESERVA' : 'PASILLO',
      150,
    );
  }

  final xAnden = frenteAndenMm > layout.anchoTotalMm
      ? 0
      : (layout.anchoTotalMm - frenteAndenMm) ~/ 2;
  final yAnden = layout.largoTotalMm;
  w.rectangulo(xAnden, yAnden, frenteAndenMm, patioProfundidadMm, 'ANDEN');
  w.texto(xAnden + frenteAndenMm / 2, yAnden + patioProfundidadMm / 2, 'ANDEN', 150);

  // Cota 1: ancho total.
  w.cotaHorizontal(0, layout.anchoTotalMm, -300, layout.anchoTotalMm);
  // Cota 2: profundidad total.
  w.cotaVertical(layout.anchoTotalMm + 300, 0, layout.largoTotalMm, layout.largoTotalMm);

  // Cota 3: ancho de pasillo (primer rectángulo de circulación).
  final pasillo = layout.rectangulos.where((r) => r.tipo == 'circulacion').firstOrNull;
  if (pasillo != null) {
    w.cotaVertical(-300, pasillo.yMm, pasillo.yMm + pasillo.largoMm, pasillo.largoMm);
  }

  // Cota 4: separación entre filas — medida entre el primer par de
  // rectángulos `reserva` consecutivos, no recibida como parámetro.
  for (var i = 0; i < layout.rectangulos.length - 1; i++) {
    final a = layout.rectangulos[i];
    final b = layout.rectangulos[i + 1];
    if (a.tipo == 'reserva' && b.tipo == 'reserva') {
      final separacion = b.yMm - (a.yMm + a.largoMm);
      w.cotaVertical(a.xMm - 600, a.yMm + a.largoMm, b.yMm, separacion);
      break;
    }
  }

  // Cota 5: frente de andén.
  w.cotaHorizontal(xAnden, xAnden + frenteAndenMm, yAnden + patioProfundidadMm + 300, frenteAndenMm);

  return w.build();
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

const _capas = <String, int>{
  // Nombre de capa → color ACI (Autodesk Color Index).
  'RACKS': 5, // azul
  'PASILLOS': 3, // verde
  'ZONAS': 2, // amarillo
  'ANDEN': 1, // rojo
  'COTAS': 8, // gris
  'TEXTO': 7, // blanco/negro
};

class _DxfWriter {
  final StringBuffer _entidades = StringBuffer();
  int _handle = 0x40;

  String _nextHandle() => (_handle++).toRadixString(16).toUpperCase();

  void _code(StringBuffer b, int codigo, Object valor) {
    b.writeln(codigo);
    b.writeln(valor);
  }

  void rectangulo(num x, num y, num ancho, num alto, String capa) {
    final b = _entidades;
    _code(b, 0, 'LWPOLYLINE');
    _code(b, 5, _nextHandle());
    _code(b, 100, 'AcDbEntity');
    _code(b, 8, capa);
    _code(b, 100, 'AcDbPolyline');
    _code(b, 90, 4);
    _code(b, 70, 1); // cerrada
    _code(b, 43, 0);
    for (final (px, py) in [(x, y), (x + ancho, y), (x + ancho, y + alto), (x, y + alto)]) {
      _code(b, 10, px);
      _code(b, 20, py);
    }
  }

  void texto(num x, num y, String contenido, num altura, {String capa = 'TEXTO'}) {
    final b = _entidades;
    _code(b, 0, 'TEXT');
    _code(b, 5, _nextHandle());
    _code(b, 100, 'AcDbEntity');
    _code(b, 8, capa);
    _code(b, 100, 'AcDbText');
    _code(b, 10, x);
    _code(b, 20, y);
    _code(b, 30, 0);
    _code(b, 40, altura);
    _code(b, 1, contenido);
  }

  void _linea(num x1, num y1, num x2, num y2, String capa) {
    final b = _entidades;
    _code(b, 0, 'LINE');
    _code(b, 5, _nextHandle());
    _code(b, 100, 'AcDbEntity');
    _code(b, 8, capa);
    _code(b, 100, 'AcDbLine');
    _code(b, 10, x1);
    _code(b, 20, y1);
    _code(b, 30, 0);
    _code(b, 11, x2);
    _code(b, 21, y2);
    _code(b, 31, 0);
  }

  /// Línea de cota horizontal entre `x1` y `x2` a la altura `y`, con la
  /// etiqueta del valor centrada encima.
  void cotaHorizontal(num x1, num x2, num y, int valorMm) {
    _linea(x1, y, x2, y, 'COTAS');
    texto((x1 + x2) / 2, y, '$valorMm mm', 150, capa: 'COTAS');
  }

  /// Línea de cota vertical entre `y1` y `y2` en `x`, con la etiqueta del
  /// valor al lado.
  void cotaVertical(num x, num y1, num y2, int valorMm) {
    _linea(x, y1, x, y2, 'COTAS');
    texto(x, (y1 + y2) / 2, '$valorMm mm', 150, capa: 'COTAS');
  }

  String build() {
    final out = StringBuffer();
    _code(out, 0, 'SECTION');
    _code(out, 2, 'HEADER');
    _code(out, 9, r'$ACADVER');
    _code(out, 1, 'AC1015');
    _code(out, 9, r'$INSUNITS');
    _code(out, 70, 4); // milímetros
    _code(out, 0, 'ENDSEC');

    _code(out, 0, 'SECTION');
    _code(out, 2, 'TABLES');
    _code(out, 0, 'TABLE');
    _code(out, 2, 'LTYPE');
    _code(out, 70, 1);
    _code(out, 0, 'LTYPE');
    _code(out, 2, 'CONTINUOUS');
    _code(out, 70, 0);
    _code(out, 3, 'Solid line');
    _code(out, 72, 65);
    _code(out, 73, 0);
    _code(out, 40, 0.0);
    _code(out, 0, 'ENDTAB');
    _code(out, 0, 'TABLE');
    _code(out, 2, 'LAYER');
    _code(out, 70, _capas.length);
    for (final entry in _capas.entries) {
      _code(out, 0, 'LAYER');
      _code(out, 2, entry.key);
      _code(out, 70, 0);
      _code(out, 62, entry.value);
      _code(out, 6, 'CONTINUOUS');
    }
    _code(out, 0, 'ENDTAB');
    _code(out, 0, 'ENDSEC');

    _code(out, 0, 'SECTION');
    _code(out, 2, 'ENTITIES');
    out.write(_entidades);
    _code(out, 0, 'ENDSEC');

    _code(out, 0, 'EOF');
    return out.toString();
  }
}
