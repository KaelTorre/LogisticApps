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

/// Fase 1 (CLAUDE.md): "las mediciones se recuperan siempre ordenadas por
/// `periodo.orden`, no por fecha" -- la regla fundamental de la sección 4
/// exige que ninguna consulta reordene por fecha ni por el id de inserción.
/// Este test crea los periodos y sus mediciones deliberadamente
/// desordenados (orden 3, luego 1, luego 2, con fechas que además
/// contradicen ese orden) para que una consulta que ordenara por fecha o
/// por id falle de forma visible.
void main() {
  test('las mediciones y los periodos se recuperan ordenados por orden, no por fecha ni por id', () async {
    final database = AppDatabase(NativeDatabase.memory());

    final organizacionId = await OrganizacionRepository(
      database,
    ).crear(const Organizacion(nombre: 'Org', tipoEmpresa: 'manufacturera'));
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

    // Se insertan a propósito fuera de orden, con fechas que contradicen
    // `orden`: el periodo 3 tiene la fecha más temprana.
    final periodoRepo = PeriodoRepository(database);
    final idOrden3 = await periodoRepo.crear(
      Periodo(
        organizacionId: organizacionId,
        orden: 3,
        etiqueta: 'Periodo 3',
        fechaInicio: '2020-01-01',
        fechaFin: '2020-01-31',
        granularidad: 'mensual',
      ),
    );
    final idOrden1 = await periodoRepo.crear(
      Periodo(
        organizacionId: organizacionId,
        orden: 1,
        etiqueta: 'Periodo 1',
        fechaInicio: '2029-01-01',
        fechaFin: '2029-01-31',
        granularidad: 'mensual',
      ),
    );
    final idOrden2 = await periodoRepo.crear(
      Periodo(
        organizacionId: organizacionId,
        orden: 2,
        etiqueta: 'Periodo 2',
        fechaInicio: '2025-01-01',
        fechaFin: '2025-01-31',
        granularidad: 'mensual',
      ),
    );

    final periodos = await periodoRepo.obtenerPorOrganizacion(organizacionId);
    expect(periodos.map((p) => p.orden).toList(), [1, 2, 3]);
    expect(periodos.map((p) => p.etiqueta).toList(), ['Periodo 1', 'Periodo 2', 'Periodo 3']);

    final medicionRepo = MedicionRepository(database);
    // Insertadas en el mismo orden de ids que los periodos (3, 1, 2), para
    // que una consulta que ordenara por id de medición también falle.
    await medicionRepo.crear(
      Medicion(indicadorId: indicadorId, periodoId: idOrden3, valor: 300, origen: 'manual'),
    );
    await medicionRepo.crear(
      Medicion(indicadorId: indicadorId, periodoId: idOrden1, valor: 100, origen: 'manual'),
    );
    await medicionRepo.crear(
      Medicion(indicadorId: indicadorId, periodoId: idOrden2, valor: 200, origen: 'manual'),
    );

    final mediciones = await medicionRepo.obtenerPorIndicador(indicadorId);
    expect(mediciones.map((m) => m.valor).toList(), [100, 200, 300]);

    await database.close();
  });
}
