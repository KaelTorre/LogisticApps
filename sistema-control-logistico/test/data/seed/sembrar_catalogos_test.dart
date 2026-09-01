import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_control_logistico/data/local/database.dart';
import 'package:sistema_control_logistico/data/repositories/accion_catalogo_repository.dart';
import 'package:sistema_control_logistico/data/repositories/regla_accion_repository.dart';
import 'package:sistema_control_logistico/data/repositories/regla_patron_repository.dart';
import 'package:sistema_control_logistico/data/seed/sembrar_catalogos.dart';
import 'package:sistema_control_logistico/domain/motor/m3_emparejador_acciones.dart';

/// Fase 4 (CLAUDE.md): "Test I — acción hacia la Unidad 5" contra el
/// catálogo semilla real (no uno sintético de prueba, como en
/// `m3_emparejador_acciones_test.dart`), más las condiciones generales de
/// la biblioteca (sección 11: cubre las tres categorías y las tres
/// magnitudes, siembra idempotente).
void main() {
  test('el catálogo semilla real satisface el Test I: costo + replaneación mayor apunta a la Unidad 5', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final reglaPatronRepo = ReglaPatronRepository(database);
    final accionRepo = AccionCatalogoRepository(database);
    final reglaAccionRepo = ReglaAccionRepository(database);

    await sembrarReglasDeSistemaSiVacio(reglaPatronRepo);
    await sembrarBibliotecaAccionesSiVacio(accionRepo, reglaAccionRepo);

    final acciones = await accionRepo.obtenerTodas();
    final mapeos = (await reglaAccionRepo.obtenerTodas())
        .map(
          (m) => MapeoAccion(
            categoriaIndicador: m.categoriaIndicador,
            reglaDisparada: m.reglaDisparada,
            clasificacion: m.clasificacion,
            accionId: m.accionId,
            prioridad: m.prioridad,
          ),
        )
        .toList();

    final candidatas = emparejarAcciones(
      categoriaIndicador: 'costo',
      reglasDisparadas: {'R4'},
      clasificacion: 'replaneacion_mayor',
      catalogoMapeos: mapeos,
    );

    expect(candidatas, isNotEmpty);
    final accionesCandidatas = acciones.where((a) => candidatas.contains(a.id));
    expect(
      accionesCandidatas.any(
        (a) =>
            (a.aplicacionExternaSugerida ?? '').contains('Unidad 5') &&
            (a.aplicacionExternaSugerida ?? '').toLowerCase().contains('red de distribución'),
      ),
      isTrue,
      reason: 'Ninguna acción candidata de costo+replaneación mayor apunta a la Unidad 5',
    );

    await database.close();
  });

  test('la biblioteca cubre las tres categorías y las tres magnitudes de respuesta', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final accionRepo = AccionCatalogoRepository(database);
    await sembrarBibliotecaAccionesSiVacio(accionRepo, ReglaAccionRepository(database));

    final acciones = await accionRepo.obtenerTodas();
    for (final categoria in ['costo', 'servicio', 'productividad']) {
      for (final magnitud in ['ajuste_menor', 'replaneacion_mayor', 'contingencia']) {
        expect(
          acciones.any((a) => a.categoriaIndicador == categoria && a.magnitudTipica == magnitud),
          isTrue,
          reason: 'Falta al menos una acción de $categoria / $magnitud',
        );
      }
    }
  });

  test('ninguna acción semilla usa texto genérico como "mejorar la eficiencia"', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final accionRepo = AccionCatalogoRepository(database);
    await sembrarBibliotecaAccionesSiVacio(accionRepo, ReglaAccionRepository(database));

    final acciones = await accionRepo.obtenerTodas();
    for (final accion in acciones) {
      expect(accion.titulo.toLowerCase(), isNot(contains('mejorar la eficiencia')));
      expect(accion.descripcion.length, greaterThan(20));
    }
  });

  test('sembrar dos veces no duplica la biblioteca (idempotente)', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final accionRepo = AccionCatalogoRepository(database);
    final reglaAccionRepo = ReglaAccionRepository(database);

    await sembrarBibliotecaAccionesSiVacio(accionRepo, reglaAccionRepo);
    final primeraCuenta = (await accionRepo.obtenerTodas()).length;

    await sembrarBibliotecaAccionesSiVacio(accionRepo, reglaAccionRepo);
    final segundaCuenta = (await accionRepo.obtenerTodas()).length;

    expect(segundaCuenta, primeraCuenta);
  });

  test('sembrar las reglas de sistema crea exactamente R1 a R6, globales', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final repo = ReglaPatronRepository(database);

    await sembrarReglasDeSistemaSiVacio(repo);
    final reglas = await repo.obtenerTodas();

    expect(reglas.map((r) => r.codigo).toSet(), {'R1', 'R2', 'R3', 'R4', 'R5', 'R6'});
    expect(reglas.every((r) => r.indicadorId == null), isTrue);

    await database.close();
  });
}
