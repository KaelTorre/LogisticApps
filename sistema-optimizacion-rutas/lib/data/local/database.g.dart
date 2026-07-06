// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $DepositoTableTable extends DepositoTable
    with TableInfo<$DepositoTableTable, DepositoTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DepositoTableTable(this.attachedDatabase, [this._alias]);
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
  @override
  List<GeneratedColumn> get $columns => [id, nombre, latitud, longitud];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'deposito';
  @override
  VerificationContext validateIntegrity(
    Insertable<DepositoTableData> instance, {
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DepositoTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DepositoTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
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
    );
  }

  @override
  $DepositoTableTable createAlias(String alias) {
    return $DepositoTableTable(attachedDatabase, alias);
  }
}

class DepositoTableData extends DataClass
    implements Insertable<DepositoTableData> {
  final int id;
  final String nombre;
  final double latitud;
  final double longitud;
  const DepositoTableData({
    required this.id,
    required this.nombre,
    required this.latitud,
    required this.longitud,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['latitud'] = Variable<double>(latitud);
    map['longitud'] = Variable<double>(longitud);
    return map;
  }

  DepositoTableCompanion toCompanion(bool nullToAbsent) {
    return DepositoTableCompanion(
      id: Value(id),
      nombre: Value(nombre),
      latitud: Value(latitud),
      longitud: Value(longitud),
    );
  }

  factory DepositoTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DepositoTableData(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      latitud: serializer.fromJson<double>(json['latitud']),
      longitud: serializer.fromJson<double>(json['longitud']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'latitud': serializer.toJson<double>(latitud),
      'longitud': serializer.toJson<double>(longitud),
    };
  }

  DepositoTableData copyWith({
    int? id,
    String? nombre,
    double? latitud,
    double? longitud,
  }) => DepositoTableData(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    latitud: latitud ?? this.latitud,
    longitud: longitud ?? this.longitud,
  );
  DepositoTableData copyWithCompanion(DepositoTableCompanion data) {
    return DepositoTableData(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      latitud: data.latitud.present ? data.latitud.value : this.latitud,
      longitud: data.longitud.present ? data.longitud.value : this.longitud,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DepositoTableData(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('latitud: $latitud, ')
          ..write('longitud: $longitud')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, latitud, longitud);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DepositoTableData &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.latitud == this.latitud &&
          other.longitud == this.longitud);
}

class DepositoTableCompanion extends UpdateCompanion<DepositoTableData> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<double> latitud;
  final Value<double> longitud;
  const DepositoTableCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.latitud = const Value.absent(),
    this.longitud = const Value.absent(),
  });
  DepositoTableCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required double latitud,
    required double longitud,
  }) : nombre = Value(nombre),
       latitud = Value(latitud),
       longitud = Value(longitud);
  static Insertable<DepositoTableData> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<double>? latitud,
    Expression<double>? longitud,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (latitud != null) 'latitud': latitud,
      if (longitud != null) 'longitud': longitud,
    });
  }

  DepositoTableCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<double>? latitud,
    Value<double>? longitud,
  }) {
    return DepositoTableCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
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
    if (latitud.present) {
      map['latitud'] = Variable<double>(latitud.value);
    }
    if (longitud.present) {
      map['longitud'] = Variable<double>(longitud.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DepositoTableCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('latitud: $latitud, ')
          ..write('longitud: $longitud')
          ..write(')'))
        .toString();
  }
}

class $PuntoEntregaTableTable extends PuntoEntregaTable
    with TableInfo<$PuntoEntregaTableTable, PuntoEntregaTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PuntoEntregaTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _demandaMeta = const VerificationMeta(
    'demanda',
  );
  @override
  late final GeneratedColumn<double> demanda = GeneratedColumn<double>(
    'demanda',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _ventanaInicioMeta = const VerificationMeta(
    'ventanaInicio',
  );
  @override
  late final GeneratedColumn<String> ventanaInicio = GeneratedColumn<String>(
    'ventana_inicio',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ventanaFinMeta = const VerificationMeta(
    'ventanaFin',
  );
  @override
  late final GeneratedColumn<String> ventanaFin = GeneratedColumn<String>(
    'ventana_fin',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    latitud,
    longitud,
    demanda,
    ventanaInicio,
    ventanaFin,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'punto_entrega';
  @override
  VerificationContext validateIntegrity(
    Insertable<PuntoEntregaTableData> instance, {
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
    if (data.containsKey('demanda')) {
      context.handle(
        _demandaMeta,
        demanda.isAcceptableOrUnknown(data['demanda']!, _demandaMeta),
      );
    }
    if (data.containsKey('ventana_inicio')) {
      context.handle(
        _ventanaInicioMeta,
        ventanaInicio.isAcceptableOrUnknown(
          data['ventana_inicio']!,
          _ventanaInicioMeta,
        ),
      );
    }
    if (data.containsKey('ventana_fin')) {
      context.handle(
        _ventanaFinMeta,
        ventanaFin.isAcceptableOrUnknown(data['ventana_fin']!, _ventanaFinMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PuntoEntregaTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PuntoEntregaTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
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
      demanda: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}demanda'],
      )!,
      ventanaInicio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ventana_inicio'],
      ),
      ventanaFin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ventana_fin'],
      ),
    );
  }

  @override
  $PuntoEntregaTableTable createAlias(String alias) {
    return $PuntoEntregaTableTable(attachedDatabase, alias);
  }
}

class PuntoEntregaTableData extends DataClass
    implements Insertable<PuntoEntregaTableData> {
  final int id;
  final String nombre;
  final double latitud;
  final double longitud;
  final double demanda;
  final String? ventanaInicio;
  final String? ventanaFin;
  const PuntoEntregaTableData({
    required this.id,
    required this.nombre,
    required this.latitud,
    required this.longitud,
    required this.demanda,
    this.ventanaInicio,
    this.ventanaFin,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['latitud'] = Variable<double>(latitud);
    map['longitud'] = Variable<double>(longitud);
    map['demanda'] = Variable<double>(demanda);
    if (!nullToAbsent || ventanaInicio != null) {
      map['ventana_inicio'] = Variable<String>(ventanaInicio);
    }
    if (!nullToAbsent || ventanaFin != null) {
      map['ventana_fin'] = Variable<String>(ventanaFin);
    }
    return map;
  }

  PuntoEntregaTableCompanion toCompanion(bool nullToAbsent) {
    return PuntoEntregaTableCompanion(
      id: Value(id),
      nombre: Value(nombre),
      latitud: Value(latitud),
      longitud: Value(longitud),
      demanda: Value(demanda),
      ventanaInicio: ventanaInicio == null && nullToAbsent
          ? const Value.absent()
          : Value(ventanaInicio),
      ventanaFin: ventanaFin == null && nullToAbsent
          ? const Value.absent()
          : Value(ventanaFin),
    );
  }

  factory PuntoEntregaTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PuntoEntregaTableData(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      latitud: serializer.fromJson<double>(json['latitud']),
      longitud: serializer.fromJson<double>(json['longitud']),
      demanda: serializer.fromJson<double>(json['demanda']),
      ventanaInicio: serializer.fromJson<String?>(json['ventanaInicio']),
      ventanaFin: serializer.fromJson<String?>(json['ventanaFin']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'latitud': serializer.toJson<double>(latitud),
      'longitud': serializer.toJson<double>(longitud),
      'demanda': serializer.toJson<double>(demanda),
      'ventanaInicio': serializer.toJson<String?>(ventanaInicio),
      'ventanaFin': serializer.toJson<String?>(ventanaFin),
    };
  }

  PuntoEntregaTableData copyWith({
    int? id,
    String? nombre,
    double? latitud,
    double? longitud,
    double? demanda,
    Value<String?> ventanaInicio = const Value.absent(),
    Value<String?> ventanaFin = const Value.absent(),
  }) => PuntoEntregaTableData(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    latitud: latitud ?? this.latitud,
    longitud: longitud ?? this.longitud,
    demanda: demanda ?? this.demanda,
    ventanaInicio: ventanaInicio.present
        ? ventanaInicio.value
        : this.ventanaInicio,
    ventanaFin: ventanaFin.present ? ventanaFin.value : this.ventanaFin,
  );
  PuntoEntregaTableData copyWithCompanion(PuntoEntregaTableCompanion data) {
    return PuntoEntregaTableData(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      latitud: data.latitud.present ? data.latitud.value : this.latitud,
      longitud: data.longitud.present ? data.longitud.value : this.longitud,
      demanda: data.demanda.present ? data.demanda.value : this.demanda,
      ventanaInicio: data.ventanaInicio.present
          ? data.ventanaInicio.value
          : this.ventanaInicio,
      ventanaFin: data.ventanaFin.present
          ? data.ventanaFin.value
          : this.ventanaFin,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PuntoEntregaTableData(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('latitud: $latitud, ')
          ..write('longitud: $longitud, ')
          ..write('demanda: $demanda, ')
          ..write('ventanaInicio: $ventanaInicio, ')
          ..write('ventanaFin: $ventanaFin')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    latitud,
    longitud,
    demanda,
    ventanaInicio,
    ventanaFin,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PuntoEntregaTableData &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.latitud == this.latitud &&
          other.longitud == this.longitud &&
          other.demanda == this.demanda &&
          other.ventanaInicio == this.ventanaInicio &&
          other.ventanaFin == this.ventanaFin);
}

class PuntoEntregaTableCompanion
    extends UpdateCompanion<PuntoEntregaTableData> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<double> latitud;
  final Value<double> longitud;
  final Value<double> demanda;
  final Value<String?> ventanaInicio;
  final Value<String?> ventanaFin;
  const PuntoEntregaTableCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.latitud = const Value.absent(),
    this.longitud = const Value.absent(),
    this.demanda = const Value.absent(),
    this.ventanaInicio = const Value.absent(),
    this.ventanaFin = const Value.absent(),
  });
  PuntoEntregaTableCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required double latitud,
    required double longitud,
    this.demanda = const Value.absent(),
    this.ventanaInicio = const Value.absent(),
    this.ventanaFin = const Value.absent(),
  }) : nombre = Value(nombre),
       latitud = Value(latitud),
       longitud = Value(longitud);
  static Insertable<PuntoEntregaTableData> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<double>? latitud,
    Expression<double>? longitud,
    Expression<double>? demanda,
    Expression<String>? ventanaInicio,
    Expression<String>? ventanaFin,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (latitud != null) 'latitud': latitud,
      if (longitud != null) 'longitud': longitud,
      if (demanda != null) 'demanda': demanda,
      if (ventanaInicio != null) 'ventana_inicio': ventanaInicio,
      if (ventanaFin != null) 'ventana_fin': ventanaFin,
    });
  }

  PuntoEntregaTableCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<double>? latitud,
    Value<double>? longitud,
    Value<double>? demanda,
    Value<String?>? ventanaInicio,
    Value<String?>? ventanaFin,
  }) {
    return PuntoEntregaTableCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      demanda: demanda ?? this.demanda,
      ventanaInicio: ventanaInicio ?? this.ventanaInicio,
      ventanaFin: ventanaFin ?? this.ventanaFin,
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
    if (latitud.present) {
      map['latitud'] = Variable<double>(latitud.value);
    }
    if (longitud.present) {
      map['longitud'] = Variable<double>(longitud.value);
    }
    if (demanda.present) {
      map['demanda'] = Variable<double>(demanda.value);
    }
    if (ventanaInicio.present) {
      map['ventana_inicio'] = Variable<String>(ventanaInicio.value);
    }
    if (ventanaFin.present) {
      map['ventana_fin'] = Variable<String>(ventanaFin.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PuntoEntregaTableCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('latitud: $latitud, ')
          ..write('longitud: $longitud, ')
          ..write('demanda: $demanda, ')
          ..write('ventanaInicio: $ventanaInicio, ')
          ..write('ventanaFin: $ventanaFin')
          ..write(')'))
        .toString();
  }
}

