class Indicador {
  const Indicador({
    this.id,
    required this.organizacionId,
    required this.codigo,
    required this.nombre,
    required this.categoria,
    required this.unidad,
    this.decimales = 2,
    required this.sentido,
    required this.meta,
    required this.bandaInferior,
    required this.bandaSuperior,
    required this.granularidad,
    required this.proceso,
    this.activo = true,
  });

  final int? id;
  final int organizacionId;
  final String codigo;
  final String nombre;
  final String categoria;
  final String unidad;
  final int decimales;
  final String sentido;
  final double meta;
  final double bandaInferior;
  final double bandaSuperior;
  final String granularidad;
  final String proceso;
  final bool activo;

  Indicador copyWith({
    int? id,
    int? organizacionId,
    String? codigo,
    String? nombre,
    String? categoria,
    String? unidad,
    int? decimales,
    String? sentido,
    double? meta,
    double? bandaInferior,
    double? bandaSuperior,
    String? granularidad,
    String? proceso,
    bool? activo,
  }) {
    return Indicador(
      id: id ?? this.id,
      organizacionId: organizacionId ?? this.organizacionId,
      codigo: codigo ?? this.codigo,
      nombre: nombre ?? this.nombre,
      categoria: categoria ?? this.categoria,
      unidad: unidad ?? this.unidad,
      decimales: decimales ?? this.decimales,
      sentido: sentido ?? this.sentido,
      meta: meta ?? this.meta,
      bandaInferior: bandaInferior ?? this.bandaInferior,
      bandaSuperior: bandaSuperior ?? this.bandaSuperior,
      granularidad: granularidad ?? this.granularidad,
      proceso: proceso ?? this.proceso,
      activo: activo ?? this.activo,
    );
  }
}
