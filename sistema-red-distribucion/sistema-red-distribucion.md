# Sistema de Optimización de Red de Distribución

**Unidad 5 del curso de Logística — Capítulos 13 y 14 (Ballou, 5.ª ed.)**

> Documento de contexto. Explica **qué es** el sistema, **qué problema resuelve**, **qué hace y qué no hace**, y **cómo se conecta** con el resto de aplicaciones del repositorio. La fuente de verdad técnica para la construcción es `CLAUDE.md`; este documento es el que se usa para entender el producto y para sustentarlo.

---

## 1. El problema

Una empresa que distribuye producto físico enfrenta, cada cierto número de años, una pregunta que cuesta millones responder mal:

> ¿Cuántos centros de distribución debo tener, dónde deben estar, y qué clientes debe atender cada uno?

En la práctica esta decisión casi nunca se calcula. Se toma por intuición, por dónde apareció un terreno barato, por dónde vive el gerente, o por inercia histórica. El resultado típico es una red con flete cruzado: camiones de dos almacenes distintos pasando por la misma avenida el mismo día, cada uno atendiendo clientes que le quedan lejos.

El costo de esa decisión mal tomada no aparece en ninguna línea del estado de resultados. Aparece diluido durante años en el gasto de transporte, en inventario duplicado y en nivel de servicio perdido.

### Por qué es difícil

Porque los costos se mueven en direcciones opuestas. Al aumentar el número de almacenes:

- El **transporte de salida baja** (cada almacén está más cerca de sus clientes).
- El **transporte de entrada sube** (hay que abastecer más puntos desde las plantas).
- El **costo fijo de instalaciones sube** en escalones.
- El **inventario total sube**, y no de forma proporcional sino según la raíz cuadrada del número de ubicaciones.
- El **nivel de servicio mejora** (menos distancia al cliente).

El costo total no es monótono: baja, toca un mínimo y vuelve a subir. Encontrar ese mínimo a mano es inviable en cuanto hay más de tres o cuatro candidatos, porque el número de combinaciones crece exponencialmente.

---

## 2. Qué es este sistema

Un **sistema de decisión estratégica pre-inversión**. El usuario carga su realidad comercial (dónde están sus clientes, cuánto compra cada uno, qué sitios está considerando) y el sistema le devuelve la configuración de red de mínimo costo total, con el mapa, los números y la trazabilidad de cómo se llegó a ellos.

### Flujo central

1. El usuario define un **proyecto**: moneda, horizonte, familia de producto, unidad de peso.
2. Carga sus **clientes** con coordenadas y demanda anual.
3. El sistema **agrega los clientes en zonas de demanda** — paso obligatorio, no opcional (ver sección 5).
4. El usuario define **sitios candidatos** (a mano sobre el mapa, o generados automáticamente por centro de gravedad).
5. El sistema consulta **una matriz de distancias y tiempos reales por carretera** entre candidatos y zonas, que queda guardada en caché local.
6. El sistema corre **heurísticas de ubicación discreta** sobre el modelo de costo de seis componentes.
7. Devuelve: almacenes a abrir, asignación de cada zona, desglose de costo, **curva de costo total contra número de almacenes**, y mapa con territorios.
8. Exporta a PDF, CSV y JSON, y genera un enlace de visor web compartible.

---

## 3. Qué NO es este sistema

Esta lista es tan importante como la anterior. El alcance está cerrado.

- **No es un ruteador de vehículos.** No decide en qué orden visitar clientes ni cuántos camiones despachar hoy. Eso es la Unidad 3 y ya existe. Este sistema opera en horizonte de años, no de días.
- **No es un WMS.** No hay recepciones, surtido, existencias ni kardex. Este sistema decide dónde poner el almacén, no cómo operarlo.
- **No es un dimensionador de almacenes.** No calcula posiciones de tarima ni superficie construida. Eso es la Unidad 4 y ya existe. Este sistema entrega el volumen que debe manejar cada centro; la Unidad 4 lo convierte en metros cuadrados.
- **No es un GIS ni un CAD.** No hay dibujo libre de polígonos ni capas geográficas. El mapa es un lienzo de resultados, no una herramienta de edición cartográfica.
- **No es un solver comercial.** No hay programación lineal entera mixta exacta. Se usan heurísticas, que es lo que el propio capítulo 13 identifica como la metodología popular y práctica para ubicación de almacenes.
- **No es un sistema en línea.** No hay servidor propio, cuenta de usuario ni sincronización. La única dependencia externa es un servicio público de ruteo, y con caché el sistema opera sin conexión.

---

## 4. Anclaje teórico

Cada módulo del sistema corresponde a un contenido explícito del material del curso. Esta tabla es la que se usa en la sustentación.

