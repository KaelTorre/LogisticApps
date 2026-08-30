# CLAUDE.md — Sistema de Optimización de Red de Distribución

**Unidad 5 · Capítulos 13 y 14 (Ballou, 5.ª ed.)**
**Carpeta del proyecto:** `sistema-red-distribucion/`
**Paquete compartido:** `paquete-geo-logistica/`

> Contrato técnico cerrado. Las líneas marcadas **[REGLA]** son decisiones tomadas: no se renegocian, no se "mejoran" y no se omiten. Si algo parece requerir violar una regla, **detente y pregunta** en vez de improvisar.

---

## 0. Cómo usar este documento

- Se implementa **fase por fase, en orden**. No se salta a una fase posterior porque "es más interesante".
- Cada fase termina con `flutter analyze` sin advertencias y `flutter test` en verde. **[REGLA]**
- Cada fase tiene una sección **Pruebas de la fase**. Esas pruebas son obligatorias y se escriben en la misma fase, no después.
- Al terminar cada fase, se actualiza el `README.md` del proyecto con el estado real. **[REGLA]** El README de la Unidad 3 quedó diciendo "scaffold inicial" con el proyecto terminado; eso no se repite.
- **No se inventan datos.** Coordenadas, tarifas, costos y capacidades vienen de fuente verificable o los provee el usuario. Lo que no tenga fuente se marca `PENDIENTE` en `docs/fuentes_datos.md`. **[REGLA]**

---

## 1. Qué se construye

Sistema de escritorio y móvil que decide **cuántos centros de distribución abrir, en cuáles sitios candidatos, y qué zona de demanda atiende cada uno**, minimizando el costo logístico total anual sujeto a un estándar de nivel de servicio.

## 2. Qué NO se construye — alcance cerrado **[REGLA]**

No implementar nada de esta lista, ni siquiera "de forma básica":

- **No es un ruteador de vehículos.** Nada de orden de visita, ventanas horarias, capacidad de camión por viaje ni algoritmos de ahorros o barrido. Eso es `sistema-optimizacion-rutas/` y ya existe.
- **No es un WMS.** Sin recepciones, surtido, existencias en tiempo real ni kardex.
- **No es un dimensionador de almacén.** Sin posiciones de tarima, racks ni superficie construida. Eso es `sistema-diseno-almacenes/` y ya existe.
- **No es un GIS.** Sin edición de polígonos, capas ni shapefiles.
- **No hay solver MIP.** Sin CPLEX, Gurobi, CBC ni binarios nativos de optimización. Solo heurísticas en Dart puro.
- **No hay backend, cuenta de usuario ni sincronización en la nube.**
- **No hay isócronas reales.** El servicio de ruteo público no las ofrece de forma fiable; la cobertura por tiempo se evalúa punto a punto sobre la matriz.

## 3. Restricciones duras del entorno **[REGLA]**

| Restricción | Detalle |
|---|---|
| Presupuesto cero | Ninguna dependencia de pago, suscripción, API con cuota ni servicio en la nube |
| Windows + Linux + Android | Los tres compilan del mismo código. iOS opcional |
| Opera sin internet | Tras poblar la caché de distancias, todo el análisis corre offline |
| Sin cuenta de usuario | La app abre y funciona |
| Dependencias justificadas | Toda dependencia nueva en `pubspec.yaml` lleva comentario explicando por qué es necesaria y por qué no se resuelve en Dart puro, igual que en `sistema-diseno-almacenes/pubspec.yaml` |

---

## 4. Stack

Idéntico al del repositorio, para no fragmentar el conocimiento:

- **Flutter/Dart** — un solo código para los tres destinos.
- **drift + drift_flutter** — base local SQLite con esquema tipado y migraciones.
- **provider** — estado.
- **flutter_map + latlong2** — mapa con teselas de OpenStreetMap.
- **http** — cliente del servicio de ruteo.
- **crypto** — hash de consultas para la caché.
- **fl_chart** — curva de costo y gráficas de barras apiladas.
- **pdf + printing** — ficha técnica exportable.
- **path_provider** — carpeta de documentos por sistema operativo.
- **flex_color_scheme, google_fonts, lucide_icons_flutter, flutter_animate** — capa visual, misma identidad que las otras apps.
- **share_plus, url_launcher, android_intent_plus** — abrir carpeta de exportados y compartir enlace del visor.

