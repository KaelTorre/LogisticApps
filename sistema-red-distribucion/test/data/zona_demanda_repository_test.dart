import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_red_distribucion/data/local/database.dart';
import 'package:sistema_red_distribucion/data/models/proyecto.dart';
import 'package:sistema_red_distribucion/data/models/zona_demanda.dart';
import 'package:sistema_red_distribucion/data/repositories/proyecto_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/zona_demanda_repository.dart';

ZonaDemanda _zonaDeEjemplo(int proyectoId) => ZonaDemanda(
  proyectoId: proyectoId,
  etiqueta: 'Zona 1',
  latitud: -8.37,
  longitud: -74.55,
  demandaAgregada: 500,
  pedidosAgregados: 30,
  numeroClientes: 4,
  errorAgregacionMetros: 850,
);

void main() {
  late AppDatabase database;
  late ZonaDemandaRepository repositorio;
  late int proyectoId;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    repositorio = ZonaDemandaRepository(database);
    proyectoId = await ProyectoRepository(database).crear(
      Proyecto(nombre: 'P', creadoEn: DateTime(2026, 1, 1).toIso8601String()),
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('crear + obtenerPorProyecto (alta y lectura)', () async {
    await repositorio.crear(_zonaDeEjemplo(proyectoId));

    final zonas = await repositorio.obtenerPorProyecto(proyectoId);

    expect(zonas, hasLength(1));
    expect(zonas.first.etiqueta, 'Zona 1');
    expect(zonas.first.errorAgregacionMetros, 850);
  });

  test('actualizar (modificación) persiste los cambios', () async {
    final id = await repositorio.crear(_zonaDeEjemplo(proyectoId));
    final original = (await repositorio.obtenerPorProyecto(proyectoId)).first;
    expect(original.id, id);

    await repositorio.actualizar(original.copyWith(demandaAgregada: 700));

    final actualizada = (await repositorio.obtenerPorProyecto(proyectoId)).first;
    expect(actualizada.demandaAgregada, 700);
  });

  test('eliminar borra la zona', () async {
    final id = await repositorio.crear(_zonaDeEjemplo(proyectoId));

    await repositorio.eliminar(id);

    expect(await repositorio.obtenerPorProyecto(proyectoId), isEmpty);
  });

  test('eliminarPorProyecto borra todas las zonas del proyecto de una vez', () async {
    await repositorio.crear(_zonaDeEjemplo(proyectoId));
    await repositorio.crear(_zonaDeEjemplo(proyectoId));

    await repositorio.eliminarPorProyecto(proyectoId);

    expect(await repositorio.obtenerPorProyecto(proyectoId), isEmpty);
  });
}
