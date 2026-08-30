// Visor de red de distribución — página estática, sin backend.
//
// Recibe los datos del escenario codificados en el fragmento de la URL
// (`#z=<base64url>`, generado por la app Flutter — ver
// lib/domain/export/exportar_visor_red.dart) y dibuja el mapa con Leaflet +
// tiles de OpenStreetMap: almacenes abiertos, zonas de demanda y una línea
// recta de asignación entre cada zona y el almacén que la sirve. A
// diferencia de `visor-web` (rutas de la Unidad 3), acá no hay geometría de
// carretera que pedirle a ningún servicio — las líneas son rectas, el mismo
// criterio que usa la Pantalla 11 de la app.
//
// El color de cada almacén viaja ya resuelto en el payload (no se
// recalcula acá) — ver el comentario en `exportar_visor_red.dart` sobre por
// qué: portar el algoritmo de paleta con contraste real a JavaScript sin
// compartir código con Dart es un riesgo de desincronización que no vale la
// pena para un puñado de colores por escenario.

const COLOR_SIN_ASIGNAR = '#898781';
const COLOR_NO_CUBIERTA = '#d4302a';

const SVG_WAREHOUSE = `<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 21V10a1 1 0 0 0-1-1H7a1 1 0 0 0-1 1v11"/><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V8a2 2 0 0 1 1.132-1.803l7.95-3.974a2 2 0 0 1 1.837 0l7.948 3.974A2 2 0 0 1 22 8z"/><path d="M6 13h12"/><path d="M6 17h12"/></svg>`;

function base64UrlABytes(codificado) {
  const base64 = codificado
    .replace(/-/g, '+')
    .replace(/_/g, '/')
    .padEnd(codificado.length + ((4 - (codificado.length % 4)) % 4), '=');
  const binario = atob(base64);
  const bytes = new Uint8Array(binario.length);
  for (let i = 0; i < binario.length; i++) bytes[i] = binario.charCodeAt(i);
  return bytes;
}

// Descomprime DEFLATE crudo (sin encabezado zlib/gzip) con la API nativa del
// navegador — sin librerías externas. Requiere un navegador relativamente
// reciente (Chrome/Edge 80+, Firefox 113+, Safari 16.4+); si no está
// disponible, lanza para que `iniciar()` muestre un mensaje claro en vez de
// fallar en silencio.
async function inflateRaw(bytes) {
  if (typeof DecompressionStream === 'undefined') {
    throw new Error('NAVEGADOR_SIN_SOPORTE');
  }
  const flujo = new DecompressionStream('deflate-raw');
  const escritor = flujo.writable.getWriter();
  escritor.write(bytes);
  escritor.close();
  const salida = await new Response(flujo.readable).arrayBuffer();
  return new Uint8Array(salida);
}

async function decodificarDatosDeLaUrl() {
  const parametros = new URLSearchParams(location.hash.slice(1));
  const comprimido = parametros.get('z');
  if (!comprimido) return null;

  const bytes = await inflateRaw(base64UrlABytes(comprimido));
  const json = new TextDecoder('utf-8').decode(bytes);
  return JSON.parse(json);
}

function iconoAlmacen(color) {
  return L.divIcon({
    className: '',
    html: `<div class="marcador-almacen" style="color:${color}">${SVG_WAREHOUSE}</div>`,
    iconSize: [26, 26],
  });
}

function mostrarError(mensaje) {
  const estado = document.getElementById('estado');
  estado.textContent = mensaje;
  estado.classList.add('error');
  estado.hidden = false;
}

