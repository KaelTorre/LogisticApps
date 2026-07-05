enum MetodoOptimizacion { ahorros, barrido }

extension MetodoOptimizacionValor on MetodoOptimizacion {
  String get valor => switch (this) {
        MetodoOptimizacion.ahorros => 'ahorros',
        MetodoOptimizacion.barrido => 'barrido',
      };

  static MetodoOptimizacion desdeValor(String valor) => switch (valor) {
        'ahorros' => MetodoOptimizacion.ahorros,
        'barrido' => MetodoOptimizacion.barrido,
        _ => throw ArgumentError('Método de optimización desconocido: $valor'),
      };
}

class EscenarioOptimizacion {
  final int? id;
  final int depositoId;
  final DateTime fechaCreacion;
  final MetodoOptimizacion metodoUsado;
  final List<int> puntoEntregaIds;
  final List<int> vehiculoIds;

  const EscenarioOptimizacion({
    this.id,
    required this.depositoId,
    required this.fechaCreacion,
    required this.metodoUsado,
    this.puntoEntregaIds = const [],
    this.vehiculoIds = const [],
  });
}
