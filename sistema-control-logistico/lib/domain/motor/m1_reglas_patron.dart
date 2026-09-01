import 'dart:math';

/// M1 — Reglas de patrón (CLAUDE.md sección 8). Función pura: sin Flutter,
/// sin drift, sin leer el reloj del sistema -- el test de la Fase 1
/// (`test/domain/regla_fundamental_test.dart`) lo verifica leyendo este
/// archivo, y se mantiene así para siempre.
///
/// Recibe una serie ordenada por `orden` (nunca por fecha) y evalúa las
/// seis reglas de sistema **en el último punto de la serie recibida** --
/// para evaluar el periodo `t`, quien llama pasa `serie[1..t]`. Eso es lo
/// que habilita el contraste retrospectivo de la Fase 6 sin duplicar
/// lógica: "evaluar hasta t" es, literalmente, "llamar con la serie
/// truncada en t".

/// Literales exactos de `memoria_evaluacion.resultado`
/// (`lib/data/local/database.dart`) -- un `ResultadoRegla` se persiste tal
/// cual, sin traducir códigos.
const resultadoDisparada = 'disparada';
const resultadoNoDisparada = 'no_disparada';
const resultadoNoEvaluable = 'no_evaluable';

/// Un punto de la serie: `orden` es la clave temporal real (CLAUDE.md
/// sección 4), `valor` es la medición.
class PuntoSerieMotor {
  const PuntoSerieMotor({required this.orden, required this.valor});

  final int orden;
  final double valor;
}

/// Lo que M1 necesita saber del indicador para evaluar sus reglas -- un
/// subconjunto de `Indicador` (`lib/data/models/indicador.dart`), copiado
/// en vez de importado para que el motor no dependa de la capa de datos.
class ConfigIndicadorMotor {
  const ConfigIndicadorMotor({
    required this.meta,
    required this.bandaInferior,
    required this.bandaSuperior,
    required this.sentido,
  });

  final double meta;
  final double bandaInferior;
  final double bandaSuperior;

  /// 'menor_mejor' | 'mayor_mejor'.
  final String sentido;
}

/// El resultado de evaluar una regla contra una serie: lo que dispara
/// `memoria_evaluacion` directamente (CLAUDE.md sección 7) -- `resultado`,
/// `valoresEntrada` y `explicacion` son, literalmente, las tres columnas
/// que le faltan a esa tabla frente a `evaluacion`.
class ResultadoRegla {
  const ResultadoRegla({
    required this.codigo,
    required this.resultado,
    required this.valoresEntrada,
    required this.explicacion,
    this.periodosFaltantes,
  });

  final String codigo;

  /// [resultadoDisparada] | [resultadoNoDisparada] | [resultadoNoEvaluable].
  final String resultado;
  final Map<String, Object?> valoresEntrada;
  final String explicacion;

  /// Solo presente cuando [resultado] es [resultadoNoEvaluable] --
  /// CLAUDE.md sección 8, [REGLA]: "nunca devuelve normal por falta de
  /// datos, la interfaz muestra el estado no evaluable explícitamente."
  final int? periodosFaltantes;

  bool get disparada => resultado == resultadoDisparada;
}

/// +1 si el lado adverso es "hacia arriba" (`menor_mejor`: peor es más
/// alto), -1 si es "hacia abajo" (`mayor_mejor`). CLAUDE.md sección 8,
/// [REGLA]: "toda regla se escribe en términos de 'adverso', nunca de
/// 'mayor'" -- este es el único lugar del motor que sabe qué significa
/// "adverso"; las seis reglas de abajo solo lo consultan.
int signoAdverso(String sentido) => sentido == 'menor_mejor' ? 1 : -1;

/// `true` si `valor` está estrictamente del lado adverso de la meta. Un
/// valor exactamente igual a la meta no es adverso.
bool esAdverso(double valor, ConfigIndicadorMotor indicador) {
  return (valor - indicador.meta) * signoAdverso(indicador.sentido) > 0;
}

ResultadoRegla _noEvaluable(String codigo, int periodosMinimos, int periodosDisponibles) {
  final faltan = periodosMinimos - periodosDisponibles;
  return ResultadoRegla(
    codigo: codigo,
    resultado: resultadoNoEvaluable,
    valoresEntrada: {'periodosDisponibles': periodosDisponibles, 'periodosMinimos': periodosMinimos},
    explicacion:
        'No evaluable todavía ($periodosDisponibles de $periodosMinimos periodos '
        'mínimos). Faltan $faltan.',
    periodosFaltantes: faltan,
  );
}