class $VehiculoTableTable extends VehiculoTable
    with TableInfo<$VehiculoTableTable, VehiculoTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VehiculoTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _capacidadMaximaMeta = const VerificationMeta(
    'capacidadMaxima',
  );
  @override
  late final GeneratedColumn<double> capacidadMaxima = GeneratedColumn<double>(
    'capacidad_maxima',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costoEstimadoPorKmMeta =
      const VerificationMeta('costoEstimadoPorKm');
  @override
  late final GeneratedColumn<double> costoEstimadoPorKm =
      GeneratedColumn<double>(
        'costo_estimado_por_km',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _tipoFlotaMeta = const VerificationMeta(
    'tipoFlota',
  );
  @override
  late final GeneratedColumn<String> tipoFlota = GeneratedColumn<String>(
    'tipo_flota',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    capacidadMaxima,
    costoEstimadoPorKm,
    tipoFlota,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vehiculo';
  @override
  VerificationContext validateIntegrity(
    Insertable<VehiculoTableData> instance, {
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
    if (data.containsKey('capacidad_maxima')) {
      context.handle(
        _capacidadMaximaMeta,
        capacidadMaxima.isAcceptableOrUnknown(
          data['capacidad_maxima']!,
          _capacidadMaximaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_capacidadMaximaMeta);
    }
    if (data.containsKey('costo_estimado_por_km')) {
      context.handle(
        _costoEstimadoPorKmMeta,
        costoEstimadoPorKm.isAcceptableOrUnknown(
          data['costo_estimado_por_km']!,
          _costoEstimadoPorKmMeta,
        ),
      );
    }
    if (data.containsKey('tipo_flota')) {
      context.handle(
        _tipoFlotaMeta,
        tipoFlota.isAcceptableOrUnknown(data['tipo_flota']!, _tipoFlotaMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VehiculoTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VehiculoTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      capacidadMaxima: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}capacidad_maxima'],
      )!,
      costoEstimadoPorKm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}costo_estimado_por_km'],
      ),
      tipoFlota: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo_flota'],
      ),
    );
  }

  @override
  $VehiculoTableTable createAlias(String alias) {
    return $VehiculoTableTable(attachedDatabase, alias);
  }
}

class VehiculoTableData extends DataClass
    implements Insertable<VehiculoTableData> {
  final int id;
  final String nombre;
  final double capacidadMaxima;
  final double? costoEstimadoPorKm;
  final String? tipoFlota;
  const VehiculoTableData({
    required this.id,
    required this.nombre,
    required this.capacidadMaxima,
    this.costoEstimadoPorKm,
    this.tipoFlota,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['capacidad_maxima'] = Variable<double>(capacidadMaxima);
    if (!nullToAbsent || costoEstimadoPorKm != null) {
      map['costo_estimado_por_km'] = Variable<double>(costoEstimadoPorKm);
    }
    if (!nullToAbsent || tipoFlota != null) {
      map['tipo_flota'] = Variable<String>(tipoFlota);
    }
    return map;
  }

  VehiculoTableCompanion toCompanion(bool nullToAbsent) {
    return VehiculoTableCompanion(
      id: Value(id),
      nombre: Value(nombre),
      capacidadMaxima: Value(capacidadMaxima),
      costoEstimadoPorKm: costoEstimadoPorKm == null && nullToAbsent
          ? const Value.absent()
          : Value(costoEstimadoPorKm),
      tipoFlota: tipoFlota == null && nullToAbsent
          ? const Value.absent()
          : Value(tipoFlota),
    );
  }

  factory VehiculoTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VehiculoTableData(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      capacidadMaxima: serializer.fromJson<double>(json['capacidadMaxima']),
      costoEstimadoPorKm: serializer.fromJson<double?>(
        json['costoEstimadoPorKm'],
      ),
      tipoFlota: serializer.fromJson<String?>(json['tipoFlota']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'capacidadMaxima': serializer.toJson<double>(capacidadMaxima),
      'costoEstimadoPorKm': serializer.toJson<double?>(costoEstimadoPorKm),
      'tipoFlota': serializer.toJson<String?>(tipoFlota),
    };
  }

  VehiculoTableData copyWith({
    int? id,
    String? nombre,
    double? capacidadMaxima,
    Value<double?> costoEstimadoPorKm = const Value.absent(),
    Value<String?> tipoFlota = const Value.absent(),
  }) => VehiculoTableData(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    capacidadMaxima: capacidadMaxima ?? this.capacidadMaxima,
    costoEstimadoPorKm: costoEstimadoPorKm.present
        ? costoEstimadoPorKm.value
        : this.costoEstimadoPorKm,
    tipoFlota: tipoFlota.present ? tipoFlota.value : this.tipoFlota,
  );
  VehiculoTableData copyWithCompanion(VehiculoTableCompanion data) {
    return VehiculoTableData(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      capacidadMaxima: data.capacidadMaxima.present
          ? data.capacidadMaxima.value
          : this.capacidadMaxima,
      costoEstimadoPorKm: data.costoEstimadoPorKm.present
          ? data.costoEstimadoPorKm.value
          : this.costoEstimadoPorKm,
      tipoFlota: data.tipoFlota.present ? data.tipoFlota.value : this.tipoFlota,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VehiculoTableData(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('capacidadMaxima: $capacidadMaxima, ')
          ..write('costoEstimadoPorKm: $costoEstimadoPorKm, ')
          ..write('tipoFlota: $tipoFlota')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nombre, capacidadMaxima, costoEstimadoPorKm, tipoFlota);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VehiculoTableData &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.capacidadMaxima == this.capacidadMaxima &&
          other.costoEstimadoPorKm == this.costoEstimadoPorKm &&
          other.tipoFlota == this.tipoFlota);
}

class VehiculoTableCompanion extends UpdateCompanion<VehiculoTableData> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<double> capacidadMaxima;
  final Value<double?> costoEstimadoPorKm;
  final Value<String?> tipoFlota;
  const VehiculoTableCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.capacidadMaxima = const Value.absent(),
    this.costoEstimadoPorKm = const Value.absent(),
    this.tipoFlota = const Value.absent(),
  });
  VehiculoTableCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required double capacidadMaxima,
    this.costoEstimadoPorKm = const Value.absent(),
    this.tipoFlota = const Value.absent(),
  }) : nombre = Value(nombre),
       capacidadMaxima = Value(capacidadMaxima);
  static Insertable<VehiculoTableData> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<double>? capacidadMaxima,
    Expression<double>? costoEstimadoPorKm,
    Expression<String>? tipoFlota,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (capacidadMaxima != null) 'capacidad_maxima': capacidadMaxima,
      if (costoEstimadoPorKm != null)
        'costo_estimado_por_km': costoEstimadoPorKm,
      if (tipoFlota != null) 'tipo_flota': tipoFlota,
    });
  }

  VehiculoTableCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<double>? capacidadMaxima,
    Value<double?>? costoEstimadoPorKm,
    Value<String?>? tipoFlota,
  }) {
    return VehiculoTableCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      capacidadMaxima: capacidadMaxima ?? this.capacidadMaxima,
      costoEstimadoPorKm: costoEstimadoPorKm ?? this.costoEstimadoPorKm,
      tipoFlota: tipoFlota ?? this.tipoFlota,
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
    if (capacidadMaxima.present) {
      map['capacidad_maxima'] = Variable<double>(capacidadMaxima.value);
    }
    if (costoEstimadoPorKm.present) {
      map['costo_estimado_por_km'] = Variable<double>(costoEstimadoPorKm.value);
    }
    if (tipoFlota.present) {
      map['tipo_flota'] = Variable<String>(tipoFlota.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VehiculoTableCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('capacidadMaxima: $capacidadMaxima, ')
          ..write('costoEstimadoPorKm: $costoEstimadoPorKm, ')
          ..write('tipoFlota: $tipoFlota')
          ..write(')'))
        .toString();
  }
}

class $HistorialCalculoTableTable extends HistorialCalculoTable
    with TableInfo<$HistorialCalculoTableTable, HistorialCalculoTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HistorialCalculoTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _fechaCalculoMeta = const VerificationMeta(
    'fechaCalculo',
  );
  @override
  late final GeneratedColumn<String> fechaCalculo = GeneratedColumn<String>(
    'fecha_calculo',
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
  static const VerificationMeta _depositoNombreMeta = const VerificationMeta(
    'depositoNombre',
  );
  @override
  late final GeneratedColumn<String> depositoNombre = GeneratedColumn<String>(
    'deposito_nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _depositoLatitudMeta = const VerificationMeta(
    'depositoLatitud',
  );
  @override
  late final GeneratedColumn<double> depositoLatitud = GeneratedColumn<double>(
    'deposito_latitud',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _depositoLongitudMeta = const VerificationMeta(
    'depositoLongitud',
  );
  @override
  late final GeneratedColumn<double> depositoLongitud = GeneratedColumn<double>(
    'deposito_longitud',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vehiculosFaltantesMeta =
      const VerificationMeta('vehiculosFaltantes');
  @override
  late final GeneratedColumn<int> vehiculosFaltantes = GeneratedColumn<int>(
    'vehiculos_faltantes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _distanciaTotalMetrosMeta =
      const VerificationMeta('distanciaTotalMetros');
  @override
  late final GeneratedColumn<double> distanciaTotalMetros =
      GeneratedColumn<double>(
        'distancia_total_metros',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _cantidadRutasMeta = const VerificationMeta(
    'cantidadRutas',
  );
  @override
  late final GeneratedColumn<int> cantidadRutas = GeneratedColumn<int>(
    'cantidad_rutas',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fechaCalculo,
    metodo,
    depositoNombre,
    depositoLatitud,
    depositoLongitud,
    vehiculosFaltantes,
    distanciaTotalMetros,
    cantidadRutas,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'historial_calculo';
  @override
  VerificationContext validateIntegrity(
    Insertable<HistorialCalculoTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('fecha_calculo')) {
      context.handle(
        _fechaCalculoMeta,
        fechaCalculo.isAcceptableOrUnknown(
          data['fecha_calculo']!,
          _fechaCalculoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaCalculoMeta);
    }
    if (data.containsKey('metodo')) {
      context.handle(
        _metodoMeta,
        metodo.isAcceptableOrUnknown(data['metodo']!, _metodoMeta),
      );
    } else if (isInserting) {
      context.missing(_metodoMeta);
    }
    if (data.containsKey('deposito_nombre')) {
      context.handle(
        _depositoNombreMeta,
        depositoNombre.isAcceptableOrUnknown(
          data['deposito_nombre']!,
          _depositoNombreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_depositoNombreMeta);
    }
    if (data.containsKey('deposito_latitud')) {
      context.handle(
        _depositoLatitudMeta,
        depositoLatitud.isAcceptableOrUnknown(
          data['deposito_latitud']!,
          _depositoLatitudMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_depositoLatitudMeta);
    }
    if (data.containsKey('deposito_longitud')) {
      context.handle(
        _depositoLongitudMeta,
        depositoLongitud.isAcceptableOrUnknown(
          data['deposito_longitud']!,
          _depositoLongitudMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_depositoLongitudMeta);
    }
    if (data.containsKey('vehiculos_faltantes')) {
      context.handle(
        _vehiculosFaltantesMeta,
        vehiculosFaltantes.isAcceptableOrUnknown(
          data['vehiculos_faltantes']!,
          _vehiculosFaltantesMeta,
        ),
      );
    }
    if (data.containsKey('distancia_total_metros')) {
      context.handle(
        _distanciaTotalMetrosMeta,
        distanciaTotalMetros.isAcceptableOrUnknown(
          data['distancia_total_metros']!,
          _distanciaTotalMetrosMeta,
        ),
      );
    }
    if (data.containsKey('cantidad_rutas')) {
      context.handle(
        _cantidadRutasMeta,
        cantidadRutas.isAcceptableOrUnknown(
          data['cantidad_rutas']!,
          _cantidadRutasMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HistorialCalculoTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HistorialCalculoTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      fechaCalculo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fecha_calculo'],
      )!,
      metodo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metodo'],
      )!,
      depositoNombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deposito_nombre'],
      )!,
      depositoLatitud: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}deposito_latitud'],
      )!,
      depositoLongitud: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}deposito_longitud'],
      )!,
      vehiculosFaltantes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vehiculos_faltantes'],
      )!,
      distanciaTotalMetros: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distancia_total_metros'],
      )!,
      cantidadRutas: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidad_rutas'],
      )!,
    );
  }

  @override
  $HistorialCalculoTableTable createAlias(String alias) {
    return $HistorialCalculoTableTable(attachedDatabase, alias);
  }
}

