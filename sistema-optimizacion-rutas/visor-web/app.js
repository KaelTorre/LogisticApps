// Visor de rutas — página estática, sin backend.
//
// Recibe los datos de la ruta codificados en el fragmento de la URL
// (`#d=<base64url>`, generado por la app Flutter — ver
// lib/core/exportar_visor_web.dart), le pide la geometría real a OSRM
// directamente desde este navegador (el servidor demo público permite
// llamadas cross-origin: responde `Access-Control-Allow-Origin: *`), y
// dibuja el mapa con Leaflet + tiles de OpenStreetMap. Sin límite de
// paradas — a diferencia de un link de Google Maps.

const OSRM_BASE_URL = 'https://router.project-osrm.org';
const COLOR_POR_DEFECTO = '#1baf7a';
// Azul reservado para el depósito/UI — mismo criterio que
// core/paleta_rutas.dart (nunca se usa para una ruta/tramo).
const COLOR_DEPOSITO = '#2a78d6';

// Mismo motor de colores que core/paleta_rutas.dart: hasta 5 tramos usa la
// paleta ya validada (contraste/CVD) con el skill de dataviz; de ahí en más
// genera tonos adicionales con el ángulo dorado en vez de repetir colores.
// Se usa para "colorear por tramo" — una preferencia local de este visor,
// no viaja en el link.
const PALETA_VALIDADA = ['#1baf7a', '#eda100', '#008300', '#4a3aa7', '#e34948'];
const ANGULO_DORADO = 137.508;

function colorParaIndice(indice) {
  if (indice < PALETA_VALIDADA.length) return PALETA_VALIDADA[indice];

  let hue = (indice * ANGULO_DORADO) % 360;
  if (hue >= 200 && hue <= 250) hue = (hue + 65) % 360;

  const distAmarilloVerde = Math.min(Math.abs(hue - 110), 180);
  const ajuste = ((distAmarilloVerde - 90) / 90) * 0.08;
  const lightness = Math.max(0.25, Math.min(0.75, 0.4 + ajuste));
  return hslToHex(hue, 0.62, lightness);
}

function hslToHex(h, s, l) {
  const c = (1 - Math.abs(2 * l - 1)) * s;
  const x = c * (1 - Math.abs(((h / 60) % 2) - 1));
  const m = l - c / 2;
  let [r, g, b] = [0, 0, 0];
  if (h < 60) [r, g, b] = [c, x, 0];
  else if (h < 120) [r, g, b] = [x, c, 0];
  else if (h < 180) [r, g, b] = [0, c, x];
  else if (h < 240) [r, g, b] = [0, x, c];
  else if (h < 300) [r, g, b] = [x, 0, c];
  else [r, g, b] = [c, 0, x];
  const canal = (v) => Math.round((v + m) * 255).toString(16).padStart(2, '0');
  return `#${canal(r)}${canal(g)}${canal(b)}`;
}

// Íconos de Lucide (ISC license, https://lucide.dev), inlineados para no
// depender de la fuente que usa Flutter (esto es HTML/SVG puro).
const SVG_WAREHOUSE = `<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 21V10a1 1 0 0 0-1-1H7a1 1 0 0 0-1 1v11"/><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V8a2 2 0 0 1 1.132-1.803l7.95-3.974a2 2 0 0 1 1.837 0l7.948 3.974A2 2 0 0 1 22 8z"/><path d="M6 13h12"/><path d="M6 17h12"/></svg>`;

// Triángulo propio (no un ícono de Lucide): necesitamos que "sin rotar"
// apunte exactamente hacia arriba (0°=norte). El ícono de Lucide
// "navigation" en realidad apunta de fábrica al noreste (~46°), lo que
// producía flechas todas con el mismo desfase en vez del rumbo real de
// cada tramo — mismo ajuste que en mapa_resultado_screen.dart.
const SVG_TRIANGULO = `<svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 14 14"><polygon points="7,0 14,14 0,14" fill="currentColor" stroke="#fff" stroke-width="1"/></svg>`;

