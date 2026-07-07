/// Formatea [fecha] como `dd/MM/yyyy HH:mm` sin depender de `intl` (no es
/// una dependencia actual del proyecto, y un par de cadenas no lo justifica).
String formatearFecha(DateTime fecha) {
  String dosDigitos(int n) => n.toString().padLeft(2, '0');
  return '${dosDigitos(fecha.day)}/${dosDigitos(fecha.month)}/${fecha.year} '
      '${dosDigitos(fecha.hour)}:${dosDigitos(fecha.minute)}';
}

/// Formatea una duración como `1d 4h 32m`, omitiendo las unidades más
/// grandes que sean cero. Usado para mostrar cada etapa del TCP (§6.2).
String formatearDuracion(Duration duracion) {
  final dias = duracion.inDays;
  final horas = duracion.inHours.remainder(24);
  final minutos = duracion.inMinutes.remainder(60);
  final segundos = duracion.inSeconds.remainder(60);

  final partes = <String>[];
  if (dias > 0) partes.add('${dias}d');
  if (horas > 0 || dias > 0) partes.add('${horas}h');
  if (minutos > 0 || horas > 0 || dias > 0) partes.add('${minutos}m');
  if (partes.isEmpty) partes.add('${segundos}s');

  return partes.join(' ');
}
