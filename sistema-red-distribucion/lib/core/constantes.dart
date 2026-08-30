import 'package:latlong2/latlong.dart';

/// Centro por defecto del selector de mapa cuando todavía no hay ninguna
/// coordenada elegida — mismo punto de referencia (Pucallpa, Perú) que usan
/// `sistema-optimizacion-rutas` y `sistema-diseno-almacenes`, para no
/// fragmentar el criterio entre proyectos hermanos mientras no hay un caso
/// de estudio propio cargado (llega en la Fase 9).
const LatLng centroMapaPorDefecto = LatLng(-8.375482, -74.556342);
