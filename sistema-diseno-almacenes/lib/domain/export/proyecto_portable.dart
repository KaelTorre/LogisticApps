import 'dart:convert';

import '../../data/local/database.dart';

/// Proyecto portable (CLAUDE.md sección 9): el caso de cálculo completo,
/// **incluyendo las filas de catálogo que usó** (`tarima`, `bastidor`,
/// `viga`, `equipo`, `camion`), como valores concretos — no como IDs — para
/// que abra en otra máquina sin depender de que su semilla tenga
/// exactamente el mismo catálogo. Las holguras y demás parámetros de norma
/// no se incluyen: son datos de semilla (`parametros_norma`) que
/// `CatalogoSeedLoader` garantiza en cualquier instalación, no una elección
/// variable del caso.
///
/// `id` viaja dentro de cada fila de catálogo serializada, pero es un
/// detalle de la base de datos de origen — quien importa lo ignora y
/// resuelve por `codigo` (ver `ComparadorEscenariosScreen`/
/// `EntradaCalculoScreen` para la lógica de import, que si no encuentra el
/// código en el catálogo local inserta una fila nueva con
/// `es_semilla = false`).
class ProyectoPortable {
  const ProyectoPortable({
    required this.version,
    required this.nombre,
    required this.demandaAnual,
    required this.rotacionAnual,
    required this.unidadesPorTarima,
    required this.factorHoneycomb,
    required this.altoCargaMm,
    required this.alturaLibreMm,
    required this.reservaTechoMm,
    required this.largoDisponibleMm,
    required this.camionesHoraPico,
    required this.tiempoServicioMinutos,
    required this.esperaObjetivoMinutos,
    required this.espaciamientoPuertaMm,
    required this.areaStagingM2,
    required this.tarima,
    required this.bastidor,
    required this.viga,
    required this.equipo,
    required this.camion,
  });

  /// Se sube cada vez que cambia la forma del JSON exportado. `fromJsonString`
  /// rechaza explícitamente un archivo de una versión más nueva que la que
  /// esta app entiende, en vez de intentar leerlo a medias.
  static const versionActual = 1;

  final int version;
  final String nombre;
  final double demandaAnual;
  final double rotacionAnual;
  final int unidadesPorTarima;
  final double factorHoneycomb;
  final int altoCargaMm;
  final int alturaLibreMm;
  final int reservaTechoMm;
  final int largoDisponibleMm;
  final double camionesHoraPico;
  final double tiempoServicioMinutos;
  final double esperaObjetivoMinutos;
  final int espaciamientoPuertaMm;
  final double areaStagingM2;
  final CatalogoTarima tarima;
  final CatalogoBastidore bastidor;
  final CatalogoViga viga;
  final CatalogoEquipo equipo;
  final CatalogoCamione camion;

  String toJsonString() => const JsonEncoder.withIndent('  ').convert(_toMap());

  Map<String, dynamic> _toMap() => {
    'version': version,
    'nombre': nombre,
    'demandaAnual': demandaAnual,
    'rotacionAnual': rotacionAnual,
    'unidadesPorTarima': unidadesPorTarima,
    'factorHoneycomb': factorHoneycomb,
    'altoCargaMm': altoCargaMm,
    'alturaLibreMm': alturaLibreMm,
    'reservaTechoMm': reservaTechoMm,
    'largoDisponibleMm': largoDisponibleMm,
    'camionesHoraPico': camionesHoraPico,
    'tiempoServicioMinutos': tiempoServicioMinutos,
    'esperaObjetivoMinutos': esperaObjetivoMinutos,
    'espaciamientoPuertaMm': espaciamientoPuertaMm,
    'areaStagingM2': areaStagingM2,
    'tarima': tarima.toJson(),
    'bastidor': bastidor.toJson(),
    'viga': viga.toJson(),
    'equipo': equipo.toJson(),
    'camion': camion.toJson(),
  };

  factory ProyectoPortable.fromJsonString(String contenido) {
    final Map<String, dynamic> map;
    try {
      map = jsonDecode(contenido) as Map<String, dynamic>;
    } on FormatException {
      throw const FormatException('El archivo no es JSON válido.');
    }

    final version = map['version'] as int?;
    if (version == null) {
      throw const FormatException('El archivo no tiene campo "version": no es un proyecto portable.');
    }
    if (version > versionActual) {
      throw FormatException(
        'Este proyecto se exportó con una versión más nueva ($version) que la '
        'que esta app entiende ($versionActual). Actualiza la app.',
      );
    }

    try {
      return ProyectoPortable(
        version: version,
        nombre: map['nombre'] as String,
        demandaAnual: (map['demandaAnual'] as num).toDouble(),
        rotacionAnual: (map['rotacionAnual'] as num).toDouble(),
        unidadesPorTarima: map['unidadesPorTarima'] as int,
        factorHoneycomb: (map['factorHoneycomb'] as num).toDouble(),
        altoCargaMm: map['altoCargaMm'] as int,
        alturaLibreMm: map['alturaLibreMm'] as int,
        reservaTechoMm: map['reservaTechoMm'] as int,
        largoDisponibleMm: map['largoDisponibleMm'] as int,
        camionesHoraPico: (map['camionesHoraPico'] as num).toDouble(),
        tiempoServicioMinutos: (map['tiempoServicioMinutos'] as num).toDouble(),
        esperaObjetivoMinutos: (map['esperaObjetivoMinutos'] as num).toDouble(),
        espaciamientoPuertaMm: map['espaciamientoPuertaMm'] as int,
        areaStagingM2: (map['areaStagingM2'] as num).toDouble(),
        tarima: CatalogoTarima.fromJson(map['tarima'] as Map<String, dynamic>),
        bastidor: CatalogoBastidore.fromJson(map['bastidor'] as Map<String, dynamic>),
        viga: CatalogoViga.fromJson(map['viga'] as Map<String, dynamic>),
        equipo: CatalogoEquipo.fromJson(map['equipo'] as Map<String, dynamic>),
        camion: CatalogoCamione.fromJson(map['camion'] as Map<String, dynamic>),
      );
    } on TypeError {
      throw const FormatException('El archivo tiene la forma de un proyecto portable pero le faltan o le sobran campos.');
    }
  }
}
