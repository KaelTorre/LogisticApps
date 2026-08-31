import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_red_distribucion/data/local/database.dart';
import 'package:sistema_red_distribucion/data/models/planta.dart';
import 'package:sistema_red_distribucion/data/models/proyecto.dart';
import 'package:sistema_red_distribucion/data/repositories/planta_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/proyecto_repository.dart';

Planta _plantaDeEjemplo(int proyectoId) => Planta(
  proyectoId: proyectoId,
  nombre: 'Planta 1',
  latitud: -8.37,
  longitud: -74.55,
  capacidadAnual: 5000,
  costoProduccionCentPorUnidad: 800,
);

void main() {
  late AppDatabase database;
  late PlantaRepository repositorio;
  late int proyectoId;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    repositorio = PlantaRepository(database);
    proyectoId = await ProyectoRepository(database).crear(
      Proyecto(nombre: 'P', creadoEn: DateTime(2026, 1, 1).toIso8601String()),
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('crear + obtenerPorProyecto (alta y lectura)', () async {
    await repositorio.crear(_plantaDeEjemplo(proyectoId));

    final plantas = await repositorio.obtenerPorProyecto(proyectoId);

    expect(plantas, hasLength(1));
    expect(plantas.first.nombre, 'Planta 1');
  });

  test('actualizar (modificación) persiste los cambios', () async {
    final id = await repositorio.crear(_plantaDeEjemplo(proyectoId));
    final original = (await repositorio.obtenerPorProyecto(proyectoId)).first;
    expect(original.id, id);

    await repositorio.actualizar(original.copyWith(capacidadAnual: 9999));

    final actualizada = (await repositorio.obtenerPorProyecto(proyectoId)).first;
    expect(actualizada.capacidadAnual, 9999);
  });

  test('eliminar borra la planta', () async {
    final id = await repositorio.crear(_plantaDeEjemplo(proyectoId));

    await repositorio.eliminar(id);

    expect(await repositorio.obtenerPorProyecto(proyectoId), isEmpty);
  });
}
