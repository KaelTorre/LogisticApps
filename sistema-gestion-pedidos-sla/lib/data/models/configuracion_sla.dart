class ConfiguracionSla {
  final int? id;
  final double coeficienteIngreso; // 'a' en P = a·√SL − b·SL²
  final double coeficienteCosto; // 'b'
  final double? valorObjetivoM; // 'm' para función de Taguchi
  final double? constanteK; // 'k' para función de Taguchi

  const ConfiguracionSla({
    this.id,
    required this.coeficienteIngreso,
    required this.coeficienteCosto,
    this.valorObjetivoM,
    this.constanteK,
  });

  ConfiguracionSla copyWith({
    int? id,
    double? coeficienteIngreso,
    double? coeficienteCosto,
    double? valorObjetivoM,
    double? constanteK,
  }) {
    return ConfiguracionSla(
      id: id ?? this.id,
      coeficienteIngreso: coeficienteIngreso ?? this.coeficienteIngreso,
      coeficienteCosto: coeficienteCosto ?? this.coeficienteCosto,
      valorObjetivoM: valorObjetivoM ?? this.valorObjetivoM,
      constanteK: constanteK ?? this.constanteK,
    );
  }
}
