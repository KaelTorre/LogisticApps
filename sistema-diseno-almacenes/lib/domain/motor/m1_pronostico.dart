import 'fila_memoria.dart';

/// Resultado de un modelo de pronóstico individual, con sus métricas de
/// error (CLAUDE.md sección 7, M1: "MAD, MSE, MAPE y señal de rastreo").
class ResultadoModeloPronostico {
  const ResultadoModeloPronostico({
    required this.nombre,
    required this.pronostico,
    required this.mad,
    required this.mse,
    required this.mape,
    required this.senalRastreo,
  });

  final String nombre;

  /// Pronóstico para los períodos futuros (horizonte).
  final List<double> pronostico;
  final double mad;
  final double mse;

  /// En porcentaje (0-100).
  final double mape;
  final double senalRastreo;
}

class ResultadoM1 {
  const ResultadoM1({
    required this.modeloElegido,
    required this.pronostico,
    required this.modelosEvaluados,
    required this.memoria,
  });

  final ResultadoModeloPronostico modeloElegido;
  final List<double> pronostico;
  final List<ResultadoModeloPronostico> modelosEvaluados;
  final List<FilaMemoria> memoria;
}

/// M1 — Pronóstico de demanda (CLAUDE.md sección 7). Evalúa suavización
/// exponencial simple, Holt (tendencia) y, si hay al menos 2 ciclos
/// estacionales completos de historia, Winters (tendencia + estacionalidad)
/// y descomposición clásica. Elige el de menor MAPE y lo declara.
///
/// **[REGLA]** se pronostica sobre demanda futura: el llamador debe usar
/// `pronostico.last` (el año/período final del horizonte) para dimensionar,
/// no el dato histórico más reciente.
///
/// Las constantes de suavizado (α=0.3, β=0.1, γ=0.1) son valores fijos de
/// libro de texto, no una búsqueda de grilla que minimice el error — una
/// simplificación declarada, igual que otras de este proyecto.
///
/// Función pura: sin acceso a base de datos, sin estado.
ResultadoM1 calcularPronostico({
  required List<double> historico,
  required int horizonte,
  int? longitudEstacional,
  double alpha = 0.3,
  double beta = 0.1,
  double gamma = 0.1,
}) {
  if (historico.length < 2) {
    throw ArgumentError('Se necesitan al menos 2 períodos de historia.');
  }
  if (horizonte <= 0) {
    throw ArgumentError.value(horizonte, 'horizonte', 'Debe ser mayor que cero.');
  }

  final modelos = <ResultadoModeloPronostico>[
    _suavizacionSimple(historico, alpha, horizonte),
    _holt(historico, alpha, beta, horizonte),
  ];

  final m = longitudEstacional;
  if (m != null && m >= 2 && historico.length >= 2 * m) {
    modelos.add(_winters(historico, alpha, beta, gamma, m, horizonte));
    modelos.add(_descomposicionClasica(historico, m, horizonte));
  }

  final elegido = modelos.reduce((a, b) => b.mape < a.mape ? b : a);

  final memoria = [
    FilaMemoria(
      orden: 1,
      modulo: 'M1',
      concepto: 'Modelo de pronóstico elegido',
      formula: 'elegir el modelo de menor MAPE entre '
          '${modelos.map((mo) => mo.nombre).join(", ")}',
      entradas: {
        for (final mo in modelos) mo.nombre: 'MAPE=${mo.mape.toStringAsFixed(2)}%',
      },
      valor: elegido.nombre,
      unidad: 'modelo',
    ),
    FilaMemoria(
      orden: 2,
      modulo: 'M1',
      concepto: 'Pronóstico para el horizonte',
      formula: 'pronóstico[h] según $elegido.nombre',
      entradas: {'horizonte': horizonte, 'mape': elegido.mape},
      valor: elegido.pronostico.map((v) => v.toStringAsFixed(1)).join(', '),
      unidad: 'unidades/período',
    ),
  ];

  return ResultadoM1(
    modeloElegido: elegido,
    pronostico: elegido.pronostico,
    modelosEvaluados: modelos,
    memoria: memoria,
  );
}

