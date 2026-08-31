import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_red_distribucion/data/local/database.dart';
import 'package:sistema_red_distribucion/data/models/proyecto.dart';
import 'package:sistema_red_distribucion/data/models/sitio_candidato.dart';
import 'package:sistema_red_distribucion/data/repositories/proyecto_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/sitio_candidato_repository.dart';

SitioCandidato _candidatoDeEjemplo(int proyectoId) => SitioCandidato(
  proyectoId: proyectoId,
  nombre: 'Candidato 1',
  latitud: -8.37,
  longitud: -74.55,
  costoFijoAnualCent: 12345600,
  capacidadAnual: 1000,
  costoVariableManejoCentPorUnidad: 500,
  origen: 'manual',
);

void main() {
  late AppDatabase database;
  late SitioCandidatoRepository repositorio;
  late int proyectoId;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    repositorio = SitioCandidatoRepository(database);
    proyectoId = await ProyectoRepository(database).crear(
      Proyecto(nombre: 'P', creadoEn: DateTime(2026, 1, 1).toIso8601String()),
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('crear + obtenerPorProyecto (alta y lectura)', () async {
    await repositorio.crear(_candidatoDeEjemplo(proyectoId));

    final candidatos = await repositorio.obtenerPorProyecto(proyectoId);

    expect(candidatos, hasLength(1));
    expect(candidatos.first.nombre, 'Candidato 1');
    expect(candidatos.first.origen, 'manual');
    expect(candidatos.first.esRedActual, isFalse);
  });

  test('actualizar (modificación) persiste los cambios', () async {
    final id = await repositorio.crear(_candidatoDeEjemplo(proyectoId));
    final original = (await repositorio.obtenerPorProyecto(proyectoId)).first;
    expect(original.id, id);

    await repositorio.actualizar(
      original.copyWith(esRedActual: true, origen: 'centro_gravedad'),
    );

    final actualizado = (await repositorio.obtenerPorProyecto(proyectoId)).first;
    expect(actualizado.esRedActual, isTrue);
    expect(actualizado.origen, 'centro_gravedad');
  });

  test('eliminar borra el candidato', () async {
    final id = await repositorio.crear(_candidatoDeEjemplo(proyectoId));

    await repositorio.eliminar(id);

    expect(await repositorio.obtenerPorProyecto(proyectoId), isEmpty);
  });
}
