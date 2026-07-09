import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import '../../core/constants.dart';
import '../local/database.dart';
import 'osrm_models.dart';

/// Coordenada simple para armar consultas a OSRM (latitud/longitud), sin
/// acoplar el cliente a los modelos de dominio (`Deposito`/`PuntoEntrega`).
class OsrmCoordenada {
  const OsrmCoordenada({required this.lat, required this.lon});

  final double lat;
  final double lon;
}

/// Error de dominio para fallos de OSRM (red, rate limit, o `code` distinto
/// de `"Ok"`). El mensaje ya está listo para mostrarse al usuario tal cual
/// (sección 6.3 y 11 de CLAUDE.md: nunca un crash genérico).
class OsrmException implements Exception {
  const OsrmException(this.mensaje);

  final String mensaje;

  @override
  String toString() => mensaje;
}

enum _TipoConsultaOsrm {
  matriz('matriz'),
  ruta('ruta');

  const _TipoConsultaOsrm(this.valor);

  final String valor;
}

/// Cliente HTTP para el servidor demo público de OSRM
/// (`router.project-osrm.org`). Implementa, en este orden, lo exigido por
/// CLAUDE.md sección 6.3:
///
/// 1. Toda consulta revisa primero `cache_osrm` antes de considerar la red.
/// 2. Las peticiones nuevas pasan por una cola con ~1 seg de espaciado.
/// 3. Un `429` se reintenta con backoff en vez de fallar de inmediato.
/// 4. `code != "Ok"` (ej. `NoRoute`) y los fallos de red lanzan
///    [OsrmException] con un mensaje específico, no un error genérico.
class OsrmClient {
  OsrmClient({required AppDatabase database, http.Client? httpClient})
    // ignore: prefer_initializing_formals
    : _database = database,
      _httpClient = httpClient ?? http.Client();

  final AppDatabase _database;
  final http.Client _httpClient;

  DateTime? _ultimaLlamada;
  Future<void> _colaPeticiones = Future.value();

  /// Matriz de distancias/tiempos entre `coordenadas`. Por convención del
  /// proyecto, `coordenadas[0]` debe ser el depósito.
  Future<OsrmTableResponse> obtenerMatriz(
    List<OsrmCoordenada> coordenadas,
  ) async {
    final json = await _consultarConCache(
      tipo: _TipoConsultaOsrm.matriz,
      coordenadas: coordenadas,
      construirUri: (coordsStr) => Uri.parse(
        '$osrmBaseUrl/table/v1/driving/$coordsStr'
        '?annotations=distance,duration',
      ),
    );
    final respuesta = OsrmTableResponse.fromJson(json);
    _verificarCodigo(respuesta.code);
    return respuesta;
  }

  /// Geometría real de la ruta que recorre `coordenadas` en ese orden.
  Future<OsrmRouteResponse> obtenerRuta(
    List<OsrmCoordenada> coordenadas,
  ) async {
    final json = await _consultarConCache(
      tipo: _TipoConsultaOsrm.ruta,
      coordenadas: coordenadas,
      construirUri: (coordsStr) => Uri.parse(
        '$osrmBaseUrl/route/v1/driving/$coordsStr'
        '?overview=full&geometries=polyline',
      ),
    );
    final respuesta = OsrmRouteResponse.fromJson(json);
    _verificarCodigo(respuesta.code);
    return respuesta;
  }

  void _verificarCodigo(String code) {
    if (code == 'Ok') return;
    if (code == 'NoRoute') {
      throw const OsrmException(
        'OSRM no encontró una ruta entre los puntos indicados. '
        'Verifica que las coordenadas estén dentro de una zona con '
        'cobertura de calles en OpenStreetMap.',
      );
    }
    throw OsrmException('OSRM respondió con un error: $code');
  }

