import 'dart:convert';

/// Proyecto portable (CLAUDE.md Fase 9): el proyecto completo — las 14
/// tablas propias de un proyecto (todo excepto `cache_ruteo`, que no cuelga
/// de `proyectoId` y ya se trata aparte incluso en el borrado en cascada de
/// la Fase 1) — serializado a JSON para poder abrirlo en otra máquina.
///
/// Mismo contrato que `ProyectoPortable` de la Unidad 4: `version` con
/// rechazo de versiones futuras, `FormatException` con mensaje humano en
/// vez de un crash. A diferencia de ese proyecto (que solo tiene un
/// registro de configuración + catálogo), acá hay listas anidadas con
/// referencias cruzadas (zona → clientes, escenario → almacenes/
/// asignaciones/costos/memoria) — los ids autoincrement de origen no
/// sirven en el destino (la base nueva les asigna otros), así que todas las
/// referencias viajan como **índice dentro de su propia lista**, no como
/// id, y quien importa las resuelve contra los ids nuevos que le devuelve
/// cada inserción.
class ProyectoRedPortable {
  const ProyectoRedPortable({
    required this.version,
    required this.nombre,
    required this.moneda,
    required this.unidadPeso,
    required this.horizonteAnios,
    required this.factorCircuidad,
    required this.creadoEn,
    required this.clientes,
    required this.zonas,
    required this.asignacionesClienteZona,
    required this.sitiosCandidatos,
    required this.plantas,
    required this.parametrosCosto,
    required this.celdasMatriz,
    required this.escenarios,
  });

  static const versionActual = 1;

  final int version;
  final String nombre;
  final String moneda;
  final String unidadPeso;
  final int horizonteAnios;
  final double factorCircuidad;
  final String creadoEn;
  final List<ClienteRedPortable> clientes;
  final List<ZonaRedPortable> zonas;
  final List<AsignacionClienteZonaPortable> asignacionesClienteZona;
  final List<SitioCandidatoRedPortable> sitiosCandidatos;
  final List<PlantaRedPortable> plantas;
  final ParametrosCostoRedPortable? parametrosCosto;
  final List<CeldaMatrizRedPortable> celdasMatriz;
  final List<EscenarioRedPortable> escenarios;

  String toJsonString() => const JsonEncoder.withIndent('  ').convert(_toMap());

  Map<String, dynamic> _toMap() => {
    'version': version,
    'nombre': nombre,
    'moneda': moneda,
    'unidadPeso': unidadPeso,
    'horizonteAnios': horizonteAnios,
    'factorCircuidad': factorCircuidad,
    'creadoEn': creadoEn,
    'clientes': clientes.map((c) => c.toJson()).toList(),
    'zonas': zonas.map((z) => z.toJson()).toList(),
    'asignacionesClienteZona': asignacionesClienteZona.map((a) => a.toJson()).toList(),
    'sitiosCandidatos': sitiosCandidatos.map((s) => s.toJson()).toList(),
    'plantas': plantas.map((p) => p.toJson()).toList(),
    'parametrosCosto': parametrosCosto?.toJson(),
    'celdasMatriz': celdasMatriz.map((c) => c.toJson()).toList(),
    'escenarios': escenarios.map((e) => e.toJson()).toList(),
  };

