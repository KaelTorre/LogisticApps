# Fuentes reales para el catálogo semilla — Unidad 4

> Registro de investigación previo a construir `assets/catalogo_semilla.json` (Fase 0). Cada dato trae su fuente citada, tal como exige la sección 6 de CLAUDE.md. Lo que no tiene fuente verificable queda marcado `PENDIENTE` — no se inventa nada.

Alcance geográfico acordado: **Perú nacional**, proveedores/normativa con presencia o aplicación en el país, aunque la sede esté en Lima.

---

## 1. Camiones de diseño (`catalogo_camiones`) — CONFIRMADO

**Fuente:** Reglamento Nacional de Vehículos, Decreto Supremo Nº 058-2003-MTC, **Anexo IV: Pesos y Medidas**, numeral 1 "Pesos y Medidas Máximas Permitidas" (tabla incorporada por D.S. Nº 002-2005-MTC, numeral 1 modificado por D.S. Nº 019-2018-MTC). Texto oficial descargado de sutran.gob.pe.

Es la norma que rige qué combinaciones vehiculares pueden circular por la red vial peruana — exactamente el tipo de "camión de diseño" que pide M7 del CLAUDE.md.

### Ancho y alto máximos (aplican a todas las configuraciones)

| Medida | Valor | Nota |
|---|---|---|
| Ancho máximo (sin espejos) | **2.60 m** | Todo tipo de vehículo, incluida la carga |
| Altura máxima — categoría N (camiones) | **4.10 m** | |
| Altura máxima — categoría O, semirremolque compartimento cerrado | **4.30 m** | |
| Altura máxima — categoría O, transporte de contenedores | **4.30 m** | |
| Altura máxima — categoría O, contenedores High Cube | **4.60 m** | |

### Longitudes máximas por configuración vehicular (selección relevante para almacén/andén)

| Config. | Nº de ejes | Long. máx. (m) | Descripción |
|---|---|---|---|
| `C2` | 2 | 12.30 | Camión rígido 2 ejes |
| `C3` | 3 | 13.20 | Camión rígido 3 ejes |
| `C4` | 4 | 13.20 | Camión rígido 4 ejes |
| `T2S1` | 3 | 20.50 | Tracto (2 ejes) + semirremolque (1 eje) |
| `T2S2` | 4 | 20.50 | Tracto (2 ejes) + semirremolque (2 ejes) |
| `T2S3` | 5 | 20.50 | Tracto (2 ejes) + semirremolque (3 ejes) |
| `T3S1` | 4 | 20.50 | Tracto (3 ejes) + semirremolque (1 eje) |
| `T3S2` | 5 | 20.50 | Tracto (3 ejes) + semirremolque (2 ejes) |
| `T3S3` | 6 | 22.00 | Tracto (3 ejes) + semirremolque (3 ejes) |
| `C2R2` | 4 | 23.00 | Camión (2 ejes) + remolque (2 ejes) |
| `C3R3` | 6 | 23.00 | Camión (3 ejes) + remolque (3 ejes) |
| `T3S2S2` | 7 | 23.00 | Bitrén |

Longitudes de vehículos de categoría O individuales (entre parachoques): remolque 10.00 m, remolque balanceado 8.50 m, semirremolque 14.68 m.

**Recomendación para la semilla:** cargar `C2` (reparto urbano), `C3` (distribución regional) y `T2S2` (carga interprovincial/contenedor) como las tres entradas base de `catalogo_camiones` — cubren el rango real de lo que llega a un andén de almacén en Perú, con `largo_mm` exacto de la tabla y `ancho_mm = 2600` fijo.

