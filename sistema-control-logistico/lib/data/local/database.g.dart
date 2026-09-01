// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $OrganizacionTableTable extends OrganizacionTable
    with TableInfo<$OrganizacionTableTable, OrganizacionTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrganizacionTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monedaMeta = const VerificationMeta('moneda');
  @override
  late final GeneratedColumn<String> moneda = GeneratedColumn<String>(
    'moneda',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PEN'),
  );
  static const VerificationMeta _tipoEmpresaMeta = const VerificationMeta(
    'tipoEmpresa',
  );
  @override
  late final GeneratedColumn<String> tipoEmpresa = GeneratedColumn<String>(
    'tipo_empresa',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notasMeta = const VerificationMeta('notas');
  @override
  late final GeneratedColumn<String> notas = GeneratedColumn<String>(
    'notas',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    moneda,
    tipoEmpresa,
    notas,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'organizacion';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrganizacionTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('moneda')) {
      context.handle(
        _monedaMeta,
        moneda.isAcceptableOrUnknown(data['moneda']!, _monedaMeta),
      );
    }
    if (data.containsKey('tipo_empresa')) {
      context.handle(
        _tipoEmpresaMeta,
        tipoEmpresa.isAcceptableOrUnknown(
          data['tipo_empresa']!,
          _tipoEmpresaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tipoEmpresaMeta);
    }
    if (data.containsKey('notas')) {
      context.handle(
        _notasMeta,
        notas.isAcceptableOrUnknown(data['notas']!, _notasMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrganizacionTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrganizacionTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      moneda: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}moneda'],
      )!,
      tipoEmpresa: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo_empresa'],
      )!,
      notas: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notas'],
      ),
    );
  }

  @override
  $OrganizacionTableTable createAlias(String alias) {
    return $OrganizacionTableTable(attachedDatabase, alias);
  }
}

class OrganizacionTableData extends DataClass
    implements Insertable<OrganizacionTableData> {
  final int id;
  final String nombre;
  final String moneda;
  final String tipoEmpresa;
  final String? notas;
  const OrganizacionTableData({
    required this.id,
    required this.nombre,
    required this.moneda,
    required this.tipoEmpresa,
    this.notas,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['moneda'] = Variable<String>(moneda);
    map['tipo_empresa'] = Variable<String>(tipoEmpresa);
    if (!nullToAbsent || notas != null) {
      map['notas'] = Variable<String>(notas);
    }
    return map;
  }

  OrganizacionTableCompanion toCompanion(bool nullToAbsent) {
    return OrganizacionTableCompanion(
      id: Value(id),
      nombre: Value(nombre),
      moneda: Value(moneda),
      tipoEmpresa: Value(tipoEmpresa),
      notas: notas == null && nullToAbsent
          ? const Value.absent()
          : Value(notas),
    );
  }

  factory OrganizacionTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrganizacionTableData(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      moneda: serializer.fromJson<String>(json['moneda']),
      tipoEmpresa: serializer.fromJson<String>(json['tipoEmpresa']),
      notas: serializer.fromJson<String?>(json['notas']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'moneda': serializer.toJson<String>(moneda),
      'tipoEmpresa': serializer.toJson<String>(tipoEmpresa),
      'notas': serializer.toJson<String?>(notas),
    };
  }

  OrganizacionTableData copyWith({
    int? id,
    String? nombre,
    String? moneda,
    String? tipoEmpresa,
    Value<String?> notas = const Value.absent(),
  }) => OrganizacionTableData(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    moneda: moneda ?? this.moneda,
    tipoEmpresa: tipoEmpresa ?? this.tipoEmpresa,
    notas: notas.present ? notas.value : this.notas,
  );
  OrganizacionTableData copyWithCompanion(OrganizacionTableCompanion data) {
    return OrganizacionTableData(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      moneda: data.moneda.present ? data.moneda.value : this.moneda,
      tipoEmpresa: data.tipoEmpresa.present
          ? data.tipoEmpresa.value
          : this.tipoEmpresa,
      notas: data.notas.present ? data.notas.value : this.notas,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrganizacionTableData(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('moneda: $moneda, ')
          ..write('tipoEmpresa: $tipoEmpresa, ')
          ..write('notas: $notas')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, moneda, tipoEmpresa, notas);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrganizacionTableData &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.moneda == this.moneda &&
          other.tipoEmpresa == this.tipoEmpresa &&
          other.notas == this.notas);
}

class OrganizacionTableCompanion
    extends UpdateCompanion<OrganizacionTableData> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String> moneda;
  final Value<String> tipoEmpresa;
  final Value<String?> notas;
  const OrganizacionTableCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.moneda = const Value.absent(),
    this.tipoEmpresa = const Value.absent(),
    this.notas = const Value.absent(),
  });
  OrganizacionTableCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    this.moneda = const Value.absent(),
    required String tipoEmpresa,
    this.notas = const Value.absent(),
  }) : nombre = Value(nombre),
       tipoEmpresa = Value(tipoEmpresa);
  static Insertable<OrganizacionTableData> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? moneda,
    Expression<String>? tipoEmpresa,
    Expression<String>? notas,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (moneda != null) 'moneda': moneda,
      if (tipoEmpresa != null) 'tipo_empresa': tipoEmpresa,
      if (notas != null) 'notas': notas,
    });
  }

  OrganizacionTableCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<String>? moneda,
    Value<String>? tipoEmpresa,
    Value<String?>? notas,
  }) {
    return OrganizacionTableCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      moneda: moneda ?? this.moneda,
      tipoEmpresa: tipoEmpresa ?? this.tipoEmpresa,
      notas: notas ?? this.notas,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (moneda.present) {
      map['moneda'] = Variable<String>(moneda.value);
    }
    if (tipoEmpresa.present) {
      map['tipo_empresa'] = Variable<String>(tipoEmpresa.value);
    }
    if (notas.present) {
      map['notas'] = Variable<String>(notas.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrganizacionTableCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('moneda: $moneda, ')
          ..write('tipoEmpresa: $tipoEmpresa, ')
          ..write('notas: $notas')
          ..write(')'))
        .toString();
  }
}

class $PeriodoTableTable extends PeriodoTable
    with TableInfo<$PeriodoTableTable, PeriodoTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PeriodoTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _organizacionIdMeta = const VerificationMeta(
    'organizacionId',
  );
  @override
  late final GeneratedColumn<int> organizacionId = GeneratedColumn<int>(
    'organizacion_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES organizacion (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _ordenMeta = const VerificationMeta('orden');
  @override
  late final GeneratedColumn<int> orden = GeneratedColumn<int>(
    'orden',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _etiquetaMeta = const VerificationMeta(
    'etiqueta',
  );
  @override
  late final GeneratedColumn<String> etiqueta = GeneratedColumn<String>(
    'etiqueta',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaInicioMeta = const VerificationMeta(
    'fechaInicio',
  );
  @override
  late final GeneratedColumn<String> fechaInicio = GeneratedColumn<String>(
    'fecha_inicio',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaFinMeta = const VerificationMeta(
    'fechaFin',
  );
  @override
  late final GeneratedColumn<String> fechaFin = GeneratedColumn<String>(
    'fecha_fin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _granularidadMeta = const VerificationMeta(
    'granularidad',
  );
  @override
  late final GeneratedColumn<String> granularidad = GeneratedColumn<String>(
    'granularidad',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _esSimuladoMeta = const VerificationMeta(
    'esSimulado',
  );
  @override
  late final GeneratedColumn<bool> esSimulado = GeneratedColumn<bool>(
    'es_simulado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("es_simulado" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    organizacionId,
    orden,
    etiqueta,
    fechaInicio,
    fechaFin,
    granularidad,
    esSimulado,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'periodo';
  @override
  VerificationContext validateIntegrity(
    Insertable<PeriodoTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('organizacion_id')) {
      context.handle(
        _organizacionIdMeta,
        organizacionId.isAcceptableOrUnknown(
          data['organizacion_id']!,
          _organizacionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_organizacionIdMeta);
    }
    if (data.containsKey('orden')) {
      context.handle(
        _ordenMeta,
        orden.isAcceptableOrUnknown(data['orden']!, _ordenMeta),
      );
    } else if (isInserting) {
      context.missing(_ordenMeta);
    }
    if (data.containsKey('etiqueta')) {
      context.handle(
        _etiquetaMeta,
        etiqueta.isAcceptableOrUnknown(data['etiqueta']!, _etiquetaMeta),
      );
    } else if (isInserting) {
      context.missing(_etiquetaMeta);
    }
    if (data.containsKey('fecha_inicio')) {
      context.handle(
        _fechaInicioMeta,
        fechaInicio.isAcceptableOrUnknown(
          data['fecha_inicio']!,
          _fechaInicioMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaInicioMeta);
    }
    if (data.containsKey('fecha_fin')) {
      context.handle(
        _fechaFinMeta,
        fechaFin.isAcceptableOrUnknown(data['fecha_fin']!, _fechaFinMeta),
      );
    } else if (isInserting) {
      context.missing(_fechaFinMeta);
    }
    if (data.containsKey('granularidad')) {
      context.handle(
        _granularidadMeta,
        granularidad.isAcceptableOrUnknown(
          data['granularidad']!,
          _granularidadMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_granularidadMeta);
    }
    if (data.containsKey('es_simulado')) {
      context.handle(
        _esSimuladoMeta,
        esSimulado.isAcceptableOrUnknown(data['es_simulado']!, _esSimuladoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {organizacionId, orden},
  ];
  @override
  PeriodoTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PeriodoTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      organizacionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}organizacion_id'],
      )!,
      orden: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}orden'],
      )!,
      etiqueta: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}etiqueta'],
      )!,
      fechaInicio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fecha_inicio'],
      )!,
      fechaFin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fecha_fin'],
      )!,
      granularidad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}granularidad'],
      )!,
      esSimulado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}es_simulado'],
      )!,
    );
  }

  @override
  $PeriodoTableTable createAlias(String alias) {
    return $PeriodoTableTable(attachedDatabase, alias);
  }
}

class PeriodoTableData extends DataClass
    implements Insertable<PeriodoTableData> {
  final int id;
  final int organizacionId;
  final int orden;
  final String etiqueta;
  final String fechaInicio;
  final String fechaFin;
  final String granularidad;
  final bool esSimulado;
  const PeriodoTableData({
    required this.id,
    required this.organizacionId,
    required this.orden,
    required this.etiqueta,
    required this.fechaInicio,
    required this.fechaFin,
    required this.granularidad,
    required this.esSimulado,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['organizacion_id'] = Variable<int>(organizacionId);
    map['orden'] = Variable<int>(orden);
    map['etiqueta'] = Variable<String>(etiqueta);
    map['fecha_inicio'] = Variable<String>(fechaInicio);
    map['fecha_fin'] = Variable<String>(fechaFin);
    map['granularidad'] = Variable<String>(granularidad);
    map['es_simulado'] = Variable<bool>(esSimulado);
    return map;
  }

  PeriodoTableCompanion toCompanion(bool nullToAbsent) {
    return PeriodoTableCompanion(
      id: Value(id),
      organizacionId: Value(organizacionId),
      orden: Value(orden),
      etiqueta: Value(etiqueta),
      fechaInicio: Value(fechaInicio),
      fechaFin: Value(fechaFin),
      granularidad: Value(granularidad),
      esSimulado: Value(esSimulado),
    );
  }

  factory PeriodoTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PeriodoTableData(
      id: serializer.fromJson<int>(json['id']),
      organizacionId: serializer.fromJson<int>(json['organizacionId']),
      orden: serializer.fromJson<int>(json['orden']),
      etiqueta: serializer.fromJson<String>(json['etiqueta']),
      fechaInicio: serializer.fromJson<String>(json['fechaInicio']),
      fechaFin: serializer.fromJson<String>(json['fechaFin']),
      granularidad: serializer.fromJson<String>(json['granularidad']),
      esSimulado: serializer.fromJson<bool>(json['esSimulado']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'organizacionId': serializer.toJson<int>(organizacionId),
      'orden': serializer.toJson<int>(orden),
      'etiqueta': serializer.toJson<String>(etiqueta),
      'fechaInicio': serializer.toJson<String>(fechaInicio),
      'fechaFin': serializer.toJson<String>(fechaFin),
      'granularidad': serializer.toJson<String>(granularidad),
      'esSimulado': serializer.toJson<bool>(esSimulado),
    };
  }

  PeriodoTableData copyWith({
    int? id,
    int? organizacionId,
    int? orden,
    String? etiqueta,
    String? fechaInicio,
    String? fechaFin,
    String? granularidad,
    bool? esSimulado,
  }) => PeriodoTableData(
    id: id ?? this.id,
    organizacionId: organizacionId ?? this.organizacionId,
    orden: orden ?? this.orden,
    etiqueta: etiqueta ?? this.etiqueta,
    fechaInicio: fechaInicio ?? this.fechaInicio,
    fechaFin: fechaFin ?? this.fechaFin,
    granularidad: granularidad ?? this.granularidad,
    esSimulado: esSimulado ?? this.esSimulado,
  );
  PeriodoTableData copyWithCompanion(PeriodoTableCompanion data) {
    return PeriodoTableData(
      id: data.id.present ? data.id.value : this.id,
      organizacionId: data.organizacionId.present
          ? data.organizacionId.value
          : this.organizacionId,
      orden: data.orden.present ? data.orden.value : this.orden,
      etiqueta: data.etiqueta.present ? data.etiqueta.value : this.etiqueta,
      fechaInicio: data.fechaInicio.present
          ? data.fechaInicio.value
          : this.fechaInicio,
      fechaFin: data.fechaFin.present ? data.fechaFin.value : this.fechaFin,
      granularidad: data.granularidad.present
          ? data.granularidad.value
          : this.granularidad,
      esSimulado: data.esSimulado.present
          ? data.esSimulado.value
          : this.esSimulado,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PeriodoTableData(')
          ..write('id: $id, ')
          ..write('organizacionId: $organizacionId, ')
          ..write('orden: $orden, ')
          ..write('etiqueta: $etiqueta, ')
          ..write('fechaInicio: $fechaInicio, ')
          ..write('fechaFin: $fechaFin, ')
          ..write('granularidad: $granularidad, ')
          ..write('esSimulado: $esSimulado')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    organizacionId,
    orden,
    etiqueta,
    fechaInicio,
    fechaFin,
    granularidad,
    esSimulado,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PeriodoTableData &&
          other.id == this.id &&
          other.organizacionId == this.organizacionId &&
          other.orden == this.orden &&
          other.etiqueta == this.etiqueta &&
          other.fechaInicio == this.fechaInicio &&
          other.fechaFin == this.fechaFin &&
          other.granularidad == this.granularidad &&
          other.esSimulado == this.esSimulado);
}

class PeriodoTableCompanion extends UpdateCompanion<PeriodoTableData> {
  final Value<int> id;
  final Value<int> organizacionId;
  final Value<int> orden;
  final Value<String> etiqueta;
  final Value<String> fechaInicio;
  final Value<String> fechaFin;
  final Value<String> granularidad;
  final Value<bool> esSimulado;
  const PeriodoTableCompanion({
    this.id = const Value.absent(),
    this.organizacionId = const Value.absent(),
    this.orden = const Value.absent(),
    this.etiqueta = const Value.absent(),
    this.fechaInicio = const Value.absent(),
    this.fechaFin = const Value.absent(),
    this.granularidad = const Value.absent(),
    this.esSimulado = const Value.absent(),
  });
  PeriodoTableCompanion.insert({
    this.id = const Value.absent(),
    required int organizacionId,
    required int orden,
    required String etiqueta,
    required String fechaInicio,
    required String fechaFin,
    required String granularidad,
    this.esSimulado = const Value.absent(),
  }) : organizacionId = Value(organizacionId),
       orden = Value(orden),
       etiqueta = Value(etiqueta),
       fechaInicio = Value(fechaInicio),
       fechaFin = Value(fechaFin),
       granularidad = Value(granularidad);
  static Insertable<PeriodoTableData> custom({
    Expression<int>? id,
    Expression<int>? organizacionId,
    Expression<int>? orden,
    Expression<String>? etiqueta,
    Expression<String>? fechaInicio,
    Expression<String>? fechaFin,
    Expression<String>? granularidad,
    Expression<bool>? esSimulado,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (organizacionId != null) 'organizacion_id': organizacionId,
      if (orden != null) 'orden': orden,
      if (etiqueta != null) 'etiqueta': etiqueta,
      if (fechaInicio != null) 'fecha_inicio': fechaInicio,
      if (fechaFin != null) 'fecha_fin': fechaFin,
      if (granularidad != null) 'granularidad': granularidad,
      if (esSimulado != null) 'es_simulado': esSimulado,
    });
  }

  PeriodoTableCompanion copyWith({
    Value<int>? id,
    Value<int>? organizacionId,
    Value<int>? orden,
    Value<String>? etiqueta,
    Value<String>? fechaInicio,
    Value<String>? fechaFin,
    Value<String>? granularidad,
    Value<bool>? esSimulado,
  }) {
    return PeriodoTableCompanion(
      id: id ?? this.id,
      organizacionId: organizacionId ?? this.organizacionId,
      orden: orden ?? this.orden,
      etiqueta: etiqueta ?? this.etiqueta,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      granularidad: granularidad ?? this.granularidad,
      esSimulado: esSimulado ?? this.esSimulado,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (organizacionId.present) {
      map['organizacion_id'] = Variable<int>(organizacionId.value);
    }
    if (orden.present) {
      map['orden'] = Variable<int>(orden.value);
    }
    if (etiqueta.present) {
      map['etiqueta'] = Variable<String>(etiqueta.value);
    }
    if (fechaInicio.present) {
      map['fecha_inicio'] = Variable<String>(fechaInicio.value);
    }
    if (fechaFin.present) {
      map['fecha_fin'] = Variable<String>(fechaFin.value);
    }
    if (granularidad.present) {
      map['granularidad'] = Variable<String>(granularidad.value);
    }
    if (esSimulado.present) {
      map['es_simulado'] = Variable<bool>(esSimulado.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PeriodoTableCompanion(')
          ..write('id: $id, ')
          ..write('organizacionId: $organizacionId, ')
          ..write('orden: $orden, ')
          ..write('etiqueta: $etiqueta, ')
          ..write('fechaInicio: $fechaInicio, ')
          ..write('fechaFin: $fechaFin, ')
          ..write('granularidad: $granularidad, ')
          ..write('esSimulado: $esSimulado')
          ..write(')'))
        .toString();
  }
}

class $IndicadorTableTable extends IndicadorTable
    with TableInfo<$IndicadorTableTable, IndicadorTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IndicadorTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _organizacionIdMeta = const VerificationMeta(
    'organizacionId',
  );
  @override
  late final GeneratedColumn<int> organizacionId = GeneratedColumn<int>(
    'organizacion_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES organizacion (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoriaMeta = const VerificationMeta(
    'categoria',
  );
  @override
  late final GeneratedColumn<String> categoria = GeneratedColumn<String>(
    'categoria',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unidadMeta = const VerificationMeta('unidad');
  @override
  late final GeneratedColumn<String> unidad = GeneratedColumn<String>(
    'unidad',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _decimalesMeta = const VerificationMeta(
    'decimales',
  );
  @override
  late final GeneratedColumn<int> decimales = GeneratedColumn<int>(
    'decimales',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2),
  );
  static const VerificationMeta _sentidoMeta = const VerificationMeta(
    'sentido',
  );
  @override
  late final GeneratedColumn<String> sentido = GeneratedColumn<String>(
    'sentido',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _metaMeta = const VerificationMeta('meta');
  @override
  late final GeneratedColumn<double> meta = GeneratedColumn<double>(
    'meta',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bandaInferiorMeta = const VerificationMeta(
    'bandaInferior',
  );
  @override
  late final GeneratedColumn<double> bandaInferior = GeneratedColumn<double>(
    'banda_inferior',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bandaSuperiorMeta = const VerificationMeta(
    'bandaSuperior',
  );
  @override
  late final GeneratedColumn<double> bandaSuperior = GeneratedColumn<double>(
    'banda_superior',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _granularidadMeta = const VerificationMeta(
    'granularidad',
  );
  @override
  late final GeneratedColumn<String> granularidad = GeneratedColumn<String>(
    'granularidad',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _procesoMeta = const VerificationMeta(
    'proceso',
  );
  @override
  late final GeneratedColumn<String> proceso = GeneratedColumn<String>(
    'proceso',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    organizacionId,
    codigo,
    nombre,
    categoria,
    unidad,
    decimales,
    sentido,
    meta,
    bandaInferior,
    bandaSuperior,
    granularidad,
    proceso,
    activo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'indicador';
  @override
  VerificationContext validateIntegrity(
    Insertable<IndicadorTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('organizacion_id')) {
      context.handle(
        _organizacionIdMeta,
        organizacionId.isAcceptableOrUnknown(
          data['organizacion_id']!,
          _organizacionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_organizacionIdMeta);
    }
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('categoria')) {
      context.handle(
        _categoriaMeta,
        categoria.isAcceptableOrUnknown(data['categoria']!, _categoriaMeta),
      );
    } else if (isInserting) {
      context.missing(_categoriaMeta);
    }
    if (data.containsKey('unidad')) {
      context.handle(
        _unidadMeta,
        unidad.isAcceptableOrUnknown(data['unidad']!, _unidadMeta),
      );
    } else if (isInserting) {
      context.missing(_unidadMeta);
    }
    if (data.containsKey('decimales')) {
      context.handle(
        _decimalesMeta,
        decimales.isAcceptableOrUnknown(data['decimales']!, _decimalesMeta),
      );
    }
    if (data.containsKey('sentido')) {
      context.handle(
        _sentidoMeta,
        sentido.isAcceptableOrUnknown(data['sentido']!, _sentidoMeta),
      );
    } else if (isInserting) {
      context.missing(_sentidoMeta);
    }
    if (data.containsKey('meta')) {
      context.handle(
        _metaMeta,
        meta.isAcceptableOrUnknown(data['meta']!, _metaMeta),
      );
    } else if (isInserting) {
      context.missing(_metaMeta);
    }
    if (data.containsKey('banda_inferior')) {
      context.handle(
        _bandaInferiorMeta,
        bandaInferior.isAcceptableOrUnknown(
          data['banda_inferior']!,
          _bandaInferiorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_bandaInferiorMeta);
    }
    if (data.containsKey('banda_superior')) {
      context.handle(
        _bandaSuperiorMeta,
        bandaSuperior.isAcceptableOrUnknown(
          data['banda_superior']!,
          _bandaSuperiorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_bandaSuperiorMeta);
    }
    if (data.containsKey('granularidad')) {
      context.handle(
        _granularidadMeta,
        granularidad.isAcceptableOrUnknown(
          data['granularidad']!,
          _granularidadMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_granularidadMeta);
    }
    if (data.containsKey('proceso')) {
      context.handle(
        _procesoMeta,
        proceso.isAcceptableOrUnknown(data['proceso']!, _procesoMeta),
      );
    } else if (isInserting) {
      context.missing(_procesoMeta);
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {organizacionId, codigo},
  ];
  @override
  IndicadorTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IndicadorTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      organizacionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}organizacion_id'],
      )!,
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      categoria: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}categoria'],
      )!,
      unidad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unidad'],
      )!,
      decimales: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}decimales'],
      )!,
      sentido: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sentido'],
      )!,
      meta: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}meta'],
      )!,
      bandaInferior: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}banda_inferior'],
      )!,
      bandaSuperior: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}banda_superior'],
      )!,
      granularidad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}granularidad'],
      )!,
      proceso: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}proceso'],
      )!,
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
    );
  }

  @override
  $IndicadorTableTable createAlias(String alias) {
    return $IndicadorTableTable(attachedDatabase, alias);
  }
}

