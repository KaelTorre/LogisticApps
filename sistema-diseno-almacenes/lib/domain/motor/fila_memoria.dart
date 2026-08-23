/// Una fila de memoria de cálculo, tal como la exige CLAUDE.md sección 5:
/// todo valor que aparezca en la ficha técnica debe poder rastrearse hasta
/// aquí, con fórmula, entradas y fuente.
///
/// Es un value type plano — el motor (`lib/domain/motor/`) no toca la base
/// de datos. Quien orqueste el cálculo (fuera del motor) decide cuándo y
/// cómo persistir estas filas en la tabla `memoria_calculo`, asociadas a un
/// `resultado_id`.
class FilaMemoria {
  const FilaMemoria({
    required this.orden,
    required this.modulo,
    required this.concepto,
    required this.formula,
    required this.entradas,
    required this.valor,
    required this.unidad,
    this.fuente,
  });

  final int orden;

  /// M1..M8.
  final String modulo;
  final String concepto;

  /// Legible por humano, ej. "posiciones_requeridas = ceil(Σ tarimas / (1 − factor_honeycomb))".
  final String formula;

  /// Valores de entrada usados en esta fila, para trazabilidad.
  final Map<String, Object?> entradas;
  final String valor;
  final String unidad;

  /// Norma o supuesto que respalda el valor. Null cuando es aritmética pura
  /// sin respaldo normativo externo (CLAUDE.md sección 5: la columna admite
  /// NULL a diferencia de `fuente` en el catálogo, que es NOT NULL).
  final String? fuente;
}
