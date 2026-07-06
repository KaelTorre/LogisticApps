# Sistema de Optimización de Rutas (VRP) con OSRM

Proyecto de la Unidad 3 del curso de Logística: aplicación Flutter multiplataforma (Windows, Linux, Android, iOS) que resuelve el problema de ruteo de vehículos (VRP) para un depósito y un conjunto de puntos de entrega en Pucallpa, Perú, usando **OSRM** como motor de ruteo real sobre calles de OpenStreetMap.

- **Fuente de verdad técnica:** [CLAUDE.md](./CLAUDE.md) — contrato de API de OSRM, esquema de base de datos, pseudocódigo de los algoritmos de Ahorros y Barrido, fases de implementación.
- **Contexto académico:** [sistema-optimizacion-rutas-vrp.md](./sistema-optimizacion-rutas-vrp.md) — mapeo teoría-código para la sustentación.

## Estado actual

Scaffold inicial (Fase 0 de CLAUDE.md, en progreso):

- [x] Proyecto Flutter creado con soporte para `windows`, `linux`, `android`, `ios`.
- [x] Dependencias instaladas: `provider`, `http`, `flutter_map`, `latlong2`, `drift` + `drift_flutter`, `drift_dev`/`build_runner`.
- [x] Estructura de carpetas de `lib/` y `test/` según la sección 4 de CLAUDE.md.
- [x] Esquema de base de datos (`lib/data/local/database.dart`) con las 8 tablas de la sección 5.1, incluyendo `cache_osrm`.
- [x] Modelos de datos (`lib/data/models/`), utilidades geográficas (ángulo polar, distancia haversine) y validador de capacidad (M6), con tests.
- [ ] **Pendiente:** recolectar ~15-20 coordenadas reales de Pucallpa (ver sección 9, Fase 0 de CLAUDE.md) — no se deben inventar.
- [ ] **Pendiente:** `osrm_client.dart` (cliente HTTP con throttling de 1 req/seg y manejo de errores).
- [ ] **Pendiente:** algoritmos de Ahorros (M3) y Barrido (M4), repositorios, y pantallas CRUD/mapa.

## Requisitos previos

- Flutter SDK (canal estable) en el PATH.
- Para compilar el target Linux desktop: `clang`, `cmake`, `ninja-build`, `gtk3-devel`, `pkg-config`.
- Para Android: Android SDK (no configurado todavía en este entorno).
- Para iOS/Windows: requieren macOS/Windows respectivamente para compilar, según la sección 8 de CLAUDE.md.

## Ejecutar en modo desarrollo

```bash
flutter pub get
flutter run -d linux   # o -d windows, o -d <device_id> para Android/iOS
```

## Generar código de drift

Cada vez que se modifique el esquema en `lib/data/local/database.dart`:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Verificación

```bash
flutter analyze
flutter test
```
