class Cliente {
  final int? id;
  final String nombre;
  final String? contacto;
  final String? notas;

  const Cliente({
    this.id,
    required this.nombre,
    this.contacto,
    this.notas,
  });

  Cliente copyWith({
    int? id,
    String? nombre,
    String? contacto,
    String? notas,
  }) {
    return Cliente(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      contacto: contacto ?? this.contacto,
      notas: notas ?? this.notas,
    );
  }
}
