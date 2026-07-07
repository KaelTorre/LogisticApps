import 'package:flutter/foundation.dart';

import '../../core/constants.dart';
import '../../data/repositories/configuracion_repository.dart';
import '../../domain/optimizacion_nivel_servicio.dart';

enum EstadoOptimizacion { inactivo, cargando, listo, error }

/// Estado y lógica de la calculadora de nivel de servicio óptimo (M4). Los
/// coeficientes `a`/`b` se prellenan con los defaults del PDF y se guardan
/// en `configuracion_sla` cada vez que el usuario calcula.
class OptimizacionServicioProvider extends ChangeNotifier {
  OptimizacionServicioProvider(this._configuracionRepository);

  final ConfiguracionRepository _configuracionRepository;

  EstadoOptimizacion estado = EstadoOptimizacion.inactivo;
  String? mensajeError;
  int? _configuracionId;
  bool cargado = false;

  double coeficienteIngreso = DefaultsSla.coeficienteIngreso;
  double coeficienteCosto = DefaultsSla.coeficienteCosto;
  ResultadoOptimizacionServicio? resultado;

  Future<void> cargarConfiguracion() async {
    final config = await _configuracionRepository.obtenerOCrearPorDefecto();
    _configuracionId = config.id;
    coeficienteIngreso = config.coeficienteIngreso;
    coeficienteCosto = config.coeficienteCosto;
    cargado = true;
    notifyListeners();
  }

  Future<void> calcular({required double a, required double b}) async {
    try {
      resultado = calcularNivelServicioOptimo(a: a, b: b);
      coeficienteIngreso = a;
      coeficienteCosto = b;
      estado = EstadoOptimizacion.listo;
      mensajeError = null;
      notifyListeners();

      final id = _configuracionId;
      if (id != null) {
        await _configuracionRepository.actualizarCoeficientesSl(id, a, b);
      }
    } on CoeficienteCostoInvalido catch (e) {
      resultado = null;
      estado = EstadoOptimizacion.error;
      mensajeError = e.toString();
      notifyListeners();
    }
  }
}