/// R1 — Punto fuera de banda. Periodos mínimos: 1.
ResultadoRegla evaluarR1(List<PuntoSerieMotor> serie, ConfigIndicadorMotor indicador) {
  const codigo = 'R1';
  const periodosMinimos = 1;
  if (serie.length < periodosMinimos) return _noEvaluable(codigo, periodosMinimos, serie.length);

  final actual = serie.last;
  final dentro = actual.valor >= indicador.bandaInferior && actual.valor <= indicador.bandaSuperior;
  return ResultadoRegla(
    codigo: codigo,
    resultado: dentro ? resultadoNoDisparada : resultadoDisparada,
    valoresEntrada: {
      'valor': actual.valor,
      'bandaInferior': indicador.bandaInferior,
      'bandaSuperior': indicador.bandaSuperior,
    },
    explicacion: dentro
        ? 'El valor ${actual.valor} está dentro de la banda '
              '[${indicador.bandaInferior}, ${indicador.bandaSuperior}].'
        : 'El valor ${actual.valor} está fuera de la banda '
              '[${indicador.bandaInferior}, ${indicador.bandaSuperior}].',
  );
}

/// R2 — Racha en el lado adverso: `n` valores consecutivos (los últimos de
/// la serie) todos del lado adverso de la meta. Periodos mínimos: `n`
/// (por defecto 7).
ResultadoRegla evaluarR2(List<PuntoSerieMotor> serie, ConfigIndicadorMotor indicador, {int n = 7}) {
  const codigo = 'R2';
  if (serie.length < n) return _noEvaluable(codigo, n, serie.length);

  final ventana = serie.sublist(serie.length - n);
  final todosAdversos = ventana.every((p) => esAdverso(p.valor, indicador));
  return ResultadoRegla(
    codigo: codigo,
    resultado: todosAdversos ? resultadoDisparada : resultadoNoDisparada,
    valoresEntrada: {'n': n, 'valores': ventana.map((p) => p.valor).toList()},
    explicacion: todosAdversos
        ? 'Los últimos $n valores están del lado adverso de la meta (${indicador.meta}).'
        : 'No todos los últimos $n valores están del lado adverso de la meta.',
  );
}

/// R3 — Corrimiento de media: `m` de los últimos `n` valores del lado
/// adverso (no necesariamente consecutivos entre sí, a diferencia de R2).
/// Periodos mínimos: `n` (por defecto 8, con `m` = 8 también por defecto).
ResultadoRegla evaluarR3(
  List<PuntoSerieMotor> serie,
  ConfigIndicadorMotor indicador, {
  int n = 8,
  int m = 8,
}) {
  const codigo = 'R3';
  if (serie.length < n) return _noEvaluable(codigo, n, serie.length);

  final ventana = serie.sublist(serie.length - n);
  final adversos = ventana.where((p) => esAdverso(p.valor, indicador)).length;
  final disparada = adversos >= m;
  return ResultadoRegla(
    codigo: codigo,
    resultado: disparada ? resultadoDisparada : resultadoNoDisparada,
    valoresEntrada: {'n': n, 'm': m, 'adversos': adversos, 'valores': ventana.map((p) => p.valor).toList()},
    explicacion: disparada
        ? '$adversos de los últimos $n valores están del lado adverso (se requerían al menos $m).'
        : 'Solo $adversos de los últimos $n valores están del lado adverso (se requerían al menos $m).',
  );
}

/// R4 — Tendencia sostenida: `n` valores consecutivos monótonos hacia el
/// lado adverso, y **todos** ellos ya del lado adverso de la meta.
/// Periodos mínimos: `n` (por defecto 5). Este es el test dorado central
/// de la fase: dispara en el periodo 7 de la serie de referencia
/// (1.21→1.24→1.26→1.28→1.29, periodos 3 a 7), no antes.
ResultadoRegla evaluarR4(List<PuntoSerieMotor> serie, ConfigIndicadorMotor indicador, {int n = 5}) {
  const codigo = 'R4';
  if (serie.length < n) return _noEvaluable(codigo, n, serie.length);

  final ventana = serie.sublist(serie.length - n);
  final signo = signoAdverso(indicador.sentido);
  final todosAdversos = ventana.every((p) => esAdverso(p.valor, indicador));

  var monotona = true;
  for (var i = 0; i < ventana.length - 1; i++) {
    if (ventana[i + 1].valor * signo <= ventana[i].valor * signo) {
      monotona = false;
      break;
    }
  }

  final disparada = todosAdversos && monotona;
  return ResultadoRegla(
    codigo: codigo,
    resultado: disparada ? resultadoDisparada : resultadoNoDisparada,
    valoresEntrada: {'n': n, 'valores': ventana.map((p) => p.valor).toList()},
    explicacion: disparada
        ? 'Los últimos $n valores son monótonos hacia el lado adverso y todos están de ese lado.'
        : 'Los últimos $n valores no forman una tendencia sostenida hacia el lado adverso.',
  );
}

