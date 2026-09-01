import 'm1_reglas_patron.dart';

/// M4 — Verificador de acciones (CLAUDE.md sección 8). Función pura: al
/// cargarse el periodo siguiente al de una acción abierta, compara el
/// valor observado contra el del periodo de la desviación y contra la
/// meta, y **propone** un resultado de verificación.
///
/// [REGLA] "El sistema propone, el usuario confirma. No se cierra una
/// acción automáticamente." -- por eso esta función solo calcula el
/// `resultado` propuesto; guardarlo con `confirmadoPorUsuario = false` y
/// decidir si eso cierra la acción es responsabilidad de la pantalla de
/// Verificación (Pantalla 10), nunca de este módulo ni del repositorio.

/// 'corrigio' | 'no_corrigio' | 'parcial' -- mismos literales que
/// `verificacion_accion.resultado`.
String proponerResultadoVerificacion({
  required double valorPeriodoDesviacion,
  required double valorObservado,
  required ConfigIndicadorMotor indicador,
}) {
  final dentroDeBanda =
      valorObservado >= indicador.bandaInferior && valorObservado <= indicador.bandaSuperior;
  if (dentroDeBanda) return 'corrigio';

  final desviacionOriginal = (valorPeriodoDesviacion - indicador.meta).abs();
  final desviacionActual = (valorObservado - indicador.meta).abs();
  if (desviacionActual < desviacionOriginal) return 'parcial';

  return 'no_corrigio';
}
