import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_control_logistico/data/local/database.dart';
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
import 'package:sistema_control_logistico/data/seed/sembrar_catalogos.dart';
import 'package:sistema_control_logistico/domain/export/organizacion_portable.dart';

/// Fase 9 (CLAUDE.md): Test U -- "exportar e importar la organización
/// completa produce un estado idéntico". Se compara por claves estables
/// (código, orden, etiqueta...) en vez de por id numérico crudo: los ids
/// nuevos que asigna la base de datos destino son, por diseño, distintos
/// de los originales -- lo que debe ser idéntico es el contenido y cómo
/// se relaciona entre sí.
void main() {
  Future<AppDatabase> baseConCatalogoSembrado() async {
    final db = AppDatabase(NativeDatabase.memory());
    await sembrarReglasDeSistemaSiVacio(ReglaPatronRepository(db));
    await sembrarBibliotecaAccionesSiVacio(AccionCatalogoRepository(db), ReglaAccionRepository(db));
    return db;
  }

  test('Test U — ida y vuelta JSON produce un estado idéntico', () async {
    final origen = await baseConCatalogoSembrado();

    final organizacionId = await OrganizacionRepository(
      origen,
    ).crear(const Organizacion(nombre: 'Organización de prueba', tipoEmpresa: 'servicios', notas: 'nota de prueba'));

    final periodoRepo = PeriodoRepository(origen);
    final periodoIds = <int>[];
    for (var i = 1; i <= 3; i++) {
      periodoIds.add(
        await periodoRepo.crear(
          Periodo(
            organizacionId: organizacionId,
            orden: i,
            etiqueta: 'Periodo $i',
            fechaInicio: '2026-0$i-01',
            fechaFin: '2026-0$i-28',
            granularidad: 'mensual',
          ),
        ),
      );
    }

    final indicadorRepo = IndicadorRepository(origen);
    final indicadorId = await indicadorRepo.crear(
      Indicador(
        organizacionId: organizacionId,
        codigo: 'IND-1',
        nombre: 'Indicador de prueba',
        categoria: 'costo',
        unidad: 'S/',
        sentido: 'menor_mejor',
        meta: 1.2,
        bandaInferior: 1.1,
        bandaSuperior: 1.3,
        granularidad: 'mensual',
        proceso: 'Transporte',
      ),
    );

    final medicionRepo = MedicionRepository(origen);
    for (var i = 0; i < 3; i++) {
      await medicionRepo.crear(
        Medicion(indicadorId: indicadorId, periodoId: periodoIds[i], valor: 1.2 + i * 0.05, origen: 'manual'),
      );
    }

    final evaluacionRepo = EvaluacionRepository(origen);
    final evaluacionId = await evaluacionRepo.crear(
      Evaluacion(
        indicadorId: indicadorId,
        periodoId: periodoIds[2],
        estado: 'desviacion',
        clasificacion: 'ajuste_menor',
        reglasDisparadasJson: '["R4"]',
        severidadCalculada: 0.4,
      ),
    );

    final reglaR4Id = (await ReglaPatronRepository(
      origen,
    ).obtenerTodas()).firstWhere((r) => r.codigo == 'R4').id!;
    await MemoriaEvaluacionRepository(origen).crear(
      MemoriaEvaluacion(
        evaluacionId: evaluacionId,
        reglaId: reglaR4Id,
        resultado: 'disparada',
        valoresEntradaJson: '{"n":5}',
        explicacion: 'explicación de prueba',
      ),
    );

    final accionCatalogoId = (await AccionCatalogoRepository(
      origen,
    ).obtenerTodas()).firstWhere((a) => a.codigo == 'AC-COSTO-AJUS-1').id!;
    final accionTomadaId = await AccionTomadaRepository(origen).crear(
      AccionTomada(
        evaluacionId: evaluacionId,
        accionCatalogoId: accionCatalogoId,
        responsable: 'Responsable de prueba',
        fechaCompromiso: '2026-04-01',
        fechaRegistro: '2026-03-05T00:00:00.000',
      ),
    );

    await VerificacionAccionRepository(origen).crear(
      VerificacionAccion(
        accionTomadaId: accionTomadaId,
        periodoVerificacionId: periodoIds[2],
        resultado: 'corrigio',
        valorObservado: 1.18,
        comentario: 'comentario de prueba',
      ),
    );

    await PresupuestoRepository(origen).crear(
      Presupuesto(
        organizacionId: organizacionId,
        rubro: 'Transporte',
        periodoId: periodoIds[0],
        montoPresupuestadoCent: 100000,
        montoRealCent: 110000,
      ),
    );

    await EscenarioSinteticoRepository(origen).crear(
      EscenarioSintetico(
        nombre: 'Escenario de prueba',
        indicadorBaseId: indicadorId,
        patron: 'estable',
        parametrosJson: '{"sigma":1.0}',
        semilla: 42,
        numeroPeriodos: 12,
      ),
    );

    await DiagnosticoOrganizacionalRepository(origen).crear(
      DiagnosticoOrganizacional(
        organizacionId: organizacionId,
        fecha: '2026-03-01T00:00:00.000',
        respuestasJson: '{"etapa-1":"1"}',
        etapaResultante: '2',
        opcionOrganizacional: 'funcional',
        ejesJson: '{"centralizacion":50}',
        orientacionDominante: 'proceso',
      ),
    );

    await FacturaTransporteRepository(origen).crear(
      FacturaTransporte(
        organizacionId: organizacionId,
        numero: 'F-100',
        transportista: 'Transportes de prueba',
        peso: 500,
        ruta: 'Lima-Trujillo',
        tarifaAplicadaCent: 40000,
        tarifaContratadaCent: 35000,
        discrepanciaTipo: 'tarifa',
        montoRecuperableCent: 5000,
      ),
    );

    final exportado = await exportarOrganizacion(origen, organizacionId);
    final texto = exportado.toJsonString();

    final destino = await baseConCatalogoSembrado();
    final nuevaOrganizacionId = await importarOrganizacion(OrganizacionPortable.fromJsonString(texto), destino);

    // ─── Comparación por claves estables, no por id numérico crudo ───
    final orgOriginal = (await OrganizacionRepository(origen).obtenerTodas()).firstWhere((o) => o.id == organizacionId);
    final orgImportada = (await OrganizacionRepository(
      destino,
    ).obtenerTodas()).firstWhere((o) => o.id == nuevaOrganizacionId);
    expect(orgImportada.nombre, orgOriginal.nombre);
    expect(orgImportada.tipoEmpresa, orgOriginal.tipoEmpresa);
    expect(orgImportada.moneda, orgOriginal.moneda);
    expect(orgImportada.notas, orgOriginal.notas);

    final periodosImportados = await PeriodoRepository(destino).obtenerPorOrganizacion(nuevaOrganizacionId);
    expect(
      periodosImportados.map((p) => '${p.orden}:${p.etiqueta}:${p.fechaInicio}:${p.fechaFin}').toSet(),
      {for (var i = 1; i <= 3; i++) '$i:Periodo $i:2026-0$i-01:2026-0$i-28'},
    );

    final indicadoresImportados = await IndicadorRepository(destino).obtenerPorOrganizacion(nuevaOrganizacionId);
    expect(indicadoresImportados.length, 1);
    final indicadorImportado = indicadoresImportados.single;
    expect(indicadorImportado.codigo, 'IND-1');
    expect(indicadorImportado.meta, 1.2);
    expect(indicadorImportado.proceso, 'Transporte');

    final medicionesImportadas = await MedicionRepository(destino).obtenerPorIndicador(indicadorImportado.id!);
    final periodoOrdenPorId = {for (final p in periodosImportados) p.id!: p.orden};
    expect(
      medicionesImportadas.map((m) => '${periodoOrdenPorId[m.periodoId]}:${m.valor}:${m.origen}').toSet(),
      {'1:1.2:manual', '2:1.25:manual', '3:1.3:manual'},
    );

    final evaluacionesImportadas = await EvaluacionRepository(destino).obtenerPorIndicador(indicadorImportado.id!);
    expect(evaluacionesImportadas.length, 1);
    final evaluacionImportada = evaluacionesImportadas.single;
    expect(evaluacionImportada.estado, 'desviacion');
    expect(evaluacionImportada.clasificacion, 'ajuste_menor');
    expect(evaluacionImportada.severidadCalculada, 0.4);

    final memoriasImportadas = await MemoriaEvaluacionRepository(
      destino,
    ).obtenerPorEvaluacion(evaluacionImportada.id!);
    expect(memoriasImportadas.length, 1);
    expect(memoriasImportadas.single.explicacion, 'explicación de prueba');
    final reglaDeLaMemoria = (await ReglaPatronRepository(
      destino,
    ).obtenerTodas()).firstWhere((r) => r.id == memoriasImportadas.single.reglaId);
    expect(reglaDeLaMemoria.codigo, 'R4');

    final accionesImportadas = await AccionTomadaRepository(destino).obtenerPorEvaluacion(evaluacionImportada.id!);
    expect(accionesImportadas.length, 1);
    final accionImportada = accionesImportadas.single;
    expect(accionImportada.responsable, 'Responsable de prueba');
    final accionCatalogoImportada = (await AccionCatalogoRepository(
      destino,
    ).obtenerTodas()).firstWhere((a) => a.id == accionImportada.accionCatalogoId);
    expect(accionCatalogoImportada.codigo, 'AC-COSTO-AJUS-1');

    final verificacionesImportadas = await VerificacionAccionRepository(
      destino,
    ).obtenerPorAccionTomada(accionImportada.id!);
    expect(verificacionesImportadas.length, 1);
    expect(verificacionesImportadas.single.resultado, 'corrigio');
    expect(verificacionesImportadas.single.valorObservado, 1.18);

    final presupuestosImportados = await PresupuestoRepository(destino).obtenerPorOrganizacion(nuevaOrganizacionId);
    expect(presupuestosImportados.length, 1);
    expect(presupuestosImportados.single.montoPresupuestadoCent, 100000);

    final escenariosImportados = (await EscenarioSinteticoRepository(
      destino,
    ).obtenerTodos()).where((e) => e.indicadorBaseId == indicadorImportado.id).toList();
    expect(escenariosImportados.length, 1);
    expect(escenariosImportados.single.nombre, 'Escenario de prueba');
    expect(escenariosImportados.single.semilla, 42);

    final diagnosticosImportados = await DiagnosticoOrganizacionalRepository(
      destino,
    ).obtenerPorOrganizacion(nuevaOrganizacionId);
    expect(diagnosticosImportados.length, 1);
    expect(diagnosticosImportados.single.etapaResultante, '2');

    final facturasImportadas = await FacturaTransporteRepository(destino).obtenerPorOrganizacion(nuevaOrganizacionId);
    expect(facturasImportadas.length, 1);
    expect(facturasImportadas.single.numero, 'F-100');
    expect(facturasImportadas.single.montoRecuperableCent, 5000);

    await origen.close();
    await destino.close();
  });

  test('Test U — rechaza un archivo de una versión futura con un mensaje humano', () {
    expect(
      () => OrganizacionPortable.fromJsonString('{"version": 999}'),
      throwsA(
        isA<FormatException>().having((e) => e.message, 'message', contains('versión más nueva')),
      ),
    );
  });
}