  factory ProyectoRedPortable.fromJsonString(String contenido) {
    final Map<String, dynamic> map;
    try {
      map = jsonDecode(contenido) as Map<String, dynamic>;
    } on FormatException {
      throw const FormatException('El archivo no es JSON válido.');
    }

    final version = map['version'] as int?;
    if (version == null) {
      throw const FormatException('El archivo no tiene campo "version": no es un proyecto portable.');
    }
    if (version > versionActual) {
      throw FormatException(
        'Este proyecto se exportó con una versión más nueva ($version) que la '
        'que esta app entiende ($versionActual). Actualiza la app.',
      );
    }

    try {
      return ProyectoRedPortable(
        version: version,
        nombre: map['nombre'] as String,
        moneda: map['moneda'] as String,
        unidadPeso: map['unidadPeso'] as String,
        horizonteAnios: map['horizonteAnios'] as int,
        factorCircuidad: (map['factorCircuidad'] as num).toDouble(),
        creadoEn: map['creadoEn'] as String,
        clientes: (map['clientes'] as List)
            .map((m) => ClienteRedPortable.fromJson(m as Map<String, dynamic>))
            .toList(),
        zonas: (map['zonas'] as List).map((m) => ZonaRedPortable.fromJson(m as Map<String, dynamic>)).toList(),
        asignacionesClienteZona: (map['asignacionesClienteZona'] as List)
            .map((m) => AsignacionClienteZonaPortable.fromJson(m as Map<String, dynamic>))
            .toList(),
        sitiosCandidatos: (map['sitiosCandidatos'] as List)
            .map((m) => SitioCandidatoRedPortable.fromJson(m as Map<String, dynamic>))
            .toList(),
        plantas: (map['plantas'] as List).map((m) => PlantaRedPortable.fromJson(m as Map<String, dynamic>)).toList(),
        parametrosCosto: map['parametrosCosto'] == null
            ? null
            : ParametrosCostoRedPortable.fromJson(map['parametrosCosto'] as Map<String, dynamic>),
        celdasMatriz: (map['celdasMatriz'] as List)
            .map((m) => CeldaMatrizRedPortable.fromJson(m as Map<String, dynamic>))
            .toList(),
        escenarios: (map['escenarios'] as List)
            .map((m) => EscenarioRedPortable.fromJson(m as Map<String, dynamic>))
            .toList(),
      );
    } on TypeError {
      throw const FormatException('El archivo tiene la forma de un proyecto portable pero le faltan o le sobran campos.');
    }
  }
}

class ClienteRedPortable {
  const ClienteRedPortable({
    required this.nombre,
    required this.latitud,
    required this.longitud,
    required this.demandaAnual,
    required this.pedidosAnuales,
    required this.activo,
  });

  final String nombre;
  final double latitud;
  final double longitud;
  final double demandaAnual;
  final int pedidosAnuales;
  final bool activo;

  Map<String, dynamic> toJson() => {
    'nombre': nombre,
    'latitud': latitud,
    'longitud': longitud,
    'demandaAnual': demandaAnual,
    'pedidosAnuales': pedidosAnuales,
    'activo': activo,
  };

  factory ClienteRedPortable.fromJson(Map<String, dynamic> m) => ClienteRedPortable(
    nombre: m['nombre'] as String,
    latitud: (m['latitud'] as num).toDouble(),
    longitud: (m['longitud'] as num).toDouble(),
    demandaAnual: (m['demandaAnual'] as num).toDouble(),
    pedidosAnuales: m['pedidosAnuales'] as int,
    activo: m['activo'] as bool,
  );
}

class ZonaRedPortable {
  const ZonaRedPortable({
    required this.etiqueta,
    required this.latitud,
    required this.longitud,
    required this.demandaAgregada,
    required this.pedidosAgregados,
    required this.numeroClientes,
    required this.errorAgregacionMetros,
  });

  final String etiqueta;
  final double latitud;
  final double longitud;
  final double demandaAgregada;
  final int pedidosAgregados;
  final int numeroClientes;
  final int errorAgregacionMetros;

  Map<String, dynamic> toJson() => {
    'etiqueta': etiqueta,
    'latitud': latitud,
    'longitud': longitud,
    'demandaAgregada': demandaAgregada,
    'pedidosAgregados': pedidosAgregados,
    'numeroClientes': numeroClientes,
    'errorAgregacionMetros': errorAgregacionMetros,
  };