| Módulo | Contenido del curso |
|---|---|
| Agregación de clientes en zonas de demanda | Cap. 14 — acumulación de datos, geocodificación, conversión de datos en información |
| Auditoría de calidad de datos | Cap. 14 — falta de información, fuentes de información, lista de verificación de datos |
| Generación de candidatos por centro de gravedad | Cap. 13 — ubicación de instalación sencilla, modelo de ubicación continua estática |
| Matriz de distancias reales | Cap. 13 — la distancia como factor de ubicación; corrige la aproximación en línea recta |
| Modelo de costo de seis componentes | Cap. 13 — balanceo de costos relevantes a la ubicación |
| Heurísticas ADD, DROP, intercambio, recocido | Cap. 13 — métodos heurísticos para ubicación de múltiples instalaciones |
| Asignación de zonas a almacenes | Cap. 14 — planeación y asignación acumuladas |
| Efecto del número de almacenes sobre el inventario | Cap. 9 — agrupación de riesgos, regla de la raíz cuadrada |
| Curva de costo total contra número de almacenes | Cap. 13 — compensación de costos, número óptimo de instalaciones |
| Restricción de nivel de servicio | Cap. 14 — auditoría de niveles de servicio al cliente |
| Horizonte multiperiodo | Cap. 13 — ubicación dinámica de almacén, trayectoria de configuración óptima |
| Comparador de escenarios | Cap. 14 — evaluación por comparación, análisis de qué pasa si |

---

## 5. Las tres decisiones de diseño que definen el producto

### 5.1 Ubicación discreta, no continua

El capítulo 13 presenta dos familias: métodos continuos (el centro de gravedad, que devuelve un punto cualquiera del plano) y métodos discretos (elegir entre sitios candidatos concretos).

**El sistema es discreto.** El centro de gravedad no desaparece: se degrada a **generador de candidatos**. Se calcula con distancia en línea recta, que es barata y no requiere red, y los puntos que arroja se agregan a la lista de sitios candidatos. La decisión final la toma el modelo discreto usando distancias reales de carretera.

Hay dos razones y ambas importan:

- **Razón práctica.** Un método continuo devuelve un punto que puede caer en medio de un río. Un método discreto solo propone sitios que el usuario ya verificó que existen y son comprables.
- **Razón técnica.** El servicio de matriz de distancias tiene un límite de coordenadas por consulta. Un método continuo necesitaría consultar la red en cada iteración hacia un punto nuevo. Un método discreto consulta **una sola matriz** de candidatos contra zonas y luego corre todas las heurísticas sobre esa matriz cacheada, sin red, en milisegundos.

### 5.2 La agregación de clientes es obligatoria

Una empresa con ochocientos clientes no puede pedir una matriz de ochocientos puntos. El servicio público de ruteo lo impide.

Pero esa restricción técnica coincide exactamente con lo que el capítulo 14 exige: **acumular los datos**. No se modela cliente por cliente, se modela por zonas de demanda. El sistema agrupa clientes cercanos en zonas ponderadas por volumen, y modela la zona como un punto único con la demanda sumada.

Esto convierte una limitación en una funcionalidad legítima con respaldo teórico. El sistema muestra el error de agregación introducido, para que el usuario sepa cuánta precisión sacrificó.

### 5.3 La caché de distancias es un activo, no un detalle

Cada consulta de matriz se guarda localmente indexada por un hash de la consulta. Consecuencias:

- Una vez calculada la matriz de un caso, **todo el análisis corre sin conexión**. Se pueden probar cincuenta escenarios sin volver a tocar la red.
- La demostración en vivo es inmune a que el servicio público esté caído o limitando peticiones ese día.
- El caso de estudio precargado viaja con su caché ya poblada.

---

## 6. Modelo de costo

El sistema minimiza el costo logístico total anual, compuesto por los seis rubros que el capítulo 13 identifica como relevantes para la decisión de ubicación:

| Rubro | Cómo se comporta al aumentar el número de almacenes |
|---|---|
| Producción y adquisición | Constante o levemente creciente |
| Transporte de entrada (planta → almacén) | **Sube** |
| Transporte de salida (almacén → zona de demanda) | **Baja** |
| Costo fijo de almacén | **Sube en escalones** |
| Almacenamiento y manejo (variable por volumen) | Aproximadamente constante |
| Manejo de inventario | **Sube según la raíz cuadrada** |
| Procesamiento de pedidos | Sube levemente |

El comportamiento opuesto de los rubros de transporte es lo que produce el mínimo. La curva de costo total contra número de almacenes, con ese mínimo marcado, es **la imagen que resume el capítulo entero** y es la pantalla central del sistema.

### Restricción de servicio

Además del costo, el usuario puede imponer un estándar de servicio: ninguna zona puede quedar a más de X kilómetros o Y minutos de su almacén asignado. Las configuraciones que violen el estándar quedan marcadas como inviables. Esto conecta la decisión de costo con la auditoría de servicio al cliente del capítulo 14.

---

## 7. Funcionalidades

### Núcleo

