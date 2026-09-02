import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_control_logistico/data/local/database.dart';
import 'package:sistema_control_logistico/data/models/accion_catalogo.dart';
import 'package:sistema_control_logistico/data/models/accion_tomada.dart';
import 'package:sistema_control_logistico/data/models/diagnostico_organizacional.dart';
import 'package:sistema_control_logistico/data/models/escenario_sintetico.dart';
import 'package:sistema_control_logistico/data/models/evaluacion.dart';
import 'package:sistema_control_logistico/data/models/factura_transporte.dart';
import 'package:sistema_control_logistico/data/models/indicador.dart';
import 'package:sistema_control_logistico/data/models/medicion.dart';
import 'package:sistema_control_logistico/data/models/memoria_evaluacion.dart';
import 'package:sistema_control_logistico/data/models/organizacion.dart';
import 'package:sistema_control_logistico/data/models/periodo.dart';
import 'package:sistema_control_logistico/data/models/presupuesto.dart';
import 'package:sistema_control_logistico/data/models/regla_accion.dart';
import 'package:sistema_control_logistico/data/models/regla_patron.dart';
import 'package:sistema_control_logistico/data/models/verificacion_accion.dart';
import 'package:sistema_control_logistico/data/repositories/accion_catalogo_repository.dart';
import 'package:sistema_control_logistico/data/repositories/accion_tomada_repository.dart';
import 'package:sistema_control_logistico/data/repositories/diagnostico_organizacional_repository.dart';
import 'package:sistema_control_logistico/data/repositories/escenario_sintetico_repository.dart';
import 'package:sistema_control_logistico/data/repositories/evaluacion_repository.dart';
import 'package:sistema_control_logistico/data/repositories/factura_transporte_repository.dart';
import 'package:sistema_control_logistico/data/repositories/indicador_repository.dart';
import 'package:sistema_control_logistico/data/repositories/medicion_repository.dart';
import 'package:sistema_control_logistico/data/repositories/memoria_evaluacion_repository.dart';
import 'package:sistema_control_logistico/data/repositories/organizacion_repository.dart';
import 'package:sistema_control_logistico/data/repositories/periodo_repository.dart';
import 'package:sistema_control_logistico/data/repositories/presupuesto_repository.dart';
import 'package:sistema_control_logistico/data/repositories/regla_accion_repository.dart';
import 'package:sistema_control_logistico/data/repositories/regla_patron_repository.dart';
import 'package:sistema_control_logistico/data/repositories/verificacion_accion_repository.dart';

