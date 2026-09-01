class Organizacion {
  const Organizacion({
    this.id,
    required this.nombre,
    this.moneda = 'PEN',
    required this.tipoEmpresa,
    this.notas,
  });

  final int? id;
  final String nombre;
  final String moneda;
  final String tipoEmpresa;
  final String? notas;

  Organizacion copyWith({
    int? id,
    String? nombre,
    String? moneda,
    String? tipoEmpresa,
    String? notas,
  }) {
    return Organizacion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      moneda: moneda ?? this.moneda,
      tipoEmpresa: tipoEmpresa ?? this.tipoEmpresa,
      notas: notas ?? this.notas,
    );
  }
}
