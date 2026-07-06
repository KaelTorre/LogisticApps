import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_optimizacion_rutas/core/exportar_visor_web.dart';
import 'package:sistema_optimizacion_rutas/data/models/deposito.dart';
import 'package:sistema_optimizacion_rutas/data/models/punto_entrega.dart';

const _deposito = Deposito(
  nombre: 'Oficina',
  latitud: -8.375482,
  longitud: -74.556342,
);

const _colorDePrueba = Color(0xFF1BAF7A);

/// Espejo de `visor-web/app.js`'s `inflateRaw` + decode, para verificar acá
/// (sin navegador) que lo que arma `construirUrlVisorWeb` es exactamente lo
/// que el visor web va a poder leer.
Map<String, dynamic> _decodificarFragmentoZ(String fragmento) {
  final codificado = fragmento.substring('z='.length);
  final comprimido = base64Url.decode(codificado);
  final json = utf8.decode(ZLibDecoder(raw: true).convert(comprimido));
  return jsonDecode(json) as Map<String, dynamic>;
}

void main() {
  test('arma la URL sobre visorWebBaseUrl, con los datos comprimidos en el fragmento', () {
    final uri = construirUrlVisorWeb(
      deposito: _deposito,
      color: _colorDePrueba,
      paradas: const [
        PuntoEntrega(nombre: 'A', latitud: -8.39, longitud: -74.57),
      ],
    );

    expect(uri.toString(), startsWith('https://kaeltorre.github.io/'));
    expect(uri.query, isEmpty, reason: 'los datos van en el fragmento, no en la query');
    expect(uri.fragment, startsWith('z='));
  });

  test('el fragmento decodifica de vuelta a depósito + paradas + vehículo + color', () {
    final uri = construirUrlVisorWeb(
      deposito: _deposito,
      color: _colorDePrueba,
      vehiculoNombre: 'Camión Reparto 1',
      paradas: const [
        PuntoEntrega(nombre: 'Universidad Nacional', latitud: -8.39, longitud: -74.57),
        PuntoEntrega(nombre: 'Puerto', latitud: -8.38, longitud: -74.52),
      ],
    );

    final datos = _decodificarFragmentoZ(uri.fragment);

    expect(datos['dep'], ['Oficina', -8.375482, -74.556342]);
    expect(datos['veh'], 'Camión Reparto 1');
    expect(datos['color'], '#1baf7a');
    expect(datos['paradas'], [
      ['Universidad Nacional', -8.39, -74.57],
      ['Puerto', -8.38, -74.52],
    ]);
  });

  test('sin nombre de vehículo, la clave "veh" no aparece', () {
    final uri = construirUrlVisorWeb(
      deposito: _deposito,
      color: _colorDePrueba,
      paradas: const [],
    );
    final datos = _decodificarFragmentoZ(uri.fragment);

    expect(datos.containsKey('veh'), isFalse);
  });

  test('el link comprimido es más corto que el equivalente sin comprimir', () {
    final paradas = List.generate(
      19,
      (i) => PuntoEntrega(
        nombre: 'Punto de entrega número $i con un nombre bien largo',
        latitud: -8.3 - i * 0.001,
        longitud: -74.5 - i * 0.001,
      ),
    );
    final uri = construirUrlVisorWeb(
      deposito: _deposito,
      color: _colorDePrueba,
      vehiculoNombre: 'Camión Reparto 1',
      paradas: paradas,
    );

    final datos = _decodificarFragmentoZ(uri.fragment);
    final sinComprimir = base64Url.encode(
      utf8.encode(jsonEncode(datos)),
    );

    expect(uri.fragment.length, lessThan(sinComprimir.length));
  });
}
