import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_red_distribucion/data/local/database.dart';
import 'package:sistema_red_distribucion/data/models/celda_matriz.dart';
import 'package:sistema_red_distribucion/data/models/proyecto.dart';
import 'package:sistema_red_distribucion/data/repositories/celda_matriz_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/proyecto_repository.dart';

void main() {
  late AppDatabase database;
  late CeldaMatrizRepository repositorio;
  late int proyectoId;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    repositorio = CeldaMatrizRepository(database);
    proyectoId = await ProyectoRepository(database).crear(
      Proyecto(nombre: 'P', creadoEn: DateTime(2026, 1, 1).toIso8601String()),
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('insertarTodas + obtenerPorProyecto (alta y lectura en bloque)', () async {
    await repositorio.insertarTodas([
      CeldaMatriz(
        proyectoId: proyectoId,
        tipoOrigen: 'candidato',
        origenId: 1,
        tipoDestino: 'zona',
        destinoId: 1,
        distanciaMetros: 5230,
        duracionSegundos: 612,
        fuente: 'osrm',
      ),
      CeldaMatriz(
        proyectoId: proyectoId,
        tipoOrigen: 'planta',
        origenId: 1,
        tipoDestino: 'zona',
        destinoId: 1,
        distanciaMetros: 10500,
        duracionSegundos: 900,
        fuente: 'haversine',
      ),
    ]);

    final celdas = await repositorio.obtenerPorProyecto(proyectoId);

    expect(celdas, hasLength(2));
    expect(celdas.map((c) => c.fuente), containsAll(['osrm', 'haversine']));
  });

  test('eliminarPorProyecto borra todas las celdas (baja, para repoblar)', () async {
    await repositorio.insertarTodas([
      CeldaMatriz(
        proyectoId: proyectoId,
        tipoOrigen: 'candidato',
        origenId: 1,
        tipoDestino: 'zona',
        destinoId: 1,
        distanciaMetros: 100,
        duracionSegundos: 10,
        fuente: 'osrm',
      ),
    ]);

    await repositorio.eliminarPorProyecto(proyectoId);

    expect(await repositorio.obtenerPorProyecto(proyectoId), isEmpty);
  });
}