/// Fase 1 (CLAUDE.md): "Test de creación de esquema y de cada repositorio"
/// -- alta, lectura, modificación y borrado, ejercitado sobre las quince
/// tablas. Se arma un único árbol de datos encadenado (una fila por tabla,
/// referenciando la anterior) porque casi todas las tablas dependen de
/// `organizacion`, `periodo` o `indicador`.
void main() {
  late AppDatabase database;
  late int organizacionId;
  late int periodoId;
  late int indicadorId;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    organizacionId = await OrganizacionRepository(
      database,
    ).crear(const Organizacion(nombre: 'Org', tipoEmpresa: 'manufacturera'));
    periodoId = await PeriodoRepository(database).crear(
      Periodo(
        organizacionId: organizacionId,
        orden: 1,
        etiqueta: 'Periodo 1',
        fechaInicio: '2026-01-01',
        fechaFin: '2026-01-31',
        granularidad: 'mensual',
      ),
    );
    indicadorId = await IndicadorRepository(database).crear(
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
  });

  tearDown(() async => database.close());

  test('OrganizacionRepository: alta, lectura, modificación, baja', () async {
    final repo = OrganizacionRepository(database);
    final id = await repo.crear(const Organizacion(nombre: 'Otra', tipoEmpresa: 'servicios'));
    expect((await repo.obtenerPorId(id))!.nombre, 'Otra');
    await repo.actualizar(Organizacion(id: id, nombre: 'Otra editada', tipoEmpresa: 'servicios'));
    expect((await repo.obtenerPorId(id))!.nombre, 'Otra editada');
    await repo.eliminar(id);
    expect(await repo.obtenerPorId(id), isNull);
  });

  test('PeriodoRepository: alta, lectura, modificación, baja', () async {
    final repo = PeriodoRepository(database);
    expect((await repo.obtenerPorId(periodoId))!.etiqueta, 'Periodo 1');
    await repo.actualizar(
      (await repo.obtenerPorId(periodoId))!.copyWith(etiqueta: 'Periodo 1 editado'),
    );
    expect((await repo.obtenerPorId(periodoId))!.etiqueta, 'Periodo 1 editado');
    await repo.eliminar(periodoId);
    expect(await repo.obtenerPorOrganizacion(organizacionId), isEmpty);
  });

  test('IndicadorRepository: alta, lectura, modificación, baja', () async {
    final repo = IndicadorRepository(database);
    expect((await repo.obtenerPorId(indicadorId))!.codigo, 'IND-1');
    await repo.actualizar((await repo.obtenerPorId(indicadorId))!.copyWith(meta: 200));
    expect((await repo.obtenerPorId(indicadorId))!.meta, 200);
    await repo.eliminar(indicadorId);
    expect(await repo.obtenerPorOrganizacion(organizacionId), isEmpty);
  });

  test('MedicionRepository: alta, lectura, modificación, baja', () async {
    final repo = MedicionRepository(database);
    final id = await repo.crear(
      Medicion(indicadorId: indicadorId, periodoId: periodoId, valor: 1.25, origen: 'manual'),
    );
    expect((await repo.obtenerPorIndicadorYPeriodo(indicadorId, periodoId))!.valor, 1.25);
    await repo.actualizar(
      (await repo.obtenerPorIndicadorYPeriodo(indicadorId, periodoId))!.copyWith(valor: 1.5),
    );
    expect((await repo.obtenerPorIndicadorYPeriodo(indicadorId, periodoId))!.valor, 1.5);
    await repo.eliminar(id);
    expect(await repo.obtenerPorIndicador(indicadorId), isEmpty);
  });

  test('ReglaPatronRepository: alta, lectura, modificación, baja', () async {
    final repo = ReglaPatronRepository(database);
    final id = await repo.crear(
      const ReglaPatron(
        codigo: 'R1',
        nombre: 'Punto fuera de banda',
        descripcion: 'desc',
        parametrosJson: '{}',
        periodosMinimos: 1,
        severidadBase: 1,
      ),
    );
    expect((await repo.obtenerTodas()).single.codigo, 'R1');
    await repo.actualizar((await repo.obtenerTodas()).single.copyWith(severidadBase: 2));
    expect((await repo.obtenerTodas()).single.severidadBase, 2);
    await repo.eliminar(id);
    expect(await repo.obtenerTodas(), isEmpty);
  });

  test('EvaluacionRepository: alta, lectura, modificación, baja', () async {
    final repo = EvaluacionRepository(database);
    final id = await repo.crear(
      Evaluacion(
        indicadorId: indicadorId,
        periodoId: periodoId,
        estado: 'normal',
        clasificacion: 'ninguna',
        reglasDisparadasJson: '[]',
        severidadCalculada: 0,
      ),
    );
    expect((await repo.obtenerPorIndicadorYPeriodo(indicadorId, periodoId))!.estado, 'normal');
    await repo.actualizar(
      (await repo.obtenerPorIndicadorYPeriodo(indicadorId, periodoId))!.copyWith(estado: 'desviacion'),
    );
    expect(
      (await repo.obtenerPorIndicadorYPeriodo(indicadorId, periodoId))!.estado,
      'desviacion',
    );
    await repo.eliminar(id);
    expect(await repo.obtenerPorIndicador(indicadorId), isEmpty);
  });

  test('MemoriaEvaluacionRepository: alta, lectura, baja', () async {
    final evaluacionId = await EvaluacionRepository(database).crear(
      Evaluacion(
        indicadorId: indicadorId,
        periodoId: periodoId,
        estado: 'normal',
        clasificacion: 'ninguna',
        reglasDisparadasJson: '[]',
        severidadCalculada: 0,
      ),
    );
    final reglaId = await ReglaPatronRepository(database).crear(
      const ReglaPatron(
        codigo: 'R1',
        nombre: 'Punto fuera de banda',
        descripcion: 'desc',
        parametrosJson: '{}',
        periodosMinimos: 1,
        severidadBase: 1,
      ),
    );
    final repo = MemoriaEvaluacionRepository(database);
    final id = await repo.crear(
      MemoriaEvaluacion(
        evaluacionId: evaluacionId,
        reglaId: reglaId,
        resultado: 'disparada',
        valoresEntradaJson: '{}',
        explicacion: 'explicación',
      ),
    );
    expect((await repo.obtenerPorEvaluacion(evaluacionId)).single.resultado, 'disparada');
    await repo.eliminar(id);
    expect(await repo.obtenerPorEvaluacion(evaluacionId), isEmpty);
  });

  test('AccionCatalogoRepository: alta, lectura, modificación, baja', () async {
    final repo = AccionCatalogoRepository(database);
    final id = await repo.crear(
      const AccionCatalogo(
        codigo: 'AC-1',
        titulo: 'Revisar factor de carga',
        descripcion: 'desc',
        categoriaIndicador: 'costo',
        magnitudTipica: 'ajuste_menor',
      ),
    );
    expect((await repo.obtenerTodas()).single.titulo, 'Revisar factor de carga');
    await repo.actualizar((await repo.obtenerTodas()).single.copyWith(titulo: 'Título editado'));
    expect((await repo.obtenerTodas()).single.titulo, 'Título editado');
    await repo.eliminar(id);
    expect(await repo.obtenerTodas(), isEmpty);
  });

  test('ReglaAccionRepository: alta, lectura por criterio, baja', () async {
    final accionId = await AccionCatalogoRepository(database).crear(
      const AccionCatalogo(
        codigo: 'AC-1',
        titulo: 'Revisar factor de carga',
        descripcion: 'desc',
        categoriaIndicador: 'costo',
        magnitudTipica: 'ajuste_menor',
      ),
    );
    final repo = ReglaAccionRepository(database);
    final id = await repo.crear(
      ReglaAccion(
        categoriaIndicador: 'costo',
        reglaDisparada: 'R2',
        clasificacion: 'ajuste_menor',
        accionId: accionId,
        prioridad: 1,
      ),
    );
    final candidatas = await repo.obtenerCandidatas(
      categoriaIndicador: 'costo',
      reglaDisparada: 'R2',
      clasificacion: 'ajuste_menor',
    );
    expect(candidatas.single.accionId, accionId);
    await repo.eliminar(id);
    expect(
      await repo.obtenerCandidatas(
        categoriaIndicador: 'costo',
        reglaDisparada: 'R2',
        clasificacion: 'ajuste_menor',
      ),
      isEmpty,
    );
  });

  test(
    'AccionCatalogoRepository: eliminar una acción borra en cascada sus mapeos de ReglaAccion',
    () async {
      final accionRepo = AccionCatalogoRepository(database);
      final accionId = await accionRepo.crear(
        const AccionCatalogo(
          codigo: 'AC-PROPIA-1',
          titulo: 'Acción propia del usuario',
          descripcion: 'desc',
          categoriaIndicador: 'costo',
          magnitudTipica: 'ajuste_menor',
          esDeSistema: false,
        ),
      );
      final reglaAccionRepo = ReglaAccionRepository(database);
      await reglaAccionRepo.crear(
        ReglaAccion(
          categoriaIndicador: 'costo',
          reglaDisparada: 'R2',
          clasificacion: 'ajuste_menor',
          accionId: accionId,
          prioridad: 1,
        ),
      );
      await reglaAccionRepo.crear(
        ReglaAccion(
          categoriaIndicador: 'costo',
          reglaDisparada: 'R3',
          clasificacion: 'ajuste_menor',
          accionId: accionId,
          prioridad: 1,
        ),
      );
      expect((await reglaAccionRepo.obtenerTodas()).length, 2);

      await accionRepo.eliminar(accionId);

      expect(await accionRepo.obtenerTodas(), isEmpty);
      expect(await reglaAccionRepo.obtenerTodas(), isEmpty);
    },
  );

  test(
    'AccionCatalogoRepository: no se puede eliminar una acción que ya fue tomada',
    () async {
      final evaluacionId = await EvaluacionRepository(database).crear(
        Evaluacion(
          indicadorId: indicadorId,
          periodoId: periodoId,
          estado: 'desviacion',
          clasificacion: 'ajuste_menor',
          reglasDisparadasJson: '["R2"]',
          severidadCalculada: 1,
        ),
      );
      final accionRepo = AccionCatalogoRepository(database);
      final accionId = await accionRepo.crear(
        const AccionCatalogo(
          codigo: 'AC-USADA-1',
          titulo: 'Acción ya usada',
          descripcion: 'desc',
          categoriaIndicador: 'costo',
          magnitudTipica: 'ajuste_menor',
        ),
      );
      await AccionTomadaRepository(database).crear(
        AccionTomada(
          evaluacionId: evaluacionId,
          accionCatalogoId: accionId,
          responsable: 'Jefe de Transporte',
          fechaCompromiso: '2026-02-01',
          fechaRegistro: '2026-01-15T10:00:00',
        ),
      );

      await expectLater(accionRepo.eliminar(accionId), throwsA(anything));
    },
  );

  test('AccionTomadaRepository: alta, lectura, modificación, baja', () async {
    final evaluacionId = await EvaluacionRepository(database).crear(
      Evaluacion(
        indicadorId: indicadorId,
        periodoId: periodoId,
        estado: 'desviacion',
        clasificacion: 'ajuste_menor',
        reglasDisparadasJson: '["R2"]',
        severidadCalculada: 1,
      ),
    );
    final accionCatalogoId = await AccionCatalogoRepository(database).crear(
      const AccionCatalogo(
        codigo: 'AC-1',
        titulo: 'Revisar factor de carga',
        descripcion: 'desc',
        categoriaIndicador: 'costo',
        magnitudTipica: 'ajuste_menor',
      ),
    );
    final repo = AccionTomadaRepository(database);
    final id = await repo.crear(
      AccionTomada(
        evaluacionId: evaluacionId,
        accionCatalogoId: accionCatalogoId,
        responsable: 'Jefe de Transporte',
        fechaCompromiso: '2026-02-01',
        fechaRegistro: '2026-01-15T10:00:00',
      ),
    );
    expect((await repo.obtenerPorEvaluacion(evaluacionId)).single.estado, 'abierta');
    await repo.actualizar(
      (await repo.obtenerPorEvaluacion(evaluacionId)).single.copyWith(estado: 'cerrada'),
    );
    expect((await repo.obtenerPorEvaluacion(evaluacionId)).single.estado, 'cerrada');
    await repo.eliminar(id);
    expect(await repo.obtenerPorEvaluacion(evaluacionId), isEmpty);
  });

  test('VerificacionAccionRepository: alta, lectura, confirmación, baja', () async {
    final evaluacionId = await EvaluacionRepository(database).crear(
      Evaluacion(
        indicadorId: indicadorId,
        periodoId: periodoId,
        estado: 'desviacion',
        clasificacion: 'ajuste_menor',
        reglasDisparadasJson: '["R2"]',
        severidadCalculada: 1,
      ),
    );
    final accionCatalogoId = await AccionCatalogoRepository(database).crear(
      const AccionCatalogo(
        codigo: 'AC-1',
        titulo: 'Revisar factor de carga',
        descripcion: 'desc',
        categoriaIndicador: 'costo',
        magnitudTipica: 'ajuste_menor',
      ),
    );
    final accionTomadaId = await AccionTomadaRepository(database).crear(
      AccionTomada(
        evaluacionId: evaluacionId,
        accionCatalogoId: accionCatalogoId,
        responsable: 'Jefe de Transporte',
        fechaCompromiso: '2026-02-01',
        fechaRegistro: '2026-01-15T10:00:00',
      ),
    );
    final periodoSiguienteId = await PeriodoRepository(database).crear(
      Periodo(
        organizacionId: organizacionId,
        orden: 2,
        etiqueta: 'Periodo 2',
        fechaInicio: '2026-02-01',
        fechaFin: '2026-02-28',
        granularidad: 'mensual',
      ),
    );
    final repo = VerificacionAccionRepository(database);
    final id = await repo.crear(
      VerificacionAccion(
        accionTomadaId: accionTomadaId,
        periodoVerificacionId: periodoSiguienteId,
        resultado: 'corrigio',
        valorObservado: 95,
      ),
    );
    expect((await repo.obtenerPorAccionTomada(accionTomadaId)).single.confirmadoPorUsuario, isFalse);
    await repo.confirmar(id, resultado: 'corrigio');
    expect((await repo.obtenerPorAccionTomada(accionTomadaId)).single.confirmadoPorUsuario, isTrue);
    await repo.eliminar(id);
    expect(await repo.obtenerPorAccionTomada(accionTomadaId), isEmpty);
  });

  test('PresupuestoRepository: alta, lectura, modificación, baja', () async {
    final repo = PresupuestoRepository(database);
    final id = await repo.crear(
      Presupuesto(
        organizacionId: organizacionId,
        rubro: 'Transporte',
        periodoId: periodoId,
        montoPresupuestadoCent: 100000,
        montoRealCent: 110000,
      ),
    );
    expect((await repo.obtenerPorOrganizacion(organizacionId)).single.montoRealCent, 110000);
    await repo.actualizar(
      (await repo.obtenerPorOrganizacion(organizacionId)).single.copyWith(montoRealCent: 95000),
    );
    expect((await repo.obtenerPorOrganizacion(organizacionId)).single.montoRealCent, 95000);
    await repo.eliminar(id);
    expect(await repo.obtenerPorOrganizacion(organizacionId), isEmpty);
  });

  test('EscenarioSinteticoRepository: alta, lectura, baja', () async {
    final repo = EscenarioSinteticoRepository(database);
    final id = await repo.crear(
      EscenarioSintetico(
        nombre: 'Deterioro brusco',
        indicadorBaseId: indicadorId,
        patron: 'deterioro_brusco',
        parametrosJson: '{}',
        semilla: 42,
        numeroPeriodos: 12,
      ),
    );
    expect((await repo.obtenerTodos()).single.nombre, 'Deterioro brusco');
    await repo.eliminar(id);
    expect(await repo.obtenerTodos(), isEmpty);
  });

  test('DiagnosticoOrganizacionalRepository: alta, lectura, baja', () async {
    final repo = DiagnosticoOrganizacionalRepository(database);
    final id = await repo.crear(
      DiagnosticoOrganizacional(
        organizacionId: organizacionId,
        fecha: '2026-01-01',
        respuestasJson: '{}',
        etapaResultante: 'madurez',
        opcionOrganizacional: 'centralizada',
        ejesJson: '{}',
        orientacionDominante: 'proceso',
      ),
    );
    expect((await repo.obtenerPorOrganizacion(organizacionId)).single.etapaResultante, 'madurez');
    await repo.eliminar(id);
    expect(await repo.obtenerPorOrganizacion(organizacionId), isEmpty);
  });

  test('FacturaTransporteRepository: alta, lectura, modificación, baja', () async {
    final repo = FacturaTransporteRepository(database);
    final id = await repo.crear(
      FacturaTransporte(
        organizacionId: organizacionId,
        numero: 'F-001',
        transportista: 'Transportes S.A.',
        peso: 1000,
        ruta: 'Lima-Ica',
        tarifaAplicadaCent: 50000,
        tarifaContratadaCent: 45000,
        discrepanciaTipo: 'tarifa',
        montoRecuperableCent: 5000,
      ),
    );
    expect((await repo.obtenerPorOrganizacion(organizacionId)).single.estado, 'pendiente');
    await repo.actualizar(
      (await repo.obtenerPorOrganizacion(organizacionId)).single.copyWith(estado: 'recuperado'),
    );
    expect((await repo.obtenerPorOrganizacion(organizacionId)).single.estado, 'recuperado');
    await repo.eliminar(id);
    expect(await repo.obtenerPorOrganizacion(organizacionId), isEmpty);
  });
}
