import '../../data/local/database.dart';
import '../../data/repositories/celda_matriz_repository.dart';
import '../../data/repositories/cliente_repository.dart';
import '../../data/repositories/cliente_zona_repository.dart';
import '../../data/repositories/escenario_almacen_repository.dart';
import '../../data/repositories/escenario_asignacion_repository.dart';
import '../../data/repositories/escenario_costo_repository.dart';
import '../../data/repositories/escenario_repository.dart';
import '../../data/repositories/memoria_calculo_repository.dart';
import '../../data/repositories/parametros_costo_repository.dart';
import '../../data/repositories/planta_repository.dart';
import '../../data/repositories/proyecto_repository.dart';
import '../../data/repositories/punto_curva_repository.dart';
import '../../data/repositories/sitio_candidato_repository.dart';
import '../../data/repositories/zona_demanda_repository.dart';
import '../../data/models/escenario.dart';
import '../../data/models/escenario_almacen.dart';
import '../../data/models/escenario_asignacion.dart';
import '../../data/models/escenario_costo.dart';
import '../../data/models/cliente.dart';
import '../../data/models/cliente_zona.dart';
import '../../data/models/celda_matriz.dart';
import '../../data/models/memoria_calculo.dart';
import '../../data/models/parametros_costo.dart';
import '../../data/models/planta.dart';
import '../../data/models/proyecto.dart';
import '../../data/models/punto_curva.dart';
import '../../data/models/sitio_candidato.dart';
import '../../data/models/zona_demanda.dart';
import 'proyecto_red_portable.dart';