**[REGLA]** No se agrega ningún paquete de optimización, geometría computacional ni machine learning. Todo el motor se escribe en Dart.

---

## 5. Reutilización — paquete `paquete-geo-logistica`

### 5.1 Qué se extrae y de dónde

**[REGLA]** Se crea un paquete Dart local en la raíz del repositorio, consumido por la app nueva con dependencia `path:`. **No se modifica `sistema-optimizacion-rutas/`**: ese entregable está cerrado y tiene sus tests pasando. La app de la Unidad 3 sigue con su copia propia; el paquete nace como copia extraída, no como refactor.

Se copian desde `sistema-optimizacion-rutas/`:

| Archivo origen | Destino en el paquete | Cambios permitidos |
|---|---|---|
| `lib/data/remote/osrm_client.dart` | `lib/src/ruteo/osrm_client.dart` | Desacoplar de `AppDatabase`: la caché se abstrae tras una interfaz `CacheRuteo` |
| `lib/data/remote/osrm_models.dart` | `lib/src/ruteo/osrm_models.dart` | Agregar modelo de matriz asimétrica |
| `lib/core/constants.dart` (parte OSRM) | `lib/src/ruteo/constantes_osrm.dart` | Ninguno |
| `lib/core/utils/geo_utils.dart` | `lib/src/geo/geo_utils.dart` | Ninguno |
| `lib/core/trusted_certs_http_overrides.dart` | `lib/src/red/trusted_certs_http_overrides.dart` | Ninguno |
| `lib/presentation/screens/_shared/selector_ubicacion_screen.dart` | `lib/src/ui/selector_ubicacion_screen.dart` | Parametrizar centro inicial y etiqueta |
| `test/core/geo_utils_test.dart`, `test/data/osrm_client_test.dart` | `test/` del paquete | Se migran tal cual y deben seguir pasando |

### 5.2 Interfaz de caché **[REGLA]**

El cliente de ruteo del paquete no conoce drift. Define:

```dart
abstract class CacheRuteo {
  Future<String?> leer(String hashConsulta);
  Future<void> guardar(String hashConsulta, String tipo, String respuestaJson);
}
```

La app implementa `CacheRuteoDrift` contra su propia tabla. Esto permite testear el cliente con una caché en memoria.

### 5.3 Lo que hay que **agregar** al cliente de ruteo

Tres capacidades que la Unidad 3 no necesitaba:

**a) Matriz asimétrica.** El servicio soporta parámetros `sources` y `destinations`. Para ubicación no hace falta la matriz completa N×N, solo `candidatos × zonas`. Se implementa `obtenerMatrizAsimetrica(origenes, destinos)`.

**b) Troceado de la matriz.** **[REGLA]** El servicio público limita el número de coordenadas por consulta al servicio `table`. **No asumas el valor del límite.** En la Fase 3 se verifica empíricamente con una consulta de prueba creciente y el valor confirmado se documenta en `docs/limites_osrm.md` y se codifica como constante `maxCoordenadasPorConsulta`. Si la verificación no es concluyente, se usa un valor conservador de 80 y se anota como supuesto.

El troceado divide orígenes y destinos en bloques, consulta cada par de bloques y ensambla la matriz completa. Cada bloque se cachea por separado, de modo que agregar un candidato nuevo solo dispara las consultas del bloque afectado.

**c) Respaldo en línea recta.** Si no hay red y no hay caché, la matriz se llena con distancia haversine multiplicada por un **factor de circuidad** configurable (por defecto 1.30, valor que el usuario puede calibrar). Cada celda de la matriz guarda su `fuente`: `osrm` o `haversine`. **[REGLA]** La interfaz debe indicar visiblemente cuando un resultado se calculó con distancias aproximadas. Nunca se presenta un resultado aproximado como si fuera real.

---

## 6. Esquema de base de datos

**[REGLA]** Todo importe monetario se guarda en **céntimos como entero**. Toda distancia en **metros como entero**. Toda duración en **segundos como entero**. Los `double` solo aparecen en coordenadas, pesos y factores. Esto evita el error de redondeo acumulado que arruina una comparación de escenarios.

