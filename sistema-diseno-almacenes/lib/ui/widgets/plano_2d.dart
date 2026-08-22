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
  static const colorMuro = Color(0xFF212121);

  @override
  Widget build(BuildContext context) {
    // Sin AspectRatio: un layout de 1 sola fila sin pasillo puede ser 20
    // veces más ancho que profundo, y forzar el widget a esa proporción lo
    // deja como una franja casi invisible. El painter mismo calcula una
    // escala uniforme (misma en X e Y, para no deformar) y centra el
    // dibujo dentro del espacio disponible.
    return InteractiveViewer(
      minScale: 0.2,
      maxScale: 8,
      child: SizedBox(
        width: double.infinity,
        height: 500,
        child: CustomPaint(
          painter: _Plano2DPainter(
            layout: layout,
            modulosPorFila: modulosPorFila,
            frenteAndenMm: frenteAndenMm,
            patioProfundidadMm: patioProfundidadMm,
          ),
        ),
      ),
    );
  }
}

class _Plano2DPainter extends CustomPainter {
  _Plano2DPainter({
    required this.layout,
    required this.modulosPorFila,
    required this.frenteAndenMm,
    required this.patioProfundidadMm,
  });

  final ResultadoLayout layout;
  final int modulosPorFila;
  final int frenteAndenMm;
  final int patioProfundidadMm;

  static const _margenCotaPx = 40.0;
  static const _colorCota = Color(0xFF616161);

  @override
  void paint(Canvas canvas, Size size) {
    final xAndenMm = frenteAndenMm > layout.anchoTotalMm
        ? 0
        : (layout.anchoTotalMm - frenteAndenMm) ~/ 2;
    final yAndenMm = layout.largoTotalMm;

    // Franja fija para el indicador del andén, aparte de la escala del
    // edificio — el patio de maniobras real (patioProfundidadMm, del orden
    // de 15-20 m) puede ser mucho más profundo que todo el racking, y
    // dibujarlo a la misma escala reduciría el edificio a un punto. El
    // andén se representa a ancho real pero a profundidad esquemática; su
    // profundidad real ya está acotada en la ficha técnica y en el DXF.
    const franjaAndenPx = 56.0;

    final espacioDisponible = Rect.fromLTWH(
      _margenCotaPx,
      _margenCotaPx,
      size.width - 2 * _margenCotaPx,
      size.height - 2 * _margenCotaPx - franjaAndenPx - _margenCotaPx,
    );
    // Escala uniforme (misma en X e Y, para no deformar el dibujo) que
    // quepa en el espacio disponible, luego centrada — así un layout muy
    // ancho y poco profundo (o al revés) no queda ni distorsionado ni
    // reducido a una línea.
    final escala = [
      espacioDisponible.width / layout.anchoTotalMm,
      espacioDisponible.height / layout.largoTotalMm,
    ].reduce((a, b) => a < b ? a : b);

    final anchoDibujoPx = layout.anchoTotalMm * escala;
    final altoDibujoPx = layout.largoTotalMm * escala;
    final origen = Offset(
      espacioDisponible.left + (espacioDisponible.width - anchoDibujoPx) / 2,
      espacioDisponible.top + (espacioDisponible.height - altoDibujoPx) / 2,
    );

    Offset punto(num xMm, num yMm) => origen + Offset(xMm * escala, yMm * escala);

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

    // Andén: mismo ancho real que frente_anden (a escala), pero profundidad
    // esquemática de `franjaAndenPx` fijos — ver el comentario sobre
    // `franjaAndenPx` más arriba. El patio real (patioProfundidadMm) está
    // acotado en el texto de la etiqueta y en la ficha técnica.
    final rectAnden = Rect.fromLTWH(
      punto(xAndenMm, yAndenMm).dx,
      punto(xAndenMm, yAndenMm).dy,
      frenteAndenMm * escala,
      franjaAndenPx,
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

    final primerPasillo = layout.rectangulos.where((r) => r.tipo == 'circulacion').firstOrNull;
    if (primerPasillo != null) {
      _dibujarCotaVertical(
        canvas,
        punto(primerPasillo.xMm + primerPasillo.anchoMm, primerPasillo.yMm),
        punto(primerPasillo.xMm + primerPasillo.anchoMm, primerPasillo.yMm + primerPasillo.largoMm),
        '${primerPasillo.largoMm} mm',
        desplazamientoEtiqueta: const Offset(6, 0),
      );
    }

    // Separación entre filas: entre el primer par de rectángulos `reserva`
    // consecutivos (fila doble, espalda con espalda) — igual criterio que
    // dxf_writer.dart, para que las dos exportaciones no se desincronicen.
    for (var i = 0; i < layout.rectangulos.length - 1; i++) {
      final a = layout.rectangulos[i];
      final b = layout.rectangulos[i + 1];
      if (a.tipo == 'reserva' && b.tipo == 'reserva') {
        final separacion = b.yMm - (a.yMm + a.largoMm);
        // Al lado derecho del edificio, no al izquierdo: la cota de
        // profundidad total ya vive ahí (afuera, a la izquierda) y quedaban
        // demasiado cerca para leerse por separado.
        _dibujarCotaVertical(
          canvas,
          punto(a.xMm + a.anchoMm, a.yMm + a.largoMm),
          punto(a.xMm + a.anchoMm, b.yMm),
          '$separacion mm',
          desplazamientoEtiqueta: const Offset(6, 0),
        );
        break;
      }
    }

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

  void _dibujarCotaHorizontal(Canvas canvas, Offset a, Offset b, String etiqueta) {
    final paint = Paint()
      ..color = _colorCota
      ..strokeWidth = 1;
    canvas.drawLine(a, b, paint);
    _dibujarTexto(canvas, etiqueta, Offset((a.dx + b.dx) / 2, a.dy - 14));
  }

  void _dibujarCotaVertical(
    Canvas canvas,
    Offset a,
    Offset b,
    String etiqueta, {
    Offset desplazamientoEtiqueta = Offset.zero,
  }) {
    final paint = Paint()
      ..color = _colorCota
      ..strokeWidth = 1;
    canvas.drawLine(a, b, paint);
    _dibujarTexto(
      canvas,
      etiqueta,
      Offset(a.dx + desplazamientoEtiqueta.dx, (a.dy + b.dy) / 2) + desplazamientoEtiqueta,
    );
  }

  void _dibujarTexto(Canvas canvas, String texto, Offset posicion) {
    final painter = TextPainter(
      text: TextSpan(text: texto, style: const TextStyle(color: _colorCota, fontSize: 10)),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, posicion - Offset(painter.width / 2, painter.height / 2));
  }

  @override
  bool shouldRepaint(covariant _Plano2DPainter oldDelegate) =>
      oldDelegate.layout != layout ||
      oldDelegate.modulosPorFila != modulosPorFila ||
      oldDelegate.frenteAndenMm != frenteAndenMm ||
      oldDelegate.patioProfundidadMm != patioProfundidadMm;
}
