# paquete_geo_logistica

Motor geográfico compartido entre las apps de Logística del repositorio:
cliente de ruteo OSRM con caché y control de peticiones, utilidades de
distancia/geometría, confianza de certificados TLS adicionales, y el
selector de ubicación sobre mapa.

Extraído como copia desacoplada de `sistema-optimizacion-rutas/` (Unidad 3)
para uso de `sistema-red-distribucion/` (Unidad 5) — ver `CLAUDE.md` de ese
proyecto, sección 5. **No se modifica `sistema-optimizacion-rutas/`**: sigue
con su propia copia de estos archivos y sus tests siguen pasando tal cual.

## Contenido

- `src/geo/geo_utils.dart` — haversine, ángulo polar, decodificación de
  polyline, muestreo de flechas de dirección, división de polyline por tramos.
- `src/red/trusted_certs_http_overrides.dart` — raíces de CA adicionales para
  TLS en escritorio (mismo problema que en la Unidad 3: el almacén de
  certificados del sistema puede no tenerlas cacheadas).
- `src/ruteo/` — cliente OSRM (`OsrmClient`), sus modelos de respuesta, y la
  interfaz `CacheRuteo` que la app consumidora implementa contra su propio
  esquema (drift) sin que este paquete dependa de él.
- `src/ui/selector_ubicacion_screen.dart` — mapa a pantalla completa para
  elegir una coordenada tocando el punto exacto, parametrizado (centro por
  defecto, user agent, textos) para que cada app consumidora lo adapte a su
  caso sin forkearlo.

## Diferencias con la copia de `sistema-optimizacion-rutas`

- `OsrmClient` recibe una `CacheRuteo` en vez de una `AppDatabase` de drift —
  el paquete no depende de ningún motor de base de datos.
- `SelectorUbicacionScreen` no trae un centro por defecto propio (antes era
  el depósito semilla de Pucallpa); cada app lo pasa como parámetro.
- `OsrmClient` agrega `obtenerMatrizAsimetrica(origenes, destinos)` (Fase 4
  de `sistema-red-distribucion/CLAUDE.md`): matriz `origenes.length ×
  destinos.length` vía los parámetros `sources`/`destinations` de OSRM, para
  no pedir la matriz cuadrada completa cuando solo hacen falta candidatos ×
  zonas. `OsrmException` ahora lleva un campo `causa`
  (`CausaOsrmException`: `redNoDisponible` | `limitePeticiones` | `sinRuta` |
  `otro`) para que quien llama distinga "no hay red" (respaldo válido en
  línea recta) de un error real que debe propagarse. El troceado por límite
  de coordenadas y el respaldo con factor de circuidad viven en la app
  (M3, `lib/domain/motor/m3_matriz_distancias.dart`), no en el paquete — son
  lógica de orquestación específica del modelo de ubicación, no del cliente
  de ruteo en sí.
