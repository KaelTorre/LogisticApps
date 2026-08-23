import 'generador_layout.dart';
import 'prisma_3d.dart';

/// Genera los prismas de bastidores y vigas de todas las filas de racks del
/// layout (CLAUDE.md sección 8.1): "un rack es una receta de prismas" —
/// `bastidor = 2 puntales`, `modulo = 2 bastidores + (niveles × 2 vigas)`,
/// `fila = modulos_por_fila × modulo`. Usa **el mismo [ResultadoLayout] de
/// la Fase 2** (las filas de tipo `reserva`) para que el isométrico y el
/// plano 2D nunca puedan mostrar geometrías distintas.
///
/// `anchoVigaMm` es una simplificación declarada: CLAUDE.md no da un ancho
/// de viga en el eje Y aparte del peralte (alto) y el largo — se usa un
/// valor nominal delgado solo para que la viga se vea como una viga y no
/// como un puntal, no es un dato de catálogo.
///
/// Función pura: sin acceso a base de datos, sin estado.
List<Prisma3D> generarPrismas3D({
  required ResultadoLayout layout,
  required int modulosPorFila,
  required int niveles,
  required int pasoNivelMm,
  required int largoVigaMm,
  required int peralteVigaMm,
  required int perfilAnchoBastidorMm,
  required int perfilFondoBastidorMm,
  required int fondoBastidorMm,
  int anchoVigaMm = 60,
}) {
  if (modulosPorFila <= 0 || niveles <= 0) {
    throw ArgumentError('modulosPorFila y niveles deben ser mayores que cero.');
  }

  final alturaTotalMm = niveles * pasoNivelMm;
  final prismas = <Prisma3D>[];

  final filas = layout.rectangulos.where((r) => r.tipo == 'reserva');

  for (final fila in filas) {
    // Bastidores: uno en cada límite de módulo a lo largo de X —
    // modulosPorFila + 1 posiciones, compartidas entre módulos vecinos.
    for (var i = 0; i <= modulosPorFila; i++) {
      final xBastidor = fila.xMm + i * largoVigaMm + i * perfilAnchoBastidorMm;
      // Puntal frontal.
      prismas.add(
        Prisma3D(
          xMm: xBastidor,
          yMm: fila.yMm,
          zMm: 0,
          dxMm: perfilAnchoBastidorMm,
          dyMm: perfilFondoBastidorMm,
          dzMm: alturaTotalMm,
          tipo: 'puntal',
        ),
      );
      // Puntal trasero.
      prismas.add(
        Prisma3D(
          xMm: xBastidor,
          yMm: fila.yMm + fondoBastidorMm - perfilFondoBastidorMm,
          zMm: 0,
          dxMm: perfilAnchoBastidorMm,
          dyMm: perfilFondoBastidorMm,
          dzMm: alturaTotalMm,
          tipo: 'puntal',
        ),
      );
    }

    // Vigas: 2 por módulo por nivel (riel frontal y riel trasero).
    for (var m = 0; m < modulosPorFila; m++) {
      final xViga = fila.xMm + m * largoVigaMm + m * perfilAnchoBastidorMm + perfilAnchoBastidorMm;
      for (var n = 1; n <= niveles; n++) {
        final zViga = n * pasoNivelMm;
        prismas.add(
          Prisma3D(
            xMm: xViga,
            yMm: fila.yMm,
            zMm: zViga,
            dxMm: largoVigaMm,
            dyMm: anchoVigaMm,
            dzMm: peralteVigaMm,
            tipo: 'viga',
          ),
        );
        prismas.add(
          Prisma3D(
            xMm: xViga,
            yMm: fila.yMm + fondoBastidorMm - anchoVigaMm,
            zMm: zViga,
            dxMm: largoVigaMm,
            dyMm: anchoVigaMm,
            dzMm: peralteVigaMm,
            tipo: 'viga',
          ),
        );
      }
    }
  }

  return prismas;
}
