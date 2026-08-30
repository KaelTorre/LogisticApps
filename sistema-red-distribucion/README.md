# Sistema de Optimización de Red de Distribución

Proyecto de la Unidad 5 del curso de Logística: aplicación Flutter multiplataforma (Windows, Linux, Android) que decide **cuántos centros de distribución abrir, en cuáles sitios candidatos, y qué zona de demanda atiende cada uno**, minimizando el costo logístico total anual sujeto a un estándar de nivel de servicio.

Cubre los capítulos 13 y 14 de Ballou (5.ª ed.): ubicación de instalaciones y planeación/asignación acumuladas.

- **Fuente de verdad técnica:** [CLAUDE.md](./CLAUDE.md) — restricciones, esquema de base de datos, pseudocódigo de los nueve módulos del motor, fases de implementación y antipatrones.
- **Contexto académico:** [sistema-red-distribucion.md](./sistema-red-distribucion.md) — qué es el sistema, qué problema resuelve, anclaje teórico y cómo se conecta con el resto de proyectos del repositorio (pendiente de copiar desde la raíz del repo).
- **Paquete compartido:** [`paquete_geo_logistica/`](./paquete_geo_logistica/) — motor de ruteo OSRM, utilidades geográficas y selector de ubicación, extraídos de `sistema-optimizacion-rutas/`. Vive anidado dentro de este proyecto (no en la raíz del repo) para que la carpeta `sistema-red-distribucion/` completa sea autocontenida y se pueda entregar sola.

## Qué hace y qué no

**Hace:** agrega clientes en zonas de demanda, genera candidatos por centro de gravedad, consulta una matriz de distancias reales por carretera, corre heurísticas de ubicación discreta (ADD, DROP, intercambio, recocido simulado) sobre un modelo de costo de siete rubros, y entrega la curva de costo total contra número de almacenes con el mínimo marcado.

**No hace:** no es un ruteador de vehículos (eso es `sistema-optimizacion-rutas/`), no es un WMS ni un dimensionador de almacén (eso es `sistema-diseno-almacenes/`), no es un GIS, y no usa ningún solver MIP — todo el motor es heurístico, en Dart puro.

## Estado actual

**Fase 0 y Fase 1 completas.** Fases 2 a 9 pendientes.

