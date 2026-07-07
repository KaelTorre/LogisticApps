/// Máquina de estados del pedido (CLAUDE.md §5.2).
///
/// Transiciones válidas: recibido → procesando → preparandoEnvio →
/// enTransito → entregado. `cancelado` es alcanzable desde cualquier estado
/// excepto `entregado`. No hay "deshacer": una vez registrada una
/// transición queda en el historial.
enum EstadoPedido {
  recibido,
  procesando,
  preparandoEnvio,
  enTransito,
  entregado,
  cancelado;

  static const _secuencia = [
    EstadoPedido.recibido,
    EstadoPedido.procesando,
    EstadoPedido.preparandoEnvio,
    EstadoPedido.enTransito,
    EstadoPedido.entregado,
  ];

  String get valorDb => switch (this) {
        EstadoPedido.recibido => 'recibido',
        EstadoPedido.procesando => 'procesando',
        EstadoPedido.preparandoEnvio => 'preparando_envio',
        EstadoPedido.enTransito => 'en_transito',
        EstadoPedido.entregado => 'entregado',
        EstadoPedido.cancelado => 'cancelado',
      };

  static EstadoPedido desdeDb(String valor) => switch (valor) {
        'recibido' => EstadoPedido.recibido,
        'procesando' => EstadoPedido.procesando,
        'preparando_envio' => EstadoPedido.preparandoEnvio,
        'en_transito' => EstadoPedido.enTransito,
        'entregado' => EstadoPedido.entregado,
        'cancelado' => EstadoPedido.cancelado,
        _ => throw ArgumentError('Estado de pedido desconocido: $valor'),
      };

  String get etiqueta => switch (this) {
        EstadoPedido.recibido => 'Recibido',
        EstadoPedido.procesando => 'Procesando',
        EstadoPedido.preparandoEnvio => 'Preparando envío',
        EstadoPedido.enTransito => 'En tránsito',
        EstadoPedido.entregado => 'Entregado',
        EstadoPedido.cancelado => 'Cancelado',
      };

  bool get esTerminal => this == EstadoPedido.entregado || this == EstadoPedido.cancelado;

  bool get puedeAvanzar => !esTerminal;

  bool get puedeCancelar => this != EstadoPedido.entregado;

  /// Siguiente estado en la secuencia normal, o `null` si ya es terminal.
  EstadoPedido? get siguienteEstado {
    if (!puedeAvanzar) return null;
    final indice = _secuencia.indexOf(this);
    return _secuencia[indice + 1];
  }
}

/// Clasificación del producto (CLAUDE.md §5.1, columna `categoria`).
enum CategoriaProducto {
  conveniencia,
  seleccion,
  especializado,
  industrial;

  String get valorDb => name;

  static CategoriaProducto desdeDb(String valor) =>
      CategoriaProducto.values.firstWhere((c) => c.valorDb == valor);

  String get etiqueta => switch (this) {
        CategoriaProducto.conveniencia => 'Conveniencia',
        CategoriaProducto.seleccion => 'Selección',
        CategoriaProducto.especializado => 'Especializado',
        CategoriaProducto.industrial => 'Industrial',
      };
}

/// Etapa de ciclo de vida del producto, informativa (CLAUDE.md §5.1).
enum EtapaCicloVida {
  introduccion,
  crecimiento,
  madurez,
  decaimiento;

  String get valorDb => name;

  static EtapaCicloVida desdeDb(String valor) =>
      EtapaCicloVida.values.firstWhere((e) => e.valorDb == valor);

  String get etiqueta => switch (this) {
        EtapaCicloVida.introduccion => 'Introducción',
        EtapaCicloVida.crecimiento => 'Crecimiento',
        EtapaCicloVida.madurez => 'Madurez',
        EtapaCicloVida.decaimiento => 'Decaimiento',
      };
}

/// Categoría ABC asignada por el módulo de clasificación (CLAUDE.md §6.3).
enum CategoriaAbc {
  a,
  b,
  c;

  String get etiqueta => switch (this) {
        CategoriaAbc.a => 'A',
        CategoriaAbc.b => 'B',
        CategoriaAbc.c => 'C',
      };
}

/// Defaults de `configuracion_sla` tomados del PDF del curso (CLAUDE.md §6.4).
class DefaultsSla {
  DefaultsSla._();

  static const double coeficienteIngreso = 0.5; // 'a'
  static const double coeficienteCosto = 0.00055; // 'b'
}
