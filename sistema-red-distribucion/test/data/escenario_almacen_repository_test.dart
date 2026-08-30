import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_red_distribucion/data/local/database.dart';
import 'package:sistema_red_distribucion/data/models/escenario.dart';
import 'package:sistema_red_distribucion/data/models/escenario_almacen.dart';
import 'package:sistema_red_distribucion/data/models/proyecto.dart';
import 'package:sistema_red_distribucion/data/models/sitio_candidato.dart';
import 'package:sistema_red_distribucion/data/repositories/escenario_almacen_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/escenario_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/proyecto_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/sitio_candidato_repository.dart';

void main() {
  late AppDatabase database;
  late EscenarioAlmacenRepository repositorio;
  late int escenarioId;
  late int candidatoId;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    repositorio = EscenarioAlmacenRepository(database);
    final proyectoId = await ProyectoRepository(database).crear(
      Proyecto(nombre: 'P', creadoEn: DateTime(2026, 1, 1).toIso8601String()),
    );
    candidatoId = await SitioCandidatoRepository(database).crear(
      SitioCandidato(
        proyectoId: proyectoId,
        nombre: 'C1',
        latitud: 0,
        longitud: 0,
        costoFijoAnualCent: 1000,
        capacidadAnual: 100,
        costoVariableManejoCentPorUnidad: 10,
        origen: 'manual',
      ),
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

  test('insertarTodos + obtenerPorEscenario (alta y lectura en bloque)', () async {
    await repositorio.insertarTodos([
      EscenarioAlmacen(
        escenarioId: escenarioId,
        sitioCandidatoId: candidatoId,
        volumenAsignado: 80,
        costoFijoCent: 1000,
        costoManejoCent: 800,
      ),
    ]);

    final almacenes = await repositorio.obtenerPorEscenario(escenarioId);

    expect(almacenes, hasLength(1));
    expect(almacenes.first.volumenAsignado, 80);
  });
}
