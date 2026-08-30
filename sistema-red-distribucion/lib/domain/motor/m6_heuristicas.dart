import 'dart:convert';
import 'dart:math';

import 'evaluador_costo.dart';
import 'fila_memoria.dart';

/// Se lanza cuando una búsqueda se cancela a mitad de camino (Pantalla 10,
/// CLAUDE.md sección 9, Fase 6) — nunca se devuelve un [ResultadoBusqueda]
/// parcial: quien orquesta (la pantalla) solo persiste un escenario si la
/// función termina con éxito, así que una cancelación no puede dejar nada
/// a medias en la base (mismo patrón que `construirMatriz`, Fase 4).
class BusquedaCancelada implements Exception {
  const BusquedaCancelada();

  @override
  String toString() => 'Búsqueda cancelada por el usuario.';
}

/// Token compartido entre la UI y una búsqueda en curso — la UI llama
/// [cancelar] desde el botón "Cancelar"; la búsqueda revisa
/// [estaCancelado] entre pasos.
class TokenCancelacion {
  bool _cancelado = false;

  void cancelar() => _cancelado = true;

  bool get estaCancelado => _cancelado;
}

class PuntoCurvaCalculado {
  const PuntoCurvaCalculado({required this.numeroAlmacenes, required this.costoTotalCent});

  final int numeroAlmacenes;
  final int costoTotalCent;
}

class ResultadoBusqueda {
  const ResultadoBusqueda({
    required this.abiertos,
    required this.costoTotalCent,
    required this.curva,
    required this.memoria,
  });

  final Set<int> abiertos;
  final int costoTotalCent;
  final List<PuntoCurvaCalculado> curva;
  final List<FilaMemoria> memoria;
}

/// Revisa cancelación en todos los pasos (barato, sincrónico) pero solo le
/// cede el control al event loop cada [cada] pasos (`await` real) — sin
/// esto una búsqueda larga nunca deja procesar el tap del botón
/// "Cancelar" (Dart es de un solo hilo: solo se atiende un evento de UI
/// cuando el código en curso le devuelve el control).
Future<void> _puntoDeControl(TokenCancelacion? cancelacion, int paso, {int cada = 1}) async {
  if (paso % cada == 0) {
    await Future<void>.delayed(Duration.zero);
  }
  if (cancelacion?.estaCancelado ?? false) throw const BusquedaCancelada();
}

/// M6 — ADD (CLAUDE.md sección 7): en cada paso agrega el candidato cerrado
/// cuya apertura más reduce el costo total; se detiene cuando ninguno
/// reduce el costo o se llega a `pMax`. Test O (Fase 6) exige que el costo
/// registrado en la curva sea estrictamente decreciente — se cumple por
/// construcción: solo se agrega un candidato cuando reduce el costo
/// estrictamente.
Future<ResultadoBusqueda> heuristicaAdd({
  required List<int> candidatosDisponibles,
  required int pMax,
  required EvaluadorCosto evaluador,
  TokenCancelacion? cancelacion,
  void Function(int abiertos, int pMax)? onProgreso,
}) async {
  final abiertos = <int>{};
  final curva = <PuntoCurvaCalculado>[];
  final limite = min(pMax, candidatosDisponibles.length);

  var paso = 0;
  while (abiertos.length < limite) {
    await _puntoDeControl(cancelacion, paso++);

    final costoActual = abiertos.isEmpty ? null : evaluador.costoDe(abiertos);
    int? mejorCandidato;
    int? mejorCosto;
    for (final candidatoId in candidatosDisponibles) {
      if (abiertos.contains(candidatoId)) continue;
      final costo = evaluador.costoDe({...abiertos, candidatoId});
      if (mejorCosto == null || costo < mejorCosto) {
        mejorCosto = costo;
        mejorCandidato = candidatoId;
      }
    }

    if (mejorCandidato == null) break;
    if (costoActual != null && mejorCosto! >= costoActual) break;

    abiertos.add(mejorCandidato);
    curva.add(PuntoCurvaCalculado(numeroAlmacenes: abiertos.length, costoTotalCent: mejorCosto!));
    onProgreso?.call(abiertos.length, limite);
  }

  final costoFinal = curva.isEmpty ? evaluador.costoDe(abiertos) : curva.last.costoTotalCent;
  return ResultadoBusqueda(
    abiertos: abiertos,
    costoTotalCent: costoFinal,
    curva: curva,
    memoria: [
      FilaMemoria(
        modulo: 'M6',
        formula: 'ADD: agrega en cada paso el candidato cerrado cuya apertura más reduce el costo '
            'total; se detiene si ninguno reduce el costo o al llegar a p_max',
        entradasJson: jsonEncode({'p_max': pMax, 'candidatos_disponibles': candidatosDisponibles.length}),
        salida: '${abiertos.length} almacén(es) abierto(s), costo $costoFinal',
        unidad: 'centavos',
      ),
    ],
  );
}

