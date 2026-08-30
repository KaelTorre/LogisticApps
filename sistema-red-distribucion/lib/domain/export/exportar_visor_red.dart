import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import '../../core/constantes.dart';

/// Un almacén abierto para el visor. A diferencia de `exportar_visor_web`
/// (que deriva el color de cada tramo por índice, con el mismo algoritmo
/// en Dart y en JS), acá el color de territorio **viaja ya calculado**
/// (`paleta_territorios.dart`, Fase 8) — el algoritmo que lo elige hace
/// varias pasadas de ΔE real contra todo lo ya usado (ver su doc comment),
/// y portarlo tal cual a JavaScript sin poder compartir código con Dart es
/// una fuente de bugs de sincronización que no vale la pena para una
/// paleta de a lo sumo un puñado de colores por escenario: es más simple y
/// más robusto mandarlos ya resueltos, y así el visor se ve exactamente
/// igual que la Pantalla 11.
class AlmacenParaVisor {
  const AlmacenParaVisor({
    required this.nombre,
    required this.latitud,
    required this.longitud,
    required this.color,
  });

  final String nombre;
  final double latitud;
  final double longitud;
  final Color color;
}

/// Una zona para el visor, con el índice del almacén de [AlmacenParaVisor]
/// que la sirve (`null` si quedó sin asignar — capacidad excedida en todos)
/// y si cumple el estándar de servicio, para que el visor la destaque
/// igual que la Pantalla 11.
class ZonaParaVisor {
  const ZonaParaVisor({
    required this.etiqueta,
    required this.latitud,
    required this.longitud,
    required this.indiceAlmacen,
    required this.cumpleEstandar,
  });

  final String etiqueta;
  final double latitud;
  final double longitud;
  final int? indiceAlmacen;
  final bool cumpleEstandar;
}

/// Límite práctico de longitud del enlace — por encima de esto, algunos
/// clientes de mensajería/navegadores lo truncan o lo rechazan. 8000
/// caracteres es un margen conservador para navegadores modernos (los
/// mismos que ya exige `DecompressionStream`, ver `visor-red/app.js`), muy
/// por debajo del límite real de la mayoría (~64 KB), pero sin acercarse a
/// los ~2000 caracteres de compatibilidad con IE, que este proyecto no
/// necesita.
const int limitePracticoUrlVisor = 8000;

/// Resultado de intentar armar el link: si los datos no entran dentro de
/// [limitePracticoUrlVisor], `uri` es `null` y `excedeLimite` es `true` —
/// **nunca se genera un enlace roto/truncado** (CLAUDE.md, Fase 8, Test W).
class ResultadoUrlVisor {
  const ResultadoUrlVisor({required this.uri, required this.excedeLimite, required this.longitudFragmento});

  final Uri? uri;
  final bool excedeLimite;
  final int longitudFragmento;
}

/// Arma el link al visor de red propio (`visor-red/`), alojado en GitHub
/// Pages — mismo patrón que `exportar_visor_web.dart` de
/// `sistema-optimizacion-rutas`: los datos viajan comprimidos (DEFLATE
/// crudo) y codificados en base64url en el **fragmento** de la URL
/// (`#z=...`), nunca llegan a ningún servidor.
ResultadoUrlVisor construirUrlVisorRed({
  required String nombreEscenario,
  required List<AlmacenParaVisor> almacenes,
  required List<ZonaParaVisor> zonas,
}) {
  final datos = {
    'esc': nombreEscenario,
    'alm': almacenes
        .map((a) => [a.nombre, _redondear(a.latitud), _redondear(a.longitud), _colorAHex(a.color)])
        .toList(),
    'zon': zonas
        .map(
          (z) => [
            z.etiqueta,
            _redondear(z.latitud),
            _redondear(z.longitud),
            z.indiceAlmacen,
            z.cumpleEstandar ? 1 : 0,
          ],
        )
        .toList(),
  };

  final comprimido = ZLibEncoder(raw: true, level: 9).convert(utf8.encode(jsonEncode(datos)));
  final codificado = base64Url.encode(comprimido);
  final fragmento = 'z=$codificado';

  if (fragmento.length > limitePracticoUrlVisor) {
    return ResultadoUrlVisor(uri: null, excedeLimite: true, longitudFragmento: fragmento.length);
  }

  final uri = Uri.parse(visorRedBaseUrl).replace(fragment: fragmento);
  return ResultadoUrlVisor(uri: uri, excedeLimite: false, longitudFragmento: fragmento.length);
}

/// 6 decimales (~11 cm de precisión) alcanza de sobra y mantiene el link
/// corto — mismo criterio que `exportar_visor_web.dart`.
double _redondear(double valor) => double.parse(valor.toStringAsFixed(6));

String _colorAHex(Color color) {
  String canal(double valor) => (valor * 255).round().clamp(0, 255).toRadixString(16).padLeft(2, '0');
  return '#${canal(color.r)}${canal(color.g)}${canal(color.b)}';
}
