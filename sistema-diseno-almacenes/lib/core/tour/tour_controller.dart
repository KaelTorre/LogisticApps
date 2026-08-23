import 'package:shared_preferences/shared_preferences.dart';

/// Recuerda si la inducción guiada (`InduccionScreen`) ya se mostró, para
/// no interrumpir con ella en cada arranque. La inducción en sí no navega
/// pantallas reales (ver `induccion_screen.dart`), así que este controlador
/// no necesita ser un `ChangeNotifier` ni propagarse por el árbol de
/// widgets — es solo persistencia de una bandera, se pasa por constructor
/// como `db`.
class TourController {
  TourController(this._prefs);

  static const _claveVisto = 'induccion_guiada_vista';

  final SharedPreferences _prefs;

  bool get yaVisto => _prefs.getBool(_claveVisto) ?? false;

  Future<void> marcarVisto() => _prefs.setBool(_claveVisto, true);
}