/// M6 — DROP: arranca con todos los candidatos abiertos y en cada paso
/// cierra el que más reduce el costo total, hasta que ninguno reduce o
/// queda solo uno.
Future<ResultadoBusqueda> heuristicaDrop({
  required List<int> todosCandidatos,
  required EvaluadorCosto evaluador,
  TokenCancelacion? cancelacion,
  void Function(int abiertos)? onProgreso,
}) async {
  var abiertos = todosCandidatos.toSet();
  final curva = <PuntoCurvaCalculado>[
    PuntoCurvaCalculado(numeroAlmacenes: abiertos.length, costoTotalCent: evaluador.costoDe(abiertos)),
  ];

  var paso = 0;
  while (abiertos.length > 1) {
    await _puntoDeControl(cancelacion, paso++);

    final costoActual = curva.last.costoTotalCent;
    int? peor;
    int? mejorCostoTrasCerrar;
    for (final candidatoId in abiertos) {
      final nuevo = Set<int>.of(abiertos)..remove(candidatoId);
      final costo = evaluador.costoDe(nuevo);
      if (mejorCostoTrasCerrar == null || costo < mejorCostoTrasCerrar) {
        mejorCostoTrasCerrar = costo;
        peor = candidatoId;
      }
    }

    if (peor == null || mejorCostoTrasCerrar! >= costoActual) break;

    abiertos = Set<int>.of(abiertos)..remove(peor);
    curva.add(PuntoCurvaCalculado(numeroAlmacenes: abiertos.length, costoTotalCent: mejorCostoTrasCerrar));
    onProgreso?.call(abiertos.length);
  }

  return ResultadoBusqueda(
    abiertos: abiertos,
    costoTotalCent: curva.last.costoTotalCent,
    curva: curva,
    memoria: [
      FilaMemoria(
        modulo: 'M6',
        formula: 'DROP: arranca con todos los candidatos abiertos y en cada paso cierra el que más '
            'reduce el costo total, hasta que ninguno reduce o queda uno solo',
        entradasJson: jsonEncode({'candidatos': todosCandidatos.length}),
        salida: '${abiertos.length} almacén(es) abierto(s), costo ${curva.last.costoTotalCent}',
        unidad: 'centavos',
      ),
    ],
  );
}

