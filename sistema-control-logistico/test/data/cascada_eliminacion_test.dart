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

/// Fase 1 (CLAUDE.md): "eliminar un proyecto elimina clientes, zonas..." --
/// acá el equivalente es organización, y transitivamente todo lo que
/// cuelga de periodo/indicador/evaluación/acción tomada. `accion_catalogo`
/// y `regla_accion` son catálogo global (no cuelgan de organización, ver
/// `database.dart`) y deben sobrevivir intactos.
void main() {
  test('eliminar una organización borra en cascada todo su árbol de datos', () async {
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
    final periodoVerificacionId = await PeriodoRepository(database).crear(
      Periodo(
        organizacionId: organizacionId,
        orden: 2,
        etiqueta: 'Periodo 2',
        fechaInicio: '2026-02-01',
        fechaFin: '2026-02-28',
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
    await MedicionRepository(database).crear(
      Medicion(indicadorId: indicadorId, periodoId: periodoId, valor: 105, origen: 'manual'),
    );
    final reglaId = await ReglaPatronRepository(database).crear(
      ReglaPatron(
        codigo: 'R1',
        nombre: 'Punto fuera de banda',
        descripcion: 'desc',
        parametrosJson: '{}',
        periodosMinimos: 1,
        severidadBase: 1,
        indicadorId: indicadorId, // override por indicador -- también cuelga de organización
      ),
    );
    final evaluacionId = await EvaluacionRepository(database).crear(
      Evaluacion(
        indicadorId: indicadorId,
        periodoId: periodoId,
        estado: 'desviacion',
        clasificacion: 'ajuste_menor',
        reglasDisparadasJson: '["R1"]',
        severidadCalculada: 1,
      ),
    );
    await MemoriaEvaluacionRepository(database).crear(
      MemoriaEvaluacion(
        evaluacionId: evaluacionId,
        reglaId: reglaId,
        resultado: 'disparada',
        valoresEntradaJson: '{}',
        explicacion: 'explicación',
      ),
    );

    // Catálogo global -- NO cuelga de esta organización.
    final accionCatalogoId = await AccionCatalogoRepository(database).crear(
      const AccionCatalogo(
        codigo: 'AC-1',
        titulo: 'Revisar factor de carga',
        descripcion: 'desc',
        categoriaIndicador: 'costo',
        magnitudTipica: 'ajuste_menor',
      ),
    );
    await ReglaAccionRepository(database).crear(
      ReglaAccion(
        categoriaIndicador: 'costo',
        reglaDisparada: 'R1',
        clasificacion: 'ajuste_menor',
        accionId: accionCatalogoId,
        prioridad: 1,
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
    await VerificacionAccionRepository(database).crear(
      VerificacionAccion(
        accionTomadaId: accionTomadaId,
        periodoVerificacionId: periodoVerificacionId,
        resultado: 'corrigio',
        valorObservado: 95,
      ),
    );
    await PresupuestoRepository(database).crear(
      Presupuesto(
        organizacionId: organizacionId,
        rubro: 'Transporte',
        periodoId: periodoId,
        montoPresupuestadoCent: 100000,
        montoRealCent: 110000,
      ),
    );
    await EscenarioSinteticoRepository(database).crear(
      EscenarioSintetico(
        nombre: 'Deterioro brusco',
        indicadorBaseId: indicadorId,
        patron: 'deterioro_brusco',
        parametrosJson: '{}',
        semilla: 42,
        numeroPeriodos: 12,
      ),
    );
    await DiagnosticoOrganizacionalRepository(database).crear(
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
    await FacturaTransporteRepository(database).crear(
      FacturaTransporte(
        organizacionId: organizacionId,
        numero: 'F-001',
        transportista: 'Transportes S.A.',
        peso: 1000,
        ruta: 'Lima-Ica',
        tarifaAplicadaCent: 50000,
        tarifaContratadaCent: 45000,
      ),
    );

    // Confirmar que todo quedó cargado antes de borrar.
    expect(await database.select(database.periodoTable).get(), hasLength(2));
    expect(await database.select(database.indicadorTable).get(), hasLength(1));
    expect(await database.select(database.medicionTable).get(), hasLength(1));
    expect(await database.select(database.reglaPatronTable).get(), hasLength(1));
    expect(await database.select(database.evaluacionTable).get(), hasLength(1));
    expect(await database.select(database.memoriaEvaluacionTable).get(), hasLength(1));
    expect(await database.select(database.accionTomadaTable).get(), hasLength(1));
    expect(await database.select(database.verificacionAccionTable).get(), hasLength(1));
    expect(await database.select(database.presupuestoTable).get(), hasLength(1));
    expect(await database.select(database.escenarioSinteticoTable).get(), hasLength(1));
    expect(await database.select(database.diagnosticoOrganizacionalTable).get(), hasLength(1));
    expect(await database.select(database.facturaTransporteTable).get(), hasLength(1));
    expect(await database.select(database.accionCatalogoTable).get(), hasLength(1));
    expect(await database.select(database.reglaAccionTable).get(), hasLength(1));

    await OrganizacionRepository(database).eliminar(organizacionId);

    expect(await database.select(database.organizacionTable).get(), isEmpty);
    expect(await database.select(database.periodoTable).get(), isEmpty);
    expect(await database.select(database.indicadorTable).get(), isEmpty);
    expect(await database.select(database.medicionTable).get(), isEmpty);
    expect(await database.select(database.reglaPatronTable).get(), isEmpty);
    expect(await database.select(database.evaluacionTable).get(), isEmpty);
    expect(await database.select(database.memoriaEvaluacionTable).get(), isEmpty);
    expect(await database.select(database.accionTomadaTable).get(), isEmpty);
    expect(await database.select(database.verificacionAccionTable).get(), isEmpty);
    expect(await database.select(database.presupuestoTable).get(), isEmpty);
    expect(await database.select(database.escenarioSinteticoTable).get(), isEmpty);
    expect(await database.select(database.diagnosticoOrganizacionalTable).get(), isEmpty);
    expect(await database.select(database.facturaTransporteTable).get(), isEmpty);

    // El catálogo global sobrevive: no pertenece a ninguna organización.
    expect(await database.select(database.accionCatalogoTable).get(), hasLength(1));
    expect(await database.select(database.reglaAccionTable).get(), hasLength(1));

    await database.close();
  });
}
