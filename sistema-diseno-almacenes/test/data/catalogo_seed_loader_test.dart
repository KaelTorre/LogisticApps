import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_diseno_almacenes/data/local/database.dart';
import 'package:sistema_diseno_almacenes/data/seed/catalogo_seed_loader.dart';

void main() {
  // rootBundle.loadString necesita el binding de Flutter inicializado, aun
  // en un test que no monta ningún widget.
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  test('carga las 6 tarimas de ISO 6780 con fuente no vacía', () async {
    await CatalogoSeedLoader(db).cargar();

    final tarimas = await db.select(db.catalogoTarimas).get();
    expect(tarimas, hasLength(6));
    expect(tarimas.every((t) => t.fuente.isNotEmpty), isTrue);
    expect(tarimas.every((t) => t.esSemilla), isTrue);

    final epal = tarimas.firstWhere((t) => t.codigo == 'EPAL');
    expect(epal.largoMm, 1200);
    expect(epal.anchoMm, 800);
  });

  test('carga el camión T2S2 con el largo oficial del RNV (20500 mm)', () async {
    await CatalogoSeedLoader(db).cargar();

    final camiones = await db.select(db.catalogoCamiones).get();
    final t2s2 = camiones.firstWhere((c) => c.codigo == 'T2S2');
    expect(t2s2.largoMm, 20500);
    expect(t2s2.anchoMm, 2600);
  });

  test('ninguna viga trae capacidad_par_g calculada (regla: no es cálculo estructural)', () async {
    await CatalogoSeedLoader(db).cargar();

    final vigas = await db.select(db.catalogoVigas).get();
    expect(vigas, isNotEmpty);
    expect(vigas.every((v) => v.capacidadParG == null), isTrue);
  });

  test('parametros_norma respeta el mínimo EN 15620 de 75mm de holgura', () async {
    await CatalogoSeedLoader(db).cargar();

    final holguraX = await (db.select(
      db.parametrosNorma,
    )..where((p) => p.clave.equals('holgura_x_mm'))).getSingle();
    expect(holguraX.valor, 75);
    expect(holguraX.norma, 'EN');
  });

  test('cargar dos veces no duplica filas semilla (idempotente)', () async {
    await CatalogoSeedLoader(db).cargar();
    await CatalogoSeedLoader(db).cargar();

    final tarimas = await db.select(db.catalogoTarimas).get();
    expect(tarimas, hasLength(6));
  });

  test('cargar preserva una tarima agregada por el usuario (es_semilla = false)', () async {
    await CatalogoSeedLoader(db).cargar();

    await db.into(db.catalogoTarimas).insert(
      CatalogoTarimasCompanion.insert(
        codigo: 'PROVEEDOR-LOCAL-1',
        largoMm: 1200,
        anchoMm: 1000,
        altoMm: 150,
        taraG: 24000,
        fuente: 'Proveedor local de Pucallpa',
        esSemilla: const Value(false),
      ),
    );

    await CatalogoSeedLoader(db).cargar();

    final tarimas = await db.select(db.catalogoTarimas).get();
    expect(tarimas, hasLength(7));
    expect(tarimas.any((t) => t.codigo == 'PROVEEDOR-LOCAL-1'), isTrue);
  });
}
