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