  Future<Map<String, dynamic>> _consultarConCache({
    required _TipoConsultaOsrm tipo,
    required List<OsrmCoordenada> coordenadas,
    required Uri Function(String coordsStr) construirUri,
  }) async {
    final hash = _hashConsulta(tipo, coordenadas);

    final cacheado =
        await (_database.select(_database.cacheOsrmTable)
              ..where((t) => t.hashConsulta.equals(hash)))
            .getSingleOrNull();
    if (cacheado != null) {
      return jsonDecode(cacheado.respuestaJson) as Map<String, dynamic>;
    }

    // OSRM usa el orden longitud,latitud en la URL — invertido respecto a
    // la convención habitual lat/lon. Ver CLAUDE.md sección 6.1.
    final coordsStr = coordenadas.map((c) => '${c.lon},${c.lat}').join(';');
    final cuerpo = await _peticionConThrottling(construirUri(coordsStr));

    await _database
        .into(_database.cacheOsrmTable)
        .insert(
          CacheOsrmTableCompanion.insert(
            hashConsulta: hash,
            tipo: tipo.valor,
            respuestaJson: cuerpo,
            fechaConsulta: DateTime.now().toIso8601String(),
          ),
        );

    return jsonDecode(cuerpo) as Map<String, dynamic>;
  }

  /// Encadena esta petición tras la anterior para que, sin importar cuántas
  /// consultas se disparen "en paralelo" desde la UI, a la red solo llegue
  /// una cada [osrmThrottleInterval] como mínimo.
  Future<String> _peticionConThrottling(Uri uri) {
    final resultado = _colaPeticiones.then((_) async {
      await _esperarTurno();
      return _ejecutarConReintento(uri);
    });
    // Ignorar el error aquí: solo nos interesa encadenar el turno, el error
    // real se propaga a quien sí espera `resultado`.
    _colaPeticiones = resultado.then((_) {}, onError: (_) {});
    return resultado;
  }

  Future<void> _esperarTurno() async {
    final ultima = _ultimaLlamada;
    if (ultima != null) {
      final transcurrido = DateTime.now().difference(ultima);
      if (transcurrido < osrmThrottleInterval) {
        await Future.delayed(osrmThrottleInterval - transcurrido);
      }
    }
    _ultimaLlamada = DateTime.now();
  }

  Future<String> _ejecutarConReintento(Uri uri, {int intento = 0}) async {
    const maxReintentos = 3;
    http.Response respuesta;
    try {
      respuesta = await _httpClient.get(uri).timeout(
        const Duration(seconds: 15),
      );
    } catch (e) {
      // Nota de diagnóstico: se agrega el tipo/mensaje real de la excepción
      // (SocketException, HandshakeException, TimeoutException, etc.) al
      // final del mensaje. Antes se descartaba por completo con `catch (_)`,
      // así que un fallo de certificado TLS o de proxy se mostraba
      // exactamente igual que no tener internet, sin forma de distinguirlos.
      throw OsrmException(
        'No se pudo conectar con OSRM. Se requiere conexión a internet '
        'para esta consulta; si ya la hiciste antes, revisa si hay una '
        'respuesta guardada en la caché local.\n\n'
        'Detalle técnico: ${e.runtimeType}: $e',
      );
    }

    if (respuesta.statusCode == 429) {
      if (intento >= maxReintentos) {
        throw const OsrmException(
          'OSRM está limitando las peticiones (código 429) y se agotaron '
          'los reintentos. Intenta de nuevo en unos minutos.',
        );
      }
      await Future.delayed(osrmThrottleInterval * (intento + 2));
      return _ejecutarConReintento(uri, intento: intento + 1);
    }

    if (respuesta.statusCode != 200) {
      throw OsrmException(
        'OSRM respondió con código HTTP ${respuesta.statusCode}.',
      );
    }

    return respuesta.body;
  }

  String _hashConsulta(
    _TipoConsultaOsrm tipo,
    List<OsrmCoordenada> coordenadas,
  ) {
    final clave = [
      tipo.valor,
      ...coordenadas.map((c) => '${c.lat},${c.lon}'),
    ].join('|');
    return sha256.convert(utf8.encode(clave)).toString();
  }

  void dispose() => _httpClient.close();
}
