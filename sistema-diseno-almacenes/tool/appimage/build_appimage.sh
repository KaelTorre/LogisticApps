#!/usr/bin/env bash
# Fase 9 (empaquetado): arma un .AppImage portable de un solo archivo a
# partir de `flutter build linux --release`. Todo el output intermedio
# (AppDir, el propio appimagetool descargado) vive bajo build/appimage/,
# que ya está cubierto por el /build/ del .gitignore raíz -- nada de esto
# se commitea.
set -euo pipefail

APP_NAME="sistema_diseno_almacenes"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
BUNDLE_DIR="$PROJECT_ROOT/build/linux/x64/release/bundle"
APPIMAGE_BUILD_DIR="$PROJECT_ROOT/build/appimage"
APPDIR="$APPIMAGE_BUILD_DIR/AppDir"
APPIMAGETOOL="$APPIMAGE_BUILD_DIR/appimagetool-x86_64.AppImage"
OUT_DIR="$PROJECT_ROOT/build/appimage/out"

echo "==> flutter build linux --release"
(cd "$PROJECT_ROOT" && flutter build linux --release)

if [ ! -x "$BUNDLE_DIR/$APP_NAME" ]; then
  echo "No se encontró el binario en $BUNDLE_DIR/$APP_NAME" >&2
  exit 1
fi

echo "==> Armando AppDir"
rm -rf "$APPDIR"
mkdir -p "$APPDIR/usr/bin"
cp -r "$BUNDLE_DIR/." "$APPDIR/usr/bin/"

# AppRun: el punto de entrada que appimagetool exige en la raíz del AppDir.
# El binario de Flutter busca lib/ y data/ como hermanos de su propio
# ejecutable (no en rutas FHS como usr/lib) -- por eso todo el bundle
# entero vive junto dentro de usr/bin/, sin reorganizarlo.
cat > "$APPDIR/AppRun" <<EOF
#!/bin/sh
HERE="\$(dirname "\$(readlink -f "\${0}")")"
exec "\$HERE/usr/bin/$APP_NAME" "\$@"
EOF
chmod +x "$APPDIR/AppRun"

cp "$SCRIPT_DIR/sistema-diseno-almacenes.desktop" "$APPDIR/$APP_NAME.desktop"

# Ícono cuadrado de 256px para el AppDir (el maestro de assets/icon/ es de
# 1024px, más grande de lo que appimagetool/los gestores de archivos esperan).
magick "$PROJECT_ROOT/assets/icon/icon.png" -resize 256x256 "$APPDIR/$APP_NAME.png"

if [ ! -x "$APPIMAGETOOL" ]; then
  echo "==> Descargando appimagetool"
  mkdir -p "$APPIMAGE_BUILD_DIR"
  curl -fL -o "$APPIMAGETOOL" \
    "https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage"
  chmod +x "$APPIMAGETOOL"
fi

echo "==> Generando el .AppImage"
mkdir -p "$OUT_DIR"
# appimagetool necesita FUSE para correr montado; --appimage-extract-and-run
# lo evita (necesario en contenedores/CI y en Xvfb sin FUSE disponible).
ARCH=x86_64 "$APPIMAGETOOL" --appimage-extract-and-run "$APPDIR" \
  "$OUT_DIR/DisenoDeAlmacenes-x86_64.AppImage"

echo "==> Listo: $OUT_DIR/DisenoDeAlmacenes-x86_64.AppImage"