function decodificarDatosDeLaUrl() {
  const parametros = new URLSearchParams(location.hash.slice(1));
  const codificado = parametros.get('d');
  if (!codificado) return null;

  const base64 = codificado
    .replace(/-/g, '+')
    .replace(/_/g, '/')
    .padEnd(codificado.length + ((4 - (codificado.length % 4)) % 4), '=');
  const binario = atob(base64);
  const bytes = new Uint8Array(binario.length);
  for (let i = 0; i < binario.length; i++) bytes[i] = binario.charCodeAt(i);
  const json = new TextDecoder('utf-8').decode(bytes);
  return JSON.parse(json);
}

// Mismo algoritmo que `decodificarPolyline` en core/utils/geo_utils.dart
// (precisión 5, estándar de Google/OSRM).
function decodificarPolyline(codificado) {
  const puntos = [];
  let indice = 0;
  let lat = 0;
  let lon = 0;

  function leerDelta() {
    let resultado = 0;
    let desplazamiento = 0;
    let byte;
    do {
      byte = codificado.charCodeAt(indice++) - 63;
      resultado |= (byte & 0x1f) << desplazamiento;
      desplazamiento += 5;
    } while (byte >= 0x20);
    return resultado & 1 ? ~(resultado >> 1) : resultado >> 1;
  }

  while (indice < codificado.length) {
    lat += leerDelta();
    lon += leerDelta();
    puntos.push([lat / 1e5, lon / 1e5]);
  }
  return puntos;
}

// Mismo algoritmo que `rumboEntrePuntos` en core/utils/geo_utils.dart.
function rumboEntrePuntos(lat1, lon1, lat2, lon2) {
  const rad = (g) => (g * Math.PI) / 180;
  const phi1 = rad(lat1);
  const phi2 = rad(lat2);
  const deltaLambda = rad(lon2 - lon1);
  const y = Math.sin(deltaLambda) * Math.cos(phi2);
  const x =
    Math.cos(phi1) * Math.sin(phi2) -
    Math.sin(phi1) * Math.cos(phi2) * Math.cos(deltaLambda);
  const theta = Math.atan2(y, x);
  return ((theta * 180) / Math.PI + 360) % 360;
}

function distanciaHaversineKm(lat1, lon1, lat2, lon2) {
  const rad = (g) => (g * Math.PI) / 180;
  const dLat = rad(lat2 - lat1);
  const dLon = rad(lon2 - lon1);
  const a =
    Math.sin(dLat / 2) ** 2 +
    Math.cos(rad(lat1)) * Math.cos(rad(lat2)) * Math.sin(dLon / 2) ** 2;
  return 6371 * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
}

function distanciasAcumuladas(puntosRuta) {
  const acumulado = [0];
  for (let i = 1; i < puntosRuta.length; i++) {
    acumulado.push(
      acumulado[acumulado.length - 1] +
        distanciaHaversineKm(
          puntosRuta[i - 1][0],
          puntosRuta[i - 1][1],
          puntosRuta[i][0],
          puntosRuta[i][1],
        ),
    );
  }
  return acumulado;
}

// Mismo algoritmo que `muestrearFlechasEnRuta` en core/utils/geo_utils.dart:
// sin esto, la polyline se ve como una línea plana sin indicar hacia dónde
// avanza el vehículo.
function muestrearFlechasEnRuta(puntosRuta, intervaloKm = 2, minimo = 3, maximo = 20) {
  if (puntosRuta.length < 2) return [];

  const distancias = distanciasAcumuladas(puntosRuta);
  const largoTotal = distancias[distancias.length - 1];
  if (largoTotal <= 0) return [];

  const cantidad = Math.min(maximo, Math.max(minimo, Math.round(largoTotal / intervaloKm)));
  const resultado = [];
  let idx = 0;

  for (let k = 1; k <= cantidad; k++) {
    const objetivo = (largoTotal * k) / (cantidad + 1);
    while (idx < distancias.length - 2 && distancias[idx + 1] < objetivo) idx++;

    const p0 = puntosRuta[idx];
    const p1 = puntosRuta[idx + 1];
    const d0 = distancias[idx];
    const d1 = distancias[idx + 1];
    const t = d1 > d0 ? Math.min(1, Math.max(0, (objetivo - d0) / (d1 - d0))) : 0;

    resultado.push({
      punto: [p0[0] + (p1[0] - p0[0]) * t, p0[1] + (p1[1] - p0[1]) * t],
      rumbo: rumboEntrePuntos(p0[0], p0[1], p1[0], p1[1]),
    });
  }
  return resultado;
}