/// M6 — intercambio de Teitz y Bart: mejora local a `p` fijo. Prueba
/// intercambiar cada abierto por cada cerrado y se queda con el mejor
/// intercambio de la ronda; repite hasta que ninguno mejora.
Future<ResultadoBusqueda> intercambioTeitzBart({
  required Set<int> abiertosInicial,
  required List<int> candidatosDisponibles,
  required EvaluadorCosto evaluador,
  TokenCancelacion? cancelacion,
  void Function(int iteracion)? onProgreso,
}) async {
  var actual = Set<int>.of(abiertosInicial);
  var costoActual = evaluador.costoDe(actual);

  var iteracion = 0;
  while (true) {
    await _puntoDeControl(cancelacion, iteracion++);

    Set<int>? mejorNuevo;
    int? mejorCosto;
    for (final a in actual) {
      for (final c in candidatosDisponibles) {
        if (actual.contains(c)) continue;
        final nuevo = Set<int>.of(actual)
          ..remove(a)
          ..add(c);
        final costo = evaluador.costoDe(nuevo);
        if (costo < costoActual && (mejorCosto == null || costo < mejorCosto)) {
          mejorCosto = costo;
          mejorNuevo = nuevo;
        }
      }
    }

    if (mejorNuevo == null) break;
    actual = mejorNuevo;
    costoActual = mejorCosto!;
    onProgreso?.call(iteracion);
  }

  return ResultadoBusqueda(
    abiertos: actual,
    costoTotalCent: costoActual,
    curva: const [],
    memoria: [
      FilaMemoria(
        modulo: 'M6',
        formula: 'Intercambio de Teitz y Bart: en cada ronda prueba cambiar cada abierto por cada '
            'cerrado y aplica el mejor intercambio de la ronda; se detiene cuando ninguno mejora',
        entradasJson: jsonEncode({
          'abiertos_iniciales': abiertosInicial.length,
          'iteraciones': iteracion,
        }),
        salida: '$costoActual',
        unidad: 'centavos',
      ),
    ],
  );
}

/// M6 — recocido simulado (CLAUDE.md sección 7, `[REGLA]`: semilla
/// explícita y reproducible). Vecino = voltear un bit (abrir/cerrar un
/// candidato) o intercambiar dos (cerrar uno abierto, abrir uno cerrado).
/// Temperatura inicial calibrada muestreando vecinos para aceptar ~50% de
/// los empeoramientos observados; enfriamiento geométrico; para por
/// iteraciones sin mejora. Devuelve el mejor estado visto, no
/// necesariamente el estado final (práctica estándar de recocido
/// simulado).
Future<ResultadoBusqueda> recocidoSimulado({
  required List<int> candidatosDisponibles,
  required EvaluadorCosto evaluador,
  required int semilla,
  int? pFijo,
  int iteracionesSinMejoraParaParar = 200,
  double alfaEnfriamiento = 0.95,
  TokenCancelacion? cancelacion,
  void Function(int iteracion, double temperatura, int costoActual)? onProgreso,
}) async {
  final random = Random(semilla);

  Set<int> vecino(Set<int> estado) {
    final cerrados = candidatosDisponibles.where((id) => !estado.contains(id)).toList();
    if (random.nextBool() && cerrados.isNotEmpty && estado.length > 1) {
      final listaAbiertos = estado.toList();
      final aCerrar = listaAbiertos[random.nextInt(listaAbiertos.length)];
      final aAbrir = cerrados[random.nextInt(cerrados.length)];
      return Set<int>.of(estado)
        ..remove(aCerrar)
        ..add(aAbrir);
    }
    final candidato = candidatosDisponibles[random.nextInt(candidatosDisponibles.length)];
    final nuevo = Set<int>.of(estado);
    if (nuevo.contains(candidato)) {
      if (nuevo.length > 1) nuevo.remove(candidato);
    } else {
      nuevo.add(candidato);
    }
    return nuevo;
  }

  Set<int> estadoInicial() {
    if (pFijo != null && pFijo > 0 && pFijo <= candidatosDisponibles.length) {
      final copia = List<int>.of(candidatosDisponibles)..shuffle(random);
      return copia.take(pFijo).toSet();
    }
    Set<int> estado;
    do {
      estado = {for (final id in candidatosDisponibles) if (random.nextDouble() < 0.5) id};
    } while (estado.isEmpty);
    return estado;
  }

  var actual = estadoInicial();
  var costoActual = evaluador.costoDe(actual);
  var mejor = actual;
  var costoMejor = costoActual;

  // Temperatura inicial: promedia los incrementos de costo de una muestra
  // de vecinos y calibra T0 para que exp(-Δ/T0) ≈ 0.5 en el incremento
  // promedio observado.
  final incrementos = <int>[];
  for (var i = 0; i < 20; i++) {
    final delta = evaluador.costoDe(vecino(actual)) - costoActual;
    if (delta > 0) incrementos.add(delta);
  }
  final deltaPromedio = incrementos.isEmpty
      ? 1.0
      : incrementos.reduce((a, b) => a + b) / incrementos.length;
  var temperatura = deltaPromedio <= 0 ? 1.0 : deltaPromedio / log(2);

  var iteracion = 0;
  var iteracionesSinMejora = 0;

  while (iteracionesSinMejora < iteracionesSinMejoraParaParar) {
    await _puntoDeControl(cancelacion, iteracion, cada: 20);
    iteracion++;

    final propuesto = vecino(actual);
    final costoPropuesto = evaluador.costoDe(propuesto);
    final delta = costoPropuesto - costoActual;

    final aceptar = delta < 0 || random.nextDouble() < exp(-delta / temperatura);
    if (aceptar) {
      actual = propuesto;
      costoActual = costoPropuesto;
    }

    if (costoActual < costoMejor) {
      mejor = actual;
      costoMejor = costoActual;
      iteracionesSinMejora = 0;
    } else {
      iteracionesSinMejora++;
    }

    temperatura *= alfaEnfriamiento;
    onProgreso?.call(iteracion, temperatura, costoActual);
  }

  return ResultadoBusqueda(
    abiertos: mejor,
    costoTotalCent: costoMejor,
    curva: const [],
    memoria: [
      FilaMemoria(
        modulo: 'M6',
        formula: 'Recocido simulado: vecino = voltear un bit o intercambiar dos; enfriamiento '
            'geométrico (α=$alfaEnfriamiento); para tras $iteracionesSinMejoraParaParar iteraciones '
            'sin mejora; semilla=$semilla',
        entradasJson: jsonEncode({
          'candidatos_disponibles': candidatosDisponibles.length,
          'p_fijo': pFijo,
          'semilla': semilla,
          'iteraciones_totales': iteracion,
        }),
        salida: '$costoMejor',
        unidad: 'centavos',
      ),
    ],
  );
}