async function iniciar() {
  let datos;
  try {
    datos = await decodificarDatosDeLaUrl();
  } catch (e) {
    if (e instanceof Error && e.message === 'NAVEGADOR_SIN_SOPORTE') {
      mostrarError(
        'Tu navegador es muy antiguo para abrir este link. Probá con una ' +
          'versión reciente de Chrome, Firefox, Edge o Safari.',
      );
      return;
    }
    throw e;
  }
  if (!datos) {
    mostrarError(
      'Este link no trae datos de ninguna red. Pídele a quien te lo ' +
        'compartió que lo genere de nuevo desde la app.',
    );
    return;
  }

  const almacenes = datos.alm || []; // [[nombre, lat, lon, colorHex], ...]
  const zonas = datos.zon || []; // [[etiqueta, lat, lon, indiceAlmacen|null, cumple01], ...]

  document.getElementById('titulo-escenario').textContent = datos.esc || 'Red de distribución';
  const noCubiertas = zonas.filter((z) => z[4] === 0).length;
  document.getElementById('metricas').innerHTML =
    `<span>${almacenes.length} almacenes</span>` +
    `<span>${zonas.length} zonas</span>` +
    (noCubiertas > 0 ? `<span style="color:${COLOR_NO_CUBIERTA}">${noCubiertas} sin cubrir</span>` : '');

  const mapa = L.map('mapa');
  L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '&copy; OpenStreetMap',
    maxZoom: 19,
  }).addTo(mapa);

  const puntos = [];

  // Líneas de asignación primero, para que queden debajo de los marcadores.
  for (const zona of zonas) {
    const [, lat, lon, indiceAlmacen] = zona;
    if (indiceAlmacen === null || indiceAlmacen === undefined) continue;
    const almacen = almacenes[indiceAlmacen];
    if (!almacen) continue;
    L.polyline(
      [
        [lat, lon],
        [almacen[1], almacen[2]],
      ],
      { color: almacen[3], weight: 2, opacity: 0.5 },
    ).addTo(mapa);
  }

  zonas.forEach((zona) => {
    const [etiqueta, lat, lon, indiceAlmacen, cumple] = zona;
    const almacen = indiceAlmacen === null || indiceAlmacen === undefined ? null : almacenes[indiceAlmacen];
    const color = almacen ? almacen[3] : COLOR_SIN_ASIGNAR;
    const noCubierta = cumple === 0;

    L.circleMarker([lat, lon], {
      radius: 7,
      color: noCubierta ? COLOR_NO_CUBIERTA : '#fff',
      weight: noCubierta ? 3 : 1.5,
      fillColor: color,
      fillOpacity: 1,
    })
      .addTo(mapa)
      .bindPopup(
        `${etiqueta}${almacen ? `<br>Asignada a ${almacen[0]}` : '<br>Sin asignar'}` +
          (noCubierta ? '<br>Fuera del estándar de servicio' : ''),
      );
    puntos.push([lat, lon]);
  });

  almacenes.forEach((almacen) => {
    const [nombre, lat, lon, color] = almacen;
    L.marker([lat, lon], { icon: iconoAlmacen(color) }).addTo(mapa).bindPopup(nombre);
    puntos.push([lat, lon]);
  });

  const listaAlmacenesEl = document.getElementById('lista-almacenes');
  almacenes.forEach((almacen) => {
    const li = document.createElement('li');
    li.innerHTML = `<span class="punto-color" style="background:${almacen[3]}"></span><span>${almacen[0]}</span>`;
    listaAlmacenesEl.appendChild(li);
  });
  document.getElementById('seccion-almacenes').hidden = almacenes.length === 0;

  const listaZonasEl = document.getElementById('lista-zonas');
  zonas.forEach((zona) => {
    const [etiqueta, , , indiceAlmacen, cumple] = zona;
    const almacen = indiceAlmacen === null || indiceAlmacen === undefined ? null : almacenes[indiceAlmacen];
    const color = almacen ? almacen[3] : COLOR_SIN_ASIGNAR;
    const li = document.createElement('li');
    li.innerHTML =
      `<span class="punto-color${almacen ? '' : ' sin-asignar'}" style="background:${color}"></span>` +
      `<span>${etiqueta}</span>` +
      (cumple === 0 ? '<span class="etiqueta-no-cubierta">no cubierta</span>' : '');
    listaZonasEl.appendChild(li);
  });
  document.getElementById('seccion-zonas').hidden = zonas.length === 0;

  if (puntos.length > 0) {
    mapa.fitBounds(L.latLngBounds(puntos), { padding: [32, 32] });
  } else {
    mapa.setView([0, 0], 2);
  }

  document.getElementById('estado').hidden = true;
}

iniciar();
