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

class $EscenarioOptimizacionTableTable extends EscenarioOptimizacionTable
    with
        TableInfo<
          $EscenarioOptimizacionTableTable,
          EscenarioOptimizacionTableData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EscenarioOptimizacionTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _depositoIdMeta = const VerificationMeta(
    'depositoId',
  );
  @override
  late final GeneratedColumn<int> depositoId = GeneratedColumn<int>(
    'deposito_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES deposito (id)',
    ),
  );
  static const VerificationMeta _fechaCreacionMeta = const VerificationMeta(
    'fechaCreacion',
  );
  @override
  late final GeneratedColumn<String> fechaCreacion = GeneratedColumn<String>(
    'fecha_creacion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _metodoUsadoMeta = const VerificationMeta(
    'metodoUsado',
  );
  @override
  late final GeneratedColumn<String> metodoUsado = GeneratedColumn<String>(
    'metodo_usado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    depositoId,
    fechaCreacion,
    metodoUsado,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'escenario_optimizacion';
  @override
  VerificationContext validateIntegrity(
    Insertable<EscenarioOptimizacionTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('deposito_id')) {
      context.handle(
        _depositoIdMeta,
        depositoId.isAcceptableOrUnknown(data['deposito_id']!, _depositoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_depositoIdMeta);
    }
    if (data.containsKey('fecha_creacion')) {
      context.handle(
        _fechaCreacionMeta,
        fechaCreacion.isAcceptableOrUnknown(
          data['fecha_creacion']!,
          _fechaCreacionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaCreacionMeta);
    }
    if (data.containsKey('metodo_usado')) {
      context.handle(
        _metodoUsadoMeta,
        metodoUsado.isAcceptableOrUnknown(
          data['metodo_usado']!,
          _metodoUsadoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_metodoUsadoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EscenarioOptimizacionTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EscenarioOptimizacionTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      depositoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deposito_id'],
      )!,
      fechaCreacion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fecha_creacion'],
      )!,
      metodoUsado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metodo_usado'],
      )!,
    );
  }

  @override
  $EscenarioOptimizacionTableTable createAlias(String alias) {
    return $EscenarioOptimizacionTableTable(attachedDatabase, alias);
  }
}