Tablas (drift, en `lib/data/local/database.dart`):

| # | Tabla | Contenido |
|---|---|---|
| 1 | `proyecto` | nombre, moneda, unidad de peso, horizonte en años, factor de circuidad, fecha |
| 2 | `cliente` | proyecto, nombre, lat, lon, demanda anual, pedidos anuales, activo |
| 3 | `zona_demanda` | proyecto, etiqueta, lat, lon (centroide ponderado), demanda agregada, pedidos agregados, nº de clientes, error de agregación en metros |
| 4 | `cliente_zona` | asignación cliente → zona (resultado de la agregación) |
| 5 | `sitio_candidato` | proyecto, nombre, lat, lon, costo fijo anual, capacidad anual, costo variable de manejo por tonelada, origen (`manual` \| `centro_gravedad`), es red actual |
| 6 | `planta` | proyecto, nombre, lat, lon, capacidad anual, costo de producción por tonelada |
| 7 | `parametros_costo` | proyecto, tarifas de entrada y salida (fijo + por km-tonelada), tasa anual de manejo de inventario, valor por tonelada, inventario base de una ubicación, costo por pedido, estándar de servicio (km o minutos), tipo de estándar |
| 8 | `celda_matriz` | proyecto, tipo de origen (`planta` \| `candidato`), id origen, tipo destino, id destino, distancia en metros, duración en segundos, fuente |
| 9 | `cache_ruteo` | hash de consulta, tipo, respuesta JSON, fecha |
| 10 | `escenario` | proyecto, nombre, método usado, p fijado o libre, restricción activa, costo total, fecha, notas |
| 11 | `escenario_almacen` | escenario, sitio candidato abierto, volumen asignado, costo fijo, costo de manejo |
| 12 | `escenario_asignacion` | escenario, zona, almacén asignado, distancia, duración, costo de salida |
| 13 | `escenario_costo` | escenario, rubro, monto — desglose por los siete rubros |
| 14 | `punto_curva` | escenario padre, número de almacenes, costo total, costo por rubro, viable según servicio |
| 15 | `memoria_calculo` | escenario, módulo, paso, fórmula en texto, entradas JSON, salida, unidad |

La tabla 15 replica el patrón de trazabilidad de la Unidad 4 y es obligatoria: **todo número visible en la interfaz debe poder abrirse y mostrar de dónde salió**. **[REGLA]**

---

## 7. Módulos del motor

Todos en `lib/domain/motor/`, funciones puras sin dependencia de Flutter ni de la base de datos. Reciben estructuras de entrada y devuelven estructuras de salida más filas de memoria de cálculo.

### M1 — Agregación de zonas de demanda

**Entrada:** lista de clientes con coordenadas y demanda, número objetivo de zonas `k`.
**Salida:** zonas con centroide ponderado, demanda sumada, y error de agregación.

```
funcion agregar(clientes, k):
    si clientes.longitud <= k: cada cliente es su propia zona; retornar
    # k-means geográfico ponderado por demanda
    centroides = inicializar_kmeans_plusplus(clientes, k)
    repetir hasta convergencia o max_iteraciones:
        para cada cliente: asignar al centroide más cercano (haversine)
        para cada centroide:
            nuevo = promedio de lat/lon de sus clientes, ponderado por demanda
    para cada zona:
        demanda_zona = suma de demandas
        pedidos_zona = suma de pedidos
        error_zona = distancia media ponderada de sus clientes al centroide
    retornar zonas
```

**[REGLA]** La agregación usa **haversine**, nunca el servicio de ruteo. Agrupar clientes no requiere distancia por carretera y consultarla sería absurdo en costo.

**[REGLA]** `k` se propone automáticamente como `min(maxCoordenadasPorConsulta - reservaCandidatos, nClientes)` pero el usuario puede bajarlo. Nunca se permite un `k` que haga inviable la matriz.

### M2 — Generación de candidatos por centro de gravedad

**Entrada:** zonas de demanda, tarifa de salida.
**Salida:** un punto por cada `p` solicitado.

