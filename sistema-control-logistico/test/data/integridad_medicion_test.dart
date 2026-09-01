import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_control_logistico/data/local/database.dart';
import 'package:sistema_control_logistico/data/models/indicador.dart';
import 'package:sistema_control_logistico/data/models/medicion.dart';
import 'package:sistema_control_logistico/data/models/organizacion.dart';
import 'package:sistema_control_logistico/data/models/periodo.dart';
import 'package:sistema_control_logistico/data/repositories/indicador_repository.dart';
import 'package:sistema_control_logistico/data/repositories/medicion_repository.dart';
import 'package:sistema_control_logistico/data/repositories/organizacion_repository.dart';
import 'package:sistema_control_logistico/data/repositories/periodo_repository.dart';

/// Fase 2 (CLAUDE.md): "Test de integridad: no se puede registrar dos
/// mediciones del mismo indicador para el mismo periodo." La restricción
/// vive en `MedicionTable.uniqueKeys` ({indicadorId, periodoId}), fijada
/// desde la Fase 1 -- este test la ejercita explícitamente porque el
/// CLAUDE.md la exige como prueba propia de la Fase 2 (pantalla de
/// Captura).
void main() {
  test('crear una segunda medición para el mismo indicador y periodo falla', () async {
    final database = AppDatabase(NativeDatabase.memory());

    final organizacionId = await OrganizacionRepository(
      database,
    ).crear(const Organizacion(nombre: 'Org', tipoEmpresa: 'manufacturera'));
    final periodoId = await PeriodoRepository(database).crear(
      Periodo(
        organizacionId: organizacionId,
        orden: 1,
        etiqueta: 'Periodo 1',
        fechaInicio: '2026-01-01',
        fechaFin: '2026-01-31',
        granularidad: 'mensual',
      ),
    );
    final indicadorId = await IndicadorRepository(database).crear(
      Indicador(
        organizacionId: organizacionId,
        codigo: 'IND-1',
        nombre: 'Indicador 1',
        categoria: 'costo',
        unidad: 'S/',
        sentido: 'menor_mejor',
        meta: 100,
        bandaInferior: 90,
        bandaSuperior: 110,
        granularidad: 'mensual',
        proceso: 'Transporte',
      ),
    );

    final repo = MedicionRepository(database);
    await repo.crear(
      Medicion(indicadorId: indicadorId, periodoId: periodoId, valor: 100, origen: 'manual'),
    );

    await expectLater(
      repo.crear(Medicion(indicadorId: indicadorId, periodoId: periodoId, valor: 105, origen: 'manual')),
      throwsA(anything),
    );

    // La primera medición sigue siendo la única -- el intento fallido no
    // dejó una fila a medias.
    expect(await repo.obtenerPorIndicador(indicadorId), hasLength(1));
    expect((await repo.obtenerPorIndicador(indicadorId)).single.valor, 100);

    await database.close();
  });
}
