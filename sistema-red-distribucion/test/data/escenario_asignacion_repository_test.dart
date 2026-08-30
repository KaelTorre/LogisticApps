import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_red_distribucion/data/local/database.dart';
import 'package:sistema_red_distribucion/data/models/escenario.dart';
import 'package:sistema_red_distribucion/data/models/escenario_asignacion.dart';
import 'package:sistema_red_distribucion/data/models/proyecto.dart';
import 'package:sistema_red_distribucion/data/models/sitio_candidato.dart';
import 'package:sistema_red_distribucion/data/models/zona_demanda.dart';
import 'package:sistema_red_distribucion/data/repositories/escenario_asignacion_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/escenario_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/proyecto_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/sitio_candidato_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/zona_demanda_repository.dart';

void main() {
  late AppDatabase database;
  late EscenarioAsignacionRepository repositorio;
  late int escenarioId;
  late int candidatoId;
  late int zonaId;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    repositorio = EscenarioAsignacionRepository(database);
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
    zonaId = await ZonaDemandaRepository(database).crear(
      ZonaDemanda(
        proyectoId: proyectoId,
        etiqueta: 'Z1',
        latitud: 0,
        longitud: 0,
        demandaAgregada: 10,
        pedidosAgregados: 1,
        numeroClientes: 1,
        errorAgregacionMetros: 0,
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

  test('insertarTodas + obtenerPorEscenario (alta y lectura en bloque)', () async {
    await repositorio.insertarTodas([
      EscenarioAsignacion(
        escenarioId: escenarioId,
        zonaId: zonaId,
        sitioCandidatoId: candidatoId,
        distanciaMetros: 5230,
        duracionSegundos: 612,
        costoSalidaCent: 4500,
      ),
    ]);

    final asignaciones = await repositorio.obtenerPorEscenario(escenarioId);

    expect(asignaciones, hasLength(1));
    expect(asignaciones.first.distanciaMetros, 5230);
  });
}
