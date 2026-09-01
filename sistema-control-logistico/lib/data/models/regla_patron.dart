class ReglaPatron {
  const ReglaPatron({
    this.id,
    required this.codigo,
    required this.nombre,
    required this.descripcion,
    required this.parametrosJson,
    required this.periodosMinimos,
    required this.severidadBase,
    this.activa = true,
    this.indicadorId,
  });

  final int? id;
  final String codigo;
  final String nombre;
  final String descripcion;
  final String parametrosJson;
  final int periodosMinimos;
  final double severidadBase;
  final bool activa;
  /// null = regla global, aplicable a cualquier indicador.
  final int? indicadorId;

  ReglaPatron copyWith({
    int? id,
    String? codigo,
    String? nombre,
    String? descripcion,
    String? parametrosJson,
    int? periodosMinimos,
    double? severidadBase,
    bool? activa,
    int? indicadorId,
  }) {
    return ReglaPatron(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      parametrosJson: parametrosJson ?? this.parametrosJson,
      periodosMinimos: periodosMinimos ?? this.periodosMinimos,
      severidadBase: severidadBase ?? this.severidadBase,
      activa: activa ?? this.activa,
      indicadorId: indicadorId ?? this.indicadorId,
    );
  }
}
