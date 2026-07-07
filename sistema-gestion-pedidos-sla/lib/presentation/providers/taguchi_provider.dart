import 'package:flutter/foundation.dart';

import '../../data/repositories/configuracion_repository.dart';
import '../../domain/funcion_taguchi.dart';

/// Estado y lógica de la calculadora de función de pérdida de Taguchi (M5).
/// `k`/`m` son persistibles en `configuracion_sla`; `y` es efímero (un
/// valor observado puntual, no se guarda).
class TaguchiProvider extends ChangeNotifier {
  TaguchiProvider(this._configuracionRepository);

  final ConfiguracionRepository _configuracionRepository;
  int? _configuracionId;
  bool cargado = false;

  double? constanteK;
  double? valorObjetivoM;
  double? resultadoPerdida;

  Future<void> cargarConfiguracion() async {
    final config = await _configuracionRepository.obtenerOCrearPorDefecto();
    _configuracionId = config.id;
    constanteK = config.constanteK;
    valorObjetivoM = config.valorObjetivoM;
    cargado = true;
    notifyListeners();
  }

  Future<void> calcular({
    required double k,
    required double y,
    required double m,
  }) async {
    resultadoPerdida = calcularPerdidaTaguchi(k: k, y: y, m: m);
    constanteK = k;
    valorObjetivoM = m;
    notifyListeners();

    final id = _configuracionId;
    if (id != null) {
      await _configuracionRepository.actualizarParametrosTaguchi(id, k, m);
    }
  }
}