- Gestión de proyectos y escenarios comparables entre sí.
- Carga de clientes por formulario, importación CSV o selección sobre mapa.
- Agregación automática de clientes en zonas de demanda, con control del número de zonas y visualización del error de agregación.
- Auditoría de calidad de datos: coordenadas fuera de rango, demanda nula o negativa, duplicados, clientes huérfanos, tarifas faltantes.
- Gestión de sitios candidatos con costo fijo, capacidad y costo variable de manejo.
- Gestión de plantas u orígenes de abastecimiento.
- Matriz de distancias y tiempos reales por carretera, troceada, cacheada y con respaldo en línea recta cuando no hay red.
- Modelo de costo parametrizable por rubro.
- Heurísticas de ubicación: ADD, DROP, intercambio de vértices y recocido simulado.
- Asignación de zonas a almacenes con y sin restricción de capacidad.
- Barrido sobre el número de almacenes con generación de la curva de costo total.
- Efecto de agrupación de riesgos sobre el inventario mediante la regla de la raíz cuadrada.
- Restricción de nivel de servicio por distancia o por tiempo.

### Visualización

- Mapa con zonas de demanda dimensionadas por volumen, sitios candidatos, almacenes abiertos y **territorios de asignación coloreados**.
- Curva de costo total contra número de almacenes, con desglose por rubro apilado.
- Comparación lado a lado de la red actual contra la red propuesta, con el ahorro anual.
- Memoria de cálculo: para cada resultado, qué fórmula se aplicó y con qué valores.

### Salida

- Ficha técnica en PDF con mapa, tabla de asignación y desglose de costos.
- Exportación CSV de la asignación y JSON del proyecto completo.
- Enlace de visor web compartible, sin backend, para mostrar la red propuesta a alguien que no tenga la app.
- Exportación del volumen asignado a cada centro en el formato que consume el sistema de dimensionamiento de almacenes de la Unidad 4.

### Opcional según avance

- Horizonte multiperiodo con trayectoria de configuración óptima y costos de apertura y cierre.
- Estimación de tarifas de transporte faltantes por regresión sobre los envíos conocidos.

---

## 8. Cómo se conecta con el resto del repositorio

El sistema no vive aislado. Es la pieza estratégica de una cadena de decisiones que el repositorio ya cubre:

```
UNIDAD 5  →  ¿Cuántos centros, dónde, y qué territorio atiende cada uno?
                            ↓  (volumen anual asignado a cada centro)
UNIDAD 4  →  ¿Qué tamaño y configuración debe tener cada centro?
                            ↓  (centro dimensionado y ubicado)
UNIDAD 3  →  ¿En qué orden reparte cada centro sus entregas del día?
                            ↓  (rutas ejecutadas)
UNIDAD 2  →  ¿Se cumplió el nivel de servicio comprometido?
                            ↓  (indicadores de desempeño)
UNIDAD 6  →  ¿La red opera según lo diseñado? ¿Hay que replanear?
```

El vínculo con la Unidad 6 cierra el ciclo: cuando el sistema de control detecta una desviación estructural sostenida y la clasifica como **replaneación mayor**, la acción correctora que propone es literalmente volver a correr este sistema con los datos actualizados.

### Reutilización técnica concreta

De la Unidad 3 se reutiliza el motor geográfico completo, extraído a un paquete Dart compartido: cliente de ruteo con caché y control de peticiones, utilidades de distancia y geometría, y el selector de coordenadas sobre mapa. De la Unidad 4 se reutilizan el constructor de PDF, los widgets de gráficas y el patrón de memoria de cálculo trazable.

---

## 9. Caso de estudio

El sistema se entrega con un caso precargado y coherente, construido con **coordenadas reales verificadas**, no inventadas. El caso incluye clientes distribuidos en una región, un conjunto de sitios candidatos plausibles, plantas de origen y parámetros de costo realistas.

La caché de distancias del caso viaja poblada, de modo que la aplicación puede demostrarse completa sin conexión a internet.

Los datos del caso son editables y eliminables como cualquier otro registro: son datos precargados, no una demostración cerrada.

---

## 10. Qué defiende este sistema en la sustentación

Tres afirmaciones, en orden de fuerza:

1. **Las distancias son reales.** El modelo no usa distancia en línea recta corregida por un factor empírico, sino distancia efectiva por carretera. Esa es precisamente la limitación que el texto le atribuye a los métodos clásicos de ubicación.

2. **La restricción técnica y el requisito teórico coinciden.** La agregación de clientes en zonas no es un atajo: es lo que el capítulo 14 exige, y además es lo que hace viable la consulta de distancias. El sistema muestra explícitamente el error de agregación en vez de esconderlo.

3. **El resultado es auditable.** Cada número tiene memoria de cálculo. El usuario puede ver por qué el sistema abrió tres almacenes y no cuatro, y cuánto costaría la alternativa.

Y una advertencia honesta que también se sostiene: el sistema **predimensiona una decisión estratégica**. No sustituye el estudio de factibilidad, la negociación del terreno ni el criterio del gerente. Entrega la mejor configuración según el modelo, con sus supuestos a la vista.
