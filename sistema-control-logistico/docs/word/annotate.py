"""
Dibuja círculos numerados (callouts) sobre copias de las capturas reales de
la app, para que el manual de usuario pueda decir "mirá el (1)" en vez de
describir posiciones en prosa. No modifica las capturas originales -- crea
una copia "<nombre>_anotada.png" al lado de cada una.

Ejecutar con el venv del motor de documentación:
    /home/kael/Escritorio/documentacion/word/.venv/bin/python annotate.py
"""

import os

from PIL import Image, ImageDraw, ImageFont

IMG_DIR = os.path.join(os.path.dirname(__file__), "img")
FONT_PATH = os.path.join(
    os.path.dirname(__file__), "..", "..", "assets", "fonts", "DejaVuSans-Bold.ttf"
)

NAVYDARK = (30, 58, 95)
WHITE = (255, 255, 255)
RADIUS = 16

# archivo -> lista de (x, y, número) en píxeles de la captura original.
CALLOUTS = {
    "00b_sin_organizacion.png": [
        (762, 406, 1),
        (816, 458, 2),
        (808, 510, 3),
    ],
    "05_detalle_indicador.png": [
        (486, 716, 1),
        (618, 716, 2),
        (668, 716, 3),
    ],
    "10_tabla_desempeno.png": [
        (148, 101, 1),
        (1139, 152, 2),
    ],
    "17_lab_calibrador.png": [
        (200, 554, 1),
        (230, 618, 2),
        (520, 666, 3),
    ],
    "18d_diagnostico_radar.png": [
        (640, 390, 1),
        (700, 604, 2),
    ],
    "19_auditoria.png": [
        (700, 101, 1),
        (100, 241, 2),
        (400, 241, 3),
    ],
    "20_catalogo_acciones.png": [
        (200, 146, 1),
        (250, 241, 2),
        (300, 294, 3),
    ],
}


def anotar(nombre, puntos):
    ruta = os.path.join(IMG_DIR, nombre)
    if not os.path.exists(ruta):
        print(f"[omitido] no existe: {ruta}")
        return
    img = Image.open(ruta).convert("RGB")
    draw = ImageDraw.Draw(img)
    font = ImageFont.truetype(FONT_PATH, 18)

    for x, y, numero in puntos:
        bbox = (x - RADIUS, y - RADIUS, x + RADIUS, y + RADIUS)
        draw.ellipse(bbox, fill=NAVYDARK, outline=WHITE, width=3)
        texto = str(numero)
        tbbox = draw.textbbox((0, 0), texto, font=font)
        tw, th = tbbox[2] - tbbox[0], tbbox[3] - tbbox[1]
        draw.text(
            (x - tw / 2 - tbbox[0], y - th / 2 - tbbox[1]),
            texto,
            fill=WHITE,
            font=font,
        )

    salida = ruta.replace(".png", "_anotada.png")
    img.save(salida)
    print(f"Generado: {salida}")


def main():
    for nombre, puntos in CALLOUTS.items():
        anotar(nombre, puntos)


if __name__ == "__main__":
    main()
