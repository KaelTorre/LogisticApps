// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ProyectoTableTable extends ProyectoTable
    with TableInfo<$ProyectoTableTable, ProyectoTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProyectoTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _unidadPesoMeta = const VerificationMeta(
    'unidadPeso',
  );
  @override
  late final GeneratedColumn<String> unidadPeso = GeneratedColumn<String>(
    'unidad_peso',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('toneladas'),
  );
  static const VerificationMeta _horizonteAniosMeta = const VerificationMeta(
    'horizonteAnios',
  );
  @override
  late final GeneratedColumn<int> horizonteAnios = GeneratedColumn<int>(
    'horizonte_anios',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5),
  );
  static const VerificationMeta _factorCircuidadMeta = const VerificationMeta(
    'factorCircuidad',
  );
  @override
  late final GeneratedColumn<double> factorCircuidad = GeneratedColumn<double>(
    'factor_circuidad',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.30),
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<String> creadoEn = GeneratedColumn<String>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    moneda,
    unidadPeso,
    horizonteAnios,
    factorCircuidad,
    creadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'proyecto';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProyectoTableData> instance, {
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
    if (data.containsKey('unidad_peso')) {
      context.handle(
        _unidadPesoMeta,
        unidadPeso.isAcceptableOrUnknown(data['unidad_peso']!, _unidadPesoMeta),
      );
    }
    if (data.containsKey('horizonte_anios')) {
      context.handle(
        _horizonteAniosMeta,
        horizonteAnios.isAcceptableOrUnknown(
          data['horizonte_anios']!,
          _horizonteAniosMeta,
        ),
      );
    }
    if (data.containsKey('factor_circuidad')) {
      context.handle(
        _factorCircuidadMeta,
        factorCircuidad.isAcceptableOrUnknown(
          data['factor_circuidad']!,
          _factorCircuidadMeta,
        ),
      );
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    } else if (isInserting) {
      context.missing(_creadoEnMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProyectoTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProyectoTableData(
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
      unidadPeso: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unidad_peso'],
      )!,
      horizonteAnios: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}horizonte_anios'],
      )!,
      factorCircuidad: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}factor_circuidad'],
      )!,
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}creado_en'],
      )!,
    );
  }

  @override
  $ProyectoTableTable createAlias(String alias) {
    return $ProyectoTableTable(attachedDatabase, alias);
  }
}

class ProyectoTableData extends DataClass
    implements Insertable<ProyectoTableData> {
  final int id;
  final String nombre;
  final String moneda;
  final String unidadPeso;
  final int horizonteAnios;
  final double factorCircuidad;
  final String creadoEn;
  const ProyectoTableData({
    required this.id,
    required this.nombre,
    required this.moneda,
    required this.unidadPeso,
    required this.horizonteAnios,
    required this.factorCircuidad,
    required this.creadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['moneda'] = Variable<String>(moneda);
    map['unidad_peso'] = Variable<String>(unidadPeso);
    map['horizonte_anios'] = Variable<int>(horizonteAnios);
    map['factor_circuidad'] = Variable<double>(factorCircuidad);
    map['creado_en'] = Variable<String>(creadoEn);
    return map;
  }

  ProyectoTableCompanion toCompanion(bool nullToAbsent) {
    return ProyectoTableCompanion(
      id: Value(id),
      nombre: Value(nombre),
      moneda: Value(moneda),
      unidadPeso: Value(unidadPeso),
      horizonteAnios: Value(horizonteAnios),
      factorCircuidad: Value(factorCircuidad),
      creadoEn: Value(creadoEn),
    );
  }

  factory ProyectoTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProyectoTableData(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      moneda: serializer.fromJson<String>(json['moneda']),
      unidadPeso: serializer.fromJson<String>(json['unidadPeso']),
      horizonteAnios: serializer.fromJson<int>(json['horizonteAnios']),
      factorCircuidad: serializer.fromJson<double>(json['factorCircuidad']),
      creadoEn: serializer.fromJson<String>(json['creadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'moneda': serializer.toJson<String>(moneda),
      'unidadPeso': serializer.toJson<String>(unidadPeso),
      'horizonteAnios': serializer.toJson<int>(horizonteAnios),
      'factorCircuidad': serializer.toJson<double>(factorCircuidad),
      'creadoEn': serializer.toJson<String>(creadoEn),
    };
  }

  ProyectoTableData copyWith({
    int? id,
    String? nombre,
    String? moneda,
    String? unidadPeso,
    int? horizonteAnios,
    double? factorCircuidad,
    String? creadoEn,
  }) => ProyectoTableData(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    moneda: moneda ?? this.moneda,
    unidadPeso: unidadPeso ?? this.unidadPeso,
    horizonteAnios: horizonteAnios ?? this.horizonteAnios,
    factorCircuidad: factorCircuidad ?? this.factorCircuidad,
    creadoEn: creadoEn ?? this.creadoEn,
  );
  ProyectoTableData copyWithCompanion(ProyectoTableCompanion data) {
    return ProyectoTableData(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      moneda: data.moneda.present ? data.moneda.value : this.moneda,
      unidadPeso: data.unidadPeso.present
          ? data.unidadPeso.value
          : this.unidadPeso,
      horizonteAnios: data.horizonteAnios.present
          ? data.horizonteAnios.value
          : this.horizonteAnios,
      factorCircuidad: data.factorCircuidad.present
          ? data.factorCircuidad.value
          : this.factorCircuidad,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProyectoTableData(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('moneda: $moneda, ')
          ..write('unidadPeso: $unidadPeso, ')
          ..write('horizonteAnios: $horizonteAnios, ')
          ..write('factorCircuidad: $factorCircuidad, ')
          ..write('creadoEn: $creadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    moneda,
    unidadPeso,
    horizonteAnios,
    factorCircuidad,
    creadoEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProyectoTableData &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.moneda == this.moneda &&
          other.unidadPeso == this.unidadPeso &&
          other.horizonteAnios == this.horizonteAnios &&
          other.factorCircuidad == this.factorCircuidad &&
          other.creadoEn == this.creadoEn);
}

class ProyectoTableCompanion extends UpdateCompanion<ProyectoTableData> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String> moneda;
  final Value<String> unidadPeso;
  final Value<int> horizonteAnios;
  final Value<double> factorCircuidad;
  final Value<String> creadoEn;
  const ProyectoTableCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.moneda = const Value.absent(),
    this.unidadPeso = const Value.absent(),
    this.horizonteAnios = const Value.absent(),
    this.factorCircuidad = const Value.absent(),
    this.creadoEn = const Value.absent(),
  });
  ProyectoTableCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    this.moneda = const Value.absent(),
    this.unidadPeso = const Value.absent(),
    this.horizonteAnios = const Value.absent(),
    this.factorCircuidad = const Value.absent(),
    required String creadoEn,
  }) : nombre = Value(nombre),
       creadoEn = Value(creadoEn);
  static Insertable<ProyectoTableData> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? moneda,
    Expression<String>? unidadPeso,
    Expression<int>? horizonteAnios,
    Expression<double>? factorCircuidad,
    Expression<String>? creadoEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (moneda != null) 'moneda': moneda,
      if (unidadPeso != null) 'unidad_peso': unidadPeso,
      if (horizonteAnios != null) 'horizonte_anios': horizonteAnios,
      if (factorCircuidad != null) 'factor_circuidad': factorCircuidad,
      if (creadoEn != null) 'creado_en': creadoEn,
    });
  }

  ProyectoTableCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<String>? moneda,
    Value<String>? unidadPeso,
    Value<int>? horizonteAnios,
    Value<double>? factorCircuidad,
    Value<String>? creadoEn,
  }) {
    return ProyectoTableCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      moneda: moneda ?? this.moneda,
      unidadPeso: unidadPeso ?? this.unidadPeso,
      horizonteAnios: horizonteAnios ?? this.horizonteAnios,
      factorCircuidad: factorCircuidad ?? this.factorCircuidad,
      creadoEn: creadoEn ?? this.creadoEn,
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
    if (unidadPeso.present) {
      map['unidad_peso'] = Variable<String>(unidadPeso.value);
    }
    if (horizonteAnios.present) {
      map['horizonte_anios'] = Variable<int>(horizonteAnios.value);
    }
    if (factorCircuidad.present) {
      map['factor_circuidad'] = Variable<double>(factorCircuidad.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<String>(creadoEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProyectoTableCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('moneda: $moneda, ')
          ..write('unidadPeso: $unidadPeso, ')
          ..write('horizonteAnios: $horizonteAnios, ')
          ..write('factorCircuidad: $factorCircuidad, ')
          ..write('creadoEn: $creadoEn')
          ..write(')'))
        .toString();
  }
}

class $ClienteTableTable extends ClienteTable
    with TableInfo<$ClienteTableTable, ClienteTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClienteTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _proyectoIdMeta = const VerificationMeta(
    'proyectoId',
  );
  @override
  late final GeneratedColumn<int> proyectoId = GeneratedColumn<int>(
    'proyecto_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES proyecto (id) ON DELETE CASCADE',
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
  static const VerificationMeta _latitudMeta = const VerificationMeta(
    'latitud',
  );
  @override
  late final GeneratedColumn<double> latitud = GeneratedColumn<double>(
    'latitud',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudMeta = const VerificationMeta(
    'longitud',
  );
  @override
  late final GeneratedColumn<double> longitud = GeneratedColumn<double>(
    'longitud',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _demandaAnualMeta = const VerificationMeta(
    'demandaAnual',
  );
  @override
  late final GeneratedColumn<double> demandaAnual = GeneratedColumn<double>(
    'demanda_anual',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pedidosAnualesMeta = const VerificationMeta(
    'pedidosAnuales',
  );
  @override
  late final GeneratedColumn<int> pedidosAnuales = GeneratedColumn<int>(
    'pedidos_anuales',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
    proyectoId,
    nombre,
    latitud,
    longitud,
    demandaAnual,
    pedidosAnuales,
    activo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cliente';
  @override
  VerificationContext validateIntegrity(
    Insertable<ClienteTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('proyecto_id')) {
      context.handle(
        _proyectoIdMeta,
        proyectoId.isAcceptableOrUnknown(data['proyecto_id']!, _proyectoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_proyectoIdMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('latitud')) {
      context.handle(
        _latitudMeta,
        latitud.isAcceptableOrUnknown(data['latitud']!, _latitudMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudMeta);
    }
    if (data.containsKey('longitud')) {
      context.handle(
        _longitudMeta,
        longitud.isAcceptableOrUnknown(data['longitud']!, _longitudMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudMeta);
    }
    if (data.containsKey('demanda_anual')) {
      context.handle(
        _demandaAnualMeta,
        demandaAnual.isAcceptableOrUnknown(
          data['demanda_anual']!,
          _demandaAnualMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_demandaAnualMeta);
    }
    if (data.containsKey('pedidos_anuales')) {
      context.handle(
        _pedidosAnualesMeta,
        pedidosAnuales.isAcceptableOrUnknown(
          data['pedidos_anuales']!,
          _pedidosAnualesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pedidosAnualesMeta);
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
  ClienteTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClienteTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      proyectoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}proyecto_id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      latitud: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitud'],
      )!,
      longitud: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitud'],
      )!,
      demandaAnual: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}demanda_anual'],
      )!,
      pedidosAnuales: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pedidos_anuales'],
      )!,
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
    );
  }

  @override
  $ClienteTableTable createAlias(String alias) {
    return $ClienteTableTable(attachedDatabase, alias);
  }
}

class ClienteTableData extends DataClass
    implements Insertable<ClienteTableData> {
  final int id;
  final int proyectoId;
  final String nombre;
  final double latitud;
  final double longitud;
  final double demandaAnual;
  final int pedidosAnuales;
  final bool activo;
  const ClienteTableData({
    required this.id,
    required this.proyectoId,
    required this.nombre,
    required this.latitud,
    required this.longitud,
    required this.demandaAnual,
    required this.pedidosAnuales,
    required this.activo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['proyecto_id'] = Variable<int>(proyectoId);
    map['nombre'] = Variable<String>(nombre);
    map['latitud'] = Variable<double>(latitud);
    map['longitud'] = Variable<double>(longitud);
    map['demanda_anual'] = Variable<double>(demandaAnual);
    map['pedidos_anuales'] = Variable<int>(pedidosAnuales);
    map['activo'] = Variable<bool>(activo);
    return map;
  }

  ClienteTableCompanion toCompanion(bool nullToAbsent) {
    return ClienteTableCompanion(
      id: Value(id),
      proyectoId: Value(proyectoId),
      nombre: Value(nombre),
      latitud: Value(latitud),
      longitud: Value(longitud),
      demandaAnual: Value(demandaAnual),
      pedidosAnuales: Value(pedidosAnuales),
      activo: Value(activo),
    );
  }

  factory ClienteTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClienteTableData(
      id: serializer.fromJson<int>(json['id']),
      proyectoId: serializer.fromJson<int>(json['proyectoId']),
      nombre: serializer.fromJson<String>(json['nombre']),
      latitud: serializer.fromJson<double>(json['latitud']),
      longitud: serializer.fromJson<double>(json['longitud']),
      demandaAnual: serializer.fromJson<double>(json['demandaAnual']),
      pedidosAnuales: serializer.fromJson<int>(json['pedidosAnuales']),
      activo: serializer.fromJson<bool>(json['activo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'proyectoId': serializer.toJson<int>(proyectoId),
      'nombre': serializer.toJson<String>(nombre),
      'latitud': serializer.toJson<double>(latitud),
      'longitud': serializer.toJson<double>(longitud),
      'demandaAnual': serializer.toJson<double>(demandaAnual),
      'pedidosAnuales': serializer.toJson<int>(pedidosAnuales),
      'activo': serializer.toJson<bool>(activo),
    };
  }

  ClienteTableData copyWith({
    int? id,
    int? proyectoId,
    String? nombre,
    double? latitud,
    double? longitud,
    double? demandaAnual,
    int? pedidosAnuales,
    bool? activo,
  }) => ClienteTableData(
    id: id ?? this.id,
    proyectoId: proyectoId ?? this.proyectoId,
    nombre: nombre ?? this.nombre,
    latitud: latitud ?? this.latitud,
    longitud: longitud ?? this.longitud,
    demandaAnual: demandaAnual ?? this.demandaAnual,
    pedidosAnuales: pedidosAnuales ?? this.pedidosAnuales,
    activo: activo ?? this.activo,
  );
  ClienteTableData copyWithCompanion(ClienteTableCompanion data) {
    return ClienteTableData(
      id: data.id.present ? data.id.value : this.id,
      proyectoId: data.proyectoId.present
          ? data.proyectoId.value
          : this.proyectoId,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      latitud: data.latitud.present ? data.latitud.value : this.latitud,
      longitud: data.longitud.present ? data.longitud.value : this.longitud,
      demandaAnual: data.demandaAnual.present
          ? data.demandaAnual.value
          : this.demandaAnual,
      pedidosAnuales: data.pedidosAnuales.present
          ? data.pedidosAnuales.value
          : this.pedidosAnuales,
      activo: data.activo.present ? data.activo.value : this.activo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClienteTableData(')
          ..write('id: $id, ')
          ..write('proyectoId: $proyectoId, ')
          ..write('nombre: $nombre, ')
          ..write('latitud: $latitud, ')
          ..write('longitud: $longitud, ')
          ..write('demandaAnual: $demandaAnual, ')
          ..write('pedidosAnuales: $pedidosAnuales, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    proyectoId,
    nombre,
    latitud,
    longitud,
    demandaAnual,
    pedidosAnuales,
    activo,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClienteTableData &&
          other.id == this.id &&
          other.proyectoId == this.proyectoId &&
          other.nombre == this.nombre &&
          other.latitud == this.latitud &&
          other.longitud == this.longitud &&
          other.demandaAnual == this.demandaAnual &&
          other.pedidosAnuales == this.pedidosAnuales &&
          other.activo == this.activo);
}

class ClienteTableCompanion extends UpdateCompanion<ClienteTableData> {
  final Value<int> id;
  final Value<int> proyectoId;
  final Value<String> nombre;
  final Value<double> latitud;
  final Value<double> longitud;
  final Value<double> demandaAnual;
  final Value<int> pedidosAnuales;
  final Value<bool> activo;
  const ClienteTableCompanion({
    this.id = const Value.absent(),
    this.proyectoId = const Value.absent(),
    this.nombre = const Value.absent(),
    this.latitud = const Value.absent(),
    this.longitud = const Value.absent(),
    this.demandaAnual = const Value.absent(),
    this.pedidosAnuales = const Value.absent(),
    this.activo = const Value.absent(),
  });
  ClienteTableCompanion.insert({
    this.id = const Value.absent(),
    required int proyectoId,
    required String nombre,
    required double latitud,
    required double longitud,
    required double demandaAnual,
    required int pedidosAnuales,
    this.activo = const Value.absent(),
  }) : proyectoId = Value(proyectoId),
       nombre = Value(nombre),
       latitud = Value(latitud),
       longitud = Value(longitud),
       demandaAnual = Value(demandaAnual),
       pedidosAnuales = Value(pedidosAnuales);
  static Insertable<ClienteTableData> custom({
    Expression<int>? id,
    Expression<int>? proyectoId,
    Expression<String>? nombre,
    Expression<double>? latitud,
    Expression<double>? longitud,
    Expression<double>? demandaAnual,
    Expression<int>? pedidosAnuales,
    Expression<bool>? activo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (proyectoId != null) 'proyecto_id': proyectoId,
      if (nombre != null) 'nombre': nombre,
      if (latitud != null) 'latitud': latitud,
      if (longitud != null) 'longitud': longitud,
      if (demandaAnual != null) 'demanda_anual': demandaAnual,
      if (pedidosAnuales != null) 'pedidos_anuales': pedidosAnuales,
      if (activo != null) 'activo': activo,
    });
  }

  ClienteTableCompanion copyWith({
    Value<int>? id,
    Value<int>? proyectoId,
    Value<String>? nombre,
    Value<double>? latitud,
    Value<double>? longitud,
    Value<double>? demandaAnual,
    Value<int>? pedidosAnuales,
    Value<bool>? activo,
  }) {
    return ClienteTableCompanion(
      id: id ?? this.id,
      proyectoId: proyectoId ?? this.proyectoId,
      nombre: nombre ?? this.nombre,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      demandaAnual: demandaAnual ?? this.demandaAnual,
      pedidosAnuales: pedidosAnuales ?? this.pedidosAnuales,
      activo: activo ?? this.activo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (proyectoId.present) {
      map['proyecto_id'] = Variable<int>(proyectoId.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (latitud.present) {
      map['latitud'] = Variable<double>(latitud.value);
    }
    if (longitud.present) {
      map['longitud'] = Variable<double>(longitud.value);
    }
    if (demandaAnual.present) {
      map['demanda_anual'] = Variable<double>(demandaAnual.value);
    }
    if (pedidosAnuales.present) {
      map['pedidos_anuales'] = Variable<int>(pedidosAnuales.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClienteTableCompanion(')
          ..write('id: $id, ')
          ..write('proyectoId: $proyectoId, ')
          ..write('nombre: $nombre, ')
          ..write('latitud: $latitud, ')
          ..write('longitud: $longitud, ')
          ..write('demandaAnual: $demandaAnual, ')
          ..write('pedidosAnuales: $pedidosAnuales, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }
}

class $ZonaDemandaTableTable extends ZonaDemandaTable
    with TableInfo<$ZonaDemandaTableTable, ZonaDemandaTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ZonaDemandaTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _proyectoIdMeta = const VerificationMeta(
    'proyectoId',
  );
  @override
  late final GeneratedColumn<int> proyectoId = GeneratedColumn<int>(
    'proyecto_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES proyecto (id) ON DELETE CASCADE',
    ),
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
  static const VerificationMeta _latitudMeta = const VerificationMeta(
    'latitud',
  );
  @override
  late final GeneratedColumn<double> latitud = GeneratedColumn<double>(
    'latitud',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudMeta = const VerificationMeta(
    'longitud',
  );
  @override
  late final GeneratedColumn<double> longitud = GeneratedColumn<double>(
    'longitud',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _demandaAgregadaMeta = const VerificationMeta(
    'demandaAgregada',
  );
  @override
  late final GeneratedColumn<double> demandaAgregada = GeneratedColumn<double>(
    'demanda_agregada',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pedidosAgregadosMeta = const VerificationMeta(
    'pedidosAgregados',
  );
  @override
  late final GeneratedColumn<int> pedidosAgregados = GeneratedColumn<int>(
    'pedidos_agregados',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numeroClientesMeta = const VerificationMeta(
    'numeroClientes',
  );
  @override
  late final GeneratedColumn<int> numeroClientes = GeneratedColumn<int>(
    'numero_clientes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _errorAgregacionMetrosMeta =
      const VerificationMeta('errorAgregacionMetros');
  @override
  late final GeneratedColumn<int> errorAgregacionMetros = GeneratedColumn<int>(
    'error_agregacion_metros',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    proyectoId,
    etiqueta,
    latitud,
    longitud,
    demandaAgregada,
    pedidosAgregados,
    numeroClientes,
    errorAgregacionMetros,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'zona_demanda';
  @override
  VerificationContext validateIntegrity(
    Insertable<ZonaDemandaTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('proyecto_id')) {
      context.handle(
        _proyectoIdMeta,
        proyectoId.isAcceptableOrUnknown(data['proyecto_id']!, _proyectoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_proyectoIdMeta);
    }
    if (data.containsKey('etiqueta')) {
      context.handle(
        _etiquetaMeta,
        etiqueta.isAcceptableOrUnknown(data['etiqueta']!, _etiquetaMeta),
      );
    } else if (isInserting) {
      context.missing(_etiquetaMeta);
    }
    if (data.containsKey('latitud')) {
      context.handle(
        _latitudMeta,
        latitud.isAcceptableOrUnknown(data['latitud']!, _latitudMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudMeta);
    }
    if (data.containsKey('longitud')) {
      context.handle(
        _longitudMeta,
        longitud.isAcceptableOrUnknown(data['longitud']!, _longitudMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudMeta);
    }
    if (data.containsKey('demanda_agregada')) {
      context.handle(
        _demandaAgregadaMeta,
        demandaAgregada.isAcceptableOrUnknown(
          data['demanda_agregada']!,
          _demandaAgregadaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_demandaAgregadaMeta);
    }
    if (data.containsKey('pedidos_agregados')) {
      context.handle(
        _pedidosAgregadosMeta,
        pedidosAgregados.isAcceptableOrUnknown(
          data['pedidos_agregados']!,
          _pedidosAgregadosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pedidosAgregadosMeta);
    }
    if (data.containsKey('numero_clientes')) {
      context.handle(
        _numeroClientesMeta,
        numeroClientes.isAcceptableOrUnknown(
          data['numero_clientes']!,
          _numeroClientesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_numeroClientesMeta);
    }
    if (data.containsKey('error_agregacion_metros')) {
      context.handle(
        _errorAgregacionMetrosMeta,
        errorAgregacionMetros.isAcceptableOrUnknown(
          data['error_agregacion_metros']!,
          _errorAgregacionMetrosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_errorAgregacionMetrosMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ZonaDemandaTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ZonaDemandaTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      proyectoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}proyecto_id'],
      )!,
      etiqueta: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}etiqueta'],
      )!,
      latitud: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitud'],
      )!,
      longitud: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitud'],
      )!,
      demandaAgregada: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}demanda_agregada'],
      )!,
      pedidosAgregados: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pedidos_agregados'],
      )!,
      numeroClientes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}numero_clientes'],
      )!,
      errorAgregacionMetros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}error_agregacion_metros'],
      )!,
    );
  }

  @override
  $ZonaDemandaTableTable createAlias(String alias) {
    return $ZonaDemandaTableTable(attachedDatabase, alias);
  }
}

class ZonaDemandaTableData extends DataClass
    implements Insertable<ZonaDemandaTableData> {
  final int id;
  final int proyectoId;
  final String etiqueta;
  final double latitud;
  final double longitud;
  final double demandaAgregada;
  final int pedidosAgregados;
  final int numeroClientes;
  final int errorAgregacionMetros;
  const ZonaDemandaTableData({
    required this.id,
    required this.proyectoId,
    required this.etiqueta,
    required this.latitud,
    required this.longitud,
    required this.demandaAgregada,
    required this.pedidosAgregados,
    required this.numeroClientes,
    required this.errorAgregacionMetros,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['proyecto_id'] = Variable<int>(proyectoId);
    map['etiqueta'] = Variable<String>(etiqueta);
    map['latitud'] = Variable<double>(latitud);
    map['longitud'] = Variable<double>(longitud);
    map['demanda_agregada'] = Variable<double>(demandaAgregada);
    map['pedidos_agregados'] = Variable<int>(pedidosAgregados);
    map['numero_clientes'] = Variable<int>(numeroClientes);
    map['error_agregacion_metros'] = Variable<int>(errorAgregacionMetros);
    return map;
  }

  ZonaDemandaTableCompanion toCompanion(bool nullToAbsent) {
    return ZonaDemandaTableCompanion(
      id: Value(id),
      proyectoId: Value(proyectoId),
      etiqueta: Value(etiqueta),
      latitud: Value(latitud),
      longitud: Value(longitud),
      demandaAgregada: Value(demandaAgregada),
      pedidosAgregados: Value(pedidosAgregados),
      numeroClientes: Value(numeroClientes),
      errorAgregacionMetros: Value(errorAgregacionMetros),
    );
  }

  factory ZonaDemandaTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ZonaDemandaTableData(
      id: serializer.fromJson<int>(json['id']),
      proyectoId: serializer.fromJson<int>(json['proyectoId']),
      etiqueta: serializer.fromJson<String>(json['etiqueta']),
      latitud: serializer.fromJson<double>(json['latitud']),
      longitud: serializer.fromJson<double>(json['longitud']),
      demandaAgregada: serializer.fromJson<double>(json['demandaAgregada']),
      pedidosAgregados: serializer.fromJson<int>(json['pedidosAgregados']),
      numeroClientes: serializer.fromJson<int>(json['numeroClientes']),
      errorAgregacionMetros: serializer.fromJson<int>(
        json['errorAgregacionMetros'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'proyectoId': serializer.toJson<int>(proyectoId),
      'etiqueta': serializer.toJson<String>(etiqueta),
      'latitud': serializer.toJson<double>(latitud),
      'longitud': serializer.toJson<double>(longitud),
      'demandaAgregada': serializer.toJson<double>(demandaAgregada),
      'pedidosAgregados': serializer.toJson<int>(pedidosAgregados),
      'numeroClientes': serializer.toJson<int>(numeroClientes),
      'errorAgregacionMetros': serializer.toJson<int>(errorAgregacionMetros),
    };
  }

  ZonaDemandaTableData copyWith({
    int? id,
    int? proyectoId,
    String? etiqueta,
    double? latitud,
    double? longitud,
    double? demandaAgregada,
    int? pedidosAgregados,
    int? numeroClientes,
    int? errorAgregacionMetros,
  }) => ZonaDemandaTableData(
    id: id ?? this.id,
    proyectoId: proyectoId ?? this.proyectoId,
    etiqueta: etiqueta ?? this.etiqueta,
    latitud: latitud ?? this.latitud,
    longitud: longitud ?? this.longitud,
    demandaAgregada: demandaAgregada ?? this.demandaAgregada,
    pedidosAgregados: pedidosAgregados ?? this.pedidosAgregados,
    numeroClientes: numeroClientes ?? this.numeroClientes,
    errorAgregacionMetros: errorAgregacionMetros ?? this.errorAgregacionMetros,
  );
  ZonaDemandaTableData copyWithCompanion(ZonaDemandaTableCompanion data) {
    return ZonaDemandaTableData(
      id: data.id.present ? data.id.value : this.id,
      proyectoId: data.proyectoId.present
          ? data.proyectoId.value
          : this.proyectoId,
      etiqueta: data.etiqueta.present ? data.etiqueta.value : this.etiqueta,
      latitud: data.latitud.present ? data.latitud.value : this.latitud,
      longitud: data.longitud.present ? data.longitud.value : this.longitud,
      demandaAgregada: data.demandaAgregada.present
          ? data.demandaAgregada.value
          : this.demandaAgregada,
      pedidosAgregados: data.pedidosAgregados.present
          ? data.pedidosAgregados.value
          : this.pedidosAgregados,
      numeroClientes: data.numeroClientes.present
          ? data.numeroClientes.value
          : this.numeroClientes,
      errorAgregacionMetros: data.errorAgregacionMetros.present
          ? data.errorAgregacionMetros.value
          : this.errorAgregacionMetros,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ZonaDemandaTableData(')
          ..write('id: $id, ')
          ..write('proyectoId: $proyectoId, ')
          ..write('etiqueta: $etiqueta, ')
          ..write('latitud: $latitud, ')
          ..write('longitud: $longitud, ')
          ..write('demandaAgregada: $demandaAgregada, ')
          ..write('pedidosAgregados: $pedidosAgregados, ')
          ..write('numeroClientes: $numeroClientes, ')
          ..write('errorAgregacionMetros: $errorAgregacionMetros')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    proyectoId,
    etiqueta,
    latitud,
    longitud,
    demandaAgregada,
    pedidosAgregados,
    numeroClientes,
    errorAgregacionMetros,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ZonaDemandaTableData &&
          other.id == this.id &&
          other.proyectoId == this.proyectoId &&
          other.etiqueta == this.etiqueta &&
          other.latitud == this.latitud &&
          other.longitud == this.longitud &&
          other.demandaAgregada == this.demandaAgregada &&
          other.pedidosAgregados == this.pedidosAgregados &&
          other.numeroClientes == this.numeroClientes &&
          other.errorAgregacionMetros == this.errorAgregacionMetros);
}

class ZonaDemandaTableCompanion extends UpdateCompanion<ZonaDemandaTableData> {
  final Value<int> id;
  final Value<int> proyectoId;
  final Value<String> etiqueta;
  final Value<double> latitud;
  final Value<double> longitud;
  final Value<double> demandaAgregada;
  final Value<int> pedidosAgregados;
  final Value<int> numeroClientes;
  final Value<int> errorAgregacionMetros;
  const ZonaDemandaTableCompanion({
    this.id = const Value.absent(),
    this.proyectoId = const Value.absent(),
    this.etiqueta = const Value.absent(),
    this.latitud = const Value.absent(),
    this.longitud = const Value.absent(),
    this.demandaAgregada = const Value.absent(),
    this.pedidosAgregados = const Value.absent(),
    this.numeroClientes = const Value.absent(),
    this.errorAgregacionMetros = const Value.absent(),
  });
  ZonaDemandaTableCompanion.insert({
    this.id = const Value.absent(),
    required int proyectoId,
    required String etiqueta,
    required double latitud,
    required double longitud,
    required double demandaAgregada,
    required int pedidosAgregados,
    required int numeroClientes,
    required int errorAgregacionMetros,
  }) : proyectoId = Value(proyectoId),
       etiqueta = Value(etiqueta),
       latitud = Value(latitud),
       longitud = Value(longitud),
       demandaAgregada = Value(demandaAgregada),
       pedidosAgregados = Value(pedidosAgregados),
       numeroClientes = Value(numeroClientes),
       errorAgregacionMetros = Value(errorAgregacionMetros);
  static Insertable<ZonaDemandaTableData> custom({
    Expression<int>? id,
    Expression<int>? proyectoId,
    Expression<String>? etiqueta,
    Expression<double>? latitud,
    Expression<double>? longitud,
    Expression<double>? demandaAgregada,
    Expression<int>? pedidosAgregados,
    Expression<int>? numeroClientes,
    Expression<int>? errorAgregacionMetros,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (proyectoId != null) 'proyecto_id': proyectoId,
      if (etiqueta != null) 'etiqueta': etiqueta,
      if (latitud != null) 'latitud': latitud,
      if (longitud != null) 'longitud': longitud,
      if (demandaAgregada != null) 'demanda_agregada': demandaAgregada,
      if (pedidosAgregados != null) 'pedidos_agregados': pedidosAgregados,
      if (numeroClientes != null) 'numero_clientes': numeroClientes,
      if (errorAgregacionMetros != null)
        'error_agregacion_metros': errorAgregacionMetros,
    });
  }

  ZonaDemandaTableCompanion copyWith({
    Value<int>? id,
    Value<int>? proyectoId,
    Value<String>? etiqueta,
    Value<double>? latitud,
    Value<double>? longitud,
    Value<double>? demandaAgregada,
    Value<int>? pedidosAgregados,
    Value<int>? numeroClientes,
    Value<int>? errorAgregacionMetros,
  }) {
    return ZonaDemandaTableCompanion(
      id: id ?? this.id,
      proyectoId: proyectoId ?? this.proyectoId,
      etiqueta: etiqueta ?? this.etiqueta,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      demandaAgregada: demandaAgregada ?? this.demandaAgregada,
      pedidosAgregados: pedidosAgregados ?? this.pedidosAgregados,
      numeroClientes: numeroClientes ?? this.numeroClientes,
      errorAgregacionMetros:
          errorAgregacionMetros ?? this.errorAgregacionMetros,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (proyectoId.present) {
      map['proyecto_id'] = Variable<int>(proyectoId.value);
    }
    if (etiqueta.present) {
      map['etiqueta'] = Variable<String>(etiqueta.value);
    }
    if (latitud.present) {
      map['latitud'] = Variable<double>(latitud.value);
    }
    if (longitud.present) {
      map['longitud'] = Variable<double>(longitud.value);
    }
    if (demandaAgregada.present) {
      map['demanda_agregada'] = Variable<double>(demandaAgregada.value);
    }
    if (pedidosAgregados.present) {
      map['pedidos_agregados'] = Variable<int>(pedidosAgregados.value);
    }
    if (numeroClientes.present) {
      map['numero_clientes'] = Variable<int>(numeroClientes.value);
    }
    if (errorAgregacionMetros.present) {
      map['error_agregacion_metros'] = Variable<int>(
        errorAgregacionMetros.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ZonaDemandaTableCompanion(')
          ..write('id: $id, ')
          ..write('proyectoId: $proyectoId, ')
          ..write('etiqueta: $etiqueta, ')
          ..write('latitud: $latitud, ')
          ..write('longitud: $longitud, ')
          ..write('demandaAgregada: $demandaAgregada, ')
          ..write('pedidosAgregados: $pedidosAgregados, ')
          ..write('numeroClientes: $numeroClientes, ')
          ..write('errorAgregacionMetros: $errorAgregacionMetros')
          ..write(')'))
        .toString();
  }
}

class $ClienteZonaTableTable extends ClienteZonaTable
    with TableInfo<$ClienteZonaTableTable, ClienteZonaTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClienteZonaTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _clienteIdMeta = const VerificationMeta(
    'clienteId',
  );
  @override
  late final GeneratedColumn<int> clienteId = GeneratedColumn<int>(
    'cliente_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cliente (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _zonaIdMeta = const VerificationMeta('zonaId');
  @override
  late final GeneratedColumn<int> zonaId = GeneratedColumn<int>(
    'zona_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES zona_demanda (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, clienteId, zonaId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cliente_zona';
  @override
  VerificationContext validateIntegrity(
    Insertable<ClienteZonaTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cliente_id')) {
      context.handle(
        _clienteIdMeta,
        clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clienteIdMeta);
    }
    if (data.containsKey('zona_id')) {
      context.handle(
        _zonaIdMeta,
        zonaId.isAcceptableOrUnknown(data['zona_id']!, _zonaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_zonaIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ClienteZonaTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClienteZonaTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      clienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cliente_id'],
      )!,
      zonaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}zona_id'],
      )!,
    );
  }

  @override
  $ClienteZonaTableTable createAlias(String alias) {
    return $ClienteZonaTableTable(attachedDatabase, alias);
  }
}

class ClienteZonaTableData extends DataClass
    implements Insertable<ClienteZonaTableData> {
  final int id;
  final int clienteId;
  final int zonaId;
  const ClienteZonaTableData({
    required this.id,
    required this.clienteId,
    required this.zonaId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cliente_id'] = Variable<int>(clienteId);
    map['zona_id'] = Variable<int>(zonaId);
    return map;
  }

  ClienteZonaTableCompanion toCompanion(bool nullToAbsent) {
    return ClienteZonaTableCompanion(
      id: Value(id),
      clienteId: Value(clienteId),
      zonaId: Value(zonaId),
    );
  }

  factory ClienteZonaTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClienteZonaTableData(
      id: serializer.fromJson<int>(json['id']),
      clienteId: serializer.fromJson<int>(json['clienteId']),
      zonaId: serializer.fromJson<int>(json['zonaId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'clienteId': serializer.toJson<int>(clienteId),
      'zonaId': serializer.toJson<int>(zonaId),
    };
  }

  ClienteZonaTableData copyWith({int? id, int? clienteId, int? zonaId}) =>
      ClienteZonaTableData(
        id: id ?? this.id,
        clienteId: clienteId ?? this.clienteId,
        zonaId: zonaId ?? this.zonaId,
      );
  ClienteZonaTableData copyWithCompanion(ClienteZonaTableCompanion data) {
    return ClienteZonaTableData(
      id: data.id.present ? data.id.value : this.id,
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
      zonaId: data.zonaId.present ? data.zonaId.value : this.zonaId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClienteZonaTableData(')
          ..write('id: $id, ')
          ..write('clienteId: $clienteId, ')
          ..write('zonaId: $zonaId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, clienteId, zonaId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClienteZonaTableData &&
          other.id == this.id &&
          other.clienteId == this.clienteId &&
          other.zonaId == this.zonaId);
}

class ClienteZonaTableCompanion extends UpdateCompanion<ClienteZonaTableData> {
  final Value<int> id;
  final Value<int> clienteId;
  final Value<int> zonaId;
  const ClienteZonaTableCompanion({
    this.id = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.zonaId = const Value.absent(),
  });
  ClienteZonaTableCompanion.insert({
    this.id = const Value.absent(),
    required int clienteId,
    required int zonaId,
  }) : clienteId = Value(clienteId),
       zonaId = Value(zonaId);
  static Insertable<ClienteZonaTableData> custom({
    Expression<int>? id,
    Expression<int>? clienteId,
    Expression<int>? zonaId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clienteId != null) 'cliente_id': clienteId,
      if (zonaId != null) 'zona_id': zonaId,
    });
  }

  ClienteZonaTableCompanion copyWith({
    Value<int>? id,
    Value<int>? clienteId,
    Value<int>? zonaId,
  }) {
    return ClienteZonaTableCompanion(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      zonaId: zonaId ?? this.zonaId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (clienteId.present) {
      map['cliente_id'] = Variable<int>(clienteId.value);
    }
    if (zonaId.present) {
      map['zona_id'] = Variable<int>(zonaId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClienteZonaTableCompanion(')
          ..write('id: $id, ')
          ..write('clienteId: $clienteId, ')
          ..write('zonaId: $zonaId')
          ..write(')'))
        .toString();
  }
}

class $SitioCandidatoTableTable extends SitioCandidatoTable
    with TableInfo<$SitioCandidatoTableTable, SitioCandidatoTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SitioCandidatoTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _proyectoIdMeta = const VerificationMeta(
    'proyectoId',
  );
  @override
  late final GeneratedColumn<int> proyectoId = GeneratedColumn<int>(
    'proyecto_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES proyecto (id) ON DELETE CASCADE',
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
  static const VerificationMeta _latitudMeta = const VerificationMeta(
    'latitud',
  );
  @override
  late final GeneratedColumn<double> latitud = GeneratedColumn<double>(
    'latitud',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudMeta = const VerificationMeta(
    'longitud',
  );
  @override
  late final GeneratedColumn<double> longitud = GeneratedColumn<double>(
    'longitud',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costoFijoAnualCentMeta =
      const VerificationMeta('costoFijoAnualCent');
  @override
  late final GeneratedColumn<int> costoFijoAnualCent = GeneratedColumn<int>(
    'costo_fijo_anual_cent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _capacidadAnualMeta = const VerificationMeta(
    'capacidadAnual',
  );
  @override
  late final GeneratedColumn<double> capacidadAnual = GeneratedColumn<double>(
    'capacidad_anual',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costoVariableManejoCentPorUnidadMeta =
      const VerificationMeta('costoVariableManejoCentPorUnidad');
  @override
  late final GeneratedColumn<int> costoVariableManejoCentPorUnidad =
      GeneratedColumn<int>(
        'costo_variable_manejo_cent_por_unidad',
        aliasedName,
        false,
        type: DriftSqlType.int,
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
  static const VerificationMeta _esRedActualMeta = const VerificationMeta(
    'esRedActual',
  );
  @override
  late final GeneratedColumn<bool> esRedActual = GeneratedColumn<bool>(
    'es_red_actual',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("es_red_actual" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    proyectoId,
    nombre,
    latitud,
    longitud,
    costoFijoAnualCent,
    capacidadAnual,
    costoVariableManejoCentPorUnidad,
    origen,
    esRedActual,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sitio_candidato';
  @override
  VerificationContext validateIntegrity(
    Insertable<SitioCandidatoTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('proyecto_id')) {
      context.handle(
        _proyectoIdMeta,
        proyectoId.isAcceptableOrUnknown(data['proyecto_id']!, _proyectoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_proyectoIdMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('latitud')) {
      context.handle(
        _latitudMeta,
        latitud.isAcceptableOrUnknown(data['latitud']!, _latitudMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudMeta);
    }
    if (data.containsKey('longitud')) {
      context.handle(
        _longitudMeta,
        longitud.isAcceptableOrUnknown(data['longitud']!, _longitudMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudMeta);
    }
    if (data.containsKey('costo_fijo_anual_cent')) {
      context.handle(
        _costoFijoAnualCentMeta,
        costoFijoAnualCent.isAcceptableOrUnknown(
          data['costo_fijo_anual_cent']!,
          _costoFijoAnualCentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_costoFijoAnualCentMeta);
    }
    if (data.containsKey('capacidad_anual')) {
      context.handle(
        _capacidadAnualMeta,
        capacidadAnual.isAcceptableOrUnknown(
          data['capacidad_anual']!,
          _capacidadAnualMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_capacidadAnualMeta);
    }
    if (data.containsKey('costo_variable_manejo_cent_por_unidad')) {
      context.handle(
        _costoVariableManejoCentPorUnidadMeta,
        costoVariableManejoCentPorUnidad.isAcceptableOrUnknown(
          data['costo_variable_manejo_cent_por_unidad']!,
          _costoVariableManejoCentPorUnidadMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_costoVariableManejoCentPorUnidadMeta);
    }
    if (data.containsKey('origen')) {
      context.handle(
        _origenMeta,
        origen.isAcceptableOrUnknown(data['origen']!, _origenMeta),
      );
    } else if (isInserting) {
      context.missing(_origenMeta);
    }
    if (data.containsKey('es_red_actual')) {
      context.handle(
        _esRedActualMeta,
        esRedActual.isAcceptableOrUnknown(
          data['es_red_actual']!,
          _esRedActualMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SitioCandidatoTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SitioCandidatoTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      proyectoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}proyecto_id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      latitud: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitud'],
      )!,
      longitud: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitud'],
      )!,
      costoFijoAnualCent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}costo_fijo_anual_cent'],
      )!,
      capacidadAnual: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}capacidad_anual'],
      )!,
      costoVariableManejoCentPorUnidad: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}costo_variable_manejo_cent_por_unidad'],
      )!,
      origen: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origen'],
      )!,
      esRedActual: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}es_red_actual'],
      )!,
    );
  }

  @override
  $SitioCandidatoTableTable createAlias(String alias) {
    return $SitioCandidatoTableTable(attachedDatabase, alias);
  }
}

class SitioCandidatoTableData extends DataClass
    implements Insertable<SitioCandidatoTableData> {
  final int id;
  final int proyectoId;
  final String nombre;
  final double latitud;
  final double longitud;
  final int costoFijoAnualCent;
  final double capacidadAnual;
  final int costoVariableManejoCentPorUnidad;
  final String origen;
  final bool esRedActual;
  const SitioCandidatoTableData({
    required this.id,
    required this.proyectoId,
    required this.nombre,
    required this.latitud,
    required this.longitud,
    required this.costoFijoAnualCent,
    required this.capacidadAnual,
    required this.costoVariableManejoCentPorUnidad,
    required this.origen,
    required this.esRedActual,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['proyecto_id'] = Variable<int>(proyectoId);
    map['nombre'] = Variable<String>(nombre);
    map['latitud'] = Variable<double>(latitud);
    map['longitud'] = Variable<double>(longitud);
    map['costo_fijo_anual_cent'] = Variable<int>(costoFijoAnualCent);
    map['capacidad_anual'] = Variable<double>(capacidadAnual);
    map['costo_variable_manejo_cent_por_unidad'] = Variable<int>(
      costoVariableManejoCentPorUnidad,
    );
    map['origen'] = Variable<String>(origen);
    map['es_red_actual'] = Variable<bool>(esRedActual);
    return map;
  }

  SitioCandidatoTableCompanion toCompanion(bool nullToAbsent) {
    return SitioCandidatoTableCompanion(
      id: Value(id),
      proyectoId: Value(proyectoId),
      nombre: Value(nombre),
      latitud: Value(latitud),
      longitud: Value(longitud),
      costoFijoAnualCent: Value(costoFijoAnualCent),
      capacidadAnual: Value(capacidadAnual),
      costoVariableManejoCentPorUnidad: Value(costoVariableManejoCentPorUnidad),
      origen: Value(origen),
      esRedActual: Value(esRedActual),
    );
  }

  factory SitioCandidatoTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SitioCandidatoTableData(
      id: serializer.fromJson<int>(json['id']),
      proyectoId: serializer.fromJson<int>(json['proyectoId']),
      nombre: serializer.fromJson<String>(json['nombre']),
      latitud: serializer.fromJson<double>(json['latitud']),
      longitud: serializer.fromJson<double>(json['longitud']),
      costoFijoAnualCent: serializer.fromJson<int>(json['costoFijoAnualCent']),
      capacidadAnual: serializer.fromJson<double>(json['capacidadAnual']),
      costoVariableManejoCentPorUnidad: serializer.fromJson<int>(
        json['costoVariableManejoCentPorUnidad'],
      ),
      origen: serializer.fromJson<String>(json['origen']),
      esRedActual: serializer.fromJson<bool>(json['esRedActual']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'proyectoId': serializer.toJson<int>(proyectoId),
      'nombre': serializer.toJson<String>(nombre),
      'latitud': serializer.toJson<double>(latitud),
      'longitud': serializer.toJson<double>(longitud),
      'costoFijoAnualCent': serializer.toJson<int>(costoFijoAnualCent),
      'capacidadAnual': serializer.toJson<double>(capacidadAnual),
      'costoVariableManejoCentPorUnidad': serializer.toJson<int>(
        costoVariableManejoCentPorUnidad,
      ),
      'origen': serializer.toJson<String>(origen),
      'esRedActual': serializer.toJson<bool>(esRedActual),
    };
  }

  SitioCandidatoTableData copyWith({
    int? id,
    int? proyectoId,
    String? nombre,
    double? latitud,
    double? longitud,
    int? costoFijoAnualCent,
    double? capacidadAnual,
    int? costoVariableManejoCentPorUnidad,
    String? origen,
    bool? esRedActual,
  }) => SitioCandidatoTableData(
    id: id ?? this.id,
    proyectoId: proyectoId ?? this.proyectoId,
    nombre: nombre ?? this.nombre,
    latitud: latitud ?? this.latitud,
    longitud: longitud ?? this.longitud,
    costoFijoAnualCent: costoFijoAnualCent ?? this.costoFijoAnualCent,
    capacidadAnual: capacidadAnual ?? this.capacidadAnual,
    costoVariableManejoCentPorUnidad:
        costoVariableManejoCentPorUnidad ??
        this.costoVariableManejoCentPorUnidad,
    origen: origen ?? this.origen,
    esRedActual: esRedActual ?? this.esRedActual,
  );
  SitioCandidatoTableData copyWithCompanion(SitioCandidatoTableCompanion data) {
    return SitioCandidatoTableData(
      id: data.id.present ? data.id.value : this.id,
      proyectoId: data.proyectoId.present
          ? data.proyectoId.value
          : this.proyectoId,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      latitud: data.latitud.present ? data.latitud.value : this.latitud,
      longitud: data.longitud.present ? data.longitud.value : this.longitud,
      costoFijoAnualCent: data.costoFijoAnualCent.present
          ? data.costoFijoAnualCent.value
          : this.costoFijoAnualCent,
      capacidadAnual: data.capacidadAnual.present
          ? data.capacidadAnual.value
          : this.capacidadAnual,
      costoVariableManejoCentPorUnidad:
          data.costoVariableManejoCentPorUnidad.present
          ? data.costoVariableManejoCentPorUnidad.value
          : this.costoVariableManejoCentPorUnidad,
      origen: data.origen.present ? data.origen.value : this.origen,
      esRedActual: data.esRedActual.present
          ? data.esRedActual.value
          : this.esRedActual,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SitioCandidatoTableData(')
          ..write('id: $id, ')
          ..write('proyectoId: $proyectoId, ')
          ..write('nombre: $nombre, ')
          ..write('latitud: $latitud, ')
          ..write('longitud: $longitud, ')
          ..write('costoFijoAnualCent: $costoFijoAnualCent, ')
          ..write('capacidadAnual: $capacidadAnual, ')
          ..write(
            'costoVariableManejoCentPorUnidad: $costoVariableManejoCentPorUnidad, ',
          )
          ..write('origen: $origen, ')
          ..write('esRedActual: $esRedActual')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    proyectoId,
    nombre,
    latitud,
    longitud,
    costoFijoAnualCent,
    capacidadAnual,
    costoVariableManejoCentPorUnidad,
    origen,
    esRedActual,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SitioCandidatoTableData &&
          other.id == this.id &&
          other.proyectoId == this.proyectoId &&
          other.nombre == this.nombre &&
          other.latitud == this.latitud &&
          other.longitud == this.longitud &&
          other.costoFijoAnualCent == this.costoFijoAnualCent &&
          other.capacidadAnual == this.capacidadAnual &&
          other.costoVariableManejoCentPorUnidad ==
              this.costoVariableManejoCentPorUnidad &&
          other.origen == this.origen &&
          other.esRedActual == this.esRedActual);
}

class SitioCandidatoTableCompanion
    extends UpdateCompanion<SitioCandidatoTableData> {
  final Value<int> id;
  final Value<int> proyectoId;
  final Value<String> nombre;
  final Value<double> latitud;
  final Value<double> longitud;
  final Value<int> costoFijoAnualCent;
  final Value<double> capacidadAnual;
  final Value<int> costoVariableManejoCentPorUnidad;
  final Value<String> origen;
  final Value<bool> esRedActual;
  const SitioCandidatoTableCompanion({
    this.id = const Value.absent(),
    this.proyectoId = const Value.absent(),
    this.nombre = const Value.absent(),
    this.latitud = const Value.absent(),
    this.longitud = const Value.absent(),
    this.costoFijoAnualCent = const Value.absent(),
    this.capacidadAnual = const Value.absent(),
    this.costoVariableManejoCentPorUnidad = const Value.absent(),
    this.origen = const Value.absent(),
    this.esRedActual = const Value.absent(),
  });
  SitioCandidatoTableCompanion.insert({
    this.id = const Value.absent(),
    required int proyectoId,
    required String nombre,
    required double latitud,
    required double longitud,
    required int costoFijoAnualCent,
    required double capacidadAnual,
    required int costoVariableManejoCentPorUnidad,
    required String origen,
    this.esRedActual = const Value.absent(),
  }) : proyectoId = Value(proyectoId),
       nombre = Value(nombre),
       latitud = Value(latitud),
       longitud = Value(longitud),
       costoFijoAnualCent = Value(costoFijoAnualCent),
       capacidadAnual = Value(capacidadAnual),
       costoVariableManejoCentPorUnidad = Value(
         costoVariableManejoCentPorUnidad,
       ),
       origen = Value(origen);
  static Insertable<SitioCandidatoTableData> custom({
    Expression<int>? id,
    Expression<int>? proyectoId,
    Expression<String>? nombre,
    Expression<double>? latitud,
    Expression<double>? longitud,
    Expression<int>? costoFijoAnualCent,
    Expression<double>? capacidadAnual,
    Expression<int>? costoVariableManejoCentPorUnidad,
    Expression<String>? origen,
    Expression<bool>? esRedActual,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (proyectoId != null) 'proyecto_id': proyectoId,
      if (nombre != null) 'nombre': nombre,
      if (latitud != null) 'latitud': latitud,
      if (longitud != null) 'longitud': longitud,
      if (costoFijoAnualCent != null)
        'costo_fijo_anual_cent': costoFijoAnualCent,
      if (capacidadAnual != null) 'capacidad_anual': capacidadAnual,
      if (costoVariableManejoCentPorUnidad != null)
        'costo_variable_manejo_cent_por_unidad':
            costoVariableManejoCentPorUnidad,
      if (origen != null) 'origen': origen,
      if (esRedActual != null) 'es_red_actual': esRedActual,
    });
  }

  SitioCandidatoTableCompanion copyWith({
    Value<int>? id,
    Value<int>? proyectoId,
    Value<String>? nombre,
    Value<double>? latitud,
    Value<double>? longitud,
    Value<int>? costoFijoAnualCent,
    Value<double>? capacidadAnual,
    Value<int>? costoVariableManejoCentPorUnidad,
    Value<String>? origen,
    Value<bool>? esRedActual,
  }) {
    return SitioCandidatoTableCompanion(
      id: id ?? this.id,
      proyectoId: proyectoId ?? this.proyectoId,
      nombre: nombre ?? this.nombre,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      costoFijoAnualCent: costoFijoAnualCent ?? this.costoFijoAnualCent,
      capacidadAnual: capacidadAnual ?? this.capacidadAnual,
      costoVariableManejoCentPorUnidad:
          costoVariableManejoCentPorUnidad ??
          this.costoVariableManejoCentPorUnidad,
      origen: origen ?? this.origen,
      esRedActual: esRedActual ?? this.esRedActual,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (proyectoId.present) {
      map['proyecto_id'] = Variable<int>(proyectoId.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (latitud.present) {
      map['latitud'] = Variable<double>(latitud.value);
    }
    if (longitud.present) {
      map['longitud'] = Variable<double>(longitud.value);
    }
    if (costoFijoAnualCent.present) {
      map['costo_fijo_anual_cent'] = Variable<int>(costoFijoAnualCent.value);
    }
    if (capacidadAnual.present) {
      map['capacidad_anual'] = Variable<double>(capacidadAnual.value);
    }
    if (costoVariableManejoCentPorUnidad.present) {
      map['costo_variable_manejo_cent_por_unidad'] = Variable<int>(
        costoVariableManejoCentPorUnidad.value,
      );
    }
    if (origen.present) {
      map['origen'] = Variable<String>(origen.value);
    }
    if (esRedActual.present) {
      map['es_red_actual'] = Variable<bool>(esRedActual.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SitioCandidatoTableCompanion(')
          ..write('id: $id, ')
          ..write('proyectoId: $proyectoId, ')
          ..write('nombre: $nombre, ')
          ..write('latitud: $latitud, ')
          ..write('longitud: $longitud, ')
          ..write('costoFijoAnualCent: $costoFijoAnualCent, ')
          ..write('capacidadAnual: $capacidadAnual, ')
          ..write(
            'costoVariableManejoCentPorUnidad: $costoVariableManejoCentPorUnidad, ',
          )
          ..write('origen: $origen, ')
          ..write('esRedActual: $esRedActual')
          ..write(')'))
        .toString();
  }
}

class $PlantaTableTable extends PlantaTable
    with TableInfo<$PlantaTableTable, PlantaTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlantaTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _proyectoIdMeta = const VerificationMeta(
    'proyectoId',
  );
  @override
  late final GeneratedColumn<int> proyectoId = GeneratedColumn<int>(
    'proyecto_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES proyecto (id) ON DELETE CASCADE',
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
  static const VerificationMeta _latitudMeta = const VerificationMeta(
    'latitud',
  );
  @override
  late final GeneratedColumn<double> latitud = GeneratedColumn<double>(
    'latitud',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudMeta = const VerificationMeta(
    'longitud',
  );
  @override
  late final GeneratedColumn<double> longitud = GeneratedColumn<double>(
    'longitud',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _capacidadAnualMeta = const VerificationMeta(
    'capacidadAnual',
  );
  @override
  late final GeneratedColumn<double> capacidadAnual = GeneratedColumn<double>(
    'capacidad_anual',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costoProduccionCentPorUnidadMeta =
      const VerificationMeta('costoProduccionCentPorUnidad');
  @override
  late final GeneratedColumn<int> costoProduccionCentPorUnidad =
      GeneratedColumn<int>(
        'costo_produccion_cent_por_unidad',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    proyectoId,
    nombre,
    latitud,
    longitud,
    capacidadAnual,
    costoProduccionCentPorUnidad,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'planta';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlantaTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('proyecto_id')) {
      context.handle(
        _proyectoIdMeta,
        proyectoId.isAcceptableOrUnknown(data['proyecto_id']!, _proyectoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_proyectoIdMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('latitud')) {
      context.handle(
        _latitudMeta,
        latitud.isAcceptableOrUnknown(data['latitud']!, _latitudMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudMeta);
    }
    if (data.containsKey('longitud')) {
      context.handle(
        _longitudMeta,
        longitud.isAcceptableOrUnknown(data['longitud']!, _longitudMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudMeta);
    }
    if (data.containsKey('capacidad_anual')) {
      context.handle(
        _capacidadAnualMeta,
        capacidadAnual.isAcceptableOrUnknown(
          data['capacidad_anual']!,
          _capacidadAnualMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_capacidadAnualMeta);
    }
    if (data.containsKey('costo_produccion_cent_por_unidad')) {
      context.handle(
        _costoProduccionCentPorUnidadMeta,
        costoProduccionCentPorUnidad.isAcceptableOrUnknown(
          data['costo_produccion_cent_por_unidad']!,
          _costoProduccionCentPorUnidadMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_costoProduccionCentPorUnidadMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlantaTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlantaTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      proyectoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}proyecto_id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      latitud: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitud'],
      )!,
      longitud: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitud'],
      )!,
      capacidadAnual: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}capacidad_anual'],
      )!,
      costoProduccionCentPorUnidad: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}costo_produccion_cent_por_unidad'],
      )!,
    );
  }

  @override
  $PlantaTableTable createAlias(String alias) {
    return $PlantaTableTable(attachedDatabase, alias);
  }
}

class PlantaTableData extends DataClass implements Insertable<PlantaTableData> {
  final int id;
  final int proyectoId;
  final String nombre;
  final double latitud;
  final double longitud;
  final double capacidadAnual;
  final int costoProduccionCentPorUnidad;
  const PlantaTableData({
    required this.id,
    required this.proyectoId,
    required this.nombre,
    required this.latitud,
    required this.longitud,
    required this.capacidadAnual,
    required this.costoProduccionCentPorUnidad,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['proyecto_id'] = Variable<int>(proyectoId);
    map['nombre'] = Variable<String>(nombre);
    map['latitud'] = Variable<double>(latitud);
    map['longitud'] = Variable<double>(longitud);
    map['capacidad_anual'] = Variable<double>(capacidadAnual);
    map['costo_produccion_cent_por_unidad'] = Variable<int>(
      costoProduccionCentPorUnidad,
    );
    return map;
  }

  PlantaTableCompanion toCompanion(bool nullToAbsent) {
    return PlantaTableCompanion(
      id: Value(id),
      proyectoId: Value(proyectoId),
      nombre: Value(nombre),
      latitud: Value(latitud),
      longitud: Value(longitud),
      capacidadAnual: Value(capacidadAnual),
      costoProduccionCentPorUnidad: Value(costoProduccionCentPorUnidad),
    );
  }

  factory PlantaTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlantaTableData(
      id: serializer.fromJson<int>(json['id']),
      proyectoId: serializer.fromJson<int>(json['proyectoId']),
      nombre: serializer.fromJson<String>(json['nombre']),
      latitud: serializer.fromJson<double>(json['latitud']),
      longitud: serializer.fromJson<double>(json['longitud']),
      capacidadAnual: serializer.fromJson<double>(json['capacidadAnual']),
      costoProduccionCentPorUnidad: serializer.fromJson<int>(
        json['costoProduccionCentPorUnidad'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'proyectoId': serializer.toJson<int>(proyectoId),
      'nombre': serializer.toJson<String>(nombre),
      'latitud': serializer.toJson<double>(latitud),
      'longitud': serializer.toJson<double>(longitud),
      'capacidadAnual': serializer.toJson<double>(capacidadAnual),
      'costoProduccionCentPorUnidad': serializer.toJson<int>(
        costoProduccionCentPorUnidad,
      ),
    };
  }

  PlantaTableData copyWith({
    int? id,
    int? proyectoId,
    String? nombre,
    double? latitud,
    double? longitud,
    double? capacidadAnual,
    int? costoProduccionCentPorUnidad,
  }) => PlantaTableData(
    id: id ?? this.id,
    proyectoId: proyectoId ?? this.proyectoId,
    nombre: nombre ?? this.nombre,
    latitud: latitud ?? this.latitud,
    longitud: longitud ?? this.longitud,
    capacidadAnual: capacidadAnual ?? this.capacidadAnual,
    costoProduccionCentPorUnidad:
        costoProduccionCentPorUnidad ?? this.costoProduccionCentPorUnidad,
  );
  PlantaTableData copyWithCompanion(PlantaTableCompanion data) {
    return PlantaTableData(
      id: data.id.present ? data.id.value : this.id,
      proyectoId: data.proyectoId.present
          ? data.proyectoId.value
          : this.proyectoId,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      latitud: data.latitud.present ? data.latitud.value : this.latitud,
      longitud: data.longitud.present ? data.longitud.value : this.longitud,
      capacidadAnual: data.capacidadAnual.present
          ? data.capacidadAnual.value
          : this.capacidadAnual,
      costoProduccionCentPorUnidad: data.costoProduccionCentPorUnidad.present
          ? data.costoProduccionCentPorUnidad.value
          : this.costoProduccionCentPorUnidad,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlantaTableData(')
          ..write('id: $id, ')
          ..write('proyectoId: $proyectoId, ')
          ..write('nombre: $nombre, ')
          ..write('latitud: $latitud, ')
          ..write('longitud: $longitud, ')
          ..write('capacidadAnual: $capacidadAnual, ')
          ..write('costoProduccionCentPorUnidad: $costoProduccionCentPorUnidad')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    proyectoId,
    nombre,
    latitud,
    longitud,
    capacidadAnual,
    costoProduccionCentPorUnidad,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlantaTableData &&
          other.id == this.id &&
          other.proyectoId == this.proyectoId &&
          other.nombre == this.nombre &&
          other.latitud == this.latitud &&
          other.longitud == this.longitud &&
          other.capacidadAnual == this.capacidadAnual &&
          other.costoProduccionCentPorUnidad ==
              this.costoProduccionCentPorUnidad);
}

class PlantaTableCompanion extends UpdateCompanion<PlantaTableData> {
  final Value<int> id;
  final Value<int> proyectoId;
  final Value<String> nombre;
  final Value<double> latitud;
  final Value<double> longitud;
  final Value<double> capacidadAnual;
  final Value<int> costoProduccionCentPorUnidad;
  const PlantaTableCompanion({
    this.id = const Value.absent(),
    this.proyectoId = const Value.absent(),
    this.nombre = const Value.absent(),
    this.latitud = const Value.absent(),
    this.longitud = const Value.absent(),
    this.capacidadAnual = const Value.absent(),
    this.costoProduccionCentPorUnidad = const Value.absent(),
  });
  PlantaTableCompanion.insert({
    this.id = const Value.absent(),
    required int proyectoId,
    required String nombre,
    required double latitud,
    required double longitud,
    required double capacidadAnual,
    required int costoProduccionCentPorUnidad,
  }) : proyectoId = Value(proyectoId),
       nombre = Value(nombre),
       latitud = Value(latitud),
       longitud = Value(longitud),
       capacidadAnual = Value(capacidadAnual),
       costoProduccionCentPorUnidad = Value(costoProduccionCentPorUnidad);
  static Insertable<PlantaTableData> custom({
    Expression<int>? id,
    Expression<int>? proyectoId,
    Expression<String>? nombre,
    Expression<double>? latitud,
    Expression<double>? longitud,
    Expression<double>? capacidadAnual,
    Expression<int>? costoProduccionCentPorUnidad,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (proyectoId != null) 'proyecto_id': proyectoId,
      if (nombre != null) 'nombre': nombre,
      if (latitud != null) 'latitud': latitud,
      if (longitud != null) 'longitud': longitud,
      if (capacidadAnual != null) 'capacidad_anual': capacidadAnual,
      if (costoProduccionCentPorUnidad != null)
        'costo_produccion_cent_por_unidad': costoProduccionCentPorUnidad,
    });
  }

  PlantaTableCompanion copyWith({
    Value<int>? id,
    Value<int>? proyectoId,
    Value<String>? nombre,
    Value<double>? latitud,
    Value<double>? longitud,
    Value<double>? capacidadAnual,
    Value<int>? costoProduccionCentPorUnidad,
  }) {
    return PlantaTableCompanion(
      id: id ?? this.id,
      proyectoId: proyectoId ?? this.proyectoId,
      nombre: nombre ?? this.nombre,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      capacidadAnual: capacidadAnual ?? this.capacidadAnual,
      costoProduccionCentPorUnidad:
          costoProduccionCentPorUnidad ?? this.costoProduccionCentPorUnidad,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (proyectoId.present) {
      map['proyecto_id'] = Variable<int>(proyectoId.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (latitud.present) {
      map['latitud'] = Variable<double>(latitud.value);
    }
    if (longitud.present) {
      map['longitud'] = Variable<double>(longitud.value);
    }
    if (capacidadAnual.present) {
      map['capacidad_anual'] = Variable<double>(capacidadAnual.value);
    }
    if (costoProduccionCentPorUnidad.present) {
      map['costo_produccion_cent_por_unidad'] = Variable<int>(
        costoProduccionCentPorUnidad.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlantaTableCompanion(')
          ..write('id: $id, ')
          ..write('proyectoId: $proyectoId, ')
          ..write('nombre: $nombre, ')
          ..write('latitud: $latitud, ')
          ..write('longitud: $longitud, ')
          ..write('capacidadAnual: $capacidadAnual, ')
          ..write('costoProduccionCentPorUnidad: $costoProduccionCentPorUnidad')
          ..write(')'))
        .toString();
  }
}

class $ParametrosCostoTableTable extends ParametrosCostoTable
    with TableInfo<$ParametrosCostoTableTable, ParametrosCostoTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ParametrosCostoTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _proyectoIdMeta = const VerificationMeta(
    'proyectoId',
  );
  @override
  late final GeneratedColumn<int> proyectoId = GeneratedColumn<int>(
    'proyecto_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES proyecto (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _tarifaEntradaFijaCentMeta =
      const VerificationMeta('tarifaEntradaFijaCent');
  @override
  late final GeneratedColumn<int> tarifaEntradaFijaCent = GeneratedColumn<int>(
    'tarifa_entrada_fija_cent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tarifaEntradaCentPorKmTonMeta =
      const VerificationMeta('tarifaEntradaCentPorKmTon');
  @override
  late final GeneratedColumn<int> tarifaEntradaCentPorKmTon =
      GeneratedColumn<int>(
        'tarifa_entrada_cent_por_km_ton',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _tarifaSalidaFijaCentMeta =
      const VerificationMeta('tarifaSalidaFijaCent');
  @override
  late final GeneratedColumn<int> tarifaSalidaFijaCent = GeneratedColumn<int>(
    'tarifa_salida_fija_cent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tarifaSalidaCentPorKmTonMeta =
      const VerificationMeta('tarifaSalidaCentPorKmTon');
  @override
  late final GeneratedColumn<int> tarifaSalidaCentPorKmTon =
      GeneratedColumn<int>(
        'tarifa_salida_cent_por_km_ton',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _tasaManejoInventarioAnualMeta =
      const VerificationMeta('tasaManejoInventarioAnual');
  @override
  late final GeneratedColumn<double> tasaManejoInventarioAnual =
      GeneratedColumn<double>(
        'tasa_manejo_inventario_anual',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _valorPorUnidadCentMeta =
      const VerificationMeta('valorPorUnidadCent');
  @override
  late final GeneratedColumn<int> valorPorUnidadCent = GeneratedColumn<int>(
    'valor_por_unidad_cent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inventarioBaseUnaUbicacionMeta =
      const VerificationMeta('inventarioBaseUnaUbicacion');
  @override
  late final GeneratedColumn<double> inventarioBaseUnaUbicacion =
      GeneratedColumn<double>(
        'inventario_base_una_ubicacion',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _costoPorPedidoCentMeta =
      const VerificationMeta('costoPorPedidoCent');
  @override
  late final GeneratedColumn<int> costoPorPedidoCent = GeneratedColumn<int>(
    'costo_por_pedido_cent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipoEstandarMeta = const VerificationMeta(
    'tipoEstandar',
  );
  @override
  late final GeneratedColumn<String> tipoEstandar = GeneratedColumn<String>(
    'tipo_estandar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estandarServicioValorMeta =
      const VerificationMeta('estandarServicioValor');
  @override
  late final GeneratedColumn<int> estandarServicioValor = GeneratedColumn<int>(
    'estandar_servicio_valor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    proyectoId,
    tarifaEntradaFijaCent,
    tarifaEntradaCentPorKmTon,
    tarifaSalidaFijaCent,
    tarifaSalidaCentPorKmTon,
    tasaManejoInventarioAnual,
    valorPorUnidadCent,
    inventarioBaseUnaUbicacion,
    costoPorPedidoCent,
    tipoEstandar,
    estandarServicioValor,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parametros_costo';
  @override
  VerificationContext validateIntegrity(
    Insertable<ParametrosCostoTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('proyecto_id')) {
      context.handle(
        _proyectoIdMeta,
        proyectoId.isAcceptableOrUnknown(data['proyecto_id']!, _proyectoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_proyectoIdMeta);
    }
    if (data.containsKey('tarifa_entrada_fija_cent')) {
      context.handle(
        _tarifaEntradaFijaCentMeta,
        tarifaEntradaFijaCent.isAcceptableOrUnknown(
          data['tarifa_entrada_fija_cent']!,
          _tarifaEntradaFijaCentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tarifaEntradaFijaCentMeta);
    }
    if (data.containsKey('tarifa_entrada_cent_por_km_ton')) {
      context.handle(
        _tarifaEntradaCentPorKmTonMeta,
        tarifaEntradaCentPorKmTon.isAcceptableOrUnknown(
          data['tarifa_entrada_cent_por_km_ton']!,
          _tarifaEntradaCentPorKmTonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tarifaEntradaCentPorKmTonMeta);
    }
    if (data.containsKey('tarifa_salida_fija_cent')) {
      context.handle(
        _tarifaSalidaFijaCentMeta,
        tarifaSalidaFijaCent.isAcceptableOrUnknown(
          data['tarifa_salida_fija_cent']!,
          _tarifaSalidaFijaCentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tarifaSalidaFijaCentMeta);
    }
    if (data.containsKey('tarifa_salida_cent_por_km_ton')) {
      context.handle(
        _tarifaSalidaCentPorKmTonMeta,
        tarifaSalidaCentPorKmTon.isAcceptableOrUnknown(
          data['tarifa_salida_cent_por_km_ton']!,
          _tarifaSalidaCentPorKmTonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tarifaSalidaCentPorKmTonMeta);
    }
    if (data.containsKey('tasa_manejo_inventario_anual')) {
      context.handle(
        _tasaManejoInventarioAnualMeta,
        tasaManejoInventarioAnual.isAcceptableOrUnknown(
          data['tasa_manejo_inventario_anual']!,
          _tasaManejoInventarioAnualMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tasaManejoInventarioAnualMeta);
    }
    if (data.containsKey('valor_por_unidad_cent')) {
      context.handle(
        _valorPorUnidadCentMeta,
        valorPorUnidadCent.isAcceptableOrUnknown(
          data['valor_por_unidad_cent']!,
          _valorPorUnidadCentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_valorPorUnidadCentMeta);
    }
    if (data.containsKey('inventario_base_una_ubicacion')) {
      context.handle(
        _inventarioBaseUnaUbicacionMeta,
        inventarioBaseUnaUbicacion.isAcceptableOrUnknown(
          data['inventario_base_una_ubicacion']!,
          _inventarioBaseUnaUbicacionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_inventarioBaseUnaUbicacionMeta);
    }
    if (data.containsKey('costo_por_pedido_cent')) {
      context.handle(
        _costoPorPedidoCentMeta,
        costoPorPedidoCent.isAcceptableOrUnknown(
          data['costo_por_pedido_cent']!,
          _costoPorPedidoCentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_costoPorPedidoCentMeta);
    }
    if (data.containsKey('tipo_estandar')) {
      context.handle(
        _tipoEstandarMeta,
        tipoEstandar.isAcceptableOrUnknown(
          data['tipo_estandar']!,
          _tipoEstandarMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tipoEstandarMeta);
    }
    if (data.containsKey('estandar_servicio_valor')) {
      context.handle(
        _estandarServicioValorMeta,
        estandarServicioValor.isAcceptableOrUnknown(
          data['estandar_servicio_valor']!,
          _estandarServicioValorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_estandarServicioValorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {proyectoId},
  ];
  @override
  ParametrosCostoTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ParametrosCostoTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      proyectoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}proyecto_id'],
      )!,
      tarifaEntradaFijaCent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tarifa_entrada_fija_cent'],
      )!,
      tarifaEntradaCentPorKmTon: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tarifa_entrada_cent_por_km_ton'],
      )!,
      tarifaSalidaFijaCent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tarifa_salida_fija_cent'],
      )!,
      tarifaSalidaCentPorKmTon: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tarifa_salida_cent_por_km_ton'],
      )!,
      tasaManejoInventarioAnual: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tasa_manejo_inventario_anual'],
      )!,
      valorPorUnidadCent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}valor_por_unidad_cent'],
      )!,
      inventarioBaseUnaUbicacion: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}inventario_base_una_ubicacion'],
      )!,
      costoPorPedidoCent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}costo_por_pedido_cent'],
      )!,
      tipoEstandar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo_estandar'],
      )!,
      estandarServicioValor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estandar_servicio_valor'],
      )!,
    );
  }

  @override
  $ParametrosCostoTableTable createAlias(String alias) {
    return $ParametrosCostoTableTable(attachedDatabase, alias);
  }
}

class ParametrosCostoTableData extends DataClass
    implements Insertable<ParametrosCostoTableData> {
  final int id;
  final int proyectoId;
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
  const ParametrosCostoTableData({
    required this.id,
    required this.proyectoId,
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
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['proyecto_id'] = Variable<int>(proyectoId);
    map['tarifa_entrada_fija_cent'] = Variable<int>(tarifaEntradaFijaCent);
    map['tarifa_entrada_cent_por_km_ton'] = Variable<int>(
      tarifaEntradaCentPorKmTon,
    );
    map['tarifa_salida_fija_cent'] = Variable<int>(tarifaSalidaFijaCent);
    map['tarifa_salida_cent_por_km_ton'] = Variable<int>(
      tarifaSalidaCentPorKmTon,
    );
    map['tasa_manejo_inventario_anual'] = Variable<double>(
      tasaManejoInventarioAnual,
    );
    map['valor_por_unidad_cent'] = Variable<int>(valorPorUnidadCent);
    map['inventario_base_una_ubicacion'] = Variable<double>(
      inventarioBaseUnaUbicacion,
    );
    map['costo_por_pedido_cent'] = Variable<int>(costoPorPedidoCent);
    map['tipo_estandar'] = Variable<String>(tipoEstandar);
    map['estandar_servicio_valor'] = Variable<int>(estandarServicioValor);
    return map;
  }

  ParametrosCostoTableCompanion toCompanion(bool nullToAbsent) {
    return ParametrosCostoTableCompanion(
      id: Value(id),
      proyectoId: Value(proyectoId),
      tarifaEntradaFijaCent: Value(tarifaEntradaFijaCent),
      tarifaEntradaCentPorKmTon: Value(tarifaEntradaCentPorKmTon),
      tarifaSalidaFijaCent: Value(tarifaSalidaFijaCent),
      tarifaSalidaCentPorKmTon: Value(tarifaSalidaCentPorKmTon),
      tasaManejoInventarioAnual: Value(tasaManejoInventarioAnual),
      valorPorUnidadCent: Value(valorPorUnidadCent),
      inventarioBaseUnaUbicacion: Value(inventarioBaseUnaUbicacion),
      costoPorPedidoCent: Value(costoPorPedidoCent),
      tipoEstandar: Value(tipoEstandar),
      estandarServicioValor: Value(estandarServicioValor),
    );
  }

  factory ParametrosCostoTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ParametrosCostoTableData(
      id: serializer.fromJson<int>(json['id']),
      proyectoId: serializer.fromJson<int>(json['proyectoId']),
      tarifaEntradaFijaCent: serializer.fromJson<int>(
        json['tarifaEntradaFijaCent'],
      ),
      tarifaEntradaCentPorKmTon: serializer.fromJson<int>(
        json['tarifaEntradaCentPorKmTon'],
      ),
      tarifaSalidaFijaCent: serializer.fromJson<int>(
        json['tarifaSalidaFijaCent'],
      ),
      tarifaSalidaCentPorKmTon: serializer.fromJson<int>(
        json['tarifaSalidaCentPorKmTon'],
      ),
      tasaManejoInventarioAnual: serializer.fromJson<double>(
        json['tasaManejoInventarioAnual'],
      ),
      valorPorUnidadCent: serializer.fromJson<int>(json['valorPorUnidadCent']),
      inventarioBaseUnaUbicacion: serializer.fromJson<double>(
        json['inventarioBaseUnaUbicacion'],
      ),
      costoPorPedidoCent: serializer.fromJson<int>(json['costoPorPedidoCent']),
      tipoEstandar: serializer.fromJson<String>(json['tipoEstandar']),
      estandarServicioValor: serializer.fromJson<int>(
        json['estandarServicioValor'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'proyectoId': serializer.toJson<int>(proyectoId),
      'tarifaEntradaFijaCent': serializer.toJson<int>(tarifaEntradaFijaCent),
      'tarifaEntradaCentPorKmTon': serializer.toJson<int>(
        tarifaEntradaCentPorKmTon,
      ),
      'tarifaSalidaFijaCent': serializer.toJson<int>(tarifaSalidaFijaCent),
      'tarifaSalidaCentPorKmTon': serializer.toJson<int>(
        tarifaSalidaCentPorKmTon,
      ),
      'tasaManejoInventarioAnual': serializer.toJson<double>(
        tasaManejoInventarioAnual,
      ),
      'valorPorUnidadCent': serializer.toJson<int>(valorPorUnidadCent),
      'inventarioBaseUnaUbicacion': serializer.toJson<double>(
        inventarioBaseUnaUbicacion,
      ),
      'costoPorPedidoCent': serializer.toJson<int>(costoPorPedidoCent),
      'tipoEstandar': serializer.toJson<String>(tipoEstandar),
      'estandarServicioValor': serializer.toJson<int>(estandarServicioValor),
    };
  }

  ParametrosCostoTableData copyWith({
    int? id,
    int? proyectoId,
    int? tarifaEntradaFijaCent,
    int? tarifaEntradaCentPorKmTon,
    int? tarifaSalidaFijaCent,
    int? tarifaSalidaCentPorKmTon,
    double? tasaManejoInventarioAnual,
    int? valorPorUnidadCent,
    double? inventarioBaseUnaUbicacion,
    int? costoPorPedidoCent,
    String? tipoEstandar,
    int? estandarServicioValor,
  }) => ParametrosCostoTableData(
    id: id ?? this.id,
    proyectoId: proyectoId ?? this.proyectoId,
    tarifaEntradaFijaCent: tarifaEntradaFijaCent ?? this.tarifaEntradaFijaCent,
    tarifaEntradaCentPorKmTon:
        tarifaEntradaCentPorKmTon ?? this.tarifaEntradaCentPorKmTon,
    tarifaSalidaFijaCent: tarifaSalidaFijaCent ?? this.tarifaSalidaFijaCent,
    tarifaSalidaCentPorKmTon:
        tarifaSalidaCentPorKmTon ?? this.tarifaSalidaCentPorKmTon,
    tasaManejoInventarioAnual:
        tasaManejoInventarioAnual ?? this.tasaManejoInventarioAnual,
    valorPorUnidadCent: valorPorUnidadCent ?? this.valorPorUnidadCent,
    inventarioBaseUnaUbicacion:
        inventarioBaseUnaUbicacion ?? this.inventarioBaseUnaUbicacion,
    costoPorPedidoCent: costoPorPedidoCent ?? this.costoPorPedidoCent,
    tipoEstandar: tipoEstandar ?? this.tipoEstandar,
    estandarServicioValor: estandarServicioValor ?? this.estandarServicioValor,
  );
  ParametrosCostoTableData copyWithCompanion(
    ParametrosCostoTableCompanion data,
  ) {
    return ParametrosCostoTableData(
      id: data.id.present ? data.id.value : this.id,
      proyectoId: data.proyectoId.present
          ? data.proyectoId.value
          : this.proyectoId,
      tarifaEntradaFijaCent: data.tarifaEntradaFijaCent.present
          ? data.tarifaEntradaFijaCent.value
          : this.tarifaEntradaFijaCent,
      tarifaEntradaCentPorKmTon: data.tarifaEntradaCentPorKmTon.present
          ? data.tarifaEntradaCentPorKmTon.value
          : this.tarifaEntradaCentPorKmTon,
      tarifaSalidaFijaCent: data.tarifaSalidaFijaCent.present
          ? data.tarifaSalidaFijaCent.value
          : this.tarifaSalidaFijaCent,
      tarifaSalidaCentPorKmTon: data.tarifaSalidaCentPorKmTon.present
          ? data.tarifaSalidaCentPorKmTon.value
          : this.tarifaSalidaCentPorKmTon,
      tasaManejoInventarioAnual: data.tasaManejoInventarioAnual.present
          ? data.tasaManejoInventarioAnual.value
          : this.tasaManejoInventarioAnual,
      valorPorUnidadCent: data.valorPorUnidadCent.present
          ? data.valorPorUnidadCent.value
          : this.valorPorUnidadCent,
      inventarioBaseUnaUbicacion: data.inventarioBaseUnaUbicacion.present
          ? data.inventarioBaseUnaUbicacion.value
          : this.inventarioBaseUnaUbicacion,
      costoPorPedidoCent: data.costoPorPedidoCent.present
          ? data.costoPorPedidoCent.value
          : this.costoPorPedidoCent,
      tipoEstandar: data.tipoEstandar.present
          ? data.tipoEstandar.value
          : this.tipoEstandar,
      estandarServicioValor: data.estandarServicioValor.present
          ? data.estandarServicioValor.value
          : this.estandarServicioValor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ParametrosCostoTableData(')
          ..write('id: $id, ')
          ..write('proyectoId: $proyectoId, ')
          ..write('tarifaEntradaFijaCent: $tarifaEntradaFijaCent, ')
          ..write('tarifaEntradaCentPorKmTon: $tarifaEntradaCentPorKmTon, ')
          ..write('tarifaSalidaFijaCent: $tarifaSalidaFijaCent, ')
          ..write('tarifaSalidaCentPorKmTon: $tarifaSalidaCentPorKmTon, ')
          ..write('tasaManejoInventarioAnual: $tasaManejoInventarioAnual, ')
          ..write('valorPorUnidadCent: $valorPorUnidadCent, ')
          ..write('inventarioBaseUnaUbicacion: $inventarioBaseUnaUbicacion, ')
          ..write('costoPorPedidoCent: $costoPorPedidoCent, ')
          ..write('tipoEstandar: $tipoEstandar, ')
          ..write('estandarServicioValor: $estandarServicioValor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    proyectoId,
    tarifaEntradaFijaCent,
    tarifaEntradaCentPorKmTon,
    tarifaSalidaFijaCent,
    tarifaSalidaCentPorKmTon,
    tasaManejoInventarioAnual,
    valorPorUnidadCent,
    inventarioBaseUnaUbicacion,
    costoPorPedidoCent,
    tipoEstandar,
    estandarServicioValor,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ParametrosCostoTableData &&
          other.id == this.id &&
          other.proyectoId == this.proyectoId &&
          other.tarifaEntradaFijaCent == this.tarifaEntradaFijaCent &&
          other.tarifaEntradaCentPorKmTon == this.tarifaEntradaCentPorKmTon &&
          other.tarifaSalidaFijaCent == this.tarifaSalidaFijaCent &&
          other.tarifaSalidaCentPorKmTon == this.tarifaSalidaCentPorKmTon &&
          other.tasaManejoInventarioAnual == this.tasaManejoInventarioAnual &&
          other.valorPorUnidadCent == this.valorPorUnidadCent &&
          other.inventarioBaseUnaUbicacion == this.inventarioBaseUnaUbicacion &&
          other.costoPorPedidoCent == this.costoPorPedidoCent &&
          other.tipoEstandar == this.tipoEstandar &&
          other.estandarServicioValor == this.estandarServicioValor);
}

class ParametrosCostoTableCompanion
    extends UpdateCompanion<ParametrosCostoTableData> {
  final Value<int> id;
  final Value<int> proyectoId;
  final Value<int> tarifaEntradaFijaCent;
  final Value<int> tarifaEntradaCentPorKmTon;
  final Value<int> tarifaSalidaFijaCent;
  final Value<int> tarifaSalidaCentPorKmTon;
  final Value<double> tasaManejoInventarioAnual;
  final Value<int> valorPorUnidadCent;
  final Value<double> inventarioBaseUnaUbicacion;
  final Value<int> costoPorPedidoCent;
  final Value<String> tipoEstandar;
  final Value<int> estandarServicioValor;
  const ParametrosCostoTableCompanion({
    this.id = const Value.absent(),
    this.proyectoId = const Value.absent(),
    this.tarifaEntradaFijaCent = const Value.absent(),
    this.tarifaEntradaCentPorKmTon = const Value.absent(),
    this.tarifaSalidaFijaCent = const Value.absent(),
    this.tarifaSalidaCentPorKmTon = const Value.absent(),
    this.tasaManejoInventarioAnual = const Value.absent(),
    this.valorPorUnidadCent = const Value.absent(),
    this.inventarioBaseUnaUbicacion = const Value.absent(),
    this.costoPorPedidoCent = const Value.absent(),
    this.tipoEstandar = const Value.absent(),
    this.estandarServicioValor = const Value.absent(),
  });
  ParametrosCostoTableCompanion.insert({
    this.id = const Value.absent(),
    required int proyectoId,
    required int tarifaEntradaFijaCent,
    required int tarifaEntradaCentPorKmTon,
    required int tarifaSalidaFijaCent,
    required int tarifaSalidaCentPorKmTon,
    required double tasaManejoInventarioAnual,
    required int valorPorUnidadCent,
    required double inventarioBaseUnaUbicacion,
    required int costoPorPedidoCent,
    required String tipoEstandar,
    required int estandarServicioValor,
  }) : proyectoId = Value(proyectoId),
       tarifaEntradaFijaCent = Value(tarifaEntradaFijaCent),
       tarifaEntradaCentPorKmTon = Value(tarifaEntradaCentPorKmTon),
       tarifaSalidaFijaCent = Value(tarifaSalidaFijaCent),
       tarifaSalidaCentPorKmTon = Value(tarifaSalidaCentPorKmTon),
       tasaManejoInventarioAnual = Value(tasaManejoInventarioAnual),
       valorPorUnidadCent = Value(valorPorUnidadCent),
       inventarioBaseUnaUbicacion = Value(inventarioBaseUnaUbicacion),
       costoPorPedidoCent = Value(costoPorPedidoCent),
       tipoEstandar = Value(tipoEstandar),
       estandarServicioValor = Value(estandarServicioValor);
  static Insertable<ParametrosCostoTableData> custom({
    Expression<int>? id,
    Expression<int>? proyectoId,
    Expression<int>? tarifaEntradaFijaCent,
    Expression<int>? tarifaEntradaCentPorKmTon,
    Expression<int>? tarifaSalidaFijaCent,
    Expression<int>? tarifaSalidaCentPorKmTon,
    Expression<double>? tasaManejoInventarioAnual,
    Expression<int>? valorPorUnidadCent,
    Expression<double>? inventarioBaseUnaUbicacion,
    Expression<int>? costoPorPedidoCent,
    Expression<String>? tipoEstandar,
    Expression<int>? estandarServicioValor,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (proyectoId != null) 'proyecto_id': proyectoId,
      if (tarifaEntradaFijaCent != null)
        'tarifa_entrada_fija_cent': tarifaEntradaFijaCent,
      if (tarifaEntradaCentPorKmTon != null)
        'tarifa_entrada_cent_por_km_ton': tarifaEntradaCentPorKmTon,
      if (tarifaSalidaFijaCent != null)
        'tarifa_salida_fija_cent': tarifaSalidaFijaCent,
      if (tarifaSalidaCentPorKmTon != null)
        'tarifa_salida_cent_por_km_ton': tarifaSalidaCentPorKmTon,
      if (tasaManejoInventarioAnual != null)
        'tasa_manejo_inventario_anual': tasaManejoInventarioAnual,
      if (valorPorUnidadCent != null)
        'valor_por_unidad_cent': valorPorUnidadCent,
      if (inventarioBaseUnaUbicacion != null)
        'inventario_base_una_ubicacion': inventarioBaseUnaUbicacion,
      if (costoPorPedidoCent != null)
        'costo_por_pedido_cent': costoPorPedidoCent,
      if (tipoEstandar != null) 'tipo_estandar': tipoEstandar,
      if (estandarServicioValor != null)
        'estandar_servicio_valor': estandarServicioValor,
    });
  }

  ParametrosCostoTableCompanion copyWith({
    Value<int>? id,
    Value<int>? proyectoId,
    Value<int>? tarifaEntradaFijaCent,
    Value<int>? tarifaEntradaCentPorKmTon,
    Value<int>? tarifaSalidaFijaCent,
    Value<int>? tarifaSalidaCentPorKmTon,
    Value<double>? tasaManejoInventarioAnual,
    Value<int>? valorPorUnidadCent,
    Value<double>? inventarioBaseUnaUbicacion,
    Value<int>? costoPorPedidoCent,
    Value<String>? tipoEstandar,
    Value<int>? estandarServicioValor,
  }) {
    return ParametrosCostoTableCompanion(
      id: id ?? this.id,
      proyectoId: proyectoId ?? this.proyectoId,
      tarifaEntradaFijaCent:
          tarifaEntradaFijaCent ?? this.tarifaEntradaFijaCent,
      tarifaEntradaCentPorKmTon:
          tarifaEntradaCentPorKmTon ?? this.tarifaEntradaCentPorKmTon,
      tarifaSalidaFijaCent: tarifaSalidaFijaCent ?? this.tarifaSalidaFijaCent,
      tarifaSalidaCentPorKmTon:
          tarifaSalidaCentPorKmTon ?? this.tarifaSalidaCentPorKmTon,
      tasaManejoInventarioAnual:
          tasaManejoInventarioAnual ?? this.tasaManejoInventarioAnual,
      valorPorUnidadCent: valorPorUnidadCent ?? this.valorPorUnidadCent,
      inventarioBaseUnaUbicacion:
          inventarioBaseUnaUbicacion ?? this.inventarioBaseUnaUbicacion,
      costoPorPedidoCent: costoPorPedidoCent ?? this.costoPorPedidoCent,
      tipoEstandar: tipoEstandar ?? this.tipoEstandar,
      estandarServicioValor:
          estandarServicioValor ?? this.estandarServicioValor,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (proyectoId.present) {
      map['proyecto_id'] = Variable<int>(proyectoId.value);
    }
    if (tarifaEntradaFijaCent.present) {
      map['tarifa_entrada_fija_cent'] = Variable<int>(
        tarifaEntradaFijaCent.value,
      );
    }
    if (tarifaEntradaCentPorKmTon.present) {
      map['tarifa_entrada_cent_por_km_ton'] = Variable<int>(
        tarifaEntradaCentPorKmTon.value,
      );
    }
    if (tarifaSalidaFijaCent.present) {
      map['tarifa_salida_fija_cent'] = Variable<int>(
        tarifaSalidaFijaCent.value,
      );
    }
    if (tarifaSalidaCentPorKmTon.present) {
      map['tarifa_salida_cent_por_km_ton'] = Variable<int>(
        tarifaSalidaCentPorKmTon.value,
      );
    }
    if (tasaManejoInventarioAnual.present) {
      map['tasa_manejo_inventario_anual'] = Variable<double>(
        tasaManejoInventarioAnual.value,
      );
    }
    if (valorPorUnidadCent.present) {
      map['valor_por_unidad_cent'] = Variable<int>(valorPorUnidadCent.value);
    }
    if (inventarioBaseUnaUbicacion.present) {
      map['inventario_base_una_ubicacion'] = Variable<double>(
        inventarioBaseUnaUbicacion.value,
      );
    }
    if (costoPorPedidoCent.present) {
      map['costo_por_pedido_cent'] = Variable<int>(costoPorPedidoCent.value);
    }
    if (tipoEstandar.present) {
      map['tipo_estandar'] = Variable<String>(tipoEstandar.value);
    }
    if (estandarServicioValor.present) {
      map['estandar_servicio_valor'] = Variable<int>(
        estandarServicioValor.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ParametrosCostoTableCompanion(')
          ..write('id: $id, ')
          ..write('proyectoId: $proyectoId, ')
          ..write('tarifaEntradaFijaCent: $tarifaEntradaFijaCent, ')
          ..write('tarifaEntradaCentPorKmTon: $tarifaEntradaCentPorKmTon, ')
          ..write('tarifaSalidaFijaCent: $tarifaSalidaFijaCent, ')
          ..write('tarifaSalidaCentPorKmTon: $tarifaSalidaCentPorKmTon, ')
          ..write('tasaManejoInventarioAnual: $tasaManejoInventarioAnual, ')
          ..write('valorPorUnidadCent: $valorPorUnidadCent, ')
          ..write('inventarioBaseUnaUbicacion: $inventarioBaseUnaUbicacion, ')
          ..write('costoPorPedidoCent: $costoPorPedidoCent, ')
          ..write('tipoEstandar: $tipoEstandar, ')
          ..write('estandarServicioValor: $estandarServicioValor')
          ..write(')'))
        .toString();
  }
}

class $CeldaMatrizTableTable extends CeldaMatrizTable
    with TableInfo<$CeldaMatrizTableTable, CeldaMatrizTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CeldaMatrizTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _proyectoIdMeta = const VerificationMeta(
    'proyectoId',
  );
  @override
  late final GeneratedColumn<int> proyectoId = GeneratedColumn<int>(
    'proyecto_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES proyecto (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _tipoOrigenMeta = const VerificationMeta(
    'tipoOrigen',
  );
  @override
  late final GeneratedColumn<String> tipoOrigen = GeneratedColumn<String>(
    'tipo_origen',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _origenIdMeta = const VerificationMeta(
    'origenId',
  );
  @override
  late final GeneratedColumn<int> origenId = GeneratedColumn<int>(
    'origen_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipoDestinoMeta = const VerificationMeta(
    'tipoDestino',
  );
  @override
  late final GeneratedColumn<String> tipoDestino = GeneratedColumn<String>(
    'tipo_destino',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _destinoIdMeta = const VerificationMeta(
    'destinoId',
  );
  @override
  late final GeneratedColumn<int> destinoId = GeneratedColumn<int>(
    'destino_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _distanciaMetrosMeta = const VerificationMeta(
    'distanciaMetros',
  );
  @override
  late final GeneratedColumn<int> distanciaMetros = GeneratedColumn<int>(
    'distancia_metros',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _duracionSegundosMeta = const VerificationMeta(
    'duracionSegundos',
  );
  @override
  late final GeneratedColumn<int> duracionSegundos = GeneratedColumn<int>(
    'duracion_segundos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fuenteMeta = const VerificationMeta('fuente');
  @override
  late final GeneratedColumn<String> fuente = GeneratedColumn<String>(
    'fuente',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    proyectoId,
    tipoOrigen,
    origenId,
    tipoDestino,
    destinoId,
    distanciaMetros,
    duracionSegundos,
    fuente,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'celda_matriz';
  @override
  VerificationContext validateIntegrity(
    Insertable<CeldaMatrizTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('proyecto_id')) {
      context.handle(
        _proyectoIdMeta,
        proyectoId.isAcceptableOrUnknown(data['proyecto_id']!, _proyectoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_proyectoIdMeta);
    }
    if (data.containsKey('tipo_origen')) {
      context.handle(
        _tipoOrigenMeta,
        tipoOrigen.isAcceptableOrUnknown(data['tipo_origen']!, _tipoOrigenMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoOrigenMeta);
    }
    if (data.containsKey('origen_id')) {
      context.handle(
        _origenIdMeta,
        origenId.isAcceptableOrUnknown(data['origen_id']!, _origenIdMeta),
      );
    } else if (isInserting) {
      context.missing(_origenIdMeta);
    }
    if (data.containsKey('tipo_destino')) {
      context.handle(
        _tipoDestinoMeta,
        tipoDestino.isAcceptableOrUnknown(
          data['tipo_destino']!,
          _tipoDestinoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tipoDestinoMeta);
    }
    if (data.containsKey('destino_id')) {
      context.handle(
        _destinoIdMeta,
        destinoId.isAcceptableOrUnknown(data['destino_id']!, _destinoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_destinoIdMeta);
    }
    if (data.containsKey('distancia_metros')) {
      context.handle(
        _distanciaMetrosMeta,
        distanciaMetros.isAcceptableOrUnknown(
          data['distancia_metros']!,
          _distanciaMetrosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_distanciaMetrosMeta);
    }
    if (data.containsKey('duracion_segundos')) {
      context.handle(
        _duracionSegundosMeta,
        duracionSegundos.isAcceptableOrUnknown(
          data['duracion_segundos']!,
          _duracionSegundosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_duracionSegundosMeta);
    }
    if (data.containsKey('fuente')) {
      context.handle(
        _fuenteMeta,
        fuente.isAcceptableOrUnknown(data['fuente']!, _fuenteMeta),
      );
    } else if (isInserting) {
      context.missing(_fuenteMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {proyectoId, tipoOrigen, origenId, tipoDestino, destinoId},
  ];
  @override
  CeldaMatrizTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CeldaMatrizTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      proyectoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}proyecto_id'],
      )!,
      tipoOrigen: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo_origen'],
      )!,
      origenId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}origen_id'],
      )!,
      tipoDestino: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo_destino'],
      )!,
      destinoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}destino_id'],
      )!,
      distanciaMetros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}distancia_metros'],
      )!,
      duracionSegundos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duracion_segundos'],
      )!,
      fuente: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fuente'],
      )!,
    );
  }

  @override
  $CeldaMatrizTableTable createAlias(String alias) {
    return $CeldaMatrizTableTable(attachedDatabase, alias);
  }
}

class CeldaMatrizTableData extends DataClass
    implements Insertable<CeldaMatrizTableData> {
  final int id;
  final int proyectoId;
  final String tipoOrigen;
  final int origenId;
  final String tipoDestino;
  final int destinoId;
  final int distanciaMetros;
  final int duracionSegundos;
  final String fuente;
  const CeldaMatrizTableData({
    required this.id,
    required this.proyectoId,
    required this.tipoOrigen,
    required this.origenId,
    required this.tipoDestino,
    required this.destinoId,
    required this.distanciaMetros,
    required this.duracionSegundos,
    required this.fuente,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['proyecto_id'] = Variable<int>(proyectoId);
    map['tipo_origen'] = Variable<String>(tipoOrigen);
    map['origen_id'] = Variable<int>(origenId);
    map['tipo_destino'] = Variable<String>(tipoDestino);
    map['destino_id'] = Variable<int>(destinoId);
    map['distancia_metros'] = Variable<int>(distanciaMetros);
    map['duracion_segundos'] = Variable<int>(duracionSegundos);
    map['fuente'] = Variable<String>(fuente);
    return map;
  }

  CeldaMatrizTableCompanion toCompanion(bool nullToAbsent) {
    return CeldaMatrizTableCompanion(
      id: Value(id),
      proyectoId: Value(proyectoId),
      tipoOrigen: Value(tipoOrigen),
      origenId: Value(origenId),
      tipoDestino: Value(tipoDestino),
      destinoId: Value(destinoId),
      distanciaMetros: Value(distanciaMetros),
      duracionSegundos: Value(duracionSegundos),
      fuente: Value(fuente),
    );
  }

  factory CeldaMatrizTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CeldaMatrizTableData(
      id: serializer.fromJson<int>(json['id']),
      proyectoId: serializer.fromJson<int>(json['proyectoId']),
      tipoOrigen: serializer.fromJson<String>(json['tipoOrigen']),
      origenId: serializer.fromJson<int>(json['origenId']),
      tipoDestino: serializer.fromJson<String>(json['tipoDestino']),
      destinoId: serializer.fromJson<int>(json['destinoId']),
      distanciaMetros: serializer.fromJson<int>(json['distanciaMetros']),
      duracionSegundos: serializer.fromJson<int>(json['duracionSegundos']),
      fuente: serializer.fromJson<String>(json['fuente']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'proyectoId': serializer.toJson<int>(proyectoId),
      'tipoOrigen': serializer.toJson<String>(tipoOrigen),
      'origenId': serializer.toJson<int>(origenId),
      'tipoDestino': serializer.toJson<String>(tipoDestino),
      'destinoId': serializer.toJson<int>(destinoId),
      'distanciaMetros': serializer.toJson<int>(distanciaMetros),
      'duracionSegundos': serializer.toJson<int>(duracionSegundos),
      'fuente': serializer.toJson<String>(fuente),
    };
  }

  CeldaMatrizTableData copyWith({
    int? id,
    int? proyectoId,
    String? tipoOrigen,
    int? origenId,
    String? tipoDestino,
    int? destinoId,
    int? distanciaMetros,
    int? duracionSegundos,
    String? fuente,
  }) => CeldaMatrizTableData(
    id: id ?? this.id,
    proyectoId: proyectoId ?? this.proyectoId,
    tipoOrigen: tipoOrigen ?? this.tipoOrigen,
    origenId: origenId ?? this.origenId,
    tipoDestino: tipoDestino ?? this.tipoDestino,
    destinoId: destinoId ?? this.destinoId,
    distanciaMetros: distanciaMetros ?? this.distanciaMetros,
    duracionSegundos: duracionSegundos ?? this.duracionSegundos,
    fuente: fuente ?? this.fuente,
  );
  CeldaMatrizTableData copyWithCompanion(CeldaMatrizTableCompanion data) {
    return CeldaMatrizTableData(
      id: data.id.present ? data.id.value : this.id,
      proyectoId: data.proyectoId.present
          ? data.proyectoId.value
          : this.proyectoId,
      tipoOrigen: data.tipoOrigen.present
          ? data.tipoOrigen.value
          : this.tipoOrigen,
      origenId: data.origenId.present ? data.origenId.value : this.origenId,
      tipoDestino: data.tipoDestino.present
          ? data.tipoDestino.value
          : this.tipoDestino,
      destinoId: data.destinoId.present ? data.destinoId.value : this.destinoId,
      distanciaMetros: data.distanciaMetros.present
          ? data.distanciaMetros.value
          : this.distanciaMetros,
      duracionSegundos: data.duracionSegundos.present
          ? data.duracionSegundos.value
          : this.duracionSegundos,
      fuente: data.fuente.present ? data.fuente.value : this.fuente,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CeldaMatrizTableData(')
          ..write('id: $id, ')
          ..write('proyectoId: $proyectoId, ')
          ..write('tipoOrigen: $tipoOrigen, ')
          ..write('origenId: $origenId, ')
          ..write('tipoDestino: $tipoDestino, ')
          ..write('destinoId: $destinoId, ')
          ..write('distanciaMetros: $distanciaMetros, ')
          ..write('duracionSegundos: $duracionSegundos, ')
          ..write('fuente: $fuente')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    proyectoId,
    tipoOrigen,
    origenId,
    tipoDestino,
    destinoId,
    distanciaMetros,
    duracionSegundos,
    fuente,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CeldaMatrizTableData &&
          other.id == this.id &&
          other.proyectoId == this.proyectoId &&
          other.tipoOrigen == this.tipoOrigen &&
          other.origenId == this.origenId &&
          other.tipoDestino == this.tipoDestino &&
          other.destinoId == this.destinoId &&
          other.distanciaMetros == this.distanciaMetros &&
          other.duracionSegundos == this.duracionSegundos &&
          other.fuente == this.fuente);
}

class CeldaMatrizTableCompanion extends UpdateCompanion<CeldaMatrizTableData> {
  final Value<int> id;
  final Value<int> proyectoId;
  final Value<String> tipoOrigen;
  final Value<int> origenId;
  final Value<String> tipoDestino;
  final Value<int> destinoId;
  final Value<int> distanciaMetros;
  final Value<int> duracionSegundos;
  final Value<String> fuente;
  const CeldaMatrizTableCompanion({
    this.id = const Value.absent(),
    this.proyectoId = const Value.absent(),
    this.tipoOrigen = const Value.absent(),
    this.origenId = const Value.absent(),
    this.tipoDestino = const Value.absent(),
    this.destinoId = const Value.absent(),
    this.distanciaMetros = const Value.absent(),
    this.duracionSegundos = const Value.absent(),
    this.fuente = const Value.absent(),
  });
  CeldaMatrizTableCompanion.insert({
    this.id = const Value.absent(),
    required int proyectoId,
    required String tipoOrigen,
    required int origenId,
    required String tipoDestino,
    required int destinoId,
    required int distanciaMetros,
    required int duracionSegundos,
    required String fuente,
  }) : proyectoId = Value(proyectoId),
       tipoOrigen = Value(tipoOrigen),
       origenId = Value(origenId),
       tipoDestino = Value(tipoDestino),
       destinoId = Value(destinoId),
       distanciaMetros = Value(distanciaMetros),
       duracionSegundos = Value(duracionSegundos),
       fuente = Value(fuente);
  static Insertable<CeldaMatrizTableData> custom({
    Expression<int>? id,
    Expression<int>? proyectoId,
    Expression<String>? tipoOrigen,
    Expression<int>? origenId,
    Expression<String>? tipoDestino,
    Expression<int>? destinoId,
    Expression<int>? distanciaMetros,
    Expression<int>? duracionSegundos,
    Expression<String>? fuente,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (proyectoId != null) 'proyecto_id': proyectoId,
      if (tipoOrigen != null) 'tipo_origen': tipoOrigen,
      if (origenId != null) 'origen_id': origenId,
      if (tipoDestino != null) 'tipo_destino': tipoDestino,
      if (destinoId != null) 'destino_id': destinoId,
      if (distanciaMetros != null) 'distancia_metros': distanciaMetros,
      if (duracionSegundos != null) 'duracion_segundos': duracionSegundos,
      if (fuente != null) 'fuente': fuente,
    });
  }

  CeldaMatrizTableCompanion copyWith({
    Value<int>? id,
    Value<int>? proyectoId,
    Value<String>? tipoOrigen,
    Value<int>? origenId,
    Value<String>? tipoDestino,
    Value<int>? destinoId,
    Value<int>? distanciaMetros,
    Value<int>? duracionSegundos,
    Value<String>? fuente,
  }) {
    return CeldaMatrizTableCompanion(
      id: id ?? this.id,
      proyectoId: proyectoId ?? this.proyectoId,
      tipoOrigen: tipoOrigen ?? this.tipoOrigen,
      origenId: origenId ?? this.origenId,
      tipoDestino: tipoDestino ?? this.tipoDestino,
      destinoId: destinoId ?? this.destinoId,
      distanciaMetros: distanciaMetros ?? this.distanciaMetros,
      duracionSegundos: duracionSegundos ?? this.duracionSegundos,
      fuente: fuente ?? this.fuente,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (proyectoId.present) {
      map['proyecto_id'] = Variable<int>(proyectoId.value);
    }
    if (tipoOrigen.present) {
      map['tipo_origen'] = Variable<String>(tipoOrigen.value);
    }
    if (origenId.present) {
      map['origen_id'] = Variable<int>(origenId.value);
    }
    if (tipoDestino.present) {
      map['tipo_destino'] = Variable<String>(tipoDestino.value);
    }
    if (destinoId.present) {
      map['destino_id'] = Variable<int>(destinoId.value);
    }
    if (distanciaMetros.present) {
      map['distancia_metros'] = Variable<int>(distanciaMetros.value);
    }
    if (duracionSegundos.present) {
      map['duracion_segundos'] = Variable<int>(duracionSegundos.value);
    }
    if (fuente.present) {
      map['fuente'] = Variable<String>(fuente.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CeldaMatrizTableCompanion(')
          ..write('id: $id, ')
          ..write('proyectoId: $proyectoId, ')
          ..write('tipoOrigen: $tipoOrigen, ')
          ..write('origenId: $origenId, ')
          ..write('tipoDestino: $tipoDestino, ')
          ..write('destinoId: $destinoId, ')
          ..write('distanciaMetros: $distanciaMetros, ')
          ..write('duracionSegundos: $duracionSegundos, ')
          ..write('fuente: $fuente')
          ..write(')'))
        .toString();
  }
}

class $CacheRuteoTableTable extends CacheRuteoTable
    with TableInfo<$CacheRuteoTableTable, CacheRuteoTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CacheRuteoTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _hashConsultaMeta = const VerificationMeta(
    'hashConsulta',
  );
  @override
  late final GeneratedColumn<String> hashConsulta = GeneratedColumn<String>(
    'hash_consulta',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _respuestaJsonMeta = const VerificationMeta(
    'respuestaJson',
  );
  @override
  late final GeneratedColumn<String> respuestaJson = GeneratedColumn<String>(
    'respuesta_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaConsultaMeta = const VerificationMeta(
    'fechaConsulta',
  );
  @override
  late final GeneratedColumn<String> fechaConsulta = GeneratedColumn<String>(
    'fecha_consulta',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    hashConsulta,
    tipo,
    respuestaJson,
    fechaConsulta,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cache_ruteo';
  @override
  VerificationContext validateIntegrity(
    Insertable<CacheRuteoTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('hash_consulta')) {
      context.handle(
        _hashConsultaMeta,
        hashConsulta.isAcceptableOrUnknown(
          data['hash_consulta']!,
          _hashConsultaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hashConsultaMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('respuesta_json')) {
      context.handle(
        _respuestaJsonMeta,
        respuestaJson.isAcceptableOrUnknown(
          data['respuesta_json']!,
          _respuestaJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_respuestaJsonMeta);
    }
    if (data.containsKey('fecha_consulta')) {
      context.handle(
        _fechaConsultaMeta,
        fechaConsulta.isAcceptableOrUnknown(
          data['fecha_consulta']!,
          _fechaConsultaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaConsultaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {hashConsulta};
  @override
  CacheRuteoTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CacheRuteoTableData(
      hashConsulta: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hash_consulta'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      respuestaJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}respuesta_json'],
      )!,
      fechaConsulta: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fecha_consulta'],
      )!,
    );
  }

  @override
  $CacheRuteoTableTable createAlias(String alias) {
    return $CacheRuteoTableTable(attachedDatabase, alias);
  }
}

class CacheRuteoTableData extends DataClass
    implements Insertable<CacheRuteoTableData> {
  final String hashConsulta;
  final String tipo;
  final String respuestaJson;
  final String fechaConsulta;
  const CacheRuteoTableData({
    required this.hashConsulta,
    required this.tipo,
    required this.respuestaJson,
    required this.fechaConsulta,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['hash_consulta'] = Variable<String>(hashConsulta);
    map['tipo'] = Variable<String>(tipo);
    map['respuesta_json'] = Variable<String>(respuestaJson);
    map['fecha_consulta'] = Variable<String>(fechaConsulta);
    return map;
  }

  CacheRuteoTableCompanion toCompanion(bool nullToAbsent) {
    return CacheRuteoTableCompanion(
      hashConsulta: Value(hashConsulta),
      tipo: Value(tipo),
      respuestaJson: Value(respuestaJson),
      fechaConsulta: Value(fechaConsulta),
    );
  }

  factory CacheRuteoTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CacheRuteoTableData(
      hashConsulta: serializer.fromJson<String>(json['hashConsulta']),
      tipo: serializer.fromJson<String>(json['tipo']),
      respuestaJson: serializer.fromJson<String>(json['respuestaJson']),
      fechaConsulta: serializer.fromJson<String>(json['fechaConsulta']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'hashConsulta': serializer.toJson<String>(hashConsulta),
      'tipo': serializer.toJson<String>(tipo),
      'respuestaJson': serializer.toJson<String>(respuestaJson),
      'fechaConsulta': serializer.toJson<String>(fechaConsulta),
    };
  }

  CacheRuteoTableData copyWith({
    String? hashConsulta,
    String? tipo,
    String? respuestaJson,
    String? fechaConsulta,
  }) => CacheRuteoTableData(
    hashConsulta: hashConsulta ?? this.hashConsulta,
    tipo: tipo ?? this.tipo,
    respuestaJson: respuestaJson ?? this.respuestaJson,
    fechaConsulta: fechaConsulta ?? this.fechaConsulta,
  );
  CacheRuteoTableData copyWithCompanion(CacheRuteoTableCompanion data) {
    return CacheRuteoTableData(
      hashConsulta: data.hashConsulta.present
          ? data.hashConsulta.value
          : this.hashConsulta,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      respuestaJson: data.respuestaJson.present
          ? data.respuestaJson.value
          : this.respuestaJson,
      fechaConsulta: data.fechaConsulta.present
          ? data.fechaConsulta.value
          : this.fechaConsulta,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CacheRuteoTableData(')
          ..write('hashConsulta: $hashConsulta, ')
          ..write('tipo: $tipo, ')
          ..write('respuestaJson: $respuestaJson, ')
          ..write('fechaConsulta: $fechaConsulta')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(hashConsulta, tipo, respuestaJson, fechaConsulta);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CacheRuteoTableData &&
          other.hashConsulta == this.hashConsulta &&
          other.tipo == this.tipo &&
          other.respuestaJson == this.respuestaJson &&
          other.fechaConsulta == this.fechaConsulta);
}

class CacheRuteoTableCompanion extends UpdateCompanion<CacheRuteoTableData> {
  final Value<String> hashConsulta;
  final Value<String> tipo;
  final Value<String> respuestaJson;
  final Value<String> fechaConsulta;
  final Value<int> rowid;
  const CacheRuteoTableCompanion({
    this.hashConsulta = const Value.absent(),
    this.tipo = const Value.absent(),
    this.respuestaJson = const Value.absent(),
    this.fechaConsulta = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CacheRuteoTableCompanion.insert({
    required String hashConsulta,
    required String tipo,
    required String respuestaJson,
    required String fechaConsulta,
    this.rowid = const Value.absent(),
  }) : hashConsulta = Value(hashConsulta),
       tipo = Value(tipo),
       respuestaJson = Value(respuestaJson),
       fechaConsulta = Value(fechaConsulta);
  static Insertable<CacheRuteoTableData> custom({
    Expression<String>? hashConsulta,
    Expression<String>? tipo,
    Expression<String>? respuestaJson,
    Expression<String>? fechaConsulta,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (hashConsulta != null) 'hash_consulta': hashConsulta,
      if (tipo != null) 'tipo': tipo,
      if (respuestaJson != null) 'respuesta_json': respuestaJson,
      if (fechaConsulta != null) 'fecha_consulta': fechaConsulta,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CacheRuteoTableCompanion copyWith({
    Value<String>? hashConsulta,
    Value<String>? tipo,
    Value<String>? respuestaJson,
    Value<String>? fechaConsulta,
    Value<int>? rowid,
  }) {
    return CacheRuteoTableCompanion(
      hashConsulta: hashConsulta ?? this.hashConsulta,
      tipo: tipo ?? this.tipo,
      respuestaJson: respuestaJson ?? this.respuestaJson,
      fechaConsulta: fechaConsulta ?? this.fechaConsulta,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (hashConsulta.present) {
      map['hash_consulta'] = Variable<String>(hashConsulta.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (respuestaJson.present) {
      map['respuesta_json'] = Variable<String>(respuestaJson.value);
    }
    if (fechaConsulta.present) {
      map['fecha_consulta'] = Variable<String>(fechaConsulta.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CacheRuteoTableCompanion(')
          ..write('hashConsulta: $hashConsulta, ')
          ..write('tipo: $tipo, ')
          ..write('respuestaJson: $respuestaJson, ')
          ..write('fechaConsulta: $fechaConsulta, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EscenarioTableTable extends EscenarioTable
    with TableInfo<$EscenarioTableTable, EscenarioTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EscenarioTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _proyectoIdMeta = const VerificationMeta(
    'proyectoId',
  );
  @override
  late final GeneratedColumn<int> proyectoId = GeneratedColumn<int>(
    'proyecto_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES proyecto (id) ON DELETE CASCADE',
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
  static const VerificationMeta _metodoMeta = const VerificationMeta('metodo');
  @override
  late final GeneratedColumn<String> metodo = GeneratedColumn<String>(
    'metodo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pFijoMeta = const VerificationMeta('pFijo');
  @override
  late final GeneratedColumn<int> pFijo = GeneratedColumn<int>(
    'p_fijo',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _restriccionCapacidadActivaMeta =
      const VerificationMeta('restriccionCapacidadActiva');
  @override
  late final GeneratedColumn<bool> restriccionCapacidadActiva =
      GeneratedColumn<bool>(
        'restriccion_capacidad_activa',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("restriccion_capacidad_activa" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _costoTotalCentMeta = const VerificationMeta(
    'costoTotalCent',
  );
  @override
  late final GeneratedColumn<int> costoTotalCent = GeneratedColumn<int>(
    'costo_total_cent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
    proyectoId,
    nombre,
    metodo,
    pFijo,
    restriccionCapacidadActiva,
    costoTotalCent,
    fecha,
    notas,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'escenario';
  @override
  VerificationContext validateIntegrity(
    Insertable<EscenarioTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('proyecto_id')) {
      context.handle(
        _proyectoIdMeta,
        proyectoId.isAcceptableOrUnknown(data['proyecto_id']!, _proyectoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_proyectoIdMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('metodo')) {
      context.handle(
        _metodoMeta,
        metodo.isAcceptableOrUnknown(data['metodo']!, _metodoMeta),
      );
    } else if (isInserting) {
      context.missing(_metodoMeta);
    }
    if (data.containsKey('p_fijo')) {
      context.handle(
        _pFijoMeta,
        pFijo.isAcceptableOrUnknown(data['p_fijo']!, _pFijoMeta),
      );
    }
    if (data.containsKey('restriccion_capacidad_activa')) {
      context.handle(
        _restriccionCapacidadActivaMeta,
        restriccionCapacidadActiva.isAcceptableOrUnknown(
          data['restriccion_capacidad_activa']!,
          _restriccionCapacidadActivaMeta,
        ),
      );
    }
    if (data.containsKey('costo_total_cent')) {
      context.handle(
        _costoTotalCentMeta,
        costoTotalCent.isAcceptableOrUnknown(
          data['costo_total_cent']!,
          _costoTotalCentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_costoTotalCentMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    } else if (isInserting) {
      context.missing(_fechaMeta);
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
  EscenarioTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EscenarioTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      proyectoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}proyecto_id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      metodo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metodo'],
      )!,
      pFijo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}p_fijo'],
      ),
      restriccionCapacidadActiva: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}restriccion_capacidad_activa'],
      )!,
      costoTotalCent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}costo_total_cent'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fecha'],
      )!,
      notas: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notas'],
      ),
    );
  }

  @override
  $EscenarioTableTable createAlias(String alias) {
    return $EscenarioTableTable(attachedDatabase, alias);
  }
}

class EscenarioTableData extends DataClass
    implements Insertable<EscenarioTableData> {
  final int id;
  final int proyectoId;
  final String nombre;
  final String metodo;
  final int? pFijo;
  final bool restriccionCapacidadActiva;
  final int costoTotalCent;
  final String fecha;
  final String? notas;
  const EscenarioTableData({
    required this.id,
    required this.proyectoId,
    required this.nombre,
    required this.metodo,
    this.pFijo,
    required this.restriccionCapacidadActiva,
    required this.costoTotalCent,
    required this.fecha,
    this.notas,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['proyecto_id'] = Variable<int>(proyectoId);
    map['nombre'] = Variable<String>(nombre);
    map['metodo'] = Variable<String>(metodo);
    if (!nullToAbsent || pFijo != null) {
      map['p_fijo'] = Variable<int>(pFijo);
    }
    map['restriccion_capacidad_activa'] = Variable<bool>(
      restriccionCapacidadActiva,
    );
    map['costo_total_cent'] = Variable<int>(costoTotalCent);
    map['fecha'] = Variable<String>(fecha);
    if (!nullToAbsent || notas != null) {
      map['notas'] = Variable<String>(notas);
    }
    return map;
  }

  EscenarioTableCompanion toCompanion(bool nullToAbsent) {
    return EscenarioTableCompanion(
      id: Value(id),
      proyectoId: Value(proyectoId),
      nombre: Value(nombre),
      metodo: Value(metodo),
      pFijo: pFijo == null && nullToAbsent
          ? const Value.absent()
          : Value(pFijo),
      restriccionCapacidadActiva: Value(restriccionCapacidadActiva),
      costoTotalCent: Value(costoTotalCent),
      fecha: Value(fecha),
      notas: notas == null && nullToAbsent
          ? const Value.absent()
          : Value(notas),
    );
  }

  factory EscenarioTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EscenarioTableData(
      id: serializer.fromJson<int>(json['id']),
      proyectoId: serializer.fromJson<int>(json['proyectoId']),
      nombre: serializer.fromJson<String>(json['nombre']),
      metodo: serializer.fromJson<String>(json['metodo']),
      pFijo: serializer.fromJson<int?>(json['pFijo']),
      restriccionCapacidadActiva: serializer.fromJson<bool>(
        json['restriccionCapacidadActiva'],
      ),
      costoTotalCent: serializer.fromJson<int>(json['costoTotalCent']),
      fecha: serializer.fromJson<String>(json['fecha']),
      notas: serializer.fromJson<String?>(json['notas']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'proyectoId': serializer.toJson<int>(proyectoId),
      'nombre': serializer.toJson<String>(nombre),
      'metodo': serializer.toJson<String>(metodo),
      'pFijo': serializer.toJson<int?>(pFijo),
      'restriccionCapacidadActiva': serializer.toJson<bool>(
        restriccionCapacidadActiva,
      ),
      'costoTotalCent': serializer.toJson<int>(costoTotalCent),
      'fecha': serializer.toJson<String>(fecha),
      'notas': serializer.toJson<String?>(notas),
    };
  }

  EscenarioTableData copyWith({
    int? id,
    int? proyectoId,
    String? nombre,
    String? metodo,
    Value<int?> pFijo = const Value.absent(),
    bool? restriccionCapacidadActiva,
    int? costoTotalCent,
    String? fecha,
    Value<String?> notas = const Value.absent(),
  }) => EscenarioTableData(
    id: id ?? this.id,
    proyectoId: proyectoId ?? this.proyectoId,
    nombre: nombre ?? this.nombre,
    metodo: metodo ?? this.metodo,
    pFijo: pFijo.present ? pFijo.value : this.pFijo,
    restriccionCapacidadActiva:
        restriccionCapacidadActiva ?? this.restriccionCapacidadActiva,
    costoTotalCent: costoTotalCent ?? this.costoTotalCent,
    fecha: fecha ?? this.fecha,
    notas: notas.present ? notas.value : this.notas,
  );
  EscenarioTableData copyWithCompanion(EscenarioTableCompanion data) {
    return EscenarioTableData(
      id: data.id.present ? data.id.value : this.id,
      proyectoId: data.proyectoId.present
          ? data.proyectoId.value
          : this.proyectoId,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      metodo: data.metodo.present ? data.metodo.value : this.metodo,
      pFijo: data.pFijo.present ? data.pFijo.value : this.pFijo,
      restriccionCapacidadActiva: data.restriccionCapacidadActiva.present
          ? data.restriccionCapacidadActiva.value
          : this.restriccionCapacidadActiva,
      costoTotalCent: data.costoTotalCent.present
          ? data.costoTotalCent.value
          : this.costoTotalCent,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      notas: data.notas.present ? data.notas.value : this.notas,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EscenarioTableData(')
          ..write('id: $id, ')
          ..write('proyectoId: $proyectoId, ')
          ..write('nombre: $nombre, ')
          ..write('metodo: $metodo, ')
          ..write('pFijo: $pFijo, ')
          ..write('restriccionCapacidadActiva: $restriccionCapacidadActiva, ')
          ..write('costoTotalCent: $costoTotalCent, ')
          ..write('fecha: $fecha, ')
          ..write('notas: $notas')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    proyectoId,
    nombre,
    metodo,
    pFijo,
    restriccionCapacidadActiva,
    costoTotalCent,
    fecha,
    notas,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EscenarioTableData &&
          other.id == this.id &&
          other.proyectoId == this.proyectoId &&
          other.nombre == this.nombre &&
          other.metodo == this.metodo &&
          other.pFijo == this.pFijo &&
          other.restriccionCapacidadActiva == this.restriccionCapacidadActiva &&
          other.costoTotalCent == this.costoTotalCent &&
          other.fecha == this.fecha &&
          other.notas == this.notas);
}

class EscenarioTableCompanion extends UpdateCompanion<EscenarioTableData> {
  final Value<int> id;
  final Value<int> proyectoId;
  final Value<String> nombre;
  final Value<String> metodo;
  final Value<int?> pFijo;
  final Value<bool> restriccionCapacidadActiva;
  final Value<int> costoTotalCent;
  final Value<String> fecha;
  final Value<String?> notas;
  const EscenarioTableCompanion({
    this.id = const Value.absent(),
    this.proyectoId = const Value.absent(),
    this.nombre = const Value.absent(),
    this.metodo = const Value.absent(),
    this.pFijo = const Value.absent(),
    this.restriccionCapacidadActiva = const Value.absent(),
    this.costoTotalCent = const Value.absent(),
    this.fecha = const Value.absent(),
    this.notas = const Value.absent(),
  });
  EscenarioTableCompanion.insert({
    this.id = const Value.absent(),
    required int proyectoId,
    required String nombre,
    required String metodo,
    this.pFijo = const Value.absent(),
    this.restriccionCapacidadActiva = const Value.absent(),
    required int costoTotalCent,
    required String fecha,
    this.notas = const Value.absent(),
  }) : proyectoId = Value(proyectoId),
       nombre = Value(nombre),
       metodo = Value(metodo),
       costoTotalCent = Value(costoTotalCent),
       fecha = Value(fecha);
  static Insertable<EscenarioTableData> custom({
    Expression<int>? id,
    Expression<int>? proyectoId,
    Expression<String>? nombre,
    Expression<String>? metodo,
    Expression<int>? pFijo,
    Expression<bool>? restriccionCapacidadActiva,
    Expression<int>? costoTotalCent,
    Expression<String>? fecha,
    Expression<String>? notas,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (proyectoId != null) 'proyecto_id': proyectoId,
      if (nombre != null) 'nombre': nombre,
      if (metodo != null) 'metodo': metodo,
      if (pFijo != null) 'p_fijo': pFijo,
      if (restriccionCapacidadActiva != null)
        'restriccion_capacidad_activa': restriccionCapacidadActiva,
      if (costoTotalCent != null) 'costo_total_cent': costoTotalCent,
      if (fecha != null) 'fecha': fecha,
      if (notas != null) 'notas': notas,
    });
  }

  EscenarioTableCompanion copyWith({
    Value<int>? id,
    Value<int>? proyectoId,
    Value<String>? nombre,
    Value<String>? metodo,
    Value<int?>? pFijo,
    Value<bool>? restriccionCapacidadActiva,
    Value<int>? costoTotalCent,
    Value<String>? fecha,
    Value<String?>? notas,
  }) {
    return EscenarioTableCompanion(
      id: id ?? this.id,
      proyectoId: proyectoId ?? this.proyectoId,
      nombre: nombre ?? this.nombre,
      metodo: metodo ?? this.metodo,
      pFijo: pFijo ?? this.pFijo,
      restriccionCapacidadActiva:
          restriccionCapacidadActiva ?? this.restriccionCapacidadActiva,
      costoTotalCent: costoTotalCent ?? this.costoTotalCent,
      fecha: fecha ?? this.fecha,
      notas: notas ?? this.notas,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (proyectoId.present) {
      map['proyecto_id'] = Variable<int>(proyectoId.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (metodo.present) {
      map['metodo'] = Variable<String>(metodo.value);
    }
    if (pFijo.present) {
      map['p_fijo'] = Variable<int>(pFijo.value);
    }
    if (restriccionCapacidadActiva.present) {
      map['restriccion_capacidad_activa'] = Variable<bool>(
        restriccionCapacidadActiva.value,
      );
    }
    if (costoTotalCent.present) {
      map['costo_total_cent'] = Variable<int>(costoTotalCent.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<String>(fecha.value);
    }
    if (notas.present) {
      map['notas'] = Variable<String>(notas.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EscenarioTableCompanion(')
          ..write('id: $id, ')
          ..write('proyectoId: $proyectoId, ')
          ..write('nombre: $nombre, ')
          ..write('metodo: $metodo, ')
          ..write('pFijo: $pFijo, ')
          ..write('restriccionCapacidadActiva: $restriccionCapacidadActiva, ')
          ..write('costoTotalCent: $costoTotalCent, ')
          ..write('fecha: $fecha, ')
          ..write('notas: $notas')
          ..write(')'))
        .toString();
  }
}

class $EscenarioAlmacenTableTable extends EscenarioAlmacenTable
    with TableInfo<$EscenarioAlmacenTableTable, EscenarioAlmacenTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EscenarioAlmacenTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _escenarioIdMeta = const VerificationMeta(
    'escenarioId',
  );
  @override
  late final GeneratedColumn<int> escenarioId = GeneratedColumn<int>(
    'escenario_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES escenario (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _sitioCandidatoIdMeta = const VerificationMeta(
    'sitioCandidatoId',
  );
  @override
  late final GeneratedColumn<int> sitioCandidatoId = GeneratedColumn<int>(
    'sitio_candidato_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sitio_candidato (id)',
    ),
  );
  static const VerificationMeta _volumenAsignadoMeta = const VerificationMeta(
    'volumenAsignado',
  );
  @override
  late final GeneratedColumn<double> volumenAsignado = GeneratedColumn<double>(
    'volumen_asignado',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costoFijoCentMeta = const VerificationMeta(
    'costoFijoCent',
  );
  @override
  late final GeneratedColumn<int> costoFijoCent = GeneratedColumn<int>(
    'costo_fijo_cent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costoManejoCentMeta = const VerificationMeta(
    'costoManejoCent',
  );
  @override
  late final GeneratedColumn<int> costoManejoCent = GeneratedColumn<int>(
    'costo_manejo_cent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    escenarioId,
    sitioCandidatoId,
    volumenAsignado,
    costoFijoCent,
    costoManejoCent,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'escenario_almacen';
  @override
  VerificationContext validateIntegrity(
    Insertable<EscenarioAlmacenTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('escenario_id')) {
      context.handle(
        _escenarioIdMeta,
        escenarioId.isAcceptableOrUnknown(
          data['escenario_id']!,
          _escenarioIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_escenarioIdMeta);
    }
    if (data.containsKey('sitio_candidato_id')) {
      context.handle(
        _sitioCandidatoIdMeta,
        sitioCandidatoId.isAcceptableOrUnknown(
          data['sitio_candidato_id']!,
          _sitioCandidatoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sitioCandidatoIdMeta);
    }
    if (data.containsKey('volumen_asignado')) {
      context.handle(
        _volumenAsignadoMeta,
        volumenAsignado.isAcceptableOrUnknown(
          data['volumen_asignado']!,
          _volumenAsignadoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_volumenAsignadoMeta);
    }
    if (data.containsKey('costo_fijo_cent')) {
      context.handle(
        _costoFijoCentMeta,
        costoFijoCent.isAcceptableOrUnknown(
          data['costo_fijo_cent']!,
          _costoFijoCentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_costoFijoCentMeta);
    }
    if (data.containsKey('costo_manejo_cent')) {
      context.handle(
        _costoManejoCentMeta,
        costoManejoCent.isAcceptableOrUnknown(
          data['costo_manejo_cent']!,
          _costoManejoCentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_costoManejoCentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EscenarioAlmacenTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EscenarioAlmacenTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      escenarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}escenario_id'],
      )!,
      sitioCandidatoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sitio_candidato_id'],
      )!,
      volumenAsignado: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}volumen_asignado'],
      )!,
      costoFijoCent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}costo_fijo_cent'],
      )!,
      costoManejoCent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}costo_manejo_cent'],
      )!,
    );
  }

  @override
  $EscenarioAlmacenTableTable createAlias(String alias) {
    return $EscenarioAlmacenTableTable(attachedDatabase, alias);
  }
}

class EscenarioAlmacenTableData extends DataClass
    implements Insertable<EscenarioAlmacenTableData> {
  final int id;
  final int escenarioId;
  final int sitioCandidatoId;
  final double volumenAsignado;
  final int costoFijoCent;
  final int costoManejoCent;
  const EscenarioAlmacenTableData({
    required this.id,
    required this.escenarioId,
    required this.sitioCandidatoId,
    required this.volumenAsignado,
    required this.costoFijoCent,
    required this.costoManejoCent,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['escenario_id'] = Variable<int>(escenarioId);
    map['sitio_candidato_id'] = Variable<int>(sitioCandidatoId);
    map['volumen_asignado'] = Variable<double>(volumenAsignado);
    map['costo_fijo_cent'] = Variable<int>(costoFijoCent);
    map['costo_manejo_cent'] = Variable<int>(costoManejoCent);
    return map;
  }

  EscenarioAlmacenTableCompanion toCompanion(bool nullToAbsent) {
    return EscenarioAlmacenTableCompanion(
      id: Value(id),
      escenarioId: Value(escenarioId),
      sitioCandidatoId: Value(sitioCandidatoId),
      volumenAsignado: Value(volumenAsignado),
      costoFijoCent: Value(costoFijoCent),
      costoManejoCent: Value(costoManejoCent),
    );
  }

  factory EscenarioAlmacenTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EscenarioAlmacenTableData(
      id: serializer.fromJson<int>(json['id']),
      escenarioId: serializer.fromJson<int>(json['escenarioId']),
      sitioCandidatoId: serializer.fromJson<int>(json['sitioCandidatoId']),
      volumenAsignado: serializer.fromJson<double>(json['volumenAsignado']),
      costoFijoCent: serializer.fromJson<int>(json['costoFijoCent']),
      costoManejoCent: serializer.fromJson<int>(json['costoManejoCent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'escenarioId': serializer.toJson<int>(escenarioId),
      'sitioCandidatoId': serializer.toJson<int>(sitioCandidatoId),
      'volumenAsignado': serializer.toJson<double>(volumenAsignado),
      'costoFijoCent': serializer.toJson<int>(costoFijoCent),
      'costoManejoCent': serializer.toJson<int>(costoManejoCent),
    };
  }

  EscenarioAlmacenTableData copyWith({
    int? id,
    int? escenarioId,
    int? sitioCandidatoId,
    double? volumenAsignado,
    int? costoFijoCent,
    int? costoManejoCent,
  }) => EscenarioAlmacenTableData(
    id: id ?? this.id,
    escenarioId: escenarioId ?? this.escenarioId,
    sitioCandidatoId: sitioCandidatoId ?? this.sitioCandidatoId,
    volumenAsignado: volumenAsignado ?? this.volumenAsignado,
    costoFijoCent: costoFijoCent ?? this.costoFijoCent,
    costoManejoCent: costoManejoCent ?? this.costoManejoCent,
  );
  EscenarioAlmacenTableData copyWithCompanion(
    EscenarioAlmacenTableCompanion data,
  ) {
    return EscenarioAlmacenTableData(
      id: data.id.present ? data.id.value : this.id,
      escenarioId: data.escenarioId.present
          ? data.escenarioId.value
          : this.escenarioId,
      sitioCandidatoId: data.sitioCandidatoId.present
          ? data.sitioCandidatoId.value
          : this.sitioCandidatoId,
      volumenAsignado: data.volumenAsignado.present
          ? data.volumenAsignado.value
          : this.volumenAsignado,
      costoFijoCent: data.costoFijoCent.present
          ? data.costoFijoCent.value
          : this.costoFijoCent,
      costoManejoCent: data.costoManejoCent.present
          ? data.costoManejoCent.value
          : this.costoManejoCent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EscenarioAlmacenTableData(')
          ..write('id: $id, ')
          ..write('escenarioId: $escenarioId, ')
          ..write('sitioCandidatoId: $sitioCandidatoId, ')
          ..write('volumenAsignado: $volumenAsignado, ')
          ..write('costoFijoCent: $costoFijoCent, ')
          ..write('costoManejoCent: $costoManejoCent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    escenarioId,
    sitioCandidatoId,
    volumenAsignado,
    costoFijoCent,
    costoManejoCent,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EscenarioAlmacenTableData &&
          other.id == this.id &&
          other.escenarioId == this.escenarioId &&
          other.sitioCandidatoId == this.sitioCandidatoId &&
          other.volumenAsignado == this.volumenAsignado &&
          other.costoFijoCent == this.costoFijoCent &&
          other.costoManejoCent == this.costoManejoCent);
}

class EscenarioAlmacenTableCompanion
    extends UpdateCompanion<EscenarioAlmacenTableData> {
  final Value<int> id;
  final Value<int> escenarioId;
  final Value<int> sitioCandidatoId;
  final Value<double> volumenAsignado;
  final Value<int> costoFijoCent;
  final Value<int> costoManejoCent;
  const EscenarioAlmacenTableCompanion({
    this.id = const Value.absent(),
    this.escenarioId = const Value.absent(),
    this.sitioCandidatoId = const Value.absent(),
    this.volumenAsignado = const Value.absent(),
    this.costoFijoCent = const Value.absent(),
    this.costoManejoCent = const Value.absent(),
  });
  EscenarioAlmacenTableCompanion.insert({
    this.id = const Value.absent(),
    required int escenarioId,
    required int sitioCandidatoId,
    required double volumenAsignado,
    required int costoFijoCent,
    required int costoManejoCent,
  }) : escenarioId = Value(escenarioId),
       sitioCandidatoId = Value(sitioCandidatoId),
       volumenAsignado = Value(volumenAsignado),
       costoFijoCent = Value(costoFijoCent),
       costoManejoCent = Value(costoManejoCent);
  static Insertable<EscenarioAlmacenTableData> custom({
    Expression<int>? id,
    Expression<int>? escenarioId,
    Expression<int>? sitioCandidatoId,
    Expression<double>? volumenAsignado,
    Expression<int>? costoFijoCent,
    Expression<int>? costoManejoCent,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (escenarioId != null) 'escenario_id': escenarioId,
      if (sitioCandidatoId != null) 'sitio_candidato_id': sitioCandidatoId,
      if (volumenAsignado != null) 'volumen_asignado': volumenAsignado,
      if (costoFijoCent != null) 'costo_fijo_cent': costoFijoCent,
      if (costoManejoCent != null) 'costo_manejo_cent': costoManejoCent,
    });
  }

  EscenarioAlmacenTableCompanion copyWith({
    Value<int>? id,
    Value<int>? escenarioId,
    Value<int>? sitioCandidatoId,
    Value<double>? volumenAsignado,
    Value<int>? costoFijoCent,
    Value<int>? costoManejoCent,
  }) {
    return EscenarioAlmacenTableCompanion(
      id: id ?? this.id,
      escenarioId: escenarioId ?? this.escenarioId,
      sitioCandidatoId: sitioCandidatoId ?? this.sitioCandidatoId,
      volumenAsignado: volumenAsignado ?? this.volumenAsignado,
      costoFijoCent: costoFijoCent ?? this.costoFijoCent,
      costoManejoCent: costoManejoCent ?? this.costoManejoCent,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (escenarioId.present) {
      map['escenario_id'] = Variable<int>(escenarioId.value);
    }
    if (sitioCandidatoId.present) {
      map['sitio_candidato_id'] = Variable<int>(sitioCandidatoId.value);
    }
    if (volumenAsignado.present) {
      map['volumen_asignado'] = Variable<double>(volumenAsignado.value);
    }
    if (costoFijoCent.present) {
      map['costo_fijo_cent'] = Variable<int>(costoFijoCent.value);
    }
    if (costoManejoCent.present) {
      map['costo_manejo_cent'] = Variable<int>(costoManejoCent.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EscenarioAlmacenTableCompanion(')
          ..write('id: $id, ')
          ..write('escenarioId: $escenarioId, ')
          ..write('sitioCandidatoId: $sitioCandidatoId, ')
          ..write('volumenAsignado: $volumenAsignado, ')
          ..write('costoFijoCent: $costoFijoCent, ')
          ..write('costoManejoCent: $costoManejoCent')
          ..write(')'))
        .toString();
  }
}

class $EscenarioAsignacionTableTable extends EscenarioAsignacionTable
    with
        TableInfo<
          $EscenarioAsignacionTableTable,
          EscenarioAsignacionTableData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EscenarioAsignacionTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _escenarioIdMeta = const VerificationMeta(
    'escenarioId',
  );
  @override
  late final GeneratedColumn<int> escenarioId = GeneratedColumn<int>(
    'escenario_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES escenario (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _zonaIdMeta = const VerificationMeta('zonaId');
  @override
  late final GeneratedColumn<int> zonaId = GeneratedColumn<int>(
    'zona_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES zona_demanda (id)',
    ),
  );
  static const VerificationMeta _sitioCandidatoIdMeta = const VerificationMeta(
    'sitioCandidatoId',
  );
  @override
  late final GeneratedColumn<int> sitioCandidatoId = GeneratedColumn<int>(
    'sitio_candidato_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sitio_candidato (id)',
    ),
  );
  static const VerificationMeta _distanciaMetrosMeta = const VerificationMeta(
    'distanciaMetros',
  );
  @override
  late final GeneratedColumn<int> distanciaMetros = GeneratedColumn<int>(
    'distancia_metros',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _duracionSegundosMeta = const VerificationMeta(
    'duracionSegundos',
  );
  @override
  late final GeneratedColumn<int> duracionSegundos = GeneratedColumn<int>(
    'duracion_segundos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costoSalidaCentMeta = const VerificationMeta(
    'costoSalidaCent',
  );
  @override
  late final GeneratedColumn<int> costoSalidaCent = GeneratedColumn<int>(
    'costo_salida_cent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    escenarioId,
    zonaId,
    sitioCandidatoId,
    distanciaMetros,
    duracionSegundos,
    costoSalidaCent,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'escenario_asignacion';
  @override
  VerificationContext validateIntegrity(
    Insertable<EscenarioAsignacionTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('escenario_id')) {
      context.handle(
        _escenarioIdMeta,
        escenarioId.isAcceptableOrUnknown(
          data['escenario_id']!,
          _escenarioIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_escenarioIdMeta);
    }
    if (data.containsKey('zona_id')) {
      context.handle(
        _zonaIdMeta,
        zonaId.isAcceptableOrUnknown(data['zona_id']!, _zonaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_zonaIdMeta);
    }
    if (data.containsKey('sitio_candidato_id')) {
      context.handle(
        _sitioCandidatoIdMeta,
        sitioCandidatoId.isAcceptableOrUnknown(
          data['sitio_candidato_id']!,
          _sitioCandidatoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sitioCandidatoIdMeta);
    }
    if (data.containsKey('distancia_metros')) {
      context.handle(
        _distanciaMetrosMeta,
        distanciaMetros.isAcceptableOrUnknown(
          data['distancia_metros']!,
          _distanciaMetrosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_distanciaMetrosMeta);
    }
    if (data.containsKey('duracion_segundos')) {
      context.handle(
        _duracionSegundosMeta,
        duracionSegundos.isAcceptableOrUnknown(
          data['duracion_segundos']!,
          _duracionSegundosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_duracionSegundosMeta);
    }
    if (data.containsKey('costo_salida_cent')) {
      context.handle(
        _costoSalidaCentMeta,
        costoSalidaCent.isAcceptableOrUnknown(
          data['costo_salida_cent']!,
          _costoSalidaCentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_costoSalidaCentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EscenarioAsignacionTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EscenarioAsignacionTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      escenarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}escenario_id'],
      )!,
      zonaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}zona_id'],
      )!,
      sitioCandidatoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sitio_candidato_id'],
      )!,
      distanciaMetros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}distancia_metros'],
      )!,
      duracionSegundos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duracion_segundos'],
      )!,
      costoSalidaCent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}costo_salida_cent'],
      )!,
    );
  }

  @override
  $EscenarioAsignacionTableTable createAlias(String alias) {
    return $EscenarioAsignacionTableTable(attachedDatabase, alias);
  }
}

class EscenarioAsignacionTableData extends DataClass
    implements Insertable<EscenarioAsignacionTableData> {
  final int id;
  final int escenarioId;
  final int zonaId;
  final int sitioCandidatoId;
  final int distanciaMetros;
  final int duracionSegundos;
  final int costoSalidaCent;
  const EscenarioAsignacionTableData({
    required this.id,
    required this.escenarioId,
    required this.zonaId,
    required this.sitioCandidatoId,
    required this.distanciaMetros,
    required this.duracionSegundos,
    required this.costoSalidaCent,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['escenario_id'] = Variable<int>(escenarioId);
    map['zona_id'] = Variable<int>(zonaId);
    map['sitio_candidato_id'] = Variable<int>(sitioCandidatoId);
    map['distancia_metros'] = Variable<int>(distanciaMetros);
    map['duracion_segundos'] = Variable<int>(duracionSegundos);
    map['costo_salida_cent'] = Variable<int>(costoSalidaCent);
    return map;
  }

  EscenarioAsignacionTableCompanion toCompanion(bool nullToAbsent) {
    return EscenarioAsignacionTableCompanion(
      id: Value(id),
      escenarioId: Value(escenarioId),
      zonaId: Value(zonaId),
      sitioCandidatoId: Value(sitioCandidatoId),
      distanciaMetros: Value(distanciaMetros),
      duracionSegundos: Value(duracionSegundos),
      costoSalidaCent: Value(costoSalidaCent),
    );
  }

  factory EscenarioAsignacionTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EscenarioAsignacionTableData(
      id: serializer.fromJson<int>(json['id']),
      escenarioId: serializer.fromJson<int>(json['escenarioId']),
      zonaId: serializer.fromJson<int>(json['zonaId']),
      sitioCandidatoId: serializer.fromJson<int>(json['sitioCandidatoId']),
      distanciaMetros: serializer.fromJson<int>(json['distanciaMetros']),
      duracionSegundos: serializer.fromJson<int>(json['duracionSegundos']),
      costoSalidaCent: serializer.fromJson<int>(json['costoSalidaCent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'escenarioId': serializer.toJson<int>(escenarioId),
      'zonaId': serializer.toJson<int>(zonaId),
      'sitioCandidatoId': serializer.toJson<int>(sitioCandidatoId),
      'distanciaMetros': serializer.toJson<int>(distanciaMetros),
      'duracionSegundos': serializer.toJson<int>(duracionSegundos),
      'costoSalidaCent': serializer.toJson<int>(costoSalidaCent),
    };
  }

  EscenarioAsignacionTableData copyWith({
    int? id,
    int? escenarioId,
    int? zonaId,
    int? sitioCandidatoId,
    int? distanciaMetros,
    int? duracionSegundos,
    int? costoSalidaCent,
  }) => EscenarioAsignacionTableData(
    id: id ?? this.id,
    escenarioId: escenarioId ?? this.escenarioId,
    zonaId: zonaId ?? this.zonaId,
    sitioCandidatoId: sitioCandidatoId ?? this.sitioCandidatoId,
    distanciaMetros: distanciaMetros ?? this.distanciaMetros,
    duracionSegundos: duracionSegundos ?? this.duracionSegundos,
    costoSalidaCent: costoSalidaCent ?? this.costoSalidaCent,
  );
  EscenarioAsignacionTableData copyWithCompanion(
    EscenarioAsignacionTableCompanion data,
  ) {
    return EscenarioAsignacionTableData(
      id: data.id.present ? data.id.value : this.id,
      escenarioId: data.escenarioId.present
          ? data.escenarioId.value
          : this.escenarioId,
      zonaId: data.zonaId.present ? data.zonaId.value : this.zonaId,
      sitioCandidatoId: data.sitioCandidatoId.present
          ? data.sitioCandidatoId.value
          : this.sitioCandidatoId,
      distanciaMetros: data.distanciaMetros.present
          ? data.distanciaMetros.value
          : this.distanciaMetros,
      duracionSegundos: data.duracionSegundos.present
          ? data.duracionSegundos.value
          : this.duracionSegundos,
      costoSalidaCent: data.costoSalidaCent.present
          ? data.costoSalidaCent.value
          : this.costoSalidaCent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EscenarioAsignacionTableData(')
          ..write('id: $id, ')
          ..write('escenarioId: $escenarioId, ')
          ..write('zonaId: $zonaId, ')
          ..write('sitioCandidatoId: $sitioCandidatoId, ')
          ..write('distanciaMetros: $distanciaMetros, ')
          ..write('duracionSegundos: $duracionSegundos, ')
          ..write('costoSalidaCent: $costoSalidaCent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    escenarioId,
    zonaId,
    sitioCandidatoId,
    distanciaMetros,
    duracionSegundos,
    costoSalidaCent,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EscenarioAsignacionTableData &&
          other.id == this.id &&
          other.escenarioId == this.escenarioId &&
          other.zonaId == this.zonaId &&
          other.sitioCandidatoId == this.sitioCandidatoId &&
          other.distanciaMetros == this.distanciaMetros &&
          other.duracionSegundos == this.duracionSegundos &&
          other.costoSalidaCent == this.costoSalidaCent);
}

class EscenarioAsignacionTableCompanion
    extends UpdateCompanion<EscenarioAsignacionTableData> {
  final Value<int> id;
  final Value<int> escenarioId;
  final Value<int> zonaId;
  final Value<int> sitioCandidatoId;
  final Value<int> distanciaMetros;
  final Value<int> duracionSegundos;
  final Value<int> costoSalidaCent;
  const EscenarioAsignacionTableCompanion({
    this.id = const Value.absent(),
    this.escenarioId = const Value.absent(),
    this.zonaId = const Value.absent(),
    this.sitioCandidatoId = const Value.absent(),
    this.distanciaMetros = const Value.absent(),
    this.duracionSegundos = const Value.absent(),
    this.costoSalidaCent = const Value.absent(),
  });
  EscenarioAsignacionTableCompanion.insert({
    this.id = const Value.absent(),
    required int escenarioId,
    required int zonaId,
    required int sitioCandidatoId,
    required int distanciaMetros,
    required int duracionSegundos,
    required int costoSalidaCent,
  }) : escenarioId = Value(escenarioId),
       zonaId = Value(zonaId),
       sitioCandidatoId = Value(sitioCandidatoId),
       distanciaMetros = Value(distanciaMetros),
       duracionSegundos = Value(duracionSegundos),
       costoSalidaCent = Value(costoSalidaCent);
  static Insertable<EscenarioAsignacionTableData> custom({
    Expression<int>? id,
    Expression<int>? escenarioId,
    Expression<int>? zonaId,
    Expression<int>? sitioCandidatoId,
    Expression<int>? distanciaMetros,
    Expression<int>? duracionSegundos,
    Expression<int>? costoSalidaCent,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (escenarioId != null) 'escenario_id': escenarioId,
      if (zonaId != null) 'zona_id': zonaId,
      if (sitioCandidatoId != null) 'sitio_candidato_id': sitioCandidatoId,
      if (distanciaMetros != null) 'distancia_metros': distanciaMetros,
      if (duracionSegundos != null) 'duracion_segundos': duracionSegundos,
      if (costoSalidaCent != null) 'costo_salida_cent': costoSalidaCent,
    });
  }

  EscenarioAsignacionTableCompanion copyWith({
    Value<int>? id,
    Value<int>? escenarioId,
    Value<int>? zonaId,
    Value<int>? sitioCandidatoId,
    Value<int>? distanciaMetros,
    Value<int>? duracionSegundos,
    Value<int>? costoSalidaCent,
  }) {
    return EscenarioAsignacionTableCompanion(
      id: id ?? this.id,
      escenarioId: escenarioId ?? this.escenarioId,
      zonaId: zonaId ?? this.zonaId,
      sitioCandidatoId: sitioCandidatoId ?? this.sitioCandidatoId,
      distanciaMetros: distanciaMetros ?? this.distanciaMetros,
      duracionSegundos: duracionSegundos ?? this.duracionSegundos,
      costoSalidaCent: costoSalidaCent ?? this.costoSalidaCent,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (escenarioId.present) {
      map['escenario_id'] = Variable<int>(escenarioId.value);
    }
    if (zonaId.present) {
      map['zona_id'] = Variable<int>(zonaId.value);
    }
    if (sitioCandidatoId.present) {
      map['sitio_candidato_id'] = Variable<int>(sitioCandidatoId.value);
    }
    if (distanciaMetros.present) {
      map['distancia_metros'] = Variable<int>(distanciaMetros.value);
    }
    if (duracionSegundos.present) {
      map['duracion_segundos'] = Variable<int>(duracionSegundos.value);
    }
    if (costoSalidaCent.present) {
      map['costo_salida_cent'] = Variable<int>(costoSalidaCent.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EscenarioAsignacionTableCompanion(')
          ..write('id: $id, ')
          ..write('escenarioId: $escenarioId, ')
          ..write('zonaId: $zonaId, ')
          ..write('sitioCandidatoId: $sitioCandidatoId, ')
          ..write('distanciaMetros: $distanciaMetros, ')
          ..write('duracionSegundos: $duracionSegundos, ')
          ..write('costoSalidaCent: $costoSalidaCent')
          ..write(')'))
        .toString();
  }
}

class $EscenarioCostoTableTable extends EscenarioCostoTable
    with TableInfo<$EscenarioCostoTableTable, EscenarioCostoTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EscenarioCostoTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _escenarioIdMeta = const VerificationMeta(
    'escenarioId',
  );
  @override
  late final GeneratedColumn<int> escenarioId = GeneratedColumn<int>(
    'escenario_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES escenario (id) ON DELETE CASCADE',
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
  static const VerificationMeta _montoCentMeta = const VerificationMeta(
    'montoCent',
  );
  @override
  late final GeneratedColumn<int> montoCent = GeneratedColumn<int>(
    'monto_cent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, escenarioId, rubro, montoCent];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'escenario_costo';
  @override
  VerificationContext validateIntegrity(
    Insertable<EscenarioCostoTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('escenario_id')) {
      context.handle(
        _escenarioIdMeta,
        escenarioId.isAcceptableOrUnknown(
          data['escenario_id']!,
          _escenarioIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_escenarioIdMeta);
    }
    if (data.containsKey('rubro')) {
      context.handle(
        _rubroMeta,
        rubro.isAcceptableOrUnknown(data['rubro']!, _rubroMeta),
      );
    } else if (isInserting) {
      context.missing(_rubroMeta);
    }
    if (data.containsKey('monto_cent')) {
      context.handle(
        _montoCentMeta,
        montoCent.isAcceptableOrUnknown(data['monto_cent']!, _montoCentMeta),
      );
    } else if (isInserting) {
      context.missing(_montoCentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EscenarioCostoTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EscenarioCostoTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      escenarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}escenario_id'],
      )!,
      rubro: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rubro'],
      )!,
      montoCent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monto_cent'],
      )!,
    );
  }

  @override
  $EscenarioCostoTableTable createAlias(String alias) {
    return $EscenarioCostoTableTable(attachedDatabase, alias);
  }
}

class EscenarioCostoTableData extends DataClass
    implements Insertable<EscenarioCostoTableData> {
  final int id;
  final int escenarioId;
  final String rubro;
  final int montoCent;
  const EscenarioCostoTableData({
    required this.id,
    required this.escenarioId,
    required this.rubro,
    required this.montoCent,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['escenario_id'] = Variable<int>(escenarioId);
    map['rubro'] = Variable<String>(rubro);
    map['monto_cent'] = Variable<int>(montoCent);
    return map;
  }

  EscenarioCostoTableCompanion toCompanion(bool nullToAbsent) {
    return EscenarioCostoTableCompanion(
      id: Value(id),
      escenarioId: Value(escenarioId),
      rubro: Value(rubro),
      montoCent: Value(montoCent),
    );
  }

  factory EscenarioCostoTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EscenarioCostoTableData(
      id: serializer.fromJson<int>(json['id']),
      escenarioId: serializer.fromJson<int>(json['escenarioId']),
      rubro: serializer.fromJson<String>(json['rubro']),
      montoCent: serializer.fromJson<int>(json['montoCent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'escenarioId': serializer.toJson<int>(escenarioId),
      'rubro': serializer.toJson<String>(rubro),
      'montoCent': serializer.toJson<int>(montoCent),
    };
  }

  EscenarioCostoTableData copyWith({
    int? id,
    int? escenarioId,
    String? rubro,
    int? montoCent,
  }) => EscenarioCostoTableData(
    id: id ?? this.id,
    escenarioId: escenarioId ?? this.escenarioId,
    rubro: rubro ?? this.rubro,
    montoCent: montoCent ?? this.montoCent,
  );
  EscenarioCostoTableData copyWithCompanion(EscenarioCostoTableCompanion data) {
    return EscenarioCostoTableData(
      id: data.id.present ? data.id.value : this.id,
      escenarioId: data.escenarioId.present
          ? data.escenarioId.value
          : this.escenarioId,
      rubro: data.rubro.present ? data.rubro.value : this.rubro,
      montoCent: data.montoCent.present ? data.montoCent.value : this.montoCent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EscenarioCostoTableData(')
          ..write('id: $id, ')
          ..write('escenarioId: $escenarioId, ')
          ..write('rubro: $rubro, ')
          ..write('montoCent: $montoCent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, escenarioId, rubro, montoCent);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EscenarioCostoTableData &&
          other.id == this.id &&
          other.escenarioId == this.escenarioId &&
          other.rubro == this.rubro &&
          other.montoCent == this.montoCent);
}

class EscenarioCostoTableCompanion
    extends UpdateCompanion<EscenarioCostoTableData> {
  final Value<int> id;
  final Value<int> escenarioId;
  final Value<String> rubro;
  final Value<int> montoCent;
  const EscenarioCostoTableCompanion({
    this.id = const Value.absent(),
    this.escenarioId = const Value.absent(),
    this.rubro = const Value.absent(),
    this.montoCent = const Value.absent(),
  });
  EscenarioCostoTableCompanion.insert({
    this.id = const Value.absent(),
    required int escenarioId,
    required String rubro,
    required int montoCent,
  }) : escenarioId = Value(escenarioId),
       rubro = Value(rubro),
       montoCent = Value(montoCent);
  static Insertable<EscenarioCostoTableData> custom({
    Expression<int>? id,
    Expression<int>? escenarioId,
    Expression<String>? rubro,
    Expression<int>? montoCent,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (escenarioId != null) 'escenario_id': escenarioId,
      if (rubro != null) 'rubro': rubro,
      if (montoCent != null) 'monto_cent': montoCent,
    });
  }

  EscenarioCostoTableCompanion copyWith({
    Value<int>? id,
    Value<int>? escenarioId,
    Value<String>? rubro,
    Value<int>? montoCent,
  }) {
    return EscenarioCostoTableCompanion(
      id: id ?? this.id,
      escenarioId: escenarioId ?? this.escenarioId,
      rubro: rubro ?? this.rubro,
      montoCent: montoCent ?? this.montoCent,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (escenarioId.present) {
      map['escenario_id'] = Variable<int>(escenarioId.value);
    }
    if (rubro.present) {
      map['rubro'] = Variable<String>(rubro.value);
    }
    if (montoCent.present) {
      map['monto_cent'] = Variable<int>(montoCent.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EscenarioCostoTableCompanion(')
          ..write('id: $id, ')
          ..write('escenarioId: $escenarioId, ')
          ..write('rubro: $rubro, ')
          ..write('montoCent: $montoCent')
          ..write(')'))
        .toString();
  }
}

class $PuntoCurvaTableTable extends PuntoCurvaTable
    with TableInfo<$PuntoCurvaTableTable, PuntoCurvaTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PuntoCurvaTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _escenarioIdMeta = const VerificationMeta(
    'escenarioId',
  );
  @override
  late final GeneratedColumn<int> escenarioId = GeneratedColumn<int>(
    'escenario_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES escenario (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _numeroAlmacenesMeta = const VerificationMeta(
    'numeroAlmacenes',
  );
  @override
  late final GeneratedColumn<int> numeroAlmacenes = GeneratedColumn<int>(
    'numero_almacenes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costoTotalCentMeta = const VerificationMeta(
    'costoTotalCent',
  );
  @override
  late final GeneratedColumn<int> costoTotalCent = GeneratedColumn<int>(
    'costo_total_cent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costoPorRubroJsonMeta = const VerificationMeta(
    'costoPorRubroJson',
  );
  @override
  late final GeneratedColumn<String> costoPorRubroJson =
      GeneratedColumn<String>(
        'costo_por_rubro_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _viableSegunServicioMeta =
      const VerificationMeta('viableSegunServicio');
  @override
  late final GeneratedColumn<bool> viableSegunServicio = GeneratedColumn<bool>(
    'viable_segun_servicio',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("viable_segun_servicio" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    escenarioId,
    numeroAlmacenes,
    costoTotalCent,
    costoPorRubroJson,
    viableSegunServicio,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'punto_curva';
  @override
  VerificationContext validateIntegrity(
    Insertable<PuntoCurvaTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('escenario_id')) {
      context.handle(
        _escenarioIdMeta,
        escenarioId.isAcceptableOrUnknown(
          data['escenario_id']!,
          _escenarioIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_escenarioIdMeta);
    }
    if (data.containsKey('numero_almacenes')) {
      context.handle(
        _numeroAlmacenesMeta,
        numeroAlmacenes.isAcceptableOrUnknown(
          data['numero_almacenes']!,
          _numeroAlmacenesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_numeroAlmacenesMeta);
    }
    if (data.containsKey('costo_total_cent')) {
      context.handle(
        _costoTotalCentMeta,
        costoTotalCent.isAcceptableOrUnknown(
          data['costo_total_cent']!,
          _costoTotalCentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_costoTotalCentMeta);
    }
    if (data.containsKey('costo_por_rubro_json')) {
      context.handle(
        _costoPorRubroJsonMeta,
        costoPorRubroJson.isAcceptableOrUnknown(
          data['costo_por_rubro_json']!,
          _costoPorRubroJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_costoPorRubroJsonMeta);
    }
    if (data.containsKey('viable_segun_servicio')) {
      context.handle(
        _viableSegunServicioMeta,
        viableSegunServicio.isAcceptableOrUnknown(
          data['viable_segun_servicio']!,
          _viableSegunServicioMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_viableSegunServicioMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PuntoCurvaTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PuntoCurvaTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      escenarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}escenario_id'],
      )!,
      numeroAlmacenes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}numero_almacenes'],
      )!,
      costoTotalCent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}costo_total_cent'],
      )!,
      costoPorRubroJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}costo_por_rubro_json'],
      )!,
      viableSegunServicio: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}viable_segun_servicio'],
      )!,
    );
  }

  @override
  $PuntoCurvaTableTable createAlias(String alias) {
    return $PuntoCurvaTableTable(attachedDatabase, alias);
  }
}

class PuntoCurvaTableData extends DataClass
    implements Insertable<PuntoCurvaTableData> {
  final int id;
  final int escenarioId;
  final int numeroAlmacenes;
  final int costoTotalCent;
  final String costoPorRubroJson;
  final bool viableSegunServicio;
  const PuntoCurvaTableData({
    required this.id,
    required this.escenarioId,
    required this.numeroAlmacenes,
    required this.costoTotalCent,
    required this.costoPorRubroJson,
    required this.viableSegunServicio,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['escenario_id'] = Variable<int>(escenarioId);
    map['numero_almacenes'] = Variable<int>(numeroAlmacenes);
    map['costo_total_cent'] = Variable<int>(costoTotalCent);
    map['costo_por_rubro_json'] = Variable<String>(costoPorRubroJson);
    map['viable_segun_servicio'] = Variable<bool>(viableSegunServicio);
    return map;
  }

  PuntoCurvaTableCompanion toCompanion(bool nullToAbsent) {
    return PuntoCurvaTableCompanion(
      id: Value(id),
      escenarioId: Value(escenarioId),
      numeroAlmacenes: Value(numeroAlmacenes),
      costoTotalCent: Value(costoTotalCent),
      costoPorRubroJson: Value(costoPorRubroJson),
      viableSegunServicio: Value(viableSegunServicio),
    );
  }

  factory PuntoCurvaTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PuntoCurvaTableData(
      id: serializer.fromJson<int>(json['id']),
      escenarioId: serializer.fromJson<int>(json['escenarioId']),
      numeroAlmacenes: serializer.fromJson<int>(json['numeroAlmacenes']),
      costoTotalCent: serializer.fromJson<int>(json['costoTotalCent']),
      costoPorRubroJson: serializer.fromJson<String>(json['costoPorRubroJson']),
      viableSegunServicio: serializer.fromJson<bool>(
        json['viableSegunServicio'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'escenarioId': serializer.toJson<int>(escenarioId),
      'numeroAlmacenes': serializer.toJson<int>(numeroAlmacenes),
      'costoTotalCent': serializer.toJson<int>(costoTotalCent),
      'costoPorRubroJson': serializer.toJson<String>(costoPorRubroJson),
      'viableSegunServicio': serializer.toJson<bool>(viableSegunServicio),
    };
  }

  PuntoCurvaTableData copyWith({
    int? id,
    int? escenarioId,
    int? numeroAlmacenes,
    int? costoTotalCent,
    String? costoPorRubroJson,
    bool? viableSegunServicio,
  }) => PuntoCurvaTableData(
    id: id ?? this.id,
    escenarioId: escenarioId ?? this.escenarioId,
    numeroAlmacenes: numeroAlmacenes ?? this.numeroAlmacenes,
    costoTotalCent: costoTotalCent ?? this.costoTotalCent,
    costoPorRubroJson: costoPorRubroJson ?? this.costoPorRubroJson,
    viableSegunServicio: viableSegunServicio ?? this.viableSegunServicio,
  );
  PuntoCurvaTableData copyWithCompanion(PuntoCurvaTableCompanion data) {
    return PuntoCurvaTableData(
      id: data.id.present ? data.id.value : this.id,
      escenarioId: data.escenarioId.present
          ? data.escenarioId.value
          : this.escenarioId,
      numeroAlmacenes: data.numeroAlmacenes.present
          ? data.numeroAlmacenes.value
          : this.numeroAlmacenes,
      costoTotalCent: data.costoTotalCent.present
          ? data.costoTotalCent.value
          : this.costoTotalCent,
      costoPorRubroJson: data.costoPorRubroJson.present
          ? data.costoPorRubroJson.value
          : this.costoPorRubroJson,
      viableSegunServicio: data.viableSegunServicio.present
          ? data.viableSegunServicio.value
          : this.viableSegunServicio,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PuntoCurvaTableData(')
          ..write('id: $id, ')
          ..write('escenarioId: $escenarioId, ')
          ..write('numeroAlmacenes: $numeroAlmacenes, ')
          ..write('costoTotalCent: $costoTotalCent, ')
          ..write('costoPorRubroJson: $costoPorRubroJson, ')
          ..write('viableSegunServicio: $viableSegunServicio')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    escenarioId,
    numeroAlmacenes,
    costoTotalCent,
    costoPorRubroJson,
    viableSegunServicio,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PuntoCurvaTableData &&
          other.id == this.id &&
          other.escenarioId == this.escenarioId &&
          other.numeroAlmacenes == this.numeroAlmacenes &&
          other.costoTotalCent == this.costoTotalCent &&
          other.costoPorRubroJson == this.costoPorRubroJson &&
          other.viableSegunServicio == this.viableSegunServicio);
}

class PuntoCurvaTableCompanion extends UpdateCompanion<PuntoCurvaTableData> {
  final Value<int> id;
  final Value<int> escenarioId;
  final Value<int> numeroAlmacenes;
  final Value<int> costoTotalCent;
  final Value<String> costoPorRubroJson;
  final Value<bool> viableSegunServicio;
  const PuntoCurvaTableCompanion({
    this.id = const Value.absent(),
    this.escenarioId = const Value.absent(),
    this.numeroAlmacenes = const Value.absent(),
    this.costoTotalCent = const Value.absent(),
    this.costoPorRubroJson = const Value.absent(),
    this.viableSegunServicio = const Value.absent(),
  });
  PuntoCurvaTableCompanion.insert({
    this.id = const Value.absent(),
    required int escenarioId,
    required int numeroAlmacenes,
    required int costoTotalCent,
    required String costoPorRubroJson,
    required bool viableSegunServicio,
  }) : escenarioId = Value(escenarioId),
       numeroAlmacenes = Value(numeroAlmacenes),
       costoTotalCent = Value(costoTotalCent),
       costoPorRubroJson = Value(costoPorRubroJson),
       viableSegunServicio = Value(viableSegunServicio);
  static Insertable<PuntoCurvaTableData> custom({
    Expression<int>? id,
    Expression<int>? escenarioId,
    Expression<int>? numeroAlmacenes,
    Expression<int>? costoTotalCent,
    Expression<String>? costoPorRubroJson,
    Expression<bool>? viableSegunServicio,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (escenarioId != null) 'escenario_id': escenarioId,
      if (numeroAlmacenes != null) 'numero_almacenes': numeroAlmacenes,
      if (costoTotalCent != null) 'costo_total_cent': costoTotalCent,
      if (costoPorRubroJson != null) 'costo_por_rubro_json': costoPorRubroJson,
      if (viableSegunServicio != null)
        'viable_segun_servicio': viableSegunServicio,
    });
  }

  PuntoCurvaTableCompanion copyWith({
    Value<int>? id,
    Value<int>? escenarioId,
    Value<int>? numeroAlmacenes,
    Value<int>? costoTotalCent,
    Value<String>? costoPorRubroJson,
    Value<bool>? viableSegunServicio,
  }) {
    return PuntoCurvaTableCompanion(
      id: id ?? this.id,
      escenarioId: escenarioId ?? this.escenarioId,
      numeroAlmacenes: numeroAlmacenes ?? this.numeroAlmacenes,
      costoTotalCent: costoTotalCent ?? this.costoTotalCent,
      costoPorRubroJson: costoPorRubroJson ?? this.costoPorRubroJson,
      viableSegunServicio: viableSegunServicio ?? this.viableSegunServicio,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (escenarioId.present) {
      map['escenario_id'] = Variable<int>(escenarioId.value);
    }
    if (numeroAlmacenes.present) {
      map['numero_almacenes'] = Variable<int>(numeroAlmacenes.value);
    }
    if (costoTotalCent.present) {
      map['costo_total_cent'] = Variable<int>(costoTotalCent.value);
    }
    if (costoPorRubroJson.present) {
      map['costo_por_rubro_json'] = Variable<String>(costoPorRubroJson.value);
    }
    if (viableSegunServicio.present) {
      map['viable_segun_servicio'] = Variable<bool>(viableSegunServicio.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PuntoCurvaTableCompanion(')
          ..write('id: $id, ')
          ..write('escenarioId: $escenarioId, ')
          ..write('numeroAlmacenes: $numeroAlmacenes, ')
          ..write('costoTotalCent: $costoTotalCent, ')
          ..write('costoPorRubroJson: $costoPorRubroJson, ')
          ..write('viableSegunServicio: $viableSegunServicio')
          ..write(')'))
        .toString();
  }
}

class $MemoriaCalculoTableTable extends MemoriaCalculoTable
    with TableInfo<$MemoriaCalculoTableTable, MemoriaCalculoTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemoriaCalculoTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _escenarioIdMeta = const VerificationMeta(
    'escenarioId',
  );
  @override
  late final GeneratedColumn<int> escenarioId = GeneratedColumn<int>(
    'escenario_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES escenario (id) ON DELETE CASCADE',
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
  static const VerificationMeta _moduloMeta = const VerificationMeta('modulo');
  @override
  late final GeneratedColumn<String> modulo = GeneratedColumn<String>(
    'modulo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _formulaMeta = const VerificationMeta(
    'formula',
  );
  @override
  late final GeneratedColumn<String> formula = GeneratedColumn<String>(
    'formula',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entradasJsonMeta = const VerificationMeta(
    'entradasJson',
  );
  @override
  late final GeneratedColumn<String> entradasJson = GeneratedColumn<String>(
    'entradas_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _salidaMeta = const VerificationMeta('salida');
  @override
  late final GeneratedColumn<String> salida = GeneratedColumn<String>(
    'salida',
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    escenarioId,
    orden,
    modulo,
    formula,
    entradasJson,
    salida,
    unidad,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'memoria_calculo';
  @override
  VerificationContext validateIntegrity(
    Insertable<MemoriaCalculoTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('escenario_id')) {
      context.handle(
        _escenarioIdMeta,
        escenarioId.isAcceptableOrUnknown(
          data['escenario_id']!,
          _escenarioIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_escenarioIdMeta);
    }
    if (data.containsKey('orden')) {
      context.handle(
        _ordenMeta,
        orden.isAcceptableOrUnknown(data['orden']!, _ordenMeta),
      );
    } else if (isInserting) {
      context.missing(_ordenMeta);
    }
    if (data.containsKey('modulo')) {
      context.handle(
        _moduloMeta,
        modulo.isAcceptableOrUnknown(data['modulo']!, _moduloMeta),
      );
    } else if (isInserting) {
      context.missing(_moduloMeta);
    }
    if (data.containsKey('formula')) {
      context.handle(
        _formulaMeta,
        formula.isAcceptableOrUnknown(data['formula']!, _formulaMeta),
      );
    } else if (isInserting) {
      context.missing(_formulaMeta);
    }
    if (data.containsKey('entradas_json')) {
      context.handle(
        _entradasJsonMeta,
        entradasJson.isAcceptableOrUnknown(
          data['entradas_json']!,
          _entradasJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_entradasJsonMeta);
    }
    if (data.containsKey('salida')) {
      context.handle(
        _salidaMeta,
        salida.isAcceptableOrUnknown(data['salida']!, _salidaMeta),
      );
    } else if (isInserting) {
      context.missing(_salidaMeta);
    }
    if (data.containsKey('unidad')) {
      context.handle(
        _unidadMeta,
        unidad.isAcceptableOrUnknown(data['unidad']!, _unidadMeta),
      );
    } else if (isInserting) {
      context.missing(_unidadMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MemoriaCalculoTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemoriaCalculoTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      escenarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}escenario_id'],
      )!,
      orden: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}orden'],
      )!,
      modulo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}modulo'],
      )!,
      formula: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}formula'],
      )!,
      entradasJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entradas_json'],
      )!,
      salida: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}salida'],
      )!,
      unidad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unidad'],
      )!,
    );
  }

  @override
  $MemoriaCalculoTableTable createAlias(String alias) {
    return $MemoriaCalculoTableTable(attachedDatabase, alias);
  }
}

class MemoriaCalculoTableData extends DataClass
    implements Insertable<MemoriaCalculoTableData> {
  final int id;
  final int escenarioId;
  final int orden;
  final String modulo;
  final String formula;
  final String entradasJson;
  final String salida;
  final String unidad;
  const MemoriaCalculoTableData({
    required this.id,
    required this.escenarioId,
    required this.orden,
    required this.modulo,
    required this.formula,
    required this.entradasJson,
    required this.salida,
    required this.unidad,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['escenario_id'] = Variable<int>(escenarioId);
    map['orden'] = Variable<int>(orden);
    map['modulo'] = Variable<String>(modulo);
    map['formula'] = Variable<String>(formula);
    map['entradas_json'] = Variable<String>(entradasJson);
    map['salida'] = Variable<String>(salida);
    map['unidad'] = Variable<String>(unidad);
    return map;
  }

  MemoriaCalculoTableCompanion toCompanion(bool nullToAbsent) {
    return MemoriaCalculoTableCompanion(
      id: Value(id),
      escenarioId: Value(escenarioId),
      orden: Value(orden),
      modulo: Value(modulo),
      formula: Value(formula),
      entradasJson: Value(entradasJson),
      salida: Value(salida),
      unidad: Value(unidad),
    );
  }

  factory MemoriaCalculoTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemoriaCalculoTableData(
      id: serializer.fromJson<int>(json['id']),
      escenarioId: serializer.fromJson<int>(json['escenarioId']),
      orden: serializer.fromJson<int>(json['orden']),
      modulo: serializer.fromJson<String>(json['modulo']),
      formula: serializer.fromJson<String>(json['formula']),
      entradasJson: serializer.fromJson<String>(json['entradasJson']),
      salida: serializer.fromJson<String>(json['salida']),
      unidad: serializer.fromJson<String>(json['unidad']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'escenarioId': serializer.toJson<int>(escenarioId),
      'orden': serializer.toJson<int>(orden),
      'modulo': serializer.toJson<String>(modulo),
      'formula': serializer.toJson<String>(formula),
      'entradasJson': serializer.toJson<String>(entradasJson),
      'salida': serializer.toJson<String>(salida),
      'unidad': serializer.toJson<String>(unidad),
    };
  }

  MemoriaCalculoTableData copyWith({
    int? id,
    int? escenarioId,
    int? orden,
    String? modulo,
    String? formula,
    String? entradasJson,
    String? salida,
    String? unidad,
  }) => MemoriaCalculoTableData(
    id: id ?? this.id,
    escenarioId: escenarioId ?? this.escenarioId,
    orden: orden ?? this.orden,
    modulo: modulo ?? this.modulo,
    formula: formula ?? this.formula,
    entradasJson: entradasJson ?? this.entradasJson,
    salida: salida ?? this.salida,
    unidad: unidad ?? this.unidad,
  );
  MemoriaCalculoTableData copyWithCompanion(MemoriaCalculoTableCompanion data) {
    return MemoriaCalculoTableData(
      id: data.id.present ? data.id.value : this.id,
      escenarioId: data.escenarioId.present
          ? data.escenarioId.value
          : this.escenarioId,
      orden: data.orden.present ? data.orden.value : this.orden,
      modulo: data.modulo.present ? data.modulo.value : this.modulo,
      formula: data.formula.present ? data.formula.value : this.formula,
      entradasJson: data.entradasJson.present
          ? data.entradasJson.value
          : this.entradasJson,
      salida: data.salida.present ? data.salida.value : this.salida,
      unidad: data.unidad.present ? data.unidad.value : this.unidad,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemoriaCalculoTableData(')
          ..write('id: $id, ')
          ..write('escenarioId: $escenarioId, ')
          ..write('orden: $orden, ')
          ..write('modulo: $modulo, ')
          ..write('formula: $formula, ')
          ..write('entradasJson: $entradasJson, ')
          ..write('salida: $salida, ')
          ..write('unidad: $unidad')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    escenarioId,
    orden,
    modulo,
    formula,
    entradasJson,
    salida,
    unidad,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemoriaCalculoTableData &&
          other.id == this.id &&
          other.escenarioId == this.escenarioId &&
          other.orden == this.orden &&
          other.modulo == this.modulo &&
          other.formula == this.formula &&
          other.entradasJson == this.entradasJson &&
          other.salida == this.salida &&
          other.unidad == this.unidad);
}

class MemoriaCalculoTableCompanion
    extends UpdateCompanion<MemoriaCalculoTableData> {
  final Value<int> id;
  final Value<int> escenarioId;
  final Value<int> orden;
  final Value<String> modulo;
  final Value<String> formula;
  final Value<String> entradasJson;
  final Value<String> salida;
  final Value<String> unidad;
  const MemoriaCalculoTableCompanion({
    this.id = const Value.absent(),
    this.escenarioId = const Value.absent(),
    this.orden = const Value.absent(),
    this.modulo = const Value.absent(),
    this.formula = const Value.absent(),
    this.entradasJson = const Value.absent(),
    this.salida = const Value.absent(),
    this.unidad = const Value.absent(),
  });
  MemoriaCalculoTableCompanion.insert({
    this.id = const Value.absent(),
    required int escenarioId,
    required int orden,
    required String modulo,
    required String formula,
    required String entradasJson,
    required String salida,
    required String unidad,
  }) : escenarioId = Value(escenarioId),
       orden = Value(orden),
       modulo = Value(modulo),
       formula = Value(formula),
       entradasJson = Value(entradasJson),
       salida = Value(salida),
       unidad = Value(unidad);
  static Insertable<MemoriaCalculoTableData> custom({
    Expression<int>? id,
    Expression<int>? escenarioId,
    Expression<int>? orden,
    Expression<String>? modulo,
    Expression<String>? formula,
    Expression<String>? entradasJson,
    Expression<String>? salida,
    Expression<String>? unidad,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (escenarioId != null) 'escenario_id': escenarioId,
      if (orden != null) 'orden': orden,
      if (modulo != null) 'modulo': modulo,
      if (formula != null) 'formula': formula,
      if (entradasJson != null) 'entradas_json': entradasJson,
      if (salida != null) 'salida': salida,
      if (unidad != null) 'unidad': unidad,
    });
  }

  MemoriaCalculoTableCompanion copyWith({
    Value<int>? id,
    Value<int>? escenarioId,
    Value<int>? orden,
    Value<String>? modulo,
    Value<String>? formula,
    Value<String>? entradasJson,
    Value<String>? salida,
    Value<String>? unidad,
  }) {
    return MemoriaCalculoTableCompanion(
      id: id ?? this.id,
      escenarioId: escenarioId ?? this.escenarioId,
      orden: orden ?? this.orden,
      modulo: modulo ?? this.modulo,
      formula: formula ?? this.formula,
      entradasJson: entradasJson ?? this.entradasJson,
      salida: salida ?? this.salida,
      unidad: unidad ?? this.unidad,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (escenarioId.present) {
      map['escenario_id'] = Variable<int>(escenarioId.value);
    }
    if (orden.present) {
      map['orden'] = Variable<int>(orden.value);
    }
    if (modulo.present) {
      map['modulo'] = Variable<String>(modulo.value);
    }
    if (formula.present) {
      map['formula'] = Variable<String>(formula.value);
    }
    if (entradasJson.present) {
      map['entradas_json'] = Variable<String>(entradasJson.value);
    }
    if (salida.present) {
      map['salida'] = Variable<String>(salida.value);
    }
    if (unidad.present) {
      map['unidad'] = Variable<String>(unidad.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemoriaCalculoTableCompanion(')
          ..write('id: $id, ')
          ..write('escenarioId: $escenarioId, ')
          ..write('orden: $orden, ')
          ..write('modulo: $modulo, ')
          ..write('formula: $formula, ')
          ..write('entradasJson: $entradasJson, ')
          ..write('salida: $salida, ')
          ..write('unidad: $unidad')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProyectoTableTable proyectoTable = $ProyectoTableTable(this);
  late final $ClienteTableTable clienteTable = $ClienteTableTable(this);
  late final $ZonaDemandaTableTable zonaDemandaTable = $ZonaDemandaTableTable(
    this,
  );
  late final $ClienteZonaTableTable clienteZonaTable = $ClienteZonaTableTable(
    this,
  );
  late final $SitioCandidatoTableTable sitioCandidatoTable =
      $SitioCandidatoTableTable(this);
  late final $PlantaTableTable plantaTable = $PlantaTableTable(this);
  late final $ParametrosCostoTableTable parametrosCostoTable =
      $ParametrosCostoTableTable(this);
  late final $CeldaMatrizTableTable celdaMatrizTable = $CeldaMatrizTableTable(
    this,
  );
  late final $CacheRuteoTableTable cacheRuteoTable = $CacheRuteoTableTable(
    this,
  );
  late final $EscenarioTableTable escenarioTable = $EscenarioTableTable(this);
  late final $EscenarioAlmacenTableTable escenarioAlmacenTable =
      $EscenarioAlmacenTableTable(this);
  late final $EscenarioAsignacionTableTable escenarioAsignacionTable =
      $EscenarioAsignacionTableTable(this);
  late final $EscenarioCostoTableTable escenarioCostoTable =
      $EscenarioCostoTableTable(this);
  late final $PuntoCurvaTableTable puntoCurvaTable = $PuntoCurvaTableTable(
    this,
  );
  late final $MemoriaCalculoTableTable memoriaCalculoTable =
      $MemoriaCalculoTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    proyectoTable,
    clienteTable,
    zonaDemandaTable,
    clienteZonaTable,
    sitioCandidatoTable,
    plantaTable,
    parametrosCostoTable,
    celdaMatrizTable,
    cacheRuteoTable,
    escenarioTable,
    escenarioAlmacenTable,
    escenarioAsignacionTable,
    escenarioCostoTable,
    puntoCurvaTable,
    memoriaCalculoTable,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'proyecto',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('cliente', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'proyecto',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('zona_demanda', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'cliente',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('cliente_zona', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'zona_demanda',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('cliente_zona', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'proyecto',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('sitio_candidato', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'proyecto',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('planta', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'proyecto',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('parametros_costo', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'proyecto',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('celda_matriz', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'proyecto',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('escenario', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'escenario',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('escenario_almacen', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'escenario',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('escenario_asignacion', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'escenario',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('escenario_costo', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'escenario',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('punto_curva', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'escenario',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('memoria_calculo', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ProyectoTableTableCreateCompanionBuilder =
    ProyectoTableCompanion Function({
      Value<int> id,
      required String nombre,
      Value<String> moneda,
      Value<String> unidadPeso,
      Value<int> horizonteAnios,
      Value<double> factorCircuidad,
      required String creadoEn,
    });
typedef $$ProyectoTableTableUpdateCompanionBuilder =
    ProyectoTableCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<String> moneda,
      Value<String> unidadPeso,
      Value<int> horizonteAnios,
      Value<double> factorCircuidad,
      Value<String> creadoEn,
    });

final class $$ProyectoTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $ProyectoTableTable, ProyectoTableData> {
  $$ProyectoTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ClienteTableTable, List<ClienteTableData>>
  _clienteTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.clienteTable,
    aliasName: 'proyecto__id__cliente__proyecto_id',
  );

  $$ClienteTableTableProcessedTableManager get clienteTableRefs {
    final manager = $$ClienteTableTableTableManager(
      $_db,
      $_db.clienteTable,
    ).filter((f) => f.proyectoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_clienteTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ZonaDemandaTableTable, List<ZonaDemandaTableData>>
  _zonaDemandaTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.zonaDemandaTable,
    aliasName: 'proyecto__id__zona_demanda__proyecto_id',
  );

  $$ZonaDemandaTableTableProcessedTableManager get zonaDemandaTableRefs {
    final manager = $$ZonaDemandaTableTableTableManager(
      $_db,
      $_db.zonaDemandaTable,
    ).filter((f) => f.proyectoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _zonaDemandaTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $SitioCandidatoTableTable,
    List<SitioCandidatoTableData>
  >
  _sitioCandidatoTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.sitioCandidatoTable,
        aliasName: 'proyecto__id__sitio_candidato__proyecto_id',
      );

  $$SitioCandidatoTableTableProcessedTableManager get sitioCandidatoTableRefs {
    final manager = $$SitioCandidatoTableTableTableManager(
      $_db,
      $_db.sitioCandidatoTable,
    ).filter((f) => f.proyectoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _sitioCandidatoTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PlantaTableTable, List<PlantaTableData>>
  _plantaTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.plantaTable,
    aliasName: 'proyecto__id__planta__proyecto_id',
  );

  $$PlantaTableTableProcessedTableManager get plantaTableRefs {
    final manager = $$PlantaTableTableTableManager(
      $_db,
      $_db.plantaTable,
    ).filter((f) => f.proyectoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_plantaTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ParametrosCostoTableTable,
    List<ParametrosCostoTableData>
  >
  _parametrosCostoTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.parametrosCostoTable,
        aliasName: 'proyecto__id__parametros_costo__proyecto_id',
      );

  $$ParametrosCostoTableTableProcessedTableManager
  get parametrosCostoTableRefs {
    final manager = $$ParametrosCostoTableTableTableManager(
      $_db,
      $_db.parametrosCostoTable,
    ).filter((f) => f.proyectoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _parametrosCostoTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CeldaMatrizTableTable, List<CeldaMatrizTableData>>
  _celdaMatrizTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.celdaMatrizTable,
    aliasName: 'proyecto__id__celda_matriz__proyecto_id',
  );

  $$CeldaMatrizTableTableProcessedTableManager get celdaMatrizTableRefs {
    final manager = $$CeldaMatrizTableTableTableManager(
      $_db,
      $_db.celdaMatrizTable,
    ).filter((f) => f.proyectoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _celdaMatrizTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$EscenarioTableTable, List<EscenarioTableData>>
  _escenarioTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.escenarioTable,
    aliasName: 'proyecto__id__escenario__proyecto_id',
  );

  $$EscenarioTableTableProcessedTableManager get escenarioTableRefs {
    final manager = $$EscenarioTableTableTableManager(
      $_db,
      $_db.escenarioTable,
    ).filter((f) => f.proyectoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_escenarioTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProyectoTableTableFilterComposer
    extends Composer<_$AppDatabase, $ProyectoTableTable> {
  $$ProyectoTableTableFilterComposer({
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

  ColumnFilters<String> get unidadPeso => $composableBuilder(
    column: $table.unidadPeso,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get horizonteAnios => $composableBuilder(
    column: $table.horizonteAnios,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get factorCircuidad => $composableBuilder(
    column: $table.factorCircuidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> clienteTableRefs(
    Expression<bool> Function($$ClienteTableTableFilterComposer f) f,
  ) {
    final $$ClienteTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.clienteTable,
      getReferencedColumn: (t) => t.proyectoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClienteTableTableFilterComposer(
            $db: $db,
            $table: $db.clienteTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> zonaDemandaTableRefs(
    Expression<bool> Function($$ZonaDemandaTableTableFilterComposer f) f,
  ) {
    final $$ZonaDemandaTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.zonaDemandaTable,
      getReferencedColumn: (t) => t.proyectoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ZonaDemandaTableTableFilterComposer(
            $db: $db,
            $table: $db.zonaDemandaTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sitioCandidatoTableRefs(
    Expression<bool> Function($$SitioCandidatoTableTableFilterComposer f) f,
  ) {
    final $$SitioCandidatoTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sitioCandidatoTable,
      getReferencedColumn: (t) => t.proyectoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitioCandidatoTableTableFilterComposer(
            $db: $db,
            $table: $db.sitioCandidatoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> plantaTableRefs(
    Expression<bool> Function($$PlantaTableTableFilterComposer f) f,
  ) {
    final $$PlantaTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.plantaTable,
      getReferencedColumn: (t) => t.proyectoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlantaTableTableFilterComposer(
            $db: $db,
            $table: $db.plantaTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> parametrosCostoTableRefs(
    Expression<bool> Function($$ParametrosCostoTableTableFilterComposer f) f,
  ) {
    final $$ParametrosCostoTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.parametrosCostoTable,
      getReferencedColumn: (t) => t.proyectoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ParametrosCostoTableTableFilterComposer(
            $db: $db,
            $table: $db.parametrosCostoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> celdaMatrizTableRefs(
    Expression<bool> Function($$CeldaMatrizTableTableFilterComposer f) f,
  ) {
    final $$CeldaMatrizTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.celdaMatrizTable,
      getReferencedColumn: (t) => t.proyectoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CeldaMatrizTableTableFilterComposer(
            $db: $db,
            $table: $db.celdaMatrizTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> escenarioTableRefs(
    Expression<bool> Function($$EscenarioTableTableFilterComposer f) f,
  ) {
    final $$EscenarioTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.escenarioTable,
      getReferencedColumn: (t) => t.proyectoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EscenarioTableTableFilterComposer(
            $db: $db,
            $table: $db.escenarioTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProyectoTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ProyectoTableTable> {
  $$ProyectoTableTableOrderingComposer({
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

  ColumnOrderings<String> get unidadPeso => $composableBuilder(
    column: $table.unidadPeso,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get horizonteAnios => $composableBuilder(
    column: $table.horizonteAnios,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get factorCircuidad => $composableBuilder(
    column: $table.factorCircuidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProyectoTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProyectoTableTable> {
  $$ProyectoTableTableAnnotationComposer({
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

  GeneratedColumn<String> get unidadPeso => $composableBuilder(
    column: $table.unidadPeso,
    builder: (column) => column,
  );

  GeneratedColumn<int> get horizonteAnios => $composableBuilder(
    column: $table.horizonteAnios,
    builder: (column) => column,
  );

  GeneratedColumn<double> get factorCircuidad => $composableBuilder(
    column: $table.factorCircuidad,
    builder: (column) => column,
  );

  GeneratedColumn<String> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  Expression<T> clienteTableRefs<T extends Object>(
    Expression<T> Function($$ClienteTableTableAnnotationComposer a) f,
  ) {
    final $$ClienteTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.clienteTable,
      getReferencedColumn: (t) => t.proyectoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClienteTableTableAnnotationComposer(
            $db: $db,
            $table: $db.clienteTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> zonaDemandaTableRefs<T extends Object>(
    Expression<T> Function($$ZonaDemandaTableTableAnnotationComposer a) f,
  ) {
    final $$ZonaDemandaTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.zonaDemandaTable,
      getReferencedColumn: (t) => t.proyectoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ZonaDemandaTableTableAnnotationComposer(
            $db: $db,
            $table: $db.zonaDemandaTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> sitioCandidatoTableRefs<T extends Object>(
    Expression<T> Function($$SitioCandidatoTableTableAnnotationComposer a) f,
  ) {
    final $$SitioCandidatoTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.sitioCandidatoTable,
          getReferencedColumn: (t) => t.proyectoId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SitioCandidatoTableTableAnnotationComposer(
                $db: $db,
                $table: $db.sitioCandidatoTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> plantaTableRefs<T extends Object>(
    Expression<T> Function($$PlantaTableTableAnnotationComposer a) f,
  ) {
    final $$PlantaTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.plantaTable,
      getReferencedColumn: (t) => t.proyectoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlantaTableTableAnnotationComposer(
            $db: $db,
            $table: $db.plantaTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> parametrosCostoTableRefs<T extends Object>(
    Expression<T> Function($$ParametrosCostoTableTableAnnotationComposer a) f,
  ) {
    final $$ParametrosCostoTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.parametrosCostoTable,
          getReferencedColumn: (t) => t.proyectoId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ParametrosCostoTableTableAnnotationComposer(
                $db: $db,
                $table: $db.parametrosCostoTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> celdaMatrizTableRefs<T extends Object>(
    Expression<T> Function($$CeldaMatrizTableTableAnnotationComposer a) f,
  ) {
    final $$CeldaMatrizTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.celdaMatrizTable,
      getReferencedColumn: (t) => t.proyectoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CeldaMatrizTableTableAnnotationComposer(
            $db: $db,
            $table: $db.celdaMatrizTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> escenarioTableRefs<T extends Object>(
    Expression<T> Function($$EscenarioTableTableAnnotationComposer a) f,
  ) {
    final $$EscenarioTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.escenarioTable,
      getReferencedColumn: (t) => t.proyectoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EscenarioTableTableAnnotationComposer(
            $db: $db,
            $table: $db.escenarioTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProyectoTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProyectoTableTable,
          ProyectoTableData,
          $$ProyectoTableTableFilterComposer,
          $$ProyectoTableTableOrderingComposer,
          $$ProyectoTableTableAnnotationComposer,
          $$ProyectoTableTableCreateCompanionBuilder,
          $$ProyectoTableTableUpdateCompanionBuilder,
          (ProyectoTableData, $$ProyectoTableTableReferences),
          ProyectoTableData,
          PrefetchHooks Function({
            bool clienteTableRefs,
            bool zonaDemandaTableRefs,
            bool sitioCandidatoTableRefs,
            bool plantaTableRefs,
            bool parametrosCostoTableRefs,
            bool celdaMatrizTableRefs,
            bool escenarioTableRefs,
          })
        > {
  $$ProyectoTableTableTableManager(_$AppDatabase db, $ProyectoTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProyectoTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProyectoTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProyectoTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> moneda = const Value.absent(),
                Value<String> unidadPeso = const Value.absent(),
                Value<int> horizonteAnios = const Value.absent(),
                Value<double> factorCircuidad = const Value.absent(),
                Value<String> creadoEn = const Value.absent(),
              }) => ProyectoTableCompanion(
                id: id,
                nombre: nombre,
                moneda: moneda,
                unidadPeso: unidadPeso,
                horizonteAnios: horizonteAnios,
                factorCircuidad: factorCircuidad,
                creadoEn: creadoEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                Value<String> moneda = const Value.absent(),
                Value<String> unidadPeso = const Value.absent(),
                Value<int> horizonteAnios = const Value.absent(),
                Value<double> factorCircuidad = const Value.absent(),
                required String creadoEn,
              }) => ProyectoTableCompanion.insert(
                id: id,
                nombre: nombre,
                moneda: moneda,
                unidadPeso: unidadPeso,
                horizonteAnios: horizonteAnios,
                factorCircuidad: factorCircuidad,
                creadoEn: creadoEn,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProyectoTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                clienteTableRefs = false,
                zonaDemandaTableRefs = false,
                sitioCandidatoTableRefs = false,
                plantaTableRefs = false,
                parametrosCostoTableRefs = false,
                celdaMatrizTableRefs = false,
                escenarioTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (clienteTableRefs) db.clienteTable,
                    if (zonaDemandaTableRefs) db.zonaDemandaTable,
                    if (sitioCandidatoTableRefs) db.sitioCandidatoTable,
                    if (plantaTableRefs) db.plantaTable,
                    if (parametrosCostoTableRefs) db.parametrosCostoTable,
                    if (celdaMatrizTableRefs) db.celdaMatrizTable,
                    if (escenarioTableRefs) db.escenarioTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (clienteTableRefs)
                        await $_getPrefetchedData<
                          ProyectoTableData,
                          $ProyectoTableTable,
                          ClienteTableData
                        >(
                          currentTable: table,
                          referencedTable: $$ProyectoTableTableReferences
                              ._clienteTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProyectoTableTableReferences(
                                db,
                                table,
                                p0,
                              ).clienteTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.proyectoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (zonaDemandaTableRefs)
                        await $_getPrefetchedData<
                          ProyectoTableData,
                          $ProyectoTableTable,
                          ZonaDemandaTableData
                        >(
                          currentTable: table,
                          referencedTable: $$ProyectoTableTableReferences
                              ._zonaDemandaTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProyectoTableTableReferences(
                                db,
                                table,
                                p0,
                              ).zonaDemandaTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.proyectoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (sitioCandidatoTableRefs)
                        await $_getPrefetchedData<
                          ProyectoTableData,
                          $ProyectoTableTable,
                          SitioCandidatoTableData
                        >(
                          currentTable: table,
                          referencedTable: $$ProyectoTableTableReferences
                              ._sitioCandidatoTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProyectoTableTableReferences(
                                db,
                                table,
                                p0,
                              ).sitioCandidatoTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.proyectoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (plantaTableRefs)
                        await $_getPrefetchedData<
                          ProyectoTableData,
                          $ProyectoTableTable,
                          PlantaTableData
                        >(
                          currentTable: table,
                          referencedTable: $$ProyectoTableTableReferences
                              ._plantaTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProyectoTableTableReferences(
                                db,
                                table,
                                p0,
                              ).plantaTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.proyectoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (parametrosCostoTableRefs)
                        await $_getPrefetchedData<
                          ProyectoTableData,
                          $ProyectoTableTable,
                          ParametrosCostoTableData
                        >(
                          currentTable: table,
                          referencedTable: $$ProyectoTableTableReferences
                              ._parametrosCostoTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProyectoTableTableReferences(
                                db,
                                table,
                                p0,
                              ).parametrosCostoTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.proyectoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (celdaMatrizTableRefs)
                        await $_getPrefetchedData<
                          ProyectoTableData,
                          $ProyectoTableTable,
                          CeldaMatrizTableData
                        >(
                          currentTable: table,
                          referencedTable: $$ProyectoTableTableReferences
                              ._celdaMatrizTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProyectoTableTableReferences(
                                db,
                                table,
                                p0,
                              ).celdaMatrizTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.proyectoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (escenarioTableRefs)
                        await $_getPrefetchedData<
                          ProyectoTableData,
                          $ProyectoTableTable,
                          EscenarioTableData
                        >(
                          currentTable: table,
                          referencedTable: $$ProyectoTableTableReferences
                              ._escenarioTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProyectoTableTableReferences(
                                db,
                                table,
                                p0,
                              ).escenarioTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.proyectoId == item.id,
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

typedef $$ProyectoTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProyectoTableTable,
      ProyectoTableData,
      $$ProyectoTableTableFilterComposer,
      $$ProyectoTableTableOrderingComposer,
      $$ProyectoTableTableAnnotationComposer,
      $$ProyectoTableTableCreateCompanionBuilder,
      $$ProyectoTableTableUpdateCompanionBuilder,
      (ProyectoTableData, $$ProyectoTableTableReferences),
      ProyectoTableData,
      PrefetchHooks Function({
        bool clienteTableRefs,
        bool zonaDemandaTableRefs,
        bool sitioCandidatoTableRefs,
        bool plantaTableRefs,
        bool parametrosCostoTableRefs,
        bool celdaMatrizTableRefs,
        bool escenarioTableRefs,
      })
    >;
typedef $$ClienteTableTableCreateCompanionBuilder =
    ClienteTableCompanion Function({
      Value<int> id,
      required int proyectoId,
      required String nombre,
      required double latitud,
      required double longitud,
      required double demandaAnual,
      required int pedidosAnuales,
      Value<bool> activo,
    });
typedef $$ClienteTableTableUpdateCompanionBuilder =
    ClienteTableCompanion Function({
      Value<int> id,
      Value<int> proyectoId,
      Value<String> nombre,
      Value<double> latitud,
      Value<double> longitud,
      Value<double> demandaAnual,
      Value<int> pedidosAnuales,
      Value<bool> activo,
    });

final class $$ClienteTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $ClienteTableTable, ClienteTableData> {
  $$ClienteTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProyectoTableTable _proyectoIdTable(_$AppDatabase db) =>
      db.proyectoTable.createAlias('cliente__proyecto_id__proyecto__id');

  $$ProyectoTableTableProcessedTableManager get proyectoId {
    final $_column = $_itemColumn<int>('proyecto_id')!;

    final manager = $$ProyectoTableTableTableManager(
      $_db,
      $_db.proyectoTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_proyectoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ClienteZonaTableTable, List<ClienteZonaTableData>>
  _clienteZonaTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.clienteZonaTable,
    aliasName: 'cliente__id__cliente_zona__cliente_id',
  );

  $$ClienteZonaTableTableProcessedTableManager get clienteZonaTableRefs {
    final manager = $$ClienteZonaTableTableTableManager(
      $_db,
      $_db.clienteZonaTable,
    ).filter((f) => f.clienteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _clienteZonaTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ClienteTableTableFilterComposer
    extends Composer<_$AppDatabase, $ClienteTableTable> {
  $$ClienteTableTableFilterComposer({
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

  ColumnFilters<double> get latitud => $composableBuilder(
    column: $table.latitud,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitud => $composableBuilder(
    column: $table.longitud,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get demandaAnual => $composableBuilder(
    column: $table.demandaAnual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pedidosAnuales => $composableBuilder(
    column: $table.pedidosAnuales,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  $$ProyectoTableTableFilterComposer get proyectoId {
    final $$ProyectoTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proyectoId,
      referencedTable: $db.proyectoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProyectoTableTableFilterComposer(
            $db: $db,
            $table: $db.proyectoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> clienteZonaTableRefs(
    Expression<bool> Function($$ClienteZonaTableTableFilterComposer f) f,
  ) {
    final $$ClienteZonaTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.clienteZonaTable,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClienteZonaTableTableFilterComposer(
            $db: $db,
            $table: $db.clienteZonaTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClienteTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ClienteTableTable> {
  $$ClienteTableTableOrderingComposer({
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

  ColumnOrderings<double> get latitud => $composableBuilder(
    column: $table.latitud,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitud => $composableBuilder(
    column: $table.longitud,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get demandaAnual => $composableBuilder(
    column: $table.demandaAnual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pedidosAnuales => $composableBuilder(
    column: $table.pedidosAnuales,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProyectoTableTableOrderingComposer get proyectoId {
    final $$ProyectoTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proyectoId,
      referencedTable: $db.proyectoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProyectoTableTableOrderingComposer(
            $db: $db,
            $table: $db.proyectoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClienteTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClienteTableTable> {
  $$ClienteTableTableAnnotationComposer({
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

  GeneratedColumn<double> get latitud =>
      $composableBuilder(column: $table.latitud, builder: (column) => column);

  GeneratedColumn<double> get longitud =>
      $composableBuilder(column: $table.longitud, builder: (column) => column);

  GeneratedColumn<double> get demandaAnual => $composableBuilder(
    column: $table.demandaAnual,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pedidosAnuales => $composableBuilder(
    column: $table.pedidosAnuales,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  $$ProyectoTableTableAnnotationComposer get proyectoId {
    final $$ProyectoTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proyectoId,
      referencedTable: $db.proyectoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProyectoTableTableAnnotationComposer(
            $db: $db,
            $table: $db.proyectoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> clienteZonaTableRefs<T extends Object>(
    Expression<T> Function($$ClienteZonaTableTableAnnotationComposer a) f,
  ) {
    final $$ClienteZonaTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.clienteZonaTable,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClienteZonaTableTableAnnotationComposer(
            $db: $db,
            $table: $db.clienteZonaTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClienteTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClienteTableTable,
          ClienteTableData,
          $$ClienteTableTableFilterComposer,
          $$ClienteTableTableOrderingComposer,
          $$ClienteTableTableAnnotationComposer,
          $$ClienteTableTableCreateCompanionBuilder,
          $$ClienteTableTableUpdateCompanionBuilder,
          (ClienteTableData, $$ClienteTableTableReferences),
          ClienteTableData,
          PrefetchHooks Function({bool proyectoId, bool clienteZonaTableRefs})
        > {
  $$ClienteTableTableTableManager(_$AppDatabase db, $ClienteTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClienteTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClienteTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClienteTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> proyectoId = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<double> latitud = const Value.absent(),
                Value<double> longitud = const Value.absent(),
                Value<double> demandaAnual = const Value.absent(),
                Value<int> pedidosAnuales = const Value.absent(),
                Value<bool> activo = const Value.absent(),
              }) => ClienteTableCompanion(
                id: id,
                proyectoId: proyectoId,
                nombre: nombre,
                latitud: latitud,
                longitud: longitud,
                demandaAnual: demandaAnual,
                pedidosAnuales: pedidosAnuales,
                activo: activo,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int proyectoId,
                required String nombre,
                required double latitud,
                required double longitud,
                required double demandaAnual,
                required int pedidosAnuales,
                Value<bool> activo = const Value.absent(),
              }) => ClienteTableCompanion.insert(
                id: id,
                proyectoId: proyectoId,
                nombre: nombre,
                latitud: latitud,
                longitud: longitud,
                demandaAnual: demandaAnual,
                pedidosAnuales: pedidosAnuales,
                activo: activo,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ClienteTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({proyectoId = false, clienteZonaTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (clienteZonaTableRefs) db.clienteZonaTable,
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
                        if (proyectoId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.proyectoId,
                            referencedTable: $$ClienteTableTableReferences
                                ._proyectoIdTable(db),
                            referencedColumn: $$ClienteTableTableReferences
                                ._proyectoIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (clienteZonaTableRefs)
                        await $_getPrefetchedData<
                          ClienteTableData,
                          $ClienteTableTable,
                          ClienteZonaTableData
                        >(
                          currentTable: table,
                          referencedTable: $$ClienteTableTableReferences
                              ._clienteZonaTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ClienteTableTableReferences(
                                db,
                                table,
                                p0,
                              ).clienteZonaTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.clienteId == item.id,
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

typedef $$ClienteTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClienteTableTable,
      ClienteTableData,
      $$ClienteTableTableFilterComposer,
      $$ClienteTableTableOrderingComposer,
      $$ClienteTableTableAnnotationComposer,
      $$ClienteTableTableCreateCompanionBuilder,
      $$ClienteTableTableUpdateCompanionBuilder,
      (ClienteTableData, $$ClienteTableTableReferences),
      ClienteTableData,
      PrefetchHooks Function({bool proyectoId, bool clienteZonaTableRefs})
    >;
typedef $$ZonaDemandaTableTableCreateCompanionBuilder =
    ZonaDemandaTableCompanion Function({
      Value<int> id,
      required int proyectoId,
      required String etiqueta,
      required double latitud,
      required double longitud,
      required double demandaAgregada,
      required int pedidosAgregados,
      required int numeroClientes,
      required int errorAgregacionMetros,
    });
typedef $$ZonaDemandaTableTableUpdateCompanionBuilder =
    ZonaDemandaTableCompanion Function({
      Value<int> id,
      Value<int> proyectoId,
      Value<String> etiqueta,
      Value<double> latitud,
      Value<double> longitud,
      Value<double> demandaAgregada,
      Value<int> pedidosAgregados,
      Value<int> numeroClientes,
      Value<int> errorAgregacionMetros,
    });

final class $$ZonaDemandaTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ZonaDemandaTableTable,
          ZonaDemandaTableData
        > {
  $$ZonaDemandaTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProyectoTableTable _proyectoIdTable(_$AppDatabase db) =>
      db.proyectoTable.createAlias('zona_demanda__proyecto_id__proyecto__id');

  $$ProyectoTableTableProcessedTableManager get proyectoId {
    final $_column = $_itemColumn<int>('proyecto_id')!;

    final manager = $$ProyectoTableTableTableManager(
      $_db,
      $_db.proyectoTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_proyectoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ClienteZonaTableTable, List<ClienteZonaTableData>>
  _clienteZonaTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.clienteZonaTable,
    aliasName: 'zona_demanda__id__cliente_zona__zona_id',
  );

  $$ClienteZonaTableTableProcessedTableManager get clienteZonaTableRefs {
    final manager = $$ClienteZonaTableTableTableManager(
      $_db,
      $_db.clienteZonaTable,
    ).filter((f) => f.zonaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _clienteZonaTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $EscenarioAsignacionTableTable,
    List<EscenarioAsignacionTableData>
  >
  _escenarioAsignacionTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.escenarioAsignacionTable,
        aliasName: 'zona_demanda__id__escenario_asignacion__zona_id',
      );

  $$EscenarioAsignacionTableTableProcessedTableManager
  get escenarioAsignacionTableRefs {
    final manager = $$EscenarioAsignacionTableTableTableManager(
      $_db,
      $_db.escenarioAsignacionTable,
    ).filter((f) => f.zonaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _escenarioAsignacionTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ZonaDemandaTableTableFilterComposer
    extends Composer<_$AppDatabase, $ZonaDemandaTableTable> {
  $$ZonaDemandaTableTableFilterComposer({
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

  ColumnFilters<String> get etiqueta => $composableBuilder(
    column: $table.etiqueta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitud => $composableBuilder(
    column: $table.latitud,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitud => $composableBuilder(
    column: $table.longitud,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get demandaAgregada => $composableBuilder(
    column: $table.demandaAgregada,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pedidosAgregados => $composableBuilder(
    column: $table.pedidosAgregados,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get numeroClientes => $composableBuilder(
    column: $table.numeroClientes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get errorAgregacionMetros => $composableBuilder(
    column: $table.errorAgregacionMetros,
    builder: (column) => ColumnFilters(column),
  );

  $$ProyectoTableTableFilterComposer get proyectoId {
    final $$ProyectoTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proyectoId,
      referencedTable: $db.proyectoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProyectoTableTableFilterComposer(
            $db: $db,
            $table: $db.proyectoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> clienteZonaTableRefs(
    Expression<bool> Function($$ClienteZonaTableTableFilterComposer f) f,
  ) {
    final $$ClienteZonaTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.clienteZonaTable,
      getReferencedColumn: (t) => t.zonaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClienteZonaTableTableFilterComposer(
            $db: $db,
            $table: $db.clienteZonaTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> escenarioAsignacionTableRefs(
    Expression<bool> Function($$EscenarioAsignacionTableTableFilterComposer f)
    f,
  ) {
    final $$EscenarioAsignacionTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.escenarioAsignacionTable,
          getReferencedColumn: (t) => t.zonaId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EscenarioAsignacionTableTableFilterComposer(
                $db: $db,
                $table: $db.escenarioAsignacionTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ZonaDemandaTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ZonaDemandaTableTable> {
  $$ZonaDemandaTableTableOrderingComposer({
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

  ColumnOrderings<String> get etiqueta => $composableBuilder(
    column: $table.etiqueta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitud => $composableBuilder(
    column: $table.latitud,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitud => $composableBuilder(
    column: $table.longitud,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get demandaAgregada => $composableBuilder(
    column: $table.demandaAgregada,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pedidosAgregados => $composableBuilder(
    column: $table.pedidosAgregados,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get numeroClientes => $composableBuilder(
    column: $table.numeroClientes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get errorAgregacionMetros => $composableBuilder(
    column: $table.errorAgregacionMetros,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProyectoTableTableOrderingComposer get proyectoId {
    final $$ProyectoTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proyectoId,
      referencedTable: $db.proyectoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProyectoTableTableOrderingComposer(
            $db: $db,
            $table: $db.proyectoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ZonaDemandaTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ZonaDemandaTableTable> {
  $$ZonaDemandaTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get etiqueta =>
      $composableBuilder(column: $table.etiqueta, builder: (column) => column);

  GeneratedColumn<double> get latitud =>
      $composableBuilder(column: $table.latitud, builder: (column) => column);

  GeneratedColumn<double> get longitud =>
      $composableBuilder(column: $table.longitud, builder: (column) => column);

  GeneratedColumn<double> get demandaAgregada => $composableBuilder(
    column: $table.demandaAgregada,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pedidosAgregados => $composableBuilder(
    column: $table.pedidosAgregados,
    builder: (column) => column,
  );

  GeneratedColumn<int> get numeroClientes => $composableBuilder(
    column: $table.numeroClientes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get errorAgregacionMetros => $composableBuilder(
    column: $table.errorAgregacionMetros,
    builder: (column) => column,
  );

  $$ProyectoTableTableAnnotationComposer get proyectoId {
    final $$ProyectoTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proyectoId,
      referencedTable: $db.proyectoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProyectoTableTableAnnotationComposer(
            $db: $db,
            $table: $db.proyectoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> clienteZonaTableRefs<T extends Object>(
    Expression<T> Function($$ClienteZonaTableTableAnnotationComposer a) f,
  ) {
    final $$ClienteZonaTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.clienteZonaTable,
      getReferencedColumn: (t) => t.zonaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClienteZonaTableTableAnnotationComposer(
            $db: $db,
            $table: $db.clienteZonaTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> escenarioAsignacionTableRefs<T extends Object>(
    Expression<T> Function($$EscenarioAsignacionTableTableAnnotationComposer a)
    f,
  ) {
    final $$EscenarioAsignacionTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.escenarioAsignacionTable,
          getReferencedColumn: (t) => t.zonaId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EscenarioAsignacionTableTableAnnotationComposer(
                $db: $db,
                $table: $db.escenarioAsignacionTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ZonaDemandaTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ZonaDemandaTableTable,
          ZonaDemandaTableData,
          $$ZonaDemandaTableTableFilterComposer,
          $$ZonaDemandaTableTableOrderingComposer,
          $$ZonaDemandaTableTableAnnotationComposer,
          $$ZonaDemandaTableTableCreateCompanionBuilder,
          $$ZonaDemandaTableTableUpdateCompanionBuilder,
          (ZonaDemandaTableData, $$ZonaDemandaTableTableReferences),
          ZonaDemandaTableData,
          PrefetchHooks Function({
            bool proyectoId,
            bool clienteZonaTableRefs,
            bool escenarioAsignacionTableRefs,
          })
        > {
  $$ZonaDemandaTableTableTableManager(
    _$AppDatabase db,
    $ZonaDemandaTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ZonaDemandaTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ZonaDemandaTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ZonaDemandaTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> proyectoId = const Value.absent(),
                Value<String> etiqueta = const Value.absent(),
                Value<double> latitud = const Value.absent(),
                Value<double> longitud = const Value.absent(),
                Value<double> demandaAgregada = const Value.absent(),
                Value<int> pedidosAgregados = const Value.absent(),
                Value<int> numeroClientes = const Value.absent(),
                Value<int> errorAgregacionMetros = const Value.absent(),
              }) => ZonaDemandaTableCompanion(
                id: id,
                proyectoId: proyectoId,
                etiqueta: etiqueta,
                latitud: latitud,
                longitud: longitud,
                demandaAgregada: demandaAgregada,
                pedidosAgregados: pedidosAgregados,
                numeroClientes: numeroClientes,
                errorAgregacionMetros: errorAgregacionMetros,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int proyectoId,
                required String etiqueta,
                required double latitud,
                required double longitud,
                required double demandaAgregada,
                required int pedidosAgregados,
                required int numeroClientes,
                required int errorAgregacionMetros,
              }) => ZonaDemandaTableCompanion.insert(
                id: id,
                proyectoId: proyectoId,
                etiqueta: etiqueta,
                latitud: latitud,
                longitud: longitud,
                demandaAgregada: demandaAgregada,
                pedidosAgregados: pedidosAgregados,
                numeroClientes: numeroClientes,
                errorAgregacionMetros: errorAgregacionMetros,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ZonaDemandaTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                proyectoId = false,
                clienteZonaTableRefs = false,
                escenarioAsignacionTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (clienteZonaTableRefs) db.clienteZonaTable,
                    if (escenarioAsignacionTableRefs)
                      db.escenarioAsignacionTable,
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
                        if (proyectoId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.proyectoId,
                            referencedTable: $$ZonaDemandaTableTableReferences
                                ._proyectoIdTable(db),
                            referencedColumn: $$ZonaDemandaTableTableReferences
                                ._proyectoIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (clienteZonaTableRefs)
                        await $_getPrefetchedData<
                          ZonaDemandaTableData,
                          $ZonaDemandaTableTable,
                          ClienteZonaTableData
                        >(
                          currentTable: table,
                          referencedTable: $$ZonaDemandaTableTableReferences
                              ._clienteZonaTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ZonaDemandaTableTableReferences(
                                db,
                                table,
                                p0,
                              ).clienteZonaTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.zonaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (escenarioAsignacionTableRefs)
                        await $_getPrefetchedData<
                          ZonaDemandaTableData,
                          $ZonaDemandaTableTable,
                          EscenarioAsignacionTableData
                        >(
                          currentTable: table,
                          referencedTable: $$ZonaDemandaTableTableReferences
                              ._escenarioAsignacionTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ZonaDemandaTableTableReferences(
                                db,
                                table,
                                p0,
                              ).escenarioAsignacionTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.zonaId == item.id,
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

typedef $$ZonaDemandaTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ZonaDemandaTableTable,
      ZonaDemandaTableData,
      $$ZonaDemandaTableTableFilterComposer,
      $$ZonaDemandaTableTableOrderingComposer,
      $$ZonaDemandaTableTableAnnotationComposer,
      $$ZonaDemandaTableTableCreateCompanionBuilder,
      $$ZonaDemandaTableTableUpdateCompanionBuilder,
      (ZonaDemandaTableData, $$ZonaDemandaTableTableReferences),
      ZonaDemandaTableData,
      PrefetchHooks Function({
        bool proyectoId,
        bool clienteZonaTableRefs,
        bool escenarioAsignacionTableRefs,
      })
    >;
typedef $$ClienteZonaTableTableCreateCompanionBuilder =
    ClienteZonaTableCompanion Function({
      Value<int> id,
      required int clienteId,
      required int zonaId,
    });
typedef $$ClienteZonaTableTableUpdateCompanionBuilder =
    ClienteZonaTableCompanion Function({
      Value<int> id,
      Value<int> clienteId,
      Value<int> zonaId,
    });

final class $$ClienteZonaTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ClienteZonaTableTable,
          ClienteZonaTableData
        > {
  $$ClienteZonaTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ClienteTableTable _clienteIdTable(_$AppDatabase db) =>
      db.clienteTable.createAlias('cliente_zona__cliente_id__cliente__id');

  $$ClienteTableTableProcessedTableManager get clienteId {
    final $_column = $_itemColumn<int>('cliente_id')!;

    final manager = $$ClienteTableTableTableManager(
      $_db,
      $_db.clienteTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clienteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ZonaDemandaTableTable _zonaIdTable(_$AppDatabase db) => db
      .zonaDemandaTable
      .createAlias('cliente_zona__zona_id__zona_demanda__id');

  $$ZonaDemandaTableTableProcessedTableManager get zonaId {
    final $_column = $_itemColumn<int>('zona_id')!;

    final manager = $$ZonaDemandaTableTableTableManager(
      $_db,
      $_db.zonaDemandaTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_zonaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ClienteZonaTableTableFilterComposer
    extends Composer<_$AppDatabase, $ClienteZonaTableTable> {
  $$ClienteZonaTableTableFilterComposer({
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

  $$ClienteTableTableFilterComposer get clienteId {
    final $$ClienteTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clienteTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClienteTableTableFilterComposer(
            $db: $db,
            $table: $db.clienteTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ZonaDemandaTableTableFilterComposer get zonaId {
    final $$ZonaDemandaTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.zonaId,
      referencedTable: $db.zonaDemandaTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ZonaDemandaTableTableFilterComposer(
            $db: $db,
            $table: $db.zonaDemandaTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClienteZonaTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ClienteZonaTableTable> {
  $$ClienteZonaTableTableOrderingComposer({
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

  $$ClienteTableTableOrderingComposer get clienteId {
    final $$ClienteTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clienteTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClienteTableTableOrderingComposer(
            $db: $db,
            $table: $db.clienteTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ZonaDemandaTableTableOrderingComposer get zonaId {
    final $$ZonaDemandaTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.zonaId,
      referencedTable: $db.zonaDemandaTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ZonaDemandaTableTableOrderingComposer(
            $db: $db,
            $table: $db.zonaDemandaTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClienteZonaTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClienteZonaTableTable> {
  $$ClienteZonaTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  $$ClienteTableTableAnnotationComposer get clienteId {
    final $$ClienteTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clienteTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClienteTableTableAnnotationComposer(
            $db: $db,
            $table: $db.clienteTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ZonaDemandaTableTableAnnotationComposer get zonaId {
    final $$ZonaDemandaTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.zonaId,
      referencedTable: $db.zonaDemandaTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ZonaDemandaTableTableAnnotationComposer(
            $db: $db,
            $table: $db.zonaDemandaTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClienteZonaTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClienteZonaTableTable,
          ClienteZonaTableData,
          $$ClienteZonaTableTableFilterComposer,
          $$ClienteZonaTableTableOrderingComposer,
          $$ClienteZonaTableTableAnnotationComposer,
          $$ClienteZonaTableTableCreateCompanionBuilder,
          $$ClienteZonaTableTableUpdateCompanionBuilder,
          (ClienteZonaTableData, $$ClienteZonaTableTableReferences),
          ClienteZonaTableData,
          PrefetchHooks Function({bool clienteId, bool zonaId})
        > {
  $$ClienteZonaTableTableTableManager(
    _$AppDatabase db,
    $ClienteZonaTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClienteZonaTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClienteZonaTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClienteZonaTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> clienteId = const Value.absent(),
                Value<int> zonaId = const Value.absent(),
              }) => ClienteZonaTableCompanion(
                id: id,
                clienteId: clienteId,
                zonaId: zonaId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int clienteId,
                required int zonaId,
              }) => ClienteZonaTableCompanion.insert(
                id: id,
                clienteId: clienteId,
                zonaId: zonaId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ClienteZonaTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({clienteId = false, zonaId = false}) {
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
                    if (clienteId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.clienteId,
                        referencedTable: $$ClienteZonaTableTableReferences
                            ._clienteIdTable(db),
                        referencedColumn: $$ClienteZonaTableTableReferences
                            ._clienteIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (zonaId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.zonaId,
                        referencedTable: $$ClienteZonaTableTableReferences
                            ._zonaIdTable(db),
                        referencedColumn: $$ClienteZonaTableTableReferences
                            ._zonaIdTable(db)
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

typedef $$ClienteZonaTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClienteZonaTableTable,
      ClienteZonaTableData,
      $$ClienteZonaTableTableFilterComposer,
      $$ClienteZonaTableTableOrderingComposer,
      $$ClienteZonaTableTableAnnotationComposer,
      $$ClienteZonaTableTableCreateCompanionBuilder,
      $$ClienteZonaTableTableUpdateCompanionBuilder,
      (ClienteZonaTableData, $$ClienteZonaTableTableReferences),
      ClienteZonaTableData,
      PrefetchHooks Function({bool clienteId, bool zonaId})
    >;
typedef $$SitioCandidatoTableTableCreateCompanionBuilder =
    SitioCandidatoTableCompanion Function({
      Value<int> id,
      required int proyectoId,
      required String nombre,
      required double latitud,
      required double longitud,
      required int costoFijoAnualCent,
      required double capacidadAnual,
      required int costoVariableManejoCentPorUnidad,
      required String origen,
      Value<bool> esRedActual,
    });
typedef $$SitioCandidatoTableTableUpdateCompanionBuilder =
    SitioCandidatoTableCompanion Function({
      Value<int> id,
      Value<int> proyectoId,
      Value<String> nombre,
      Value<double> latitud,
      Value<double> longitud,
      Value<int> costoFijoAnualCent,
      Value<double> capacidadAnual,
      Value<int> costoVariableManejoCentPorUnidad,
      Value<String> origen,
      Value<bool> esRedActual,
    });

final class $$SitioCandidatoTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SitioCandidatoTableTable,
          SitioCandidatoTableData
        > {
  $$SitioCandidatoTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProyectoTableTable _proyectoIdTable(_$AppDatabase db) => db
      .proyectoTable
      .createAlias('sitio_candidato__proyecto_id__proyecto__id');

  $$ProyectoTableTableProcessedTableManager get proyectoId {
    final $_column = $_itemColumn<int>('proyecto_id')!;

    final manager = $$ProyectoTableTableTableManager(
      $_db,
      $_db.proyectoTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_proyectoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $EscenarioAlmacenTableTable,
    List<EscenarioAlmacenTableData>
  >
  _escenarioAlmacenTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.escenarioAlmacenTable,
        aliasName: 'sitio_candidato__id__escenario_almacen__sitio_candidato_id',
      );

  $$EscenarioAlmacenTableTableProcessedTableManager
  get escenarioAlmacenTableRefs {
    final manager = $$EscenarioAlmacenTableTableTableManager(
      $_db,
      $_db.escenarioAlmacenTable,
    ).filter((f) => f.sitioCandidatoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _escenarioAlmacenTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $EscenarioAsignacionTableTable,
    List<EscenarioAsignacionTableData>
  >
  _escenarioAsignacionTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.escenarioAsignacionTable,
        aliasName:
            'sitio_candidato__id__escenario_asignacion__sitio_candidato_id',
      );

  $$EscenarioAsignacionTableTableProcessedTableManager
  get escenarioAsignacionTableRefs {
    final manager = $$EscenarioAsignacionTableTableTableManager(
      $_db,
      $_db.escenarioAsignacionTable,
    ).filter((f) => f.sitioCandidatoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _escenarioAsignacionTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SitioCandidatoTableTableFilterComposer
    extends Composer<_$AppDatabase, $SitioCandidatoTableTable> {
  $$SitioCandidatoTableTableFilterComposer({
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

  ColumnFilters<double> get latitud => $composableBuilder(
    column: $table.latitud,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitud => $composableBuilder(
    column: $table.longitud,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get costoFijoAnualCent => $composableBuilder(
    column: $table.costoFijoAnualCent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get capacidadAnual => $composableBuilder(
    column: $table.capacidadAnual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get costoVariableManejoCentPorUnidad => $composableBuilder(
    column: $table.costoVariableManejoCentPorUnidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get origen => $composableBuilder(
    column: $table.origen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get esRedActual => $composableBuilder(
    column: $table.esRedActual,
    builder: (column) => ColumnFilters(column),
  );

  $$ProyectoTableTableFilterComposer get proyectoId {
    final $$ProyectoTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proyectoId,
      referencedTable: $db.proyectoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProyectoTableTableFilterComposer(
            $db: $db,
            $table: $db.proyectoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> escenarioAlmacenTableRefs(
    Expression<bool> Function($$EscenarioAlmacenTableTableFilterComposer f) f,
  ) {
    final $$EscenarioAlmacenTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.escenarioAlmacenTable,
          getReferencedColumn: (t) => t.sitioCandidatoId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EscenarioAlmacenTableTableFilterComposer(
                $db: $db,
                $table: $db.escenarioAlmacenTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> escenarioAsignacionTableRefs(
    Expression<bool> Function($$EscenarioAsignacionTableTableFilterComposer f)
    f,
  ) {
    final $$EscenarioAsignacionTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.escenarioAsignacionTable,
          getReferencedColumn: (t) => t.sitioCandidatoId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EscenarioAsignacionTableTableFilterComposer(
                $db: $db,
                $table: $db.escenarioAsignacionTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$SitioCandidatoTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SitioCandidatoTableTable> {
  $$SitioCandidatoTableTableOrderingComposer({
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

  ColumnOrderings<double> get latitud => $composableBuilder(
    column: $table.latitud,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitud => $composableBuilder(
    column: $table.longitud,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get costoFijoAnualCent => $composableBuilder(
    column: $table.costoFijoAnualCent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get capacidadAnual => $composableBuilder(
    column: $table.capacidadAnual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get costoVariableManejoCentPorUnidad =>
      $composableBuilder(
        column: $table.costoVariableManejoCentPorUnidad,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<String> get origen => $composableBuilder(
    column: $table.origen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get esRedActual => $composableBuilder(
    column: $table.esRedActual,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProyectoTableTableOrderingComposer get proyectoId {
    final $$ProyectoTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proyectoId,
      referencedTable: $db.proyectoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProyectoTableTableOrderingComposer(
            $db: $db,
            $table: $db.proyectoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SitioCandidatoTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SitioCandidatoTableTable> {
  $$SitioCandidatoTableTableAnnotationComposer({
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

  GeneratedColumn<double> get latitud =>
      $composableBuilder(column: $table.latitud, builder: (column) => column);

  GeneratedColumn<double> get longitud =>
      $composableBuilder(column: $table.longitud, builder: (column) => column);

  GeneratedColumn<int> get costoFijoAnualCent => $composableBuilder(
    column: $table.costoFijoAnualCent,
    builder: (column) => column,
  );

  GeneratedColumn<double> get capacidadAnual => $composableBuilder(
    column: $table.capacidadAnual,
    builder: (column) => column,
  );

  GeneratedColumn<int> get costoVariableManejoCentPorUnidad =>
      $composableBuilder(
        column: $table.costoVariableManejoCentPorUnidad,
        builder: (column) => column,
      );

  GeneratedColumn<String> get origen =>
      $composableBuilder(column: $table.origen, builder: (column) => column);

  GeneratedColumn<bool> get esRedActual => $composableBuilder(
    column: $table.esRedActual,
    builder: (column) => column,
  );

  $$ProyectoTableTableAnnotationComposer get proyectoId {
    final $$ProyectoTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proyectoId,
      referencedTable: $db.proyectoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProyectoTableTableAnnotationComposer(
            $db: $db,
            $table: $db.proyectoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> escenarioAlmacenTableRefs<T extends Object>(
    Expression<T> Function($$EscenarioAlmacenTableTableAnnotationComposer a) f,
  ) {
    final $$EscenarioAlmacenTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.escenarioAlmacenTable,
          getReferencedColumn: (t) => t.sitioCandidatoId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EscenarioAlmacenTableTableAnnotationComposer(
                $db: $db,
                $table: $db.escenarioAlmacenTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> escenarioAsignacionTableRefs<T extends Object>(
    Expression<T> Function($$EscenarioAsignacionTableTableAnnotationComposer a)
    f,
  ) {
    final $$EscenarioAsignacionTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.escenarioAsignacionTable,
          getReferencedColumn: (t) => t.sitioCandidatoId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EscenarioAsignacionTableTableAnnotationComposer(
                $db: $db,
                $table: $db.escenarioAsignacionTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$SitioCandidatoTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SitioCandidatoTableTable,
          SitioCandidatoTableData,
          $$SitioCandidatoTableTableFilterComposer,
          $$SitioCandidatoTableTableOrderingComposer,
          $$SitioCandidatoTableTableAnnotationComposer,
          $$SitioCandidatoTableTableCreateCompanionBuilder,
          $$SitioCandidatoTableTableUpdateCompanionBuilder,
          (SitioCandidatoTableData, $$SitioCandidatoTableTableReferences),
          SitioCandidatoTableData,
          PrefetchHooks Function({
            bool proyectoId,
            bool escenarioAlmacenTableRefs,
            bool escenarioAsignacionTableRefs,
          })
        > {
  $$SitioCandidatoTableTableTableManager(
    _$AppDatabase db,
    $SitioCandidatoTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SitioCandidatoTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SitioCandidatoTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SitioCandidatoTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> proyectoId = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<double> latitud = const Value.absent(),
                Value<double> longitud = const Value.absent(),
                Value<int> costoFijoAnualCent = const Value.absent(),
                Value<double> capacidadAnual = const Value.absent(),
                Value<int> costoVariableManejoCentPorUnidad =
                    const Value.absent(),
                Value<String> origen = const Value.absent(),
                Value<bool> esRedActual = const Value.absent(),
              }) => SitioCandidatoTableCompanion(
                id: id,
                proyectoId: proyectoId,
                nombre: nombre,
                latitud: latitud,
                longitud: longitud,
                costoFijoAnualCent: costoFijoAnualCent,
                capacidadAnual: capacidadAnual,
                costoVariableManejoCentPorUnidad:
                    costoVariableManejoCentPorUnidad,
                origen: origen,
                esRedActual: esRedActual,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int proyectoId,
                required String nombre,
                required double latitud,
                required double longitud,
                required int costoFijoAnualCent,
                required double capacidadAnual,
                required int costoVariableManejoCentPorUnidad,
                required String origen,
                Value<bool> esRedActual = const Value.absent(),
              }) => SitioCandidatoTableCompanion.insert(
                id: id,
                proyectoId: proyectoId,
                nombre: nombre,
                latitud: latitud,
                longitud: longitud,
                costoFijoAnualCent: costoFijoAnualCent,
                capacidadAnual: capacidadAnual,
                costoVariableManejoCentPorUnidad:
                    costoVariableManejoCentPorUnidad,
                origen: origen,
                esRedActual: esRedActual,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SitioCandidatoTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                proyectoId = false,
                escenarioAlmacenTableRefs = false,
                escenarioAsignacionTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (escenarioAlmacenTableRefs) db.escenarioAlmacenTable,
                    if (escenarioAsignacionTableRefs)
                      db.escenarioAsignacionTable,
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
                        if (proyectoId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.proyectoId,
                            referencedTable:
                                $$SitioCandidatoTableTableReferences
                                    ._proyectoIdTable(db),
                            referencedColumn:
                                $$SitioCandidatoTableTableReferences
                                    ._proyectoIdTable(db)
                                    .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (escenarioAlmacenTableRefs)
                        await $_getPrefetchedData<
                          SitioCandidatoTableData,
                          $SitioCandidatoTableTable,
                          EscenarioAlmacenTableData
                        >(
                          currentTable: table,
                          referencedTable: $$SitioCandidatoTableTableReferences
                              ._escenarioAlmacenTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SitioCandidatoTableTableReferences(
                                db,
                                table,
                                p0,
                              ).escenarioAlmacenTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sitioCandidatoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (escenarioAsignacionTableRefs)
                        await $_getPrefetchedData<
                          SitioCandidatoTableData,
                          $SitioCandidatoTableTable,
                          EscenarioAsignacionTableData
                        >(
                          currentTable: table,
                          referencedTable: $$SitioCandidatoTableTableReferences
                              ._escenarioAsignacionTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SitioCandidatoTableTableReferences(
                                db,
                                table,
                                p0,
                              ).escenarioAsignacionTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sitioCandidatoId == item.id,
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

typedef $$SitioCandidatoTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SitioCandidatoTableTable,
      SitioCandidatoTableData,
      $$SitioCandidatoTableTableFilterComposer,
      $$SitioCandidatoTableTableOrderingComposer,
      $$SitioCandidatoTableTableAnnotationComposer,
      $$SitioCandidatoTableTableCreateCompanionBuilder,
      $$SitioCandidatoTableTableUpdateCompanionBuilder,
      (SitioCandidatoTableData, $$SitioCandidatoTableTableReferences),
      SitioCandidatoTableData,
      PrefetchHooks Function({
        bool proyectoId,
        bool escenarioAlmacenTableRefs,
        bool escenarioAsignacionTableRefs,
      })
    >;
typedef $$PlantaTableTableCreateCompanionBuilder =
    PlantaTableCompanion Function({
      Value<int> id,
      required int proyectoId,
      required String nombre,
      required double latitud,
      required double longitud,
      required double capacidadAnual,
      required int costoProduccionCentPorUnidad,
    });
typedef $$PlantaTableTableUpdateCompanionBuilder =
    PlantaTableCompanion Function({
      Value<int> id,
      Value<int> proyectoId,
      Value<String> nombre,
      Value<double> latitud,
      Value<double> longitud,
      Value<double> capacidadAnual,
      Value<int> costoProduccionCentPorUnidad,
    });

final class $$PlantaTableTableReferences
    extends BaseReferences<_$AppDatabase, $PlantaTableTable, PlantaTableData> {
  $$PlantaTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProyectoTableTable _proyectoIdTable(_$AppDatabase db) =>
      db.proyectoTable.createAlias('planta__proyecto_id__proyecto__id');

  $$ProyectoTableTableProcessedTableManager get proyectoId {
    final $_column = $_itemColumn<int>('proyecto_id')!;

    final manager = $$ProyectoTableTableTableManager(
      $_db,
      $_db.proyectoTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_proyectoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PlantaTableTableFilterComposer
    extends Composer<_$AppDatabase, $PlantaTableTable> {
  $$PlantaTableTableFilterComposer({
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

  ColumnFilters<double> get latitud => $composableBuilder(
    column: $table.latitud,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitud => $composableBuilder(
    column: $table.longitud,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get capacidadAnual => $composableBuilder(
    column: $table.capacidadAnual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get costoProduccionCentPorUnidad => $composableBuilder(
    column: $table.costoProduccionCentPorUnidad,
    builder: (column) => ColumnFilters(column),
  );

  $$ProyectoTableTableFilterComposer get proyectoId {
    final $$ProyectoTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proyectoId,
      referencedTable: $db.proyectoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProyectoTableTableFilterComposer(
            $db: $db,
            $table: $db.proyectoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlantaTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PlantaTableTable> {
  $$PlantaTableTableOrderingComposer({
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

  ColumnOrderings<double> get latitud => $composableBuilder(
    column: $table.latitud,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitud => $composableBuilder(
    column: $table.longitud,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get capacidadAnual => $composableBuilder(
    column: $table.capacidadAnual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get costoProduccionCentPorUnidad => $composableBuilder(
    column: $table.costoProduccionCentPorUnidad,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProyectoTableTableOrderingComposer get proyectoId {
    final $$ProyectoTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proyectoId,
      referencedTable: $db.proyectoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProyectoTableTableOrderingComposer(
            $db: $db,
            $table: $db.proyectoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlantaTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlantaTableTable> {
  $$PlantaTableTableAnnotationComposer({
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

  GeneratedColumn<double> get latitud =>
      $composableBuilder(column: $table.latitud, builder: (column) => column);

  GeneratedColumn<double> get longitud =>
      $composableBuilder(column: $table.longitud, builder: (column) => column);

  GeneratedColumn<double> get capacidadAnual => $composableBuilder(
    column: $table.capacidadAnual,
    builder: (column) => column,
  );

  GeneratedColumn<int> get costoProduccionCentPorUnidad => $composableBuilder(
    column: $table.costoProduccionCentPorUnidad,
    builder: (column) => column,
  );

  $$ProyectoTableTableAnnotationComposer get proyectoId {
    final $$ProyectoTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proyectoId,
      referencedTable: $db.proyectoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProyectoTableTableAnnotationComposer(
            $db: $db,
            $table: $db.proyectoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlantaTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlantaTableTable,
          PlantaTableData,
          $$PlantaTableTableFilterComposer,
          $$PlantaTableTableOrderingComposer,
          $$PlantaTableTableAnnotationComposer,
          $$PlantaTableTableCreateCompanionBuilder,
          $$PlantaTableTableUpdateCompanionBuilder,
          (PlantaTableData, $$PlantaTableTableReferences),
          PlantaTableData,
          PrefetchHooks Function({bool proyectoId})
        > {
  $$PlantaTableTableTableManager(_$AppDatabase db, $PlantaTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlantaTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlantaTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlantaTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> proyectoId = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<double> latitud = const Value.absent(),
                Value<double> longitud = const Value.absent(),
                Value<double> capacidadAnual = const Value.absent(),
                Value<int> costoProduccionCentPorUnidad = const Value.absent(),
              }) => PlantaTableCompanion(
                id: id,
                proyectoId: proyectoId,
                nombre: nombre,
                latitud: latitud,
                longitud: longitud,
                capacidadAnual: capacidadAnual,
                costoProduccionCentPorUnidad: costoProduccionCentPorUnidad,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int proyectoId,
                required String nombre,
                required double latitud,
                required double longitud,
                required double capacidadAnual,
                required int costoProduccionCentPorUnidad,
              }) => PlantaTableCompanion.insert(
                id: id,
                proyectoId: proyectoId,
                nombre: nombre,
                latitud: latitud,
                longitud: longitud,
                capacidadAnual: capacidadAnual,
                costoProduccionCentPorUnidad: costoProduccionCentPorUnidad,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlantaTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({proyectoId = false}) {
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
                    if (proyectoId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.proyectoId,
                        referencedTable: $$PlantaTableTableReferences
                            ._proyectoIdTable(db),
                        referencedColumn: $$PlantaTableTableReferences
                            ._proyectoIdTable(db)
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

typedef $$PlantaTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlantaTableTable,
      PlantaTableData,
      $$PlantaTableTableFilterComposer,
      $$PlantaTableTableOrderingComposer,
      $$PlantaTableTableAnnotationComposer,
      $$PlantaTableTableCreateCompanionBuilder,
      $$PlantaTableTableUpdateCompanionBuilder,
      (PlantaTableData, $$PlantaTableTableReferences),
      PlantaTableData,
      PrefetchHooks Function({bool proyectoId})
    >;
typedef $$ParametrosCostoTableTableCreateCompanionBuilder =
    ParametrosCostoTableCompanion Function({
      Value<int> id,
      required int proyectoId,
      required int tarifaEntradaFijaCent,
      required int tarifaEntradaCentPorKmTon,
      required int tarifaSalidaFijaCent,
      required int tarifaSalidaCentPorKmTon,
      required double tasaManejoInventarioAnual,
      required int valorPorUnidadCent,
      required double inventarioBaseUnaUbicacion,
      required int costoPorPedidoCent,
      required String tipoEstandar,
      required int estandarServicioValor,
    });
typedef $$ParametrosCostoTableTableUpdateCompanionBuilder =
    ParametrosCostoTableCompanion Function({
      Value<int> id,
      Value<int> proyectoId,
      Value<int> tarifaEntradaFijaCent,
      Value<int> tarifaEntradaCentPorKmTon,
      Value<int> tarifaSalidaFijaCent,
      Value<int> tarifaSalidaCentPorKmTon,
      Value<double> tasaManejoInventarioAnual,
      Value<int> valorPorUnidadCent,
      Value<double> inventarioBaseUnaUbicacion,
      Value<int> costoPorPedidoCent,
      Value<String> tipoEstandar,
      Value<int> estandarServicioValor,
    });

final class $$ParametrosCostoTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ParametrosCostoTableTable,
          ParametrosCostoTableData
        > {
  $$ParametrosCostoTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProyectoTableTable _proyectoIdTable(_$AppDatabase db) => db
      .proyectoTable
      .createAlias('parametros_costo__proyecto_id__proyecto__id');

  $$ProyectoTableTableProcessedTableManager get proyectoId {
    final $_column = $_itemColumn<int>('proyecto_id')!;

    final manager = $$ProyectoTableTableTableManager(
      $_db,
      $_db.proyectoTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_proyectoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ParametrosCostoTableTableFilterComposer
    extends Composer<_$AppDatabase, $ParametrosCostoTableTable> {
  $$ParametrosCostoTableTableFilterComposer({
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

  ColumnFilters<int> get tarifaEntradaFijaCent => $composableBuilder(
    column: $table.tarifaEntradaFijaCent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tarifaEntradaCentPorKmTon => $composableBuilder(
    column: $table.tarifaEntradaCentPorKmTon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tarifaSalidaFijaCent => $composableBuilder(
    column: $table.tarifaSalidaFijaCent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tarifaSalidaCentPorKmTon => $composableBuilder(
    column: $table.tarifaSalidaCentPorKmTon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get tasaManejoInventarioAnual => $composableBuilder(
    column: $table.tasaManejoInventarioAnual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get valorPorUnidadCent => $composableBuilder(
    column: $table.valorPorUnidadCent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get inventarioBaseUnaUbicacion => $composableBuilder(
    column: $table.inventarioBaseUnaUbicacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get costoPorPedidoCent => $composableBuilder(
    column: $table.costoPorPedidoCent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipoEstandar => $composableBuilder(
    column: $table.tipoEstandar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estandarServicioValor => $composableBuilder(
    column: $table.estandarServicioValor,
    builder: (column) => ColumnFilters(column),
  );

  $$ProyectoTableTableFilterComposer get proyectoId {
    final $$ProyectoTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proyectoId,
      referencedTable: $db.proyectoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProyectoTableTableFilterComposer(
            $db: $db,
            $table: $db.proyectoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ParametrosCostoTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ParametrosCostoTableTable> {
  $$ParametrosCostoTableTableOrderingComposer({
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

  ColumnOrderings<int> get tarifaEntradaFijaCent => $composableBuilder(
    column: $table.tarifaEntradaFijaCent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tarifaEntradaCentPorKmTon => $composableBuilder(
    column: $table.tarifaEntradaCentPorKmTon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tarifaSalidaFijaCent => $composableBuilder(
    column: $table.tarifaSalidaFijaCent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tarifaSalidaCentPorKmTon => $composableBuilder(
    column: $table.tarifaSalidaCentPorKmTon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get tasaManejoInventarioAnual => $composableBuilder(
    column: $table.tasaManejoInventarioAnual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get valorPorUnidadCent => $composableBuilder(
    column: $table.valorPorUnidadCent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get inventarioBaseUnaUbicacion => $composableBuilder(
    column: $table.inventarioBaseUnaUbicacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get costoPorPedidoCent => $composableBuilder(
    column: $table.costoPorPedidoCent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipoEstandar => $composableBuilder(
    column: $table.tipoEstandar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estandarServicioValor => $composableBuilder(
    column: $table.estandarServicioValor,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProyectoTableTableOrderingComposer get proyectoId {
    final $$ProyectoTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proyectoId,
      referencedTable: $db.proyectoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProyectoTableTableOrderingComposer(
            $db: $db,
            $table: $db.proyectoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ParametrosCostoTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ParametrosCostoTableTable> {
  $$ParametrosCostoTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get tarifaEntradaFijaCent => $composableBuilder(
    column: $table.tarifaEntradaFijaCent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tarifaEntradaCentPorKmTon => $composableBuilder(
    column: $table.tarifaEntradaCentPorKmTon,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tarifaSalidaFijaCent => $composableBuilder(
    column: $table.tarifaSalidaFijaCent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tarifaSalidaCentPorKmTon => $composableBuilder(
    column: $table.tarifaSalidaCentPorKmTon,
    builder: (column) => column,
  );

  GeneratedColumn<double> get tasaManejoInventarioAnual => $composableBuilder(
    column: $table.tasaManejoInventarioAnual,
    builder: (column) => column,
  );

  GeneratedColumn<int> get valorPorUnidadCent => $composableBuilder(
    column: $table.valorPorUnidadCent,
    builder: (column) => column,
  );

  GeneratedColumn<double> get inventarioBaseUnaUbicacion => $composableBuilder(
    column: $table.inventarioBaseUnaUbicacion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get costoPorPedidoCent => $composableBuilder(
    column: $table.costoPorPedidoCent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tipoEstandar => $composableBuilder(
    column: $table.tipoEstandar,
    builder: (column) => column,
  );

  GeneratedColumn<int> get estandarServicioValor => $composableBuilder(
    column: $table.estandarServicioValor,
    builder: (column) => column,
  );

  $$ProyectoTableTableAnnotationComposer get proyectoId {
    final $$ProyectoTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proyectoId,
      referencedTable: $db.proyectoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProyectoTableTableAnnotationComposer(
            $db: $db,
            $table: $db.proyectoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ParametrosCostoTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ParametrosCostoTableTable,
          ParametrosCostoTableData,
          $$ParametrosCostoTableTableFilterComposer,
          $$ParametrosCostoTableTableOrderingComposer,
          $$ParametrosCostoTableTableAnnotationComposer,
          $$ParametrosCostoTableTableCreateCompanionBuilder,
          $$ParametrosCostoTableTableUpdateCompanionBuilder,
          (ParametrosCostoTableData, $$ParametrosCostoTableTableReferences),
          ParametrosCostoTableData,
          PrefetchHooks Function({bool proyectoId})
        > {
  $$ParametrosCostoTableTableTableManager(
    _$AppDatabase db,
    $ParametrosCostoTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ParametrosCostoTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ParametrosCostoTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ParametrosCostoTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> proyectoId = const Value.absent(),
                Value<int> tarifaEntradaFijaCent = const Value.absent(),
                Value<int> tarifaEntradaCentPorKmTon = const Value.absent(),
                Value<int> tarifaSalidaFijaCent = const Value.absent(),
                Value<int> tarifaSalidaCentPorKmTon = const Value.absent(),
                Value<double> tasaManejoInventarioAnual = const Value.absent(),
                Value<int> valorPorUnidadCent = const Value.absent(),
                Value<double> inventarioBaseUnaUbicacion = const Value.absent(),
                Value<int> costoPorPedidoCent = const Value.absent(),
                Value<String> tipoEstandar = const Value.absent(),
                Value<int> estandarServicioValor = const Value.absent(),
              }) => ParametrosCostoTableCompanion(
                id: id,
                proyectoId: proyectoId,
                tarifaEntradaFijaCent: tarifaEntradaFijaCent,
                tarifaEntradaCentPorKmTon: tarifaEntradaCentPorKmTon,
                tarifaSalidaFijaCent: tarifaSalidaFijaCent,
                tarifaSalidaCentPorKmTon: tarifaSalidaCentPorKmTon,
                tasaManejoInventarioAnual: tasaManejoInventarioAnual,
                valorPorUnidadCent: valorPorUnidadCent,
                inventarioBaseUnaUbicacion: inventarioBaseUnaUbicacion,
                costoPorPedidoCent: costoPorPedidoCent,
                tipoEstandar: tipoEstandar,
                estandarServicioValor: estandarServicioValor,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int proyectoId,
                required int tarifaEntradaFijaCent,
                required int tarifaEntradaCentPorKmTon,
                required int tarifaSalidaFijaCent,
                required int tarifaSalidaCentPorKmTon,
                required double tasaManejoInventarioAnual,
                required int valorPorUnidadCent,
                required double inventarioBaseUnaUbicacion,
                required int costoPorPedidoCent,
                required String tipoEstandar,
                required int estandarServicioValor,
              }) => ParametrosCostoTableCompanion.insert(
                id: id,
                proyectoId: proyectoId,
                tarifaEntradaFijaCent: tarifaEntradaFijaCent,
                tarifaEntradaCentPorKmTon: tarifaEntradaCentPorKmTon,
                tarifaSalidaFijaCent: tarifaSalidaFijaCent,
                tarifaSalidaCentPorKmTon: tarifaSalidaCentPorKmTon,
                tasaManejoInventarioAnual: tasaManejoInventarioAnual,
                valorPorUnidadCent: valorPorUnidadCent,
                inventarioBaseUnaUbicacion: inventarioBaseUnaUbicacion,
                costoPorPedidoCent: costoPorPedidoCent,
                tipoEstandar: tipoEstandar,
                estandarServicioValor: estandarServicioValor,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ParametrosCostoTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({proyectoId = false}) {
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
                    if (proyectoId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.proyectoId,
                        referencedTable: $$ParametrosCostoTableTableReferences
                            ._proyectoIdTable(db),
                        referencedColumn: $$ParametrosCostoTableTableReferences
                            ._proyectoIdTable(db)
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

typedef $$ParametrosCostoTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ParametrosCostoTableTable,
      ParametrosCostoTableData,
      $$ParametrosCostoTableTableFilterComposer,
      $$ParametrosCostoTableTableOrderingComposer,
      $$ParametrosCostoTableTableAnnotationComposer,
      $$ParametrosCostoTableTableCreateCompanionBuilder,
      $$ParametrosCostoTableTableUpdateCompanionBuilder,
      (ParametrosCostoTableData, $$ParametrosCostoTableTableReferences),
      ParametrosCostoTableData,
      PrefetchHooks Function({bool proyectoId})
    >;
typedef $$CeldaMatrizTableTableCreateCompanionBuilder =
    CeldaMatrizTableCompanion Function({
      Value<int> id,
      required int proyectoId,
      required String tipoOrigen,
      required int origenId,
      required String tipoDestino,
      required int destinoId,
      required int distanciaMetros,
      required int duracionSegundos,
      required String fuente,
    });
typedef $$CeldaMatrizTableTableUpdateCompanionBuilder =
    CeldaMatrizTableCompanion Function({
      Value<int> id,
      Value<int> proyectoId,
      Value<String> tipoOrigen,
      Value<int> origenId,
      Value<String> tipoDestino,
      Value<int> destinoId,
      Value<int> distanciaMetros,
      Value<int> duracionSegundos,
      Value<String> fuente,
    });

final class $$CeldaMatrizTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CeldaMatrizTableTable,
          CeldaMatrizTableData
        > {
  $$CeldaMatrizTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProyectoTableTable _proyectoIdTable(_$AppDatabase db) =>
      db.proyectoTable.createAlias('celda_matriz__proyecto_id__proyecto__id');

  $$ProyectoTableTableProcessedTableManager get proyectoId {
    final $_column = $_itemColumn<int>('proyecto_id')!;

    final manager = $$ProyectoTableTableTableManager(
      $_db,
      $_db.proyectoTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_proyectoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CeldaMatrizTableTableFilterComposer
    extends Composer<_$AppDatabase, $CeldaMatrizTableTable> {
  $$CeldaMatrizTableTableFilterComposer({
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

  ColumnFilters<String> get tipoOrigen => $composableBuilder(
    column: $table.tipoOrigen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get origenId => $composableBuilder(
    column: $table.origenId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipoDestino => $composableBuilder(
    column: $table.tipoDestino,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get destinoId => $composableBuilder(
    column: $table.destinoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get distanciaMetros => $composableBuilder(
    column: $table.distanciaMetros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get duracionSegundos => $composableBuilder(
    column: $table.duracionSegundos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fuente => $composableBuilder(
    column: $table.fuente,
    builder: (column) => ColumnFilters(column),
  );

  $$ProyectoTableTableFilterComposer get proyectoId {
    final $$ProyectoTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proyectoId,
      referencedTable: $db.proyectoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProyectoTableTableFilterComposer(
            $db: $db,
            $table: $db.proyectoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CeldaMatrizTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CeldaMatrizTableTable> {
  $$CeldaMatrizTableTableOrderingComposer({
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

  ColumnOrderings<String> get tipoOrigen => $composableBuilder(
    column: $table.tipoOrigen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get origenId => $composableBuilder(
    column: $table.origenId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipoDestino => $composableBuilder(
    column: $table.tipoDestino,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get destinoId => $composableBuilder(
    column: $table.destinoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get distanciaMetros => $composableBuilder(
    column: $table.distanciaMetros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get duracionSegundos => $composableBuilder(
    column: $table.duracionSegundos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fuente => $composableBuilder(
    column: $table.fuente,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProyectoTableTableOrderingComposer get proyectoId {
    final $$ProyectoTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proyectoId,
      referencedTable: $db.proyectoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProyectoTableTableOrderingComposer(
            $db: $db,
            $table: $db.proyectoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CeldaMatrizTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CeldaMatrizTableTable> {
  $$CeldaMatrizTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tipoOrigen => $composableBuilder(
    column: $table.tipoOrigen,
    builder: (column) => column,
  );

  GeneratedColumn<int> get origenId =>
      $composableBuilder(column: $table.origenId, builder: (column) => column);

  GeneratedColumn<String> get tipoDestino => $composableBuilder(
    column: $table.tipoDestino,
    builder: (column) => column,
  );

  GeneratedColumn<int> get destinoId =>
      $composableBuilder(column: $table.destinoId, builder: (column) => column);

  GeneratedColumn<int> get distanciaMetros => $composableBuilder(
    column: $table.distanciaMetros,
    builder: (column) => column,
  );

  GeneratedColumn<int> get duracionSegundos => $composableBuilder(
    column: $table.duracionSegundos,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fuente =>
      $composableBuilder(column: $table.fuente, builder: (column) => column);

  $$ProyectoTableTableAnnotationComposer get proyectoId {
    final $$ProyectoTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proyectoId,
      referencedTable: $db.proyectoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProyectoTableTableAnnotationComposer(
            $db: $db,
            $table: $db.proyectoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CeldaMatrizTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CeldaMatrizTableTable,
          CeldaMatrizTableData,
          $$CeldaMatrizTableTableFilterComposer,
          $$CeldaMatrizTableTableOrderingComposer,
          $$CeldaMatrizTableTableAnnotationComposer,
          $$CeldaMatrizTableTableCreateCompanionBuilder,
          $$CeldaMatrizTableTableUpdateCompanionBuilder,
          (CeldaMatrizTableData, $$CeldaMatrizTableTableReferences),
          CeldaMatrizTableData,
          PrefetchHooks Function({bool proyectoId})
        > {
  $$CeldaMatrizTableTableTableManager(
    _$AppDatabase db,
    $CeldaMatrizTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CeldaMatrizTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CeldaMatrizTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CeldaMatrizTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> proyectoId = const Value.absent(),
                Value<String> tipoOrigen = const Value.absent(),
                Value<int> origenId = const Value.absent(),
                Value<String> tipoDestino = const Value.absent(),
                Value<int> destinoId = const Value.absent(),
                Value<int> distanciaMetros = const Value.absent(),
                Value<int> duracionSegundos = const Value.absent(),
                Value<String> fuente = const Value.absent(),
              }) => CeldaMatrizTableCompanion(
                id: id,
                proyectoId: proyectoId,
                tipoOrigen: tipoOrigen,
                origenId: origenId,
                tipoDestino: tipoDestino,
                destinoId: destinoId,
                distanciaMetros: distanciaMetros,
                duracionSegundos: duracionSegundos,
                fuente: fuente,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int proyectoId,
                required String tipoOrigen,
                required int origenId,
                required String tipoDestino,
                required int destinoId,
                required int distanciaMetros,
                required int duracionSegundos,
                required String fuente,
              }) => CeldaMatrizTableCompanion.insert(
                id: id,
                proyectoId: proyectoId,
                tipoOrigen: tipoOrigen,
                origenId: origenId,
                tipoDestino: tipoDestino,
                destinoId: destinoId,
                distanciaMetros: distanciaMetros,
                duracionSegundos: duracionSegundos,
                fuente: fuente,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CeldaMatrizTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({proyectoId = false}) {
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
                    if (proyectoId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.proyectoId,
                        referencedTable: $$CeldaMatrizTableTableReferences
                            ._proyectoIdTable(db),
                        referencedColumn: $$CeldaMatrizTableTableReferences
                            ._proyectoIdTable(db)
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

typedef $$CeldaMatrizTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CeldaMatrizTableTable,
      CeldaMatrizTableData,
      $$CeldaMatrizTableTableFilterComposer,
      $$CeldaMatrizTableTableOrderingComposer,
      $$CeldaMatrizTableTableAnnotationComposer,
      $$CeldaMatrizTableTableCreateCompanionBuilder,
      $$CeldaMatrizTableTableUpdateCompanionBuilder,
      (CeldaMatrizTableData, $$CeldaMatrizTableTableReferences),
      CeldaMatrizTableData,
      PrefetchHooks Function({bool proyectoId})
    >;
typedef $$CacheRuteoTableTableCreateCompanionBuilder =
    CacheRuteoTableCompanion Function({
      required String hashConsulta,
      required String tipo,
      required String respuestaJson,
      required String fechaConsulta,
      Value<int> rowid,
    });
typedef $$CacheRuteoTableTableUpdateCompanionBuilder =
    CacheRuteoTableCompanion Function({
      Value<String> hashConsulta,
      Value<String> tipo,
      Value<String> respuestaJson,
      Value<String> fechaConsulta,
      Value<int> rowid,
    });

class $$CacheRuteoTableTableFilterComposer
    extends Composer<_$AppDatabase, $CacheRuteoTableTable> {
  $$CacheRuteoTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get hashConsulta => $composableBuilder(
    column: $table.hashConsulta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get respuestaJson => $composableBuilder(
    column: $table.respuestaJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fechaConsulta => $composableBuilder(
    column: $table.fechaConsulta,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CacheRuteoTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CacheRuteoTableTable> {
  $$CacheRuteoTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get hashConsulta => $composableBuilder(
    column: $table.hashConsulta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get respuestaJson => $composableBuilder(
    column: $table.respuestaJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fechaConsulta => $composableBuilder(
    column: $table.fechaConsulta,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CacheRuteoTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CacheRuteoTableTable> {
  $$CacheRuteoTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get hashConsulta => $composableBuilder(
    column: $table.hashConsulta,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get respuestaJson => $composableBuilder(
    column: $table.respuestaJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fechaConsulta => $composableBuilder(
    column: $table.fechaConsulta,
    builder: (column) => column,
  );
}

class $$CacheRuteoTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CacheRuteoTableTable,
          CacheRuteoTableData,
          $$CacheRuteoTableTableFilterComposer,
          $$CacheRuteoTableTableOrderingComposer,
          $$CacheRuteoTableTableAnnotationComposer,
          $$CacheRuteoTableTableCreateCompanionBuilder,
          $$CacheRuteoTableTableUpdateCompanionBuilder,
          (
            CacheRuteoTableData,
            BaseReferences<
              _$AppDatabase,
              $CacheRuteoTableTable,
              CacheRuteoTableData
            >,
          ),
          CacheRuteoTableData,
          PrefetchHooks Function()
        > {
  $$CacheRuteoTableTableTableManager(
    _$AppDatabase db,
    $CacheRuteoTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CacheRuteoTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CacheRuteoTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CacheRuteoTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> hashConsulta = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<String> respuestaJson = const Value.absent(),
                Value<String> fechaConsulta = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CacheRuteoTableCompanion(
                hashConsulta: hashConsulta,
                tipo: tipo,
                respuestaJson: respuestaJson,
                fechaConsulta: fechaConsulta,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String hashConsulta,
                required String tipo,
                required String respuestaJson,
                required String fechaConsulta,
                Value<int> rowid = const Value.absent(),
              }) => CacheRuteoTableCompanion.insert(
                hashConsulta: hashConsulta,
                tipo: tipo,
                respuestaJson: respuestaJson,
                fechaConsulta: fechaConsulta,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CacheRuteoTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CacheRuteoTableTable,
      CacheRuteoTableData,
      $$CacheRuteoTableTableFilterComposer,
      $$CacheRuteoTableTableOrderingComposer,
      $$CacheRuteoTableTableAnnotationComposer,
      $$CacheRuteoTableTableCreateCompanionBuilder,
      $$CacheRuteoTableTableUpdateCompanionBuilder,
      (
        CacheRuteoTableData,
        BaseReferences<
          _$AppDatabase,
          $CacheRuteoTableTable,
          CacheRuteoTableData
        >,
      ),
      CacheRuteoTableData,
      PrefetchHooks Function()
    >;
typedef $$EscenarioTableTableCreateCompanionBuilder =
    EscenarioTableCompanion Function({
      Value<int> id,
      required int proyectoId,
      required String nombre,
      required String metodo,
      Value<int?> pFijo,
      Value<bool> restriccionCapacidadActiva,
      required int costoTotalCent,
      required String fecha,
      Value<String?> notas,
    });
typedef $$EscenarioTableTableUpdateCompanionBuilder =
    EscenarioTableCompanion Function({
      Value<int> id,
      Value<int> proyectoId,
      Value<String> nombre,
      Value<String> metodo,
      Value<int?> pFijo,
      Value<bool> restriccionCapacidadActiva,
      Value<int> costoTotalCent,
      Value<String> fecha,
      Value<String?> notas,
    });

final class $$EscenarioTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $EscenarioTableTable,
          EscenarioTableData
        > {
  $$EscenarioTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProyectoTableTable _proyectoIdTable(_$AppDatabase db) =>
      db.proyectoTable.createAlias('escenario__proyecto_id__proyecto__id');

  $$ProyectoTableTableProcessedTableManager get proyectoId {
    final $_column = $_itemColumn<int>('proyecto_id')!;

    final manager = $$ProyectoTableTableTableManager(
      $_db,
      $_db.proyectoTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_proyectoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $EscenarioAlmacenTableTable,
    List<EscenarioAlmacenTableData>
  >
  _escenarioAlmacenTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.escenarioAlmacenTable,
        aliasName: 'escenario__id__escenario_almacen__escenario_id',
      );

  $$EscenarioAlmacenTableTableProcessedTableManager
  get escenarioAlmacenTableRefs {
    final manager = $$EscenarioAlmacenTableTableTableManager(
      $_db,
      $_db.escenarioAlmacenTable,
    ).filter((f) => f.escenarioId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _escenarioAlmacenTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $EscenarioAsignacionTableTable,
    List<EscenarioAsignacionTableData>
  >
  _escenarioAsignacionTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.escenarioAsignacionTable,
        aliasName: 'escenario__id__escenario_asignacion__escenario_id',
      );

  $$EscenarioAsignacionTableTableProcessedTableManager
  get escenarioAsignacionTableRefs {
    final manager = $$EscenarioAsignacionTableTableTableManager(
      $_db,
      $_db.escenarioAsignacionTable,
    ).filter((f) => f.escenarioId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _escenarioAsignacionTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $EscenarioCostoTableTable,
    List<EscenarioCostoTableData>
  >
  _escenarioCostoTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.escenarioCostoTable,
        aliasName: 'escenario__id__escenario_costo__escenario_id',
      );

  $$EscenarioCostoTableTableProcessedTableManager get escenarioCostoTableRefs {
    final manager = $$EscenarioCostoTableTableTableManager(
      $_db,
      $_db.escenarioCostoTable,
    ).filter((f) => f.escenarioId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _escenarioCostoTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PuntoCurvaTableTable, List<PuntoCurvaTableData>>
  _puntoCurvaTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.puntoCurvaTable,
    aliasName: 'escenario__id__punto_curva__escenario_id',
  );

  $$PuntoCurvaTableTableProcessedTableManager get puntoCurvaTableRefs {
    final manager = $$PuntoCurvaTableTableTableManager(
      $_db,
      $_db.puntoCurvaTable,
    ).filter((f) => f.escenarioId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _puntoCurvaTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $MemoriaCalculoTableTable,
    List<MemoriaCalculoTableData>
  >
  _memoriaCalculoTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.memoriaCalculoTable,
        aliasName: 'escenario__id__memoria_calculo__escenario_id',
      );

  $$MemoriaCalculoTableTableProcessedTableManager get memoriaCalculoTableRefs {
    final manager = $$MemoriaCalculoTableTableTableManager(
      $_db,
      $_db.memoriaCalculoTable,
    ).filter((f) => f.escenarioId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _memoriaCalculoTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EscenarioTableTableFilterComposer
    extends Composer<_$AppDatabase, $EscenarioTableTable> {
  $$EscenarioTableTableFilterComposer({
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

  ColumnFilters<String> get metodo => $composableBuilder(
    column: $table.metodo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pFijo => $composableBuilder(
    column: $table.pFijo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get restriccionCapacidadActiva => $composableBuilder(
    column: $table.restriccionCapacidadActiva,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get costoTotalCent => $composableBuilder(
    column: $table.costoTotalCent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notas => $composableBuilder(
    column: $table.notas,
    builder: (column) => ColumnFilters(column),
  );

  $$ProyectoTableTableFilterComposer get proyectoId {
    final $$ProyectoTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proyectoId,
      referencedTable: $db.proyectoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProyectoTableTableFilterComposer(
            $db: $db,
            $table: $db.proyectoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> escenarioAlmacenTableRefs(
    Expression<bool> Function($$EscenarioAlmacenTableTableFilterComposer f) f,
  ) {
    final $$EscenarioAlmacenTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.escenarioAlmacenTable,
          getReferencedColumn: (t) => t.escenarioId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EscenarioAlmacenTableTableFilterComposer(
                $db: $db,
                $table: $db.escenarioAlmacenTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> escenarioAsignacionTableRefs(
    Expression<bool> Function($$EscenarioAsignacionTableTableFilterComposer f)
    f,
  ) {
    final $$EscenarioAsignacionTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.escenarioAsignacionTable,
          getReferencedColumn: (t) => t.escenarioId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EscenarioAsignacionTableTableFilterComposer(
                $db: $db,
                $table: $db.escenarioAsignacionTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> escenarioCostoTableRefs(
    Expression<bool> Function($$EscenarioCostoTableTableFilterComposer f) f,
  ) {
    final $$EscenarioCostoTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.escenarioCostoTable,
      getReferencedColumn: (t) => t.escenarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EscenarioCostoTableTableFilterComposer(
            $db: $db,
            $table: $db.escenarioCostoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> puntoCurvaTableRefs(
    Expression<bool> Function($$PuntoCurvaTableTableFilterComposer f) f,
  ) {
    final $$PuntoCurvaTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.puntoCurvaTable,
      getReferencedColumn: (t) => t.escenarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PuntoCurvaTableTableFilterComposer(
            $db: $db,
            $table: $db.puntoCurvaTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> memoriaCalculoTableRefs(
    Expression<bool> Function($$MemoriaCalculoTableTableFilterComposer f) f,
  ) {
    final $$MemoriaCalculoTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.memoriaCalculoTable,
      getReferencedColumn: (t) => t.escenarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemoriaCalculoTableTableFilterComposer(
            $db: $db,
            $table: $db.memoriaCalculoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EscenarioTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EscenarioTableTable> {
  $$EscenarioTableTableOrderingComposer({
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

  ColumnOrderings<String> get metodo => $composableBuilder(
    column: $table.metodo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pFijo => $composableBuilder(
    column: $table.pFijo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get restriccionCapacidadActiva => $composableBuilder(
    column: $table.restriccionCapacidadActiva,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get costoTotalCent => $composableBuilder(
    column: $table.costoTotalCent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notas => $composableBuilder(
    column: $table.notas,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProyectoTableTableOrderingComposer get proyectoId {
    final $$ProyectoTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proyectoId,
      referencedTable: $db.proyectoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProyectoTableTableOrderingComposer(
            $db: $db,
            $table: $db.proyectoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EscenarioTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EscenarioTableTable> {
  $$EscenarioTableTableAnnotationComposer({
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

  GeneratedColumn<String> get metodo =>
      $composableBuilder(column: $table.metodo, builder: (column) => column);

  GeneratedColumn<int> get pFijo =>
      $composableBuilder(column: $table.pFijo, builder: (column) => column);

  GeneratedColumn<bool> get restriccionCapacidadActiva => $composableBuilder(
    column: $table.restriccionCapacidadActiva,
    builder: (column) => column,
  );

  GeneratedColumn<int> get costoTotalCent => $composableBuilder(
    column: $table.costoTotalCent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<String> get notas =>
      $composableBuilder(column: $table.notas, builder: (column) => column);

  $$ProyectoTableTableAnnotationComposer get proyectoId {
    final $$ProyectoTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proyectoId,
      referencedTable: $db.proyectoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProyectoTableTableAnnotationComposer(
            $db: $db,
            $table: $db.proyectoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> escenarioAlmacenTableRefs<T extends Object>(
    Expression<T> Function($$EscenarioAlmacenTableTableAnnotationComposer a) f,
  ) {
    final $$EscenarioAlmacenTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.escenarioAlmacenTable,
          getReferencedColumn: (t) => t.escenarioId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EscenarioAlmacenTableTableAnnotationComposer(
                $db: $db,
                $table: $db.escenarioAlmacenTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> escenarioAsignacionTableRefs<T extends Object>(
    Expression<T> Function($$EscenarioAsignacionTableTableAnnotationComposer a)
    f,
  ) {
    final $$EscenarioAsignacionTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.escenarioAsignacionTable,
          getReferencedColumn: (t) => t.escenarioId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EscenarioAsignacionTableTableAnnotationComposer(
                $db: $db,
                $table: $db.escenarioAsignacionTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> escenarioCostoTableRefs<T extends Object>(
    Expression<T> Function($$EscenarioCostoTableTableAnnotationComposer a) f,
  ) {
    final $$EscenarioCostoTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.escenarioCostoTable,
          getReferencedColumn: (t) => t.escenarioId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EscenarioCostoTableTableAnnotationComposer(
                $db: $db,
                $table: $db.escenarioCostoTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> puntoCurvaTableRefs<T extends Object>(
    Expression<T> Function($$PuntoCurvaTableTableAnnotationComposer a) f,
  ) {
    final $$PuntoCurvaTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.puntoCurvaTable,
      getReferencedColumn: (t) => t.escenarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PuntoCurvaTableTableAnnotationComposer(
            $db: $db,
            $table: $db.puntoCurvaTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> memoriaCalculoTableRefs<T extends Object>(
    Expression<T> Function($$MemoriaCalculoTableTableAnnotationComposer a) f,
  ) {
    final $$MemoriaCalculoTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.memoriaCalculoTable,
          getReferencedColumn: (t) => t.escenarioId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MemoriaCalculoTableTableAnnotationComposer(
                $db: $db,
                $table: $db.memoriaCalculoTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$EscenarioTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EscenarioTableTable,
          EscenarioTableData,
          $$EscenarioTableTableFilterComposer,
          $$EscenarioTableTableOrderingComposer,
          $$EscenarioTableTableAnnotationComposer,
          $$EscenarioTableTableCreateCompanionBuilder,
          $$EscenarioTableTableUpdateCompanionBuilder,
          (EscenarioTableData, $$EscenarioTableTableReferences),
          EscenarioTableData,
          PrefetchHooks Function({
            bool proyectoId,
            bool escenarioAlmacenTableRefs,
            bool escenarioAsignacionTableRefs,
            bool escenarioCostoTableRefs,
            bool puntoCurvaTableRefs,
            bool memoriaCalculoTableRefs,
          })
        > {
  $$EscenarioTableTableTableManager(
    _$AppDatabase db,
    $EscenarioTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EscenarioTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EscenarioTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EscenarioTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> proyectoId = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> metodo = const Value.absent(),
                Value<int?> pFijo = const Value.absent(),
                Value<bool> restriccionCapacidadActiva = const Value.absent(),
                Value<int> costoTotalCent = const Value.absent(),
                Value<String> fecha = const Value.absent(),
                Value<String?> notas = const Value.absent(),
              }) => EscenarioTableCompanion(
                id: id,
                proyectoId: proyectoId,
                nombre: nombre,
                metodo: metodo,
                pFijo: pFijo,
                restriccionCapacidadActiva: restriccionCapacidadActiva,
                costoTotalCent: costoTotalCent,
                fecha: fecha,
                notas: notas,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int proyectoId,
                required String nombre,
                required String metodo,
                Value<int?> pFijo = const Value.absent(),
                Value<bool> restriccionCapacidadActiva = const Value.absent(),
                required int costoTotalCent,
                required String fecha,
                Value<String?> notas = const Value.absent(),
              }) => EscenarioTableCompanion.insert(
                id: id,
                proyectoId: proyectoId,
                nombre: nombre,
                metodo: metodo,
                pFijo: pFijo,
                restriccionCapacidadActiva: restriccionCapacidadActiva,
                costoTotalCent: costoTotalCent,
                fecha: fecha,
                notas: notas,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EscenarioTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                proyectoId = false,
                escenarioAlmacenTableRefs = false,
                escenarioAsignacionTableRefs = false,
                escenarioCostoTableRefs = false,
                puntoCurvaTableRefs = false,
                memoriaCalculoTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (escenarioAlmacenTableRefs) db.escenarioAlmacenTable,
                    if (escenarioAsignacionTableRefs)
                      db.escenarioAsignacionTable,
                    if (escenarioCostoTableRefs) db.escenarioCostoTable,
                    if (puntoCurvaTableRefs) db.puntoCurvaTable,
                    if (memoriaCalculoTableRefs) db.memoriaCalculoTable,
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
                        if (proyectoId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.proyectoId,
                            referencedTable: $$EscenarioTableTableReferences
                                ._proyectoIdTable(db),
                            referencedColumn: $$EscenarioTableTableReferences
                                ._proyectoIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (escenarioAlmacenTableRefs)
                        await $_getPrefetchedData<
                          EscenarioTableData,
                          $EscenarioTableTable,
                          EscenarioAlmacenTableData
                        >(
                          currentTable: table,
                          referencedTable: $$EscenarioTableTableReferences
                              ._escenarioAlmacenTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EscenarioTableTableReferences(
                                db,
                                table,
                                p0,
                              ).escenarioAlmacenTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.escenarioId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (escenarioAsignacionTableRefs)
                        await $_getPrefetchedData<
                          EscenarioTableData,
                          $EscenarioTableTable,
                          EscenarioAsignacionTableData
                        >(
                          currentTable: table,
                          referencedTable: $$EscenarioTableTableReferences
                              ._escenarioAsignacionTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EscenarioTableTableReferences(
                                db,
                                table,
                                p0,
                              ).escenarioAsignacionTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.escenarioId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (escenarioCostoTableRefs)
                        await $_getPrefetchedData<
                          EscenarioTableData,
                          $EscenarioTableTable,
                          EscenarioCostoTableData
                        >(
                          currentTable: table,
                          referencedTable: $$EscenarioTableTableReferences
                              ._escenarioCostoTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EscenarioTableTableReferences(
                                db,
                                table,
                                p0,
                              ).escenarioCostoTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.escenarioId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (puntoCurvaTableRefs)
                        await $_getPrefetchedData<
                          EscenarioTableData,
                          $EscenarioTableTable,
                          PuntoCurvaTableData
                        >(
                          currentTable: table,
                          referencedTable: $$EscenarioTableTableReferences
                              ._puntoCurvaTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EscenarioTableTableReferences(
                                db,
                                table,
                                p0,
                              ).puntoCurvaTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.escenarioId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (memoriaCalculoTableRefs)
                        await $_getPrefetchedData<
                          EscenarioTableData,
                          $EscenarioTableTable,
                          MemoriaCalculoTableData
                        >(
                          currentTable: table,
                          referencedTable: $$EscenarioTableTableReferences
                              ._memoriaCalculoTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EscenarioTableTableReferences(
                                db,
                                table,
                                p0,
                              ).memoriaCalculoTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.escenarioId == item.id,
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

typedef $$EscenarioTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EscenarioTableTable,
      EscenarioTableData,
      $$EscenarioTableTableFilterComposer,
      $$EscenarioTableTableOrderingComposer,
      $$EscenarioTableTableAnnotationComposer,
      $$EscenarioTableTableCreateCompanionBuilder,
      $$EscenarioTableTableUpdateCompanionBuilder,
      (EscenarioTableData, $$EscenarioTableTableReferences),
      EscenarioTableData,
      PrefetchHooks Function({
        bool proyectoId,
        bool escenarioAlmacenTableRefs,
        bool escenarioAsignacionTableRefs,
        bool escenarioCostoTableRefs,
        bool puntoCurvaTableRefs,
        bool memoriaCalculoTableRefs,
      })
    >;
typedef $$EscenarioAlmacenTableTableCreateCompanionBuilder =
    EscenarioAlmacenTableCompanion Function({
      Value<int> id,
      required int escenarioId,
      required int sitioCandidatoId,
      required double volumenAsignado,
      required int costoFijoCent,
      required int costoManejoCent,
    });
typedef $$EscenarioAlmacenTableTableUpdateCompanionBuilder =
    EscenarioAlmacenTableCompanion Function({
      Value<int> id,
      Value<int> escenarioId,
      Value<int> sitioCandidatoId,
      Value<double> volumenAsignado,
      Value<int> costoFijoCent,
      Value<int> costoManejoCent,
    });

final class $$EscenarioAlmacenTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $EscenarioAlmacenTableTable,
          EscenarioAlmacenTableData
        > {
  $$EscenarioAlmacenTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EscenarioTableTable _escenarioIdTable(_$AppDatabase db) => db
      .escenarioTable
      .createAlias('escenario_almacen__escenario_id__escenario__id');

  $$EscenarioTableTableProcessedTableManager get escenarioId {
    final $_column = $_itemColumn<int>('escenario_id')!;

    final manager = $$EscenarioTableTableTableManager(
      $_db,
      $_db.escenarioTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_escenarioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SitioCandidatoTableTable _sitioCandidatoIdTable(_$AppDatabase db) =>
      db.sitioCandidatoTable.createAlias(
        'escenario_almacen__sitio_candidato_id__sitio_candidato__id',
      );

  $$SitioCandidatoTableTableProcessedTableManager get sitioCandidatoId {
    final $_column = $_itemColumn<int>('sitio_candidato_id')!;

    final manager = $$SitioCandidatoTableTableTableManager(
      $_db,
      $_db.sitioCandidatoTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sitioCandidatoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EscenarioAlmacenTableTableFilterComposer
    extends Composer<_$AppDatabase, $EscenarioAlmacenTableTable> {
  $$EscenarioAlmacenTableTableFilterComposer({
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

  ColumnFilters<double> get volumenAsignado => $composableBuilder(
    column: $table.volumenAsignado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get costoFijoCent => $composableBuilder(
    column: $table.costoFijoCent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get costoManejoCent => $composableBuilder(
    column: $table.costoManejoCent,
    builder: (column) => ColumnFilters(column),
  );

  $$EscenarioTableTableFilterComposer get escenarioId {
    final $$EscenarioTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.escenarioId,
      referencedTable: $db.escenarioTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EscenarioTableTableFilterComposer(
            $db: $db,
            $table: $db.escenarioTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SitioCandidatoTableTableFilterComposer get sitioCandidatoId {
    final $$SitioCandidatoTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sitioCandidatoId,
      referencedTable: $db.sitioCandidatoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitioCandidatoTableTableFilterComposer(
            $db: $db,
            $table: $db.sitioCandidatoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EscenarioAlmacenTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EscenarioAlmacenTableTable> {
  $$EscenarioAlmacenTableTableOrderingComposer({
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

  ColumnOrderings<double> get volumenAsignado => $composableBuilder(
    column: $table.volumenAsignado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get costoFijoCent => $composableBuilder(
    column: $table.costoFijoCent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get costoManejoCent => $composableBuilder(
    column: $table.costoManejoCent,
    builder: (column) => ColumnOrderings(column),
  );

  $$EscenarioTableTableOrderingComposer get escenarioId {
    final $$EscenarioTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.escenarioId,
      referencedTable: $db.escenarioTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EscenarioTableTableOrderingComposer(
            $db: $db,
            $table: $db.escenarioTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SitioCandidatoTableTableOrderingComposer get sitioCandidatoId {
    final $$SitioCandidatoTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sitioCandidatoId,
          referencedTable: $db.sitioCandidatoTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SitioCandidatoTableTableOrderingComposer(
                $db: $db,
                $table: $db.sitioCandidatoTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$EscenarioAlmacenTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EscenarioAlmacenTableTable> {
  $$EscenarioAlmacenTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get volumenAsignado => $composableBuilder(
    column: $table.volumenAsignado,
    builder: (column) => column,
  );

  GeneratedColumn<int> get costoFijoCent => $composableBuilder(
    column: $table.costoFijoCent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get costoManejoCent => $composableBuilder(
    column: $table.costoManejoCent,
    builder: (column) => column,
  );

  $$EscenarioTableTableAnnotationComposer get escenarioId {
    final $$EscenarioTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.escenarioId,
      referencedTable: $db.escenarioTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EscenarioTableTableAnnotationComposer(
            $db: $db,
            $table: $db.escenarioTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SitioCandidatoTableTableAnnotationComposer get sitioCandidatoId {
    final $$SitioCandidatoTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sitioCandidatoId,
          referencedTable: $db.sitioCandidatoTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SitioCandidatoTableTableAnnotationComposer(
                $db: $db,
                $table: $db.sitioCandidatoTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$EscenarioAlmacenTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EscenarioAlmacenTableTable,
          EscenarioAlmacenTableData,
          $$EscenarioAlmacenTableTableFilterComposer,
          $$EscenarioAlmacenTableTableOrderingComposer,
          $$EscenarioAlmacenTableTableAnnotationComposer,
          $$EscenarioAlmacenTableTableCreateCompanionBuilder,
          $$EscenarioAlmacenTableTableUpdateCompanionBuilder,
          (EscenarioAlmacenTableData, $$EscenarioAlmacenTableTableReferences),
          EscenarioAlmacenTableData,
          PrefetchHooks Function({bool escenarioId, bool sitioCandidatoId})
        > {
  $$EscenarioAlmacenTableTableTableManager(
    _$AppDatabase db,
    $EscenarioAlmacenTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EscenarioAlmacenTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$EscenarioAlmacenTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$EscenarioAlmacenTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> escenarioId = const Value.absent(),
                Value<int> sitioCandidatoId = const Value.absent(),
                Value<double> volumenAsignado = const Value.absent(),
                Value<int> costoFijoCent = const Value.absent(),
                Value<int> costoManejoCent = const Value.absent(),
              }) => EscenarioAlmacenTableCompanion(
                id: id,
                escenarioId: escenarioId,
                sitioCandidatoId: sitioCandidatoId,
                volumenAsignado: volumenAsignado,
                costoFijoCent: costoFijoCent,
                costoManejoCent: costoManejoCent,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int escenarioId,
                required int sitioCandidatoId,
                required double volumenAsignado,
                required int costoFijoCent,
                required int costoManejoCent,
              }) => EscenarioAlmacenTableCompanion.insert(
                id: id,
                escenarioId: escenarioId,
                sitioCandidatoId: sitioCandidatoId,
                volumenAsignado: volumenAsignado,
                costoFijoCent: costoFijoCent,
                costoManejoCent: costoManejoCent,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EscenarioAlmacenTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({escenarioId = false, sitioCandidatoId = false}) {
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
                        if (escenarioId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.escenarioId,
                            referencedTable:
                                $$EscenarioAlmacenTableTableReferences
                                    ._escenarioIdTable(db),
                            referencedColumn:
                                $$EscenarioAlmacenTableTableReferences
                                    ._escenarioIdTable(db)
                                    .id,
                          ) as T;
                        }
                        if (sitioCandidatoId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.sitioCandidatoId,
                            referencedTable:
                                $$EscenarioAlmacenTableTableReferences
                                    ._sitioCandidatoIdTable(db),
                            referencedColumn:
                                $$EscenarioAlmacenTableTableReferences
                                    ._sitioCandidatoIdTable(db)
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

typedef $$EscenarioAlmacenTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EscenarioAlmacenTableTable,
      EscenarioAlmacenTableData,
      $$EscenarioAlmacenTableTableFilterComposer,
      $$EscenarioAlmacenTableTableOrderingComposer,
      $$EscenarioAlmacenTableTableAnnotationComposer,
      $$EscenarioAlmacenTableTableCreateCompanionBuilder,
      $$EscenarioAlmacenTableTableUpdateCompanionBuilder,
      (EscenarioAlmacenTableData, $$EscenarioAlmacenTableTableReferences),
      EscenarioAlmacenTableData,
      PrefetchHooks Function({bool escenarioId, bool sitioCandidatoId})
    >;
typedef $$EscenarioAsignacionTableTableCreateCompanionBuilder =
    EscenarioAsignacionTableCompanion Function({
      Value<int> id,
      required int escenarioId,
      required int zonaId,
      required int sitioCandidatoId,
      required int distanciaMetros,
      required int duracionSegundos,
      required int costoSalidaCent,
    });
typedef $$EscenarioAsignacionTableTableUpdateCompanionBuilder =
    EscenarioAsignacionTableCompanion Function({
      Value<int> id,
      Value<int> escenarioId,
      Value<int> zonaId,
      Value<int> sitioCandidatoId,
      Value<int> distanciaMetros,
      Value<int> duracionSegundos,
      Value<int> costoSalidaCent,
    });

final class $$EscenarioAsignacionTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $EscenarioAsignacionTableTable,
          EscenarioAsignacionTableData
        > {
  $$EscenarioAsignacionTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EscenarioTableTable _escenarioIdTable(_$AppDatabase db) => db
      .escenarioTable
      .createAlias('escenario_asignacion__escenario_id__escenario__id');

  $$EscenarioTableTableProcessedTableManager get escenarioId {
    final $_column = $_itemColumn<int>('escenario_id')!;

    final manager = $$EscenarioTableTableTableManager(
      $_db,
      $_db.escenarioTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_escenarioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ZonaDemandaTableTable _zonaIdTable(_$AppDatabase db) => db
      .zonaDemandaTable
      .createAlias('escenario_asignacion__zona_id__zona_demanda__id');

  $$ZonaDemandaTableTableProcessedTableManager get zonaId {
    final $_column = $_itemColumn<int>('zona_id')!;

    final manager = $$ZonaDemandaTableTableTableManager(
      $_db,
      $_db.zonaDemandaTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_zonaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SitioCandidatoTableTable _sitioCandidatoIdTable(_$AppDatabase db) =>
      db.sitioCandidatoTable.createAlias(
        'escenario_asignacion__sitio_candidato_id__sitio_candidato__id',
      );

  $$SitioCandidatoTableTableProcessedTableManager get sitioCandidatoId {
    final $_column = $_itemColumn<int>('sitio_candidato_id')!;

    final manager = $$SitioCandidatoTableTableTableManager(
      $_db,
      $_db.sitioCandidatoTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sitioCandidatoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EscenarioAsignacionTableTableFilterComposer
    extends Composer<_$AppDatabase, $EscenarioAsignacionTableTable> {
  $$EscenarioAsignacionTableTableFilterComposer({
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

  ColumnFilters<int> get distanciaMetros => $composableBuilder(
    column: $table.distanciaMetros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get duracionSegundos => $composableBuilder(
    column: $table.duracionSegundos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get costoSalidaCent => $composableBuilder(
    column: $table.costoSalidaCent,
    builder: (column) => ColumnFilters(column),
  );

  $$EscenarioTableTableFilterComposer get escenarioId {
    final $$EscenarioTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.escenarioId,
      referencedTable: $db.escenarioTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EscenarioTableTableFilterComposer(
            $db: $db,
            $table: $db.escenarioTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ZonaDemandaTableTableFilterComposer get zonaId {
    final $$ZonaDemandaTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.zonaId,
      referencedTable: $db.zonaDemandaTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ZonaDemandaTableTableFilterComposer(
            $db: $db,
            $table: $db.zonaDemandaTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SitioCandidatoTableTableFilterComposer get sitioCandidatoId {
    final $$SitioCandidatoTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sitioCandidatoId,
      referencedTable: $db.sitioCandidatoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitioCandidatoTableTableFilterComposer(
            $db: $db,
            $table: $db.sitioCandidatoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EscenarioAsignacionTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EscenarioAsignacionTableTable> {
  $$EscenarioAsignacionTableTableOrderingComposer({
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

  ColumnOrderings<int> get distanciaMetros => $composableBuilder(
    column: $table.distanciaMetros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get duracionSegundos => $composableBuilder(
    column: $table.duracionSegundos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get costoSalidaCent => $composableBuilder(
    column: $table.costoSalidaCent,
    builder: (column) => ColumnOrderings(column),
  );

  $$EscenarioTableTableOrderingComposer get escenarioId {
    final $$EscenarioTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.escenarioId,
      referencedTable: $db.escenarioTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EscenarioTableTableOrderingComposer(
            $db: $db,
            $table: $db.escenarioTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ZonaDemandaTableTableOrderingComposer get zonaId {
    final $$ZonaDemandaTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.zonaId,
      referencedTable: $db.zonaDemandaTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ZonaDemandaTableTableOrderingComposer(
            $db: $db,
            $table: $db.zonaDemandaTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SitioCandidatoTableTableOrderingComposer get sitioCandidatoId {
    final $$SitioCandidatoTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sitioCandidatoId,
          referencedTable: $db.sitioCandidatoTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SitioCandidatoTableTableOrderingComposer(
                $db: $db,
                $table: $db.sitioCandidatoTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$EscenarioAsignacionTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EscenarioAsignacionTableTable> {
  $$EscenarioAsignacionTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get distanciaMetros => $composableBuilder(
    column: $table.distanciaMetros,
    builder: (column) => column,
  );

  GeneratedColumn<int> get duracionSegundos => $composableBuilder(
    column: $table.duracionSegundos,
    builder: (column) => column,
  );

  GeneratedColumn<int> get costoSalidaCent => $composableBuilder(
    column: $table.costoSalidaCent,
    builder: (column) => column,
  );

  $$EscenarioTableTableAnnotationComposer get escenarioId {
    final $$EscenarioTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.escenarioId,
      referencedTable: $db.escenarioTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EscenarioTableTableAnnotationComposer(
            $db: $db,
            $table: $db.escenarioTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ZonaDemandaTableTableAnnotationComposer get zonaId {
    final $$ZonaDemandaTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.zonaId,
      referencedTable: $db.zonaDemandaTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ZonaDemandaTableTableAnnotationComposer(
            $db: $db,
            $table: $db.zonaDemandaTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SitioCandidatoTableTableAnnotationComposer get sitioCandidatoId {
    final $$SitioCandidatoTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sitioCandidatoId,
          referencedTable: $db.sitioCandidatoTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SitioCandidatoTableTableAnnotationComposer(
                $db: $db,
                $table: $db.sitioCandidatoTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$EscenarioAsignacionTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EscenarioAsignacionTableTable,
          EscenarioAsignacionTableData,
          $$EscenarioAsignacionTableTableFilterComposer,
          $$EscenarioAsignacionTableTableOrderingComposer,
          $$EscenarioAsignacionTableTableAnnotationComposer,
          $$EscenarioAsignacionTableTableCreateCompanionBuilder,
          $$EscenarioAsignacionTableTableUpdateCompanionBuilder,
          (
            EscenarioAsignacionTableData,
            $$EscenarioAsignacionTableTableReferences,
          ),
          EscenarioAsignacionTableData,
          PrefetchHooks Function({
            bool escenarioId,
            bool zonaId,
            bool sitioCandidatoId,
          })
        > {
  $$EscenarioAsignacionTableTableTableManager(
    _$AppDatabase db,
    $EscenarioAsignacionTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EscenarioAsignacionTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$EscenarioAsignacionTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$EscenarioAsignacionTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> escenarioId = const Value.absent(),
                Value<int> zonaId = const Value.absent(),
                Value<int> sitioCandidatoId = const Value.absent(),
                Value<int> distanciaMetros = const Value.absent(),
                Value<int> duracionSegundos = const Value.absent(),
                Value<int> costoSalidaCent = const Value.absent(),
              }) => EscenarioAsignacionTableCompanion(
                id: id,
                escenarioId: escenarioId,
                zonaId: zonaId,
                sitioCandidatoId: sitioCandidatoId,
                distanciaMetros: distanciaMetros,
                duracionSegundos: duracionSegundos,
                costoSalidaCent: costoSalidaCent,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int escenarioId,
                required int zonaId,
                required int sitioCandidatoId,
                required int distanciaMetros,
                required int duracionSegundos,
                required int costoSalidaCent,
              }) => EscenarioAsignacionTableCompanion.insert(
                id: id,
                escenarioId: escenarioId,
                zonaId: zonaId,
                sitioCandidatoId: sitioCandidatoId,
                distanciaMetros: distanciaMetros,
                duracionSegundos: duracionSegundos,
                costoSalidaCent: costoSalidaCent,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EscenarioAsignacionTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                escenarioId = false,
                zonaId = false,
                sitioCandidatoId = false,
              }) {
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
                        if (escenarioId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.escenarioId,
                            referencedTable:
                                $$EscenarioAsignacionTableTableReferences
                                    ._escenarioIdTable(db),
                            referencedColumn:
                                $$EscenarioAsignacionTableTableReferences
                                    ._escenarioIdTable(db)
                                    .id,
                          ) as T;
                        }
                        if (zonaId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.zonaId,
                            referencedTable:
                                $$EscenarioAsignacionTableTableReferences
                                    ._zonaIdTable(db),
                            referencedColumn:
                                $$EscenarioAsignacionTableTableReferences
                                    ._zonaIdTable(db)
                                    .id,
                          ) as T;
                        }
                        if (sitioCandidatoId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.sitioCandidatoId,
                            referencedTable:
                                $$EscenarioAsignacionTableTableReferences
                                    ._sitioCandidatoIdTable(db),
                            referencedColumn:
                                $$EscenarioAsignacionTableTableReferences
                                    ._sitioCandidatoIdTable(db)
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

typedef $$EscenarioAsignacionTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EscenarioAsignacionTableTable,
      EscenarioAsignacionTableData,
      $$EscenarioAsignacionTableTableFilterComposer,
      $$EscenarioAsignacionTableTableOrderingComposer,
      $$EscenarioAsignacionTableTableAnnotationComposer,
      $$EscenarioAsignacionTableTableCreateCompanionBuilder,
      $$EscenarioAsignacionTableTableUpdateCompanionBuilder,
      (EscenarioAsignacionTableData, $$EscenarioAsignacionTableTableReferences),
      EscenarioAsignacionTableData,
      PrefetchHooks Function({
        bool escenarioId,
        bool zonaId,
        bool sitioCandidatoId,
      })
    >;
typedef $$EscenarioCostoTableTableCreateCompanionBuilder =
    EscenarioCostoTableCompanion Function({
      Value<int> id,
      required int escenarioId,
      required String rubro,
      required int montoCent,
    });
typedef $$EscenarioCostoTableTableUpdateCompanionBuilder =
    EscenarioCostoTableCompanion Function({
      Value<int> id,
      Value<int> escenarioId,
      Value<String> rubro,
      Value<int> montoCent,
    });

final class $$EscenarioCostoTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $EscenarioCostoTableTable,
          EscenarioCostoTableData
        > {
  $$EscenarioCostoTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EscenarioTableTable _escenarioIdTable(_$AppDatabase db) => db
      .escenarioTable
      .createAlias('escenario_costo__escenario_id__escenario__id');

  $$EscenarioTableTableProcessedTableManager get escenarioId {
    final $_column = $_itemColumn<int>('escenario_id')!;

    final manager = $$EscenarioTableTableTableManager(
      $_db,
      $_db.escenarioTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_escenarioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EscenarioCostoTableTableFilterComposer
    extends Composer<_$AppDatabase, $EscenarioCostoTableTable> {
  $$EscenarioCostoTableTableFilterComposer({
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

  ColumnFilters<int> get montoCent => $composableBuilder(
    column: $table.montoCent,
    builder: (column) => ColumnFilters(column),
  );

  $$EscenarioTableTableFilterComposer get escenarioId {
    final $$EscenarioTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.escenarioId,
      referencedTable: $db.escenarioTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EscenarioTableTableFilterComposer(
            $db: $db,
            $table: $db.escenarioTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EscenarioCostoTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EscenarioCostoTableTable> {
  $$EscenarioCostoTableTableOrderingComposer({
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

  ColumnOrderings<int> get montoCent => $composableBuilder(
    column: $table.montoCent,
    builder: (column) => ColumnOrderings(column),
  );

  $$EscenarioTableTableOrderingComposer get escenarioId {
    final $$EscenarioTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.escenarioId,
      referencedTable: $db.escenarioTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EscenarioTableTableOrderingComposer(
            $db: $db,
            $table: $db.escenarioTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EscenarioCostoTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EscenarioCostoTableTable> {
  $$EscenarioCostoTableTableAnnotationComposer({
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

  GeneratedColumn<int> get montoCent =>
      $composableBuilder(column: $table.montoCent, builder: (column) => column);

  $$EscenarioTableTableAnnotationComposer get escenarioId {
    final $$EscenarioTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.escenarioId,
      referencedTable: $db.escenarioTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EscenarioTableTableAnnotationComposer(
            $db: $db,
            $table: $db.escenarioTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EscenarioCostoTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EscenarioCostoTableTable,
          EscenarioCostoTableData,
          $$EscenarioCostoTableTableFilterComposer,
          $$EscenarioCostoTableTableOrderingComposer,
          $$EscenarioCostoTableTableAnnotationComposer,
          $$EscenarioCostoTableTableCreateCompanionBuilder,
          $$EscenarioCostoTableTableUpdateCompanionBuilder,
          (EscenarioCostoTableData, $$EscenarioCostoTableTableReferences),
          EscenarioCostoTableData,
          PrefetchHooks Function({bool escenarioId})
        > {
  $$EscenarioCostoTableTableTableManager(
    _$AppDatabase db,
    $EscenarioCostoTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EscenarioCostoTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EscenarioCostoTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$EscenarioCostoTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> escenarioId = const Value.absent(),
                Value<String> rubro = const Value.absent(),
                Value<int> montoCent = const Value.absent(),
              }) => EscenarioCostoTableCompanion(
                id: id,
                escenarioId: escenarioId,
                rubro: rubro,
                montoCent: montoCent,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int escenarioId,
                required String rubro,
                required int montoCent,
              }) => EscenarioCostoTableCompanion.insert(
                id: id,
                escenarioId: escenarioId,
                rubro: rubro,
                montoCent: montoCent,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EscenarioCostoTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({escenarioId = false}) {
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
                    if (escenarioId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.escenarioId,
                        referencedTable: $$EscenarioCostoTableTableReferences
                            ._escenarioIdTable(db),
                        referencedColumn: $$EscenarioCostoTableTableReferences
                            ._escenarioIdTable(db)
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

typedef $$EscenarioCostoTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EscenarioCostoTableTable,
      EscenarioCostoTableData,
      $$EscenarioCostoTableTableFilterComposer,
      $$EscenarioCostoTableTableOrderingComposer,
      $$EscenarioCostoTableTableAnnotationComposer,
      $$EscenarioCostoTableTableCreateCompanionBuilder,
      $$EscenarioCostoTableTableUpdateCompanionBuilder,
      (EscenarioCostoTableData, $$EscenarioCostoTableTableReferences),
      EscenarioCostoTableData,
      PrefetchHooks Function({bool escenarioId})
    >;
typedef $$PuntoCurvaTableTableCreateCompanionBuilder =
    PuntoCurvaTableCompanion Function({
      Value<int> id,
      required int escenarioId,
      required int numeroAlmacenes,
      required int costoTotalCent,
      required String costoPorRubroJson,
      required bool viableSegunServicio,
    });
typedef $$PuntoCurvaTableTableUpdateCompanionBuilder =
    PuntoCurvaTableCompanion Function({
      Value<int> id,
      Value<int> escenarioId,
      Value<int> numeroAlmacenes,
      Value<int> costoTotalCent,
      Value<String> costoPorRubroJson,
      Value<bool> viableSegunServicio,
    });

final class $$PuntoCurvaTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PuntoCurvaTableTable,
          PuntoCurvaTableData
        > {
  $$PuntoCurvaTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EscenarioTableTable _escenarioIdTable(_$AppDatabase db) =>
      db.escenarioTable.createAlias('punto_curva__escenario_id__escenario__id');

  $$EscenarioTableTableProcessedTableManager get escenarioId {
    final $_column = $_itemColumn<int>('escenario_id')!;

    final manager = $$EscenarioTableTableTableManager(
      $_db,
      $_db.escenarioTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_escenarioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PuntoCurvaTableTableFilterComposer
    extends Composer<_$AppDatabase, $PuntoCurvaTableTable> {
  $$PuntoCurvaTableTableFilterComposer({
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

  ColumnFilters<int> get numeroAlmacenes => $composableBuilder(
    column: $table.numeroAlmacenes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get costoTotalCent => $composableBuilder(
    column: $table.costoTotalCent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get costoPorRubroJson => $composableBuilder(
    column: $table.costoPorRubroJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get viableSegunServicio => $composableBuilder(
    column: $table.viableSegunServicio,
    builder: (column) => ColumnFilters(column),
  );

  $$EscenarioTableTableFilterComposer get escenarioId {
    final $$EscenarioTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.escenarioId,
      referencedTable: $db.escenarioTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EscenarioTableTableFilterComposer(
            $db: $db,
            $table: $db.escenarioTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PuntoCurvaTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PuntoCurvaTableTable> {
  $$PuntoCurvaTableTableOrderingComposer({
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

  ColumnOrderings<int> get numeroAlmacenes => $composableBuilder(
    column: $table.numeroAlmacenes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get costoTotalCent => $composableBuilder(
    column: $table.costoTotalCent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get costoPorRubroJson => $composableBuilder(
    column: $table.costoPorRubroJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get viableSegunServicio => $composableBuilder(
    column: $table.viableSegunServicio,
    builder: (column) => ColumnOrderings(column),
  );

  $$EscenarioTableTableOrderingComposer get escenarioId {
    final $$EscenarioTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.escenarioId,
      referencedTable: $db.escenarioTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EscenarioTableTableOrderingComposer(
            $db: $db,
            $table: $db.escenarioTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PuntoCurvaTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PuntoCurvaTableTable> {
  $$PuntoCurvaTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get numeroAlmacenes => $composableBuilder(
    column: $table.numeroAlmacenes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get costoTotalCent => $composableBuilder(
    column: $table.costoTotalCent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get costoPorRubroJson => $composableBuilder(
    column: $table.costoPorRubroJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get viableSegunServicio => $composableBuilder(
    column: $table.viableSegunServicio,
    builder: (column) => column,
  );

  $$EscenarioTableTableAnnotationComposer get escenarioId {
    final $$EscenarioTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.escenarioId,
      referencedTable: $db.escenarioTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EscenarioTableTableAnnotationComposer(
            $db: $db,
            $table: $db.escenarioTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PuntoCurvaTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PuntoCurvaTableTable,
          PuntoCurvaTableData,
          $$PuntoCurvaTableTableFilterComposer,
          $$PuntoCurvaTableTableOrderingComposer,
          $$PuntoCurvaTableTableAnnotationComposer,
          $$PuntoCurvaTableTableCreateCompanionBuilder,
          $$PuntoCurvaTableTableUpdateCompanionBuilder,
          (PuntoCurvaTableData, $$PuntoCurvaTableTableReferences),
          PuntoCurvaTableData,
          PrefetchHooks Function({bool escenarioId})
        > {
  $$PuntoCurvaTableTableTableManager(
    _$AppDatabase db,
    $PuntoCurvaTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PuntoCurvaTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PuntoCurvaTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PuntoCurvaTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> escenarioId = const Value.absent(),
                Value<int> numeroAlmacenes = const Value.absent(),
                Value<int> costoTotalCent = const Value.absent(),
                Value<String> costoPorRubroJson = const Value.absent(),
                Value<bool> viableSegunServicio = const Value.absent(),
              }) => PuntoCurvaTableCompanion(
                id: id,
                escenarioId: escenarioId,
                numeroAlmacenes: numeroAlmacenes,
                costoTotalCent: costoTotalCent,
                costoPorRubroJson: costoPorRubroJson,
                viableSegunServicio: viableSegunServicio,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int escenarioId,
                required int numeroAlmacenes,
                required int costoTotalCent,
                required String costoPorRubroJson,
                required bool viableSegunServicio,
              }) => PuntoCurvaTableCompanion.insert(
                id: id,
                escenarioId: escenarioId,
                numeroAlmacenes: numeroAlmacenes,
                costoTotalCent: costoTotalCent,
                costoPorRubroJson: costoPorRubroJson,
                viableSegunServicio: viableSegunServicio,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PuntoCurvaTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({escenarioId = false}) {
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
                    if (escenarioId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.escenarioId,
                        referencedTable: $$PuntoCurvaTableTableReferences
                            ._escenarioIdTable(db),
                        referencedColumn: $$PuntoCurvaTableTableReferences
                            ._escenarioIdTable(db)
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

typedef $$PuntoCurvaTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PuntoCurvaTableTable,
      PuntoCurvaTableData,
      $$PuntoCurvaTableTableFilterComposer,
      $$PuntoCurvaTableTableOrderingComposer,
      $$PuntoCurvaTableTableAnnotationComposer,
      $$PuntoCurvaTableTableCreateCompanionBuilder,
      $$PuntoCurvaTableTableUpdateCompanionBuilder,
      (PuntoCurvaTableData, $$PuntoCurvaTableTableReferences),
      PuntoCurvaTableData,
      PrefetchHooks Function({bool escenarioId})
    >;
typedef $$MemoriaCalculoTableTableCreateCompanionBuilder =
    MemoriaCalculoTableCompanion Function({
      Value<int> id,
      required int escenarioId,
      required int orden,
      required String modulo,
      required String formula,
      required String entradasJson,
      required String salida,
      required String unidad,
    });
typedef $$MemoriaCalculoTableTableUpdateCompanionBuilder =
    MemoriaCalculoTableCompanion Function({
      Value<int> id,
      Value<int> escenarioId,
      Value<int> orden,
      Value<String> modulo,
      Value<String> formula,
      Value<String> entradasJson,
      Value<String> salida,
      Value<String> unidad,
    });

final class $$MemoriaCalculoTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MemoriaCalculoTableTable,
          MemoriaCalculoTableData
        > {
  $$MemoriaCalculoTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EscenarioTableTable _escenarioIdTable(_$AppDatabase db) => db
      .escenarioTable
      .createAlias('memoria_calculo__escenario_id__escenario__id');

  $$EscenarioTableTableProcessedTableManager get escenarioId {
    final $_column = $_itemColumn<int>('escenario_id')!;

    final manager = $$EscenarioTableTableTableManager(
      $_db,
      $_db.escenarioTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_escenarioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MemoriaCalculoTableTableFilterComposer
    extends Composer<_$AppDatabase, $MemoriaCalculoTableTable> {
  $$MemoriaCalculoTableTableFilterComposer({
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

  ColumnFilters<String> get modulo => $composableBuilder(
    column: $table.modulo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get formula => $composableBuilder(
    column: $table.formula,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entradasJson => $composableBuilder(
    column: $table.entradasJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get salida => $composableBuilder(
    column: $table.salida,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unidad => $composableBuilder(
    column: $table.unidad,
    builder: (column) => ColumnFilters(column),
  );

  $$EscenarioTableTableFilterComposer get escenarioId {
    final $$EscenarioTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.escenarioId,
      referencedTable: $db.escenarioTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EscenarioTableTableFilterComposer(
            $db: $db,
            $table: $db.escenarioTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemoriaCalculoTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MemoriaCalculoTableTable> {
  $$MemoriaCalculoTableTableOrderingComposer({
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

  ColumnOrderings<String> get modulo => $composableBuilder(
    column: $table.modulo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get formula => $composableBuilder(
    column: $table.formula,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entradasJson => $composableBuilder(
    column: $table.entradasJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get salida => $composableBuilder(
    column: $table.salida,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unidad => $composableBuilder(
    column: $table.unidad,
    builder: (column) => ColumnOrderings(column),
  );

  $$EscenarioTableTableOrderingComposer get escenarioId {
    final $$EscenarioTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.escenarioId,
      referencedTable: $db.escenarioTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EscenarioTableTableOrderingComposer(
            $db: $db,
            $table: $db.escenarioTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemoriaCalculoTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MemoriaCalculoTableTable> {
  $$MemoriaCalculoTableTableAnnotationComposer({
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

  GeneratedColumn<String> get modulo =>
      $composableBuilder(column: $table.modulo, builder: (column) => column);

  GeneratedColumn<String> get formula =>
      $composableBuilder(column: $table.formula, builder: (column) => column);

  GeneratedColumn<String> get entradasJson => $composableBuilder(
    column: $table.entradasJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get salida =>
      $composableBuilder(column: $table.salida, builder: (column) => column);

  GeneratedColumn<String> get unidad =>
      $composableBuilder(column: $table.unidad, builder: (column) => column);

  $$EscenarioTableTableAnnotationComposer get escenarioId {
    final $$EscenarioTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.escenarioId,
      referencedTable: $db.escenarioTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EscenarioTableTableAnnotationComposer(
            $db: $db,
            $table: $db.escenarioTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemoriaCalculoTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MemoriaCalculoTableTable,
          MemoriaCalculoTableData,
          $$MemoriaCalculoTableTableFilterComposer,
          $$MemoriaCalculoTableTableOrderingComposer,
          $$MemoriaCalculoTableTableAnnotationComposer,
          $$MemoriaCalculoTableTableCreateCompanionBuilder,
          $$MemoriaCalculoTableTableUpdateCompanionBuilder,
          (MemoriaCalculoTableData, $$MemoriaCalculoTableTableReferences),
          MemoriaCalculoTableData,
          PrefetchHooks Function({bool escenarioId})
        > {
  $$MemoriaCalculoTableTableTableManager(
    _$AppDatabase db,
    $MemoriaCalculoTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MemoriaCalculoTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MemoriaCalculoTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MemoriaCalculoTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> escenarioId = const Value.absent(),
                Value<int> orden = const Value.absent(),
                Value<String> modulo = const Value.absent(),
                Value<String> formula = const Value.absent(),
                Value<String> entradasJson = const Value.absent(),
                Value<String> salida = const Value.absent(),
                Value<String> unidad = const Value.absent(),
              }) => MemoriaCalculoTableCompanion(
                id: id,
                escenarioId: escenarioId,
                orden: orden,
                modulo: modulo,
                formula: formula,
                entradasJson: entradasJson,
                salida: salida,
                unidad: unidad,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int escenarioId,
                required int orden,
                required String modulo,
                required String formula,
                required String entradasJson,
                required String salida,
                required String unidad,
              }) => MemoriaCalculoTableCompanion.insert(
                id: id,
                escenarioId: escenarioId,
                orden: orden,
                modulo: modulo,
                formula: formula,
                entradasJson: entradasJson,
                salida: salida,
                unidad: unidad,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MemoriaCalculoTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({escenarioId = false}) {
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
                    if (escenarioId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.escenarioId,
                        referencedTable: $$MemoriaCalculoTableTableReferences
                            ._escenarioIdTable(db),
                        referencedColumn: $$MemoriaCalculoTableTableReferences
                            ._escenarioIdTable(db)
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

typedef $$MemoriaCalculoTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MemoriaCalculoTableTable,
      MemoriaCalculoTableData,
      $$MemoriaCalculoTableTableFilterComposer,
      $$MemoriaCalculoTableTableOrderingComposer,
      $$MemoriaCalculoTableTableAnnotationComposer,
      $$MemoriaCalculoTableTableCreateCompanionBuilder,
      $$MemoriaCalculoTableTableUpdateCompanionBuilder,
      (MemoriaCalculoTableData, $$MemoriaCalculoTableTableReferences),
      MemoriaCalculoTableData,
      PrefetchHooks Function({bool escenarioId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProyectoTableTableTableManager get proyectoTable =>
      $$ProyectoTableTableTableManager(_db, _db.proyectoTable);
  $$ClienteTableTableTableManager get clienteTable =>
      $$ClienteTableTableTableManager(_db, _db.clienteTable);
  $$ZonaDemandaTableTableTableManager get zonaDemandaTable =>
      $$ZonaDemandaTableTableTableManager(_db, _db.zonaDemandaTable);
  $$ClienteZonaTableTableTableManager get clienteZonaTable =>
      $$ClienteZonaTableTableTableManager(_db, _db.clienteZonaTable);
  $$SitioCandidatoTableTableTableManager get sitioCandidatoTable =>
      $$SitioCandidatoTableTableTableManager(_db, _db.sitioCandidatoTable);
  $$PlantaTableTableTableManager get plantaTable =>
      $$PlantaTableTableTableManager(_db, _db.plantaTable);
  $$ParametrosCostoTableTableTableManager get parametrosCostoTable =>
      $$ParametrosCostoTableTableTableManager(_db, _db.parametrosCostoTable);
  $$CeldaMatrizTableTableTableManager get celdaMatrizTable =>
      $$CeldaMatrizTableTableTableManager(_db, _db.celdaMatrizTable);
  $$CacheRuteoTableTableTableManager get cacheRuteoTable =>
      $$CacheRuteoTableTableTableManager(_db, _db.cacheRuteoTable);
  $$EscenarioTableTableTableManager get escenarioTable =>
      $$EscenarioTableTableTableManager(_db, _db.escenarioTable);
  $$EscenarioAlmacenTableTableTableManager get escenarioAlmacenTable =>
      $$EscenarioAlmacenTableTableTableManager(_db, _db.escenarioAlmacenTable);
  $$EscenarioAsignacionTableTableTableManager get escenarioAsignacionTable =>
      $$EscenarioAsignacionTableTableTableManager(
        _db,
        _db.escenarioAsignacionTable,
      );
  $$EscenarioCostoTableTableTableManager get escenarioCostoTable =>
      $$EscenarioCostoTableTableTableManager(_db, _db.escenarioCostoTable);
  $$PuntoCurvaTableTableTableManager get puntoCurvaTable =>
      $$PuntoCurvaTableTableTableManager(_db, _db.puntoCurvaTable);
  $$MemoriaCalculoTableTableTableManager get memoriaCalculoTable =>
      $$MemoriaCalculoTableTableTableManager(_db, _db.memoriaCalculoTable);
}
