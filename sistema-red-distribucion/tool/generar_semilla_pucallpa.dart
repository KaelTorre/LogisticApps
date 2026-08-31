// Fase 9 (CLAUDE.md sección 9): "Caso de estudio precargado con
// coordenadas reales verificadas por el usuario y caché de distancias
// poblada." Este script corre UNA sola vez, con red real, y escribe el
// resultado completo (proyecto + clientes + zonas + candidatos + planta +
// parámetros de costo + matriz de distancias YA calculada) a
// `assets/seed/semilla_pucallpa.json` — el arranque real de la app
// (`lib/data/seed/sembrar_caso_estudio.dart`) solo lee ese archivo
// estático, nunca vuelve a llamar a OSRM. Así el Test Z ("la optimización
// corre de punta a punta sin ninguna petición de red") no depende de
// replicar por fuera el hash privado de caché de `OsrmClient`: la matriz ya
// queda persistida como `celda_matriz` con `fuente = 'osrm'`, lista para
// que M6/M8 la lean directo de la base.
//
// Uso (requiere red real, ~10-15 peticiones a OSRM con el mismo espaciado
// de 1 req/seg que ya exige OsrmClient):
//   flutter test tool/generar_semilla_pucallpa.dart
// (no `dart run`: `database.dart` depende de `drift_flutter`, que a su vez
// depende del framework de Flutter — mismo motivo por el que este archivo
// no es un script de Dart puro como `tool/verificar_limite_osrm.dart`.)
import 'dart:io';

import 'package:drift/native.dart';
import 'package:paquete_geo_logistica/paquete_geo_logistica.dart';
import 'package:sistema_red_distribucion/core/constantes.dart';
import 'package:sistema_red_distribucion/core/pucallpa_dataset_red.dart';
import 'package:sistema_red_distribucion/data/local/cache_ruteo_drift.dart';
import 'package:sistema_red_distribucion/data/local/database.dart';
import 'package:sistema_red_distribucion/data/models/cliente.dart';
import 'package:sistema_red_distribucion/data/models/cliente_zona.dart';
import 'package:sistema_red_distribucion/data/models/parametros_costo.dart';
import 'package:sistema_red_distribucion/data/models/planta.dart';
import 'package:sistema_red_distribucion/data/models/proyecto.dart';
import 'package:sistema_red_distribucion/data/models/sitio_candidato.dart';
import 'package:sistema_red_distribucion/data/models/zona_demanda.dart';
import 'package:sistema_red_distribucion/data/repositories/celda_matriz_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/cliente_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/cliente_zona_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/parametros_costo_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/planta_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/proyecto_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/sitio_candidato_repository.dart';
import 'package:sistema_red_distribucion/data/repositories/zona_demanda_repository.dart';
import 'package:sistema_red_distribucion/domain/export/exportar_importar_proyecto.dart';
import 'package:sistema_red_distribucion/domain/motor/m1_agregacion.dart';
import 'package:sistema_red_distribucion/domain/motor/m2_centro_gravedad.dart';
import 'package:sistema_red_distribucion/domain/motor/m3_matriz_distancias.dart';

// k de M1 (zonas) y p de M2 (candidatos): valores elegidos para que el caso
// de estudio ejercite de verdad la agregación y la sugerencia de centro de
// gravedad (no triviales) sin volverse una matriz tan grande que tarde
// minutos contra el servidor demo de OSRM.
const _kZonas = 8;
const _pCandidatos = 4;