// Divide la polyline completa en un tramo por cada parada (depósito→1,
// 1→2, ..., última→depósito), usando la proporción real de distancia de
// cada tramo (de `legDistanciasMetros`, que sí son exactas) para ubicar
// dónde "cortarla" dentro de la geometría combinada. Es una aproximación
// visual (no exacta al metro) — OSRM no separa la geometría por tramo salvo
// pidiendo `steps=true` y reconstruyéndola, que para un visor de "colorear
// para distinguir mejor" es más complejidad de la que hace falta.
function dividirPolylinePorTramos(puntosRuta, legDistanciasMetros) {
  if (legDistanciasMetros.length <= 1) return [puntosRuta];

  const distancias = distanciasAcumuladas(puntosRuta);
  const largoTotalPolyline = distancias[distancias.length - 1];
  const largoTotalLegsKm = legDistanciasMetros.reduce((a, b) => a + b, 0) / 1000;
  if (largoTotalLegsKm <= 0) return [puntosRuta];

  const segmentos = [];
  let idxInicio = 0;
  let acumuladoKm = 0;

  for (let li = 0; li < legDistanciasMetros.length; li++) {
    acumuladoKm += legDistanciasMetros[li] / 1000;
    const esUltimo = li === legDistanciasMetros.length - 1;
    const objetivo = esUltimo
      ? largoTotalPolyline
      : (acumuladoKm / largoTotalLegsKm) * largoTotalPolyline;

    let idxCorte = idxInicio;
    while (idxCorte < distancias.length - 1 && distancias[idxCorte] < objetivo) idxCorte++;

    segmentos.push(puntosRuta.slice(idxInicio, idxCorte + 1));
    idxInicio = idxCorte;
  }
  return segmentos;
}

function iconoNumerado(numero, color) {
  return L.divIcon({
    className: '',
    html: `<div class="marcador-numerado" style="background:${color}">${numero}</div>`,
    iconSize: [26, 26],
  });
}

function iconoDeposito() {
  return L.divIcon({
    className: '',
    html: `<div class="marcador-numerado deposito" style="background:${COLOR_DEPOSITO}">${SVG_WAREHOUSE}</div>`,
    iconSize: [32, 32],
  });
}

function iconoFlecha(rumboGrados, color) {
  return L.divIcon({
    className: '',
    html: `<div class="marcador-flecha" style="color:${color}; transform: rotate(${rumboGrados}deg)">${SVG_TRIANGULO}</div>`,
    iconSize: [14, 14],
  });
}

function mostrarError(mensaje) {
  const estado = document.getElementById('estado');
  estado.textContent = mensaje;
  estado.classList.add('error');
}

