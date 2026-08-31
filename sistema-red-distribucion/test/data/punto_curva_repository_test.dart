import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_red_distribucion/data/local/database.dart';
import 'package:sistema_red_distribucion/data/models/escenario.dart';
import 'package:sistema_red_distribucion/data/models/proyecto.dart';
import 'package:sistema_red_distribucion/data/models/punto_curva.dart';
import 'package:sistema_red_distribucion/data/repositories/escenario_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/proyecto_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/punto_curva_repository.dart';

void main() {
  late AppDatabase database;
  late PuntoCurvaRepository repositorio;
  late int escenarioId;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    repositorio = PuntoCurvaRepository(database);
    final proyectoId = await ProyectoRepository(database).crear(
      Proyecto(nombre: 'P', creadoEn: DateTime(2026, 1, 1).toIso8601String()),
    );
    escenarioId = await EscenarioRepository(database).crear(
      Escenario(
        proyectoId: proyectoId,
        nombre: 'Barrido',
        metodo: 'add',
        costoTotalCent: 0,
        fecha: DateTime(2026, 1, 1).toIso8601String(),
      ),
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('insertarTodos + obtenerPorEscenario, un punto por número de almacenes', () async {
    await repositorio.insertarTodos([
      PuntoCurva(
        escenarioId: escenarioId,
        numeroAlmacenes: 1,
        costoTotalCent: 900000,
        costoPorRubroJson: jsonEncode({'fijo': 900000}),
        viableSegunServicio: false,
      ),
      PuntoCurva(
        escenarioId: escenarioId,
        numeroAlmacenes: 2,
        costoTotalCent: 700000,
        costoPorRubroJson: jsonEncode({'fijo': 700000}),
        viableSegunServicio: true,
      ),
    ]);

    final puntos = await repositorio.obtenerPorEscenario(escenarioId);

    expect(puntos, hasLength(2));
    expect(
      puntos.firstWhere((p) => p.numeroAlmacenes == 2).viableSegunServicio,
      isTrue,
    );
  });
}
