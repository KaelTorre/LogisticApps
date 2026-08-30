/// Una fila de cliente ya parseada y validada del CSV, lista para insertar
/// con `ClienteRepository.crear` (falta solo `proyectoId`, que decide quien
/// llama al importador).
class FilaClienteImportada {
  const FilaClienteImportada({
    required this.nombre,
    required this.latitud,
    required this.longitud,
    required this.demandaAnual,
    required this.pedidosAnuales,
  });

  final String nombre;
  final double latitud;
  final double longitud;
  final double demandaAnual;
  final int pedidosAnuales;
}

/// Resultado de parsear un CSV completo: las filas válidas más un mensaje
/// por cada fila rechazada (con su número de línea), sin abortar el resto
/// de la importación (CLAUDE.md, Pruebas de la Fase 2).
class ResultadoImportacionCsv {
  const ResultadoImportacionCsv({required this.filas, required this.errores});

  final List<FilaClienteImportada> filas;
  final List<String> errores;
}

const _encabezadosNombre = ['nombre', 'cliente', 'razon_social', 'razón_social'];
const _encabezadosLatitud = ['latitud', 'lat'];
const _encabezadosLongitud = ['longitud', 'lon', 'lng'];
const _encabezadosDemanda = ['demanda_anual', 'demanda', 'demandaanual'];
const _encabezadosPedidos = ['pedidos_anuales', 'pedidos', 'pedidosanuales'];

/// Parsea el contenido crudo de un CSV de clientes: detecta el separador
/// (coma, punto y coma o tabulador), detecta si la primera línea es
/// encabezado o ya es un dato, mapea columnas por nombre si hay encabezado
/// (o asume el orden nombre, latitud, longitud, demanda_anual,
/// pedidos_anuales si no lo hay), y valida fila por fila — una fila
/// malformada se rechaza individualmente sin abortar el resto.
///
/// Nota: split ingenuo por separador (sin soporte de campos entre comillas
/// con el separador embebido) — suficiente para el CSV plano que produce
/// cualquier hoja de cálculo al exportar sin texto con comas internas.
ResultadoImportacionCsv parsearCsvClientes(String contenido) {
  final lineas = contenido
      .split(RegExp(r'\r\n|\r|\n'))
      .where((l) => l.trim().isNotEmpty)
      .toList();

  if (lineas.isEmpty) {
    return const ResultadoImportacionCsv(filas: [], errores: []);
  }

  final separador = _detectarSeparador(lineas.first);
  final primeraFila = _dividirLinea(lineas.first, separador);
  final indices = _mapearColumnas(primeraFila);

  final tieneEncabezado = indices != null;
  final mapaColumnas = indices ?? const {'nombre': 0, 'latitud': 1, 'longitud': 2, 'demanda_anual': 3, 'pedidos_anuales': 4};

  final filas = <FilaClienteImportada>[];
  final errores = <String>[];

  final inicioDatos = tieneEncabezado ? 1 : 0;
  for (var i = inicioDatos; i < lineas.length; i++) {
    final numeroLinea = i + 1;
    final campos = _dividirLinea(lineas[i], separador);
    final maximoIndiceRequerido = mapaColumnas.values.reduce((a, b) => a > b ? a : b);
    if (campos.length <= maximoIndiceRequerido) {
      errores.add('Línea $numeroLinea: tiene ${campos.length} columnas, se '
          'esperaban al menos ${maximoIndiceRequerido + 1}.');
      continue;
    }

    try {
      final nombre = campos[mapaColumnas['nombre']!].trim();
      if (nombre.isEmpty) {
        errores.add('Línea $numeroLinea: el nombre está vacío.');
        continue;
      }
      final latitud = _parsearDouble(campos[mapaColumnas['latitud']!]);
      final longitud = _parsearDouble(campos[mapaColumnas['longitud']!]);
      final demanda = _parsearDouble(campos[mapaColumnas['demanda_anual']!]);
      final pedidos = _parsearEntero(campos[mapaColumnas['pedidos_anuales']!]);

      if (latitud < -90 || latitud > 90) {
        errores.add('Línea $numeroLinea: latitud $latitud fuera de rango '
            '(-90 a 90).');
        continue;
      }
      if (longitud < -180 || longitud > 180) {
        errores.add('Línea $numeroLinea: longitud $longitud fuera de rango '
            '(-180 a 180).');
        continue;
      }

      filas.add(
        FilaClienteImportada(
          nombre: nombre,
          latitud: latitud,
          longitud: longitud,
          demandaAnual: demanda,
          pedidosAnuales: pedidos,
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
      .map((campo) => campo.startsWith('"') && campo.endsWith('"') && campo.length >= 2
          ? campo.substring(1, campo.length - 1)
          : campo)
      .toList();
}

/// Si la primera fila es reconocible como encabezado (todas sus columnas
/// obligatorias coinciden con alguno de los sinónimos conocidos), devuelve
/// el mapa nombre-de-columna → índice. Si no, devuelve `null` (se asume que
/// la primera fila ya es un dato, en el orden fijo de siempre).
Map<String, int>? _mapearColumnas(List<String> primeraFila) {
  final normalizada = primeraFila.map((c) => c.trim().toLowerCase()).toList();

  int? buscar(List<String> sinonimos) {
    for (var i = 0; i < normalizada.length; i++) {
      if (sinonimos.contains(normalizada[i])) return i;
    }
    return null;
  }

  final nombre = buscar(_encabezadosNombre);
  final latitud = buscar(_encabezadosLatitud);
  final longitud = buscar(_encabezadosLongitud);
  final demanda = buscar(_encabezadosDemanda);
  final pedidos = buscar(_encabezadosPedidos);

  if (nombre == null ||
      latitud == null ||
      longitud == null ||
      demanda == null ||
      pedidos == null) {
    return null;
  }

  return {
    'nombre': nombre,
    'latitud': latitud,
    'longitud': longitud,
    'demanda_anual': demanda,
    'pedidos_anuales': pedidos,
  };
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
