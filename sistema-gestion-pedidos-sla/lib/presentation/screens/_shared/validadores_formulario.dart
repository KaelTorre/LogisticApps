/// Validadores reutilizados por los formularios de Cliente, Producto y
/// Pedido.
String? validarObligatorio(String? valor, {String etiqueta = 'Este campo'}) {
  if (valor == null || valor.trim().isEmpty) {
    return '$etiqueta es obligatorio.';
  }
  return null;
}

/// Valida un número >= 0 (peso, volumen, valor unitario, coeficientes):
/// obligatorio si [requerido] es true, opcional (vacío permitido) en caso
/// contrario.
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

/// Valida un entero positivo (cantidad de un item de pedido).
String? validarEnteroPositivo(String? valor, {required String etiqueta}) {
  if (valor == null || valor.trim().isEmpty) {
    return '$etiqueta es obligatorio.';
  }
  final numero = int.tryParse(valor.trim());
  if (numero == null) return 'Debe ser un número entero.';
  if (numero <= 0) return 'Debe ser mayor a cero.';
  return null;
}