  factory ZonaRedPortable.fromJson(Map<String, dynamic> m) => ZonaRedPortable(
    etiqueta: m['etiqueta'] as String,
    latitud: (m['latitud'] as num).toDouble(),
    longitud: (m['longitud'] as num).toDouble(),
    demandaAgregada: (m['demandaAgregada'] as num).toDouble(),
    pedidosAgregados: m['pedidosAgregados'] as int,
    numeroClientes: m['numeroClientes'] as int,
    errorAgregacionMetros: m['errorAgregacionMetros'] as int,
  );
}

class AsignacionClienteZonaPortable {
  const AsignacionClienteZonaPortable({required this.clienteIndice, required this.zonaIndice});

  final int clienteIndice;
  final int zonaIndice;

  Map<String, dynamic> toJson() => {'clienteIndice': clienteIndice, 'zonaIndice': zonaIndice};

  factory AsignacionClienteZonaPortable.fromJson(Map<String, dynamic> m) =>
      AsignacionClienteZonaPortable(clienteIndice: m['clienteIndice'] as int, zonaIndice: m['zonaIndice'] as int);
}

class SitioCandidatoRedPortable {
  const SitioCandidatoRedPortable({
    required this.nombre,
    required this.latitud,
    required this.longitud,
    required this.costoFijoAnualCent,
    required this.capacidadAnual,
    required this.costoVariableManejoCentPorUnidad,
    required this.origen,
    required this.esRedActual,
  });

  final String nombre;
  final double latitud;
  final double longitud;
  final int costoFijoAnualCent;
  final double capacidadAnual;
  final int costoVariableManejoCentPorUnidad;
  final String origen;
  final bool esRedActual;

  Map<String, dynamic> toJson() => {
    'nombre': nombre,
    'latitud': latitud,
    'longitud': longitud,
    'costoFijoAnualCent': costoFijoAnualCent,
    'capacidadAnual': capacidadAnual,
    'costoVariableManejoCentPorUnidad': costoVariableManejoCentPorUnidad,
    'origen': origen,
    'esRedActual': esRedActual,
  };

  factory SitioCandidatoRedPortable.fromJson(Map<String, dynamic> m) => SitioCandidatoRedPortable(
    nombre: m['nombre'] as String,
    latitud: (m['latitud'] as num).toDouble(),
    longitud: (m['longitud'] as num).toDouble(),
    costoFijoAnualCent: m['costoFijoAnualCent'] as int,
    capacidadAnual: (m['capacidadAnual'] as num).toDouble(),
    costoVariableManejoCentPorUnidad: m['costoVariableManejoCentPorUnidad'] as int,
    origen: m['origen'] as String,
    esRedActual: m['esRedActual'] as bool,
  );
}

class PlantaRedPortable {
  const PlantaRedPortable({
    required this.nombre,
    required this.latitud,
    required this.longitud,
    required this.capacidadAnual,
    required this.costoProduccionCentPorUnidad,
  });

  final String nombre;
  final double latitud;
  final double longitud;
  final double capacidadAnual;
  final int costoProduccionCentPorUnidad;

  Map<String, dynamic> toJson() => {
    'nombre': nombre,
    'latitud': latitud,
    'longitud': longitud,
    'capacidadAnual': capacidadAnual,
    'costoProduccionCentPorUnidad': costoProduccionCentPorUnidad,
  };

  factory PlantaRedPortable.fromJson(Map<String, dynamic> m) => PlantaRedPortable(
    nombre: m['nombre'] as String,
    latitud: (m['latitud'] as num).toDouble(),
    longitud: (m['longitud'] as num).toDouble(),
    capacidadAnual: (m['capacidadAnual'] as num).toDouble(),
    costoProduccionCentPorUnidad: m['costoProduccionCentPorUnidad'] as int,
  );
}

