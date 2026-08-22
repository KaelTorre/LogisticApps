import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/geometria/generador_layout.dart';

/// Vista cenital acotada del layout (CLAUDE.md sección 8.3). Misma fuente de
/// datos que la vista isométrica — ambas leen [ResultadoLayout], nunca un
/// dibujo aparte.
///
/// Cada zona lleva borde, relleno distinto por tipo y una etiqueta con su
/// nombre y dimensiones; los racks llevan además líneas divisorias por
/// módulo, para que el plano se lea como un plano real y no como un
/// rectángulo de color sin información.
///
/// El ancho (X) siempre está a escala uniforme. El alto (Y) usa una escala
/// "quebrada": cada franja (fila de racks, pasillo, separación de espalda,
/// margen de muro) recibe como mínimo el alto de píxeles que necesita su
/// propia etiqueta, aunque en milímetros sea mucho más delgada que las
/// demás — si no, una separación de espalda de 200mm queda invisible junto
/// a un pasillo de 2800mm y dos filas contiguas se leen como una sola. Esto
/// no afecta la exportación a DXF: `dxf_writer.dart` lee las coordenadas en
/// milímetros directo de [ResultadoLayout], nunca los píxeles de este
/// painter.
class Plano2D extends StatelessWidget {
  const Plano2D({
    super.key,
    required this.layout,
    required this.modulosPorFila,
    required this.frenteAndenMm,
    required this.patioProfundidadMm,
  });

  final ResultadoLayout layout;

  /// Para dibujar las líneas divisorias de módulo dentro de cada rectángulo
  /// de racks — se asume el mismo ancho de módulo en todo el layout, que es
  /// como lo construye `generarLayout`.
  final int modulosPorFila;
  final int frenteAndenMm;
  final int patioProfundidadMm;

  /// Colores públicos para que la leyenda de [PlanoScreen] use exactamente
  /// los mismos tonos que el dibujo, sin duplicar valores.
  static const colorRacks = Color(0xFFC5CAE9);
  static const colorRacksBorde = Color(0xFF283593);
  static const colorPasillo = Color(0xFFFFF3E0);
  static const colorPasilloBorde = Color(0xFFEF6C00);
  static const colorAnden = Color(0xFFE8F5E9);
  static const colorAndenBorde = Color(0xFF2E7D32);
  static const colorSeparacion = Color(0xFFECEFF1);
  static const colorSeparacionBorde = Color(0xFF607D8B);
  static const colorMuro = Color(0xFF212121);

  static const _margenCotaPx = 40.0;
  static const _franjaAndenPx = 56.0;
  static const _alturaObjetivoPx = 500.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final anchoDisponible = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : 800.0;

        final espacioAnchoDibujo = anchoDisponible - 2 * _margenCotaPx;
        final espacioAltoObjetivoDibujo =
            _alturaObjetivoPx - 2 * _margenCotaPx - _franjaAndenPx - _margenCotaPx;
        final escala = [
          espacioAnchoDibujo / layout.anchoTotalMm,
          espacioAltoObjetivoDibujo / layout.largoTotalMm,
        ].reduce((a, b) => a < b ? a : b);

        final bandas = _construirBandas(layout);
        final ejeY = _EjeY(bandas, escala);
        final altoCanvas =
            ejeY.alturaTotalPx + 2 * _margenCotaPx + _franjaAndenPx + _margenCotaPx;

        // Sin AspectRatio: un layout de 1 sola fila sin pasillo puede ser 20
        // veces más ancho que profundo, y forzar el widget a esa proporción
        // lo deja como una franja casi invisible. El painter calcula una
        // escala uniforme en X y centra el dibujo; en Y usa [ejeY], que ya
        // garantiza espacio mínimo por franja — el `SizedBox` crece a lo
        // que haga falta y `InteractiveViewer` deja acercar o alejar.
        return InteractiveViewer(
          minScale: 0.2,
          maxScale: 8,
          child: SizedBox(
            width: anchoDisponible,
            height: altoCanvas,
            child: CustomPaint(
              painter: _Plano2DPainter(
                layout: layout,
                modulosPorFila: modulosPorFila,
                frenteAndenMm: frenteAndenMm,
                patioProfundidadMm: patioProfundidadMm,
                escala: escala,
                bandas: bandas,
                ejeY: ejeY,
              ),
            ),
          ),
        );
      },
    );
  }
}

