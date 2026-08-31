import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_red_distribucion/data/local/database.dart';
import 'package:sistema_red_distribucion/data/models/escenario.dart';
import 'package:sistema_red_distribucion/data/models/memoria_calculo.dart';
import 'package:sistema_red_distribucion/data/models/proyecto.dart';
import 'package:sistema_red_distribucion/data/repositories/escenario_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/memoria_calculo_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/proyecto_repository.dart';

void main() {
  late AppDatabase database;
  late MemoriaCalculoRepository repositorio;
  late int escenarioId;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    repositorio = MemoriaCalculoRepository(database);
    final proyectoId = await ProyectoRepository(database).crear(
      Proyecto(nombre: 'P', creadoEn: DateTime(2026, 1, 1).toIso8601String()),
    );
    escenarioId = await EscenarioRepository(database).crear(
      Escenario(
        proyectoId: proyectoId,
        nombre: 'E1',
        metodo: 'add',
        costoTotalCent: 0,
        fecha: DateTime(2026, 1, 1).toIso8601String(),
      ),
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('crear (alta) + obtenerPorEscenario ordena por orden (paso)', () async {
    await repositorio.crear(
      MemoriaCalculo(
        escenarioId: escenarioId,
        orden: 2,
        modulo: 'M4',
        formula: 'costo = fijo + variable',
        entradasJson: '{"fijo": 100}',
        salida: '100',
        unidad: 'centavos',
      ),
    );
    await repositorio.crear(
      MemoriaCalculo(
        escenarioId: escenarioId,
        orden: 1,
        modulo: 'M1',
        formula: 'zonas = kmeans(clientes, k)',
        entradasJson: '{"k": 3}',
        salida: '3',
        unidad: 'zonas',
      ),
    );

    final memoria = await repositorio.obtenerPorEscenario(escenarioId);

    expect(memoria, hasLength(2));
    expect(memoria.first.orden, 1);
    expect(memoria.first.modulo, 'M1');
    expect(memoria.last.orden, 2);
  });

  test('insertarTodas inserta en bloque', () async {
    await repositorio.insertarTodas([
      MemoriaCalculo(
        escenarioId: escenarioId,
        orden: 1,
        modulo: 'M1',
        formula: 'f',
        entradasJson: '{}',
        salida: '1',
        unidad: 'u',
      ),
      MemoriaCalculo(
        escenarioId: escenarioId,
        orden: 2,
        modulo: 'M2',
        formula: 'g',
        entradasJson: '{}',
        salida: '2',
        unidad: 'u',
      ),
    ]);

    expect(await repositorio.obtenerPorEscenario(escenarioId), hasLength(2));
  });
}
