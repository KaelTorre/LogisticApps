import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_red_distribucion/domain/export/exportar_visor_red.dart';

/// Espejo de `visor-red/app.js`'s `inflateRaw` + decode, para verificar acá
/// (sin navegador) que lo que arma `construirUrlVisorRed` es exactamente
/// lo que el visor va a poder leer — mismo patrón que
/// `exportar_visor_web_test.dart` de `sistema-optimizacion-rutas`.
Map<String, dynamic> _decodificarFragmentoZ(String fragmento) {
  final codificado = fragmento.substring('z='.length);
  final comprimido = base64Url.decode(codificado);
  final json = utf8.decode(ZLibDecoder(raw: true).convert(comprimido));
  return jsonDecode(json) as Map<String, dynamic>;
}

void main() {
  test('arma la URL sobre visorRedBaseUrl, con los datos comprimidos en el fragmento', () {
    final resultado = construirUrlVisorRed(
      nombreEscenario: 'Barrido óptimo',
      almacenes: const [AlmacenParaVisor(nombre: 'C1', latitud: -8.37, longitud: -74.55, color: Color(0xFF1BAF7A))],
      zonas: const [
        ZonaParaVisor(
          etiqueta: 'Z1',
          latitud: -8.39,
          longitud: -74.57,
          indiceAlmacen: 0,
          cumpleEstandar: true,
        ),
      ],
    );

    expect(resultado.excedeLimite, isFalse);
    expect(resultado.uri, isNotNull);
    expect(resultado.uri!.toString(), startsWith('https://kaeltorre.github.io/'));
    expect(resultado.uri!.query, isEmpty, reason: 'los datos van en el fragmento, no en la query');
    expect(resultado.uri!.fragment, startsWith('z='));
  });

  test(
    'Test V — la carga útil codificada y luego decodificada devuelve exactamente '
    'los mismos almacenes y asignaciones',
    () {
      const almacenes = [
        AlmacenParaVisor(nombre: 'Almacén Norte', latitud: -8.37, longitud: -74.55, color: Color(0xFF1BAF7A)),
        AlmacenParaVisor(nombre: 'Almacén Sur', latitud: -8.42, longitud: -74.60, color: Color(0xFFEDA100)),
      ];
      const zonas = [
        ZonaParaVisor(
          etiqueta: 'Zona 1',
          latitud: -8.38,
          longitud: -74.56,
          indiceAlmacen: 0,
          cumpleEstandar: true,
        ),
        ZonaParaVisor(
          etiqueta: 'Zona 2',
          latitud: -8.41,
          longitud: -74.59,
          indiceAlmacen: 1,
          cumpleEstandar: false,
        ),
        ZonaParaVisor(
          etiqueta: 'Zona 3 sin capacidad',
          latitud: -8.50,
          longitud: -74.70,
          indiceAlmacen: null,
          cumpleEstandar: false,
        ),
      ];

      final resultado = construirUrlVisorRed(
        nombreEscenario: 'Escenario de prueba',
        almacenes: almacenes,
        zonas: zonas,
      );

      final datos = _decodificarFragmentoZ(resultado.uri!.fragment);

      expect(datos['esc'], 'Escenario de prueba');
      expect(datos['alm'], [
        ['Almacén Norte', -8.37, -74.55, '#1baf7a'],
        ['Almacén Sur', -8.42, -74.60, '#eda100'],
      ]);
      expect(datos['zon'], [
        ['Zona 1', -8.38, -74.56, 0, 1],
        ['Zona 2', -8.41, -74.59, 1, 0],
        ['Zona 3 sin capacidad', -8.50, -74.70, null, 0],
      ]);
    },
  );

  test(
    'Test W — treinta zonas producen un enlace por debajo del límite práctico',
    () {
      final almacenes = List.generate(
        5,
        (i) => AlmacenParaVisor(nombre: 'Almacén $i', latitud: -8.0 - i * 0.1, longitud: -74.0 - i * 0.1, color: const Color(0xFF1BAF7A)),
      );
      final zonas = List.generate(
        30,
        (i) => ZonaParaVisor(
          etiqueta: 'Zona número $i',
          latitud: -8.0 - i * 0.01,
          longitud: -74.0 - i * 0.01,
          indiceAlmacen: i % 5,
          cumpleEstandar: i % 3 != 0,
        ),
      );

      final resultado = construirUrlVisorRed(
        nombreEscenario: 'Caso de treinta zonas',
        almacenes: almacenes,
        zonas: zonas,
      );

      expect(resultado.excedeLimite, isFalse);
      expect(resultado.uri, isNotNull);
      expect(resultado.longitudFragmento, lessThan(limitePracticoUrlVisor));
    },
  );

  test(
    'Test W — si el caso excede el límite práctico, el sistema avisa en vez de '
    'generar un enlace roto',
    () {
      final almacenes = List.generate(
        5,
        (i) => AlmacenParaVisor(nombre: 'Almacén $i', latitud: -8.0 - i * 0.1, longitud: -74.0 - i * 0.1, color: const Color(0xFF1BAF7A)),
      );
      // Muchas zonas con nombres largos — a propósito, para forzar que el
      // fragmento comprimido supere el límite práctico.
      final zonasEnormes = List.generate(
        2000,
        (i) => ZonaParaVisor(
          etiqueta: 'Zona con un nombre bastante largo para inflar el payload número $i',
          latitud: -8.0 - i * 0.0001,
          longitud: -74.0 - i * 0.0001,
          indiceAlmacen: i % 5,
          cumpleEstandar: true,
        ),
      );

      final resultado = construirUrlVisorRed(
        nombreEscenario: 'Caso enorme',
        almacenes: almacenes,
        zonas: zonasEnormes,
      );

      expect(resultado.excedeLimite, isTrue);
      expect(resultado.uri, isNull);
    },
  );
}
