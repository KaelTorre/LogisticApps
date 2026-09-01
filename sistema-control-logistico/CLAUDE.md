# CLAUDE.md — Sistema de Control Logístico de Lazo Cerrado

**Unidad 6 · Capítulos 15 y 16 (Ballou, 5.ª ed.)**
**Carpeta del proyecto:** `sistema-control-logistico/`

> Contrato técnico cerrado. Las líneas marcadas **[REGLA]** son decisiones tomadas: no se renegocian, no se "mejoran" y no se omiten. Si algo parece requerir violar una regla, **detente y pregunta** en vez de improvisar.

---

## 0. Cómo usar este documento

- Se implementa **fase por fase, en orden**.
- Cada fase termina con `flutter analyze` sin advertencias y `flutter test` en verde. **[REGLA]**
- Cada fase tiene **Pruebas de la fase**, obligatorias y escritas en la misma fase.
- Al terminar cada fase se actualiza el `README.md` del proyecto con el estado real. **[REGLA]**
- **No se inventan datos.** Los valores del caso de estudio son sintéticos y deben estar **etiquetados como sintéticos** en la interfaz. **[REGLA]** Nunca se presentan como datos de una empresa real.

---

## 1. Qué se construye

Sistema de escritorio y móvil que implementa el modelo de control del capítulo 16 como lazo cerrado: define estándares con banda de tolerancia, recibe mediciones por periodo, **evalúa la serie mediante reglas de patrón**, clasifica la magnitud de la respuesta requerida, propone acciones correctoras, registra la decisión y **verifica su efecto en el periodo siguiente**.

## 2. Qué NO se construye — alcance cerrado **[REGLA]**

- **No es un ERP ni un WMS.** No hay transacciones, pedidos, existencias ni movimientos. El sistema recibe indicadores ya calculados.
- **No es tiempo real.** No hay eventos, ni sockets, ni notificaciones push, ni observación continua.
- **No es un tablero de inteligencia de negocios genérico.** No hay constructor de gráficas arbitrarias ni cubos de datos.
- **No hay servicios de inteligencia artificial.** El reconocimiento de patrones es control estadístico de procesos con reglas deterministas. Cero llamadas a modelos, cero dependencias de red para el motor.
- **No hay generación de acciones correctoras.** Se seleccionan de una biblioteca mediante reglas. El sistema es experto, no generativo.
- **No hay backend, cuenta de usuario ni sincronización.**

## 3. Restricciones duras del entorno **[REGLA]**

| Restricción | Detalle |
|---|---|
| Presupuesto cero | Ninguna dependencia de pago, suscripción, API con cuota ni servicio en la nube |
| Windows + Linux + Android | Los tres compilan del mismo código. iOS opcional |
| Funciona sin internet | **Sin excepciones.** Este sistema no consulta ninguna red, nunca |
| Sin cuenta de usuario | La app abre y funciona |
| Dependencias justificadas | Toda dependencia nueva lleva comentario de justificación en `pubspec.yaml` |

---

## 4. LA REGLA FUNDAMENTAL

**[REGLA]** **El periodo es un dato, no el reloj del sistema.**

El motor de evaluación **jamás** invoca `DateTime.now()` para decidir en qué periodo está, qué serie evaluar ni qué medición corresponde. Recibe una lista de mediciones ordenadas por el campo `orden` de la tabla `periodo` y las evalúa.

`DateTime.now()` solo puede aparecer en:
- sellos de auditoría (`fecha_registro` de una acción tomada),
- el valor por defecto de un campo de formulario que el usuario puede cambiar.

**Nunca** en `lib/domain/motor/`. Un test de la Fase 1 verifica esto por análisis del código fuente.

Consecuencia directa: se puede cargar una historia de treinta y seis periodos y procesarla completa en segundos, y el laboratorio de escenarios de la Fase 6 es posible.

---

## 5. Stack