/// Lee las 14 tablas propias de [proyectoId] desde [database] y arma el
/// `ProyectoRedPortable` completo (ver comentario del archivo hermano sobre
/// por qué las referencias cruzadas viajan como índice, no como id).
Future<ProyectoRedPortable> exportarProyecto(int proyectoId, AppDatabase database) async {
  final proyecto = await ProyectoRepository(database).obtenerPorId(proyectoId);
  if (proyecto == null) {
    throw ArgumentError('No existe el proyecto $proyectoId.');
  }

  final clientes = await ClienteRepository(database).obtenerPorProyecto(proyectoId);
  final zonas = await ZonaDemandaRepository(database).obtenerPorProyecto(proyectoId);
  final candidatos = await SitioCandidatoRepository(database).obtenerPorProyecto(proyectoId);
  final plantas = await PlantaRepository(database).obtenerPorProyecto(proyectoId);
  final parametros = await ParametrosCostoRepository(database).obtenerPorProyecto(proyectoId);
  final celdas = await CeldaMatrizRepository(database).obtenerPorProyecto(proyectoId);
  final escenarios = await EscenarioRepository(database).obtenerPorProyecto(proyectoId);

  final indiceCliente = {for (var i = 0; i < clientes.length; i++) clientes[i].id!: i};
  final indiceZona = {for (var i = 0; i < zonas.length; i++) zonas[i].id!: i};
  final indiceCandidato = {for (var i = 0; i < candidatos.length; i++) candidatos[i].id!: i};
  final indicePlanta = {for (var i = 0; i < plantas.length; i++) plantas[i].id!: i};

  final clienteZonaRepo = ClienteZonaRepository(database);
  final asignacionesClienteZona = <AsignacionClienteZonaPortable>[];
  for (final zona in zonas) {
    final filas = await clienteZonaRepo.obtenerPorZona(zona.id!);
    for (final fila in filas) {
      asignacionesClienteZona.add(
        AsignacionClienteZonaPortable(
          clienteIndice: indiceCliente[fila.clienteId]!,
          zonaIndice: indiceZona[zona.id!]!,
        ),
      );
    }
  }

  final escenarioAlmacenRepo = EscenarioAlmacenRepository(database);
  final escenarioAsignacionRepo = EscenarioAsignacionRepository(database);
  final escenarioCostoRepo = EscenarioCostoRepository(database);
  final puntoCurvaRepo = PuntoCurvaRepository(database);
  final memoriaRepo = MemoriaCalculoRepository(database);

  final escenariosPortable = <EscenarioRedPortable>[];
  for (final escenario in escenarios) {
    final almacenes = await escenarioAlmacenRepo.obtenerPorEscenario(escenario.id!);
    final asignaciones = await escenarioAsignacionRepo.obtenerPorEscenario(escenario.id!);
    final costos = await escenarioCostoRepo.obtenerPorEscenario(escenario.id!);
    final puntos = await puntoCurvaRepo.obtenerPorEscenario(escenario.id!);
    final memoria = await memoriaRepo.obtenerPorEscenario(escenario.id!);

    escenariosPortable.add(
      EscenarioRedPortable(
        nombre: escenario.nombre,
        metodo: escenario.metodo,
        pFijo: escenario.pFijo,
        restriccionCapacidadActiva: escenario.restriccionCapacidadActiva,
        costoTotalCent: escenario.costoTotalCent,
        fecha: escenario.fecha,
        notas: escenario.notas,
        almacenes: almacenes
            .map(
              (a) => EscenarioAlmacenPortable(
                sitioCandidatoIndice: indiceCandidato[a.sitioCandidatoId]!,
                volumenAsignado: a.volumenAsignado,
                costoFijoCent: a.costoFijoCent,
                costoManejoCent: a.costoManejoCent,
              ),
            )
            .toList(),
        asignaciones: asignaciones
            .map(
              (a) => EscenarioAsignacionPortable(
                zonaIndice: indiceZona[a.zonaId]!,
                sitioCandidatoIndice: indiceCandidato[a.sitioCandidatoId]!,
                distanciaMetros: a.distanciaMetros,
                duracionSegundos: a.duracionSegundos,
                costoSalidaCent: a.costoSalidaCent,
              ),
            )
            .toList(),
        costos: costos.map((c) => EscenarioCostoPortable(rubro: c.rubro, montoCent: c.montoCent)).toList(),
        puntosCurva: puntos
            .map(
              (p) => PuntoCurvaPortable(
                numeroAlmacenes: p.numeroAlmacenes,
                costoTotalCent: p.costoTotalCent,
                costoPorRubroJson: p.costoPorRubroJson,
                viableSegunServicio: p.viableSegunServicio,
              ),
            )
            .toList(),
        memoria: memoria
            .map(
              (m) => MemoriaCalculoPortable(
                orden: m.orden,
                modulo: m.modulo,
                formula: m.formula,
                entradasJson: m.entradasJson,
                salida: m.salida,
                unidad: m.unidad,
              ),
            )
            .toList(),
      ),
    );
  }

  return ProyectoRedPortable(
    version: ProyectoRedPortable.versionActual,
    nombre: proyecto.nombre,
    moneda: proyecto.moneda,
    unidadPeso: proyecto.unidadPeso,
    horizonteAnios: proyecto.horizonteAnios,
    factorCircuidad: proyecto.factorCircuidad,
    creadoEn: proyecto.creadoEn,
    clientes: clientes
        .map(
          (c) => ClienteRedPortable(
            nombre: c.nombre,
            latitud: c.latitud,
            longitud: c.longitud,
            demandaAnual: c.demandaAnual,
            pedidosAnuales: c.pedidosAnuales,
            activo: c.activo,
          ),
        )
        .toList(),
    zonas: zonas
        .map(
          (z) => ZonaRedPortable(
            etiqueta: z.etiqueta,
            latitud: z.latitud,
            longitud: z.longitud,
            demandaAgregada: z.demandaAgregada,
            pedidosAgregados: z.pedidosAgregados,
            numeroClientes: z.numeroClientes,
            errorAgregacionMetros: z.errorAgregacionMetros,
          ),
        )
        .toList(),
    asignacionesClienteZona: asignacionesClienteZona,
    sitiosCandidatos: candidatos
        .map(
          (s) => SitioCandidatoRedPortable(
            nombre: s.nombre,
            latitud: s.latitud,
            longitud: s.longitud,
            costoFijoAnualCent: s.costoFijoAnualCent,
            capacidadAnual: s.capacidadAnual,
            costoVariableManejoCentPorUnidad: s.costoVariableManejoCentPorUnidad,
            origen: s.origen,
            esRedActual: s.esRedActual,
          ),
        )
        .toList(),
    plantas: plantas
        .map(
          (p) => PlantaRedPortable(
            nombre: p.nombre,
            latitud: p.latitud,
            longitud: p.longitud,
            capacidadAnual: p.capacidadAnual,
            costoProduccionCentPorUnidad: p.costoProduccionCentPorUnidad,
          ),
        )
        .toList(),
    parametrosCosto: parametros == null
        ? null
        : ParametrosCostoRedPortable(
            tarifaEntradaFijaCent: parametros.tarifaEntradaFijaCent,
            tarifaEntradaCentPorKmTon: parametros.tarifaEntradaCentPorKmTon,
            tarifaSalidaFijaCent: parametros.tarifaSalidaFijaCent,
            tarifaSalidaCentPorKmTon: parametros.tarifaSalidaCentPorKmTon,
            tasaManejoInventarioAnual: parametros.tasaManejoInventarioAnual,
            valorPorUnidadCent: parametros.valorPorUnidadCent,
            inventarioBaseUnaUbicacion: parametros.inventarioBaseUnaUbicacion,
            costoPorPedidoCent: parametros.costoPorPedidoCent,
            tipoEstandar: parametros.tipoEstandar,
            estandarServicioValor: parametros.estandarServicioValor,
          ),
    celdasMatriz: celdas
        .map(
          (c) => CeldaMatrizRedPortable(
            tipoOrigen: c.tipoOrigen,
            origenIndice: c.tipoOrigen == 'planta' ? indicePlanta[c.origenId]! : indiceCandidato[c.origenId]!,
            tipoDestino: c.tipoDestino,
            destinoIndice: c.tipoDestino == 'candidato' ? indiceCandidato[c.destinoId]! : indiceZona[c.destinoId]!,
            distanciaMetros: c.distanciaMetros,
            duracionSegundos: c.duracionSegundos,
            fuente: c.fuente,
          ),
        )
        .toList(),
    escenarios: escenariosPortable,
  );
}

