import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Pasos de la inducción guiada, en el orden en que se muestran. Cada
/// pantalla llama [TourController.irA] con su propio paso en `initState`
/// mientras el recorrido esté activo — así el recorrido "navega" con la
/// navegación real de la app, en vez de imitarla con datos falsos.
enum PasoTour { entrada, ficha, plano }

/// Estado de la inducción guiada (CLAUDE.md no la pide explícitamente, es un
/// agregado pedido por el usuario tras probar la app): aparece automática la
/// primera vez que se abre la app, y queda disponible para repetirla desde
/// un botón de ayuda. Se guarda si ya se vio con `shared_preferences` — es
/// la única bandera que persiste, no hace falta una tabla en la base.
class TourController extends ChangeNotifier {
  TourController(this._prefs);

  static const _claveVisto = 'induccion_guiada_vista';

  final SharedPreferences _prefs;

  bool _activo = false;
  PasoTour _pasoActual = PasoTour.entrada;

  bool get activo => _activo;
  PasoTour get pasoActual => _pasoActual;
  bool get yaVisto => _prefs.getBool(_claveVisto) ?? false;

  /// Se llama una sola vez, al arrancar la app. Si nunca se vio, empieza el
  /// recorrido; si ya se vio (incluso en una sesión anterior), no hace nada.
  void iniciarSiEsPrimeraVez() {
    if (!yaVisto) iniciar();
  }

  /// Para el botón de ayuda (?) — repetir el recorrido a pedido, sin
  /// importar si ya se había visto antes.
  void iniciar() {
    _activo = true;
    _pasoActual = PasoTour.entrada;
    notifyListeners();
  }

  /// Cada pantalla del recorrido llama esto en su `initState` para
  /// declararse como el paso actual, solo si el recorrido sigue activo.
  void irA(PasoTour paso) {
    if (!_activo) return;
    _pasoActual = paso;
    notifyListeners();
  }

  /// El usuario cierra el recorrido antes de terminar, o llega al último
  /// paso — en ambos casos se marca como visto para no interrumpir de
  /// nuevo en el próximo arranque.
  void terminar() {
    _activo = false;
    _prefs.setBool(_claveVisto, true);
    notifyListeners();
  }
}
