import 'dart:convert';

import '../../data/local/database.dart';
import '../../data/models/accion_tomada.dart';
import '../../data/models/diagnostico_organizacional.dart';
import '../../data/models/escenario_sintetico.dart';
import '../../data/models/evaluacion.dart';
import '../../data/models/factura_transporte.dart';
import '../../data/models/indicador.dart';
import '../../data/models/medicion.dart';
import '../../data/models/memoria_evaluacion.dart';
import '../../data/models/organizacion.dart';
import '../../data/models/periodo.dart';
import '../../data/models/presupuesto.dart';
import '../../data/models/verificacion_accion.dart';
import '../../data/repositories/accion_catalogo_repository.dart';
import '../../data/repositories/accion_tomada_repository.dart';
import '../../data/repositories/diagnostico_organizacional_repository.dart';
import '../../data/repositories/escenario_sintetico_repository.dart';
import '../../data/repositories/evaluacion_repository.dart';
import '../../data/repositories/factura_transporte_repository.dart';
import '../../data/repositories/indicador_repository.dart';
import '../../data/repositories/medicion_repository.dart';
import '../../data/repositories/memoria_evaluacion_repository.dart';
import '../../data/repositories/organizacion_repository.dart';
import '../../data/repositories/periodo_repository.dart';
import '../../data/repositories/presupuesto_repository.dart';
import '../../data/repositories/regla_patron_repository.dart';
import '../../data/repositories/verificacion_accion_repository.dart';

/// Ida y vuelta en JSON de una organización completa (Pantalla 22,
/// CLAUDE.md Fase 9, Test U): exportar produce un archivo de texto que se
/// puede volver a importar -- en esta u otra instalación -- reconstruyendo
/// exactamente los mismos datos.
///
/// [REGLA] `regla_patron` (global, las seis reglas de sistema) y
/// `accion_catalogo` (global, la biblioteca de acciones) no viajan en
/// este archivo: no son datos de la organización, son catálogo -- ya
/// están sembrados en cualquier instalación del sistema (`main.dart` los
/// siembra al arrancar si faltan). Las referencias hacia ellos
/// (`memoria_evaluacion.reglaId`, `accion_tomada.accionCatalogoId`) se
/// exportan por su `codigo` (estable entre instalaciones) y se resuelven
/// contra el catálogo del destino al importar, nunca por el id numérico
/// crudo (que puede no coincidir entre bases de datos distintas).
///
/// Solo cubre reglas de sistema *globales* (`indicadorId == null`); si en
/// el futuro existiera una pantalla para crear reglas personalizadas por
/// indicador, esta exportación tendría que ampliarse para incluirlas --
/// hoy ninguna pantalla las crea, así que no existen datos de ese tipo
/// que perder.
const _versionActual = 1;

class OrganizacionPortable {
  const OrganizacionPortable({
    required this.version,
    required this.organizacion,
    required this.periodos,
    required this.indicadores,
    required this.mediciones,
    required this.evaluaciones,
    required this.memoriasEvaluacion,
    required this.presupuestos,
    required this.escenariosSinteticos,
    required this.diagnosticos,
    required this.facturas,
    required this.accionesTomadas,
    required this.verificaciones,
  });

  final int version;
  final Organizacion organizacion;
  final List<Periodo> periodos;
  final List<Indicador> indicadores;
  final List<Medicion> mediciones;
  final List<Evaluacion> evaluaciones;

  /// Cada entrada trae `evaluacionId` (id **antiguo**, se remapea al
  /// importar) y `reglaCodigo` en vez de `reglaId`.
  final List<({int evaluacionId, String reglaCodigo, MemoriaEvaluacion memoria})> memoriasEvaluacion;
  final List<Presupuesto> presupuestos;
  final List<EscenarioSintetico> escenariosSinteticos;
  final List<DiagnosticoOrganizacional> diagnosticos;
  final List<FacturaTransporte> facturas;

  /// Cada entrada trae `evaluacionId` (id antiguo) y `accionCodigo` en
  /// vez de `accionCatalogoId`.
  final List<({int evaluacionId, String accionCodigo, AccionTomada accion})> accionesTomadas;