_Errores _calcularErrores(List<double> y, List<double> fcast, int offset) {
  final n = y.length - offset;
  var sumaAbs = 0.0, sumaCuad = 0.0, sumaPorc = 0.0, sumaSigno = 0.0;
  for (var i = 0; i < n; i++) {
    final actual = y[i + offset];
    final error = actual - fcast[i];
    sumaAbs += error.abs();
    sumaCuad += error * error;
    if (actual != 0) sumaPorc += (error.abs() / actual.abs());
    sumaSigno += error;
  }
  final mad = sumaAbs / n;
  final mse = sumaCuad / n;
  final mape = (sumaPorc / n) * 100;
  final senalRastreo = mad == 0 ? 0.0 : sumaSigno / mad;
  return _Errores(mad, mse, mape, senalRastreo);
}

class _Errores {
  const _Errores(this.mad, this.mse, this.mape, this.senalRastreo);
  final double mad, mse, mape, senalRastreo;
}

/// S_1 = y_1; S_t = α·y_t + (1-α)·S_(t-1). Pronóstico futuro plano = S_n.
ResultadoModeloPronostico _suavizacionSimple(List<double> y, double alpha, int horizonte) {
  final n = y.length;
  final s = List<double>.filled(n, 0);
  s[0] = y[0];
  for (var t = 1; t < n; t++) {
    s[t] = alpha * y[t] + (1 - alpha) * s[t - 1];
  }
  // fcast[t] (t=1..n-1) usa el nivel suavizado hasta t-1: fcast[t] = s[t-1].
  final fcast = [for (var t = 1; t < n; t++) s[t - 1]];
  final errores = _calcularErrores(y, fcast, 1);
  return ResultadoModeloPronostico(
    nombre: 'suavizacion_simple',
    pronostico: List.filled(horizonte, s[n - 1]),
    mad: errores.mad,
    mse: errores.mse,
    mape: errores.mape,
    senalRastreo: errores.senalRastreo,
  );
}

/// Holt: nivel + tendencia. L_t = α·y_t + (1-α)·(L_(t-1)+T_(t-1));
/// T_t = β·(L_t-L_(t-1)) + (1-β)·T_(t-1). Pronóstico[h] = L_n + h·T_n.
ResultadoModeloPronostico _holt(List<double> y, double alpha, double beta, int horizonte) {
  final n = y.length;
  final l = List<double>.filled(n, 0);
  final t = List<double>.filled(n, 0);
  l[0] = y[0];
  t[0] = n > 1 ? y[1] - y[0] : 0;
  for (var i = 1; i < n; i++) {
    l[i] = alpha * y[i] + (1 - alpha) * (l[i - 1] + t[i - 1]);
    t[i] = beta * (l[i] - l[i - 1]) + (1 - beta) * t[i - 1];
  }
  final fcast = [for (var i = 1; i < n; i++) l[i - 1] + t[i - 1]];
  final errores = _calcularErrores(y, fcast, 1);
  final pronostico = [for (var h = 1; h <= horizonte; h++) l[n - 1] + h * t[n - 1]];
  return ResultadoModeloPronostico(
    nombre: 'holt',
    pronostico: pronostico,
    mad: errores.mad,
    mse: errores.mse,
    mape: errores.mape,
    senalRastreo: errores.senalRastreo,
  );
}