class IndicadorTableData extends DataClass
    implements Insertable<IndicadorTableData> {
  final int id;
  final int organizacionId;
  final String codigo;
  final String nombre;
  final String categoria;
  final String unidad;
  final int decimales;
  final String sentido;
  final double meta;
  final double bandaInferior;
  final double bandaSuperior;
  final String granularidad;
  final String proceso;
  final bool activo;
  const IndicadorTableData({
    required this.id,
    required this.organizacionId,
    required this.codigo,
    required this.nombre,
    required this.categoria,
    required this.unidad,
    required this.decimales,
    required this.sentido,
    required this.meta,
    required this.bandaInferior,
    required this.bandaSuperior,
    required this.granularidad,
    required this.proceso,
    required this.activo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['organizacion_id'] = Variable<int>(organizacionId);
    map['codigo'] = Variable<String>(codigo);
    map['nombre'] = Variable<String>(nombre);
    map['categoria'] = Variable<String>(categoria);
    map['unidad'] = Variable<String>(unidad);
    map['decimales'] = Variable<int>(decimales);
    map['sentido'] = Variable<String>(sentido);
    map['meta'] = Variable<double>(meta);
    map['banda_inferior'] = Variable<double>(bandaInferior);
    map['banda_superior'] = Variable<double>(bandaSuperior);
    map['granularidad'] = Variable<String>(granularidad);
    map['proceso'] = Variable<String>(proceso);
    map['activo'] = Variable<bool>(activo);
    return map;
  }

  IndicadorTableCompanion toCompanion(bool nullToAbsent) {
    return IndicadorTableCompanion(
      id: Value(id),
      organizacionId: Value(organizacionId),
      codigo: Value(codigo),
      nombre: Value(nombre),
      categoria: Value(categoria),
      unidad: Value(unidad),
      decimales: Value(decimales),
      sentido: Value(sentido),
      meta: Value(meta),
      bandaInferior: Value(bandaInferior),
      bandaSuperior: Value(bandaSuperior),
      granularidad: Value(granularidad),
      proceso: Value(proceso),
      activo: Value(activo),
    );
  }

  factory IndicadorTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IndicadorTableData(
      id: serializer.fromJson<int>(json['id']),
      organizacionId: serializer.fromJson<int>(json['organizacionId']),
      codigo: serializer.fromJson<String>(json['codigo']),
      nombre: serializer.fromJson<String>(json['nombre']),
      categoria: serializer.fromJson<String>(json['categoria']),
      unidad: serializer.fromJson<String>(json['unidad']),
      decimales: serializer.fromJson<int>(json['decimales']),
      sentido: serializer.fromJson<String>(json['sentido']),
      meta: serializer.fromJson<double>(json['meta']),
      bandaInferior: serializer.fromJson<double>(json['bandaInferior']),
      bandaSuperior: serializer.fromJson<double>(json['bandaSuperior']),
      granularidad: serializer.fromJson<String>(json['granularidad']),
      proceso: serializer.fromJson<String>(json['proceso']),
      activo: serializer.fromJson<bool>(json['activo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'organizacionId': serializer.toJson<int>(organizacionId),
      'codigo': serializer.toJson<String>(codigo),
      'nombre': serializer.toJson<String>(nombre),
      'categoria': serializer.toJson<String>(categoria),
      'unidad': serializer.toJson<String>(unidad),
      'decimales': serializer.toJson<int>(decimales),
      'sentido': serializer.toJson<String>(sentido),
      'meta': serializer.toJson<double>(meta),
      'bandaInferior': serializer.toJson<double>(bandaInferior),
      'bandaSuperior': serializer.toJson<double>(bandaSuperior),
      'granularidad': serializer.toJson<String>(granularidad),
      'proceso': serializer.toJson<String>(proceso),
      'activo': serializer.toJson<bool>(activo),
    };
  }

  IndicadorTableData copyWith({
    int? id,
    int? organizacionId,
    String? codigo,
    String? nombre,
    String? categoria,
    String? unidad,
    int? decimales,
    String? sentido,
    double? meta,
    double? bandaInferior,
    double? bandaSuperior,
    String? granularidad,
    String? proceso,
    bool? activo,
  }) => IndicadorTableData(
    id: id ?? this.id,
    organizacionId: organizacionId ?? this.organizacionId,
    codigo: codigo ?? this.codigo,
    nombre: nombre ?? this.nombre,
    categoria: categoria ?? this.categoria,
    unidad: unidad ?? this.unidad,
    decimales: decimales ?? this.decimales,
    sentido: sentido ?? this.sentido,
    meta: meta ?? this.meta,
    bandaInferior: bandaInferior ?? this.bandaInferior,
    bandaSuperior: bandaSuperior ?? this.bandaSuperior,
    granularidad: granularidad ?? this.granularidad,
    proceso: proceso ?? this.proceso,
    activo: activo ?? this.activo,
  );
  IndicadorTableData copyWithCompanion(IndicadorTableCompanion data) {
    return IndicadorTableData(
      id: data.id.present ? data.id.value : this.id,
      organizacionId: data.organizacionId.present
          ? data.organizacionId.value
          : this.organizacionId,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      categoria: data.categoria.present ? data.categoria.value : this.categoria,
      unidad: data.unidad.present ? data.unidad.value : this.unidad,
      decimales: data.decimales.present ? data.decimales.value : this.decimales,
      sentido: data.sentido.present ? data.sentido.value : this.sentido,
      meta: data.meta.present ? data.meta.value : this.meta,
      bandaInferior: data.bandaInferior.present
          ? data.bandaInferior.value
          : this.bandaInferior,
      bandaSuperior: data.bandaSuperior.present
          ? data.bandaSuperior.value
          : this.bandaSuperior,
      granularidad: data.granularidad.present
          ? data.granularidad.value
          : this.granularidad,
      proceso: data.proceso.present ? data.proceso.value : this.proceso,
      activo: data.activo.present ? data.activo.value : this.activo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IndicadorTableData(')
          ..write('id: $id, ')
          ..write('organizacionId: $organizacionId, ')
          ..write('codigo: $codigo, ')
          ..write('nombre: $nombre, ')
          ..write('categoria: $categoria, ')
          ..write('unidad: $unidad, ')
          ..write('decimales: $decimales, ')
          ..write('sentido: $sentido, ')
          ..write('meta: $meta, ')
          ..write('bandaInferior: $bandaInferior, ')
          ..write('bandaSuperior: $bandaSuperior, ')
          ..write('granularidad: $granularidad, ')
          ..write('proceso: $proceso, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    organizacionId,
    codigo,
    nombre,
    categoria,
    unidad,
    decimales,
    sentido,
    meta,
    bandaInferior,
    bandaSuperior,
    granularidad,
    proceso,
    activo,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IndicadorTableData &&
          other.id == this.id &&
          other.organizacionId == this.organizacionId &&
          other.codigo == this.codigo &&
          other.nombre == this.nombre &&
          other.categoria == this.categoria &&
          other.unidad == this.unidad &&
          other.decimales == this.decimales &&
          other.sentido == this.sentido &&
          other.meta == this.meta &&
          other.bandaInferior == this.bandaInferior &&
          other.bandaSuperior == this.bandaSuperior &&
          other.granularidad == this.granularidad &&
          other.proceso == this.proceso &&
          other.activo == this.activo);
}

class IndicadorTableCompanion extends UpdateCompanion<IndicadorTableData> {
  final Value<int> id;
  final Value<int> organizacionId;
  final Value<String> codigo;
  final Value<String> nombre;
  final Value<String> categoria;
  final Value<String> unidad;
  final Value<int> decimales;
  final Value<String> sentido;
  final Value<double> meta;
  final Value<double> bandaInferior;
  final Value<double> bandaSuperior;
  final Value<String> granularidad;
  final Value<String> proceso;
  final Value<bool> activo;
  const IndicadorTableCompanion({
    this.id = const Value.absent(),
    this.organizacionId = const Value.absent(),
    this.codigo = const Value.absent(),
    this.nombre = const Value.absent(),
    this.categoria = const Value.absent(),
    this.unidad = const Value.absent(),
    this.decimales = const Value.absent(),
    this.sentido = const Value.absent(),
    this.meta = const Value.absent(),
    this.bandaInferior = const Value.absent(),
    this.bandaSuperior = const Value.absent(),
    this.granularidad = const Value.absent(),
    this.proceso = const Value.absent(),
    this.activo = const Value.absent(),
  });
  IndicadorTableCompanion.insert({
    this.id = const Value.absent(),
    required int organizacionId,
    required String codigo,
    required String nombre,
    required String categoria,
    required String unidad,
    this.decimales = const Value.absent(),
    required String sentido,
    required double meta,
    required double bandaInferior,
    required double bandaSuperior,
    required String granularidad,
    required String proceso,
    this.activo = const Value.absent(),
  }) : organizacionId = Value(organizacionId),
       codigo = Value(codigo),
       nombre = Value(nombre),
       categoria = Value(categoria),
       unidad = Value(unidad),
       sentido = Value(sentido),
       meta = Value(meta),
       bandaInferior = Value(bandaInferior),
       bandaSuperior = Value(bandaSuperior),
       granularidad = Value(granularidad),
       proceso = Value(proceso);
  static Insertable<IndicadorTableData> custom({
    Expression<int>? id,
    Expression<int>? organizacionId,
    Expression<String>? codigo,
    Expression<String>? nombre,
    Expression<String>? categoria,
    Expression<String>? unidad,
    Expression<int>? decimales,
    Expression<String>? sentido,
    Expression<double>? meta,
    Expression<double>? bandaInferior,
    Expression<double>? bandaSuperior,
    Expression<String>? granularidad,
    Expression<String>? proceso,
    Expression<bool>? activo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (organizacionId != null) 'organizacion_id': organizacionId,
      if (codigo != null) 'codigo': codigo,
      if (nombre != null) 'nombre': nombre,
      if (categoria != null) 'categoria': categoria,
      if (unidad != null) 'unidad': unidad,
      if (decimales != null) 'decimales': decimales,
      if (sentido != null) 'sentido': sentido,
      if (meta != null) 'meta': meta,
      if (bandaInferior != null) 'banda_inferior': bandaInferior,
      if (bandaSuperior != null) 'banda_superior': bandaSuperior,
      if (granularidad != null) 'granularidad': granularidad,
      if (proceso != null) 'proceso': proceso,
      if (activo != null) 'activo': activo,
    });
  }

  IndicadorTableCompanion copyWith({
    Value<int>? id,
    Value<int>? organizacionId,
    Value<String>? codigo,
    Value<String>? nombre,
    Value<String>? categoria,
    Value<String>? unidad,
    Value<int>? decimales,
    Value<String>? sentido,
    Value<double>? meta,
    Value<double>? bandaInferior,
    Value<double>? bandaSuperior,
    Value<String>? granularidad,
    Value<String>? proceso,
    Value<bool>? activo,
  }) {
    return IndicadorTableCompanion(
      id: id ?? this.id,
      organizacionId: organizacionId ?? this.organizacionId,
      codigo: codigo ?? this.codigo,
      nombre: nombre ?? this.nombre,
      categoria: categoria ?? this.categoria,
      unidad: unidad ?? this.unidad,
      decimales: decimales ?? this.decimales,
      sentido: sentido ?? this.sentido,
      meta: meta ?? this.meta,
      bandaInferior: bandaInferior ?? this.bandaInferior,
      bandaSuperior: bandaSuperior ?? this.bandaSuperior,
      granularidad: granularidad ?? this.granularidad,
      proceso: proceso ?? this.proceso,
      activo: activo ?? this.activo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (organizacionId.present) {
      map['organizacion_id'] = Variable<int>(organizacionId.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (categoria.present) {
      map['categoria'] = Variable<String>(categoria.value);
    }
    if (unidad.present) {
      map['unidad'] = Variable<String>(unidad.value);
    }
    if (decimales.present) {
      map['decimales'] = Variable<int>(decimales.value);
    }
    if (sentido.present) {
      map['sentido'] = Variable<String>(sentido.value);
    }
    if (meta.present) {
      map['meta'] = Variable<double>(meta.value);
    }
    if (bandaInferior.present) {
      map['banda_inferior'] = Variable<double>(bandaInferior.value);
    }
    if (bandaSuperior.present) {
      map['banda_superior'] = Variable<double>(bandaSuperior.value);
    }
    if (granularidad.present) {
      map['granularidad'] = Variable<String>(granularidad.value);
    }
    if (proceso.present) {
      map['proceso'] = Variable<String>(proceso.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IndicadorTableCompanion(')
          ..write('id: $id, ')
          ..write('organizacionId: $organizacionId, ')
          ..write('codigo: $codigo, ')
          ..write('nombre: $nombre, ')
          ..write('categoria: $categoria, ')
          ..write('unidad: $unidad, ')
          ..write('decimales: $decimales, ')
          ..write('sentido: $sentido, ')
          ..write('meta: $meta, ')
          ..write('bandaInferior: $bandaInferior, ')
          ..write('bandaSuperior: $bandaSuperior, ')
          ..write('granularidad: $granularidad, ')
          ..write('proceso: $proceso, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }
}

class $MedicionTableTable extends MedicionTable
    with TableInfo<$MedicionTableTable, MedicionTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicionTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _indicadorIdMeta = const VerificationMeta(
    'indicadorId',
  );
  @override
  late final GeneratedColumn<int> indicadorId = GeneratedColumn<int>(
    'indicador_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES indicador (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _periodoIdMeta = const VerificationMeta(
    'periodoId',
  );
  @override
  late final GeneratedColumn<int> periodoId = GeneratedColumn<int>(
    'periodo_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES periodo (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _valorMeta = const VerificationMeta('valor');
  @override
  late final GeneratedColumn<double> valor = GeneratedColumn<double>(
    'valor',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _origenMeta = const VerificationMeta('origen');
  @override
  late final GeneratedColumn<String> origen = GeneratedColumn<String>(
    'origen',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notaMeta = const VerificationMeta('nota');
  @override
  late final GeneratedColumn<String> nota = GeneratedColumn<String>(
    'nota',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    indicadorId,
    periodoId,
    valor,
    origen,
    nota,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medicion';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicionTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('indicador_id')) {
      context.handle(
        _indicadorIdMeta,
        indicadorId.isAcceptableOrUnknown(
          data['indicador_id']!,
          _indicadorIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_indicadorIdMeta);
    }
    if (data.containsKey('periodo_id')) {
      context.handle(
        _periodoIdMeta,
        periodoId.isAcceptableOrUnknown(data['periodo_id']!, _periodoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_periodoIdMeta);
    }
    if (data.containsKey('valor')) {
      context.handle(
        _valorMeta,
        valor.isAcceptableOrUnknown(data['valor']!, _valorMeta),
      );
    } else if (isInserting) {
      context.missing(_valorMeta);
    }
    if (data.containsKey('origen')) {
      context.handle(
        _origenMeta,
        origen.isAcceptableOrUnknown(data['origen']!, _origenMeta),
      );
    } else if (isInserting) {
      context.missing(_origenMeta);
    }
    if (data.containsKey('nota')) {
      context.handle(
        _notaMeta,
        nota.isAcceptableOrUnknown(data['nota']!, _notaMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {indicadorId, periodoId},
  ];
  @override
  MedicionTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicionTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      indicadorId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}indicador_id'],
      )!,
      periodoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}periodo_id'],
      )!,
      valor: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}valor'],
      )!,
      origen: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origen'],
      )!,
      nota: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nota'],
      ),
    );
  }

  @override
  $MedicionTableTable createAlias(String alias) {
    return $MedicionTableTable(attachedDatabase, alias);
  }
}

class MedicionTableData extends DataClass
    implements Insertable<MedicionTableData> {
  final int id;
  final int indicadorId;
  final int periodoId;
  final double valor;
  final String origen;
  final String? nota;
  const MedicionTableData({
    required this.id,
    required this.indicadorId,
    required this.periodoId,
    required this.valor,
    required this.origen,
    this.nota,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['indicador_id'] = Variable<int>(indicadorId);
    map['periodo_id'] = Variable<int>(periodoId);
    map['valor'] = Variable<double>(valor);
    map['origen'] = Variable<String>(origen);
    if (!nullToAbsent || nota != null) {
      map['nota'] = Variable<String>(nota);
    }
    return map;
  }

  MedicionTableCompanion toCompanion(bool nullToAbsent) {
    return MedicionTableCompanion(
      id: Value(id),
      indicadorId: Value(indicadorId),
      periodoId: Value(periodoId),
      valor: Value(valor),
      origen: Value(origen),
      nota: nota == null && nullToAbsent ? const Value.absent() : Value(nota),
    );
  }

  factory MedicionTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicionTableData(
      id: serializer.fromJson<int>(json['id']),
      indicadorId: serializer.fromJson<int>(json['indicadorId']),
      periodoId: serializer.fromJson<int>(json['periodoId']),
      valor: serializer.fromJson<double>(json['valor']),
      origen: serializer.fromJson<String>(json['origen']),
      nota: serializer.fromJson<String?>(json['nota']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'indicadorId': serializer.toJson<int>(indicadorId),
      'periodoId': serializer.toJson<int>(periodoId),
      'valor': serializer.toJson<double>(valor),
      'origen': serializer.toJson<String>(origen),
      'nota': serializer.toJson<String?>(nota),
    };
  }

  MedicionTableData copyWith({
    int? id,
    int? indicadorId,
    int? periodoId,
    double? valor,
    String? origen,
    Value<String?> nota = const Value.absent(),
  }) => MedicionTableData(
    id: id ?? this.id,
    indicadorId: indicadorId ?? this.indicadorId,
    periodoId: periodoId ?? this.periodoId,
    valor: valor ?? this.valor,
    origen: origen ?? this.origen,
    nota: nota.present ? nota.value : this.nota,
  );
  MedicionTableData copyWithCompanion(MedicionTableCompanion data) {
    return MedicionTableData(
      id: data.id.present ? data.id.value : this.id,
      indicadorId: data.indicadorId.present
          ? data.indicadorId.value
          : this.indicadorId,
      periodoId: data.periodoId.present ? data.periodoId.value : this.periodoId,
      valor: data.valor.present ? data.valor.value : this.valor,
      origen: data.origen.present ? data.origen.value : this.origen,
      nota: data.nota.present ? data.nota.value : this.nota,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicionTableData(')
          ..write('id: $id, ')
          ..write('indicadorId: $indicadorId, ')
          ..write('periodoId: $periodoId, ')
          ..write('valor: $valor, ')
          ..write('origen: $origen, ')
          ..write('nota: $nota')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, indicadorId, periodoId, valor, origen, nota);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicionTableData &&
          other.id == this.id &&
          other.indicadorId == this.indicadorId &&
          other.periodoId == this.periodoId &&
          other.valor == this.valor &&
          other.origen == this.origen &&
          other.nota == this.nota);
}

class MedicionTableCompanion extends UpdateCompanion<MedicionTableData> {
  final Value<int> id;
  final Value<int> indicadorId;
  final Value<int> periodoId;
  final Value<double> valor;
  final Value<String> origen;
  final Value<String?> nota;
  const MedicionTableCompanion({
    this.id = const Value.absent(),
    this.indicadorId = const Value.absent(),
    this.periodoId = const Value.absent(),
    this.valor = const Value.absent(),
    this.origen = const Value.absent(),
    this.nota = const Value.absent(),
  });
  MedicionTableCompanion.insert({
    this.id = const Value.absent(),
    required int indicadorId,
    required int periodoId,
    required double valor,
    required String origen,
    this.nota = const Value.absent(),
  }) : indicadorId = Value(indicadorId),
       periodoId = Value(periodoId),
       valor = Value(valor),
       origen = Value(origen);
  static Insertable<MedicionTableData> custom({
    Expression<int>? id,
    Expression<int>? indicadorId,
    Expression<int>? periodoId,
    Expression<double>? valor,
    Expression<String>? origen,
    Expression<String>? nota,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (indicadorId != null) 'indicador_id': indicadorId,
      if (periodoId != null) 'periodo_id': periodoId,
      if (valor != null) 'valor': valor,
      if (origen != null) 'origen': origen,
      if (nota != null) 'nota': nota,
    });
  }

  MedicionTableCompanion copyWith({
    Value<int>? id,
    Value<int>? indicadorId,
    Value<int>? periodoId,
    Value<double>? valor,
    Value<String>? origen,
    Value<String?>? nota,
  }) {
    return MedicionTableCompanion(
      id: id ?? this.id,
      indicadorId: indicadorId ?? this.indicadorId,
      periodoId: periodoId ?? this.periodoId,
      valor: valor ?? this.valor,
      origen: origen ?? this.origen,
      nota: nota ?? this.nota,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (indicadorId.present) {
      map['indicador_id'] = Variable<int>(indicadorId.value);
    }
    if (periodoId.present) {
      map['periodo_id'] = Variable<int>(periodoId.value);
    }
    if (valor.present) {
      map['valor'] = Variable<double>(valor.value);
    }
    if (origen.present) {
      map['origen'] = Variable<String>(origen.value);
    }
    if (nota.present) {
      map['nota'] = Variable<String>(nota.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicionTableCompanion(')
          ..write('id: $id, ')
          ..write('indicadorId: $indicadorId, ')
          ..write('periodoId: $periodoId, ')
          ..write('valor: $valor, ')
          ..write('origen: $origen, ')
          ..write('nota: $nota')
          ..write(')'))
        .toString();
  }
}

class $ReglaPatronTableTable extends ReglaPatronTable
    with TableInfo<$ReglaPatronTableTable, ReglaPatronTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReglaPatronTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descripcionMeta = const VerificationMeta(
    'descripcion',
  );
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
    'descripcion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parametrosJsonMeta = const VerificationMeta(
    'parametrosJson',
  );
  @override
  late final GeneratedColumn<String> parametrosJson = GeneratedColumn<String>(
    'parametros_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _periodosMinimosMeta = const VerificationMeta(
    'periodosMinimos',
  );
  @override
  late final GeneratedColumn<int> periodosMinimos = GeneratedColumn<int>(
    'periodos_minimos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _severidadBaseMeta = const VerificationMeta(
    'severidadBase',
  );
  @override
  late final GeneratedColumn<double> severidadBase = GeneratedColumn<double>(
    'severidad_base',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activaMeta = const VerificationMeta('activa');
  @override
  late final GeneratedColumn<bool> activa = GeneratedColumn<bool>(
    'activa',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activa" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _indicadorIdMeta = const VerificationMeta(
    'indicadorId',
  );
  @override
  late final GeneratedColumn<int> indicadorId = GeneratedColumn<int>(
    'indicador_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES indicador (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    codigo,
    nombre,
    descripcion,
    parametrosJson,
    periodosMinimos,
    severidadBase,
    activa,
    indicadorId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'regla_patron';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReglaPatronTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
        _descripcionMeta,
        descripcion.isAcceptableOrUnknown(
          data['descripcion']!,
          _descripcionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descripcionMeta);
    }
    if (data.containsKey('parametros_json')) {
      context.handle(
        _parametrosJsonMeta,
        parametrosJson.isAcceptableOrUnknown(
          data['parametros_json']!,
          _parametrosJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_parametrosJsonMeta);
    }
    if (data.containsKey('periodos_minimos')) {
      context.handle(
        _periodosMinimosMeta,
        periodosMinimos.isAcceptableOrUnknown(
          data['periodos_minimos']!,
          _periodosMinimosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_periodosMinimosMeta);
    }
    if (data.containsKey('severidad_base')) {
      context.handle(
        _severidadBaseMeta,
        severidadBase.isAcceptableOrUnknown(
          data['severidad_base']!,
          _severidadBaseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_severidadBaseMeta);
    }
    if (data.containsKey('activa')) {
      context.handle(
        _activaMeta,
        activa.isAcceptableOrUnknown(data['activa']!, _activaMeta),
      );
    }
    if (data.containsKey('indicador_id')) {
      context.handle(
        _indicadorIdMeta,
        indicadorId.isAcceptableOrUnknown(
          data['indicador_id']!,
          _indicadorIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReglaPatronTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReglaPatronTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      )!,
      parametrosJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parametros_json'],
      )!,
      periodosMinimos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}periodos_minimos'],
      )!,
      severidadBase: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}severidad_base'],
      )!,
      activa: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activa'],
      )!,
      indicadorId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}indicador_id'],
      ),
    );
  }

  @override
  $ReglaPatronTableTable createAlias(String alias) {
    return $ReglaPatronTableTable(attachedDatabase, alias);
  }
}

class ReglaPatronTableData extends DataClass
    implements Insertable<ReglaPatronTableData> {
  final int id;
  final String codigo;
  final String nombre;
  final String descripcion;
  final String parametrosJson;
  final int periodosMinimos;
  final double severidadBase;
  final bool activa;
  final int? indicadorId;
  const ReglaPatronTableData({
    required this.id,
    required this.codigo,
    required this.nombre,
    required this.descripcion,
    required this.parametrosJson,
    required this.periodosMinimos,
    required this.severidadBase,
    required this.activa,
    this.indicadorId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['codigo'] = Variable<String>(codigo);
    map['nombre'] = Variable<String>(nombre);
    map['descripcion'] = Variable<String>(descripcion);
    map['parametros_json'] = Variable<String>(parametrosJson);
    map['periodos_minimos'] = Variable<int>(periodosMinimos);
    map['severidad_base'] = Variable<double>(severidadBase);
    map['activa'] = Variable<bool>(activa);
    if (!nullToAbsent || indicadorId != null) {
      map['indicador_id'] = Variable<int>(indicadorId);
    }
    return map;
  }

  ReglaPatronTableCompanion toCompanion(bool nullToAbsent) {
    return ReglaPatronTableCompanion(
      id: Value(id),
      codigo: Value(codigo),
      nombre: Value(nombre),
      descripcion: Value(descripcion),
      parametrosJson: Value(parametrosJson),
      periodosMinimos: Value(periodosMinimos),
      severidadBase: Value(severidadBase),
      activa: Value(activa),
      indicadorId: indicadorId == null && nullToAbsent
          ? const Value.absent()
          : Value(indicadorId),
    );
  }

  factory ReglaPatronTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReglaPatronTableData(
      id: serializer.fromJson<int>(json['id']),
      codigo: serializer.fromJson<String>(json['codigo']),
      nombre: serializer.fromJson<String>(json['nombre']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      parametrosJson: serializer.fromJson<String>(json['parametrosJson']),
      periodosMinimos: serializer.fromJson<int>(json['periodosMinimos']),
      severidadBase: serializer.fromJson<double>(json['severidadBase']),
      activa: serializer.fromJson<bool>(json['activa']),
      indicadorId: serializer.fromJson<int?>(json['indicadorId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'codigo': serializer.toJson<String>(codigo),
      'nombre': serializer.toJson<String>(nombre),
      'descripcion': serializer.toJson<String>(descripcion),
      'parametrosJson': serializer.toJson<String>(parametrosJson),
      'periodosMinimos': serializer.toJson<int>(periodosMinimos),
      'severidadBase': serializer.toJson<double>(severidadBase),
      'activa': serializer.toJson<bool>(activa),
      'indicadorId': serializer.toJson<int?>(indicadorId),
    };
  }

  ReglaPatronTableData copyWith({
    int? id,
    String? codigo,
    String? nombre,
    String? descripcion,
    String? parametrosJson,
    int? periodosMinimos,
    double? severidadBase,
    bool? activa,
    Value<int?> indicadorId = const Value.absent(),
  }) => ReglaPatronTableData(
    id: id ?? this.id,
    codigo: codigo ?? this.codigo,
    nombre: nombre ?? this.nombre,
    descripcion: descripcion ?? this.descripcion,
    parametrosJson: parametrosJson ?? this.parametrosJson,
    periodosMinimos: periodosMinimos ?? this.periodosMinimos,
    severidadBase: severidadBase ?? this.severidadBase,
    activa: activa ?? this.activa,
    indicadorId: indicadorId.present ? indicadorId.value : this.indicadorId,
  );
  ReglaPatronTableData copyWithCompanion(ReglaPatronTableCompanion data) {
    return ReglaPatronTableData(
      id: data.id.present ? data.id.value : this.id,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      descripcion: data.descripcion.present
          ? data.descripcion.value
          : this.descripcion,
      parametrosJson: data.parametrosJson.present
          ? data.parametrosJson.value
          : this.parametrosJson,
      periodosMinimos: data.periodosMinimos.present
          ? data.periodosMinimos.value
          : this.periodosMinimos,
      severidadBase: data.severidadBase.present
          ? data.severidadBase.value
          : this.severidadBase,
      activa: data.activa.present ? data.activa.value : this.activa,
      indicadorId: data.indicadorId.present
          ? data.indicadorId.value
          : this.indicadorId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReglaPatronTableData(')
          ..write('id: $id, ')
          ..write('codigo: $codigo, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('parametrosJson: $parametrosJson, ')
          ..write('periodosMinimos: $periodosMinimos, ')
          ..write('severidadBase: $severidadBase, ')
          ..write('activa: $activa, ')
          ..write('indicadorId: $indicadorId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    codigo,
    nombre,
    descripcion,
    parametrosJson,
    periodosMinimos,
    severidadBase,
    activa,
    indicadorId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReglaPatronTableData &&
          other.id == this.id &&
          other.codigo == this.codigo &&
          other.nombre == this.nombre &&
          other.descripcion == this.descripcion &&
          other.parametrosJson == this.parametrosJson &&
          other.periodosMinimos == this.periodosMinimos &&
          other.severidadBase == this.severidadBase &&
          other.activa == this.activa &&
          other.indicadorId == this.indicadorId);
}

class ReglaPatronTableCompanion extends UpdateCompanion<ReglaPatronTableData> {
  final Value<int> id;
  final Value<String> codigo;
  final Value<String> nombre;
  final Value<String> descripcion;
  final Value<String> parametrosJson;
  final Value<int> periodosMinimos;
  final Value<double> severidadBase;
  final Value<bool> activa;
  final Value<int?> indicadorId;
  const ReglaPatronTableCompanion({
    this.id = const Value.absent(),
    this.codigo = const Value.absent(),
    this.nombre = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.parametrosJson = const Value.absent(),
    this.periodosMinimos = const Value.absent(),
    this.severidadBase = const Value.absent(),
    this.activa = const Value.absent(),
    this.indicadorId = const Value.absent(),
  });
  ReglaPatronTableCompanion.insert({
    this.id = const Value.absent(),
    required String codigo,
    required String nombre,
    required String descripcion,
    required String parametrosJson,
    required int periodosMinimos,
    required double severidadBase,
    this.activa = const Value.absent(),
    this.indicadorId = const Value.absent(),
  }) : codigo = Value(codigo),
       nombre = Value(nombre),
       descripcion = Value(descripcion),
       parametrosJson = Value(parametrosJson),
       periodosMinimos = Value(periodosMinimos),
       severidadBase = Value(severidadBase);
  static Insertable<ReglaPatronTableData> custom({
    Expression<int>? id,
    Expression<String>? codigo,
    Expression<String>? nombre,
    Expression<String>? descripcion,
    Expression<String>? parametrosJson,
    Expression<int>? periodosMinimos,
    Expression<double>? severidadBase,
    Expression<bool>? activa,
    Expression<int>? indicadorId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (codigo != null) 'codigo': codigo,
      if (nombre != null) 'nombre': nombre,
      if (descripcion != null) 'descripcion': descripcion,
      if (parametrosJson != null) 'parametros_json': parametrosJson,
      if (periodosMinimos != null) 'periodos_minimos': periodosMinimos,
      if (severidadBase != null) 'severidad_base': severidadBase,
      if (activa != null) 'activa': activa,
      if (indicadorId != null) 'indicador_id': indicadorId,
    });
  }

  ReglaPatronTableCompanion copyWith({
    Value<int>? id,
    Value<String>? codigo,
    Value<String>? nombre,
    Value<String>? descripcion,
    Value<String>? parametrosJson,
    Value<int>? periodosMinimos,
    Value<double>? severidadBase,
    Value<bool>? activa,
    Value<int?>? indicadorId,
  }) {
    return ReglaPatronTableCompanion(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      parametrosJson: parametrosJson ?? this.parametrosJson,
      periodosMinimos: periodosMinimos ?? this.periodosMinimos,
      severidadBase: severidadBase ?? this.severidadBase,
      activa: activa ?? this.activa,
      indicadorId: indicadorId ?? this.indicadorId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (parametrosJson.present) {
      map['parametros_json'] = Variable<String>(parametrosJson.value);
    }
    if (periodosMinimos.present) {
      map['periodos_minimos'] = Variable<int>(periodosMinimos.value);
    }
    if (severidadBase.present) {
      map['severidad_base'] = Variable<double>(severidadBase.value);
    }
    if (activa.present) {
      map['activa'] = Variable<bool>(activa.value);
    }
    if (indicadorId.present) {
      map['indicador_id'] = Variable<int>(indicadorId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReglaPatronTableCompanion(')
          ..write('id: $id, ')
          ..write('codigo: $codigo, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('parametrosJson: $parametrosJson, ')
          ..write('periodosMinimos: $periodosMinimos, ')
          ..write('severidadBase: $severidadBase, ')
          ..write('activa: $activa, ')
          ..write('indicadorId: $indicadorId')
          ..write(')'))
        .toString();
  }
}

class $EvaluacionTableTable extends EvaluacionTable
    with TableInfo<$EvaluacionTableTable, EvaluacionTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EvaluacionTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _indicadorIdMeta = const VerificationMeta(
    'indicadorId',
  );
  @override
  late final GeneratedColumn<int> indicadorId = GeneratedColumn<int>(
    'indicador_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES indicador (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _periodoIdMeta = const VerificationMeta(
    'periodoId',
  );
  @override
  late final GeneratedColumn<int> periodoId = GeneratedColumn<int>(
    'periodo_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES periodo (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
    'estado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clasificacionMeta = const VerificationMeta(
    'clasificacion',
  );
  @override
  late final GeneratedColumn<String> clasificacion = GeneratedColumn<String>(
    'clasificacion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reglasDisparadasJsonMeta =
      const VerificationMeta('reglasDisparadasJson');
  @override
  late final GeneratedColumn<String> reglasDisparadasJson =
      GeneratedColumn<String>(
        'reglas_disparadas_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _severidadCalculadaMeta =
      const VerificationMeta('severidadCalculada');
  @override
  late final GeneratedColumn<double> severidadCalculada =
      GeneratedColumn<double>(
        'severidad_calculada',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    indicadorId,
    periodoId,
    estado,
    clasificacion,
    reglasDisparadasJson,
    severidadCalculada,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'evaluacion';
  @override
  VerificationContext validateIntegrity(
    Insertable<EvaluacionTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('indicador_id')) {
      context.handle(
        _indicadorIdMeta,
        indicadorId.isAcceptableOrUnknown(
          data['indicador_id']!,
          _indicadorIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_indicadorIdMeta);
    }
    if (data.containsKey('periodo_id')) {
      context.handle(
        _periodoIdMeta,
        periodoId.isAcceptableOrUnknown(data['periodo_id']!, _periodoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_periodoIdMeta);
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    } else if (isInserting) {
      context.missing(_estadoMeta);
    }
    if (data.containsKey('clasificacion')) {
      context.handle(
        _clasificacionMeta,
        clasificacion.isAcceptableOrUnknown(
          data['clasificacion']!,
          _clasificacionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clasificacionMeta);
    }
    if (data.containsKey('reglas_disparadas_json')) {
      context.handle(
        _reglasDisparadasJsonMeta,
        reglasDisparadasJson.isAcceptableOrUnknown(
          data['reglas_disparadas_json']!,
          _reglasDisparadasJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_reglasDisparadasJsonMeta);
    }
    if (data.containsKey('severidad_calculada')) {
      context.handle(
        _severidadCalculadaMeta,
        severidadCalculada.isAcceptableOrUnknown(
          data['severidad_calculada']!,
          _severidadCalculadaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_severidadCalculadaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {indicadorId, periodoId},
  ];
  @override
  EvaluacionTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EvaluacionTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      indicadorId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}indicador_id'],
      )!,
      periodoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}periodo_id'],
      )!,
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
      )!,
      clasificacion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}clasificacion'],
      )!,
      reglasDisparadasJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reglas_disparadas_json'],
      )!,
      severidadCalculada: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}severidad_calculada'],
      )!,
    );
  }

  @override
  $EvaluacionTableTable createAlias(String alias) {
    return $EvaluacionTableTable(attachedDatabase, alias);
  }
}

class EvaluacionTableData extends DataClass
    implements Insertable<EvaluacionTableData> {
  final int id;
  final int indicadorId;
  final int periodoId;
  final String estado;
  final String clasificacion;
  final String reglasDisparadasJson;
  final double severidadCalculada;
  const EvaluacionTableData({
    required this.id,
    required this.indicadorId,
    required this.periodoId,
    required this.estado,
    required this.clasificacion,
    required this.reglasDisparadasJson,
    required this.severidadCalculada,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['indicador_id'] = Variable<int>(indicadorId);
    map['periodo_id'] = Variable<int>(periodoId);
    map['estado'] = Variable<String>(estado);
    map['clasificacion'] = Variable<String>(clasificacion);
    map['reglas_disparadas_json'] = Variable<String>(reglasDisparadasJson);
    map['severidad_calculada'] = Variable<double>(severidadCalculada);
    return map;
  }

  EvaluacionTableCompanion toCompanion(bool nullToAbsent) {
    return EvaluacionTableCompanion(
      id: Value(id),
      indicadorId: Value(indicadorId),
      periodoId: Value(periodoId),
      estado: Value(estado),
      clasificacion: Value(clasificacion),
      reglasDisparadasJson: Value(reglasDisparadasJson),
      severidadCalculada: Value(severidadCalculada),
    );
  }

  factory EvaluacionTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EvaluacionTableData(
      id: serializer.fromJson<int>(json['id']),
      indicadorId: serializer.fromJson<int>(json['indicadorId']),
      periodoId: serializer.fromJson<int>(json['periodoId']),
      estado: serializer.fromJson<String>(json['estado']),
      clasificacion: serializer.fromJson<String>(json['clasificacion']),
      reglasDisparadasJson: serializer.fromJson<String>(
        json['reglasDisparadasJson'],
      ),
      severidadCalculada: serializer.fromJson<double>(
        json['severidadCalculada'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'indicadorId': serializer.toJson<int>(indicadorId),
      'periodoId': serializer.toJson<int>(periodoId),
      'estado': serializer.toJson<String>(estado),
      'clasificacion': serializer.toJson<String>(clasificacion),
      'reglasDisparadasJson': serializer.toJson<String>(reglasDisparadasJson),
      'severidadCalculada': serializer.toJson<double>(severidadCalculada),
    };
  }

  EvaluacionTableData copyWith({
    int? id,
    int? indicadorId,
    int? periodoId,
    String? estado,
    String? clasificacion,
    String? reglasDisparadasJson,
    double? severidadCalculada,
  }) => EvaluacionTableData(
    id: id ?? this.id,
    indicadorId: indicadorId ?? this.indicadorId,
    periodoId: periodoId ?? this.periodoId,
    estado: estado ?? this.estado,
    clasificacion: clasificacion ?? this.clasificacion,
    reglasDisparadasJson: reglasDisparadasJson ?? this.reglasDisparadasJson,
    severidadCalculada: severidadCalculada ?? this.severidadCalculada,
  );
  EvaluacionTableData copyWithCompanion(EvaluacionTableCompanion data) {
    return EvaluacionTableData(
      id: data.id.present ? data.id.value : this.id,
      indicadorId: data.indicadorId.present
          ? data.indicadorId.value
          : this.indicadorId,
      periodoId: data.periodoId.present ? data.periodoId.value : this.periodoId,
      estado: data.estado.present ? data.estado.value : this.estado,
      clasificacion: data.clasificacion.present
          ? data.clasificacion.value
          : this.clasificacion,
      reglasDisparadasJson: data.reglasDisparadasJson.present
          ? data.reglasDisparadasJson.value
          : this.reglasDisparadasJson,
      severidadCalculada: data.severidadCalculada.present
          ? data.severidadCalculada.value
          : this.severidadCalculada,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EvaluacionTableData(')
          ..write('id: $id, ')
          ..write('indicadorId: $indicadorId, ')
          ..write('periodoId: $periodoId, ')
          ..write('estado: $estado, ')
          ..write('clasificacion: $clasificacion, ')
          ..write('reglasDisparadasJson: $reglasDisparadasJson, ')
          ..write('severidadCalculada: $severidadCalculada')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    indicadorId,
    periodoId,
    estado,
    clasificacion,
    reglasDisparadasJson,
    severidadCalculada,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EvaluacionTableData &&
          other.id == this.id &&
          other.indicadorId == this.indicadorId &&
          other.periodoId == this.periodoId &&
          other.estado == this.estado &&
          other.clasificacion == this.clasificacion &&
          other.reglasDisparadasJson == this.reglasDisparadasJson &&
          other.severidadCalculada == this.severidadCalculada);
}

class EvaluacionTableCompanion extends UpdateCompanion<EvaluacionTableData> {
  final Value<int> id;
  final Value<int> indicadorId;
  final Value<int> periodoId;
  final Value<String> estado;
  final Value<String> clasificacion;
  final Value<String> reglasDisparadasJson;
  final Value<double> severidadCalculada;
  const EvaluacionTableCompanion({
    this.id = const Value.absent(),
    this.indicadorId = const Value.absent(),
    this.periodoId = const Value.absent(),
    this.estado = const Value.absent(),
    this.clasificacion = const Value.absent(),
    this.reglasDisparadasJson = const Value.absent(),
    this.severidadCalculada = const Value.absent(),
  });
  EvaluacionTableCompanion.insert({
    this.id = const Value.absent(),
    required int indicadorId,
    required int periodoId,
    required String estado,
    required String clasificacion,
    required String reglasDisparadasJson,
    required double severidadCalculada,
  }) : indicadorId = Value(indicadorId),
       periodoId = Value(periodoId),
       estado = Value(estado),
       clasificacion = Value(clasificacion),
       reglasDisparadasJson = Value(reglasDisparadasJson),
       severidadCalculada = Value(severidadCalculada);
  static Insertable<EvaluacionTableData> custom({
    Expression<int>? id,
    Expression<int>? indicadorId,
    Expression<int>? periodoId,
    Expression<String>? estado,
    Expression<String>? clasificacion,
    Expression<String>? reglasDisparadasJson,
    Expression<double>? severidadCalculada,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (indicadorId != null) 'indicador_id': indicadorId,
      if (periodoId != null) 'periodo_id': periodoId,
      if (estado != null) 'estado': estado,
      if (clasificacion != null) 'clasificacion': clasificacion,
      if (reglasDisparadasJson != null)
        'reglas_disparadas_json': reglasDisparadasJson,
      if (severidadCalculada != null) 'severidad_calculada': severidadCalculada,
    });
  }

  EvaluacionTableCompanion copyWith({
    Value<int>? id,
    Value<int>? indicadorId,
    Value<int>? periodoId,
    Value<String>? estado,
    Value<String>? clasificacion,
    Value<String>? reglasDisparadasJson,
    Value<double>? severidadCalculada,
  }) {
    return EvaluacionTableCompanion(
      id: id ?? this.id,
      indicadorId: indicadorId ?? this.indicadorId,
      periodoId: periodoId ?? this.periodoId,
      estado: estado ?? this.estado,
      clasificacion: clasificacion ?? this.clasificacion,
      reglasDisparadasJson: reglasDisparadasJson ?? this.reglasDisparadasJson,
      severidadCalculada: severidadCalculada ?? this.severidadCalculada,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (indicadorId.present) {
      map['indicador_id'] = Variable<int>(indicadorId.value);
    }
    if (periodoId.present) {
      map['periodo_id'] = Variable<int>(periodoId.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (clasificacion.present) {
      map['clasificacion'] = Variable<String>(clasificacion.value);
    }
    if (reglasDisparadasJson.present) {
      map['reglas_disparadas_json'] = Variable<String>(
        reglasDisparadasJson.value,
      );
    }
    if (severidadCalculada.present) {
      map['severidad_calculada'] = Variable<double>(severidadCalculada.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EvaluacionTableCompanion(')
          ..write('id: $id, ')
          ..write('indicadorId: $indicadorId, ')
          ..write('periodoId: $periodoId, ')
          ..write('estado: $estado, ')
          ..write('clasificacion: $clasificacion, ')
          ..write('reglasDisparadasJson: $reglasDisparadasJson, ')
          ..write('severidadCalculada: $severidadCalculada')
          ..write(')'))
        .toString();
  }
}

class $MemoriaEvaluacionTableTable extends MemoriaEvaluacionTable
    with TableInfo<$MemoriaEvaluacionTableTable, MemoriaEvaluacionTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemoriaEvaluacionTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _evaluacionIdMeta = const VerificationMeta(
    'evaluacionId',
  );
  @override
  late final GeneratedColumn<int> evaluacionId = GeneratedColumn<int>(
    'evaluacion_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES evaluacion (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _reglaIdMeta = const VerificationMeta(
    'reglaId',
  );
  @override
  late final GeneratedColumn<int> reglaId = GeneratedColumn<int>(
    'regla_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES regla_patron (id)',
    ),
  );
  static const VerificationMeta _resultadoMeta = const VerificationMeta(
    'resultado',
  );
  @override
  late final GeneratedColumn<String> resultado = GeneratedColumn<String>(
    'resultado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valoresEntradaJsonMeta =
      const VerificationMeta('valoresEntradaJson');
  @override
  late final GeneratedColumn<String> valoresEntradaJson =
      GeneratedColumn<String>(
        'valores_entrada_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _explicacionMeta = const VerificationMeta(
    'explicacion',
  );
  @override
  late final GeneratedColumn<String> explicacion = GeneratedColumn<String>(
    'explicacion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    evaluacionId,
    reglaId,
    resultado,
    valoresEntradaJson,
    explicacion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'memoria_evaluacion';
  @override
  VerificationContext validateIntegrity(
    Insertable<MemoriaEvaluacionTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('evaluacion_id')) {
      context.handle(
        _evaluacionIdMeta,
        evaluacionId.isAcceptableOrUnknown(
          data['evaluacion_id']!,
          _evaluacionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_evaluacionIdMeta);
    }
    if (data.containsKey('regla_id')) {
      context.handle(
        _reglaIdMeta,
        reglaId.isAcceptableOrUnknown(data['regla_id']!, _reglaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_reglaIdMeta);
    }
    if (data.containsKey('resultado')) {
      context.handle(
        _resultadoMeta,
        resultado.isAcceptableOrUnknown(data['resultado']!, _resultadoMeta),
      );
    } else if (isInserting) {
      context.missing(_resultadoMeta);
    }
    if (data.containsKey('valores_entrada_json')) {
      context.handle(
        _valoresEntradaJsonMeta,
        valoresEntradaJson.isAcceptableOrUnknown(
          data['valores_entrada_json']!,
          _valoresEntradaJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_valoresEntradaJsonMeta);
    }
    if (data.containsKey('explicacion')) {
      context.handle(
        _explicacionMeta,
        explicacion.isAcceptableOrUnknown(
          data['explicacion']!,
          _explicacionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_explicacionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MemoriaEvaluacionTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemoriaEvaluacionTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      evaluacionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}evaluacion_id'],
      )!,
      reglaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}regla_id'],
      )!,
      resultado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}resultado'],
      )!,
      valoresEntradaJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}valores_entrada_json'],
      )!,
      explicacion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explicacion'],
      )!,
    );
  }

  @override
  $MemoriaEvaluacionTableTable createAlias(String alias) {
    return $MemoriaEvaluacionTableTable(attachedDatabase, alias);
  }
}

class MemoriaEvaluacionTableData extends DataClass
    implements Insertable<MemoriaEvaluacionTableData> {
  final int id;
  final int evaluacionId;
  final int reglaId;
  final String resultado;
  final String valoresEntradaJson;
  final String explicacion;
  const MemoriaEvaluacionTableData({
    required this.id,
    required this.evaluacionId,
    required this.reglaId,
    required this.resultado,
    required this.valoresEntradaJson,
    required this.explicacion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['evaluacion_id'] = Variable<int>(evaluacionId);
    map['regla_id'] = Variable<int>(reglaId);
    map['resultado'] = Variable<String>(resultado);
    map['valores_entrada_json'] = Variable<String>(valoresEntradaJson);
    map['explicacion'] = Variable<String>(explicacion);
    return map;
  }

  MemoriaEvaluacionTableCompanion toCompanion(bool nullToAbsent) {
    return MemoriaEvaluacionTableCompanion(
      id: Value(id),
      evaluacionId: Value(evaluacionId),
      reglaId: Value(reglaId),
      resultado: Value(resultado),
      valoresEntradaJson: Value(valoresEntradaJson),
      explicacion: Value(explicacion),
    );
  }

  factory MemoriaEvaluacionTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemoriaEvaluacionTableData(
      id: serializer.fromJson<int>(json['id']),
      evaluacionId: serializer.fromJson<int>(json['evaluacionId']),
      reglaId: serializer.fromJson<int>(json['reglaId']),
      resultado: serializer.fromJson<String>(json['resultado']),
      valoresEntradaJson: serializer.fromJson<String>(
        json['valoresEntradaJson'],
      ),
      explicacion: serializer.fromJson<String>(json['explicacion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'evaluacionId': serializer.toJson<int>(evaluacionId),
      'reglaId': serializer.toJson<int>(reglaId),
      'resultado': serializer.toJson<String>(resultado),
      'valoresEntradaJson': serializer.toJson<String>(valoresEntradaJson),
      'explicacion': serializer.toJson<String>(explicacion),
    };
  }

  MemoriaEvaluacionTableData copyWith({
    int? id,
    int? evaluacionId,
    int? reglaId,
    String? resultado,
    String? valoresEntradaJson,
    String? explicacion,
  }) => MemoriaEvaluacionTableData(
    id: id ?? this.id,
    evaluacionId: evaluacionId ?? this.evaluacionId,
    reglaId: reglaId ?? this.reglaId,
    resultado: resultado ?? this.resultado,
    valoresEntradaJson: valoresEntradaJson ?? this.valoresEntradaJson,
    explicacion: explicacion ?? this.explicacion,
  );
  MemoriaEvaluacionTableData copyWithCompanion(
    MemoriaEvaluacionTableCompanion data,
  ) {
    return MemoriaEvaluacionTableData(
      id: data.id.present ? data.id.value : this.id,
      evaluacionId: data.evaluacionId.present
          ? data.evaluacionId.value
          : this.evaluacionId,
      reglaId: data.reglaId.present ? data.reglaId.value : this.reglaId,
      resultado: data.resultado.present ? data.resultado.value : this.resultado,
      valoresEntradaJson: data.valoresEntradaJson.present
          ? data.valoresEntradaJson.value
          : this.valoresEntradaJson,
      explicacion: data.explicacion.present
          ? data.explicacion.value
          : this.explicacion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemoriaEvaluacionTableData(')
          ..write('id: $id, ')
          ..write('evaluacionId: $evaluacionId, ')
          ..write('reglaId: $reglaId, ')
          ..write('resultado: $resultado, ')
          ..write('valoresEntradaJson: $valoresEntradaJson, ')
          ..write('explicacion: $explicacion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    evaluacionId,
    reglaId,
    resultado,
    valoresEntradaJson,
    explicacion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemoriaEvaluacionTableData &&
          other.id == this.id &&
          other.evaluacionId == this.evaluacionId &&
          other.reglaId == this.reglaId &&
          other.resultado == this.resultado &&
          other.valoresEntradaJson == this.valoresEntradaJson &&
          other.explicacion == this.explicacion);
}

class MemoriaEvaluacionTableCompanion
    extends UpdateCompanion<MemoriaEvaluacionTableData> {
  final Value<int> id;
  final Value<int> evaluacionId;
  final Value<int> reglaId;
  final Value<String> resultado;
  final Value<String> valoresEntradaJson;
  final Value<String> explicacion;
  const MemoriaEvaluacionTableCompanion({
    this.id = const Value.absent(),
    this.evaluacionId = const Value.absent(),
    this.reglaId = const Value.absent(),
    this.resultado = const Value.absent(),
    this.valoresEntradaJson = const Value.absent(),
    this.explicacion = const Value.absent(),
  });
  MemoriaEvaluacionTableCompanion.insert({
    this.id = const Value.absent(),
    required int evaluacionId,
    required int reglaId,
    required String resultado,
    required String valoresEntradaJson,
    required String explicacion,
  }) : evaluacionId = Value(evaluacionId),
       reglaId = Value(reglaId),
       resultado = Value(resultado),
       valoresEntradaJson = Value(valoresEntradaJson),
       explicacion = Value(explicacion);
  static Insertable<MemoriaEvaluacionTableData> custom({
    Expression<int>? id,
    Expression<int>? evaluacionId,
    Expression<int>? reglaId,
    Expression<String>? resultado,
    Expression<String>? valoresEntradaJson,
    Expression<String>? explicacion,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (evaluacionId != null) 'evaluacion_id': evaluacionId,
      if (reglaId != null) 'regla_id': reglaId,
      if (resultado != null) 'resultado': resultado,
      if (valoresEntradaJson != null)
        'valores_entrada_json': valoresEntradaJson,
      if (explicacion != null) 'explicacion': explicacion,
    });
  }

  MemoriaEvaluacionTableCompanion copyWith({
    Value<int>? id,
    Value<int>? evaluacionId,
    Value<int>? reglaId,
    Value<String>? resultado,
    Value<String>? valoresEntradaJson,
    Value<String>? explicacion,
  }) {
    return MemoriaEvaluacionTableCompanion(
      id: id ?? this.id,
      evaluacionId: evaluacionId ?? this.evaluacionId,
      reglaId: reglaId ?? this.reglaId,
      resultado: resultado ?? this.resultado,
      valoresEntradaJson: valoresEntradaJson ?? this.valoresEntradaJson,
      explicacion: explicacion ?? this.explicacion,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (evaluacionId.present) {
      map['evaluacion_id'] = Variable<int>(evaluacionId.value);
    }
    if (reglaId.present) {
      map['regla_id'] = Variable<int>(reglaId.value);
    }
    if (resultado.present) {
      map['resultado'] = Variable<String>(resultado.value);
    }
    if (valoresEntradaJson.present) {
      map['valores_entrada_json'] = Variable<String>(valoresEntradaJson.value);
    }
    if (explicacion.present) {
      map['explicacion'] = Variable<String>(explicacion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemoriaEvaluacionTableCompanion(')
          ..write('id: $id, ')
          ..write('evaluacionId: $evaluacionId, ')
          ..write('reglaId: $reglaId, ')
          ..write('resultado: $resultado, ')
          ..write('valoresEntradaJson: $valoresEntradaJson, ')
          ..write('explicacion: $explicacion')
          ..write(')'))
        .toString();
  }
}

class $AccionCatalogoTableTable extends AccionCatalogoTable
    with TableInfo<$AccionCatalogoTableTable, AccionCatalogoTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccionCatalogoTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tituloMeta = const VerificationMeta('titulo');
  @override
  late final GeneratedColumn<String> titulo = GeneratedColumn<String>(
    'titulo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descripcionMeta = const VerificationMeta(
    'descripcion',
  );
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
    'descripcion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoriaIndicadorMeta =
      const VerificationMeta('categoriaIndicador');
  @override
  late final GeneratedColumn<String> categoriaIndicador =
      GeneratedColumn<String>(
        'categoria_indicador',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _magnitudTipicaMeta = const VerificationMeta(
    'magnitudTipica',
  );
  @override
  late final GeneratedColumn<String> magnitudTipica = GeneratedColumn<String>(
    'magnitud_tipica',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _esDeSistemaMeta = const VerificationMeta(
    'esDeSistema',
  );
  @override
  late final GeneratedColumn<bool> esDeSistema = GeneratedColumn<bool>(
    'es_de_sistema',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("es_de_sistema" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _aplicacionExternaSugeridaMeta =
      const VerificationMeta('aplicacionExternaSugerida');
  @override
  late final GeneratedColumn<String> aplicacionExternaSugerida =
      GeneratedColumn<String>(
        'aplicacion_externa_sugerida',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    codigo,
    titulo,
    descripcion,
    categoriaIndicador,
    magnitudTipica,
    esDeSistema,
    aplicacionExternaSugerida,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accion_catalogo';
  @override
  VerificationContext validateIntegrity(
    Insertable<AccionCatalogoTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('titulo')) {
      context.handle(
        _tituloMeta,
        titulo.isAcceptableOrUnknown(data['titulo']!, _tituloMeta),
      );
    } else if (isInserting) {
      context.missing(_tituloMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
        _descripcionMeta,
        descripcion.isAcceptableOrUnknown(
          data['descripcion']!,
          _descripcionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descripcionMeta);
    }
    if (data.containsKey('categoria_indicador')) {
      context.handle(
        _categoriaIndicadorMeta,
        categoriaIndicador.isAcceptableOrUnknown(
          data['categoria_indicador']!,
          _categoriaIndicadorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoriaIndicadorMeta);
    }
    if (data.containsKey('magnitud_tipica')) {
      context.handle(
        _magnitudTipicaMeta,
        magnitudTipica.isAcceptableOrUnknown(
          data['magnitud_tipica']!,
          _magnitudTipicaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_magnitudTipicaMeta);
    }
    if (data.containsKey('es_de_sistema')) {
      context.handle(
        _esDeSistemaMeta,
        esDeSistema.isAcceptableOrUnknown(
          data['es_de_sistema']!,
          _esDeSistemaMeta,
        ),
      );
    }
    if (data.containsKey('aplicacion_externa_sugerida')) {
      context.handle(
        _aplicacionExternaSugeridaMeta,
        aplicacionExternaSugerida.isAcceptableOrUnknown(
          data['aplicacion_externa_sugerida']!,
          _aplicacionExternaSugeridaMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccionCatalogoTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccionCatalogoTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      titulo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}titulo'],
      )!,
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      )!,
      categoriaIndicador: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}categoria_indicador'],
      )!,
      magnitudTipica: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}magnitud_tipica'],
      )!,
      esDeSistema: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}es_de_sistema'],
      )!,
      aplicacionExternaSugerida: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}aplicacion_externa_sugerida'],
      ),
    );
  }

  @override
  $AccionCatalogoTableTable createAlias(String alias) {
    return $AccionCatalogoTableTable(attachedDatabase, alias);
  }
}

class AccionCatalogoTableData extends DataClass
    implements Insertable<AccionCatalogoTableData> {
  final int id;
  final String codigo;
  final String titulo;
  final String descripcion;
  final String categoriaIndicador;
  final String magnitudTipica;
  final bool esDeSistema;
  final String? aplicacionExternaSugerida;
  const AccionCatalogoTableData({
    required this.id,
    required this.codigo,
    required this.titulo,
    required this.descripcion,
    required this.categoriaIndicador,
    required this.magnitudTipica,
    required this.esDeSistema,
    this.aplicacionExternaSugerida,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['codigo'] = Variable<String>(codigo);
    map['titulo'] = Variable<String>(titulo);
    map['descripcion'] = Variable<String>(descripcion);
    map['categoria_indicador'] = Variable<String>(categoriaIndicador);
    map['magnitud_tipica'] = Variable<String>(magnitudTipica);
    map['es_de_sistema'] = Variable<bool>(esDeSistema);
    if (!nullToAbsent || aplicacionExternaSugerida != null) {
      map['aplicacion_externa_sugerida'] = Variable<String>(
        aplicacionExternaSugerida,
      );
    }
    return map;
  }

  AccionCatalogoTableCompanion toCompanion(bool nullToAbsent) {
    return AccionCatalogoTableCompanion(
      id: Value(id),
      codigo: Value(codigo),
      titulo: Value(titulo),
      descripcion: Value(descripcion),
      categoriaIndicador: Value(categoriaIndicador),
      magnitudTipica: Value(magnitudTipica),
      esDeSistema: Value(esDeSistema),
      aplicacionExternaSugerida:
          aplicacionExternaSugerida == null && nullToAbsent
          ? const Value.absent()
          : Value(aplicacionExternaSugerida),
    );
  }

  factory AccionCatalogoTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccionCatalogoTableData(
      id: serializer.fromJson<int>(json['id']),
      codigo: serializer.fromJson<String>(json['codigo']),
      titulo: serializer.fromJson<String>(json['titulo']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      categoriaIndicador: serializer.fromJson<String>(
        json['categoriaIndicador'],
      ),
      magnitudTipica: serializer.fromJson<String>(json['magnitudTipica']),
      esDeSistema: serializer.fromJson<bool>(json['esDeSistema']),
      aplicacionExternaSugerida: serializer.fromJson<String?>(
        json['aplicacionExternaSugerida'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'codigo': serializer.toJson<String>(codigo),
      'titulo': serializer.toJson<String>(titulo),
      'descripcion': serializer.toJson<String>(descripcion),
      'categoriaIndicador': serializer.toJson<String>(categoriaIndicador),
      'magnitudTipica': serializer.toJson<String>(magnitudTipica),
      'esDeSistema': serializer.toJson<bool>(esDeSistema),
      'aplicacionExternaSugerida': serializer.toJson<String?>(
        aplicacionExternaSugerida,
      ),
    };
  }

  AccionCatalogoTableData copyWith({
    int? id,
    String? codigo,
    String? titulo,
    String? descripcion,
    String? categoriaIndicador,
    String? magnitudTipica,
    bool? esDeSistema,
    Value<String?> aplicacionExternaSugerida = const Value.absent(),
  }) => AccionCatalogoTableData(
    id: id ?? this.id,
    codigo: codigo ?? this.codigo,
    titulo: titulo ?? this.titulo,
    descripcion: descripcion ?? this.descripcion,
    categoriaIndicador: categoriaIndicador ?? this.categoriaIndicador,
    magnitudTipica: magnitudTipica ?? this.magnitudTipica,
    esDeSistema: esDeSistema ?? this.esDeSistema,
    aplicacionExternaSugerida: aplicacionExternaSugerida.present
        ? aplicacionExternaSugerida.value
        : this.aplicacionExternaSugerida,
  );
  AccionCatalogoTableData copyWithCompanion(AccionCatalogoTableCompanion data) {
    return AccionCatalogoTableData(
      id: data.id.present ? data.id.value : this.id,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      titulo: data.titulo.present ? data.titulo.value : this.titulo,
      descripcion: data.descripcion.present
          ? data.descripcion.value
          : this.descripcion,
      categoriaIndicador: data.categoriaIndicador.present
          ? data.categoriaIndicador.value
          : this.categoriaIndicador,
      magnitudTipica: data.magnitudTipica.present
          ? data.magnitudTipica.value
          : this.magnitudTipica,
      esDeSistema: data.esDeSistema.present
          ? data.esDeSistema.value
          : this.esDeSistema,
      aplicacionExternaSugerida: data.aplicacionExternaSugerida.present
          ? data.aplicacionExternaSugerida.value
          : this.aplicacionExternaSugerida,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccionCatalogoTableData(')
          ..write('id: $id, ')
          ..write('codigo: $codigo, ')
          ..write('titulo: $titulo, ')
          ..write('descripcion: $descripcion, ')
          ..write('categoriaIndicador: $categoriaIndicador, ')
          ..write('magnitudTipica: $magnitudTipica, ')
          ..write('esDeSistema: $esDeSistema, ')
          ..write('aplicacionExternaSugerida: $aplicacionExternaSugerida')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    codigo,
    titulo,
    descripcion,
    categoriaIndicador,
    magnitudTipica,
    esDeSistema,
    aplicacionExternaSugerida,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccionCatalogoTableData &&
          other.id == this.id &&
          other.codigo == this.codigo &&
          other.titulo == this.titulo &&
          other.descripcion == this.descripcion &&
          other.categoriaIndicador == this.categoriaIndicador &&
          other.magnitudTipica == this.magnitudTipica &&
          other.esDeSistema == this.esDeSistema &&
          other.aplicacionExternaSugerida == this.aplicacionExternaSugerida);
}

class AccionCatalogoTableCompanion
    extends UpdateCompanion<AccionCatalogoTableData> {
  final Value<int> id;
  final Value<String> codigo;
  final Value<String> titulo;
  final Value<String> descripcion;
  final Value<String> categoriaIndicador;
  final Value<String> magnitudTipica;
  final Value<bool> esDeSistema;
  final Value<String?> aplicacionExternaSugerida;
  const AccionCatalogoTableCompanion({
    this.id = const Value.absent(),
    this.codigo = const Value.absent(),
    this.titulo = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.categoriaIndicador = const Value.absent(),
    this.magnitudTipica = const Value.absent(),
    this.esDeSistema = const Value.absent(),
    this.aplicacionExternaSugerida = const Value.absent(),
  });
  AccionCatalogoTableCompanion.insert({
    this.id = const Value.absent(),
    required String codigo,
    required String titulo,
    required String descripcion,
    required String categoriaIndicador,
    required String magnitudTipica,
    this.esDeSistema = const Value.absent(),
    this.aplicacionExternaSugerida = const Value.absent(),
  }) : codigo = Value(codigo),
       titulo = Value(titulo),
       descripcion = Value(descripcion),
       categoriaIndicador = Value(categoriaIndicador),
       magnitudTipica = Value(magnitudTipica);
  static Insertable<AccionCatalogoTableData> custom({
    Expression<int>? id,
    Expression<String>? codigo,
    Expression<String>? titulo,
    Expression<String>? descripcion,
    Expression<String>? categoriaIndicador,
    Expression<String>? magnitudTipica,
    Expression<bool>? esDeSistema,
    Expression<String>? aplicacionExternaSugerida,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (codigo != null) 'codigo': codigo,
      if (titulo != null) 'titulo': titulo,
      if (descripcion != null) 'descripcion': descripcion,
      if (categoriaIndicador != null) 'categoria_indicador': categoriaIndicador,
      if (magnitudTipica != null) 'magnitud_tipica': magnitudTipica,
      if (esDeSistema != null) 'es_de_sistema': esDeSistema,
      if (aplicacionExternaSugerida != null)
        'aplicacion_externa_sugerida': aplicacionExternaSugerida,
    });
  }

  AccionCatalogoTableCompanion copyWith({
    Value<int>? id,
    Value<String>? codigo,
    Value<String>? titulo,
    Value<String>? descripcion,
    Value<String>? categoriaIndicador,
    Value<String>? magnitudTipica,
    Value<bool>? esDeSistema,
    Value<String?>? aplicacionExternaSugerida,
  }) {
    return AccionCatalogoTableCompanion(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      categoriaIndicador: categoriaIndicador ?? this.categoriaIndicador,
      magnitudTipica: magnitudTipica ?? this.magnitudTipica,
      esDeSistema: esDeSistema ?? this.esDeSistema,
      aplicacionExternaSugerida:
          aplicacionExternaSugerida ?? this.aplicacionExternaSugerida,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (titulo.present) {
      map['titulo'] = Variable<String>(titulo.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (categoriaIndicador.present) {
      map['categoria_indicador'] = Variable<String>(categoriaIndicador.value);
    }
    if (magnitudTipica.present) {
      map['magnitud_tipica'] = Variable<String>(magnitudTipica.value);
    }
    if (esDeSistema.present) {
      map['es_de_sistema'] = Variable<bool>(esDeSistema.value);
    }
    if (aplicacionExternaSugerida.present) {
      map['aplicacion_externa_sugerida'] = Variable<String>(
        aplicacionExternaSugerida.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccionCatalogoTableCompanion(')
          ..write('id: $id, ')
          ..write('codigo: $codigo, ')
          ..write('titulo: $titulo, ')
          ..write('descripcion: $descripcion, ')
          ..write('categoriaIndicador: $categoriaIndicador, ')
          ..write('magnitudTipica: $magnitudTipica, ')
          ..write('esDeSistema: $esDeSistema, ')
          ..write('aplicacionExternaSugerida: $aplicacionExternaSugerida')
          ..write(')'))
        .toString();
  }
}

class $ReglaAccionTableTable extends ReglaAccionTable
    with TableInfo<$ReglaAccionTableTable, ReglaAccionTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReglaAccionTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _categoriaIndicadorMeta =
      const VerificationMeta('categoriaIndicador');
  @override
  late final GeneratedColumn<String> categoriaIndicador =
      GeneratedColumn<String>(
        'categoria_indicador',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _reglaDisparadaMeta = const VerificationMeta(
    'reglaDisparada',
  );
  @override
  late final GeneratedColumn<String> reglaDisparada = GeneratedColumn<String>(
    'regla_disparada',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clasificacionMeta = const VerificationMeta(
    'clasificacion',
  );
  @override
  late final GeneratedColumn<String> clasificacion = GeneratedColumn<String>(
    'clasificacion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accionIdMeta = const VerificationMeta(
    'accionId',
  );
  @override
  late final GeneratedColumn<int> accionId = GeneratedColumn<int>(
    'accion_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accion_catalogo (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _prioridadMeta = const VerificationMeta(
    'prioridad',
  );
  @override
  late final GeneratedColumn<int> prioridad = GeneratedColumn<int>(
    'prioridad',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    categoriaIndicador,
    reglaDisparada,
    clasificacion,
    accionId,
    prioridad,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'regla_accion';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReglaAccionTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('categoria_indicador')) {
      context.handle(
        _categoriaIndicadorMeta,
        categoriaIndicador.isAcceptableOrUnknown(
          data['categoria_indicador']!,
          _categoriaIndicadorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoriaIndicadorMeta);
    }
    if (data.containsKey('regla_disparada')) {
      context.handle(
        _reglaDisparadaMeta,
        reglaDisparada.isAcceptableOrUnknown(
          data['regla_disparada']!,
          _reglaDisparadaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_reglaDisparadaMeta);
    }
    if (data.containsKey('clasificacion')) {
      context.handle(
        _clasificacionMeta,
        clasificacion.isAcceptableOrUnknown(
          data['clasificacion']!,
          _clasificacionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clasificacionMeta);
    }
    if (data.containsKey('accion_id')) {
      context.handle(
        _accionIdMeta,
        accionId.isAcceptableOrUnknown(data['accion_id']!, _accionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accionIdMeta);
    }
    if (data.containsKey('prioridad')) {
      context.handle(
        _prioridadMeta,
        prioridad.isAcceptableOrUnknown(data['prioridad']!, _prioridadMeta),
      );
    } else if (isInserting) {
      context.missing(_prioridadMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReglaAccionTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReglaAccionTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      categoriaIndicador: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}categoria_indicador'],
      )!,
      reglaDisparada: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}regla_disparada'],
      )!,
      clasificacion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}clasificacion'],
      )!,
      accionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}accion_id'],
      )!,
      prioridad: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prioridad'],
      )!,
    );
  }

  @override
  $ReglaAccionTableTable createAlias(String alias) {
    return $ReglaAccionTableTable(attachedDatabase, alias);
  }
}

class ReglaAccionTableData extends DataClass
    implements Insertable<ReglaAccionTableData> {
  final int id;
  final String categoriaIndicador;
  final String reglaDisparada;
  final String clasificacion;
  final int accionId;
  final int prioridad;
  const ReglaAccionTableData({
    required this.id,
    required this.categoriaIndicador,
    required this.reglaDisparada,
    required this.clasificacion,
    required this.accionId,
    required this.prioridad,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['categoria_indicador'] = Variable<String>(categoriaIndicador);
    map['regla_disparada'] = Variable<String>(reglaDisparada);
    map['clasificacion'] = Variable<String>(clasificacion);
    map['accion_id'] = Variable<int>(accionId);
    map['prioridad'] = Variable<int>(prioridad);
    return map;
  }

  ReglaAccionTableCompanion toCompanion(bool nullToAbsent) {
    return ReglaAccionTableCompanion(
      id: Value(id),
      categoriaIndicador: Value(categoriaIndicador),
      reglaDisparada: Value(reglaDisparada),
      clasificacion: Value(clasificacion),
      accionId: Value(accionId),
      prioridad: Value(prioridad),
    );
  }

  factory ReglaAccionTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReglaAccionTableData(
      id: serializer.fromJson<int>(json['id']),
      categoriaIndicador: serializer.fromJson<String>(
        json['categoriaIndicador'],
      ),
      reglaDisparada: serializer.fromJson<String>(json['reglaDisparada']),
      clasificacion: serializer.fromJson<String>(json['clasificacion']),
      accionId: serializer.fromJson<int>(json['accionId']),
      prioridad: serializer.fromJson<int>(json['prioridad']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoriaIndicador': serializer.toJson<String>(categoriaIndicador),
      'reglaDisparada': serializer.toJson<String>(reglaDisparada),
      'clasificacion': serializer.toJson<String>(clasificacion),
      'accionId': serializer.toJson<int>(accionId),
      'prioridad': serializer.toJson<int>(prioridad),
    };
  }

  ReglaAccionTableData copyWith({
    int? id,
    String? categoriaIndicador,
    String? reglaDisparada,
    String? clasificacion,
    int? accionId,
    int? prioridad,
  }) => ReglaAccionTableData(
    id: id ?? this.id,
    categoriaIndicador: categoriaIndicador ?? this.categoriaIndicador,
    reglaDisparada: reglaDisparada ?? this.reglaDisparada,
    clasificacion: clasificacion ?? this.clasificacion,
    accionId: accionId ?? this.accionId,
    prioridad: prioridad ?? this.prioridad,
  );
  ReglaAccionTableData copyWithCompanion(ReglaAccionTableCompanion data) {
    return ReglaAccionTableData(
      id: data.id.present ? data.id.value : this.id,
      categoriaIndicador: data.categoriaIndicador.present
          ? data.categoriaIndicador.value
          : this.categoriaIndicador,
      reglaDisparada: data.reglaDisparada.present
          ? data.reglaDisparada.value
          : this.reglaDisparada,
      clasificacion: data.clasificacion.present
          ? data.clasificacion.value
          : this.clasificacion,
      accionId: data.accionId.present ? data.accionId.value : this.accionId,
      prioridad: data.prioridad.present ? data.prioridad.value : this.prioridad,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReglaAccionTableData(')
          ..write('id: $id, ')
          ..write('categoriaIndicador: $categoriaIndicador, ')
          ..write('reglaDisparada: $reglaDisparada, ')
          ..write('clasificacion: $clasificacion, ')
          ..write('accionId: $accionId, ')
          ..write('prioridad: $prioridad')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    categoriaIndicador,
    reglaDisparada,
    clasificacion,
    accionId,
    prioridad,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReglaAccionTableData &&
          other.id == this.id &&
          other.categoriaIndicador == this.categoriaIndicador &&
          other.reglaDisparada == this.reglaDisparada &&
          other.clasificacion == this.clasificacion &&
          other.accionId == this.accionId &&
          other.prioridad == this.prioridad);
}

class ReglaAccionTableCompanion extends UpdateCompanion<ReglaAccionTableData> {
  final Value<int> id;
  final Value<String> categoriaIndicador;
  final Value<String> reglaDisparada;
  final Value<String> clasificacion;
  final Value<int> accionId;
  final Value<int> prioridad;
  const ReglaAccionTableCompanion({
    this.id = const Value.absent(),
    this.categoriaIndicador = const Value.absent(),
    this.reglaDisparada = const Value.absent(),
    this.clasificacion = const Value.absent(),
    this.accionId = const Value.absent(),
    this.prioridad = const Value.absent(),
  });
  ReglaAccionTableCompanion.insert({
    this.id = const Value.absent(),
    required String categoriaIndicador,
    required String reglaDisparada,
    required String clasificacion,
    required int accionId,
    required int prioridad,
  }) : categoriaIndicador = Value(categoriaIndicador),
       reglaDisparada = Value(reglaDisparada),
       clasificacion = Value(clasificacion),
       accionId = Value(accionId),
       prioridad = Value(prioridad);
  static Insertable<ReglaAccionTableData> custom({
    Expression<int>? id,
    Expression<String>? categoriaIndicador,
    Expression<String>? reglaDisparada,
    Expression<String>? clasificacion,
    Expression<int>? accionId,
    Expression<int>? prioridad,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoriaIndicador != null) 'categoria_indicador': categoriaIndicador,
      if (reglaDisparada != null) 'regla_disparada': reglaDisparada,
      if (clasificacion != null) 'clasificacion': clasificacion,
      if (accionId != null) 'accion_id': accionId,
      if (prioridad != null) 'prioridad': prioridad,
    });
  }

  ReglaAccionTableCompanion copyWith({
    Value<int>? id,
    Value<String>? categoriaIndicador,
    Value<String>? reglaDisparada,
    Value<String>? clasificacion,
    Value<int>? accionId,
    Value<int>? prioridad,
  }) {
    return ReglaAccionTableCompanion(
      id: id ?? this.id,
      categoriaIndicador: categoriaIndicador ?? this.categoriaIndicador,
      reglaDisparada: reglaDisparada ?? this.reglaDisparada,
      clasificacion: clasificacion ?? this.clasificacion,
      accionId: accionId ?? this.accionId,
      prioridad: prioridad ?? this.prioridad,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoriaIndicador.present) {
      map['categoria_indicador'] = Variable<String>(categoriaIndicador.value);
    }
    if (reglaDisparada.present) {
      map['regla_disparada'] = Variable<String>(reglaDisparada.value);
    }
    if (clasificacion.present) {
      map['clasificacion'] = Variable<String>(clasificacion.value);
    }
    if (accionId.present) {
      map['accion_id'] = Variable<int>(accionId.value);
    }
    if (prioridad.present) {
      map['prioridad'] = Variable<int>(prioridad.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReglaAccionTableCompanion(')
          ..write('id: $id, ')
          ..write('categoriaIndicador: $categoriaIndicador, ')
          ..write('reglaDisparada: $reglaDisparada, ')
          ..write('clasificacion: $clasificacion, ')
          ..write('accionId: $accionId, ')
          ..write('prioridad: $prioridad')
          ..write(')'))
        .toString();
  }
}

class $AccionTomadaTableTable extends AccionTomadaTable
    with TableInfo<$AccionTomadaTableTable, AccionTomadaTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccionTomadaTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _evaluacionIdMeta = const VerificationMeta(
    'evaluacionId',
  );
  @override
  late final GeneratedColumn<int> evaluacionId = GeneratedColumn<int>(
    'evaluacion_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES evaluacion (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _accionCatalogoIdMeta = const VerificationMeta(
    'accionCatalogoId',
  );
  @override
  late final GeneratedColumn<int> accionCatalogoId = GeneratedColumn<int>(
    'accion_catalogo_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accion_catalogo (id)',
    ),
  );
  static const VerificationMeta _responsableMeta = const VerificationMeta(
    'responsable',
  );
  @override
  late final GeneratedColumn<String> responsable = GeneratedColumn<String>(
    'responsable',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaCompromisoMeta = const VerificationMeta(
    'fechaCompromiso',
  );
  @override
  late final GeneratedColumn<String> fechaCompromiso = GeneratedColumn<String>(
    'fecha_compromiso',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
    'estado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('abierta'),
  );
  static const VerificationMeta _notasMeta = const VerificationMeta('notas');
  @override
  late final GeneratedColumn<String> notas = GeneratedColumn<String>(
    'notas',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fechaRegistroMeta = const VerificationMeta(
    'fechaRegistro',
  );
  @override
  late final GeneratedColumn<String> fechaRegistro = GeneratedColumn<String>(
    'fecha_registro',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    evaluacionId,
    accionCatalogoId,
    responsable,
    fechaCompromiso,
    estado,
    notas,
    fechaRegistro,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accion_tomada';
  @override
  VerificationContext validateIntegrity(
    Insertable<AccionTomadaTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('evaluacion_id')) {
      context.handle(
        _evaluacionIdMeta,
        evaluacionId.isAcceptableOrUnknown(
          data['evaluacion_id']!,
          _evaluacionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_evaluacionIdMeta);
    }
    if (data.containsKey('accion_catalogo_id')) {
      context.handle(
        _accionCatalogoIdMeta,
        accionCatalogoId.isAcceptableOrUnknown(
          data['accion_catalogo_id']!,
          _accionCatalogoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accionCatalogoIdMeta);
    }
    if (data.containsKey('responsable')) {
      context.handle(
        _responsableMeta,
        responsable.isAcceptableOrUnknown(
          data['responsable']!,
          _responsableMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_responsableMeta);
    }
    if (data.containsKey('fecha_compromiso')) {
      context.handle(
        _fechaCompromisoMeta,
        fechaCompromiso.isAcceptableOrUnknown(
          data['fecha_compromiso']!,
          _fechaCompromisoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaCompromisoMeta);
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    }
    if (data.containsKey('notas')) {
      context.handle(
        _notasMeta,
        notas.isAcceptableOrUnknown(data['notas']!, _notasMeta),
      );
    }
    if (data.containsKey('fecha_registro')) {
      context.handle(
        _fechaRegistroMeta,
        fechaRegistro.isAcceptableOrUnknown(
          data['fecha_registro']!,
          _fechaRegistroMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaRegistroMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccionTomadaTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccionTomadaTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      evaluacionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}evaluacion_id'],
      )!,
      accionCatalogoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}accion_catalogo_id'],
      )!,
      responsable: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}responsable'],
      )!,
      fechaCompromiso: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fecha_compromiso'],
      )!,
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
      )!,
      notas: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notas'],
      ),
      fechaRegistro: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fecha_registro'],
      )!,
    );
  }

  @override
  $AccionTomadaTableTable createAlias(String alias) {
    return $AccionTomadaTableTable(attachedDatabase, alias);
  }
}

class AccionTomadaTableData extends DataClass
    implements Insertable<AccionTomadaTableData> {
  final int id;
  final int evaluacionId;
  final int accionCatalogoId;
  final String responsable;
  final String fechaCompromiso;
  final String estado;
  final String? notas;
  final String fechaRegistro;
  const AccionTomadaTableData({
    required this.id,
    required this.evaluacionId,
    required this.accionCatalogoId,
    required this.responsable,
    required this.fechaCompromiso,
    required this.estado,
    this.notas,
    required this.fechaRegistro,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['evaluacion_id'] = Variable<int>(evaluacionId);
    map['accion_catalogo_id'] = Variable<int>(accionCatalogoId);
    map['responsable'] = Variable<String>(responsable);
    map['fecha_compromiso'] = Variable<String>(fechaCompromiso);
    map['estado'] = Variable<String>(estado);
    if (!nullToAbsent || notas != null) {
      map['notas'] = Variable<String>(notas);
    }
    map['fecha_registro'] = Variable<String>(fechaRegistro);
    return map;
  }

  AccionTomadaTableCompanion toCompanion(bool nullToAbsent) {
    return AccionTomadaTableCompanion(
      id: Value(id),
      evaluacionId: Value(evaluacionId),
      accionCatalogoId: Value(accionCatalogoId),
      responsable: Value(responsable),
      fechaCompromiso: Value(fechaCompromiso),
      estado: Value(estado),
      notas: notas == null && nullToAbsent
          ? const Value.absent()
          : Value(notas),
      fechaRegistro: Value(fechaRegistro),
    );
  }

  factory AccionTomadaTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccionTomadaTableData(
      id: serializer.fromJson<int>(json['id']),
      evaluacionId: serializer.fromJson<int>(json['evaluacionId']),
      accionCatalogoId: serializer.fromJson<int>(json['accionCatalogoId']),
      responsable: serializer.fromJson<String>(json['responsable']),
      fechaCompromiso: serializer.fromJson<String>(json['fechaCompromiso']),
      estado: serializer.fromJson<String>(json['estado']),
      notas: serializer.fromJson<String?>(json['notas']),
      fechaRegistro: serializer.fromJson<String>(json['fechaRegistro']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'evaluacionId': serializer.toJson<int>(evaluacionId),
      'accionCatalogoId': serializer.toJson<int>(accionCatalogoId),
      'responsable': serializer.toJson<String>(responsable),
      'fechaCompromiso': serializer.toJson<String>(fechaCompromiso),
      'estado': serializer.toJson<String>(estado),
      'notas': serializer.toJson<String?>(notas),
      'fechaRegistro': serializer.toJson<String>(fechaRegistro),
    };
  }

  AccionTomadaTableData copyWith({
    int? id,
    int? evaluacionId,
    int? accionCatalogoId,
    String? responsable,
    String? fechaCompromiso,
    String? estado,
    Value<String?> notas = const Value.absent(),
    String? fechaRegistro,
  }) => AccionTomadaTableData(
    id: id ?? this.id,
    evaluacionId: evaluacionId ?? this.evaluacionId,
    accionCatalogoId: accionCatalogoId ?? this.accionCatalogoId,
    responsable: responsable ?? this.responsable,
    fechaCompromiso: fechaCompromiso ?? this.fechaCompromiso,
    estado: estado ?? this.estado,
    notas: notas.present ? notas.value : this.notas,
    fechaRegistro: fechaRegistro ?? this.fechaRegistro,
  );
  AccionTomadaTableData copyWithCompanion(AccionTomadaTableCompanion data) {
    return AccionTomadaTableData(
      id: data.id.present ? data.id.value : this.id,
      evaluacionId: data.evaluacionId.present
          ? data.evaluacionId.value
          : this.evaluacionId,
      accionCatalogoId: data.accionCatalogoId.present
          ? data.accionCatalogoId.value
          : this.accionCatalogoId,
      responsable: data.responsable.present
          ? data.responsable.value
          : this.responsable,
      fechaCompromiso: data.fechaCompromiso.present
          ? data.fechaCompromiso.value
          : this.fechaCompromiso,
      estado: data.estado.present ? data.estado.value : this.estado,
      notas: data.notas.present ? data.notas.value : this.notas,
      fechaRegistro: data.fechaRegistro.present
          ? data.fechaRegistro.value
          : this.fechaRegistro,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccionTomadaTableData(')
          ..write('id: $id, ')
          ..write('evaluacionId: $evaluacionId, ')
          ..write('accionCatalogoId: $accionCatalogoId, ')
          ..write('responsable: $responsable, ')
          ..write('fechaCompromiso: $fechaCompromiso, ')
          ..write('estado: $estado, ')
          ..write('notas: $notas, ')
          ..write('fechaRegistro: $fechaRegistro')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    evaluacionId,
    accionCatalogoId,
    responsable,
    fechaCompromiso,
    estado,
    notas,
    fechaRegistro,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccionTomadaTableData &&
          other.id == this.id &&
          other.evaluacionId == this.evaluacionId &&
          other.accionCatalogoId == this.accionCatalogoId &&
          other.responsable == this.responsable &&
          other.fechaCompromiso == this.fechaCompromiso &&
          other.estado == this.estado &&
          other.notas == this.notas &&
          other.fechaRegistro == this.fechaRegistro);
}

class AccionTomadaTableCompanion
    extends UpdateCompanion<AccionTomadaTableData> {
  final Value<int> id;
  final Value<int> evaluacionId;
  final Value<int> accionCatalogoId;
  final Value<String> responsable;
  final Value<String> fechaCompromiso;
  final Value<String> estado;
  final Value<String?> notas;
  final Value<String> fechaRegistro;
  const AccionTomadaTableCompanion({
    this.id = const Value.absent(),
    this.evaluacionId = const Value.absent(),
    this.accionCatalogoId = const Value.absent(),
    this.responsable = const Value.absent(),
    this.fechaCompromiso = const Value.absent(),
    this.estado = const Value.absent(),
    this.notas = const Value.absent(),
    this.fechaRegistro = const Value.absent(),
  });
  AccionTomadaTableCompanion.insert({
    this.id = const Value.absent(),
    required int evaluacionId,
    required int accionCatalogoId,
    required String responsable,
    required String fechaCompromiso,
    this.estado = const Value.absent(),
    this.notas = const Value.absent(),
    required String fechaRegistro,
  }) : evaluacionId = Value(evaluacionId),
       accionCatalogoId = Value(accionCatalogoId),
       responsable = Value(responsable),
       fechaCompromiso = Value(fechaCompromiso),
       fechaRegistro = Value(fechaRegistro);
  static Insertable<AccionTomadaTableData> custom({
    Expression<int>? id,
    Expression<int>? evaluacionId,
    Expression<int>? accionCatalogoId,
    Expression<String>? responsable,
    Expression<String>? fechaCompromiso,
    Expression<String>? estado,
    Expression<String>? notas,
    Expression<String>? fechaRegistro,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (evaluacionId != null) 'evaluacion_id': evaluacionId,
      if (accionCatalogoId != null) 'accion_catalogo_id': accionCatalogoId,
      if (responsable != null) 'responsable': responsable,
      if (fechaCompromiso != null) 'fecha_compromiso': fechaCompromiso,
      if (estado != null) 'estado': estado,
      if (notas != null) 'notas': notas,
      if (fechaRegistro != null) 'fecha_registro': fechaRegistro,
    });
  }

  AccionTomadaTableCompanion copyWith({
    Value<int>? id,
    Value<int>? evaluacionId,
    Value<int>? accionCatalogoId,
    Value<String>? responsable,
    Value<String>? fechaCompromiso,
    Value<String>? estado,
    Value<String?>? notas,
    Value<String>? fechaRegistro,
  }) {
    return AccionTomadaTableCompanion(
      id: id ?? this.id,
      evaluacionId: evaluacionId ?? this.evaluacionId,
      accionCatalogoId: accionCatalogoId ?? this.accionCatalogoId,
      responsable: responsable ?? this.responsable,
      fechaCompromiso: fechaCompromiso ?? this.fechaCompromiso,
      estado: estado ?? this.estado,
      notas: notas ?? this.notas,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (evaluacionId.present) {
      map['evaluacion_id'] = Variable<int>(evaluacionId.value);
    }
    if (accionCatalogoId.present) {
      map['accion_catalogo_id'] = Variable<int>(accionCatalogoId.value);
    }
    if (responsable.present) {
      map['responsable'] = Variable<String>(responsable.value);
    }
    if (fechaCompromiso.present) {
      map['fecha_compromiso'] = Variable<String>(fechaCompromiso.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (notas.present) {
      map['notas'] = Variable<String>(notas.value);
    }
    if (fechaRegistro.present) {
      map['fecha_registro'] = Variable<String>(fechaRegistro.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccionTomadaTableCompanion(')
          ..write('id: $id, ')
          ..write('evaluacionId: $evaluacionId, ')
          ..write('accionCatalogoId: $accionCatalogoId, ')
          ..write('responsable: $responsable, ')
          ..write('fechaCompromiso: $fechaCompromiso, ')
          ..write('estado: $estado, ')
          ..write('notas: $notas, ')
          ..write('fechaRegistro: $fechaRegistro')
          ..write(')'))
        .toString();
  }
}

class $VerificacionAccionTableTable extends VerificacionAccionTable
    with TableInfo<$VerificacionAccionTableTable, VerificacionAccionTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VerificacionAccionTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _accionTomadaIdMeta = const VerificationMeta(
    'accionTomadaId',
  );
  @override
  late final GeneratedColumn<int> accionTomadaId = GeneratedColumn<int>(
    'accion_tomada_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accion_tomada (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _periodoVerificacionIdMeta =
      const VerificationMeta('periodoVerificacionId');
  @override
  late final GeneratedColumn<int> periodoVerificacionId = GeneratedColumn<int>(
    'periodo_verificacion_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES periodo (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _resultadoMeta = const VerificationMeta(
    'resultado',
  );
  @override
  late final GeneratedColumn<String> resultado = GeneratedColumn<String>(
    'resultado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valorObservadoMeta = const VerificationMeta(
    'valorObservado',
  );
  @override
  late final GeneratedColumn<double> valorObservado = GeneratedColumn<double>(
    'valor_observado',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _comentarioMeta = const VerificationMeta(
    'comentario',
  );
  @override
  late final GeneratedColumn<String> comentario = GeneratedColumn<String>(
    'comentario',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _confirmadoPorUsuarioMeta =
      const VerificationMeta('confirmadoPorUsuario');
  @override
  late final GeneratedColumn<bool> confirmadoPorUsuario = GeneratedColumn<bool>(
    'confirmado_por_usuario',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("confirmado_por_usuario" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accionTomadaId,
    periodoVerificacionId,
    resultado,
    valorObservado,
    comentario,
    confirmadoPorUsuario,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'verificacion_accion';
  @override
  VerificationContext validateIntegrity(
    Insertable<VerificacionAccionTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('accion_tomada_id')) {
      context.handle(
        _accionTomadaIdMeta,
        accionTomadaId.isAcceptableOrUnknown(
          data['accion_tomada_id']!,
          _accionTomadaIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accionTomadaIdMeta);
    }
    if (data.containsKey('periodo_verificacion_id')) {
      context.handle(
        _periodoVerificacionIdMeta,
        periodoVerificacionId.isAcceptableOrUnknown(
          data['periodo_verificacion_id']!,
          _periodoVerificacionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_periodoVerificacionIdMeta);
    }
    if (data.containsKey('resultado')) {
      context.handle(
        _resultadoMeta,
        resultado.isAcceptableOrUnknown(data['resultado']!, _resultadoMeta),
      );
    } else if (isInserting) {
      context.missing(_resultadoMeta);
    }
    if (data.containsKey('valor_observado')) {
      context.handle(
        _valorObservadoMeta,
        valorObservado.isAcceptableOrUnknown(
          data['valor_observado']!,
          _valorObservadoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_valorObservadoMeta);
    }
    if (data.containsKey('comentario')) {
      context.handle(
        _comentarioMeta,
        comentario.isAcceptableOrUnknown(data['comentario']!, _comentarioMeta),
      );
    }
    if (data.containsKey('confirmado_por_usuario')) {
      context.handle(
        _confirmadoPorUsuarioMeta,
        confirmadoPorUsuario.isAcceptableOrUnknown(
          data['confirmado_por_usuario']!,
          _confirmadoPorUsuarioMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VerificacionAccionTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VerificacionAccionTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      accionTomadaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}accion_tomada_id'],
      )!,
      periodoVerificacionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}periodo_verificacion_id'],
      )!,
      resultado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}resultado'],
      )!,
      valorObservado: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}valor_observado'],
      )!,
      comentario: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}comentario'],
      ),
      confirmadoPorUsuario: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}confirmado_por_usuario'],
      )!,
    );
  }

  @override
  $VerificacionAccionTableTable createAlias(String alias) {
    return $VerificacionAccionTableTable(attachedDatabase, alias);
  }
}

class VerificacionAccionTableData extends DataClass
    implements Insertable<VerificacionAccionTableData> {
  final int id;
  final int accionTomadaId;
  final int periodoVerificacionId;
  final String resultado;
  final double valorObservado;
  final String? comentario;
  final bool confirmadoPorUsuario;
  const VerificacionAccionTableData({
    required this.id,
    required this.accionTomadaId,
    required this.periodoVerificacionId,
    required this.resultado,
    required this.valorObservado,
    this.comentario,
    required this.confirmadoPorUsuario,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['accion_tomada_id'] = Variable<int>(accionTomadaId);
    map['periodo_verificacion_id'] = Variable<int>(periodoVerificacionId);
    map['resultado'] = Variable<String>(resultado);
    map['valor_observado'] = Variable<double>(valorObservado);
    if (!nullToAbsent || comentario != null) {
      map['comentario'] = Variable<String>(comentario);
    }
    map['confirmado_por_usuario'] = Variable<bool>(confirmadoPorUsuario);
    return map;
  }

  VerificacionAccionTableCompanion toCompanion(bool nullToAbsent) {
    return VerificacionAccionTableCompanion(
      id: Value(id),
      accionTomadaId: Value(accionTomadaId),
      periodoVerificacionId: Value(periodoVerificacionId),
      resultado: Value(resultado),
      valorObservado: Value(valorObservado),
      comentario: comentario == null && nullToAbsent
          ? const Value.absent()
          : Value(comentario),
      confirmadoPorUsuario: Value(confirmadoPorUsuario),
    );
  }

  factory VerificacionAccionTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VerificacionAccionTableData(
      id: serializer.fromJson<int>(json['id']),
      accionTomadaId: serializer.fromJson<int>(json['accionTomadaId']),
      periodoVerificacionId: serializer.fromJson<int>(
        json['periodoVerificacionId'],
      ),
      resultado: serializer.fromJson<String>(json['resultado']),
      valorObservado: serializer.fromJson<double>(json['valorObservado']),
      comentario: serializer.fromJson<String?>(json['comentario']),
      confirmadoPorUsuario: serializer.fromJson<bool>(
        json['confirmadoPorUsuario'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accionTomadaId': serializer.toJson<int>(accionTomadaId),
      'periodoVerificacionId': serializer.toJson<int>(periodoVerificacionId),
      'resultado': serializer.toJson<String>(resultado),
      'valorObservado': serializer.toJson<double>(valorObservado),
      'comentario': serializer.toJson<String?>(comentario),
      'confirmadoPorUsuario': serializer.toJson<bool>(confirmadoPorUsuario),
    };
  }

  VerificacionAccionTableData copyWith({
    int? id,
    int? accionTomadaId,
    int? periodoVerificacionId,
    String? resultado,
    double? valorObservado,
    Value<String?> comentario = const Value.absent(),
    bool? confirmadoPorUsuario,
  }) => VerificacionAccionTableData(
    id: id ?? this.id,
    accionTomadaId: accionTomadaId ?? this.accionTomadaId,
    periodoVerificacionId: periodoVerificacionId ?? this.periodoVerificacionId,
    resultado: resultado ?? this.resultado,
    valorObservado: valorObservado ?? this.valorObservado,
    comentario: comentario.present ? comentario.value : this.comentario,
    confirmadoPorUsuario: confirmadoPorUsuario ?? this.confirmadoPorUsuario,
  );
  VerificacionAccionTableData copyWithCompanion(
    VerificacionAccionTableCompanion data,
  ) {
    return VerificacionAccionTableData(
      id: data.id.present ? data.id.value : this.id,
      accionTomadaId: data.accionTomadaId.present
          ? data.accionTomadaId.value
          : this.accionTomadaId,
      periodoVerificacionId: data.periodoVerificacionId.present
          ? data.periodoVerificacionId.value
          : this.periodoVerificacionId,
      resultado: data.resultado.present ? data.resultado.value : this.resultado,
      valorObservado: data.valorObservado.present
          ? data.valorObservado.value
          : this.valorObservado,
      comentario: data.comentario.present
          ? data.comentario.value
          : this.comentario,
      confirmadoPorUsuario: data.confirmadoPorUsuario.present
          ? data.confirmadoPorUsuario.value
          : this.confirmadoPorUsuario,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VerificacionAccionTableData(')
          ..write('id: $id, ')
          ..write('accionTomadaId: $accionTomadaId, ')
          ..write('periodoVerificacionId: $periodoVerificacionId, ')
          ..write('resultado: $resultado, ')
          ..write('valorObservado: $valorObservado, ')
          ..write('comentario: $comentario, ')
          ..write('confirmadoPorUsuario: $confirmadoPorUsuario')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accionTomadaId,
    periodoVerificacionId,
    resultado,
    valorObservado,
    comentario,
    confirmadoPorUsuario,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VerificacionAccionTableData &&
          other.id == this.id &&
          other.accionTomadaId == this.accionTomadaId &&
          other.periodoVerificacionId == this.periodoVerificacionId &&
          other.resultado == this.resultado &&
          other.valorObservado == this.valorObservado &&
          other.comentario == this.comentario &&
          other.confirmadoPorUsuario == this.confirmadoPorUsuario);
}

class VerificacionAccionTableCompanion
    extends UpdateCompanion<VerificacionAccionTableData> {
  final Value<int> id;
  final Value<int> accionTomadaId;
  final Value<int> periodoVerificacionId;
  final Value<String> resultado;
  final Value<double> valorObservado;
  final Value<String?> comentario;
  final Value<bool> confirmadoPorUsuario;
  const VerificacionAccionTableCompanion({
    this.id = const Value.absent(),
    this.accionTomadaId = const Value.absent(),
    this.periodoVerificacionId = const Value.absent(),
    this.resultado = const Value.absent(),
    this.valorObservado = const Value.absent(),
    this.comentario = const Value.absent(),
    this.confirmadoPorUsuario = const Value.absent(),
  });
  VerificacionAccionTableCompanion.insert({
    this.id = const Value.absent(),
    required int accionTomadaId,
    required int periodoVerificacionId,
    required String resultado,
    required double valorObservado,
    this.comentario = const Value.absent(),
    this.confirmadoPorUsuario = const Value.absent(),
  }) : accionTomadaId = Value(accionTomadaId),
       periodoVerificacionId = Value(periodoVerificacionId),
       resultado = Value(resultado),
       valorObservado = Value(valorObservado);
  static Insertable<VerificacionAccionTableData> custom({
    Expression<int>? id,
    Expression<int>? accionTomadaId,
    Expression<int>? periodoVerificacionId,
    Expression<String>? resultado,
    Expression<double>? valorObservado,
    Expression<String>? comentario,
    Expression<bool>? confirmadoPorUsuario,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accionTomadaId != null) 'accion_tomada_id': accionTomadaId,
      if (periodoVerificacionId != null)
        'periodo_verificacion_id': periodoVerificacionId,
      if (resultado != null) 'resultado': resultado,
      if (valorObservado != null) 'valor_observado': valorObservado,
      if (comentario != null) 'comentario': comentario,
      if (confirmadoPorUsuario != null)
        'confirmado_por_usuario': confirmadoPorUsuario,
    });
  }

  VerificacionAccionTableCompanion copyWith({
    Value<int>? id,
    Value<int>? accionTomadaId,
    Value<int>? periodoVerificacionId,
    Value<String>? resultado,
    Value<double>? valorObservado,
    Value<String?>? comentario,
    Value<bool>? confirmadoPorUsuario,
  }) {
    return VerificacionAccionTableCompanion(
      id: id ?? this.id,
      accionTomadaId: accionTomadaId ?? this.accionTomadaId,
      periodoVerificacionId:
          periodoVerificacionId ?? this.periodoVerificacionId,
      resultado: resultado ?? this.resultado,
      valorObservado: valorObservado ?? this.valorObservado,
      comentario: comentario ?? this.comentario,
      confirmadoPorUsuario: confirmadoPorUsuario ?? this.confirmadoPorUsuario,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accionTomadaId.present) {
      map['accion_tomada_id'] = Variable<int>(accionTomadaId.value);
    }
    if (periodoVerificacionId.present) {
      map['periodo_verificacion_id'] = Variable<int>(
        periodoVerificacionId.value,
      );
    }
    if (resultado.present) {
      map['resultado'] = Variable<String>(resultado.value);
    }
    if (valorObservado.present) {
      map['valor_observado'] = Variable<double>(valorObservado.value);
    }
    if (comentario.present) {
      map['comentario'] = Variable<String>(comentario.value);
    }
    if (confirmadoPorUsuario.present) {
      map['confirmado_por_usuario'] = Variable<bool>(
        confirmadoPorUsuario.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VerificacionAccionTableCompanion(')
          ..write('id: $id, ')
          ..write('accionTomadaId: $accionTomadaId, ')
          ..write('periodoVerificacionId: $periodoVerificacionId, ')
          ..write('resultado: $resultado, ')
          ..write('valorObservado: $valorObservado, ')
          ..write('comentario: $comentario, ')
          ..write('confirmadoPorUsuario: $confirmadoPorUsuario')
          ..write(')'))
        .toString();
  }
}

class $PresupuestoTableTable extends PresupuestoTable
    with TableInfo<$PresupuestoTableTable, PresupuestoTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PresupuestoTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _organizacionIdMeta = const VerificationMeta(
    'organizacionId',
  );
  @override
  late final GeneratedColumn<int> organizacionId = GeneratedColumn<int>(
    'organizacion_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES organizacion (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _rubroMeta = const VerificationMeta('rubro');
  @override
  late final GeneratedColumn<String> rubro = GeneratedColumn<String>(
    'rubro',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _periodoIdMeta = const VerificationMeta(
    'periodoId',
  );
  @override
  late final GeneratedColumn<int> periodoId = GeneratedColumn<int>(
    'periodo_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES periodo (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _montoPresupuestadoCentMeta =
      const VerificationMeta('montoPresupuestadoCent');
  @override
  late final GeneratedColumn<int> montoPresupuestadoCent = GeneratedColumn<int>(
    'monto_presupuestado_cent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _montoRealCentMeta = const VerificationMeta(
    'montoRealCent',
  );
  @override
  late final GeneratedColumn<int> montoRealCent = GeneratedColumn<int>(
    'monto_real_cent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    organizacionId,
    rubro,
    periodoId,
    montoPresupuestadoCent,
    montoRealCent,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'presupuesto';
  @override
  VerificationContext validateIntegrity(
    Insertable<PresupuestoTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('organizacion_id')) {
      context.handle(
        _organizacionIdMeta,
        organizacionId.isAcceptableOrUnknown(
          data['organizacion_id']!,
          _organizacionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_organizacionIdMeta);
    }
    if (data.containsKey('rubro')) {
      context.handle(
        _rubroMeta,
        rubro.isAcceptableOrUnknown(data['rubro']!, _rubroMeta),
      );
    } else if (isInserting) {
      context.missing(_rubroMeta);
    }
    if (data.containsKey('periodo_id')) {
      context.handle(
        _periodoIdMeta,
        periodoId.isAcceptableOrUnknown(data['periodo_id']!, _periodoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_periodoIdMeta);
    }
    if (data.containsKey('monto_presupuestado_cent')) {
      context.handle(
        _montoPresupuestadoCentMeta,
        montoPresupuestadoCent.isAcceptableOrUnknown(
          data['monto_presupuestado_cent']!,
          _montoPresupuestadoCentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_montoPresupuestadoCentMeta);
    }
    if (data.containsKey('monto_real_cent')) {
      context.handle(
        _montoRealCentMeta,
        montoRealCent.isAcceptableOrUnknown(
          data['monto_real_cent']!,
          _montoRealCentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_montoRealCentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {organizacionId, rubro, periodoId},
  ];
  @override
  PresupuestoTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PresupuestoTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      organizacionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}organizacion_id'],
      )!,
      rubro: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rubro'],
      )!,
      periodoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}periodo_id'],
      )!,
      montoPresupuestadoCent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monto_presupuestado_cent'],
      )!,
      montoRealCent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monto_real_cent'],
      )!,
    );
  }

  @override
  $PresupuestoTableTable createAlias(String alias) {
    return $PresupuestoTableTable(attachedDatabase, alias);
  }
}

class PresupuestoTableData extends DataClass
    implements Insertable<PresupuestoTableData> {
  final int id;
  final int organizacionId;
  final String rubro;
  final int periodoId;
  final int montoPresupuestadoCent;
  final int montoRealCent;
  const PresupuestoTableData({
    required this.id,
    required this.organizacionId,
    required this.rubro,
    required this.periodoId,
    required this.montoPresupuestadoCent,
    required this.montoRealCent,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['organizacion_id'] = Variable<int>(organizacionId);
    map['rubro'] = Variable<String>(rubro);
    map['periodo_id'] = Variable<int>(periodoId);
    map['monto_presupuestado_cent'] = Variable<int>(montoPresupuestadoCent);
    map['monto_real_cent'] = Variable<int>(montoRealCent);
    return map;
  }

  PresupuestoTableCompanion toCompanion(bool nullToAbsent) {
    return PresupuestoTableCompanion(
      id: Value(id),
      organizacionId: Value(organizacionId),
      rubro: Value(rubro),
      periodoId: Value(periodoId),
      montoPresupuestadoCent: Value(montoPresupuestadoCent),
      montoRealCent: Value(montoRealCent),
    );
  }

  factory PresupuestoTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PresupuestoTableData(
      id: serializer.fromJson<int>(json['id']),
      organizacionId: serializer.fromJson<int>(json['organizacionId']),
      rubro: serializer.fromJson<String>(json['rubro']),
      periodoId: serializer.fromJson<int>(json['periodoId']),
      montoPresupuestadoCent: serializer.fromJson<int>(
        json['montoPresupuestadoCent'],
      ),
      montoRealCent: serializer.fromJson<int>(json['montoRealCent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'organizacionId': serializer.toJson<int>(organizacionId),
      'rubro': serializer.toJson<String>(rubro),
      'periodoId': serializer.toJson<int>(periodoId),
      'montoPresupuestadoCent': serializer.toJson<int>(montoPresupuestadoCent),
      'montoRealCent': serializer.toJson<int>(montoRealCent),
    };
  }

  PresupuestoTableData copyWith({
    int? id,
    int? organizacionId,
    String? rubro,
    int? periodoId,
    int? montoPresupuestadoCent,
    int? montoRealCent,
  }) => PresupuestoTableData(
    id: id ?? this.id,
    organizacionId: organizacionId ?? this.organizacionId,
    rubro: rubro ?? this.rubro,
    periodoId: periodoId ?? this.periodoId,
    montoPresupuestadoCent:
        montoPresupuestadoCent ?? this.montoPresupuestadoCent,
    montoRealCent: montoRealCent ?? this.montoRealCent,
  );
  PresupuestoTableData copyWithCompanion(PresupuestoTableCompanion data) {
    return PresupuestoTableData(
      id: data.id.present ? data.id.value : this.id,
      organizacionId: data.organizacionId.present
          ? data.organizacionId.value
          : this.organizacionId,
      rubro: data.rubro.present ? data.rubro.value : this.rubro,
      periodoId: data.periodoId.present ? data.periodoId.value : this.periodoId,
      montoPresupuestadoCent: data.montoPresupuestadoCent.present
          ? data.montoPresupuestadoCent.value
          : this.montoPresupuestadoCent,
      montoRealCent: data.montoRealCent.present
          ? data.montoRealCent.value
          : this.montoRealCent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PresupuestoTableData(')
          ..write('id: $id, ')
          ..write('organizacionId: $organizacionId, ')
          ..write('rubro: $rubro, ')
          ..write('periodoId: $periodoId, ')
          ..write('montoPresupuestadoCent: $montoPresupuestadoCent, ')
          ..write('montoRealCent: $montoRealCent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    organizacionId,
    rubro,
    periodoId,
    montoPresupuestadoCent,
    montoRealCent,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PresupuestoTableData &&
          other.id == this.id &&
          other.organizacionId == this.organizacionId &&
          other.rubro == this.rubro &&
          other.periodoId == this.periodoId &&
          other.montoPresupuestadoCent == this.montoPresupuestadoCent &&
          other.montoRealCent == this.montoRealCent);
}

class PresupuestoTableCompanion extends UpdateCompanion<PresupuestoTableData> {
  final Value<int> id;
  final Value<int> organizacionId;
  final Value<String> rubro;
  final Value<int> periodoId;
  final Value<int> montoPresupuestadoCent;
  final Value<int> montoRealCent;
  const PresupuestoTableCompanion({
    this.id = const Value.absent(),
    this.organizacionId = const Value.absent(),
    this.rubro = const Value.absent(),
    this.periodoId = const Value.absent(),
    this.montoPresupuestadoCent = const Value.absent(),
    this.montoRealCent = const Value.absent(),
  });
  PresupuestoTableCompanion.insert({
    this.id = const Value.absent(),
    required int organizacionId,
    required String rubro,
    required int periodoId,
    required int montoPresupuestadoCent,
    required int montoRealCent,
  }) : organizacionId = Value(organizacionId),
       rubro = Value(rubro),
       periodoId = Value(periodoId),
       montoPresupuestadoCent = Value(montoPresupuestadoCent),
       montoRealCent = Value(montoRealCent);
  static Insertable<PresupuestoTableData> custom({
    Expression<int>? id,
    Expression<int>? organizacionId,
    Expression<String>? rubro,
    Expression<int>? periodoId,
    Expression<int>? montoPresupuestadoCent,
    Expression<int>? montoRealCent,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (organizacionId != null) 'organizacion_id': organizacionId,
      if (rubro != null) 'rubro': rubro,
      if (periodoId != null) 'periodo_id': periodoId,
      if (montoPresupuestadoCent != null)
        'monto_presupuestado_cent': montoPresupuestadoCent,
      if (montoRealCent != null) 'monto_real_cent': montoRealCent,
    });
  }

  PresupuestoTableCompanion copyWith({
    Value<int>? id,
    Value<int>? organizacionId,
    Value<String>? rubro,
    Value<int>? periodoId,
    Value<int>? montoPresupuestadoCent,
    Value<int>? montoRealCent,
  }) {
    return PresupuestoTableCompanion(
      id: id ?? this.id,
      organizacionId: organizacionId ?? this.organizacionId,
      rubro: rubro ?? this.rubro,
      periodoId: periodoId ?? this.periodoId,
      montoPresupuestadoCent:
          montoPresupuestadoCent ?? this.montoPresupuestadoCent,
      montoRealCent: montoRealCent ?? this.montoRealCent,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (organizacionId.present) {
      map['organizacion_id'] = Variable<int>(organizacionId.value);
    }
    if (rubro.present) {
      map['rubro'] = Variable<String>(rubro.value);
    }
    if (periodoId.present) {
      map['periodo_id'] = Variable<int>(periodoId.value);
    }
    if (montoPresupuestadoCent.present) {
      map['monto_presupuestado_cent'] = Variable<int>(
        montoPresupuestadoCent.value,
      );
    }
    if (montoRealCent.present) {
      map['monto_real_cent'] = Variable<int>(montoRealCent.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PresupuestoTableCompanion(')
          ..write('id: $id, ')
          ..write('organizacionId: $organizacionId, ')
          ..write('rubro: $rubro, ')
          ..write('periodoId: $periodoId, ')
          ..write('montoPresupuestadoCent: $montoPresupuestadoCent, ')
          ..write('montoRealCent: $montoRealCent')
          ..write(')'))
        .toString();
  }
}

class $EscenarioSinteticoTableTable extends EscenarioSinteticoTable
    with TableInfo<$EscenarioSinteticoTableTable, EscenarioSinteticoTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EscenarioSinteticoTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _indicadorBaseIdMeta = const VerificationMeta(
    'indicadorBaseId',
  );
  @override
  late final GeneratedColumn<int> indicadorBaseId = GeneratedColumn<int>(
    'indicador_base_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES indicador (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _patronMeta = const VerificationMeta('patron');
  @override
  late final GeneratedColumn<String> patron = GeneratedColumn<String>(
    'patron',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parametrosJsonMeta = const VerificationMeta(
    'parametrosJson',
  );
  @override
  late final GeneratedColumn<String> parametrosJson = GeneratedColumn<String>(
    'parametros_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _semillaMeta = const VerificationMeta(
    'semilla',
  );
  @override
  late final GeneratedColumn<int> semilla = GeneratedColumn<int>(
    'semilla',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numeroPeriodosMeta = const VerificationMeta(
    'numeroPeriodos',
  );
  @override
  late final GeneratedColumn<int> numeroPeriodos = GeneratedColumn<int>(
    'numero_periodos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    indicadorBaseId,
    patron,
    parametrosJson,
    semilla,
    numeroPeriodos,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'escenario_sintetico';
  @override
  VerificationContext validateIntegrity(
    Insertable<EscenarioSinteticoTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('indicador_base_id')) {
      context.handle(
        _indicadorBaseIdMeta,
        indicadorBaseId.isAcceptableOrUnknown(
          data['indicador_base_id']!,
          _indicadorBaseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_indicadorBaseIdMeta);
    }
    if (data.containsKey('patron')) {
      context.handle(
        _patronMeta,
        patron.isAcceptableOrUnknown(data['patron']!, _patronMeta),
      );
    } else if (isInserting) {
      context.missing(_patronMeta);
    }
    if (data.containsKey('parametros_json')) {
      context.handle(
        _parametrosJsonMeta,
        parametrosJson.isAcceptableOrUnknown(
          data['parametros_json']!,
          _parametrosJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_parametrosJsonMeta);
    }
    if (data.containsKey('semilla')) {
      context.handle(
        _semillaMeta,
        semilla.isAcceptableOrUnknown(data['semilla']!, _semillaMeta),
      );
    } else if (isInserting) {
      context.missing(_semillaMeta);
    }
    if (data.containsKey('numero_periodos')) {
      context.handle(
        _numeroPeriodosMeta,
        numeroPeriodos.isAcceptableOrUnknown(
          data['numero_periodos']!,
          _numeroPeriodosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_numeroPeriodosMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EscenarioSinteticoTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EscenarioSinteticoTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      indicadorBaseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}indicador_base_id'],
      )!,
      patron: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}patron'],
      )!,
      parametrosJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parametros_json'],
      )!,
      semilla: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}semilla'],
      )!,
      numeroPeriodos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}numero_periodos'],
      )!,
    );
  }

  @override
  $EscenarioSinteticoTableTable createAlias(String alias) {
    return $EscenarioSinteticoTableTable(attachedDatabase, alias);
  }
}

class EscenarioSinteticoTableData extends DataClass
    implements Insertable<EscenarioSinteticoTableData> {
  final int id;
  final String nombre;
  final int indicadorBaseId;
  final String patron;
  final String parametrosJson;
  final int semilla;
  final int numeroPeriodos;
  const EscenarioSinteticoTableData({
    required this.id,
    required this.nombre,
    required this.indicadorBaseId,
    required this.patron,
    required this.parametrosJson,
    required this.semilla,
    required this.numeroPeriodos,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['indicador_base_id'] = Variable<int>(indicadorBaseId);
    map['patron'] = Variable<String>(patron);
    map['parametros_json'] = Variable<String>(parametrosJson);
    map['semilla'] = Variable<int>(semilla);
    map['numero_periodos'] = Variable<int>(numeroPeriodos);
    return map;
  }

  EscenarioSinteticoTableCompanion toCompanion(bool nullToAbsent) {
    return EscenarioSinteticoTableCompanion(
      id: Value(id),
      nombre: Value(nombre),
      indicadorBaseId: Value(indicadorBaseId),
      patron: Value(patron),
      parametrosJson: Value(parametrosJson),
      semilla: Value(semilla),
      numeroPeriodos: Value(numeroPeriodos),
    );
  }

  factory EscenarioSinteticoTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EscenarioSinteticoTableData(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      indicadorBaseId: serializer.fromJson<int>(json['indicadorBaseId']),
      patron: serializer.fromJson<String>(json['patron']),
      parametrosJson: serializer.fromJson<String>(json['parametrosJson']),
      semilla: serializer.fromJson<int>(json['semilla']),
      numeroPeriodos: serializer.fromJson<int>(json['numeroPeriodos']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'indicadorBaseId': serializer.toJson<int>(indicadorBaseId),
      'patron': serializer.toJson<String>(patron),
      'parametrosJson': serializer.toJson<String>(parametrosJson),
      'semilla': serializer.toJson<int>(semilla),
      'numeroPeriodos': serializer.toJson<int>(numeroPeriodos),
    };
  }

  EscenarioSinteticoTableData copyWith({
    int? id,
    String? nombre,
    int? indicadorBaseId,
    String? patron,
    String? parametrosJson,
    int? semilla,
    int? numeroPeriodos,
  }) => EscenarioSinteticoTableData(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    indicadorBaseId: indicadorBaseId ?? this.indicadorBaseId,
    patron: patron ?? this.patron,
    parametrosJson: parametrosJson ?? this.parametrosJson,
    semilla: semilla ?? this.semilla,
    numeroPeriodos: numeroPeriodos ?? this.numeroPeriodos,
  );
  EscenarioSinteticoTableData copyWithCompanion(
    EscenarioSinteticoTableCompanion data,
  ) {
    return EscenarioSinteticoTableData(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      indicadorBaseId: data.indicadorBaseId.present
          ? data.indicadorBaseId.value
          : this.indicadorBaseId,
      patron: data.patron.present ? data.patron.value : this.patron,
      parametrosJson: data.parametrosJson.present
          ? data.parametrosJson.value
          : this.parametrosJson,
      semilla: data.semilla.present ? data.semilla.value : this.semilla,
      numeroPeriodos: data.numeroPeriodos.present
          ? data.numeroPeriodos.value
          : this.numeroPeriodos,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EscenarioSinteticoTableData(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('indicadorBaseId: $indicadorBaseId, ')
          ..write('patron: $patron, ')
          ..write('parametrosJson: $parametrosJson, ')
          ..write('semilla: $semilla, ')
          ..write('numeroPeriodos: $numeroPeriodos')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    indicadorBaseId,
    patron,
    parametrosJson,
    semilla,
    numeroPeriodos,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EscenarioSinteticoTableData &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.indicadorBaseId == this.indicadorBaseId &&
          other.patron == this.patron &&
          other.parametrosJson == this.parametrosJson &&
          other.semilla == this.semilla &&
          other.numeroPeriodos == this.numeroPeriodos);
}

class EscenarioSinteticoTableCompanion
    extends UpdateCompanion<EscenarioSinteticoTableData> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<int> indicadorBaseId;
  final Value<String> patron;
  final Value<String> parametrosJson;
  final Value<int> semilla;
  final Value<int> numeroPeriodos;
  const EscenarioSinteticoTableCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.indicadorBaseId = const Value.absent(),
    this.patron = const Value.absent(),
    this.parametrosJson = const Value.absent(),
    this.semilla = const Value.absent(),
    this.numeroPeriodos = const Value.absent(),
  });
  EscenarioSinteticoTableCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required int indicadorBaseId,
    required String patron,
    required String parametrosJson,
    required int semilla,
    required int numeroPeriodos,
  }) : nombre = Value(nombre),
       indicadorBaseId = Value(indicadorBaseId),
       patron = Value(patron),
       parametrosJson = Value(parametrosJson),
       semilla = Value(semilla),
       numeroPeriodos = Value(numeroPeriodos);
  static Insertable<EscenarioSinteticoTableData> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<int>? indicadorBaseId,
    Expression<String>? patron,
    Expression<String>? parametrosJson,
    Expression<int>? semilla,
    Expression<int>? numeroPeriodos,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (indicadorBaseId != null) 'indicador_base_id': indicadorBaseId,
      if (patron != null) 'patron': patron,
      if (parametrosJson != null) 'parametros_json': parametrosJson,
      if (semilla != null) 'semilla': semilla,
      if (numeroPeriodos != null) 'numero_periodos': numeroPeriodos,
    });
  }

  EscenarioSinteticoTableCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<int>? indicadorBaseId,
    Value<String>? patron,
    Value<String>? parametrosJson,
    Value<int>? semilla,
    Value<int>? numeroPeriodos,
  }) {
    return EscenarioSinteticoTableCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      indicadorBaseId: indicadorBaseId ?? this.indicadorBaseId,
      patron: patron ?? this.patron,
      parametrosJson: parametrosJson ?? this.parametrosJson,
      semilla: semilla ?? this.semilla,
      numeroPeriodos: numeroPeriodos ?? this.numeroPeriodos,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (indicadorBaseId.present) {
      map['indicador_base_id'] = Variable<int>(indicadorBaseId.value);
    }
    if (patron.present) {
      map['patron'] = Variable<String>(patron.value);
    }
    if (parametrosJson.present) {
      map['parametros_json'] = Variable<String>(parametrosJson.value);
    }
    if (semilla.present) {
      map['semilla'] = Variable<int>(semilla.value);
    }
    if (numeroPeriodos.present) {
      map['numero_periodos'] = Variable<int>(numeroPeriodos.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EscenarioSinteticoTableCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('indicadorBaseId: $indicadorBaseId, ')
          ..write('patron: $patron, ')
          ..write('parametrosJson: $parametrosJson, ')
          ..write('semilla: $semilla, ')
          ..write('numeroPeriodos: $numeroPeriodos')
          ..write(')'))
        .toString();
  }
}

class $DiagnosticoOrganizacionalTableTable
    extends DiagnosticoOrganizacionalTable
    with
        TableInfo<
          $DiagnosticoOrganizacionalTableTable,
          DiagnosticoOrganizacionalTableData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiagnosticoOrganizacionalTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _organizacionIdMeta = const VerificationMeta(
    'organizacionId',
  );
  @override
  late final GeneratedColumn<int> organizacionId = GeneratedColumn<int>(
    'organizacion_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES organizacion (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<String> fecha = GeneratedColumn<String>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _respuestasJsonMeta = const VerificationMeta(
    'respuestasJson',
  );
  @override
  late final GeneratedColumn<String> respuestasJson = GeneratedColumn<String>(
    'respuestas_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _etapaResultanteMeta = const VerificationMeta(
    'etapaResultante',
  );
  @override
  late final GeneratedColumn<String> etapaResultante = GeneratedColumn<String>(
    'etapa_resultante',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _opcionOrganizacionalMeta =
      const VerificationMeta('opcionOrganizacional');
  @override
  late final GeneratedColumn<String> opcionOrganizacional =
      GeneratedColumn<String>(
        'opcion_organizacional',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _ejesJsonMeta = const VerificationMeta(
    'ejesJson',
  );
  @override
  late final GeneratedColumn<String> ejesJson = GeneratedColumn<String>(
    'ejes_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orientacionDominanteMeta =
      const VerificationMeta('orientacionDominante');
  @override
  late final GeneratedColumn<String> orientacionDominante =
      GeneratedColumn<String>(
        'orientacion_dominante',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    organizacionId,
    fecha,
    respuestasJson,
    etapaResultante,
    opcionOrganizacional,
    ejesJson,
    orientacionDominante,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'diagnostico_organizacional';
  @override
  VerificationContext validateIntegrity(
    Insertable<DiagnosticoOrganizacionalTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('organizacion_id')) {
      context.handle(
        _organizacionIdMeta,
        organizacionId.isAcceptableOrUnknown(
          data['organizacion_id']!,
          _organizacionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_organizacionIdMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    if (data.containsKey('respuestas_json')) {
      context.handle(
        _respuestasJsonMeta,
        respuestasJson.isAcceptableOrUnknown(
          data['respuestas_json']!,
          _respuestasJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_respuestasJsonMeta);
    }
    if (data.containsKey('etapa_resultante')) {
      context.handle(
        _etapaResultanteMeta,
        etapaResultante.isAcceptableOrUnknown(
          data['etapa_resultante']!,
          _etapaResultanteMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_etapaResultanteMeta);
    }
    if (data.containsKey('opcion_organizacional')) {
      context.handle(
        _opcionOrganizacionalMeta,
        opcionOrganizacional.isAcceptableOrUnknown(
          data['opcion_organizacional']!,
          _opcionOrganizacionalMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_opcionOrganizacionalMeta);
    }
    if (data.containsKey('ejes_json')) {
      context.handle(
        _ejesJsonMeta,
        ejesJson.isAcceptableOrUnknown(data['ejes_json']!, _ejesJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_ejesJsonMeta);
    }
    if (data.containsKey('orientacion_dominante')) {
      context.handle(
        _orientacionDominanteMeta,
        orientacionDominante.isAcceptableOrUnknown(
          data['orientacion_dominante']!,
          _orientacionDominanteMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_orientacionDominanteMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiagnosticoOrganizacionalTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiagnosticoOrganizacionalTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      organizacionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}organizacion_id'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fecha'],
      )!,
      respuestasJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}respuestas_json'],
      )!,
      etapaResultante: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}etapa_resultante'],
      )!,
      opcionOrganizacional: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}opcion_organizacional'],
      )!,
      ejesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ejes_json'],
      )!,
      orientacionDominante: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}orientacion_dominante'],
      )!,
    );
  }

  @override
  $DiagnosticoOrganizacionalTableTable createAlias(String alias) {
    return $DiagnosticoOrganizacionalTableTable(attachedDatabase, alias);
  }
}

class DiagnosticoOrganizacionalTableData extends DataClass
    implements Insertable<DiagnosticoOrganizacionalTableData> {
  final int id;
  final int organizacionId;
  final String fecha;
  final String respuestasJson;
  final String etapaResultante;
  final String opcionOrganizacional;
  final String ejesJson;
  final String orientacionDominante;
  const DiagnosticoOrganizacionalTableData({
    required this.id,
    required this.organizacionId,
    required this.fecha,
    required this.respuestasJson,
    required this.etapaResultante,
    required this.opcionOrganizacional,
    required this.ejesJson,
    required this.orientacionDominante,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['organizacion_id'] = Variable<int>(organizacionId);
    map['fecha'] = Variable<String>(fecha);
    map['respuestas_json'] = Variable<String>(respuestasJson);
    map['etapa_resultante'] = Variable<String>(etapaResultante);
    map['opcion_organizacional'] = Variable<String>(opcionOrganizacional);
    map['ejes_json'] = Variable<String>(ejesJson);
    map['orientacion_dominante'] = Variable<String>(orientacionDominante);
    return map;
  }

  DiagnosticoOrganizacionalTableCompanion toCompanion(bool nullToAbsent) {
    return DiagnosticoOrganizacionalTableCompanion(
      id: Value(id),
      organizacionId: Value(organizacionId),
      fecha: Value(fecha),
      respuestasJson: Value(respuestasJson),
      etapaResultante: Value(etapaResultante),
      opcionOrganizacional: Value(opcionOrganizacional),
      ejesJson: Value(ejesJson),
      orientacionDominante: Value(orientacionDominante),
    );
  }

  factory DiagnosticoOrganizacionalTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiagnosticoOrganizacionalTableData(
      id: serializer.fromJson<int>(json['id']),
      organizacionId: serializer.fromJson<int>(json['organizacionId']),
      fecha: serializer.fromJson<String>(json['fecha']),
      respuestasJson: serializer.fromJson<String>(json['respuestasJson']),
      etapaResultante: serializer.fromJson<String>(json['etapaResultante']),
      opcionOrganizacional: serializer.fromJson<String>(
        json['opcionOrganizacional'],
      ),
      ejesJson: serializer.fromJson<String>(json['ejesJson']),
      orientacionDominante: serializer.fromJson<String>(
        json['orientacionDominante'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'organizacionId': serializer.toJson<int>(organizacionId),
      'fecha': serializer.toJson<String>(fecha),
      'respuestasJson': serializer.toJson<String>(respuestasJson),
      'etapaResultante': serializer.toJson<String>(etapaResultante),
      'opcionOrganizacional': serializer.toJson<String>(opcionOrganizacional),
      'ejesJson': serializer.toJson<String>(ejesJson),
      'orientacionDominante': serializer.toJson<String>(orientacionDominante),
    };
  }

  DiagnosticoOrganizacionalTableData copyWith({
    int? id,
    int? organizacionId,
    String? fecha,
    String? respuestasJson,
    String? etapaResultante,
    String? opcionOrganizacional,
    String? ejesJson,
    String? orientacionDominante,
  }) => DiagnosticoOrganizacionalTableData(
    id: id ?? this.id,
    organizacionId: organizacionId ?? this.organizacionId,
    fecha: fecha ?? this.fecha,
    respuestasJson: respuestasJson ?? this.respuestasJson,
    etapaResultante: etapaResultante ?? this.etapaResultante,
    opcionOrganizacional: opcionOrganizacional ?? this.opcionOrganizacional,
    ejesJson: ejesJson ?? this.ejesJson,
    orientacionDominante: orientacionDominante ?? this.orientacionDominante,
  );
  DiagnosticoOrganizacionalTableData copyWithCompanion(
    DiagnosticoOrganizacionalTableCompanion data,
  ) {
    return DiagnosticoOrganizacionalTableData(
      id: data.id.present ? data.id.value : this.id,
      organizacionId: data.organizacionId.present
          ? data.organizacionId.value
          : this.organizacionId,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      respuestasJson: data.respuestasJson.present
          ? data.respuestasJson.value
          : this.respuestasJson,
      etapaResultante: data.etapaResultante.present
          ? data.etapaResultante.value
          : this.etapaResultante,
      opcionOrganizacional: data.opcionOrganizacional.present
          ? data.opcionOrganizacional.value
          : this.opcionOrganizacional,
      ejesJson: data.ejesJson.present ? data.ejesJson.value : this.ejesJson,
      orientacionDominante: data.orientacionDominante.present
          ? data.orientacionDominante.value
          : this.orientacionDominante,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiagnosticoOrganizacionalTableData(')
          ..write('id: $id, ')
          ..write('organizacionId: $organizacionId, ')
          ..write('fecha: $fecha, ')
          ..write('respuestasJson: $respuestasJson, ')
          ..write('etapaResultante: $etapaResultante, ')
          ..write('opcionOrganizacional: $opcionOrganizacional, ')
          ..write('ejesJson: $ejesJson, ')
          ..write('orientacionDominante: $orientacionDominante')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    organizacionId,
    fecha,
    respuestasJson,
    etapaResultante,
    opcionOrganizacional,
    ejesJson,
    orientacionDominante,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiagnosticoOrganizacionalTableData &&
          other.id == this.id &&
          other.organizacionId == this.organizacionId &&
          other.fecha == this.fecha &&
          other.respuestasJson == this.respuestasJson &&
          other.etapaResultante == this.etapaResultante &&
          other.opcionOrganizacional == this.opcionOrganizacional &&
          other.ejesJson == this.ejesJson &&
          other.orientacionDominante == this.orientacionDominante);
}

class DiagnosticoOrganizacionalTableCompanion
    extends UpdateCompanion<DiagnosticoOrganizacionalTableData> {
  final Value<int> id;
  final Value<int> organizacionId;
  final Value<String> fecha;
  final Value<String> respuestasJson;
  final Value<String> etapaResultante;
  final Value<String> opcionOrganizacional;
  final Value<String> ejesJson;
  final Value<String> orientacionDominante;
  const DiagnosticoOrganizacionalTableCompanion({
    this.id = const Value.absent(),
    this.organizacionId = const Value.absent(),
    this.fecha = const Value.absent(),
    this.respuestasJson = const Value.absent(),
    this.etapaResultante = const Value.absent(),
    this.opcionOrganizacional = const Value.absent(),
    this.ejesJson = const Value.absent(),
    this.orientacionDominante = const Value.absent(),
  });
  DiagnosticoOrganizacionalTableCompanion.insert({
    this.id = const Value.absent(),
    required int organizacionId,
    required String fecha,
    required String respuestasJson,
    required String etapaResultante,
    required String opcionOrganizacional,
    required String ejesJson,
    required String orientacionDominante,
  }) : organizacionId = Value(organizacionId),
       fecha = Value(fecha),
       respuestasJson = Value(respuestasJson),
       etapaResultante = Value(etapaResultante),
       opcionOrganizacional = Value(opcionOrganizacional),
       ejesJson = Value(ejesJson),
       orientacionDominante = Value(orientacionDominante);
  static Insertable<DiagnosticoOrganizacionalTableData> custom({
    Expression<int>? id,
    Expression<int>? organizacionId,
    Expression<String>? fecha,
    Expression<String>? respuestasJson,
    Expression<String>? etapaResultante,
    Expression<String>? opcionOrganizacional,
    Expression<String>? ejesJson,
    Expression<String>? orientacionDominante,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (organizacionId != null) 'organizacion_id': organizacionId,
      if (fecha != null) 'fecha': fecha,
      if (respuestasJson != null) 'respuestas_json': respuestasJson,
      if (etapaResultante != null) 'etapa_resultante': etapaResultante,
      if (opcionOrganizacional != null)
        'opcion_organizacional': opcionOrganizacional,
      if (ejesJson != null) 'ejes_json': ejesJson,
      if (orientacionDominante != null)
        'orientacion_dominante': orientacionDominante,
    });
  }

  DiagnosticoOrganizacionalTableCompanion copyWith({
    Value<int>? id,
    Value<int>? organizacionId,
    Value<String>? fecha,
    Value<String>? respuestasJson,
    Value<String>? etapaResultante,
    Value<String>? opcionOrganizacional,
    Value<String>? ejesJson,
    Value<String>? orientacionDominante,
  }) {
    return DiagnosticoOrganizacionalTableCompanion(
      id: id ?? this.id,
      organizacionId: organizacionId ?? this.organizacionId,
      fecha: fecha ?? this.fecha,
      respuestasJson: respuestasJson ?? this.respuestasJson,
      etapaResultante: etapaResultante ?? this.etapaResultante,
      opcionOrganizacional: opcionOrganizacional ?? this.opcionOrganizacional,
      ejesJson: ejesJson ?? this.ejesJson,
      orientacionDominante: orientacionDominante ?? this.orientacionDominante,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (organizacionId.present) {
      map['organizacion_id'] = Variable<int>(organizacionId.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<String>(fecha.value);
    }
    if (respuestasJson.present) {
      map['respuestas_json'] = Variable<String>(respuestasJson.value);
    }
    if (etapaResultante.present) {
      map['etapa_resultante'] = Variable<String>(etapaResultante.value);
    }
    if (opcionOrganizacional.present) {
      map['opcion_organizacional'] = Variable<String>(
        opcionOrganizacional.value,
      );
    }
    if (ejesJson.present) {
      map['ejes_json'] = Variable<String>(ejesJson.value);
    }
    if (orientacionDominante.present) {
      map['orientacion_dominante'] = Variable<String>(
        orientacionDominante.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiagnosticoOrganizacionalTableCompanion(')
          ..write('id: $id, ')
          ..write('organizacionId: $organizacionId, ')
          ..write('fecha: $fecha, ')
          ..write('respuestasJson: $respuestasJson, ')
          ..write('etapaResultante: $etapaResultante, ')
          ..write('opcionOrganizacional: $opcionOrganizacional, ')
          ..write('ejesJson: $ejesJson, ')
          ..write('orientacionDominante: $orientacionDominante')
          ..write(')'))
        .toString();
  }
}

class $FacturaTransporteTableTable extends FacturaTransporteTable
    with TableInfo<$FacturaTransporteTableTable, FacturaTransporteTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FacturaTransporteTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _organizacionIdMeta = const VerificationMeta(
    'organizacionId',
  );
  @override
  late final GeneratedColumn<int> organizacionId = GeneratedColumn<int>(
    'organizacion_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES organizacion (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _numeroMeta = const VerificationMeta('numero');
  @override
  late final GeneratedColumn<String> numero = GeneratedColumn<String>(
    'numero',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transportistaMeta = const VerificationMeta(
    'transportista',
  );
  @override
  late final GeneratedColumn<String> transportista = GeneratedColumn<String>(
    'transportista',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pesoMeta = const VerificationMeta('peso');
  @override
  late final GeneratedColumn<double> peso = GeneratedColumn<double>(
    'peso',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rutaMeta = const VerificationMeta('ruta');
  @override
  late final GeneratedColumn<String> ruta = GeneratedColumn<String>(
    'ruta',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tarifaAplicadaCentMeta =
      const VerificationMeta('tarifaAplicadaCent');
  @override
  late final GeneratedColumn<int> tarifaAplicadaCent = GeneratedColumn<int>(
    'tarifa_aplicada_cent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tarifaContratadaCentMeta =
      const VerificationMeta('tarifaContratadaCent');
  @override
  late final GeneratedColumn<int> tarifaContratadaCent = GeneratedColumn<int>(
    'tarifa_contratada_cent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _discrepanciaTipoMeta = const VerificationMeta(
    'discrepanciaTipo',
  );
  @override
  late final GeneratedColumn<String> discrepanciaTipo = GeneratedColumn<String>(
    'discrepancia_tipo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _montoRecuperableCentMeta =
      const VerificationMeta('montoRecuperableCent');
  @override
  late final GeneratedColumn<int> montoRecuperableCent = GeneratedColumn<int>(
    'monto_recuperable_cent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
    'estado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pendiente'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    organizacionId,
    numero,
    transportista,
    peso,
    ruta,
    tarifaAplicadaCent,
    tarifaContratadaCent,
    discrepanciaTipo,
    montoRecuperableCent,
    estado,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'factura_transporte';
  @override
  VerificationContext validateIntegrity(
    Insertable<FacturaTransporteTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('organizacion_id')) {
      context.handle(
        _organizacionIdMeta,
        organizacionId.isAcceptableOrUnknown(
          data['organizacion_id']!,
          _organizacionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_organizacionIdMeta);
    }
    if (data.containsKey('numero')) {
      context.handle(
        _numeroMeta,
        numero.isAcceptableOrUnknown(data['numero']!, _numeroMeta),
      );
    } else if (isInserting) {
      context.missing(_numeroMeta);
    }
    if (data.containsKey('transportista')) {
      context.handle(
        _transportistaMeta,
        transportista.isAcceptableOrUnknown(
          data['transportista']!,
          _transportistaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transportistaMeta);
    }
    if (data.containsKey('peso')) {
      context.handle(
        _pesoMeta,
        peso.isAcceptableOrUnknown(data['peso']!, _pesoMeta),
      );
    } else if (isInserting) {
      context.missing(_pesoMeta);
    }
    if (data.containsKey('ruta')) {
      context.handle(
        _rutaMeta,
        ruta.isAcceptableOrUnknown(data['ruta']!, _rutaMeta),
      );
    } else if (isInserting) {
      context.missing(_rutaMeta);
    }
    if (data.containsKey('tarifa_aplicada_cent')) {
      context.handle(
        _tarifaAplicadaCentMeta,
        tarifaAplicadaCent.isAcceptableOrUnknown(
          data['tarifa_aplicada_cent']!,
          _tarifaAplicadaCentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tarifaAplicadaCentMeta);
    }
    if (data.containsKey('tarifa_contratada_cent')) {
      context.handle(
        _tarifaContratadaCentMeta,
        tarifaContratadaCent.isAcceptableOrUnknown(
          data['tarifa_contratada_cent']!,
          _tarifaContratadaCentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tarifaContratadaCentMeta);
    }
    if (data.containsKey('discrepancia_tipo')) {
      context.handle(
        _discrepanciaTipoMeta,
        discrepanciaTipo.isAcceptableOrUnknown(
          data['discrepancia_tipo']!,
          _discrepanciaTipoMeta,
        ),
      );
    }
    if (data.containsKey('monto_recuperable_cent')) {
      context.handle(
        _montoRecuperableCentMeta,
        montoRecuperableCent.isAcceptableOrUnknown(
          data['monto_recuperable_cent']!,
          _montoRecuperableCentMeta,
        ),
      );
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FacturaTransporteTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FacturaTransporteTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      organizacionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}organizacion_id'],
      )!,
      numero: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}numero'],
      )!,
      transportista: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transportista'],
      )!,
      peso: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}peso'],
      )!,
      ruta: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ruta'],
      )!,
      tarifaAplicadaCent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tarifa_aplicada_cent'],
      )!,
      tarifaContratadaCent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tarifa_contratada_cent'],
      )!,
      discrepanciaTipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}discrepancia_tipo'],
      ),
      montoRecuperableCent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monto_recuperable_cent'],
      )!,
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
      )!,
    );
  }

  @override
  $FacturaTransporteTableTable createAlias(String alias) {
    return $FacturaTransporteTableTable(attachedDatabase, alias);
  }
}

class FacturaTransporteTableData extends DataClass
    implements Insertable<FacturaTransporteTableData> {
  final int id;
  final int organizacionId;
  final String numero;
  final String transportista;
  final double peso;
  final String ruta;
  final int tarifaAplicadaCent;
  final int tarifaContratadaCent;
  final String? discrepanciaTipo;
  final int montoRecuperableCent;
  final String estado;
  const FacturaTransporteTableData({
    required this.id,
    required this.organizacionId,
    required this.numero,
    required this.transportista,
    required this.peso,
    required this.ruta,
    required this.tarifaAplicadaCent,
    required this.tarifaContratadaCent,
    this.discrepanciaTipo,
    required this.montoRecuperableCent,
    required this.estado,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['organizacion_id'] = Variable<int>(organizacionId);
    map['numero'] = Variable<String>(numero);
    map['transportista'] = Variable<String>(transportista);
    map['peso'] = Variable<double>(peso);
    map['ruta'] = Variable<String>(ruta);
    map['tarifa_aplicada_cent'] = Variable<int>(tarifaAplicadaCent);
    map['tarifa_contratada_cent'] = Variable<int>(tarifaContratadaCent);
    if (!nullToAbsent || discrepanciaTipo != null) {
      map['discrepancia_tipo'] = Variable<String>(discrepanciaTipo);
    }
    map['monto_recuperable_cent'] = Variable<int>(montoRecuperableCent);
    map['estado'] = Variable<String>(estado);
    return map;
  }

  FacturaTransporteTableCompanion toCompanion(bool nullToAbsent) {
    return FacturaTransporteTableCompanion(
      id: Value(id),
      organizacionId: Value(organizacionId),
      numero: Value(numero),
      transportista: Value(transportista),
      peso: Value(peso),
      ruta: Value(ruta),
      tarifaAplicadaCent: Value(tarifaAplicadaCent),
      tarifaContratadaCent: Value(tarifaContratadaCent),
      discrepanciaTipo: discrepanciaTipo == null && nullToAbsent
          ? const Value.absent()
          : Value(discrepanciaTipo),
      montoRecuperableCent: Value(montoRecuperableCent),
      estado: Value(estado),
    );
  }

  factory FacturaTransporteTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FacturaTransporteTableData(
      id: serializer.fromJson<int>(json['id']),
      organizacionId: serializer.fromJson<int>(json['organizacionId']),
      numero: serializer.fromJson<String>(json['numero']),
      transportista: serializer.fromJson<String>(json['transportista']),
      peso: serializer.fromJson<double>(json['peso']),
      ruta: serializer.fromJson<String>(json['ruta']),
      tarifaAplicadaCent: serializer.fromJson<int>(json['tarifaAplicadaCent']),
      tarifaContratadaCent: serializer.fromJson<int>(
        json['tarifaContratadaCent'],
      ),
      discrepanciaTipo: serializer.fromJson<String?>(json['discrepanciaTipo']),
      montoRecuperableCent: serializer.fromJson<int>(
        json['montoRecuperableCent'],
      ),
      estado: serializer.fromJson<String>(json['estado']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'organizacionId': serializer.toJson<int>(organizacionId),
      'numero': serializer.toJson<String>(numero),
      'transportista': serializer.toJson<String>(transportista),
      'peso': serializer.toJson<double>(peso),
      'ruta': serializer.toJson<String>(ruta),
      'tarifaAplicadaCent': serializer.toJson<int>(tarifaAplicadaCent),
      'tarifaContratadaCent': serializer.toJson<int>(tarifaContratadaCent),
      'discrepanciaTipo': serializer.toJson<String?>(discrepanciaTipo),
      'montoRecuperableCent': serializer.toJson<int>(montoRecuperableCent),
      'estado': serializer.toJson<String>(estado),
    };
  }

  FacturaTransporteTableData copyWith({
    int? id,
    int? organizacionId,
    String? numero,
    String? transportista,
    double? peso,
    String? ruta,
    int? tarifaAplicadaCent,
    int? tarifaContratadaCent,
    Value<String?> discrepanciaTipo = const Value.absent(),
    int? montoRecuperableCent,
    String? estado,
  }) => FacturaTransporteTableData(
    id: id ?? this.id,
    organizacionId: organizacionId ?? this.organizacionId,
    numero: numero ?? this.numero,
    transportista: transportista ?? this.transportista,
    peso: peso ?? this.peso,
    ruta: ruta ?? this.ruta,
    tarifaAplicadaCent: tarifaAplicadaCent ?? this.tarifaAplicadaCent,
    tarifaContratadaCent: tarifaContratadaCent ?? this.tarifaContratadaCent,
    discrepanciaTipo: discrepanciaTipo.present
        ? discrepanciaTipo.value
        : this.discrepanciaTipo,
    montoRecuperableCent: montoRecuperableCent ?? this.montoRecuperableCent,
    estado: estado ?? this.estado,
  );
  FacturaTransporteTableData copyWithCompanion(
    FacturaTransporteTableCompanion data,
  ) {
    return FacturaTransporteTableData(
      id: data.id.present ? data.id.value : this.id,
      organizacionId: data.organizacionId.present
          ? data.organizacionId.value
          : this.organizacionId,
      numero: data.numero.present ? data.numero.value : this.numero,
      transportista: data.transportista.present
          ? data.transportista.value
          : this.transportista,
      peso: data.peso.present ? data.peso.value : this.peso,
      ruta: data.ruta.present ? data.ruta.value : this.ruta,
      tarifaAplicadaCent: data.tarifaAplicadaCent.present
          ? data.tarifaAplicadaCent.value
          : this.tarifaAplicadaCent,
      tarifaContratadaCent: data.tarifaContratadaCent.present
          ? data.tarifaContratadaCent.value
          : this.tarifaContratadaCent,
      discrepanciaTipo: data.discrepanciaTipo.present
          ? data.discrepanciaTipo.value
          : this.discrepanciaTipo,
      montoRecuperableCent: data.montoRecuperableCent.present
          ? data.montoRecuperableCent.value
          : this.montoRecuperableCent,
      estado: data.estado.present ? data.estado.value : this.estado,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FacturaTransporteTableData(')
          ..write('id: $id, ')
          ..write('organizacionId: $organizacionId, ')
          ..write('numero: $numero, ')
          ..write('transportista: $transportista, ')
          ..write('peso: $peso, ')
          ..write('ruta: $ruta, ')
          ..write('tarifaAplicadaCent: $tarifaAplicadaCent, ')
          ..write('tarifaContratadaCent: $tarifaContratadaCent, ')
          ..write('discrepanciaTipo: $discrepanciaTipo, ')
          ..write('montoRecuperableCent: $montoRecuperableCent, ')
          ..write('estado: $estado')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    organizacionId,
    numero,
    transportista,
    peso,
    ruta,
    tarifaAplicadaCent,
    tarifaContratadaCent,
    discrepanciaTipo,
    montoRecuperableCent,
    estado,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FacturaTransporteTableData &&
          other.id == this.id &&
          other.organizacionId == this.organizacionId &&
          other.numero == this.numero &&
          other.transportista == this.transportista &&
          other.peso == this.peso &&
          other.ruta == this.ruta &&
          other.tarifaAplicadaCent == this.tarifaAplicadaCent &&
          other.tarifaContratadaCent == this.tarifaContratadaCent &&
          other.discrepanciaTipo == this.discrepanciaTipo &&
          other.montoRecuperableCent == this.montoRecuperableCent &&
          other.estado == this.estado);
}

class FacturaTransporteTableCompanion
    extends UpdateCompanion<FacturaTransporteTableData> {
  final Value<int> id;
  final Value<int> organizacionId;
  final Value<String> numero;
  final Value<String> transportista;
  final Value<double> peso;
  final Value<String> ruta;
  final Value<int> tarifaAplicadaCent;
  final Value<int> tarifaContratadaCent;
  final Value<String?> discrepanciaTipo;
  final Value<int> montoRecuperableCent;
  final Value<String> estado;
  const FacturaTransporteTableCompanion({
    this.id = const Value.absent(),
    this.organizacionId = const Value.absent(),
    this.numero = const Value.absent(),
    this.transportista = const Value.absent(),
    this.peso = const Value.absent(),
    this.ruta = const Value.absent(),
    this.tarifaAplicadaCent = const Value.absent(),
    this.tarifaContratadaCent = const Value.absent(),
    this.discrepanciaTipo = const Value.absent(),
    this.montoRecuperableCent = const Value.absent(),
    this.estado = const Value.absent(),
  });
  FacturaTransporteTableCompanion.insert({
    this.id = const Value.absent(),
    required int organizacionId,
    required String numero,
    required String transportista,
    required double peso,
    required String ruta,
    required int tarifaAplicadaCent,
    required int tarifaContratadaCent,
    this.discrepanciaTipo = const Value.absent(),
    this.montoRecuperableCent = const Value.absent(),
    this.estado = const Value.absent(),
  }) : organizacionId = Value(organizacionId),
       numero = Value(numero),
       transportista = Value(transportista),
       peso = Value(peso),
       ruta = Value(ruta),
       tarifaAplicadaCent = Value(tarifaAplicadaCent),
       tarifaContratadaCent = Value(tarifaContratadaCent);
  static Insertable<FacturaTransporteTableData> custom({
    Expression<int>? id,
    Expression<int>? organizacionId,
    Expression<String>? numero,
    Expression<String>? transportista,
    Expression<double>? peso,
    Expression<String>? ruta,
    Expression<int>? tarifaAplicadaCent,
    Expression<int>? tarifaContratadaCent,
    Expression<String>? discrepanciaTipo,
    Expression<int>? montoRecuperableCent,
    Expression<String>? estado,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (organizacionId != null) 'organizacion_id': organizacionId,
      if (numero != null) 'numero': numero,
      if (transportista != null) 'transportista': transportista,
      if (peso != null) 'peso': peso,
      if (ruta != null) 'ruta': ruta,
      if (tarifaAplicadaCent != null)
        'tarifa_aplicada_cent': tarifaAplicadaCent,
      if (tarifaContratadaCent != null)
        'tarifa_contratada_cent': tarifaContratadaCent,
      if (discrepanciaTipo != null) 'discrepancia_tipo': discrepanciaTipo,
      if (montoRecuperableCent != null)
        'monto_recuperable_cent': montoRecuperableCent,
      if (estado != null) 'estado': estado,
    });
  }

  FacturaTransporteTableCompanion copyWith({
    Value<int>? id,
    Value<int>? organizacionId,
    Value<String>? numero,
    Value<String>? transportista,
    Value<double>? peso,
    Value<String>? ruta,
    Value<int>? tarifaAplicadaCent,
    Value<int>? tarifaContratadaCent,
    Value<String?>? discrepanciaTipo,
    Value<int>? montoRecuperableCent,
    Value<String>? estado,
  }) {
    return FacturaTransporteTableCompanion(
      id: id ?? this.id,
      organizacionId: organizacionId ?? this.organizacionId,
      numero: numero ?? this.numero,
      transportista: transportista ?? this.transportista,
      peso: peso ?? this.peso,
      ruta: ruta ?? this.ruta,
      tarifaAplicadaCent: tarifaAplicadaCent ?? this.tarifaAplicadaCent,
      tarifaContratadaCent: tarifaContratadaCent ?? this.tarifaContratadaCent,
      discrepanciaTipo: discrepanciaTipo ?? this.discrepanciaTipo,
      montoRecuperableCent: montoRecuperableCent ?? this.montoRecuperableCent,
      estado: estado ?? this.estado,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (organizacionId.present) {
      map['organizacion_id'] = Variable<int>(organizacionId.value);
    }
    if (numero.present) {
      map['numero'] = Variable<String>(numero.value);
    }
    if (transportista.present) {
      map['transportista'] = Variable<String>(transportista.value);
    }
    if (peso.present) {
      map['peso'] = Variable<double>(peso.value);
    }
    if (ruta.present) {
      map['ruta'] = Variable<String>(ruta.value);
    }
    if (tarifaAplicadaCent.present) {
      map['tarifa_aplicada_cent'] = Variable<int>(tarifaAplicadaCent.value);
    }
    if (tarifaContratadaCent.present) {
      map['tarifa_contratada_cent'] = Variable<int>(tarifaContratadaCent.value);
    }
    if (discrepanciaTipo.present) {
      map['discrepancia_tipo'] = Variable<String>(discrepanciaTipo.value);
    }
    if (montoRecuperableCent.present) {
      map['monto_recuperable_cent'] = Variable<int>(montoRecuperableCent.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FacturaTransporteTableCompanion(')
          ..write('id: $id, ')
          ..write('organizacionId: $organizacionId, ')
          ..write('numero: $numero, ')
          ..write('transportista: $transportista, ')
          ..write('peso: $peso, ')
          ..write('ruta: $ruta, ')
          ..write('tarifaAplicadaCent: $tarifaAplicadaCent, ')
          ..write('tarifaContratadaCent: $tarifaContratadaCent, ')
          ..write('discrepanciaTipo: $discrepanciaTipo, ')
          ..write('montoRecuperableCent: $montoRecuperableCent, ')
          ..write('estado: $estado')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $OrganizacionTableTable organizacionTable =
      $OrganizacionTableTable(this);
  late final $PeriodoTableTable periodoTable = $PeriodoTableTable(this);
  late final $IndicadorTableTable indicadorTable = $IndicadorTableTable(this);
  late final $MedicionTableTable medicionTable = $MedicionTableTable(this);
  late final $ReglaPatronTableTable reglaPatronTable = $ReglaPatronTableTable(
    this,
  );
  late final $EvaluacionTableTable evaluacionTable = $EvaluacionTableTable(
    this,
  );
  late final $MemoriaEvaluacionTableTable memoriaEvaluacionTable =
      $MemoriaEvaluacionTableTable(this);
  late final $AccionCatalogoTableTable accionCatalogoTable =
      $AccionCatalogoTableTable(this);
  late final $ReglaAccionTableTable reglaAccionTable = $ReglaAccionTableTable(
    this,
  );
  late final $AccionTomadaTableTable accionTomadaTable =
      $AccionTomadaTableTable(this);
  late final $VerificacionAccionTableTable verificacionAccionTable =
      $VerificacionAccionTableTable(this);
  late final $PresupuestoTableTable presupuestoTable = $PresupuestoTableTable(
    this,
  );
  late final $EscenarioSinteticoTableTable escenarioSinteticoTable =
      $EscenarioSinteticoTableTable(this);
  late final $DiagnosticoOrganizacionalTableTable
  diagnosticoOrganizacionalTable = $DiagnosticoOrganizacionalTableTable(this);
  late final $FacturaTransporteTableTable facturaTransporteTable =
      $FacturaTransporteTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    organizacionTable,
    periodoTable,
    indicadorTable,
    medicionTable,
    reglaPatronTable,
    evaluacionTable,
    memoriaEvaluacionTable,
    accionCatalogoTable,
    reglaAccionTable,
    accionTomadaTable,
    verificacionAccionTable,
    presupuestoTable,
    escenarioSinteticoTable,
    diagnosticoOrganizacionalTable,
    facturaTransporteTable,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'organizacion',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('periodo', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'organizacion',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('indicador', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'indicador',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('medicion', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'periodo',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('medicion', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'indicador',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('regla_patron', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'indicador',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('evaluacion', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'periodo',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('evaluacion', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'evaluacion',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('memoria_evaluacion', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'accion_catalogo',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('regla_accion', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'evaluacion',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('accion_tomada', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'accion_tomada',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('verificacion_accion', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'periodo',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('verificacion_accion', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'organizacion',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('presupuesto', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'periodo',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('presupuesto', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'indicador',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('escenario_sintetico', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'organizacion',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('diagnostico_organizacional', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'organizacion',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('factura_transporte', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$OrganizacionTableTableCreateCompanionBuilder =
    OrganizacionTableCompanion Function({
      Value<int> id,
      required String nombre,
      Value<String> moneda,
      required String tipoEmpresa,
      Value<String?> notas,
    });
typedef $$OrganizacionTableTableUpdateCompanionBuilder =
    OrganizacionTableCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<String> moneda,
      Value<String> tipoEmpresa,
      Value<String?> notas,
    });

final class $$OrganizacionTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $OrganizacionTableTable,
          OrganizacionTableData
        > {
  $$OrganizacionTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$PeriodoTableTable, List<PeriodoTableData>>
  _periodoTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.periodoTable,
    aliasName: 'organizacion__id__periodo__organizacion_id',
  );

  $$PeriodoTableTableProcessedTableManager get periodoTableRefs {
    final manager = $$PeriodoTableTableTableManager(
      $_db,
      $_db.periodoTable,
    ).filter((f) => f.organizacionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_periodoTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$IndicadorTableTable, List<IndicadorTableData>>
  _indicadorTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.indicadorTable,
    aliasName: 'organizacion__id__indicador__organizacion_id',
  );

  $$IndicadorTableTableProcessedTableManager get indicadorTableRefs {
    final manager = $$IndicadorTableTableTableManager(
      $_db,
      $_db.indicadorTable,
    ).filter((f) => f.organizacionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_indicadorTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PresupuestoTableTable, List<PresupuestoTableData>>
  _presupuestoTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.presupuestoTable,
    aliasName: 'organizacion__id__presupuesto__organizacion_id',
  );

  $$PresupuestoTableTableProcessedTableManager get presupuestoTableRefs {
    final manager = $$PresupuestoTableTableTableManager(
      $_db,
      $_db.presupuestoTable,
    ).filter((f) => f.organizacionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _presupuestoTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $DiagnosticoOrganizacionalTableTable,
    List<DiagnosticoOrganizacionalTableData>
  >
  _diagnosticoOrganizacionalTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.diagnosticoOrganizacionalTable,
        aliasName:
            'organizacion__id__diagnostico_organizacional__organizacion_id',
      );

  $$DiagnosticoOrganizacionalTableTableProcessedTableManager
  get diagnosticoOrganizacionalTableRefs {
    final manager = $$DiagnosticoOrganizacionalTableTableTableManager(
      $_db,
      $_db.diagnosticoOrganizacionalTable,
    ).filter((f) => f.organizacionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _diagnosticoOrganizacionalTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $FacturaTransporteTableTable,
    List<FacturaTransporteTableData>
  >
  _facturaTransporteTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.facturaTransporteTable,
        aliasName: 'organizacion__id__factura_transporte__organizacion_id',
      );

  $$FacturaTransporteTableTableProcessedTableManager
  get facturaTransporteTableRefs {
    final manager = $$FacturaTransporteTableTableTableManager(
      $_db,
      $_db.facturaTransporteTable,
    ).filter((f) => f.organizacionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _facturaTransporteTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OrganizacionTableTableFilterComposer
    extends Composer<_$AppDatabase, $OrganizacionTableTable> {
  $$OrganizacionTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moneda => $composableBuilder(
    column: $table.moneda,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipoEmpresa => $composableBuilder(
    column: $table.tipoEmpresa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notas => $composableBuilder(
    column: $table.notas,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> periodoTableRefs(
    Expression<bool> Function($$PeriodoTableTableFilterComposer f) f,
  ) {
    final $$PeriodoTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.periodoTable,
      getReferencedColumn: (t) => t.organizacionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeriodoTableTableFilterComposer(
            $db: $db,
            $table: $db.periodoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> indicadorTableRefs(
    Expression<bool> Function($$IndicadorTableTableFilterComposer f) f,
  ) {
    final $$IndicadorTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.indicadorTable,
      getReferencedColumn: (t) => t.organizacionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IndicadorTableTableFilterComposer(
            $db: $db,
            $table: $db.indicadorTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> presupuestoTableRefs(
    Expression<bool> Function($$PresupuestoTableTableFilterComposer f) f,
  ) {
    final $$PresupuestoTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.presupuestoTable,
      getReferencedColumn: (t) => t.organizacionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PresupuestoTableTableFilterComposer(
            $db: $db,
            $table: $db.presupuestoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> diagnosticoOrganizacionalTableRefs(
    Expression<bool> Function(
      $$DiagnosticoOrganizacionalTableTableFilterComposer f,
    )
    f,
  ) {
    final $$DiagnosticoOrganizacionalTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.diagnosticoOrganizacionalTable,
          getReferencedColumn: (t) => t.organizacionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DiagnosticoOrganizacionalTableTableFilterComposer(
                $db: $db,
                $table: $db.diagnosticoOrganizacionalTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> facturaTransporteTableRefs(
    Expression<bool> Function($$FacturaTransporteTableTableFilterComposer f) f,
  ) {
    final $$FacturaTransporteTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.facturaTransporteTable,
          getReferencedColumn: (t) => t.organizacionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FacturaTransporteTableTableFilterComposer(
                $db: $db,
                $table: $db.facturaTransporteTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$OrganizacionTableTableOrderingComposer
    extends Composer<_$AppDatabase, $OrganizacionTableTable> {
  $$OrganizacionTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moneda => $composableBuilder(
    column: $table.moneda,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipoEmpresa => $composableBuilder(
    column: $table.tipoEmpresa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notas => $composableBuilder(
    column: $table.notas,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OrganizacionTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrganizacionTableTable> {
  $$OrganizacionTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get moneda =>
      $composableBuilder(column: $table.moneda, builder: (column) => column);

  GeneratedColumn<String> get tipoEmpresa => $composableBuilder(
    column: $table.tipoEmpresa,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notas =>
      $composableBuilder(column: $table.notas, builder: (column) => column);

  Expression<T> periodoTableRefs<T extends Object>(
    Expression<T> Function($$PeriodoTableTableAnnotationComposer a) f,
  ) {
    final $$PeriodoTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.periodoTable,
      getReferencedColumn: (t) => t.organizacionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeriodoTableTableAnnotationComposer(
            $db: $db,
            $table: $db.periodoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> indicadorTableRefs<T extends Object>(
    Expression<T> Function($$IndicadorTableTableAnnotationComposer a) f,
  ) {
    final $$IndicadorTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.indicadorTable,
      getReferencedColumn: (t) => t.organizacionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IndicadorTableTableAnnotationComposer(
            $db: $db,
            $table: $db.indicadorTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> presupuestoTableRefs<T extends Object>(
    Expression<T> Function($$PresupuestoTableTableAnnotationComposer a) f,
  ) {
    final $$PresupuestoTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.presupuestoTable,
      getReferencedColumn: (t) => t.organizacionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PresupuestoTableTableAnnotationComposer(
            $db: $db,
            $table: $db.presupuestoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> diagnosticoOrganizacionalTableRefs<T extends Object>(
    Expression<T> Function(
      $$DiagnosticoOrganizacionalTableTableAnnotationComposer a,
    )
    f,
  ) {
    final $$DiagnosticoOrganizacionalTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.diagnosticoOrganizacionalTable,
          getReferencedColumn: (t) => t.organizacionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DiagnosticoOrganizacionalTableTableAnnotationComposer(
                $db: $db,
                $table: $db.diagnosticoOrganizacionalTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> facturaTransporteTableRefs<T extends Object>(
    Expression<T> Function($$FacturaTransporteTableTableAnnotationComposer a) f,
  ) {
    final $$FacturaTransporteTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.facturaTransporteTable,
          getReferencedColumn: (t) => t.organizacionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FacturaTransporteTableTableAnnotationComposer(
                $db: $db,
                $table: $db.facturaTransporteTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$OrganizacionTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrganizacionTableTable,
          OrganizacionTableData,
          $$OrganizacionTableTableFilterComposer,
          $$OrganizacionTableTableOrderingComposer,
          $$OrganizacionTableTableAnnotationComposer,
          $$OrganizacionTableTableCreateCompanionBuilder,
          $$OrganizacionTableTableUpdateCompanionBuilder,
          (OrganizacionTableData, $$OrganizacionTableTableReferences),
          OrganizacionTableData,
          PrefetchHooks Function({
            bool periodoTableRefs,
            bool indicadorTableRefs,
            bool presupuestoTableRefs,
            bool diagnosticoOrganizacionalTableRefs,
            bool facturaTransporteTableRefs,
          })
        > {
  $$OrganizacionTableTableTableManager(
    _$AppDatabase db,
    $OrganizacionTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrganizacionTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrganizacionTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrganizacionTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> moneda = const Value.absent(),
                Value<String> tipoEmpresa = const Value.absent(),
                Value<String?> notas = const Value.absent(),
              }) => OrganizacionTableCompanion(
                id: id,
                nombre: nombre,
                moneda: moneda,
                tipoEmpresa: tipoEmpresa,
                notas: notas,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                Value<String> moneda = const Value.absent(),
                required String tipoEmpresa,
                Value<String?> notas = const Value.absent(),
              }) => OrganizacionTableCompanion.insert(
                id: id,
                nombre: nombre,
                moneda: moneda,
                tipoEmpresa: tipoEmpresa,
                notas: notas,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OrganizacionTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                periodoTableRefs = false,
                indicadorTableRefs = false,
                presupuestoTableRefs = false,
                diagnosticoOrganizacionalTableRefs = false,
                facturaTransporteTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (periodoTableRefs) db.periodoTable,
                    if (indicadorTableRefs) db.indicadorTable,
                    if (presupuestoTableRefs) db.presupuestoTable,
                    if (diagnosticoOrganizacionalTableRefs)
                      db.diagnosticoOrganizacionalTable,
                    if (facturaTransporteTableRefs) db.facturaTransporteTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (periodoTableRefs)
                        await $_getPrefetchedData<
                          OrganizacionTableData,
                          $OrganizacionTableTable,
                          PeriodoTableData
                        >(
                          currentTable: table,
                          referencedTable: $$OrganizacionTableTableReferences
                              ._periodoTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrganizacionTableTableReferences(
                                db,
                                table,
                                p0,
                              ).periodoTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.organizacionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (indicadorTableRefs)
                        await $_getPrefetchedData<
                          OrganizacionTableData,
                          $OrganizacionTableTable,
                          IndicadorTableData
                        >(
                          currentTable: table,
                          referencedTable: $$OrganizacionTableTableReferences
                              ._indicadorTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrganizacionTableTableReferences(
                                db,
                                table,
                                p0,
                              ).indicadorTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.organizacionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (presupuestoTableRefs)
                        await $_getPrefetchedData<
                          OrganizacionTableData,
                          $OrganizacionTableTable,
                          PresupuestoTableData
                        >(
                          currentTable: table,
                          referencedTable: $$OrganizacionTableTableReferences
                              ._presupuestoTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrganizacionTableTableReferences(
                                db,
                                table,
                                p0,
                              ).presupuestoTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.organizacionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (diagnosticoOrganizacionalTableRefs)
                        await $_getPrefetchedData<
                          OrganizacionTableData,
                          $OrganizacionTableTable,
                          DiagnosticoOrganizacionalTableData
                        >(
                          currentTable: table,
                          referencedTable: $$OrganizacionTableTableReferences
                              ._diagnosticoOrganizacionalTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrganizacionTableTableReferences(
                                db,
                                table,
                                p0,
                              ).diagnosticoOrganizacionalTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.organizacionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (facturaTransporteTableRefs)
                        await $_getPrefetchedData<
                          OrganizacionTableData,
                          $OrganizacionTableTable,
                          FacturaTransporteTableData
                        >(
                          currentTable: table,
                          referencedTable: $$OrganizacionTableTableReferences
                              ._facturaTransporteTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrganizacionTableTableReferences(
                                db,
                                table,
                                p0,
                              ).facturaTransporteTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.organizacionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$OrganizacionTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrganizacionTableTable,
      OrganizacionTableData,
      $$OrganizacionTableTableFilterComposer,
      $$OrganizacionTableTableOrderingComposer,
      $$OrganizacionTableTableAnnotationComposer,
      $$OrganizacionTableTableCreateCompanionBuilder,
      $$OrganizacionTableTableUpdateCompanionBuilder,
      (OrganizacionTableData, $$OrganizacionTableTableReferences),
      OrganizacionTableData,
      PrefetchHooks Function({
        bool periodoTableRefs,
        bool indicadorTableRefs,
        bool presupuestoTableRefs,
        bool diagnosticoOrganizacionalTableRefs,
        bool facturaTransporteTableRefs,
      })
    >;
typedef $$PeriodoTableTableCreateCompanionBuilder =
    PeriodoTableCompanion Function({
      Value<int> id,
      required int organizacionId,
      required int orden,
      required String etiqueta,
      required String fechaInicio,
      required String fechaFin,
      required String granularidad,
      Value<bool> esSimulado,
    });
typedef $$PeriodoTableTableUpdateCompanionBuilder =
    PeriodoTableCompanion Function({
      Value<int> id,
      Value<int> organizacionId,
      Value<int> orden,
      Value<String> etiqueta,
      Value<String> fechaInicio,
      Value<String> fechaFin,
      Value<String> granularidad,
      Value<bool> esSimulado,
    });

final class $$PeriodoTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $PeriodoTableTable, PeriodoTableData> {
  $$PeriodoTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrganizacionTableTable _organizacionIdTable(_$AppDatabase db) => db
      .organizacionTable
      .createAlias('periodo__organizacion_id__organizacion__id');

  $$OrganizacionTableTableProcessedTableManager get organizacionId {
    final $_column = $_itemColumn<int>('organizacion_id')!;

    final manager = $$OrganizacionTableTableTableManager(
      $_db,
      $_db.organizacionTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_organizacionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MedicionTableTable, List<MedicionTableData>>
  _medicionTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.medicionTable,
    aliasName: 'periodo__id__medicion__periodo_id',
  );

  $$MedicionTableTableProcessedTableManager get medicionTableRefs {
    final manager = $$MedicionTableTableTableManager(
      $_db,
      $_db.medicionTable,
    ).filter((f) => f.periodoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_medicionTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$EvaluacionTableTable, List<EvaluacionTableData>>
  _evaluacionTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.evaluacionTable,
    aliasName: 'periodo__id__evaluacion__periodo_id',
  );

  $$EvaluacionTableTableProcessedTableManager get evaluacionTableRefs {
    final manager = $$EvaluacionTableTableTableManager(
      $_db,
      $_db.evaluacionTable,
    ).filter((f) => f.periodoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _evaluacionTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $VerificacionAccionTableTable,
    List<VerificacionAccionTableData>
  >
  _verificacionAccionTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.verificacionAccionTable,
        aliasName: 'periodo__id__verificacion_accion__periodo_verificacion_id',
      );

  $$VerificacionAccionTableTableProcessedTableManager
  get verificacionAccionTableRefs {
    final manager =
        $$VerificacionAccionTableTableTableManager(
          $_db,
          $_db.verificacionAccionTable,
        ).filter(
          (f) => f.periodoVerificacionId.id.sqlEquals($_itemColumn<int>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _verificacionAccionTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PresupuestoTableTable, List<PresupuestoTableData>>
  _presupuestoTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.presupuestoTable,
    aliasName: 'periodo__id__presupuesto__periodo_id',
  );

  $$PresupuestoTableTableProcessedTableManager get presupuestoTableRefs {
    final manager = $$PresupuestoTableTableTableManager(
      $_db,
      $_db.presupuestoTable,
    ).filter((f) => f.periodoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _presupuestoTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PeriodoTableTableFilterComposer
    extends Composer<_$AppDatabase, $PeriodoTableTable> {
  $$PeriodoTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orden => $composableBuilder(
    column: $table.orden,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get etiqueta => $composableBuilder(
    column: $table.etiqueta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fechaInicio => $composableBuilder(
    column: $table.fechaInicio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fechaFin => $composableBuilder(
    column: $table.fechaFin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get granularidad => $composableBuilder(
    column: $table.granularidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get esSimulado => $composableBuilder(
    column: $table.esSimulado,
    builder: (column) => ColumnFilters(column),
  );

  $$OrganizacionTableTableFilterComposer get organizacionId {
    final $$OrganizacionTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organizacionId,
      referencedTable: $db.organizacionTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizacionTableTableFilterComposer(
            $db: $db,
            $table: $db.organizacionTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> medicionTableRefs(
    Expression<bool> Function($$MedicionTableTableFilterComposer f) f,
  ) {
    final $$MedicionTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medicionTable,
      getReferencedColumn: (t) => t.periodoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicionTableTableFilterComposer(
            $db: $db,
            $table: $db.medicionTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> evaluacionTableRefs(
    Expression<bool> Function($$EvaluacionTableTableFilterComposer f) f,
  ) {
    final $$EvaluacionTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.evaluacionTable,
      getReferencedColumn: (t) => t.periodoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EvaluacionTableTableFilterComposer(
            $db: $db,
            $table: $db.evaluacionTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> verificacionAccionTableRefs(
    Expression<bool> Function($$VerificacionAccionTableTableFilterComposer f) f,
  ) {
    final $$VerificacionAccionTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.verificacionAccionTable,
          getReferencedColumn: (t) => t.periodoVerificacionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$VerificacionAccionTableTableFilterComposer(
                $db: $db,
                $table: $db.verificacionAccionTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> presupuestoTableRefs(
    Expression<bool> Function($$PresupuestoTableTableFilterComposer f) f,
  ) {
    final $$PresupuestoTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.presupuestoTable,
      getReferencedColumn: (t) => t.periodoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PresupuestoTableTableFilterComposer(
            $db: $db,
            $table: $db.presupuestoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PeriodoTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PeriodoTableTable> {
  $$PeriodoTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orden => $composableBuilder(
    column: $table.orden,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get etiqueta => $composableBuilder(
    column: $table.etiqueta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fechaInicio => $composableBuilder(
    column: $table.fechaInicio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fechaFin => $composableBuilder(
    column: $table.fechaFin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get granularidad => $composableBuilder(
    column: $table.granularidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get esSimulado => $composableBuilder(
    column: $table.esSimulado,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrganizacionTableTableOrderingComposer get organizacionId {
    final $$OrganizacionTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organizacionId,
      referencedTable: $db.organizacionTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizacionTableTableOrderingComposer(
            $db: $db,
            $table: $db.organizacionTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PeriodoTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PeriodoTableTable> {
  $$PeriodoTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get orden =>
      $composableBuilder(column: $table.orden, builder: (column) => column);

  GeneratedColumn<String> get etiqueta =>
      $composableBuilder(column: $table.etiqueta, builder: (column) => column);

  GeneratedColumn<String> get fechaInicio => $composableBuilder(
    column: $table.fechaInicio,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fechaFin =>
      $composableBuilder(column: $table.fechaFin, builder: (column) => column);

  GeneratedColumn<String> get granularidad => $composableBuilder(
    column: $table.granularidad,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get esSimulado => $composableBuilder(
    column: $table.esSimulado,
    builder: (column) => column,
  );

  $$OrganizacionTableTableAnnotationComposer get organizacionId {
    final $$OrganizacionTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.organizacionId,
          referencedTable: $db.organizacionTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$OrganizacionTableTableAnnotationComposer(
                $db: $db,
                $table: $db.organizacionTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> medicionTableRefs<T extends Object>(
    Expression<T> Function($$MedicionTableTableAnnotationComposer a) f,
  ) {
    final $$MedicionTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medicionTable,
      getReferencedColumn: (t) => t.periodoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicionTableTableAnnotationComposer(
            $db: $db,
            $table: $db.medicionTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> evaluacionTableRefs<T extends Object>(
    Expression<T> Function($$EvaluacionTableTableAnnotationComposer a) f,
  ) {
    final $$EvaluacionTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.evaluacionTable,
      getReferencedColumn: (t) => t.periodoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EvaluacionTableTableAnnotationComposer(
            $db: $db,
            $table: $db.evaluacionTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> verificacionAccionTableRefs<T extends Object>(
    Expression<T> Function($$VerificacionAccionTableTableAnnotationComposer a)
    f,
  ) {
    final $$VerificacionAccionTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.verificacionAccionTable,
          getReferencedColumn: (t) => t.periodoVerificacionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$VerificacionAccionTableTableAnnotationComposer(
                $db: $db,
                $table: $db.verificacionAccionTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> presupuestoTableRefs<T extends Object>(
    Expression<T> Function($$PresupuestoTableTableAnnotationComposer a) f,
  ) {
    final $$PresupuestoTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.presupuestoTable,
      getReferencedColumn: (t) => t.periodoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PresupuestoTableTableAnnotationComposer(
            $db: $db,
            $table: $db.presupuestoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PeriodoTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PeriodoTableTable,
          PeriodoTableData,
          $$PeriodoTableTableFilterComposer,
          $$PeriodoTableTableOrderingComposer,
          $$PeriodoTableTableAnnotationComposer,
          $$PeriodoTableTableCreateCompanionBuilder,
          $$PeriodoTableTableUpdateCompanionBuilder,
          (PeriodoTableData, $$PeriodoTableTableReferences),
          PeriodoTableData,
          PrefetchHooks Function({
            bool organizacionId,
            bool medicionTableRefs,
            bool evaluacionTableRefs,
            bool verificacionAccionTableRefs,
            bool presupuestoTableRefs,
          })
        > {
  $$PeriodoTableTableTableManager(_$AppDatabase db, $PeriodoTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PeriodoTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PeriodoTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PeriodoTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> organizacionId = const Value.absent(),
                Value<int> orden = const Value.absent(),
                Value<String> etiqueta = const Value.absent(),
                Value<String> fechaInicio = const Value.absent(),
                Value<String> fechaFin = const Value.absent(),
                Value<String> granularidad = const Value.absent(),
                Value<bool> esSimulado = const Value.absent(),
              }) => PeriodoTableCompanion(
                id: id,
                organizacionId: organizacionId,
                orden: orden,
                etiqueta: etiqueta,
                fechaInicio: fechaInicio,
                fechaFin: fechaFin,
                granularidad: granularidad,
                esSimulado: esSimulado,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int organizacionId,
                required int orden,
                required String etiqueta,
                required String fechaInicio,
                required String fechaFin,
                required String granularidad,
                Value<bool> esSimulado = const Value.absent(),
              }) => PeriodoTableCompanion.insert(
                id: id,
                organizacionId: organizacionId,
                orden: orden,
                etiqueta: etiqueta,
                fechaInicio: fechaInicio,
                fechaFin: fechaFin,
                granularidad: granularidad,
                esSimulado: esSimulado,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PeriodoTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                organizacionId = false,
                medicionTableRefs = false,
                evaluacionTableRefs = false,
                verificacionAccionTableRefs = false,
                presupuestoTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (medicionTableRefs) db.medicionTable,
                    if (evaluacionTableRefs) db.evaluacionTable,
                    if (verificacionAccionTableRefs) db.verificacionAccionTable,
                    if (presupuestoTableRefs) db.presupuestoTable,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (organizacionId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.organizacionId,
                            referencedTable: $$PeriodoTableTableReferences
                                ._organizacionIdTable(db),
                            referencedColumn: $$PeriodoTableTableReferences
                                ._organizacionIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (medicionTableRefs)
                        await $_getPrefetchedData<
                          PeriodoTableData,
                          $PeriodoTableTable,
                          MedicionTableData
                        >(
                          currentTable: table,
                          referencedTable: $$PeriodoTableTableReferences
                              ._medicionTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PeriodoTableTableReferences(
                                db,
                                table,
                                p0,
                              ).medicionTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.periodoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (evaluacionTableRefs)
                        await $_getPrefetchedData<
                          PeriodoTableData,
                          $PeriodoTableTable,
                          EvaluacionTableData
                        >(
                          currentTable: table,
                          referencedTable: $$PeriodoTableTableReferences
                              ._evaluacionTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PeriodoTableTableReferences(
                                db,
                                table,
                                p0,
                              ).evaluacionTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.periodoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (verificacionAccionTableRefs)
                        await $_getPrefetchedData<
                          PeriodoTableData,
                          $PeriodoTableTable,
                          VerificacionAccionTableData
                        >(
                          currentTable: table,
                          referencedTable: $$PeriodoTableTableReferences
                              ._verificacionAccionTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PeriodoTableTableReferences(
                                db,
                                table,
                                p0,
                              ).verificacionAccionTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.periodoVerificacionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (presupuestoTableRefs)
                        await $_getPrefetchedData<
                          PeriodoTableData,
                          $PeriodoTableTable,
                          PresupuestoTableData
                        >(
                          currentTable: table,
                          referencedTable: $$PeriodoTableTableReferences
                              ._presupuestoTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PeriodoTableTableReferences(
                                db,
                                table,
                                p0,
                              ).presupuestoTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.periodoId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PeriodoTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PeriodoTableTable,
      PeriodoTableData,
      $$PeriodoTableTableFilterComposer,
      $$PeriodoTableTableOrderingComposer,
      $$PeriodoTableTableAnnotationComposer,
      $$PeriodoTableTableCreateCompanionBuilder,
      $$PeriodoTableTableUpdateCompanionBuilder,
      (PeriodoTableData, $$PeriodoTableTableReferences),
      PeriodoTableData,
      PrefetchHooks Function({
        bool organizacionId,
        bool medicionTableRefs,
        bool evaluacionTableRefs,
        bool verificacionAccionTableRefs,
        bool presupuestoTableRefs,
      })
    >;
typedef $$IndicadorTableTableCreateCompanionBuilder =
    IndicadorTableCompanion Function({
      Value<int> id,
      required int organizacionId,
      required String codigo,
      required String nombre,
      required String categoria,
      required String unidad,
      Value<int> decimales,
      required String sentido,
      required double meta,
      required double bandaInferior,
      required double bandaSuperior,
      required String granularidad,
      required String proceso,
      Value<bool> activo,
    });
typedef $$IndicadorTableTableUpdateCompanionBuilder =
    IndicadorTableCompanion Function({
      Value<int> id,
      Value<int> organizacionId,
      Value<String> codigo,
      Value<String> nombre,
      Value<String> categoria,
      Value<String> unidad,
      Value<int> decimales,
      Value<String> sentido,
      Value<double> meta,
      Value<double> bandaInferior,
      Value<double> bandaSuperior,
      Value<String> granularidad,
      Value<String> proceso,
      Value<bool> activo,
    });

final class $$IndicadorTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $IndicadorTableTable,
          IndicadorTableData
        > {
  $$IndicadorTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $OrganizacionTableTable _organizacionIdTable(_$AppDatabase db) => db
      .organizacionTable
      .createAlias('indicador__organizacion_id__organizacion__id');

  $$OrganizacionTableTableProcessedTableManager get organizacionId {
    final $_column = $_itemColumn<int>('organizacion_id')!;

    final manager = $$OrganizacionTableTableTableManager(
      $_db,
      $_db.organizacionTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_organizacionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MedicionTableTable, List<MedicionTableData>>
  _medicionTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.medicionTable,
    aliasName: 'indicador__id__medicion__indicador_id',
  );

  $$MedicionTableTableProcessedTableManager get medicionTableRefs {
    final manager = $$MedicionTableTableTableManager(
      $_db,
      $_db.medicionTable,
    ).filter((f) => f.indicadorId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_medicionTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReglaPatronTableTable, List<ReglaPatronTableData>>
  _reglaPatronTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reglaPatronTable,
    aliasName: 'indicador__id__regla_patron__indicador_id',
  );

  $$ReglaPatronTableTableProcessedTableManager get reglaPatronTableRefs {
    final manager = $$ReglaPatronTableTableTableManager(
      $_db,
      $_db.reglaPatronTable,
    ).filter((f) => f.indicadorId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _reglaPatronTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$EvaluacionTableTable, List<EvaluacionTableData>>
  _evaluacionTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.evaluacionTable,
    aliasName: 'indicador__id__evaluacion__indicador_id',
  );

  $$EvaluacionTableTableProcessedTableManager get evaluacionTableRefs {
    final manager = $$EvaluacionTableTableTableManager(
      $_db,
      $_db.evaluacionTable,
    ).filter((f) => f.indicadorId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _evaluacionTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $EscenarioSinteticoTableTable,
    List<EscenarioSinteticoTableData>
  >
  _escenarioSinteticoTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.escenarioSinteticoTable,
        aliasName: 'indicador__id__escenario_sintetico__indicador_base_id',
      );

  $$EscenarioSinteticoTableTableProcessedTableManager
  get escenarioSinteticoTableRefs {
    final manager = $$EscenarioSinteticoTableTableTableManager(
      $_db,
      $_db.escenarioSinteticoTable,
    ).filter((f) => f.indicadorBaseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _escenarioSinteticoTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$IndicadorTableTableFilterComposer
    extends Composer<_$AppDatabase, $IndicadorTableTable> {
  $$IndicadorTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unidad => $composableBuilder(
    column: $table.unidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get decimales => $composableBuilder(
    column: $table.decimales,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sentido => $composableBuilder(
    column: $table.sentido,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get meta => $composableBuilder(
    column: $table.meta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bandaInferior => $composableBuilder(
    column: $table.bandaInferior,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bandaSuperior => $composableBuilder(
    column: $table.bandaSuperior,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get granularidad => $composableBuilder(
    column: $table.granularidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get proceso => $composableBuilder(
    column: $table.proceso,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  $$OrganizacionTableTableFilterComposer get organizacionId {
    final $$OrganizacionTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organizacionId,
      referencedTable: $db.organizacionTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizacionTableTableFilterComposer(
            $db: $db,
            $table: $db.organizacionTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> medicionTableRefs(
    Expression<bool> Function($$MedicionTableTableFilterComposer f) f,
  ) {
    final $$MedicionTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medicionTable,
      getReferencedColumn: (t) => t.indicadorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicionTableTableFilterComposer(
            $db: $db,
            $table: $db.medicionTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> reglaPatronTableRefs(
    Expression<bool> Function($$ReglaPatronTableTableFilterComposer f) f,
  ) {
    final $$ReglaPatronTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reglaPatronTable,
      getReferencedColumn: (t) => t.indicadorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReglaPatronTableTableFilterComposer(
            $db: $db,
            $table: $db.reglaPatronTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> evaluacionTableRefs(
    Expression<bool> Function($$EvaluacionTableTableFilterComposer f) f,
  ) {
    final $$EvaluacionTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.evaluacionTable,
      getReferencedColumn: (t) => t.indicadorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EvaluacionTableTableFilterComposer(
            $db: $db,
            $table: $db.evaluacionTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> escenarioSinteticoTableRefs(
    Expression<bool> Function($$EscenarioSinteticoTableTableFilterComposer f) f,
  ) {
    final $$EscenarioSinteticoTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.escenarioSinteticoTable,
          getReferencedColumn: (t) => t.indicadorBaseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EscenarioSinteticoTableTableFilterComposer(
                $db: $db,
                $table: $db.escenarioSinteticoTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$IndicadorTableTableOrderingComposer
    extends Composer<_$AppDatabase, $IndicadorTableTable> {
  $$IndicadorTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unidad => $composableBuilder(
    column: $table.unidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get decimales => $composableBuilder(
    column: $table.decimales,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sentido => $composableBuilder(
    column: $table.sentido,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get meta => $composableBuilder(
    column: $table.meta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bandaInferior => $composableBuilder(
    column: $table.bandaInferior,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bandaSuperior => $composableBuilder(
    column: $table.bandaSuperior,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get granularidad => $composableBuilder(
    column: $table.granularidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get proceso => $composableBuilder(
    column: $table.proceso,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrganizacionTableTableOrderingComposer get organizacionId {
    final $$OrganizacionTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organizacionId,
      referencedTable: $db.organizacionTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizacionTableTableOrderingComposer(
            $db: $db,
            $table: $db.organizacionTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IndicadorTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $IndicadorTableTable> {
  $$IndicadorTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get categoria =>
      $composableBuilder(column: $table.categoria, builder: (column) => column);

  GeneratedColumn<String> get unidad =>
      $composableBuilder(column: $table.unidad, builder: (column) => column);

  GeneratedColumn<int> get decimales =>
      $composableBuilder(column: $table.decimales, builder: (column) => column);

  GeneratedColumn<String> get sentido =>
      $composableBuilder(column: $table.sentido, builder: (column) => column);

  GeneratedColumn<double> get meta =>
      $composableBuilder(column: $table.meta, builder: (column) => column);

  GeneratedColumn<double> get bandaInferior => $composableBuilder(
    column: $table.bandaInferior,
    builder: (column) => column,
  );

  GeneratedColumn<double> get bandaSuperior => $composableBuilder(
    column: $table.bandaSuperior,
    builder: (column) => column,
  );

  GeneratedColumn<String> get granularidad => $composableBuilder(
    column: $table.granularidad,
    builder: (column) => column,
  );

  GeneratedColumn<String> get proceso =>
      $composableBuilder(column: $table.proceso, builder: (column) => column);

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  $$OrganizacionTableTableAnnotationComposer get organizacionId {
    final $$OrganizacionTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.organizacionId,
          referencedTable: $db.organizacionTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$OrganizacionTableTableAnnotationComposer(
                $db: $db,
                $table: $db.organizacionTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> medicionTableRefs<T extends Object>(
    Expression<T> Function($$MedicionTableTableAnnotationComposer a) f,
  ) {
    final $$MedicionTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medicionTable,
      getReferencedColumn: (t) => t.indicadorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicionTableTableAnnotationComposer(
            $db: $db,
            $table: $db.medicionTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> reglaPatronTableRefs<T extends Object>(
    Expression<T> Function($$ReglaPatronTableTableAnnotationComposer a) f,
  ) {
    final $$ReglaPatronTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reglaPatronTable,
      getReferencedColumn: (t) => t.indicadorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReglaPatronTableTableAnnotationComposer(
            $db: $db,
            $table: $db.reglaPatronTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> evaluacionTableRefs<T extends Object>(
    Expression<T> Function($$EvaluacionTableTableAnnotationComposer a) f,
  ) {
    final $$EvaluacionTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.evaluacionTable,
      getReferencedColumn: (t) => t.indicadorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EvaluacionTableTableAnnotationComposer(
            $db: $db,
            $table: $db.evaluacionTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> escenarioSinteticoTableRefs<T extends Object>(
    Expression<T> Function($$EscenarioSinteticoTableTableAnnotationComposer a)
    f,
  ) {
    final $$EscenarioSinteticoTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.escenarioSinteticoTable,
          getReferencedColumn: (t) => t.indicadorBaseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EscenarioSinteticoTableTableAnnotationComposer(
                $db: $db,
                $table: $db.escenarioSinteticoTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$IndicadorTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IndicadorTableTable,
          IndicadorTableData,
          $$IndicadorTableTableFilterComposer,
          $$IndicadorTableTableOrderingComposer,
          $$IndicadorTableTableAnnotationComposer,
          $$IndicadorTableTableCreateCompanionBuilder,
          $$IndicadorTableTableUpdateCompanionBuilder,
          (IndicadorTableData, $$IndicadorTableTableReferences),
          IndicadorTableData,
          PrefetchHooks Function({
            bool organizacionId,
            bool medicionTableRefs,
            bool reglaPatronTableRefs,
            bool evaluacionTableRefs,
            bool escenarioSinteticoTableRefs,
          })
        > {
  $$IndicadorTableTableTableManager(
    _$AppDatabase db,
    $IndicadorTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IndicadorTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IndicadorTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IndicadorTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> organizacionId = const Value.absent(),
                Value<String> codigo = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> categoria = const Value.absent(),
                Value<String> unidad = const Value.absent(),
                Value<int> decimales = const Value.absent(),
                Value<String> sentido = const Value.absent(),
                Value<double> meta = const Value.absent(),
                Value<double> bandaInferior = const Value.absent(),
                Value<double> bandaSuperior = const Value.absent(),
                Value<String> granularidad = const Value.absent(),
                Value<String> proceso = const Value.absent(),
                Value<bool> activo = const Value.absent(),
              }) => IndicadorTableCompanion(
                id: id,
                organizacionId: organizacionId,
                codigo: codigo,
                nombre: nombre,
                categoria: categoria,
                unidad: unidad,
                decimales: decimales,
                sentido: sentido,
                meta: meta,
                bandaInferior: bandaInferior,
                bandaSuperior: bandaSuperior,
                granularidad: granularidad,
                proceso: proceso,
                activo: activo,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int organizacionId,
                required String codigo,
                required String nombre,
                required String categoria,
                required String unidad,
                Value<int> decimales = const Value.absent(),
                required String sentido,
                required double meta,
                required double bandaInferior,
                required double bandaSuperior,
                required String granularidad,
                required String proceso,
                Value<bool> activo = const Value.absent(),
              }) => IndicadorTableCompanion.insert(
                id: id,
                organizacionId: organizacionId,
                codigo: codigo,
                nombre: nombre,
                categoria: categoria,
                unidad: unidad,
                decimales: decimales,
                sentido: sentido,
                meta: meta,
                bandaInferior: bandaInferior,
                bandaSuperior: bandaSuperior,
                granularidad: granularidad,
                proceso: proceso,
                activo: activo,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IndicadorTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                organizacionId = false,
                medicionTableRefs = false,
                reglaPatronTableRefs = false,
                evaluacionTableRefs = false,
                escenarioSinteticoTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (medicionTableRefs) db.medicionTable,
                    if (reglaPatronTableRefs) db.reglaPatronTable,
                    if (evaluacionTableRefs) db.evaluacionTable,
                    if (escenarioSinteticoTableRefs) db.escenarioSinteticoTable,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (organizacionId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.organizacionId,
                            referencedTable: $$IndicadorTableTableReferences
                                ._organizacionIdTable(db),
                            referencedColumn: $$IndicadorTableTableReferences
                                ._organizacionIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (medicionTableRefs)
                        await $_getPrefetchedData<
                          IndicadorTableData,
                          $IndicadorTableTable,
                          MedicionTableData
                        >(
                          currentTable: table,
                          referencedTable: $$IndicadorTableTableReferences
                              ._medicionTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IndicadorTableTableReferences(
                                db,
                                table,
                                p0,
                              ).medicionTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.indicadorId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (reglaPatronTableRefs)
                        await $_getPrefetchedData<
                          IndicadorTableData,
                          $IndicadorTableTable,
                          ReglaPatronTableData
                        >(
                          currentTable: table,
                          referencedTable: $$IndicadorTableTableReferences
                              ._reglaPatronTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IndicadorTableTableReferences(
                                db,
                                table,
                                p0,
                              ).reglaPatronTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.indicadorId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (evaluacionTableRefs)
                        await $_getPrefetchedData<
                          IndicadorTableData,
                          $IndicadorTableTable,
                          EvaluacionTableData
                        >(
                          currentTable: table,
                          referencedTable: $$IndicadorTableTableReferences
                              ._evaluacionTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IndicadorTableTableReferences(
                                db,
                                table,
                                p0,
                              ).evaluacionTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.indicadorId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (escenarioSinteticoTableRefs)
                        await $_getPrefetchedData<
                          IndicadorTableData,
                          $IndicadorTableTable,
                          EscenarioSinteticoTableData
                        >(
                          currentTable: table,
                          referencedTable: $$IndicadorTableTableReferences
                              ._escenarioSinteticoTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IndicadorTableTableReferences(
                                db,
                                table,
                                p0,
                              ).escenarioSinteticoTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.indicadorBaseId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$IndicadorTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IndicadorTableTable,
      IndicadorTableData,
      $$IndicadorTableTableFilterComposer,
      $$IndicadorTableTableOrderingComposer,
      $$IndicadorTableTableAnnotationComposer,
      $$IndicadorTableTableCreateCompanionBuilder,
      $$IndicadorTableTableUpdateCompanionBuilder,
      (IndicadorTableData, $$IndicadorTableTableReferences),
      IndicadorTableData,
      PrefetchHooks Function({
        bool organizacionId,
        bool medicionTableRefs,
        bool reglaPatronTableRefs,
        bool evaluacionTableRefs,
        bool escenarioSinteticoTableRefs,
      })
    >;
typedef $$MedicionTableTableCreateCompanionBuilder =
    MedicionTableCompanion Function({
      Value<int> id,
      required int indicadorId,
      required int periodoId,
      required double valor,
      required String origen,
      Value<String?> nota,
    });
typedef $$MedicionTableTableUpdateCompanionBuilder =
    MedicionTableCompanion Function({
      Value<int> id,
      Value<int> indicadorId,
      Value<int> periodoId,
      Value<double> valor,
      Value<String> origen,
      Value<String?> nota,
    });

final class $$MedicionTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $MedicionTableTable, MedicionTableData> {
  $$MedicionTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $IndicadorTableTable _indicadorIdTable(_$AppDatabase db) =>
      db.indicadorTable.createAlias('medicion__indicador_id__indicador__id');

  $$IndicadorTableTableProcessedTableManager get indicadorId {
    final $_column = $_itemColumn<int>('indicador_id')!;

    final manager = $$IndicadorTableTableTableManager(
      $_db,
      $_db.indicadorTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_indicadorIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PeriodoTableTable _periodoIdTable(_$AppDatabase db) =>
      db.periodoTable.createAlias('medicion__periodo_id__periodo__id');

  $$PeriodoTableTableProcessedTableManager get periodoId {
    final $_column = $_itemColumn<int>('periodo_id')!;

    final manager = $$PeriodoTableTableTableManager(
      $_db,
      $_db.periodoTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_periodoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MedicionTableTableFilterComposer
    extends Composer<_$AppDatabase, $MedicionTableTable> {
  $$MedicionTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get origen => $composableBuilder(
    column: $table.origen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nota => $composableBuilder(
    column: $table.nota,
    builder: (column) => ColumnFilters(column),
  );

  $$IndicadorTableTableFilterComposer get indicadorId {
    final $$IndicadorTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.indicadorId,
      referencedTable: $db.indicadorTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IndicadorTableTableFilterComposer(
            $db: $db,
            $table: $db.indicadorTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PeriodoTableTableFilterComposer get periodoId {
    final $$PeriodoTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.periodoId,
      referencedTable: $db.periodoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeriodoTableTableFilterComposer(
            $db: $db,
            $table: $db.periodoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicionTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicionTableTable> {
  $$MedicionTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get origen => $composableBuilder(
    column: $table.origen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nota => $composableBuilder(
    column: $table.nota,
    builder: (column) => ColumnOrderings(column),
  );

  $$IndicadorTableTableOrderingComposer get indicadorId {
    final $$IndicadorTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.indicadorId,
      referencedTable: $db.indicadorTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IndicadorTableTableOrderingComposer(
            $db: $db,
            $table: $db.indicadorTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PeriodoTableTableOrderingComposer get periodoId {
    final $$PeriodoTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.periodoId,
      referencedTable: $db.periodoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeriodoTableTableOrderingComposer(
            $db: $db,
            $table: $db.periodoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicionTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicionTableTable> {
  $$MedicionTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get valor =>
      $composableBuilder(column: $table.valor, builder: (column) => column);

  GeneratedColumn<String> get origen =>
      $composableBuilder(column: $table.origen, builder: (column) => column);

  GeneratedColumn<String> get nota =>
      $composableBuilder(column: $table.nota, builder: (column) => column);

  $$IndicadorTableTableAnnotationComposer get indicadorId {
    final $$IndicadorTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.indicadorId,
      referencedTable: $db.indicadorTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IndicadorTableTableAnnotationComposer(
            $db: $db,
            $table: $db.indicadorTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PeriodoTableTableAnnotationComposer get periodoId {
    final $$PeriodoTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.periodoId,
      referencedTable: $db.periodoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeriodoTableTableAnnotationComposer(
            $db: $db,
            $table: $db.periodoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicionTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicionTableTable,
          MedicionTableData,
          $$MedicionTableTableFilterComposer,
          $$MedicionTableTableOrderingComposer,
          $$MedicionTableTableAnnotationComposer,
          $$MedicionTableTableCreateCompanionBuilder,
          $$MedicionTableTableUpdateCompanionBuilder,
          (MedicionTableData, $$MedicionTableTableReferences),
          MedicionTableData,
          PrefetchHooks Function({bool indicadorId, bool periodoId})
        > {
  $$MedicionTableTableTableManager(_$AppDatabase db, $MedicionTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicionTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicionTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicionTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> indicadorId = const Value.absent(),
                Value<int> periodoId = const Value.absent(),
                Value<double> valor = const Value.absent(),
                Value<String> origen = const Value.absent(),
                Value<String?> nota = const Value.absent(),
              }) => MedicionTableCompanion(
                id: id,
                indicadorId: indicadorId,
                periodoId: periodoId,
                valor: valor,
                origen: origen,
                nota: nota,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int indicadorId,
                required int periodoId,
                required double valor,
                required String origen,
                Value<String?> nota = const Value.absent(),
              }) => MedicionTableCompanion.insert(
                id: id,
                indicadorId: indicadorId,
                periodoId: periodoId,
                valor: valor,
                origen: origen,
                nota: nota,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MedicionTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({indicadorId = false, periodoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (indicadorId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.indicadorId,
                        referencedTable: $$MedicionTableTableReferences
                            ._indicadorIdTable(db),
                        referencedColumn: $$MedicionTableTableReferences
                            ._indicadorIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (periodoId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.periodoId,
                        referencedTable: $$MedicionTableTableReferences
                            ._periodoIdTable(db),
                        referencedColumn: $$MedicionTableTableReferences
                            ._periodoIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MedicionTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicionTableTable,
      MedicionTableData,
      $$MedicionTableTableFilterComposer,
      $$MedicionTableTableOrderingComposer,
      $$MedicionTableTableAnnotationComposer,
      $$MedicionTableTableCreateCompanionBuilder,
      $$MedicionTableTableUpdateCompanionBuilder,
      (MedicionTableData, $$MedicionTableTableReferences),
      MedicionTableData,
      PrefetchHooks Function({bool indicadorId, bool periodoId})
    >;
typedef $$ReglaPatronTableTableCreateCompanionBuilder =
    ReglaPatronTableCompanion Function({
      Value<int> id,
      required String codigo,
      required String nombre,
      required String descripcion,
      required String parametrosJson,
      required int periodosMinimos,
      required double severidadBase,
      Value<bool> activa,
      Value<int?> indicadorId,
    });
typedef $$ReglaPatronTableTableUpdateCompanionBuilder =
    ReglaPatronTableCompanion Function({
      Value<int> id,
      Value<String> codigo,
      Value<String> nombre,
      Value<String> descripcion,
      Value<String> parametrosJson,
      Value<int> periodosMinimos,
      Value<double> severidadBase,
      Value<bool> activa,
      Value<int?> indicadorId,
    });

final class $$ReglaPatronTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ReglaPatronTableTable,
          ReglaPatronTableData
        > {
  $$ReglaPatronTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $IndicadorTableTable _indicadorIdTable(_$AppDatabase db) => db
      .indicadorTable
      .createAlias('regla_patron__indicador_id__indicador__id');

  $$IndicadorTableTableProcessedTableManager? get indicadorId {
    final $_column = $_itemColumn<int>('indicador_id');
    if ($_column == null) return null;
    final manager = $$IndicadorTableTableTableManager(
      $_db,
      $_db.indicadorTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_indicadorIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $MemoriaEvaluacionTableTable,
    List<MemoriaEvaluacionTableData>
  >
  _memoriaEvaluacionTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.memoriaEvaluacionTable,
        aliasName: 'regla_patron__id__memoria_evaluacion__regla_id',
      );

  $$MemoriaEvaluacionTableTableProcessedTableManager
  get memoriaEvaluacionTableRefs {
    final manager = $$MemoriaEvaluacionTableTableTableManager(
      $_db,
      $_db.memoriaEvaluacionTable,
    ).filter((f) => f.reglaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _memoriaEvaluacionTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ReglaPatronTableTableFilterComposer
    extends Composer<_$AppDatabase, $ReglaPatronTableTable> {
  $$ReglaPatronTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parametrosJson => $composableBuilder(
    column: $table.parametrosJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get periodosMinimos => $composableBuilder(
    column: $table.periodosMinimos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get severidadBase => $composableBuilder(
    column: $table.severidadBase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activa => $composableBuilder(
    column: $table.activa,
    builder: (column) => ColumnFilters(column),
  );

  $$IndicadorTableTableFilterComposer get indicadorId {
    final $$IndicadorTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.indicadorId,
      referencedTable: $db.indicadorTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IndicadorTableTableFilterComposer(
            $db: $db,
            $table: $db.indicadorTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> memoriaEvaluacionTableRefs(
    Expression<bool> Function($$MemoriaEvaluacionTableTableFilterComposer f) f,
  ) {
    final $$MemoriaEvaluacionTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.memoriaEvaluacionTable,
          getReferencedColumn: (t) => t.reglaId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MemoriaEvaluacionTableTableFilterComposer(
                $db: $db,
                $table: $db.memoriaEvaluacionTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ReglaPatronTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ReglaPatronTableTable> {
  $$ReglaPatronTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parametrosJson => $composableBuilder(
    column: $table.parametrosJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get periodosMinimos => $composableBuilder(
    column: $table.periodosMinimos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get severidadBase => $composableBuilder(
    column: $table.severidadBase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activa => $composableBuilder(
    column: $table.activa,
    builder: (column) => ColumnOrderings(column),
  );

  $$IndicadorTableTableOrderingComposer get indicadorId {
    final $$IndicadorTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.indicadorId,
      referencedTable: $db.indicadorTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IndicadorTableTableOrderingComposer(
            $db: $db,
            $table: $db.indicadorTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReglaPatronTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReglaPatronTableTable> {
  $$ReglaPatronTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get parametrosJson => $composableBuilder(
    column: $table.parametrosJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get periodosMinimos => $composableBuilder(
    column: $table.periodosMinimos,
    builder: (column) => column,
  );

  GeneratedColumn<double> get severidadBase => $composableBuilder(
    column: $table.severidadBase,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get activa =>
      $composableBuilder(column: $table.activa, builder: (column) => column);

  $$IndicadorTableTableAnnotationComposer get indicadorId {
    final $$IndicadorTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.indicadorId,
      referencedTable: $db.indicadorTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IndicadorTableTableAnnotationComposer(
            $db: $db,
            $table: $db.indicadorTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> memoriaEvaluacionTableRefs<T extends Object>(
    Expression<T> Function($$MemoriaEvaluacionTableTableAnnotationComposer a) f,
  ) {
    final $$MemoriaEvaluacionTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.memoriaEvaluacionTable,
          getReferencedColumn: (t) => t.reglaId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MemoriaEvaluacionTableTableAnnotationComposer(
                $db: $db,
                $table: $db.memoriaEvaluacionTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ReglaPatronTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReglaPatronTableTable,
          ReglaPatronTableData,
          $$ReglaPatronTableTableFilterComposer,
          $$ReglaPatronTableTableOrderingComposer,
          $$ReglaPatronTableTableAnnotationComposer,
          $$ReglaPatronTableTableCreateCompanionBuilder,
          $$ReglaPatronTableTableUpdateCompanionBuilder,
          (ReglaPatronTableData, $$ReglaPatronTableTableReferences),
          ReglaPatronTableData,
          PrefetchHooks Function({
            bool indicadorId,
            bool memoriaEvaluacionTableRefs,
          })
        > {
  $$ReglaPatronTableTableTableManager(
    _$AppDatabase db,
    $ReglaPatronTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReglaPatronTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReglaPatronTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReglaPatronTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> codigo = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> descripcion = const Value.absent(),
                Value<String> parametrosJson = const Value.absent(),
                Value<int> periodosMinimos = const Value.absent(),
                Value<double> severidadBase = const Value.absent(),
                Value<bool> activa = const Value.absent(),
                Value<int?> indicadorId = const Value.absent(),
              }) => ReglaPatronTableCompanion(
                id: id,
                codigo: codigo,
                nombre: nombre,
                descripcion: descripcion,
                parametrosJson: parametrosJson,
                periodosMinimos: periodosMinimos,
                severidadBase: severidadBase,
                activa: activa,
                indicadorId: indicadorId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String codigo,
                required String nombre,
                required String descripcion,
                required String parametrosJson,
                required int periodosMinimos,
                required double severidadBase,
                Value<bool> activa = const Value.absent(),
                Value<int?> indicadorId = const Value.absent(),
              }) => ReglaPatronTableCompanion.insert(
                id: id,
                codigo: codigo,
                nombre: nombre,
                descripcion: descripcion,
                parametrosJson: parametrosJson,
                periodosMinimos: periodosMinimos,
                severidadBase: severidadBase,
                activa: activa,
                indicadorId: indicadorId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ReglaPatronTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({indicadorId = false, memoriaEvaluacionTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (memoriaEvaluacionTableRefs) db.memoriaEvaluacionTable,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (indicadorId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.indicadorId,
                            referencedTable: $$ReglaPatronTableTableReferences
                                ._indicadorIdTable(db),
                            referencedColumn: $$ReglaPatronTableTableReferences
                                ._indicadorIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (memoriaEvaluacionTableRefs)
                        await $_getPrefetchedData<
                          ReglaPatronTableData,
                          $ReglaPatronTableTable,
                          MemoriaEvaluacionTableData
                        >(
                          currentTable: table,
                          referencedTable: $$ReglaPatronTableTableReferences
                              ._memoriaEvaluacionTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ReglaPatronTableTableReferences(
                                db,
                                table,
                                p0,
                              ).memoriaEvaluacionTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.reglaId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ReglaPatronTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReglaPatronTableTable,
      ReglaPatronTableData,
      $$ReglaPatronTableTableFilterComposer,
      $$ReglaPatronTableTableOrderingComposer,
      $$ReglaPatronTableTableAnnotationComposer,
      $$ReglaPatronTableTableCreateCompanionBuilder,
      $$ReglaPatronTableTableUpdateCompanionBuilder,
      (ReglaPatronTableData, $$ReglaPatronTableTableReferences),
      ReglaPatronTableData,
      PrefetchHooks Function({
        bool indicadorId,
        bool memoriaEvaluacionTableRefs,
      })
    >;
typedef $$EvaluacionTableTableCreateCompanionBuilder =
    EvaluacionTableCompanion Function({
      Value<int> id,
      required int indicadorId,
      required int periodoId,
      required String estado,
      required String clasificacion,
      required String reglasDisparadasJson,
      required double severidadCalculada,
    });
typedef $$EvaluacionTableTableUpdateCompanionBuilder =
    EvaluacionTableCompanion Function({
      Value<int> id,
      Value<int> indicadorId,
      Value<int> periodoId,
      Value<String> estado,
      Value<String> clasificacion,
      Value<String> reglasDisparadasJson,
      Value<double> severidadCalculada,
    });

final class $$EvaluacionTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $EvaluacionTableTable,
          EvaluacionTableData
        > {
  $$EvaluacionTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $IndicadorTableTable _indicadorIdTable(_$AppDatabase db) =>
      db.indicadorTable.createAlias('evaluacion__indicador_id__indicador__id');

  $$IndicadorTableTableProcessedTableManager get indicadorId {
    final $_column = $_itemColumn<int>('indicador_id')!;

    final manager = $$IndicadorTableTableTableManager(
      $_db,
      $_db.indicadorTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_indicadorIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PeriodoTableTable _periodoIdTable(_$AppDatabase db) =>
      db.periodoTable.createAlias('evaluacion__periodo_id__periodo__id');

  $$PeriodoTableTableProcessedTableManager get periodoId {
    final $_column = $_itemColumn<int>('periodo_id')!;

    final manager = $$PeriodoTableTableTableManager(
      $_db,
      $_db.periodoTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_periodoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $MemoriaEvaluacionTableTable,
    List<MemoriaEvaluacionTableData>
  >
  _memoriaEvaluacionTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.memoriaEvaluacionTable,
        aliasName: 'evaluacion__id__memoria_evaluacion__evaluacion_id',
      );

  $$MemoriaEvaluacionTableTableProcessedTableManager
  get memoriaEvaluacionTableRefs {
    final manager = $$MemoriaEvaluacionTableTableTableManager(
      $_db,
      $_db.memoriaEvaluacionTable,
    ).filter((f) => f.evaluacionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _memoriaEvaluacionTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $AccionTomadaTableTable,
    List<AccionTomadaTableData>
  >
  _accionTomadaTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.accionTomadaTable,
        aliasName: 'evaluacion__id__accion_tomada__evaluacion_id',
      );

  $$AccionTomadaTableTableProcessedTableManager get accionTomadaTableRefs {
    final manager = $$AccionTomadaTableTableTableManager(
      $_db,
      $_db.accionTomadaTable,
    ).filter((f) => f.evaluacionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _accionTomadaTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EvaluacionTableTableFilterComposer
    extends Composer<_$AppDatabase, $EvaluacionTableTable> {
  $$EvaluacionTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clasificacion => $composableBuilder(
    column: $table.clasificacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reglasDisparadasJson => $composableBuilder(
    column: $table.reglasDisparadasJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get severidadCalculada => $composableBuilder(
    column: $table.severidadCalculada,
    builder: (column) => ColumnFilters(column),
  );

  $$IndicadorTableTableFilterComposer get indicadorId {
    final $$IndicadorTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.indicadorId,
      referencedTable: $db.indicadorTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IndicadorTableTableFilterComposer(
            $db: $db,
            $table: $db.indicadorTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PeriodoTableTableFilterComposer get periodoId {
    final $$PeriodoTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.periodoId,
      referencedTable: $db.periodoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeriodoTableTableFilterComposer(
            $db: $db,
            $table: $db.periodoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> memoriaEvaluacionTableRefs(
    Expression<bool> Function($$MemoriaEvaluacionTableTableFilterComposer f) f,
  ) {
    final $$MemoriaEvaluacionTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.memoriaEvaluacionTable,
          getReferencedColumn: (t) => t.evaluacionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MemoriaEvaluacionTableTableFilterComposer(
                $db: $db,
                $table: $db.memoriaEvaluacionTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> accionTomadaTableRefs(
    Expression<bool> Function($$AccionTomadaTableTableFilterComposer f) f,
  ) {
    final $$AccionTomadaTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.accionTomadaTable,
      getReferencedColumn: (t) => t.evaluacionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccionTomadaTableTableFilterComposer(
            $db: $db,
            $table: $db.accionTomadaTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EvaluacionTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EvaluacionTableTable> {
  $$EvaluacionTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clasificacion => $composableBuilder(
    column: $table.clasificacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reglasDisparadasJson => $composableBuilder(
    column: $table.reglasDisparadasJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get severidadCalculada => $composableBuilder(
    column: $table.severidadCalculada,
    builder: (column) => ColumnOrderings(column),
  );

  $$IndicadorTableTableOrderingComposer get indicadorId {
    final $$IndicadorTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.indicadorId,
      referencedTable: $db.indicadorTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IndicadorTableTableOrderingComposer(
            $db: $db,
            $table: $db.indicadorTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PeriodoTableTableOrderingComposer get periodoId {
    final $$PeriodoTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.periodoId,
      referencedTable: $db.periodoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeriodoTableTableOrderingComposer(
            $db: $db,
            $table: $db.periodoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EvaluacionTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EvaluacionTableTable> {
  $$EvaluacionTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<String> get clasificacion => $composableBuilder(
    column: $table.clasificacion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reglasDisparadasJson => $composableBuilder(
    column: $table.reglasDisparadasJson,
    builder: (column) => column,
  );

  GeneratedColumn<double> get severidadCalculada => $composableBuilder(
    column: $table.severidadCalculada,
    builder: (column) => column,
  );

  $$IndicadorTableTableAnnotationComposer get indicadorId {
    final $$IndicadorTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.indicadorId,
      referencedTable: $db.indicadorTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IndicadorTableTableAnnotationComposer(
            $db: $db,
            $table: $db.indicadorTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PeriodoTableTableAnnotationComposer get periodoId {
    final $$PeriodoTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.periodoId,
      referencedTable: $db.periodoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeriodoTableTableAnnotationComposer(
            $db: $db,
            $table: $db.periodoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> memoriaEvaluacionTableRefs<T extends Object>(
    Expression<T> Function($$MemoriaEvaluacionTableTableAnnotationComposer a) f,
  ) {
    final $$MemoriaEvaluacionTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.memoriaEvaluacionTable,
          getReferencedColumn: (t) => t.evaluacionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MemoriaEvaluacionTableTableAnnotationComposer(
                $db: $db,
                $table: $db.memoriaEvaluacionTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> accionTomadaTableRefs<T extends Object>(
    Expression<T> Function($$AccionTomadaTableTableAnnotationComposer a) f,
  ) {
    final $$AccionTomadaTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.accionTomadaTable,
          getReferencedColumn: (t) => t.evaluacionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AccionTomadaTableTableAnnotationComposer(
                $db: $db,
                $table: $db.accionTomadaTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$EvaluacionTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EvaluacionTableTable,
          EvaluacionTableData,
          $$EvaluacionTableTableFilterComposer,
          $$EvaluacionTableTableOrderingComposer,
          $$EvaluacionTableTableAnnotationComposer,
          $$EvaluacionTableTableCreateCompanionBuilder,
          $$EvaluacionTableTableUpdateCompanionBuilder,
          (EvaluacionTableData, $$EvaluacionTableTableReferences),
          EvaluacionTableData,
          PrefetchHooks Function({
            bool indicadorId,
            bool periodoId,
            bool memoriaEvaluacionTableRefs,
            bool accionTomadaTableRefs,
          })
        > {
  $$EvaluacionTableTableTableManager(
    _$AppDatabase db,
    $EvaluacionTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EvaluacionTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EvaluacionTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EvaluacionTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> indicadorId = const Value.absent(),
                Value<int> periodoId = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<String> clasificacion = const Value.absent(),
                Value<String> reglasDisparadasJson = const Value.absent(),
                Value<double> severidadCalculada = const Value.absent(),
              }) => EvaluacionTableCompanion(
                id: id,
                indicadorId: indicadorId,
                periodoId: periodoId,
                estado: estado,
                clasificacion: clasificacion,
                reglasDisparadasJson: reglasDisparadasJson,
                severidadCalculada: severidadCalculada,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int indicadorId,
                required int periodoId,
                required String estado,
                required String clasificacion,
                required String reglasDisparadasJson,
                required double severidadCalculada,
              }) => EvaluacionTableCompanion.insert(
                id: id,
                indicadorId: indicadorId,
                periodoId: periodoId,
                estado: estado,
                clasificacion: clasificacion,
                reglasDisparadasJson: reglasDisparadasJson,
                severidadCalculada: severidadCalculada,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EvaluacionTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                indicadorId = false,
                periodoId = false,
                memoriaEvaluacionTableRefs = false,
                accionTomadaTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (memoriaEvaluacionTableRefs) db.memoriaEvaluacionTable,
                    if (accionTomadaTableRefs) db.accionTomadaTable,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (indicadorId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.indicadorId,
                            referencedTable: $$EvaluacionTableTableReferences
                                ._indicadorIdTable(db),
                            referencedColumn: $$EvaluacionTableTableReferences
                                ._indicadorIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (periodoId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.periodoId,
                            referencedTable: $$EvaluacionTableTableReferences
                                ._periodoIdTable(db),
                            referencedColumn: $$EvaluacionTableTableReferences
                                ._periodoIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (memoriaEvaluacionTableRefs)
                        await $_getPrefetchedData<
                          EvaluacionTableData,
                          $EvaluacionTableTable,
                          MemoriaEvaluacionTableData
                        >(
                          currentTable: table,
                          referencedTable: $$EvaluacionTableTableReferences
                              ._memoriaEvaluacionTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EvaluacionTableTableReferences(
                                db,
                                table,
                                p0,
                              ).memoriaEvaluacionTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.evaluacionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (accionTomadaTableRefs)
                        await $_getPrefetchedData<
                          EvaluacionTableData,
                          $EvaluacionTableTable,
                          AccionTomadaTableData
                        >(
                          currentTable: table,
                          referencedTable: $$EvaluacionTableTableReferences
                              ._accionTomadaTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EvaluacionTableTableReferences(
                                db,
                                table,
                                p0,
                              ).accionTomadaTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.evaluacionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$EvaluacionTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EvaluacionTableTable,
      EvaluacionTableData,
      $$EvaluacionTableTableFilterComposer,
      $$EvaluacionTableTableOrderingComposer,
      $$EvaluacionTableTableAnnotationComposer,
      $$EvaluacionTableTableCreateCompanionBuilder,
      $$EvaluacionTableTableUpdateCompanionBuilder,
      (EvaluacionTableData, $$EvaluacionTableTableReferences),
      EvaluacionTableData,
      PrefetchHooks Function({
        bool indicadorId,
        bool periodoId,
        bool memoriaEvaluacionTableRefs,
        bool accionTomadaTableRefs,
      })
    >;
typedef $$MemoriaEvaluacionTableTableCreateCompanionBuilder =
    MemoriaEvaluacionTableCompanion Function({
      Value<int> id,
      required int evaluacionId,
      required int reglaId,
      required String resultado,
      required String valoresEntradaJson,
      required String explicacion,
    });
typedef $$MemoriaEvaluacionTableTableUpdateCompanionBuilder =
    MemoriaEvaluacionTableCompanion Function({
      Value<int> id,
      Value<int> evaluacionId,
      Value<int> reglaId,
      Value<String> resultado,
      Value<String> valoresEntradaJson,
      Value<String> explicacion,
    });

final class $$MemoriaEvaluacionTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MemoriaEvaluacionTableTable,
          MemoriaEvaluacionTableData
        > {
  $$MemoriaEvaluacionTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EvaluacionTableTable _evaluacionIdTable(_$AppDatabase db) => db
      .evaluacionTable
      .createAlias('memoria_evaluacion__evaluacion_id__evaluacion__id');

  $$EvaluacionTableTableProcessedTableManager get evaluacionId {
    final $_column = $_itemColumn<int>('evaluacion_id')!;

    final manager = $$EvaluacionTableTableTableManager(
      $_db,
      $_db.evaluacionTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_evaluacionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ReglaPatronTableTable _reglaIdTable(_$AppDatabase db) => db
      .reglaPatronTable
      .createAlias('memoria_evaluacion__regla_id__regla_patron__id');

  $$ReglaPatronTableTableProcessedTableManager get reglaId {
    final $_column = $_itemColumn<int>('regla_id')!;

    final manager = $$ReglaPatronTableTableTableManager(
      $_db,
      $_db.reglaPatronTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_reglaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MemoriaEvaluacionTableTableFilterComposer
    extends Composer<_$AppDatabase, $MemoriaEvaluacionTableTable> {
  $$MemoriaEvaluacionTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resultado => $composableBuilder(
    column: $table.resultado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valoresEntradaJson => $composableBuilder(
    column: $table.valoresEntradaJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explicacion => $composableBuilder(
    column: $table.explicacion,
    builder: (column) => ColumnFilters(column),
  );

  $$EvaluacionTableTableFilterComposer get evaluacionId {
    final $$EvaluacionTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.evaluacionId,
      referencedTable: $db.evaluacionTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EvaluacionTableTableFilterComposer(
            $db: $db,
            $table: $db.evaluacionTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ReglaPatronTableTableFilterComposer get reglaId {
    final $$ReglaPatronTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reglaId,
      referencedTable: $db.reglaPatronTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReglaPatronTableTableFilterComposer(
            $db: $db,
            $table: $db.reglaPatronTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemoriaEvaluacionTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MemoriaEvaluacionTableTable> {
  $$MemoriaEvaluacionTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resultado => $composableBuilder(
    column: $table.resultado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valoresEntradaJson => $composableBuilder(
    column: $table.valoresEntradaJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explicacion => $composableBuilder(
    column: $table.explicacion,
    builder: (column) => ColumnOrderings(column),
  );

  $$EvaluacionTableTableOrderingComposer get evaluacionId {
    final $$EvaluacionTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.evaluacionId,
      referencedTable: $db.evaluacionTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EvaluacionTableTableOrderingComposer(
            $db: $db,
            $table: $db.evaluacionTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ReglaPatronTableTableOrderingComposer get reglaId {
    final $$ReglaPatronTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reglaId,
      referencedTable: $db.reglaPatronTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReglaPatronTableTableOrderingComposer(
            $db: $db,
            $table: $db.reglaPatronTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemoriaEvaluacionTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MemoriaEvaluacionTableTable> {
  $$MemoriaEvaluacionTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get resultado =>
      $composableBuilder(column: $table.resultado, builder: (column) => column);

  GeneratedColumn<String> get valoresEntradaJson => $composableBuilder(
    column: $table.valoresEntradaJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get explicacion => $composableBuilder(
    column: $table.explicacion,
    builder: (column) => column,
  );

  $$EvaluacionTableTableAnnotationComposer get evaluacionId {
    final $$EvaluacionTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.evaluacionId,
      referencedTable: $db.evaluacionTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EvaluacionTableTableAnnotationComposer(
            $db: $db,
            $table: $db.evaluacionTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ReglaPatronTableTableAnnotationComposer get reglaId {
    final $$ReglaPatronTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reglaId,
      referencedTable: $db.reglaPatronTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReglaPatronTableTableAnnotationComposer(
            $db: $db,
            $table: $db.reglaPatronTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemoriaEvaluacionTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MemoriaEvaluacionTableTable,
          MemoriaEvaluacionTableData,
          $$MemoriaEvaluacionTableTableFilterComposer,
          $$MemoriaEvaluacionTableTableOrderingComposer,
          $$MemoriaEvaluacionTableTableAnnotationComposer,
          $$MemoriaEvaluacionTableTableCreateCompanionBuilder,
          $$MemoriaEvaluacionTableTableUpdateCompanionBuilder,
          (MemoriaEvaluacionTableData, $$MemoriaEvaluacionTableTableReferences),
          MemoriaEvaluacionTableData,
          PrefetchHooks Function({bool evaluacionId, bool reglaId})
        > {
  $$MemoriaEvaluacionTableTableTableManager(
    _$AppDatabase db,
    $MemoriaEvaluacionTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MemoriaEvaluacionTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$MemoriaEvaluacionTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MemoriaEvaluacionTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> evaluacionId = const Value.absent(),
                Value<int> reglaId = const Value.absent(),
                Value<String> resultado = const Value.absent(),
                Value<String> valoresEntradaJson = const Value.absent(),
                Value<String> explicacion = const Value.absent(),
              }) => MemoriaEvaluacionTableCompanion(
                id: id,
                evaluacionId: evaluacionId,
                reglaId: reglaId,
                resultado: resultado,
                valoresEntradaJson: valoresEntradaJson,
                explicacion: explicacion,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int evaluacionId,
                required int reglaId,
                required String resultado,
                required String valoresEntradaJson,
                required String explicacion,
              }) => MemoriaEvaluacionTableCompanion.insert(
                id: id,
                evaluacionId: evaluacionId,
                reglaId: reglaId,
                resultado: resultado,
                valoresEntradaJson: valoresEntradaJson,
                explicacion: explicacion,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MemoriaEvaluacionTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({evaluacionId = false, reglaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (evaluacionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.evaluacionId,
                        referencedTable: $$MemoriaEvaluacionTableTableReferences
                            ._evaluacionIdTable(db),
                        referencedColumn:
                            $$MemoriaEvaluacionTableTableReferences
                                ._evaluacionIdTable(db)
                                .id,
                      ) as T;
                    }
                    if (reglaId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.reglaId,
                        referencedTable: $$MemoriaEvaluacionTableTableReferences
                            ._reglaIdTable(db),
                        referencedColumn:
                            $$MemoriaEvaluacionTableTableReferences
                                ._reglaIdTable(db)
                                .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MemoriaEvaluacionTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MemoriaEvaluacionTableTable,
      MemoriaEvaluacionTableData,
      $$MemoriaEvaluacionTableTableFilterComposer,
      $$MemoriaEvaluacionTableTableOrderingComposer,
      $$MemoriaEvaluacionTableTableAnnotationComposer,
      $$MemoriaEvaluacionTableTableCreateCompanionBuilder,
      $$MemoriaEvaluacionTableTableUpdateCompanionBuilder,
      (MemoriaEvaluacionTableData, $$MemoriaEvaluacionTableTableReferences),
      MemoriaEvaluacionTableData,
      PrefetchHooks Function({bool evaluacionId, bool reglaId})
    >;
typedef $$AccionCatalogoTableTableCreateCompanionBuilder =
    AccionCatalogoTableCompanion Function({
      Value<int> id,
      required String codigo,
      required String titulo,
      required String descripcion,
      required String categoriaIndicador,
      required String magnitudTipica,
      Value<bool> esDeSistema,
      Value<String?> aplicacionExternaSugerida,
    });
typedef $$AccionCatalogoTableTableUpdateCompanionBuilder =
    AccionCatalogoTableCompanion Function({
      Value<int> id,
      Value<String> codigo,
      Value<String> titulo,
      Value<String> descripcion,
      Value<String> categoriaIndicador,
      Value<String> magnitudTipica,
      Value<bool> esDeSistema,
      Value<String?> aplicacionExternaSugerida,
    });

final class $$AccionCatalogoTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $AccionCatalogoTableTable,
          AccionCatalogoTableData
        > {
  $$AccionCatalogoTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ReglaAccionTableTable, List<ReglaAccionTableData>>
  _reglaAccionTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reglaAccionTable,
    aliasName: 'accion_catalogo__id__regla_accion__accion_id',
  );

  $$ReglaAccionTableTableProcessedTableManager get reglaAccionTableRefs {
    final manager = $$ReglaAccionTableTableTableManager(
      $_db,
      $_db.reglaAccionTable,
    ).filter((f) => f.accionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _reglaAccionTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $AccionTomadaTableTable,
    List<AccionTomadaTableData>
  >
  _accionTomadaTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.accionTomadaTable,
        aliasName: 'accion_catalogo__id__accion_tomada__accion_catalogo_id',
      );

  $$AccionTomadaTableTableProcessedTableManager get accionTomadaTableRefs {
    final manager = $$AccionTomadaTableTableTableManager(
      $_db,
      $_db.accionTomadaTable,
    ).filter((f) => f.accionCatalogoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _accionTomadaTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AccionCatalogoTableTableFilterComposer
    extends Composer<_$AppDatabase, $AccionCatalogoTableTable> {
  $$AccionCatalogoTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoriaIndicador => $composableBuilder(
    column: $table.categoriaIndicador,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get magnitudTipica => $composableBuilder(
    column: $table.magnitudTipica,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get esDeSistema => $composableBuilder(
    column: $table.esDeSistema,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aplicacionExternaSugerida => $composableBuilder(
    column: $table.aplicacionExternaSugerida,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> reglaAccionTableRefs(
    Expression<bool> Function($$ReglaAccionTableTableFilterComposer f) f,
  ) {
    final $$ReglaAccionTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reglaAccionTable,
      getReferencedColumn: (t) => t.accionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReglaAccionTableTableFilterComposer(
            $db: $db,
            $table: $db.reglaAccionTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> accionTomadaTableRefs(
    Expression<bool> Function($$AccionTomadaTableTableFilterComposer f) f,
  ) {
    final $$AccionTomadaTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.accionTomadaTable,
      getReferencedColumn: (t) => t.accionCatalogoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccionTomadaTableTableFilterComposer(
            $db: $db,
            $table: $db.accionTomadaTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccionCatalogoTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AccionCatalogoTableTable> {
  $$AccionCatalogoTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoriaIndicador => $composableBuilder(
    column: $table.categoriaIndicador,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get magnitudTipica => $composableBuilder(
    column: $table.magnitudTipica,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get esDeSistema => $composableBuilder(
    column: $table.esDeSistema,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aplicacionExternaSugerida => $composableBuilder(
    column: $table.aplicacionExternaSugerida,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccionCatalogoTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccionCatalogoTableTable> {
  $$AccionCatalogoTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<String> get titulo =>
      $composableBuilder(column: $table.titulo, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoriaIndicador => $composableBuilder(
    column: $table.categoriaIndicador,
    builder: (column) => column,
  );

  GeneratedColumn<String> get magnitudTipica => $composableBuilder(
    column: $table.magnitudTipica,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get esDeSistema => $composableBuilder(
    column: $table.esDeSistema,
    builder: (column) => column,
  );

  GeneratedColumn<String> get aplicacionExternaSugerida => $composableBuilder(
    column: $table.aplicacionExternaSugerida,
    builder: (column) => column,
  );

  Expression<T> reglaAccionTableRefs<T extends Object>(
    Expression<T> Function($$ReglaAccionTableTableAnnotationComposer a) f,
  ) {
    final $$ReglaAccionTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reglaAccionTable,
      getReferencedColumn: (t) => t.accionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReglaAccionTableTableAnnotationComposer(
            $db: $db,
            $table: $db.reglaAccionTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> accionTomadaTableRefs<T extends Object>(
    Expression<T> Function($$AccionTomadaTableTableAnnotationComposer a) f,
  ) {
    final $$AccionTomadaTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.accionTomadaTable,
          getReferencedColumn: (t) => t.accionCatalogoId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AccionTomadaTableTableAnnotationComposer(
                $db: $db,
                $table: $db.accionTomadaTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$AccionCatalogoTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccionCatalogoTableTable,
          AccionCatalogoTableData,
          $$AccionCatalogoTableTableFilterComposer,
          $$AccionCatalogoTableTableOrderingComposer,
          $$AccionCatalogoTableTableAnnotationComposer,
          $$AccionCatalogoTableTableCreateCompanionBuilder,
          $$AccionCatalogoTableTableUpdateCompanionBuilder,
          (AccionCatalogoTableData, $$AccionCatalogoTableTableReferences),
          AccionCatalogoTableData,
          PrefetchHooks Function({
            bool reglaAccionTableRefs,
            bool accionTomadaTableRefs,
          })
        > {
  $$AccionCatalogoTableTableTableManager(
    _$AppDatabase db,
    $AccionCatalogoTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccionCatalogoTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccionCatalogoTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AccionCatalogoTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> codigo = const Value.absent(),
                Value<String> titulo = const Value.absent(),
                Value<String> descripcion = const Value.absent(),
                Value<String> categoriaIndicador = const Value.absent(),
                Value<String> magnitudTipica = const Value.absent(),
                Value<bool> esDeSistema = const Value.absent(),
                Value<String?> aplicacionExternaSugerida = const Value.absent(),
              }) => AccionCatalogoTableCompanion(
                id: id,
                codigo: codigo,
                titulo: titulo,
                descripcion: descripcion,
                categoriaIndicador: categoriaIndicador,
                magnitudTipica: magnitudTipica,
                esDeSistema: esDeSistema,
                aplicacionExternaSugerida: aplicacionExternaSugerida,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String codigo,
                required String titulo,
                required String descripcion,
                required String categoriaIndicador,
                required String magnitudTipica,
                Value<bool> esDeSistema = const Value.absent(),
                Value<String?> aplicacionExternaSugerida = const Value.absent(),
              }) => AccionCatalogoTableCompanion.insert(
                id: id,
                codigo: codigo,
                titulo: titulo,
                descripcion: descripcion,
                categoriaIndicador: categoriaIndicador,
                magnitudTipica: magnitudTipica,
                esDeSistema: esDeSistema,
                aplicacionExternaSugerida: aplicacionExternaSugerida,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AccionCatalogoTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({reglaAccionTableRefs = false, accionTomadaTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (reglaAccionTableRefs) db.reglaAccionTable,
                    if (accionTomadaTableRefs) db.accionTomadaTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (reglaAccionTableRefs)
                        await $_getPrefetchedData<
                          AccionCatalogoTableData,
                          $AccionCatalogoTableTable,
                          ReglaAccionTableData
                        >(
                          currentTable: table,
                          referencedTable: $$AccionCatalogoTableTableReferences
                              ._reglaAccionTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccionCatalogoTableTableReferences(
                                db,
                                table,
                                p0,
                              ).reglaAccionTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (accionTomadaTableRefs)
                        await $_getPrefetchedData<
                          AccionCatalogoTableData,
                          $AccionCatalogoTableTable,
                          AccionTomadaTableData
                        >(
                          currentTable: table,
                          referencedTable: $$AccionCatalogoTableTableReferences
                              ._accionTomadaTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccionCatalogoTableTableReferences(
                                db,
                                table,
                                p0,
                              ).accionTomadaTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accionCatalogoId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$AccionCatalogoTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccionCatalogoTableTable,
      AccionCatalogoTableData,
      $$AccionCatalogoTableTableFilterComposer,
      $$AccionCatalogoTableTableOrderingComposer,
      $$AccionCatalogoTableTableAnnotationComposer,
      $$AccionCatalogoTableTableCreateCompanionBuilder,
      $$AccionCatalogoTableTableUpdateCompanionBuilder,
      (AccionCatalogoTableData, $$AccionCatalogoTableTableReferences),
      AccionCatalogoTableData,
      PrefetchHooks Function({
        bool reglaAccionTableRefs,
        bool accionTomadaTableRefs,
      })
    >;
typedef $$ReglaAccionTableTableCreateCompanionBuilder =
    ReglaAccionTableCompanion Function({
      Value<int> id,
      required String categoriaIndicador,
      required String reglaDisparada,
      required String clasificacion,
      required int accionId,
      required int prioridad,
    });
typedef $$ReglaAccionTableTableUpdateCompanionBuilder =
    ReglaAccionTableCompanion Function({
      Value<int> id,
      Value<String> categoriaIndicador,
      Value<String> reglaDisparada,
      Value<String> clasificacion,
      Value<int> accionId,
      Value<int> prioridad,
    });

final class $$ReglaAccionTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ReglaAccionTableTable,
          ReglaAccionTableData
        > {
  $$ReglaAccionTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AccionCatalogoTableTable _accionIdTable(_$AppDatabase db) => db
      .accionCatalogoTable
      .createAlias('regla_accion__accion_id__accion_catalogo__id');

  $$AccionCatalogoTableTableProcessedTableManager get accionId {
    final $_column = $_itemColumn<int>('accion_id')!;

    final manager = $$AccionCatalogoTableTableTableManager(
      $_db,
      $_db.accionCatalogoTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReglaAccionTableTableFilterComposer
    extends Composer<_$AppDatabase, $ReglaAccionTableTable> {
  $$ReglaAccionTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoriaIndicador => $composableBuilder(
    column: $table.categoriaIndicador,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reglaDisparada => $composableBuilder(
    column: $table.reglaDisparada,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clasificacion => $composableBuilder(
    column: $table.clasificacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get prioridad => $composableBuilder(
    column: $table.prioridad,
    builder: (column) => ColumnFilters(column),
  );

  $$AccionCatalogoTableTableFilterComposer get accionId {
    final $$AccionCatalogoTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accionId,
      referencedTable: $db.accionCatalogoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccionCatalogoTableTableFilterComposer(
            $db: $db,
            $table: $db.accionCatalogoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReglaAccionTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ReglaAccionTableTable> {
  $$ReglaAccionTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoriaIndicador => $composableBuilder(
    column: $table.categoriaIndicador,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reglaDisparada => $composableBuilder(
    column: $table.reglaDisparada,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clasificacion => $composableBuilder(
    column: $table.clasificacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get prioridad => $composableBuilder(
    column: $table.prioridad,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccionCatalogoTableTableOrderingComposer get accionId {
    final $$AccionCatalogoTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.accionId,
          referencedTable: $db.accionCatalogoTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AccionCatalogoTableTableOrderingComposer(
                $db: $db,
                $table: $db.accionCatalogoTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ReglaAccionTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReglaAccionTableTable> {
  $$ReglaAccionTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get categoriaIndicador => $composableBuilder(
    column: $table.categoriaIndicador,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reglaDisparada => $composableBuilder(
    column: $table.reglaDisparada,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clasificacion => $composableBuilder(
    column: $table.clasificacion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get prioridad =>
      $composableBuilder(column: $table.prioridad, builder: (column) => column);

  $$AccionCatalogoTableTableAnnotationComposer get accionId {
    final $$AccionCatalogoTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.accionId,
          referencedTable: $db.accionCatalogoTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AccionCatalogoTableTableAnnotationComposer(
                $db: $db,
                $table: $db.accionCatalogoTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ReglaAccionTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReglaAccionTableTable,
          ReglaAccionTableData,
          $$ReglaAccionTableTableFilterComposer,
          $$ReglaAccionTableTableOrderingComposer,
          $$ReglaAccionTableTableAnnotationComposer,
          $$ReglaAccionTableTableCreateCompanionBuilder,
          $$ReglaAccionTableTableUpdateCompanionBuilder,
          (ReglaAccionTableData, $$ReglaAccionTableTableReferences),
          ReglaAccionTableData,
          PrefetchHooks Function({bool accionId})
        > {
  $$ReglaAccionTableTableTableManager(
    _$AppDatabase db,
    $ReglaAccionTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReglaAccionTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReglaAccionTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReglaAccionTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> categoriaIndicador = const Value.absent(),
                Value<String> reglaDisparada = const Value.absent(),
                Value<String> clasificacion = const Value.absent(),
                Value<int> accionId = const Value.absent(),
                Value<int> prioridad = const Value.absent(),
              }) => ReglaAccionTableCompanion(
                id: id,
                categoriaIndicador: categoriaIndicador,
                reglaDisparada: reglaDisparada,
                clasificacion: clasificacion,
                accionId: accionId,
                prioridad: prioridad,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String categoriaIndicador,
                required String reglaDisparada,
                required String clasificacion,
                required int accionId,
                required int prioridad,
              }) => ReglaAccionTableCompanion.insert(
                id: id,
                categoriaIndicador: categoriaIndicador,
                reglaDisparada: reglaDisparada,
                clasificacion: clasificacion,
                accionId: accionId,
                prioridad: prioridad,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ReglaAccionTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({accionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (accionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.accionId,
                        referencedTable: $$ReglaAccionTableTableReferences
                            ._accionIdTable(db),
                        referencedColumn: $$ReglaAccionTableTableReferences
                            ._accionIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReglaAccionTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReglaAccionTableTable,
      ReglaAccionTableData,
      $$ReglaAccionTableTableFilterComposer,
      $$ReglaAccionTableTableOrderingComposer,
      $$ReglaAccionTableTableAnnotationComposer,
      $$ReglaAccionTableTableCreateCompanionBuilder,
      $$ReglaAccionTableTableUpdateCompanionBuilder,
      (ReglaAccionTableData, $$ReglaAccionTableTableReferences),
      ReglaAccionTableData,
      PrefetchHooks Function({bool accionId})
    >;
typedef $$AccionTomadaTableTableCreateCompanionBuilder =
    AccionTomadaTableCompanion Function({
      Value<int> id,
      required int evaluacionId,
      required int accionCatalogoId,
      required String responsable,
      required String fechaCompromiso,
      Value<String> estado,
      Value<String?> notas,
      required String fechaRegistro,
    });
typedef $$AccionTomadaTableTableUpdateCompanionBuilder =
    AccionTomadaTableCompanion Function({
      Value<int> id,
      Value<int> evaluacionId,
      Value<int> accionCatalogoId,
      Value<String> responsable,
      Value<String> fechaCompromiso,
      Value<String> estado,
      Value<String?> notas,
      Value<String> fechaRegistro,
    });

final class $$AccionTomadaTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $AccionTomadaTableTable,
          AccionTomadaTableData
        > {
  $$AccionTomadaTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EvaluacionTableTable _evaluacionIdTable(_$AppDatabase db) => db
      .evaluacionTable
      .createAlias('accion_tomada__evaluacion_id__evaluacion__id');

  $$EvaluacionTableTableProcessedTableManager get evaluacionId {
    final $_column = $_itemColumn<int>('evaluacion_id')!;

    final manager = $$EvaluacionTableTableTableManager(
      $_db,
      $_db.evaluacionTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_evaluacionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AccionCatalogoTableTable _accionCatalogoIdTable(_$AppDatabase db) =>
      db.accionCatalogoTable.createAlias(
        'accion_tomada__accion_catalogo_id__accion_catalogo__id',
      );

  $$AccionCatalogoTableTableProcessedTableManager get accionCatalogoId {
    final $_column = $_itemColumn<int>('accion_catalogo_id')!;

    final manager = $$AccionCatalogoTableTableTableManager(
      $_db,
      $_db.accionCatalogoTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accionCatalogoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $VerificacionAccionTableTable,
    List<VerificacionAccionTableData>
  >
  _verificacionAccionTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.verificacionAccionTable,
        aliasName: 'accion_tomada__id__verificacion_accion__accion_tomada_id',
      );

  $$VerificacionAccionTableTableProcessedTableManager
  get verificacionAccionTableRefs {
    final manager = $$VerificacionAccionTableTableTableManager(
      $_db,
      $_db.verificacionAccionTable,
    ).filter((f) => f.accionTomadaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _verificacionAccionTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AccionTomadaTableTableFilterComposer
    extends Composer<_$AppDatabase, $AccionTomadaTableTable> {
  $$AccionTomadaTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get responsable => $composableBuilder(
    column: $table.responsable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fechaCompromiso => $composableBuilder(
    column: $table.fechaCompromiso,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notas => $composableBuilder(
    column: $table.notas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fechaRegistro => $composableBuilder(
    column: $table.fechaRegistro,
    builder: (column) => ColumnFilters(column),
  );

  $$EvaluacionTableTableFilterComposer get evaluacionId {
    final $$EvaluacionTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.evaluacionId,
      referencedTable: $db.evaluacionTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EvaluacionTableTableFilterComposer(
            $db: $db,
            $table: $db.evaluacionTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccionCatalogoTableTableFilterComposer get accionCatalogoId {
    final $$AccionCatalogoTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accionCatalogoId,
      referencedTable: $db.accionCatalogoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccionCatalogoTableTableFilterComposer(
            $db: $db,
            $table: $db.accionCatalogoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> verificacionAccionTableRefs(
    Expression<bool> Function($$VerificacionAccionTableTableFilterComposer f) f,
  ) {
    final $$VerificacionAccionTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.verificacionAccionTable,
          getReferencedColumn: (t) => t.accionTomadaId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$VerificacionAccionTableTableFilterComposer(
                $db: $db,
                $table: $db.verificacionAccionTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$AccionTomadaTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AccionTomadaTableTable> {
  $$AccionTomadaTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get responsable => $composableBuilder(
    column: $table.responsable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fechaCompromiso => $composableBuilder(
    column: $table.fechaCompromiso,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notas => $composableBuilder(
    column: $table.notas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fechaRegistro => $composableBuilder(
    column: $table.fechaRegistro,
    builder: (column) => ColumnOrderings(column),
  );

  $$EvaluacionTableTableOrderingComposer get evaluacionId {
    final $$EvaluacionTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.evaluacionId,
      referencedTable: $db.evaluacionTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EvaluacionTableTableOrderingComposer(
            $db: $db,
            $table: $db.evaluacionTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccionCatalogoTableTableOrderingComposer get accionCatalogoId {
    final $$AccionCatalogoTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.accionCatalogoId,
          referencedTable: $db.accionCatalogoTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AccionCatalogoTableTableOrderingComposer(
                $db: $db,
                $table: $db.accionCatalogoTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$AccionTomadaTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccionTomadaTableTable> {
  $$AccionTomadaTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get responsable => $composableBuilder(
    column: $table.responsable,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fechaCompromiso => $composableBuilder(
    column: $table.fechaCompromiso,
    builder: (column) => column,
  );

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<String> get notas =>
      $composableBuilder(column: $table.notas, builder: (column) => column);

  GeneratedColumn<String> get fechaRegistro => $composableBuilder(
    column: $table.fechaRegistro,
    builder: (column) => column,
  );

  $$EvaluacionTableTableAnnotationComposer get evaluacionId {
    final $$EvaluacionTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.evaluacionId,
      referencedTable: $db.evaluacionTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EvaluacionTableTableAnnotationComposer(
            $db: $db,
            $table: $db.evaluacionTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccionCatalogoTableTableAnnotationComposer get accionCatalogoId {
    final $$AccionCatalogoTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.accionCatalogoId,
          referencedTable: $db.accionCatalogoTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AccionCatalogoTableTableAnnotationComposer(
                $db: $db,
                $table: $db.accionCatalogoTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> verificacionAccionTableRefs<T extends Object>(
    Expression<T> Function($$VerificacionAccionTableTableAnnotationComposer a)
    f,
  ) {
    final $$VerificacionAccionTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.verificacionAccionTable,
          getReferencedColumn: (t) => t.accionTomadaId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$VerificacionAccionTableTableAnnotationComposer(
                $db: $db,
                $table: $db.verificacionAccionTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$AccionTomadaTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccionTomadaTableTable,
          AccionTomadaTableData,
          $$AccionTomadaTableTableFilterComposer,
          $$AccionTomadaTableTableOrderingComposer,
          $$AccionTomadaTableTableAnnotationComposer,
          $$AccionTomadaTableTableCreateCompanionBuilder,
          $$AccionTomadaTableTableUpdateCompanionBuilder,
          (AccionTomadaTableData, $$AccionTomadaTableTableReferences),
          AccionTomadaTableData,
          PrefetchHooks Function({
            bool evaluacionId,
            bool accionCatalogoId,
            bool verificacionAccionTableRefs,
          })
        > {
  $$AccionTomadaTableTableTableManager(
    _$AppDatabase db,
    $AccionTomadaTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccionTomadaTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccionTomadaTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccionTomadaTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> evaluacionId = const Value.absent(),
                Value<int> accionCatalogoId = const Value.absent(),
                Value<String> responsable = const Value.absent(),
                Value<String> fechaCompromiso = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<String?> notas = const Value.absent(),
                Value<String> fechaRegistro = const Value.absent(),
              }) => AccionTomadaTableCompanion(
                id: id,
                evaluacionId: evaluacionId,
                accionCatalogoId: accionCatalogoId,
                responsable: responsable,
                fechaCompromiso: fechaCompromiso,
                estado: estado,
                notas: notas,
                fechaRegistro: fechaRegistro,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int evaluacionId,
                required int accionCatalogoId,
                required String responsable,
                required String fechaCompromiso,
                Value<String> estado = const Value.absent(),
                Value<String?> notas = const Value.absent(),
                required String fechaRegistro,
              }) => AccionTomadaTableCompanion.insert(
                id: id,
                evaluacionId: evaluacionId,
                accionCatalogoId: accionCatalogoId,
                responsable: responsable,
                fechaCompromiso: fechaCompromiso,
                estado: estado,
                notas: notas,
                fechaRegistro: fechaRegistro,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AccionTomadaTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                evaluacionId = false,
                accionCatalogoId = false,
                verificacionAccionTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (verificacionAccionTableRefs) db.verificacionAccionTable,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (evaluacionId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.evaluacionId,
                            referencedTable: $$AccionTomadaTableTableReferences
                                ._evaluacionIdTable(db),
                            referencedColumn: $$AccionTomadaTableTableReferences
                                ._evaluacionIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (accionCatalogoId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.accionCatalogoId,
                            referencedTable: $$AccionTomadaTableTableReferences
                                ._accionCatalogoIdTable(db),
                            referencedColumn: $$AccionTomadaTableTableReferences
                                ._accionCatalogoIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (verificacionAccionTableRefs)
                        await $_getPrefetchedData<
                          AccionTomadaTableData,
                          $AccionTomadaTableTable,
                          VerificacionAccionTableData
                        >(
                          currentTable: table,
                          referencedTable: $$AccionTomadaTableTableReferences
                              ._verificacionAccionTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccionTomadaTableTableReferences(
                                db,
                                table,
                                p0,
                              ).verificacionAccionTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accionTomadaId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$AccionTomadaTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccionTomadaTableTable,
      AccionTomadaTableData,
      $$AccionTomadaTableTableFilterComposer,
      $$AccionTomadaTableTableOrderingComposer,
      $$AccionTomadaTableTableAnnotationComposer,
      $$AccionTomadaTableTableCreateCompanionBuilder,
      $$AccionTomadaTableTableUpdateCompanionBuilder,
      (AccionTomadaTableData, $$AccionTomadaTableTableReferences),
      AccionTomadaTableData,
      PrefetchHooks Function({
        bool evaluacionId,
        bool accionCatalogoId,
        bool verificacionAccionTableRefs,
      })
    >;
typedef $$VerificacionAccionTableTableCreateCompanionBuilder =
    VerificacionAccionTableCompanion Function({
      Value<int> id,
      required int accionTomadaId,
      required int periodoVerificacionId,
      required String resultado,
      required double valorObservado,
      Value<String?> comentario,
      Value<bool> confirmadoPorUsuario,
    });
typedef $$VerificacionAccionTableTableUpdateCompanionBuilder =
    VerificacionAccionTableCompanion Function({
      Value<int> id,
      Value<int> accionTomadaId,
      Value<int> periodoVerificacionId,
      Value<String> resultado,
      Value<double> valorObservado,
      Value<String?> comentario,
      Value<bool> confirmadoPorUsuario,
    });

final class $$VerificacionAccionTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $VerificacionAccionTableTable,
          VerificacionAccionTableData
        > {
  $$VerificacionAccionTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AccionTomadaTableTable _accionTomadaIdTable(_$AppDatabase db) => db
      .accionTomadaTable
      .createAlias('verificacion_accion__accion_tomada_id__accion_tomada__id');

  $$AccionTomadaTableTableProcessedTableManager get accionTomadaId {
    final $_column = $_itemColumn<int>('accion_tomada_id')!;

    final manager = $$AccionTomadaTableTableTableManager(
      $_db,
      $_db.accionTomadaTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accionTomadaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PeriodoTableTable _periodoVerificacionIdTable(_$AppDatabase db) => db
      .periodoTable
      .createAlias('verificacion_accion__periodo_verificacion_id__periodo__id');

  $$PeriodoTableTableProcessedTableManager get periodoVerificacionId {
    final $_column = $_itemColumn<int>('periodo_verificacion_id')!;

    final manager = $$PeriodoTableTableTableManager(
      $_db,
      $_db.periodoTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _periodoVerificacionIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$VerificacionAccionTableTableFilterComposer
    extends Composer<_$AppDatabase, $VerificacionAccionTableTable> {
  $$VerificacionAccionTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resultado => $composableBuilder(
    column: $table.resultado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get valorObservado => $composableBuilder(
    column: $table.valorObservado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get comentario => $composableBuilder(
    column: $table.comentario,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get confirmadoPorUsuario => $composableBuilder(
    column: $table.confirmadoPorUsuario,
    builder: (column) => ColumnFilters(column),
  );

  $$AccionTomadaTableTableFilterComposer get accionTomadaId {
    final $$AccionTomadaTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accionTomadaId,
      referencedTable: $db.accionTomadaTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccionTomadaTableTableFilterComposer(
            $db: $db,
            $table: $db.accionTomadaTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PeriodoTableTableFilterComposer get periodoVerificacionId {
    final $$PeriodoTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.periodoVerificacionId,
      referencedTable: $db.periodoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeriodoTableTableFilterComposer(
            $db: $db,
            $table: $db.periodoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VerificacionAccionTableTableOrderingComposer
    extends Composer<_$AppDatabase, $VerificacionAccionTableTable> {
  $$VerificacionAccionTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resultado => $composableBuilder(
    column: $table.resultado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get valorObservado => $composableBuilder(
    column: $table.valorObservado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get comentario => $composableBuilder(
    column: $table.comentario,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get confirmadoPorUsuario => $composableBuilder(
    column: $table.confirmadoPorUsuario,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccionTomadaTableTableOrderingComposer get accionTomadaId {
    final $$AccionTomadaTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accionTomadaId,
      referencedTable: $db.accionTomadaTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccionTomadaTableTableOrderingComposer(
            $db: $db,
            $table: $db.accionTomadaTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PeriodoTableTableOrderingComposer get periodoVerificacionId {
    final $$PeriodoTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.periodoVerificacionId,
      referencedTable: $db.periodoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeriodoTableTableOrderingComposer(
            $db: $db,
            $table: $db.periodoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VerificacionAccionTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $VerificacionAccionTableTable> {
  $$VerificacionAccionTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get resultado =>
      $composableBuilder(column: $table.resultado, builder: (column) => column);

  GeneratedColumn<double> get valorObservado => $composableBuilder(
    column: $table.valorObservado,
    builder: (column) => column,
  );

  GeneratedColumn<String> get comentario => $composableBuilder(
    column: $table.comentario,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get confirmadoPorUsuario => $composableBuilder(
    column: $table.confirmadoPorUsuario,
    builder: (column) => column,
  );

  $$AccionTomadaTableTableAnnotationComposer get accionTomadaId {
    final $$AccionTomadaTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.accionTomadaId,
          referencedTable: $db.accionTomadaTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AccionTomadaTableTableAnnotationComposer(
                $db: $db,
                $table: $db.accionTomadaTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$PeriodoTableTableAnnotationComposer get periodoVerificacionId {
    final $$PeriodoTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.periodoVerificacionId,
      referencedTable: $db.periodoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeriodoTableTableAnnotationComposer(
            $db: $db,
            $table: $db.periodoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VerificacionAccionTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VerificacionAccionTableTable,
          VerificacionAccionTableData,
          $$VerificacionAccionTableTableFilterComposer,
          $$VerificacionAccionTableTableOrderingComposer,
          $$VerificacionAccionTableTableAnnotationComposer,
          $$VerificacionAccionTableTableCreateCompanionBuilder,
          $$VerificacionAccionTableTableUpdateCompanionBuilder,
          (
            VerificacionAccionTableData,
            $$VerificacionAccionTableTableReferences,
          ),
          VerificacionAccionTableData,
          PrefetchHooks Function({
            bool accionTomadaId,
            bool periodoVerificacionId,
          })
        > {
  $$VerificacionAccionTableTableTableManager(
    _$AppDatabase db,
    $VerificacionAccionTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VerificacionAccionTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$VerificacionAccionTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$VerificacionAccionTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> accionTomadaId = const Value.absent(),
                Value<int> periodoVerificacionId = const Value.absent(),
                Value<String> resultado = const Value.absent(),
                Value<double> valorObservado = const Value.absent(),
                Value<String?> comentario = const Value.absent(),
                Value<bool> confirmadoPorUsuario = const Value.absent(),
              }) => VerificacionAccionTableCompanion(
                id: id,
                accionTomadaId: accionTomadaId,
                periodoVerificacionId: periodoVerificacionId,
                resultado: resultado,
                valorObservado: valorObservado,
                comentario: comentario,
                confirmadoPorUsuario: confirmadoPorUsuario,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int accionTomadaId,
                required int periodoVerificacionId,
                required String resultado,
                required double valorObservado,
                Value<String?> comentario = const Value.absent(),
                Value<bool> confirmadoPorUsuario = const Value.absent(),
              }) => VerificacionAccionTableCompanion.insert(
                id: id,
                accionTomadaId: accionTomadaId,
                periodoVerificacionId: periodoVerificacionId,
                resultado: resultado,
                valorObservado: valorObservado,
                comentario: comentario,
                confirmadoPorUsuario: confirmadoPorUsuario,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$VerificacionAccionTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({accionTomadaId = false, periodoVerificacionId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (accionTomadaId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.accionTomadaId,
                            referencedTable:
                                $$VerificacionAccionTableTableReferences
                                    ._accionTomadaIdTable(db),
                            referencedColumn:
                                $$VerificacionAccionTableTableReferences
                                    ._accionTomadaIdTable(db)
                                    .id,
                          ) as T;
                        }
                        if (periodoVerificacionId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.periodoVerificacionId,
                            referencedTable:
                                $$VerificacionAccionTableTableReferences
                                    ._periodoVerificacionIdTable(db),
                            referencedColumn:
                                $$VerificacionAccionTableTableReferences
                                    ._periodoVerificacionIdTable(db)
                                    .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$VerificacionAccionTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VerificacionAccionTableTable,
      VerificacionAccionTableData,
      $$VerificacionAccionTableTableFilterComposer,
      $$VerificacionAccionTableTableOrderingComposer,
      $$VerificacionAccionTableTableAnnotationComposer,
      $$VerificacionAccionTableTableCreateCompanionBuilder,
      $$VerificacionAccionTableTableUpdateCompanionBuilder,
      (VerificacionAccionTableData, $$VerificacionAccionTableTableReferences),
      VerificacionAccionTableData,
      PrefetchHooks Function({bool accionTomadaId, bool periodoVerificacionId})
    >;
typedef $$PresupuestoTableTableCreateCompanionBuilder =
    PresupuestoTableCompanion Function({
      Value<int> id,
      required int organizacionId,
      required String rubro,
      required int periodoId,
      required int montoPresupuestadoCent,
      required int montoRealCent,
    });
typedef $$PresupuestoTableTableUpdateCompanionBuilder =
    PresupuestoTableCompanion Function({
      Value<int> id,
      Value<int> organizacionId,
      Value<String> rubro,
      Value<int> periodoId,
      Value<int> montoPresupuestadoCent,
      Value<int> montoRealCent,
    });

final class $$PresupuestoTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PresupuestoTableTable,
          PresupuestoTableData
        > {
  $$PresupuestoTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $OrganizacionTableTable _organizacionIdTable(_$AppDatabase db) => db
      .organizacionTable
      .createAlias('presupuesto__organizacion_id__organizacion__id');

  $$OrganizacionTableTableProcessedTableManager get organizacionId {
    final $_column = $_itemColumn<int>('organizacion_id')!;

    final manager = $$OrganizacionTableTableTableManager(
      $_db,
      $_db.organizacionTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_organizacionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PeriodoTableTable _periodoIdTable(_$AppDatabase db) =>
      db.periodoTable.createAlias('presupuesto__periodo_id__periodo__id');

  $$PeriodoTableTableProcessedTableManager get periodoId {
    final $_column = $_itemColumn<int>('periodo_id')!;

    final manager = $$PeriodoTableTableTableManager(
      $_db,
      $_db.periodoTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_periodoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PresupuestoTableTableFilterComposer
    extends Composer<_$AppDatabase, $PresupuestoTableTable> {
  $$PresupuestoTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rubro => $composableBuilder(
    column: $table.rubro,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get montoPresupuestadoCent => $composableBuilder(
    column: $table.montoPresupuestadoCent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get montoRealCent => $composableBuilder(
    column: $table.montoRealCent,
    builder: (column) => ColumnFilters(column),
  );

  $$OrganizacionTableTableFilterComposer get organizacionId {
    final $$OrganizacionTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organizacionId,
      referencedTable: $db.organizacionTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizacionTableTableFilterComposer(
            $db: $db,
            $table: $db.organizacionTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PeriodoTableTableFilterComposer get periodoId {
    final $$PeriodoTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.periodoId,
      referencedTable: $db.periodoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeriodoTableTableFilterComposer(
            $db: $db,
            $table: $db.periodoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PresupuestoTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PresupuestoTableTable> {
  $$PresupuestoTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rubro => $composableBuilder(
    column: $table.rubro,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get montoPresupuestadoCent => $composableBuilder(
    column: $table.montoPresupuestadoCent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get montoRealCent => $composableBuilder(
    column: $table.montoRealCent,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrganizacionTableTableOrderingComposer get organizacionId {
    final $$OrganizacionTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organizacionId,
      referencedTable: $db.organizacionTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizacionTableTableOrderingComposer(
            $db: $db,
            $table: $db.organizacionTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PeriodoTableTableOrderingComposer get periodoId {
    final $$PeriodoTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.periodoId,
      referencedTable: $db.periodoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeriodoTableTableOrderingComposer(
            $db: $db,
            $table: $db.periodoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PresupuestoTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PresupuestoTableTable> {
  $$PresupuestoTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get rubro =>
      $composableBuilder(column: $table.rubro, builder: (column) => column);

  GeneratedColumn<int> get montoPresupuestadoCent => $composableBuilder(
    column: $table.montoPresupuestadoCent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get montoRealCent => $composableBuilder(
    column: $table.montoRealCent,
    builder: (column) => column,
  );

  $$OrganizacionTableTableAnnotationComposer get organizacionId {
    final $$OrganizacionTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.organizacionId,
          referencedTable: $db.organizacionTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$OrganizacionTableTableAnnotationComposer(
                $db: $db,
                $table: $db.organizacionTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$PeriodoTableTableAnnotationComposer get periodoId {
    final $$PeriodoTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.periodoId,
      referencedTable: $db.periodoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeriodoTableTableAnnotationComposer(
            $db: $db,
            $table: $db.periodoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PresupuestoTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PresupuestoTableTable,
          PresupuestoTableData,
          $$PresupuestoTableTableFilterComposer,
          $$PresupuestoTableTableOrderingComposer,
          $$PresupuestoTableTableAnnotationComposer,
          $$PresupuestoTableTableCreateCompanionBuilder,
          $$PresupuestoTableTableUpdateCompanionBuilder,
          (PresupuestoTableData, $$PresupuestoTableTableReferences),
          PresupuestoTableData,
          PrefetchHooks Function({bool organizacionId, bool periodoId})
        > {
  $$PresupuestoTableTableTableManager(
    _$AppDatabase db,
    $PresupuestoTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PresupuestoTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PresupuestoTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PresupuestoTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> organizacionId = const Value.absent(),
                Value<String> rubro = const Value.absent(),
                Value<int> periodoId = const Value.absent(),
                Value<int> montoPresupuestadoCent = const Value.absent(),
                Value<int> montoRealCent = const Value.absent(),
              }) => PresupuestoTableCompanion(
                id: id,
                organizacionId: organizacionId,
                rubro: rubro,
                periodoId: periodoId,
                montoPresupuestadoCent: montoPresupuestadoCent,
                montoRealCent: montoRealCent,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int organizacionId,
                required String rubro,
                required int periodoId,
                required int montoPresupuestadoCent,
                required int montoRealCent,
              }) => PresupuestoTableCompanion.insert(
                id: id,
                organizacionId: organizacionId,
                rubro: rubro,
                periodoId: periodoId,
                montoPresupuestadoCent: montoPresupuestadoCent,
                montoRealCent: montoRealCent,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PresupuestoTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({organizacionId = false, periodoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (organizacionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.organizacionId,
                        referencedTable: $$PresupuestoTableTableReferences
                            ._organizacionIdTable(db),
                        referencedColumn: $$PresupuestoTableTableReferences
                            ._organizacionIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (periodoId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.periodoId,
                        referencedTable: $$PresupuestoTableTableReferences
                            ._periodoIdTable(db),
                        referencedColumn: $$PresupuestoTableTableReferences
                            ._periodoIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PresupuestoTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PresupuestoTableTable,
      PresupuestoTableData,
      $$PresupuestoTableTableFilterComposer,
      $$PresupuestoTableTableOrderingComposer,
      $$PresupuestoTableTableAnnotationComposer,
      $$PresupuestoTableTableCreateCompanionBuilder,
      $$PresupuestoTableTableUpdateCompanionBuilder,
      (PresupuestoTableData, $$PresupuestoTableTableReferences),
      PresupuestoTableData,
      PrefetchHooks Function({bool organizacionId, bool periodoId})
    >;
typedef $$EscenarioSinteticoTableTableCreateCompanionBuilder =
    EscenarioSinteticoTableCompanion Function({
      Value<int> id,
      required String nombre,
      required int indicadorBaseId,
      required String patron,
      required String parametrosJson,
      required int semilla,
      required int numeroPeriodos,
    });
typedef $$EscenarioSinteticoTableTableUpdateCompanionBuilder =
    EscenarioSinteticoTableCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<int> indicadorBaseId,
      Value<String> patron,
      Value<String> parametrosJson,
      Value<int> semilla,
      Value<int> numeroPeriodos,
    });

final class $$EscenarioSinteticoTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $EscenarioSinteticoTableTable,
          EscenarioSinteticoTableData
        > {
  $$EscenarioSinteticoTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $IndicadorTableTable _indicadorBaseIdTable(_$AppDatabase db) => db
      .indicadorTable
      .createAlias('escenario_sintetico__indicador_base_id__indicador__id');

  $$IndicadorTableTableProcessedTableManager get indicadorBaseId {
    final $_column = $_itemColumn<int>('indicador_base_id')!;

    final manager = $$IndicadorTableTableTableManager(
      $_db,
      $_db.indicadorTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_indicadorBaseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EscenarioSinteticoTableTableFilterComposer
    extends Composer<_$AppDatabase, $EscenarioSinteticoTableTable> {
  $$EscenarioSinteticoTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get patron => $composableBuilder(
    column: $table.patron,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parametrosJson => $composableBuilder(
    column: $table.parametrosJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get semilla => $composableBuilder(
    column: $table.semilla,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get numeroPeriodos => $composableBuilder(
    column: $table.numeroPeriodos,
    builder: (column) => ColumnFilters(column),
  );

  $$IndicadorTableTableFilterComposer get indicadorBaseId {
    final $$IndicadorTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.indicadorBaseId,
      referencedTable: $db.indicadorTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IndicadorTableTableFilterComposer(
            $db: $db,
            $table: $db.indicadorTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EscenarioSinteticoTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EscenarioSinteticoTableTable> {
  $$EscenarioSinteticoTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get patron => $composableBuilder(
    column: $table.patron,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parametrosJson => $composableBuilder(
    column: $table.parametrosJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get semilla => $composableBuilder(
    column: $table.semilla,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get numeroPeriodos => $composableBuilder(
    column: $table.numeroPeriodos,
    builder: (column) => ColumnOrderings(column),
  );

  $$IndicadorTableTableOrderingComposer get indicadorBaseId {
    final $$IndicadorTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.indicadorBaseId,
      referencedTable: $db.indicadorTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IndicadorTableTableOrderingComposer(
            $db: $db,
            $table: $db.indicadorTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EscenarioSinteticoTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EscenarioSinteticoTableTable> {
  $$EscenarioSinteticoTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get patron =>
      $composableBuilder(column: $table.patron, builder: (column) => column);

  GeneratedColumn<String> get parametrosJson => $composableBuilder(
    column: $table.parametrosJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get semilla =>
      $composableBuilder(column: $table.semilla, builder: (column) => column);

  GeneratedColumn<int> get numeroPeriodos => $composableBuilder(
    column: $table.numeroPeriodos,
    builder: (column) => column,
  );

  $$IndicadorTableTableAnnotationComposer get indicadorBaseId {
    final $$IndicadorTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.indicadorBaseId,
      referencedTable: $db.indicadorTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IndicadorTableTableAnnotationComposer(
            $db: $db,
            $table: $db.indicadorTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EscenarioSinteticoTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EscenarioSinteticoTableTable,
          EscenarioSinteticoTableData,
          $$EscenarioSinteticoTableTableFilterComposer,
          $$EscenarioSinteticoTableTableOrderingComposer,
          $$EscenarioSinteticoTableTableAnnotationComposer,
          $$EscenarioSinteticoTableTableCreateCompanionBuilder,
          $$EscenarioSinteticoTableTableUpdateCompanionBuilder,
          (
            EscenarioSinteticoTableData,
            $$EscenarioSinteticoTableTableReferences,
          ),
          EscenarioSinteticoTableData,
          PrefetchHooks Function({bool indicadorBaseId})
        > {
  $$EscenarioSinteticoTableTableTableManager(
    _$AppDatabase db,
    $EscenarioSinteticoTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EscenarioSinteticoTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$EscenarioSinteticoTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$EscenarioSinteticoTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<int> indicadorBaseId = const Value.absent(),
                Value<String> patron = const Value.absent(),
                Value<String> parametrosJson = const Value.absent(),
                Value<int> semilla = const Value.absent(),
                Value<int> numeroPeriodos = const Value.absent(),
              }) => EscenarioSinteticoTableCompanion(
                id: id,
                nombre: nombre,
                indicadorBaseId: indicadorBaseId,
                patron: patron,
                parametrosJson: parametrosJson,
                semilla: semilla,
                numeroPeriodos: numeroPeriodos,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                required int indicadorBaseId,
                required String patron,
                required String parametrosJson,
                required int semilla,
                required int numeroPeriodos,
              }) => EscenarioSinteticoTableCompanion.insert(
                id: id,
                nombre: nombre,
                indicadorBaseId: indicadorBaseId,
                patron: patron,
                parametrosJson: parametrosJson,
                semilla: semilla,
                numeroPeriodos: numeroPeriodos,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EscenarioSinteticoTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({indicadorBaseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (indicadorBaseId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.indicadorBaseId,
                        referencedTable:
                            $$EscenarioSinteticoTableTableReferences
                                ._indicadorBaseIdTable(db),
                        referencedColumn:
                            $$EscenarioSinteticoTableTableReferences
                                ._indicadorBaseIdTable(db)
                                .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$EscenarioSinteticoTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EscenarioSinteticoTableTable,
      EscenarioSinteticoTableData,
      $$EscenarioSinteticoTableTableFilterComposer,
      $$EscenarioSinteticoTableTableOrderingComposer,
      $$EscenarioSinteticoTableTableAnnotationComposer,
      $$EscenarioSinteticoTableTableCreateCompanionBuilder,
      $$EscenarioSinteticoTableTableUpdateCompanionBuilder,
      (EscenarioSinteticoTableData, $$EscenarioSinteticoTableTableReferences),
      EscenarioSinteticoTableData,
      PrefetchHooks Function({bool indicadorBaseId})
    >;
typedef $$DiagnosticoOrganizacionalTableTableCreateCompanionBuilder =
    DiagnosticoOrganizacionalTableCompanion Function({
      Value<int> id,
      required int organizacionId,
      required String fecha,
      required String respuestasJson,
      required String etapaResultante,
      required String opcionOrganizacional,
      required String ejesJson,
      required String orientacionDominante,
    });
typedef $$DiagnosticoOrganizacionalTableTableUpdateCompanionBuilder =
    DiagnosticoOrganizacionalTableCompanion Function({
      Value<int> id,
      Value<int> organizacionId,
      Value<String> fecha,
      Value<String> respuestasJson,
      Value<String> etapaResultante,
      Value<String> opcionOrganizacional,
      Value<String> ejesJson,
      Value<String> orientacionDominante,
    });

final class $$DiagnosticoOrganizacionalTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $DiagnosticoOrganizacionalTableTable,
          DiagnosticoOrganizacionalTableData
        > {
  $$DiagnosticoOrganizacionalTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $OrganizacionTableTable _organizacionIdTable(_$AppDatabase db) =>
      db.organizacionTable.createAlias(
        'diagnostico_organizacional__organizacion_id__organizacion__id',
      );

  $$OrganizacionTableTableProcessedTableManager get organizacionId {
    final $_column = $_itemColumn<int>('organizacion_id')!;

    final manager = $$OrganizacionTableTableTableManager(
      $_db,
      $_db.organizacionTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_organizacionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DiagnosticoOrganizacionalTableTableFilterComposer
    extends Composer<_$AppDatabase, $DiagnosticoOrganizacionalTableTable> {
  $$DiagnosticoOrganizacionalTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get respuestasJson => $composableBuilder(
    column: $table.respuestasJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get etapaResultante => $composableBuilder(
    column: $table.etapaResultante,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get opcionOrganizacional => $composableBuilder(
    column: $table.opcionOrganizacional,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ejesJson => $composableBuilder(
    column: $table.ejesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orientacionDominante => $composableBuilder(
    column: $table.orientacionDominante,
    builder: (column) => ColumnFilters(column),
  );

  $$OrganizacionTableTableFilterComposer get organizacionId {
    final $$OrganizacionTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organizacionId,
      referencedTable: $db.organizacionTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizacionTableTableFilterComposer(
            $db: $db,
            $table: $db.organizacionTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DiagnosticoOrganizacionalTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DiagnosticoOrganizacionalTableTable> {
  $$DiagnosticoOrganizacionalTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get respuestasJson => $composableBuilder(
    column: $table.respuestasJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get etapaResultante => $composableBuilder(
    column: $table.etapaResultante,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get opcionOrganizacional => $composableBuilder(
    column: $table.opcionOrganizacional,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ejesJson => $composableBuilder(
    column: $table.ejesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orientacionDominante => $composableBuilder(
    column: $table.orientacionDominante,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrganizacionTableTableOrderingComposer get organizacionId {
    final $$OrganizacionTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organizacionId,
      referencedTable: $db.organizacionTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizacionTableTableOrderingComposer(
            $db: $db,
            $table: $db.organizacionTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DiagnosticoOrganizacionalTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiagnosticoOrganizacionalTableTable> {
  $$DiagnosticoOrganizacionalTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<String> get respuestasJson => $composableBuilder(
    column: $table.respuestasJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get etapaResultante => $composableBuilder(
    column: $table.etapaResultante,
    builder: (column) => column,
  );

  GeneratedColumn<String> get opcionOrganizacional => $composableBuilder(
    column: $table.opcionOrganizacional,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ejesJson =>
      $composableBuilder(column: $table.ejesJson, builder: (column) => column);

  GeneratedColumn<String> get orientacionDominante => $composableBuilder(
    column: $table.orientacionDominante,
    builder: (column) => column,
  );

  $$OrganizacionTableTableAnnotationComposer get organizacionId {
    final $$OrganizacionTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.organizacionId,
          referencedTable: $db.organizacionTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$OrganizacionTableTableAnnotationComposer(
                $db: $db,
                $table: $db.organizacionTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$DiagnosticoOrganizacionalTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DiagnosticoOrganizacionalTableTable,
          DiagnosticoOrganizacionalTableData,
          $$DiagnosticoOrganizacionalTableTableFilterComposer,
          $$DiagnosticoOrganizacionalTableTableOrderingComposer,
          $$DiagnosticoOrganizacionalTableTableAnnotationComposer,
          $$DiagnosticoOrganizacionalTableTableCreateCompanionBuilder,
          $$DiagnosticoOrganizacionalTableTableUpdateCompanionBuilder,
          (
            DiagnosticoOrganizacionalTableData,
            $$DiagnosticoOrganizacionalTableTableReferences,
          ),
          DiagnosticoOrganizacionalTableData,
          PrefetchHooks Function({bool organizacionId})
        > {
  $$DiagnosticoOrganizacionalTableTableTableManager(
    _$AppDatabase db,
    $DiagnosticoOrganizacionalTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiagnosticoOrganizacionalTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$DiagnosticoOrganizacionalTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DiagnosticoOrganizacionalTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> organizacionId = const Value.absent(),
                Value<String> fecha = const Value.absent(),
                Value<String> respuestasJson = const Value.absent(),
                Value<String> etapaResultante = const Value.absent(),
                Value<String> opcionOrganizacional = const Value.absent(),
                Value<String> ejesJson = const Value.absent(),
                Value<String> orientacionDominante = const Value.absent(),
              }) => DiagnosticoOrganizacionalTableCompanion(
                id: id,
                organizacionId: organizacionId,
                fecha: fecha,
                respuestasJson: respuestasJson,
                etapaResultante: etapaResultante,
                opcionOrganizacional: opcionOrganizacional,
                ejesJson: ejesJson,
                orientacionDominante: orientacionDominante,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int organizacionId,
                required String fecha,
                required String respuestasJson,
                required String etapaResultante,
                required String opcionOrganizacional,
                required String ejesJson,
                required String orientacionDominante,
              }) => DiagnosticoOrganizacionalTableCompanion.insert(
                id: id,
                organizacionId: organizacionId,
                fecha: fecha,
                respuestasJson: respuestasJson,
                etapaResultante: etapaResultante,
                opcionOrganizacional: opcionOrganizacional,
                ejesJson: ejesJson,
                orientacionDominante: orientacionDominante,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DiagnosticoOrganizacionalTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({organizacionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (organizacionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.organizacionId,
                        referencedTable:
                            $$DiagnosticoOrganizacionalTableTableReferences
                                ._organizacionIdTable(db),
                        referencedColumn:
                            $$DiagnosticoOrganizacionalTableTableReferences
                                ._organizacionIdTable(db)
                                .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DiagnosticoOrganizacionalTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DiagnosticoOrganizacionalTableTable,
      DiagnosticoOrganizacionalTableData,
      $$DiagnosticoOrganizacionalTableTableFilterComposer,
      $$DiagnosticoOrganizacionalTableTableOrderingComposer,
      $$DiagnosticoOrganizacionalTableTableAnnotationComposer,
      $$DiagnosticoOrganizacionalTableTableCreateCompanionBuilder,
      $$DiagnosticoOrganizacionalTableTableUpdateCompanionBuilder,
      (
        DiagnosticoOrganizacionalTableData,
        $$DiagnosticoOrganizacionalTableTableReferences,
      ),
      DiagnosticoOrganizacionalTableData,
      PrefetchHooks Function({bool organizacionId})
    >;
typedef $$FacturaTransporteTableTableCreateCompanionBuilder =
    FacturaTransporteTableCompanion Function({
      Value<int> id,
      required int organizacionId,
      required String numero,
      required String transportista,
      required double peso,
      required String ruta,
      required int tarifaAplicadaCent,
      required int tarifaContratadaCent,
      Value<String?> discrepanciaTipo,
      Value<int> montoRecuperableCent,
      Value<String> estado,
    });
typedef $$FacturaTransporteTableTableUpdateCompanionBuilder =
    FacturaTransporteTableCompanion Function({
      Value<int> id,
      Value<int> organizacionId,
      Value<String> numero,
      Value<String> transportista,
      Value<double> peso,
      Value<String> ruta,
      Value<int> tarifaAplicadaCent,
      Value<int> tarifaContratadaCent,
      Value<String?> discrepanciaTipo,
      Value<int> montoRecuperableCent,
      Value<String> estado,
    });

final class $$FacturaTransporteTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $FacturaTransporteTableTable,
          FacturaTransporteTableData
        > {
  $$FacturaTransporteTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $OrganizacionTableTable _organizacionIdTable(_$AppDatabase db) => db
      .organizacionTable
      .createAlias('factura_transporte__organizacion_id__organizacion__id');

  $$OrganizacionTableTableProcessedTableManager get organizacionId {
    final $_column = $_itemColumn<int>('organizacion_id')!;

    final manager = $$OrganizacionTableTableTableManager(
      $_db,
      $_db.organizacionTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_organizacionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FacturaTransporteTableTableFilterComposer
    extends Composer<_$AppDatabase, $FacturaTransporteTableTable> {
  $$FacturaTransporteTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get numero => $composableBuilder(
    column: $table.numero,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transportista => $composableBuilder(
    column: $table.transportista,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get peso => $composableBuilder(
    column: $table.peso,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ruta => $composableBuilder(
    column: $table.ruta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tarifaAplicadaCent => $composableBuilder(
    column: $table.tarifaAplicadaCent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tarifaContratadaCent => $composableBuilder(
    column: $table.tarifaContratadaCent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get discrepanciaTipo => $composableBuilder(
    column: $table.discrepanciaTipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get montoRecuperableCent => $composableBuilder(
    column: $table.montoRecuperableCent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  $$OrganizacionTableTableFilterComposer get organizacionId {
    final $$OrganizacionTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organizacionId,
      referencedTable: $db.organizacionTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizacionTableTableFilterComposer(
            $db: $db,
            $table: $db.organizacionTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FacturaTransporteTableTableOrderingComposer
    extends Composer<_$AppDatabase, $FacturaTransporteTableTable> {
  $$FacturaTransporteTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get numero => $composableBuilder(
    column: $table.numero,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transportista => $composableBuilder(
    column: $table.transportista,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get peso => $composableBuilder(
    column: $table.peso,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ruta => $composableBuilder(
    column: $table.ruta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tarifaAplicadaCent => $composableBuilder(
    column: $table.tarifaAplicadaCent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tarifaContratadaCent => $composableBuilder(
    column: $table.tarifaContratadaCent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get discrepanciaTipo => $composableBuilder(
    column: $table.discrepanciaTipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get montoRecuperableCent => $composableBuilder(
    column: $table.montoRecuperableCent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrganizacionTableTableOrderingComposer get organizacionId {
    final $$OrganizacionTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organizacionId,
      referencedTable: $db.organizacionTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizacionTableTableOrderingComposer(
            $db: $db,
            $table: $db.organizacionTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FacturaTransporteTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $FacturaTransporteTableTable> {
  $$FacturaTransporteTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get numero =>
      $composableBuilder(column: $table.numero, builder: (column) => column);

  GeneratedColumn<String> get transportista => $composableBuilder(
    column: $table.transportista,
    builder: (column) => column,
  );

  GeneratedColumn<double> get peso =>
      $composableBuilder(column: $table.peso, builder: (column) => column);

  GeneratedColumn<String> get ruta =>
      $composableBuilder(column: $table.ruta, builder: (column) => column);

  GeneratedColumn<int> get tarifaAplicadaCent => $composableBuilder(
    column: $table.tarifaAplicadaCent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tarifaContratadaCent => $composableBuilder(
    column: $table.tarifaContratadaCent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get discrepanciaTipo => $composableBuilder(
    column: $table.discrepanciaTipo,
    builder: (column) => column,
  );

  GeneratedColumn<int> get montoRecuperableCent => $composableBuilder(
    column: $table.montoRecuperableCent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  $$OrganizacionTableTableAnnotationComposer get organizacionId {
    final $$OrganizacionTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.organizacionId,
          referencedTable: $db.organizacionTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$OrganizacionTableTableAnnotationComposer(
                $db: $db,
                $table: $db.organizacionTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$FacturaTransporteTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FacturaTransporteTableTable,
          FacturaTransporteTableData,
          $$FacturaTransporteTableTableFilterComposer,
          $$FacturaTransporteTableTableOrderingComposer,
          $$FacturaTransporteTableTableAnnotationComposer,
          $$FacturaTransporteTableTableCreateCompanionBuilder,
          $$FacturaTransporteTableTableUpdateCompanionBuilder,
          (FacturaTransporteTableData, $$FacturaTransporteTableTableReferences),
          FacturaTransporteTableData,
          PrefetchHooks Function({bool organizacionId})
        > {
  $$FacturaTransporteTableTableTableManager(
    _$AppDatabase db,
    $FacturaTransporteTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FacturaTransporteTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$FacturaTransporteTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$FacturaTransporteTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> organizacionId = const Value.absent(),
                Value<String> numero = const Value.absent(),
                Value<String> transportista = const Value.absent(),
                Value<double> peso = const Value.absent(),
                Value<String> ruta = const Value.absent(),
                Value<int> tarifaAplicadaCent = const Value.absent(),
                Value<int> tarifaContratadaCent = const Value.absent(),
                Value<String?> discrepanciaTipo = const Value.absent(),
                Value<int> montoRecuperableCent = const Value.absent(),
                Value<String> estado = const Value.absent(),
              }) => FacturaTransporteTableCompanion(
                id: id,
                organizacionId: organizacionId,
                numero: numero,
                transportista: transportista,
                peso: peso,
                ruta: ruta,
                tarifaAplicadaCent: tarifaAplicadaCent,
                tarifaContratadaCent: tarifaContratadaCent,
                discrepanciaTipo: discrepanciaTipo,
                montoRecuperableCent: montoRecuperableCent,
                estado: estado,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int organizacionId,
                required String numero,
                required String transportista,
                required double peso,
                required String ruta,
                required int tarifaAplicadaCent,
                required int tarifaContratadaCent,
                Value<String?> discrepanciaTipo = const Value.absent(),
                Value<int> montoRecuperableCent = const Value.absent(),
                Value<String> estado = const Value.absent(),
              }) => FacturaTransporteTableCompanion.insert(
                id: id,
                organizacionId: organizacionId,
                numero: numero,
                transportista: transportista,
                peso: peso,
                ruta: ruta,
                tarifaAplicadaCent: tarifaAplicadaCent,
                tarifaContratadaCent: tarifaContratadaCent,
                discrepanciaTipo: discrepanciaTipo,
                montoRecuperableCent: montoRecuperableCent,
                estado: estado,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FacturaTransporteTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({organizacionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (organizacionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.organizacionId,
                        referencedTable: $$FacturaTransporteTableTableReferences
                            ._organizacionIdTable(db),
                        referencedColumn:
                            $$FacturaTransporteTableTableReferences
                                ._organizacionIdTable(db)
                                .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FacturaTransporteTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FacturaTransporteTableTable,
      FacturaTransporteTableData,
      $$FacturaTransporteTableTableFilterComposer,
      $$FacturaTransporteTableTableOrderingComposer,
      $$FacturaTransporteTableTableAnnotationComposer,
      $$FacturaTransporteTableTableCreateCompanionBuilder,
      $$FacturaTransporteTableTableUpdateCompanionBuilder,
      (FacturaTransporteTableData, $$FacturaTransporteTableTableReferences),
      FacturaTransporteTableData,
      PrefetchHooks Function({bool organizacionId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$OrganizacionTableTableTableManager get organizacionTable =>
      $$OrganizacionTableTableTableManager(_db, _db.organizacionTable);
  $$PeriodoTableTableTableManager get periodoTable =>
      $$PeriodoTableTableTableManager(_db, _db.periodoTable);
  $$IndicadorTableTableTableManager get indicadorTable =>
      $$IndicadorTableTableTableManager(_db, _db.indicadorTable);
  $$MedicionTableTableTableManager get medicionTable =>
      $$MedicionTableTableTableManager(_db, _db.medicionTable);
  $$ReglaPatronTableTableTableManager get reglaPatronTable =>
      $$ReglaPatronTableTableTableManager(_db, _db.reglaPatronTable);
  $$EvaluacionTableTableTableManager get evaluacionTable =>
      $$EvaluacionTableTableTableManager(_db, _db.evaluacionTable);
  $$MemoriaEvaluacionTableTableTableManager get memoriaEvaluacionTable =>
      $$MemoriaEvaluacionTableTableTableManager(
        _db,
        _db.memoriaEvaluacionTable,
      );
  $$AccionCatalogoTableTableTableManager get accionCatalogoTable =>
      $$AccionCatalogoTableTableTableManager(_db, _db.accionCatalogoTable);
  $$ReglaAccionTableTableTableManager get reglaAccionTable =>
      $$ReglaAccionTableTableTableManager(_db, _db.reglaAccionTable);
  $$AccionTomadaTableTableTableManager get accionTomadaTable =>
      $$AccionTomadaTableTableTableManager(_db, _db.accionTomadaTable);
  $$VerificacionAccionTableTableTableManager get verificacionAccionTable =>
      $$VerificacionAccionTableTableTableManager(
        _db,
        _db.verificacionAccionTable,
      );
  $$PresupuestoTableTableTableManager get presupuestoTable =>
      $$PresupuestoTableTableTableManager(_db, _db.presupuestoTable);
  $$EscenarioSinteticoTableTableTableManager get escenarioSinteticoTable =>
      $$EscenarioSinteticoTableTableTableManager(
        _db,
        _db.escenarioSinteticoTable,
      );
  $$DiagnosticoOrganizacionalTableTableTableManager
  get diagnosticoOrganizacionalTable =>
      $$DiagnosticoOrganizacionalTableTableTableManager(
        _db,
        _db.diagnosticoOrganizacionalTable,
      );
  $$FacturaTransporteTableTableTableManager get facturaTransporteTable =>
      $$FacturaTransporteTableTableTableManager(
        _db,
        _db.facturaTransporteTable,
      );
}
