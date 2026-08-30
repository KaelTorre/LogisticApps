import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_red_distribucion/data/local/database.dart';
import 'package:sistema_red_distribucion/data/models/parametros_costo.dart';
import 'package:sistema_red_distribucion/data/models/proyecto.dart';
import 'package:sistema_red_distribucion/data/repositories/parametros_costo_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/proyecto_repository.dart';

ParametrosCosto _parametrosDeEjemplo(int proyectoId, {int valorPorUnidadCent = 123456}) =>
    ParametrosCosto(
      proyectoId: proyectoId,
      tarifaEntradaFijaCent: 1000,
      tarifaEntradaCentPorKmTon: 50,
      tarifaSalidaFijaCent: 1200,
      tarifaSalidaCentPorKmTon: 60,
      tasaManejoInventarioAnual: 0.25,
      valorPorUnidadCent: valorPorUnidadCent,
      inventarioBaseUnaUbicacion: 100,
      costoPorPedidoCent: 350,
      tipoEstandar: 'distancia',
      estandarServicioValor: 50000,
    );

void main() {
  late AppDatabase database;
  late ParametrosCostoRepository repositorio;
  late int proyectoId;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    repositorio = ParametrosCostoRepository(database);
    proyectoId = await ProyectoRepository(database).crear(
      Proyecto(nombre: 'P', creadoEn: DateTime(2026, 1, 1).toIso8601String()),
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('guardar (alta) + obtenerPorProyecto (lectura)', () async {
    await repositorio.guardar(_parametrosDeEjemplo(proyectoId));

    final leidos = await repositorio.obtenerPorProyecto(proyectoId);

    expect(leidos, isNotNull);
    expect(leidos!.tipoEstandar, 'distancia');
    expect(leidos.estandarServicioValor, 50000);
  });

  test('guardar dos veces (modificación) reemplaza la única fila del proyecto, no crea otra', () async {
    await repositorio.guardar(_parametrosDeEjemplo(proyectoId));
    await repositorio.guardar(
      _parametrosDeEjemplo(proyectoId, valorPorUnidadCent: 999900),
    );

    final leidos = await repositorio.obtenerPorProyecto(proyectoId);
    expect(leidos!.valorPorUnidadCent, 999900);

    final filas = await database.select(database.parametrosCostoTable).get();
    expect(filas, hasLength(1));
  });

  test('eliminarPorProyecto borra la fila', () async {
    await repositorio.guardar(_parametrosDeEjemplo(proyectoId));

    await repositorio.eliminarPorProyecto(proyectoId);

    expect(await repositorio.obtenerPorProyecto(proyectoId), isNull);
  });

  test('invariante monetaria: guardar S/ 1234.56 y releer da exactamente 123456 céntimos', () async {
    const soles = 1234.56;
    final centimos = (soles * 100).round();
    expect(centimos, 123456);

    await repositorio.guardar(
      _parametrosDeEjemplo(proyectoId, valorPorUnidadCent: centimos),
    );

    final leidos = await repositorio.obtenerPorProyecto(proyectoId);

    expect(leidos!.valorPorUnidadCent, 123456);
    expect(leidos.valorPorUnidadCent, isA<int>());
  });
}