/// Winters aditivo: nivel + tendencia + estacionalidad, período `m`.
ResultadoModeloPronostico _winters(
  List<double> y,
  double alpha,
  double beta,
  double gamma,
  int m,
  int horizonte,
) {
  final n = y.length;
  final promedioCiclo1 = _promedio(y.sublist(0, m));
  final promedioCiclo2 = _promedio(y.sublist(m, 2 * m));

  final l = List<double>.filled(n, 0);
  final t = List<double>.filled(n, 0);
  final s = List<double>.filled(n, 0);
  l[m - 1] = promedioCiclo1;
  t[m - 1] = (promedioCiclo2 - promedioCiclo1) / m;
  for (var i = 0; i < m; i++) {
    s[i] = y[i] - promedioCiclo1;
  }

  final fcast = <double>[];
  for (var i = m; i < n; i++) {
    final lAnterior = l[i - 1];
    final tAnterior = t[i - 1];
    fcast.add(lAnterior + tAnterior + s[i - m]);
    l[i] = alpha * (y[i] - s[i - m]) + (1 - alpha) * (lAnterior + tAnterior);
    t[i] = beta * (l[i] - lAnterior) + (1 - beta) * tAnterior;
    s[i] = gamma * (y[i] - l[i]) + (1 - gamma) * s[i - m];
  }

  final errores = _calcularErrores(y, fcast, m);
  final pronostico = [
    for (var h = 1; h <= horizonte; h++)
      l[n - 1] + h * t[n - 1] + s[n - m + ((h - 1) % m)],
  ];
  return ResultadoModeloPronostico(
    nombre: 'winters',
    pronostico: pronostico,
    mad: errores.mad,
    mse: errores.mse,
    mape: errores.mape,
    senalRastreo: errores.senalRastreo,
  );
}

/// Descomposición clásica: tendencia por media móvil centrada, índices
/// estacionales del promedio de los residuos, y una recta de tendencia
/// ajustada por mínimos cuadrados sobre los datos desestacionalizados.
ResultadoModeloPronostico _descomposicionClasica(List<double> y, int m, int horizonte) {
  final n = y.length;
  final tendencia = List<double?>.filled(n, null);
  final mitad = m ~/ 2;
  for (var i = mitad; i < n - mitad; i++) {
    if (m.isEven) {
      final ventana = y.sublist(i - mitad, i + mitad + 1);
      tendencia[i] = (_promedio(ventana.sublist(0, m)) + _promedio(ventana.sublist(1))) / 2;
    } else {
      tendencia[i] = _promedio(y.sublist(i - mitad, i + mitad + 1));
    }
  }

  final indicesEstacionales = List<double>.filled(m, 0);
  final conteos = List<int>.filled(m, 0);
  for (var i = 0; i < n; i++) {
    final tend = tendencia[i];
    if (tend != null) {
      indicesEstacionales[i % m] += y[i] - tend;
      conteos[i % m]++;
    }
  }
  for (var i = 0; i < m; i++) {
    indicesEstacionales[i] = conteos[i] > 0 ? indicesEstacionales[i] / conteos[i] : 0;
  }

  final desestacionalizado = [for (var i = 0; i < n; i++) y[i] - indicesEstacionales[i % m]];
  final (pendiente, intercepto) = _regresionLineal(desestacionalizado);

  final fcast = [for (var i = 0; i < n; i++) (intercepto + pendiente * i) + indicesEstacionales[i % m]];
  final errores = _calcularErrores(y, fcast, 0);
  final pronostico = [
    for (var h = 0; h < horizonte; h++)
      (intercepto + pendiente * (n + h)) + indicesEstacionales[(n + h) % m],
  ];
  return ResultadoModeloPronostico(
    nombre: 'descomposicion',
    pronostico: pronostico,
    mad: errores.mad,
    mse: errores.mse,
    mape: errores.mape,
    senalRastreo: errores.senalRastreo,
  );
}

double _promedio(List<double> valores) => valores.reduce((a, b) => a + b) / valores.length;

/// Mínimos cuadrados: y = intercepto + pendiente·x, x = 0..n-1.
(double, double) _regresionLineal(List<double> y) {
  final n = y.length;
  final xs = List.generate(n, (i) => i.toDouble());
  final xMedio = _promedio(xs);
  final yMedio = _promedio(y);
  var numerador = 0.0, denominador = 0.0;
  for (var i = 0; i < n; i++) {
    numerador += (xs[i] - xMedio) * (y[i] - yMedio);
    denominador += (xs[i] - xMedio) * (xs[i] - xMedio);
  }
  final pendiente = denominador == 0 ? 0.0 : numerador / denominador;
  final intercepto = yMedio - pendiente * xMedio;
  return (pendiente, intercepto);
}
