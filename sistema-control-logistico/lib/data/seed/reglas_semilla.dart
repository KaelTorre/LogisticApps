import '../models/regla_patron.dart';

/// Las seis reglas de sistema de M1 (CLAUDE.md sección 8), como filas
/// globales de `regla_patron` (`indicadorId: null`). `parametrosJson`
/// refleja los mismos valores por defecto que ya usan las funciones puras
/// de `lib/domain/motor/m1_reglas_patron.dart` -- **si algún día se separa
/// esta fila y se le da un valor distinto desde Pantalla 5 (Reglas), M1
/// seguirá evaluando con su propio default hasta que el código que llama
/// a `evaluarReglasDeSistema` empiece a leer y pasar estos parámetros
/// explícitamente.** Por ahora, estas filas existen únicamente para que
/// `memoria_evaluacion.reglaId` tenga a qué apuntar.
///
/// `severidadBase` es metadato descriptivo -- el cálculo real de
/// severidad lo hace M2 con su propia fórmula (`ResultadoClasificacion
/// .severidadCalculada`), no lee esta columna todavía.
final reglasDeSistemaSemilla = <ReglaPatron>[
  const ReglaPatron(
    codigo: 'R1',
    nombre: 'Punto fuera de banda',
    descripcion: 'El último valor está fuera de la banda de tolerancia.',
    parametrosJson: '{}',
    periodosMinimos: 1,
    severidadBase: 1,
  ),
  const ReglaPatron(
    codigo: 'R2',
    nombre: 'Racha en el lado adverso',
    descripcion: '7 valores consecutivos del lado adverso de la meta.',
    parametrosJson: '{"n":7}',
    periodosMinimos: 7,
    severidadBase: 2,
  ),
  const ReglaPatron(
    codigo: 'R3',
    nombre: 'Corrimiento de media',
    descripcion: '8 de los últimos 8 valores del lado adverso de la meta.',
    parametrosJson: '{"n":8,"m":8}',
    periodosMinimos: 8,
    severidadBase: 2,
  ),
  const ReglaPatron(
    codigo: 'R4',
    nombre: 'Tendencia sostenida',
    descripcion:
        '5 valores consecutivos monótonos hacia el lado adverso, todos del lado adverso de la meta.',
    parametrosJson: '{"n":5}',
    periodosMinimos: 5,
    severidadBase: 3,
  ),
  const ReglaPatron(
    codigo: 'R5',
    nombre: 'Deterioro brusco',
    descripcion:
        'La variación respecto al periodo anterior, en la dirección adversa, supera el ancho de banda.',
    parametrosJson: '{"porcentajeAnchoBanda":1.0}',
    periodosMinimos: 2,
    severidadBase: 3,
  ),
  const ReglaPatron(
    codigo: 'R6',
    nombre: 'Dispersión creciente',
    descripcion:
        'La desviación estándar de los últimos 10 periodos supera en 1.5x a la de los 10 anteriores.',
    parametrosJson: '{"n":10,"factor":1.5}',
    periodosMinimos: 20,
    severidadBase: 2,
  ),
];
