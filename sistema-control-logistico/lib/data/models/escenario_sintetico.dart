class EscenarioSintetico {
  const EscenarioSintetico({
    this.id,
    required this.nombre,
    required this.indicadorBaseId,
    required this.patron,
    required this.parametrosJson,
    required this.semilla,
    required this.numeroPeriodos,
  });

  final int? id;
  final String nombre;
  final int indicadorBaseId;
  final String patron;
  final String parametrosJson;
  final int semilla;
  final int numeroPeriodos;

  EscenarioSintetico copyWith({
    int? id,
    String? nombre,
    int? indicadorBaseId,
    String? patron,
    String? parametrosJson,
    int? semilla,
    int? numeroPeriodos,
  }) {
    return EscenarioSintetico(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      indicadorBaseId: indicadorBaseId ?? this.indicadorBaseId,
      patron: patron ?? this.patron,
      parametrosJson: parametrosJson ?? this.parametrosJson,
      semilla: semilla ?? this.semilla,
      numeroPeriodos: numeroPeriodos ?? this.numeroPeriodos,
    );
  }
}
