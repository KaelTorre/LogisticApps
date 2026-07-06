/// Validadores reutilizados por los formularios de Depósito, Puntos de
/// entrega y Vehículos. La latitud/longitud ya no se valida como texto: se
/// elige tocando el mapa (`SelectorUbicacionCampo`), que por construcción
/// siempre da coordenadas dentro de rango.
String? validarObligatorio(String? valor, {String etiqueta = 'Este campo'}) {
  if (valor == null || valor.trim().isEmpty) {
    return '$etiqueta es obligatorio.';
  }
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