- **Flutter/Dart**, **drift + drift_flutter**, **provider** — igual que el resto del repositorio.
- **fl_chart** — series temporales con banda de tolerancia sombreada, barras apiladas de costo, radar del diagnóstico organizacional.
- **pdf + printing** — informes exportables.
- **path_provider**, **share_plus**, **android_intent_plus**, **url_launcher** — exportación y apertura de carpeta.
- **flex_color_scheme, google_fonts, lucide_icons_flutter, flutter_animate** — misma identidad visual.
- **shared_preferences** — únicamente la bandera de inducción ya mostrada.

**[REGLA]** No se agrega `http`, ni ningún paquete de red. Si aparece uno en `pubspec.yaml`, es un error.

**[REGLA]** No se agrega ningún paquete de estadística. Las reglas de patrón son aritmética elemental y se escriben en Dart.

---

## 6. Reutilización desde el repositorio

| Qué | De dónde | Cómo |
|---|---|---|
| Patrón de constructor de PDF | `sistema-diseno-almacenes/lib/domain/export/pdf_builder.dart` | Se copia y se adapta a los tres informes |
| Widgets de gráficas | `sistema-diseno-almacenes/lib/ui/widgets/grafica_*.dart` | Base para la serie temporal con banda |
| Inducción guiada | `sistema-diseno-almacenes/lib/core/tour/` | Se copia el mecanismo |
| Estructura de carpetas y convenciones drift | Cualquiera de las tres apps | `lib/ui/pantallas/`, `lib/domain/motor/`, `lib/data/` |
| Apertura de carpeta de exportados | `sistema-diseno-almacenes/lib/core/plataforma/abrir_carpeta.dart` | Se copia |
| Generador de series | `sistema-diseno-almacenes/lib/domain/motor/m1_pronostico.dart` | La descomposición nivel-tendencia-estacionalidad se **invierte** para generar en vez de proyectar |

**[REGLA]** No se usa `paquete-geo-logistica`. Este sistema no tiene geografía.

---

## 7. Esquema de base de datos

**[REGLA]** Todo importe monetario en **céntimos como entero**. Los valores de indicador se guardan como `double` porque pueden ser porcentajes, ratios o tiempos, pero se acompañan siempre de su `unidad` y su `decimales` de presentación.

| # | Tabla | Contenido |
|---|---|---|
| 1 | `organizacion` | nombre, moneda, tipo de empresa (extractiva, manufacturera, de servicios, de marketing), notas |
| 2 | `periodo` | organización, **orden** (entero, clave del sistema), etiqueta, fecha inicio, fecha fin, granularidad, es simulado |
| 3 | `indicador` | organización, código, nombre, categoría (`costo` \| `servicio` \| `productividad`), unidad, decimales, sentido (`menor_mejor` \| `mayor_mejor`), meta, banda inferior, banda superior, granularidad, proceso al que pertenece, activo |
| 4 | `medicion` | indicador, periodo, valor, origen (`manual` \| `importado` \| `derivado` \| `sintetico`), nota |
| 5 | `regla_patron` | código, nombre, descripción, parámetros JSON, periodos mínimos requeridos, severidad base, activa; puede ser global o por indicador |
| 6 | `evaluacion` | indicador, periodo, estado (`normal` \| `observacion` \| `desviacion`), clasificación (`ninguna` \| `ajuste_menor` \| `replaneacion_mayor` \| `contingencia`), reglas disparadas JSON, severidad calculada |
| 7 | `memoria_evaluacion` | evaluación, regla, resultado, valores de entrada JSON, explicación en texto |
| 8 | `accion_catalogo` | código, título, descripción, categoría de indicador aplicable, magnitud típica, es de sistema o del usuario, aplicación externa sugerida |
| 9 | `regla_accion` | mapeo de (categoría de indicador + regla disparada + clasificación) → acciones candidatas, con prioridad |
| 10 | `accion_tomada` | evaluación, acción del catálogo, responsable, fecha de compromiso, estado (`abierta` \| `cerrada` \| `descartada`), notas, fecha de registro |
| 11 | `verificacion_accion` | acción tomada, periodo de verificación, resultado (`corrigio` \| `no_corrigio` \| `parcial`), valor observado, comentario |
| 12 | `presupuesto` | organización, rubro, periodo, monto presupuestado, monto real |
| 13 | `escenario_sintetico` | nombre, indicador base, patrón, parámetros JSON, semilla, número de periodos |
| 14 | `diagnostico_organizacional` | organización, fecha, respuestas JSON, etapa resultante, opción organizacional, ejes, orientación dominante |
| 15 | `factura_transporte` | organización, número, transportista, peso, ruta, tarifa aplicada, tarifa contratada, discrepancia, monto recuperable, estado |

