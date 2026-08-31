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
import 'package:sistema_red_distribucion/domain/export/exportar_importar_proyecto.dart';
import 'package:sistema_red_distribucion/domain/export/proyecto_red_portable.dart';

/// Test X (CLAUDE.md Fase 9): "exportar un proyecto e importarlo produce un
/// proyecto idéntico en todas sus tablas" — usa el mismo árbol de datos
/// completo (las 13 tablas propias de un proyecto, más `cliente_zona`) que
/// ya arma `cascada_eliminacion_test.dart` para la Fase 1, para no
/// duplicar un segundo dataset de prueba con las mismas 14 tablas.
void main() {
  test('exportar un proyecto e importarlo produce un proyecto idéntico en todas sus tablas', () async {
    final origen = AppDatabase(NativeDatabase.memory());

    final proyectoId = await ProyectoRepository(origen).crear(
      Proyecto(
        nombre: 'P',
        moneda: 'PEN',
        unidadPeso: 'toneladas',
        horizonteAnios: 7,
        factorCircuidad: 1.25,
        creadoEn: DateTime(2026, 1, 1).toIso8601String(),
      ),
    );

    final clienteId = await ClienteRepository(origen).crear(
      Cliente(
        proyectoId: proyectoId,
        nombre: 'Cliente A',
        latitud: -8.1,
        longitud: -74.1,
        demandaAnual: 10,
        pedidosAnuales: 2,
      ),
    );
    final zonaId = await ZonaDemandaRepository(origen).crear(
      ZonaDemanda(
        proyectoId: proyectoId,
        etiqueta: 'Zona 1',
        latitud: -8.1,
        longitud: -74.1,
        demandaAgregada: 10,
        pedidosAgregados: 2,
        numeroClientes: 1,
        errorAgregacionMetros: 5,
      ),
    );
    await ClienteZonaRepository(origen).insertarTodas([ClienteZona(clienteId: clienteId, zonaId: zonaId)]);

    final candidatoId = await SitioCandidatoRepository(origen).crear(
      SitioCandidato(
        proyectoId: proyectoId,
        nombre: 'Candidato 1',
        latitud: -8.2,
        longitud: -74.2,
        costoFijoAnualCent: 1000,
        capacidadAnual: 100,
        costoVariableManejoCentPorUnidad: 10,
        origen: 'manual',
        esRedActual: true,
      ),
    );
    final plantaId = await PlantaRepository(origen).crear(
      Planta(
        proyectoId: proyectoId,
        nombre: 'Planta 1',
        latitud: -8.3,
        longitud: -74.3,
        capacidadAnual: 1000,
        costoProduccionCentPorUnidad: 100,
      ),
    );
    await ParametrosCostoRepository(origen).guardar(
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
    await CeldaMatrizRepository(origen).insertarTodas([
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
      CeldaMatriz(
        proyectoId: proyectoId,
        tipoOrigen: 'planta',
        origenId: plantaId,
        tipoDestino: 'zona',
        destinoId: zonaId,
        distanciaMetros: 2000,
        duracionSegundos: 200,
        fuente: 'haversine',
      ),
      // Celda planta -> candidato (usada por M4 para el costo de entrada):
      // `destinoId` referencia un sitio_candidato, no una zona. Cubre el caso
      // que el resto de las celdas de este fixture no ejercitaba.
      CeldaMatriz(
        proyectoId: proyectoId,
        tipoOrigen: 'planta',
        origenId: plantaId,
        tipoDestino: 'candidato',
        destinoId: candidatoId,
        distanciaMetros: 3000,
        duracionSegundos: 300,
        fuente: 'osrm',
      ),
    ]);

    final escenarioId = await EscenarioRepository(origen).crear(
      Escenario(
        proyectoId: proyectoId,
        nombre: 'Escenario 1',
        metodo: 'add',
        pFijo: 1,
        restriccionCapacidadActiva: true,
        costoTotalCent: 900000,
        fecha: DateTime(2026, 1, 1).toIso8601String(),
        notas: 'nota de prueba',
      ),
    );
    await EscenarioAlmacenRepository(origen).insertarTodos([
      EscenarioAlmacen(
        escenarioId: escenarioId,
        sitioCandidatoId: candidatoId,
        volumenAsignado: 10,
        costoFijoCent: 1000,
        costoManejoCent: 100,
      ),
    ]);
    await EscenarioAsignacionRepository(origen).insertarTodas([
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
      origen,
    ).insertarTodos([EscenarioCosto(escenarioId: escenarioId, rubro: 'fijo', montoCent: 1000)]);
    await PuntoCurvaRepository(origen).insertarTodos([
      PuntoCurva(
        escenarioId: escenarioId,
        numeroAlmacenes: 1,
        costoTotalCent: 900000,
        costoPorRubroJson: '{"fijo":1000}',
        viableSegunServicio: true,
      ),
    ]);
    await MemoriaCalculoRepository(origen).crear(
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

    // Ida y vuelta completa: exportar, serializar a JSON, deserializar, e
    // importar en una base NUEVA y separada — nunca reabrir la de origen,
    // para que el test realmente pruebe que el archivo es autocontenido.
    final portable = await exportarProyecto(proyectoId, origen);
    final json = portable.toJsonString();
    final reconstruido = ProyectoRedPortable.fromJsonString(json);

    final destino = AppDatabase(NativeDatabase.memory());
    final nuevoProyectoId = await importarProyecto(reconstruido, destino);

    final proyectoOriginal = await ProyectoRepository(origen).obtenerPorId(proyectoId);
    final proyectoImportado = await ProyectoRepository(destino).obtenerPorId(nuevoProyectoId);
    expect(proyectoImportado!.nombre, proyectoOriginal!.nombre);
    expect(proyectoImportado.moneda, proyectoOriginal.moneda);
    expect(proyectoImportado.unidadPeso, proyectoOriginal.unidadPeso);
    expect(proyectoImportado.horizonteAnios, proyectoOriginal.horizonteAnios);
    expect(proyectoImportado.factorCircuidad, proyectoOriginal.factorCircuidad);
    expect(proyectoImportado.creadoEn, proyectoOriginal.creadoEn);

    final clientesImportados = await ClienteRepository(destino).obtenerPorProyecto(nuevoProyectoId);
    expect(clientesImportados, hasLength(1));
    expect(clientesImportados.single.nombre, 'Cliente A');
    expect(clientesImportados.single.demandaAnual, 10);

    final zonasImportadas = await ZonaDemandaRepository(destino).obtenerPorProyecto(nuevoProyectoId);
    expect(zonasImportadas, hasLength(1));
    expect(zonasImportadas.single.etiqueta, 'Zona 1');
    expect(zonasImportadas.single.numeroClientes, 1);

    final clienteZonaImportada = await ClienteZonaRepository(destino).obtenerPorZona(zonasImportadas.single.id!);
    expect(clienteZonaImportada, hasLength(1));
    expect(clienteZonaImportada.single.clienteId, clientesImportados.single.id);

    final candidatosImportados = await SitioCandidatoRepository(destino).obtenerPorProyecto(nuevoProyectoId);
    expect(candidatosImportados, hasLength(1));
    expect(candidatosImportados.single.nombre, 'Candidato 1');
    expect(candidatosImportados.single.esRedActual, true);

    final plantasImportadas = await PlantaRepository(destino).obtenerPorProyecto(nuevoProyectoId);
    expect(plantasImportadas, hasLength(1));
    expect(plantasImportadas.single.nombre, 'Planta 1');

    final parametrosImportados = await ParametrosCostoRepository(destino).obtenerPorProyecto(nuevoProyectoId);
    expect(parametrosImportados, isNotNull);
    expect(parametrosImportados!.tarifaEntradaFijaCent, 100);
    expect(parametrosImportados.tipoEstandar, 'distancia');

    final celdasImportadas = await CeldaMatrizRepository(destino).obtenerPorProyecto(nuevoProyectoId);
    expect(celdasImportadas, hasLength(3));
    final celdaCandidato = celdasImportadas.firstWhere((c) => c.tipoOrigen == 'candidato');
    expect(celdaCandidato.origenId, candidatosImportados.single.id);
    expect(celdaCandidato.destinoId, zonasImportadas.single.id);
    expect(celdaCandidato.distanciaMetros, 1000);
    final celdaPlantaZona = celdasImportadas.firstWhere((c) => c.tipoOrigen == 'planta' && c.tipoDestino == 'zona');
    expect(celdaPlantaZona.origenId, plantasImportadas.single.id);
    expect(celdaPlantaZona.destinoId, zonasImportadas.single.id);
    expect(celdaPlantaZona.fuente, 'haversine');
    final celdaPlantaCandidato = celdasImportadas.firstWhere(
      (c) => c.tipoOrigen == 'planta' && c.tipoDestino == 'candidato',
    );
    expect(celdaPlantaCandidato.origenId, plantasImportadas.single.id);
    expect(celdaPlantaCandidato.destinoId, candidatosImportados.single.id);
    expect(celdaPlantaCandidato.distanciaMetros, 3000);

    final escenariosImportados = await EscenarioRepository(destino).obtenerPorProyecto(nuevoProyectoId);
    expect(escenariosImportados, hasLength(1));
    final escenarioImportado = escenariosImportados.single;
    expect(escenarioImportado.nombre, 'Escenario 1');
    expect(escenarioImportado.pFijo, 1);
    expect(escenarioImportado.restriccionCapacidadActiva, true);
    expect(escenarioImportado.costoTotalCent, 900000);
    expect(escenarioImportado.notas, 'nota de prueba');

    final almacenesImportados = await EscenarioAlmacenRepository(destino).obtenerPorEscenario(escenarioImportado.id!);
    expect(almacenesImportados, hasLength(1));
    expect(almacenesImportados.single.sitioCandidatoId, candidatosImportados.single.id);
    expect(almacenesImportados.single.volumenAsignado, 10);

    final asignacionesImportadas = await EscenarioAsignacionRepository(
      destino,
    ).obtenerPorEscenario(escenarioImportado.id!);
    expect(asignacionesImportadas, hasLength(1));
    expect(asignacionesImportadas.single.zonaId, zonasImportadas.single.id);
    expect(asignacionesImportadas.single.sitioCandidatoId, candidatosImportados.single.id);

    final costosImportados = await EscenarioCostoRepository(destino).obtenerPorEscenario(escenarioImportado.id!);
    expect(costosImportados, hasLength(1));
    expect(costosImportados.single.rubro, 'fijo');
    expect(costosImportados.single.montoCent, 1000);

    final puntosImportados = await PuntoCurvaRepository(destino).obtenerPorEscenario(escenarioImportado.id!);
    expect(puntosImportados, hasLength(1));
    expect(puntosImportados.single.costoPorRubroJson, '{"fijo":1000}');

    final memoriaImportada = await MemoriaCalculoRepository(destino).obtenerPorEscenario(escenarioImportado.id!);
    expect(memoriaImportada, hasLength(1));
    expect(memoriaImportada.single.formula, 'costo = fijo');
    expect(memoriaImportada.single.salida, '1000');

    await origen.close();
    await destino.close();
  });

  test('fromJsonString rechaza un archivo de versión más nueva que la actual', () {
    final json =
        '{"version": 999, "nombre": "x", "moneda": "PEN", "unidadPeso": "toneladas", '
        '"horizonteAnios": 5, "factorCircuidad": 1.3, "creadoEn": "x", "clientes": [], '
        '"zonas": [], "asignacionesClienteZona": [], "sitiosCandidatos": [], "plantas": [], '
        '"parametrosCosto": null, "celdasMatriz": [], "escenarios": []}';
    expect(() => ProyectoRedPortable.fromJsonString(json), throwsFormatException);
  });

  test('fromJsonString rechaza un archivo sin campo version', () {
    expect(() => ProyectoRedPortable.fromJsonString('{"nombre": "x"}'), throwsFormatException);
  });

  test('fromJsonString rechaza JSON inválido', () {
    expect(() => ProyectoRedPortable.fromJsonString('no es json'), throwsFormatException);
  });
}