class EscenarioOptimizacionTableData extends DataClass
    implements Insertable<EscenarioOptimizacionTableData> {
  final int id;
  final int depositoId;
  final String fechaCreacion;
  final String metodoUsado;
  const EscenarioOptimizacionTableData({
    required this.id,
    required this.depositoId,
    required this.fechaCreacion,
    required this.metodoUsado,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['deposito_id'] = Variable<int>(depositoId);
    map['fecha_creacion'] = Variable<String>(fechaCreacion);
    map['metodo_usado'] = Variable<String>(metodoUsado);
    return map;
  }

  EscenarioOptimizacionTableCompanion toCompanion(bool nullToAbsent) {
    return EscenarioOptimizacionTableCompanion(
      id: Value(id),
      depositoId: Value(depositoId),
      fechaCreacion: Value(fechaCreacion),
      metodoUsado: Value(metodoUsado),
    );
  }

  factory EscenarioOptimizacionTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EscenarioOptimizacionTableData(
      id: serializer.fromJson<int>(json['id']),
      depositoId: serializer.fromJson<int>(json['depositoId']),
      fechaCreacion: serializer.fromJson<String>(json['fechaCreacion']),
      metodoUsado: serializer.fromJson<String>(json['metodoUsado']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'depositoId': serializer.toJson<int>(depositoId),
      'fechaCreacion': serializer.toJson<String>(fechaCreacion),
      'metodoUsado': serializer.toJson<String>(metodoUsado),
    };
  }

  EscenarioOptimizacionTableData copyWith({
    int? id,
    int? depositoId,
    String? fechaCreacion,
    String? metodoUsado,
  }) => EscenarioOptimizacionTableData(
    id: id ?? this.id,
    depositoId: depositoId ?? this.depositoId,
    fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    metodoUsado: metodoUsado ?? this.metodoUsado,
  );
  EscenarioOptimizacionTableData copyWithCompanion(
    EscenarioOptimizacionTableCompanion data,
  ) {
    return EscenarioOptimizacionTableData(
      id: data.id.present ? data.id.value : this.id,
      depositoId: data.depositoId.present
          ? data.depositoId.value
          : this.depositoId,
      fechaCreacion: data.fechaCreacion.present
          ? data.fechaCreacion.value
          : this.fechaCreacion,
      metodoUsado: data.metodoUsado.present
          ? data.metodoUsado.value
          : this.metodoUsado,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EscenarioOptimizacionTableData(')
          ..write('id: $id, ')
          ..write('depositoId: $depositoId, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('metodoUsado: $metodoUsado')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, depositoId, fechaCreacion, metodoUsado);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EscenarioOptimizacionTableData &&
          other.id == this.id &&
          other.depositoId == this.depositoId &&
          other.fechaCreacion == this.fechaCreacion &&
          other.metodoUsado == this.metodoUsado);
}

class EscenarioOptimizacionTableCompanion
    extends UpdateCompanion<EscenarioOptimizacionTableData> {
  final Value<int> id;
  final Value<int> depositoId;
  final Value<String> fechaCreacion;
  final Value<String> metodoUsado;
  const EscenarioOptimizacionTableCompanion({
    this.id = const Value.absent(),
    this.depositoId = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.metodoUsado = const Value.absent(),
  });
  EscenarioOptimizacionTableCompanion.insert({
    this.id = const Value.absent(),
    required int depositoId,
    required String fechaCreacion,
    required String metodoUsado,
  }) : depositoId = Value(depositoId),
       fechaCreacion = Value(fechaCreacion),
       metodoUsado = Value(metodoUsado);
  static Insertable<EscenarioOptimizacionTableData> custom({
    Expression<int>? id,
    Expression<int>? depositoId,
    Expression<String>? fechaCreacion,
    Expression<String>? metodoUsado,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (depositoId != null) 'deposito_id': depositoId,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
      if (metodoUsado != null) 'metodo_usado': metodoUsado,
    });
  }

  EscenarioOptimizacionTableCompanion copyWith({
    Value<int>? id,
    Value<int>? depositoId,
    Value<String>? fechaCreacion,
    Value<String>? metodoUsado,
  }) {
    return EscenarioOptimizacionTableCompanion(
      id: id ?? this.id,
      depositoId: depositoId ?? this.depositoId,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      metodoUsado: metodoUsado ?? this.metodoUsado,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (depositoId.present) {
      map['deposito_id'] = Variable<int>(depositoId.value);
    }
    if (fechaCreacion.present) {
      map['fecha_creacion'] = Variable<String>(fechaCreacion.value);
    }
    if (metodoUsado.present) {
      map['metodo_usado'] = Variable<String>(metodoUsado.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EscenarioOptimizacionTableCompanion(')
          ..write('id: $id, ')
          ..write('depositoId: $depositoId, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('metodoUsado: $metodoUsado')
          ..write(')'))
        .toString();
  }
}

class $EscenarioPuntoTableTable extends EscenarioPuntoTable
    with TableInfo<$EscenarioPuntoTableTable, EscenarioPuntoTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EscenarioPuntoTableTable(this.attachedDatabase, [this._alias]);
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
      'REFERENCES escenario_optimizacion (id)',
    ),
  );
  static const VerificationMeta _puntoEntregaIdMeta = const VerificationMeta(
    'puntoEntregaId',
  );
  @override
  late final GeneratedColumn<int> puntoEntregaId = GeneratedColumn<int>(
    'punto_entrega_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES punto_entrega (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [escenarioId, puntoEntregaId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'escenario_punto';
  @override
  VerificationContext validateIntegrity(
    Insertable<EscenarioPuntoTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
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
    if (data.containsKey('punto_entrega_id')) {
      context.handle(
        _puntoEntregaIdMeta,
        puntoEntregaId.isAcceptableOrUnknown(
          data['punto_entrega_id']!,
          _puntoEntregaIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_puntoEntregaIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  EscenarioPuntoTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EscenarioPuntoTableData(
      escenarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}escenario_id'],
      )!,
      puntoEntregaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}punto_entrega_id'],
      )!,
    );
  }

  @override
  $EscenarioPuntoTableTable createAlias(String alias) {
    return $EscenarioPuntoTableTable(attachedDatabase, alias);
  }
}

class EscenarioPuntoTableData extends DataClass
    implements Insertable<EscenarioPuntoTableData> {
  final int escenarioId;
  final int puntoEntregaId;
  const EscenarioPuntoTableData({
    required this.escenarioId,
    required this.puntoEntregaId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['escenario_id'] = Variable<int>(escenarioId);
    map['punto_entrega_id'] = Variable<int>(puntoEntregaId);
    return map;
  }

  EscenarioPuntoTableCompanion toCompanion(bool nullToAbsent) {
    return EscenarioPuntoTableCompanion(
      escenarioId: Value(escenarioId),
      puntoEntregaId: Value(puntoEntregaId),
    );
  }

  factory EscenarioPuntoTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EscenarioPuntoTableData(
      escenarioId: serializer.fromJson<int>(json['escenarioId']),
      puntoEntregaId: serializer.fromJson<int>(json['puntoEntregaId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'escenarioId': serializer.toJson<int>(escenarioId),
      'puntoEntregaId': serializer.toJson<int>(puntoEntregaId),
    };
  }

  EscenarioPuntoTableData copyWith({int? escenarioId, int? puntoEntregaId}) =>
      EscenarioPuntoTableData(
        escenarioId: escenarioId ?? this.escenarioId,
        puntoEntregaId: puntoEntregaId ?? this.puntoEntregaId,
      );
  EscenarioPuntoTableData copyWithCompanion(EscenarioPuntoTableCompanion data) {
    return EscenarioPuntoTableData(
      escenarioId: data.escenarioId.present
          ? data.escenarioId.value
          : this.escenarioId,
      puntoEntregaId: data.puntoEntregaId.present
          ? data.puntoEntregaId.value
          : this.puntoEntregaId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EscenarioPuntoTableData(')
          ..write('escenarioId: $escenarioId, ')
          ..write('puntoEntregaId: $puntoEntregaId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(escenarioId, puntoEntregaId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EscenarioPuntoTableData &&
          other.escenarioId == this.escenarioId &&
          other.puntoEntregaId == this.puntoEntregaId);
}

class EscenarioPuntoTableCompanion
    extends UpdateCompanion<EscenarioPuntoTableData> {
  final Value<int> escenarioId;
  final Value<int> puntoEntregaId;
  final Value<int> rowid;
  const EscenarioPuntoTableCompanion({
    this.escenarioId = const Value.absent(),
    this.puntoEntregaId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EscenarioPuntoTableCompanion.insert({
    required int escenarioId,
    required int puntoEntregaId,
    this.rowid = const Value.absent(),
  }) : escenarioId = Value(escenarioId),
       puntoEntregaId = Value(puntoEntregaId);
  static Insertable<EscenarioPuntoTableData> custom({
    Expression<int>? escenarioId,
    Expression<int>? puntoEntregaId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (escenarioId != null) 'escenario_id': escenarioId,
      if (puntoEntregaId != null) 'punto_entrega_id': puntoEntregaId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EscenarioPuntoTableCompanion copyWith({
    Value<int>? escenarioId,
    Value<int>? puntoEntregaId,
    Value<int>? rowid,
  }) {
    return EscenarioPuntoTableCompanion(
      escenarioId: escenarioId ?? this.escenarioId,
      puntoEntregaId: puntoEntregaId ?? this.puntoEntregaId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (escenarioId.present) {
      map['escenario_id'] = Variable<int>(escenarioId.value);
    }
    if (puntoEntregaId.present) {
      map['punto_entrega_id'] = Variable<int>(puntoEntregaId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EscenarioPuntoTableCompanion(')
          ..write('escenarioId: $escenarioId, ')
          ..write('puntoEntregaId: $puntoEntregaId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EscenarioVehiculoTableTable extends EscenarioVehiculoTable
    with TableInfo<$EscenarioVehiculoTableTable, EscenarioVehiculoTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EscenarioVehiculoTableTable(this.attachedDatabase, [this._alias]);
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
      'REFERENCES escenario_optimizacion (id)',
    ),
  );
  static const VerificationMeta _vehiculoIdMeta = const VerificationMeta(
    'vehiculoId',
  );
  @override
  late final GeneratedColumn<int> vehiculoId = GeneratedColumn<int>(
    'vehiculo_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vehiculo (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [escenarioId, vehiculoId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'escenario_vehiculo';
  @override
  VerificationContext validateIntegrity(
    Insertable<EscenarioVehiculoTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
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
    if (data.containsKey('vehiculo_id')) {
      context.handle(
        _vehiculoIdMeta,
        vehiculoId.isAcceptableOrUnknown(data['vehiculo_id']!, _vehiculoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehiculoIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  EscenarioVehiculoTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EscenarioVehiculoTableData(
      escenarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}escenario_id'],
      )!,
      vehiculoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vehiculo_id'],
      )!,
    );
  }

  @override
  $EscenarioVehiculoTableTable createAlias(String alias) {
    return $EscenarioVehiculoTableTable(attachedDatabase, alias);
  }
}

class EscenarioVehiculoTableData extends DataClass
    implements Insertable<EscenarioVehiculoTableData> {
  final int escenarioId;
  final int vehiculoId;
  const EscenarioVehiculoTableData({
    required this.escenarioId,
    required this.vehiculoId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['escenario_id'] = Variable<int>(escenarioId);
    map['vehiculo_id'] = Variable<int>(vehiculoId);
    return map;
  }

  EscenarioVehiculoTableCompanion toCompanion(bool nullToAbsent) {
    return EscenarioVehiculoTableCompanion(
      escenarioId: Value(escenarioId),
      vehiculoId: Value(vehiculoId),
    );
  }

  factory EscenarioVehiculoTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EscenarioVehiculoTableData(
      escenarioId: serializer.fromJson<int>(json['escenarioId']),
      vehiculoId: serializer.fromJson<int>(json['vehiculoId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'escenarioId': serializer.toJson<int>(escenarioId),
      'vehiculoId': serializer.toJson<int>(vehiculoId),
    };
  }

  EscenarioVehiculoTableData copyWith({int? escenarioId, int? vehiculoId}) =>
      EscenarioVehiculoTableData(
        escenarioId: escenarioId ?? this.escenarioId,
        vehiculoId: vehiculoId ?? this.vehiculoId,
      );
  EscenarioVehiculoTableData copyWithCompanion(
    EscenarioVehiculoTableCompanion data,
  ) {
    return EscenarioVehiculoTableData(
      escenarioId: data.escenarioId.present
          ? data.escenarioId.value
          : this.escenarioId,
      vehiculoId: data.vehiculoId.present
          ? data.vehiculoId.value
          : this.vehiculoId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EscenarioVehiculoTableData(')
          ..write('escenarioId: $escenarioId, ')
          ..write('vehiculoId: $vehiculoId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(escenarioId, vehiculoId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EscenarioVehiculoTableData &&
          other.escenarioId == this.escenarioId &&
          other.vehiculoId == this.vehiculoId);
}

class EscenarioVehiculoTableCompanion
    extends UpdateCompanion<EscenarioVehiculoTableData> {
  final Value<int> escenarioId;
  final Value<int> vehiculoId;
  final Value<int> rowid;
  const EscenarioVehiculoTableCompanion({
    this.escenarioId = const Value.absent(),
    this.vehiculoId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EscenarioVehiculoTableCompanion.insert({
    required int escenarioId,
    required int vehiculoId,
    this.rowid = const Value.absent(),
  }) : escenarioId = Value(escenarioId),
       vehiculoId = Value(vehiculoId);
  static Insertable<EscenarioVehiculoTableData> custom({
    Expression<int>? escenarioId,
    Expression<int>? vehiculoId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (escenarioId != null) 'escenario_id': escenarioId,
      if (vehiculoId != null) 'vehiculo_id': vehiculoId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EscenarioVehiculoTableCompanion copyWith({
    Value<int>? escenarioId,
    Value<int>? vehiculoId,
    Value<int>? rowid,
  }) {
    return EscenarioVehiculoTableCompanion(
      escenarioId: escenarioId ?? this.escenarioId,
      vehiculoId: vehiculoId ?? this.vehiculoId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (escenarioId.present) {
      map['escenario_id'] = Variable<int>(escenarioId.value);
    }
    if (vehiculoId.present) {
      map['vehiculo_id'] = Variable<int>(vehiculoId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EscenarioVehiculoTableCompanion(')
          ..write('escenarioId: $escenarioId, ')
          ..write('vehiculoId: $vehiculoId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RutaResultadoTableTable extends RutaResultadoTable
    with TableInfo<$RutaResultadoTableTable, RutaResultadoTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RutaResultadoTableTable(this.attachedDatabase, [this._alias]);
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
      'REFERENCES escenario_optimizacion (id)',
    ),
  );
  static const VerificationMeta _vehiculoIdMeta = const VerificationMeta(
    'vehiculoId',
  );
  @override
  late final GeneratedColumn<int> vehiculoId = GeneratedColumn<int>(
    'vehiculo_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vehiculo (id)',
    ),
  );
  static const VerificationMeta _secuenciaParadasMeta = const VerificationMeta(
    'secuenciaParadas',
  );
  @override
  late final GeneratedColumn<String> secuenciaParadas = GeneratedColumn<String>(
    'secuencia_paradas',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _distanciaTotalKmMeta = const VerificationMeta(
    'distanciaTotalKm',
  );
  @override
  late final GeneratedColumn<double> distanciaTotalKm = GeneratedColumn<double>(
    'distancia_total_km',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tiempoTotalSegundosMeta =
      const VerificationMeta('tiempoTotalSegundos');
  @override
  late final GeneratedColumn<double> tiempoTotalSegundos =
      GeneratedColumn<double>(
        'tiempo_total_segundos',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
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
    escenarioId,
    vehiculoId,
    secuenciaParadas,
    distanciaTotalKm,
    tiempoTotalSegundos,
    geometriaPolyline,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ruta_resultado';
  @override
  VerificationContext validateIntegrity(
    Insertable<RutaResultadoTableData> instance, {
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
    if (data.containsKey('vehiculo_id')) {
      context.handle(
        _vehiculoIdMeta,
        vehiculoId.isAcceptableOrUnknown(data['vehiculo_id']!, _vehiculoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehiculoIdMeta);
    }
    if (data.containsKey('secuencia_paradas')) {
      context.handle(
        _secuenciaParadasMeta,
        secuenciaParadas.isAcceptableOrUnknown(
          data['secuencia_paradas']!,
          _secuenciaParadasMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_secuenciaParadasMeta);
    }
    if (data.containsKey('distancia_total_km')) {
      context.handle(
        _distanciaTotalKmMeta,
        distanciaTotalKm.isAcceptableOrUnknown(
          data['distancia_total_km']!,
          _distanciaTotalKmMeta,
        ),
      );
    }
    if (data.containsKey('tiempo_total_segundos')) {
      context.handle(
        _tiempoTotalSegundosMeta,
        tiempoTotalSegundos.isAcceptableOrUnknown(
          data['tiempo_total_segundos']!,
          _tiempoTotalSegundosMeta,
        ),
      );
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
  RutaResultadoTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RutaResultadoTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      escenarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}escenario_id'],
      )!,
      vehiculoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vehiculo_id'],
      )!,
      secuenciaParadas: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}secuencia_paradas'],
      )!,
      distanciaTotalKm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distancia_total_km'],
      ),
      tiempoTotalSegundos: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tiempo_total_segundos'],
      ),
      geometriaPolyline: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}geometria_polyline'],
      ),
    );
  }

  @override
  $RutaResultadoTableTable createAlias(String alias) {
    return $RutaResultadoTableTable(attachedDatabase, alias);
  }
}

class RutaResultadoTableData extends DataClass
    implements Insertable<RutaResultadoTableData> {
  final int id;
  final int escenarioId;
  final int vehiculoId;
  final String secuenciaParadas;
  final double? distanciaTotalKm;
  final double? tiempoTotalSegundos;
  final String? geometriaPolyline;
  const RutaResultadoTableData({
    required this.id,
    required this.escenarioId,
    required this.vehiculoId,
    required this.secuenciaParadas,
    this.distanciaTotalKm,
    this.tiempoTotalSegundos,
    this.geometriaPolyline,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['escenario_id'] = Variable<int>(escenarioId);
    map['vehiculo_id'] = Variable<int>(vehiculoId);
    map['secuencia_paradas'] = Variable<String>(secuenciaParadas);
    if (!nullToAbsent || distanciaTotalKm != null) {
      map['distancia_total_km'] = Variable<double>(distanciaTotalKm);
    }
    if (!nullToAbsent || tiempoTotalSegundos != null) {
      map['tiempo_total_segundos'] = Variable<double>(tiempoTotalSegundos);
    }
    if (!nullToAbsent || geometriaPolyline != null) {
      map['geometria_polyline'] = Variable<String>(geometriaPolyline);
    }
    return map;
  }

  RutaResultadoTableCompanion toCompanion(bool nullToAbsent) {
    return RutaResultadoTableCompanion(
      id: Value(id),
      escenarioId: Value(escenarioId),
      vehiculoId: Value(vehiculoId),
      secuenciaParadas: Value(secuenciaParadas),
      distanciaTotalKm: distanciaTotalKm == null && nullToAbsent
          ? const Value.absent()
          : Value(distanciaTotalKm),
      tiempoTotalSegundos: tiempoTotalSegundos == null && nullToAbsent
          ? const Value.absent()
          : Value(tiempoTotalSegundos),
      geometriaPolyline: geometriaPolyline == null && nullToAbsent
          ? const Value.absent()
          : Value(geometriaPolyline),
    );
  }

  factory RutaResultadoTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RutaResultadoTableData(
      id: serializer.fromJson<int>(json['id']),
      escenarioId: serializer.fromJson<int>(json['escenarioId']),
      vehiculoId: serializer.fromJson<int>(json['vehiculoId']),
      secuenciaParadas: serializer.fromJson<String>(json['secuenciaParadas']),
      distanciaTotalKm: serializer.fromJson<double?>(json['distanciaTotalKm']),
      tiempoTotalSegundos: serializer.fromJson<double?>(
        json['tiempoTotalSegundos'],
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
      'escenarioId': serializer.toJson<int>(escenarioId),
      'vehiculoId': serializer.toJson<int>(vehiculoId),
      'secuenciaParadas': serializer.toJson<String>(secuenciaParadas),
      'distanciaTotalKm': serializer.toJson<double?>(distanciaTotalKm),
      'tiempoTotalSegundos': serializer.toJson<double?>(tiempoTotalSegundos),
      'geometriaPolyline': serializer.toJson<String?>(geometriaPolyline),
    };
  }

  RutaResultadoTableData copyWith({
    int? id,
    int? escenarioId,
    int? vehiculoId,
    String? secuenciaParadas,
    Value<double?> distanciaTotalKm = const Value.absent(),
    Value<double?> tiempoTotalSegundos = const Value.absent(),
    Value<String?> geometriaPolyline = const Value.absent(),
  }) => RutaResultadoTableData(
    id: id ?? this.id,
    escenarioId: escenarioId ?? this.escenarioId,
    vehiculoId: vehiculoId ?? this.vehiculoId,
    secuenciaParadas: secuenciaParadas ?? this.secuenciaParadas,
    distanciaTotalKm: distanciaTotalKm.present
        ? distanciaTotalKm.value
        : this.distanciaTotalKm,
    tiempoTotalSegundos: tiempoTotalSegundos.present
        ? tiempoTotalSegundos.value
        : this.tiempoTotalSegundos,
    geometriaPolyline: geometriaPolyline.present
        ? geometriaPolyline.value
        : this.geometriaPolyline,
  );
  RutaResultadoTableData copyWithCompanion(RutaResultadoTableCompanion data) {
    return RutaResultadoTableData(
      id: data.id.present ? data.id.value : this.id,
      escenarioId: data.escenarioId.present
          ? data.escenarioId.value
          : this.escenarioId,
      vehiculoId: data.vehiculoId.present
          ? data.vehiculoId.value
          : this.vehiculoId,
      secuenciaParadas: data.secuenciaParadas.present
          ? data.secuenciaParadas.value
          : this.secuenciaParadas,
      distanciaTotalKm: data.distanciaTotalKm.present
          ? data.distanciaTotalKm.value
          : this.distanciaTotalKm,
      tiempoTotalSegundos: data.tiempoTotalSegundos.present
          ? data.tiempoTotalSegundos.value
          : this.tiempoTotalSegundos,
      geometriaPolyline: data.geometriaPolyline.present
          ? data.geometriaPolyline.value
          : this.geometriaPolyline,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RutaResultadoTableData(')
          ..write('id: $id, ')
          ..write('escenarioId: $escenarioId, ')
          ..write('vehiculoId: $vehiculoId, ')
          ..write('secuenciaParadas: $secuenciaParadas, ')
          ..write('distanciaTotalKm: $distanciaTotalKm, ')
          ..write('tiempoTotalSegundos: $tiempoTotalSegundos, ')
          ..write('geometriaPolyline: $geometriaPolyline')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    escenarioId,
    vehiculoId,
    secuenciaParadas,
    distanciaTotalKm,
    tiempoTotalSegundos,
    geometriaPolyline,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RutaResultadoTableData &&
          other.id == this.id &&
          other.escenarioId == this.escenarioId &&
          other.vehiculoId == this.vehiculoId &&
          other.secuenciaParadas == this.secuenciaParadas &&
          other.distanciaTotalKm == this.distanciaTotalKm &&
          other.tiempoTotalSegundos == this.tiempoTotalSegundos &&
          other.geometriaPolyline == this.geometriaPolyline);
}

class RutaResultadoTableCompanion
    extends UpdateCompanion<RutaResultadoTableData> {
  final Value<int> id;
  final Value<int> escenarioId;
  final Value<int> vehiculoId;
  final Value<String> secuenciaParadas;
  final Value<double?> distanciaTotalKm;
  final Value<double?> tiempoTotalSegundos;
  final Value<String?> geometriaPolyline;
  const RutaResultadoTableCompanion({
    this.id = const Value.absent(),
    this.escenarioId = const Value.absent(),
    this.vehiculoId = const Value.absent(),
    this.secuenciaParadas = const Value.absent(),
    this.distanciaTotalKm = const Value.absent(),
    this.tiempoTotalSegundos = const Value.absent(),
    this.geometriaPolyline = const Value.absent(),
  });
  RutaResultadoTableCompanion.insert({
    this.id = const Value.absent(),
    required int escenarioId,
    required int vehiculoId,
    required String secuenciaParadas,
    this.distanciaTotalKm = const Value.absent(),
    this.tiempoTotalSegundos = const Value.absent(),
    this.geometriaPolyline = const Value.absent(),
  }) : escenarioId = Value(escenarioId),
       vehiculoId = Value(vehiculoId),
       secuenciaParadas = Value(secuenciaParadas);
  static Insertable<RutaResultadoTableData> custom({
    Expression<int>? id,
    Expression<int>? escenarioId,
    Expression<int>? vehiculoId,
    Expression<String>? secuenciaParadas,
    Expression<double>? distanciaTotalKm,
    Expression<double>? tiempoTotalSegundos,
    Expression<String>? geometriaPolyline,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (escenarioId != null) 'escenario_id': escenarioId,
      if (vehiculoId != null) 'vehiculo_id': vehiculoId,
      if (secuenciaParadas != null) 'secuencia_paradas': secuenciaParadas,
      if (distanciaTotalKm != null) 'distancia_total_km': distanciaTotalKm,
      if (tiempoTotalSegundos != null)
        'tiempo_total_segundos': tiempoTotalSegundos,
      if (geometriaPolyline != null) 'geometria_polyline': geometriaPolyline,
    });
  }

  RutaResultadoTableCompanion copyWith({
    Value<int>? id,
    Value<int>? escenarioId,
    Value<int>? vehiculoId,
    Value<String>? secuenciaParadas,
    Value<double?>? distanciaTotalKm,
    Value<double?>? tiempoTotalSegundos,
    Value<String?>? geometriaPolyline,
  }) {
    return RutaResultadoTableCompanion(
      id: id ?? this.id,
      escenarioId: escenarioId ?? this.escenarioId,
      vehiculoId: vehiculoId ?? this.vehiculoId,
      secuenciaParadas: secuenciaParadas ?? this.secuenciaParadas,
      distanciaTotalKm: distanciaTotalKm ?? this.distanciaTotalKm,
      tiempoTotalSegundos: tiempoTotalSegundos ?? this.tiempoTotalSegundos,
      geometriaPolyline: geometriaPolyline ?? this.geometriaPolyline,
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
    if (vehiculoId.present) {
      map['vehiculo_id'] = Variable<int>(vehiculoId.value);
    }
    if (secuenciaParadas.present) {
      map['secuencia_paradas'] = Variable<String>(secuenciaParadas.value);
    }
    if (distanciaTotalKm.present) {
      map['distancia_total_km'] = Variable<double>(distanciaTotalKm.value);
    }
    if (tiempoTotalSegundos.present) {
      map['tiempo_total_segundos'] = Variable<double>(
        tiempoTotalSegundos.value,
      );
    }
    if (geometriaPolyline.present) {
      map['geometria_polyline'] = Variable<String>(geometriaPolyline.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RutaResultadoTableCompanion(')
          ..write('id: $id, ')
          ..write('escenarioId: $escenarioId, ')
          ..write('vehiculoId: $vehiculoId, ')
          ..write('secuenciaParadas: $secuenciaParadas, ')
          ..write('distanciaTotalKm: $distanciaTotalKm, ')
          ..write('tiempoTotalSegundos: $tiempoTotalSegundos, ')
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
  late final $EscenarioOptimizacionTableTable escenarioOptimizacionTable =
      $EscenarioOptimizacionTableTable(this);
  late final $EscenarioPuntoTableTable escenarioPuntoTable =
      $EscenarioPuntoTableTable(this);
  late final $EscenarioVehiculoTableTable escenarioVehiculoTable =
      $EscenarioVehiculoTableTable(this);
  late final $RutaResultadoTableTable rutaResultadoTable =
      $RutaResultadoTableTable(this);
  late final $CacheOsrmTableTable cacheOsrmTable = $CacheOsrmTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    depositoTable,
    puntoEntregaTable,
    vehiculoTable,
    escenarioOptimizacionTable,
    escenarioPuntoTable,
    escenarioVehiculoTable,
    rutaResultadoTable,
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

final class $$DepositoTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $DepositoTableTable, DepositoTableData> {
  $$DepositoTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $EscenarioOptimizacionTableTable,
    List<EscenarioOptimizacionTableData>
  >
  _escenarioOptimizacionTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.escenarioOptimizacionTable,
        aliasName: 'deposito__id__escenario_optimizacion__deposito_id',
      );

  $$EscenarioOptimizacionTableTableProcessedTableManager
  get escenarioOptimizacionTableRefs {
    final manager = $$EscenarioOptimizacionTableTableTableManager(
      $_db,
      $_db.escenarioOptimizacionTable,
    ).filter((f) => f.depositoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _escenarioOptimizacionTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

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

  Expression<bool> escenarioOptimizacionTableRefs(
    Expression<bool> Function($$EscenarioOptimizacionTableTableFilterComposer f)
    f,
  ) {
    final $$EscenarioOptimizacionTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.escenarioOptimizacionTable,
          getReferencedColumn: (t) => t.depositoId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EscenarioOptimizacionTableTableFilterComposer(
                $db: $db,
                $table: $db.escenarioOptimizacionTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
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

  Expression<T> escenarioOptimizacionTableRefs<T extends Object>(
    Expression<T> Function(
      $$EscenarioOptimizacionTableTableAnnotationComposer a,
    )
    f,
  ) {
    final $$EscenarioOptimizacionTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.escenarioOptimizacionTable,
          getReferencedColumn: (t) => t.depositoId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EscenarioOptimizacionTableTableAnnotationComposer(
                $db: $db,
                $table: $db.escenarioOptimizacionTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
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
          (DepositoTableData, $$DepositoTableTableReferences),
          DepositoTableData,
          PrefetchHooks Function({bool escenarioOptimizacionTableRefs})
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
              .map(
                (e) => (
                  e.readTable(table),
                  $$DepositoTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({escenarioOptimizacionTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (escenarioOptimizacionTableRefs)
                  db.escenarioOptimizacionTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (escenarioOptimizacionTableRefs)
                    await $_getPrefetchedData<
                      DepositoTableData,
                      $DepositoTableTable,
                      EscenarioOptimizacionTableData
                    >(
                      currentTable: table,
                      referencedTable: $$DepositoTableTableReferences
                          ._escenarioOptimizacionTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$DepositoTableTableReferences(
                            db,
                            table,
                            p0,
                          ).escenarioOptimizacionTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.depositoId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
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
      (DepositoTableData, $$DepositoTableTableReferences),
      DepositoTableData,
      PrefetchHooks Function({bool escenarioOptimizacionTableRefs})
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

final class $$PuntoEntregaTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PuntoEntregaTableTable,
          PuntoEntregaTableData
        > {
  $$PuntoEntregaTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $EscenarioPuntoTableTable,
    List<EscenarioPuntoTableData>
  >
  _escenarioPuntoTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.escenarioPuntoTable,
        aliasName: 'punto_entrega__id__escenario_punto__punto_entrega_id',
      );

  $$EscenarioPuntoTableTableProcessedTableManager get escenarioPuntoTableRefs {
    final manager = $$EscenarioPuntoTableTableTableManager(
      $_db,
      $_db.escenarioPuntoTable,
    ).filter((f) => f.puntoEntregaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _escenarioPuntoTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

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

  Expression<bool> escenarioPuntoTableRefs(
    Expression<bool> Function($$EscenarioPuntoTableTableFilterComposer f) f,
  ) {
    final $$EscenarioPuntoTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.escenarioPuntoTable,
      getReferencedColumn: (t) => t.puntoEntregaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EscenarioPuntoTableTableFilterComposer(
            $db: $db,
            $table: $db.escenarioPuntoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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

  Expression<T> escenarioPuntoTableRefs<T extends Object>(
    Expression<T> Function($$EscenarioPuntoTableTableAnnotationComposer a) f,
  ) {
    final $$EscenarioPuntoTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.escenarioPuntoTable,
          getReferencedColumn: (t) => t.puntoEntregaId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EscenarioPuntoTableTableAnnotationComposer(
                $db: $db,
                $table: $db.escenarioPuntoTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
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
          (PuntoEntregaTableData, $$PuntoEntregaTableTableReferences),
          PuntoEntregaTableData,
          PrefetchHooks Function({bool escenarioPuntoTableRefs})
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
              .map(
                (e) => (
                  e.readTable(table),
                  $$PuntoEntregaTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({escenarioPuntoTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (escenarioPuntoTableRefs) db.escenarioPuntoTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (escenarioPuntoTableRefs)
                    await $_getPrefetchedData<
                      PuntoEntregaTableData,
                      $PuntoEntregaTableTable,
                      EscenarioPuntoTableData
                    >(
                      currentTable: table,
                      referencedTable: $$PuntoEntregaTableTableReferences
                          ._escenarioPuntoTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PuntoEntregaTableTableReferences(
                            db,
                            table,
                            p0,
                          ).escenarioPuntoTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.puntoEntregaId == item.id,
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
      (PuntoEntregaTableData, $$PuntoEntregaTableTableReferences),
      PuntoEntregaTableData,
      PrefetchHooks Function({bool escenarioPuntoTableRefs})
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

final class $$VehiculoTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $VehiculoTableTable, VehiculoTableData> {
  $$VehiculoTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $EscenarioVehiculoTableTable,
    List<EscenarioVehiculoTableData>
  >
  _escenarioVehiculoTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.escenarioVehiculoTable,
        aliasName: 'vehiculo__id__escenario_vehiculo__vehiculo_id',
      );

  $$EscenarioVehiculoTableTableProcessedTableManager
  get escenarioVehiculoTableRefs {
    final manager = $$EscenarioVehiculoTableTableTableManager(
      $_db,
      $_db.escenarioVehiculoTable,
    ).filter((f) => f.vehiculoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _escenarioVehiculoTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $RutaResultadoTableTable,
    List<RutaResultadoTableData>
  >
  _rutaResultadoTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.rutaResultadoTable,
        aliasName: 'vehiculo__id__ruta_resultado__vehiculo_id',
      );

  $$RutaResultadoTableTableProcessedTableManager get rutaResultadoTableRefs {
    final manager = $$RutaResultadoTableTableTableManager(
      $_db,
      $_db.rutaResultadoTable,
    ).filter((f) => f.vehiculoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _rutaResultadoTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

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

  Expression<bool> escenarioVehiculoTableRefs(
    Expression<bool> Function($$EscenarioVehiculoTableTableFilterComposer f) f,
  ) {
    final $$EscenarioVehiculoTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.escenarioVehiculoTable,
          getReferencedColumn: (t) => t.vehiculoId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EscenarioVehiculoTableTableFilterComposer(
                $db: $db,
                $table: $db.escenarioVehiculoTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> rutaResultadoTableRefs(
    Expression<bool> Function($$RutaResultadoTableTableFilterComposer f) f,
  ) {
    final $$RutaResultadoTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rutaResultadoTable,
      getReferencedColumn: (t) => t.vehiculoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RutaResultadoTableTableFilterComposer(
            $db: $db,
            $table: $db.rutaResultadoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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

  Expression<T> escenarioVehiculoTableRefs<T extends Object>(
    Expression<T> Function($$EscenarioVehiculoTableTableAnnotationComposer a) f,
  ) {
    final $$EscenarioVehiculoTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.escenarioVehiculoTable,
          getReferencedColumn: (t) => t.vehiculoId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EscenarioVehiculoTableTableAnnotationComposer(
                $db: $db,
                $table: $db.escenarioVehiculoTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> rutaResultadoTableRefs<T extends Object>(
    Expression<T> Function($$RutaResultadoTableTableAnnotationComposer a) f,
  ) {
    final $$RutaResultadoTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.rutaResultadoTable,
          getReferencedColumn: (t) => t.vehiculoId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RutaResultadoTableTableAnnotationComposer(
                $db: $db,
                $table: $db.rutaResultadoTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
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
          (VehiculoTableData, $$VehiculoTableTableReferences),
          VehiculoTableData,
          PrefetchHooks Function({
            bool escenarioVehiculoTableRefs,
            bool rutaResultadoTableRefs,
          })
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
              .map(
                (e) => (
                  e.readTable(table),
                  $$VehiculoTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                escenarioVehiculoTableRefs = false,
                rutaResultadoTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (escenarioVehiculoTableRefs) db.escenarioVehiculoTable,
                    if (rutaResultadoTableRefs) db.rutaResultadoTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (escenarioVehiculoTableRefs)
                        await $_getPrefetchedData<
                          VehiculoTableData,
                          $VehiculoTableTable,
                          EscenarioVehiculoTableData
                        >(
                          currentTable: table,
                          referencedTable: $$VehiculoTableTableReferences
                              ._escenarioVehiculoTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VehiculoTableTableReferences(
                                db,
                                table,
                                p0,
                              ).escenarioVehiculoTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vehiculoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (rutaResultadoTableRefs)
                        await $_getPrefetchedData<
                          VehiculoTableData,
                          $VehiculoTableTable,
                          RutaResultadoTableData
                        >(
                          currentTable: table,
                          referencedTable: $$VehiculoTableTableReferences
                              ._rutaResultadoTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VehiculoTableTableReferences(
                                db,
                                table,
                                p0,
                              ).rutaResultadoTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vehiculoId == item.id,
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
      (VehiculoTableData, $$VehiculoTableTableReferences),
      VehiculoTableData,
      PrefetchHooks Function({
        bool escenarioVehiculoTableRefs,
        bool rutaResultadoTableRefs,
      })
    >;
typedef $$EscenarioOptimizacionTableTableCreateCompanionBuilder =
    EscenarioOptimizacionTableCompanion Function({
      Value<int> id,
      required int depositoId,
      required String fechaCreacion,
      required String metodoUsado,
    });
typedef $$EscenarioOptimizacionTableTableUpdateCompanionBuilder =
    EscenarioOptimizacionTableCompanion Function({
      Value<int> id,
      Value<int> depositoId,
      Value<String> fechaCreacion,
      Value<String> metodoUsado,
    });

final class $$EscenarioOptimizacionTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $EscenarioOptimizacionTableTable,
          EscenarioOptimizacionTableData
        > {
  $$EscenarioOptimizacionTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DepositoTableTable _depositoIdTable(_$AppDatabase db) => db
      .depositoTable
      .createAlias('escenario_optimizacion__deposito_id__deposito__id');

  $$DepositoTableTableProcessedTableManager get depositoId {
    final $_column = $_itemColumn<int>('deposito_id')!;

    final manager = $$DepositoTableTableTableManager(
      $_db,
      $_db.depositoTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_depositoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $EscenarioPuntoTableTable,
    List<EscenarioPuntoTableData>
  >
  _escenarioPuntoTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.escenarioPuntoTable,
        aliasName: 'escenario_optimizacion__id__escenario_punto__escenario_id',
      );

  $$EscenarioPuntoTableTableProcessedTableManager get escenarioPuntoTableRefs {
    final manager = $$EscenarioPuntoTableTableTableManager(
      $_db,
      $_db.escenarioPuntoTable,
    ).filter((f) => f.escenarioId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _escenarioPuntoTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $EscenarioVehiculoTableTable,
    List<EscenarioVehiculoTableData>
  >
  _escenarioVehiculoTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.escenarioVehiculoTable,
        aliasName:
            'escenario_optimizacion__id__escenario_vehiculo__escenario_id',
      );

  $$EscenarioVehiculoTableTableProcessedTableManager
  get escenarioVehiculoTableRefs {
    final manager = $$EscenarioVehiculoTableTableTableManager(
      $_db,
      $_db.escenarioVehiculoTable,
    ).filter((f) => f.escenarioId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _escenarioVehiculoTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $RutaResultadoTableTable,
    List<RutaResultadoTableData>
  >
  _rutaResultadoTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.rutaResultadoTable,
        aliasName: 'escenario_optimizacion__id__ruta_resultado__escenario_id',
      );

  $$RutaResultadoTableTableProcessedTableManager get rutaResultadoTableRefs {
    final manager = $$RutaResultadoTableTableTableManager(
      $_db,
      $_db.rutaResultadoTable,
    ).filter((f) => f.escenarioId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _rutaResultadoTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EscenarioOptimizacionTableTableFilterComposer
    extends Composer<_$AppDatabase, $EscenarioOptimizacionTableTable> {
  $$EscenarioOptimizacionTableTableFilterComposer({
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

  ColumnFilters<String> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metodoUsado => $composableBuilder(
    column: $table.metodoUsado,
    builder: (column) => ColumnFilters(column),
  );

  $$DepositoTableTableFilterComposer get depositoId {
    final $$DepositoTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.depositoId,
      referencedTable: $db.depositoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepositoTableTableFilterComposer(
            $db: $db,
            $table: $db.depositoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> escenarioPuntoTableRefs(
    Expression<bool> Function($$EscenarioPuntoTableTableFilterComposer f) f,
  ) {
    final $$EscenarioPuntoTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.escenarioPuntoTable,
      getReferencedColumn: (t) => t.escenarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EscenarioPuntoTableTableFilterComposer(
            $db: $db,
            $table: $db.escenarioPuntoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> escenarioVehiculoTableRefs(
    Expression<bool> Function($$EscenarioVehiculoTableTableFilterComposer f) f,
  ) {
    final $$EscenarioVehiculoTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.escenarioVehiculoTable,
          getReferencedColumn: (t) => t.escenarioId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EscenarioVehiculoTableTableFilterComposer(
                $db: $db,
                $table: $db.escenarioVehiculoTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> rutaResultadoTableRefs(
    Expression<bool> Function($$RutaResultadoTableTableFilterComposer f) f,
  ) {
    final $$RutaResultadoTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rutaResultadoTable,
      getReferencedColumn: (t) => t.escenarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RutaResultadoTableTableFilterComposer(
            $db: $db,
            $table: $db.rutaResultadoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EscenarioOptimizacionTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EscenarioOptimizacionTableTable> {
  $$EscenarioOptimizacionTableTableOrderingComposer({
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

  ColumnOrderings<String> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metodoUsado => $composableBuilder(
    column: $table.metodoUsado,
    builder: (column) => ColumnOrderings(column),
  );

  $$DepositoTableTableOrderingComposer get depositoId {
    final $$DepositoTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.depositoId,
      referencedTable: $db.depositoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepositoTableTableOrderingComposer(
            $db: $db,
            $table: $db.depositoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EscenarioOptimizacionTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EscenarioOptimizacionTableTable> {
  $$EscenarioOptimizacionTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get metodoUsado => $composableBuilder(
    column: $table.metodoUsado,
    builder: (column) => column,
  );

  $$DepositoTableTableAnnotationComposer get depositoId {
    final $$DepositoTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.depositoId,
      referencedTable: $db.depositoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepositoTableTableAnnotationComposer(
            $db: $db,
            $table: $db.depositoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> escenarioPuntoTableRefs<T extends Object>(
    Expression<T> Function($$EscenarioPuntoTableTableAnnotationComposer a) f,
  ) {
    final $$EscenarioPuntoTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.escenarioPuntoTable,
          getReferencedColumn: (t) => t.escenarioId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EscenarioPuntoTableTableAnnotationComposer(
                $db: $db,
                $table: $db.escenarioPuntoTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> escenarioVehiculoTableRefs<T extends Object>(
    Expression<T> Function($$EscenarioVehiculoTableTableAnnotationComposer a) f,
  ) {
    final $$EscenarioVehiculoTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.escenarioVehiculoTable,
          getReferencedColumn: (t) => t.escenarioId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EscenarioVehiculoTableTableAnnotationComposer(
                $db: $db,
                $table: $db.escenarioVehiculoTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> rutaResultadoTableRefs<T extends Object>(
    Expression<T> Function($$RutaResultadoTableTableAnnotationComposer a) f,
  ) {
    final $$RutaResultadoTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.rutaResultadoTable,
          getReferencedColumn: (t) => t.escenarioId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RutaResultadoTableTableAnnotationComposer(
                $db: $db,
                $table: $db.rutaResultadoTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$EscenarioOptimizacionTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EscenarioOptimizacionTableTable,
          EscenarioOptimizacionTableData,
          $$EscenarioOptimizacionTableTableFilterComposer,
          $$EscenarioOptimizacionTableTableOrderingComposer,
          $$EscenarioOptimizacionTableTableAnnotationComposer,
          $$EscenarioOptimizacionTableTableCreateCompanionBuilder,
          $$EscenarioOptimizacionTableTableUpdateCompanionBuilder,
          (
            EscenarioOptimizacionTableData,
            $$EscenarioOptimizacionTableTableReferences,
          ),
          EscenarioOptimizacionTableData,
          PrefetchHooks Function({
            bool depositoId,
            bool escenarioPuntoTableRefs,
            bool escenarioVehiculoTableRefs,
            bool rutaResultadoTableRefs,
          })
        > {
  $$EscenarioOptimizacionTableTableTableManager(
    _$AppDatabase db,
    $EscenarioOptimizacionTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EscenarioOptimizacionTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$EscenarioOptimizacionTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$EscenarioOptimizacionTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> depositoId = const Value.absent(),
                Value<String> fechaCreacion = const Value.absent(),
                Value<String> metodoUsado = const Value.absent(),
              }) => EscenarioOptimizacionTableCompanion(
                id: id,
                depositoId: depositoId,
                fechaCreacion: fechaCreacion,
                metodoUsado: metodoUsado,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int depositoId,
                required String fechaCreacion,
                required String metodoUsado,
              }) => EscenarioOptimizacionTableCompanion.insert(
                id: id,
                depositoId: depositoId,
                fechaCreacion: fechaCreacion,
                metodoUsado: metodoUsado,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EscenarioOptimizacionTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                depositoId = false,
                escenarioPuntoTableRefs = false,
                escenarioVehiculoTableRefs = false,
                rutaResultadoTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (escenarioPuntoTableRefs) db.escenarioPuntoTable,
                    if (escenarioVehiculoTableRefs) db.escenarioVehiculoTable,
                    if (rutaResultadoTableRefs) db.rutaResultadoTable,
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
                        if (depositoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.depositoId,
                                    referencedTable:
                                        $$EscenarioOptimizacionTableTableReferences
                                            ._depositoIdTable(db),
                                    referencedColumn:
                                        $$EscenarioOptimizacionTableTableReferences
                                            ._depositoIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (escenarioPuntoTableRefs)
                        await $_getPrefetchedData<
                          EscenarioOptimizacionTableData,
                          $EscenarioOptimizacionTableTable,
                          EscenarioPuntoTableData
                        >(
                          currentTable: table,
                          referencedTable:
                              $$EscenarioOptimizacionTableTableReferences
                                  ._escenarioPuntoTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EscenarioOptimizacionTableTableReferences(
                                db,
                                table,
                                p0,
                              ).escenarioPuntoTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.escenarioId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (escenarioVehiculoTableRefs)
                        await $_getPrefetchedData<
                          EscenarioOptimizacionTableData,
                          $EscenarioOptimizacionTableTable,
                          EscenarioVehiculoTableData
                        >(
                          currentTable: table,
                          referencedTable:
                              $$EscenarioOptimizacionTableTableReferences
                                  ._escenarioVehiculoTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EscenarioOptimizacionTableTableReferences(
                                db,
                                table,
                                p0,
                              ).escenarioVehiculoTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.escenarioId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (rutaResultadoTableRefs)
                        await $_getPrefetchedData<
                          EscenarioOptimizacionTableData,
                          $EscenarioOptimizacionTableTable,
                          RutaResultadoTableData
                        >(
                          currentTable: table,
                          referencedTable:
                              $$EscenarioOptimizacionTableTableReferences
                                  ._rutaResultadoTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EscenarioOptimizacionTableTableReferences(
                                db,
                                table,
                                p0,
                              ).rutaResultadoTableRefs,
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

typedef $$EscenarioOptimizacionTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EscenarioOptimizacionTableTable,
      EscenarioOptimizacionTableData,
      $$EscenarioOptimizacionTableTableFilterComposer,
      $$EscenarioOptimizacionTableTableOrderingComposer,
      $$EscenarioOptimizacionTableTableAnnotationComposer,
      $$EscenarioOptimizacionTableTableCreateCompanionBuilder,
      $$EscenarioOptimizacionTableTableUpdateCompanionBuilder,
      (
        EscenarioOptimizacionTableData,
        $$EscenarioOptimizacionTableTableReferences,
      ),
      EscenarioOptimizacionTableData,
      PrefetchHooks Function({
        bool depositoId,
        bool escenarioPuntoTableRefs,
        bool escenarioVehiculoTableRefs,
        bool rutaResultadoTableRefs,
      })
    >;
typedef $$EscenarioPuntoTableTableCreateCompanionBuilder =
    EscenarioPuntoTableCompanion Function({
      required int escenarioId,
      required int puntoEntregaId,
      Value<int> rowid,
    });
typedef $$EscenarioPuntoTableTableUpdateCompanionBuilder =
    EscenarioPuntoTableCompanion Function({
      Value<int> escenarioId,
      Value<int> puntoEntregaId,
      Value<int> rowid,
    });

final class $$EscenarioPuntoTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $EscenarioPuntoTableTable,
          EscenarioPuntoTableData
        > {
  $$EscenarioPuntoTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EscenarioOptimizacionTableTable _escenarioIdTable(_$AppDatabase db) =>
      db.escenarioOptimizacionTable.createAlias(
        'escenario_punto__escenario_id__escenario_optimizacion__id',
      );

  $$EscenarioOptimizacionTableTableProcessedTableManager get escenarioId {
    final $_column = $_itemColumn<int>('escenario_id')!;

    final manager = $$EscenarioOptimizacionTableTableTableManager(
      $_db,
      $_db.escenarioOptimizacionTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_escenarioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PuntoEntregaTableTable _puntoEntregaIdTable(_$AppDatabase db) => db
      .puntoEntregaTable
      .createAlias('escenario_punto__punto_entrega_id__punto_entrega__id');

  $$PuntoEntregaTableTableProcessedTableManager get puntoEntregaId {
    final $_column = $_itemColumn<int>('punto_entrega_id')!;

    final manager = $$PuntoEntregaTableTableTableManager(
      $_db,
      $_db.puntoEntregaTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_puntoEntregaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EscenarioPuntoTableTableFilterComposer
    extends Composer<_$AppDatabase, $EscenarioPuntoTableTable> {
  $$EscenarioPuntoTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$EscenarioOptimizacionTableTableFilterComposer get escenarioId {
    final $$EscenarioOptimizacionTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.escenarioId,
          referencedTable: $db.escenarioOptimizacionTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EscenarioOptimizacionTableTableFilterComposer(
                $db: $db,
                $table: $db.escenarioOptimizacionTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$PuntoEntregaTableTableFilterComposer get puntoEntregaId {
    final $$PuntoEntregaTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.puntoEntregaId,
      referencedTable: $db.puntoEntregaTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PuntoEntregaTableTableFilterComposer(
            $db: $db,
            $table: $db.puntoEntregaTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EscenarioPuntoTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EscenarioPuntoTableTable> {
  $$EscenarioPuntoTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$EscenarioOptimizacionTableTableOrderingComposer get escenarioId {
    final $$EscenarioOptimizacionTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.escenarioId,
          referencedTable: $db.escenarioOptimizacionTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EscenarioOptimizacionTableTableOrderingComposer(
                $db: $db,
                $table: $db.escenarioOptimizacionTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$PuntoEntregaTableTableOrderingComposer get puntoEntregaId {
    final $$PuntoEntregaTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.puntoEntregaId,
      referencedTable: $db.puntoEntregaTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PuntoEntregaTableTableOrderingComposer(
            $db: $db,
            $table: $db.puntoEntregaTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EscenarioPuntoTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EscenarioPuntoTableTable> {
  $$EscenarioPuntoTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$EscenarioOptimizacionTableTableAnnotationComposer get escenarioId {
    final $$EscenarioOptimizacionTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.escenarioId,
          referencedTable: $db.escenarioOptimizacionTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EscenarioOptimizacionTableTableAnnotationComposer(
                $db: $db,
                $table: $db.escenarioOptimizacionTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$PuntoEntregaTableTableAnnotationComposer get puntoEntregaId {
    final $$PuntoEntregaTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.puntoEntregaId,
          referencedTable: $db.puntoEntregaTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PuntoEntregaTableTableAnnotationComposer(
                $db: $db,
                $table: $db.puntoEntregaTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$EscenarioPuntoTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EscenarioPuntoTableTable,
          EscenarioPuntoTableData,
          $$EscenarioPuntoTableTableFilterComposer,
          $$EscenarioPuntoTableTableOrderingComposer,
          $$EscenarioPuntoTableTableAnnotationComposer,
          $$EscenarioPuntoTableTableCreateCompanionBuilder,
          $$EscenarioPuntoTableTableUpdateCompanionBuilder,
          (EscenarioPuntoTableData, $$EscenarioPuntoTableTableReferences),
          EscenarioPuntoTableData,
          PrefetchHooks Function({bool escenarioId, bool puntoEntregaId})
        > {
  $$EscenarioPuntoTableTableTableManager(
    _$AppDatabase db,
    $EscenarioPuntoTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EscenarioPuntoTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EscenarioPuntoTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$EscenarioPuntoTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> escenarioId = const Value.absent(),
                Value<int> puntoEntregaId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EscenarioPuntoTableCompanion(
                escenarioId: escenarioId,
                puntoEntregaId: puntoEntregaId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int escenarioId,
                required int puntoEntregaId,
                Value<int> rowid = const Value.absent(),
              }) => EscenarioPuntoTableCompanion.insert(
                escenarioId: escenarioId,
                puntoEntregaId: puntoEntregaId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EscenarioPuntoTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({escenarioId = false, puntoEntregaId = false}) {
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
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.escenarioId,
                                    referencedTable:
                                        $$EscenarioPuntoTableTableReferences
                                            ._escenarioIdTable(db),
                                    referencedColumn:
                                        $$EscenarioPuntoTableTableReferences
                                            ._escenarioIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (puntoEntregaId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.puntoEntregaId,
                                    referencedTable:
                                        $$EscenarioPuntoTableTableReferences
                                            ._puntoEntregaIdTable(db),
                                    referencedColumn:
                                        $$EscenarioPuntoTableTableReferences
                                            ._puntoEntregaIdTable(db)
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

typedef $$EscenarioPuntoTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EscenarioPuntoTableTable,
      EscenarioPuntoTableData,
      $$EscenarioPuntoTableTableFilterComposer,
      $$EscenarioPuntoTableTableOrderingComposer,
      $$EscenarioPuntoTableTableAnnotationComposer,
      $$EscenarioPuntoTableTableCreateCompanionBuilder,
      $$EscenarioPuntoTableTableUpdateCompanionBuilder,
      (EscenarioPuntoTableData, $$EscenarioPuntoTableTableReferences),
      EscenarioPuntoTableData,
      PrefetchHooks Function({bool escenarioId, bool puntoEntregaId})
    >;
typedef $$EscenarioVehiculoTableTableCreateCompanionBuilder =
    EscenarioVehiculoTableCompanion Function({
      required int escenarioId,
      required int vehiculoId,
      Value<int> rowid,
    });
typedef $$EscenarioVehiculoTableTableUpdateCompanionBuilder =
    EscenarioVehiculoTableCompanion Function({
      Value<int> escenarioId,
      Value<int> vehiculoId,
      Value<int> rowid,
    });

final class $$EscenarioVehiculoTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $EscenarioVehiculoTableTable,
          EscenarioVehiculoTableData
        > {
  $$EscenarioVehiculoTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EscenarioOptimizacionTableTable _escenarioIdTable(_$AppDatabase db) =>
      db.escenarioOptimizacionTable.createAlias(
        'escenario_vehiculo__escenario_id__escenario_optimizacion__id',
      );

  $$EscenarioOptimizacionTableTableProcessedTableManager get escenarioId {
    final $_column = $_itemColumn<int>('escenario_id')!;

    final manager = $$EscenarioOptimizacionTableTableTableManager(
      $_db,
      $_db.escenarioOptimizacionTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_escenarioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $VehiculoTableTable _vehiculoIdTable(_$AppDatabase db) => db
      .vehiculoTable
      .createAlias('escenario_vehiculo__vehiculo_id__vehiculo__id');

  $$VehiculoTableTableProcessedTableManager get vehiculoId {
    final $_column = $_itemColumn<int>('vehiculo_id')!;

    final manager = $$VehiculoTableTableTableManager(
      $_db,
      $_db.vehiculoTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vehiculoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EscenarioVehiculoTableTableFilterComposer
    extends Composer<_$AppDatabase, $EscenarioVehiculoTableTable> {
  $$EscenarioVehiculoTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$EscenarioOptimizacionTableTableFilterComposer get escenarioId {
    final $$EscenarioOptimizacionTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.escenarioId,
          referencedTable: $db.escenarioOptimizacionTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EscenarioOptimizacionTableTableFilterComposer(
                $db: $db,
                $table: $db.escenarioOptimizacionTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$VehiculoTableTableFilterComposer get vehiculoId {
    final $$VehiculoTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehiculoId,
      referencedTable: $db.vehiculoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiculoTableTableFilterComposer(
            $db: $db,
            $table: $db.vehiculoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EscenarioVehiculoTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EscenarioVehiculoTableTable> {
  $$EscenarioVehiculoTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$EscenarioOptimizacionTableTableOrderingComposer get escenarioId {
    final $$EscenarioOptimizacionTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.escenarioId,
          referencedTable: $db.escenarioOptimizacionTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EscenarioOptimizacionTableTableOrderingComposer(
                $db: $db,
                $table: $db.escenarioOptimizacionTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$VehiculoTableTableOrderingComposer get vehiculoId {
    final $$VehiculoTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehiculoId,
      referencedTable: $db.vehiculoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiculoTableTableOrderingComposer(
            $db: $db,
            $table: $db.vehiculoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EscenarioVehiculoTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EscenarioVehiculoTableTable> {
  $$EscenarioVehiculoTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$EscenarioOptimizacionTableTableAnnotationComposer get escenarioId {
    final $$EscenarioOptimizacionTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.escenarioId,
          referencedTable: $db.escenarioOptimizacionTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EscenarioOptimizacionTableTableAnnotationComposer(
                $db: $db,
                $table: $db.escenarioOptimizacionTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$VehiculoTableTableAnnotationComposer get vehiculoId {
    final $$VehiculoTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehiculoId,
      referencedTable: $db.vehiculoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiculoTableTableAnnotationComposer(
            $db: $db,
            $table: $db.vehiculoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EscenarioVehiculoTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EscenarioVehiculoTableTable,
          EscenarioVehiculoTableData,
          $$EscenarioVehiculoTableTableFilterComposer,
          $$EscenarioVehiculoTableTableOrderingComposer,
          $$EscenarioVehiculoTableTableAnnotationComposer,
          $$EscenarioVehiculoTableTableCreateCompanionBuilder,
          $$EscenarioVehiculoTableTableUpdateCompanionBuilder,
          (EscenarioVehiculoTableData, $$EscenarioVehiculoTableTableReferences),
          EscenarioVehiculoTableData,
          PrefetchHooks Function({bool escenarioId, bool vehiculoId})
        > {
  $$EscenarioVehiculoTableTableTableManager(
    _$AppDatabase db,
    $EscenarioVehiculoTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EscenarioVehiculoTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$EscenarioVehiculoTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$EscenarioVehiculoTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> escenarioId = const Value.absent(),
                Value<int> vehiculoId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EscenarioVehiculoTableCompanion(
                escenarioId: escenarioId,
                vehiculoId: vehiculoId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int escenarioId,
                required int vehiculoId,
                Value<int> rowid = const Value.absent(),
              }) => EscenarioVehiculoTableCompanion.insert(
                escenarioId: escenarioId,
                vehiculoId: vehiculoId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EscenarioVehiculoTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({escenarioId = false, vehiculoId = false}) {
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
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.escenarioId,
                                referencedTable:
                                    $$EscenarioVehiculoTableTableReferences
                                        ._escenarioIdTable(db),
                                referencedColumn:
                                    $$EscenarioVehiculoTableTableReferences
                                        ._escenarioIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (vehiculoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.vehiculoId,
                                referencedTable:
                                    $$EscenarioVehiculoTableTableReferences
                                        ._vehiculoIdTable(db),
                                referencedColumn:
                                    $$EscenarioVehiculoTableTableReferences
                                        ._vehiculoIdTable(db)
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

typedef $$EscenarioVehiculoTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EscenarioVehiculoTableTable,
      EscenarioVehiculoTableData,
      $$EscenarioVehiculoTableTableFilterComposer,
      $$EscenarioVehiculoTableTableOrderingComposer,
      $$EscenarioVehiculoTableTableAnnotationComposer,
      $$EscenarioVehiculoTableTableCreateCompanionBuilder,
      $$EscenarioVehiculoTableTableUpdateCompanionBuilder,
      (EscenarioVehiculoTableData, $$EscenarioVehiculoTableTableReferences),
      EscenarioVehiculoTableData,
      PrefetchHooks Function({bool escenarioId, bool vehiculoId})
    >;
typedef $$RutaResultadoTableTableCreateCompanionBuilder =
    RutaResultadoTableCompanion Function({
      Value<int> id,
      required int escenarioId,
      required int vehiculoId,
      required String secuenciaParadas,
      Value<double?> distanciaTotalKm,
      Value<double?> tiempoTotalSegundos,
      Value<String?> geometriaPolyline,
    });
typedef $$RutaResultadoTableTableUpdateCompanionBuilder =
    RutaResultadoTableCompanion Function({
      Value<int> id,
      Value<int> escenarioId,
      Value<int> vehiculoId,
      Value<String> secuenciaParadas,
      Value<double?> distanciaTotalKm,
      Value<double?> tiempoTotalSegundos,
      Value<String?> geometriaPolyline,
    });

final class $$RutaResultadoTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RutaResultadoTableTable,
          RutaResultadoTableData
        > {
  $$RutaResultadoTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EscenarioOptimizacionTableTable _escenarioIdTable(_$AppDatabase db) =>
      db.escenarioOptimizacionTable.createAlias(
        'ruta_resultado__escenario_id__escenario_optimizacion__id',
      );

  $$EscenarioOptimizacionTableTableProcessedTableManager get escenarioId {
    final $_column = $_itemColumn<int>('escenario_id')!;

    final manager = $$EscenarioOptimizacionTableTableTableManager(
      $_db,
      $_db.escenarioOptimizacionTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_escenarioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $VehiculoTableTable _vehiculoIdTable(_$AppDatabase db) =>
      db.vehiculoTable.createAlias('ruta_resultado__vehiculo_id__vehiculo__id');

  $$VehiculoTableTableProcessedTableManager get vehiculoId {
    final $_column = $_itemColumn<int>('vehiculo_id')!;

    final manager = $$VehiculoTableTableTableManager(
      $_db,
      $_db.vehiculoTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vehiculoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RutaResultadoTableTableFilterComposer
    extends Composer<_$AppDatabase, $RutaResultadoTableTable> {
  $$RutaResultadoTableTableFilterComposer({
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

  ColumnFilters<String> get secuenciaParadas => $composableBuilder(
    column: $table.secuenciaParadas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanciaTotalKm => $composableBuilder(
    column: $table.distanciaTotalKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get tiempoTotalSegundos => $composableBuilder(
    column: $table.tiempoTotalSegundos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get geometriaPolyline => $composableBuilder(
    column: $table.geometriaPolyline,
    builder: (column) => ColumnFilters(column),
  );

  $$EscenarioOptimizacionTableTableFilterComposer get escenarioId {
    final $$EscenarioOptimizacionTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.escenarioId,
          referencedTable: $db.escenarioOptimizacionTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EscenarioOptimizacionTableTableFilterComposer(
                $db: $db,
                $table: $db.escenarioOptimizacionTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$VehiculoTableTableFilterComposer get vehiculoId {
    final $$VehiculoTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehiculoId,
      referencedTable: $db.vehiculoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiculoTableTableFilterComposer(
            $db: $db,
            $table: $db.vehiculoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RutaResultadoTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RutaResultadoTableTable> {
  $$RutaResultadoTableTableOrderingComposer({
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

  ColumnOrderings<String> get secuenciaParadas => $composableBuilder(
    column: $table.secuenciaParadas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanciaTotalKm => $composableBuilder(
    column: $table.distanciaTotalKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get tiempoTotalSegundos => $composableBuilder(
    column: $table.tiempoTotalSegundos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get geometriaPolyline => $composableBuilder(
    column: $table.geometriaPolyline,
    builder: (column) => ColumnOrderings(column),
  );

  $$EscenarioOptimizacionTableTableOrderingComposer get escenarioId {
    final $$EscenarioOptimizacionTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.escenarioId,
          referencedTable: $db.escenarioOptimizacionTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EscenarioOptimizacionTableTableOrderingComposer(
                $db: $db,
                $table: $db.escenarioOptimizacionTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$VehiculoTableTableOrderingComposer get vehiculoId {
    final $$VehiculoTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehiculoId,
      referencedTable: $db.vehiculoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiculoTableTableOrderingComposer(
            $db: $db,
            $table: $db.vehiculoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RutaResultadoTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RutaResultadoTableTable> {
  $$RutaResultadoTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get secuenciaParadas => $composableBuilder(
    column: $table.secuenciaParadas,
    builder: (column) => column,
  );

  GeneratedColumn<double> get distanciaTotalKm => $composableBuilder(
    column: $table.distanciaTotalKm,
    builder: (column) => column,
  );

  GeneratedColumn<double> get tiempoTotalSegundos => $composableBuilder(
    column: $table.tiempoTotalSegundos,
    builder: (column) => column,
  );

  GeneratedColumn<String> get geometriaPolyline => $composableBuilder(
    column: $table.geometriaPolyline,
    builder: (column) => column,
  );

  $$EscenarioOptimizacionTableTableAnnotationComposer get escenarioId {
    final $$EscenarioOptimizacionTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.escenarioId,
          referencedTable: $db.escenarioOptimizacionTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EscenarioOptimizacionTableTableAnnotationComposer(
                $db: $db,
                $table: $db.escenarioOptimizacionTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$VehiculoTableTableAnnotationComposer get vehiculoId {
    final $$VehiculoTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehiculoId,
      referencedTable: $db.vehiculoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiculoTableTableAnnotationComposer(
            $db: $db,
            $table: $db.vehiculoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RutaResultadoTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RutaResultadoTableTable,
          RutaResultadoTableData,
          $$RutaResultadoTableTableFilterComposer,
          $$RutaResultadoTableTableOrderingComposer,
          $$RutaResultadoTableTableAnnotationComposer,
          $$RutaResultadoTableTableCreateCompanionBuilder,
          $$RutaResultadoTableTableUpdateCompanionBuilder,
          (RutaResultadoTableData, $$RutaResultadoTableTableReferences),
          RutaResultadoTableData,
          PrefetchHooks Function({bool escenarioId, bool vehiculoId})
        > {
  $$RutaResultadoTableTableTableManager(
    _$AppDatabase db,
    $RutaResultadoTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RutaResultadoTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RutaResultadoTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RutaResultadoTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> escenarioId = const Value.absent(),
                Value<int> vehiculoId = const Value.absent(),
                Value<String> secuenciaParadas = const Value.absent(),
                Value<double?> distanciaTotalKm = const Value.absent(),
                Value<double?> tiempoTotalSegundos = const Value.absent(),
                Value<String?> geometriaPolyline = const Value.absent(),
              }) => RutaResultadoTableCompanion(
                id: id,
                escenarioId: escenarioId,
                vehiculoId: vehiculoId,
                secuenciaParadas: secuenciaParadas,
                distanciaTotalKm: distanciaTotalKm,
                tiempoTotalSegundos: tiempoTotalSegundos,
                geometriaPolyline: geometriaPolyline,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int escenarioId,
                required int vehiculoId,
                required String secuenciaParadas,
                Value<double?> distanciaTotalKm = const Value.absent(),
                Value<double?> tiempoTotalSegundos = const Value.absent(),
                Value<String?> geometriaPolyline = const Value.absent(),
              }) => RutaResultadoTableCompanion.insert(
                id: id,
                escenarioId: escenarioId,
                vehiculoId: vehiculoId,
                secuenciaParadas: secuenciaParadas,
                distanciaTotalKm: distanciaTotalKm,
                tiempoTotalSegundos: tiempoTotalSegundos,
                geometriaPolyline: geometriaPolyline,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RutaResultadoTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({escenarioId = false, vehiculoId = false}) {
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
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.escenarioId,
                                referencedTable:
                                    $$RutaResultadoTableTableReferences
                                        ._escenarioIdTable(db),
                                referencedColumn:
                                    $$RutaResultadoTableTableReferences
                                        ._escenarioIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (vehiculoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.vehiculoId,
                                referencedTable:
                                    $$RutaResultadoTableTableReferences
                                        ._vehiculoIdTable(db),
                                referencedColumn:
                                    $$RutaResultadoTableTableReferences
                                        ._vehiculoIdTable(db)
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

typedef $$RutaResultadoTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RutaResultadoTableTable,
      RutaResultadoTableData,
      $$RutaResultadoTableTableFilterComposer,
      $$RutaResultadoTableTableOrderingComposer,
      $$RutaResultadoTableTableAnnotationComposer,
      $$RutaResultadoTableTableCreateCompanionBuilder,
      $$RutaResultadoTableTableUpdateCompanionBuilder,
      (RutaResultadoTableData, $$RutaResultadoTableTableReferences),
      RutaResultadoTableData,
      PrefetchHooks Function({bool escenarioId, bool vehiculoId})
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
  $$EscenarioOptimizacionTableTableTableManager
  get escenarioOptimizacionTable =>
      $$EscenarioOptimizacionTableTableTableManager(
        _db,
        _db.escenarioOptimizacionTable,
      );
  $$EscenarioPuntoTableTableTableManager get escenarioPuntoTable =>
      $$EscenarioPuntoTableTableTableManager(_db, _db.escenarioPuntoTable);
  $$EscenarioVehiculoTableTableTableManager get escenarioVehiculoTable =>
      $$EscenarioVehiculoTableTableTableManager(
        _db,
        _db.escenarioVehiculoTable,
      );
  $$RutaResultadoTableTableTableManager get rutaResultadoTable =>
      $$RutaResultadoTableTableTableManager(_db, _db.rutaResultadoTable);
  $$CacheOsrmTableTableTableManager get cacheOsrmTable =>
      $$CacheOsrmTableTableTableManager(_db, _db.cacheOsrmTable);
}