---

## 8. Módulos del motor

Todos en `lib/domain/motor/`, funciones **puras**: sin Flutter, sin drift, sin `DateTime.now()`.

### M1 — Reglas de patrón

**Entrada:** serie de mediciones ordenadas por `orden`, configuración del indicador, configuración de reglas.
**Salida:** lista de reglas disparadas con sus valores de soporte, más filas de memoria.

**[REGLA]** El "lado adverso" depende de `sentido`. Para `menor_mejor`, adverso es por encima de la meta. Para `mayor_mejor`, por debajo. Toda regla se escribe en términos de "adverso", nunca de "mayor".

Reglas de sistema, con sus parámetros por defecto:

| Código | Nombre | Condición | Periodos mínimos |
|---|---|---|---|
| `R1` | Punto fuera de banda | El último valor está fuera de `[banda_inf, banda_sup]` | 1 |
| `R2` | Racha en el lado adverso | `n` valores consecutivos del lado adverso de la meta (por defecto 7) | 7 |
| `R3` | Corrimiento de media | `m` de los últimos `n` valores del lado adverso (por defecto 8 de 8) | 8 |
| `R4` | Tendencia sostenida | `n` valores consecutivos monótonos hacia el lado adverso, **todos ellos del lado adverso de la meta** (por defecto 5) | 5 |
| `R5` | Deterioro brusco | La variación respecto al periodo anterior supera un porcentaje del ancho de banda (por defecto 60 %) | 2 |
| `R6` | Dispersión creciente | La desviación estándar móvil de los últimos `n` periodos supera en un factor a la de los `n` anteriores | 10 |

**[REGLA]** Cuando la serie no alcanza los periodos mínimos de una regla, esa regla devuelve `noEvaluable` con el conteo de periodos faltantes. **Nunca** devuelve "normal" por falta de datos, porque eso es mentir por omisión. La interfaz muestra el estado `noEvaluable` explícitamente.

**[REGLA]** `R1` por sí sola **no** produce clasificación de acción. Produce estado `observacion`. Este es el corazón conceptual del sistema y hay un test dorado que lo verifica.

### M2 — Clasificador de magnitud

**Entrada:** reglas disparadas, severidad, indicadores relacionados del mismo proceso.
**Salida:** una de cuatro clasificaciones.

```
funcion clasificar(disparadas, indicador, contexto):
    si disparadas está vacío: retornar ninguna
    si disparadas == solo {R1}: retornar ninguna con estado observacion

    procesos_afectados = indicadores del mismo proceso con desviación en este periodo
    si procesos_afectados >= umbral_contingencia (por defecto 3)
       o R6 disparada junto con R2 o R3:
        retornar contingencia

    desviacion_relativa = |valor - meta| / ancho_banda
    persistencia = número de periodos consecutivos con estado desviacion

    si (R2 o R3 o R4) y (desviacion_relativa > 1.0 o persistencia >= 4):
        retornar replaneacion_mayor
    si (R2 o R3 o R4 o R5):
        retornar ajuste_menor
    retornar ninguna
```

**[REGLA]** Todos los umbrales del clasificador son configurables y se guardan; ninguno queda escrito dentro de una condición sin poder cambiarse.

### M3 — Emparejador de acciones

Dado el indicador (categoría y proceso), las reglas disparadas y la clasificación, consulta `regla_accion` y devuelve acciones candidatas ordenadas por prioridad.

