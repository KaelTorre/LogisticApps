# Fuentes de datos

Registro obligatorio (CLAUDE.md sección 0, regla "no se inventan datos") de
de dónde sale cada coordenada, tarifa, costo o capacidad usada en el caso de
estudio o en cualquier valor por defecto de la app. Todo lo que no tenga
fuente verificable se marca `PENDIENTE` acá, no se inventa en el código.

## Caso de estudio — Pucallpa (Fase 9)

| Dato | Valor | Fuente | Estado |
|---|---|---|---|
| Coordenada de la planta | `-8.375482, -74.556342` | Reusada de `sistema-optimizacion-rutas/lib/core/pucallpa_dataset.dart` (`depositoSemillaOficina`), validada a mano por el usuario en openstreetmap.org en esa Unidad. Reinterpretada acá como planta/origen en vez de depósito de reparto — misma coordenada real, otro rol, ningún dato nuevo inventado. | Verificado (reusado) |
| Coordenadas de los 19 clientes | Ver `lib/core/pucallpa_dataset_red.dart` (`puntosPucallpa`) | Mismos 19 puntos reales de Pucallpa (universidades, hospitales, centro comercial, puerto, aeropuerto, clínicas, municipalidad, etc.) que `sistema-optimizacion-rutas/lib/core/pucallpa_dataset.dart` ya usa como `puntosEntregaSemillaPucallpa`, validados a mano por el usuario en openstreetmap.org en esa Unidad. | Verificado (reusado) |
| Demanda anual de cada cliente | `demandaKgSemana × 52` | **Asunción explícita, no medida.** El valor base en kg es el mismo genérico-pero-realista que ya documentaba el proyecto de Unidad 3 (no había datos reales de demanda disponibles); acá se reinterpreta como demanda semanal y se escala a una cifra anual (×52 semanas) porque este proyecto necesita una demanda ANUAL, unidad que el caso original no definía. | Asunción documentada, no un dato real |
| Zonas de demanda (8) | Calculadas | Resultado real de `agregarEnZonas` (M1, k-means geográfico ponderado) corrido sobre los 19 clientes — no son datos de entrada, son una salida del propio motor. | Calculado por el sistema |
| Sitios candidatos (4) | Calculados | Resultado real de `generarCandidatosPorCentroGravedad` (M2, Weiszfeld) corrido sobre las 8 zonas — **sugerencias, no direcciones reales verificadas** (CLAUDE.md sección 7: "el resultado de M2 no es una decisión"). El usuario debe confirmar si esos puntos son edificables antes de tratarlos como una decisión real. | Sugerido por el sistema, no verificado como sitio real |
| Costo fijo anual / capacidad / costo variable de manejo de cada candidato | `8,000,000` céntimos, `300,000`, `15` céntimos/unidad | Valores genéricos plausibles, sin fuente pública — no se presentan como datos reales de ninguna empresa (CLAUDE.md, notas de desarrollo de la Fase 9). | Genérico, sin fuente real |
| Capacidad / costo de producción de la planta | `500,000`, `50` céntimos/unidad | Genérico plausible, mismo criterio que el punto anterior. | Genérico, sin fuente real |
| Tarifas de entrada/salida, tasa de manejo de inventario, valor por unidad, inventario base, costo por pedido, estándar de servicio | Ver `tool/generar_semilla_pucallpa.dart` | Genéricos plausibles para una red de distribución pequeña — no verificados contra ningún proveedor u operador real. | Genérico, sin fuente real |
| Matriz de distancias planta↔candidatos y candidatos↔zonas (36 celdas) | `assets/seed/semilla_pucallpa.json` | **Real**: consultada contra el servidor demo público de OSRM (`router.project-osrm.org`) por `tool/generar_semilla_pucallpa.dart`, con el mismo espaciado de 1 req/seg que exige `OsrmClient`. Las 36 celdas quedaron con `fuente = 'osrm'` (verificado, ninguna cayó a respaldo haversine). | Verificado, distancias reales por carretera |

**Cómo se generó y se puede regenerar:** `tool/generar_semilla_pucallpa.dart`
(correr con `flutter test tool/generar_semilla_pucallpa.dart`, no `dart run`
— ver el comentario del propio archivo) construye el proyecto completo con
el motor real (M1 + M2 + M3 contra OSRM real) y escribe
`assets/seed/semilla_pucallpa.json`. Ese archivo es lo único que
`lib/data/seed/sembrar_caso_estudio.dart` lee al arrancar con la base
vacía — **cero peticiones de red en el arranque real de la app** (Test Z).
