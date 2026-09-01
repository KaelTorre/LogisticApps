# Sistema de Control Logístico de Lazo Cerrado

Proyecto de la Unidad 6 del curso de Logística: aplicación Flutter multiplataforma (Windows, Linux, Android) que implementa el modelo de control administrativo del capítulo 16 (Ballou, 5.ª ed.) como **lazo cerrado**: define estándares con banda de tolerancia, recibe mediciones por periodo, evalúa la serie mediante reglas de patrón, clasifica la magnitud de la respuesta requerida, propone acciones correctoras, registra la decisión y **verifica su efecto en el periodo siguiente**.

Cubre los capítulos 15 y 16 de Ballou (5.ª ed.): estructura organizacional logística y control.

- **Fuente de verdad técnica:** [CLAUDE.md](./CLAUDE.md) — restricciones, la regla fundamental del periodo como dato, esquema de base de datos, pseudocódigo de los diez módulos del motor, fases de implementación y antipatrones.
- **Contexto académico:** [sistema-control-logistico.md](./sistema-control-logistico.md) — qué es el sistema, qué problema resuelve, la diferencia con un umbral simple, anclaje teórico y cómo cierra el ciclo del curso (Unidad 6 devuelve a la Unidad 5 cuando detecta que hay que replanear la red).

## Qué hace y qué no

**Hace:** evalúa series de indicadores de costo, servicio y productividad contra reglas de patrón deterministas (punto fuera de banda, racha, corrimiento de media, tendencia sostenida, deterioro brusco, dispersión creciente), clasifica la desviación en ajuste menor / replaneación mayor / plan de contingencia, propone acciones concretas desde una biblioteca, y cierra el lazo verificando en el periodo siguiente si la acción funcionó. Incluye un laboratorio de escenarios (series sintéticas, reloj de simulación, contraste retrospectivo contra un umbral simple, calibrador de banda) y dos módulos complementarios (diagnóstico de estructura organizacional, auditoría de facturas de transporte).

**No hace:** no es un ERP ni un WMS (recibe indicadores ya calculados, no transacciones), no es tiempo real (opera por periodos, no por eventos), no es un tablero de inteligencia de negocios genérico, no usa servicios de inteligencia artificial (el reconocimiento de patrones es control estadístico de procesos con reglas deterministas, cero red), y no genera acciones nuevas — las selecciona de una biblioteca.

**La regla fundamental de la arquitectura:** el periodo es un dato, no el reloj del sistema. El motor de evaluación (`lib/domain/motor/`) nunca invoca `DateTime.now()` para decidir qué periodo evaluar — eso es lo que hace posible cargar treinta y seis periodos de historia y procesarlos en segundos, y es lo que habilita el reloj de simulación y el contraste retrospectivo.

## Estado actual

