/// Validadores reutilizados por los formularios de Depósito, Puntos de
/// entrega y Vehículos (sección 11 de CLAUDE.md: coordenadas fuera de rango
/// deben rechazarse en el formulario, no llegar a OSRM).
String? validarObligatorio(String? valor, {String etiqueta = 'Este campo'}) {
  if (valor == null || valor.trim().isEmpty) {
    return '$etiqueta es obligatorio.';
  }
  return null;
}

String? validarLatitud(String? valor) {
  if (valor == null || valor.trim().isEmpty) return 'La latitud es obligatoria.';
  final numero = double.tryParse(valor.trim());
  if (numero == null) return 'Debe ser un número.';
  if (numero < -90 || numero > 90) return 'Debe estar entre -90 y 90.';
  return null;
}

String? validarLongitud(String? valor) {
  if (valor == null || valor.trim().isEmpty) {
    return 'La longitud es obligatoria.';
  }
  final numero = double.tryParse(valor.trim());
  if (numero == null) return 'Debe ser un número.';
  if (numero < -180 || numero > 180) return 'Debe estar entre -180 y 180.';
  return null;
}

/// Valida un número >= 0 (demanda, capacidad, costo por km): obligatorio si
/// [requerido] es true, opcional (vacío permitido) en caso contrario.
String? validarNumeroNoNegativo(
  String? valor, {
  required String etiqueta,
  bool requerido = true,
}) {
  if (valor == null || valor.trim().isEmpty) {
    return requerido ? '$etiqueta es obligatorio.' : null;
  }
  final numero = double.tryParse(valor.trim());
  if (numero == null) return 'Debe ser un número.';
  if (numero < 0) return 'No puede ser negativo.';
  return null;
}
