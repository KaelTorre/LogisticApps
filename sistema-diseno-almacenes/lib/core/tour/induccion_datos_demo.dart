import '../../domain/geometria/generador_layout.dart';
import '../../domain/geometria/generador_prismas_3d.dart';
import '../../domain/geometria/prisma_3d.dart';

/// Datos sintéticos para la inducción guiada: un layout y unos prismas de
/// ejemplo, calculados una sola vez con las funciones puras reales del
/// motor (no una imagen ni una maqueta) para que el plano y la vista
/// isométrica que ve el usuario durante el recorrido sean el mismo render
/// que vería con un caso real — solo que con datos de ejemplo, no con los
/// suyos. 3 filas / 3 módulos por fila da una fila doble + una fila suelta
/// con pasillo visible, el caso más ilustrativo para explicar el plano.
class DatosDemoInduccion {
  DatosDemoInduccion._();

  static const modulosPorFila = 3;
  static const niveles = 4;
  static const pasoNivelMm = 1550;
  static const frenteAndenMm = 10800;
  static const patioProfundidadMm = 18000;

  static final ResultadoLayout layout = generarLayout(
    filas: 3,
    modulosPorFila: modulosPorFila,
    largoVigaMm: 1825,
    perfilAnchoBastidorMm: 100,
    fondoBastidorMm: 1100,
    anchoPasilloMm: 2800,
    separacionEspaldaMm: 200,
    holguraMuroMm: 200,
  );

  static final List<Prisma3D> prismas = generarPrismas3D(
    layout: layout,
    modulosPorFila: modulosPorFila,
    niveles: niveles,
    pasoNivelMm: pasoNivelMm,
    largoVigaMm: 1825,
    peralteVigaMm: 110,
    perfilAnchoBastidorMm: 100,
    perfilFondoBastidorMm: 50,
    fondoBastidorMm: 1100,
  );

  static const requerimientosMensuales = [100, 100, 100, 120, 140, 160, 180, 160, 140, 120, 100, 100];
  static const capacidadPropiaDemo = 140;

  static const List<double> historicoPronosticoDemo = [
    100,
    108,
    115,
    120,
    130,
    138,
    145,
    150,
    160,
    168,
    175,
    182,
  ];
  static const List<double> pronosticoDemo = [190.4, 198.1, 205.8];
}