Future<void> main() async {
  HttpOverrides.global = TrustedRootsHttpOverrides();
  final database = AppDatabase(NativeDatabase.memory());
  final osrmClient = OsrmClient(cache: CacheRuteoDrift(database));

  stdout.writeln('Sembrando proyecto y datos maestros...');
  final proyectoId = await ProyectoRepository(database).crear(
    Proyecto(
      nombre: 'Pucallpa (caso de estudio)',
      moneda: 'PEN',
      unidadPeso: 'kilogramos',
      horizonteAnios: 5,
      factorCircuidad: 1.30,
      creadoEn: DateTime.now().toIso8601String(),
    ),
  );

  final plantaId = await PlantaRepository(database).crear(
    Planta(
      proyectoId: proyectoId,
      nombre: plantaPucallpa.nombre,
      latitud: plantaPucallpa.latitud,
      longitud: plantaPucallpa.longitud,
      capacidadAnual: 500000,
      costoProduccionCentPorUnidad: 50,
    ),
  );

  final clienteRepo = ClienteRepository(database);
  final clientesInsertados = <Cliente>[];
  for (final p in puntosPucallpa) {
    final id = await clienteRepo.crear(
      Cliente(
        proyectoId: proyectoId,
        nombre: p.nombre,
        latitud: p.latitud,
        longitud: p.longitud,
        // Ver docs/fuentes_datos.md: escalado semana→año (×52), asunción
        // explícita, no un dato medido — mismo criterio que el proyecto de
        // Unidad 3 ya documentaba para este mismo valor.
        demandaAnual: p.demandaKgSemana * 52,
        pedidosAnuales: 52,
      ),
    );
    clientesInsertados.add((await clienteRepo.obtenerPorProyecto(proyectoId)).firstWhere((c) => c.id == id));
  }

  stdout.writeln('Corriendo M1 (agregación en $_kZonas zonas)...');
  final zonasAgregadas = agregarEnZonas(clientes: clientesInsertados, k: _kZonas);
  final zonaRepo = ZonaDemandaRepository(database);
  final clienteZonaRepo = ClienteZonaRepository(database);
  final zonasInsertadas = <ZonaDemanda>[];
  for (final z in zonasAgregadas) {
    final zonaId = await zonaRepo.crear(
      ZonaDemanda(
        proyectoId: proyectoId,
        etiqueta: 'Zona ${zonasInsertadas.length + 1}',
        latitud: z.latitud,
        longitud: z.longitud,
        demandaAgregada: z.demandaAgregada,
        pedidosAgregados: z.pedidosAgregados,
        numeroClientes: z.numeroClientes,
        errorAgregacionMetros: z.errorAgregacionMetros,
      ),
    );
    await clienteZonaRepo.insertarTodas(
      z.clienteIds.map((clienteId) => ClienteZona(clienteId: clienteId, zonaId: zonaId)).toList(),
    );
    zonasInsertadas.add((await zonaRepo.obtenerPorProyecto(proyectoId)).firstWhere((zz) => zz.id == zonaId));
  }

  stdout.writeln('Corriendo M2 (sugerencia de $_pCandidatos candidatos por centro de gravedad)...');
  const tarifaSalidaGenericaCentPorKmTon = 50;
  final candidatosGravedad = generarCandidatosPorCentroGravedad(
    zonas: zonasInsertadas,
    tarifaCentPorKmTon: tarifaSalidaGenericaCentPorKmTon.toDouble(),
    p: _pCandidatos,
  );
  final candidatoRepo = SitioCandidatoRepository(database);
  final candidatosInsertados = <SitioCandidato>[];
  for (var i = 0; i < candidatosGravedad.length; i++) {
    final c = candidatosGravedad[i];
    final id = await candidatoRepo.crear(
      SitioCandidato(
        proyectoId: proyectoId,
        nombre: 'Candidato ${i + 1} (centro de gravedad)',
        latitud: c.latitud,
        longitud: c.longitud,
        // Valores genéricos plausibles, sin fuente real — documentado en
        // docs/fuentes_datos.md (CLAUDE.md, notas de desarrollo Fase 9: "no
        // se presentan como datos reales de ninguna empresa").
        costoFijoAnualCent: 8000000,
        capacidadAnual: 300000,
        costoVariableManejoCentPorUnidad: 15,
        origen: 'centro_gravedad',
      ),
    );
    candidatosInsertados.add((await candidatoRepo.obtenerPorProyecto(proyectoId)).firstWhere((cc) => cc.id == id));
  }

  await ParametrosCostoRepository(database).guardar(
    ParametrosCosto(
      proyectoId: proyectoId,
      tarifaEntradaFijaCent: 5000,
      tarifaEntradaCentPorKmTon: 40,
      tarifaSalidaFijaCent: 3000,
      tarifaSalidaCentPorKmTon: tarifaSalidaGenericaCentPorKmTon,
      tasaManejoInventarioAnual: 0.25,
      valorPorUnidadCent: 200000,
      inventarioBaseUnaUbicacion: 5000,
      costoPorPedidoCent: 1500,
      tipoEstandar: 'tiempo',
      estandarServicioValor: 3600 * 4, // 4 horas
    ),
  );

  stdout.writeln('Consultando OSRM real para planta -> candidatos y candidatos -> zonas (~1 req/seg)...');
  final celdaRepo = CeldaMatrizRepository(database);

  final celdasPlantaCandidato = await construirMatriz(
    proyectoId: proyectoId,
    origenes: [OrigenMatriz(tipo: 'planta', id: plantaId, latitud: plantaPucallpa.latitud, longitud: plantaPucallpa.longitud)],
    destinos: candidatosInsertados
        .map((c) => DestinoMatriz(id: c.id!, latitud: c.latitud, longitud: c.longitud, tipo: 'candidato'))
        .toList(),
    celdasExistentes: const [],
    factorCircuidad: 1.30,
    cliente: osrmClient,
    maxCoordenadasPorConsulta: maxCoordenadasPorConsulta,
    onProgreso: (p) => stdout.writeln('  planta->candidatos: ${p.bloquesCompletados}/${p.bloquesTotales} bloques'),
  );
  await celdaRepo.insertarTodas(celdasPlantaCandidato);

  final celdasCandidatoZona = await construirMatriz(
    proyectoId: proyectoId,
    origenes: candidatosInsertados
        .map((c) => OrigenMatriz(tipo: 'candidato', id: c.id!, latitud: c.latitud, longitud: c.longitud))
        .toList(),
    destinos: zonasInsertadas.map((z) => DestinoMatriz(id: z.id!, latitud: z.latitud, longitud: z.longitud)).toList(),
    celdasExistentes: const [],
    factorCircuidad: 1.30,
    cliente: osrmClient,
    maxCoordenadasPorConsulta: maxCoordenadasPorConsulta,
    onProgreso: (p) => stdout.writeln('  candidatos->zonas: ${p.bloquesCompletados}/${p.bloquesTotales} bloques'),
  );
  await celdaRepo.insertarTodas(celdasCandidatoZona);

  final celdasOsrm = [...celdasPlantaCandidato, ...celdasCandidatoZona].where((c) => c.fuente == 'osrm').length;
  final celdasTotal = celdasPlantaCandidato.length + celdasCandidatoZona.length;
  stdout.writeln('Matriz poblada: $celdasOsrm/$celdasTotal celdas con fuente=osrm.');
  if (celdasOsrm != celdasTotal) {
    stdout.writeln(
      'ADVERTENCIA: no todas las celdas vinieron de OSRM real (¿se cayó la red a mitad de camino? '
      'revisar antes de congelar la semilla, el Test Z exige fuente=osrm en todo).',
    );
  }

  stdout.writeln('Exportando el proyecto completo a JSON...');
  final portable = await exportarProyecto(proyectoId, database);
  final archivoSalida = File('assets/seed/semilla_pucallpa.json');
  await archivoSalida.create(recursive: true);
  await archivoSalida.writeAsString(portable.toJsonString());

  stdout.writeln('Listo: ${archivoSalida.path}');
  stdout.writeln(
    'Resumen: ${clientesInsertados.length} clientes, ${zonasInsertadas.length} zonas, '
    '${candidatosInsertados.length} candidatos, 1 planta, $celdasTotal celdas de matriz.',
  );

  osrmClient.dispose();
  await database.close();
}
