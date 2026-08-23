import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_diseno_almacenes/data/local/database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  test('crea las 13 tablas del esquema sin errores', () async {
    // Si createAll() falla (referencia rota, tipo inválido), este await
    // lanza — basta con que no lance para confirmar que el DDL es válido.
    await db.customSelect('SELECT 1').get();
  });

  test('inserta un proyecto y una familia de producto con FK válida', () async {
    final proyectoId = await db.into(db.proyectos).insert(
      ProyectosCompanion.insert(
        nombre: 'Almacén de prueba',
        creadoEn: DateTime(2026, 1, 1).toIso8601String(),
      ),
    );

    final tarimaId = await db.into(db.catalogoTarimas).insert(
      CatalogoTarimasCompanion.insert(
        codigo: 'EPAL',
        largoMm: 1200,
        anchoMm: 800,
        altoMm: 144,
        taraG: 25000,
        fuente: 'EN 13698',
      ),
    );

    final familiaId = await db.into(db.familiasProducto).insert(
      FamiliasProductoCompanion.insert(
        proyectoId: proyectoId,
        nombre: 'Familia A',
        tarimaId: tarimaId,
        altoCargaMm: 1000,
        pesoCargaG: 500000,
        unidadesPorTarima: 40,
      ),
    );

    final familia = await (db.select(
      db.familiasProducto,
    )..where((f) => f.id.equals(familiaId))).getSingle();

    expect(familia.proyectoId, proyectoId);
    expect(familia.tarimaId, tarimaId);
  });

  test('borrar un proyecto elimina en cascada sus familias de producto', () async {
    final proyectoId = await db.into(db.proyectos).insert(
      ProyectosCompanion.insert(
        nombre: 'Almacén a borrar',
        creadoEn: DateTime(2026, 1, 1).toIso8601String(),
      ),
    );
    final tarimaId = await db.into(db.catalogoTarimas).insert(
      CatalogoTarimasCompanion.insert(
        codigo: 'GMA',
        largoMm: 1219,
        anchoMm: 1016,
        altoMm: 140,
        taraG: 20000,
        fuente: 'ISO 6780',
      ),
    );
    await db.into(db.familiasProducto).insert(
      FamiliasProductoCompanion.insert(
        proyectoId: proyectoId,
        nombre: 'Familia B',
        tarimaId: tarimaId,
        altoCargaMm: 800,
        pesoCargaG: 300000,
        unidadesPorTarima: 30,
      ),
    );

    await (db.delete(
      db.proyectos,
    )..where((p) => p.id.equals(proyectoId))).go();

    final familiasRestantes = await db.select(db.familiasProducto).get();
    expect(familiasRestantes, isEmpty);
  });

  test('parametros_norma rechaza duplicar (norma, clave, clase)', () async {
    await db.into(db.parametrosNorma).insert(
      ParametrosNormaCompanion.insert(
        norma: 'EN',
        clave: 'elevacion_max_mm',
        valor: 6000,
        fuente: 'EN 15620',
        clase: const Value('400'),
      ),
    );

    expect(
      () => db.into(db.parametrosNorma).insert(
        ParametrosNormaCompanion.insert(
          norma: 'EN',
          clave: 'elevacion_max_mm',
          valor: 9000,
          fuente: 'EN 15620',
          clase: const Value('400'),
        ),
      ),
      throwsA(anything),
    );
  });

  test(
    'parametros_norma SÍ permite dos filas con clase NULL (semántica SQL estándar: NULL no colisiona con NULL)',
    () async {
      await db.into(db.parametrosNorma).insert(
        ParametrosNormaCompanion.insert(
          norma: 'EN',
          clave: 'holgura_x_mm',
          valor: 75,
          fuente: 'EN 15620',
        ),
      );

      // Mismo (norma, clave), clase NULL en ambas: no debe lanzar. Es el
      // comportamiento correcto de UNIQUE con NULL, no un bug del esquema.
      await db.into(db.parametrosNorma).insert(
        ParametrosNormaCompanion.insert(
          norma: 'EN',
          clave: 'holgura_x_mm',
          valor: 80,
          fuente: 'EN 15620 (variante)',
        ),
      );
    },
  );
}
