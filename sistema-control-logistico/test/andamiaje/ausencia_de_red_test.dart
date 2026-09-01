import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// CLAUDE.md sección 3 y 5: "Funciona sin internet. Sin excepciones." y
/// "No se agrega `http`, ni ningún paquete de red." Este test lee
/// `pubspec.yaml` directamente (sin agregar un parser YAML solo para esto:
/// el formato de las secciones `dependencies`/`dev_dependencies` es fijo,
/// dos espacios de indentación, una dependencia por línea) y falla si
/// aparece cualquier paquete conocido de red como dependencia directa.
void main() {
  test('pubspec.yaml no declara ningún paquete de red', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();

    final paquetesDeRed = [
      'http',
      'dio',
      'http_client',
      'cupertino_http',
      'chopper',
      'cronet_http',
      'cookie_jar',
      'web_socket_channel',
      'grpc',
      'connectivity_plus',
    ];

    for (final linea in pubspec.split('\n')) {
      final sinComentario = linea.split('#').first;
      final coincidencia = RegExp(r'^\s{2}([a-zA-Z0-9_]+):').firstMatch(sinComentario);
      if (coincidencia == null) continue;
      final nombrePaquete = coincidencia.group(1);
      expect(
        paquetesDeRed.contains(nombrePaquete),
        isFalse,
        reason:
            '"$nombrePaquete" es un paquete de red — CLAUDE.md sección 5 lo '
            'prohíbe explícitamente. Este sistema no consulta ninguna red, nunca.',
      );
    }
  });
}