- [x] `paquete_geo_logistica/` creado como paquete Dart local **anidado dentro de este proyecto** (no en la raíz del repo, para que la carpeta completa se pueda entregar sola como código fuente), consumido por dependencia `path: paquete_geo_logistica`. Copia desacoplada de `sistema-optimizacion-rutas/` (que **no se modificó**): `OsrmClient` ya no depende de drift/`AppDatabase`, sino de una interfaz `CacheRuteo` que la app implementa contra su propia tabla; `SelectorUbicacionScreen` ya no trae un centro por defecto propio, lo recibe como parámetro. Tests migrados (`geo_utils_test.dart`, `osrm_client_test.dart`, adaptado a `CacheRuteoEnMemoria`) pasan sin tocar sus aserciones, más un test nuevo de la interfaz. `flutter analyze` limpio, 22/22 tests en verde.
- [x] Proyecto Flutter `sistema-red-distribucion/` creado con soporte para `windows`, `linux`, `android`.
- [x] Dependencias instaladas y justificadas en `pubspec.yaml`: `paquete_geo_logistica` (path), `provider`, `drift`+`drift_flutter`, `path_provider`, `flutter_map`+`latlong2`, `http`, `crypto`, `fl_chart`, `pdf`+`printing`, `flex_color_scheme`+`google_fonts`+`lucide_icons_flutter`+`flutter_animate`, `share_plus`+`url_launcher`+`android_intent_plus`.
- [x] Estructura de carpetas de `lib/` y `test/` según la sección 9 de `CLAUDE.md`, con la nomenclatura `lib/ui/pantallas/` (no `lib/presentation/screens/` de la Unidad 3 — unificada hacia adelante).
- [x] `docs/fuentes_datos.md` creado (vacío, a completar cuando entren datos reales o del caso de estudio).
- [x] **Fase 1 — Esquema de base de datos.** Las quince tablas de la sección 6 en drift (`lib/data/local/database.dart`), `schemaVersion` 1, `PRAGMA foreign_keys = ON` explícito y cascada real hasta 2 niveles (`proyecto` → `escenario` → `memoria_calculo`/`escenario_almacen`/`escenario_asignacion`/`escenario_costo`/`punto_curva`, y `proyecto` → `cliente`/`zona_demanda` → `cliente_zona`). Invariante monetaria (céntimos enteros para dinero, metros/segundos enteros para distancia/duración, `double` solo en coordenadas/pesos/factores) respetada en todas las columnas. `CacheRuteoDrift` (`lib/data/local/cache_ruteo_drift.dart`) implementa la interfaz `CacheRuteo` del paquete contra `cache_ruteo`. Modelos de dominio (`lib/data/models/`) y repositorios (`lib/data/repositories/`) para las 15 tablas: CRUD completo en las de datos maestros (proyecto, cliente, zona_demanda, sitio_candidato, planta, parámetros de costo — 1 fila por proyecto); alta en bloque + consulta + baja en las de resultado calculado (cliente_zona, celda_matriz, escenario y sus 5 tablas hijas), que se recalculan enteras en vez de editarse fila por fila. `flutter analyze` limpio, 40/40 tests en verde — incluye el test de borrado en cascada exigido por la fase (eliminar un proyecto con todo su árbol cargado deja las 13 tablas relacionadas vacías) y el de invariante monetaria (`S/ 1234.56` → exactamente `123456` céntimos, ida y vuelta).
- [ ] **Pendiente — Fase 2:** pantallas de datos de entrada (proyecto, clientes, sitios candidatos, plantas, parámetros de costo), importador CSV, auditoría de calidad de datos.
- [ ] **Pendiente — Fase 3:** M1 (agregación de zonas de demanda) y `tool/verificar_limite_osrm.dart` (límite real de coordenadas por consulta, documentado en `docs/limites_osrm.md`).
- [ ] **Pendiente — Fase 4:** M3 (matriz de distancias asimétrica, troceada, cacheada, con respaldo haversine) — acá se le agrega a `paquete_geo_logistica` la matriz asimétrica que hoy no tiene (ver su README, sección "Pendiente").
- [ ] **Pendiente — Fase 5:** M4 (modelo de costo), M5 (asignación), M7 (regla de la raíz cuadrada), memoria de cálculo.
- [ ] **Pendiente — Fase 6:** M6 (heurísticas ADD/DROP/intercambio/recocido simulado, enumeración exhaustiva para instancias pequeñas).
- [ ] **Pendiente — Fase 7:** M8 (barrido/curva de costo) y M9 (comparador de escenarios).
- [ ] **Pendiente — Fase 8:** mapa de resultados con territorios coloreados y visor web (`visor-red/`).
- [ ] **Pendiente — Fase 9:** exportación (PDF/CSV/JSON + formato de importación de la Unidad 4), caso de estudio con coordenadas reales verificadas, inducción guiada, empaquetado de los tres binarios.

## Requisitos previos

- Flutter SDK (canal estable) en el PATH.
- Para compilar el target Linux desktop: `clang`, `cmake`, `ninja-build`, `gtk3-devel`, `pkg-config`.
- Para Android: Android SDK.
- Para Windows: requiere Windows para compilar (ver Fase 9 de `CLAUDE.md` — se resuelve vía GitHub Actions, mismo patrón que los proyectos hermanos).

## Ejecutar en modo desarrollo

```bash
flutter pub get
flutter run -d linux   # o -d windows, o -d <device_id> para Android
```

## Generar código de drift

Cada vez que se modifique el esquema en `lib/data/local/database.dart` (a partir de la Fase 1):

```bash
dart run build_runner build --delete-conflicting-outputs
```
