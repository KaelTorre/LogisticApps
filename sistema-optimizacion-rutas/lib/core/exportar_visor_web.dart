import 'dart:convert';

import 'constants.dart';
import '../data/models/deposito.dart';
import '../data/models/punto_entrega.dart';

/// Arma el link al visor de rutas propio (`visor-web/`), alojado en GitHub
/// Pages — sin el límite de 9/3 waypoints de un link de Google Maps (ver
/// CLAUDE.md sección 3.1). Los datos viajan codificados en el **fragmento**
/// de la URL (`#d=...`), nunca llegan a ningún servidor: la página los lee
/// en el navegador de quien la abre y le pide la geometría real a OSRM
/// directamente desde ahí.
Uri construirUrlVisorWeb({
  required Deposito deposito,
  required List<PuntoEntrega> paradas,
  String? vehiculoNombre,
}) {
  final datos = {
    'dep': [deposito.nombre, _redondear(deposito.latitud), _redondear(deposito.longitud)],
    'veh': ?vehiculoNombre,
    'paradas': paradas
        .map((p) => [p.nombre, _redondear(p.latitud), _redondear(p.longitud)])
        .toList(),
  };

  final codificado = base64Url.encode(utf8.encode(jsonEncode(datos)));
  return Uri.parse(visorWebBaseUrl).replace(fragment: 'd=$codificado');
}

/// 6 decimales (~11 cm de precisión) alcanza de sobra y mantiene el link
/// corto.
double _redondear(double valor) => double.parse(valor.toStringAsFixed(6));
