import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_red_distribucion/data/local/database.dart';
import 'package:sistema_red_distribucion/data/models/celda_matriz.dart';
import 'package:sistema_red_distribucion/data/models/cliente.dart';
import 'package:sistema_red_distribucion/data/models/cliente_zona.dart';
import 'package:sistema_red_distribucion/data/models/escenario.dart';
import 'package:sistema_red_distribucion/data/models/escenario_almacen.dart';
import 'package:sistema_red_distribucion/data/models/escenario_asignacion.dart';
import 'package:sistema_red_distribucion/data/models/escenario_costo.dart';
import 'package:sistema_red_distribucion/data/models/memoria_calculo.dart';
import 'package:sistema_red_distribucion/data/models/parametros_costo.dart';
import 'package:sistema_red_distribucion/data/models/planta.dart';
import 'package:sistema_red_distribucion/data/models/proyecto.dart';
import 'package:sistema_red_distribucion/data/models/punto_curva.dart';
import 'package:sistema_red_distribucion/data/models/sitio_candidato.dart';
import 'package:sistema_red_distribucion/data/models/zona_demanda.dart';
import 'package:sistema_red_distribucion/data/repositories/celda_matriz_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/cliente_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/cliente_zona_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/escenario_almacen_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/escenario_asignacion_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/escenario_costo_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/escenario_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/memoria_calculo_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/parametros_costo_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/planta_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/proyecto_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/punto_curva_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/sitio_candidato_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/zona_demanda_repository.dart';