  /// Cada entrada trae `accionTomadaId` (id antiguo, se remapea).
  final List<({int accionTomadaId, VerificacionAccion verificacion})> verificaciones;

  String toJsonString() => jsonEncode(_aMapa(this));

  static OrganizacionPortable fromJsonString(String texto) {
    final mapa = jsonDecode(texto) as Map<String, dynamic>;
    final version = mapa['version'] as int;
    if (version > _versionActual) {
      throw FormatException(
        'Este archivo fue exportado por una versión más nueva del sistema '
        '(versión $version; esta instalación entiende hasta la versión '
        '$_versionActual). Actualiza la aplicación antes de importarlo.',
      );
    }
    return _deMapa(mapa);
  }
}

Map<String, dynamic> _aMapa(OrganizacionPortable p) => {
  'version': p.version,
  'organizacion': _organizacionAMapa(p.organizacion),
  'periodos': p.periodos.map(_periodoAMapa).toList(),
  'indicadores': p.indicadores.map(_indicadorAMapa).toList(),
  'mediciones': p.mediciones.map(_medicionAMapa).toList(),
  'evaluaciones': p.evaluaciones.map(_evaluacionAMapa).toList(),
  'memoriasEvaluacion': [
    for (final m in p.memoriasEvaluacion)
      {'evaluacionId': m.evaluacionId, 'reglaCodigo': m.reglaCodigo, ..._memoriaAMapa(m.memoria)},
  ],
  'presupuestos': p.presupuestos.map(_presupuestoAMapa).toList(),
  'escenariosSinteticos': p.escenariosSinteticos.map(_escenarioAMapa).toList(),
  'diagnosticos': p.diagnosticos.map(_diagnosticoAMapa).toList(),
  'facturas': p.facturas.map(_facturaAMapa).toList(),
  'accionesTomadas': [
    for (final a in p.accionesTomadas)
      {'evaluacionId': a.evaluacionId, 'accionCodigo': a.accionCodigo, ..._accionTomadaAMapa(a.accion)},
  ],
  'verificaciones': [
    for (final v in p.verificaciones)
      {'accionTomadaId': v.accionTomadaId, ..._verificacionAMapa(v.verificacion)},
  ],
};

OrganizacionPortable _deMapa(Map<String, dynamic> mapa) {
  List<T> lista<T>(String clave, T Function(Map<String, dynamic>) desde) =>
      (mapa[clave] as List).map((e) => desde(e as Map<String, dynamic>)).toList();

  return OrganizacionPortable(
    version: mapa['version'] as int,
    organizacion: _organizacionDeMapa(mapa['organizacion'] as Map<String, dynamic>),
    periodos: lista('periodos', _periodoDeMapa),
    indicadores: lista('indicadores', _indicadorDeMapa),
    mediciones: lista('mediciones', _medicionDeMapa),
    evaluaciones: lista('evaluaciones', _evaluacionDeMapa),
    memoriasEvaluacion: [
      for (final m in mapa['memoriasEvaluacion'] as List)
        (
          evaluacionId: (m as Map<String, dynamic>)['evaluacionId'] as int,
          reglaCodigo: m['reglaCodigo'] as String,
          memoria: _memoriaDeMapa(m),
        ),
    ],
    presupuestos: lista('presupuestos', _presupuestoDeMapa),
    escenariosSinteticos: lista('escenariosSinteticos', _escenarioDeMapa),
    diagnosticos: lista('diagnosticos', _diagnosticoDeMapa),
    facturas: lista('facturas', _facturaDeMapa),
    accionesTomadas: [
      for (final a in mapa['accionesTomadas'] as List)
        (
          evaluacionId: (a as Map<String, dynamic>)['evaluacionId'] as int,
          accionCodigo: a['accionCodigo'] as String,
          accion: _accionTomadaDeMapa(a),
        ),
    ],
    verificaciones: [
      for (final v in mapa['verificaciones'] as List)
        (accionTomadaId: (v as Map<String, dynamic>)['accionTomadaId'] as int, verificacion: _verificacionDeMapa(v)),
    ],
  );
}