```
funcion centro_gravedad_exacto(zonas, tarifa):
    # Weiszfeld
    x, y = centro_gravedad_simple(zonas)   # promedio ponderado por V*R
    repetir hasta que el desplazamiento < tolerancia o max_iteraciones:
        para cada zona i:
            d_i = haversine((x,y), zona_i)
            si d_i == 0: d_i = epsilon      # evitar división por cero
            w_i = (V_i * R_i) / d_i
        x = suma(w_i * x_i) / suma(w_i)
        y = suma(w_i * y_i) / suma(w_i)
    retornar (x, y)
```

Para múltiples centros se aplica el **múltiple centro de gravedad**: asignar zonas al centro más cercano, recalcular cada centro sobre sus zonas, repetir hasta que las asignaciones no cambien.

**[REGLA]** El resultado de M2 **no es una decisión**, es una sugerencia de sitio candidato. Se inserta en `sitio_candidato` con `origen = 'centro_gravedad'` y el usuario decide si lo conserva. La interfaz debe dejar claro que ese punto puede caer en un lugar no edificable.

### M3 — Matriz de distancias

**Entrada:** orígenes (candidatos y plantas), destinos (zonas).
**Salida:** `celda_matriz` poblada.

```
funcion construir_matriz(origenes, destinos):
    faltantes = celdas que no están ya en celda_matriz
    si faltantes vacío: retornar
    si no hay red:
        llenar faltantes con haversine * factor_circuidad, fuente='haversine'
        retornar con advertencia
    bloques_o = trocear(origenes, maxCoordenadasPorConsulta / 2)
    bloques_d = trocear(destinos, maxCoordenadasPorConsulta / 2)
    para cada (bo, bd):
        respuesta = cliente.obtenerMatrizAsimetrica(bo, bd)   # con caché y throttling
        volcar distancias y duraciones, fuente='osrm'
```

**[REGLA]** El progreso se muestra al usuario con número de bloques completados y estimación de tiempo, porque con espaciado de un segundo entre peticiones una matriz grande tarda minutos. Nunca una pantalla congelada sin retroalimentación.

### M4 — Modelo de costo

**Entrada:** configuración (conjunto de almacenes abiertos), asignación, parámetros.
**Salida:** costo total y desglose por rubro.

```
funcion costo_total(abiertos, asignacion, params):
    c_produccion   = suma sobre zonas de (demanda * costo_produccion_tonelada)
    c_entrada      = suma sobre almacenes abiertos de
                       (volumen_almacen * tarifa_entrada(distancia_planta_almacen))
    c_salida       = suma sobre zonas de
                       (demanda_zona * tarifa_salida(distancia_zona_almacen))
    c_fijo         = suma sobre abiertos de costo_fijo_anual
    c_manejo       = suma sobre abiertos de (volumen * costo_variable_manejo)
    c_inventario   = inventario(n_abiertos) * valor_tonelada * tasa_manejo_anual
    c_pedidos      = suma sobre zonas de (pedidos_zona * costo_por_pedido)
    retornar suma de los siete + desglose

funcion tarifa(distancia_m, tarifa_fija, tarifa_por_km_ton):
    retornar tarifa_fija + tarifa_por_km_ton * (distancia_m / 1000)
```

### M5 — Asignación de zonas a almacenes

```
funcion asignar(abiertos, zonas, params):
    si no hay restricción de capacidad:
        cada zona → almacén que minimice (costo_salida + costo_manejo)
        si viola estándar de servicio: marcar zona como no cubierta
    si hay restricción de capacidad:
        ordenar zonas por (costo del mejor almacén - costo del segundo mejor), descendente
        asignar en ese orden al mejor almacén con capacidad disponible
    retornar asignación, zonas no cubiertas, capacidad excedida
```

**[REGLA]** La heurística de asignación con capacidad es **golosa por costo de oportunidad**, no óptima. Debe documentarse como tal en la memoria de cálculo. No se implementa el problema de transporte exacto.

### M6 — Heurísticas de ubicación

