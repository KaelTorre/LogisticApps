/// Abstracción de caché que [OsrmClient] usa para no depender de drift ni de
/// ningún motor de base de datos concreto — la app que consume el paquete
/// implementa esta interfaz contra su propia tabla (`CacheRuteoDrift`), y los
/// tests del paquete pueden satisfacerla con una versión en memoria.
abstract class CacheRuteo {
  /// Devuelve el JSON guardado para `hashConsulta`, o `null` si no hay
  /// entrada cacheada.
  Future<String?> leer(String hashConsulta);

  /// Guarda la respuesta cruda (`respuestaJson`) de una consulta de tipo
  /// `tipo` (`'matriz'` | `'ruta'`) bajo `hashConsulta`.
  Future<void> guardar(String hashConsulta, String tipo, String respuestaJson);
}
