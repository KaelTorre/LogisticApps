# Procedencia de assets externos

## Fuentes

- **DejaVu Sans** (`fonts/DejaVuSans.ttf`, `fonts/DejaVuSans-Bold.ttf`)
  Usada para incrustar texto Unicode en el PDF de exportación (`lib/domain/export/pdf_builder.dart`):
  las fórmulas de la memoria de cálculo usan letras griegas y símbolos
  matemáticos (Σ, ρ, λ, μ, ×, ≤) que la fuente base Helvetica del paquete
  `pdf` no puede dibujar.
  Licencia: [Bitstream Vera Fonts License](https://dejavu-fonts.github.io/License.html)
  (permisiva, permite embeber y redistribuir). Sin cambios respecto al
  archivo original de la distribución `ttf-dejavu`.