```
funcion heuristica_add(candidatos, zonas, params, p_max):
    abiertos = {}
    mientras abiertos.tamaño < p_max:
        mejor = candidato cerrado cuya apertura más reduce el costo total
        si ninguno reduce el costo: romper
        abiertos += mejor
        registrar punto de curva (abiertos.tamaño, costo)
    retornar abiertos

funcion heuristica_drop(candidatos, zonas, params):
    abiertos = todos los candidatos
    mientras abiertos.tamaño > 1:
        peor = abierto cuyo cierre más reduce el costo total
        si ninguno reduce el costo: romper
        abiertos -= peor
        registrar punto de curva
    retornar abiertos

funcion intercambio_teitz_bart(abiertos_inicial, candidatos, zonas, params):
    # p fijo: mejora local por intercambio
    actual = abiertos_inicial
    repetir:
        mejor_intercambio = ninguno
        para cada a en actual, para cada c en candidatos - actual:
            nuevo = actual - a + c
            si costo(nuevo) < costo(actual): registrar el mejor
        si no hubo mejora: romper
        actual = mejor_intercambio
    retornar actual

funcion recocido_simulado(candidatos, zonas, params, semilla):
    # vector binario de apertura; vecino = voltear un bit o intercambiar dos
    # temperatura inicial calibrada para aceptar ~50% de empeoramientos
    # enfriamiento geométrico, criterio de parada por iteraciones sin mejora
```

**[REGLA]** El recocido simulado recibe **semilla explícita** y es reproducible. Dos ejecuciones con la misma semilla y las mismas entradas producen el mismo resultado, o el test de reproducibilidad falla.

**[REGLA]** Para instancias con hasta 14 candidatos, el sistema puede correr **enumeración exhaustiva** (2^14 = 16 384 configuraciones) y reportar el óptimo exacto. Esto es lo que valida las heurísticas en los tests y también es un modo de uso legítimo para casos pequeños.

### M7 — Efecto de agrupación de riesgos

```
funcion inventario(n_ubicaciones, inventario_base_una_ubicacion):
    # regla de la raíz cuadrada, cap. 9
    retornar inventario_base_una_ubicacion * raiz(n_ubicaciones)
```

### M8 — Barrido sobre el número de almacenes

Para `p = 1 .. p_max`: obtener la mejor configuración de tamaño `p` (ADD seguido de intercambio, o enumeración si el caso es pequeño), calcular el costo total y guardar un `punto_curva` con el desglose. El mínimo de la curva es la recomendación del sistema.

### M9 — Comparador de escenarios

Diferencia entre dos escenarios: costo por rubro, almacenes que se abren y se cierran, zonas que cambian de asignación, ahorro anual y variación en el cumplimiento del estándar de servicio.

---

## 8. Pantallas

| # | Pantalla | Contenido |
|---|---|---|
| 1 | Inicio | Tarjetas de acceso, proyecto activo, estado de la caché de distancias |
| 2 | Proyecto | Alta y edición, moneda, horizonte, factor de circuidad |
| 3 | Clientes | Lista, formulario, importación CSV, selección en mapa |
| 4 | Auditoría de datos | Hallazgos de calidad con severidad y acción sugerida |
| 5 | Agregación | Control de `k`, mapa de zonas resultantes, error de agregación |
| 6 | Sitios candidatos | Lista, formulario, generación por centro de gravedad, marcado de red actual |
| 7 | Plantas | Lista y formulario |
| 8 | Parámetros de costo | Los siete rubros, estándar de servicio |
| 9 | Matriz | Estado de la matriz, progreso de construcción, proporción de celdas reales contra aproximadas |
| 10 | Optimización | Selección de método, `p` fijo o libre, ejecución con progreso |
| 11 | Resultado — mapa | Territorios coloreados, almacenes abiertos, zonas no cubiertas destacadas |
| 12 | Resultado — costos | Desglose por rubro, comparación contra la red actual |
| 13 | Curva | Costo total contra número de almacenes, barras apiladas por rubro, mínimo marcado |
| 14 | Memoria de cálculo | Navegable por módulo y paso |
| 15 | Comparador de escenarios | Dos o más escenarios lado a lado |
| 16 | Exportación | PDF, CSV, JSON, enlace de visor web, paquete para la Unidad 4 |
| 17 | Inducción guiada | Recorrido de primera ejecución, mismo patrón que `tour_controller` de la Unidad 4 |