class ParametrosCostoRedPortable {
  const ParametrosCostoRedPortable({
    required this.tarifaEntradaFijaCent,
    required this.tarifaEntradaCentPorKmTon,
    required this.tarifaSalidaFijaCent,
    required this.tarifaSalidaCentPorKmTon,
    required this.tasaManejoInventarioAnual,
    required this.valorPorUnidadCent,
    required this.inventarioBaseUnaUbicacion,
    required this.costoPorPedidoCent,
    required this.tipoEstandar,
    required this.estandarServicioValor,
  });

  final int tarifaEntradaFijaCent;
  final int tarifaEntradaCentPorKmTon;
  final int tarifaSalidaFijaCent;
  final int tarifaSalidaCentPorKmTon;
  final double tasaManejoInventarioAnual;
  final int valorPorUnidadCent;
  final double inventarioBaseUnaUbicacion;
  final int costoPorPedidoCent;
  final String tipoEstandar;
  final int estandarServicioValor;

  Map<String, dynamic> toJson() => {
    'tarifaEntradaFijaCent': tarifaEntradaFijaCent,
    'tarifaEntradaCentPorKmTon': tarifaEntradaCentPorKmTon,
    'tarifaSalidaFijaCent': tarifaSalidaFijaCent,
    'tarifaSalidaCentPorKmTon': tarifaSalidaCentPorKmTon,
    'tasaManejoInventarioAnual': tasaManejoInventarioAnual,
    'valorPorUnidadCent': valorPorUnidadCent,
    'inventarioBaseUnaUbicacion': inventarioBaseUnaUbicacion,
    'costoPorPedidoCent': costoPorPedidoCent,
    'tipoEstandar': tipoEstandar,
    'estandarServicioValor': estandarServicioValor,
  };

  factory ParametrosCostoRedPortable.fromJson(Map<String, dynamic> m) => ParametrosCostoRedPortable(
    tarifaEntradaFijaCent: m['tarifaEntradaFijaCent'] as int,
    tarifaEntradaCentPorKmTon: m['tarifaEntradaCentPorKmTon'] as int,
    tarifaSalidaFijaCent: m['tarifaSalidaFijaCent'] as int,
    tarifaSalidaCentPorKmTon: m['tarifaSalidaCentPorKmTon'] as int,
    tasaManejoInventarioAnual: (m['tasaManejoInventarioAnual'] as num).toDouble(),
    valorPorUnidadCent: m['valorPorUnidadCent'] as int,
    inventarioBaseUnaUbicacion: (m['inventarioBaseUnaUbicacion'] as num).toDouble(),
    costoPorPedidoCent: m['costoPorPedidoCent'] as int,
    tipoEstandar: m['tipoEstandar'] as String,
    estandarServicioValor: m['estandarServicioValor'] as int,
  );
}

/// [origenIndice] indexa dentro de `plantas` o `sitiosCandidatos` según
/// [tipoOrigen] (`'planta'` | `'candidato'`); [destinoIndice] indexa
/// `zonas` (`tipoDestino` es siempre `'zona'` hoy, igual que en la tabla
/// real — se conserva el campo por si un futuro módulo agrega otro tipo).
class CeldaMatrizRedPortable {
  const CeldaMatrizRedPortable({
    required this.tipoOrigen,
    required this.origenIndice,
    required this.tipoDestino,
    required this.destinoIndice,
    required this.distanciaMetros,
    required this.duracionSegundos,
    required this.fuente,
  });

  final String tipoOrigen;
  final int origenIndice;
  final String tipoDestino;
  final int destinoIndice;
  final int distanciaMetros;
  final int duracionSegundos;
  final String fuente;

  Map<String, dynamic> toJson() => {
    'tipoOrigen': tipoOrigen,
    'origenIndice': origenIndice,
    'tipoDestino': tipoDestino,
    'destinoIndice': destinoIndice,
    'distanciaMetros': distanciaMetros,
    'duracionSegundos': duracionSegundos,
    'fuente': fuente,
  };