**[REGLA]** La biblioteca semilla debe incluir al menos una acción de clasificación `replaneacion_mayor` cuya `aplicacion_externa_sugerida` apunte al sistema de la Unidad 5, con texto explícito de que corresponde rediseñar la red de distribución.

### M4 — Verificador de acciones

Al cargarse el periodo siguiente al de una acción abierta, compara el valor observado contra el del periodo de la desviación y contra la meta, y propone un resultado de verificación que el usuario confirma o corrige.

**[REGLA]** El sistema **propone**, el usuario **confirma**. No se cierra una acción automáticamente.

### M5 — Generador de series sintéticas

**Entrada:** patrón, parámetros, semilla, número de periodos, meta y banda del indicador.
**Salida:** serie de valores con `origen = 'sintetico'`.

Patrones obligatorios: `estable`, `punto_aislado`, `tendencia`, `corrimiento`, `estacional`, `deterioro_brusco`.

```
funcion generar(patron, params, semilla, n, meta, banda):
    rng = generador con semilla
    base = meta
    para t en 1..n:
        ruido = rng.normal(0, params.sigma)
        componente = segun patron:
            estable          → 0
            punto_aislado    → si t == params.t_evento: params.magnitud, si no 0
            tendencia        → params.pendiente * max(0, t - params.t_inicio)
            corrimiento      → si t >= params.t_evento: params.salto, si no 0
            estacional       → params.amplitud * sin(2*pi*t / params.ciclo)
            deterioro_brusco → si t >= params.t_evento: params.salto * (t - t_evento)
        valor[t] = base + componente + ruido
```

**[REGLA]** El generador es **determinista con semilla**. Misma semilla y mismos parámetros producen la misma serie, siempre.

### M6 — Contraste retrospectivo

**Entrada:** serie completa, configuración del indicador.
**Salida:** para cada método, el primer periodo de detección y el número de falsas alarmas.

```
funcion contrastar(serie, config):
    resultados = {}
    para metodo en [umbral_simple, reconocimiento_patrones]:
        para t en 1..serie.longitud:
            veredicto = evaluar(metodo, serie[1..t], config)   # solo el pasado
            registrar primera detección y alarmas
    marcar como falsa alarma toda detección que no sea seguida de
        al menos params.persistencia periodos adversos consecutivos
    retornar tabla comparativa
```

**[REGLA]** En cada paso `t` el motor solo ve `serie[1..t]`. Si accede a un índice mayor que `t`, el contraste es inválido. Hay un test que lo verifica.

### M7 — Calibrador de banda

Dado un histórico y un conjunto de eventos que el usuario marca como "esto sí era un problema real", busca por barrido el ancho de banda que maximiza detecciones reales y minimiza falsas alarmas, y lo propone.

### M8 — Informes

Costo y servicio, productividad, tabla de desempeño, presupuesto contra real, y centro de utilidades con precios de transferencia.

### M9 — Diagnóstico organizacional

Cuestionario ponderado que ubica la organización en etapa de desarrollo, opción organizacional, ejes de centralización y de asesor contra línea, y orientación dominante. Salida en radar más informe de brechas.

### M10 — Auditoría de facturas

Recalcula cada factura contra el tarifario contratado y clasifica la discrepancia por tipo: tarifa, peso, ruta, descripción, duplicado, cargo accesorio no pactado. Cuantifica el monto recuperable.

---

## 9. Pantallas

