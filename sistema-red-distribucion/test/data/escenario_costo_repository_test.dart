import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_red_distribucion/data/local/database.dart';
import 'package:sistema_red_distribucion/data/models/escenario.dart';
import 'package:sistema_red_distribucion/data/models/escenario_costo.dart';
import 'package:sistema_red_distribucion/data/models/proyecto.dart';
import 'package:sistema_red_distribucion/data/repositories/escenario_costo_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/escenario_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/proyecto_repository.dart';

void main() {
  late AppDatabase database;
  late EscenarioCostoRepository repositorio;
  late int escenarioId;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    repositorio = EscenarioCostoRepository(database);
    final proyectoId = await ProyectoRepository(database).crear(
      Proyecto(nombre: 'P', creadoEn: DateTime(2026, 1, 1).toIso8601String()),
    );
    escenarioId = await EscenarioRepository(database).crear(
      Escenario(
        proyectoId: proyectoId,
        nombre: 'E1',
        metodo: 'add',
        costoTotalCent: 1000000,
        fecha: DateTime(2026, 1, 1).toIso8601String(),
      ),
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('insertarTodos + obtenerPorEscenario, un rubro por fila (alta y lectura)', () async {
    await repositorio.insertarTodos([
      EscenarioCosto(escenarioId: escenarioId, rubro: 'produccion', montoCent: 100000),
      EscenarioCosto(escenarioId: escenarioId, rubro: 'entrada', montoCent: 50000),
      EscenarioCosto(escenarioId: escenarioId, rubro: 'salida', montoCent: 70000),
    ]);

    final costos = await repositorio.obtenerPorEscenario(escenarioId);

    expect(costos, hasLength(3));
    expect(costos.map((c) => c.rubro), containsAll(['produccion', 'entrada', 'salida']));
  });
}