// ─── Organizacion ───
Map<String, dynamic> _organizacionAMapa(Organizacion o) => {
  'nombre': o.nombre,
  'moneda': o.moneda,
  'tipoEmpresa': o.tipoEmpresa,
  'notas': o.notas,
};
Organizacion _organizacionDeMapa(Map<String, dynamic> m) => Organizacion(
  nombre: m['nombre'] as String,
  moneda: m['moneda'] as String,
  tipoEmpresa: m['tipoEmpresa'] as String,
  notas: m['notas'] as String?,
);

// ─── Periodo ───
Map<String, dynamic> _periodoAMapa(Periodo p) => {
  'id': p.id,
  'orden': p.orden,
  'etiqueta': p.etiqueta,
  'fechaInicio': p.fechaInicio,
  'fechaFin': p.fechaFin,
  'granularidad': p.granularidad,
  'esSimulado': p.esSimulado,
};
Periodo _periodoDeMapa(Map<String, dynamic> m) => Periodo(
  id: m['id'] as int,
  organizacionId: 0,
  orden: m['orden'] as int,
  etiqueta: m['etiqueta'] as String,
  fechaInicio: m['fechaInicio'] as String,
  fechaFin: m['fechaFin'] as String,
  granularidad: m['granularidad'] as String,
  esSimulado: m['esSimulado'] as bool,
);

// ─── Indicador ───
Map<String, dynamic> _indicadorAMapa(Indicador i) => {
  'id': i.id,
  'codigo': i.codigo,
  'nombre': i.nombre,
  'categoria': i.categoria,
  'unidad': i.unidad,
  'decimales': i.decimales,
  'sentido': i.sentido,
  'meta': i.meta,
  'bandaInferior': i.bandaInferior,
  'bandaSuperior': i.bandaSuperior,
  'granularidad': i.granularidad,
  'proceso': i.proceso,
  'activo': i.activo,
};
Indicador _indicadorDeMapa(Map<String, dynamic> m) => Indicador(
  id: m['id'] as int,
  organizacionId: 0,
  codigo: m['codigo'] as String,
  nombre: m['nombre'] as String,
  categoria: m['categoria'] as String,
  unidad: m['unidad'] as String,
  decimales: m['decimales'] as int,
  sentido: m['sentido'] as String,
  meta: (m['meta'] as num).toDouble(),
  bandaInferior: (m['bandaInferior'] as num).toDouble(),
  bandaSuperior: (m['bandaSuperior'] as num).toDouble(),
  granularidad: m['granularidad'] as String,
  proceso: m['proceso'] as String,
  activo: m['activo'] as bool,
);

// ─── Medicion ───
Map<String, dynamic> _medicionAMapa(Medicion x) => {
  'indicadorId': x.indicadorId,
  'periodoId': x.periodoId,
  'valor': x.valor,
  'origen': x.origen,
  'nota': x.nota,
};
Medicion _medicionDeMapa(Map<String, dynamic> m) => Medicion(
  indicadorId: m['indicadorId'] as int,
  periodoId: m['periodoId'] as int,
  valor: (m['valor'] as num).toDouble(),
  origen: m['origen'] as String,
  nota: m['nota'] as String?,
);

// ─── Evaluacion ───
Map<String, dynamic> _evaluacionAMapa(Evaluacion e) => {
  'id': e.id,
  'indicadorId': e.indicadorId,
  'periodoId': e.periodoId,
  'estado': e.estado,
  'clasificacion': e.clasificacion,
  'reglasDisparadasJson': e.reglasDisparadasJson,
  'severidadCalculada': e.severidadCalculada,
};
Evaluacion _evaluacionDeMapa(Map<String, dynamic> m) => Evaluacion(
  id: m['id'] as int,
  indicadorId: m['indicadorId'] as int,
  periodoId: m['periodoId'] as int,
  estado: m['estado'] as String,
  clasificacion: m['clasificacion'] as String,
  reglasDisparadasJson: m['reglasDisparadasJson'] as String,
  severidadCalculada: (m['severidadCalculada'] as num).toDouble(),
);