enum _TipoBanda { margen, reserva, circulacion, separacion }

/// Una franja del eje Y: una fila de racks, un pasillo, una separación de
/// espalda (el hueco entre dos filas de una fila doble) o un margen de
/// muro. Es un concepto de presentación de este archivo — no toca
/// [Rectangulo.tipo], cuyo vocabulario (`reserva`/`circulacion`) sigue
/// siendo el que define CLAUDE.md sección 5.
class _Banda {
  const _Banda({required this.tipo, required this.alturaMm});
  final _TipoBanda tipo;
  final int alturaMm;

  double get alturaMinPx => switch (tipo) {
    _TipoBanda.reserva => 46.0,
    _TipoBanda.circulacion => 36.0,
    _TipoBanda.separacion => 20.0,
    _TipoBanda.margen => 4.0,
  };

  double alturaPx(double escala) => math.max(alturaMm * escala, alturaMinPx);
}

/// Recorre `layout.rectangulos` (ya en orden ascendente de `yMm`, por cómo
/// los construye `generarLayout`) y arma las franjas del eje Y: una por
/// cada rectángulo, más una franja `separacion` en cada hueco entre dos
/// `reserva` consecutivos (la separación de espalda de una fila doble, que
/// no tiene su propio `Rectangulo`) y una franja `margen` en cada extremo.
List<_Banda> _construirBandas(ResultadoLayout layout) {
  final rects = layout.rectangulos;
  final bandas = <_Banda>[];
  if (rects.isEmpty) {
    return [_Banda(tipo: _TipoBanda.margen, alturaMm: layout.largoTotalMm)];
  }

  var cursorMm = 0;
  if (rects.first.yMm > cursorMm) {
    bandas.add(_Banda(tipo: _TipoBanda.margen, alturaMm: rects.first.yMm - cursorMm));
  }
  for (var i = 0; i < rects.length; i++) {
    final r = rects[i];
    bandas.add(
      _Banda(
        tipo: r.tipo == 'reserva' ? _TipoBanda.reserva : _TipoBanda.circulacion,
        alturaMm: r.largoMm,
      ),
    );
    cursorMm = r.yMm + r.largoMm;
    if (i + 1 < rects.length) {
      final hueco = rects[i + 1].yMm - cursorMm;
      if (hueco > 0) {
        bandas.add(_Banda(tipo: _TipoBanda.separacion, alturaMm: hueco));
        cursorMm += hueco;
      }
    }
  }
  if (layout.largoTotalMm > cursorMm) {
    bandas.add(_Banda(tipo: _TipoBanda.margen, alturaMm: layout.largoTotalMm - cursorMm));
  }
  return bandas;
}

/// Mapeo milímetro → píxel del eje Y, respetando el alto mínimo de cada
/// [_Banda]. Se construye una sola vez por pintado y lo usan tanto el
/// tamaño del `CustomPaint` (su altura total) como el painter (la posición
/// de cada rectángulo).
class _EjeY {
  _EjeY(List<_Banda> bandas, double escala) {
    var mm = 0;
    var px = 0.0;
    _mmLimites.add(mm);
    _pxLimites.add(px);
    for (final b in bandas) {
      mm += b.alturaMm;
      px += b.alturaPx(escala);
      _mmLimites.add(mm);
      _pxLimites.add(px);
    }
  }

  final List<int> _mmLimites = [];
  final List<double> _pxLimites = [];

  double get alturaTotalPx => _pxLimites.last;