/// Inserta [portable] como un proyecto nuevo en [database] y devuelve el id
/// asignado. Resuelve cada índice contra el id real que le tocó a esa fila
/// en esta base (que puede no ser el mismo que en la base de origen).
Future<int> importarProyecto(ProyectoRedPortable portable, AppDatabase database) async {
  final proyectoId = await ProyectoRepository(database).crear(
    Proyecto(
      nombre: portable.nombre,
      moneda: portable.moneda,
      unidadPeso: portable.unidadPeso,
      horizonteAnios: portable.horizonteAnios,
      factorCircuidad: portable.factorCircuidad,
      creadoEn: portable.creadoEn,
    ),
  );

  final clienteRepo = ClienteRepository(database);
  final idsCliente = <int>[];
  for (final c in portable.clientes) {
    idsCliente.add(
      await clienteRepo.crear(
        Cliente(
          proyectoId: proyectoId,
          nombre: c.nombre,
          latitud: c.latitud,
          longitud: c.longitud,
          demandaAnual: c.demandaAnual,
          pedidosAnuales: c.pedidosAnuales,
          activo: c.activo,
        ),
      ),
    );
  }

  final zonaRepo = ZonaDemandaRepository(database);
  final idsZona = <int>[];
  for (final z in portable.zonas) {
    idsZona.add(
      await zonaRepo.crear(
        ZonaDemanda(
          proyectoId: proyectoId,
          etiqueta: z.etiqueta,
          latitud: z.latitud,
          longitud: z.longitud,
          demandaAgregada: z.demandaAgregada,
          pedidosAgregados: z.pedidosAgregados,
          numeroClientes: z.numeroClientes,
          errorAgregacionMetros: z.errorAgregacionMetros,
        ),
      ),
    );
  }

  await ClienteZonaRepository(database).insertarTodas(
    portable.asignacionesClienteZona
        .map(
          (a) => ClienteZona(
            clienteId: idsCliente[a.clienteIndice],
            zonaId: idsZona[a.zonaIndice],
          ),
        )
        .toList(),
  );

  final candidatoRepo = SitioCandidatoRepository(database);
  final idsCandidato = <int>[];
  for (final s in portable.sitiosCandidatos) {
    idsCandidato.add(
      await candidatoRepo.crear(
        SitioCandidato(
          proyectoId: proyectoId,
          nombre: s.nombre,
          latitud: s.latitud,
          longitud: s.longitud,
          costoFijoAnualCent: s.costoFijoAnualCent,
          capacidadAnual: s.capacidadAnual,
          costoVariableManejoCentPorUnidad: s.costoVariableManejoCentPorUnidad,
          origen: s.origen,
          esRedActual: s.esRedActual,
        ),
      ),
    );
  }

  final plantaRepo = PlantaRepository(database);
  final idsPlanta = <int>[];
  for (final p in portable.plantas) {
    idsPlanta.add(
      await plantaRepo.crear(
        Planta(
          proyectoId: proyectoId,
          nombre: p.nombre,
          latitud: p.latitud,
          longitud: p.longitud,
          capacidadAnual: p.capacidadAnual,
          costoProduccionCentPorUnidad: p.costoProduccionCentPorUnidad,
        ),
      ),
    );
  }

  final parametros = portable.parametrosCosto;
  if (parametros != null) {
    await ParametrosCostoRepository(database).guardar(
      ParametrosCosto(
        proyectoId: proyectoId,
        tarifaEntradaFijaCent: parametros.tarifaEntradaFijaCent,
        tarifaEntradaCentPorKmTon: parametros.tarifaEntradaCentPorKmTon,
        tarifaSalidaFijaCent: parametros.tarifaSalidaFijaCent,
        tarifaSalidaCentPorKmTon: parametros.tarifaSalidaCentPorKmTon,
        tasaManejoInventarioAnual: parametros.tasaManejoInventarioAnual,
        valorPorUnidadCent: parametros.valorPorUnidadCent,
        inventarioBaseUnaUbicacion: parametros.inventarioBaseUnaUbicacion,
        costoPorPedidoCent: parametros.costoPorPedidoCent,
        tipoEstandar: parametros.tipoEstandar,
        estandarServicioValor: parametros.estandarServicioValor,
      ),
    );
  }

  await CeldaMatrizRepository(database).insertarTodas(
    portable.celdasMatriz
        .map(
          (c) => CeldaMatriz(
            proyectoId: proyectoId,
            tipoOrigen: c.tipoOrigen,
            origenId: c.tipoOrigen == 'planta' ? idsPlanta[c.origenIndice] : idsCandidato[c.origenIndice],
            tipoDestino: c.tipoDestino,
            destinoId: c.tipoDestino == 'candidato' ? idsCandidato[c.destinoIndice] : idsZona[c.destinoIndice],
            distanciaMetros: c.distanciaMetros,
            duracionSegundos: c.duracionSegundos,
            fuente: c.fuente,
          ),
        )
        .toList(),
  );

  final escenarioRepo = EscenarioRepository(database);
  final escenarioAlmacenRepo = EscenarioAlmacenRepository(database);
  final escenarioAsignacionRepo = EscenarioAsignacionRepository(database);
  final escenarioCostoRepo = EscenarioCostoRepository(database);
  final puntoCurvaRepo = PuntoCurvaRepository(database);
  final memoriaRepo = MemoriaCalculoRepository(database);

  for (final e in portable.escenarios) {
    final escenarioId = await escenarioRepo.crear(
      Escenario(
        proyectoId: proyectoId,
        nombre: e.nombre,
        metodo: e.metodo,
        pFijo: e.pFijo,
        restriccionCapacidadActiva: e.restriccionCapacidadActiva,
        costoTotalCent: e.costoTotalCent,
        fecha: e.fecha,
        notas: e.notas,
      ),
    );

    await escenarioAlmacenRepo.insertarTodos(
      e.almacenes
          .map(
            (a) => EscenarioAlmacen(
              escenarioId: escenarioId,
              sitioCandidatoId: idsCandidato[a.sitioCandidatoIndice],
              volumenAsignado: a.volumenAsignado,
              costoFijoCent: a.costoFijoCent,
              costoManejoCent: a.costoManejoCent,
            ),
          )
          .toList(),
    );

    await escenarioAsignacionRepo.insertarTodas(
      e.asignaciones
          .map(
            (a) => EscenarioAsignacion(
              escenarioId: escenarioId,
              zonaId: idsZona[a.zonaIndice],
              sitioCandidatoId: idsCandidato[a.sitioCandidatoIndice],
              distanciaMetros: a.distanciaMetros,
              duracionSegundos: a.duracionSegundos,
              costoSalidaCent: a.costoSalidaCent,
            ),
          )
          .toList(),
    );

    await escenarioCostoRepo.insertarTodos(
      e.costos.map((c) => EscenarioCosto(escenarioId: escenarioId, rubro: c.rubro, montoCent: c.montoCent)).toList(),
    );

    await puntoCurvaRepo.insertarTodos(
      e.puntosCurva
          .map(
            (p) => PuntoCurva(
              escenarioId: escenarioId,
              numeroAlmacenes: p.numeroAlmacenes,
              costoTotalCent: p.costoTotalCent,
              costoPorRubroJson: p.costoPorRubroJson,
              viableSegunServicio: p.viableSegunServicio,
            ),
          )
          .toList(),
    );

    await memoriaRepo.insertarTodas(
      e.memoria
          .map(
            (m) => MemoriaCalculo(
              escenarioId: escenarioId,
              orden: m.orden,
              modulo: m.modulo,
              formula: m.formula,
              entradasJson: m.entradasJson,
              salida: m.salida,
              unidad: m.unidad,
            ),
          )
          .toList(),
    );
  }

  return proyectoId;
}
