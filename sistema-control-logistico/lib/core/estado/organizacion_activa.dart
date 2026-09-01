import 'package:flutter/foundation.dart';

import '../../data/models/organizacion.dart';

/// Organización que el usuario tiene abierta -- todas las pantallas de
/// datos (periodos, indicadores, mediciones, presupuesto...) operan sobre
/// `organizacion!.id`. Se selecciona desde `InicioScreen`.
class OrganizacionActiva extends ChangeNotifier {
  Organizacion? _organizacion;

  Organizacion? get organizacion => _organizacion;

  void seleccionar(Organizacion organizacion) {
    _organizacion = organizacion;
    notifyListeners();
  }

  void limpiar() {
    _organizacion = null;
    notifyListeners();
  }
}
