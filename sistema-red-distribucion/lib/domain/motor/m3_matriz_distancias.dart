import 'package:paquete_geo_logistica/paquete_geo_logistica.dart';

import '../../data/models/celda_matriz.dart';

/// Un origen de la matriz — sitio candidato o planta.
class OrigenMatriz {
  const OrigenMatriz({
    required this.tipo, // planta | candidato
    required this.id,
    required this.latitud,
    required this.longitud,
  });

  final String tipo;
  final int id;
  final double latitud;
  final double longitud;
}

/// Un destino de la matriz — una zona de demanda (uso original de la
/// Fase 4), o un sitio candidato (Fase 5: M4 necesita la distancia
/// planta→almacén para el rubro de transporte de entrada, que la matriz de
/// la Fase 4 no cubría porque solo conectaba orígenes con zonas). Mismo
/// motor de troceado/caché de `construirMatriz` para ambos casos — la
/// tabla `celda_matriz` ya declaraba `tipoDestino` genérico para esto (ver
/// comentario de `CeldaMatrizTable`).
class DestinoMatriz {
  const DestinoMatriz({
    required this.id,
    required this.latitud,
    required this.longitud,
    this.tipo = 'zona',
  });

  final int id;
  final double latitud;
  final double longitud;
  final String tipo;
}

/// Progreso de `construirMatriz`, para que la Pantalla 9 muestre bloques
/// completados y una estimación de tiempo (CLAUDE.md sección 7, `[REGLA]`:
/// "nunca una pantalla congelada sin retroalimentación").
class ProgresoMatriz {
  const ProgresoMatriz({
    required this.bloquesCompletados,
    required this.bloquesTotales,
    required this.tiempoRestanteEstimado,
  });

  final int bloquesCompletados;
  final int bloquesTotales;
  final Duration tiempoRestanteEstimado;
}