| # | Pantalla | Contenido |
|---|---|---|
| 1 | Inicio | Semáforo general por categoría, acciones abiertas, periodo activo |
| 2 | Organización | Datos, tipo de empresa, moneda |
| 3 | Periodos | Calendario de periodos, alta y edición, granularidad |
| 4 | Indicadores | Catálogo, formulario con meta, banda, sentido y proceso |
| 5 | Reglas | Configuración de reglas global y por indicador |
| 6 | Captura | Ingreso de mediciones del periodo, con importación CSV |
| 7 | Detalle de indicador | Serie temporal con banda sombreada, marcas de eventos, estado por periodo |
| 8 | Evaluación del periodo | Veredictos, clasificación, reglas disparadas y su explicación |
| 9 | Acciones | Propuestas, registro con responsable y fecha, seguimiento |
| 10 | Verificación | Acciones pendientes de verificar y su resultado |
| 11 | Memoria de evaluación | Navegable por indicador, periodo y regla |
| 12 | Laboratorio — generador | Elección de patrón, parámetros, semilla, previsualización |
| 13 | Laboratorio — simulación | Reloj de periodos, avanzar y retroceder, estado en vivo |
| 14 | Laboratorio — contraste | Tabla comparativa entre métodos |
| 15 | Laboratorio — calibrador | Propuesta de banda óptima |
| 16 | Informe de costo y servicio | Desglose por actividad y peso relativo |
| 17 | Informe de productividad | Índices |
| 18 | Tabla de desempeño | Matriz de indicadores por periodo con semáforo |
| 19 | Presupuesto | Presupuestado contra real y variaciones |
| 20 | Diagnóstico organizacional | Cuestionario y resultado |
| 21 | Auditoría de facturas | Carga, discrepancias y monto recuperable |
| 22 | Exportación | PDF de cada informe, CSV, JSON |
| 23 | Inducción guiada | Recorrido de primera ejecución |

---

## 10. Fases de implementación

### Fase 0 — Andamiaje

**Trabajo:** proyecto Flutter con los tres destinos, estructura de carpetas, tema visual copiado del repositorio, dependencias con justificación.

**Pruebas de la fase:**
- `flutter analyze` limpio.
- Test de humo: la app arranca y muestra la pantalla de inicio.
- **Test de ausencia de red:** `pubspec.yaml` no contiene `http`, `dio` ni ningún paquete de red. Test que lee el archivo y falla si aparece alguno.

---

### Fase 1 — Esquema y regla fundamental

**Trabajo:** las quince tablas, modelos, repositorios, pantallas 2, 3 y 4.

**Pruebas de la fase:**
- Test de esquema y de cada repositorio.
- Test de borrado en cascada.
- **Test de la regla fundamental:** un test que lee todos los archivos de `lib/domain/motor/` y **falla si encuentra `DateTime.now()`**. Este test se mantiene hasta el final del proyecto. **[REGLA]**
- Test de ordenamiento: las mediciones se recuperan siempre ordenadas por `periodo.orden`, no por fecha.

---

### Fase 2 — Captura y series

**Trabajo:** M1 sin reglas todavía, pantalla 6 y pantalla 7 con la gráfica de serie y banda.

**Pruebas de la fase:**
- Test del importador CSV con separadores distintos y filas malformadas.
- Test de integridad: no se puede registrar dos mediciones del mismo indicador para el mismo periodo.
- Test de widget: la gráfica dibuja la banda en la posición correcta para `menor_mejor` y para `mayor_mejor`.

---

### Fase 3 — Motor de reglas

**Trabajo:** las seis reglas de M1 completas, con memoria de evaluación.

**Pruebas de la fase — estas son las que definen el producto:**

- **Test dorado A — la serie de referencia.** Con meta 1.20, banda ±8 % (rango 1.104 a 1.296) y la serie:
  `1.18, 1.33, 1.21, 1.24, 1.26, 1.28, 1.29, 1.29, 1.28, 1.29, 1.31, 1.34`
  se verifica que:
  - en el periodo 2, `R1` dispara y **ninguna otra regla** lo hace;
  - en los periodos 3 a 6, **ninguna regla** dispara;
  - en el periodo 7, `R4` dispara (cinco valores consecutivos ascendentes por encima de la meta: periodos 3 a 7);
  - en el periodo 7, `R1` **no** dispara, porque 1.29 está dentro de la banda;
  - en el periodo 11, `R1` vuelve a disparar.