/// M6 — enumeración exhaustiva (CLAUDE.md sección 7, `[REGLA]`: viable
/// hasta 14 candidatos, 2^14=16384 configuraciones). Óptimo exacto — es lo
/// que valida las heurísticas en los tests de la Fase 6 y también un modo
/// de uso legítimo para casos pequeños desde la Pantalla 10.
Future<ResultadoBusqueda> enumeracionExhaustiva({
  required List<int> candidatos,
  required EvaluadorCosto evaluador,
  int? pFijo,
  TokenCancelacion? cancelacion,
  void Function(int evaluadas, int total)? onProgreso,
}) async {
  assert(
    candidatos.length <= 14,
    'La enumeración exhaustiva solo es viable hasta 14 candidatos (2^14 configuraciones).',
  );
  final n = candidatos.length;
  final totalConfiguraciones = (1 << n) - 1;

  Set<int>? mejor;
  var mejorCosto = costoInfinito;

  for (var mascara = 1; mascara <= totalConfiguraciones; mascara++) {
    await _puntoDeControl(cancelacion, mascara, cada: 200);

    if (pFijo != null && _bitsEncendidos(mascara) != pFijo) continue;

    final abiertos = <int>{
      for (var i = 0; i < n; i++)
        if ((mascara & (1 << i)) != 0) candidatos[i],
    };
    final costo = evaluador.costoDe(abiertos);
    if (costo < mejorCosto) {
      mejorCosto = costo;
      mejor = abiertos;
    }
    onProgreso?.call(mascara, totalConfiguraciones);
  }

  return ResultadoBusqueda(
    abiertos: mejor ?? const {},
    costoTotalCent: mejorCosto,
    curva: const [],
    memoria: [
      FilaMemoria(
        modulo: 'M6',
        formula: 'Enumeración exhaustiva: evalúa las 2^n − 1 configuraciones no vacías (con p fijo si '
            'se pidió) y devuelve la de menor costo — óptimo exacto',
        entradasJson: jsonEncode({'n_candidatos': n, 'p_fijo': pFijo}),
        salida: '$mejorCosto',
        unidad: 'centavos',
      ),
    ],
  );
}

int _bitsEncendidos(int mascara) {
  var contador = 0;
  var m = mascara;
  while (m != 0) {
    contador += m & 1;
    m >>= 1;
  }
  return contador;
}