/// M3 — matriz de distancias (CLAUDE.md sección 7). Función de orquestación
/// **pura respecto a la base de datos**: no escribe nada, solo calcula las
/// celdas que faltan y las devuelve — quien llama las persiste (una sola
/// vez, con `CeldaMatrizRepository.insertarTodas`) solo si esta función
/// termina con éxito. Así se garantiza que un error nunca deja "una matriz
/// a medias guardada" (`[REGLA]`, pruebas de la Fase 4): si algo falla acá
/// dentro, la excepción se propaga antes de devolver nada.
///
/// Trocea orígenes y destinos en bloques de `maxCoordenadasPorConsulta / 2`
/// y solo consulta los bloques que tienen **al menos una celda faltante**
/// respecto a `celdasExistentes` — agregar un candidato nuevo dispara
/// únicamente las consultas de los bloques que lo contienen, el resto de la
/// matriz ya cacheada no se vuelve a pedir.
///
/// Con `cliente == null` (modo explícito sin conexión) llena todo con
/// haversine × `factorCircuidad`, `fuente = 'haversine'`. Si hay cliente
/// pero la primera petición de red falla por falta de conexión
/// ([CausaOsrmException.redNoDisponible]), el resto de los bloques
/// pendientes también cae a haversine — pero un error real (límite de
/// peticiones agotado, `NoRoute`, etc.) se propaga tal cual, sin respaldo
/// silencioso.
Future<List<CeldaMatriz>> construirMatriz({
  required int proyectoId,
  required List<OrigenMatriz> origenes,
  required List<DestinoMatriz> destinos,
  required List<CeldaMatriz> celdasExistentes,
  required double factorCircuidad,
  required OsrmClient? cliente,
  required int maxCoordenadasPorConsulta,
  void Function(ProgresoMatriz progreso)? onProgreso,
}) async {
  if (origenes.isEmpty || destinos.isEmpty) return const [];

  final existentes = <String, bool>{
    for (final c in celdasExistentes) _clave(c.tipoOrigen, c.origenId, c.tipoDestino, c.destinoId): true,
  };

  final tamanioBloque = (maxCoordenadasPorConsulta / 2).floor().clamp(1, maxCoordenadasPorConsulta);
  final bloquesOrigen = _trocear(origenes, tamanioBloque);
  final bloquesDestino = _trocear(destinos, tamanioBloque);

  final paresConFaltantes = <(List<OrigenMatriz>, List<DestinoMatriz>)>[];
  for (final bo in bloquesOrigen) {
    for (final bd in bloquesDestino) {
      final tieneFaltante = bo.any(
        (o) => bd.any((d) => !existentes.containsKey(_clave(o.tipo, o.id, d.tipo, d.id))),
      );
      if (tieneFaltante) paresConFaltantes.add((bo, bd));
    }
  }

  if (paresConFaltantes.isEmpty) return const [];

  if (cliente == null) {
    final resultado = _respaldoHaversine(proyectoId, paresConFaltantes, factorCircuidad);
    onProgreso?.call(
      ProgresoMatriz(
        bloquesCompletados: paresConFaltantes.length,
        bloquesTotales: paresConFaltantes.length,
        tiempoRestanteEstimado: Duration.zero,
      ),
    );
    return resultado;
  }

  final resultado = <CeldaMatriz>[];
  for (var i = 0; i < paresConFaltantes.length; i++) {
    final (bo, bd) = paresConFaltantes[i];

    OsrmTableResponse respuesta;
    try {
      respuesta = await cliente.obtenerMatrizAsimetrica(
        origenes: bo.map((o) => OsrmCoordenada(lat: o.latitud, lon: o.longitud)).toList(),
        destinos: bd.map((d) => OsrmCoordenada(lat: d.latitud, lon: d.longitud)).toList(),
      );
    } on OsrmException catch (e) {
      if (e.causa != CausaOsrmException.redNoDisponible) rethrow;

      // Sin red desde acá: respaldo haversine para este bloque y todos los
      // que faltan, sin perder lo ya conseguido ni abortar el resto.
      final restantes = [(bo, bd), ...paresConFaltantes.sublist(i + 1)];
      resultado.addAll(_respaldoHaversine(proyectoId, restantes, factorCircuidad));
      onProgreso?.call(
        ProgresoMatriz(
          bloquesCompletados: paresConFaltantes.length,
          bloquesTotales: paresConFaltantes.length,
          tiempoRestanteEstimado: Duration.zero,
        ),
      );
      return resultado;
    }

    final distancias = respuesta.distanciasMetros!;
    final duraciones = respuesta.duracionesSegundos!;
    for (var oi = 0; oi < bo.length; oi++) {
      for (var di = 0; di < bd.length; di++) {
        resultado.add(
          CeldaMatriz(
            proyectoId: proyectoId,
            tipoOrigen: bo[oi].tipo,
            origenId: bo[oi].id,
            tipoDestino: bd[di].tipo,
            destinoId: bd[di].id,
            distanciaMetros: distancias[oi][di].round(),
            duracionSegundos: duraciones[oi][di].round(),
            fuente: 'osrm',
          ),
        );
      }
    }

    onProgreso?.call(
      ProgresoMatriz(
        bloquesCompletados: i + 1,
        bloquesTotales: paresConFaltantes.length,
        tiempoRestanteEstimado: osrmThrottleInterval * (paresConFaltantes.length - i - 1),
      ),
    );
  }

  return resultado;
}

List<CeldaMatriz> _respaldoHaversine(
  int proyectoId,
  List<(List<OrigenMatriz>, List<DestinoMatriz>)> pares,
  double factorCircuidad,
) {
  final resultado = <CeldaMatriz>[];
  for (final (bo, bd) in pares) {
    for (final o in bo) {
      for (final d in bd) {
        final distanciaKm = distanciaHaversineKm(
          lat1: o.latitud,
          lon1: o.longitud,
          lat2: d.latitud,
          lon2: d.longitud,
        );
        resultado.add(
          CeldaMatriz(
            proyectoId: proyectoId,
            tipoOrigen: o.tipo,
            origenId: o.id,
            tipoDestino: d.tipo,
            destinoId: d.id,
            distanciaMetros: (distanciaKm * 1000 * factorCircuidad).round(),
            // Sin ruteo real no hay forma honesta de estimar el tiempo de
            // viaje — se deja en 0 en vez de inventar una velocidad
            // promedio; `fuente = 'haversine'` ya avisa que no es un dato
            // real (CLAUDE.md `[REGLA]`: nunca presentar un resultado
            // aproximado como si fuera real).
            duracionSegundos: 0,
            fuente: 'haversine',
          ),
        );
      }
    }
  }
  return resultado;
}

List<List<T>> _trocear<T>(List<T> lista, int tamanio) {
  final bloques = <List<T>>[];
  for (var i = 0; i < lista.length; i += tamanio) {
    final fin = (i + tamanio) > lista.length ? lista.length : i + tamanio;
    bloques.add(lista.sublist(i, fin));
  }
  return bloques;
}

String _clave(String tipoOrigen, int origenId, String tipoDestino, int destinoId) =>
    '$tipoOrigen:$origenId:$tipoDestino:$destinoId';
