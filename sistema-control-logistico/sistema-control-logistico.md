# Sistema de Control Logístico de Lazo Cerrado

**Unidad 6 del curso de Logística — Capítulos 15 y 16 (Ballou, 5.ª ed.)**

> Documento de contexto. Explica **qué es** el sistema, **qué problema resuelve**, **qué hace y qué no hace**, y **cómo se conecta** con el resto de aplicaciones del repositorio. La fuente de verdad técnica para la construcción es `CLAUDE.md`; este documento es el que se usa para entender el producto y para sustentarlo.

---

## 1. El problema

Las empresas medianas miden. Tienen indicadores de costo de transporte, de cumplimiento de entregas, de productividad de almacén. Los ponen en un Excel, los proyectan en la reunión mensual y no pasa nada.

El problema no es la falta de medición. Es que **medir no es controlar**. Entre el dato y la decisión falta un proceso, y ese proceso casi nunca existe formalmente.

Cuando sí existe alguna alerta, suele estar mal construida. La regla típica es `si el valor supera la meta, alarma`. Eso produce dos fallas simultáneas:

- **Ruido.** Un mes atípico dispara una alarma que no ameritaba acción. Después de la tercera falsa alarma, nadie las mira.
- **Ceguera.** Un deterioro lento y sostenido —el más peligroso, porque es estructural— nunca cruza el umbral hasta que ya es grave. Cuando la alarma finalmente suena, el problema lleva meses instalado.

El capítulo 16 es explícito al respecto: que los costos estén altos y el servicio bajo **no significa por sí solo que deba iniciarse una acción correctora**. Esa frase es la tesis de este sistema.

---

## 2. Qué es este sistema

Un **sistema de control administrativo por periodos** que implementa el modelo de control del capítulo 16 como lazo cerrado real: entradas, proceso, salida, estándares, monitor y acción correctora, con verificación posterior.

Recibe mediciones de desempeño, evalúa **la serie completa** contra un conjunto de reglas de patrón, y cuando detecta una desviación que amerita acción, la clasifica en una de las tres magnitudes de respuesta que define el texto, propone acciones concretas, registra lo que se decidió, y **verifica en el periodo siguiente si funcionó**.

### El ciclo completo

1. **Definir** el indicador: meta, banda de tolerancia, periodicidad y sentido (si menor es mejor o mayor es mejor).
2. **Capturar** la medición del periodo.
3. **Evaluar** la serie con las reglas de patrón. No el punto contra el umbral: la serie.
4. **Clasificar** la magnitud de la respuesta requerida.
5. **Proponer** acciones correctoras desde la biblioteca, según el tipo de desviación y el indicador afectado.
6. **Registrar** la acción elegida, con responsable y fecha comprometida.
7. **Verificar** en el periodo siguiente si la desviación se corrigió, y dejar constancia de si la acción sirvió.

El paso 7 es el que cierra el lazo y es el que ninguna herramienta de tablero tiene. Un tablero de indicadores se detiene en el paso 3.

---

## 3. Qué NO es este sistema

- **No es un ERP ni un WMS.** No registra transacciones, pedidos ni movimientos. Recibe indicadores **ya calculados**.
- **No es tiempo real.** No observa eventos de la operación. Trabaja por periodos definidos: diario, semanal, mensual o trimestral según el indicador.
- **No es un tablero de inteligencia de negocios.** Un tablero muestra. Este decide si hay que actuar, propone qué hacer y verifica el resultado.
- **No genera soluciones nuevas.** Selecciona desde una biblioteca de acciones correctoras mediante reglas. Es un sistema experto, no un generador.
- **No sustituye el criterio gerencial.** Propone y documenta; la persona elige. El propio texto describe el objetivo como especificar las líneas de acción que el gerente debería emprender, no reemplazarlo.
- **No usa servicios de inteligencia artificial en la nube.** El reconocimiento de patrones es control estadístico de procesos y reglas deterministas, escrito localmente.

---

## 4. La diferencia con un umbral simple

Este es el núcleo del producto y conviene verlo con números. Indicador de costo de transporte, meta S/ 1.20 por tonelada-kilómetro, banda de tolerancia de ±8 %, es decir el rango de S/ 1.104 a S/ 1.296.

| Periodo | Valor | Umbral simple | Este sistema |
|---|---|---|---|
| 1 | 1.18 | Normal | Normal |
| 2 | **1.33** | **¡Alarma!** | Observación registrada, sin acción — punto aislado sin tendencia previa |
| 3 | 1.21 | Normal | Normal |
| 4 | 1.24 | Normal | Normal |
| 5 | 1.26 | Normal | Normal |
| 6 | 1.28 | Normal | Normal |
| 7 | 1.29 | Normal | **Tendencia adversa confirmada** — cinco lecturas consecutivas ascendentes por encima de la meta |
| 8 | 1.29 | Normal | Seguimiento de la acción tomada |
| 9 | 1.28 | Normal | Seguimiento |
| 10 | 1.29 | Normal | Seguimiento |
| 11 | **1.31** | **¡Alarma!** | Ya estaba en gestión desde el periodo 7 |
| 12 | 1.34 | ¡Alarma! | — |

