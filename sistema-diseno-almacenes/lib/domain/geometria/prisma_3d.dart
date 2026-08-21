/// Un prisma rectangular en el espacio 3D del almacén, en mm. Origen en la
/// esquina de coordenadas mínimas; `dxMm`/`dyMm`/`dzMm` son las dimensiones
/// hacia +X/+Y/+Z. CLAUDE.md sección 8.1: un rack es una receta de estos
/// prismas — nunca una malla externa.
class Prisma3D {
  const Prisma3D({
    required this.xMm,
    required this.yMm,
    required this.zMm,
    required this.dxMm,
    required this.dyMm,
    required this.dzMm,
    required this.tipo,
  });

  final int xMm;
  final int yMm;
  final int zMm;
  final int dxMm;
  final int dyMm;
  final int dzMm;

  /// puntal | viga.
  final String tipo;
}
