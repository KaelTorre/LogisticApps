import 'package:flutter/material.dart';

import '../../domain/geometria/generador_layout.dart';

/// Vista cenital acotada del layout (CLAUDE.md sección 8.3). Misma fuente de
/// datos que usará la vista isométrica de la Fase 6 — ambas leen
/// [ResultadoLayout], nunca un dibujo aparte.
class Plano2D extends StatelessWidget {
  const Plano2D({super.key, required this.layout});

  final ResultadoLayout layout;

  /// Colores públicos para que la leyenda de [PlanoScreen] use exactamente
  /// los mismos tonos que el dibujo, sin duplicar valores.
  static const colorRacks = Color(0xFF3949AB);
  static const colorPasillo = Color(0xFFE0E0E0);

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
        child: CustomPaint(painter: _Plano2DPainter(layout)),
      ),
    );
  }
}

class _Plano2DPainter extends CustomPainter {
  _Plano2DPainter(this.layout);

  final ResultadoLayout layout;

  static const _margenCotaPx = 40.0;
  static const _colorCota = Color(0xFF616161);

  @override
  void paint(Canvas canvas, Size size) {
    final espacioDisponible = Rect.fromLTWH(
      _margenCotaPx,
      _margenCotaPx,
      size.width - 2 * _margenCotaPx,
      size.height - 2 * _margenCotaPx,
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

    Offset punto(int xMm, int yMm) => origen + Offset(xMm * escala, yMm * escala);

    for (final r in layout.rectangulos) {
      final rect = Rect.fromPoints(
        punto(r.xMm, r.yMm),
        punto(r.xMm + r.anchoMm, r.yMm + r.largoMm),
      );
      final paint = Paint()..color = r.tipo == 'reserva' ? Plano2D.colorRacks : Plano2D.colorPasillo;
      canvas.drawRect(rect, paint);
      canvas.drawRect(rect, Paint()..color = Colors.black12..style = PaintingStyle.stroke);
    }

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
  bool shouldRepaint(covariant _Plano2DPainter oldDelegate) => oldDelegate.layout != layout;
}