class HistorialCalculoTableData extends DataClass
    implements Insertable<HistorialCalculoTableData> {
  final int id;
  final String fechaCalculo;
  final String metodo;
  final String depositoNombre;
  final double depositoLatitud;
  final double depositoLongitud;
  final int vehiculosFaltantes;
  final double distanciaTotalMetros;
  final int cantidadRutas;
  const HistorialCalculoTableData({
    required this.id,
    required this.fechaCalculo,
    required this.metodo,
    required this.depositoNombre,
    required this.depositoLatitud,
    required this.depositoLongitud,
    required this.vehiculosFaltantes,
    required this.distanciaTotalMetros,
    required this.cantidadRutas,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['fecha_calculo'] = Variable<String>(fechaCalculo);
    map['metodo'] = Variable<String>(metodo);
    map['deposito_nombre'] = Variable<String>(depositoNombre);
    map['deposito_latitud'] = Variable<double>(depositoLatitud);
    map['deposito_longitud'] = Variable<double>(depositoLongitud);
    map['vehiculos_faltantes'] = Variable<int>(vehiculosFaltantes);
    map['distancia_total_metros'] = Variable<double>(distanciaTotalMetros);
    map['cantidad_rutas'] = Variable<int>(cantidadRutas);
    return map;
  }

  HistorialCalculoTableCompanion toCompanion(bool nullToAbsent) {
    return HistorialCalculoTableCompanion(
      id: Value(id),
      fechaCalculo: Value(fechaCalculo),
      metodo: Value(metodo),
      depositoNombre: Value(depositoNombre),
      depositoLatitud: Value(depositoLatitud),
      depositoLongitud: Value(depositoLongitud),
      vehiculosFaltantes: Value(vehiculosFaltantes),
      distanciaTotalMetros: Value(distanciaTotalMetros),
      cantidadRutas: Value(cantidadRutas),
    );
  }

  factory HistorialCalculoTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HistorialCalculoTableData(
      id: serializer.fromJson<int>(json['id']),
      fechaCalculo: serializer.fromJson<String>(json['fechaCalculo']),
      metodo: serializer.fromJson<String>(json['metodo']),
      depositoNombre: serializer.fromJson<String>(json['depositoNombre']),
      depositoLatitud: serializer.fromJson<double>(json['depositoLatitud']),
      depositoLongitud: serializer.fromJson<double>(json['depositoLongitud']),
      vehiculosFaltantes: serializer.fromJson<int>(json['vehiculosFaltantes']),
      distanciaTotalMetros: serializer.fromJson<double>(
        json['distanciaTotalMetros'],
      ),
      cantidadRutas: serializer.fromJson<int>(json['cantidadRutas']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fechaCalculo': serializer.toJson<String>(fechaCalculo),
      'metodo': serializer.toJson<String>(metodo),
      'depositoNombre': serializer.toJson<String>(depositoNombre),
      'depositoLatitud': serializer.toJson<double>(depositoLatitud),
      'depositoLongitud': serializer.toJson<double>(depositoLongitud),
      'vehiculosFaltantes': serializer.toJson<int>(vehiculosFaltantes),
      'distanciaTotalMetros': serializer.toJson<double>(distanciaTotalMetros),
      'cantidadRutas': serializer.toJson<int>(cantidadRutas),
    };
  }

  HistorialCalculoTableData copyWith({
    int? id,
    String? fechaCalculo,
    String? metodo,
    String? depositoNombre,
    double? depositoLatitud,
    double? depositoLongitud,
    int? vehiculosFaltantes,
    double? distanciaTotalMetros,
    int? cantidadRutas,
  }) => HistorialCalculoTableData(
    id: id ?? this.id,
    fechaCalculo: fechaCalculo ?? this.fechaCalculo,
    metodo: metodo ?? this.metodo,
    depositoNombre: depositoNombre ?? this.depositoNombre,
    depositoLatitud: depositoLatitud ?? this.depositoLatitud,
    depositoLongitud: depositoLongitud ?? this.depositoLongitud,
    vehiculosFaltantes: vehiculosFaltantes ?? this.vehiculosFaltantes,
    distanciaTotalMetros: distanciaTotalMetros ?? this.distanciaTotalMetros,
    cantidadRutas: cantidadRutas ?? this.cantidadRutas,
  );
  HistorialCalculoTableData copyWithCompanion(
    HistorialCalculoTableCompanion data,
  ) {
    return HistorialCalculoTableData(
      id: data.id.present ? data.id.value : this.id,
      fechaCalculo: data.fechaCalculo.present
          ? data.fechaCalculo.value
          : this.fechaCalculo,
      metodo: data.metodo.present ? data.metodo.value : this.metodo,
      depositoNombre: data.depositoNombre.present
          ? data.depositoNombre.value
          : this.depositoNombre,
      depositoLatitud: data.depositoLatitud.present
          ? data.depositoLatitud.value
          : this.depositoLatitud,
      depositoLongitud: data.depositoLongitud.present
          ? data.depositoLongitud.value
          : this.depositoLongitud,
      vehiculosFaltantes: data.vehiculosFaltantes.present
          ? data.vehiculosFaltantes.value
          : this.vehiculosFaltantes,
      distanciaTotalMetros: data.distanciaTotalMetros.present
          ? data.distanciaTotalMetros.value
          : this.distanciaTotalMetros,
      cantidadRutas: data.cantidadRutas.present
          ? data.cantidadRutas.value
          : this.cantidadRutas,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HistorialCalculoTableData(')
          ..write('id: $id, ')
          ..write('fechaCalculo: $fechaCalculo, ')
          ..write('metodo: $metodo, ')
          ..write('depositoNombre: $depositoNombre, ')
          ..write('depositoLatitud: $depositoLatitud, ')
          ..write('depositoLongitud: $depositoLongitud, ')
          ..write('vehiculosFaltantes: $vehiculosFaltantes, ')
          ..write('distanciaTotalMetros: $distanciaTotalMetros, ')
          ..write('cantidadRutas: $cantidadRutas')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    fechaCalculo,
    metodo,
    depositoNombre,
    depositoLatitud,
    depositoLongitud,
    vehiculosFaltantes,
    distanciaTotalMetros,
    cantidadRutas,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HistorialCalculoTableData &&
          other.id == this.id &&
          other.fechaCalculo == this.fechaCalculo &&
          other.metodo == this.metodo &&
          other.depositoNombre == this.depositoNombre &&
          other.depositoLatitud == this.depositoLatitud &&
          other.depositoLongitud == this.depositoLongitud &&
          other.vehiculosFaltantes == this.vehiculosFaltantes &&
          other.distanciaTotalMetros == this.distanciaTotalMetros &&
          other.cantidadRutas == this.cantidadRutas);
}

class HistorialCalculoTableCompanion
    extends UpdateCompanion<HistorialCalculoTableData> {
  final Value<int> id;
  final Value<String> fechaCalculo;
  final Value<String> metodo;
  final Value<String> depositoNombre;
  final Value<double> depositoLatitud;
  final Value<double> depositoLongitud;
  final Value<int> vehiculosFaltantes;
  final Value<double> distanciaTotalMetros;
  final Value<int> cantidadRutas;
  const HistorialCalculoTableCompanion({
    this.id = const Value.absent(),
    this.fechaCalculo = const Value.absent(),
    this.metodo = const Value.absent(),
    this.depositoNombre = const Value.absent(),
    this.depositoLatitud = const Value.absent(),
    this.depositoLongitud = const Value.absent(),
    this.vehiculosFaltantes = const Value.absent(),
    this.distanciaTotalMetros = const Value.absent(),
    this.cantidadRutas = const Value.absent(),
  });
  HistorialCalculoTableCompanion.insert({
    this.id = const Value.absent(),
    required String fechaCalculo,
    required String metodo,
    required String depositoNombre,
    required double depositoLatitud,
    required double depositoLongitud,
    this.vehiculosFaltantes = const Value.absent(),
    this.distanciaTotalMetros = const Value.absent(),
    this.cantidadRutas = const Value.absent(),
  }) : fechaCalculo = Value(fechaCalculo),
       metodo = Value(metodo),
       depositoNombre = Value(depositoNombre),
       depositoLatitud = Value(depositoLatitud),
       depositoLongitud = Value(depositoLongitud);
  static Insertable<HistorialCalculoTableData> custom({
    Expression<int>? id,
    Expression<String>? fechaCalculo,
    Expression<String>? metodo,
    Expression<String>? depositoNombre,
    Expression<double>? depositoLatitud,
    Expression<double>? depositoLongitud,
    Expression<int>? vehiculosFaltantes,
    Expression<double>? distanciaTotalMetros,
    Expression<int>? cantidadRutas,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fechaCalculo != null) 'fecha_calculo': fechaCalculo,
      if (metodo != null) 'metodo': metodo,
      if (depositoNombre != null) 'deposito_nombre': depositoNombre,
      if (depositoLatitud != null) 'deposito_latitud': depositoLatitud,
      if (depositoLongitud != null) 'deposito_longitud': depositoLongitud,
      if (vehiculosFaltantes != null) 'vehiculos_faltantes': vehiculosFaltantes,
      if (distanciaTotalMetros != null)
        'distancia_total_metros': distanciaTotalMetros,
      if (cantidadRutas != null) 'cantidad_rutas': cantidadRutas,
    });
  }

  HistorialCalculoTableCompanion copyWith({
    Value<int>? id,
    Value<String>? fechaCalculo,
    Value<String>? metodo,
    Value<String>? depositoNombre,
    Value<double>? depositoLatitud,
    Value<double>? depositoLongitud,
    Value<int>? vehiculosFaltantes,
    Value<double>? distanciaTotalMetros,
    Value<int>? cantidadRutas,
  }) {
    return HistorialCalculoTableCompanion(
      id: id ?? this.id,
      fechaCalculo: fechaCalculo ?? this.fechaCalculo,
      metodo: metodo ?? this.metodo,
      depositoNombre: depositoNombre ?? this.depositoNombre,
      depositoLatitud: depositoLatitud ?? this.depositoLatitud,
      depositoLongitud: depositoLongitud ?? this.depositoLongitud,
      vehiculosFaltantes: vehiculosFaltantes ?? this.vehiculosFaltantes,
      distanciaTotalMetros: distanciaTotalMetros ?? this.distanciaTotalMetros,
      cantidadRutas: cantidadRutas ?? this.cantidadRutas,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fechaCalculo.present) {
      map['fecha_calculo'] = Variable<String>(fechaCalculo.value);
    }
    if (metodo.present) {
      map['metodo'] = Variable<String>(metodo.value);
    }
    if (depositoNombre.present) {
      map['deposito_nombre'] = Variable<String>(depositoNombre.value);
    }
    if (depositoLatitud.present) {
      map['deposito_latitud'] = Variable<double>(depositoLatitud.value);
    }
    if (depositoLongitud.present) {
      map['deposito_longitud'] = Variable<double>(depositoLongitud.value);
    }
    if (vehiculosFaltantes.present) {
      map['vehiculos_faltantes'] = Variable<int>(vehiculosFaltantes.value);
    }
    if (distanciaTotalMetros.present) {
      map['distancia_total_metros'] = Variable<double>(
        distanciaTotalMetros.value,
      );
    }
    if (cantidadRutas.present) {
      map['cantidad_rutas'] = Variable<int>(cantidadRutas.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HistorialCalculoTableCompanion(')
          ..write('id: $id, ')
          ..write('fechaCalculo: $fechaCalculo, ')
          ..write('metodo: $metodo, ')
          ..write('depositoNombre: $depositoNombre, ')
          ..write('depositoLatitud: $depositoLatitud, ')
          ..write('depositoLongitud: $depositoLongitud, ')
          ..write('vehiculosFaltantes: $vehiculosFaltantes, ')
          ..write('distanciaTotalMetros: $distanciaTotalMetros, ')
          ..write('cantidadRutas: $cantidadRutas')
          ..write(')'))
        .toString();
  }
}

class $HistorialRutaTableTable extends HistorialRutaTable
    with TableInfo<$HistorialRutaTableTable, HistorialRutaTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HistorialRutaTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _historialIdMeta = const VerificationMeta(
    'historialId',
  );
  @override
  late final GeneratedColumn<int> historialId = GeneratedColumn<int>(
    'historial_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES historial_calculo (id)',
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
  static const VerificationMeta _vehiculoNombreMeta = const VerificationMeta(
    'vehiculoNombre',
  );
  @override
  late final GeneratedColumn<String> vehiculoNombre = GeneratedColumn<String>(
    'vehiculo_nombre',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _vehiculoCapacidadMaximaMeta =
      const VerificationMeta('vehiculoCapacidadMaxima');
  @override
  late final GeneratedColumn<double> vehiculoCapacidadMaxima =
      GeneratedColumn<double>(
        'vehiculo_capacidad_maxima',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _vehiculoCostoEstimadoPorKmMeta =
      const VerificationMeta('vehiculoCostoEstimadoPorKm');
  @override
  late final GeneratedColumn<double> vehiculoCostoEstimadoPorKm =
      GeneratedColumn<double>(
        'vehiculo_costo_estimado_por_km',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _vehiculoTipoFlotaMeta = const VerificationMeta(
    'vehiculoTipoFlota',
  );
  @override
  late final GeneratedColumn<String> vehiculoTipoFlota =
      GeneratedColumn<String>(
        'vehiculo_tipo_flota',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _paradasJsonMeta = const VerificationMeta(
    'paradasJson',
  );
  @override
  late final GeneratedColumn<String> paradasJson = GeneratedColumn<String>(
    'paradas_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _distanciaMetrosMeta = const VerificationMeta(
    'distanciaMetros',
  );
  @override
  late final GeneratedColumn<double> distanciaMetros = GeneratedColumn<double>(
    'distancia_metros',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _duracionSegundosMeta = const VerificationMeta(
    'duracionSegundos',
  );
  @override
  late final GeneratedColumn<double> duracionSegundos = GeneratedColumn<double>(
    'duracion_segundos',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _distanciasPorTramoMetrosMeta =
      const VerificationMeta('distanciasPorTramoMetros');
  @override
  late final GeneratedColumn<String> distanciasPorTramoMetros =
      GeneratedColumn<String>(
        'distancias_por_tramo_metros',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _geometriaPolylineMeta = const VerificationMeta(
    'geometriaPolyline',
  );
  @override
  late final GeneratedColumn<String> geometriaPolyline =
      GeneratedColumn<String>(
        'geometria_polyline',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    historialId,
    orden,
    vehiculoNombre,
    vehiculoCapacidadMaxima,
    vehiculoCostoEstimadoPorKm,
    vehiculoTipoFlota,
    paradasJson,
    distanciaMetros,
    duracionSegundos,
    distanciasPorTramoMetros,
    geometriaPolyline,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'historial_ruta';
  @override
  VerificationContext validateIntegrity(
    Insertable<HistorialRutaTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('historial_id')) {
      context.handle(
        _historialIdMeta,
        historialId.isAcceptableOrUnknown(
          data['historial_id']!,
          _historialIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_historialIdMeta);
    }
    if (data.containsKey('orden')) {
      context.handle(
        _ordenMeta,
        orden.isAcceptableOrUnknown(data['orden']!, _ordenMeta),
      );
    } else if (isInserting) {
      context.missing(_ordenMeta);
    }
    if (data.containsKey('vehiculo_nombre')) {
      context.handle(
        _vehiculoNombreMeta,
        vehiculoNombre.isAcceptableOrUnknown(
          data['vehiculo_nombre']!,
          _vehiculoNombreMeta,
        ),
      );
    }
    if (data.containsKey('vehiculo_capacidad_maxima')) {
      context.handle(
        _vehiculoCapacidadMaximaMeta,
        vehiculoCapacidadMaxima.isAcceptableOrUnknown(
          data['vehiculo_capacidad_maxima']!,
          _vehiculoCapacidadMaximaMeta,
        ),
      );
    }
    if (data.containsKey('vehiculo_costo_estimado_por_km')) {
      context.handle(
        _vehiculoCostoEstimadoPorKmMeta,
        vehiculoCostoEstimadoPorKm.isAcceptableOrUnknown(
          data['vehiculo_costo_estimado_por_km']!,
          _vehiculoCostoEstimadoPorKmMeta,
        ),
      );
    }
    if (data.containsKey('vehiculo_tipo_flota')) {
      context.handle(
        _vehiculoTipoFlotaMeta,
        vehiculoTipoFlota.isAcceptableOrUnknown(
          data['vehiculo_tipo_flota']!,
          _vehiculoTipoFlotaMeta,
        ),
      );
    }
    if (data.containsKey('paradas_json')) {
      context.handle(
        _paradasJsonMeta,
        paradasJson.isAcceptableOrUnknown(
          data['paradas_json']!,
          _paradasJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paradasJsonMeta);
    }
    if (data.containsKey('distancia_metros')) {
      context.handle(
        _distanciaMetrosMeta,
        distanciaMetros.isAcceptableOrUnknown(
          data['distancia_metros']!,
          _distanciaMetrosMeta,
        ),
      );
    }
    if (data.containsKey('duracion_segundos')) {
      context.handle(
        _duracionSegundosMeta,
        duracionSegundos.isAcceptableOrUnknown(
          data['duracion_segundos']!,
          _duracionSegundosMeta,
        ),
      );
    }
    if (data.containsKey('distancias_por_tramo_metros')) {
      context.handle(
        _distanciasPorTramoMetrosMeta,
        distanciasPorTramoMetros.isAcceptableOrUnknown(
          data['distancias_por_tramo_metros']!,
          _distanciasPorTramoMetrosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_distanciasPorTramoMetrosMeta);
    }
    if (data.containsKey('geometria_polyline')) {
      context.handle(
        _geometriaPolylineMeta,
        geometriaPolyline.isAcceptableOrUnknown(
          data['geometria_polyline']!,
          _geometriaPolylineMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HistorialRutaTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HistorialRutaTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      historialId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}historial_id'],
      )!,
      orden: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}orden'],
      )!,
      vehiculoNombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehiculo_nombre'],
      ),
      vehiculoCapacidadMaxima: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}vehiculo_capacidad_maxima'],
      ),
      vehiculoCostoEstimadoPorKm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}vehiculo_costo_estimado_por_km'],
      ),
      vehiculoTipoFlota: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehiculo_tipo_flota'],
      ),
      paradasJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}paradas_json'],
      )!,
      distanciaMetros: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distancia_metros'],
      ),
      duracionSegundos: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}duracion_segundos'],
      ),
      distanciasPorTramoMetros: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}distancias_por_tramo_metros'],
      )!,
      geometriaPolyline: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}geometria_polyline'],
      ),
    );
  }

  @override
  $HistorialRutaTableTable createAlias(String alias) {
    return $HistorialRutaTableTable(attachedDatabase, alias);
  }
}

