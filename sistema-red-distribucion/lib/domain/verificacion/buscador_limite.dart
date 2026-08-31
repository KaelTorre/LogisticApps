/// Búsqueda del máximo `n` para el que `probar(n)` sigue devolviendo `true`
/// — separada del script `tool/verificar_limite_osrm.dart` para poder
/// testearla sin red real (CLAUDE.md sección 9, Fase 3): crece
/// exponencialmente hasta encontrar un `n` que falla, y después acota el
/// límite exacto por búsqueda binaria entre el último éxito y el primer
/// fallo. `probar` puede tardar (una petición HTTP real), así que se llama
/// el mínimo de veces posible: O(log n) llamadas en total.
///
/// Si `probar` nunca falla hasta [maximoAbsoluto], devuelve
/// [maximoAbsoluto] (límite no encontrado dentro del techo razonable que
/// puso quien llama).
Future<int> buscarMaximoAceptado({
  required Future<bool> Function(int n) probar,
  int inicio = 10,
  int maximoAbsoluto = 2000,
}) async {
  var ultimoExitoso = 0;
  var n = inicio;

  while (n <= maximoAbsoluto) {
    final aceptado = await probar(n);
    if (!aceptado) break;
    ultimoExitoso = n;
    if (n == maximoAbsoluto) return ultimoExitoso;
    n = (n * 2).clamp(0, maximoAbsoluto);
  }

  if (ultimoExitoso == 0) {
    // Ni siquiera `inicio` funcionó — no hay límite útil que reportar.
    return 0;
  }

  // Búsqueda binaria entre [ultimoExitoso] (aceptado) y [n] (rechazado).
  var bajo = ultimoExitoso;
  var alto = n;
  while (alto - bajo > 1) {
    final medio = bajo + ((alto - bajo) ~/ 2);
    final aceptado = await probar(medio);
    if (aceptado) {
      bajo = medio;
    } else {
      alto = medio;
    }
  }
  return bajo;
}