// ─── MemoriaEvaluacion ───
Map<String, dynamic> _memoriaAMapa(MemoriaEvaluacion x) => {
  'resultado': x.resultado,
  'valoresEntradaJson': x.valoresEntradaJson,
  'explicacion': x.explicacion,
};
MemoriaEvaluacion _memoriaDeMapa(Map<String, dynamic> m) => MemoriaEvaluacion(
  evaluacionId: 0,
  reglaId: 0,
  resultado: m['resultado'] as String,
  valoresEntradaJson: m['valoresEntradaJson'] as String,
  explicacion: m['explicacion'] as String,
);

// ─── Presupuesto ───
Map<String, dynamic> _presupuestoAMapa(Presupuesto p) => {
  'rubro': p.rubro,
  'periodoId': p.periodoId,
  'montoPresupuestadoCent': p.montoPresupuestadoCent,
  'montoRealCent': p.montoRealCent,
};
Presupuesto _presupuestoDeMapa(Map<String, dynamic> m) => Presupuesto(
  organizacionId: 0,
  rubro: m['rubro'] as String,
  periodoId: m['periodoId'] as int,
  montoPresupuestadoCent: m['montoPresupuestadoCent'] as int,
  montoRealCent: m['montoRealCent'] as int,
);

// ─── EscenarioSintetico ───
Map<String, dynamic> _escenarioAMapa(EscenarioSintetico e) => {
  'nombre': e.nombre,
  'indicadorBaseId': e.indicadorBaseId,
  'patron': e.patron,
  'parametrosJson': e.parametrosJson,
  'semilla': e.semilla,
  'numeroPeriodos': e.numeroPeriodos,
};
EscenarioSintetico _escenarioDeMapa(Map<String, dynamic> m) => EscenarioSintetico(
  nombre: m['nombre'] as String,
  indicadorBaseId: m['indicadorBaseId'] as int,
  patron: m['patron'] as String,
  parametrosJson: m['parametrosJson'] as String,
  semilla: m['semilla'] as int,
  numeroPeriodos: m['numeroPeriodos'] as int,
);

// ─── DiagnosticoOrganizacional ───
Map<String, dynamic> _diagnosticoAMapa(DiagnosticoOrganizacional d) => {
  'fecha': d.fecha,
  'respuestasJson': d.respuestasJson,
  'etapaResultante': d.etapaResultante,
  'opcionOrganizacional': d.opcionOrganizacional,
  'ejesJson': d.ejesJson,
  'orientacionDominante': d.orientacionDominante,
};
DiagnosticoOrganizacional _diagnosticoDeMapa(Map<String, dynamic> m) => DiagnosticoOrganizacional(
  organizacionId: 0,
  fecha: m['fecha'] as String,
  respuestasJson: m['respuestasJson'] as String,
  etapaResultante: m['etapaResultante'] as String,
  opcionOrganizacional: m['opcionOrganizacional'] as String,
  ejesJson: m['ejesJson'] as String,
  orientacionDominante: m['orientacionDominante'] as String,
);

// ─── FacturaTransporte ───
Map<String, dynamic> _facturaAMapa(FacturaTransporte f) => {
  'numero': f.numero,
  'transportista': f.transportista,
  'peso': f.peso,
  'ruta': f.ruta,
  'tarifaAplicadaCent': f.tarifaAplicadaCent,
  'tarifaContratadaCent': f.tarifaContratadaCent,
  'discrepanciaTipo': f.discrepanciaTipo,
  'montoRecuperableCent': f.montoRecuperableCent,
  'estado': f.estado,
};
FacturaTransporte _facturaDeMapa(Map<String, dynamic> m) => FacturaTransporte(
  organizacionId: 0,
  numero: m['numero'] as String,
  transportista: m['transportista'] as String,
  peso: (m['peso'] as num).toDouble(),
  ruta: m['ruta'] as String,
  tarifaAplicadaCent: m['tarifaAplicadaCent'] as int,
  tarifaContratadaCent: m['tarifaContratadaCent'] as int,
  discrepanciaTipo: m['discrepanciaTipo'] as String?,
  montoRecuperableCent: m['montoRecuperableCent'] as int,
  estado: m['estado'] as String,
);

