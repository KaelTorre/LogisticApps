/// Convierte un monto escrito por el usuario en la moneda del proyecto
/// (ej. "1234.56") a céntimos enteros (123456) — invariante monetaria de
/// CLAUDE.md sección 6. Usado por los formularios de Sitio candidato,
/// Planta y Parámetros de costo.
int aCentimos(String texto) => (double.parse(texto.trim()) * 100).round();

/// Inverso de [aCentimos], para precargar un formulario de edición con el
/// valor guardado.
String centimosATexto(int centimos) => (centimos / 100).toStringAsFixed(2);
