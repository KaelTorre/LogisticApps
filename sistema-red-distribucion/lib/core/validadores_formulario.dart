/// Validadores reutilizados por los formularios de Proyecto, Cliente, Sitio
/// candidato, Planta y Parámetros de costo.
///
/// [femenino] y [plural] existen para que el mensaje concuerde en género y
/// número con [etiqueta] ("La demanda anual es obligatoria", "Los pedidos
/// anuales son obligatorios") — sin esto, un campo femenino o plural queda
/// con un mensaje mal concordado ("La demanda anual es obligatorio").
String? validarObligatorio(
  String? valor, {
  String etiqueta = 'Este campo',
  bool femenino = false,
  bool plural = false,
}) {
  if (valor == null || valor.trim().isEmpty) {
    return '$etiqueta ${_esSon(plural)} ${_concordar('obligatorio', femenino: femenino, plural: plural)}.';
  }
  return null;
}

/// Valida un número >= 0 (demanda, capacidad, costo, tarifa): obligatorio
/// si [requerido] es true, opcional (vacío permitido) en caso contrario.
String? validarNumeroNoNegativo(
  String? valor, {
  required String etiqueta,
  bool requerido = true,
  bool femenino = false,
  bool plural = false,
}) {
  if (valor == null || valor.trim().isEmpty) {
    return requerido
        ? '$etiqueta ${_esSon(plural)} ${_concordar('obligatorio', femenino: femenino, plural: plural)}.'
        : null;
  }
  final numero = double.tryParse(valor.trim());
  if (numero == null) return 'Debe ser un número.';
  if (numero < 0) {
    return '$etiqueta no ${_puedenSer(plural)} ${_concordar('negativo', femenino: femenino, plural: plural)}.';
  }
  return null;
}

/// A diferencia de [validarNumeroNoNegativo], exige un número mayor que
/// cero — para campos donde cero rompería el cálculo en vez de solo
/// significar "sin dato" (factor de circuidad: se multiplica por la
/// distancia en línea recta, así que en cero anularía cualquier respaldo
/// sin red).
String? validarNumeroPositivo(
  String? valor, {
  required String etiqueta,
  bool requerido = true,
  bool femenino = false,
  bool plural = false,
}) {
  if (valor == null || valor.trim().isEmpty) {
    return requerido
        ? '$etiqueta ${_esSon(plural)} ${_concordar('obligatorio', femenino: femenino, plural: plural)}.'
        : null;
  }
  final numero = double.tryParse(valor.trim());
  if (numero == null) return 'Debe ser un número.';
  if (numero <= 0) return '$etiqueta ${_debenSer(plural)} mayor que cero.';
  return null;
}

/// Igual que [validarNumeroNoNegativo] pero exige un entero (pedidos
/// anuales, que sí pueden ser cero — un cliente todavía sin pedidos
/// registrados es válido, y queda marcado aparte en la auditoría).
String? validarEnteroNoNegativo(
  String? valor, {
  required String etiqueta,
  bool requerido = true,
  bool femenino = false,
  bool plural = false,
}) {
  if (valor == null || valor.trim().isEmpty) {
    return requerido
        ? '$etiqueta ${_esSon(plural)} ${_concordar('obligatorio', femenino: femenino, plural: plural)}.'
        : null;
  }
  final numero = int.tryParse(valor.trim());
  if (numero == null) return 'Debe ser un número entero.';
  if (numero < 0) {
    return '$etiqueta no ${_puedenSer(plural)} ${_concordar('negativo', femenino: femenino, plural: plural)}.';
  }
  return null;
}

/// A diferencia de [validarEnteroNoNegativo], exige un entero mayor que
/// cero — para campos donde cero no tiene sentido (horizonte del
/// proyecto en años).
String? validarEnteroPositivo(
  String? valor, {
  required String etiqueta,
  bool requerido = true,
  bool femenino = false,
  bool plural = false,
}) {
  if (valor == null || valor.trim().isEmpty) {
    return requerido
        ? '$etiqueta ${_esSon(plural)} ${_concordar('obligatorio', femenino: femenino, plural: plural)}.'
        : null;
  }
  final numero = int.tryParse(valor.trim());
  if (numero == null) return 'Debe ser un número entero.';
  if (numero <= 0) return '$etiqueta ${_debenSer(plural)} mayor que cero.';
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

String _esSon(bool plural) => plural ? 'son' : 'es';

String _puedenSer(bool plural) => plural ? 'pueden ser' : 'puede ser';

String _debenSer(bool plural) => plural ? 'deben ser' : 'debe ser';

/// Concuerda un adjetivo terminado en "-o" (obligatorio, negativo) en
/// género y número.
String _concordar(String masculinoSingular, {required bool femenino, required bool plural}) {
  final raiz = masculinoSingular.substring(0, masculinoSingular.length - 1);
  final terminacion = femenino ? 'a' : 'o';
  final sufijoPlural = plural ? 's' : '';
  return '$raiz$terminacion$sufijoPlural';
}