  /// Píxel Y correspondiente a `mm`. Los bordes de cada [Rectangulo]
  /// siempre caen exactamente en un límite de banda, así que en la
  /// práctica esto nunca interpola dentro de una franja — pero lo hace de
  /// todas formas por si el valor cae en medio (p.ej. redondeos).
  double px(int mm) {
    for (var i = 0; i < _mmLimites.length - 1; i++) {
      final mm0 = _mmLimites[i];
      final mm1 = _mmLimites[i + 1];
      if (mm <= mm1) {
        if (mm1 == mm0) return _pxLimites[i];
        final t = (mm - mm0) / (mm1 - mm0);
        return _pxLimites[i] + t * (_pxLimites[i + 1] - _pxLimites[i]);
      }
    }
    return _pxLimites.last;
  }
}

class _Plano2DPainter extends CustomPainter {
  _Plano2DPainter({
    required this.layout,
    required this.modulosPorFila,
    required this.frenteAndenMm,
    required this.patioProfundidadMm,
    required this.escala,
    required this.bandas,
    required this.ejeY,
  });

  final ResultadoLayout layout;
  final int modulosPorFila;
  final int frenteAndenMm;
  final int patioProfundidadMm;
  final double escala;
  final List<_Banda> bandas;
  final _EjeY ejeY;

  static const _margenCotaPx = 40.0;
  static const _franjaAndenPx = 56.0;
  static const _colorCota = Color(0xFF616161);

