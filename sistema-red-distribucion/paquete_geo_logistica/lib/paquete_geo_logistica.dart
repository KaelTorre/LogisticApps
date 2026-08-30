/// Motor geográfico compartido entre las apps de Logística del repositorio:
/// cliente de ruteo OSRM con caché y control de peticiones, utilidades de
/// distancia y geometría, confianza de certificados TLS adicionales, y el
/// selector de ubicación sobre mapa.
///
/// Extraído de `sistema-optimizacion-rutas/` (Unidad 3) como copia
/// desacoplada de drift — ver `sistema-red-distribucion/CLAUDE.md`
/// sección 5. No se modifica `sistema-optimizacion-rutas/`.
library;

export 'src/geo/geo_utils.dart';
export 'src/red/trusted_certs_http_overrides.dart';
export 'src/ruteo/cache_ruteo.dart';
export 'src/ruteo/constantes_osrm.dart';
export 'src/ruteo/osrm_client.dart';
export 'src/ruteo/osrm_models.dart';
export 'src/ui/selector_ubicacion_screen.dart';