Observa lo que pasó en las dos filas críticas:

- **Periodo 2:** el valor se salió de la banda y el sistema **no** disparó acción. El umbral simple sí — y era una falsa alarma.
- **Periodo 7:** el valor estaba **dentro** de la banda y el sistema **sí** disparó. El umbral simple no vio nada durante cuatro periodos más.

Un umbral simple se equivocó en ambas direcciones: ruido cuando no tocaba, silencio cuando sí. Esa tabla es el argumento central de la sustentación y el sistema la genera automáticamente mediante su módulo de contraste retrospectivo.

---

## 5. Las tres magnitudes de respuesta

Cuando el sistema confirma una desviación, no dice simplemente "hay un problema". Clasifica la magnitud de la respuesta según las tres categorías que define el capítulo 16:

**Ajuste menor.** La desviación es moderada y anticipable. Basta retocar la mezcla de actividades. Ejemplo: el costo de transporte sube por baja consolidación → revisar el factor de carga, agrupar embarques, renegociar la tarifa vigente.

**Replaneación mayor.** La desviación es sostenida y estructural. Hay que replanificar con anticipación a la necesidad. Ejemplo: el costo de transporte sube porque la geografía de la demanda cambió y la red de distribución ya no corresponde → **volver a correr el sistema de diseño de red de la Unidad 5**. Ese enganche no es retórico: es una acción concreta de la biblioteca que apunta a otra aplicación del repositorio.

**Plan de contingencia.** Reevaluación completa del sistema logístico por cambio de objetivos, del entorno o del portafolio de productos. Ejemplo: varios indicadores de procesos distintos se deterioran simultáneamente, lo que sugiere una causa común que ninguna acción puntual va a resolver.

La clasificación es determinista y auditable: depende de la magnitud de la desviación, de su persistencia y de cuántos indicadores relacionados están afectados a la vez.

---

## 6. El problema del tiempo, y cómo se resuelve

Un sistema que detecta patrones necesita historia. La objeción natural es: *¿entonces hay que usarlo tres años para ver si sirve?*

No. La solución es una decisión de arquitectura tomada desde el inicio:

> **El periodo es un dato de la medición, no el reloj del computador.**

El motor de evaluación nunca pregunta qué fecha es hoy. Recibe una serie de mediciones etiquetadas por periodo y las evalúa. Consecuencia: **el tiempo del modelo es independiente del tiempo del calendario**, y una historia de treinta y seis periodos se carga y se procesa en segundos.

Sobre esa base se construyen cuatro capacidades:

**Generador de series sintéticas.** El usuario define un indicador y elige qué patrón inyectar: serie estable, punto aislado atípico, tendencia sostenida, corrimiento de media, estacionalidad o deterioro brusco. El generador produce la serie con ruido realista. No es un truco de demostración: es una **herramienta de calibración**, porque un gerente necesita saber si su banda de tolerancia está bien puesta antes de aplicarla al negocio real.

**Reloj de simulación.** La aplicación muestra solo los primeros periodos de una serie cargada. Un control de "avanzar periodo" incorpora el siguiente, reevalúa las reglas y actualiza el estado. En la demostración, el público ve el semáforo cambiar y la clasificación aparecer en el momento exacto. Los datos estaban ahí desde el principio; el sistema simplemente no los había visto.

**Contraste retrospectivo.** Como la serie completa está disponible, el motor puede correr hacia atrás y responder en qué periodo habría detectado cada método la desviación, y cuántas falsas alarmas habría producido cada uno. Es la tabla de la sección 4, generada automáticamente.

**Importación de historia real.** Y esta es la respuesta de fondo: en el mundo real el sistema tampoco arranca vacío. Cualquier empresa mediana tiene dos o tres años de indicadores en hojas de cálculo. Se importa el archivo y el sistema opera con historia desde el primer día. El escenario de "instalarlo y esperar tres años" no ocurre.

### Honestidad sobre lo que aún no se puede evaluar

Cada regla necesita un mínimo de periodos. Cuando no los hay, el sistema lo dice en vez de fingir:

> *Utilización de andén — Regla "tendencia sostenida": no evaluable todavía (3 de 5 periodos mínimos). Faltan 2 mediciones.*

Ese mensaje es mejor producto y además es la respuesta preparada para la pregunta obvia del jurado.

---

## 7. Anclaje teórico

| Módulo | Contenido del curso |
|---|---|
| Modelo de control: entradas, proceso, salida, estándares, monitor | Cap. 16 — estructura del proceso de control |
| Lazo abierto, lazo cerrado y control modificado | Cap. 16 — tipos de sistemas de control |
| Banda de tolerancia al error | Cap. 16 — detalles del sistema de control, tolerancia de error |
| Reconocimiento de patrones de desempeño | Cap. 16 — enlaces de control para inteligencia artificial |
| Clasificación en ajuste menor, replaneación mayor y contingencia | Cap. 16 — acción correctora |
| Informe de costo y servicio | Cap. 16 — informes de medición clave |
| Informe de productividad | Cap. 16 — índices de productividad |
| Tabla de desempeño y detección de tendencia adversa | Cap. 16 — tabla de desempeño |
| Presupuesto y centro de utilidades | Cap. 16 — el control en la práctica |
| Auditoría de inventario y de facturas de transporte | Cap. 16 — información de control, medición e interpretación |
| Evaluación comparativa | Cap. 16 — comparación con otras empresas |
| Modelo de referencia de operaciones | Cap. 16 — ROCS |
| Diagnóstico de estructura organizacional | Cap. 15 — posicionamiento, orientación y opciones organizacionales |
| Costo de la fragmentación entre funciones | Cap. 15 — fragmentación organizacional, dirección interfuncional |