  @override
  void paint(Canvas canvas, Size size) {
    final xAndenMm = frenteAndenMm > layout.anchoTotalMm
        ? 0
        : (layout.anchoTotalMm - frenteAndenMm) ~/ 2;
    final yAndenMm = layout.largoTotalMm;

    final anchoDibujoPx = layout.anchoTotalMm * escala;
    final espacioAnchoDibujo = size.width - 2 * _margenCotaPx;
    final origenX = _margenCotaPx + (espacioAnchoDibujo - anchoDibujoPx) / 2;
    const origenY = _margenCotaPx;

    Offset punto(num xMm, num yMm) =>
        Offset(origenX + xMm * escala, origenY + ejeY.px(yMm.round()));

    // Envolvente del edificio (el "muro"): ancla visual del plano, para que
    // no se lea como formas flotantes sin contexto.
    canvas.drawRect(
      Rect.fromPoints(punto(0, 0), punto(layout.anchoTotalMm, layout.largoTotalMm)),
      Paint()
        ..color = Plano2D.colorMuro
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );

    for (final r in layout.rectangulos) {
      final esRack = r.tipo == 'reserva';
      final rect = Rect.fromPoints(
        punto(r.xMm, r.yMm),
        punto(r.xMm + r.anchoMm, r.yMm + r.largoMm),
      );
      final colorRelleno = esRack ? Plano2D.colorRacks : Plano2D.colorPasillo;
      final colorBorde = esRack ? Plano2D.colorRacksBorde : Plano2D.colorPasilloBorde;

      canvas.drawRect(rect, Paint()..color = colorRelleno);
      if (esRack) {
        _dibujarLineasModulo(canvas, rect, r.anchoMm, modulosPorFila);
      } else {
        _dibujarRayado(canvas, rect, colorBorde);
      }
      canvas.drawRect(
        rect,
        Paint()
          ..color = colorBorde
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );

      final etiqueta = esRack
          ? 'RACKS\n${r.anchoMm}×${r.largoMm} mm\n$modulosPorFila módulos'
          : 'PASILLO\n${r.anchoMm}×${r.largoMm} mm';
      _dibujarEtiquetaEnRect(canvas, rect, etiqueta, colorBorde);
    }

    // Separaciones de espalda (huecos entre dos `reserva` consecutivos de
    // una fila doble): sin esto, con el hueco real de 200mm la franja es
    // invisible a esta escala y dos filas distintas se leen como una sola.
    // Al dibujarla con su propio color y su alto mínimo garantizado
    // ([_TipoBanda.separacion]), se ve claramente que son 2 filas con un
    // hueco estructural entre ellas — no un pasillo transitable.
    for (var i = 0; i < layout.rectangulos.length - 1; i++) {
      final a = layout.rectangulos[i];
      final b = layout.rectangulos[i + 1];
      if (a.tipo == 'reserva' && b.tipo == 'reserva') {
        final separacionMm = b.yMm - (a.yMm + a.largoMm);
        final rectSeparacion = Rect.fromPoints(
          punto(a.xMm, a.yMm + a.largoMm),
          punto(a.xMm + a.anchoMm, b.yMm),
        );
        canvas.drawRect(rectSeparacion, Paint()..color = Plano2D.colorSeparacion);
        canvas.drawRect(
          rectSeparacion,
          Paint()
            ..color = Plano2D.colorSeparacionBorde
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );
        _dibujarEtiquetaEnRect(
          canvas,
          rectSeparacion,
          '$separacionMm mm',
          Plano2D.colorSeparacionBorde,
        );
      }
    }

    // Andén: mismo ancho real que frente_anden (a escala), pero profundidad
    // esquemática de `_franjaAndenPx` fijos — el patio real
    // (patioProfundidadMm) puede ser mucho más profundo que todo el
    // racking, y dibujarlo a la misma escala reduciría el edificio a un
    // punto. El patio real está acotado en el texto de la etiqueta y en la
    // ficha técnica.
    final origenAnden = punto(xAndenMm, yAndenMm);
    final rectAnden = Rect.fromLTWH(
      origenAnden.dx,
      origenAnden.dy,
      frenteAndenMm * escala,
      _franjaAndenPx,
    );
    canvas.drawRect(rectAnden, Paint()..color = Plano2D.colorAnden);
    _dibujarRayado(canvas, rectAnden, Plano2D.colorAndenBorde);
    canvas.drawRect(
      rectAnden,
      Paint()
        ..color = Plano2D.colorAndenBorde
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    _dibujarEtiquetaEnRect(
      canvas,
      rectAnden,
      'ANDÉN · frente $frenteAndenMm mm\npatio $patioProfundidadMm mm (no a escala)',
      Plano2D.colorAndenBorde,
    );

    _dibujarCotaHorizontal(
      canvas,
      punto(0, 0).translate(0, -_margenCotaPx / 2),
      punto(layout.anchoTotalMm, 0).translate(0, -_margenCotaPx / 2),
      '${layout.anchoTotalMm} mm',
    );
    _dibujarCotaVertical(
      canvas,
      punto(0, 0).translate(-_margenCotaPx / 2, 0),
      punto(0, layout.largoTotalMm).translate(-_margenCotaPx / 2, 0),
      '${layout.largoTotalMm} mm',
    );
  }

  /// Líneas verticales entre módulos dentro de un rectángulo de racks, para
  /// que se vea la subdivisión real en vez de un bloque uniforme.
  void _dibujarLineasModulo(Canvas canvas, Rect rect, int anchoRectMm, int modulos) {
    if (modulos <= 1) return;
    final anchoModuloPx = rect.width / modulos;
    final paint = Paint()
      ..color = Plano2D.colorRacksBorde.withValues(alpha: 0.35)
      ..strokeWidth = 0.75;
    for (var i = 1; i < modulos; i++) {
      final x = rect.left + anchoModuloPx * i;
      canvas.drawLine(Offset(x, rect.top), Offset(x, rect.bottom), paint);
    }
  }

  /// Rayado diagonal ligero para distinguir a simple vista una zona de
  /// circulación (vacía) de una zona sólida (racks), más allá del color.
  void _dibujarRayado(Canvas canvas, Rect rect, Color color) {
    canvas.save();
    canvas.clipRect(rect);
    final paint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..strokeWidth = 1;
    const paso = 10.0;
    final total = (rect.width + rect.height) ~/ paso + 1;
    for (var i = -total; i < total; i++) {
      final x0 = rect.left + i * paso;
      canvas.drawLine(
        Offset(x0, rect.bottom),
        Offset(x0 + rect.height, rect.top),
        paint,
      );
    }
    canvas.restore();
  }

  /// Dibuja una etiqueta centrada dentro de `rect`, en varias líneas; si no
  /// cabe ni la primera línea, no dibuja nada (mejor sin etiqueta que una
  /// ilegible encimada con el borde). Con `InteractiveViewer` el usuario
  /// puede acercar para que el texto se vea a un tamaño legible, igual que
  /// en un visor de CAD real.
  void _dibujarEtiquetaEnRect(Canvas canvas, Rect rect, String texto, Color color) {
    final painter = TextPainter(
      text: TextSpan(
        text: texto,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600, height: 1.3),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: rect.width - 4);
    if (painter.width > rect.width - 4 && rect.width < 40) return;
    if (painter.height > rect.height - 4 && rect.height < 30) return;
    painter.paint(
      canvas,
      rect.center - Offset(painter.width / 2, painter.height / 2),
    );
  }

  /// Cota horizontal: línea + remates perpendiculares (marcas de inicio y
  /// fin) + valor centrado arriba, en texto horizontal — es la orientación
  /// natural para una medida horizontal, no necesita rotarse.
  void _dibujarCotaHorizontal(Canvas canvas, Offset a, Offset b, String etiqueta) {
    final paint = Paint()
      ..color = _colorCota
      ..strokeWidth = 1;
    canvas.drawLine(a, b, paint);
    const remate = 4.0;
    canvas.drawLine(a.translate(0, -remate), a.translate(0, remate), paint);
    canvas.drawLine(b.translate(0, -remate), b.translate(0, remate), paint);
    _dibujarTexto(canvas, etiqueta, Offset((a.dx + b.dx) / 2, a.dy - 14));
  }

  /// Cota vertical: línea + remates perpendiculares + valor en texto
  /// vertical, girado 90° y desplazado al lado de la línea (nunca encima)
  /// — de arriba hacia abajo se lee de izquierda a derecha si se inclina la
  /// cabeza hacia la derecha, la misma convención que un plano CAD.
  void _dibujarCotaVertical(Canvas canvas, Offset a, Offset b, String etiqueta) {
    final paint = Paint()
      ..color = _colorCota
      ..strokeWidth = 1;
    canvas.drawLine(a, b, paint);
    const remate = 4.0;
    canvas.drawLine(a.translate(-remate, 0), a.translate(remate, 0), paint);
    canvas.drawLine(b.translate(-remate, 0), b.translate(remate, 0), paint);
    _dibujarTextoVertical(canvas, etiqueta, Offset(a.dx + 9, (a.dy + b.dy) / 2));
  }

  void _dibujarTexto(Canvas canvas, String texto, Offset posicion) {
    final painter = TextPainter(
      text: TextSpan(text: texto, style: const TextStyle(color: _colorCota, fontSize: 10)),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, posicion - Offset(painter.width / 2, painter.height / 2));
  }

  /// Texto rotado -90° (de abajo hacia arriba en pantalla): la misma
  /// convención que usan los ejes verticales de un plano CAD o de un
  /// gráfico, para que nunca quede escrito horizontalmente encima de una
  /// línea de cota vertical.
  void _dibujarTextoVertical(Canvas canvas, String texto, Offset posicion) {
    final painter = TextPainter(
      text: TextSpan(text: texto, style: const TextStyle(color: _colorCota, fontSize: 10)),
      textDirection: TextDirection.ltr,
    )..layout();
    canvas.save();
    canvas.translate(posicion.dx, posicion.dy);
    canvas.rotate(-math.pi / 2);
    painter.paint(canvas, Offset(-painter.width / 2, -painter.height / 2));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _Plano2DPainter oldDelegate) =>
      oldDelegate.layout != layout ||
      oldDelegate.modulosPorFila != modulosPorFila ||
      oldDelegate.frenteAndenMm != frenteAndenMm ||
      oldDelegate.patioProfundidadMm != patioProfundidadMm;
}
