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
