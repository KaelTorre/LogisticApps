class Presupuesto {
  const Presupuesto({
    this.id,
    required this.organizacionId,
    required this.rubro,
    required this.periodoId,
    required this.montoPresupuestadoCent,
    required this.montoRealCent,
  });

  final int? id;
  final int organizacionId;
  final String rubro;
  final int periodoId;
  final int montoPresupuestadoCent;
  final int montoRealCent;

  Presupuesto copyWith({
    int? id,
    int? organizacionId,
    String? rubro,
    int? periodoId,
    int? montoPresupuestadoCent,
    int? montoRealCent,
  }) {
    return Presupuesto(
      id: id ?? this.id,
      organizacionId: organizacionId ?? this.organizacionId,
      rubro: rubro ?? this.rubro,
      periodoId: periodoId ?? this.periodoId,
      montoPresupuestadoCent: montoPresupuestadoCent ?? this.montoPresupuestadoCent,
      montoRealCent: montoRealCent ?? this.montoRealCent,
    );
  }
}
