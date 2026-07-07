#!/usr/bin/env bash
# Driver para construir, lanzar y controlar la app Flutter Linux desktop
# (sistema_gestion_pedidos_sla) de forma headless bajo Xvfb.
#
# Cada invocación es un proceso bash nuevo (no hay estado de shell entre
# llamadas), así que el estado (PIDs, id de ventana) se persiste en un
# archivo bajo STATE_DIR. Los procesos de fondo (Xvfb, la app) sí
# sobreviven entre invocaciones — solo las variables de shell no.
#
# Uso: driver.sh <comando> [args]
set -euo pipefail

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_DIR="$(cd "$SKILL_DIR/../../.." && pwd)"
APP_NAME="sistema_gestion_pedidos_sla"
BINARY="$APP_DIR/build/linux/x64/debug/bundle/$APP_NAME"

# Display/estado/screenshots con defaults propios (distintos de los del
# proyecto hermano sistema-optimizacion-rutas) para poder correr ambos
# drivers en el mismo contenedor sin pisarse.
DISPLAY_NUM="${FLUTTER_DRIVER_DISPLAY:-98}"
XDISPLAY=":$DISPLAY_NUM"
STATE_DIR="${FLUTTER_DRIVER_STATE_DIR:-/tmp/flutter-run-driver-gestion-pedidos}"
SHOT_DIR="${SCREENSHOT_DIR:-/tmp/shots-gestion-pedidos}"
mkdir -p "$STATE_DIR" "$SHOT_DIR"

STATE_FILE="$STATE_DIR/state.env"

_load_state() { [ -f "$STATE_FILE" ] && source "$STATE_FILE" || true; }
_save_state() {
  {
    echo "XVFB_PID=${XVFB_PID:-}"
    echo "APP_PID=${APP_PID:-}"
    echo "WINDOW_ID=${WINDOW_ID:-}"
  } > "$STATE_FILE"
}

_pid_alive() { [ -n "${1:-}" ] && kill -0 "$1" 2>/dev/null; }

cmd_build() {
  echo "==> flutter build linux --debug (en $APP_DIR)"
  (cd "$APP_DIR" && flutter build linux --debug)
}

cmd_start() {
  _load_state
  if ! _pid_alive "${XVFB_PID:-}"; then
    echo "==> Iniciando Xvfb en $XDISPLAY"
    rm -f "/tmp/.X${DISPLAY_NUM}-lock"
    Xvfb "$XDISPLAY" -screen 0 1400x900x24 >"$STATE_DIR/xvfb.log" 2>&1 &
    XVFB_PID=$!
    sleep 1
  else
    echo "==> Xvfb ya corría (pid $XVFB_PID)"
  fi

  if [ ! -x "$BINARY" ]; then
    echo "ERROR: no existe $BINARY — corre 'driver.sh build' primero." >&2
    exit 1
  fi

  echo "==> Lanzando $APP_NAME en $XDISPLAY"
  # IMPORTANTE: forzar X11 y quitar WAYLAND_DISPLAY (ver Gotchas en SKILL.md) —
  # sin esto, si el entorno tiene GDK_BACKEND=wayland heredado, la app puede
  # abrir su ventana en la sesión Wayland real del host en vez del Xvfb.
  env -u WAYLAND_DISPLAY DISPLAY="$XDISPLAY" GDK_BACKEND=x11 \
    "$BINARY" >"$STATE_DIR/app.log" 2>&1 &
  APP_PID=$!

  WINDOW_ID=""
  for _ in $(seq 1 15); do
    sleep 1
    WINDOW_ID=$(DISPLAY="$XDISPLAY" xwininfo -root -tree 2>/dev/null \
      | grep "\"$APP_NAME\"" | awk '{print $1}' | head -n1 || true)
    [ -n "$WINDOW_ID" ] && break
  done

  _save_state

  if [ -z "$WINDOW_ID" ]; then
    echo "ERROR: no apareció la ventana tras 15s. Revisa $STATE_DIR/app.log" >&2
    exit 1
  fi
  echo "==> Ventana lista: $WINDOW_ID (app pid $APP_PID, xvfb pid $XVFB_PID)"
}

cmd_screenshot() {
  _load_state
  if [ -z "${WINDOW_ID:-}" ]; then
    echo "ERROR: no hay ventana registrada — corre 'driver.sh start' primero." >&2
    exit 1
  fi
  local name="${1:-ss-$(date +%s)}"
  local file="$SHOT_DIR/$name.png"
  import -display "$XDISPLAY" -window "$WINDOW_ID" "$file"
  echo "screenshot: $file"
}

cmd_click() {
  _load_state
  local x="$1" y="$2"
  DISPLAY="$XDISPLAY" xdotool mousemove --window "$WINDOW_ID" "$x" "$y" click 1
  echo "click en ($x, $y)"
}

cmd_scroll() {
  _load_state
  local x="${1:-640}" y="${2:-400}" clicks="${3:-5}" boton="${4:-5}"
  for _ in $(seq 1 "$clicks"); do
    DISPLAY="$XDISPLAY" xdotool mousemove --window "$WINDOW_ID" "$x" "$y" click "$boton"
  done
  echo "scroll en ($x, $y) x$clicks (botón $boton: 4=arriba, 5=abajo)"
}

cmd_key() {
  _load_state
  DISPLAY="$XDISPLAY" xdotool key --window "$WINDOW_ID" "$1"
  echo "key: $1"
}

cmd_type() {
  _load_state
  DISPLAY="$XDISPLAY" xdotool type --window "$WINDOW_ID" -- "$1"
  echo "type: $1"
}

cmd_status() {
  _load_state
  echo "display: $XDISPLAY"
  echo "xvfb pid: ${XVFB_PID:-（ninguno）} $(_pid_alive "${XVFB_PID:-}" && echo vivo || echo muerto)"
  echo "app pid:  ${APP_PID:-（ninguno）} $(_pid_alive "${APP_PID:-}" && echo vivo || echo muerto)"
  echo "window:   ${WINDOW_ID:-（ninguna）}"
}

cmd_stop() {
  _load_state
  _pid_alive "${APP_PID:-}" && kill "$APP_PID" 2>/dev/null || true
  _pid_alive "${XVFB_PID:-}" && kill "$XVFB_PID" 2>/dev/null || true
  rm -f "$STATE_FILE"
  echo "==> detenido"
}

case "${1:-}" in
  build)      cmd_build ;;
  start)      cmd_start ;;
  screenshot) shift; cmd_screenshot "$@" ;;
  click)      shift; cmd_click "$@" ;;
  scroll)     shift; cmd_scroll "$@" ;;
  key)        shift; cmd_key "$@" ;;
  type)       shift; cmd_type "$@" ;;
  status)     cmd_status ;;
  stop)       cmd_stop ;;
  *)
    echo "Uso: driver.sh {build|start|screenshot [nombre]|click X Y|scroll [X Y CLICKS BOTON]|key TECLA|type TEXTO|status|stop}" >&2
    exit 1
    ;;
esac