// ─── AccionTomada ───
Map<String, dynamic> _accionTomadaAMapa(AccionTomada a) => {
  'id': a.id,
  'responsable': a.responsable,
  'fechaCompromiso': a.fechaCompromiso,
  'estado': a.estado,
  'notas': a.notas,
  'fechaRegistro': a.fechaRegistro,
};
AccionTomada _accionTomadaDeMapa(Map<String, dynamic> m) => AccionTomada(
  id: m['id'] as int,
  evaluacionId: 0,
  accionCatalogoId: 0,
  responsable: m['responsable'] as String,
  fechaCompromiso: m['fechaCompromiso'] as String,
  estado: m['estado'] as String,
  notas: m['notas'] as String?,
  fechaRegistro: m['fechaRegistro'] as String,
);

// ─── VerificacionAccion ───
Map<String, dynamic> _verificacionAMapa(VerificacionAccion v) => {
  'periodoVerificacionId': v.periodoVerificacionId,
  'resultado': v.resultado,
  'valorObservado': v.valorObservado,
  'comentario': v.comentario,
  'confirmadoPorUsuario': v.confirmadoPorUsuario,
};
VerificacionAccion _verificacionDeMapa(Map<String, dynamic> m) => VerificacionAccion(
  accionTomadaId: 0,
  periodoVerificacionId: m['periodoVerificacionId'] as int,
  resultado: m['resultado'] as String,
  valorObservado: (m['valorObservado'] as num).toDouble(),
  comentario: m['comentario'] as String?,
  confirmadoPorUsuario: m['confirmadoPorUsuario'] as bool,
);

/// Reúne toda la información de una organización desde la base real.
Future<OrganizacionPortable> exportarOrganizacion(AppDatabase database, int organizacionId) async {
  final organizacion = (await OrganizacionRepository(
    database,
  ).obtenerTodas()).firstWhere((o) => o.id == organizacionId);
  final periodos = await PeriodoRepository(database).obtenerPorOrganizacion(organizacionId);
  final indicadores = await IndicadorRepository(database).obtenerPorOrganizacion(organizacionId);

  final medicionRepo = MedicionRepository(database);
  final evaluacionRepo = EvaluacionRepository(database);
  final memoriaRepo = MemoriaEvaluacionRepository(database);
  final accionTomadaRepo = AccionTomadaRepository(database);
  final verificacionRepo = VerificacionAccionRepository(database);
  final reglaPatronRepo = ReglaPatronRepository(database);
  final accionCatalogoRepo = AccionCatalogoRepository(database);

  final reglasPorId = {for (final r in await reglaPatronRepo.obtenerTodas()) r.id!: r.codigo};
  final accionesPorId = {for (final a in await accionCatalogoRepo.obtenerTodas()) a.id!: a.codigo};

  final mediciones = <Medicion>[];
  final evaluaciones = <Evaluacion>[];
  final memoriasEvaluacion = <({int evaluacionId, String reglaCodigo, MemoriaEvaluacion memoria})>[];
  final accionesTomadas = <({int evaluacionId, String accionCodigo, AccionTomada accion})>[];
  final verificaciones = <({int accionTomadaId, VerificacionAccion verificacion})>[];

  for (final indicador in indicadores) {
    mediciones.addAll(await medicionRepo.obtenerPorIndicador(indicador.id!));

    final evaluacionesDelIndicador = await evaluacionRepo.obtenerPorIndicador(indicador.id!);
    evaluaciones.addAll(evaluacionesDelIndicador);

    for (final evaluacion in evaluacionesDelIndicador) {
      for (final memoria in await memoriaRepo.obtenerPorEvaluacion(evaluacion.id!)) {
        final reglaCodigo = reglasPorId[memoria.reglaId];
        if (reglaCodigo == null) {
          throw StateError('La regla con id ${memoria.reglaId} no existe en el catálogo -- dato inconsistente.');
        }
        memoriasEvaluacion.add((evaluacionId: evaluacion.id!, reglaCodigo: reglaCodigo, memoria: memoria));
      }
      for (final accion in await accionTomadaRepo.obtenerPorEvaluacion(evaluacion.id!)) {
        final accionCodigo = accionesPorId[accion.accionCatalogoId];
        if (accionCodigo == null) {
          throw StateError(
            'La acción con id ${accion.accionCatalogoId} no existe en el catálogo -- dato inconsistente.',
          );
        }
        accionesTomadas.add((evaluacionId: evaluacion.id!, accionCodigo: accionCodigo, accion: accion));
        for (final verificacion in await verificacionRepo.obtenerPorAccionTomada(accion.id!)) {
          verificaciones.add((accionTomadaId: accion.id!, verificacion: verificacion));
        }
      }
    }
  }

  final idsIndicadores = indicadores.map((i) => i.id!).toSet();
  final escenariosSinteticos = (await EscenarioSinteticoRepository(
    database,
  ).obtenerTodos()).where((e) => idsIndicadores.contains(e.indicadorBaseId)).toList();

  return OrganizacionPortable(
    version: _versionActual,
    organizacion: organizacion,
    periodos: periodos,
    indicadores: indicadores,
    mediciones: mediciones,
    evaluaciones: evaluaciones,
    memoriasEvaluacion: memoriasEvaluacion,
    presupuestos: await PresupuestoRepository(database).obtenerPorOrganizacion(organizacionId),
    escenariosSinteticos: escenariosSinteticos,
    diagnosticos: await DiagnosticoOrganizacionalRepository(database).obtenerPorOrganizacion(organizacionId),
    facturas: await FacturaTransporteRepository(database).obtenerPorOrganizacion(organizacionId),
    accionesTomadas: accionesTomadas,
    verificaciones: verificaciones,
  );
}

