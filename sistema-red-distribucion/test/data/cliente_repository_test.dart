import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_red_distribucion/data/local/database.dart';
import 'package:sistema_red_distribucion/data/models/cliente.dart';
import 'package:sistema_red_distribucion/data/models/proyecto.dart';
import 'package:sistema_red_distribucion/data/repositories/cliente_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/proyecto_repository.dart';

void main() {
  late AppDatabase database;
  late ClienteRepository repositorio;
  late int proyectoId;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    repositorio = ClienteRepository(database);
    proyectoId = await ProyectoRepository(database).crear(
      Proyecto(nombre: 'P', creadoEn: DateTime(2026, 1, 1).toIso8601String()),
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('crear + obtenerPorProyecto (alta y lectura)', () async {
    await repositorio.crear(
      Cliente(
        proyectoId: proyectoId,
        nombre: 'Cliente A',
        latitud: -8.37,
        longitud: -74.55,
        demandaAnual: 120.5,
        pedidosAnuales: 52,
      ),
    );

    final clientes = await repositorio.obtenerPorProyecto(proyectoId);

    expect(clientes, hasLength(1));
    expect(clientes.first.nombre, 'Cliente A');
    expect(clientes.first.demandaAnual, 120.5);
    expect(clientes.first.activo, isTrue);
  });

  test('actualizar (modificación) persiste los cambios', () async {
    final id = await repositorio.crear(
      Cliente(
        proyectoId: proyectoId,
        nombre: 'Original',
        latitud: 0,
        longitud: 0,
        demandaAnual: 10,
        pedidosAnuales: 1,
      ),
    );
    final original = (await repositorio.obtenerPorProyecto(proyectoId)).first;
    expect(original.id, id);

    await repositorio.actualizar(
      original.copyWith(demandaAnual: 99, activo: false),
    );

    final actualizado = (await repositorio.obtenerPorProyecto(proyectoId)).first;
    expect(actualizado.demandaAnual, 99);
    expect(actualizado.activo, isFalse);
  });

  test('eliminar borra el cliente', () async {
    final id = await repositorio.crear(
      Cliente(
        proyectoId: proyectoId,
        nombre: 'Temporal',
        latitud: 0,
        longitud: 0,
        demandaAnual: 1,
        pedidosAnuales: 1,
      ),
    );

    await repositorio.eliminar(id);

    expect(await repositorio.obtenerPorProyecto(proyectoId), isEmpty);
  });
}
