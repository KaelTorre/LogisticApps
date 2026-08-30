// Fase 3 (CLAUDE.md sección 9): "No asumas el valor del límite [de
// coordenadas por consulta al servicio `table` de OSRM]. Se verifica
// empíricamente con una consulta de prueba creciente y el valor confirmado
// se documenta en docs/limites_osrm.md y se codifica como constante
// maxCoordenadasPorConsulta."
//
// Uso:
//   dart run tool/verificar_limite_osrm.dart
//
// Hace peticiones reales al servidor demo público de OSRM
// (router.project-osrm.org), respetando el mismo espaciado de ~1 req/seg
// que usa OsrmClient (paquete_geo_logistica) — es un servicio compartido
// sin SLA, no hay que abusarlo. Usa búsqueda exponencial + binaria
// (`buscarMaximoAceptado`), así que son ~15-20 peticiones en total, no una
// por cada valor posible.
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
// Import directo del archivo (no el barrel `paquete_geo_logistica.dart`):
// el barrel re-exporta `selector_ubicacion_screen.dart`, que depende de
// Flutter (`dart:ui`) y este script corre en la VM de Dart pura
// (`dart run`, sin `flutter`), no en un engine de Flutter.
import 'package:paquete_geo_logistica/src/ruteo/constantes_osrm.dart';
import 'package:sistema_red_distribucion/domain/verificacion/buscador_limite.dart';

/// Valor conservador (CLAUDE.md sección 5.3b) si la verificación real no es
/// concluyente — ej. sin conexión, o el servicio limitando peticiones de
/// forma persistente incluso con reintentos.
const _valorConservador = 80;

/// Centro de referencia para generar coordenadas de prueba (Pucallpa, Perú
/// — mismo punto que usa el resto del repositorio). Cada coordenada de
/// prueba se separa ligeramente de la anterior para que sea una consulta
/// realista (evita que OSRM las trate como un único punto degenerado).
const _latBase = -8.375482;
const _lonBase = -74.556342;
const _pasoGrados = 0.002;

Future<void> main() async {
  final httpClient = http.Client();
  final bitacora = StringBuffer();

  void log(String linea) {
    stdout.writeln(linea);
    bitacora.writeln(linea);
  }

  log('Verificando el límite de coordenadas del servicio /table de OSRM...');
  log('Servidor: $osrmBaseUrl');
  log('');

  var peticionesRealizadas = 0;
  var inconcluso = false;
  String? motivoInconcluso;

  Future<bool> probar(int n) async {
    peticionesRealizadas++;
    final coords = List.generate(
      n,
      (i) => '${_lonBase + i * _pasoGrados},${_latBase + i * _pasoGrados}',
    ).join(';');
    final uri = Uri.parse('$osrmBaseUrl/table/v1/driving/$coords?annotations=distance');

    for (var intento = 0; intento < 3; intento++) {
      http.Response respuesta;
      try {
        respuesta = await httpClient.get(uri).timeout(const Duration(seconds: 30));
      } catch (e) {
        log('  n=$n: fallo de red ($e), no concluyente.');
        inconcluso = true;
        motivoInconcluso = 'fallo de red: $e';
        return false;
      }

      if (respuesta.statusCode == 429) {
        log('  n=$n: HTTP 429 (rate limited), reintentando tras espera...');
        await Future.delayed(Duration(seconds: 3 * (intento + 1)));
        continue;
      }

      // Espaciado entre peticiones nuevas (no cacheadas) — mismo criterio
      // que OsrmClient del paquete compartido.
      await Future.delayed(osrmThrottleInterval);

      if (respuesta.statusCode != 200) {
        log('  n=$n: HTTP ${respuesta.statusCode} -> rechazado.');
        return false;
      }

      final decodificado = jsonDecode(respuesta.body) as Map<String, dynamic>;
      final aceptado = decodificado['code'] == 'Ok';
      log('  n=$n: code=${decodificado['code']} -> ${aceptado ? 'aceptado' : 'rechazado'}.');
      return aceptado;
    }

    log('  n=$n: 429 persistente tras reintentos, no concluyente.');
    inconcluso = true;
    motivoInconcluso = '429 persistente tras reintentos';
    return false;
  }

  final maximoEncontrado = await buscarMaximoAceptado(probar: probar);
  httpClient.close();

  log('');
  log('Peticiones realizadas: $peticionesRealizadas');

  final int valorFinal;
  final String fuente;
  if (inconcluso && maximoEncontrado < _valorConservador) {
    valorFinal = _valorConservador;
    fuente = 'valor conservador (verificación no concluyente: $motivoInconcluso)';
    log('Verificación no concluyente ($motivoInconcluso) — se usa el valor '
        'conservador de $_valorConservador.');
  } else {
    valorFinal = maximoEncontrado;
    fuente = 'verificado empíricamente contra $osrmBaseUrl';
    log('Máximo de coordenadas aceptado en una sola consulta: $maximoEncontrado');
  }

  final fecha = DateTime.now().toIso8601String();
  final documento =
      '''
# Límite de coordenadas del servicio /table de OSRM

**maxCoordenadasPorConsulta = $valorFinal**

- Fuente: $fuente.
- Servidor probado: `$osrmBaseUrl`.
- Método: búsqueda exponencial + binaria sobre el número de coordenadas
  enviadas a `GET /table/v1/driving/...`, hasta encontrar el punto exacto
  donde el servicio deja de responder `code: "Ok"`.
- Verificado el: $fecha.
- Peticiones realizadas en la verificación: $peticionesRealizadas.

Este valor es del servicio demo **público** de OSRM, sin acuerdo de nivel de
servicio — puede cambiar si el operador ajusta sus límites. Si se vuelve a
correr `dart run tool/verificar_limite_osrm.dart` y el número sale distinto,
actualizar `maxCoordenadasPorConsulta` en `lib/core/constantes.dart` y este
archivo juntos.

## Bitácora de la verificación

```
${bitacora.toString().trimRight()}
```
''';

  final archivoDoc = File('docs/limites_osrm.md');
  await archivoDoc.writeAsString(documento);
  log('');
  log('Documentado en ${archivoDoc.path}');
}
