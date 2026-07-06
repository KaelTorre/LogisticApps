/// Formatea [fecha] como `dd/MM/yyyy HH:mm` sin depender de `intl` (no es
/// una dependencia actual del proyecto, y una sola cadena no lo justifica).
String formatearFecha(DateTime fecha) {
  String dosDigitos(int n) => n.toString().padLeft(2, '0');
  return '${dosDigitos(fecha.day)}/${dosDigitos(fecha.month)}/${fecha.year} '
      '${dosDigitos(fecha.hour)}:${dosDigitos(fecha.minute)}';
}
