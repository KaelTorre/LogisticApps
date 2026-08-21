import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../local/database.dart';

/// Carga `assets/catalogo_semilla.json` a las tablas de catálogo.
///
/// Se corre en la primera ejecución y en cada migración de esquema
/// (CLAUDE.md sección 6). Solo reemplaza las filas `es_semilla = true`;
/// las que el usuario agregó a mano se conservan intactas. `parametros_norma`
/// no tiene bandera `es_semilla` porque es enteramente normativo — no se
/// espera que el usuario agregue filas ahí, así que se recarga completa.
class CatalogoSeedLoader {
  const CatalogoSeedLoader(this._db);

  final AppDatabase _db;

  Future<void> cargar() async {
    final crudo = await rootBundle.loadString('assets/catalogo_semilla.json');
    final json = jsonDecode(crudo) as Map<String, dynamic>;

    await _db.transaction(() async {
      await _cargarTarimas(json['tarimas'] as List);
      await _cargarBastidores(json['bastidores'] as List);
      await _cargarVigas(json['vigas'] as List);
      await _cargarEquipos(json['equipos'] as List);
      await _cargarCamiones(json['camiones'] as List);
      await _cargarParametrosNorma(json['parametros_norma'] as List);
    });
  }

  Future<void> _cargarTarimas(List filas) async {
    await (_db.delete(_db.catalogoTarimas)
      ..where((t) => t.esSemilla.equals(true))).go();
    for (final f in filas.cast<Map<String, dynamic>>()) {
      await _db.into(_db.catalogoTarimas).insert(
        CatalogoTarimasCompanion.insert(
          codigo: f['codigo'] as String,
          largoMm: f['largo_mm'] as int,
          anchoMm: f['ancho_mm'] as int,
          altoMm: f['alto_mm'] as int,
          taraG: f['tara_g'] as int,
          cargaDinG: Value(f['carga_din_g'] as int?),
          cargaEstG: Value(f['carga_est_g'] as int?),
          region: Value(f['region'] as String?),
          fuente: f['fuente'] as String,
        ),
      );
    }
  }

  Future<void> _cargarBastidores(List filas) async {
    await (_db.delete(_db.catalogoBastidores)
      ..where((b) => b.esSemilla.equals(true))).go();
    for (final f in filas.cast<Map<String, dynamic>>()) {
      await _db.into(_db.catalogoBastidores).insert(
        CatalogoBastidoresCompanion.insert(
          codigo: f['codigo'] as String,
          fondoMm: f['fondo_mm'] as int,
          alturaMm: f['altura_mm'] as int,
          perfilAnchoMm: f['perfil_ancho_mm'] as int,
          perfilFondoMm: f['perfil_fondo_mm'] as int,
          fuente: f['fuente'] as String,
        ),
      );
    }
  }

  Future<void> _cargarVigas(List filas) async {
    await (_db.delete(_db.catalogoVigas)
      ..where((v) => v.esSemilla.equals(true))).go();
    for (final f in filas.cast<Map<String, dynamic>>()) {
      await _db.into(_db.catalogoVigas).insert(
        CatalogoVigasCompanion.insert(
          codigo: f['codigo'] as String,
          largoMm: f['largo_mm'] as int,
          peralteMm: f['peralte_mm'] as int,
          capacidadParG: Value(f['capacidad_par_g'] as int?),
          fuente: f['fuente'] as String,
        ),
      );
    }
  }

  Future<void> _cargarEquipos(List filas) async {
    await (_db.delete(_db.catalogoEquipos)
      ..where((e) => e.esSemilla.equals(true))).go();
    for (final f in filas.cast<Map<String, dynamic>>()) {
      await _db.into(_db.catalogoEquipos).insert(
        CatalogoEquiposCompanion.insert(
          codigo: f['codigo'] as String,
          tipo: f['tipo'] as String,
          claseEn: Value(f['clase_en'] as String?),
          pasilloMinMm: f['pasillo_min_mm'] as int,
          pasilloMaxMm: f['pasillo_max_mm'] as int,
          elevacionMaxMm: f['elevacion_max_mm'] as int,
          alturaMastilMm: Value(f['altura_mastil_mm'] as int?),
          requiereGuiado: Value(f['requiere_guiado'] as bool),
          costoUnitarioCent: Value(f['costo_unitario_cent'] as int?),
          fuente: f['fuente'] as String,
        ),
      );
    }
  }

  Future<void> _cargarCamiones(List filas) async {
    await (_db.delete(_db.catalogoCamiones)
      ..where((c) => c.esSemilla.equals(true))).go();
    for (final f in filas.cast<Map<String, dynamic>>()) {
      await _db.into(_db.catalogoCamiones).insert(
        CatalogoCamionesCompanion.insert(
          codigo: f['codigo'] as String,
          largoMm: f['largo_mm'] as int,
          anchoMm: f['ancho_mm'] as int,
          patioMinMm: f['patio_min_mm'] as int,
          fuente: f['fuente'] as String,
        ),
      );
    }
  }

  Future<void> _cargarParametrosNorma(List filas) async {
    await _db.delete(_db.parametrosNorma).go();
    for (final f in filas.cast<Map<String, dynamic>>()) {
      await _db.into(_db.parametrosNorma).insert(
        ParametrosNormaCompanion.insert(
          norma: f['norma'] as String,
          clave: f['clave'] as String,
          valor: f['valor'] as int,
          clase: Value(f['clase'] as String?),
          fuente: f['fuente'] as String,
        ),
      );
    }
  }
}
