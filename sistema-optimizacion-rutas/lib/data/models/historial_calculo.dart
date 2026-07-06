import 'escenario_optimizacion.dart';

/// Copia ("snapshot") de una parada tal como estaba al momento del cálculo
/// — inmutable a propósito: si el punto de entrega real se edita o se
/// borra después desde su CRUD, esta copia no cambia.
class ParadaSnapshot {
  const ParadaSnapshot({
    required this.nombre,
    required this.latitud,
    required this.longitud,
    required this.demanda,
  });

  final String nombre;
  final double latitud;
  final double longitud;
  final double demanda;

  Map<String, dynamic> toJson() => {
    'nombre': nombre,
    'latitud': latitud,
    'longitud': longitud,
    'demanda': demanda,
  };

  factory ParadaSnapshot.fromJson(Map<String, dynamic> json) =>
      ParadaSnapshot(
        nombre: json['nombre'] as String,
        latitud: (json['latitud'] as num).toDouble(),
        longitud: (json['longitud'] as num).toDouble(),
        demanda: (json['demanda'] as num).toDouble(),
      );
}

/// Una de las rutas resultantes de un cálculo guardado en el historial —
/// datos del vehículo y de cada parada copiados ("snapshot") al momento del
/// cálculo, no referencias en vivo.
class HistorialRuta {
  const HistorialRuta({
    this.id,
    required this.orden,
    this.vehiculoNombre,
    this.vehiculoCapacidadMaxima,
    this.vehiculoCostoEstimadoPorKm,
    this.vehiculoTipoFlota,
    required this.paradas,
    this.distanciaMetros,
    this.duracionSegundos,
    this.distanciasPorTramoMetros = const [],
    this.geometriaPolyline,
  });

  final int? id;
  final int orden;
  final String? vehiculoNombre;
  final double? vehiculoCapacidadMaxima;
  final double? vehiculoCostoEstimadoPorKm;
  final String? vehiculoTipoFlota;
  final List<ParadaSnapshot> paradas;
  final double? distanciaMetros;
  final double? duracionSegundos;

  /// Distancia de cada tramo, incluyendo el tramo de regreso al depósito
  /// (largo == `paradas.length + 1`, ver mapa_resultado_screen.dart).
  final List<double> distanciasPorTramoMetros;
  final String? geometriaPolyline;
}

/// Un cálculo completo guardado en el historial (sección "Historial" de la
/// app): un depósito, un método, y las rutas resultantes. `rutas` viene
/// vacío en los resúmenes de lista — solo se carga completo al abrir el
/// detalle de una entrada (`HistorialRepository.obtenerDetalle`).
class HistorialCalculo {
  const HistorialCalculo({
    this.id,
    required this.fechaCalculo,
    required this.metodo,
    required this.depositoNombre,
    required this.depositoLatitud,
    required this.depositoLongitud,
    required this.vehiculosFaltantes,
    required this.distanciaTotalMetros,
    required this.cantidadRutas,
    this.rutas = const [],
  });

  final int? id;
  final DateTime fechaCalculo;
  final MetodoOptimizacion metodo;
  final String depositoNombre;
  final double depositoLatitud;
  final double depositoLongitud;
  final int vehiculosFaltantes;
  final double distanciaTotalMetros;
  final int cantidadRutas;
  final List<HistorialRuta> rutas;
}