  factory CeldaMatrizRedPortable.fromJson(Map<String, dynamic> m) => CeldaMatrizRedPortable(
    tipoOrigen: m['tipoOrigen'] as String,
    origenIndice: m['origenIndice'] as int,
    tipoDestino: m['tipoDestino'] as String,
    destinoIndice: m['destinoIndice'] as int,
    distanciaMetros: m['distanciaMetros'] as int,
    duracionSegundos: m['duracionSegundos'] as int,
    fuente: m['fuente'] as String,
  );
}

class EscenarioRedPortable {
  const EscenarioRedPortable({
    required this.nombre,
    required this.metodo,
    required this.pFijo,
    required this.restriccionCapacidadActiva,
    required this.costoTotalCent,
    required this.fecha,
    required this.notas,
    required this.almacenes,
    required this.asignaciones,
    required this.costos,
    required this.puntosCurva,
    required this.memoria,
  });

  final String nombre;
  final String metodo;
  final int? pFijo;
  final bool restriccionCapacidadActiva;
  final int costoTotalCent;
  final String fecha;
  final String? notas;
  final List<EscenarioAlmacenPortable> almacenes;
  final List<EscenarioAsignacionPortable> asignaciones;
  final List<EscenarioCostoPortable> costos;
  final List<PuntoCurvaPortable> puntosCurva;
  final List<MemoriaCalculoPortable> memoria;

  Map<String, dynamic> toJson() => {
    'nombre': nombre,
    'metodo': metodo,
    'pFijo': pFijo,
    'restriccionCapacidadActiva': restriccionCapacidadActiva,
    'costoTotalCent': costoTotalCent,
    'fecha': fecha,
    'notas': notas,
    'almacenes': almacenes.map((a) => a.toJson()).toList(),
    'asignaciones': asignaciones.map((a) => a.toJson()).toList(),
    'costos': costos.map((c) => c.toJson()).toList(),
    'puntosCurva': puntosCurva.map((p) => p.toJson()).toList(),
    'memoria': memoria.map((f) => f.toJson()).toList(),
  };

  factory EscenarioRedPortable.fromJson(Map<String, dynamic> m) => EscenarioRedPortable(
    nombre: m['nombre'] as String,
    metodo: m['metodo'] as String,
    pFijo: m['pFijo'] as int?,
    restriccionCapacidadActiva: m['restriccionCapacidadActiva'] as bool,
    costoTotalCent: m['costoTotalCent'] as int,
    fecha: m['fecha'] as String,
    notas: m['notas'] as String?,
    almacenes: (m['almacenes'] as List)
        .map((x) => EscenarioAlmacenPortable.fromJson(x as Map<String, dynamic>))
        .toList(),
    asignaciones: (m['asignaciones'] as List)
        .map((x) => EscenarioAsignacionPortable.fromJson(x as Map<String, dynamic>))
        .toList(),
    costos: (m['costos'] as List).map((x) => EscenarioCostoPortable.fromJson(x as Map<String, dynamic>)).toList(),
    puntosCurva: (m['puntosCurva'] as List)
        .map((x) => PuntoCurvaPortable.fromJson(x as Map<String, dynamic>))
        .toList(),
    memoria: (m['memoria'] as List).map((x) => MemoriaCalculoPortable.fromJson(x as Map<String, dynamic>)).toList(),
  );
}

class EscenarioAlmacenPortable {
  const EscenarioAlmacenPortable({
    required this.sitioCandidatoIndice,
    required this.volumenAsignado,
    required this.costoFijoCent,
    required this.costoManejoCent,
  });

  final int sitioCandidatoIndice;
  final double volumenAsignado;
  final int costoFijoCent;
  final int costoManejoCent;

  Map<String, dynamic> toJson() => {
    'sitioCandidatoIndice': sitioCandidatoIndice,
    'volumenAsignado': volumenAsignado,
    'costoFijoCent': costoFijoCent,
    'costoManejoCent': costoManejoCent,
  };

