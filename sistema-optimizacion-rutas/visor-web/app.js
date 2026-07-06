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

function marcadorNumerado(numero, esDeposito) {
  return L.divIcon({
    className: '',
    html: `<div class="marcador-numerado${esDeposito ? ' deposito' : ''}">${numero}</div>`,
    iconSize: esDeposito ? [32, 32] : [26, 26],
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
  document.getElementById('titulo-vehiculo').textContent =
    datos.veh || 'Ruta';

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
  document.getElementById('metricas').innerHTML =
    `<span>${distanciaKm} km</span><span>${duracionMin} min</span><span>${paradas.length} paradas</span>`;

  const puntosRuta = decodificarPolyline(ruta.geometry);

  const mapa = L.map('mapa');
  L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '&copy; OpenStreetMap',
    maxZoom: 19,
  }).addTo(mapa);

  L.polyline(puntosRuta, { color: '#1baf7a', weight: 4 }).addTo(mapa);

  L.marker([latDep, lonDep], { icon: marcadorNumerado('D', true) })
    .addTo(mapa)
    .bindPopup(nombreDeposito || 'Depósito');

  const listaEl = document.getElementById('lista-paradas');
  listaEl.innerHTML = '';
  paradas.forEach((p, i) => {
    const [nombre, lat, lon] = p;
    L.marker([lat, lon], { icon: marcadorNumerado(i + 1, false) })
      .addTo(mapa)
      .bindPopup(`${i + 1}. ${nombre}`);

    const li = document.createElement('li');
    li.innerHTML = `<span class="numero">${i + 1}</span><span>${nombre}</span>`;
    listaEl.appendChild(li);
  });

  const bounds = L.latLngBounds(puntosRuta);
  mapa.fitBounds(bounds, { padding: [32, 32] });

  document.getElementById('estado').style.display = 'none';
}

iniciar();
