---
name: run-desktop
description: Build, launch, and screenshot the sistema_gestion_pedidos_sla Flutter Linux desktop app headlessly under Xvfb. Use when asked to run this app, take a screenshot of it, verify a UI/UX change visually, or interact with its window in this headless container.
---

`sistema_gestion_pedidos_sla` es una app Flutter (target Linux desktop, GTK).
No hay servidor de ventanas real en este contenedor, así que para verla hay
que correrla bajo un X server virtual (Xvfb) y tomar el screenshot de esa
ventana virtual.

Todos los comandos son relativos a este proyecto
(`sistema-gestion-pedidos-sla/`), pero el driver resuelve rutas solo, se
puede invocar desde cualquier directorio.

## Prerequisitos (una sola vez por contenedor)

```bash
sudo dnf install -y xorg-x11-server-Xvfb ImageMagick xdotool xwininfo xdg-user-dirs
xdg-user-dirs-update
```

(`ImageMagick` da el comando `import` para el screenshot; `xdotool`/`xwininfo`
son opcionales, solo hacen falta para los comandos `click`/`key`/`type`/`start`.
`xdg-user-dirs` es obligatorio: la app usa `drift_flutter`, que resuelve el
archivo de la base de datos vía `path_provider`'s
`getApplicationDocumentsDirectory()` — sin `xdg-user-dirs-update` corriendo al
menos una vez, esa llamada lanza `MissingPlatformDirectoryException` y la app
crashea silenciosamente al abrir la base, apenas arranca).

## Uso

```bash
cd sistema-gestion-pedidos-sla
.claude/skills/run-desktop/driver.sh build         # flutter build linux --debug
.claude/skills/run-desktop/driver.sh start          # levanta Xvfb + lanza la app, espera la ventana
.claude/skills/run-desktop/driver.sh screenshot home  # -> /tmp/shots-gestion-pedidos/home.png
.claude/skills/run-desktop/driver.sh stop           # mata la app y Xvfb
```

Luego **abre el PNG y mírecelo** (Read tool) — una ventana en negro es un
fallo de lanzamiento, no un éxito.

### Comandos

| comando | qué hace |
|---|---|
| `build` | `flutter build linux --debug` en el proyecto |
| `start` | levanta Xvfb en `:98` (si no corría ya) y lanza el binario, espera hasta 15s a que aparezca la ventana |
| `screenshot [nombre]` | screenshot de la ventana de la app → `/tmp/shots-gestion-pedidos/<nombre>.png` (override con `SCREENSHOT_DIR`) |
| `click X Y` | click izquierdo en la coordenada `(X, Y)` relativa a la ventana (vía `xdotool`) |
| `scroll [X Y CLICKS BOTON]` | scroll con la rueda del mouse en `(X, Y)` (default `640 400`), `CLICKS` veces (default 5), botón `4`=arriba / `5`=abajo (default) — útil para listas largas (`ListView`) que no responden a teclado |
| `key TECLA` | envía una tecla (ej. `Tab`, `Return`) a la ventana |
| `type TEXTO` | escribe texto en el campo con foco |
| `status` | muestra PIDs de Xvfb/app y el id de ventana actuales |
| `stop` | mata el proceso de la app y Xvfb, limpia el estado |

El estado (PIDs, id de ventana) se guarda en
`/tmp/flutter-run-driver-gestion-pedidos/state.env` porque cada invocación
del driver es un proceso bash nuevo — no hay variables de shell persistentes
entre llamadas, pero los procesos de fondo sí siguen vivos y el driver los
reengancha.

El display (`:98`), el directorio de estado y el de screenshots son
distintos de los del proyecto hermano `sistema-optimizacion-rutas`
(`:99` / `/tmp/flutter-run-driver` / `/tmp/shots`) para poder correr ambos
drivers en el mismo contenedor sin pisarse.

## Gotchas

- **`GDK_BACKEND=wayland` heredado del entorno.** Si el contenedor tiene una
  sesión Wayland real (`WAYLAND_DISPLAY` seteado) y no se fuerza X11, GTK
  intenta abrir la ventana ahí en vez de en el Xvfb — en el peor caso, una
  ventana visible en la sesión real del usuario. El driver ya lanza con
  `env -u WAYLAND_DISPLAY GDK_BACKEND=x11`; no quitar eso.
- **Dos "ventanas" con el mismo app id.** `xwininfo -tree` muestra además de
  la ventana real (1400x900, nombre `sistema_gestion_pedidos_sla`) una
  utilidad interna de 10x10 con el nombre
  `com.logisticapps.sistema_gestion_pedidos_sla` (el app id, no el título).
  El driver filtra por el nombre exacto del binario para no capturar la
  ventana equivocada.
- **`libEGL warning: DRI3 error`** en el log de la app es benigno bajo Xvfb —
  cae a software rendering (llvmpipe) y renderiza igual, solo más lento.
- El primer `flutter build linux` genera el bundle GTK completo; tarda más
  que builds subsiguientes.

## Troubleshooting

- **Screenshot en negro:** la ventana no llegó a pintarse — sube el `sleep`
  tras `start` o revisa `/tmp/flutter-run-driver-gestion-pedidos/app.log`.
- **`start` no encuentra ventana en 15s:** revisa `app.log`; si dice
  `Failed to create GL context` puede faltar Mesa software rendering
  (`mesa-libGL`, `mesa-dri-drivers`).
- **Xvfb no arranca (`_XSERVTransmkdir` warning):** es solo un warning de
  permisos de `/tmp/.X11-unix`, no bloquea — ignóralo si el proceso queda
  vivo (`driver.sh status`).
