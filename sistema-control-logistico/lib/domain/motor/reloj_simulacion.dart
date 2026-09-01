import 'evaluador_serie.dart';
import 'm1_reglas_patron.dart';

/// Reloj de simulación (Pantalla 13, CLAUDE.md sección 9): mantiene un
/// índice sobre una serie ya cargada en memoria y expone avanzar,
/// retroceder y reiniciar. El estado en cada posición se recalcula por
/// completo con [evaluarHastaIndice] -- nunca se actualiza de forma
/// incremental -- así que avanzar y luego retroceder produce exactamente
/// el mismo resultado que nunca haberse movido (Fase 7, Test P), y el
/// estado en el índice `t` es siempre idéntico al de una evaluación
/// aislada hasta `t` (Test Q).
///
/// [REGLA] (Fase 7, Test R): esta clase nunca toca la base de datos --
/// no depende de ningún repositorio, solo de la serie que ya se le
/// entregó cargada. Avanzar y retroceder no pueden, por construcción,
/// crear, modificar ni borrar una medición.
class RelojSimulacion {
  RelojSimulacion({required this.serie, required this.indicador}) : _indice = 1;

  final List<PuntoSerieMotor> serie;
  final ConfigIndicadorMotor indicador;
  int _indice;

  int get indiceActual => _indice;
  int get totalPeriodos => serie.length;
  bool get puedeAvanzar => _indice < serie.length;
  bool get puedeRetroceder => _indice > 1;

  EstadoEnPeriodo get estadoActual => evaluarHastaIndice(serie, indicador, _indice);

  void avanzar() {
    if (puedeAvanzar) _indice++;
  }

  void retroceder() {
    if (puedeRetroceder) _indice--;
  }

  void reiniciar() {
    _indice = 1;
  }
}
