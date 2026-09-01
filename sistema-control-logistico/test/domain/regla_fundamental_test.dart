import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// La regla fundamental del proyecto (CLAUDE.md sección 4, [REGLA]): "El
/// periodo es un dato, no el reloj del sistema." El motor de evaluación
/// (`lib/domain/motor/`) jamás invoca `DateTime.now()` para decidir en qué
/// periodo está o qué serie evaluar -- eso es lo que permite cargar treinta
/// y seis periodos de historia y procesarlos en segundos, y lo que habilita
/// el reloj de simulación (Fase 7) y el contraste retrospectivo (Fase 6).
///
/// Este test lee el código fuente de cada archivo en `lib/domain/motor/` y
/// falla si encuentra la cadena `DateTime.now()`. Se introduce en la Fase 1
/// (todavía sin módulos, así que hoy pasa trivialmente) y se mantiene sin
/// tocar hasta el final del proyecto (CLAUDE.md sección 10, Fase 1).
void main() {
  test('lib/domain/motor/ nunca usa DateTime.now()', () {
    final directorio = Directory('lib/domain/motor');
    if (!directorio.existsSync()) {
      // Todavía no hay ningún módulo -- cumple por definición.
      return;
    }

    final archivosConViolacion = <String>[];
    for (final entidad in directorio.listSync(recursive: true)) {
      if (entidad is! File || !entidad.path.endsWith('.dart')) continue;
      final contenido = entidad.readAsStringSync();
      if (contenido.contains('DateTime.now()')) {
        archivosConViolacion.add(entidad.path);
      }
    }

    expect(
      archivosConViolacion,
      isEmpty,
      reason:
          'CLAUDE.md sección 4, [REGLA]: el motor nunca decide el periodo '
          'con el reloj del sistema. Encontrado en: $archivosConViolacion',
    );
  });
}
