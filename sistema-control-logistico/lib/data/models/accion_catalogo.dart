class AccionCatalogo {
  const AccionCatalogo({
    this.id,
    required this.codigo,
    required this.titulo,
    required this.descripcion,
    required this.categoriaIndicador,
    required this.magnitudTipica,
    this.esDeSistema = true,
    this.aplicacionExternaSugerida,
  });

  final int? id;
  final String codigo;
  final String titulo;
  final String descripcion;
  final String categoriaIndicador;
  final String magnitudTipica;
  final bool esDeSistema;
  final String? aplicacionExternaSugerida;

  AccionCatalogo copyWith({
    int? id,
    String? codigo,
    String? titulo,
    String? descripcion,
    String? categoriaIndicador,
    String? magnitudTipica,
    bool? esDeSistema,
    String? aplicacionExternaSugerida,
  }) {
    return AccionCatalogo(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      categoriaIndicador: categoriaIndicador ?? this.categoriaIndicador,
      magnitudTipica: magnitudTipica ?? this.magnitudTipica,
      esDeSistema: esDeSistema ?? this.esDeSistema,
      aplicacionExternaSugerida: aplicacionExternaSugerida ?? this.aplicacionExternaSugerida,
    );
  }
}
