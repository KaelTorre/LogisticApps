/// Una fila de medición ya parseada y validada del CSV, lista para
/// resolverse contra los periodos existentes de la organización (el
/// importador es una función pura, sin acceso a base de datos -- no puede
/// saber si `orden` corresponde a un periodo real, eso lo resuelve quien
/// llama, igual que el importador de clientes de `sistema-red-distribucion`
/// deja `proyectoId` fuera de la fila parseada).
class FilaMedicionImportada {
  const FilaMedicionImportada({required this.orden, required this.valor, this.nota});

  final int orden;
  final double valor;
  final String? nota;
}

/// Resultado de parsear un CSV completo: las filas válidas más un mensaje
/// por cada fila rechazada (con su número de línea), sin abortar el resto
/// de la importación (CLAUDE.md, Pruebas de la Fase 2).
class ResultadoImportacionCsv {
  const ResultadoImportacionCsv({required this.filas, required this.errores});

  final List<FilaMedicionImportada> filas;
  final List<String> errores;
}

const _encabezadosOrden = ['orden', 'periodo', 'periodo_orden'];
const _encabezadosValor = ['valor', 'medicion', 'medición'];
const _encabezadosNota = ['nota', 'notas', 'comentario'];

/// Parsea el contenido crudo de un CSV de mediciones para un único
/// indicador: detecta el separador (coma, punto y coma o tabulador),
/// detecta si la primera línea es encabezado o ya es un dato, mapea
/// columnas por nombre si hay encabezado (o asume el orden `orden, valor`
/// si no lo hay, con `nota` opcional como tercera columna), y valida fila
/// por fila -- una fila malformada se rechaza individualmente sin abortar
/// el resto.
///
/// Nota: split ingenuo por separador (sin soporte de campos entre comillas
/// con el separador embebido) -- mismo criterio que el importador de
/// clientes, suficiente para el CSV plano de una hoja de cálculo.
ResultadoImportacionCsv parsearCsvMediciones(String contenido) {
  final lineas = contenido.split(RegExp(r'\r\n|\r|\n')).where((l) => l.trim().isNotEmpty).toList();

  if (lineas.isEmpty) {
    return const ResultadoImportacionCsv(filas: [], errores: []);
  }

  final separador = _detectarSeparador(lineas.first);
  final primeraFila = _dividirLinea(lineas.first, separador);
  final indices = _mapearColumnas(primeraFila);

  final tieneEncabezado = indices != null;
  final mapaColumnas = indices ?? const {'orden': 0, 'valor': 1};

  final filas = <FilaMedicionImportada>[];
  final errores = <String>[];

  final inicioDatos = tieneEncabezado ? 1 : 0;
  for (var i = inicioDatos; i < lineas.length; i++) {
    final numeroLinea = i + 1;
    final campos = _dividirLinea(lineas[i], separador);
    final maximoIndiceRequerido = mapaColumnas.values.reduce((a, b) => a > b ? a : b);
    if (campos.length <= maximoIndiceRequerido) {
      errores.add(
        'Línea $numeroLinea: tiene ${campos.length} columnas, se esperaban al '
        'menos ${maximoIndiceRequerido + 1}.',
      );
      continue;
    }

    try {
      final orden = _parsearEntero(campos[mapaColumnas['orden']!]);
      if (orden < 1) {
        errores.add('Línea $numeroLinea: el orden debe ser un entero positivo.');
        continue;
      }
      final valor = _parsearDouble(campos[mapaColumnas['valor']!]);
      final indiceNota = mapaColumnas['nota'];
      final nota = (indiceNota != null && indiceNota < campos.length)
          ? campos[indiceNota].trim()
          : null;

      filas.add(
        FilaMedicionImportada(
          orden: orden,
          valor: valor,
          nota: (nota == null || nota.isEmpty) ? null : nota,
        ),
      );
    } on FormatException catch (e) {
      errores.add('Línea $numeroLinea: ${e.message}');
    }
  }

  return ResultadoImportacionCsv(filas: filas, errores: errores);
}

String _detectarSeparador(String primeraLinea) {
  const candidatos = [',', ';', '\t'];
  var mejor = candidatos.first;
  var mejorConteo = -1;
  for (final candidato in candidatos) {
    final conteo = primeraLinea.split(candidato).length - 1;
    if (conteo > mejorConteo) {
      mejorConteo = conteo;
      mejor = candidato;
    }
  }
  return mejor;
}

List<String> _dividirLinea(String linea, String separador) {
  return linea
      .split(separador)
      .map((campo) => campo.trim())
      .map(
        (campo) => campo.startsWith('"') && campo.endsWith('"') && campo.length >= 2
            ? campo.substring(1, campo.length - 1)
            : campo,
      )
      .toList();
}

/// Si la primera fila es reconocible como encabezado (sus columnas
/// obligatorias -- `orden` y `valor` -- coinciden con algún sinónimo
/// conocido), devuelve el mapa nombre-de-columna → índice, incluyendo
/// `nota` si también aparece. Si no, devuelve `null` (se asume que la
/// primera fila ya es un dato, en el orden fijo `orden, valor`).
Map<String, int>? _mapearColumnas(List<String> primeraFila) {
  final normalizada = primeraFila.map((c) => c.trim().toLowerCase()).toList();

  int? buscar(List<String> sinonimos) {
    for (var i = 0; i < normalizada.length; i++) {
      if (sinonimos.contains(normalizada[i])) return i;
    }
    return null;
  }

  final orden = buscar(_encabezadosOrden);
  final valor = buscar(_encabezadosValor);
  if (orden == null || valor == null) return null;

  final nota = buscar(_encabezadosNota);
  return {'orden': orden, 'valor': valor, 'nota': ?nota};
}

double _parsearDouble(String texto) {
  final valor = double.tryParse(texto.trim().replaceAll(',', '.'));
  if (valor == null) {
    throw FormatException('"$texto" no es un número válido.');
  }
  return valor;
}

int _parsearEntero(String texto) {
  final valor = int.tryParse(texto.trim());
  if (valor == null) {
    throw FormatException('"$texto" no es un número entero válido.');
  }
  return valor;
}