/// Reconstruye una organización completa a partir de [portable],
/// insertándola como una organización **nueva** -- remapea cada id
/// antiguo de periodo/indicador/evaluación/acción tomada al id real que
/// asigna esta base de datos, y resuelve `reglaCodigo`/`accionCodigo`
/// contra el catálogo global ya sembrado en este destino. Devuelve el id
/// de la organización creada.
Future<int> importarOrganizacion(OrganizacionPortable portable, AppDatabase database) async {
  final organizacionRepo = OrganizacionRepository(database);
  final periodoRepo = PeriodoRepository(database);
  final indicadorRepo = IndicadorRepository(database);
  final medicionRepo = MedicionRepository(database);
  final evaluacionRepo = EvaluacionRepository(database);
  final memoriaRepo = MemoriaEvaluacionRepository(database);
  final accionTomadaRepo = AccionTomadaRepository(database);
  final verificacionRepo = VerificacionAccionRepository(database);
  final presupuestoRepo = PresupuestoRepository(database);
  final escenarioRepo = EscenarioSinteticoRepository(database);
  final diagnosticoRepo = DiagnosticoOrganizacionalRepository(database);
  final facturaRepo = FacturaTransporteRepository(database);
  final reglaPatronRepo = ReglaPatronRepository(database);
  final accionCatalogoRepo = AccionCatalogoRepository(database);

  final reglaIdPorCodigo = {for (final r in await reglaPatronRepo.obtenerTodas()) r.codigo: r.id!};
  final accionIdPorCodigo = {for (final a in await accionCatalogoRepo.obtenerTodas()) a.codigo: a.id!};

  final nuevaOrganizacionId = await organizacionRepo.crear(portable.organizacion);

  final periodoIdNuevo = <int, int>{};
  for (final periodo in portable.periodos) {
    periodoIdNuevo[periodo.id!] = await periodoRepo.crear(
      periodo.copyWith(organizacionId: nuevaOrganizacionId),
    );
  }

  final indicadorIdNuevo = <int, int>{};
  for (final indicador in portable.indicadores) {
    indicadorIdNuevo[indicador.id!] = await indicadorRepo.crear(
      indicador.copyWith(organizacionId: nuevaOrganizacionId),
    );
  }

  for (final medicion in portable.mediciones) {
    await medicionRepo.crear(
      Medicion(
        indicadorId: indicadorIdNuevo[medicion.indicadorId]!,
        periodoId: periodoIdNuevo[medicion.periodoId]!,
        valor: medicion.valor,
        origen: medicion.origen,
        nota: medicion.nota,
      ),
    );
  }

  final evaluacionIdNuevo = <int, int>{};
  for (final evaluacion in portable.evaluaciones) {
    evaluacionIdNuevo[evaluacion.id!] = await evaluacionRepo.crear(
      Evaluacion(
        indicadorId: indicadorIdNuevo[evaluacion.indicadorId]!,
        periodoId: periodoIdNuevo[evaluacion.periodoId]!,
        estado: evaluacion.estado,
        clasificacion: evaluacion.clasificacion,
        reglasDisparadasJson: evaluacion.reglasDisparadasJson,
        severidadCalculada: evaluacion.severidadCalculada,
      ),
    );
  }

  for (final entrada in portable.memoriasEvaluacion) {
    final reglaId = reglaIdPorCodigo[entrada.reglaCodigo];
    if (reglaId == null) {
      throw FormatException(
        'La regla "${entrada.reglaCodigo}" no existe en el catálogo de esta instalación.',
      );
    }
    await memoriaRepo.crear(
      MemoriaEvaluacion(
        evaluacionId: evaluacionIdNuevo[entrada.evaluacionId]!,
        reglaId: reglaId,
        resultado: entrada.memoria.resultado,
        valoresEntradaJson: entrada.memoria.valoresEntradaJson,
        explicacion: entrada.memoria.explicacion,
      ),
    );
  }

  final accionTomadaIdNuevo = <int, int>{};
  for (final entrada in portable.accionesTomadas) {
    final accionCatalogoId = accionIdPorCodigo[entrada.accionCodigo];
    if (accionCatalogoId == null) {
      throw FormatException(
        'La acción "${entrada.accionCodigo}" no existe en el catálogo de esta instalación.',
      );
    }
    accionTomadaIdNuevo[entrada.accion.id!] = await accionTomadaRepo.crear(
      AccionTomada(
        evaluacionId: evaluacionIdNuevo[entrada.evaluacionId]!,
        accionCatalogoId: accionCatalogoId,
        responsable: entrada.accion.responsable,
        fechaCompromiso: entrada.accion.fechaCompromiso,
        estado: entrada.accion.estado,
        notas: entrada.accion.notas,
        fechaRegistro: entrada.accion.fechaRegistro,
      ),
    );
  }

  for (final entrada in portable.verificaciones) {
    await verificacionRepo.crear(
      VerificacionAccion(
        accionTomadaId: accionTomadaIdNuevo[entrada.accionTomadaId]!,
        periodoVerificacionId: periodoIdNuevo[entrada.verificacion.periodoVerificacionId]!,
        resultado: entrada.verificacion.resultado,
        valorObservado: entrada.verificacion.valorObservado,
        comentario: entrada.verificacion.comentario,
        confirmadoPorUsuario: entrada.verificacion.confirmadoPorUsuario,
      ),
    );
  }

  for (final presupuesto in portable.presupuestos) {
    await presupuestoRepo.crear(
      presupuesto.copyWith(organizacionId: nuevaOrganizacionId, periodoId: periodoIdNuevo[presupuesto.periodoId]!),
    );
  }

  for (final escenario in portable.escenariosSinteticos) {
    await escenarioRepo.crear(
      escenario.copyWith(indicadorBaseId: indicadorIdNuevo[escenario.indicadorBaseId]!),
    );
  }

  for (final diagnostico in portable.diagnosticos) {
    await diagnosticoRepo.crear(diagnostico.copyWith(organizacionId: nuevaOrganizacionId));
  }

  for (final factura in portable.facturas) {
    await facturaRepo.crear(factura.copyWith(organizacionId: nuevaOrganizacionId));
  }

  return nuevaOrganizacionId;
}