  factory EscenarioAlmacenPortable.fromJson(Map<String, dynamic> m) => EscenarioAlmacenPortable(
    sitioCandidatoIndice: m['sitioCandidatoIndice'] as int,
    volumenAsignado: (m['volumenAsignado'] as num).toDouble(),
    costoFijoCent: m['costoFijoCent'] as int,
    costoManejoCent: m['costoManejoCent'] as int,
  );
}

class EscenarioAsignacionPortable {
  const EscenarioAsignacionPortable({
    required this.zonaIndice,
    required this.sitioCandidatoIndice,
    required this.distanciaMetros,
    required this.duracionSegundos,
    required this.costoSalidaCent,
  });

  final int zonaIndice;
  final int sitioCandidatoIndice;
  final int distanciaMetros;
  final int duracionSegundos;
  final int costoSalidaCent;

  Map<String, dynamic> toJson() => {
    'zonaIndice': zonaIndice,
    'sitioCandidatoIndice': sitioCandidatoIndice,
    'distanciaMetros': distanciaMetros,
    'duracionSegundos': duracionSegundos,
    'costoSalidaCent': costoSalidaCent,
  };

  factory EscenarioAsignacionPortable.fromJson(Map<String, dynamic> m) => EscenarioAsignacionPortable(
    zonaIndice: m['zonaIndice'] as int,
    sitioCandidatoIndice: m['sitioCandidatoIndice'] as int,
    distanciaMetros: m['distanciaMetros'] as int,
    duracionSegundos: m['duracionSegundos'] as int,
    costoSalidaCent: m['costoSalidaCent'] as int,
  );
}

class EscenarioCostoPortable {
  const EscenarioCostoPortable({required this.rubro, required this.montoCent});

  final String rubro;
  final int montoCent;

  Map<String, dynamic> toJson() => {'rubro': rubro, 'montoCent': montoCent};

  factory EscenarioCostoPortable.fromJson(Map<String, dynamic> m) =>
      EscenarioCostoPortable(rubro: m['rubro'] as String, montoCent: m['montoCent'] as int);
}

class PuntoCurvaPortable {
  const PuntoCurvaPortable({
    required this.numeroAlmacenes,
    required this.costoTotalCent,
    required this.costoPorRubroJson,
    required this.viableSegunServicio,
  });

  final int numeroAlmacenes;
  final int costoTotalCent;
  final String costoPorRubroJson;
  final bool viableSegunServicio;

  Map<String, dynamic> toJson() => {
    'numeroAlmacenes': numeroAlmacenes,
    'costoTotalCent': costoTotalCent,
    'costoPorRubroJson': costoPorRubroJson,
    'viableSegunServicio': viableSegunServicio,
  };

  factory PuntoCurvaPortable.fromJson(Map<String, dynamic> m) => PuntoCurvaPortable(
    numeroAlmacenes: m['numeroAlmacenes'] as int,
    costoTotalCent: m['costoTotalCent'] as int,
    costoPorRubroJson: m['costoPorRubroJson'] as String,
    viableSegunServicio: m['viableSegunServicio'] as bool,
  );
}

class MemoriaCalculoPortable {
  const MemoriaCalculoPortable({
    required this.orden,
    required this.modulo,
    required this.formula,
    required this.entradasJson,
    required this.salida,
    required this.unidad,
  });

  final int orden;
  final String modulo;
  final String formula;
  final String entradasJson;
  final String salida;
  final String unidad;

  Map<String, dynamic> toJson() => {
    'orden': orden,
    'modulo': modulo,
    'formula': formula,
    'entradasJson': entradasJson,
    'salida': salida,
    'unidad': unidad,
  };

  factory MemoriaCalculoPortable.fromJson(Map<String, dynamic> m) => MemoriaCalculoPortable(
    orden: m['orden'] as int,
    modulo: m['modulo'] as String,
    formula: m['formula'] as String,
    entradasJson: m['entradasJson'] as String,
    salida: m['salida'] as String,
    unidad: m['unidad'] as String,
  );
}
