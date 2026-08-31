import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_red_distribucion/data/local/database.dart';
import 'package:sistema_red_distribucion/data/models/escenario.dart';
import 'package:sistema_red_distribucion/data/models/proyecto.dart';
import 'package:sistema_red_distribucion/data/repositories/escenario_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/proyecto_repository.dart';

Escenario _escenarioDeEjemplo(int proyectoId) => Escenario(
  proyectoId: proyectoId,
  nombre: 'Escenario base',
  metodo: 'add',
  costoTotalCent: 500000,
  fecha: DateTime(2026, 1, 1).toIso8601String(),
);

void main() {
  late AppDatabase database;
  late EscenarioRepository repositorio;
  late int proyectoId;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    repositorio = EscenarioRepository(database);
    proyectoId = await ProyectoRepository(database).crear(
      Proyecto(nombre: 'P', creadoEn: DateTime(2026, 1, 1).toIso8601String()),
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('crear + obtenerPorId + obtenerPorProyecto (alta y lectura)', () async {
    final id = await repositorio.crear(_escenarioDeEjemplo(proyectoId));

    final porId = await repositorio.obtenerPorId(id);
    final porProyecto = await repositorio.obtenerPorProyecto(proyectoId);

    expect(porId, isNotNull);
    expect(porId!.nombre, 'Escenario base');
    expect(porId.pFijo, isNull);
    expect(porProyecto, hasLength(1));
  });

  test('eliminar borra el escenario', () async {
    final id = await repositorio.crear(_escenarioDeEjemplo(proyectoId));

    await repositorio.eliminar(id);

    expect(await repositorio.obtenerPorId(id), isNull);
  });
}