---

## 9. Fases de implementación

### Fase 0 — Paquete compartido y andamiaje

**Trabajo:**
- Crear `paquete-geo-logistica/` con la estructura de un paquete Dart y copiar los archivos de la sección 5.1.
- Desacoplar el cliente de ruteo de drift mediante la interfaz `CacheRuteo`.
- Crear el proyecto Flutter `sistema-red-distribucion/` con destinos `windows`, `linux`, `android`.
- Declarar el paquete como dependencia `path:`.
- Estructura de carpetas: `lib/core/`, `lib/data/{local,repositories,models,seed}/`, `lib/domain/motor/`, `lib/domain/export/`, `lib/ui/{pantallas,widgets}/`.
- **[REGLA]** Se adopta la nomenclatura `lib/ui/pantallas/` de la Unidad 4, no `lib/presentation/screens/` de la Unidad 3. Se unifica hacia adelante.

**Pruebas de la fase:**
- Los tests migrados del paquete (`geo_utils_test.dart`, `osrm_client_test.dart`) pasan sin modificación de sus aserciones.
- Test nuevo: `CacheRuteoEnMemoria` satisface la interfaz y el cliente la usa sin tocar red cuando hay acierto de caché.
- `flutter analyze` limpio en el paquete y en la app.

---

### Fase 1 — Esquema de base de datos

**Trabajo:**
- Las quince tablas de la sección 6 en drift, con `schemaVersion` 1.
- `CacheRuteoDrift` implementando la interfaz contra `cache_ruteo`.
- Modelos de dominio en `lib/data/models/`.
- Repositorios con operaciones de alta, baja, modificación y consulta.

**Pruebas de la fase:**
- Test de creación de esquema y de cada repositorio (alta, lectura, modificación, borrado en cascada).
- Test de borrado en cascada: eliminar un proyecto elimina clientes, zonas, candidatos, escenarios y memoria.
- Test de invariante monetaria: guardar `S/ 1234.56` y releer devuelve exactamente `123456` céntimos.

---

### Fase 2 — Datos de entrada y mapa

**Trabajo:**
- Pantallas 2, 3, 6, 7 y 8 con sus formularios y validadores.
- Integración del `selector_ubicacion_screen` del paquete.
- Importador CSV de clientes con detección de separador y mapeo de columnas.
- Pantalla 4 de auditoría de datos con las reglas: coordenada fuera de rango, coordenada duplicada exacta, demanda no positiva, cliente sin pedidos, candidato sin costo fijo, tarifa faltante.

**Pruebas de la fase:**
- Test del importador con CSV de coma, punto y coma y tabulador; con encabezado y sin él; con filas malformadas que deben rechazarse individualmente sin abortar la importación completa.
- Test de cada regla de auditoría con caso positivo y negativo.
- Test de widget: el formulario de cliente rechaza latitud 91 y longitud −181.

---

### Fase 3 — Agregación y verificación del límite de la matriz

**Trabajo:**
- M1 completo.
- Script `tool/verificar_limite_osrm.dart` que consulta el servicio con listas crecientes de coordenadas hasta obtener error, y reporta el máximo aceptado. Resultado documentado en `docs/limites_osrm.md`.
- Constante `maxCoordenadasPorConsulta` fijada con el valor verificado.
- Pantalla 5.

**Pruebas de la fase:**
- **Test dorado A:** cuatro clientes en las esquinas de un cuadrado, demanda igual, `k = 1`. El centroide debe caer en el centro del cuadrado con tolerancia de un metro.
- **Test dorado B:** los mismos cuatro clientes pero con demanda 10, 1, 1, 1. El centroide debe desplazarse hacia el cliente pesado y quedar a menos de la mitad de la distancia al centro.
- **Test C:** con `k = nClientes`, cada cliente es su propia zona y el error de agregación es cero.
- **Test D:** la suma de demanda de todas las zonas es igual a la suma de demanda de todos los clientes, exactamente.
- **Test E:** el algoritmo es determinista con semilla fija — dos ejecuciones producen zonas idénticas.

---

### Fase 4 — Matriz de distancias

