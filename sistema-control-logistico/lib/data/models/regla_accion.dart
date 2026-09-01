class ReglaAccion {
  const ReglaAccion({
    this.id,
    required this.categoriaIndicador,
    required this.reglaDisparada,
    required this.clasificacion,
    required this.accionId,
    required this.prioridad,
  });

  final int? id;
  final String categoriaIndicador;
  final String reglaDisparada;
  final String clasificacion;
  final int accionId;
  final int prioridad;

  ReglaAccion copyWith({
    int? id,
    String? categoriaIndicador,
    String? reglaDisparada,
    String? clasificacion,
    int? accionId,
    int? prioridad,
  }) {
    return ReglaAccion(
      id: id ?? this.id,
      categoriaIndicador: categoriaIndicador ?? this.categoriaIndicador,
      reglaDisparada: reglaDisparada ?? this.reglaDisparada,
      clasificacion: clasificacion ?? this.clasificacion,
      accionId: accionId ?? this.accionId,
      prioridad: prioridad ?? this.prioridad,
    );
  }
}
