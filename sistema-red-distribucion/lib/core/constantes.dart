import 'package:latlong2/latlong.dart';

/// Centro por defecto del selector de mapa cuando todavía no hay ninguna
/// coordenada elegida — mismo punto de referencia (Pucallpa, Perú) que usan
/// `sistema-optimizacion-rutas` y `sistema-diseno-almacenes`, para no
/// fragmentar el criterio entre proyectos hermanos mientras no hay un caso
/// de estudio propio cargado (llega en la Fase 9).
const LatLng centroMapaPorDefecto = LatLng(-8.375482, -74.556342);

/// Máximo de coordenadas que acepta una sola consulta al servicio `/table`
/// del servidor demo público de OSRM — verificado empíricamente (Fase 3,
/// CLAUDE.md sección 9) con `tool/verificar_limite_osrm.dart`, nunca
/// asumido. Detalle de la verificación en `docs/limites_osrm.md`; si se
/// vuelve a correr el script y el número cambia, actualizar ambos archivos
/// juntos.
const int maxCoordenadasPorConsulta = 100;
