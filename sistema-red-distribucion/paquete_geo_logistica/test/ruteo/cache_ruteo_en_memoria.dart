import 'package:paquete_geo_logistica/paquete_geo_logistica.dart';

/// Implementación mínima de [CacheRuteo] en memoria, usada solo en tests del
/// paquete (y como referencia de cómo una app consumidora satisface la
/// interfaz sin drift). La app real usa `CacheRuteoDrift` contra su propia
/// tabla `cache_ruteo`.
class CacheRuteoEnMemoria implements CacheRuteo {
  final Map<String, String> _almacen = {};

  @override
  Future<String?> leer(String hashConsulta) async => _almacen[hashConsulta];

  @override
  Future<void> guardar(
    String hashConsulta,
    String tipo,
    String respuestaJson,
  ) async {
    _almacen[hashConsulta] = respuestaJson;
  }
}
