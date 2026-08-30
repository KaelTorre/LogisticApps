# Visor de red de distribución (web, sin backend)

Página estática (HTML + CSS + JS puro, sin build step) que muestra el
resultado de un escenario — almacenes abiertos, zonas de demanda y qué
almacén atiende a cada una — a quien reciba el link, sin necesidad de tener
la app instalada. Pensada para compartir el resultado de una optimización
con alguien externo (ej. un cliente o un compañero de equipo).

## Cómo funciona

1. La app Flutter genera un link como
   `https://<usuario>.github.io/<repo>/sistema-red-distribucion/visor-red/#z=<datos-codificados>`
   (`lib/domain/export/exportar_visor_red.dart`). Los datos van comprimidos
   (DEFLATE crudo) y codificados en base64url en el **fragmento** (`#`), no
   en la query — nunca se envían a ningún servidor.
2. Esta página lee ese fragmento y lo descomprime con la API nativa del
   navegador (`DecompressionStream`) — sin librerías externas.
3. Dibuja el mapa con Leaflet + tiles de OpenStreetMap: un marcador por
   almacén (con el mismo color de territorio que usa la Pantalla 11 de la
   app), un punto por zona de demanda (coloreado según el almacén que la
   sirve, o gris si quedó sin asignar), una línea recta entre cada zona y su
   almacén, y un borde rojo en las zonas que no cumplen el estándar de
   servicio.

A diferencia de `../../sistema-optimizacion-rutas/visor-web/` (rutas de la
Unidad 3), acá no hace falta pedirle geometría de carretera a ningún
servicio: las líneas de asignación son rectas, el mismo criterio que ya usa
la propia Pantalla 11. Por eso tampoco hace ninguna petición de red más
allá de las teselas del mapa — el color de cada almacén viaja ya resuelto
en el link (ver el comentario en `exportar_visor_red.dart`).

## Requisitos para que el link funcione

- El repositorio debe estar público y con **GitHub Pages activado**:
  `Settings → Pages → Build and deployment → Source: Deploy from a branch`,
  eligiendo la rama (`main`) y carpeta `/ (root)`.
- Que exista un archivo `.nojekyll` en la raíz del repo (ya existe) para
  que GitHub no intente procesar los archivos con Jekyll.
- Actualizar `visorRedBaseUrl` en `lib/core/constantes.dart` si el usuario o
  el nombre del repositorio cambian.
- Un navegador relativamente reciente (Chrome/Edge 80+, Firefox 113+,
  Safari 16.4+) — el requisito lo pone `DecompressionStream`, la misma API
  que ya usa `visor-web`.

## Límites

- El link es una "foto" del escenario en el momento en que se generó: si
  después se recalcula algo en la app, ese link viejo no se actualiza solo.
- Un escenario con muchos almacenes y zonas puede superar el límite
  práctico de longitud de URL (`limitePracticoUrlVisor`, 8000 caracteres) —
  en ese caso la app avisa en vez de generar un link roto, no intenta
  compartirlo igual.
