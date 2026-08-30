/// Validadores reutilizados por los formularios de Proyecto, Cliente, Sitio
/// candidato, Planta y Parámetros de costo.
String? validarObligatorio(String? valor, {String etiqueta = 'Este campo'}) {
  if (valor == null || valor.trim().isEmpty) {
    return '$etiqueta es obligatorio.';
  }
  return null;
}

/// Valida un número >= 0 (demanda, capacidad, costo, tarifa): obligatorio
/// si [requerido] es true, opcional (vacío permitido) en caso contrario.
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

/// Igual que [validarNumeroNoNegativo] pero exige un entero (pedidos
/// anuales, horizonte en años).
String? validarEnteroNoNegativo(
  String? valor, {
  required String etiqueta,
  bool requerido = true,
}) {
  if (valor == null || valor.trim().isEmpty) {
    return requerido ? '$etiqueta es obligatorio.' : null;
  }
  final numero = int.tryParse(valor.trim());
  if (numero == null) return 'Debe ser un número entero.';
  if (numero < 0) return 'No puede ser negativo.';
  return null;
}

/// A diferencia de `sistema-optimizacion-rutas` (donde la coordenada solo
/// se elige tocando el mapa, así que siempre queda en rango por
/// construcción), acá el campo de latitud/longitud también se puede
/// escribir a mano — CLAUDE.md pide explícitamente rechazar valores fuera
/// de rango en el formulario.
String? validarLatitud(String? valor) {
  if (valor == null || valor.trim().isEmpty) return 'La latitud es obligatoria.';
  final numero = double.tryParse(valor.trim());
  if (numero == null) return 'Debe ser un número.';
  if (numero < -90 || numero > 90) return 'Debe estar entre -90 y 90.';
  return null;
}

String? validarLongitud(String? valor) {
  if (valor == null || valor.trim().isEmpty) return 'La longitud es obligatoria.';
  final numero = double.tryParse(valor.trim());
  if (numero == null) return 'Debe ser un número.';
  if (numero < -180 || numero > 180) return 'Debe estar entre -180 y 180.';
  return null;
}
