class Proyecto {
  const Proyecto({
    this.id,
    required this.nombre,
    this.moneda = 'PEN',
    this.unidadPeso = 'toneladas',
    this.horizonteAnios = 5,
    this.factorCircuidad = 1.30,
    required this.creadoEn,
  });

  final int? id;
  final String nombre;
  final String moneda;
  final String unidadPeso; // toneladas | kilogramos | unidades
  final int horizonteAnios;
  final double factorCircuidad;
  final String creadoEn; // DateTime.toIso8601String()

  Proyecto copyWith({
    int? id,
    String? nombre,
    String? moneda,
    String? unidadPeso,
    int? horizonteAnios,
    double? factorCircuidad,
    String? creadoEn,
  }) {
    return Proyecto(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      moneda: moneda ?? this.moneda,
      unidadPeso: unidadPeso ?? this.unidadPeso,
      horizonteAnios: horizonteAnios ?? this.horizonteAnios,
      factorCircuidad: factorCircuidad ?? this.factorCircuidad,
      creadoEn: creadoEn ?? this.creadoEn,
    );
  }
}