- **Test B — sentido invertido:** la misma serie reflejada, con un indicador `mayor_mejor`, produce exactamente los mismos disparos.
- **Test C — no evaluable:** con solo tres periodos cargados, `R4` devuelve `noEvaluable` con "faltan 2", nunca `normal`.
- **Test D — estacionalidad:** una serie puramente estacional generada por M5 con amplitud dentro de la banda **no** dispara `R4`. Si lo hace, la regla está confundiendo ciclo con deterioro.
- **Test E — memoria:** cada regla disparada produce una fila de memoria con sus valores de entrada.

---

### Fase 4 — Clasificador y acciones

**Trabajo:** M2, M3, M4, biblioteca semilla de acciones, pantallas 8, 9 y 10.

**Pruebas de la fase:**
- **Test dorado F — R1 aislada no clasifica.** Sobre la serie de referencia en el periodo 2, la clasificación resultante es `ninguna` y el estado es `observacion`. **Este es el test más importante del sistema.**
- **Test G — clasificación en el periodo 7:** con `R4` disparada y la desviación relativa correspondiente, la clasificación es determinista y reproducible; el test fija el valor esperado según la fórmula de M2.
- **Test H — contingencia:** con tres indicadores del mismo proceso en desviación simultánea, la clasificación es `contingencia`.
- **Test I — acción hacia la Unidad 5:** una clasificación `replaneacion_mayor` sobre un indicador de categoría `costo` del proceso de transporte incluye entre sus propuestas la acción que apunta al rediseño de red.
- **Test J — verificación:** una acción abierta en el periodo 7, con el valor del periodo 8 dentro de banda y por debajo de la meta, produce propuesta de verificación `corrigio`, pero la acción **sigue abierta** hasta que el usuario confirma.

---

### Fase 5 — Informes

**Trabajo:** M8, pantallas 16 a 19, exportación PDF.

**Pruebas de la fase:**
- Test de suma: el costo logístico total del informe es exactamente la suma de sus actividades.
- Test de variación presupuestal: el porcentaje de variación es correcto en signo para sobregasto y para ahorro.
- Test de PDF: el archivo se genera y contiene el nombre de la organización y el periodo.

---

### Fase 6 — Laboratorio de escenarios

**Trabajo:** M5, M6, M7, pantallas 12 a 15.

**Pruebas de la fase:**
- **Test K — determinismo del generador:** misma semilla y parámetros producen serie idéntica en dos ejecuciones.
- **Test L — el patrón está presente:** una serie generada con patrón `tendencia` y pendiente positiva tiene correlación positiva significativa entre `orden` y `valor`; una serie `estable` no.
- **Test dorado M — contraste retrospectivo.** Sobre la serie de referencia del Test A, la tabla de contraste debe reportar:
  - umbral simple: primera detección en el periodo 2, marcada como **falsa alarma**; siguiente detección en el periodo 11;
  - reconocimiento de patrones: primera detección en el periodo 7, **no** marcada como falsa alarma;
  - ventaja de detección: cuatro periodos.
- **Test N — sin mirar el futuro:** el contraste evaluado en el periodo `t` produce el mismo veredicto que una evaluación normal sobre una base que contenga solo hasta `t`. Si difiere, el motor está espiando periodos futuros.
- **Test O — calibrador:** con un histórico y eventos marcados, la banda propuesta reduce las falsas alarmas respecto a la banda inicial sin perder ninguna detección marcada como real.

---

### Fase 7 — Reloj de simulación

**Trabajo:** pantalla 13 completa, con avanzar, retroceder y reiniciar, y recálculo de estado en cada paso.

**Pruebas de la fase:**
- **Test P — reversibilidad:** avanzar `n` periodos y retroceder `n` deja el estado exactamente igual al inicial.
- **Test Q — coherencia:** el estado mostrado tras avanzar hasta el periodo `t` es idéntico al estado que produce una evaluación completa de la serie hasta `t`.
- **Test R — el reloj no toca los datos:** avanzar y retroceder no crea, modifica ni borra mediciones.

---

### Fase 8 — Módulos complementarios

**Trabajo:** M9 y M10, pantallas 20 y 21.