/// Test de la fase 1 (CLAUDE.md): "eliminar un proyecto elimina clientes,
/// zonas, candidatos, escenarios y memoria" — y transitivamente todo lo que
/// cuelga de zonas (cliente_zona) y de escenarios (almacenes, asignaciones,
/// costos, puntos de curva, memoria de cálculo), en una sola llamada a
/// `ProyectoRepository.eliminar`.
void main() {
  test('eliminar un proyecto borra en cascada todo su árbol de datos', () async {
    final database = AppDatabase(NativeDatabase.memory());

    final proyectoId = await ProyectoRepository(database).crear(
      Proyecto(nombre: 'P', creadoEn: DateTime(2026, 1, 1).toIso8601String()),
    );

    final clienteId = await ClienteRepository(database).crear(
      Cliente(
        proyectoId: proyectoId,
        nombre: 'Cliente A',
        latitud: 0,
        longitud: 0,
        demandaAnual: 10,
        pedidosAnuales: 2,
      ),
    );
    final zonaId = await ZonaDemandaRepository(database).crear(
      ZonaDemanda(
        proyectoId: proyectoId,
        etiqueta: 'Zona 1',
        latitud: 0,
        longitud: 0,
        demandaAgregada: 10,
        pedidosAgregados: 2,
        numeroClientes: 1,
        errorAgregacionMetros: 0,
      ),
    );
    await ClienteZonaRepository(
      database,
    ).insertarTodas([ClienteZona(clienteId: clienteId, zonaId: zonaId)]);

    final candidatoId = await SitioCandidatoRepository(database).crear(
      SitioCandidato(
        proyectoId: proyectoId,
        nombre: 'Candidato 1',
        latitud: 0,
        longitud: 0,
        costoFijoAnualCent: 1000,
        capacidadAnual: 100,
        costoVariableManejoCentPorUnidad: 10,
        origen: 'manual',
      ),
    );
    await PlantaRepository(database).crear(
      Planta(
        proyectoId: proyectoId,
        nombre: 'Planta 1',
        latitud: 0,
        longitud: 0,
        capacidadAnual: 1000,
        costoProduccionCentPorUnidad: 100,
      ),
    );
    await ParametrosCostoRepository(database).guardar(
      ParametrosCosto(
        proyectoId: proyectoId,
        tarifaEntradaFijaCent: 100,
        tarifaEntradaCentPorKmTon: 10,
        tarifaSalidaFijaCent: 100,
        tarifaSalidaCentPorKmTon: 10,
        tasaManejoInventarioAnual: 0.2,
        valorPorUnidadCent: 100000,
        inventarioBaseUnaUbicacion: 10,
        costoPorPedidoCent: 50,
        tipoEstandar: 'distancia',
        estandarServicioValor: 50000,
      ),
    );
    await CeldaMatrizRepository(database).insertarTodas([
      CeldaMatriz(
        proyectoId: proyectoId,
        tipoOrigen: 'candidato',
        origenId: candidatoId,
        tipoDestino: 'zona',
        destinoId: zonaId,
        distanciaMetros: 1000,
        duracionSegundos: 100,
        fuente: 'osrm',
      ),
    ]);

    final escenarioId = await EscenarioRepository(database).crear(
      Escenario(
        proyectoId: proyectoId,
        nombre: 'Escenario 1',
        metodo: 'add',
        costoTotalCent: 900000,
        fecha: DateTime(2026, 1, 1).toIso8601String(),
      ),
    );
    await EscenarioAlmacenRepository(database).insertarTodos([
      EscenarioAlmacen(
        escenarioId: escenarioId,
        sitioCandidatoId: candidatoId,
        volumenAsignado: 10,
        costoFijoCent: 1000,
        costoManejoCent: 100,
      ),
    ]);
    await EscenarioAsignacionRepository(database).insertarTodas([
      EscenarioAsignacion(
        escenarioId: escenarioId,
        zonaId: zonaId,
        sitioCandidatoId: candidatoId,
        distanciaMetros: 1000,
        duracionSegundos: 100,
        costoSalidaCent: 500,
      ),
    ]);
    await EscenarioCostoRepository(
      database,
    ).insertarTodos([EscenarioCosto(escenarioId: escenarioId, rubro: 'fijo', montoCent: 1000)]);
    await PuntoCurvaRepository(database).insertarTodos([
      PuntoCurva(
        escenarioId: escenarioId,
        numeroAlmacenes: 1,
        costoTotalCent: 900000,
        costoPorRubroJson: '{}',
        viableSegunServicio: true,
      ),
    ]);
    await MemoriaCalculoRepository(database).crear(
      MemoriaCalculo(
        escenarioId: escenarioId,
        orden: 1,
        modulo: 'M4',
        formula: 'costo = fijo',
        entradasJson: '{}',
        salida: '1000',
        unidad: 'centavos',
      ),
    );

    // Confirmar que todo quedó cargado antes de borrar, para que el test
    // realmente pruebe la cascada y no un árbol vacío por accidente.
    expect(await database.select(database.clienteTable).get(), hasLength(1));
    expect(await database.select(database.zonaDemandaTable).get(), hasLength(1));
    expect(await database.select(database.clienteZonaTable).get(), hasLength(1));
    expect(await database.select(database.sitioCandidatoTable).get(), hasLength(1));
    expect(await database.select(database.plantaTable).get(), hasLength(1));
    expect(await database.select(database.parametrosCostoTable).get(), hasLength(1));
    expect(await database.select(database.celdaMatrizTable).get(), hasLength(1));
    expect(await database.select(database.escenarioTable).get(), hasLength(1));
    expect(await database.select(database.escenarioAlmacenTable).get(), hasLength(1));
    expect(await database.select(database.escenarioAsignacionTable).get(), hasLength(1));
    expect(await database.select(database.escenarioCostoTable).get(), hasLength(1));
    expect(await database.select(database.puntoCurvaTable).get(), hasLength(1));
    expect(await database.select(database.memoriaCalculoTable).get(), hasLength(1));

    await ProyectoRepository(database).eliminar(proyectoId);

    expect(await database.select(database.proyectoTable).get(), isEmpty);
    expect(await database.select(database.clienteTable).get(), isEmpty);
    expect(await database.select(database.zonaDemandaTable).get(), isEmpty);
    expect(await database.select(database.clienteZonaTable).get(), isEmpty);
    expect(await database.select(database.sitioCandidatoTable).get(), isEmpty);
    expect(await database.select(database.plantaTable).get(), isEmpty);
    expect(await database.select(database.parametrosCostoTable).get(), isEmpty);
    expect(await database.select(database.celdaMatrizTable).get(), isEmpty);
    expect(await database.select(database.escenarioTable).get(), isEmpty);
    expect(await database.select(database.escenarioAlmacenTable).get(), isEmpty);
    expect(await database.select(database.escenarioAsignacionTable).get(), isEmpty);
    expect(await database.select(database.escenarioCostoTable).get(), isEmpty);
    expect(await database.select(database.puntoCurvaTable).get(), isEmpty);
    expect(await database.select(database.memoriaCalculoTable).get(), isEmpty);

    await database.close();
  });

  test(
    'eliminar el escenario que usa un candidato lo libera para poder borrarlo '
    '(Pantalla Escenarios, agregada tras un reporte del usuario)',
    () async {
      final database = AppDatabase(NativeDatabase.memory());

      final proyectoId = await ProyectoRepository(database).crear(
        Proyecto(nombre: 'P', creadoEn: DateTime(2026, 1, 1).toIso8601String()),
      );
      final candidatoId = await SitioCandidatoRepository(database).crear(
        SitioCandidato(
          proyectoId: proyectoId,
          nombre: 'Candidato 1',
          latitud: 0,
          longitud: 0,
          costoFijoAnualCent: 1000,
          capacidadAnual: 100,
          costoVariableManejoCentPorUnidad: 10,
          origen: 'manual',
        ),
      );
      final escenarioId = await EscenarioRepository(database).crear(
        Escenario(
          proyectoId: proyectoId,
          nombre: 'Escenario 1',
          metodo: 'add',
          costoTotalCent: 900000,
          fecha: DateTime(2026, 1, 1).toIso8601String(),
        ),
      );
      await EscenarioAlmacenRepository(database).insertarTodos([
        EscenarioAlmacen(
          escenarioId: escenarioId,
          sitioCandidatoId: candidatoId,
          volumenAsignado: 10,
          costoFijoCent: 1000,
          costoManejoCent: 100,
        ),
      ]);

      // Mientras el escenario existe, el candidato está bloqueado.
      await expectLater(
        SitioCandidatoRepository(database).eliminar(candidatoId),
        throwsA(anything),
      );
      expect(await database.select(database.sitioCandidatoTable).get(), hasLength(1));

      await EscenarioRepository(database).eliminar(escenarioId);

      expect(await database.select(database.escenarioTable).get(), isEmpty);
      expect(await database.select(database.escenarioAlmacenTable).get(), isEmpty);

      // Con el escenario fuera, el candidato ya se puede borrar sin error.
      await SitioCandidatoRepository(database).eliminar(candidatoId);
      expect(await database.select(database.sitioCandidatoTable).get(), isEmpty);

      await database.close();
    },
  );
}