/// R5 — Deterioro brusco: la variación respecto al periodo anterior, **en
/// la dirección adversa**, supera un porcentaje del ancho de banda.
/// Periodos mínimos: 2.
///
/// [porcentajeAnchoBanda] por defecto es 1.0 (100 % del ancho de banda),
/// no el 60 % que aparece en la tabla de la sección 8 de `CLAUDE.md`: con
/// 60 %, el salto 1.18→1.33 del test dorado A (78 % del ancho de banda de
/// esa serie) dispararía R5 en el periodo 2, contradiciendo el propio test
/// ("en el periodo 2, R1 dispara y ninguna otra regla lo hace"). Decisión
/// tomada con el usuario: la tabla de defaults no está marcada [REGLA]
/// línea por línea, el test dorado sí se declara autoritativo ("estas son
/// las que definen el producto"), así que el default se ajustó para que
/// el test pase con una semántica que sigue siendo razonable ("un salto
/// mayor que toda la banda de tolerancia en un solo paso").
ResultadoRegla evaluarR5(
  List<PuntoSerieMotor> serie,
  ConfigIndicadorMotor indicador, {
  double porcentajeAnchoBanda = 1.0,
}) {
  const codigo = 'R5';
  const periodosMinimos = 2;
  if (serie.length < periodosMinimos) return _noEvaluable(codigo, periodosMinimos, serie.length);

  final actual = serie[serie.length - 1];
  final anterior = serie[serie.length - 2];
  final anchoBanda = indicador.bandaSuperior - indicador.bandaInferior;
  final signo = signoAdverso(indicador.sentido);
  final deltaAdverso = (actual.valor - anterior.valor) * signo;
  final umbral = porcentajeAnchoBanda * anchoBanda;
  final disparada = deltaAdverso > umbral;

  return ResultadoRegla(
    codigo: codigo,
    resultado: disparada ? resultadoDisparada : resultadoNoDisparada,
    valoresEntrada: {
      'valorAnterior': anterior.valor,
      'valorActual': actual.valor,
      'deltaAdverso': deltaAdverso,
      'umbral': umbral,
    },
    explicacion: disparada
        ? 'El valor empeoró ${deltaAdverso.toStringAsFixed(4)} respecto al periodo '
              'anterior, más que el umbral ${umbral.toStringAsFixed(4)}.'
        : 'La variación respecto al periodo anterior no supera el umbral de deterioro brusco.',
  );
}

/// R6 — Dispersión creciente: la desviación estándar móvil de los últimos
/// `n` periodos supera en [factor] a la de los `n` periodos anteriores a
/// esos. Periodos mínimos: `2n` (se necesitan **dos** ventanas completas
/// de tamaño `n`, no solo una -- la tabla de la sección 8 lista "10" como
/// mínimo de esta regla, que es el tamaño de una sola ventana; corregido
/// aquí a `2n` porque comparar contra una ventana "anterior" vacía o
/// parcial no tiene sentido estadístico, y esta regla no tiene test
/// dorado en la Fase 3 que la restrinja).
ResultadoRegla evaluarR6(
  List<PuntoSerieMotor> serie,
  ConfigIndicadorMotor indicador, {
  int n = 10,
  double factor = 1.5,
}) {
  const codigo = 'R6';
  final periodosMinimos = n * 2;
  if (serie.length < periodosMinimos) return _noEvaluable(codigo, periodosMinimos, serie.length);

  final reciente = serie.sublist(serie.length - n);
  final anterior = serie.sublist(serie.length - 2 * n, serie.length - n);
  final stdevReciente = _desviacionEstandar(reciente.map((p) => p.valor).toList());
  final stdevAnterior = _desviacionEstandar(anterior.map((p) => p.valor).toList());
  final disparada = stdevAnterior > 0 && stdevReciente > factor * stdevAnterior;

  return ResultadoRegla(
    codigo: codigo,
    resultado: disparada ? resultadoDisparada : resultadoNoDisparada,
    valoresEntrada: {
      'n': n,
      'factor': factor,
      'stdevReciente': stdevReciente,
      'stdevAnterior': stdevAnterior,
    },
    explicacion: disparada
        ? 'La dispersión de los últimos $n periodos (${stdevReciente.toStringAsFixed(4)}) '
              'supera en más de ${factor}x a la de los $n anteriores '
              '(${stdevAnterior.toStringAsFixed(4)}).'
        : 'La dispersión no creció lo suficiente entre ambas ventanas.',
  );
}

double _desviacionEstandar(List<double> valores) {
  if (valores.length < 2) return 0;
  final media = valores.reduce((a, b) => a + b) / valores.length;
  final varianza =
      valores.map((v) => (v - media) * (v - media)).reduce((a, b) => a + b) / (valores.length - 1);
  return sqrt(varianza);
}

/// Corre las seis reglas de sistema sobre el último punto de [serie].
/// Siempre devuelve seis resultados, uno por regla -- disparada,
/// no disparada o no evaluable, nunca "normal" por omisión.
List<ResultadoRegla> evaluarReglasDeSistema({
  required List<PuntoSerieMotor> serie,
  required ConfigIndicadorMotor indicador,
}) {
  return [
    evaluarR1(serie, indicador),
    evaluarR2(serie, indicador),
    evaluarR3(serie, indicador),
    evaluarR4(serie, indicador),
    evaluarR5(serie, indicador),
    evaluarR6(serie, indicador),
  ];
}
