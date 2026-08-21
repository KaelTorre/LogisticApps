import 'package:flutter/material.dart';

import '../../domain/geometria/prisma_3d.dart';
import 'proyeccion_isometrica.dart';

/// Vista isométrica (CLAUDE.md sección 8.2): sin motor 3D, proyección
/// directa en `CustomPainter`. Misma fuente de datos que el plano 2D — los
/// prismas vienen de [ResultadoLayout] vía `generarPrismas3D`, nunca de un
/// dibujo aparte.
class VistaIsometrica extends StatelessWidget {
  const VistaIsometrica({
    super.key,
    required this.prismas,
    required this.angulo,
    this.nivelCorte,
    required this.pasoNivelMm,
  });

  final List<Prisma3D> prismas;

  /// 0..3, pasos de 90°. Nunca cámara libre.
  final int angulo;

  /// Si no es null, solo se dibujan prismas hasta este nivel (corte por
  /// nivel de rack, CLAUDE.md sección 8.2).
  final int? nivelCorte;
  final int pasoNivelMm;

  @override
  Widget build(BuildContext context) {
    final visibles = nivelCorte == null
        ? prismas
        : prismas.where((p) => p.zMm <= nivelCorte! * pasoNivelMm).toList();

    return InteractiveViewer(
      minScale: 0.2,
      maxScale: 8,
      child: SizedBox(
        width: double.infinity,
        height: 500,
        child: CustomPaint(painter: _VistaIsometricaPainter(visibles, angulo)),
      ),
    );
  }
}

class _VistaIsometricaPainter extends CustomPainter {
  _VistaIsometricaPainter(this.prismas, this.angulo);

  final List<Prisma3D> prismas;
  final int angulo;

  static const _margenPx = 24.0;
  static const _colorPuntal = Color(0xFF3949AB);
  static const _colorViga = Color(0xFFEF6C00);

  @override
  void paint(Canvas canvas, Size size) {
    if (prismas.isEmpty) return;

    // Primera pasada a escala 1 para conocer el bounding box proyectado, y
    // así ajustar y centrar sin deformar (mismo enfoque que Plano2D).
    var minX = double.infinity, maxX = double.negativeInfinity;
    var minY = double.infinity, maxY = double.negativeInfinity;
    for (final p in prismas) {
      for (final esquina in _esquinas(p)) {
        final (ex, ey, ez) = esquina;
        final (rx, ry) = rotarXY(ex, ey, angulo);
        final punto = iso(rx, ry, ez, 1, Offset.zero);
        minX = minX < punto.dx ? minX : punto.dx;
        maxX = maxX > punto.dx ? maxX : punto.dx;
        minY = minY < punto.dy ? minY : punto.dy;
        maxY = maxY > punto.dy ? maxY : punto.dy;
      }
    }

    final anchoDisponible = size.width - 2 * _margenPx;
    final altoDisponible = size.height - 2 * _margenPx;
    final anchoProyectado = maxX - minX;
    final altoProyectado = maxY - minY;
    final escala = [
      if (anchoProyectado > 0) anchoDisponible / anchoProyectado,
      if (altoProyectado > 0) altoDisponible / altoProyectado,
    ].fold(double.infinity, (a, b) => a < b ? a : b);

    final origen = Offset(
      _margenPx - minX * escala + (anchoDisponible - anchoProyectado * escala) / 2,
      _margenPx - minY * escala + (altoDisponible - altoProyectado * escala) / 2,
    );

    Offset proyectar(int x, int y, int z) {
      final (rx, ry) = rotarXY(x, y, angulo);
      return iso(rx, ry, z, escala, origen);
    }

    for (final p in ordenarParaPintar(prismas, angulo)) {
      final base = p.tipo == 'puntal' ? _colorPuntal : _colorViga;
      _dibujarPrisma(canvas, p, proyectar, base);
    }
  }

  void _dibujarPrisma(
    Canvas canvas,
    Prisma3D p,
    Offset Function(int, int, int) proyectar,
    Color base,
  ) {
    final x0 = p.xMm, x1 = p.xMm + p.dxMm;
    final y0 = p.yMm, y1 = p.yMm + p.dyMm;
    final z0 = p.zMm, z1 = p.zMm + p.dzMm;

    // Las 3 caras visibles desde la cámara isométrica estándar (CLAUDE.md
    // 8.2): superior, y las dos caras que se juntan en la arista más
    // cercana al observador (x1,y1). 3 tonos del mismo color para simular
    // sombreado, sin luces reales.
    final caraSuperior = [
      proyectar(x0, y0, z1),
      proyectar(x1, y0, z1),
      proyectar(x1, y1, z1),
      proyectar(x0, y1, z1),
    ];
    final caraX = [
      proyectar(x1, y0, z0),
      proyectar(x1, y1, z0),
      proyectar(x1, y1, z1),
      proyectar(x1, y0, z1),
    ];
    final caraY = [
      proyectar(x0, y1, z0),
      proyectar(x1, y1, z0),
      proyectar(x1, y1, z1),
      proyectar(x0, y1, z1),
    ];

    _rellenarPoligono(canvas, caraSuperior, Color.lerp(base, Colors.white, 0.35)!);
    _rellenarPoligono(canvas, caraX, Color.lerp(base, Colors.black, 0.15)!);
    _rellenarPoligono(canvas, caraY, Color.lerp(base, Colors.black, 0.35)!);
  }

  void _rellenarPoligono(Canvas canvas, List<Offset> puntos, Color color) {
    final path = Path()..addPolygon(puntos, true);
    canvas.drawPath(path, Paint()..color = color);
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.black12
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5,
    );
  }

  List<(int, int, int)> _esquinas(Prisma3D p) {
    final x0 = p.xMm, x1 = p.xMm + p.dxMm;
    final y0 = p.yMm, y1 = p.yMm + p.dyMm;
    final z0 = p.zMm, z1 = p.zMm + p.dzMm;
    return [
      (x0, y0, z0), (x1, y0, z0), (x0, y1, z0), (x1, y1, z0),
      (x0, y0, z1), (x1, y0, z1), (x0, y1, z1), (x1, y1, z1),
    ];
  }

  @override
  bool shouldRepaint(covariant _VistaIsometricaPainter oldDelegate) =>
      oldDelegate.prismas != prismas || oldDelegate.angulo != angulo;
}