- [x] **Fase 0 — Andamiaje.** Proyecto Flutter creado con soporte para `windows`, `linux`, `android` (`com.logisticapps.sistema_control_logistico`). Estructura de carpetas (`lib/core/`, `lib/data/`, `lib/domain/motor/`, `lib/ui/pantallas/`, `lib/ui/widgets/`) según la sección 9 de `CLAUDE.md`. Tema visual (`lib/core/theme.dart`) copiado de los tres proyectos hermanos — mismo esquema `FlexScheme.shadBlue`, para no fragmentar el lenguaje visual del repositorio. `lib/core/plataforma/abrir_carpeta.dart` copiado de `sistema-diseno-almacenes`/`sistema-red-distribucion` (mismo mecanismo de "Ir a la carpeta"/"Abrir archivo"/"Compartir" para los exportables de la Fase 5, con su `FileProvider` propio ya declarado en el manifiesto de Android). Dependencias instaladas y justificadas en `pubspec.yaml`: `provider`, `drift`+`drift_flutter`, `fl_chart`, `pdf`+`printing`, `share_plus`+`android_intent_plus`, `flex_color_scheme`+`google_fonts`+`lucide_icons_flutter`+`flutter_animate`, `shared_preferences` — **sin `http` ni ningún paquete de red**, verificado por un test dedicado que lee `pubspec.yaml`. `flutter analyze` limpio, 2/2 tests en verde (test de humo de la pantalla de inicio + test de ausencia de red). Verificado también compilando el APK de Android (`flutter build apk --debug`) y corriendo el binario de Linux real bajo Xvfb headless (`GDK_BACKEND=x11`), con captura de pantalla confirmando que la ventana abre y renderiza el tema correcto.
- [x] **Fase 1 — Esquema y regla fundamental.** Las quince tablas de la sección 7 de `CLAUDE.md` en drift (`lib/data/local/database.dart`), `schemaVersion` 1, `PRAGMA foreign_keys = ON` explícito y cascada real desde `organizacion` hasta `periodo`/`indicador`/`medicion`/`regla_patron`/`evaluacion`/`memoria_evaluacion`/`accion_tomada`/`verificacion_accion`/`presupuesto`/`escenario_sintetico`/`diagnostico_organizacional`/`factura_transporte` — `accion_catalogo` y `regla_accion` son catálogo global, no cuelgan de ninguna organización, a propósito. Modelos de dominio (`lib/data/models/`) y repositorios (`lib/data/repositories/`) para las 15 tablas. Pantallas 2 (Organización), 3 (Periodos) y 4 (Indicadores): Inicio (Pantalla 1) se fusiona con el alta/edición de Organización, mismo criterio que `sistema-red-distribucion` fusionó Inicio con Proyectos — este sistema opera sobre una sola organización por instalación, así que Pantalla 2 nunca es una lista. `flutter analyze` limpio, 22/22 tests en verde: esquema de las 15 tablas, CRUD de cada repositorio, borrado en cascada de una organización completa (con el catálogo global sobreviviendo intacto), el test de la regla fundamental (`test/domain/regla_fundamental_test.dart`, que se mantiene sin tocar hasta el final del proyecto), y el test de ordenamiento por `periodo.orden` (nunca por fecha). **Verificado también con clics reales bajo Xvfb** (`xdotool`, no solo capturas): crear organización → periodo → indicador de punta a punta, confirmando persistencia real entre pantallas. Se encontró y evitó un bug de tree-shaking de íconos de `lucide_icons_flutter` en builds `--release` (`--no-tree-shake-icons` los corrige) — a revisar si afecta los binarios ya entregados de los proyectos hermanos.
- [x] **Fase 2 — Captura y series.** Importador CSV de mediciones (`lib/domain/importacion/importador_csv_mediciones.dart`, mismo patrón que el importador de clientes de `sistema-red-distribucion`: detecta separador coma/punto y coma/tabulador, con o sin encabezado, rechaza filas malformadas una por una sin abortar el resto) — es una función pura que devuelve `orden` sin resolver contra la base; la pantalla es quien empareja `orden` con el periodo real y rechaza los que no existen. Pantalla 6 (`lib/ui/pantallas/captura/captura_screen.dart`): selector de indicador, lista de periodos con su medición actual, edición por diálogo y botón de importación CSV con resumen de filas importadas/rechazadas. Pantalla 7 (`lib/ui/pantallas/detalle_indicador/detalle_indicador_screen.dart` + widget reusable `lib/ui/widgets/grafica_serie_banda.dart`): serie temporal contra `periodo.orden` con la banda de tolerancia sombreada — el estado por periodo llega en la Fase 3, cuando exista M1. `flutter analyze` limpio, 33/33 tests en verde: 8 del importador CSV (separadores, con/sin encabezado, filas malformadas, orden no positivo, coma decimal), el test de integridad exigido por la fase (no se puede crear dos mediciones del mismo indicador y periodo — la restricción vive en `MedicionTable.uniqueKeys` desde la Fase 1), y el test de widget de la banda (`menor_mejor` y `mayor_mejor` producen exactamente la misma posición de banda, sin desplazamiento por sentido). **Verificado también con clics reales bajo Xvfb**: captura manual de un valor, importación CSV con filas válidas y rechazadas (una por orden inexistente, otra por valor no numérico) mostrando el resumen correcto, y la Pantalla 7 renderizando la serie real (1.18 → 1.33 → 1.21) contra la banda 1.10–1.30 sombreada.

## Requisitos previos

- Flutter SDK (canal estable) en el PATH.
- Para compilar el target Linux desktop: `clang`, `cmake`, `ninja-build`, `gtk3-devel`, `pkg-config`.
- Para Android: Android SDK. El build `--release` requiere Java 21 explícito (`JAVA_HOME=/usr/lib/jvm/java-21-openjdk`) — el Java por defecto de esta máquina choca con un bug conocido de AGP/jlink en el build release, mismo hallazgo que en los proyectos hermanos.
- Para Windows: requiere Windows para compilar.

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
