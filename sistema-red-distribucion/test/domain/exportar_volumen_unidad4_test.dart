import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_red_distribucion/domain/export/exportar_volumen_unidad4.dart';

/// Mini-espejo de `ProyectoPortable.fromJsonString` de
/// `sistema-diseno-almacenes` (releído campo por campo al escribir
/// `exportar_volumen_unidad4.dart`) — mismo criterio que ya se usó en la
/// Fase 8 para verificar en Dart que el payload del visor cumple el
/// contrato que el otro lado (acá, otro proyecto Flutter en vez de JS) va a
/// leer, sin poder importar esa clase directamente (paquetes separados).
/// Si algún campo requerido falta o cambia de tipo, esto lanza igual que lo
/// haría el importador real.
void _validarComoProyectoPortableUnidad4(Map<String, dynamic> m) {
  final version = m['version'] as int;
  if (version > 1) throw const FormatException('versión más nueva');
  m['nombre'] as String;
  (m['demandaAnual'] as num).toDouble();
  (m['rotacionAnual'] as num).toDouble();
  m['unidadesPorTarima'] as int;
  (m['factorHoneycomb'] as num).toDouble();
  m['altoCargaMm'] as int;
  m['alturaLibreMm'] as int;
  m['reservaTechoMm'] as int;
  m['largoDisponibleMm'] as int;
  (m['camionesHoraPico'] as num).toDouble();
  (m['tiempoServicioMinutos'] as num).toDouble();
  (m['esperaObjetivoMinutos'] as num).toDouble();
  m['espaciamientoPuertaMm'] as int;
  (m['areaStagingM2'] as num).toDouble();

  final tarima = m['tarima'] as Map<String, dynamic>;
  tarima['id'] as int;
  tarima['codigo'] as String;
  tarima['largoMm'] as int;
  tarima['anchoMm'] as int;
  tarima['altoMm'] as int;
  tarima['taraG'] as int;
  tarima['fuente'] as String;
  tarima['esSemilla'] as bool;

  final bastidor = m['bastidor'] as Map<String, dynamic>;
  bastidor['codigo'] as String;
  bastidor['fondoMm'] as int;
  bastidor['alturaMm'] as int;
  bastidor['perfilAnchoMm'] as int;
  bastidor['perfilFondoMm'] as int;

  final viga = m['viga'] as Map<String, dynamic>;
  viga['codigo'] as String;
  viga['largoMm'] as int;
  viga['peralteMm'] as int;

  final equipo = m['equipo'] as Map<String, dynamic>;
  equipo['codigo'] as String;
  equipo['tipo'] as String;
  equipo['pasilloMinMm'] as int;
  equipo['pasilloMaxMm'] as int;
  equipo['elevacionMaxMm'] as int;
  equipo['requiereGuiado'] as bool;

  final camion = m['camion'] as Map<String, dynamic>;
  camion['codigo'] as String;
  camion['largoMm'] as int;
  camion['anchoMm'] as int;
  camion['patioMinMm'] as int;
}

void main() {
  test('exportarVolumenPorCentro produce un archivo por almacén abierto', () {
    final archivos = exportarVolumenPorCentro(
      almacenesAbiertos: [
        (sitioCandidatoId: 1, nombre: 'Almacén Norte', volumenAnual: 1200.5),
        (sitioCandidatoId: 2, nombre: 'Almacén Sur', volumenAnual: 800.0),
      ],
    );
    expect(archivos, hasLength(2));
    expect(archivos[0].nombreAlmacen, 'Almacén Norte');
    expect(archivos[1].nombreAlmacen, 'Almacén Sur');
  });

  test('el JSON de cada almacén cumple el contrato de ProyectoPortable de Unidad 4', () {
    final archivos = exportarVolumenPorCentro(
      almacenesAbiertos: [(sitioCandidatoId: 1, nombre: 'Almacén Norte', volumenAnual: 1200.5)],
    );
    final mapa = jsonDecode(archivos.single.contenidoJson) as Map<String, dynamic>;
    expect(() => _validarComoProyectoPortableUnidad4(mapa), returnsNormally);
  });

  test('demandaAnual del JSON exportado es exactamente el volumen anual del almacén', () {
    final archivos = exportarVolumenPorCentro(
      almacenesAbiertos: [(sitioCandidatoId: 1, nombre: 'Almacén Norte', volumenAnual: 1234.5)],
    );
    final mapa = jsonDecode(archivos.single.contenidoJson) as Map<String, dynamic>;
    expect(mapa['demandaAnual'], 1234.5);
  });

  test('las filas de catálogo usan códigos reales del catálogo semilla de Unidad 4', () {
    final archivos = exportarVolumenPorCentro(
      almacenesAbiertos: [(sitioCandidatoId: 1, nombre: 'Almacén Norte', volumenAnual: 100)],
    );
    final mapa = jsonDecode(archivos.single.contenidoJson) as Map<String, dynamic>;
    expect((mapa['tarima'] as Map)['codigo'], 'EPAL');
    expect((mapa['bastidor'] as Map)['codigo'], 'BAST-914');
    expect((mapa['viga'] as Map)['codigo'], 'VIGA-1825');
    expect((mapa['equipo'] as Map)['codigo'], 'TRANSPALETA-MANUAL');
    expect((mapa['camion'] as Map)['codigo'], 'C2');
  });
}
