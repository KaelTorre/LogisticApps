import 'dart:convert';
import 'dart:ui';

import 'constants.dart';
import '../data/models/deposito.dart';
import '../data/models/punto_entrega.dart';

/// Arma el link al visor de rutas propio (`visor-web/`), alojado en GitHub
/// Pages — sin el límite de 9/3 waypoints de un link de Google Maps (ver
/// CLAUDE.md sección 3.1). Los datos viajan codificados en el **fragmento**
/// de la URL (`#d=...`), nunca llegan a ningún servidor: la página los lee
/// en el navegador de quien la abre y le pide la geometría real a OSRM
/// directamente desde ahí.
///
/// [color] es el mismo color con el que esa ruta se ve en la pantalla de
/// Mapa (ya resuelto para el tema actual) — se manda como hex para que el
/// visor web dibuje la ruta con el color exacto que vio quien la compartió.
Uri construirUrlVisorWeb({
  required Deposito deposito,
  required List<PuntoEntrega> paradas,
  required Color color,
  String? vehiculoNombre,
}) {
  final datos = {
    'dep': [deposito.nombre, _redondear(deposito.latitud), _redondear(deposito.longitud)],
    'veh': ?vehiculoNombre,
    'color': _colorAHex(color),
    'paradas': paradas
        .map((p) => [p.nombre, _redondear(p.latitud), _redondear(p.longitud)])
        .toList(),
  };

  final codificado = base64Url.encode(utf8.encode(jsonEncode(datos)));
  return Uri.parse(visorWebBaseUrl).replace(fragment: 'd=$codificado');
}

String _colorAHex(Color color) {
  String canal(double valor) =>
      (valor * 255).round().clamp(0, 255).toRadixString(16).padLeft(2, '0');
  return '#${canal(color.r)}${canal(color.g)}${canal(color.b)}';
}

/// 6 decimales (~11 cm de precisión) alcanza de sobra y mantiene el link
/// corto.
double _redondear(double valor) => double.parse(valor.toStringAsFixed(6));