async function iniciar() {
  const datos = decodificarDatosDeLaUrl();
  if (!datos) {
    mostrarError(
      'Este link no trae datos de ninguna ruta. Pídele a quien te lo ' +
        'compartió que lo genere de nuevo desde la app.',
    );
    return;
  }

  const [nombreDeposito, latDep, lonDep] = datos.dep;
  const paradas = datos.paradas; // [[nombre, lat, lon], ...]
  const colorUnico = datos.color || COLOR_POR_DEFECTO;
  document.getElementById('titulo-vehiculo').textContent = datos.veh || 'Ruta';

  const coordenadas = [
    [lonDep, latDep],
    ...paradas.map((p) => [p[2], p[1]]),
    [lonDep, latDep],
  ];
  const coordsUrl = coordenadas.map((c) => c.join(',')).join(';');

  let respuesta;
  try {
    const resp = await fetch(
      `${OSRM_BASE_URL}/route/v1/driving/${coordsUrl}?overview=full&geometries=polyline`,
    );
    respuesta = await resp.json();
  } catch (e) {
    mostrarError(
      'No se pudo conectar con OSRM. Se necesita conexión a internet para ' +
        'calcular esta ruta.',
    );
    return;
  }

  if (respuesta.code !== 'Ok') {
    mostrarError(
      respuesta.code === 'NoRoute'
        ? 'OSRM no encontró una ruta entre estos puntos.'
        : `OSRM respondió con un error: ${respuesta.code}`,
    );
    return;
  }

  const ruta = respuesta.routes[0];
  const distanciaKm = (ruta.distance / 1000).toFixed(1);
  const duracionMin = Math.round(ruta.duration / 60);
  const legs = ruta.legs || [];
  document.getElementById('metricas').innerHTML =
    `<span>${distanciaKm} km</span><span>${duracionMin} min</span><span>${paradas.length} paradas</span>`;

  const puntosRuta = decodificarPolyline(ruta.geometry);
  const tramos = dividirPolylinePorTramos(
    puntosRuta,
    legs.map((l) => l.distance),
  );

  const mapa = L.map('mapa');
  L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '&copy; OpenStreetMap',
    maxZoom: 19,
  }).addTo(mapa);

  const capaRuta = L.layerGroup().addTo(mapa);
  let colorearPorTramo = false;

  function colorDeTramo(indiceTramo) {
    return colorearPorTramo ? colorParaIndice(indiceTramo) : colorUnico;
  }

  function dibujarRuta() {
    capaRuta.clearLayers();

    tramos.forEach((puntosTramo, i) => {
      L.polyline(puntosTramo, { color: colorDeTramo(i), weight: 4 }).addTo(capaRuta);
      for (const flecha of muestrearFlechasEnRuta(puntosTramo, 2, 1, 8)) {
        L.marker(flecha.punto, {
          icon: iconoFlecha(flecha.rumbo, colorDeTramo(i)),
        }).addTo(capaRuta);
      }
    });

    paradas.forEach((p, i) => {
      const [nombre, lat, lon] = p;
      L.marker([lat, lon], { icon: iconoNumerado(i + 1, colorDeTramo(i)) })
        .addTo(capaRuta)
        .bindPopup(`${i + 1}. ${nombre}`);
    });
  }

  dibujarRuta();

  L.marker([latDep, lonDep], { icon: iconoDeposito() })
    .addTo(mapa)
    .bindPopup(nombreDeposito || 'Depósito');

  const botonTramo = document.getElementById('btn-color-tramo');
  if (paradas.length > 1) {
    botonTramo.hidden = false;
    botonTramo.addEventListener('click', () => {
      colorearPorTramo = !colorearPorTramo;
      botonTramo.classList.toggle('activo', colorearPorTramo);
      botonTramo.textContent = colorearPorTramo
        ? 'Un color por toda la ruta'
        : 'Colorear por tramo';
      dibujarRuta();
      actualizarListaParadas();
    });
  }

  const listaEl = document.getElementById('lista-paradas');
  function actualizarListaParadas() {
    listaEl.innerHTML = '';
    paradas.forEach((p, i) => {
      const [nombre] = p;
      const distanciaTramoKm = legs[i] ? (legs[i].distance / 1000).toFixed(1) : null;
      const li = document.createElement('li');
      li.innerHTML = `
        <span class="numero" style="background:${colorDeTramo(i)}">${i + 1}</span>
        <span>
          <div>${nombre}</div>
          ${distanciaTramoKm ? `<div class="distancia-tramo">${distanciaTramoKm} km ${i === 0 ? 'desde el depósito' : 'desde la parada anterior'}</div>` : ''}
        </span>`;
      listaEl.appendChild(li);
    });
  }
  actualizarListaParadas();

  const bounds = L.latLngBounds(puntosRuta);
  mapa.fitBounds(bounds, { padding: [32, 32] });

  document.getElementById('estado').style.display = 'none';
}

iniciar();
