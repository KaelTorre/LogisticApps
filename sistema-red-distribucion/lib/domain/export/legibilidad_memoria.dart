import 'dart:convert';

import '../../core/dinero_utils.dart';

/// Traduce lo que guarda `memoria_calculo` (pensado para trazabilidad
/// interna: código de módulo, JSON de entradas con nombres de variable,
/// salida a veces en céntimos crudos) a texto que alguien sin acceso al
/// código pueda leer — usado por la ficha técnica en PDF (y por cualquier
/// otro reporte que muestre memoria de cálculo en el futuro).
///
/// Nunca inventa un dato: si aparece una clave de entrada que esta lista
/// todavía no conoce, se muestra igual (con guiones bajos cambiados por
/// espacios) en vez de desaparecer — mejor una etiqueta imperfecta que un
/// valor perdido en un reporte de auditoría.
const etiquetasModulo = {
  'M1': 'Agregación de zonas de demanda',
  'M2': 'Generación de candidatos por centro de gravedad',
  'M3': 'Matriz de distancias',
  'M4': 'Modelo de costo',
  'M5': 'Asignación de zonas a almacenes',
  'M6': 'Heurística de ubicación',
  'M7': 'Efecto de agrupación de riesgos',
  'M8': 'Barrido sobre el número de almacenes',
  'M9': 'Comparador de escenarios',
};

/// Módulo tal como se muestra en un reporte: nombre completo primero, con
/// el código entre paréntesis para quien sí conozca el capítulo del libro
/// de texto — nunca el código solo.
String moduloLegible(String modulo) {
  final etiqueta = etiquetasModulo[modulo];
  return etiqueta == null ? modulo : '$etiqueta ($modulo)';
}

const _etiquetasEntrada = {
  'zonas_asignadas': 'Zonas asignadas',
  'almacenes_abiertos': 'Almacenes abiertos',
  'zonas': 'Zonas de demanda',
  'candidatos_abiertos': 'Candidatos abiertos',
  'candidatos_disponibles': 'Candidatos disponibles',
  'candidatos': 'Candidatos evaluados',
  'p_max': 'Cantidad máxima de almacenes (p)',
  'p_fijo': 'Cantidad fija de almacenes (p)',
  'n_abiertos': 'Almacenes abiertos',
  'n_candidatos': 'Candidatos evaluados',
  'inventario_base': 'Inventario base de una ubicación',
  'valor_por_unidad_cent': 'Valor por unidad',
  'tasa_manejo_inventario_anual': 'Tasa anual de manejo de inventario',
  'abiertos_iniciales': 'Almacenes abiertos al empezar',
  'iteraciones': 'Iteraciones realizadas',
  'iteraciones_totales': 'Iteraciones realizadas',
  'semilla': 'Semilla aleatoria',
  'metodo_por_punto': 'Método usado en cada punto',
  // Las claves de `porRubro` (M4, fila de costo total): mismos siete
  // rubros de CLAUDE.md sección 7, sin sufijo "_cent" pero igual en
  // céntimos — ver `_esClaveMonetaria`.
  'produccion': 'Producción',
  'entrada': 'Transporte de entrada',
  'salida': 'Transporte de salida',
  'fijo': 'Costo fijo',
  'manejo': 'Manejo',
  'inventario': 'Inventario',
  'pedidos': 'Pedidos',
};

const _clavesRubroMonetarias = {
  'produccion',
  'entrada',
  'salida',
  'fijo',
  'manejo',
  'inventario',
  'pedidos',
};

bool _esClaveMonetaria(String clave) =>
    clave.endsWith('_cent') || _clavesRubroMonetarias.contains(clave);

const _valoresMetodoPorPunto = {
  'exhaustiva': 'Enumeración exhaustiva',
  'add_intercambio': 'ADD + intercambio',
};

/// Vuelve el JSON crudo de `entradasJson` (ej. `{"zonas_asignadas":4}`) en
/// una lista corta de "Etiqueta: valor" separada por " · ", con montos en
/// céntimos ya convertidos y tasas ya expresadas en porcentaje.
String entradasLegibles(String entradasJson) {
  final Map<String, dynamic> datos;
  try {
    datos = jsonDecode(entradasJson) as Map<String, dynamic>;
  } catch (_) {
    return entradasJson;
  }
  if (datos.isEmpty) return '—';

  return datos.entries.map((entrada) => _parLegible(entrada.key, entrada.value)).join(' · ');
}

String _parLegible(String clave, dynamic valor) {
  final etiqueta = _etiquetasEntrada[clave] ?? clave.replaceAll('_', ' ');

  if (valor == null) {
    return '$etiqueta: libre (sin fijar)';
  }
  if (_esClaveMonetaria(clave) && valor is num) {
    return '$etiqueta: ${centimosATexto(valor.round())}';
  }
  if (clave == 'tasa_manejo_inventario_anual' && valor is num) {
    return '$etiqueta: ${(valor * 100).toStringAsFixed(0)}%';
  }
  if (clave == 'metodo_por_punto' && valor is String) {
    return '$etiqueta: ${_valoresMetodoPorPunto[valor] ?? valor}';
  }
  return '$etiqueta: $valor';
}

/// Vuelve legible `salida` cuando está en céntimos: el valor de costo
/// siempre es el último número entero del texto (ver los call sites en
/// `lib/domain/motor/`: o es un entero puro, o una frase que termina en
/// "costo" seguido del monto en céntimos) — nunca se tocan otros números
/// de la misma frase (ej. "p=2" en el resultado de un barrido).
String salidaLegible(String salida, String unidad) {
  if (unidad != 'centavos') return salida;

  final coincidencias = RegExp(r'-?\d+').allMatches(salida).toList();
  if (coincidencias.isEmpty) return salida;

  final ultima = coincidencias.last;
  final centimos = int.tryParse(ultima.group(0)!);
  if (centimos == null) return salida;

  return salida.replaceRange(ultima.start, ultima.end, centimosATexto(centimos));
}

/// La unidad ya queda implícita en `salidaLegible` (un monto formateado
/// con dos decimales) o no aporta nada ("zonas" ya lo dice el propio
/// texto de salida) — se resume a un rótulo corto en vez del valor crudo
/// de la base de datos.
String unidadLegible(String unidad) {
  switch (unidad) {
    case 'centavos':
      return 'Monto';
    case 'zonas':
      return 'Zonas';
    default:
      return unidad;
  }
}