class HistorialRutaTableData extends DataClass
    implements Insertable<HistorialRutaTableData> {
  final int id;
  final int historialId;
  final int orden;
  final String? vehiculoNombre;
  final double? vehiculoCapacidadMaxima;
  final double? vehiculoCostoEstimadoPorKm;
  final String? vehiculoTipoFlota;
  final String paradasJson;
  final double? distanciaMetros;
  final double? duracionSegundos;
  final String distanciasPorTramoMetros;
  final String? geometriaPolyline;
  const HistorialRutaTableData({
    required this.id,
    required this.historialId,
    required this.orden,
    this.vehiculoNombre,
    this.vehiculoCapacidadMaxima,
    this.vehiculoCostoEstimadoPorKm,
    this.vehiculoTipoFlota,
    required this.paradasJson,
    this.distanciaMetros,
    this.duracionSegundos,
    required this.distanciasPorTramoMetros,
    this.geometriaPolyline,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['historial_id'] = Variable<int>(historialId);
    map['orden'] = Variable<int>(orden);
    if (!nullToAbsent || vehiculoNombre != null) {
      map['vehiculo_nombre'] = Variable<String>(vehiculoNombre);
    }
    if (!nullToAbsent || vehiculoCapacidadMaxima != null) {
      map['vehiculo_capacidad_maxima'] = Variable<double>(
        vehiculoCapacidadMaxima,
      );
    }
    if (!nullToAbsent || vehiculoCostoEstimadoPorKm != null) {
      map['vehiculo_costo_estimado_por_km'] = Variable<double>(
        vehiculoCostoEstimadoPorKm,
      );
    }
    if (!nullToAbsent || vehiculoTipoFlota != null) {
      map['vehiculo_tipo_flota'] = Variable<String>(vehiculoTipoFlota);
    }
    map['paradas_json'] = Variable<String>(paradasJson);
    if (!nullToAbsent || distanciaMetros != null) {
      map['distancia_metros'] = Variable<double>(distanciaMetros);
    }
    if (!nullToAbsent || duracionSegundos != null) {
      map['duracion_segundos'] = Variable<double>(duracionSegundos);
    }
    map['distancias_por_tramo_metros'] = Variable<String>(
      distanciasPorTramoMetros,
    );
    if (!nullToAbsent || geometriaPolyline != null) {
      map['geometria_polyline'] = Variable<String>(geometriaPolyline);
    }
    return map;
  }

  HistorialRutaTableCompanion toCompanion(bool nullToAbsent) {
    return HistorialRutaTableCompanion(
      id: Value(id),
      historialId: Value(historialId),
      orden: Value(orden),
      vehiculoNombre: vehiculoNombre == null && nullToAbsent
          ? const Value.absent()
          : Value(vehiculoNombre),
      vehiculoCapacidadMaxima: vehiculoCapacidadMaxima == null && nullToAbsent
          ? const Value.absent()
          : Value(vehiculoCapacidadMaxima),
      vehiculoCostoEstimadoPorKm:
          vehiculoCostoEstimadoPorKm == null && nullToAbsent
          ? const Value.absent()
          : Value(vehiculoCostoEstimadoPorKm),
      vehiculoTipoFlota: vehiculoTipoFlota == null && nullToAbsent
          ? const Value.absent()
          : Value(vehiculoTipoFlota),
      paradasJson: Value(paradasJson),
      distanciaMetros: distanciaMetros == null && nullToAbsent
          ? const Value.absent()
          : Value(distanciaMetros),
      duracionSegundos: duracionSegundos == null && nullToAbsent
          ? const Value.absent()
          : Value(duracionSegundos),
      distanciasPorTramoMetros: Value(distanciasPorTramoMetros),
      geometriaPolyline: geometriaPolyline == null && nullToAbsent
          ? const Value.absent()
          : Value(geometriaPolyline),
    );
  }

  factory HistorialRutaTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HistorialRutaTableData(
      id: serializer.fromJson<int>(json['id']),
      historialId: serializer.fromJson<int>(json['historialId']),
      orden: serializer.fromJson<int>(json['orden']),
      vehiculoNombre: serializer.fromJson<String?>(json['vehiculoNombre']),
      vehiculoCapacidadMaxima: serializer.fromJson<double?>(
        json['vehiculoCapacidadMaxima'],
      ),
      vehiculoCostoEstimadoPorKm: serializer.fromJson<double?>(
        json['vehiculoCostoEstimadoPorKm'],
      ),
      vehiculoTipoFlota: serializer.fromJson<String?>(
        json['vehiculoTipoFlota'],
      ),
      paradasJson: serializer.fromJson<String>(json['paradasJson']),
      distanciaMetros: serializer.fromJson<double?>(json['distanciaMetros']),
      duracionSegundos: serializer.fromJson<double?>(json['duracionSegundos']),
      distanciasPorTramoMetros: serializer.fromJson<String>(
        json['distanciasPorTramoMetros'],
      ),
      geometriaPolyline: serializer.fromJson<String?>(
        json['geometriaPolyline'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'historialId': serializer.toJson<int>(historialId),
      'orden': serializer.toJson<int>(orden),
      'vehiculoNombre': serializer.toJson<String?>(vehiculoNombre),
      'vehiculoCapacidadMaxima': serializer.toJson<double?>(
        vehiculoCapacidadMaxima,
      ),
      'vehiculoCostoEstimadoPorKm': serializer.toJson<double?>(
        vehiculoCostoEstimadoPorKm,
      ),
      'vehiculoTipoFlota': serializer.toJson<String?>(vehiculoTipoFlota),
      'paradasJson': serializer.toJson<String>(paradasJson),
      'distanciaMetros': serializer.toJson<double?>(distanciaMetros),
      'duracionSegundos': serializer.toJson<double?>(duracionSegundos),
      'distanciasPorTramoMetros': serializer.toJson<String>(
        distanciasPorTramoMetros,
      ),
      'geometriaPolyline': serializer.toJson<String?>(geometriaPolyline),
    };
  }

  HistorialRutaTableData copyWith({
    int? id,
    int? historialId,
    int? orden,
    Value<String?> vehiculoNombre = const Value.absent(),
    Value<double?> vehiculoCapacidadMaxima = const Value.absent(),
    Value<double?> vehiculoCostoEstimadoPorKm = const Value.absent(),
    Value<String?> vehiculoTipoFlota = const Value.absent(),
    String? paradasJson,
    Value<double?> distanciaMetros = const Value.absent(),
    Value<double?> duracionSegundos = const Value.absent(),
    String? distanciasPorTramoMetros,
    Value<String?> geometriaPolyline = const Value.absent(),
  }) => HistorialRutaTableData(
    id: id ?? this.id,
    historialId: historialId ?? this.historialId,
    orden: orden ?? this.orden,
    vehiculoNombre: vehiculoNombre.present
        ? vehiculoNombre.value
        : this.vehiculoNombre,
    vehiculoCapacidadMaxima: vehiculoCapacidadMaxima.present
        ? vehiculoCapacidadMaxima.value
        : this.vehiculoCapacidadMaxima,
    vehiculoCostoEstimadoPorKm: vehiculoCostoEstimadoPorKm.present
        ? vehiculoCostoEstimadoPorKm.value
        : this.vehiculoCostoEstimadoPorKm,
    vehiculoTipoFlota: vehiculoTipoFlota.present
        ? vehiculoTipoFlota.value
        : this.vehiculoTipoFlota,
    paradasJson: paradasJson ?? this.paradasJson,
    distanciaMetros: distanciaMetros.present
        ? distanciaMetros.value
        : this.distanciaMetros,
    duracionSegundos: duracionSegundos.present
        ? duracionSegundos.value
        : this.duracionSegundos,
    distanciasPorTramoMetros:
        distanciasPorTramoMetros ?? this.distanciasPorTramoMetros,
    geometriaPolyline: geometriaPolyline.present
        ? geometriaPolyline.value
        : this.geometriaPolyline,
  );
  HistorialRutaTableData copyWithCompanion(HistorialRutaTableCompanion data) {
    return HistorialRutaTableData(
      id: data.id.present ? data.id.value : this.id,
      historialId: data.historialId.present
          ? data.historialId.value
          : this.historialId,
      orden: data.orden.present ? data.orden.value : this.orden,
      vehiculoNombre: data.vehiculoNombre.present
          ? data.vehiculoNombre.value
          : this.vehiculoNombre,
      vehiculoCapacidadMaxima: data.vehiculoCapacidadMaxima.present
          ? data.vehiculoCapacidadMaxima.value
          : this.vehiculoCapacidadMaxima,
      vehiculoCostoEstimadoPorKm: data.vehiculoCostoEstimadoPorKm.present
          ? data.vehiculoCostoEstimadoPorKm.value
          : this.vehiculoCostoEstimadoPorKm,
      vehiculoTipoFlota: data.vehiculoTipoFlota.present
          ? data.vehiculoTipoFlota.value
          : this.vehiculoTipoFlota,
      paradasJson: data.paradasJson.present
          ? data.paradasJson.value
          : this.paradasJson,
      distanciaMetros: data.distanciaMetros.present
          ? data.distanciaMetros.value
          : this.distanciaMetros,
      duracionSegundos: data.duracionSegundos.present
          ? data.duracionSegundos.value
          : this.duracionSegundos,
      distanciasPorTramoMetros: data.distanciasPorTramoMetros.present
          ? data.distanciasPorTramoMetros.value
          : this.distanciasPorTramoMetros,
      geometriaPolyline: data.geometriaPolyline.present
          ? data.geometriaPolyline.value
          : this.geometriaPolyline,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HistorialRutaTableData(')
          ..write('id: $id, ')
          ..write('historialId: $historialId, ')
          ..write('orden: $orden, ')
          ..write('vehiculoNombre: $vehiculoNombre, ')
          ..write('vehiculoCapacidadMaxima: $vehiculoCapacidadMaxima, ')
          ..write('vehiculoCostoEstimadoPorKm: $vehiculoCostoEstimadoPorKm, ')
          ..write('vehiculoTipoFlota: $vehiculoTipoFlota, ')
          ..write('paradasJson: $paradasJson, ')
          ..write('distanciaMetros: $distanciaMetros, ')
          ..write('duracionSegundos: $duracionSegundos, ')
          ..write('distanciasPorTramoMetros: $distanciasPorTramoMetros, ')
          ..write('geometriaPolyline: $geometriaPolyline')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    historialId,
    orden,
    vehiculoNombre,
    vehiculoCapacidadMaxima,
    vehiculoCostoEstimadoPorKm,
    vehiculoTipoFlota,
    paradasJson,
    distanciaMetros,
    duracionSegundos,
    distanciasPorTramoMetros,
    geometriaPolyline,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HistorialRutaTableData &&
          other.id == this.id &&
          other.historialId == this.historialId &&
          other.orden == this.orden &&
          other.vehiculoNombre == this.vehiculoNombre &&
          other.vehiculoCapacidadMaxima == this.vehiculoCapacidadMaxima &&
          other.vehiculoCostoEstimadoPorKm == this.vehiculoCostoEstimadoPorKm &&
          other.vehiculoTipoFlota == this.vehiculoTipoFlota &&
          other.paradasJson == this.paradasJson &&
          other.distanciaMetros == this.distanciaMetros &&
          other.duracionSegundos == this.duracionSegundos &&
          other.distanciasPorTramoMetros == this.distanciasPorTramoMetros &&
          other.geometriaPolyline == this.geometriaPolyline);
}

class HistorialRutaTableCompanion
    extends UpdateCompanion<HistorialRutaTableData> {
  final Value<int> id;
  final Value<int> historialId;
  final Value<int> orden;
  final Value<String?> vehiculoNombre;
  final Value<double?> vehiculoCapacidadMaxima;
  final Value<double?> vehiculoCostoEstimadoPorKm;
  final Value<String?> vehiculoTipoFlota;
  final Value<String> paradasJson;
  final Value<double?> distanciaMetros;
  final Value<double?> duracionSegundos;
  final Value<String> distanciasPorTramoMetros;
  final Value<String?> geometriaPolyline;
  const HistorialRutaTableCompanion({
    this.id = const Value.absent(),
    this.historialId = const Value.absent(),
    this.orden = const Value.absent(),
    this.vehiculoNombre = const Value.absent(),
    this.vehiculoCapacidadMaxima = const Value.absent(),
    this.vehiculoCostoEstimadoPorKm = const Value.absent(),
    this.vehiculoTipoFlota = const Value.absent(),
    this.paradasJson = const Value.absent(),
    this.distanciaMetros = const Value.absent(),
    this.duracionSegundos = const Value.absent(),
    this.distanciasPorTramoMetros = const Value.absent(),
    this.geometriaPolyline = const Value.absent(),
  });
  HistorialRutaTableCompanion.insert({
    this.id = const Value.absent(),
    required int historialId,
    required int orden,
    this.vehiculoNombre = const Value.absent(),
    this.vehiculoCapacidadMaxima = const Value.absent(),
    this.vehiculoCostoEstimadoPorKm = const Value.absent(),
    this.vehiculoTipoFlota = const Value.absent(),
    required String paradasJson,
    this.distanciaMetros = const Value.absent(),
    this.duracionSegundos = const Value.absent(),
    required String distanciasPorTramoMetros,
    this.geometriaPolyline = const Value.absent(),
  }) : historialId = Value(historialId),
       orden = Value(orden),
       paradasJson = Value(paradasJson),
       distanciasPorTramoMetros = Value(distanciasPorTramoMetros);
  static Insertable<HistorialRutaTableData> custom({
    Expression<int>? id,
    Expression<int>? historialId,
    Expression<int>? orden,
    Expression<String>? vehiculoNombre,
    Expression<double>? vehiculoCapacidadMaxima,
    Expression<double>? vehiculoCostoEstimadoPorKm,
    Expression<String>? vehiculoTipoFlota,
    Expression<String>? paradasJson,
    Expression<double>? distanciaMetros,
    Expression<double>? duracionSegundos,
    Expression<String>? distanciasPorTramoMetros,
    Expression<String>? geometriaPolyline,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (historialId != null) 'historial_id': historialId,
      if (orden != null) 'orden': orden,
      if (vehiculoNombre != null) 'vehiculo_nombre': vehiculoNombre,
      if (vehiculoCapacidadMaxima != null)
        'vehiculo_capacidad_maxima': vehiculoCapacidadMaxima,
      if (vehiculoCostoEstimadoPorKm != null)
        'vehiculo_costo_estimado_por_km': vehiculoCostoEstimadoPorKm,
      if (vehiculoTipoFlota != null) 'vehiculo_tipo_flota': vehiculoTipoFlota,
      if (paradasJson != null) 'paradas_json': paradasJson,
      if (distanciaMetros != null) 'distancia_metros': distanciaMetros,
      if (duracionSegundos != null) 'duracion_segundos': duracionSegundos,
      if (distanciasPorTramoMetros != null)
        'distancias_por_tramo_metros': distanciasPorTramoMetros,
      if (geometriaPolyline != null) 'geometria_polyline': geometriaPolyline,
    });
  }

  HistorialRutaTableCompanion copyWith({
    Value<int>? id,
    Value<int>? historialId,
    Value<int>? orden,
    Value<String?>? vehiculoNombre,
    Value<double?>? vehiculoCapacidadMaxima,
    Value<double?>? vehiculoCostoEstimadoPorKm,
    Value<String?>? vehiculoTipoFlota,
    Value<String>? paradasJson,
    Value<double?>? distanciaMetros,
    Value<double?>? duracionSegundos,
    Value<String>? distanciasPorTramoMetros,
    Value<String?>? geometriaPolyline,
  }) {
    return HistorialRutaTableCompanion(
      id: id ?? this.id,
      historialId: historialId ?? this.historialId,
      orden: orden ?? this.orden,
      vehiculoNombre: vehiculoNombre ?? this.vehiculoNombre,
      vehiculoCapacidadMaxima:
          vehiculoCapacidadMaxima ?? this.vehiculoCapacidadMaxima,
      vehiculoCostoEstimadoPorKm:
          vehiculoCostoEstimadoPorKm ?? this.vehiculoCostoEstimadoPorKm,
      vehiculoTipoFlota: vehiculoTipoFlota ?? this.vehiculoTipoFlota,
      paradasJson: paradasJson ?? this.paradasJson,
      distanciaMetros: distanciaMetros ?? this.distanciaMetros,
      duracionSegundos: duracionSegundos ?? this.duracionSegundos,
      distanciasPorTramoMetros:
          distanciasPorTramoMetros ?? this.distanciasPorTramoMetros,
      geometriaPolyline: geometriaPolyline ?? this.geometriaPolyline,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (historialId.present) {
      map['historial_id'] = Variable<int>(historialId.value);
    }
    if (orden.present) {
      map['orden'] = Variable<int>(orden.value);
    }
    if (vehiculoNombre.present) {
      map['vehiculo_nombre'] = Variable<String>(vehiculoNombre.value);
    }
    if (vehiculoCapacidadMaxima.present) {
      map['vehiculo_capacidad_maxima'] = Variable<double>(
        vehiculoCapacidadMaxima.value,
      );
    }
    if (vehiculoCostoEstimadoPorKm.present) {
      map['vehiculo_costo_estimado_por_km'] = Variable<double>(
        vehiculoCostoEstimadoPorKm.value,
      );
    }
    if (vehiculoTipoFlota.present) {
      map['vehiculo_tipo_flota'] = Variable<String>(vehiculoTipoFlota.value);
    }
    if (paradasJson.present) {
      map['paradas_json'] = Variable<String>(paradasJson.value);
    }
    if (distanciaMetros.present) {
      map['distancia_metros'] = Variable<double>(distanciaMetros.value);
    }
    if (duracionSegundos.present) {
      map['duracion_segundos'] = Variable<double>(duracionSegundos.value);
    }
    if (distanciasPorTramoMetros.present) {
      map['distancias_por_tramo_metros'] = Variable<String>(
        distanciasPorTramoMetros.value,
      );
    }
    if (geometriaPolyline.present) {
      map['geometria_polyline'] = Variable<String>(geometriaPolyline.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HistorialRutaTableCompanion(')
          ..write('id: $id, ')
          ..write('historialId: $historialId, ')
          ..write('orden: $orden, ')
          ..write('vehiculoNombre: $vehiculoNombre, ')
          ..write('vehiculoCapacidadMaxima: $vehiculoCapacidadMaxima, ')
          ..write('vehiculoCostoEstimadoPorKm: $vehiculoCostoEstimadoPorKm, ')
          ..write('vehiculoTipoFlota: $vehiculoTipoFlota, ')
          ..write('paradasJson: $paradasJson, ')
          ..write('distanciaMetros: $distanciaMetros, ')
          ..write('duracionSegundos: $duracionSegundos, ')
          ..write('distanciasPorTramoMetros: $distanciasPorTramoMetros, ')
          ..write('geometriaPolyline: $geometriaPolyline')
          ..write(')'))
        .toString();
  }
}

class $CacheOsrmTableTable extends CacheOsrmTable
    with TableInfo<$CacheOsrmTableTable, CacheOsrmTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CacheOsrmTableTable(this.attachedDatabase, [this._alias]);
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
  static const String $name = 'cache_osrm';
  @override
  VerificationContext validateIntegrity(
    Insertable<CacheOsrmTableData> instance, {
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
  CacheOsrmTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CacheOsrmTableData(
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
  $CacheOsrmTableTable createAlias(String alias) {
    return $CacheOsrmTableTable(attachedDatabase, alias);
  }
}

class CacheOsrmTableData extends DataClass
    implements Insertable<CacheOsrmTableData> {
  final String hashConsulta;
  final String tipo;
  final String respuestaJson;
  final String fechaConsulta;
  const CacheOsrmTableData({
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

  CacheOsrmTableCompanion toCompanion(bool nullToAbsent) {
    return CacheOsrmTableCompanion(
      hashConsulta: Value(hashConsulta),
      tipo: Value(tipo),
      respuestaJson: Value(respuestaJson),
      fechaConsulta: Value(fechaConsulta),
    );
  }

  factory CacheOsrmTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CacheOsrmTableData(
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

  CacheOsrmTableData copyWith({
    String? hashConsulta,
    String? tipo,
    String? respuestaJson,
    String? fechaConsulta,
  }) => CacheOsrmTableData(
    hashConsulta: hashConsulta ?? this.hashConsulta,
    tipo: tipo ?? this.tipo,
    respuestaJson: respuestaJson ?? this.respuestaJson,
    fechaConsulta: fechaConsulta ?? this.fechaConsulta,
  );
  CacheOsrmTableData copyWithCompanion(CacheOsrmTableCompanion data) {
    return CacheOsrmTableData(
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
    return (StringBuffer('CacheOsrmTableData(')
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
      (other is CacheOsrmTableData &&
          other.hashConsulta == this.hashConsulta &&
          other.tipo == this.tipo &&
          other.respuestaJson == this.respuestaJson &&
          other.fechaConsulta == this.fechaConsulta);
}

class CacheOsrmTableCompanion extends UpdateCompanion<CacheOsrmTableData> {
  final Value<String> hashConsulta;
  final Value<String> tipo;
  final Value<String> respuestaJson;
  final Value<String> fechaConsulta;
  final Value<int> rowid;
  const CacheOsrmTableCompanion({
    this.hashConsulta = const Value.absent(),
    this.tipo = const Value.absent(),
    this.respuestaJson = const Value.absent(),
    this.fechaConsulta = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CacheOsrmTableCompanion.insert({
    required String hashConsulta,
    required String tipo,
    required String respuestaJson,
    required String fechaConsulta,
    this.rowid = const Value.absent(),
  }) : hashConsulta = Value(hashConsulta),
       tipo = Value(tipo),
       respuestaJson = Value(respuestaJson),
       fechaConsulta = Value(fechaConsulta);
  static Insertable<CacheOsrmTableData> custom({
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

  CacheOsrmTableCompanion copyWith({
    Value<String>? hashConsulta,
    Value<String>? tipo,
    Value<String>? respuestaJson,
    Value<String>? fechaConsulta,
    Value<int>? rowid,
  }) {
    return CacheOsrmTableCompanion(
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
    return (StringBuffer('CacheOsrmTableCompanion(')
          ..write('hashConsulta: $hashConsulta, ')
          ..write('tipo: $tipo, ')
          ..write('respuestaJson: $respuestaJson, ')
          ..write('fechaConsulta: $fechaConsulta, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DepositoTableTable depositoTable = $DepositoTableTable(this);
  late final $PuntoEntregaTableTable puntoEntregaTable =
      $PuntoEntregaTableTable(this);
  late final $VehiculoTableTable vehiculoTable = $VehiculoTableTable(this);
  late final $HistorialCalculoTableTable historialCalculoTable =
      $HistorialCalculoTableTable(this);
  late final $HistorialRutaTableTable historialRutaTable =
      $HistorialRutaTableTable(this);
  late final $CacheOsrmTableTable cacheOsrmTable = $CacheOsrmTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    depositoTable,
    puntoEntregaTable,
    vehiculoTable,
    historialCalculoTable,
    historialRutaTable,
    cacheOsrmTable,
  ];
}

typedef $$DepositoTableTableCreateCompanionBuilder =
    DepositoTableCompanion Function({
      Value<int> id,
      required String nombre,
      required double latitud,
      required double longitud,
    });
typedef $$DepositoTableTableUpdateCompanionBuilder =
    DepositoTableCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<double> latitud,
      Value<double> longitud,
    });

class $$DepositoTableTableFilterComposer
    extends Composer<_$AppDatabase, $DepositoTableTable> {
  $$DepositoTableTableFilterComposer({
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
}

class $$DepositoTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DepositoTableTable> {
  $$DepositoTableTableOrderingComposer({
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
}

class $$DepositoTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DepositoTableTable> {
  $$DepositoTableTableAnnotationComposer({
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
}

class $$DepositoTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DepositoTableTable,
          DepositoTableData,
          $$DepositoTableTableFilterComposer,
          $$DepositoTableTableOrderingComposer,
          $$DepositoTableTableAnnotationComposer,
          $$DepositoTableTableCreateCompanionBuilder,
          $$DepositoTableTableUpdateCompanionBuilder,
          (
            DepositoTableData,
            BaseReferences<
              _$AppDatabase,
              $DepositoTableTable,
              DepositoTableData
            >,
          ),
          DepositoTableData,
          PrefetchHooks Function()
        > {
  $$DepositoTableTableTableManager(_$AppDatabase db, $DepositoTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DepositoTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DepositoTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DepositoTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<double> latitud = const Value.absent(),
                Value<double> longitud = const Value.absent(),
              }) => DepositoTableCompanion(
                id: id,
                nombre: nombre,
                latitud: latitud,
                longitud: longitud,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                required double latitud,
                required double longitud,
              }) => DepositoTableCompanion.insert(
                id: id,
                nombre: nombre,
                latitud: latitud,
                longitud: longitud,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DepositoTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DepositoTableTable,
      DepositoTableData,
      $$DepositoTableTableFilterComposer,
      $$DepositoTableTableOrderingComposer,
      $$DepositoTableTableAnnotationComposer,
      $$DepositoTableTableCreateCompanionBuilder,
      $$DepositoTableTableUpdateCompanionBuilder,
      (
        DepositoTableData,
        BaseReferences<_$AppDatabase, $DepositoTableTable, DepositoTableData>,
      ),
      DepositoTableData,
      PrefetchHooks Function()
    >;
typedef $$PuntoEntregaTableTableCreateCompanionBuilder =
    PuntoEntregaTableCompanion Function({
      Value<int> id,
      required String nombre,
      required double latitud,
      required double longitud,
      Value<double> demanda,
      Value<String?> ventanaInicio,
      Value<String?> ventanaFin,
    });
typedef $$PuntoEntregaTableTableUpdateCompanionBuilder =
    PuntoEntregaTableCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<double> latitud,
      Value<double> longitud,
      Value<double> demanda,
      Value<String?> ventanaInicio,
      Value<String?> ventanaFin,
    });

class $$PuntoEntregaTableTableFilterComposer
    extends Composer<_$AppDatabase, $PuntoEntregaTableTable> {
  $$PuntoEntregaTableTableFilterComposer({
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

  ColumnFilters<double> get demanda => $composableBuilder(
    column: $table.demanda,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ventanaInicio => $composableBuilder(
    column: $table.ventanaInicio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ventanaFin => $composableBuilder(
    column: $table.ventanaFin,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PuntoEntregaTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PuntoEntregaTableTable> {
  $$PuntoEntregaTableTableOrderingComposer({
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

  ColumnOrderings<double> get demanda => $composableBuilder(
    column: $table.demanda,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ventanaInicio => $composableBuilder(
    column: $table.ventanaInicio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ventanaFin => $composableBuilder(
    column: $table.ventanaFin,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PuntoEntregaTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PuntoEntregaTableTable> {
  $$PuntoEntregaTableTableAnnotationComposer({
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

  GeneratedColumn<double> get demanda =>
      $composableBuilder(column: $table.demanda, builder: (column) => column);

  GeneratedColumn<String> get ventanaInicio => $composableBuilder(
    column: $table.ventanaInicio,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ventanaFin => $composableBuilder(
    column: $table.ventanaFin,
    builder: (column) => column,
  );
}

class $$PuntoEntregaTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PuntoEntregaTableTable,
          PuntoEntregaTableData,
          $$PuntoEntregaTableTableFilterComposer,
          $$PuntoEntregaTableTableOrderingComposer,
          $$PuntoEntregaTableTableAnnotationComposer,
          $$PuntoEntregaTableTableCreateCompanionBuilder,
          $$PuntoEntregaTableTableUpdateCompanionBuilder,
          (
            PuntoEntregaTableData,
            BaseReferences<
              _$AppDatabase,
              $PuntoEntregaTableTable,
              PuntoEntregaTableData
            >,
          ),
          PuntoEntregaTableData,
          PrefetchHooks Function()
        > {
  $$PuntoEntregaTableTableTableManager(
    _$AppDatabase db,
    $PuntoEntregaTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PuntoEntregaTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PuntoEntregaTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PuntoEntregaTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<double> latitud = const Value.absent(),
                Value<double> longitud = const Value.absent(),
                Value<double> demanda = const Value.absent(),
                Value<String?> ventanaInicio = const Value.absent(),
                Value<String?> ventanaFin = const Value.absent(),
              }) => PuntoEntregaTableCompanion(
                id: id,
                nombre: nombre,
                latitud: latitud,
                longitud: longitud,
                demanda: demanda,
                ventanaInicio: ventanaInicio,
                ventanaFin: ventanaFin,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                required double latitud,
                required double longitud,
                Value<double> demanda = const Value.absent(),
                Value<String?> ventanaInicio = const Value.absent(),
                Value<String?> ventanaFin = const Value.absent(),
              }) => PuntoEntregaTableCompanion.insert(
                id: id,
                nombre: nombre,
                latitud: latitud,
                longitud: longitud,
                demanda: demanda,
                ventanaInicio: ventanaInicio,
                ventanaFin: ventanaFin,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PuntoEntregaTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PuntoEntregaTableTable,
      PuntoEntregaTableData,
      $$PuntoEntregaTableTableFilterComposer,
      $$PuntoEntregaTableTableOrderingComposer,
      $$PuntoEntregaTableTableAnnotationComposer,
      $$PuntoEntregaTableTableCreateCompanionBuilder,
      $$PuntoEntregaTableTableUpdateCompanionBuilder,
      (
        PuntoEntregaTableData,
        BaseReferences<
          _$AppDatabase,
          $PuntoEntregaTableTable,
          PuntoEntregaTableData
        >,
      ),
      PuntoEntregaTableData,
      PrefetchHooks Function()
    >;
typedef $$VehiculoTableTableCreateCompanionBuilder =
    VehiculoTableCompanion Function({
      Value<int> id,
      required String nombre,
      required double capacidadMaxima,
      Value<double?> costoEstimadoPorKm,
      Value<String?> tipoFlota,
    });
typedef $$VehiculoTableTableUpdateCompanionBuilder =
    VehiculoTableCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<double> capacidadMaxima,
      Value<double?> costoEstimadoPorKm,
      Value<String?> tipoFlota,
    });

class $$VehiculoTableTableFilterComposer
    extends Composer<_$AppDatabase, $VehiculoTableTable> {
  $$VehiculoTableTableFilterComposer({
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

  ColumnFilters<double> get capacidadMaxima => $composableBuilder(
    column: $table.capacidadMaxima,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get costoEstimadoPorKm => $composableBuilder(
    column: $table.costoEstimadoPorKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipoFlota => $composableBuilder(
    column: $table.tipoFlota,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VehiculoTableTableOrderingComposer
    extends Composer<_$AppDatabase, $VehiculoTableTable> {
  $$VehiculoTableTableOrderingComposer({
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

  ColumnOrderings<double> get capacidadMaxima => $composableBuilder(
    column: $table.capacidadMaxima,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get costoEstimadoPorKm => $composableBuilder(
    column: $table.costoEstimadoPorKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipoFlota => $composableBuilder(
    column: $table.tipoFlota,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VehiculoTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $VehiculoTableTable> {
  $$VehiculoTableTableAnnotationComposer({
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

  GeneratedColumn<double> get capacidadMaxima => $composableBuilder(
    column: $table.capacidadMaxima,
    builder: (column) => column,
  );

  GeneratedColumn<double> get costoEstimadoPorKm => $composableBuilder(
    column: $table.costoEstimadoPorKm,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tipoFlota =>
      $composableBuilder(column: $table.tipoFlota, builder: (column) => column);
}

class $$VehiculoTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VehiculoTableTable,
          VehiculoTableData,
          $$VehiculoTableTableFilterComposer,
          $$VehiculoTableTableOrderingComposer,
          $$VehiculoTableTableAnnotationComposer,
          $$VehiculoTableTableCreateCompanionBuilder,
          $$VehiculoTableTableUpdateCompanionBuilder,
          (
            VehiculoTableData,
            BaseReferences<
              _$AppDatabase,
              $VehiculoTableTable,
              VehiculoTableData
            >,
          ),
          VehiculoTableData,
          PrefetchHooks Function()
        > {
  $$VehiculoTableTableTableManager(_$AppDatabase db, $VehiculoTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VehiculoTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VehiculoTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VehiculoTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<double> capacidadMaxima = const Value.absent(),
                Value<double?> costoEstimadoPorKm = const Value.absent(),
                Value<String?> tipoFlota = const Value.absent(),
              }) => VehiculoTableCompanion(
                id: id,
                nombre: nombre,
                capacidadMaxima: capacidadMaxima,
                costoEstimadoPorKm: costoEstimadoPorKm,
                tipoFlota: tipoFlota,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                required double capacidadMaxima,
                Value<double?> costoEstimadoPorKm = const Value.absent(),
                Value<String?> tipoFlota = const Value.absent(),
              }) => VehiculoTableCompanion.insert(
                id: id,
                nombre: nombre,
                capacidadMaxima: capacidadMaxima,
                costoEstimadoPorKm: costoEstimadoPorKm,
                tipoFlota: tipoFlota,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VehiculoTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VehiculoTableTable,
      VehiculoTableData,
      $$VehiculoTableTableFilterComposer,
      $$VehiculoTableTableOrderingComposer,
      $$VehiculoTableTableAnnotationComposer,
      $$VehiculoTableTableCreateCompanionBuilder,
      $$VehiculoTableTableUpdateCompanionBuilder,
      (
        VehiculoTableData,
        BaseReferences<_$AppDatabase, $VehiculoTableTable, VehiculoTableData>,
      ),
      VehiculoTableData,
      PrefetchHooks Function()
    >;
typedef $$HistorialCalculoTableTableCreateCompanionBuilder =
    HistorialCalculoTableCompanion Function({
      Value<int> id,
      required String fechaCalculo,
      required String metodo,
      required String depositoNombre,
      required double depositoLatitud,
      required double depositoLongitud,
      Value<int> vehiculosFaltantes,
      Value<double> distanciaTotalMetros,
      Value<int> cantidadRutas,
    });
typedef $$HistorialCalculoTableTableUpdateCompanionBuilder =
    HistorialCalculoTableCompanion Function({
      Value<int> id,
      Value<String> fechaCalculo,
      Value<String> metodo,
      Value<String> depositoNombre,
      Value<double> depositoLatitud,
      Value<double> depositoLongitud,
      Value<int> vehiculosFaltantes,
      Value<double> distanciaTotalMetros,
      Value<int> cantidadRutas,
    });

final class $$HistorialCalculoTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $HistorialCalculoTableTable,
          HistorialCalculoTableData
        > {
  $$HistorialCalculoTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $HistorialRutaTableTable,
    List<HistorialRutaTableData>
  >
  _historialRutaTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.historialRutaTable,
        aliasName: 'historial_calculo__id__historial_ruta__historial_id',
      );

  $$HistorialRutaTableTableProcessedTableManager get historialRutaTableRefs {
    final manager = $$HistorialRutaTableTableTableManager(
      $_db,
      $_db.historialRutaTable,
    ).filter((f) => f.historialId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _historialRutaTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$HistorialCalculoTableTableFilterComposer
    extends Composer<_$AppDatabase, $HistorialCalculoTableTable> {
  $$HistorialCalculoTableTableFilterComposer({
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

  ColumnFilters<String> get fechaCalculo => $composableBuilder(
    column: $table.fechaCalculo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metodo => $composableBuilder(
    column: $table.metodo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get depositoNombre => $composableBuilder(
    column: $table.depositoNombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get depositoLatitud => $composableBuilder(
    column: $table.depositoLatitud,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get depositoLongitud => $composableBuilder(
    column: $table.depositoLongitud,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get vehiculosFaltantes => $composableBuilder(
    column: $table.vehiculosFaltantes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanciaTotalMetros => $composableBuilder(
    column: $table.distanciaTotalMetros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cantidadRutas => $composableBuilder(
    column: $table.cantidadRutas,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> historialRutaTableRefs(
    Expression<bool> Function($$HistorialRutaTableTableFilterComposer f) f,
  ) {
    final $$HistorialRutaTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.historialRutaTable,
      getReferencedColumn: (t) => t.historialId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HistorialRutaTableTableFilterComposer(
            $db: $db,
            $table: $db.historialRutaTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HistorialCalculoTableTableOrderingComposer
    extends Composer<_$AppDatabase, $HistorialCalculoTableTable> {
  $$HistorialCalculoTableTableOrderingComposer({
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

  ColumnOrderings<String> get fechaCalculo => $composableBuilder(
    column: $table.fechaCalculo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metodo => $composableBuilder(
    column: $table.metodo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get depositoNombre => $composableBuilder(
    column: $table.depositoNombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get depositoLatitud => $composableBuilder(
    column: $table.depositoLatitud,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get depositoLongitud => $composableBuilder(
    column: $table.depositoLongitud,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get vehiculosFaltantes => $composableBuilder(
    column: $table.vehiculosFaltantes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanciaTotalMetros => $composableBuilder(
    column: $table.distanciaTotalMetros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cantidadRutas => $composableBuilder(
    column: $table.cantidadRutas,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HistorialCalculoTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $HistorialCalculoTableTable> {
  $$HistorialCalculoTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fechaCalculo => $composableBuilder(
    column: $table.fechaCalculo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get metodo =>
      $composableBuilder(column: $table.metodo, builder: (column) => column);

  GeneratedColumn<String> get depositoNombre => $composableBuilder(
    column: $table.depositoNombre,
    builder: (column) => column,
  );

  GeneratedColumn<double> get depositoLatitud => $composableBuilder(
    column: $table.depositoLatitud,
    builder: (column) => column,
  );

  GeneratedColumn<double> get depositoLongitud => $composableBuilder(
    column: $table.depositoLongitud,
    builder: (column) => column,
  );

  GeneratedColumn<int> get vehiculosFaltantes => $composableBuilder(
    column: $table.vehiculosFaltantes,
    builder: (column) => column,
  );

  GeneratedColumn<double> get distanciaTotalMetros => $composableBuilder(
    column: $table.distanciaTotalMetros,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cantidadRutas => $composableBuilder(
    column: $table.cantidadRutas,
    builder: (column) => column,
  );

  Expression<T> historialRutaTableRefs<T extends Object>(
    Expression<T> Function($$HistorialRutaTableTableAnnotationComposer a) f,
  ) {
    final $$HistorialRutaTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.historialRutaTable,
          getReferencedColumn: (t) => t.historialId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$HistorialRutaTableTableAnnotationComposer(
                $db: $db,
                $table: $db.historialRutaTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$HistorialCalculoTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HistorialCalculoTableTable,
          HistorialCalculoTableData,
          $$HistorialCalculoTableTableFilterComposer,
          $$HistorialCalculoTableTableOrderingComposer,
          $$HistorialCalculoTableTableAnnotationComposer,
          $$HistorialCalculoTableTableCreateCompanionBuilder,
          $$HistorialCalculoTableTableUpdateCompanionBuilder,
          (HistorialCalculoTableData, $$HistorialCalculoTableTableReferences),
          HistorialCalculoTableData,
          PrefetchHooks Function({bool historialRutaTableRefs})
        > {
  $$HistorialCalculoTableTableTableManager(
    _$AppDatabase db,
    $HistorialCalculoTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HistorialCalculoTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$HistorialCalculoTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$HistorialCalculoTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> fechaCalculo = const Value.absent(),
                Value<String> metodo = const Value.absent(),
                Value<String> depositoNombre = const Value.absent(),
                Value<double> depositoLatitud = const Value.absent(),
                Value<double> depositoLongitud = const Value.absent(),
                Value<int> vehiculosFaltantes = const Value.absent(),
                Value<double> distanciaTotalMetros = const Value.absent(),
                Value<int> cantidadRutas = const Value.absent(),
              }) => HistorialCalculoTableCompanion(
                id: id,
                fechaCalculo: fechaCalculo,
                metodo: metodo,
                depositoNombre: depositoNombre,
                depositoLatitud: depositoLatitud,
                depositoLongitud: depositoLongitud,
                vehiculosFaltantes: vehiculosFaltantes,
                distanciaTotalMetros: distanciaTotalMetros,
                cantidadRutas: cantidadRutas,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String fechaCalculo,
                required String metodo,
                required String depositoNombre,
                required double depositoLatitud,
                required double depositoLongitud,
                Value<int> vehiculosFaltantes = const Value.absent(),
                Value<double> distanciaTotalMetros = const Value.absent(),
                Value<int> cantidadRutas = const Value.absent(),
              }) => HistorialCalculoTableCompanion.insert(
                id: id,
                fechaCalculo: fechaCalculo,
                metodo: metodo,
                depositoNombre: depositoNombre,
                depositoLatitud: depositoLatitud,
                depositoLongitud: depositoLongitud,
                vehiculosFaltantes: vehiculosFaltantes,
                distanciaTotalMetros: distanciaTotalMetros,
                cantidadRutas: cantidadRutas,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HistorialCalculoTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({historialRutaTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (historialRutaTableRefs) db.historialRutaTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (historialRutaTableRefs)
                    await $_getPrefetchedData<
                      HistorialCalculoTableData,
                      $HistorialCalculoTableTable,
                      HistorialRutaTableData
                    >(
                      currentTable: table,
                      referencedTable: $$HistorialCalculoTableTableReferences
                          ._historialRutaTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$HistorialCalculoTableTableReferences(
                            db,
                            table,
                            p0,
                          ).historialRutaTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.historialId == item.id,
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

typedef $$HistorialCalculoTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HistorialCalculoTableTable,
      HistorialCalculoTableData,
      $$HistorialCalculoTableTableFilterComposer,
      $$HistorialCalculoTableTableOrderingComposer,
      $$HistorialCalculoTableTableAnnotationComposer,
      $$HistorialCalculoTableTableCreateCompanionBuilder,
      $$HistorialCalculoTableTableUpdateCompanionBuilder,
      (HistorialCalculoTableData, $$HistorialCalculoTableTableReferences),
      HistorialCalculoTableData,
      PrefetchHooks Function({bool historialRutaTableRefs})
    >;
typedef $$HistorialRutaTableTableCreateCompanionBuilder =
    HistorialRutaTableCompanion Function({
      Value<int> id,
      required int historialId,
      required int orden,
      Value<String?> vehiculoNombre,
      Value<double?> vehiculoCapacidadMaxima,
      Value<double?> vehiculoCostoEstimadoPorKm,
      Value<String?> vehiculoTipoFlota,
      required String paradasJson,
      Value<double?> distanciaMetros,
      Value<double?> duracionSegundos,
      required String distanciasPorTramoMetros,
      Value<String?> geometriaPolyline,
    });
typedef $$HistorialRutaTableTableUpdateCompanionBuilder =
    HistorialRutaTableCompanion Function({
      Value<int> id,
      Value<int> historialId,
      Value<int> orden,
      Value<String?> vehiculoNombre,
      Value<double?> vehiculoCapacidadMaxima,
      Value<double?> vehiculoCostoEstimadoPorKm,
      Value<String?> vehiculoTipoFlota,
      Value<String> paradasJson,
      Value<double?> distanciaMetros,
      Value<double?> duracionSegundos,
      Value<String> distanciasPorTramoMetros,
      Value<String?> geometriaPolyline,
    });

final class $$HistorialRutaTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $HistorialRutaTableTable,
          HistorialRutaTableData
        > {
  $$HistorialRutaTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $HistorialCalculoTableTable _historialIdTable(_$AppDatabase db) => db
      .historialCalculoTable
      .createAlias('historial_ruta__historial_id__historial_calculo__id');

  $$HistorialCalculoTableTableProcessedTableManager get historialId {
    final $_column = $_itemColumn<int>('historial_id')!;

    final manager = $$HistorialCalculoTableTableTableManager(
      $_db,
      $_db.historialCalculoTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_historialIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$HistorialRutaTableTableFilterComposer
    extends Composer<_$AppDatabase, $HistorialRutaTableTable> {
  $$HistorialRutaTableTableFilterComposer({
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

  ColumnFilters<String> get vehiculoNombre => $composableBuilder(
    column: $table.vehiculoNombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get vehiculoCapacidadMaxima => $composableBuilder(
    column: $table.vehiculoCapacidadMaxima,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get vehiculoCostoEstimadoPorKm => $composableBuilder(
    column: $table.vehiculoCostoEstimadoPorKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vehiculoTipoFlota => $composableBuilder(
    column: $table.vehiculoTipoFlota,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paradasJson => $composableBuilder(
    column: $table.paradasJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanciaMetros => $composableBuilder(
    column: $table.distanciaMetros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get duracionSegundos => $composableBuilder(
    column: $table.duracionSegundos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get distanciasPorTramoMetros => $composableBuilder(
    column: $table.distanciasPorTramoMetros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get geometriaPolyline => $composableBuilder(
    column: $table.geometriaPolyline,
    builder: (column) => ColumnFilters(column),
  );

  $$HistorialCalculoTableTableFilterComposer get historialId {
    final $$HistorialCalculoTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.historialId,
          referencedTable: $db.historialCalculoTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$HistorialCalculoTableTableFilterComposer(
                $db: $db,
                $table: $db.historialCalculoTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$HistorialRutaTableTableOrderingComposer
    extends Composer<_$AppDatabase, $HistorialRutaTableTable> {
  $$HistorialRutaTableTableOrderingComposer({
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

  ColumnOrderings<String> get vehiculoNombre => $composableBuilder(
    column: $table.vehiculoNombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get vehiculoCapacidadMaxima => $composableBuilder(
    column: $table.vehiculoCapacidadMaxima,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get vehiculoCostoEstimadoPorKm => $composableBuilder(
    column: $table.vehiculoCostoEstimadoPorKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vehiculoTipoFlota => $composableBuilder(
    column: $table.vehiculoTipoFlota,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paradasJson => $composableBuilder(
    column: $table.paradasJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanciaMetros => $composableBuilder(
    column: $table.distanciaMetros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get duracionSegundos => $composableBuilder(
    column: $table.duracionSegundos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get distanciasPorTramoMetros => $composableBuilder(
    column: $table.distanciasPorTramoMetros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get geometriaPolyline => $composableBuilder(
    column: $table.geometriaPolyline,
    builder: (column) => ColumnOrderings(column),
  );

  $$HistorialCalculoTableTableOrderingComposer get historialId {
    final $$HistorialCalculoTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.historialId,
          referencedTable: $db.historialCalculoTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$HistorialCalculoTableTableOrderingComposer(
                $db: $db,
                $table: $db.historialCalculoTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$HistorialRutaTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $HistorialRutaTableTable> {
  $$HistorialRutaTableTableAnnotationComposer({
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

  GeneratedColumn<String> get vehiculoNombre => $composableBuilder(
    column: $table.vehiculoNombre,
    builder: (column) => column,
  );

  GeneratedColumn<double> get vehiculoCapacidadMaxima => $composableBuilder(
    column: $table.vehiculoCapacidadMaxima,
    builder: (column) => column,
  );

  GeneratedColumn<double> get vehiculoCostoEstimadoPorKm => $composableBuilder(
    column: $table.vehiculoCostoEstimadoPorKm,
    builder: (column) => column,
  );

  GeneratedColumn<String> get vehiculoTipoFlota => $composableBuilder(
    column: $table.vehiculoTipoFlota,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paradasJson => $composableBuilder(
    column: $table.paradasJson,
    builder: (column) => column,
  );

  GeneratedColumn<double> get distanciaMetros => $composableBuilder(
    column: $table.distanciaMetros,
    builder: (column) => column,
  );

  GeneratedColumn<double> get duracionSegundos => $composableBuilder(
    column: $table.duracionSegundos,
    builder: (column) => column,
  );

  GeneratedColumn<String> get distanciasPorTramoMetros => $composableBuilder(
    column: $table.distanciasPorTramoMetros,
    builder: (column) => column,
  );

  GeneratedColumn<String> get geometriaPolyline => $composableBuilder(
    column: $table.geometriaPolyline,
    builder: (column) => column,
  );

  $$HistorialCalculoTableTableAnnotationComposer get historialId {
    final $$HistorialCalculoTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.historialId,
          referencedTable: $db.historialCalculoTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$HistorialCalculoTableTableAnnotationComposer(
                $db: $db,
                $table: $db.historialCalculoTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$HistorialRutaTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HistorialRutaTableTable,
          HistorialRutaTableData,
          $$HistorialRutaTableTableFilterComposer,
          $$HistorialRutaTableTableOrderingComposer,
          $$HistorialRutaTableTableAnnotationComposer,
          $$HistorialRutaTableTableCreateCompanionBuilder,
          $$HistorialRutaTableTableUpdateCompanionBuilder,
          (HistorialRutaTableData, $$HistorialRutaTableTableReferences),
          HistorialRutaTableData,
          PrefetchHooks Function({bool historialId})
        > {
  $$HistorialRutaTableTableTableManager(
    _$AppDatabase db,
    $HistorialRutaTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HistorialRutaTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HistorialRutaTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HistorialRutaTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> historialId = const Value.absent(),
                Value<int> orden = const Value.absent(),
                Value<String?> vehiculoNombre = const Value.absent(),
                Value<double?> vehiculoCapacidadMaxima = const Value.absent(),
                Value<double?> vehiculoCostoEstimadoPorKm =
                    const Value.absent(),
                Value<String?> vehiculoTipoFlota = const Value.absent(),
                Value<String> paradasJson = const Value.absent(),
                Value<double?> distanciaMetros = const Value.absent(),
                Value<double?> duracionSegundos = const Value.absent(),
                Value<String> distanciasPorTramoMetros = const Value.absent(),
                Value<String?> geometriaPolyline = const Value.absent(),
              }) => HistorialRutaTableCompanion(
                id: id,
                historialId: historialId,
                orden: orden,
                vehiculoNombre: vehiculoNombre,
                vehiculoCapacidadMaxima: vehiculoCapacidadMaxima,
                vehiculoCostoEstimadoPorKm: vehiculoCostoEstimadoPorKm,
                vehiculoTipoFlota: vehiculoTipoFlota,
                paradasJson: paradasJson,
                distanciaMetros: distanciaMetros,
                duracionSegundos: duracionSegundos,
                distanciasPorTramoMetros: distanciasPorTramoMetros,
                geometriaPolyline: geometriaPolyline,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int historialId,
                required int orden,
                Value<String?> vehiculoNombre = const Value.absent(),
                Value<double?> vehiculoCapacidadMaxima = const Value.absent(),
                Value<double?> vehiculoCostoEstimadoPorKm =
                    const Value.absent(),
                Value<String?> vehiculoTipoFlota = const Value.absent(),
                required String paradasJson,
                Value<double?> distanciaMetros = const Value.absent(),
                Value<double?> duracionSegundos = const Value.absent(),
                required String distanciasPorTramoMetros,
                Value<String?> geometriaPolyline = const Value.absent(),
              }) => HistorialRutaTableCompanion.insert(
                id: id,
                historialId: historialId,
                orden: orden,
                vehiculoNombre: vehiculoNombre,
                vehiculoCapacidadMaxima: vehiculoCapacidadMaxima,
                vehiculoCostoEstimadoPorKm: vehiculoCostoEstimadoPorKm,
                vehiculoTipoFlota: vehiculoTipoFlota,
                paradasJson: paradasJson,
                distanciaMetros: distanciaMetros,
                duracionSegundos: duracionSegundos,
                distanciasPorTramoMetros: distanciasPorTramoMetros,
                geometriaPolyline: geometriaPolyline,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HistorialRutaTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({historialId = false}) {
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
                    if (historialId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.historialId,
                                referencedTable:
                                    $$HistorialRutaTableTableReferences
                                        ._historialIdTable(db),
                                referencedColumn:
                                    $$HistorialRutaTableTableReferences
                                        ._historialIdTable(db)
                                        .id,
                              )
                              as T;
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

typedef $$HistorialRutaTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HistorialRutaTableTable,
      HistorialRutaTableData,
      $$HistorialRutaTableTableFilterComposer,
      $$HistorialRutaTableTableOrderingComposer,
      $$HistorialRutaTableTableAnnotationComposer,
      $$HistorialRutaTableTableCreateCompanionBuilder,
      $$HistorialRutaTableTableUpdateCompanionBuilder,
      (HistorialRutaTableData, $$HistorialRutaTableTableReferences),
      HistorialRutaTableData,
      PrefetchHooks Function({bool historialId})
    >;
typedef $$CacheOsrmTableTableCreateCompanionBuilder =
    CacheOsrmTableCompanion Function({
      required String hashConsulta,
      required String tipo,
      required String respuestaJson,
      required String fechaConsulta,
      Value<int> rowid,
    });
typedef $$CacheOsrmTableTableUpdateCompanionBuilder =
    CacheOsrmTableCompanion Function({
      Value<String> hashConsulta,
      Value<String> tipo,
      Value<String> respuestaJson,
      Value<String> fechaConsulta,
      Value<int> rowid,
    });

class $$CacheOsrmTableTableFilterComposer
    extends Composer<_$AppDatabase, $CacheOsrmTableTable> {
  $$CacheOsrmTableTableFilterComposer({
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

class $$CacheOsrmTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CacheOsrmTableTable> {
  $$CacheOsrmTableTableOrderingComposer({
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

class $$CacheOsrmTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CacheOsrmTableTable> {
  $$CacheOsrmTableTableAnnotationComposer({
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

class $$CacheOsrmTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CacheOsrmTableTable,
          CacheOsrmTableData,
          $$CacheOsrmTableTableFilterComposer,
          $$CacheOsrmTableTableOrderingComposer,
          $$CacheOsrmTableTableAnnotationComposer,
          $$CacheOsrmTableTableCreateCompanionBuilder,
          $$CacheOsrmTableTableUpdateCompanionBuilder,
          (
            CacheOsrmTableData,
            BaseReferences<
              _$AppDatabase,
              $CacheOsrmTableTable,
              CacheOsrmTableData
            >,
          ),
          CacheOsrmTableData,
          PrefetchHooks Function()
        > {
  $$CacheOsrmTableTableTableManager(
    _$AppDatabase db,
    $CacheOsrmTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CacheOsrmTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CacheOsrmTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CacheOsrmTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> hashConsulta = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<String> respuestaJson = const Value.absent(),
                Value<String> fechaConsulta = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CacheOsrmTableCompanion(
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
              }) => CacheOsrmTableCompanion.insert(
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

typedef $$CacheOsrmTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CacheOsrmTableTable,
      CacheOsrmTableData,
      $$CacheOsrmTableTableFilterComposer,
      $$CacheOsrmTableTableOrderingComposer,
      $$CacheOsrmTableTableAnnotationComposer,
      $$CacheOsrmTableTableCreateCompanionBuilder,
      $$CacheOsrmTableTableUpdateCompanionBuilder,
      (
        CacheOsrmTableData,
        BaseReferences<_$AppDatabase, $CacheOsrmTableTable, CacheOsrmTableData>,
      ),
      CacheOsrmTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DepositoTableTableTableManager get depositoTable =>
      $$DepositoTableTableTableManager(_db, _db.depositoTable);
  $$PuntoEntregaTableTableTableManager get puntoEntregaTable =>
      $$PuntoEntregaTableTableTableManager(_db, _db.puntoEntregaTable);
  $$VehiculoTableTableTableManager get vehiculoTable =>
      $$VehiculoTableTableTableManager(_db, _db.vehiculoTable);
  $$HistorialCalculoTableTableTableManager get historialCalculoTable =>
      $$HistorialCalculoTableTableTableManager(_db, _db.historialCalculoTable);
  $$HistorialRutaTableTableTableManager get historialRutaTable =>
      $$HistorialRutaTableTableTableManager(_db, _db.historialRutaTable);
  $$CacheOsrmTableTableTableManager get cacheOsrmTable =>
      $$CacheOsrmTableTableTableManager(_db, _db.cacheOsrmTable);
}
