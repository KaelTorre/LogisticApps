import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_red_distribucion/data/local/database.dart';

void main() {
  test('el esquema crea las quince tablas y cada una acepta una consulta vacía', () async {
    final database = AppDatabase(NativeDatabase.memory());

    expect(await database.select(database.proyectoTable).get(), isEmpty);
    expect(await database.select(database.clienteTable).get(), isEmpty);
    expect(await database.select(database.zonaDemandaTable).get(), isEmpty);
    expect(await database.select(database.clienteZonaTable).get(), isEmpty);
    expect(await database.select(database.sitioCandidatoTable).get(), isEmpty);
    expect(await database.select(database.plantaTable).get(), isEmpty);
    expect(
      await database.select(database.parametrosCostoTable).get(),
      isEmpty,
    );
    expect(await database.select(database.celdaMatrizTable).get(), isEmpty);
    expect(await database.select(database.cacheRuteoTable).get(), isEmpty);
    expect(await database.select(database.escenarioTable).get(), isEmpty);
    expect(
      await database.select(database.escenarioAlmacenTable).get(),
      isEmpty,
    );
    expect(
      await database.select(database.escenarioAsignacionTable).get(),
      isEmpty,
    );
    expect(
      await database.select(database.escenarioCostoTable).get(),
      isEmpty,
    );
    expect(await database.select(database.puntoCurvaTable).get(), isEmpty);
    expect(
      await database.select(database.memoriaCalculoTable).get(),
      isEmpty,
    );

    await database.close();
  });

  test('PRAGMA foreign_keys queda activado al abrir la conexión', () async {
    final database = AppDatabase(NativeDatabase.memory());

    final resultado = await database
        .customSelect('PRAGMA foreign_keys')
        .getSingle();

    expect(resultado.data.values.first, 1);
    await database.close();
  });
}
