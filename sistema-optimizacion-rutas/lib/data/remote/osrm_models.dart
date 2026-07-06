/// Respuesta parseada de `GET /table/v1/driving/...` (sección 6.1 de CLAUDE.md).
class OsrmTableResponse {
  const OsrmTableResponse({
    required this.code,
    this.distanciasMetros,
    this.duracionesSegundos,
  });

  factory OsrmTableResponse.fromJson(Map<String, dynamic> json) {
    return OsrmTableResponse(
      code: json['code'] as String,
      distanciasMetros: _parseMatriz(json['distances']),
      duracionesSegundos: _parseMatriz(json['durations']),
    );
  }

  /// `"Ok"` si la consulta fue exitosa; otro valor (ej. `"NoRoute"`) en error.
  final String code;

  /// Matriz fila-columna de distancias en metros, mismo orden que las
  /// coordenadas enviadas.
  final List<List<double>>? distanciasMetros;

  /// Matriz fila-columna de tiempos en segundos, mismo orden.
  final List<List<double>>? duracionesSegundos;

  static List<List<double>>? _parseMatriz(dynamic valor) {
    if (valor == null) return null;
    return (valor as List)
        .map(
          (fila) =>
              (fila as List).map((v) => (v as num).toDouble()).toList(),
        )
        .toList();
  }
}

/// Un tramo ("leg") de la ruta entre dos paradas consecutivas — OSRM
/// devuelve uno por cada par de coordenadas consecutivas que se le envían
/// (ver CLAUDE.md: depósito → parada 1 → parada 2 → ... → depósito), sin
/// pedir nada extra.
class OsrmTramo {
  const OsrmTramo({required this.distanciaMetros, required this.duracionSegundos});

  factory OsrmTramo.fromJson(Map<String, dynamic> json) {
    return OsrmTramo(
      distanciaMetros: (json['distance'] as num).toDouble(),
      duracionSegundos: (json['duration'] as num).toDouble(),
    );
  }

  final double distanciaMetros;
  final double duracionSegundos;
}

/// Respuesta parseada de `GET /route/v1/driving/...` (sección 6.2 de
/// CLAUDE.md). Solo toma la primera ruta devuelta por OSRM.
class OsrmRouteResponse {
  const OsrmRouteResponse({
    required this.code,
    this.distanciaMetros,
    this.duracionSegundos,
    this.geometriaPolyline,
    this.tramos = const [],
  });

  factory OsrmRouteResponse.fromJson(Map<String, dynamic> json) {
    final rutas = json['routes'] as List?;
    final primera = (rutas != null && rutas.isNotEmpty)
        ? rutas.first as Map<String, dynamic>
        : null;
    final legs = primera?['legs'] as List?;

    return OsrmRouteResponse(
      code: json['code'] as String,
      distanciaMetros: (primera?['distance'] as num?)?.toDouble(),
      duracionSegundos: (primera?['duration'] as num?)?.toDouble(),
      geometriaPolyline: primera?['geometry'] as String?,
      tramos: legs == null
          ? const []
          : legs
                .map((l) => OsrmTramo.fromJson(l as Map<String, dynamic>))
                .toList(),
    );
  }

  final String code;
  final double? distanciaMetros;
  final double? duracionSegundos;

  /// String de polyline codificado, listo para decodificar a `LatLng` para
  /// `flutter_map`.
  final String? geometriaPolyline;

  /// Un tramo por cada par de paradas consecutivas (incluyendo depósito →
  /// primera parada y última parada → depósito). `tramos[i]` es el trayecto
  /// que termina en la parada `i + 1` de la ruta.
  final List<OsrmTramo> tramos;
}
