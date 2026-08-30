import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_red_distribucion/data/local/database.dart';
import 'package:sistema_red_distribucion/data/models/proyecto.dart';
import 'package:sistema_red_distribucion/data/repositories/proyecto_repository.dart';

void main() {
  late AppDatabase database;
  late ProyectoRepository repositorio;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repositorio = ProyectoRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('crear + obtenerPorId (alta y lectura)', () async {
    final id = await repositorio.crear(
      Proyecto(
        nombre: 'Red norte',
        creadoEn: DateTime(2026, 1, 1).toIso8601String(),
      ),
    );

    final leido = await repositorio.obtenerPorId(id);

    expect(leido, isNotNull);
    expect(leido!.nombre, 'Red norte');
    expect(leido.moneda, 'PEN');
    expect(leido.unidadPeso, 'toneladas');
    expect(leido.horizonteAnios, 5);
    expect(leido.factorCircuidad, 1.30);
  });

  test('obtenerTodos devuelve todos los proyectos creados', () async {
    await repositorio.crear(
      Proyecto(nombre: 'A', creadoEn: DateTime(2026, 1, 1).toIso8601String()),
    );
    await repositorio.crear(
      Proyecto(nombre: 'B', creadoEn: DateTime(2026, 1, 2).toIso8601String()),
    );

    final todos = await repositorio.obtenerTodos();

    expect(todos, hasLength(2));
  });

  test('actualizar (modificación) persiste los cambios', () async {
    final id = await repositorio.crear(
      Proyecto(nombre: 'Original', creadoEn: DateTime(2026, 1, 1).toIso8601String()),
    );
    final original = (await repositorio.obtenerPorId(id))!;

    await repositorio.actualizar(
      original.copyWith(nombre: 'Renombrado', horizonteAnios: 10),
    );

    final actualizado = await repositorio.obtenerPorId(id);
    expect(actualizado!.nombre, 'Renombrado');
    expect(actualizado.horizonteAnios, 10);
  });

  test('eliminar borra el proyecto', () async {
    final id = await repositorio.crear(
      Proyecto(nombre: 'Temporal', creadoEn: DateTime(2026, 1, 1).toIso8601String()),
    );

    await repositorio.eliminar(id);

    expect(await repositorio.obtenerPorId(id), isNull);
  });
}