**Fuente completa:** [D.S. Nº 058-2003-MTC — Reglamento Nacional de Vehículos](https://www.sutran.gob.pe/wp-content/uploads/2020/06/Reglamento-Nacional-de-Veh%C3%ADculos-%E2%80%93-DS-N%C2%BA-058-2003-MTC.pdf), Anexo IV.

---

## 2. Patio de maniobras (`patio_min_mm`) — GUÍA PRÁCTICA, no norma certificada

El RNV regula circulación en vía pública, **no** dimensiona patios internos de almacén — ese dato no existe como norma peruana. La única fuente encontrada es una guía práctica de diseño de bodegas (Centro de Ofibodegas, Guatemala), basada en experiencia operativa, no en un reglamento:

| Tipo de vehículo | Profundidad de patio recomendada |
|---|---|
| Semirremolque / tráiler 40′ | 25–35 m (hasta 30–40 m si el acceso tiene curvas previas) |
| Vehículo rígido/mediano | 18–25 m (si el andén está alineado recto) |

**Fuente:** [Cómo dimensionar patios de maniobra y parqueos en una ofibodega](https://www.centrodeofibodegas.com/blog/dimensionar-patios-maniobra-parqueos-ofibodega/) — Centro de Ofibodegas.

**[REGLA a aplicar]** Igual que con los anchos de pasillo de equipos (sección 6.4 de CLAUDE.md), esto debe marcarse en la UI como predimensionamiento de referencia, no como valor certificado. Sugiero `fuente = "Centro de Ofibodegas (guía práctica, no normativa) — ver docs/fuentes_catalogo.md"` en vez de `ESTIMADO` puro, porque sí hay una fuente real detrás, solo que no es una norma.

---

## 3. Bastidores y vigas (`catalogo_bastidores`, `catalogo_vigas`) — CONFIRMADO (parcial)

**Fuente:** Mecalux (mecalux.pe / mecalux.com.mx) — distribuidor multinacional de racks con presencia comercial en Perú, ficha técnica de rack selectivo.

Confirma exactamente los valores que CLAUDE.md sección 6.2 ya proponía como semilla:

- Fondo de bastidor estándar: **1100 mm**, derivado de tarima de 1200 mm de profundidad (regla `fondo = fondo_tarima − 2×voladizo` con voladizo ≈ 50 mm en este caso, distinto del 75 mm genérico de EN 15620 — **revisar cuál usa el fabricante realmente antes de fijarlo en la semilla**).
- Bastidores ranurados cada **50 mm** (paso de ajuste de puntal métrico, coincide con lo ya definido en M3 sección 3 de CLAUDE.md).
- Largos de viga estándar:
  - Tarimas europeas (800×1200): **1825, 2700, 3600 mm**
  - Tarimas americanas (1000×1200): **2225, 3300 mm**

**Capacidad de carga por par de vigas (kg) — investigado a fondo, conclusión: no es un dato de catálogo, es cálculo estructural caso por caso.**

Descargué y leí el manual técnico de un fabricante real de racks (Industrias Bono S.R.L., Argentina — [MANUAL TÉCNICO RACKS SELECTIVOS I-566-MD-ME-01](https://industriasbono.com.ar/wp-content/uploads/2020/11/MANUAL-TECNICO-RACKS-SELECTIVOS-I-566-MD-ME-01.pdf), dic. 2019). Confirma por qué ningún fabricante publica una tabla abierta de "kg por par de vigas": la capacidad depende de la sección exacta del perfil (área, momento de inercia, módulo resistente — el manual trae las propiedades mecánicas completas de sus perfiles de 110 mm y 160 mm) combinada con la luz de la viga, la deflexión admisible (**L/180**, norma citada) y un factor de impacto del **25%** sobre la carga en operación. Calcular la capacidad admisible a partir de esas propiedades **es exactamente el cálculo estructural que la sección 1 de CLAUDE.md prohíbe hacer** ("No es un certificador estructural... el cálculo estructural lo firma un ingeniero con la norma completa").

**Conclusión para la semilla:** `capacidad_par_g` en `catalogo_vigas` no debe llenarse con un número calculado por este proyecto. Debe:
1. Quedar `NULL`/`ESTIMADO` explícito por defecto, o
2. Cargarse solo cuando se tenga la ficha técnica de un producto comercial concreto (con su `fuente` = nombre del fabricante + código de producto), nunca derivado de las propiedades de sección.

**Dato real que sí sirve y no estaba en CLAUDE.md:** el mismo manual cita el estándar **ARLOG** (Asociación Argentina de Logística) para el pallet 1000×1200mm: **carga nominal 1250 kg/pallet** (incluyendo el peso propio del pallet) como valor de diseño de unidad de carga. Es un buen default real para `familias_producto.peso_carga_g` cuando el usuario no tiene su propio dato, aunque es una fuente regional (Argentina) y debe marcarse así si se usa como sugerencia, no como oficial de Perú.

**Altura de bastidor — CONFIRMADO, pero cambia el significado del campo.** Mecalux no vende bastidores en alturas fijas discretas (no hay "tallas" S/M/L como en las vigas): se fabrican de una sola pieza hasta **12 000 mm**; más allá se necesita un ensamble conector para empalmar dos piezas, y las instalaciones automatizadas superan los 40 m con esa técnica. Se sembró `altura_mm = 12000` en los 4 bastidores, **reinterpretando el campo como "altura máxima de una sola pieza sin conector"**, no como "la altura del producto". Documentado en el propio JSON (bloque `notas`) para que el motor M3 no lo trate como si fuera un valor de catálogo fijo.

**PENDIENTE — no encontrado en fuentes abiertas:**
- Perfil del bastidor (ancho/fondo del puntal, 80×50mm sembrado) — sigue siendo una dimensión típica de la industria, no verificada esta sesión.

**Fuente:** [Mecalux — Rack selectivo](https://www.mecalux.com.mx/racks-industriales/rack-selectivo), [Estantería convencional — mecalux.pe](https://www.mecalux.pe/estanterias-paletizacion/estanterias-paletizacion-convencional).

---

## 4. Tarimas (`catalogo_tarimas`) — CONFIRMADO, las 6 con alto/tara/carga reales

La huella (largo×ancho) de las 6 tarimas ya estaba cubierta por ISO 6780 en CLAUDE.md sección 6.1. En la revisión posterior se completó alto, tara y capacidad de carga de las 5 que faltaban (solo EPAL las traía completas desde el inicio):

| Código | Alto (mm) | Tara (g) | Carga din./est. (g) | Fuente |
|---|---|---|---|---|
| GMA | 165 | 16800 | 1134000 / 2085000 | Interlake Mecalux + FreightAmigo |
| ASIA-1100 (T11) | 150 | 18500 | 1250000 / — | JIS Z0604, Japan Pallet Association |
| ISO-1067 (42″) | 152 | 17000 | — / 1678000 | Distribuidores comerciales 42″×42″ (Uline y otros) |
| AU-1165 | 150 | 35000 | — / 2000000 | AS 4068-1993 + CHEP Australia |
| ISO-1200×1000 | 144 | 28000 | — | Rango genérico de fuentes comerciales (18-30kg tara, 120-150mm alto) — la huella más citada globalmente pero sin ficha de un fabricante único |

Ninguna quedó con el placeholder copiado de EPAL. El detalle de cada búsqueda queda en el propio `fuente` de cada fila en `assets/catalogo_semilla.json`.

---

## 5. Equipos de manutención (`catalogo_equipos`) — CONFIRMADO (contrabalanceado y retráctil), parcial (VNA)

**Distribuidores confirmados con presencia en Perú:**
- **Ferreyros** — representante de Komatsu en Perú (incluye montacargas).
- **MASA Equipos Industriales** — distribuidor exclusivo de Toyota Material Handling en Perú (grupo Mitsui).
- **Eurolift** — representante oficial de Hyster en Perú.

### Contrabalanceado — Hyster Serie S40-70FT (fuente: guía técnica oficial Hyster, LatAm)

Descargada y leída directamente la guía técnica oficial (PDF, Hyster Company, edición Latinoamérica, 4/2015). Tabla real, sin intermediarios:

| Modelo | Capacidad (kg) | Altura elevación TOF (mm) | Ancho total (mm) | Radio de giro mín. ext. (mm) | Pasillo apilado 90° * (mm) |
|---|---|---|---|---|---|
| S40FT | 1814 | 3292 | 1067 | 1950 | 2340 |
| S50FT | 2268 | 3292 | 1067 | 2000 | 2390 |
| S55FTS | 2495 | 3292 | 1108 | 1937 | 2327 |
| S60FT | 2722 | 3209 | 1108 | 2066 | 2468 |
| S70FT | 3175 | 3209 | 1158 | 2066 | 2521 |

`*` "Anchura de pasillo, apilado en ángulo recto" es un valor **base al que hay que sumar la longitud de la carga** (así lo indica la propia guía). Con una tarima estándar de ~1200 mm de largo, el pasillo real queda en **3540–3721 mm** — esto **confirma** el rango 3500–4000 mm que CLAUDE.md sección 6.4 ya tenía para clase EN 400. Documentar esta fórmula (`pasillo_min = valor_tabla + longitud_carga`) en el motor, no un número fijo.

**Fuente:** [Guía técnica Hyster S40-70FT, motor de combustión interna contrabalanceado](https://www.hyster.com/globalassets/coms/hyster/latin-america/documents/trucks/ic-cushion/low_res_s40-70ft-tg_spa.pdf) — Hyster Company, edición LatAm, 4/2015.

### Retráctil — Hyster Serie N30-45ZR3 / N30-35ZDR3 (fuente: guía técnica oficial Hyster, LatAm)

| Modelo | Capacidad (kg) | Radio de giro mín. ext. (mástil 5.5", compartimento batería 14.25") | Altura elevación libre máx. |
|---|---|---|---|
| N30ZDR3 | 1361 | 65.6″ (≈ 1666 mm) | ver tabla de mástiles, hasta 9347 mm TOF |
| N35ZDR3 | 1588 | 65.6″ (≈ 1666 mm) | hasta 10262–11278 mm TOF (versión XL) |
| N35ZR3 | 1588 | 65.6″ (≈ 1666 mm) | hasta 9347 mm TOF |
| N40ZR3 | 1814 | 65.6″ (≈ 1666 mm) | hasta 8636 mm TOF |
| N45ZR3 | 2041 | 72.6″ (≈ 1844 mm) | hasta 9347 mm TOF |

**PENDIENTE:** la propia guía remite la anchura de pasillo a una "tabla de estibado en ángulo recto" en una página posterior que no llegué a extraer en esta sesión — la capacidad y las alturas de mástil sí quedaron confirmadas con fuente real, el pasillo exacto de este modelo concreto queda para una siguiente pasada (mientras tanto sigue válido el rango EN 2700–3000 mm ya citado en CLAUDE.md).

**Fuente:** [Guía técnica Hyster N30-45ZR3 / N30-35ZDR3, montacargas retráctil de almacén](https://www.hyster.com/globalassets/coms/hyster/latin-america/documents/trucks/reach-trucks/2015hbc2sp001-e-es-mx-warehouse-tech-guide.pdf) — Hyster Company, edición LatAm.

### Trilateral / VNA — Hyster V30-35ZMU (fuente: página de producto Hyster, LatAm)

- Capacidad: 1300 kg (W30ZMU L) / 1500 kg (W35ZMU L, S, M)
- Altura de elevación máxima: 12 315 mm (W30ZMU L) / 15 945 mm (W35ZMU, todos los modelos)
- Requiere guiado por naturaleza del equipo (trilateral para pasillos muy angostos), consistente con la fila `requiere_guiado = 1` que CLAUDE.md ya definía para esta clase — la página de producto no publicó el ancho de pasillo exacto ni confirma explícitamente riel vs. inducción.

**Fuente:** [Hyster V30-35ZMU — Montacargas para pasillos muy angostos](https://www.hyster.com/es-mx/latin-america/montacargas-para-pasillos-muy-angostos/v30-35zmu/) — Hyster LatAm.

**PENDIENTE, no confirmado:** Komatsu (Ferreyros) y Toyota (MASA) — confirmé que ambos distribuidores operan en Perú, pero las páginas públicas no entregaron tablas completas limpias (Komatsu FD30T-16/FG30T-16 solo confirmó capacidad 3000 kg vía Scribd, sin el resto de dimensiones). Si se quiere diversificar el catálogo más allá de Hyster, hace falta pedir la ficha técnica PDF directa a Ferreyros o MASA.

---

## Resumen — qué queda listo vs qué falta

| Tabla | Estado | Acción siguiente |
|---|---|---|
| `catalogo_camiones` (largo/ancho) | ✅ Fuente oficial (RNV), 3 configs cargadas | Ninguna |
| `catalogo_camiones.patio_min_mm` | ⚠️ Guía práctica real, no normativa (Guatemala) | Ninguna por ahora — decisión tomada de dejarlo así |
| `catalogo_tarimas` | ✅ Las 6 con huella, alto, tara y carga confirmados | Ninguna |
| `catalogo_bastidores` (fondo, altura máx. pieza) | ✅ Confirmados contra Mecalux | Ninguna |
| `catalogo_bastidores` (perfil ancho/fondo) | ⚠️ Dimensión típica de industria, no verificada | Pendiente si se quiere precisión estructural real |
| `catalogo_vigas` (largo, peralte) | ✅ Confirmadas contra Mecalux + Industrias Bono | Ninguna |
| `catalogo_vigas.capacidad_par_g` | ❌ Por diseño, no es dato de catálogo — es cálculo estructural fuera de alcance del proyecto (ver sección 3) | Dejar `NULL` salvo que se cargue un producto comercial concreto con ficha propia |
| `catalogo_equipos` — contrabalanceado | ✅ Fuente oficial Hyster (LatAm), confirma rango EN ya citado | Ninguna |
| `catalogo_equipos` — retráctil | ✅ Elevación y mástil confirmados; pasillo exacto pendiente | Extraer tabla de estibado de la misma guía Hyster (página no leída aún) |
| `catalogo_equipos` — trilateral/VNA | ⚠️ Elevación confirmada, pasillo no publicado | Igual que arriba, o cotizar a Eurolift |
| `catalogo_equipos` — transelevador | ❌ Deliberadamente no sembrado | Sin acción — se agrega cuando haya ficha real de fabricante |
