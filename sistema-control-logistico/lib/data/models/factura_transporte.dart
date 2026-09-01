class FacturaTransporte {
  const FacturaTransporte({
    this.id,
    required this.organizacionId,
    required this.numero,
    required this.transportista,
    required this.peso,
    required this.ruta,
    required this.tarifaAplicadaCent,
    required this.tarifaContratadaCent,
    this.discrepanciaTipo,
    this.montoRecuperableCent = 0,
    this.estado = 'pendiente',
  });

  final int? id;
  final int organizacionId;
  final String numero;
  final String transportista;
  final double peso;
  final String ruta;
  final int tarifaAplicadaCent;
  final int tarifaContratadaCent;
  final String? discrepanciaTipo;
  final int montoRecuperableCent;
  final String estado;

  FacturaTransporte copyWith({
    int? id,
    int? organizacionId,
    String? numero,
    String? transportista,
    double? peso,
    String? ruta,
    int? tarifaAplicadaCent,
    int? tarifaContratadaCent,
    String? discrepanciaTipo,
    int? montoRecuperableCent,
    String? estado,
  }) {
    return FacturaTransporte(
      id: id ?? this.id,
      organizacionId: organizacionId ?? this.organizacionId,
      numero: numero ?? this.numero,
      transportista: transportista ?? this.transportista,
      peso: peso ?? this.peso,
      ruta: ruta ?? this.ruta,
      tarifaAplicadaCent: tarifaAplicadaCent ?? this.tarifaAplicadaCent,
      tarifaContratadaCent: tarifaContratadaCent ?? this.tarifaContratadaCent,
      discrepanciaTipo: discrepanciaTipo ?? this.discrepanciaTipo,
      montoRecuperableCent: montoRecuperableCent ?? this.montoRecuperableCent,
      estado: estado ?? this.estado,
    );
  }
}