---

## 8. Funcionalidades

### Núcleo de control

- Catálogo de indicadores con meta, banda de tolerancia, periodicidad, unidad y sentido de mejora, clasificados en costo, servicio y productividad.
- Calendario de periodos definido por el usuario, independiente del reloj del sistema.
- Captura de mediciones por formulario, importación de archivo o derivación desde las otras aplicaciones del repositorio.
- Motor de reglas de patrón configurable por indicador.
- Clasificador de magnitud de respuesta.
- Biblioteca de acciones correctoras, sembrada y ampliable, con reglas de emparejamiento.
- Registro de acciones tomadas con responsable, fecha comprometida y estado.
- Verificación automática en el periodo siguiente, con registro de si la acción resultó efectiva.
- Memoria de evaluación: para cada veredicto, qué reglas se dispararon, con qué valores y por qué.

### Laboratorio de escenarios

- Generador de series sintéticas con seis patrones controlados y nivel de ruido ajustable.
- Reloj de simulación para avanzar y retroceder periodos.
- Contraste retrospectivo entre umbral simple y reconocimiento de patrones, con tabla de periodo de detección y conteo de falsas alarmas.
- Calibrador de banda de tolerancia: dado un histórico, propone la banda que minimiza falsas alarmas sin perder detecciones reales.

### Informes

- Informe de costo y servicio: costos logísticos totales desglosados por actividad, con peso relativo de cada una y nivel de servicio obtenido.
- Informe de productividad con sus índices.
- Tabla de desempeño con seguimiento en el tiempo y marcado de tendencias adversas.
- Presupuesto contra real, con análisis de variaciones.
- Logística como centro de utilidades, con precios de transferencia internos.
- Exportación a PDF.

### Módulos complementarios

- Diagnóstico de estructura organizacional: etapa de desarrollo, opción organizacional, posición en los ejes de centralización y de asesor contra línea, y orientación dominante entre proceso, mercado e información.
- Auditoría de facturas de transporte: recálculo contra el tarifario contratado y detección de discrepancias en tarifa, peso, descripción y ruta, con cuantificación del monto recuperable.

---

## 9. De dónde salen los datos

Tres vías, en orden de esfuerzo:

1. **Captura manual.** Formulario por indicador y periodo.
2. **Importación de archivo.** CSV con la serie histórica completa, que es la vía normal de puesta en marcha.
3. **Derivación desde el repositorio.** Opcional pero de alto valor demostrativo: el cumplimiento de nivel de servicio del sistema de la Unidad 2, la distancia y el costo por ruta del sistema de la Unidad 3, la utilización de superficie del sistema de la Unidad 4, y el costo logístico proyectado del sistema de la Unidad 5.

Esa tercera vía convierte el conjunto en una plataforma: las aplicaciones que ejecutan alimentan a la aplicación que controla, y cuando el control detecta un problema estructural, la acción correctora devuelve al usuario a la aplicación que planifica.

---

## 10. Cómo cierra el ciclo del curso

```
UNIDAD 5  →  PLANEAR    ¿cómo debe ser la red?
UNIDAD 4  →  DIMENSIONAR ¿qué tamaño tiene cada instalación?
UNIDAD 3  →  EJECUTAR   ¿cómo se reparte hoy?
UNIDAD 2  →  MEDIR      ¿se cumplió lo prometido?
UNIDAD 6  →  CONTROLAR  ¿hay que corregir, replanear o reevaluar todo?
                              ↓
                        si la respuesta es "replanear" → vuelve a UNIDAD 5
```

Ese retorno del control a la planeación es literalmente el lazo cerrado del capítulo 16, materializado en software que existe.

---

## 11. Qué defiende este sistema en la sustentación

1. **Detecta antes y molesta menos.** La tabla de contraste retrospectivo lo demuestra con números: detección cuatro periodos antes que un umbral simple, y sin la falsa alarma que el umbral produjo.

2. **Cierra el lazo.** No se detiene en mostrar el problema. Clasifica su magnitud, propone acción, registra la decisión y verifica el resultado. Un tablero de indicadores no hace ninguna de las últimas cuatro cosas.

3. **Es honesto sobre sus límites.** Declara cuándo una regla todavía no es evaluable, distingue una observación registrada de una acción requerida, y deja claro que selecciona acciones de una biblioteca en vez de inventarlas.

Y la advertencia que también se sostiene: el sistema **apoya la decisión gerencial, no la reemplaza**. Documenta, ordena y anticipa; la responsabilidad de actuar sigue siendo de una persona.
