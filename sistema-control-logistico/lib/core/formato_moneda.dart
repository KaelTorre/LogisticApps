/// Símbolos de las monedas más comunes en la región; cualquier otro
/// código de moneda que el usuario escriba en el formulario de
/// organización se muestra tal cual, después del monto.
const _simbolosMoneda = {
  'PEN': 'S/',
  'USD': r'US$',
  'EUR': '€',
  'BOB': 'Bs',
  'COP': r'COL$',
  'CLP': r'CLP$',
  'MXN': r'MX$',
  'ARS': r'AR$',
};

/// Da formato a un monto en la moneda de la organización, siempre con dos
/// decimales -- misma presentación en toda la aplicación, ya sea con el
/// símbolo de una moneda conocida ("S/ 8.94") o con el código tal cual lo
/// escribió el usuario ("8.94 XYZ").
String formatearMoneda(num valor, String moneda) {
  final montoFormateado = valor.toStringAsFixed(2);
  final simbolo = simboloMoneda(moneda);
  return simbolo == null ? '$montoFormateado $moneda' : '$simbolo $montoFormateado';
}

/// El símbolo de una moneda conocida (para usar como prefijo de un campo
/// de formulario, por ejemplo) -- `null` si el código no está en la lista,
/// para que quien lo use decida cómo mostrar el código tal cual.
String? simboloMoneda(String moneda) => _simbolosMoneda[moneda.toUpperCase()];