**Pruebas de la fase:**
- Test del diagnóstico: un conjunto de respuestas fijado produce una etapa y una orientación deterministas.
- Test de auditoría de facturas: una factura con tarifa correcta no genera discrepancia; una con tarifa inflada genera discrepancia de tipo `tarifa` con el monto exacto de diferencia.
- Test de duplicados: dos facturas con el mismo número y transportista se marcan como duplicado.

---

### Fase 9 — Caso de estudio, inducción y empaquetado

**Trabajo:**
- Caso de estudio precargado: una organización sintética con al menos ocho indicadores repartidos entre costo, servicio y productividad, agrupados en al menos tres procesos, con treinta y seis periodos de historia coherente entre sí.
- **[REGLA]** La coherencia es obligatoria: si el costo de transporte sube en un periodo, la utilización de flota debe bajar en ese mismo periodo. Un caso con indicadores que se contradicen resta credibilidad y es un defecto, no un detalle.
- **[REGLA]** Todo dato del caso se muestra en la interfaz con la etiqueta de origen `sintetico`.
- Inducción guiada que lleve al usuario por el ciclo completo hasta la verificación.
- Importadores de derivación desde las otras apps del repositorio, **opcional**: solo si las fases anteriores están cerradas.
- Actualización del `README.md`.

**Pruebas de la fase:**
- **Test S — el caso arranca y clasifica:** con base vacía, el caso se siembra y al menos un indicador alcanza estado `desviacion` con clasificación distinta de `ninguna` dentro de los treinta y seis periodos.
- **Test T — coherencia del caso:** para cada par de indicadores declarados como correlacionados, el signo de la correlación en la serie sembrada es el declarado.
- **Test U — ida y vuelta JSON:** exportar e importar la organización completa produce un estado idéntico.

---

## 11. Notas de desarrollo

**Sobre el estado del indicador.** Un indicador tiene estado **por periodo**, no un estado global. La pantalla de inicio muestra el estado del periodo activo, y el periodo activo lo elige el usuario, no el calendario.

**Sobre la severidad.** No se inventa una escala de severidad de uno a diez. La severidad es una función explícita de la desviación relativa al ancho de banda y de la persistencia, y esa función está escrita en M2 y es auditable en la memoria de evaluación.

**Sobre la biblioteca de acciones.** La biblioteca semilla debe cubrir las tres categorías de indicador y las tres magnitudes de respuesta. Las acciones deben ser **concretas y accionables** ("revisar el factor de carga de los embarques de la ruta afectada"), no genéricas ("mejorar la eficiencia"). Una acción genérica es un defecto de contenido.

**Sobre el rendimiento.** Evaluar treinta y seis periodos por ocho indicadores es trivial. Si el reloj de simulación se siente lento, el problema es que se está reevaluando toda la historia en cada paso desde la base de datos: la serie se carga una vez a memoria y el paso solo extiende la ventana.

**Sobre la presentación.** El reloj de simulación es el momento de la sustentación. Debe verse bien: transición de color del semáforo, aparición de la tarjeta de clasificación, y la explicación de qué regla disparó y por qué. Vale invertir tiempo de pulido ahí y no en otras pantallas.

---

## 12. Antipatrones — no hacer

- Usar `DateTime.now()` en `lib/domain/motor/`.
- Hacer que `R1` por sí sola dispare una acción correctora. Eso convierte el sistema en el umbral simple que se está criticando.
- Devolver estado `normal` cuando en realidad faltan periodos para evaluar.
- Dejar que el contraste retrospectivo mire periodos posteriores a `t`.
- Cerrar una acción automáticamente sin confirmación del usuario.
- Agregar cualquier paquete de red.
- Escribir umbrales del clasificador directamente en una condición sin exponerlos como configuración.
- Sembrar un caso de estudio con indicadores incoherentes entre sí.
- Presentar datos sintéticos sin etiquetarlos como tales.
- Construir un constructor de gráficas genérico. Las pantallas son las de la sección 9 y ninguna más.
- Dejar el `README.md` desactualizado al cerrar una fase.
