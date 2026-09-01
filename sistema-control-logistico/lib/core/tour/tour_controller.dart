import 'package:shared_preferences/shared_preferences.dart';

/// Recuerda si la inducción guiada ya se mostró, para no interrumpir con
/// ella en cada arranque -- no es un `ChangeNotifier`, es solo
/// persistencia de una bandera.
class TourController {
  TourController(this._prefs);

  static const _claveVisto = 'induccion_guiada_vista';

  final SharedPreferences _prefs;

  /// `main.dart` llama esto antes de `runApp`, en el mismo momento que
  /// siembra el catálogo -- evita que `main.dart` tenga que conocer
  /// `SharedPreferences` directamente.
  static Future<TourController> crear() async => TourController(await SharedPreferences.getInstance());

  bool get yaVisto => _prefs.getBool(_claveVisto) ?? false;

  Future<void> marcarVisto() => _prefs.setBool(_claveVisto, true);
}