**Trabajo:**
- M3 completo: matriz asimétrica, troceado, ensamblado, caché por bloque, respaldo haversine.
- Pantalla 9 con progreso y proporción de celdas por fuente.

**Pruebas de la fase:**
- **Test de troceado:** con `maxCoordenadasPorConsulta = 10`, una matriz de 25 orígenes × 30 destinos debe generar el número correcto de bloques y ensamblar una matriz de dimensiones exactamente 25 × 30, sin celdas vacías, usando un cliente HTTP falso que devuelve distancias deterministas iguales al producto de los índices.
- **Test de caché:** la segunda construcción de la misma matriz no realiza ninguna petición HTTP.
- **Test de caché parcial:** agregar un candidato dispara únicamente las peticiones de los bloques que lo contienen.
- **Test de respaldo:** sin red, todas las celdas quedan con `fuente = 'haversine'` y la distancia es exactamente `haversine × factor_circuidad`.
- **Test de propagación de error:** un HTTP 429 persistente produce `OsrmException` con mensaje al usuario, nunca un crash ni una matriz a medias guardada.

---

### Fase 5 — Costo y asignación

**Trabajo:**
- M4, M5 y M7.
- Escritura de filas de `memoria_calculo` desde cada módulo.

**Pruebas de la fase:**
- **Test dorado F — costo a mano:** instancia mínima de dos zonas y un almacén, con todos los parámetros fijados, cuyo costo total se calcula a mano en el propio test y se compara céntimo a céntimo.
- **Test G — raíz cuadrada:** `inventario(4) / inventario(1)` es exactamente 2. `inventario(9) / inventario(1)` es exactamente 3.
- **Test H — asignación:** cada zona queda asignada al almacén de menor costo cuando no hay capacidad limitante.
- **Test I — capacidad:** con capacidad insuficiente, ninguna zona queda asignada a un almacén excedido, y las no asignadas se reportan explícitamente.
- **Test J — estándar de servicio:** una zona más lejana que el estándar se marca como no cubierta y no desaparece silenciosamente.
- **Test K — memoria:** cada ejecución de M4 produce al menos una fila de memoria por rubro.

---

### Fase 6 — Heurísticas

**Trabajo:**
- M6 completo: ADD, DROP, intercambio y recocido simulado.
- Enumeración exhaustiva para instancias pequeñas.
- Pantalla 10 con progreso y cancelación.

**Pruebas de la fase:**
- **Test dorado L — heurística contra óptimo:** para al menos cinco instancias generadas con semilla fija y 8 a 12 candidatos, el resultado de ADD seguido de intercambio debe **igualar** el óptimo obtenido por enumeración exhaustiva. Si alguna instancia no lo iguala, se documenta la brecha porcentual y el test asegura que sea menor al 2 %.
- **Test M — DROP:** sobre las mismas instancias, DROP también converge al óptimo o dentro del 2 %.
- **Test N — reproducibilidad:** el recocido simulado con la misma semilla produce el mismo conjunto de almacenes en dos ejecuciones.
- **Test O — monotonía de ADD:** el costo registrado en cada paso de ADD es estrictamente decreciente hasta el paso en que se detiene.
- **Test P — cancelación:** una ejecución cancelada no deja escenario a medias en la base.

---

### Fase 7 — Curva y escenarios

**Trabajo:**
- M8 y M9.
- Pantallas 12, 13 y 15.

**Pruebas de la fase:**
- **Test Q — forma de la curva:** en una instancia construida para tener mínimo interior, la curva de costo total debe ser decreciente antes del mínimo y creciente después. El punto marcado como óptimo debe coincidir con el mínimo real del vector.
- **Test R — descomposición:** en cada punto de la curva, la suma de los siete rubros es exactamente igual al costo total, sin diferencia por redondeo.
- **Test S — direcciones de costo:** al aumentar el número de almacenes, el rubro de transporte de salida no crece y el de inventario no decrece.
- **Test T — comparador:** el ahorro reportado entre dos escenarios es igual a la diferencia de sus costos totales.

---

### Fase 8 — Mapa de resultados y visor web

**Trabajo:**
- Pantalla 11 con territorios coloreados. La paleta se genera con el mismo criterio de contraste que `paleta_rutas.dart` de la Unidad 3.
- Adaptación del `visor-web` a una página nueva `visor-red/` que dibuje almacenes, zonas y líneas de asignación, con los datos en el fragmento de la URL.

