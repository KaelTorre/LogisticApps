# Visor de rutas (web, sin backend)

Página estática (HTML + CSS + JS puro, sin build step) que muestra una ruta
completa a quien reciba el link — **sin el límite de 9 paradas de Google
Maps** (ver sección 3.1 de `../CLAUDE.md`). Pensada para compartir con
alguien externo a la app (ej. un chofer) por WhatsApp o donde sea.

## Cómo funciona

1. La app Flutter genera un link como
   `https://<usuario>.github.io/<repo>/sistema-optimizacion-rutas/visor-web/#d=<datos-codificados>`
   (`lib/core/exportar_visor_web.dart`). Los datos van en el **fragmento**
   (`#`), no en la query — nunca se envían a ningún servidor.
2. Esta página lee ese fragmento, decodifica la lista de paradas, y le pide
   la ruta real a OSRM **directo desde el navegador de quien la abre** (el
   servidor demo público responde `Access-Control-Allow-Origin: *`, así que
   no hace falta ningún backend propio).
3. Dibuja el mapa con Leaflet + tiles de OpenStreetMap: ruta real, marcadores
   numerados, lista de paradas — mismo lenguaje visual que la app.

## Requisitos para que el link funcione

- El repositorio debe estar público (ya lo está) y con **GitHub Pages
  activado**: `Settings → Pages → Build and deployment → Source: Deploy
  from a branch`, elegir la rama (`main`) y carpeta `/ (root)`.
- Que exista un archivo `.nojekyll` en la raíz del repo (ya se agregó) para
  que GitHub no intente procesar los archivos con Jekyll.
- Actualizar `visorWebBaseUrl` en `lib/core/constants.dart` si el usuario o
  el nombre del repositorio cambian.

## Límites reales (a diferencia de Google Maps, no hay límite de paradas)

- Depende de que quien abre el link tenga internet (igual que la app).
- El link es una "foto" de la ruta en el momento en que se generó: si
  después se recalcula algo en la app, ese link viejo no se actualiza solo.
