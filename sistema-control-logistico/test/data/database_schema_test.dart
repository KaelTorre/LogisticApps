import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_control_logistico/data/local/database.dart';

void main() {
  test('el esquema crea las quince tablas y cada una acepta una consulta vacía', () async {
    final database = AppDatabase(NativeDatabase.memory());

    expect(await database.select(database.organizacionTable).get(), isEmpty);
    expect(await database.select(database.periodoTable).get(), isEmpty);
    expect(await database.select(database.indicadorTable).get(), isEmpty);
    expect(await database.select(database.medicionTable).get(), isEmpty);
    expect(await database.select(database.reglaPatronTable).get(), isEmpty);
    expect(await database.select(database.evaluacionTable).get(), isEmpty);
    expect(await database.select(database.memoriaEvaluacionTable).get(), isEmpty);
    expect(await database.select(database.accionCatalogoTable).get(), isEmpty);
    expect(await database.select(database.reglaAccionTable).get(), isEmpty);
    expect(await database.select(database.accionTomadaTable).get(), isEmpty);
    expect(await database.select(database.verificacionAccionTable).get(), isEmpty);
    expect(await database.select(database.presupuestoTable).get(), isEmpty);
    expect(await database.select(database.escenarioSinteticoTable).get(), isEmpty);
    expect(await database.select(database.diagnosticoOrganizacionalTable).get(), isEmpty);
    expect(await database.select(database.facturaTransporteTable).get(), isEmpty);

    await database.close();
  });

  test('PRAGMA foreign_keys queda activado al abrir la conexión', () async {
    final database = AppDatabase(NativeDatabase.memory());

    final resultado = await database.customSelect('PRAGMA foreign_keys').getSingle();

    expect(resultado.data.values.first, 1);
    await database.close();
  });
}