**Pruebas de la fase:**
- **Test U — paleta:** con hasta doce almacenes, dos territorios adyacentes nunca reciben colores con diferencia de contraste por debajo del umbral definido.
- **Test V — codificación del visor:** la carga útil codificada y luego decodificada devuelve exactamente los mismos almacenes y asignaciones.
- **Test W — tamaño del enlace:** un caso de treinta zonas produce un enlace por debajo del límite práctico de URL; si lo excede, el sistema avisa en vez de generar un enlace roto.

---

### Fase 9 — Exportación, caso de estudio y empaquetado

**Trabajo:**
- Ficha técnica PDF reutilizando el patrón de `pdf_builder.dart` de la Unidad 4.
- Exportación CSV y JSON del proyecto.
- Exportación del volumen por centro en el formato que consume `importar_proyecto_screen` de la Unidad 4. **[REGLA]** El formato se acuerda leyendo el código real de esa pantalla, no inventándolo.
- Caso de estudio precargado con coordenadas reales verificadas por el usuario y caché de distancias poblada.
- Inducción guiada.
- Actualización del `README.md` con estado real y comandos de compilación.

**Pruebas de la fase:**
- **Test X — ida y vuelta JSON:** exportar un proyecto e importarlo produce un proyecto idéntico en todas sus tablas.
- **Test Y — PDF:** el archivo se genera, tiene más de una página y contiene el nombre del proyecto.
- **Test Z — caso precargado:** al iniciar con base vacía, el caso se siembra completo y la optimización corre de principio a fin **sin realizar ninguna petición de red**.

---

## 10. Notas de desarrollo

**Sobre el rendimiento.** Las heurísticas corren sobre la matriz cacheada en memoria. Con doscientas zonas y cuarenta candidatos, una evaluación de costo completa debe tardar menos de un milisegundo. Si tarda más, el problema es que se está consultando la base de datos dentro del bucle: la matriz se carga una vez a estructuras en memoria antes de optimizar. **[REGLA]** Ninguna consulta a drift dentro de un bucle de optimización.

**Sobre el aislamiento del hilo.** Un barrido completo con recocido puede tardar segundos. Se ejecuta en un `Isolate` para no congelar la interfaz. El motor ya es de funciones puras, así que es portable a un isolate sin cambios.

**Sobre los datos del caso de estudio.** Las coordenadas las provee el usuario o se verifican en openstreetmap.org, igual que se hizo con `pucallpa_dataset.dart`. Las tarifas y costos que no tengan fuente pública se marcan como valores genéricos plausibles y se documentan como tales. **No se presentan como datos reales de ninguna empresa.**

**Sobre el servicio público de ruteo.** No tiene acuerdo de nivel de servicio y puede limitar o rechazar peticiones. El espaciado de un segundo entre peticiones que ya trae el cliente es obligatorio. Si el servicio no responde, la app debe seguir siendo usable con el respaldo en línea recta y con la caché.

**Sobre la unidad de la demanda.** El proyecto define si la demanda está en toneladas, kilogramos o unidades. Las tarifas se expresan en la misma unidad. **[REGLA]** No hay conversión automática de unidades: si el usuario mezcla unidades, el resultado es basura y el sistema no puede detectarlo. La pantalla de proyecto debe advertirlo.

---

## 11. Antipatrones — no hacer

- Consultar el servicio de ruteo dentro de una iteración de Weiszfeld o de una heurística.
- Guardar dinero en `double`.
- Presentar un resultado calculado con distancias haversine sin indicarlo.
- Permitir un `k` de agregación que haga la matriz inconsultable.
- Implementar ruteo de vehículos "porque ya está el cliente de OSRM".
- Modificar `sistema-optimizacion-rutas/` durante estas fases.
- Escribir el número óptimo de almacenes a mano en algún lugar en vez de tomarlo del mínimo de la curva.
- Dejar el `README.md` desactualizado al cerrar una fase.
- Agregar una dependencia sin comentario de justificación.
- Inventar coordenadas, tarifas o costos.
