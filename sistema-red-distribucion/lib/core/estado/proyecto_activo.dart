import 'package:flutter/foundation.dart';

import '../../data/models/proyecto.dart';

/// Proyecto que el usuario tiene abierto — todas las pantallas de datos
/// (clientes, sitios candidatos, plantas, parámetros de costo, auditoría...)
/// operan sobre `proyecto!.id`. Se selecciona desde `ProyectosScreen`.
class ProyectoActivo extends ChangeNotifier {
  Proyecto? _proyecto;

  Proyecto? get proyecto => _proyecto;

  void seleccionar(Proyecto proyecto) {
    _proyecto = proyecto;
    notifyListeners();
  }

  void limpiar() {
    _proyecto = null;
    notifyListeners();
  }
}
