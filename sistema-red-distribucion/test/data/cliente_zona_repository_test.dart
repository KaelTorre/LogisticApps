import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_red_distribucion/data/local/database.dart';
import 'package:sistema_red_distribucion/data/models/cliente.dart';
import 'package:sistema_red_distribucion/data/models/cliente_zona.dart';
import 'package:sistema_red_distribucion/data/models/proyecto.dart';
import 'package:sistema_red_distribucion/data/models/zona_demanda.dart';
import 'package:sistema_red_distribucion/data/repositories/cliente_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/cliente_zona_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/proyecto_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/zona_demanda_repository.dart';

void main() {
  late AppDatabase database;
  late ClienteZonaRepository repositorio;
  late int proyectoId;
  late int clienteAId;
  late int clienteBId;
  late int zonaId;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    repositorio = ClienteZonaRepository(database);
    proyectoId = await ProyectoRepository(database).crear(
      Proyecto(nombre: 'P', creadoEn: DateTime(2026, 1, 1).toIso8601String()),
    );
    final clientes = ClienteRepository(database);
    clienteAId = await clientes.crear(
      Cliente(
        proyectoId: proyectoId,
        nombre: 'A',
        latitud: 0,
        longitud: 0,
        demandaAnual: 1,
        pedidosAnuales: 1,
      ),
    );
    clienteBId = await clientes.crear(
      Cliente(
        proyectoId: proyectoId,
        nombre: 'B',
        latitud: 0,
        longitud: 0,
        demandaAnual: 1,
        pedidosAnuales: 1,
      ),
    );
    zonaId = await ZonaDemandaRepository(database).crear(
      ZonaDemanda(
        proyectoId: proyectoId,
        etiqueta: 'Zona 1',
        latitud: 0,
        longitud: 0,
        demandaAgregada: 2,
        pedidosAgregados: 2,
        numeroClientes: 2,
        errorAgregacionMetros: 0,
      ),
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('insertarTodas + obtenerPorZona (alta y lectura en bloque)', () async {
    await repositorio.insertarTodas([
      ClienteZona(clienteId: clienteAId, zonaId: zonaId),
      ClienteZona(clienteId: clienteBId, zonaId: zonaId),
    ]);

    final asignaciones = await repositorio.obtenerPorZona(zonaId);

    expect(asignaciones, hasLength(2));
    expect(
      asignaciones.map((a) => a.clienteId),
      containsAll([clienteAId, clienteBId]),
    );
  });

  test('borrar el cliente elimina en cascada su asignación', () async {
    await repositorio.insertarTodas([
      ClienteZona(clienteId: clienteAId, zonaId: zonaId),
    ]);

    await ClienteRepository(database).eliminar(clienteAId);

    expect(await repositorio.obtenerPorZona(zonaId), isEmpty);
  });
}
