// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CatalogoTarimasTable extends CatalogoTarimas
    with TableInfo<$CatalogoTarimasTable, CatalogoTarima> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogoTarimasTable(this.attachedDatabase, [this._alias]);
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
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _largoMmMeta = const VerificationMeta(
    'largoMm',
  );
  @override
  late final GeneratedColumn<int> largoMm = GeneratedColumn<int>(
    'largo_mm',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _anchoMmMeta = const VerificationMeta(
    'anchoMm',
  );
  @override
  late final GeneratedColumn<int> anchoMm = GeneratedColumn<int>(
    'ancho_mm',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _altoMmMeta = const VerificationMeta('altoMm');
  @override
  late final GeneratedColumn<int> altoMm = GeneratedColumn<int>(
    'alto_mm',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taraGMeta = const VerificationMeta('taraG');
  @override
  late final GeneratedColumn<int> taraG = GeneratedColumn<int>(
    'tara_g',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cargaDinGMeta = const VerificationMeta(
    'cargaDinG',
  );
  @override
  late final GeneratedColumn<int> cargaDinG = GeneratedColumn<int>(
    'carga_din_g',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cargaEstGMeta = const VerificationMeta(
    'cargaEstG',
  );
  @override
  late final GeneratedColumn<int> cargaEstG = GeneratedColumn<int>(
    'carga_est_g',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _regionMeta = const VerificationMeta('region');
  @override
  late final GeneratedColumn<String> region = GeneratedColumn<String>(
    'region',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _esSemillaMeta = const VerificationMeta(
    'esSemilla',
  );
  @override
  late final GeneratedColumn<bool> esSemilla = GeneratedColumn<bool>(
    'es_semilla',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("es_semilla" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    codigo,
    largoMm,
    anchoMm,
    altoMm,
    taraG,
    cargaDinG,
    cargaEstG,
    region,
    fuente,
    esSemilla,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalogo_tarimas';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatalogoTarima> instance, {
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
    if (data.containsKey('largo_mm')) {
      context.handle(
        _largoMmMeta,
        largoMm.isAcceptableOrUnknown(data['largo_mm']!, _largoMmMeta),
      );
    } else if (isInserting) {
      context.missing(_largoMmMeta);
    }
    if (data.containsKey('ancho_mm')) {
      context.handle(
        _anchoMmMeta,
        anchoMm.isAcceptableOrUnknown(data['ancho_mm']!, _anchoMmMeta),
      );
    } else if (isInserting) {
      context.missing(_anchoMmMeta);
    }
    if (data.containsKey('alto_mm')) {
      context.handle(
        _altoMmMeta,
        altoMm.isAcceptableOrUnknown(data['alto_mm']!, _altoMmMeta),
      );
    } else if (isInserting) {
      context.missing(_altoMmMeta);
    }
    if (data.containsKey('tara_g')) {
      context.handle(
        _taraGMeta,
        taraG.isAcceptableOrUnknown(data['tara_g']!, _taraGMeta),
      );
    } else if (isInserting) {
      context.missing(_taraGMeta);
    }
    if (data.containsKey('carga_din_g')) {
      context.handle(
        _cargaDinGMeta,
        cargaDinG.isAcceptableOrUnknown(data['carga_din_g']!, _cargaDinGMeta),
      );
    }
    if (data.containsKey('carga_est_g')) {
      context.handle(
        _cargaEstGMeta,
        cargaEstG.isAcceptableOrUnknown(data['carga_est_g']!, _cargaEstGMeta),
      );
    }
    if (data.containsKey('region')) {
      context.handle(
        _regionMeta,
        region.isAcceptableOrUnknown(data['region']!, _regionMeta),
      );
    }
    if (data.containsKey('fuente')) {
      context.handle(
        _fuenteMeta,
        fuente.isAcceptableOrUnknown(data['fuente']!, _fuenteMeta),
      );
    } else if (isInserting) {
      context.missing(_fuenteMeta);
    }
    if (data.containsKey('es_semilla')) {
      context.handle(
        _esSemillaMeta,
        esSemilla.isAcceptableOrUnknown(data['es_semilla']!, _esSemillaMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CatalogoTarima map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogoTarima(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      largoMm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}largo_mm'],
      )!,
      anchoMm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ancho_mm'],
      )!,
      altoMm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}alto_mm'],
      )!,
      taraG: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tara_g'],
      )!,
      cargaDinG: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}carga_din_g'],
      ),
      cargaEstG: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}carga_est_g'],
      ),
      region: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region'],
      ),
      fuente: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fuente'],
      )!,
      esSemilla: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}es_semilla'],
      )!,
    );
  }

  @override
  $CatalogoTarimasTable createAlias(String alias) {
    return $CatalogoTarimasTable(attachedDatabase, alias);
  }
}

class CatalogoTarima extends DataClass implements Insertable<CatalogoTarima> {
  final int id;
  final String codigo;
  final int largoMm;
  final int anchoMm;
  final int altoMm;
  final int taraG;
  final int? cargaDinG;
  final int? cargaEstG;
  final String? region;
  final String fuente;
  final bool esSemilla;
  const CatalogoTarima({
    required this.id,
    required this.codigo,
    required this.largoMm,
    required this.anchoMm,
    required this.altoMm,
    required this.taraG,
    this.cargaDinG,
    this.cargaEstG,
    this.region,
    required this.fuente,
    required this.esSemilla,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['codigo'] = Variable<String>(codigo);
    map['largo_mm'] = Variable<int>(largoMm);
    map['ancho_mm'] = Variable<int>(anchoMm);
    map['alto_mm'] = Variable<int>(altoMm);
    map['tara_g'] = Variable<int>(taraG);
    if (!nullToAbsent || cargaDinG != null) {
      map['carga_din_g'] = Variable<int>(cargaDinG);
    }
    if (!nullToAbsent || cargaEstG != null) {
      map['carga_est_g'] = Variable<int>(cargaEstG);
    }
    if (!nullToAbsent || region != null) {
      map['region'] = Variable<String>(region);
    }
    map['fuente'] = Variable<String>(fuente);
    map['es_semilla'] = Variable<bool>(esSemilla);
    return map;
  }

  CatalogoTarimasCompanion toCompanion(bool nullToAbsent) {
    return CatalogoTarimasCompanion(
      id: Value(id),
      codigo: Value(codigo),
      largoMm: Value(largoMm),
      anchoMm: Value(anchoMm),
      altoMm: Value(altoMm),
      taraG: Value(taraG),
      cargaDinG: cargaDinG == null && nullToAbsent
          ? const Value.absent()
          : Value(cargaDinG),
      cargaEstG: cargaEstG == null && nullToAbsent
          ? const Value.absent()
          : Value(cargaEstG),
      region: region == null && nullToAbsent
          ? const Value.absent()
          : Value(region),
      fuente: Value(fuente),
      esSemilla: Value(esSemilla),
    );
  }

  factory CatalogoTarima.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogoTarima(
      id: serializer.fromJson<int>(json['id']),
      codigo: serializer.fromJson<String>(json['codigo']),
      largoMm: serializer.fromJson<int>(json['largoMm']),
      anchoMm: serializer.fromJson<int>(json['anchoMm']),
      altoMm: serializer.fromJson<int>(json['altoMm']),
      taraG: serializer.fromJson<int>(json['taraG']),
      cargaDinG: serializer.fromJson<int?>(json['cargaDinG']),
      cargaEstG: serializer.fromJson<int?>(json['cargaEstG']),
      region: serializer.fromJson<String?>(json['region']),
      fuente: serializer.fromJson<String>(json['fuente']),
      esSemilla: serializer.fromJson<bool>(json['esSemilla']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'codigo': serializer.toJson<String>(codigo),
      'largoMm': serializer.toJson<int>(largoMm),
      'anchoMm': serializer.toJson<int>(anchoMm),
      'altoMm': serializer.toJson<int>(altoMm),
      'taraG': serializer.toJson<int>(taraG),
      'cargaDinG': serializer.toJson<int?>(cargaDinG),
      'cargaEstG': serializer.toJson<int?>(cargaEstG),
      'region': serializer.toJson<String?>(region),
      'fuente': serializer.toJson<String>(fuente),
      'esSemilla': serializer.toJson<bool>(esSemilla),
    };
  }

  CatalogoTarima copyWith({
    int? id,
    String? codigo,
    int? largoMm,
    int? anchoMm,
    int? altoMm,
    int? taraG,
    Value<int?> cargaDinG = const Value.absent(),
    Value<int?> cargaEstG = const Value.absent(),
    Value<String?> region = const Value.absent(),
    String? fuente,
    bool? esSemilla,
  }) => CatalogoTarima(
    id: id ?? this.id,
    codigo: codigo ?? this.codigo,
    largoMm: largoMm ?? this.largoMm,
    anchoMm: anchoMm ?? this.anchoMm,
    altoMm: altoMm ?? this.altoMm,
    taraG: taraG ?? this.taraG,
    cargaDinG: cargaDinG.present ? cargaDinG.value : this.cargaDinG,
    cargaEstG: cargaEstG.present ? cargaEstG.value : this.cargaEstG,
    region: region.present ? region.value : this.region,
    fuente: fuente ?? this.fuente,
    esSemilla: esSemilla ?? this.esSemilla,
  );
  CatalogoTarima copyWithCompanion(CatalogoTarimasCompanion data) {
    return CatalogoTarima(
      id: data.id.present ? data.id.value : this.id,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      largoMm: data.largoMm.present ? data.largoMm.value : this.largoMm,
      anchoMm: data.anchoMm.present ? data.anchoMm.value : this.anchoMm,
      altoMm: data.altoMm.present ? data.altoMm.value : this.altoMm,
      taraG: data.taraG.present ? data.taraG.value : this.taraG,
      cargaDinG: data.cargaDinG.present ? data.cargaDinG.value : this.cargaDinG,
      cargaEstG: data.cargaEstG.present ? data.cargaEstG.value : this.cargaEstG,
      region: data.region.present ? data.region.value : this.region,
      fuente: data.fuente.present ? data.fuente.value : this.fuente,
      esSemilla: data.esSemilla.present ? data.esSemilla.value : this.esSemilla,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogoTarima(')
          ..write('id: $id, ')
          ..write('codigo: $codigo, ')
          ..write('largoMm: $largoMm, ')
          ..write('anchoMm: $anchoMm, ')
          ..write('altoMm: $altoMm, ')
          ..write('taraG: $taraG, ')
          ..write('cargaDinG: $cargaDinG, ')
          ..write('cargaEstG: $cargaEstG, ')
          ..write('region: $region, ')
          ..write('fuente: $fuente, ')
          ..write('esSemilla: $esSemilla')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    codigo,
    largoMm,
    anchoMm,
    altoMm,
    taraG,
    cargaDinG,
    cargaEstG,
    region,
    fuente,
    esSemilla,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogoTarima &&
          other.id == this.id &&
          other.codigo == this.codigo &&
          other.largoMm == this.largoMm &&
          other.anchoMm == this.anchoMm &&
          other.altoMm == this.altoMm &&
          other.taraG == this.taraG &&
          other.cargaDinG == this.cargaDinG &&
          other.cargaEstG == this.cargaEstG &&
          other.region == this.region &&
          other.fuente == this.fuente &&
          other.esSemilla == this.esSemilla);
}

class CatalogoTarimasCompanion extends UpdateCompanion<CatalogoTarima> {
  final Value<int> id;
  final Value<String> codigo;
  final Value<int> largoMm;
  final Value<int> anchoMm;
  final Value<int> altoMm;
  final Value<int> taraG;
  final Value<int?> cargaDinG;
  final Value<int?> cargaEstG;
  final Value<String?> region;
  final Value<String> fuente;
  final Value<bool> esSemilla;
  const CatalogoTarimasCompanion({
    this.id = const Value.absent(),
    this.codigo = const Value.absent(),
    this.largoMm = const Value.absent(),
    this.anchoMm = const Value.absent(),
    this.altoMm = const Value.absent(),
    this.taraG = const Value.absent(),
    this.cargaDinG = const Value.absent(),
    this.cargaEstG = const Value.absent(),
    this.region = const Value.absent(),
    this.fuente = const Value.absent(),
    this.esSemilla = const Value.absent(),
  });
  CatalogoTarimasCompanion.insert({
    this.id = const Value.absent(),
    required String codigo,
    required int largoMm,
    required int anchoMm,
    required int altoMm,
    required int taraG,
    this.cargaDinG = const Value.absent(),
    this.cargaEstG = const Value.absent(),
    this.region = const Value.absent(),
    required String fuente,
    this.esSemilla = const Value.absent(),
  }) : codigo = Value(codigo),
       largoMm = Value(largoMm),
       anchoMm = Value(anchoMm),
       altoMm = Value(altoMm),
       taraG = Value(taraG),
       fuente = Value(fuente);
  static Insertable<CatalogoTarima> custom({
    Expression<int>? id,
    Expression<String>? codigo,
    Expression<int>? largoMm,
    Expression<int>? anchoMm,
    Expression<int>? altoMm,
    Expression<int>? taraG,
    Expression<int>? cargaDinG,
    Expression<int>? cargaEstG,
    Expression<String>? region,
    Expression<String>? fuente,
    Expression<bool>? esSemilla,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (codigo != null) 'codigo': codigo,
      if (largoMm != null) 'largo_mm': largoMm,
      if (anchoMm != null) 'ancho_mm': anchoMm,
      if (altoMm != null) 'alto_mm': altoMm,
      if (taraG != null) 'tara_g': taraG,
      if (cargaDinG != null) 'carga_din_g': cargaDinG,
      if (cargaEstG != null) 'carga_est_g': cargaEstG,
      if (region != null) 'region': region,
      if (fuente != null) 'fuente': fuente,
      if (esSemilla != null) 'es_semilla': esSemilla,
    });
  }

  CatalogoTarimasCompanion copyWith({
    Value<int>? id,
    Value<String>? codigo,
    Value<int>? largoMm,
    Value<int>? anchoMm,
    Value<int>? altoMm,
    Value<int>? taraG,
    Value<int?>? cargaDinG,
    Value<int?>? cargaEstG,
    Value<String?>? region,
    Value<String>? fuente,
    Value<bool>? esSemilla,
  }) {
    return CatalogoTarimasCompanion(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      largoMm: largoMm ?? this.largoMm,
      anchoMm: anchoMm ?? this.anchoMm,
      altoMm: altoMm ?? this.altoMm,
      taraG: taraG ?? this.taraG,
      cargaDinG: cargaDinG ?? this.cargaDinG,
      cargaEstG: cargaEstG ?? this.cargaEstG,
      region: region ?? this.region,
      fuente: fuente ?? this.fuente,
      esSemilla: esSemilla ?? this.esSemilla,
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
    if (largoMm.present) {
      map['largo_mm'] = Variable<int>(largoMm.value);
    }
    if (anchoMm.present) {
      map['ancho_mm'] = Variable<int>(anchoMm.value);
    }
    if (altoMm.present) {
      map['alto_mm'] = Variable<int>(altoMm.value);
    }
    if (taraG.present) {
      map['tara_g'] = Variable<int>(taraG.value);
    }
    if (cargaDinG.present) {
      map['carga_din_g'] = Variable<int>(cargaDinG.value);
    }
    if (cargaEstG.present) {
      map['carga_est_g'] = Variable<int>(cargaEstG.value);
    }
    if (region.present) {
      map['region'] = Variable<String>(region.value);
    }
    if (fuente.present) {
      map['fuente'] = Variable<String>(fuente.value);
    }
    if (esSemilla.present) {
      map['es_semilla'] = Variable<bool>(esSemilla.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogoTarimasCompanion(')
          ..write('id: $id, ')
          ..write('codigo: $codigo, ')
          ..write('largoMm: $largoMm, ')
          ..write('anchoMm: $anchoMm, ')
          ..write('altoMm: $altoMm, ')
          ..write('taraG: $taraG, ')
          ..write('cargaDinG: $cargaDinG, ')
          ..write('cargaEstG: $cargaEstG, ')
          ..write('region: $region, ')
          ..write('fuente: $fuente, ')
          ..write('esSemilla: $esSemilla')
          ..write(')'))
        .toString();
  }
}

class $CatalogoBastidoresTable extends CatalogoBastidores
    with TableInfo<$CatalogoBastidoresTable, CatalogoBastidore> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogoBastidoresTable(this.attachedDatabase, [this._alias]);
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
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _fondoMmMeta = const VerificationMeta(
    'fondoMm',
  );
  @override
  late final GeneratedColumn<int> fondoMm = GeneratedColumn<int>(
    'fondo_mm',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _alturaMmMeta = const VerificationMeta(
    'alturaMm',
  );
  @override
  late final GeneratedColumn<int> alturaMm = GeneratedColumn<int>(
    'altura_mm',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _perfilAnchoMmMeta = const VerificationMeta(
    'perfilAnchoMm',
  );
  @override
  late final GeneratedColumn<int> perfilAnchoMm = GeneratedColumn<int>(
    'perfil_ancho_mm',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _perfilFondoMmMeta = const VerificationMeta(
    'perfilFondoMm',
  );
  @override
  late final GeneratedColumn<int> perfilFondoMm = GeneratedColumn<int>(
    'perfil_fondo_mm',
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
  static const VerificationMeta _esSemillaMeta = const VerificationMeta(
    'esSemilla',
  );
  @override
  late final GeneratedColumn<bool> esSemilla = GeneratedColumn<bool>(
    'es_semilla',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("es_semilla" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    codigo,
    fondoMm,
    alturaMm,
    perfilAnchoMm,
    perfilFondoMm,
    fuente,
    esSemilla,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalogo_bastidores';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatalogoBastidore> instance, {
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
    if (data.containsKey('fondo_mm')) {
      context.handle(
        _fondoMmMeta,
        fondoMm.isAcceptableOrUnknown(data['fondo_mm']!, _fondoMmMeta),
      );
    } else if (isInserting) {
      context.missing(_fondoMmMeta);
    }
    if (data.containsKey('altura_mm')) {
      context.handle(
        _alturaMmMeta,
        alturaMm.isAcceptableOrUnknown(data['altura_mm']!, _alturaMmMeta),
      );
    } else if (isInserting) {
      context.missing(_alturaMmMeta);
    }
    if (data.containsKey('perfil_ancho_mm')) {
      context.handle(
        _perfilAnchoMmMeta,
        perfilAnchoMm.isAcceptableOrUnknown(
          data['perfil_ancho_mm']!,
          _perfilAnchoMmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_perfilAnchoMmMeta);
    }
    if (data.containsKey('perfil_fondo_mm')) {
      context.handle(
        _perfilFondoMmMeta,
        perfilFondoMm.isAcceptableOrUnknown(
          data['perfil_fondo_mm']!,
          _perfilFondoMmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_perfilFondoMmMeta);
    }
    if (data.containsKey('fuente')) {
      context.handle(
        _fuenteMeta,
        fuente.isAcceptableOrUnknown(data['fuente']!, _fuenteMeta),
      );
    } else if (isInserting) {
      context.missing(_fuenteMeta);
    }
    if (data.containsKey('es_semilla')) {
      context.handle(
        _esSemillaMeta,
        esSemilla.isAcceptableOrUnknown(data['es_semilla']!, _esSemillaMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CatalogoBastidore map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogoBastidore(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      fondoMm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fondo_mm'],
      )!,
      alturaMm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}altura_mm'],
      )!,
      perfilAnchoMm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}perfil_ancho_mm'],
      )!,
      perfilFondoMm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}perfil_fondo_mm'],
      )!,
      fuente: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fuente'],
      )!,
      esSemilla: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}es_semilla'],
      )!,
    );
  }

  @override
  $CatalogoBastidoresTable createAlias(String alias) {
    return $CatalogoBastidoresTable(attachedDatabase, alias);
  }
}

class CatalogoBastidore extends DataClass
    implements Insertable<CatalogoBastidore> {
  final int id;
  final String codigo;
  final int fondoMm;
  final int alturaMm;
  final int perfilAnchoMm;
  final int perfilFondoMm;
  final String fuente;
  final bool esSemilla;
  const CatalogoBastidore({
    required this.id,
    required this.codigo,
    required this.fondoMm,
    required this.alturaMm,
    required this.perfilAnchoMm,
    required this.perfilFondoMm,
    required this.fuente,
    required this.esSemilla,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['codigo'] = Variable<String>(codigo);
    map['fondo_mm'] = Variable<int>(fondoMm);
    map['altura_mm'] = Variable<int>(alturaMm);
    map['perfil_ancho_mm'] = Variable<int>(perfilAnchoMm);
    map['perfil_fondo_mm'] = Variable<int>(perfilFondoMm);
    map['fuente'] = Variable<String>(fuente);
    map['es_semilla'] = Variable<bool>(esSemilla);
    return map;
  }

  CatalogoBastidoresCompanion toCompanion(bool nullToAbsent) {
    return CatalogoBastidoresCompanion(
      id: Value(id),
      codigo: Value(codigo),
      fondoMm: Value(fondoMm),
      alturaMm: Value(alturaMm),
      perfilAnchoMm: Value(perfilAnchoMm),
      perfilFondoMm: Value(perfilFondoMm),
      fuente: Value(fuente),
      esSemilla: Value(esSemilla),
    );
  }

  factory CatalogoBastidore.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogoBastidore(
      id: serializer.fromJson<int>(json['id']),
      codigo: serializer.fromJson<String>(json['codigo']),
      fondoMm: serializer.fromJson<int>(json['fondoMm']),
      alturaMm: serializer.fromJson<int>(json['alturaMm']),
      perfilAnchoMm: serializer.fromJson<int>(json['perfilAnchoMm']),
      perfilFondoMm: serializer.fromJson<int>(json['perfilFondoMm']),
      fuente: serializer.fromJson<String>(json['fuente']),
      esSemilla: serializer.fromJson<bool>(json['esSemilla']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'codigo': serializer.toJson<String>(codigo),
      'fondoMm': serializer.toJson<int>(fondoMm),
      'alturaMm': serializer.toJson<int>(alturaMm),
      'perfilAnchoMm': serializer.toJson<int>(perfilAnchoMm),
      'perfilFondoMm': serializer.toJson<int>(perfilFondoMm),
      'fuente': serializer.toJson<String>(fuente),
      'esSemilla': serializer.toJson<bool>(esSemilla),
    };
  }

  CatalogoBastidore copyWith({
    int? id,
    String? codigo,
    int? fondoMm,
    int? alturaMm,
    int? perfilAnchoMm,
    int? perfilFondoMm,
    String? fuente,
    bool? esSemilla,
  }) => CatalogoBastidore(
    id: id ?? this.id,
    codigo: codigo ?? this.codigo,
    fondoMm: fondoMm ?? this.fondoMm,
    alturaMm: alturaMm ?? this.alturaMm,
    perfilAnchoMm: perfilAnchoMm ?? this.perfilAnchoMm,
    perfilFondoMm: perfilFondoMm ?? this.perfilFondoMm,
    fuente: fuente ?? this.fuente,
    esSemilla: esSemilla ?? this.esSemilla,
  );
  CatalogoBastidore copyWithCompanion(CatalogoBastidoresCompanion data) {
    return CatalogoBastidore(
      id: data.id.present ? data.id.value : this.id,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      fondoMm: data.fondoMm.present ? data.fondoMm.value : this.fondoMm,
      alturaMm: data.alturaMm.present ? data.alturaMm.value : this.alturaMm,
      perfilAnchoMm: data.perfilAnchoMm.present
          ? data.perfilAnchoMm.value
          : this.perfilAnchoMm,
      perfilFondoMm: data.perfilFondoMm.present
          ? data.perfilFondoMm.value
          : this.perfilFondoMm,
      fuente: data.fuente.present ? data.fuente.value : this.fuente,
      esSemilla: data.esSemilla.present ? data.esSemilla.value : this.esSemilla,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogoBastidore(')
          ..write('id: $id, ')
          ..write('codigo: $codigo, ')
          ..write('fondoMm: $fondoMm, ')
          ..write('alturaMm: $alturaMm, ')
          ..write('perfilAnchoMm: $perfilAnchoMm, ')
          ..write('perfilFondoMm: $perfilFondoMm, ')
          ..write('fuente: $fuente, ')
          ..write('esSemilla: $esSemilla')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    codigo,
    fondoMm,
    alturaMm,
    perfilAnchoMm,
    perfilFondoMm,
    fuente,
    esSemilla,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogoBastidore &&
          other.id == this.id &&
          other.codigo == this.codigo &&
          other.fondoMm == this.fondoMm &&
          other.alturaMm == this.alturaMm &&
          other.perfilAnchoMm == this.perfilAnchoMm &&
          other.perfilFondoMm == this.perfilFondoMm &&
          other.fuente == this.fuente &&
          other.esSemilla == this.esSemilla);
}

class CatalogoBastidoresCompanion extends UpdateCompanion<CatalogoBastidore> {
  final Value<int> id;
  final Value<String> codigo;
  final Value<int> fondoMm;
  final Value<int> alturaMm;
  final Value<int> perfilAnchoMm;
  final Value<int> perfilFondoMm;
  final Value<String> fuente;
  final Value<bool> esSemilla;
  const CatalogoBastidoresCompanion({
    this.id = const Value.absent(),
    this.codigo = const Value.absent(),
    this.fondoMm = const Value.absent(),
    this.alturaMm = const Value.absent(),
    this.perfilAnchoMm = const Value.absent(),
    this.perfilFondoMm = const Value.absent(),
    this.fuente = const Value.absent(),
    this.esSemilla = const Value.absent(),
  });
  CatalogoBastidoresCompanion.insert({
    this.id = const Value.absent(),
    required String codigo,
    required int fondoMm,
    required int alturaMm,
    required int perfilAnchoMm,
    required int perfilFondoMm,
    required String fuente,
    this.esSemilla = const Value.absent(),
  }) : codigo = Value(codigo),
       fondoMm = Value(fondoMm),
       alturaMm = Value(alturaMm),
       perfilAnchoMm = Value(perfilAnchoMm),
       perfilFondoMm = Value(perfilFondoMm),
       fuente = Value(fuente);
  static Insertable<CatalogoBastidore> custom({
    Expression<int>? id,
    Expression<String>? codigo,
    Expression<int>? fondoMm,
    Expression<int>? alturaMm,
    Expression<int>? perfilAnchoMm,
    Expression<int>? perfilFondoMm,
    Expression<String>? fuente,
    Expression<bool>? esSemilla,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (codigo != null) 'codigo': codigo,
      if (fondoMm != null) 'fondo_mm': fondoMm,
      if (alturaMm != null) 'altura_mm': alturaMm,
      if (perfilAnchoMm != null) 'perfil_ancho_mm': perfilAnchoMm,
      if (perfilFondoMm != null) 'perfil_fondo_mm': perfilFondoMm,
      if (fuente != null) 'fuente': fuente,
      if (esSemilla != null) 'es_semilla': esSemilla,
    });
  }

  CatalogoBastidoresCompanion copyWith({
    Value<int>? id,
    Value<String>? codigo,
    Value<int>? fondoMm,
    Value<int>? alturaMm,
    Value<int>? perfilAnchoMm,
    Value<int>? perfilFondoMm,
    Value<String>? fuente,
    Value<bool>? esSemilla,
  }) {
    return CatalogoBastidoresCompanion(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      fondoMm: fondoMm ?? this.fondoMm,
      alturaMm: alturaMm ?? this.alturaMm,
      perfilAnchoMm: perfilAnchoMm ?? this.perfilAnchoMm,
      perfilFondoMm: perfilFondoMm ?? this.perfilFondoMm,
      fuente: fuente ?? this.fuente,
      esSemilla: esSemilla ?? this.esSemilla,
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
    if (fondoMm.present) {
      map['fondo_mm'] = Variable<int>(fondoMm.value);
    }
    if (alturaMm.present) {
      map['altura_mm'] = Variable<int>(alturaMm.value);
    }
    if (perfilAnchoMm.present) {
      map['perfil_ancho_mm'] = Variable<int>(perfilAnchoMm.value);
    }
    if (perfilFondoMm.present) {
      map['perfil_fondo_mm'] = Variable<int>(perfilFondoMm.value);
    }
    if (fuente.present) {
      map['fuente'] = Variable<String>(fuente.value);
    }
    if (esSemilla.present) {
      map['es_semilla'] = Variable<bool>(esSemilla.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogoBastidoresCompanion(')
          ..write('id: $id, ')
          ..write('codigo: $codigo, ')
          ..write('fondoMm: $fondoMm, ')
          ..write('alturaMm: $alturaMm, ')
          ..write('perfilAnchoMm: $perfilAnchoMm, ')
          ..write('perfilFondoMm: $perfilFondoMm, ')
          ..write('fuente: $fuente, ')
          ..write('esSemilla: $esSemilla')
          ..write(')'))
        .toString();
  }
}

class $CatalogoVigasTable extends CatalogoVigas
    with TableInfo<$CatalogoVigasTable, CatalogoViga> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogoVigasTable(this.attachedDatabase, [this._alias]);
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
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _largoMmMeta = const VerificationMeta(
    'largoMm',
  );
  @override
  late final GeneratedColumn<int> largoMm = GeneratedColumn<int>(
    'largo_mm',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _peralteMmMeta = const VerificationMeta(
    'peralteMm',
  );
  @override
  late final GeneratedColumn<int> peralteMm = GeneratedColumn<int>(
    'peralte_mm',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _capacidadParGMeta = const VerificationMeta(
    'capacidadParG',
  );
  @override
  late final GeneratedColumn<int> capacidadParG = GeneratedColumn<int>(
    'capacidad_par_g',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
  static const VerificationMeta _esSemillaMeta = const VerificationMeta(
    'esSemilla',
  );
  @override
  late final GeneratedColumn<bool> esSemilla = GeneratedColumn<bool>(
    'es_semilla',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("es_semilla" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    codigo,
    largoMm,
    peralteMm,
    capacidadParG,
    fuente,
    esSemilla,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalogo_vigas';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatalogoViga> instance, {
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
    if (data.containsKey('largo_mm')) {
      context.handle(
        _largoMmMeta,
        largoMm.isAcceptableOrUnknown(data['largo_mm']!, _largoMmMeta),
      );
    } else if (isInserting) {
      context.missing(_largoMmMeta);
    }
    if (data.containsKey('peralte_mm')) {
      context.handle(
        _peralteMmMeta,
        peralteMm.isAcceptableOrUnknown(data['peralte_mm']!, _peralteMmMeta),
      );
    } else if (isInserting) {
      context.missing(_peralteMmMeta);
    }
    if (data.containsKey('capacidad_par_g')) {
      context.handle(
        _capacidadParGMeta,
        capacidadParG.isAcceptableOrUnknown(
          data['capacidad_par_g']!,
          _capacidadParGMeta,
        ),
      );
    }
    if (data.containsKey('fuente')) {
      context.handle(
        _fuenteMeta,
        fuente.isAcceptableOrUnknown(data['fuente']!, _fuenteMeta),
      );
    } else if (isInserting) {
      context.missing(_fuenteMeta);
    }
    if (data.containsKey('es_semilla')) {
      context.handle(
        _esSemillaMeta,
        esSemilla.isAcceptableOrUnknown(data['es_semilla']!, _esSemillaMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CatalogoViga map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogoViga(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      largoMm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}largo_mm'],
      )!,
      peralteMm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}peralte_mm'],
      )!,
      capacidadParG: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}capacidad_par_g'],
      ),
      fuente: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fuente'],
      )!,
      esSemilla: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}es_semilla'],
      )!,
    );
  }

  @override
  $CatalogoVigasTable createAlias(String alias) {
    return $CatalogoVigasTable(attachedDatabase, alias);
  }
}

class CatalogoViga extends DataClass implements Insertable<CatalogoViga> {
  final int id;
  final String codigo;
  final int largoMm;
  final int peralteMm;
  final int? capacidadParG;
  final String fuente;
  final bool esSemilla;
  const CatalogoViga({
    required this.id,
    required this.codigo,
    required this.largoMm,
    required this.peralteMm,
    this.capacidadParG,
    required this.fuente,
    required this.esSemilla,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['codigo'] = Variable<String>(codigo);
    map['largo_mm'] = Variable<int>(largoMm);
    map['peralte_mm'] = Variable<int>(peralteMm);
    if (!nullToAbsent || capacidadParG != null) {
      map['capacidad_par_g'] = Variable<int>(capacidadParG);
    }
    map['fuente'] = Variable<String>(fuente);
    map['es_semilla'] = Variable<bool>(esSemilla);
    return map;
  }

  CatalogoVigasCompanion toCompanion(bool nullToAbsent) {
    return CatalogoVigasCompanion(
      id: Value(id),
      codigo: Value(codigo),
      largoMm: Value(largoMm),
      peralteMm: Value(peralteMm),
      capacidadParG: capacidadParG == null && nullToAbsent
          ? const Value.absent()
          : Value(capacidadParG),
      fuente: Value(fuente),
      esSemilla: Value(esSemilla),
    );
  }

  factory CatalogoViga.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogoViga(
      id: serializer.fromJson<int>(json['id']),
      codigo: serializer.fromJson<String>(json['codigo']),
      largoMm: serializer.fromJson<int>(json['largoMm']),
      peralteMm: serializer.fromJson<int>(json['peralteMm']),
      capacidadParG: serializer.fromJson<int?>(json['capacidadParG']),
      fuente: serializer.fromJson<String>(json['fuente']),
      esSemilla: serializer.fromJson<bool>(json['esSemilla']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'codigo': serializer.toJson<String>(codigo),
      'largoMm': serializer.toJson<int>(largoMm),
      'peralteMm': serializer.toJson<int>(peralteMm),
      'capacidadParG': serializer.toJson<int?>(capacidadParG),
      'fuente': serializer.toJson<String>(fuente),
      'esSemilla': serializer.toJson<bool>(esSemilla),
    };
  }

  CatalogoViga copyWith({
    int? id,
    String? codigo,
    int? largoMm,
    int? peralteMm,
    Value<int?> capacidadParG = const Value.absent(),
    String? fuente,
    bool? esSemilla,
  }) => CatalogoViga(
    id: id ?? this.id,
    codigo: codigo ?? this.codigo,
    largoMm: largoMm ?? this.largoMm,
    peralteMm: peralteMm ?? this.peralteMm,
    capacidadParG: capacidadParG.present
        ? capacidadParG.value
        : this.capacidadParG,
    fuente: fuente ?? this.fuente,
    esSemilla: esSemilla ?? this.esSemilla,
  );
  CatalogoViga copyWithCompanion(CatalogoVigasCompanion data) {
    return CatalogoViga(
      id: data.id.present ? data.id.value : this.id,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      largoMm: data.largoMm.present ? data.largoMm.value : this.largoMm,
      peralteMm: data.peralteMm.present ? data.peralteMm.value : this.peralteMm,
      capacidadParG: data.capacidadParG.present
          ? data.capacidadParG.value
          : this.capacidadParG,
      fuente: data.fuente.present ? data.fuente.value : this.fuente,
      esSemilla: data.esSemilla.present ? data.esSemilla.value : this.esSemilla,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogoViga(')
          ..write('id: $id, ')
          ..write('codigo: $codigo, ')
          ..write('largoMm: $largoMm, ')
          ..write('peralteMm: $peralteMm, ')
          ..write('capacidadParG: $capacidadParG, ')
          ..write('fuente: $fuente, ')
          ..write('esSemilla: $esSemilla')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    codigo,
    largoMm,
    peralteMm,
    capacidadParG,
    fuente,
    esSemilla,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogoViga &&
          other.id == this.id &&
          other.codigo == this.codigo &&
          other.largoMm == this.largoMm &&
          other.peralteMm == this.peralteMm &&
          other.capacidadParG == this.capacidadParG &&
          other.fuente == this.fuente &&
          other.esSemilla == this.esSemilla);
}

class CatalogoVigasCompanion extends UpdateCompanion<CatalogoViga> {
  final Value<int> id;
  final Value<String> codigo;
  final Value<int> largoMm;
  final Value<int> peralteMm;
  final Value<int?> capacidadParG;
  final Value<String> fuente;
  final Value<bool> esSemilla;
  const CatalogoVigasCompanion({
    this.id = const Value.absent(),
    this.codigo = const Value.absent(),
    this.largoMm = const Value.absent(),
    this.peralteMm = const Value.absent(),
    this.capacidadParG = const Value.absent(),
    this.fuente = const Value.absent(),
    this.esSemilla = const Value.absent(),
  });
  CatalogoVigasCompanion.insert({
    this.id = const Value.absent(),
    required String codigo,
    required int largoMm,
    required int peralteMm,
    this.capacidadParG = const Value.absent(),
    required String fuente,
    this.esSemilla = const Value.absent(),
  }) : codigo = Value(codigo),
       largoMm = Value(largoMm),
       peralteMm = Value(peralteMm),
       fuente = Value(fuente);
  static Insertable<CatalogoViga> custom({
    Expression<int>? id,
    Expression<String>? codigo,
    Expression<int>? largoMm,
    Expression<int>? peralteMm,
    Expression<int>? capacidadParG,
    Expression<String>? fuente,
    Expression<bool>? esSemilla,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (codigo != null) 'codigo': codigo,
      if (largoMm != null) 'largo_mm': largoMm,
      if (peralteMm != null) 'peralte_mm': peralteMm,
      if (capacidadParG != null) 'capacidad_par_g': capacidadParG,
      if (fuente != null) 'fuente': fuente,
      if (esSemilla != null) 'es_semilla': esSemilla,
    });
  }

  CatalogoVigasCompanion copyWith({
    Value<int>? id,
    Value<String>? codigo,
    Value<int>? largoMm,
    Value<int>? peralteMm,
    Value<int?>? capacidadParG,
    Value<String>? fuente,
    Value<bool>? esSemilla,
  }) {
    return CatalogoVigasCompanion(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      largoMm: largoMm ?? this.largoMm,
      peralteMm: peralteMm ?? this.peralteMm,
      capacidadParG: capacidadParG ?? this.capacidadParG,
      fuente: fuente ?? this.fuente,
      esSemilla: esSemilla ?? this.esSemilla,
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
    if (largoMm.present) {
      map['largo_mm'] = Variable<int>(largoMm.value);
    }
    if (peralteMm.present) {
      map['peralte_mm'] = Variable<int>(peralteMm.value);
    }
    if (capacidadParG.present) {
      map['capacidad_par_g'] = Variable<int>(capacidadParG.value);
    }
    if (fuente.present) {
      map['fuente'] = Variable<String>(fuente.value);
    }
    if (esSemilla.present) {
      map['es_semilla'] = Variable<bool>(esSemilla.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogoVigasCompanion(')
          ..write('id: $id, ')
          ..write('codigo: $codigo, ')
          ..write('largoMm: $largoMm, ')
          ..write('peralteMm: $peralteMm, ')
          ..write('capacidadParG: $capacidadParG, ')
          ..write('fuente: $fuente, ')
          ..write('esSemilla: $esSemilla')
          ..write(')'))
        .toString();
  }
}

class $CatalogoEquiposTable extends CatalogoEquipos
    with TableInfo<$CatalogoEquiposTable, CatalogoEquipo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogoEquiposTable(this.attachedDatabase, [this._alias]);
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
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
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
  static const VerificationMeta _claseEnMeta = const VerificationMeta(
    'claseEn',
  );
  @override
  late final GeneratedColumn<String> claseEn = GeneratedColumn<String>(
    'clase_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pasilloMinMmMeta = const VerificationMeta(
    'pasilloMinMm',
  );
  @override
  late final GeneratedColumn<int> pasilloMinMm = GeneratedColumn<int>(
    'pasillo_min_mm',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pasilloMaxMmMeta = const VerificationMeta(
    'pasilloMaxMm',
  );
  @override
  late final GeneratedColumn<int> pasilloMaxMm = GeneratedColumn<int>(
    'pasillo_max_mm',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _elevacionMaxMmMeta = const VerificationMeta(
    'elevacionMaxMm',
  );
  @override
  late final GeneratedColumn<int> elevacionMaxMm = GeneratedColumn<int>(
    'elevacion_max_mm',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _alturaMastilMmMeta = const VerificationMeta(
    'alturaMastilMm',
  );
  @override
  late final GeneratedColumn<int> alturaMastilMm = GeneratedColumn<int>(
    'altura_mastil_mm',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _requiereGuiadoMeta = const VerificationMeta(
    'requiereGuiado',
  );
  @override
  late final GeneratedColumn<bool> requiereGuiado = GeneratedColumn<bool>(
    'requiere_guiado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("requiere_guiado" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _costoUnitarioCentMeta = const VerificationMeta(
    'costoUnitarioCent',
  );
  @override
  late final GeneratedColumn<int> costoUnitarioCent = GeneratedColumn<int>(
    'costo_unitario_cent',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
  static const VerificationMeta _esSemillaMeta = const VerificationMeta(
    'esSemilla',
  );
  @override
  late final GeneratedColumn<bool> esSemilla = GeneratedColumn<bool>(
    'es_semilla',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("es_semilla" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    codigo,
    tipo,
    claseEn,
    pasilloMinMm,
    pasilloMaxMm,
    elevacionMaxMm,
    alturaMastilMm,
    requiereGuiado,
    costoUnitarioCent,
    fuente,
    esSemilla,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalogo_equipos';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatalogoEquipo> instance, {
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
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('clase_en')) {
      context.handle(
        _claseEnMeta,
        claseEn.isAcceptableOrUnknown(data['clase_en']!, _claseEnMeta),
      );
    }
    if (data.containsKey('pasillo_min_mm')) {
      context.handle(
        _pasilloMinMmMeta,
        pasilloMinMm.isAcceptableOrUnknown(
          data['pasillo_min_mm']!,
          _pasilloMinMmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pasilloMinMmMeta);
    }
    if (data.containsKey('pasillo_max_mm')) {
      context.handle(
        _pasilloMaxMmMeta,
        pasilloMaxMm.isAcceptableOrUnknown(
          data['pasillo_max_mm']!,
          _pasilloMaxMmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pasilloMaxMmMeta);
    }
    if (data.containsKey('elevacion_max_mm')) {
      context.handle(
        _elevacionMaxMmMeta,
        elevacionMaxMm.isAcceptableOrUnknown(
          data['elevacion_max_mm']!,
          _elevacionMaxMmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_elevacionMaxMmMeta);
    }
    if (data.containsKey('altura_mastil_mm')) {
      context.handle(
        _alturaMastilMmMeta,
        alturaMastilMm.isAcceptableOrUnknown(
          data['altura_mastil_mm']!,
          _alturaMastilMmMeta,
        ),
      );
    }
    if (data.containsKey('requiere_guiado')) {
      context.handle(
        _requiereGuiadoMeta,
        requiereGuiado.isAcceptableOrUnknown(
          data['requiere_guiado']!,
          _requiereGuiadoMeta,
        ),
      );
    }
    if (data.containsKey('costo_unitario_cent')) {
      context.handle(
        _costoUnitarioCentMeta,
        costoUnitarioCent.isAcceptableOrUnknown(
          data['costo_unitario_cent']!,
          _costoUnitarioCentMeta,
        ),
      );
    }
    if (data.containsKey('fuente')) {
      context.handle(
        _fuenteMeta,
        fuente.isAcceptableOrUnknown(data['fuente']!, _fuenteMeta),
      );
    } else if (isInserting) {
      context.missing(_fuenteMeta);
    }
    if (data.containsKey('es_semilla')) {
      context.handle(
        _esSemillaMeta,
        esSemilla.isAcceptableOrUnknown(data['es_semilla']!, _esSemillaMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CatalogoEquipo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogoEquipo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      claseEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}clase_en'],
      ),
      pasilloMinMm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pasillo_min_mm'],
      )!,
      pasilloMaxMm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pasillo_max_mm'],
      )!,
      elevacionMaxMm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}elevacion_max_mm'],
      )!,
      alturaMastilMm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}altura_mastil_mm'],
      ),
      requiereGuiado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}requiere_guiado'],
      )!,
      costoUnitarioCent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}costo_unitario_cent'],
      ),
      fuente: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fuente'],
      )!,
      esSemilla: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}es_semilla'],
      )!,
    );
  }

  @override
  $CatalogoEquiposTable createAlias(String alias) {
    return $CatalogoEquiposTable(attachedDatabase, alias);
  }
}

class CatalogoEquipo extends DataClass implements Insertable<CatalogoEquipo> {
  final int id;
  final String codigo;
  final String tipo;
  final String? claseEn;
  final int pasilloMinMm;
  final int pasilloMaxMm;
  final int elevacionMaxMm;
  final int? alturaMastilMm;
  final bool requiereGuiado;
  final int? costoUnitarioCent;
  final String fuente;
  final bool esSemilla;
  const CatalogoEquipo({
    required this.id,
    required this.codigo,
    required this.tipo,
    this.claseEn,
    required this.pasilloMinMm,
    required this.pasilloMaxMm,
    required this.elevacionMaxMm,
    this.alturaMastilMm,
    required this.requiereGuiado,
    this.costoUnitarioCent,
    required this.fuente,
    required this.esSemilla,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['codigo'] = Variable<String>(codigo);
    map['tipo'] = Variable<String>(tipo);
    if (!nullToAbsent || claseEn != null) {
      map['clase_en'] = Variable<String>(claseEn);
    }
    map['pasillo_min_mm'] = Variable<int>(pasilloMinMm);
    map['pasillo_max_mm'] = Variable<int>(pasilloMaxMm);
    map['elevacion_max_mm'] = Variable<int>(elevacionMaxMm);
    if (!nullToAbsent || alturaMastilMm != null) {
      map['altura_mastil_mm'] = Variable<int>(alturaMastilMm);
    }
    map['requiere_guiado'] = Variable<bool>(requiereGuiado);
    if (!nullToAbsent || costoUnitarioCent != null) {
      map['costo_unitario_cent'] = Variable<int>(costoUnitarioCent);
    }
    map['fuente'] = Variable<String>(fuente);
    map['es_semilla'] = Variable<bool>(esSemilla);
    return map;
  }

  CatalogoEquiposCompanion toCompanion(bool nullToAbsent) {
    return CatalogoEquiposCompanion(
      id: Value(id),
      codigo: Value(codigo),
      tipo: Value(tipo),
      claseEn: claseEn == null && nullToAbsent
          ? const Value.absent()
          : Value(claseEn),
      pasilloMinMm: Value(pasilloMinMm),
      pasilloMaxMm: Value(pasilloMaxMm),
      elevacionMaxMm: Value(elevacionMaxMm),
      alturaMastilMm: alturaMastilMm == null && nullToAbsent
          ? const Value.absent()
          : Value(alturaMastilMm),
      requiereGuiado: Value(requiereGuiado),
      costoUnitarioCent: costoUnitarioCent == null && nullToAbsent
          ? const Value.absent()
          : Value(costoUnitarioCent),
      fuente: Value(fuente),
      esSemilla: Value(esSemilla),
    );
  }

  factory CatalogoEquipo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogoEquipo(
      id: serializer.fromJson<int>(json['id']),
      codigo: serializer.fromJson<String>(json['codigo']),
      tipo: serializer.fromJson<String>(json['tipo']),
      claseEn: serializer.fromJson<String?>(json['claseEn']),
      pasilloMinMm: serializer.fromJson<int>(json['pasilloMinMm']),
      pasilloMaxMm: serializer.fromJson<int>(json['pasilloMaxMm']),
      elevacionMaxMm: serializer.fromJson<int>(json['elevacionMaxMm']),
      alturaMastilMm: serializer.fromJson<int?>(json['alturaMastilMm']),
      requiereGuiado: serializer.fromJson<bool>(json['requiereGuiado']),
      costoUnitarioCent: serializer.fromJson<int?>(json['costoUnitarioCent']),
      fuente: serializer.fromJson<String>(json['fuente']),
      esSemilla: serializer.fromJson<bool>(json['esSemilla']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'codigo': serializer.toJson<String>(codigo),
      'tipo': serializer.toJson<String>(tipo),
      'claseEn': serializer.toJson<String?>(claseEn),
      'pasilloMinMm': serializer.toJson<int>(pasilloMinMm),
      'pasilloMaxMm': serializer.toJson<int>(pasilloMaxMm),
      'elevacionMaxMm': serializer.toJson<int>(elevacionMaxMm),
      'alturaMastilMm': serializer.toJson<int?>(alturaMastilMm),
      'requiereGuiado': serializer.toJson<bool>(requiereGuiado),
      'costoUnitarioCent': serializer.toJson<int?>(costoUnitarioCent),
      'fuente': serializer.toJson<String>(fuente),
      'esSemilla': serializer.toJson<bool>(esSemilla),
    };
  }

  CatalogoEquipo copyWith({
    int? id,
    String? codigo,
    String? tipo,
    Value<String?> claseEn = const Value.absent(),
    int? pasilloMinMm,
    int? pasilloMaxMm,
    int? elevacionMaxMm,
    Value<int?> alturaMastilMm = const Value.absent(),
    bool? requiereGuiado,
    Value<int?> costoUnitarioCent = const Value.absent(),
    String? fuente,
    bool? esSemilla,
  }) => CatalogoEquipo(
    id: id ?? this.id,
    codigo: codigo ?? this.codigo,
    tipo: tipo ?? this.tipo,
    claseEn: claseEn.present ? claseEn.value : this.claseEn,
    pasilloMinMm: pasilloMinMm ?? this.pasilloMinMm,
    pasilloMaxMm: pasilloMaxMm ?? this.pasilloMaxMm,
    elevacionMaxMm: elevacionMaxMm ?? this.elevacionMaxMm,
    alturaMastilMm: alturaMastilMm.present
        ? alturaMastilMm.value
        : this.alturaMastilMm,
    requiereGuiado: requiereGuiado ?? this.requiereGuiado,
    costoUnitarioCent: costoUnitarioCent.present
        ? costoUnitarioCent.value
        : this.costoUnitarioCent,
    fuente: fuente ?? this.fuente,
    esSemilla: esSemilla ?? this.esSemilla,
  );
  CatalogoEquipo copyWithCompanion(CatalogoEquiposCompanion data) {
    return CatalogoEquipo(
      id: data.id.present ? data.id.value : this.id,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      claseEn: data.claseEn.present ? data.claseEn.value : this.claseEn,
      pasilloMinMm: data.pasilloMinMm.present
          ? data.pasilloMinMm.value
          : this.pasilloMinMm,
      pasilloMaxMm: data.pasilloMaxMm.present
          ? data.pasilloMaxMm.value
          : this.pasilloMaxMm,
      elevacionMaxMm: data.elevacionMaxMm.present
          ? data.elevacionMaxMm.value
          : this.elevacionMaxMm,
      alturaMastilMm: data.alturaMastilMm.present
          ? data.alturaMastilMm.value
          : this.alturaMastilMm,
      requiereGuiado: data.requiereGuiado.present
          ? data.requiereGuiado.value
          : this.requiereGuiado,
      costoUnitarioCent: data.costoUnitarioCent.present
          ? data.costoUnitarioCent.value
          : this.costoUnitarioCent,
      fuente: data.fuente.present ? data.fuente.value : this.fuente,
      esSemilla: data.esSemilla.present ? data.esSemilla.value : this.esSemilla,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogoEquipo(')
          ..write('id: $id, ')
          ..write('codigo: $codigo, ')
          ..write('tipo: $tipo, ')
          ..write('claseEn: $claseEn, ')
          ..write('pasilloMinMm: $pasilloMinMm, ')
          ..write('pasilloMaxMm: $pasilloMaxMm, ')
          ..write('elevacionMaxMm: $elevacionMaxMm, ')
          ..write('alturaMastilMm: $alturaMastilMm, ')
          ..write('requiereGuiado: $requiereGuiado, ')
          ..write('costoUnitarioCent: $costoUnitarioCent, ')
          ..write('fuente: $fuente, ')
          ..write('esSemilla: $esSemilla')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    codigo,
    tipo,
    claseEn,
    pasilloMinMm,
    pasilloMaxMm,
    elevacionMaxMm,
    alturaMastilMm,
    requiereGuiado,
    costoUnitarioCent,
    fuente,
    esSemilla,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogoEquipo &&
          other.id == this.id &&
          other.codigo == this.codigo &&
          other.tipo == this.tipo &&
          other.claseEn == this.claseEn &&
          other.pasilloMinMm == this.pasilloMinMm &&
          other.pasilloMaxMm == this.pasilloMaxMm &&
          other.elevacionMaxMm == this.elevacionMaxMm &&
          other.alturaMastilMm == this.alturaMastilMm &&
          other.requiereGuiado == this.requiereGuiado &&
          other.costoUnitarioCent == this.costoUnitarioCent &&
          other.fuente == this.fuente &&
          other.esSemilla == this.esSemilla);
}

class CatalogoEquiposCompanion extends UpdateCompanion<CatalogoEquipo> {
  final Value<int> id;
  final Value<String> codigo;
  final Value<String> tipo;
  final Value<String?> claseEn;
  final Value<int> pasilloMinMm;
  final Value<int> pasilloMaxMm;
  final Value<int> elevacionMaxMm;
  final Value<int?> alturaMastilMm;
  final Value<bool> requiereGuiado;
  final Value<int?> costoUnitarioCent;
  final Value<String> fuente;
  final Value<bool> esSemilla;
  const CatalogoEquiposCompanion({
    this.id = const Value.absent(),
    this.codigo = const Value.absent(),
    this.tipo = const Value.absent(),
    this.claseEn = const Value.absent(),
    this.pasilloMinMm = const Value.absent(),
    this.pasilloMaxMm = const Value.absent(),
    this.elevacionMaxMm = const Value.absent(),
    this.alturaMastilMm = const Value.absent(),
    this.requiereGuiado = const Value.absent(),
    this.costoUnitarioCent = const Value.absent(),
    this.fuente = const Value.absent(),
    this.esSemilla = const Value.absent(),
  });
  CatalogoEquiposCompanion.insert({
    this.id = const Value.absent(),
    required String codigo,
    required String tipo,
    this.claseEn = const Value.absent(),
    required int pasilloMinMm,
    required int pasilloMaxMm,
    required int elevacionMaxMm,
    this.alturaMastilMm = const Value.absent(),
    this.requiereGuiado = const Value.absent(),
    this.costoUnitarioCent = const Value.absent(),
    required String fuente,
    this.esSemilla = const Value.absent(),
  }) : codigo = Value(codigo),
       tipo = Value(tipo),
       pasilloMinMm = Value(pasilloMinMm),
       pasilloMaxMm = Value(pasilloMaxMm),
       elevacionMaxMm = Value(elevacionMaxMm),
       fuente = Value(fuente);
  static Insertable<CatalogoEquipo> custom({
    Expression<int>? id,
    Expression<String>? codigo,
    Expression<String>? tipo,
    Expression<String>? claseEn,
    Expression<int>? pasilloMinMm,
    Expression<int>? pasilloMaxMm,
    Expression<int>? elevacionMaxMm,
    Expression<int>? alturaMastilMm,
    Expression<bool>? requiereGuiado,
    Expression<int>? costoUnitarioCent,
    Expression<String>? fuente,
    Expression<bool>? esSemilla,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (codigo != null) 'codigo': codigo,
      if (tipo != null) 'tipo': tipo,
      if (claseEn != null) 'clase_en': claseEn,
      if (pasilloMinMm != null) 'pasillo_min_mm': pasilloMinMm,
      if (pasilloMaxMm != null) 'pasillo_max_mm': pasilloMaxMm,
      if (elevacionMaxMm != null) 'elevacion_max_mm': elevacionMaxMm,
      if (alturaMastilMm != null) 'altura_mastil_mm': alturaMastilMm,
      if (requiereGuiado != null) 'requiere_guiado': requiereGuiado,
      if (costoUnitarioCent != null) 'costo_unitario_cent': costoUnitarioCent,
      if (fuente != null) 'fuente': fuente,
      if (esSemilla != null) 'es_semilla': esSemilla,
    });
  }

  CatalogoEquiposCompanion copyWith({
    Value<int>? id,
    Value<String>? codigo,
    Value<String>? tipo,
    Value<String?>? claseEn,
    Value<int>? pasilloMinMm,
    Value<int>? pasilloMaxMm,
    Value<int>? elevacionMaxMm,
    Value<int?>? alturaMastilMm,
    Value<bool>? requiereGuiado,
    Value<int?>? costoUnitarioCent,
    Value<String>? fuente,
    Value<bool>? esSemilla,
  }) {
    return CatalogoEquiposCompanion(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      tipo: tipo ?? this.tipo,
      claseEn: claseEn ?? this.claseEn,
      pasilloMinMm: pasilloMinMm ?? this.pasilloMinMm,
      pasilloMaxMm: pasilloMaxMm ?? this.pasilloMaxMm,
      elevacionMaxMm: elevacionMaxMm ?? this.elevacionMaxMm,
      alturaMastilMm: alturaMastilMm ?? this.alturaMastilMm,
      requiereGuiado: requiereGuiado ?? this.requiereGuiado,
      costoUnitarioCent: costoUnitarioCent ?? this.costoUnitarioCent,
      fuente: fuente ?? this.fuente,
      esSemilla: esSemilla ?? this.esSemilla,
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
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (claseEn.present) {
      map['clase_en'] = Variable<String>(claseEn.value);
    }
    if (pasilloMinMm.present) {
      map['pasillo_min_mm'] = Variable<int>(pasilloMinMm.value);
    }
    if (pasilloMaxMm.present) {
      map['pasillo_max_mm'] = Variable<int>(pasilloMaxMm.value);
    }
    if (elevacionMaxMm.present) {
      map['elevacion_max_mm'] = Variable<int>(elevacionMaxMm.value);
    }
    if (alturaMastilMm.present) {
      map['altura_mastil_mm'] = Variable<int>(alturaMastilMm.value);
    }
    if (requiereGuiado.present) {
      map['requiere_guiado'] = Variable<bool>(requiereGuiado.value);
    }
    if (costoUnitarioCent.present) {
      map['costo_unitario_cent'] = Variable<int>(costoUnitarioCent.value);
    }
    if (fuente.present) {
      map['fuente'] = Variable<String>(fuente.value);
    }
    if (esSemilla.present) {
      map['es_semilla'] = Variable<bool>(esSemilla.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogoEquiposCompanion(')
          ..write('id: $id, ')
          ..write('codigo: $codigo, ')
          ..write('tipo: $tipo, ')
          ..write('claseEn: $claseEn, ')
          ..write('pasilloMinMm: $pasilloMinMm, ')
          ..write('pasilloMaxMm: $pasilloMaxMm, ')
          ..write('elevacionMaxMm: $elevacionMaxMm, ')
          ..write('alturaMastilMm: $alturaMastilMm, ')
          ..write('requiereGuiado: $requiereGuiado, ')
          ..write('costoUnitarioCent: $costoUnitarioCent, ')
          ..write('fuente: $fuente, ')
          ..write('esSemilla: $esSemilla')
          ..write(')'))
        .toString();
  }
}

class $CatalogoCamionesTable extends CatalogoCamiones
    with TableInfo<$CatalogoCamionesTable, CatalogoCamione> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogoCamionesTable(this.attachedDatabase, [this._alias]);
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
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _largoMmMeta = const VerificationMeta(
    'largoMm',
  );
  @override
  late final GeneratedColumn<int> largoMm = GeneratedColumn<int>(
    'largo_mm',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _anchoMmMeta = const VerificationMeta(
    'anchoMm',
  );
  @override
  late final GeneratedColumn<int> anchoMm = GeneratedColumn<int>(
    'ancho_mm',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _patioMinMmMeta = const VerificationMeta(
    'patioMinMm',
  );
  @override
  late final GeneratedColumn<int> patioMinMm = GeneratedColumn<int>(
    'patio_min_mm',
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
  static const VerificationMeta _esSemillaMeta = const VerificationMeta(
    'esSemilla',
  );
  @override
  late final GeneratedColumn<bool> esSemilla = GeneratedColumn<bool>(
    'es_semilla',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("es_semilla" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    codigo,
    largoMm,
    anchoMm,
    patioMinMm,
    fuente,
    esSemilla,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalogo_camiones';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatalogoCamione> instance, {
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
    if (data.containsKey('largo_mm')) {
      context.handle(
        _largoMmMeta,
        largoMm.isAcceptableOrUnknown(data['largo_mm']!, _largoMmMeta),
      );
    } else if (isInserting) {
      context.missing(_largoMmMeta);
    }
    if (data.containsKey('ancho_mm')) {
      context.handle(
        _anchoMmMeta,
        anchoMm.isAcceptableOrUnknown(data['ancho_mm']!, _anchoMmMeta),
      );
    } else if (isInserting) {
      context.missing(_anchoMmMeta);
    }
    if (data.containsKey('patio_min_mm')) {
      context.handle(
        _patioMinMmMeta,
        patioMinMm.isAcceptableOrUnknown(
          data['patio_min_mm']!,
          _patioMinMmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_patioMinMmMeta);
    }
    if (data.containsKey('fuente')) {
      context.handle(
        _fuenteMeta,
        fuente.isAcceptableOrUnknown(data['fuente']!, _fuenteMeta),
      );
    } else if (isInserting) {
      context.missing(_fuenteMeta);
    }
    if (data.containsKey('es_semilla')) {
      context.handle(
        _esSemillaMeta,
        esSemilla.isAcceptableOrUnknown(data['es_semilla']!, _esSemillaMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CatalogoCamione map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogoCamione(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      largoMm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}largo_mm'],
      )!,
      anchoMm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ancho_mm'],
      )!,
      patioMinMm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}patio_min_mm'],
      )!,
      fuente: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fuente'],
      )!,
      esSemilla: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}es_semilla'],
      )!,
    );
  }

  @override
  $CatalogoCamionesTable createAlias(String alias) {
    return $CatalogoCamionesTable(attachedDatabase, alias);
  }
}

class CatalogoCamione extends DataClass implements Insertable<CatalogoCamione> {
  final int id;
  final String codigo;
  final int largoMm;
  final int anchoMm;
  final int patioMinMm;
  final String fuente;
  final bool esSemilla;
  const CatalogoCamione({
    required this.id,
    required this.codigo,
    required this.largoMm,
    required this.anchoMm,
    required this.patioMinMm,
    required this.fuente,
    required this.esSemilla,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['codigo'] = Variable<String>(codigo);
    map['largo_mm'] = Variable<int>(largoMm);
    map['ancho_mm'] = Variable<int>(anchoMm);
    map['patio_min_mm'] = Variable<int>(patioMinMm);
    map['fuente'] = Variable<String>(fuente);
    map['es_semilla'] = Variable<bool>(esSemilla);
    return map;
  }

  CatalogoCamionesCompanion toCompanion(bool nullToAbsent) {
    return CatalogoCamionesCompanion(
      id: Value(id),
      codigo: Value(codigo),
      largoMm: Value(largoMm),
      anchoMm: Value(anchoMm),
      patioMinMm: Value(patioMinMm),
      fuente: Value(fuente),
      esSemilla: Value(esSemilla),
    );
  }

  factory CatalogoCamione.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogoCamione(
      id: serializer.fromJson<int>(json['id']),
      codigo: serializer.fromJson<String>(json['codigo']),
      largoMm: serializer.fromJson<int>(json['largoMm']),
      anchoMm: serializer.fromJson<int>(json['anchoMm']),
      patioMinMm: serializer.fromJson<int>(json['patioMinMm']),
      fuente: serializer.fromJson<String>(json['fuente']),
      esSemilla: serializer.fromJson<bool>(json['esSemilla']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'codigo': serializer.toJson<String>(codigo),
      'largoMm': serializer.toJson<int>(largoMm),
      'anchoMm': serializer.toJson<int>(anchoMm),
      'patioMinMm': serializer.toJson<int>(patioMinMm),
      'fuente': serializer.toJson<String>(fuente),
      'esSemilla': serializer.toJson<bool>(esSemilla),
    };
  }

  CatalogoCamione copyWith({
    int? id,
    String? codigo,
    int? largoMm,
    int? anchoMm,
    int? patioMinMm,
    String? fuente,
    bool? esSemilla,
  }) => CatalogoCamione(
    id: id ?? this.id,
    codigo: codigo ?? this.codigo,
    largoMm: largoMm ?? this.largoMm,
    anchoMm: anchoMm ?? this.anchoMm,
    patioMinMm: patioMinMm ?? this.patioMinMm,
    fuente: fuente ?? this.fuente,
    esSemilla: esSemilla ?? this.esSemilla,
  );
  CatalogoCamione copyWithCompanion(CatalogoCamionesCompanion data) {
    return CatalogoCamione(
      id: data.id.present ? data.id.value : this.id,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      largoMm: data.largoMm.present ? data.largoMm.value : this.largoMm,
      anchoMm: data.anchoMm.present ? data.anchoMm.value : this.anchoMm,
      patioMinMm: data.patioMinMm.present
          ? data.patioMinMm.value
          : this.patioMinMm,
      fuente: data.fuente.present ? data.fuente.value : this.fuente,
      esSemilla: data.esSemilla.present ? data.esSemilla.value : this.esSemilla,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogoCamione(')
          ..write('id: $id, ')
          ..write('codigo: $codigo, ')
          ..write('largoMm: $largoMm, ')
          ..write('anchoMm: $anchoMm, ')
          ..write('patioMinMm: $patioMinMm, ')
          ..write('fuente: $fuente, ')
          ..write('esSemilla: $esSemilla')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, codigo, largoMm, anchoMm, patioMinMm, fuente, esSemilla);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogoCamione &&
          other.id == this.id &&
          other.codigo == this.codigo &&
          other.largoMm == this.largoMm &&
          other.anchoMm == this.anchoMm &&
          other.patioMinMm == this.patioMinMm &&
          other.fuente == this.fuente &&
          other.esSemilla == this.esSemilla);
}

class CatalogoCamionesCompanion extends UpdateCompanion<CatalogoCamione> {
  final Value<int> id;
  final Value<String> codigo;
  final Value<int> largoMm;
  final Value<int> anchoMm;
  final Value<int> patioMinMm;
  final Value<String> fuente;
  final Value<bool> esSemilla;
  const CatalogoCamionesCompanion({
    this.id = const Value.absent(),
    this.codigo = const Value.absent(),
    this.largoMm = const Value.absent(),
    this.anchoMm = const Value.absent(),
    this.patioMinMm = const Value.absent(),
    this.fuente = const Value.absent(),
    this.esSemilla = const Value.absent(),
  });
  CatalogoCamionesCompanion.insert({
    this.id = const Value.absent(),
    required String codigo,
    required int largoMm,
    required int anchoMm,
    required int patioMinMm,
    required String fuente,
    this.esSemilla = const Value.absent(),
  }) : codigo = Value(codigo),
       largoMm = Value(largoMm),
       anchoMm = Value(anchoMm),
       patioMinMm = Value(patioMinMm),
       fuente = Value(fuente);
  static Insertable<CatalogoCamione> custom({
    Expression<int>? id,
    Expression<String>? codigo,
    Expression<int>? largoMm,
    Expression<int>? anchoMm,
    Expression<int>? patioMinMm,
    Expression<String>? fuente,
    Expression<bool>? esSemilla,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (codigo != null) 'codigo': codigo,
      if (largoMm != null) 'largo_mm': largoMm,
      if (anchoMm != null) 'ancho_mm': anchoMm,
      if (patioMinMm != null) 'patio_min_mm': patioMinMm,
      if (fuente != null) 'fuente': fuente,
      if (esSemilla != null) 'es_semilla': esSemilla,
    });
  }

  CatalogoCamionesCompanion copyWith({
    Value<int>? id,
    Value<String>? codigo,
    Value<int>? largoMm,
    Value<int>? anchoMm,
    Value<int>? patioMinMm,
    Value<String>? fuente,
    Value<bool>? esSemilla,
  }) {
    return CatalogoCamionesCompanion(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      largoMm: largoMm ?? this.largoMm,
      anchoMm: anchoMm ?? this.anchoMm,
      patioMinMm: patioMinMm ?? this.patioMinMm,
      fuente: fuente ?? this.fuente,
      esSemilla: esSemilla ?? this.esSemilla,
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
    if (largoMm.present) {
      map['largo_mm'] = Variable<int>(largoMm.value);
    }
    if (anchoMm.present) {
      map['ancho_mm'] = Variable<int>(anchoMm.value);
    }
    if (patioMinMm.present) {
      map['patio_min_mm'] = Variable<int>(patioMinMm.value);
    }
    if (fuente.present) {
      map['fuente'] = Variable<String>(fuente.value);
    }
    if (esSemilla.present) {
      map['es_semilla'] = Variable<bool>(esSemilla.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogoCamionesCompanion(')
          ..write('id: $id, ')
          ..write('codigo: $codigo, ')
          ..write('largoMm: $largoMm, ')
          ..write('anchoMm: $anchoMm, ')
          ..write('patioMinMm: $patioMinMm, ')
          ..write('fuente: $fuente, ')
          ..write('esSemilla: $esSemilla')
          ..write(')'))
        .toString();
  }
}

class $ParametrosNormaTable extends ParametrosNorma
    with TableInfo<$ParametrosNormaTable, ParametrosNormaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ParametrosNormaTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _normaMeta = const VerificationMeta('norma');
  @override
  late final GeneratedColumn<String> norma = GeneratedColumn<String>(
    'norma',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _claveMeta = const VerificationMeta('clave');
  @override
  late final GeneratedColumn<String> clave = GeneratedColumn<String>(
    'clave',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valorMeta = const VerificationMeta('valor');
  @override
  late final GeneratedColumn<int> valor = GeneratedColumn<int>(
    'valor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _claseMeta = const VerificationMeta('clase');
  @override
  late final GeneratedColumn<String> clase = GeneratedColumn<String>(
    'clase',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    norma,
    clave,
    valor,
    clase,
    fuente,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parametros_norma';
  @override
  VerificationContext validateIntegrity(
    Insertable<ParametrosNormaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('norma')) {
      context.handle(
        _normaMeta,
        norma.isAcceptableOrUnknown(data['norma']!, _normaMeta),
      );
    } else if (isInserting) {
      context.missing(_normaMeta);
    }
    if (data.containsKey('clave')) {
      context.handle(
        _claveMeta,
        clave.isAcceptableOrUnknown(data['clave']!, _claveMeta),
      );
    } else if (isInserting) {
      context.missing(_claveMeta);
    }
    if (data.containsKey('valor')) {
      context.handle(
        _valorMeta,
        valor.isAcceptableOrUnknown(data['valor']!, _valorMeta),
      );
    } else if (isInserting) {
      context.missing(_valorMeta);
    }
    if (data.containsKey('clase')) {
      context.handle(
        _claseMeta,
        clase.isAcceptableOrUnknown(data['clase']!, _claseMeta),
      );
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
    {norma, clave, clase},
  ];
  @override
  ParametrosNormaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ParametrosNormaData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      norma: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}norma'],
      )!,
      clave: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}clave'],
      )!,
      valor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}valor'],
      )!,
      clase: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}clase'],
      ),
      fuente: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fuente'],
      )!,
    );
  }

  @override
  $ParametrosNormaTable createAlias(String alias) {
    return $ParametrosNormaTable(attachedDatabase, alias);
  }
}

class ParametrosNormaData extends DataClass
    implements Insertable<ParametrosNormaData> {
  final int id;
  final String norma;
  final String clave;
  final int valor;
  final String? clase;
  final String fuente;
  const ParametrosNormaData({
    required this.id,
    required this.norma,
    required this.clave,
    required this.valor,
    this.clase,
    required this.fuente,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['norma'] = Variable<String>(norma);
    map['clave'] = Variable<String>(clave);
    map['valor'] = Variable<int>(valor);
    if (!nullToAbsent || clase != null) {
      map['clase'] = Variable<String>(clase);
    }
    map['fuente'] = Variable<String>(fuente);
    return map;
  }

  ParametrosNormaCompanion toCompanion(bool nullToAbsent) {
    return ParametrosNormaCompanion(
      id: Value(id),
      norma: Value(norma),
      clave: Value(clave),
      valor: Value(valor),
      clase: clase == null && nullToAbsent
          ? const Value.absent()
          : Value(clase),
      fuente: Value(fuente),
    );
  }

  factory ParametrosNormaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ParametrosNormaData(
      id: serializer.fromJson<int>(json['id']),
      norma: serializer.fromJson<String>(json['norma']),
      clave: serializer.fromJson<String>(json['clave']),
      valor: serializer.fromJson<int>(json['valor']),
      clase: serializer.fromJson<String?>(json['clase']),
      fuente: serializer.fromJson<String>(json['fuente']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'norma': serializer.toJson<String>(norma),
      'clave': serializer.toJson<String>(clave),
      'valor': serializer.toJson<int>(valor),
      'clase': serializer.toJson<String?>(clase),
      'fuente': serializer.toJson<String>(fuente),
    };
  }

  ParametrosNormaData copyWith({
    int? id,
    String? norma,
    String? clave,
    int? valor,
    Value<String?> clase = const Value.absent(),
    String? fuente,
  }) => ParametrosNormaData(
    id: id ?? this.id,
    norma: norma ?? this.norma,
    clave: clave ?? this.clave,
    valor: valor ?? this.valor,
    clase: clase.present ? clase.value : this.clase,
    fuente: fuente ?? this.fuente,
  );
  ParametrosNormaData copyWithCompanion(ParametrosNormaCompanion data) {
    return ParametrosNormaData(
      id: data.id.present ? data.id.value : this.id,
      norma: data.norma.present ? data.norma.value : this.norma,
      clave: data.clave.present ? data.clave.value : this.clave,
      valor: data.valor.present ? data.valor.value : this.valor,
      clase: data.clase.present ? data.clase.value : this.clase,
      fuente: data.fuente.present ? data.fuente.value : this.fuente,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ParametrosNormaData(')
          ..write('id: $id, ')
          ..write('norma: $norma, ')
          ..write('clave: $clave, ')
          ..write('valor: $valor, ')
          ..write('clase: $clase, ')
          ..write('fuente: $fuente')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, norma, clave, valor, clase, fuente);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ParametrosNormaData &&
          other.id == this.id &&
          other.norma == this.norma &&
          other.clave == this.clave &&
          other.valor == this.valor &&
          other.clase == this.clase &&
          other.fuente == this.fuente);
}

class ParametrosNormaCompanion extends UpdateCompanion<ParametrosNormaData> {
  final Value<int> id;
  final Value<String> norma;
  final Value<String> clave;
  final Value<int> valor;
  final Value<String?> clase;
  final Value<String> fuente;
  const ParametrosNormaCompanion({
    this.id = const Value.absent(),
    this.norma = const Value.absent(),
    this.clave = const Value.absent(),
    this.valor = const Value.absent(),
    this.clase = const Value.absent(),
    this.fuente = const Value.absent(),
  });
  ParametrosNormaCompanion.insert({
    this.id = const Value.absent(),
    required String norma,
    required String clave,
    required int valor,
    this.clase = const Value.absent(),
    required String fuente,
  }) : norma = Value(norma),
       clave = Value(clave),
       valor = Value(valor),
       fuente = Value(fuente);
  static Insertable<ParametrosNormaData> custom({
    Expression<int>? id,
    Expression<String>? norma,
    Expression<String>? clave,
    Expression<int>? valor,
    Expression<String>? clase,
    Expression<String>? fuente,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (norma != null) 'norma': norma,
      if (clave != null) 'clave': clave,
      if (valor != null) 'valor': valor,
      if (clase != null) 'clase': clase,
      if (fuente != null) 'fuente': fuente,
    });
  }

  ParametrosNormaCompanion copyWith({
    Value<int>? id,
    Value<String>? norma,
    Value<String>? clave,
    Value<int>? valor,
    Value<String?>? clase,
    Value<String>? fuente,
  }) {
    return ParametrosNormaCompanion(
      id: id ?? this.id,
      norma: norma ?? this.norma,
      clave: clave ?? this.clave,
      valor: valor ?? this.valor,
      clase: clase ?? this.clase,
      fuente: fuente ?? this.fuente,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (norma.present) {
      map['norma'] = Variable<String>(norma.value);
    }
    if (clave.present) {
      map['clave'] = Variable<String>(clave.value);
    }
    if (valor.present) {
      map['valor'] = Variable<int>(valor.value);
    }
    if (clase.present) {
      map['clase'] = Variable<String>(clase.value);
    }
    if (fuente.present) {
      map['fuente'] = Variable<String>(fuente.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ParametrosNormaCompanion(')
          ..write('id: $id, ')
          ..write('norma: $norma, ')
          ..write('clave: $clave, ')
          ..write('valor: $valor, ')
          ..write('clase: $clase, ')
          ..write('fuente: $fuente')
          ..write(')'))
        .toString();
  }
}

class $ProyectosTable extends Proyectos
    with TableInfo<$ProyectosTable, Proyecto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProyectosTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _normaMeta = const VerificationMeta('norma');
  @override
  late final GeneratedColumn<String> norma = GeneratedColumn<String>(
    'norma',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('EN'),
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
  static const VerificationMeta _alturaLibreMmMeta = const VerificationMeta(
    'alturaLibreMm',
  );
  @override
  late final GeneratedColumn<int> alturaLibreMm = GeneratedColumn<int>(
    'altura_libre_mm',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reservaTechoMmMeta = const VerificationMeta(
    'reservaTechoMm',
  );
  @override
  late final GeneratedColumn<int> reservaTechoMm = GeneratedColumn<int>(
    'reserva_techo_mm',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(450),
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
    norma,
    moneda,
    horizonteAnios,
    alturaLibreMm,
    reservaTechoMm,
    creadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'proyectos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Proyecto> instance, {
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
    if (data.containsKey('norma')) {
      context.handle(
        _normaMeta,
        norma.isAcceptableOrUnknown(data['norma']!, _normaMeta),
      );
    }
    if (data.containsKey('moneda')) {
      context.handle(
        _monedaMeta,
        moneda.isAcceptableOrUnknown(data['moneda']!, _monedaMeta),
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
    if (data.containsKey('altura_libre_mm')) {
      context.handle(
        _alturaLibreMmMeta,
        alturaLibreMm.isAcceptableOrUnknown(
          data['altura_libre_mm']!,
          _alturaLibreMmMeta,
        ),
      );
    }
    if (data.containsKey('reserva_techo_mm')) {
      context.handle(
        _reservaTechoMmMeta,
        reservaTechoMm.isAcceptableOrUnknown(
          data['reserva_techo_mm']!,
          _reservaTechoMmMeta,
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
  Proyecto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Proyecto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      norma: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}norma'],
      )!,
      moneda: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}moneda'],
      )!,
      horizonteAnios: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}horizonte_anios'],
      )!,
      alturaLibreMm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}altura_libre_mm'],
      ),
      reservaTechoMm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reserva_techo_mm'],
      )!,
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}creado_en'],
      )!,
    );
  }

  @override
  $ProyectosTable createAlias(String alias) {
    return $ProyectosTable(attachedDatabase, alias);
  }
}

class Proyecto extends DataClass implements Insertable<Proyecto> {
  final int id;
  final String nombre;
  final String norma;
  final String moneda;
  final int horizonteAnios;
  final int? alturaLibreMm;
  final int reservaTechoMm;
  final String creadoEn;
  const Proyecto({
    required this.id,
    required this.nombre,
    required this.norma,
    required this.moneda,
    required this.horizonteAnios,
    this.alturaLibreMm,
    required this.reservaTechoMm,
    required this.creadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['norma'] = Variable<String>(norma);
    map['moneda'] = Variable<String>(moneda);
    map['horizonte_anios'] = Variable<int>(horizonteAnios);
    if (!nullToAbsent || alturaLibreMm != null) {
      map['altura_libre_mm'] = Variable<int>(alturaLibreMm);
    }
    map['reserva_techo_mm'] = Variable<int>(reservaTechoMm);
    map['creado_en'] = Variable<String>(creadoEn);
    return map;
  }

  ProyectosCompanion toCompanion(bool nullToAbsent) {
    return ProyectosCompanion(
      id: Value(id),
      nombre: Value(nombre),
      norma: Value(norma),
      moneda: Value(moneda),
      horizonteAnios: Value(horizonteAnios),
      alturaLibreMm: alturaLibreMm == null && nullToAbsent
          ? const Value.absent()
          : Value(alturaLibreMm),
      reservaTechoMm: Value(reservaTechoMm),
      creadoEn: Value(creadoEn),
    );
  }

  factory Proyecto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Proyecto(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      norma: serializer.fromJson<String>(json['norma']),
      moneda: serializer.fromJson<String>(json['moneda']),
      horizonteAnios: serializer.fromJson<int>(json['horizonteAnios']),
      alturaLibreMm: serializer.fromJson<int?>(json['alturaLibreMm']),
      reservaTechoMm: serializer.fromJson<int>(json['reservaTechoMm']),
      creadoEn: serializer.fromJson<String>(json['creadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'norma': serializer.toJson<String>(norma),
      'moneda': serializer.toJson<String>(moneda),
      'horizonteAnios': serializer.toJson<int>(horizonteAnios),
      'alturaLibreMm': serializer.toJson<int?>(alturaLibreMm),
      'reservaTechoMm': serializer.toJson<int>(reservaTechoMm),
      'creadoEn': serializer.toJson<String>(creadoEn),
    };
  }

  Proyecto copyWith({
    int? id,
    String? nombre,
    String? norma,
    String? moneda,
    int? horizonteAnios,
    Value<int?> alturaLibreMm = const Value.absent(),
    int? reservaTechoMm,
    String? creadoEn,
  }) => Proyecto(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    norma: norma ?? this.norma,
    moneda: moneda ?? this.moneda,
    horizonteAnios: horizonteAnios ?? this.horizonteAnios,
    alturaLibreMm: alturaLibreMm.present
        ? alturaLibreMm.value
        : this.alturaLibreMm,
    reservaTechoMm: reservaTechoMm ?? this.reservaTechoMm,
    creadoEn: creadoEn ?? this.creadoEn,
  );
  Proyecto copyWithCompanion(ProyectosCompanion data) {
    return Proyecto(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      norma: data.norma.present ? data.norma.value : this.norma,
      moneda: data.moneda.present ? data.moneda.value : this.moneda,
      horizonteAnios: data.horizonteAnios.present
          ? data.horizonteAnios.value
          : this.horizonteAnios,
      alturaLibreMm: data.alturaLibreMm.present
          ? data.alturaLibreMm.value
          : this.alturaLibreMm,
      reservaTechoMm: data.reservaTechoMm.present
          ? data.reservaTechoMm.value
          : this.reservaTechoMm,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Proyecto(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('norma: $norma, ')
          ..write('moneda: $moneda, ')
          ..write('horizonteAnios: $horizonteAnios, ')
          ..write('alturaLibreMm: $alturaLibreMm, ')
          ..write('reservaTechoMm: $reservaTechoMm, ')
          ..write('creadoEn: $creadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    norma,
    moneda,
    horizonteAnios,
    alturaLibreMm,
    reservaTechoMm,
    creadoEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Proyecto &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.norma == this.norma &&
          other.moneda == this.moneda &&
          other.horizonteAnios == this.horizonteAnios &&
          other.alturaLibreMm == this.alturaLibreMm &&
          other.reservaTechoMm == this.reservaTechoMm &&
          other.creadoEn == this.creadoEn);
}

class ProyectosCompanion extends UpdateCompanion<Proyecto> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String> norma;
  final Value<String> moneda;
  final Value<int> horizonteAnios;
  final Value<int?> alturaLibreMm;
  final Value<int> reservaTechoMm;
  final Value<String> creadoEn;
  const ProyectosCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.norma = const Value.absent(),
    this.moneda = const Value.absent(),
    this.horizonteAnios = const Value.absent(),
    this.alturaLibreMm = const Value.absent(),
    this.reservaTechoMm = const Value.absent(),
    this.creadoEn = const Value.absent(),
  });
  ProyectosCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    this.norma = const Value.absent(),
    this.moneda = const Value.absent(),
    this.horizonteAnios = const Value.absent(),
    this.alturaLibreMm = const Value.absent(),
    this.reservaTechoMm = const Value.absent(),
    required String creadoEn,
  }) : nombre = Value(nombre),
       creadoEn = Value(creadoEn);
  static Insertable<Proyecto> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? norma,
    Expression<String>? moneda,
    Expression<int>? horizonteAnios,
    Expression<int>? alturaLibreMm,
    Expression<int>? reservaTechoMm,
    Expression<String>? creadoEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (norma != null) 'norma': norma,
      if (moneda != null) 'moneda': moneda,
      if (horizonteAnios != null) 'horizonte_anios': horizonteAnios,
      if (alturaLibreMm != null) 'altura_libre_mm': alturaLibreMm,
      if (reservaTechoMm != null) 'reserva_techo_mm': reservaTechoMm,
      if (creadoEn != null) 'creado_en': creadoEn,
    });
  }

  ProyectosCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<String>? norma,
    Value<String>? moneda,
    Value<int>? horizonteAnios,
    Value<int?>? alturaLibreMm,
    Value<int>? reservaTechoMm,
    Value<String>? creadoEn,
  }) {
    return ProyectosCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      norma: norma ?? this.norma,
      moneda: moneda ?? this.moneda,
      horizonteAnios: horizonteAnios ?? this.horizonteAnios,
      alturaLibreMm: alturaLibreMm ?? this.alturaLibreMm,
      reservaTechoMm: reservaTechoMm ?? this.reservaTechoMm,
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
    if (norma.present) {
      map['norma'] = Variable<String>(norma.value);
    }
    if (moneda.present) {
      map['moneda'] = Variable<String>(moneda.value);
    }
    if (horizonteAnios.present) {
      map['horizonte_anios'] = Variable<int>(horizonteAnios.value);
    }
    if (alturaLibreMm.present) {
      map['altura_libre_mm'] = Variable<int>(alturaLibreMm.value);
    }
    if (reservaTechoMm.present) {
      map['reserva_techo_mm'] = Variable<int>(reservaTechoMm.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<String>(creadoEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProyectosCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('norma: $norma, ')
          ..write('moneda: $moneda, ')
          ..write('horizonteAnios: $horizonteAnios, ')
          ..write('alturaLibreMm: $alturaLibreMm, ')
          ..write('reservaTechoMm: $reservaTechoMm, ')
          ..write('creadoEn: $creadoEn')
          ..write(')'))
        .toString();
  }
}

class $FamiliasProductoTable extends FamiliasProducto
    with TableInfo<$FamiliasProductoTable, FamiliasProductoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FamiliasProductoTable(this.attachedDatabase, [this._alias]);
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
      'REFERENCES proyectos (id) ON DELETE CASCADE',
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
  static const VerificationMeta _tarimaIdMeta = const VerificationMeta(
    'tarimaId',
  );
  @override
  late final GeneratedColumn<int> tarimaId = GeneratedColumn<int>(
    'tarima_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES catalogo_tarimas (id)',
    ),
  );
  static const VerificationMeta _altoCargaMmMeta = const VerificationMeta(
    'altoCargaMm',
  );
  @override
  late final GeneratedColumn<int> altoCargaMm = GeneratedColumn<int>(
    'alto_carga_mm',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pesoCargaGMeta = const VerificationMeta(
    'pesoCargaG',
  );
  @override
  late final GeneratedColumn<int> pesoCargaG = GeneratedColumn<int>(
    'peso_carga_g',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unidadesPorTarimaMeta = const VerificationMeta(
    'unidadesPorTarima',
  );
  @override
  late final GeneratedColumn<int> unidadesPorTarima = GeneratedColumn<int>(
    'unidades_por_tarima',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _apilableNivelesMeta = const VerificationMeta(
    'apilableNiveles',
  );
  @override
  late final GeneratedColumn<int> apilableNiveles = GeneratedColumn<int>(
    'apilable_niveles',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _rotacionAnualMeta = const VerificationMeta(
    'rotacionAnual',
  );
  @override
  late final GeneratedColumn<double> rotacionAnual = GeneratedColumn<double>(
    'rotacion_anual',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _claseAbcMeta = const VerificationMeta(
    'claseAbc',
  );
  @override
  late final GeneratedColumn<String> claseAbc = GeneratedColumn<String>(
    'clase_abc',
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
    tarimaId,
    altoCargaMm,
    pesoCargaG,
    unidadesPorTarima,
    apilableNiveles,
    rotacionAnual,
    claseAbc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'familias_producto';
  @override
  VerificationContext validateIntegrity(
    Insertable<FamiliasProductoData> instance, {
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
    if (data.containsKey('tarima_id')) {
      context.handle(
        _tarimaIdMeta,
        tarimaId.isAcceptableOrUnknown(data['tarima_id']!, _tarimaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tarimaIdMeta);
    }
    if (data.containsKey('alto_carga_mm')) {
      context.handle(
        _altoCargaMmMeta,
        altoCargaMm.isAcceptableOrUnknown(
          data['alto_carga_mm']!,
          _altoCargaMmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_altoCargaMmMeta);
    }
    if (data.containsKey('peso_carga_g')) {
      context.handle(
        _pesoCargaGMeta,
        pesoCargaG.isAcceptableOrUnknown(
          data['peso_carga_g']!,
          _pesoCargaGMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pesoCargaGMeta);
    }
    if (data.containsKey('unidades_por_tarima')) {
      context.handle(
        _unidadesPorTarimaMeta,
        unidadesPorTarima.isAcceptableOrUnknown(
          data['unidades_por_tarima']!,
          _unidadesPorTarimaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unidadesPorTarimaMeta);
    }
    if (data.containsKey('apilable_niveles')) {
      context.handle(
        _apilableNivelesMeta,
        apilableNiveles.isAcceptableOrUnknown(
          data['apilable_niveles']!,
          _apilableNivelesMeta,
        ),
      );
    }
    if (data.containsKey('rotacion_anual')) {
      context.handle(
        _rotacionAnualMeta,
        rotacionAnual.isAcceptableOrUnknown(
          data['rotacion_anual']!,
          _rotacionAnualMeta,
        ),
      );
    }
    if (data.containsKey('clase_abc')) {
      context.handle(
        _claseAbcMeta,
        claseAbc.isAcceptableOrUnknown(data['clase_abc']!, _claseAbcMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FamiliasProductoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FamiliasProductoData(
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
      tarimaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tarima_id'],
      )!,
      altoCargaMm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}alto_carga_mm'],
      )!,
      pesoCargaG: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}peso_carga_g'],
      )!,
      unidadesPorTarima: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unidades_por_tarima'],
      )!,
      apilableNiveles: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}apilable_niveles'],
      )!,
      rotacionAnual: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rotacion_anual'],
      ),
      claseAbc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}clase_abc'],
      ),
    );
  }

  @override
  $FamiliasProductoTable createAlias(String alias) {
    return $FamiliasProductoTable(attachedDatabase, alias);
  }
}

class FamiliasProductoData extends DataClass
    implements Insertable<FamiliasProductoData> {
  final int id;
  final int proyectoId;
  final String nombre;
  final int tarimaId;
  final int altoCargaMm;
  final int pesoCargaG;
  final int unidadesPorTarima;
  final int apilableNiveles;
  final double? rotacionAnual;
  final String? claseAbc;
  const FamiliasProductoData({
    required this.id,
    required this.proyectoId,
    required this.nombre,
    required this.tarimaId,
    required this.altoCargaMm,
    required this.pesoCargaG,
    required this.unidadesPorTarima,
    required this.apilableNiveles,
    this.rotacionAnual,
    this.claseAbc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['proyecto_id'] = Variable<int>(proyectoId);
    map['nombre'] = Variable<String>(nombre);
    map['tarima_id'] = Variable<int>(tarimaId);
    map['alto_carga_mm'] = Variable<int>(altoCargaMm);
    map['peso_carga_g'] = Variable<int>(pesoCargaG);
    map['unidades_por_tarima'] = Variable<int>(unidadesPorTarima);
    map['apilable_niveles'] = Variable<int>(apilableNiveles);
    if (!nullToAbsent || rotacionAnual != null) {
      map['rotacion_anual'] = Variable<double>(rotacionAnual);
    }
    if (!nullToAbsent || claseAbc != null) {
      map['clase_abc'] = Variable<String>(claseAbc);
    }
    return map;
  }

  FamiliasProductoCompanion toCompanion(bool nullToAbsent) {
    return FamiliasProductoCompanion(
      id: Value(id),
      proyectoId: Value(proyectoId),
      nombre: Value(nombre),
      tarimaId: Value(tarimaId),
      altoCargaMm: Value(altoCargaMm),
      pesoCargaG: Value(pesoCargaG),
      unidadesPorTarima: Value(unidadesPorTarima),
      apilableNiveles: Value(apilableNiveles),
      rotacionAnual: rotacionAnual == null && nullToAbsent
          ? const Value.absent()
          : Value(rotacionAnual),
      claseAbc: claseAbc == null && nullToAbsent
          ? const Value.absent()
          : Value(claseAbc),
    );
  }

  factory FamiliasProductoData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FamiliasProductoData(
      id: serializer.fromJson<int>(json['id']),
      proyectoId: serializer.fromJson<int>(json['proyectoId']),
      nombre: serializer.fromJson<String>(json['nombre']),
      tarimaId: serializer.fromJson<int>(json['tarimaId']),
      altoCargaMm: serializer.fromJson<int>(json['altoCargaMm']),
      pesoCargaG: serializer.fromJson<int>(json['pesoCargaG']),
      unidadesPorTarima: serializer.fromJson<int>(json['unidadesPorTarima']),
      apilableNiveles: serializer.fromJson<int>(json['apilableNiveles']),
      rotacionAnual: serializer.fromJson<double?>(json['rotacionAnual']),
      claseAbc: serializer.fromJson<String?>(json['claseAbc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'proyectoId': serializer.toJson<int>(proyectoId),
      'nombre': serializer.toJson<String>(nombre),
      'tarimaId': serializer.toJson<int>(tarimaId),
      'altoCargaMm': serializer.toJson<int>(altoCargaMm),
      'pesoCargaG': serializer.toJson<int>(pesoCargaG),
      'unidadesPorTarima': serializer.toJson<int>(unidadesPorTarima),
      'apilableNiveles': serializer.toJson<int>(apilableNiveles),
      'rotacionAnual': serializer.toJson<double?>(rotacionAnual),
      'claseAbc': serializer.toJson<String?>(claseAbc),
    };
  }

  FamiliasProductoData copyWith({
    int? id,
    int? proyectoId,
    String? nombre,
    int? tarimaId,
    int? altoCargaMm,
    int? pesoCargaG,
    int? unidadesPorTarima,
    int? apilableNiveles,
    Value<double?> rotacionAnual = const Value.absent(),
    Value<String?> claseAbc = const Value.absent(),
  }) => FamiliasProductoData(
    id: id ?? this.id,
    proyectoId: proyectoId ?? this.proyectoId,
    nombre: nombre ?? this.nombre,
    tarimaId: tarimaId ?? this.tarimaId,
    altoCargaMm: altoCargaMm ?? this.altoCargaMm,
    pesoCargaG: pesoCargaG ?? this.pesoCargaG,
    unidadesPorTarima: unidadesPorTarima ?? this.unidadesPorTarima,
    apilableNiveles: apilableNiveles ?? this.apilableNiveles,
    rotacionAnual: rotacionAnual.present
        ? rotacionAnual.value
        : this.rotacionAnual,
    claseAbc: claseAbc.present ? claseAbc.value : this.claseAbc,
  );
  FamiliasProductoData copyWithCompanion(FamiliasProductoCompanion data) {
    return FamiliasProductoData(
      id: data.id.present ? data.id.value : this.id,
      proyectoId: data.proyectoId.present
          ? data.proyectoId.value
          : this.proyectoId,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      tarimaId: data.tarimaId.present ? data.tarimaId.value : this.tarimaId,
      altoCargaMm: data.altoCargaMm.present
          ? data.altoCargaMm.value
          : this.altoCargaMm,
      pesoCargaG: data.pesoCargaG.present
          ? data.pesoCargaG.value
          : this.pesoCargaG,
      unidadesPorTarima: data.unidadesPorTarima.present
          ? data.unidadesPorTarima.value
          : this.unidadesPorTarima,
      apilableNiveles: data.apilableNiveles.present
          ? data.apilableNiveles.value
          : this.apilableNiveles,
      rotacionAnual: data.rotacionAnual.present
          ? data.rotacionAnual.value
          : this.rotacionAnual,
      claseAbc: data.claseAbc.present ? data.claseAbc.value : this.claseAbc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FamiliasProductoData(')
          ..write('id: $id, ')
          ..write('proyectoId: $proyectoId, ')
          ..write('nombre: $nombre, ')
          ..write('tarimaId: $tarimaId, ')
          ..write('altoCargaMm: $altoCargaMm, ')
          ..write('pesoCargaG: $pesoCargaG, ')
          ..write('unidadesPorTarima: $unidadesPorTarima, ')
          ..write('apilableNiveles: $apilableNiveles, ')
          ..write('rotacionAnual: $rotacionAnual, ')
          ..write('claseAbc: $claseAbc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    proyectoId,
    nombre,
    tarimaId,
    altoCargaMm,
    pesoCargaG,
    unidadesPorTarima,
    apilableNiveles,
    rotacionAnual,
    claseAbc,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FamiliasProductoData &&
          other.id == this.id &&
          other.proyectoId == this.proyectoId &&
          other.nombre == this.nombre &&
          other.tarimaId == this.tarimaId &&
          other.altoCargaMm == this.altoCargaMm &&
          other.pesoCargaG == this.pesoCargaG &&
          other.unidadesPorTarima == this.unidadesPorTarima &&
          other.apilableNiveles == this.apilableNiveles &&
          other.rotacionAnual == this.rotacionAnual &&
          other.claseAbc == this.claseAbc);
}

class FamiliasProductoCompanion extends UpdateCompanion<FamiliasProductoData> {
  final Value<int> id;
  final Value<int> proyectoId;
  final Value<String> nombre;
  final Value<int> tarimaId;
  final Value<int> altoCargaMm;
  final Value<int> pesoCargaG;
  final Value<int> unidadesPorTarima;
  final Value<int> apilableNiveles;
  final Value<double?> rotacionAnual;
  final Value<String?> claseAbc;
  const FamiliasProductoCompanion({
    this.id = const Value.absent(),
    this.proyectoId = const Value.absent(),
    this.nombre = const Value.absent(),
    this.tarimaId = const Value.absent(),
    this.altoCargaMm = const Value.absent(),
    this.pesoCargaG = const Value.absent(),
    this.unidadesPorTarima = const Value.absent(),
    this.apilableNiveles = const Value.absent(),
    this.rotacionAnual = const Value.absent(),
    this.claseAbc = const Value.absent(),
  });
  FamiliasProductoCompanion.insert({
    this.id = const Value.absent(),
    required int proyectoId,
    required String nombre,
    required int tarimaId,
    required int altoCargaMm,
    required int pesoCargaG,
    required int unidadesPorTarima,
    this.apilableNiveles = const Value.absent(),
    this.rotacionAnual = const Value.absent(),
    this.claseAbc = const Value.absent(),
  }) : proyectoId = Value(proyectoId),
       nombre = Value(nombre),
       tarimaId = Value(tarimaId),
       altoCargaMm = Value(altoCargaMm),
       pesoCargaG = Value(pesoCargaG),
       unidadesPorTarima = Value(unidadesPorTarima);
  static Insertable<FamiliasProductoData> custom({
    Expression<int>? id,
    Expression<int>? proyectoId,
    Expression<String>? nombre,
    Expression<int>? tarimaId,
    Expression<int>? altoCargaMm,
    Expression<int>? pesoCargaG,
    Expression<int>? unidadesPorTarima,
    Expression<int>? apilableNiveles,
    Expression<double>? rotacionAnual,
    Expression<String>? claseAbc,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (proyectoId != null) 'proyecto_id': proyectoId,
      if (nombre != null) 'nombre': nombre,
      if (tarimaId != null) 'tarima_id': tarimaId,
      if (altoCargaMm != null) 'alto_carga_mm': altoCargaMm,
      if (pesoCargaG != null) 'peso_carga_g': pesoCargaG,
      if (unidadesPorTarima != null) 'unidades_por_tarima': unidadesPorTarima,
      if (apilableNiveles != null) 'apilable_niveles': apilableNiveles,
      if (rotacionAnual != null) 'rotacion_anual': rotacionAnual,
      if (claseAbc != null) 'clase_abc': claseAbc,
    });
  }

  FamiliasProductoCompanion copyWith({
    Value<int>? id,
    Value<int>? proyectoId,
    Value<String>? nombre,
    Value<int>? tarimaId,
    Value<int>? altoCargaMm,
    Value<int>? pesoCargaG,
    Value<int>? unidadesPorTarima,
    Value<int>? apilableNiveles,
    Value<double?>? rotacionAnual,
    Value<String?>? claseAbc,
  }) {
    return FamiliasProductoCompanion(
      id: id ?? this.id,
      proyectoId: proyectoId ?? this.proyectoId,
      nombre: nombre ?? this.nombre,
      tarimaId: tarimaId ?? this.tarimaId,
      altoCargaMm: altoCargaMm ?? this.altoCargaMm,
      pesoCargaG: pesoCargaG ?? this.pesoCargaG,
      unidadesPorTarima: unidadesPorTarima ?? this.unidadesPorTarima,
      apilableNiveles: apilableNiveles ?? this.apilableNiveles,
      rotacionAnual: rotacionAnual ?? this.rotacionAnual,
      claseAbc: claseAbc ?? this.claseAbc,
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
    if (tarimaId.present) {
      map['tarima_id'] = Variable<int>(tarimaId.value);
    }
    if (altoCargaMm.present) {
      map['alto_carga_mm'] = Variable<int>(altoCargaMm.value);
    }
    if (pesoCargaG.present) {
      map['peso_carga_g'] = Variable<int>(pesoCargaG.value);
    }
    if (unidadesPorTarima.present) {
      map['unidades_por_tarima'] = Variable<int>(unidadesPorTarima.value);
    }
    if (apilableNiveles.present) {
      map['apilable_niveles'] = Variable<int>(apilableNiveles.value);
    }
    if (rotacionAnual.present) {
      map['rotacion_anual'] = Variable<double>(rotacionAnual.value);
    }
    if (claseAbc.present) {
      map['clase_abc'] = Variable<String>(claseAbc.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FamiliasProductoCompanion(')
          ..write('id: $id, ')
          ..write('proyectoId: $proyectoId, ')
          ..write('nombre: $nombre, ')
          ..write('tarimaId: $tarimaId, ')
          ..write('altoCargaMm: $altoCargaMm, ')
          ..write('pesoCargaG: $pesoCargaG, ')
          ..write('unidadesPorTarima: $unidadesPorTarima, ')
          ..write('apilableNiveles: $apilableNiveles, ')
          ..write('rotacionAnual: $rotacionAnual, ')
          ..write('claseAbc: $claseAbc')
          ..write(')'))
        .toString();
  }
}

class $DemandaPeriodosTable extends DemandaPeriodos
    with TableInfo<$DemandaPeriodosTable, DemandaPeriodo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DemandaPeriodosTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _familiaIdMeta = const VerificationMeta(
    'familiaId',
  );
  @override
  late final GeneratedColumn<int> familiaId = GeneratedColumn<int>(
    'familia_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES familias_producto (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _periodoMeta = const VerificationMeta(
    'periodo',
  );
  @override
  late final GeneratedColumn<String> periodo = GeneratedColumn<String>(
    'periodo',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _esPronosticoMeta = const VerificationMeta(
    'esPronostico',
  );
  @override
  late final GeneratedColumn<bool> esPronostico = GeneratedColumn<bool>(
    'es_pronostico',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("es_pronostico" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    familiaId,
    periodo,
    demanda,
    esPronostico,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'demanda_periodos';
  @override
  VerificationContext validateIntegrity(
    Insertable<DemandaPeriodo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('familia_id')) {
      context.handle(
        _familiaIdMeta,
        familiaId.isAcceptableOrUnknown(data['familia_id']!, _familiaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_familiaIdMeta);
    }
    if (data.containsKey('periodo')) {
      context.handle(
        _periodoMeta,
        periodo.isAcceptableOrUnknown(data['periodo']!, _periodoMeta),
      );
    } else if (isInserting) {
      context.missing(_periodoMeta);
    }
    if (data.containsKey('demanda')) {
      context.handle(
        _demandaMeta,
        demanda.isAcceptableOrUnknown(data['demanda']!, _demandaMeta),
      );
    } else if (isInserting) {
      context.missing(_demandaMeta);
    }
    if (data.containsKey('es_pronostico')) {
      context.handle(
        _esPronosticoMeta,
        esPronostico.isAcceptableOrUnknown(
          data['es_pronostico']!,
          _esPronosticoMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DemandaPeriodo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DemandaPeriodo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      familiaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}familia_id'],
      )!,
      periodo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}periodo'],
      )!,
      demanda: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}demanda'],
      )!,
      esPronostico: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}es_pronostico'],
      )!,
    );
  }

  @override
  $DemandaPeriodosTable createAlias(String alias) {
    return $DemandaPeriodosTable(attachedDatabase, alias);
  }
}

class DemandaPeriodo extends DataClass implements Insertable<DemandaPeriodo> {
  final int id;
  final int familiaId;
  final String periodo;
  final double demanda;
  final bool esPronostico;
  const DemandaPeriodo({
    required this.id,
    required this.familiaId,
    required this.periodo,
    required this.demanda,
    required this.esPronostico,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['familia_id'] = Variable<int>(familiaId);
    map['periodo'] = Variable<String>(periodo);
    map['demanda'] = Variable<double>(demanda);
    map['es_pronostico'] = Variable<bool>(esPronostico);
    return map;
  }

  DemandaPeriodosCompanion toCompanion(bool nullToAbsent) {
    return DemandaPeriodosCompanion(
      id: Value(id),
      familiaId: Value(familiaId),
      periodo: Value(periodo),
      demanda: Value(demanda),
      esPronostico: Value(esPronostico),
    );
  }

  factory DemandaPeriodo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DemandaPeriodo(
      id: serializer.fromJson<int>(json['id']),
      familiaId: serializer.fromJson<int>(json['familiaId']),
      periodo: serializer.fromJson<String>(json['periodo']),
      demanda: serializer.fromJson<double>(json['demanda']),
      esPronostico: serializer.fromJson<bool>(json['esPronostico']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'familiaId': serializer.toJson<int>(familiaId),
      'periodo': serializer.toJson<String>(periodo),
      'demanda': serializer.toJson<double>(demanda),
      'esPronostico': serializer.toJson<bool>(esPronostico),
    };
  }

  DemandaPeriodo copyWith({
    int? id,
    int? familiaId,
    String? periodo,
    double? demanda,
    bool? esPronostico,
  }) => DemandaPeriodo(
    id: id ?? this.id,
    familiaId: familiaId ?? this.familiaId,
    periodo: periodo ?? this.periodo,
    demanda: demanda ?? this.demanda,
    esPronostico: esPronostico ?? this.esPronostico,
  );
  DemandaPeriodo copyWithCompanion(DemandaPeriodosCompanion data) {
    return DemandaPeriodo(
      id: data.id.present ? data.id.value : this.id,
      familiaId: data.familiaId.present ? data.familiaId.value : this.familiaId,
      periodo: data.periodo.present ? data.periodo.value : this.periodo,
      demanda: data.demanda.present ? data.demanda.value : this.demanda,
      esPronostico: data.esPronostico.present
          ? data.esPronostico.value
          : this.esPronostico,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DemandaPeriodo(')
          ..write('id: $id, ')
          ..write('familiaId: $familiaId, ')
          ..write('periodo: $periodo, ')
          ..write('demanda: $demanda, ')
          ..write('esPronostico: $esPronostico')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, familiaId, periodo, demanda, esPronostico);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DemandaPeriodo &&
          other.id == this.id &&
          other.familiaId == this.familiaId &&
          other.periodo == this.periodo &&
          other.demanda == this.demanda &&
          other.esPronostico == this.esPronostico);
}

class DemandaPeriodosCompanion extends UpdateCompanion<DemandaPeriodo> {
  final Value<int> id;
  final Value<int> familiaId;
  final Value<String> periodo;
  final Value<double> demanda;
  final Value<bool> esPronostico;
  const DemandaPeriodosCompanion({
    this.id = const Value.absent(),
    this.familiaId = const Value.absent(),
    this.periodo = const Value.absent(),
    this.demanda = const Value.absent(),
    this.esPronostico = const Value.absent(),
  });
  DemandaPeriodosCompanion.insert({
    this.id = const Value.absent(),
    required int familiaId,
    required String periodo,
    required double demanda,
    this.esPronostico = const Value.absent(),
  }) : familiaId = Value(familiaId),
       periodo = Value(periodo),
       demanda = Value(demanda);
  static Insertable<DemandaPeriodo> custom({
    Expression<int>? id,
    Expression<int>? familiaId,
    Expression<String>? periodo,
    Expression<double>? demanda,
    Expression<bool>? esPronostico,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (familiaId != null) 'familia_id': familiaId,
      if (periodo != null) 'periodo': periodo,
      if (demanda != null) 'demanda': demanda,
      if (esPronostico != null) 'es_pronostico': esPronostico,
    });
  }

  DemandaPeriodosCompanion copyWith({
    Value<int>? id,
    Value<int>? familiaId,
    Value<String>? periodo,
    Value<double>? demanda,
    Value<bool>? esPronostico,
  }) {
    return DemandaPeriodosCompanion(
      id: id ?? this.id,
      familiaId: familiaId ?? this.familiaId,
      periodo: periodo ?? this.periodo,
      demanda: demanda ?? this.demanda,
      esPronostico: esPronostico ?? this.esPronostico,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (familiaId.present) {
      map['familia_id'] = Variable<int>(familiaId.value);
    }
    if (periodo.present) {
      map['periodo'] = Variable<String>(periodo.value);
    }
    if (demanda.present) {
      map['demanda'] = Variable<double>(demanda.value);
    }
    if (esPronostico.present) {
      map['es_pronostico'] = Variable<bool>(esPronostico.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DemandaPeriodosCompanion(')
          ..write('id: $id, ')
          ..write('familiaId: $familiaId, ')
          ..write('periodo: $periodo, ')
          ..write('demanda: $demanda, ')
          ..write('esPronostico: $esPronostico')
          ..write(')'))
        .toString();
  }
}

class $EscenariosTable extends Escenarios
    with TableInfo<$EscenariosTable, Escenario> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EscenariosTable(this.attachedDatabase, [this._alias]);
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
      'REFERENCES proyectos (id) ON DELETE CASCADE',
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
  static const VerificationMeta _tipoSistemaMeta = const VerificationMeta(
    'tipoSistema',
  );
  @override
  late final GeneratedColumn<String> tipoSistema = GeneratedColumn<String>(
    'tipo_sistema',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _equipoIdMeta = const VerificationMeta(
    'equipoId',
  );
  @override
  late final GeneratedColumn<int> equipoId = GeneratedColumn<int>(
    'equipo_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES catalogo_equipos (id)',
    ),
  );
  static const VerificationMeta _bastidorIdMeta = const VerificationMeta(
    'bastidorId',
  );
  @override
  late final GeneratedColumn<int> bastidorId = GeneratedColumn<int>(
    'bastidor_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES catalogo_bastidores (id)',
    ),
  );
  static const VerificationMeta _vigaIdMeta = const VerificationMeta('vigaId');
  @override
  late final GeneratedColumn<int> vigaId = GeneratedColumn<int>(
    'viga_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES catalogo_vigas (id)',
    ),
  );
  static const VerificationMeta _tarimasPorNivelMeta = const VerificationMeta(
    'tarimasPorNivel',
  );
  @override
  late final GeneratedColumn<int> tarimasPorNivel = GeneratedColumn<int>(
    'tarimas_por_nivel',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _patronFlujoMeta = const VerificationMeta(
    'patronFlujo',
  );
  @override
  late final GeneratedColumn<String> patronFlujo = GeneratedColumn<String>(
    'patron_flujo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('U'),
  );
  static const VerificationMeta _factorHoneycombMeta = const VerificationMeta(
    'factorHoneycomb',
  );
  @override
  late final GeneratedColumn<double> factorHoneycomb = GeneratedColumn<double>(
    'factor_honeycomb',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.20),
  );
  static const VerificationMeta _esBaseMeta = const VerificationMeta('esBase');
  @override
  late final GeneratedColumn<bool> esBase = GeneratedColumn<bool>(
    'es_base',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("es_base" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    proyectoId,
    nombre,
    tipoSistema,
    equipoId,
    bastidorId,
    vigaId,
    tarimasPorNivel,
    patronFlujo,
    factorHoneycomb,
    esBase,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'escenarios';
  @override
  VerificationContext validateIntegrity(
    Insertable<Escenario> instance, {
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
    if (data.containsKey('tipo_sistema')) {
      context.handle(
        _tipoSistemaMeta,
        tipoSistema.isAcceptableOrUnknown(
          data['tipo_sistema']!,
          _tipoSistemaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tipoSistemaMeta);
    }
    if (data.containsKey('equipo_id')) {
      context.handle(
        _equipoIdMeta,
        equipoId.isAcceptableOrUnknown(data['equipo_id']!, _equipoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_equipoIdMeta);
    }
    if (data.containsKey('bastidor_id')) {
      context.handle(
        _bastidorIdMeta,
        bastidorId.isAcceptableOrUnknown(data['bastidor_id']!, _bastidorIdMeta),
      );
    }
    if (data.containsKey('viga_id')) {
      context.handle(
        _vigaIdMeta,
        vigaId.isAcceptableOrUnknown(data['viga_id']!, _vigaIdMeta),
      );
    }
    if (data.containsKey('tarimas_por_nivel')) {
      context.handle(
        _tarimasPorNivelMeta,
        tarimasPorNivel.isAcceptableOrUnknown(
          data['tarimas_por_nivel']!,
          _tarimasPorNivelMeta,
        ),
      );
    }
    if (data.containsKey('patron_flujo')) {
      context.handle(
        _patronFlujoMeta,
        patronFlujo.isAcceptableOrUnknown(
          data['patron_flujo']!,
          _patronFlujoMeta,
        ),
      );
    }
    if (data.containsKey('factor_honeycomb')) {
      context.handle(
        _factorHoneycombMeta,
        factorHoneycomb.isAcceptableOrUnknown(
          data['factor_honeycomb']!,
          _factorHoneycombMeta,
        ),
      );
    }
    if (data.containsKey('es_base')) {
      context.handle(
        _esBaseMeta,
        esBase.isAcceptableOrUnknown(data['es_base']!, _esBaseMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Escenario map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Escenario(
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
      tipoSistema: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo_sistema'],
      )!,
      equipoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}equipo_id'],
      )!,
      bastidorId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bastidor_id'],
      ),
      vigaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}viga_id'],
      ),
      tarimasPorNivel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tarimas_por_nivel'],
      ),
      patronFlujo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}patron_flujo'],
      )!,
      factorHoneycomb: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}factor_honeycomb'],
      )!,
      esBase: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}es_base'],
      )!,
    );
  }

  @override
  $EscenariosTable createAlias(String alias) {
    return $EscenariosTable(attachedDatabase, alias);
  }
}

class Escenario extends DataClass implements Insertable<Escenario> {
  final int id;
  final int proyectoId;
  final String nombre;
  final String tipoSistema;
  final int equipoId;
  final int? bastidorId;
  final int? vigaId;
  final int? tarimasPorNivel;
  final String patronFlujo;
  final double factorHoneycomb;
  final bool esBase;
  const Escenario({
    required this.id,
    required this.proyectoId,
    required this.nombre,
    required this.tipoSistema,
    required this.equipoId,
    this.bastidorId,
    this.vigaId,
    this.tarimasPorNivel,
    required this.patronFlujo,
    required this.factorHoneycomb,
    required this.esBase,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['proyecto_id'] = Variable<int>(proyectoId);
    map['nombre'] = Variable<String>(nombre);
    map['tipo_sistema'] = Variable<String>(tipoSistema);
    map['equipo_id'] = Variable<int>(equipoId);
    if (!nullToAbsent || bastidorId != null) {
      map['bastidor_id'] = Variable<int>(bastidorId);
    }
    if (!nullToAbsent || vigaId != null) {
      map['viga_id'] = Variable<int>(vigaId);
    }
    if (!nullToAbsent || tarimasPorNivel != null) {
      map['tarimas_por_nivel'] = Variable<int>(tarimasPorNivel);
    }
    map['patron_flujo'] = Variable<String>(patronFlujo);
    map['factor_honeycomb'] = Variable<double>(factorHoneycomb);
    map['es_base'] = Variable<bool>(esBase);
    return map;
  }

  EscenariosCompanion toCompanion(bool nullToAbsent) {
    return EscenariosCompanion(
      id: Value(id),
      proyectoId: Value(proyectoId),
      nombre: Value(nombre),
      tipoSistema: Value(tipoSistema),
      equipoId: Value(equipoId),
      bastidorId: bastidorId == null && nullToAbsent
          ? const Value.absent()
          : Value(bastidorId),
      vigaId: vigaId == null && nullToAbsent
          ? const Value.absent()
          : Value(vigaId),
      tarimasPorNivel: tarimasPorNivel == null && nullToAbsent
          ? const Value.absent()
          : Value(tarimasPorNivel),
      patronFlujo: Value(patronFlujo),
      factorHoneycomb: Value(factorHoneycomb),
      esBase: Value(esBase),
    );
  }

  factory Escenario.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Escenario(
      id: serializer.fromJson<int>(json['id']),
      proyectoId: serializer.fromJson<int>(json['proyectoId']),
      nombre: serializer.fromJson<String>(json['nombre']),
      tipoSistema: serializer.fromJson<String>(json['tipoSistema']),
      equipoId: serializer.fromJson<int>(json['equipoId']),
      bastidorId: serializer.fromJson<int?>(json['bastidorId']),
      vigaId: serializer.fromJson<int?>(json['vigaId']),
      tarimasPorNivel: serializer.fromJson<int?>(json['tarimasPorNivel']),
      patronFlujo: serializer.fromJson<String>(json['patronFlujo']),
      factorHoneycomb: serializer.fromJson<double>(json['factorHoneycomb']),
      esBase: serializer.fromJson<bool>(json['esBase']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'proyectoId': serializer.toJson<int>(proyectoId),
      'nombre': serializer.toJson<String>(nombre),
      'tipoSistema': serializer.toJson<String>(tipoSistema),
      'equipoId': serializer.toJson<int>(equipoId),
      'bastidorId': serializer.toJson<int?>(bastidorId),
      'vigaId': serializer.toJson<int?>(vigaId),
      'tarimasPorNivel': serializer.toJson<int?>(tarimasPorNivel),
      'patronFlujo': serializer.toJson<String>(patronFlujo),
      'factorHoneycomb': serializer.toJson<double>(factorHoneycomb),
      'esBase': serializer.toJson<bool>(esBase),
    };
  }

  Escenario copyWith({
    int? id,
    int? proyectoId,
    String? nombre,
    String? tipoSistema,
    int? equipoId,
    Value<int?> bastidorId = const Value.absent(),
    Value<int?> vigaId = const Value.absent(),
    Value<int?> tarimasPorNivel = const Value.absent(),
    String? patronFlujo,
    double? factorHoneycomb,
    bool? esBase,
  }) => Escenario(
    id: id ?? this.id,
    proyectoId: proyectoId ?? this.proyectoId,
    nombre: nombre ?? this.nombre,
    tipoSistema: tipoSistema ?? this.tipoSistema,
    equipoId: equipoId ?? this.equipoId,
    bastidorId: bastidorId.present ? bastidorId.value : this.bastidorId,
    vigaId: vigaId.present ? vigaId.value : this.vigaId,
    tarimasPorNivel: tarimasPorNivel.present
        ? tarimasPorNivel.value
        : this.tarimasPorNivel,
    patronFlujo: patronFlujo ?? this.patronFlujo,
    factorHoneycomb: factorHoneycomb ?? this.factorHoneycomb,
    esBase: esBase ?? this.esBase,
  );
  Escenario copyWithCompanion(EscenariosCompanion data) {
    return Escenario(
      id: data.id.present ? data.id.value : this.id,
      proyectoId: data.proyectoId.present
          ? data.proyectoId.value
          : this.proyectoId,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      tipoSistema: data.tipoSistema.present
          ? data.tipoSistema.value
          : this.tipoSistema,
      equipoId: data.equipoId.present ? data.equipoId.value : this.equipoId,
      bastidorId: data.bastidorId.present
          ? data.bastidorId.value
          : this.bastidorId,
      vigaId: data.vigaId.present ? data.vigaId.value : this.vigaId,
      tarimasPorNivel: data.tarimasPorNivel.present
          ? data.tarimasPorNivel.value
          : this.tarimasPorNivel,
      patronFlujo: data.patronFlujo.present
          ? data.patronFlujo.value
          : this.patronFlujo,
      factorHoneycomb: data.factorHoneycomb.present
          ? data.factorHoneycomb.value
          : this.factorHoneycomb,
      esBase: data.esBase.present ? data.esBase.value : this.esBase,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Escenario(')
          ..write('id: $id, ')
          ..write('proyectoId: $proyectoId, ')
          ..write('nombre: $nombre, ')
          ..write('tipoSistema: $tipoSistema, ')
          ..write('equipoId: $equipoId, ')
          ..write('bastidorId: $bastidorId, ')
          ..write('vigaId: $vigaId, ')
          ..write('tarimasPorNivel: $tarimasPorNivel, ')
          ..write('patronFlujo: $patronFlujo, ')
          ..write('factorHoneycomb: $factorHoneycomb, ')
          ..write('esBase: $esBase')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    proyectoId,
    nombre,
    tipoSistema,
    equipoId,
    bastidorId,
    vigaId,
    tarimasPorNivel,
    patronFlujo,
    factorHoneycomb,
    esBase,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Escenario &&
          other.id == this.id &&
          other.proyectoId == this.proyectoId &&
          other.nombre == this.nombre &&
          other.tipoSistema == this.tipoSistema &&
          other.equipoId == this.equipoId &&
          other.bastidorId == this.bastidorId &&
          other.vigaId == this.vigaId &&
          other.tarimasPorNivel == this.tarimasPorNivel &&
          other.patronFlujo == this.patronFlujo &&
          other.factorHoneycomb == this.factorHoneycomb &&
          other.esBase == this.esBase);
}

class EscenariosCompanion extends UpdateCompanion<Escenario> {
  final Value<int> id;
  final Value<int> proyectoId;
  final Value<String> nombre;
  final Value<String> tipoSistema;
  final Value<int> equipoId;
  final Value<int?> bastidorId;
  final Value<int?> vigaId;
  final Value<int?> tarimasPorNivel;
  final Value<String> patronFlujo;
  final Value<double> factorHoneycomb;
  final Value<bool> esBase;
  const EscenariosCompanion({
    this.id = const Value.absent(),
    this.proyectoId = const Value.absent(),
    this.nombre = const Value.absent(),
    this.tipoSistema = const Value.absent(),
    this.equipoId = const Value.absent(),
    this.bastidorId = const Value.absent(),
    this.vigaId = const Value.absent(),
    this.tarimasPorNivel = const Value.absent(),
    this.patronFlujo = const Value.absent(),
    this.factorHoneycomb = const Value.absent(),
    this.esBase = const Value.absent(),
  });
  EscenariosCompanion.insert({
    this.id = const Value.absent(),
    required int proyectoId,
    required String nombre,
    required String tipoSistema,
    required int equipoId,
    this.bastidorId = const Value.absent(),
    this.vigaId = const Value.absent(),
    this.tarimasPorNivel = const Value.absent(),
    this.patronFlujo = const Value.absent(),
    this.factorHoneycomb = const Value.absent(),
    this.esBase = const Value.absent(),
  }) : proyectoId = Value(proyectoId),
       nombre = Value(nombre),
       tipoSistema = Value(tipoSistema),
       equipoId = Value(equipoId);
  static Insertable<Escenario> custom({
    Expression<int>? id,
    Expression<int>? proyectoId,
    Expression<String>? nombre,
    Expression<String>? tipoSistema,
    Expression<int>? equipoId,
    Expression<int>? bastidorId,
    Expression<int>? vigaId,
    Expression<int>? tarimasPorNivel,
    Expression<String>? patronFlujo,
    Expression<double>? factorHoneycomb,
    Expression<bool>? esBase,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (proyectoId != null) 'proyecto_id': proyectoId,
      if (nombre != null) 'nombre': nombre,
      if (tipoSistema != null) 'tipo_sistema': tipoSistema,
      if (equipoId != null) 'equipo_id': equipoId,
      if (bastidorId != null) 'bastidor_id': bastidorId,
      if (vigaId != null) 'viga_id': vigaId,
      if (tarimasPorNivel != null) 'tarimas_por_nivel': tarimasPorNivel,
      if (patronFlujo != null) 'patron_flujo': patronFlujo,
      if (factorHoneycomb != null) 'factor_honeycomb': factorHoneycomb,
      if (esBase != null) 'es_base': esBase,
    });
  }

  EscenariosCompanion copyWith({
    Value<int>? id,
    Value<int>? proyectoId,
    Value<String>? nombre,
    Value<String>? tipoSistema,
    Value<int>? equipoId,
    Value<int?>? bastidorId,
    Value<int?>? vigaId,
    Value<int?>? tarimasPorNivel,
    Value<String>? patronFlujo,
    Value<double>? factorHoneycomb,
    Value<bool>? esBase,
  }) {
    return EscenariosCompanion(
      id: id ?? this.id,
      proyectoId: proyectoId ?? this.proyectoId,
      nombre: nombre ?? this.nombre,
      tipoSistema: tipoSistema ?? this.tipoSistema,
      equipoId: equipoId ?? this.equipoId,
      bastidorId: bastidorId ?? this.bastidorId,
      vigaId: vigaId ?? this.vigaId,
      tarimasPorNivel: tarimasPorNivel ?? this.tarimasPorNivel,
      patronFlujo: patronFlujo ?? this.patronFlujo,
      factorHoneycomb: factorHoneycomb ?? this.factorHoneycomb,
      esBase: esBase ?? this.esBase,
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
    if (tipoSistema.present) {
      map['tipo_sistema'] = Variable<String>(tipoSistema.value);
    }
    if (equipoId.present) {
      map['equipo_id'] = Variable<int>(equipoId.value);
    }
    if (bastidorId.present) {
      map['bastidor_id'] = Variable<int>(bastidorId.value);
    }
    if (vigaId.present) {
      map['viga_id'] = Variable<int>(vigaId.value);
    }
    if (tarimasPorNivel.present) {
      map['tarimas_por_nivel'] = Variable<int>(tarimasPorNivel.value);
    }
    if (patronFlujo.present) {
      map['patron_flujo'] = Variable<String>(patronFlujo.value);
    }
    if (factorHoneycomb.present) {
      map['factor_honeycomb'] = Variable<double>(factorHoneycomb.value);
    }
    if (esBase.present) {
      map['es_base'] = Variable<bool>(esBase.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EscenariosCompanion(')
          ..write('id: $id, ')
          ..write('proyectoId: $proyectoId, ')
          ..write('nombre: $nombre, ')
          ..write('tipoSistema: $tipoSistema, ')
          ..write('equipoId: $equipoId, ')
          ..write('bastidorId: $bastidorId, ')
          ..write('vigaId: $vigaId, ')
          ..write('tarimasPorNivel: $tarimasPorNivel, ')
          ..write('patronFlujo: $patronFlujo, ')
          ..write('factorHoneycomb: $factorHoneycomb, ')
          ..write('esBase: $esBase')
          ..write(')'))
        .toString();
  }
}

class $ResultadosTable extends Resultados
    with TableInfo<$ResultadosTable, Resultado> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ResultadosTable(this.attachedDatabase, [this._alias]);
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
      'REFERENCES escenarios (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _calculadoEnMeta = const VerificationMeta(
    'calculadoEn',
  );
  @override
  late final GeneratedColumn<String> calculadoEn = GeneratedColumn<String>(
    'calculado_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _posicionesRequeridasMeta =
      const VerificationMeta('posicionesRequeridas');
  @override
  late final GeneratedColumn<int> posicionesRequeridas = GeneratedColumn<int>(
    'posiciones_requeridas',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _posicionesInstaladasMeta =
      const VerificationMeta('posicionesInstaladas');
  @override
  late final GeneratedColumn<int> posicionesInstaladas = GeneratedColumn<int>(
    'posiciones_instaladas',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modulosMeta = const VerificationMeta(
    'modulos',
  );
  @override
  late final GeneratedColumn<int> modulos = GeneratedColumn<int>(
    'modulos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filasMeta = const VerificationMeta('filas');
  @override
  late final GeneratedColumn<int> filas = GeneratedColumn<int>(
    'filas',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nivelesMeta = const VerificationMeta(
    'niveles',
  );
  @override
  late final GeneratedColumn<int> niveles = GeneratedColumn<int>(
    'niveles',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _supAlmacenamientoMm2Meta =
      const VerificationMeta('supAlmacenamientoMm2');
  @override
  late final GeneratedColumn<int> supAlmacenamientoMm2 = GeneratedColumn<int>(
    'sup_almacenamiento_mm2',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _supConstruidaMm2Meta = const VerificationMeta(
    'supConstruidaMm2',
  );
  @override
  late final GeneratedColumn<int> supConstruidaMm2 = GeneratedColumn<int>(
    'sup_construida_mm2',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _puertasAndenMeta = const VerificationMeta(
    'puertasAnden',
  );
  @override
  late final GeneratedColumn<int> puertasAnden = GeneratedColumn<int>(
    'puertas_anden',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _patioProfundidadMmMeta =
      const VerificationMeta('patioProfundidadMm');
  @override
  late final GeneratedColumn<int> patioProfundidadMm = GeneratedColumn<int>(
    'patio_profundidad_mm',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _distanciaEsperadaMmMeta =
      const VerificationMeta('distanciaEsperadaMm');
  @override
  late final GeneratedColumn<int> distanciaEsperadaMm = GeneratedColumn<int>(
    'distancia_esperada_mm',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _inversionCentMeta = const VerificationMeta(
    'inversionCent',
  );
  @override
  late final GeneratedColumn<int> inversionCent = GeneratedColumn<int>(
    'inversion_cent',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    escenarioId,
    calculadoEn,
    posicionesRequeridas,
    posicionesInstaladas,
    modulos,
    filas,
    niveles,
    supAlmacenamientoMm2,
    supConstruidaMm2,
    puertasAnden,
    patioProfundidadMm,
    distanciaEsperadaMm,
    inversionCent,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'resultados';
  @override
  VerificationContext validateIntegrity(
    Insertable<Resultado> instance, {
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
    if (data.containsKey('calculado_en')) {
      context.handle(
        _calculadoEnMeta,
        calculadoEn.isAcceptableOrUnknown(
          data['calculado_en']!,
          _calculadoEnMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_calculadoEnMeta);
    }
    if (data.containsKey('posiciones_requeridas')) {
      context.handle(
        _posicionesRequeridasMeta,
        posicionesRequeridas.isAcceptableOrUnknown(
          data['posiciones_requeridas']!,
          _posicionesRequeridasMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_posicionesRequeridasMeta);
    }
    if (data.containsKey('posiciones_instaladas')) {
      context.handle(
        _posicionesInstaladasMeta,
        posicionesInstaladas.isAcceptableOrUnknown(
          data['posiciones_instaladas']!,
          _posicionesInstaladasMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_posicionesInstaladasMeta);
    }
    if (data.containsKey('modulos')) {
      context.handle(
        _modulosMeta,
        modulos.isAcceptableOrUnknown(data['modulos']!, _modulosMeta),
      );
    } else if (isInserting) {
      context.missing(_modulosMeta);
    }
    if (data.containsKey('filas')) {
      context.handle(
        _filasMeta,
        filas.isAcceptableOrUnknown(data['filas']!, _filasMeta),
      );
    } else if (isInserting) {
      context.missing(_filasMeta);
    }
    if (data.containsKey('niveles')) {
      context.handle(
        _nivelesMeta,
        niveles.isAcceptableOrUnknown(data['niveles']!, _nivelesMeta),
      );
    } else if (isInserting) {
      context.missing(_nivelesMeta);
    }
    if (data.containsKey('sup_almacenamiento_mm2')) {
      context.handle(
        _supAlmacenamientoMm2Meta,
        supAlmacenamientoMm2.isAcceptableOrUnknown(
          data['sup_almacenamiento_mm2']!,
          _supAlmacenamientoMm2Meta,
        ),
      );
    } else if (isInserting) {
      context.missing(_supAlmacenamientoMm2Meta);
    }
    if (data.containsKey('sup_construida_mm2')) {
      context.handle(
        _supConstruidaMm2Meta,
        supConstruidaMm2.isAcceptableOrUnknown(
          data['sup_construida_mm2']!,
          _supConstruidaMm2Meta,
        ),
      );
    } else if (isInserting) {
      context.missing(_supConstruidaMm2Meta);
    }
    if (data.containsKey('puertas_anden')) {
      context.handle(
        _puertasAndenMeta,
        puertasAnden.isAcceptableOrUnknown(
          data['puertas_anden']!,
          _puertasAndenMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_puertasAndenMeta);
    }
    if (data.containsKey('patio_profundidad_mm')) {
      context.handle(
        _patioProfundidadMmMeta,
        patioProfundidadMm.isAcceptableOrUnknown(
          data['patio_profundidad_mm']!,
          _patioProfundidadMmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_patioProfundidadMmMeta);
    }
    if (data.containsKey('distancia_esperada_mm')) {
      context.handle(
        _distanciaEsperadaMmMeta,
        distanciaEsperadaMm.isAcceptableOrUnknown(
          data['distancia_esperada_mm']!,
          _distanciaEsperadaMmMeta,
        ),
      );
    }
    if (data.containsKey('inversion_cent')) {
      context.handle(
        _inversionCentMeta,
        inversionCent.isAcceptableOrUnknown(
          data['inversion_cent']!,
          _inversionCentMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Resultado map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Resultado(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      escenarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}escenario_id'],
      )!,
      calculadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}calculado_en'],
      )!,
      posicionesRequeridas: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}posiciones_requeridas'],
      )!,
      posicionesInstaladas: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}posiciones_instaladas'],
      )!,
      modulos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}modulos'],
      )!,
      filas: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}filas'],
      )!,
      niveles: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}niveles'],
      )!,
      supAlmacenamientoMm2: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sup_almacenamiento_mm2'],
      )!,
      supConstruidaMm2: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sup_construida_mm2'],
      )!,
      puertasAnden: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}puertas_anden'],
      )!,
      patioProfundidadMm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}patio_profundidad_mm'],
      )!,
      distanciaEsperadaMm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}distancia_esperada_mm'],
      ),
      inversionCent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}inversion_cent'],
      ),
    );
  }

  @override
  $ResultadosTable createAlias(String alias) {
    return $ResultadosTable(attachedDatabase, alias);
  }
}

class Resultado extends DataClass implements Insertable<Resultado> {
  final int id;
  final int escenarioId;
  final String calculadoEn;
  final int posicionesRequeridas;
  final int posicionesInstaladas;
  final int modulos;
  final int filas;
  final int niveles;
  final int supAlmacenamientoMm2;
  final int supConstruidaMm2;
  final int puertasAnden;
  final int patioProfundidadMm;
  final int? distanciaEsperadaMm;
  final int? inversionCent;
  const Resultado({
    required this.id,
    required this.escenarioId,
    required this.calculadoEn,
    required this.posicionesRequeridas,
    required this.posicionesInstaladas,
    required this.modulos,
    required this.filas,
    required this.niveles,
    required this.supAlmacenamientoMm2,
    required this.supConstruidaMm2,
    required this.puertasAnden,
    required this.patioProfundidadMm,
    this.distanciaEsperadaMm,
    this.inversionCent,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['escenario_id'] = Variable<int>(escenarioId);
    map['calculado_en'] = Variable<String>(calculadoEn);
    map['posiciones_requeridas'] = Variable<int>(posicionesRequeridas);
    map['posiciones_instaladas'] = Variable<int>(posicionesInstaladas);
    map['modulos'] = Variable<int>(modulos);
    map['filas'] = Variable<int>(filas);
    map['niveles'] = Variable<int>(niveles);
    map['sup_almacenamiento_mm2'] = Variable<int>(supAlmacenamientoMm2);
    map['sup_construida_mm2'] = Variable<int>(supConstruidaMm2);
    map['puertas_anden'] = Variable<int>(puertasAnden);
    map['patio_profundidad_mm'] = Variable<int>(patioProfundidadMm);
    if (!nullToAbsent || distanciaEsperadaMm != null) {
      map['distancia_esperada_mm'] = Variable<int>(distanciaEsperadaMm);
    }
    if (!nullToAbsent || inversionCent != null) {
      map['inversion_cent'] = Variable<int>(inversionCent);
    }
    return map;
  }

  ResultadosCompanion toCompanion(bool nullToAbsent) {
    return ResultadosCompanion(
      id: Value(id),
      escenarioId: Value(escenarioId),
      calculadoEn: Value(calculadoEn),
      posicionesRequeridas: Value(posicionesRequeridas),
      posicionesInstaladas: Value(posicionesInstaladas),
      modulos: Value(modulos),
      filas: Value(filas),
      niveles: Value(niveles),
      supAlmacenamientoMm2: Value(supAlmacenamientoMm2),
      supConstruidaMm2: Value(supConstruidaMm2),
      puertasAnden: Value(puertasAnden),
      patioProfundidadMm: Value(patioProfundidadMm),
      distanciaEsperadaMm: distanciaEsperadaMm == null && nullToAbsent
          ? const Value.absent()
          : Value(distanciaEsperadaMm),
      inversionCent: inversionCent == null && nullToAbsent
          ? const Value.absent()
          : Value(inversionCent),
    );
  }

  factory Resultado.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Resultado(
      id: serializer.fromJson<int>(json['id']),
      escenarioId: serializer.fromJson<int>(json['escenarioId']),
      calculadoEn: serializer.fromJson<String>(json['calculadoEn']),
      posicionesRequeridas: serializer.fromJson<int>(
        json['posicionesRequeridas'],
      ),
      posicionesInstaladas: serializer.fromJson<int>(
        json['posicionesInstaladas'],
      ),
      modulos: serializer.fromJson<int>(json['modulos']),
      filas: serializer.fromJson<int>(json['filas']),
      niveles: serializer.fromJson<int>(json['niveles']),
      supAlmacenamientoMm2: serializer.fromJson<int>(
        json['supAlmacenamientoMm2'],
      ),
      supConstruidaMm2: serializer.fromJson<int>(json['supConstruidaMm2']),
      puertasAnden: serializer.fromJson<int>(json['puertasAnden']),
      patioProfundidadMm: serializer.fromJson<int>(json['patioProfundidadMm']),
      distanciaEsperadaMm: serializer.fromJson<int?>(
        json['distanciaEsperadaMm'],
      ),
      inversionCent: serializer.fromJson<int?>(json['inversionCent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'escenarioId': serializer.toJson<int>(escenarioId),
      'calculadoEn': serializer.toJson<String>(calculadoEn),
      'posicionesRequeridas': serializer.toJson<int>(posicionesRequeridas),
      'posicionesInstaladas': serializer.toJson<int>(posicionesInstaladas),
      'modulos': serializer.toJson<int>(modulos),
      'filas': serializer.toJson<int>(filas),
      'niveles': serializer.toJson<int>(niveles),
      'supAlmacenamientoMm2': serializer.toJson<int>(supAlmacenamientoMm2),
      'supConstruidaMm2': serializer.toJson<int>(supConstruidaMm2),
      'puertasAnden': serializer.toJson<int>(puertasAnden),
      'patioProfundidadMm': serializer.toJson<int>(patioProfundidadMm),
      'distanciaEsperadaMm': serializer.toJson<int?>(distanciaEsperadaMm),
      'inversionCent': serializer.toJson<int?>(inversionCent),
    };
  }

  Resultado copyWith({
    int? id,
    int? escenarioId,
    String? calculadoEn,
    int? posicionesRequeridas,
    int? posicionesInstaladas,
    int? modulos,
    int? filas,
    int? niveles,
    int? supAlmacenamientoMm2,
    int? supConstruidaMm2,
    int? puertasAnden,
    int? patioProfundidadMm,
    Value<int?> distanciaEsperadaMm = const Value.absent(),
    Value<int?> inversionCent = const Value.absent(),
  }) => Resultado(
    id: id ?? this.id,
    escenarioId: escenarioId ?? this.escenarioId,
    calculadoEn: calculadoEn ?? this.calculadoEn,
    posicionesRequeridas: posicionesRequeridas ?? this.posicionesRequeridas,
    posicionesInstaladas: posicionesInstaladas ?? this.posicionesInstaladas,
    modulos: modulos ?? this.modulos,
    filas: filas ?? this.filas,
    niveles: niveles ?? this.niveles,
    supAlmacenamientoMm2: supAlmacenamientoMm2 ?? this.supAlmacenamientoMm2,
    supConstruidaMm2: supConstruidaMm2 ?? this.supConstruidaMm2,
    puertasAnden: puertasAnden ?? this.puertasAnden,
    patioProfundidadMm: patioProfundidadMm ?? this.patioProfundidadMm,
    distanciaEsperadaMm: distanciaEsperadaMm.present
        ? distanciaEsperadaMm.value
        : this.distanciaEsperadaMm,
    inversionCent: inversionCent.present
        ? inversionCent.value
        : this.inversionCent,
  );
  Resultado copyWithCompanion(ResultadosCompanion data) {
    return Resultado(
      id: data.id.present ? data.id.value : this.id,
      escenarioId: data.escenarioId.present
          ? data.escenarioId.value
          : this.escenarioId,
      calculadoEn: data.calculadoEn.present
          ? data.calculadoEn.value
          : this.calculadoEn,
      posicionesRequeridas: data.posicionesRequeridas.present
          ? data.posicionesRequeridas.value
          : this.posicionesRequeridas,
      posicionesInstaladas: data.posicionesInstaladas.present
          ? data.posicionesInstaladas.value
          : this.posicionesInstaladas,
      modulos: data.modulos.present ? data.modulos.value : this.modulos,
      filas: data.filas.present ? data.filas.value : this.filas,
      niveles: data.niveles.present ? data.niveles.value : this.niveles,
      supAlmacenamientoMm2: data.supAlmacenamientoMm2.present
          ? data.supAlmacenamientoMm2.value
          : this.supAlmacenamientoMm2,
      supConstruidaMm2: data.supConstruidaMm2.present
          ? data.supConstruidaMm2.value
          : this.supConstruidaMm2,
      puertasAnden: data.puertasAnden.present
          ? data.puertasAnden.value
          : this.puertasAnden,
      patioProfundidadMm: data.patioProfundidadMm.present
          ? data.patioProfundidadMm.value
          : this.patioProfundidadMm,
      distanciaEsperadaMm: data.distanciaEsperadaMm.present
          ? data.distanciaEsperadaMm.value
          : this.distanciaEsperadaMm,
      inversionCent: data.inversionCent.present
          ? data.inversionCent.value
          : this.inversionCent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Resultado(')
          ..write('id: $id, ')
          ..write('escenarioId: $escenarioId, ')
          ..write('calculadoEn: $calculadoEn, ')
          ..write('posicionesRequeridas: $posicionesRequeridas, ')
          ..write('posicionesInstaladas: $posicionesInstaladas, ')
          ..write('modulos: $modulos, ')
          ..write('filas: $filas, ')
          ..write('niveles: $niveles, ')
          ..write('supAlmacenamientoMm2: $supAlmacenamientoMm2, ')
          ..write('supConstruidaMm2: $supConstruidaMm2, ')
          ..write('puertasAnden: $puertasAnden, ')
          ..write('patioProfundidadMm: $patioProfundidadMm, ')
          ..write('distanciaEsperadaMm: $distanciaEsperadaMm, ')
          ..write('inversionCent: $inversionCent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    escenarioId,
    calculadoEn,
    posicionesRequeridas,
    posicionesInstaladas,
    modulos,
    filas,
    niveles,
    supAlmacenamientoMm2,
    supConstruidaMm2,
    puertasAnden,
    patioProfundidadMm,
    distanciaEsperadaMm,
    inversionCent,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Resultado &&
          other.id == this.id &&
          other.escenarioId == this.escenarioId &&
          other.calculadoEn == this.calculadoEn &&
          other.posicionesRequeridas == this.posicionesRequeridas &&
          other.posicionesInstaladas == this.posicionesInstaladas &&
          other.modulos == this.modulos &&
          other.filas == this.filas &&
          other.niveles == this.niveles &&
          other.supAlmacenamientoMm2 == this.supAlmacenamientoMm2 &&
          other.supConstruidaMm2 == this.supConstruidaMm2 &&
          other.puertasAnden == this.puertasAnden &&
          other.patioProfundidadMm == this.patioProfundidadMm &&
          other.distanciaEsperadaMm == this.distanciaEsperadaMm &&
          other.inversionCent == this.inversionCent);
}

class ResultadosCompanion extends UpdateCompanion<Resultado> {
  final Value<int> id;
  final Value<int> escenarioId;
  final Value<String> calculadoEn;
  final Value<int> posicionesRequeridas;
  final Value<int> posicionesInstaladas;
  final Value<int> modulos;
  final Value<int> filas;
  final Value<int> niveles;
  final Value<int> supAlmacenamientoMm2;
  final Value<int> supConstruidaMm2;
  final Value<int> puertasAnden;
  final Value<int> patioProfundidadMm;
  final Value<int?> distanciaEsperadaMm;
  final Value<int?> inversionCent;
  const ResultadosCompanion({
    this.id = const Value.absent(),
    this.escenarioId = const Value.absent(),
    this.calculadoEn = const Value.absent(),
    this.posicionesRequeridas = const Value.absent(),
    this.posicionesInstaladas = const Value.absent(),
    this.modulos = const Value.absent(),
    this.filas = const Value.absent(),
    this.niveles = const Value.absent(),
    this.supAlmacenamientoMm2 = const Value.absent(),
    this.supConstruidaMm2 = const Value.absent(),
    this.puertasAnden = const Value.absent(),
    this.patioProfundidadMm = const Value.absent(),
    this.distanciaEsperadaMm = const Value.absent(),
    this.inversionCent = const Value.absent(),
  });
  ResultadosCompanion.insert({
    this.id = const Value.absent(),
    required int escenarioId,
    required String calculadoEn,
    required int posicionesRequeridas,
    required int posicionesInstaladas,
    required int modulos,
    required int filas,
    required int niveles,
    required int supAlmacenamientoMm2,
    required int supConstruidaMm2,
    required int puertasAnden,
    required int patioProfundidadMm,
    this.distanciaEsperadaMm = const Value.absent(),
    this.inversionCent = const Value.absent(),
  }) : escenarioId = Value(escenarioId),
       calculadoEn = Value(calculadoEn),
       posicionesRequeridas = Value(posicionesRequeridas),
       posicionesInstaladas = Value(posicionesInstaladas),
       modulos = Value(modulos),
       filas = Value(filas),
       niveles = Value(niveles),
       supAlmacenamientoMm2 = Value(supAlmacenamientoMm2),
       supConstruidaMm2 = Value(supConstruidaMm2),
       puertasAnden = Value(puertasAnden),
       patioProfundidadMm = Value(patioProfundidadMm);
  static Insertable<Resultado> custom({
    Expression<int>? id,
    Expression<int>? escenarioId,
    Expression<String>? calculadoEn,
    Expression<int>? posicionesRequeridas,
    Expression<int>? posicionesInstaladas,
    Expression<int>? modulos,
    Expression<int>? filas,
    Expression<int>? niveles,
    Expression<int>? supAlmacenamientoMm2,
    Expression<int>? supConstruidaMm2,
    Expression<int>? puertasAnden,
    Expression<int>? patioProfundidadMm,
    Expression<int>? distanciaEsperadaMm,
    Expression<int>? inversionCent,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (escenarioId != null) 'escenario_id': escenarioId,
      if (calculadoEn != null) 'calculado_en': calculadoEn,
      if (posicionesRequeridas != null)
        'posiciones_requeridas': posicionesRequeridas,
      if (posicionesInstaladas != null)
        'posiciones_instaladas': posicionesInstaladas,
      if (modulos != null) 'modulos': modulos,
      if (filas != null) 'filas': filas,
      if (niveles != null) 'niveles': niveles,
      if (supAlmacenamientoMm2 != null)
        'sup_almacenamiento_mm2': supAlmacenamientoMm2,
      if (supConstruidaMm2 != null) 'sup_construida_mm2': supConstruidaMm2,
      if (puertasAnden != null) 'puertas_anden': puertasAnden,
      if (patioProfundidadMm != null)
        'patio_profundidad_mm': patioProfundidadMm,
      if (distanciaEsperadaMm != null)
        'distancia_esperada_mm': distanciaEsperadaMm,
      if (inversionCent != null) 'inversion_cent': inversionCent,
    });
  }

  ResultadosCompanion copyWith({
    Value<int>? id,
    Value<int>? escenarioId,
    Value<String>? calculadoEn,
    Value<int>? posicionesRequeridas,
    Value<int>? posicionesInstaladas,
    Value<int>? modulos,
    Value<int>? filas,
    Value<int>? niveles,
    Value<int>? supAlmacenamientoMm2,
    Value<int>? supConstruidaMm2,
    Value<int>? puertasAnden,
    Value<int>? patioProfundidadMm,
    Value<int?>? distanciaEsperadaMm,
    Value<int?>? inversionCent,
  }) {
    return ResultadosCompanion(
      id: id ?? this.id,
      escenarioId: escenarioId ?? this.escenarioId,
      calculadoEn: calculadoEn ?? this.calculadoEn,
      posicionesRequeridas: posicionesRequeridas ?? this.posicionesRequeridas,
      posicionesInstaladas: posicionesInstaladas ?? this.posicionesInstaladas,
      modulos: modulos ?? this.modulos,
      filas: filas ?? this.filas,
      niveles: niveles ?? this.niveles,
      supAlmacenamientoMm2: supAlmacenamientoMm2 ?? this.supAlmacenamientoMm2,
      supConstruidaMm2: supConstruidaMm2 ?? this.supConstruidaMm2,
      puertasAnden: puertasAnden ?? this.puertasAnden,
      patioProfundidadMm: patioProfundidadMm ?? this.patioProfundidadMm,
      distanciaEsperadaMm: distanciaEsperadaMm ?? this.distanciaEsperadaMm,
      inversionCent: inversionCent ?? this.inversionCent,
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
    if (calculadoEn.present) {
      map['calculado_en'] = Variable<String>(calculadoEn.value);
    }
    if (posicionesRequeridas.present) {
      map['posiciones_requeridas'] = Variable<int>(posicionesRequeridas.value);
    }
    if (posicionesInstaladas.present) {
      map['posiciones_instaladas'] = Variable<int>(posicionesInstaladas.value);
    }
    if (modulos.present) {
      map['modulos'] = Variable<int>(modulos.value);
    }
    if (filas.present) {
      map['filas'] = Variable<int>(filas.value);
    }
    if (niveles.present) {
      map['niveles'] = Variable<int>(niveles.value);
    }
    if (supAlmacenamientoMm2.present) {
      map['sup_almacenamiento_mm2'] = Variable<int>(supAlmacenamientoMm2.value);
    }
    if (supConstruidaMm2.present) {
      map['sup_construida_mm2'] = Variable<int>(supConstruidaMm2.value);
    }
    if (puertasAnden.present) {
      map['puertas_anden'] = Variable<int>(puertasAnden.value);
    }
    if (patioProfundidadMm.present) {
      map['patio_profundidad_mm'] = Variable<int>(patioProfundidadMm.value);
    }
    if (distanciaEsperadaMm.present) {
      map['distancia_esperada_mm'] = Variable<int>(distanciaEsperadaMm.value);
    }
    if (inversionCent.present) {
      map['inversion_cent'] = Variable<int>(inversionCent.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ResultadosCompanion(')
          ..write('id: $id, ')
          ..write('escenarioId: $escenarioId, ')
          ..write('calculadoEn: $calculadoEn, ')
          ..write('posicionesRequeridas: $posicionesRequeridas, ')
          ..write('posicionesInstaladas: $posicionesInstaladas, ')
          ..write('modulos: $modulos, ')
          ..write('filas: $filas, ')
          ..write('niveles: $niveles, ')
          ..write('supAlmacenamientoMm2: $supAlmacenamientoMm2, ')
          ..write('supConstruidaMm2: $supConstruidaMm2, ')
          ..write('puertasAnden: $puertasAnden, ')
          ..write('patioProfundidadMm: $patioProfundidadMm, ')
          ..write('distanciaEsperadaMm: $distanciaEsperadaMm, ')
          ..write('inversionCent: $inversionCent')
          ..write(')'))
        .toString();
  }
}

class $ZonasTable extends Zonas with TableInfo<$ZonasTable, Zona> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ZonasTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _resultadoIdMeta = const VerificationMeta(
    'resultadoId',
  );
  @override
  late final GeneratedColumn<int> resultadoId = GeneratedColumn<int>(
    'resultado_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES resultados (id) ON DELETE CASCADE',
    ),
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
  static const VerificationMeta _xMmMeta = const VerificationMeta('xMm');
  @override
  late final GeneratedColumn<int> xMm = GeneratedColumn<int>(
    'x_mm',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yMmMeta = const VerificationMeta('yMm');
  @override
  late final GeneratedColumn<int> yMm = GeneratedColumn<int>(
    'y_mm',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _anchoMmMeta = const VerificationMeta(
    'anchoMm',
  );
  @override
  late final GeneratedColumn<int> anchoMm = GeneratedColumn<int>(
    'ancho_mm',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _largoMmMeta = const VerificationMeta(
    'largoMm',
  );
  @override
  late final GeneratedColumn<int> largoMm = GeneratedColumn<int>(
    'largo_mm',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    resultadoId,
    tipo,
    xMm,
    yMm,
    anchoMm,
    largoMm,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'zonas';
  @override
  VerificationContext validateIntegrity(
    Insertable<Zona> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('resultado_id')) {
      context.handle(
        _resultadoIdMeta,
        resultadoId.isAcceptableOrUnknown(
          data['resultado_id']!,
          _resultadoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_resultadoIdMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('x_mm')) {
      context.handle(
        _xMmMeta,
        xMm.isAcceptableOrUnknown(data['x_mm']!, _xMmMeta),
      );
    } else if (isInserting) {
      context.missing(_xMmMeta);
    }
    if (data.containsKey('y_mm')) {
      context.handle(
        _yMmMeta,
        yMm.isAcceptableOrUnknown(data['y_mm']!, _yMmMeta),
      );
    } else if (isInserting) {
      context.missing(_yMmMeta);
    }
    if (data.containsKey('ancho_mm')) {
      context.handle(
        _anchoMmMeta,
        anchoMm.isAcceptableOrUnknown(data['ancho_mm']!, _anchoMmMeta),
      );
    } else if (isInserting) {
      context.missing(_anchoMmMeta);
    }
    if (data.containsKey('largo_mm')) {
      context.handle(
        _largoMmMeta,
        largoMm.isAcceptableOrUnknown(data['largo_mm']!, _largoMmMeta),
      );
    } else if (isInserting) {
      context.missing(_largoMmMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Zona map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Zona(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      resultadoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}resultado_id'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      xMm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}x_mm'],
      )!,
      yMm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}y_mm'],
      )!,
      anchoMm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ancho_mm'],
      )!,
      largoMm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}largo_mm'],
      )!,
    );
  }

  @override
  $ZonasTable createAlias(String alias) {
    return $ZonasTable(attachedDatabase, alias);
  }
}

class Zona extends DataClass implements Insertable<Zona> {
  final int id;
  final int resultadoId;
  final String tipo;
  final int xMm;
  final int yMm;
  final int anchoMm;
  final int largoMm;
  const Zona({
    required this.id,
    required this.resultadoId,
    required this.tipo,
    required this.xMm,
    required this.yMm,
    required this.anchoMm,
    required this.largoMm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['resultado_id'] = Variable<int>(resultadoId);
    map['tipo'] = Variable<String>(tipo);
    map['x_mm'] = Variable<int>(xMm);
    map['y_mm'] = Variable<int>(yMm);
    map['ancho_mm'] = Variable<int>(anchoMm);
    map['largo_mm'] = Variable<int>(largoMm);
    return map;
  }

  ZonasCompanion toCompanion(bool nullToAbsent) {
    return ZonasCompanion(
      id: Value(id),
      resultadoId: Value(resultadoId),
      tipo: Value(tipo),
      xMm: Value(xMm),
      yMm: Value(yMm),
      anchoMm: Value(anchoMm),
      largoMm: Value(largoMm),
    );
  }

  factory Zona.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Zona(
      id: serializer.fromJson<int>(json['id']),
      resultadoId: serializer.fromJson<int>(json['resultadoId']),
      tipo: serializer.fromJson<String>(json['tipo']),
      xMm: serializer.fromJson<int>(json['xMm']),
      yMm: serializer.fromJson<int>(json['yMm']),
      anchoMm: serializer.fromJson<int>(json['anchoMm']),
      largoMm: serializer.fromJson<int>(json['largoMm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'resultadoId': serializer.toJson<int>(resultadoId),
      'tipo': serializer.toJson<String>(tipo),
      'xMm': serializer.toJson<int>(xMm),
      'yMm': serializer.toJson<int>(yMm),
      'anchoMm': serializer.toJson<int>(anchoMm),
      'largoMm': serializer.toJson<int>(largoMm),
    };
  }

  Zona copyWith({
    int? id,
    int? resultadoId,
    String? tipo,
    int? xMm,
    int? yMm,
    int? anchoMm,
    int? largoMm,
  }) => Zona(
    id: id ?? this.id,
    resultadoId: resultadoId ?? this.resultadoId,
    tipo: tipo ?? this.tipo,
    xMm: xMm ?? this.xMm,
    yMm: yMm ?? this.yMm,
    anchoMm: anchoMm ?? this.anchoMm,
    largoMm: largoMm ?? this.largoMm,
  );
  Zona copyWithCompanion(ZonasCompanion data) {
    return Zona(
      id: data.id.present ? data.id.value : this.id,
      resultadoId: data.resultadoId.present
          ? data.resultadoId.value
          : this.resultadoId,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      xMm: data.xMm.present ? data.xMm.value : this.xMm,
      yMm: data.yMm.present ? data.yMm.value : this.yMm,
      anchoMm: data.anchoMm.present ? data.anchoMm.value : this.anchoMm,
      largoMm: data.largoMm.present ? data.largoMm.value : this.largoMm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Zona(')
          ..write('id: $id, ')
          ..write('resultadoId: $resultadoId, ')
          ..write('tipo: $tipo, ')
          ..write('xMm: $xMm, ')
          ..write('yMm: $yMm, ')
          ..write('anchoMm: $anchoMm, ')
          ..write('largoMm: $largoMm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, resultadoId, tipo, xMm, yMm, anchoMm, largoMm);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Zona &&
          other.id == this.id &&
          other.resultadoId == this.resultadoId &&
          other.tipo == this.tipo &&
          other.xMm == this.xMm &&
          other.yMm == this.yMm &&
          other.anchoMm == this.anchoMm &&
          other.largoMm == this.largoMm);
}

class ZonasCompanion extends UpdateCompanion<Zona> {
  final Value<int> id;
  final Value<int> resultadoId;
  final Value<String> tipo;
  final Value<int> xMm;
  final Value<int> yMm;
  final Value<int> anchoMm;
  final Value<int> largoMm;
  const ZonasCompanion({
    this.id = const Value.absent(),
    this.resultadoId = const Value.absent(),
    this.tipo = const Value.absent(),
    this.xMm = const Value.absent(),
    this.yMm = const Value.absent(),
    this.anchoMm = const Value.absent(),
    this.largoMm = const Value.absent(),
  });
  ZonasCompanion.insert({
    this.id = const Value.absent(),
    required int resultadoId,
    required String tipo,
    required int xMm,
    required int yMm,
    required int anchoMm,
    required int largoMm,
  }) : resultadoId = Value(resultadoId),
       tipo = Value(tipo),
       xMm = Value(xMm),
       yMm = Value(yMm),
       anchoMm = Value(anchoMm),
       largoMm = Value(largoMm);
  static Insertable<Zona> custom({
    Expression<int>? id,
    Expression<int>? resultadoId,
    Expression<String>? tipo,
    Expression<int>? xMm,
    Expression<int>? yMm,
    Expression<int>? anchoMm,
    Expression<int>? largoMm,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (resultadoId != null) 'resultado_id': resultadoId,
      if (tipo != null) 'tipo': tipo,
      if (xMm != null) 'x_mm': xMm,
      if (yMm != null) 'y_mm': yMm,
      if (anchoMm != null) 'ancho_mm': anchoMm,
      if (largoMm != null) 'largo_mm': largoMm,
    });
  }

  ZonasCompanion copyWith({
    Value<int>? id,
    Value<int>? resultadoId,
    Value<String>? tipo,
    Value<int>? xMm,
    Value<int>? yMm,
    Value<int>? anchoMm,
    Value<int>? largoMm,
  }) {
    return ZonasCompanion(
      id: id ?? this.id,
      resultadoId: resultadoId ?? this.resultadoId,
      tipo: tipo ?? this.tipo,
      xMm: xMm ?? this.xMm,
      yMm: yMm ?? this.yMm,
      anchoMm: anchoMm ?? this.anchoMm,
      largoMm: largoMm ?? this.largoMm,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (resultadoId.present) {
      map['resultado_id'] = Variable<int>(resultadoId.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (xMm.present) {
      map['x_mm'] = Variable<int>(xMm.value);
    }
    if (yMm.present) {
      map['y_mm'] = Variable<int>(yMm.value);
    }
    if (anchoMm.present) {
      map['ancho_mm'] = Variable<int>(anchoMm.value);
    }
    if (largoMm.present) {
      map['largo_mm'] = Variable<int>(largoMm.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ZonasCompanion(')
          ..write('id: $id, ')
          ..write('resultadoId: $resultadoId, ')
          ..write('tipo: $tipo, ')
          ..write('xMm: $xMm, ')
          ..write('yMm: $yMm, ')
          ..write('anchoMm: $anchoMm, ')
          ..write('largoMm: $largoMm')
          ..write(')'))
        .toString();
  }
}

class $MemoriaCalculoTable extends MemoriaCalculo
    with TableInfo<$MemoriaCalculoTable, MemoriaCalculoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemoriaCalculoTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _resultadoIdMeta = const VerificationMeta(
    'resultadoId',
  );
  @override
  late final GeneratedColumn<int> resultadoId = GeneratedColumn<int>(
    'resultado_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES resultados (id) ON DELETE CASCADE',
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
  static const VerificationMeta _conceptoMeta = const VerificationMeta(
    'concepto',
  );
  @override
  late final GeneratedColumn<String> concepto = GeneratedColumn<String>(
    'concepto',
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
  static const VerificationMeta _entradasMeta = const VerificationMeta(
    'entradas',
  );
  @override
  late final GeneratedColumn<String> entradas = GeneratedColumn<String>(
    'entradas',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valorMeta = const VerificationMeta('valor');
  @override
  late final GeneratedColumn<String> valor = GeneratedColumn<String>(
    'valor',
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
  static const VerificationMeta _fuenteMeta = const VerificationMeta('fuente');
  @override
  late final GeneratedColumn<String> fuente = GeneratedColumn<String>(
    'fuente',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    resultadoId,
    orden,
    modulo,
    concepto,
    formula,
    entradas,
    valor,
    unidad,
    fuente,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'memoria_calculo';
  @override
  VerificationContext validateIntegrity(
    Insertable<MemoriaCalculoData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('resultado_id')) {
      context.handle(
        _resultadoIdMeta,
        resultadoId.isAcceptableOrUnknown(
          data['resultado_id']!,
          _resultadoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_resultadoIdMeta);
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
    if (data.containsKey('concepto')) {
      context.handle(
        _conceptoMeta,
        concepto.isAcceptableOrUnknown(data['concepto']!, _conceptoMeta),
      );
    } else if (isInserting) {
      context.missing(_conceptoMeta);
    }
    if (data.containsKey('formula')) {
      context.handle(
        _formulaMeta,
        formula.isAcceptableOrUnknown(data['formula']!, _formulaMeta),
      );
    } else if (isInserting) {
      context.missing(_formulaMeta);
    }
    if (data.containsKey('entradas')) {
      context.handle(
        _entradasMeta,
        entradas.isAcceptableOrUnknown(data['entradas']!, _entradasMeta),
      );
    } else if (isInserting) {
      context.missing(_entradasMeta);
    }
    if (data.containsKey('valor')) {
      context.handle(
        _valorMeta,
        valor.isAcceptableOrUnknown(data['valor']!, _valorMeta),
      );
    } else if (isInserting) {
      context.missing(_valorMeta);
    }
    if (data.containsKey('unidad')) {
      context.handle(
        _unidadMeta,
        unidad.isAcceptableOrUnknown(data['unidad']!, _unidadMeta),
      );
    } else if (isInserting) {
      context.missing(_unidadMeta);
    }
    if (data.containsKey('fuente')) {
      context.handle(
        _fuenteMeta,
        fuente.isAcceptableOrUnknown(data['fuente']!, _fuenteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MemoriaCalculoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemoriaCalculoData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      resultadoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}resultado_id'],
      )!,
      orden: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}orden'],
      )!,
      modulo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}modulo'],
      )!,
      concepto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}concepto'],
      )!,
      formula: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}formula'],
      )!,
      entradas: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entradas'],
      )!,
      valor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}valor'],
      )!,
      unidad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unidad'],
      )!,
      fuente: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fuente'],
      ),
    );
  }

  @override
  $MemoriaCalculoTable createAlias(String alias) {
    return $MemoriaCalculoTable(attachedDatabase, alias);
  }
}

class MemoriaCalculoData extends DataClass
    implements Insertable<MemoriaCalculoData> {
  final int id;
  final int resultadoId;
  final int orden;
  final String modulo;
  final String concepto;
  final String formula;
  final String entradas;
  final String valor;
  final String unidad;
  final String? fuente;
  const MemoriaCalculoData({
    required this.id,
    required this.resultadoId,
    required this.orden,
    required this.modulo,
    required this.concepto,
    required this.formula,
    required this.entradas,
    required this.valor,
    required this.unidad,
    this.fuente,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['resultado_id'] = Variable<int>(resultadoId);
    map['orden'] = Variable<int>(orden);
    map['modulo'] = Variable<String>(modulo);
    map['concepto'] = Variable<String>(concepto);
    map['formula'] = Variable<String>(formula);
    map['entradas'] = Variable<String>(entradas);
    map['valor'] = Variable<String>(valor);
    map['unidad'] = Variable<String>(unidad);
    if (!nullToAbsent || fuente != null) {
      map['fuente'] = Variable<String>(fuente);
    }
    return map;
  }

  MemoriaCalculoCompanion toCompanion(bool nullToAbsent) {
    return MemoriaCalculoCompanion(
      id: Value(id),
      resultadoId: Value(resultadoId),
      orden: Value(orden),
      modulo: Value(modulo),
      concepto: Value(concepto),
      formula: Value(formula),
      entradas: Value(entradas),
      valor: Value(valor),
      unidad: Value(unidad),
      fuente: fuente == null && nullToAbsent
          ? const Value.absent()
          : Value(fuente),
    );
  }

  factory MemoriaCalculoData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemoriaCalculoData(
      id: serializer.fromJson<int>(json['id']),
      resultadoId: serializer.fromJson<int>(json['resultadoId']),
      orden: serializer.fromJson<int>(json['orden']),
      modulo: serializer.fromJson<String>(json['modulo']),
      concepto: serializer.fromJson<String>(json['concepto']),
      formula: serializer.fromJson<String>(json['formula']),
      entradas: serializer.fromJson<String>(json['entradas']),
      valor: serializer.fromJson<String>(json['valor']),
      unidad: serializer.fromJson<String>(json['unidad']),
      fuente: serializer.fromJson<String?>(json['fuente']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'resultadoId': serializer.toJson<int>(resultadoId),
      'orden': serializer.toJson<int>(orden),
      'modulo': serializer.toJson<String>(modulo),
      'concepto': serializer.toJson<String>(concepto),
      'formula': serializer.toJson<String>(formula),
      'entradas': serializer.toJson<String>(entradas),
      'valor': serializer.toJson<String>(valor),
      'unidad': serializer.toJson<String>(unidad),
      'fuente': serializer.toJson<String?>(fuente),
    };
  }

  MemoriaCalculoData copyWith({
    int? id,
    int? resultadoId,
    int? orden,
    String? modulo,
    String? concepto,
    String? formula,
    String? entradas,
    String? valor,
    String? unidad,
    Value<String?> fuente = const Value.absent(),
  }) => MemoriaCalculoData(
    id: id ?? this.id,
    resultadoId: resultadoId ?? this.resultadoId,
    orden: orden ?? this.orden,
    modulo: modulo ?? this.modulo,
    concepto: concepto ?? this.concepto,
    formula: formula ?? this.formula,
    entradas: entradas ?? this.entradas,
    valor: valor ?? this.valor,
    unidad: unidad ?? this.unidad,
    fuente: fuente.present ? fuente.value : this.fuente,
  );
  MemoriaCalculoData copyWithCompanion(MemoriaCalculoCompanion data) {
    return MemoriaCalculoData(
      id: data.id.present ? data.id.value : this.id,
      resultadoId: data.resultadoId.present
          ? data.resultadoId.value
          : this.resultadoId,
      orden: data.orden.present ? data.orden.value : this.orden,
      modulo: data.modulo.present ? data.modulo.value : this.modulo,
      concepto: data.concepto.present ? data.concepto.value : this.concepto,
      formula: data.formula.present ? data.formula.value : this.formula,
      entradas: data.entradas.present ? data.entradas.value : this.entradas,
      valor: data.valor.present ? data.valor.value : this.valor,
      unidad: data.unidad.present ? data.unidad.value : this.unidad,
      fuente: data.fuente.present ? data.fuente.value : this.fuente,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemoriaCalculoData(')
          ..write('id: $id, ')
          ..write('resultadoId: $resultadoId, ')
          ..write('orden: $orden, ')
          ..write('modulo: $modulo, ')
          ..write('concepto: $concepto, ')
          ..write('formula: $formula, ')
          ..write('entradas: $entradas, ')
          ..write('valor: $valor, ')
          ..write('unidad: $unidad, ')
          ..write('fuente: $fuente')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    resultadoId,
    orden,
    modulo,
    concepto,
    formula,
    entradas,
    valor,
    unidad,
    fuente,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemoriaCalculoData &&
          other.id == this.id &&
          other.resultadoId == this.resultadoId &&
          other.orden == this.orden &&
          other.modulo == this.modulo &&
          other.concepto == this.concepto &&
          other.formula == this.formula &&
          other.entradas == this.entradas &&
          other.valor == this.valor &&
          other.unidad == this.unidad &&
          other.fuente == this.fuente);
}

class MemoriaCalculoCompanion extends UpdateCompanion<MemoriaCalculoData> {
  final Value<int> id;
  final Value<int> resultadoId;
  final Value<int> orden;
  final Value<String> modulo;
  final Value<String> concepto;
  final Value<String> formula;
  final Value<String> entradas;
  final Value<String> valor;
  final Value<String> unidad;
  final Value<String?> fuente;
  const MemoriaCalculoCompanion({
    this.id = const Value.absent(),
    this.resultadoId = const Value.absent(),
    this.orden = const Value.absent(),
    this.modulo = const Value.absent(),
    this.concepto = const Value.absent(),
    this.formula = const Value.absent(),
    this.entradas = const Value.absent(),
    this.valor = const Value.absent(),
    this.unidad = const Value.absent(),
    this.fuente = const Value.absent(),
  });
  MemoriaCalculoCompanion.insert({
    this.id = const Value.absent(),
    required int resultadoId,
    required int orden,
    required String modulo,
    required String concepto,
    required String formula,
    required String entradas,
    required String valor,
    required String unidad,
    this.fuente = const Value.absent(),
  }) : resultadoId = Value(resultadoId),
       orden = Value(orden),
       modulo = Value(modulo),
       concepto = Value(concepto),
       formula = Value(formula),
       entradas = Value(entradas),
       valor = Value(valor),
       unidad = Value(unidad);
  static Insertable<MemoriaCalculoData> custom({
    Expression<int>? id,
    Expression<int>? resultadoId,
    Expression<int>? orden,
    Expression<String>? modulo,
    Expression<String>? concepto,
    Expression<String>? formula,
    Expression<String>? entradas,
    Expression<String>? valor,
    Expression<String>? unidad,
    Expression<String>? fuente,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (resultadoId != null) 'resultado_id': resultadoId,
      if (orden != null) 'orden': orden,
      if (modulo != null) 'modulo': modulo,
      if (concepto != null) 'concepto': concepto,
      if (formula != null) 'formula': formula,
      if (entradas != null) 'entradas': entradas,
      if (valor != null) 'valor': valor,
      if (unidad != null) 'unidad': unidad,
      if (fuente != null) 'fuente': fuente,
    });
  }

  MemoriaCalculoCompanion copyWith({
    Value<int>? id,
    Value<int>? resultadoId,
    Value<int>? orden,
    Value<String>? modulo,
    Value<String>? concepto,
    Value<String>? formula,
    Value<String>? entradas,
    Value<String>? valor,
    Value<String>? unidad,
    Value<String?>? fuente,
  }) {
    return MemoriaCalculoCompanion(
      id: id ?? this.id,
      resultadoId: resultadoId ?? this.resultadoId,
      orden: orden ?? this.orden,
      modulo: modulo ?? this.modulo,
      concepto: concepto ?? this.concepto,
      formula: formula ?? this.formula,
      entradas: entradas ?? this.entradas,
      valor: valor ?? this.valor,
      unidad: unidad ?? this.unidad,
      fuente: fuente ?? this.fuente,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (resultadoId.present) {
      map['resultado_id'] = Variable<int>(resultadoId.value);
    }
    if (orden.present) {
      map['orden'] = Variable<int>(orden.value);
    }
    if (modulo.present) {
      map['modulo'] = Variable<String>(modulo.value);
    }
    if (concepto.present) {
      map['concepto'] = Variable<String>(concepto.value);
    }
    if (formula.present) {
      map['formula'] = Variable<String>(formula.value);
    }
    if (entradas.present) {
      map['entradas'] = Variable<String>(entradas.value);
    }
    if (valor.present) {
      map['valor'] = Variable<String>(valor.value);
    }
    if (unidad.present) {
      map['unidad'] = Variable<String>(unidad.value);
    }
    if (fuente.present) {
      map['fuente'] = Variable<String>(fuente.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemoriaCalculoCompanion(')
          ..write('id: $id, ')
          ..write('resultadoId: $resultadoId, ')
          ..write('orden: $orden, ')
          ..write('modulo: $modulo, ')
          ..write('concepto: $concepto, ')
          ..write('formula: $formula, ')
          ..write('entradas: $entradas, ')
          ..write('valor: $valor, ')
          ..write('unidad: $unidad, ')
          ..write('fuente: $fuente')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CatalogoTarimasTable catalogoTarimas = $CatalogoTarimasTable(
    this,
  );
  late final $CatalogoBastidoresTable catalogoBastidores =
      $CatalogoBastidoresTable(this);
  late final $CatalogoVigasTable catalogoVigas = $CatalogoVigasTable(this);
  late final $CatalogoEquiposTable catalogoEquipos = $CatalogoEquiposTable(
    this,
  );
  late final $CatalogoCamionesTable catalogoCamiones = $CatalogoCamionesTable(
    this,
  );
  late final $ParametrosNormaTable parametrosNorma = $ParametrosNormaTable(
    this,
  );
  late final $ProyectosTable proyectos = $ProyectosTable(this);
  late final $FamiliasProductoTable familiasProducto = $FamiliasProductoTable(
    this,
  );
  late final $DemandaPeriodosTable demandaPeriodos = $DemandaPeriodosTable(
    this,
  );
  late final $EscenariosTable escenarios = $EscenariosTable(this);
  late final $ResultadosTable resultados = $ResultadosTable(this);
  late final $ZonasTable zonas = $ZonasTable(this);
  late final $MemoriaCalculoTable memoriaCalculo = $MemoriaCalculoTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    catalogoTarimas,
    catalogoBastidores,
    catalogoVigas,
    catalogoEquipos,
    catalogoCamiones,
    parametrosNorma,
    proyectos,
    familiasProducto,
    demandaPeriodos,
    escenarios,
    resultados,
    zonas,
    memoriaCalculo,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'proyectos',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('familias_producto', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'familias_producto',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('demanda_periodos', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'proyectos',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('escenarios', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'escenarios',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('resultados', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'resultados',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('zonas', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'resultados',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('memoria_calculo', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$CatalogoTarimasTableCreateCompanionBuilder =
    CatalogoTarimasCompanion Function({
      Value<int> id,
      required String codigo,
      required int largoMm,
      required int anchoMm,
      required int altoMm,
      required int taraG,
      Value<int?> cargaDinG,
      Value<int?> cargaEstG,
      Value<String?> region,
      required String fuente,
      Value<bool> esSemilla,
    });
typedef $$CatalogoTarimasTableUpdateCompanionBuilder =
    CatalogoTarimasCompanion Function({
      Value<int> id,
      Value<String> codigo,
      Value<int> largoMm,
      Value<int> anchoMm,
      Value<int> altoMm,
      Value<int> taraG,
      Value<int?> cargaDinG,
      Value<int?> cargaEstG,
      Value<String?> region,
      Value<String> fuente,
      Value<bool> esSemilla,
    });

final class $$CatalogoTarimasTableReferences
    extends
        BaseReferences<_$AppDatabase, $CatalogoTarimasTable, CatalogoTarima> {
  $$CatalogoTarimasTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$FamiliasProductoTable, List<FamiliasProductoData>>
  _familiasProductoRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.familiasProducto,
    aliasName: 'catalogo_tarimas__id__familias_producto__tarima_id',
  );

  $$FamiliasProductoTableProcessedTableManager get familiasProductoRefs {
    final manager = $$FamiliasProductoTableTableManager(
      $_db,
      $_db.familiasProducto,
    ).filter((f) => f.tarimaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _familiasProductoRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CatalogoTarimasTableFilterComposer
    extends Composer<_$AppDatabase, $CatalogoTarimasTable> {
  $$CatalogoTarimasTableFilterComposer({
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

  ColumnFilters<int> get largoMm => $composableBuilder(
    column: $table.largoMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get anchoMm => $composableBuilder(
    column: $table.anchoMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get altoMm => $composableBuilder(
    column: $table.altoMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taraG => $composableBuilder(
    column: $table.taraG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cargaDinG => $composableBuilder(
    column: $table.cargaDinG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cargaEstG => $composableBuilder(
    column: $table.cargaEstG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fuente => $composableBuilder(
    column: $table.fuente,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get esSemilla => $composableBuilder(
    column: $table.esSemilla,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> familiasProductoRefs(
    Expression<bool> Function($$FamiliasProductoTableFilterComposer f) f,
  ) {
    final $$FamiliasProductoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.familiasProducto,
      getReferencedColumn: (t) => t.tarimaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FamiliasProductoTableFilterComposer(
            $db: $db,
            $table: $db.familiasProducto,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CatalogoTarimasTableOrderingComposer
    extends Composer<_$AppDatabase, $CatalogoTarimasTable> {
  $$CatalogoTarimasTableOrderingComposer({
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

  ColumnOrderings<int> get largoMm => $composableBuilder(
    column: $table.largoMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get anchoMm => $composableBuilder(
    column: $table.anchoMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get altoMm => $composableBuilder(
    column: $table.altoMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taraG => $composableBuilder(
    column: $table.taraG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cargaDinG => $composableBuilder(
    column: $table.cargaDinG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cargaEstG => $composableBuilder(
    column: $table.cargaEstG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fuente => $composableBuilder(
    column: $table.fuente,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get esSemilla => $composableBuilder(
    column: $table.esSemilla,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CatalogoTarimasTableAnnotationComposer
    extends Composer<_$AppDatabase, $CatalogoTarimasTable> {
  $$CatalogoTarimasTableAnnotationComposer({
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

  GeneratedColumn<int> get largoMm =>
      $composableBuilder(column: $table.largoMm, builder: (column) => column);

  GeneratedColumn<int> get anchoMm =>
      $composableBuilder(column: $table.anchoMm, builder: (column) => column);

  GeneratedColumn<int> get altoMm =>
      $composableBuilder(column: $table.altoMm, builder: (column) => column);

  GeneratedColumn<int> get taraG =>
      $composableBuilder(column: $table.taraG, builder: (column) => column);

  GeneratedColumn<int> get cargaDinG =>
      $composableBuilder(column: $table.cargaDinG, builder: (column) => column);

  GeneratedColumn<int> get cargaEstG =>
      $composableBuilder(column: $table.cargaEstG, builder: (column) => column);

  GeneratedColumn<String> get region =>
      $composableBuilder(column: $table.region, builder: (column) => column);

  GeneratedColumn<String> get fuente =>
      $composableBuilder(column: $table.fuente, builder: (column) => column);

  GeneratedColumn<bool> get esSemilla =>
      $composableBuilder(column: $table.esSemilla, builder: (column) => column);

  Expression<T> familiasProductoRefs<T extends Object>(
    Expression<T> Function($$FamiliasProductoTableAnnotationComposer a) f,
  ) {
    final $$FamiliasProductoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.familiasProducto,
      getReferencedColumn: (t) => t.tarimaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FamiliasProductoTableAnnotationComposer(
            $db: $db,
            $table: $db.familiasProducto,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CatalogoTarimasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatalogoTarimasTable,
          CatalogoTarima,
          $$CatalogoTarimasTableFilterComposer,
          $$CatalogoTarimasTableOrderingComposer,
          $$CatalogoTarimasTableAnnotationComposer,
          $$CatalogoTarimasTableCreateCompanionBuilder,
          $$CatalogoTarimasTableUpdateCompanionBuilder,
          (CatalogoTarima, $$CatalogoTarimasTableReferences),
          CatalogoTarima,
          PrefetchHooks Function({bool familiasProductoRefs})
        > {
  $$CatalogoTarimasTableTableManager(
    _$AppDatabase db,
    $CatalogoTarimasTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatalogoTarimasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatalogoTarimasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatalogoTarimasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> codigo = const Value.absent(),
                Value<int> largoMm = const Value.absent(),
                Value<int> anchoMm = const Value.absent(),
                Value<int> altoMm = const Value.absent(),
                Value<int> taraG = const Value.absent(),
                Value<int?> cargaDinG = const Value.absent(),
                Value<int?> cargaEstG = const Value.absent(),
                Value<String?> region = const Value.absent(),
                Value<String> fuente = const Value.absent(),
                Value<bool> esSemilla = const Value.absent(),
              }) => CatalogoTarimasCompanion(
                id: id,
                codigo: codigo,
                largoMm: largoMm,
                anchoMm: anchoMm,
                altoMm: altoMm,
                taraG: taraG,
                cargaDinG: cargaDinG,
                cargaEstG: cargaEstG,
                region: region,
                fuente: fuente,
                esSemilla: esSemilla,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String codigo,
                required int largoMm,
                required int anchoMm,
                required int altoMm,
                required int taraG,
                Value<int?> cargaDinG = const Value.absent(),
                Value<int?> cargaEstG = const Value.absent(),
                Value<String?> region = const Value.absent(),
                required String fuente,
                Value<bool> esSemilla = const Value.absent(),
              }) => CatalogoTarimasCompanion.insert(
                id: id,
                codigo: codigo,
                largoMm: largoMm,
                anchoMm: anchoMm,
                altoMm: altoMm,
                taraG: taraG,
                cargaDinG: cargaDinG,
                cargaEstG: cargaEstG,
                region: region,
                fuente: fuente,
                esSemilla: esSemilla,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CatalogoTarimasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({familiasProductoRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (familiasProductoRefs) db.familiasProducto,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (familiasProductoRefs)
                    await $_getPrefetchedData<
                      CatalogoTarima,
                      $CatalogoTarimasTable,
                      FamiliasProductoData
                    >(
                      currentTable: table,
                      referencedTable: $$CatalogoTarimasTableReferences
                          ._familiasProductoRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CatalogoTarimasTableReferences(
                            db,
                            table,
                            p0,
                          ).familiasProductoRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.tarimaId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CatalogoTarimasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatalogoTarimasTable,
      CatalogoTarima,
      $$CatalogoTarimasTableFilterComposer,
      $$CatalogoTarimasTableOrderingComposer,
      $$CatalogoTarimasTableAnnotationComposer,
      $$CatalogoTarimasTableCreateCompanionBuilder,
      $$CatalogoTarimasTableUpdateCompanionBuilder,
      (CatalogoTarima, $$CatalogoTarimasTableReferences),
      CatalogoTarima,
      PrefetchHooks Function({bool familiasProductoRefs})
    >;
typedef $$CatalogoBastidoresTableCreateCompanionBuilder =
    CatalogoBastidoresCompanion Function({
      Value<int> id,
      required String codigo,
      required int fondoMm,
      required int alturaMm,
      required int perfilAnchoMm,
      required int perfilFondoMm,
      required String fuente,
      Value<bool> esSemilla,
    });
typedef $$CatalogoBastidoresTableUpdateCompanionBuilder =
    CatalogoBastidoresCompanion Function({
      Value<int> id,
      Value<String> codigo,
      Value<int> fondoMm,
      Value<int> alturaMm,
      Value<int> perfilAnchoMm,
      Value<int> perfilFondoMm,
      Value<String> fuente,
      Value<bool> esSemilla,
    });

final class $$CatalogoBastidoresTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CatalogoBastidoresTable,
          CatalogoBastidore
        > {
  $$CatalogoBastidoresTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$EscenariosTable, List<Escenario>>
  _escenariosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.escenarios,
    aliasName: 'catalogo_bastidores__id__escenarios__bastidor_id',
  );

  $$EscenariosTableProcessedTableManager get escenariosRefs {
    final manager = $$EscenariosTableTableManager(
      $_db,
      $_db.escenarios,
    ).filter((f) => f.bastidorId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_escenariosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CatalogoBastidoresTableFilterComposer
    extends Composer<_$AppDatabase, $CatalogoBastidoresTable> {
  $$CatalogoBastidoresTableFilterComposer({
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

  ColumnFilters<int> get fondoMm => $composableBuilder(
    column: $table.fondoMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get alturaMm => $composableBuilder(
    column: $table.alturaMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get perfilAnchoMm => $composableBuilder(
    column: $table.perfilAnchoMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get perfilFondoMm => $composableBuilder(
    column: $table.perfilFondoMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fuente => $composableBuilder(
    column: $table.fuente,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get esSemilla => $composableBuilder(
    column: $table.esSemilla,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> escenariosRefs(
    Expression<bool> Function($$EscenariosTableFilterComposer f) f,
  ) {
    final $$EscenariosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.escenarios,
      getReferencedColumn: (t) => t.bastidorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EscenariosTableFilterComposer(
            $db: $db,
            $table: $db.escenarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CatalogoBastidoresTableOrderingComposer
    extends Composer<_$AppDatabase, $CatalogoBastidoresTable> {
  $$CatalogoBastidoresTableOrderingComposer({
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

  ColumnOrderings<int> get fondoMm => $composableBuilder(
    column: $table.fondoMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get alturaMm => $composableBuilder(
    column: $table.alturaMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get perfilAnchoMm => $composableBuilder(
    column: $table.perfilAnchoMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get perfilFondoMm => $composableBuilder(
    column: $table.perfilFondoMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fuente => $composableBuilder(
    column: $table.fuente,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get esSemilla => $composableBuilder(
    column: $table.esSemilla,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CatalogoBastidoresTableAnnotationComposer
    extends Composer<_$AppDatabase, $CatalogoBastidoresTable> {
  $$CatalogoBastidoresTableAnnotationComposer({
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

  GeneratedColumn<int> get fondoMm =>
      $composableBuilder(column: $table.fondoMm, builder: (column) => column);

  GeneratedColumn<int> get alturaMm =>
      $composableBuilder(column: $table.alturaMm, builder: (column) => column);

  GeneratedColumn<int> get perfilAnchoMm => $composableBuilder(
    column: $table.perfilAnchoMm,
    builder: (column) => column,
  );

  GeneratedColumn<int> get perfilFondoMm => $composableBuilder(
    column: $table.perfilFondoMm,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fuente =>
      $composableBuilder(column: $table.fuente, builder: (column) => column);

  GeneratedColumn<bool> get esSemilla =>
      $composableBuilder(column: $table.esSemilla, builder: (column) => column);

  Expression<T> escenariosRefs<T extends Object>(
    Expression<T> Function($$EscenariosTableAnnotationComposer a) f,
  ) {
    final $$EscenariosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.escenarios,
      getReferencedColumn: (t) => t.bastidorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EscenariosTableAnnotationComposer(
            $db: $db,
            $table: $db.escenarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CatalogoBastidoresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatalogoBastidoresTable,
          CatalogoBastidore,
          $$CatalogoBastidoresTableFilterComposer,
          $$CatalogoBastidoresTableOrderingComposer,
          $$CatalogoBastidoresTableAnnotationComposer,
          $$CatalogoBastidoresTableCreateCompanionBuilder,
          $$CatalogoBastidoresTableUpdateCompanionBuilder,
          (CatalogoBastidore, $$CatalogoBastidoresTableReferences),
          CatalogoBastidore,
          PrefetchHooks Function({bool escenariosRefs})
        > {
  $$CatalogoBastidoresTableTableManager(
    _$AppDatabase db,
    $CatalogoBastidoresTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatalogoBastidoresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatalogoBastidoresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatalogoBastidoresTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> codigo = const Value.absent(),
                Value<int> fondoMm = const Value.absent(),
                Value<int> alturaMm = const Value.absent(),
                Value<int> perfilAnchoMm = const Value.absent(),
                Value<int> perfilFondoMm = const Value.absent(),
                Value<String> fuente = const Value.absent(),
                Value<bool> esSemilla = const Value.absent(),
              }) => CatalogoBastidoresCompanion(
                id: id,
                codigo: codigo,
                fondoMm: fondoMm,
                alturaMm: alturaMm,
                perfilAnchoMm: perfilAnchoMm,
                perfilFondoMm: perfilFondoMm,
                fuente: fuente,
                esSemilla: esSemilla,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String codigo,
                required int fondoMm,
                required int alturaMm,
                required int perfilAnchoMm,
                required int perfilFondoMm,
                required String fuente,
                Value<bool> esSemilla = const Value.absent(),
              }) => CatalogoBastidoresCompanion.insert(
                id: id,
                codigo: codigo,
                fondoMm: fondoMm,
                alturaMm: alturaMm,
                perfilAnchoMm: perfilAnchoMm,
                perfilFondoMm: perfilFondoMm,
                fuente: fuente,
                esSemilla: esSemilla,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CatalogoBastidoresTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({escenariosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (escenariosRefs) db.escenarios],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (escenariosRefs)
                    await $_getPrefetchedData<
                      CatalogoBastidore,
                      $CatalogoBastidoresTable,
                      Escenario
                    >(
                      currentTable: table,
                      referencedTable: $$CatalogoBastidoresTableReferences
                          ._escenariosRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CatalogoBastidoresTableReferences(
                            db,
                            table,
                            p0,
                          ).escenariosRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.bastidorId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CatalogoBastidoresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatalogoBastidoresTable,
      CatalogoBastidore,
      $$CatalogoBastidoresTableFilterComposer,
      $$CatalogoBastidoresTableOrderingComposer,
      $$CatalogoBastidoresTableAnnotationComposer,
      $$CatalogoBastidoresTableCreateCompanionBuilder,
      $$CatalogoBastidoresTableUpdateCompanionBuilder,
      (CatalogoBastidore, $$CatalogoBastidoresTableReferences),
      CatalogoBastidore,
      PrefetchHooks Function({bool escenariosRefs})
    >;
typedef $$CatalogoVigasTableCreateCompanionBuilder =
    CatalogoVigasCompanion Function({
      Value<int> id,
      required String codigo,
      required int largoMm,
      required int peralteMm,
      Value<int?> capacidadParG,
      required String fuente,
      Value<bool> esSemilla,
    });
typedef $$CatalogoVigasTableUpdateCompanionBuilder =
    CatalogoVigasCompanion Function({
      Value<int> id,
      Value<String> codigo,
      Value<int> largoMm,
      Value<int> peralteMm,
      Value<int?> capacidadParG,
      Value<String> fuente,
      Value<bool> esSemilla,
    });

final class $$CatalogoVigasTableReferences
    extends BaseReferences<_$AppDatabase, $CatalogoVigasTable, CatalogoViga> {
  $$CatalogoVigasTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$EscenariosTable, List<Escenario>>
  _escenariosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.escenarios,
    aliasName: 'catalogo_vigas__id__escenarios__viga_id',
  );

  $$EscenariosTableProcessedTableManager get escenariosRefs {
    final manager = $$EscenariosTableTableManager(
      $_db,
      $_db.escenarios,
    ).filter((f) => f.vigaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_escenariosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CatalogoVigasTableFilterComposer
    extends Composer<_$AppDatabase, $CatalogoVigasTable> {
  $$CatalogoVigasTableFilterComposer({
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

  ColumnFilters<int> get largoMm => $composableBuilder(
    column: $table.largoMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get peralteMm => $composableBuilder(
    column: $table.peralteMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get capacidadParG => $composableBuilder(
    column: $table.capacidadParG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fuente => $composableBuilder(
    column: $table.fuente,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get esSemilla => $composableBuilder(
    column: $table.esSemilla,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> escenariosRefs(
    Expression<bool> Function($$EscenariosTableFilterComposer f) f,
  ) {
    final $$EscenariosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.escenarios,
      getReferencedColumn: (t) => t.vigaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EscenariosTableFilterComposer(
            $db: $db,
            $table: $db.escenarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CatalogoVigasTableOrderingComposer
    extends Composer<_$AppDatabase, $CatalogoVigasTable> {
  $$CatalogoVigasTableOrderingComposer({
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

  ColumnOrderings<int> get largoMm => $composableBuilder(
    column: $table.largoMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get peralteMm => $composableBuilder(
    column: $table.peralteMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get capacidadParG => $composableBuilder(
    column: $table.capacidadParG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fuente => $composableBuilder(
    column: $table.fuente,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get esSemilla => $composableBuilder(
    column: $table.esSemilla,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CatalogoVigasTableAnnotationComposer
    extends Composer<_$AppDatabase, $CatalogoVigasTable> {
  $$CatalogoVigasTableAnnotationComposer({
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

  GeneratedColumn<int> get largoMm =>
      $composableBuilder(column: $table.largoMm, builder: (column) => column);

  GeneratedColumn<int> get peralteMm =>
      $composableBuilder(column: $table.peralteMm, builder: (column) => column);

  GeneratedColumn<int> get capacidadParG => $composableBuilder(
    column: $table.capacidadParG,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fuente =>
      $composableBuilder(column: $table.fuente, builder: (column) => column);

  GeneratedColumn<bool> get esSemilla =>
      $composableBuilder(column: $table.esSemilla, builder: (column) => column);

  Expression<T> escenariosRefs<T extends Object>(
    Expression<T> Function($$EscenariosTableAnnotationComposer a) f,
  ) {
    final $$EscenariosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.escenarios,
      getReferencedColumn: (t) => t.vigaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EscenariosTableAnnotationComposer(
            $db: $db,
            $table: $db.escenarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CatalogoVigasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatalogoVigasTable,
          CatalogoViga,
          $$CatalogoVigasTableFilterComposer,
          $$CatalogoVigasTableOrderingComposer,
          $$CatalogoVigasTableAnnotationComposer,
          $$CatalogoVigasTableCreateCompanionBuilder,
          $$CatalogoVigasTableUpdateCompanionBuilder,
          (CatalogoViga, $$CatalogoVigasTableReferences),
          CatalogoViga,
          PrefetchHooks Function({bool escenariosRefs})
        > {
  $$CatalogoVigasTableTableManager(_$AppDatabase db, $CatalogoVigasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatalogoVigasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatalogoVigasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatalogoVigasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> codigo = const Value.absent(),
                Value<int> largoMm = const Value.absent(),
                Value<int> peralteMm = const Value.absent(),
                Value<int?> capacidadParG = const Value.absent(),
                Value<String> fuente = const Value.absent(),
                Value<bool> esSemilla = const Value.absent(),
              }) => CatalogoVigasCompanion(
                id: id,
                codigo: codigo,
                largoMm: largoMm,
                peralteMm: peralteMm,
                capacidadParG: capacidadParG,
                fuente: fuente,
                esSemilla: esSemilla,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String codigo,
                required int largoMm,
                required int peralteMm,
                Value<int?> capacidadParG = const Value.absent(),
                required String fuente,
                Value<bool> esSemilla = const Value.absent(),
              }) => CatalogoVigasCompanion.insert(
                id: id,
                codigo: codigo,
                largoMm: largoMm,
                peralteMm: peralteMm,
                capacidadParG: capacidadParG,
                fuente: fuente,
                esSemilla: esSemilla,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CatalogoVigasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({escenariosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (escenariosRefs) db.escenarios],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (escenariosRefs)
                    await $_getPrefetchedData<
                      CatalogoViga,
                      $CatalogoVigasTable,
                      Escenario
                    >(
                      currentTable: table,
                      referencedTable: $$CatalogoVigasTableReferences
                          ._escenariosRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CatalogoVigasTableReferences(
                            db,
                            table,
                            p0,
                          ).escenariosRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.vigaId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CatalogoVigasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatalogoVigasTable,
      CatalogoViga,
      $$CatalogoVigasTableFilterComposer,
      $$CatalogoVigasTableOrderingComposer,
      $$CatalogoVigasTableAnnotationComposer,
      $$CatalogoVigasTableCreateCompanionBuilder,
      $$CatalogoVigasTableUpdateCompanionBuilder,
      (CatalogoViga, $$CatalogoVigasTableReferences),
      CatalogoViga,
      PrefetchHooks Function({bool escenariosRefs})
    >;
typedef $$CatalogoEquiposTableCreateCompanionBuilder =
    CatalogoEquiposCompanion Function({
      Value<int> id,
      required String codigo,
      required String tipo,
      Value<String?> claseEn,
      required int pasilloMinMm,
      required int pasilloMaxMm,
      required int elevacionMaxMm,
      Value<int?> alturaMastilMm,
      Value<bool> requiereGuiado,
      Value<int?> costoUnitarioCent,
      required String fuente,
      Value<bool> esSemilla,
    });
typedef $$CatalogoEquiposTableUpdateCompanionBuilder =
    CatalogoEquiposCompanion Function({
      Value<int> id,
      Value<String> codigo,
      Value<String> tipo,
      Value<String?> claseEn,
      Value<int> pasilloMinMm,
      Value<int> pasilloMaxMm,
      Value<int> elevacionMaxMm,
      Value<int?> alturaMastilMm,
      Value<bool> requiereGuiado,
      Value<int?> costoUnitarioCent,
      Value<String> fuente,
      Value<bool> esSemilla,
    });

final class $$CatalogoEquiposTableReferences
    extends
        BaseReferences<_$AppDatabase, $CatalogoEquiposTable, CatalogoEquipo> {
  $$CatalogoEquiposTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$EscenariosTable, List<Escenario>>
  _escenariosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.escenarios,
    aliasName: 'catalogo_equipos__id__escenarios__equipo_id',
  );

  $$EscenariosTableProcessedTableManager get escenariosRefs {
    final manager = $$EscenariosTableTableManager(
      $_db,
      $_db.escenarios,
    ).filter((f) => f.equipoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_escenariosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CatalogoEquiposTableFilterComposer
    extends Composer<_$AppDatabase, $CatalogoEquiposTable> {
  $$CatalogoEquiposTableFilterComposer({
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

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get claseEn => $composableBuilder(
    column: $table.claseEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pasilloMinMm => $composableBuilder(
    column: $table.pasilloMinMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pasilloMaxMm => $composableBuilder(
    column: $table.pasilloMaxMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get elevacionMaxMm => $composableBuilder(
    column: $table.elevacionMaxMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get alturaMastilMm => $composableBuilder(
    column: $table.alturaMastilMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get requiereGuiado => $composableBuilder(
    column: $table.requiereGuiado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get costoUnitarioCent => $composableBuilder(
    column: $table.costoUnitarioCent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fuente => $composableBuilder(
    column: $table.fuente,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get esSemilla => $composableBuilder(
    column: $table.esSemilla,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> escenariosRefs(
    Expression<bool> Function($$EscenariosTableFilterComposer f) f,
  ) {
    final $$EscenariosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.escenarios,
      getReferencedColumn: (t) => t.equipoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EscenariosTableFilterComposer(
            $db: $db,
            $table: $db.escenarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CatalogoEquiposTableOrderingComposer
    extends Composer<_$AppDatabase, $CatalogoEquiposTable> {
  $$CatalogoEquiposTableOrderingComposer({
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

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get claseEn => $composableBuilder(
    column: $table.claseEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pasilloMinMm => $composableBuilder(
    column: $table.pasilloMinMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pasilloMaxMm => $composableBuilder(
    column: $table.pasilloMaxMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get elevacionMaxMm => $composableBuilder(
    column: $table.elevacionMaxMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get alturaMastilMm => $composableBuilder(
    column: $table.alturaMastilMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get requiereGuiado => $composableBuilder(
    column: $table.requiereGuiado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get costoUnitarioCent => $composableBuilder(
    column: $table.costoUnitarioCent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fuente => $composableBuilder(
    column: $table.fuente,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get esSemilla => $composableBuilder(
    column: $table.esSemilla,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CatalogoEquiposTableAnnotationComposer
    extends Composer<_$AppDatabase, $CatalogoEquiposTable> {
  $$CatalogoEquiposTableAnnotationComposer({
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

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get claseEn =>
      $composableBuilder(column: $table.claseEn, builder: (column) => column);

  GeneratedColumn<int> get pasilloMinMm => $composableBuilder(
    column: $table.pasilloMinMm,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pasilloMaxMm => $composableBuilder(
    column: $table.pasilloMaxMm,
    builder: (column) => column,
  );

  GeneratedColumn<int> get elevacionMaxMm => $composableBuilder(
    column: $table.elevacionMaxMm,
    builder: (column) => column,
  );

  GeneratedColumn<int> get alturaMastilMm => $composableBuilder(
    column: $table.alturaMastilMm,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get requiereGuiado => $composableBuilder(
    column: $table.requiereGuiado,
    builder: (column) => column,
  );

  GeneratedColumn<int> get costoUnitarioCent => $composableBuilder(
    column: $table.costoUnitarioCent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fuente =>
      $composableBuilder(column: $table.fuente, builder: (column) => column);

  GeneratedColumn<bool> get esSemilla =>
      $composableBuilder(column: $table.esSemilla, builder: (column) => column);

  Expression<T> escenariosRefs<T extends Object>(
    Expression<T> Function($$EscenariosTableAnnotationComposer a) f,
  ) {
    final $$EscenariosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.escenarios,
      getReferencedColumn: (t) => t.equipoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EscenariosTableAnnotationComposer(
            $db: $db,
            $table: $db.escenarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CatalogoEquiposTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatalogoEquiposTable,
          CatalogoEquipo,
          $$CatalogoEquiposTableFilterComposer,
          $$CatalogoEquiposTableOrderingComposer,
          $$CatalogoEquiposTableAnnotationComposer,
          $$CatalogoEquiposTableCreateCompanionBuilder,
          $$CatalogoEquiposTableUpdateCompanionBuilder,
          (CatalogoEquipo, $$CatalogoEquiposTableReferences),
          CatalogoEquipo,
          PrefetchHooks Function({bool escenariosRefs})
        > {
  $$CatalogoEquiposTableTableManager(
    _$AppDatabase db,
    $CatalogoEquiposTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatalogoEquiposTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatalogoEquiposTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatalogoEquiposTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> codigo = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<String?> claseEn = const Value.absent(),
                Value<int> pasilloMinMm = const Value.absent(),
                Value<int> pasilloMaxMm = const Value.absent(),
                Value<int> elevacionMaxMm = const Value.absent(),
                Value<int?> alturaMastilMm = const Value.absent(),
                Value<bool> requiereGuiado = const Value.absent(),
                Value<int?> costoUnitarioCent = const Value.absent(),
                Value<String> fuente = const Value.absent(),
                Value<bool> esSemilla = const Value.absent(),
              }) => CatalogoEquiposCompanion(
                id: id,
                codigo: codigo,
                tipo: tipo,
                claseEn: claseEn,
                pasilloMinMm: pasilloMinMm,
                pasilloMaxMm: pasilloMaxMm,
                elevacionMaxMm: elevacionMaxMm,
                alturaMastilMm: alturaMastilMm,
                requiereGuiado: requiereGuiado,
                costoUnitarioCent: costoUnitarioCent,
                fuente: fuente,
                esSemilla: esSemilla,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String codigo,
                required String tipo,
                Value<String?> claseEn = const Value.absent(),
                required int pasilloMinMm,
                required int pasilloMaxMm,
                required int elevacionMaxMm,
                Value<int?> alturaMastilMm = const Value.absent(),
                Value<bool> requiereGuiado = const Value.absent(),
                Value<int?> costoUnitarioCent = const Value.absent(),
                required String fuente,
                Value<bool> esSemilla = const Value.absent(),
              }) => CatalogoEquiposCompanion.insert(
                id: id,
                codigo: codigo,
                tipo: tipo,
                claseEn: claseEn,
                pasilloMinMm: pasilloMinMm,
                pasilloMaxMm: pasilloMaxMm,
                elevacionMaxMm: elevacionMaxMm,
                alturaMastilMm: alturaMastilMm,
                requiereGuiado: requiereGuiado,
                costoUnitarioCent: costoUnitarioCent,
                fuente: fuente,
                esSemilla: esSemilla,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CatalogoEquiposTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({escenariosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (escenariosRefs) db.escenarios],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (escenariosRefs)
                    await $_getPrefetchedData<
                      CatalogoEquipo,
                      $CatalogoEquiposTable,
                      Escenario
                    >(
                      currentTable: table,
                      referencedTable: $$CatalogoEquiposTableReferences
                          ._escenariosRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CatalogoEquiposTableReferences(
                            db,
                            table,
                            p0,
                          ).escenariosRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.equipoId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CatalogoEquiposTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatalogoEquiposTable,
      CatalogoEquipo,
      $$CatalogoEquiposTableFilterComposer,
      $$CatalogoEquiposTableOrderingComposer,
      $$CatalogoEquiposTableAnnotationComposer,
      $$CatalogoEquiposTableCreateCompanionBuilder,
      $$CatalogoEquiposTableUpdateCompanionBuilder,
      (CatalogoEquipo, $$CatalogoEquiposTableReferences),
      CatalogoEquipo,
      PrefetchHooks Function({bool escenariosRefs})
    >;
typedef $$CatalogoCamionesTableCreateCompanionBuilder =
    CatalogoCamionesCompanion Function({
      Value<int> id,
      required String codigo,
      required int largoMm,
      required int anchoMm,
      required int patioMinMm,
      required String fuente,
      Value<bool> esSemilla,
    });
typedef $$CatalogoCamionesTableUpdateCompanionBuilder =
    CatalogoCamionesCompanion Function({
      Value<int> id,
      Value<String> codigo,
      Value<int> largoMm,
      Value<int> anchoMm,
      Value<int> patioMinMm,
      Value<String> fuente,
      Value<bool> esSemilla,
    });

class $$CatalogoCamionesTableFilterComposer
    extends Composer<_$AppDatabase, $CatalogoCamionesTable> {
  $$CatalogoCamionesTableFilterComposer({
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

  ColumnFilters<int> get largoMm => $composableBuilder(
    column: $table.largoMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get anchoMm => $composableBuilder(
    column: $table.anchoMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get patioMinMm => $composableBuilder(
    column: $table.patioMinMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fuente => $composableBuilder(
    column: $table.fuente,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get esSemilla => $composableBuilder(
    column: $table.esSemilla,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CatalogoCamionesTableOrderingComposer
    extends Composer<_$AppDatabase, $CatalogoCamionesTable> {
  $$CatalogoCamionesTableOrderingComposer({
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

  ColumnOrderings<int> get largoMm => $composableBuilder(
    column: $table.largoMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get anchoMm => $composableBuilder(
    column: $table.anchoMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get patioMinMm => $composableBuilder(
    column: $table.patioMinMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fuente => $composableBuilder(
    column: $table.fuente,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get esSemilla => $composableBuilder(
    column: $table.esSemilla,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CatalogoCamionesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CatalogoCamionesTable> {
  $$CatalogoCamionesTableAnnotationComposer({
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

  GeneratedColumn<int> get largoMm =>
      $composableBuilder(column: $table.largoMm, builder: (column) => column);

  GeneratedColumn<int> get anchoMm =>
      $composableBuilder(column: $table.anchoMm, builder: (column) => column);

  GeneratedColumn<int> get patioMinMm => $composableBuilder(
    column: $table.patioMinMm,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fuente =>
      $composableBuilder(column: $table.fuente, builder: (column) => column);

  GeneratedColumn<bool> get esSemilla =>
      $composableBuilder(column: $table.esSemilla, builder: (column) => column);
}

class $$CatalogoCamionesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatalogoCamionesTable,
          CatalogoCamione,
          $$CatalogoCamionesTableFilterComposer,
          $$CatalogoCamionesTableOrderingComposer,
          $$CatalogoCamionesTableAnnotationComposer,
          $$CatalogoCamionesTableCreateCompanionBuilder,
          $$CatalogoCamionesTableUpdateCompanionBuilder,
          (
            CatalogoCamione,
            BaseReferences<
              _$AppDatabase,
              $CatalogoCamionesTable,
              CatalogoCamione
            >,
          ),
          CatalogoCamione,
          PrefetchHooks Function()
        > {
  $$CatalogoCamionesTableTableManager(
    _$AppDatabase db,
    $CatalogoCamionesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatalogoCamionesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatalogoCamionesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatalogoCamionesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> codigo = const Value.absent(),
                Value<int> largoMm = const Value.absent(),
                Value<int> anchoMm = const Value.absent(),
                Value<int> patioMinMm = const Value.absent(),
                Value<String> fuente = const Value.absent(),
                Value<bool> esSemilla = const Value.absent(),
              }) => CatalogoCamionesCompanion(
                id: id,
                codigo: codigo,
                largoMm: largoMm,
                anchoMm: anchoMm,
                patioMinMm: patioMinMm,
                fuente: fuente,
                esSemilla: esSemilla,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String codigo,
                required int largoMm,
                required int anchoMm,
                required int patioMinMm,
                required String fuente,
                Value<bool> esSemilla = const Value.absent(),
              }) => CatalogoCamionesCompanion.insert(
                id: id,
                codigo: codigo,
                largoMm: largoMm,
                anchoMm: anchoMm,
                patioMinMm: patioMinMm,
                fuente: fuente,
                esSemilla: esSemilla,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CatalogoCamionesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatalogoCamionesTable,
      CatalogoCamione,
      $$CatalogoCamionesTableFilterComposer,
      $$CatalogoCamionesTableOrderingComposer,
      $$CatalogoCamionesTableAnnotationComposer,
      $$CatalogoCamionesTableCreateCompanionBuilder,
      $$CatalogoCamionesTableUpdateCompanionBuilder,
      (
        CatalogoCamione,
        BaseReferences<_$AppDatabase, $CatalogoCamionesTable, CatalogoCamione>,
      ),
      CatalogoCamione,
      PrefetchHooks Function()
    >;
typedef $$ParametrosNormaTableCreateCompanionBuilder =
    ParametrosNormaCompanion Function({
      Value<int> id,
      required String norma,
      required String clave,
      required int valor,
      Value<String?> clase,
      required String fuente,
    });
typedef $$ParametrosNormaTableUpdateCompanionBuilder =
    ParametrosNormaCompanion Function({
      Value<int> id,
      Value<String> norma,
      Value<String> clave,
      Value<int> valor,
      Value<String?> clase,
      Value<String> fuente,
    });

class $$ParametrosNormaTableFilterComposer
    extends Composer<_$AppDatabase, $ParametrosNormaTable> {
  $$ParametrosNormaTableFilterComposer({
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

  ColumnFilters<String> get norma => $composableBuilder(
    column: $table.norma,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clave => $composableBuilder(
    column: $table.clave,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clase => $composableBuilder(
    column: $table.clase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fuente => $composableBuilder(
    column: $table.fuente,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ParametrosNormaTableOrderingComposer
    extends Composer<_$AppDatabase, $ParametrosNormaTable> {
  $$ParametrosNormaTableOrderingComposer({
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

  ColumnOrderings<String> get norma => $composableBuilder(
    column: $table.norma,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clave => $composableBuilder(
    column: $table.clave,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clase => $composableBuilder(
    column: $table.clase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fuente => $composableBuilder(
    column: $table.fuente,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ParametrosNormaTableAnnotationComposer
    extends Composer<_$AppDatabase, $ParametrosNormaTable> {
  $$ParametrosNormaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get norma =>
      $composableBuilder(column: $table.norma, builder: (column) => column);

  GeneratedColumn<String> get clave =>
      $composableBuilder(column: $table.clave, builder: (column) => column);

  GeneratedColumn<int> get valor =>
      $composableBuilder(column: $table.valor, builder: (column) => column);

  GeneratedColumn<String> get clase =>
      $composableBuilder(column: $table.clase, builder: (column) => column);

  GeneratedColumn<String> get fuente =>
      $composableBuilder(column: $table.fuente, builder: (column) => column);
}

class $$ParametrosNormaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ParametrosNormaTable,
          ParametrosNormaData,
          $$ParametrosNormaTableFilterComposer,
          $$ParametrosNormaTableOrderingComposer,
          $$ParametrosNormaTableAnnotationComposer,
          $$ParametrosNormaTableCreateCompanionBuilder,
          $$ParametrosNormaTableUpdateCompanionBuilder,
          (
            ParametrosNormaData,
            BaseReferences<
              _$AppDatabase,
              $ParametrosNormaTable,
              ParametrosNormaData
            >,
          ),
          ParametrosNormaData,
          PrefetchHooks Function()
        > {
  $$ParametrosNormaTableTableManager(
    _$AppDatabase db,
    $ParametrosNormaTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ParametrosNormaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ParametrosNormaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ParametrosNormaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> norma = const Value.absent(),
                Value<String> clave = const Value.absent(),
                Value<int> valor = const Value.absent(),
                Value<String?> clase = const Value.absent(),
                Value<String> fuente = const Value.absent(),
              }) => ParametrosNormaCompanion(
                id: id,
                norma: norma,
                clave: clave,
                valor: valor,
                clase: clase,
                fuente: fuente,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String norma,
                required String clave,
                required int valor,
                Value<String?> clase = const Value.absent(),
                required String fuente,
              }) => ParametrosNormaCompanion.insert(
                id: id,
                norma: norma,
                clave: clave,
                valor: valor,
                clase: clase,
                fuente: fuente,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ParametrosNormaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ParametrosNormaTable,
      ParametrosNormaData,
      $$ParametrosNormaTableFilterComposer,
      $$ParametrosNormaTableOrderingComposer,
      $$ParametrosNormaTableAnnotationComposer,
      $$ParametrosNormaTableCreateCompanionBuilder,
      $$ParametrosNormaTableUpdateCompanionBuilder,
      (
        ParametrosNormaData,
        BaseReferences<
          _$AppDatabase,
          $ParametrosNormaTable,
          ParametrosNormaData
        >,
      ),
      ParametrosNormaData,
      PrefetchHooks Function()
    >;
typedef $$ProyectosTableCreateCompanionBuilder = ProyectosCompanion Function({
  Value<int> id,
  required String nombre,
  Value<String> norma,
  Value<String> moneda,
  Value<int> horizonteAnios,
  Value<int?> alturaLibreMm,
  Value<int> reservaTechoMm,
  required String creadoEn,
});
typedef $$ProyectosTableUpdateCompanionBuilder = ProyectosCompanion Function({
  Value<int> id,
  Value<String> nombre,
  Value<String> norma,
  Value<String> moneda,
  Value<int> horizonteAnios,
  Value<int?> alturaLibreMm,
  Value<int> reservaTechoMm,
  Value<String> creadoEn,
});

final class $$ProyectosTableReferences
    extends BaseReferences<_$AppDatabase, $ProyectosTable, Proyecto> {
  $$ProyectosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FamiliasProductoTable, List<FamiliasProductoData>>
  _familiasProductoRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.familiasProducto,
    aliasName: 'proyectos__id__familias_producto__proyecto_id',
  );

  $$FamiliasProductoTableProcessedTableManager get familiasProductoRefs {
    final manager = $$FamiliasProductoTableTableManager(
      $_db,
      $_db.familiasProducto,
    ).filter((f) => f.proyectoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _familiasProductoRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$EscenariosTable, List<Escenario>>
  _escenariosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.escenarios,
    aliasName: 'proyectos__id__escenarios__proyecto_id',
  );

  $$EscenariosTableProcessedTableManager get escenariosRefs {
    final manager = $$EscenariosTableTableManager(
      $_db,
      $_db.escenarios,
    ).filter((f) => f.proyectoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_escenariosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProyectosTableFilterComposer
    extends Composer<_$AppDatabase, $ProyectosTable> {
  $$ProyectosTableFilterComposer({
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

  ColumnFilters<String> get norma => $composableBuilder(
    column: $table.norma,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moneda => $composableBuilder(
    column: $table.moneda,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get horizonteAnios => $composableBuilder(
    column: $table.horizonteAnios,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get alturaLibreMm => $composableBuilder(
    column: $table.alturaLibreMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reservaTechoMm => $composableBuilder(
    column: $table.reservaTechoMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> familiasProductoRefs(
    Expression<bool> Function($$FamiliasProductoTableFilterComposer f) f,
  ) {
    final $$FamiliasProductoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.familiasProducto,
      getReferencedColumn: (t) => t.proyectoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FamiliasProductoTableFilterComposer(
            $db: $db,
            $table: $db.familiasProducto,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> escenariosRefs(
    Expression<bool> Function($$EscenariosTableFilterComposer f) f,
  ) {
    final $$EscenariosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.escenarios,
      getReferencedColumn: (t) => t.proyectoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EscenariosTableFilterComposer(
            $db: $db,
            $table: $db.escenarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProyectosTableOrderingComposer
    extends Composer<_$AppDatabase, $ProyectosTable> {
  $$ProyectosTableOrderingComposer({
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

  ColumnOrderings<String> get norma => $composableBuilder(
    column: $table.norma,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moneda => $composableBuilder(
    column: $table.moneda,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get horizonteAnios => $composableBuilder(
    column: $table.horizonteAnios,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get alturaLibreMm => $composableBuilder(
    column: $table.alturaLibreMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reservaTechoMm => $composableBuilder(
    column: $table.reservaTechoMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProyectosTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProyectosTable> {
  $$ProyectosTableAnnotationComposer({
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

  GeneratedColumn<String> get norma =>
      $composableBuilder(column: $table.norma, builder: (column) => column);

  GeneratedColumn<String> get moneda =>
      $composableBuilder(column: $table.moneda, builder: (column) => column);

  GeneratedColumn<int> get horizonteAnios => $composableBuilder(
    column: $table.horizonteAnios,
    builder: (column) => column,
  );

  GeneratedColumn<int> get alturaLibreMm => $composableBuilder(
    column: $table.alturaLibreMm,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reservaTechoMm => $composableBuilder(
    column: $table.reservaTechoMm,
    builder: (column) => column,
  );

  GeneratedColumn<String> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  Expression<T> familiasProductoRefs<T extends Object>(
    Expression<T> Function($$FamiliasProductoTableAnnotationComposer a) f,
  ) {
    final $$FamiliasProductoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.familiasProducto,
      getReferencedColumn: (t) => t.proyectoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FamiliasProductoTableAnnotationComposer(
            $db: $db,
            $table: $db.familiasProducto,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> escenariosRefs<T extends Object>(
    Expression<T> Function($$EscenariosTableAnnotationComposer a) f,
  ) {
    final $$EscenariosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.escenarios,
      getReferencedColumn: (t) => t.proyectoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EscenariosTableAnnotationComposer(
            $db: $db,
            $table: $db.escenarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProyectosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProyectosTable,
          Proyecto,
          $$ProyectosTableFilterComposer,
          $$ProyectosTableOrderingComposer,
          $$ProyectosTableAnnotationComposer,
          $$ProyectosTableCreateCompanionBuilder,
          $$ProyectosTableUpdateCompanionBuilder,
          (Proyecto, $$ProyectosTableReferences),
          Proyecto,
          PrefetchHooks Function({
            bool familiasProductoRefs,
            bool escenariosRefs,
          })
        > {
  $$ProyectosTableTableManager(_$AppDatabase db, $ProyectosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProyectosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProyectosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProyectosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> norma = const Value.absent(),
                Value<String> moneda = const Value.absent(),
                Value<int> horizonteAnios = const Value.absent(),
                Value<int?> alturaLibreMm = const Value.absent(),
                Value<int> reservaTechoMm = const Value.absent(),
                Value<String> creadoEn = const Value.absent(),
              }) => ProyectosCompanion(
                id: id,
                nombre: nombre,
                norma: norma,
                moneda: moneda,
                horizonteAnios: horizonteAnios,
                alturaLibreMm: alturaLibreMm,
                reservaTechoMm: reservaTechoMm,
                creadoEn: creadoEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                Value<String> norma = const Value.absent(),
                Value<String> moneda = const Value.absent(),
                Value<int> horizonteAnios = const Value.absent(),
                Value<int?> alturaLibreMm = const Value.absent(),
                Value<int> reservaTechoMm = const Value.absent(),
                required String creadoEn,
              }) => ProyectosCompanion.insert(
                id: id,
                nombre: nombre,
                norma: norma,
                moneda: moneda,
                horizonteAnios: horizonteAnios,
                alturaLibreMm: alturaLibreMm,
                reservaTechoMm: reservaTechoMm,
                creadoEn: creadoEn,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProyectosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({familiasProductoRefs = false, escenariosRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (familiasProductoRefs) db.familiasProducto,
                    if (escenariosRefs) db.escenarios,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (familiasProductoRefs)
                        await $_getPrefetchedData<
                          Proyecto,
                          $ProyectosTable,
                          FamiliasProductoData
                        >(
                          currentTable: table,
                          referencedTable: $$ProyectosTableReferences
                              ._familiasProductoRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProyectosTableReferences(
                                db,
                                table,
                                p0,
                              ).familiasProductoRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.proyectoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (escenariosRefs)
                        await $_getPrefetchedData<
                          Proyecto,
                          $ProyectosTable,
                          Escenario
                        >(
                          currentTable: table,
                          referencedTable: $$ProyectosTableReferences
                              ._escenariosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProyectosTableReferences(
                                db,
                                table,
                                p0,
                              ).escenariosRefs,
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

typedef $$ProyectosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProyectosTable,
      Proyecto,
      $$ProyectosTableFilterComposer,
      $$ProyectosTableOrderingComposer,
      $$ProyectosTableAnnotationComposer,
      $$ProyectosTableCreateCompanionBuilder,
      $$ProyectosTableUpdateCompanionBuilder,
      (Proyecto, $$ProyectosTableReferences),
      Proyecto,
      PrefetchHooks Function({bool familiasProductoRefs, bool escenariosRefs})
    >;
typedef $$FamiliasProductoTableCreateCompanionBuilder =
    FamiliasProductoCompanion Function({
      Value<int> id,
      required int proyectoId,
      required String nombre,
      required int tarimaId,
      required int altoCargaMm,
      required int pesoCargaG,
      required int unidadesPorTarima,
      Value<int> apilableNiveles,
      Value<double?> rotacionAnual,
      Value<String?> claseAbc,
    });
typedef $$FamiliasProductoTableUpdateCompanionBuilder =
    FamiliasProductoCompanion Function({
      Value<int> id,
      Value<int> proyectoId,
      Value<String> nombre,
      Value<int> tarimaId,
      Value<int> altoCargaMm,
      Value<int> pesoCargaG,
      Value<int> unidadesPorTarima,
      Value<int> apilableNiveles,
      Value<double?> rotacionAnual,
      Value<String?> claseAbc,
    });

final class $$FamiliasProductoTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $FamiliasProductoTable,
          FamiliasProductoData
        > {
  $$FamiliasProductoTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProyectosTable _proyectoIdTable(_$AppDatabase db) =>
      db.proyectos.createAlias('familias_producto__proyecto_id__proyectos__id');

  $$ProyectosTableProcessedTableManager get proyectoId {
    final $_column = $_itemColumn<int>('proyecto_id')!;

    final manager = $$ProyectosTableTableManager(
      $_db,
      $_db.proyectos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_proyectoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CatalogoTarimasTable _tarimaIdTable(_$AppDatabase db) => db
      .catalogoTarimas
      .createAlias('familias_producto__tarima_id__catalogo_tarimas__id');

  $$CatalogoTarimasTableProcessedTableManager get tarimaId {
    final $_column = $_itemColumn<int>('tarima_id')!;

    final manager = $$CatalogoTarimasTableTableManager(
      $_db,
      $_db.catalogoTarimas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tarimaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$DemandaPeriodosTable, List<DemandaPeriodo>>
  _demandaPeriodosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.demandaPeriodos,
    aliasName: 'familias_producto__id__demanda_periodos__familia_id',
  );

  $$DemandaPeriodosTableProcessedTableManager get demandaPeriodosRefs {
    final manager = $$DemandaPeriodosTableTableManager(
      $_db,
      $_db.demandaPeriodos,
    ).filter((f) => f.familiaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _demandaPeriodosRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FamiliasProductoTableFilterComposer
    extends Composer<_$AppDatabase, $FamiliasProductoTable> {
  $$FamiliasProductoTableFilterComposer({
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

  ColumnFilters<int> get altoCargaMm => $composableBuilder(
    column: $table.altoCargaMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pesoCargaG => $composableBuilder(
    column: $table.pesoCargaG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unidadesPorTarima => $composableBuilder(
    column: $table.unidadesPorTarima,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get apilableNiveles => $composableBuilder(
    column: $table.apilableNiveles,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rotacionAnual => $composableBuilder(
    column: $table.rotacionAnual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get claseAbc => $composableBuilder(
    column: $table.claseAbc,
    builder: (column) => ColumnFilters(column),
  );

  $$ProyectosTableFilterComposer get proyectoId {
    final $$ProyectosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proyectoId,
      referencedTable: $db.proyectos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProyectosTableFilterComposer(
            $db: $db,
            $table: $db.proyectos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CatalogoTarimasTableFilterComposer get tarimaId {
    final $$CatalogoTarimasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tarimaId,
      referencedTable: $db.catalogoTarimas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatalogoTarimasTableFilterComposer(
            $db: $db,
            $table: $db.catalogoTarimas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> demandaPeriodosRefs(
    Expression<bool> Function($$DemandaPeriodosTableFilterComposer f) f,
  ) {
    final $$DemandaPeriodosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.demandaPeriodos,
      getReferencedColumn: (t) => t.familiaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DemandaPeriodosTableFilterComposer(
            $db: $db,
            $table: $db.demandaPeriodos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FamiliasProductoTableOrderingComposer
    extends Composer<_$AppDatabase, $FamiliasProductoTable> {
  $$FamiliasProductoTableOrderingComposer({
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

  ColumnOrderings<int> get altoCargaMm => $composableBuilder(
    column: $table.altoCargaMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pesoCargaG => $composableBuilder(
    column: $table.pesoCargaG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unidadesPorTarima => $composableBuilder(
    column: $table.unidadesPorTarima,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get apilableNiveles => $composableBuilder(
    column: $table.apilableNiveles,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rotacionAnual => $composableBuilder(
    column: $table.rotacionAnual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get claseAbc => $composableBuilder(
    column: $table.claseAbc,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProyectosTableOrderingComposer get proyectoId {
    final $$ProyectosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proyectoId,
      referencedTable: $db.proyectos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProyectosTableOrderingComposer(
            $db: $db,
            $table: $db.proyectos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CatalogoTarimasTableOrderingComposer get tarimaId {
    final $$CatalogoTarimasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tarimaId,
      referencedTable: $db.catalogoTarimas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatalogoTarimasTableOrderingComposer(
            $db: $db,
            $table: $db.catalogoTarimas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FamiliasProductoTableAnnotationComposer
    extends Composer<_$AppDatabase, $FamiliasProductoTable> {
  $$FamiliasProductoTableAnnotationComposer({
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

  GeneratedColumn<int> get altoCargaMm => $composableBuilder(
    column: $table.altoCargaMm,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pesoCargaG => $composableBuilder(
    column: $table.pesoCargaG,
    builder: (column) => column,
  );

  GeneratedColumn<int> get unidadesPorTarima => $composableBuilder(
    column: $table.unidadesPorTarima,
    builder: (column) => column,
  );

  GeneratedColumn<int> get apilableNiveles => $composableBuilder(
    column: $table.apilableNiveles,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rotacionAnual => $composableBuilder(
    column: $table.rotacionAnual,
    builder: (column) => column,
  );

  GeneratedColumn<String> get claseAbc =>
      $composableBuilder(column: $table.claseAbc, builder: (column) => column);

  $$ProyectosTableAnnotationComposer get proyectoId {
    final $$ProyectosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proyectoId,
      referencedTable: $db.proyectos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProyectosTableAnnotationComposer(
            $db: $db,
            $table: $db.proyectos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CatalogoTarimasTableAnnotationComposer get tarimaId {
    final $$CatalogoTarimasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tarimaId,
      referencedTable: $db.catalogoTarimas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatalogoTarimasTableAnnotationComposer(
            $db: $db,
            $table: $db.catalogoTarimas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> demandaPeriodosRefs<T extends Object>(
    Expression<T> Function($$DemandaPeriodosTableAnnotationComposer a) f,
  ) {
    final $$DemandaPeriodosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.demandaPeriodos,
      getReferencedColumn: (t) => t.familiaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DemandaPeriodosTableAnnotationComposer(
            $db: $db,
            $table: $db.demandaPeriodos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FamiliasProductoTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FamiliasProductoTable,
          FamiliasProductoData,
          $$FamiliasProductoTableFilterComposer,
          $$FamiliasProductoTableOrderingComposer,
          $$FamiliasProductoTableAnnotationComposer,
          $$FamiliasProductoTableCreateCompanionBuilder,
          $$FamiliasProductoTableUpdateCompanionBuilder,
          (FamiliasProductoData, $$FamiliasProductoTableReferences),
          FamiliasProductoData,
          PrefetchHooks Function({
            bool proyectoId,
            bool tarimaId,
            bool demandaPeriodosRefs,
          })
        > {
  $$FamiliasProductoTableTableManager(
    _$AppDatabase db,
    $FamiliasProductoTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FamiliasProductoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FamiliasProductoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FamiliasProductoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> proyectoId = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<int> tarimaId = const Value.absent(),
                Value<int> altoCargaMm = const Value.absent(),
                Value<int> pesoCargaG = const Value.absent(),
                Value<int> unidadesPorTarima = const Value.absent(),
                Value<int> apilableNiveles = const Value.absent(),
                Value<double?> rotacionAnual = const Value.absent(),
                Value<String?> claseAbc = const Value.absent(),
              }) => FamiliasProductoCompanion(
                id: id,
                proyectoId: proyectoId,
                nombre: nombre,
                tarimaId: tarimaId,
                altoCargaMm: altoCargaMm,
                pesoCargaG: pesoCargaG,
                unidadesPorTarima: unidadesPorTarima,
                apilableNiveles: apilableNiveles,
                rotacionAnual: rotacionAnual,
                claseAbc: claseAbc,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int proyectoId,
                required String nombre,
                required int tarimaId,
                required int altoCargaMm,
                required int pesoCargaG,
                required int unidadesPorTarima,
                Value<int> apilableNiveles = const Value.absent(),
                Value<double?> rotacionAnual = const Value.absent(),
                Value<String?> claseAbc = const Value.absent(),
              }) => FamiliasProductoCompanion.insert(
                id: id,
                proyectoId: proyectoId,
                nombre: nombre,
                tarimaId: tarimaId,
                altoCargaMm: altoCargaMm,
                pesoCargaG: pesoCargaG,
                unidadesPorTarima: unidadesPorTarima,
                apilableNiveles: apilableNiveles,
                rotacionAnual: rotacionAnual,
                claseAbc: claseAbc,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FamiliasProductoTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                proyectoId = false,
                tarimaId = false,
                demandaPeriodosRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (demandaPeriodosRefs) db.demandaPeriodos,
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
                            referencedTable: $$FamiliasProductoTableReferences
                                ._proyectoIdTable(db),
                            referencedColumn: $$FamiliasProductoTableReferences
                                ._proyectoIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (tarimaId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.tarimaId,
                            referencedTable: $$FamiliasProductoTableReferences
                                ._tarimaIdTable(db),
                            referencedColumn: $$FamiliasProductoTableReferences
                                ._tarimaIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (demandaPeriodosRefs)
                        await $_getPrefetchedData<
                          FamiliasProductoData,
                          $FamiliasProductoTable,
                          DemandaPeriodo
                        >(
                          currentTable: table,
                          referencedTable: $$FamiliasProductoTableReferences
                              ._demandaPeriodosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FamiliasProductoTableReferences(
                                db,
                                table,
                                p0,
                              ).demandaPeriodosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.familiaId == item.id,
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

typedef $$FamiliasProductoTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FamiliasProductoTable,
      FamiliasProductoData,
      $$FamiliasProductoTableFilterComposer,
      $$FamiliasProductoTableOrderingComposer,
      $$FamiliasProductoTableAnnotationComposer,
      $$FamiliasProductoTableCreateCompanionBuilder,
      $$FamiliasProductoTableUpdateCompanionBuilder,
      (FamiliasProductoData, $$FamiliasProductoTableReferences),
      FamiliasProductoData,
      PrefetchHooks Function({
        bool proyectoId,
        bool tarimaId,
        bool demandaPeriodosRefs,
      })
    >;
typedef $$DemandaPeriodosTableCreateCompanionBuilder =
    DemandaPeriodosCompanion Function({
      Value<int> id,
      required int familiaId,
      required String periodo,
      required double demanda,
      Value<bool> esPronostico,
    });
typedef $$DemandaPeriodosTableUpdateCompanionBuilder =
    DemandaPeriodosCompanion Function({
      Value<int> id,
      Value<int> familiaId,
      Value<String> periodo,
      Value<double> demanda,
      Value<bool> esPronostico,
    });

final class $$DemandaPeriodosTableReferences
    extends
        BaseReferences<_$AppDatabase, $DemandaPeriodosTable, DemandaPeriodo> {
  $$DemandaPeriodosTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $FamiliasProductoTable _familiaIdTable(_$AppDatabase db) => db
      .familiasProducto
      .createAlias('demanda_periodos__familia_id__familias_producto__id');

  $$FamiliasProductoTableProcessedTableManager get familiaId {
    final $_column = $_itemColumn<int>('familia_id')!;

    final manager = $$FamiliasProductoTableTableManager(
      $_db,
      $_db.familiasProducto,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_familiaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DemandaPeriodosTableFilterComposer
    extends Composer<_$AppDatabase, $DemandaPeriodosTable> {
  $$DemandaPeriodosTableFilterComposer({
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

  ColumnFilters<String> get periodo => $composableBuilder(
    column: $table.periodo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get demanda => $composableBuilder(
    column: $table.demanda,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get esPronostico => $composableBuilder(
    column: $table.esPronostico,
    builder: (column) => ColumnFilters(column),
  );

  $$FamiliasProductoTableFilterComposer get familiaId {
    final $$FamiliasProductoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.familiaId,
      referencedTable: $db.familiasProducto,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FamiliasProductoTableFilterComposer(
            $db: $db,
            $table: $db.familiasProducto,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DemandaPeriodosTableOrderingComposer
    extends Composer<_$AppDatabase, $DemandaPeriodosTable> {
  $$DemandaPeriodosTableOrderingComposer({
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

  ColumnOrderings<String> get periodo => $composableBuilder(
    column: $table.periodo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get demanda => $composableBuilder(
    column: $table.demanda,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get esPronostico => $composableBuilder(
    column: $table.esPronostico,
    builder: (column) => ColumnOrderings(column),
  );

  $$FamiliasProductoTableOrderingComposer get familiaId {
    final $$FamiliasProductoTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.familiaId,
      referencedTable: $db.familiasProducto,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FamiliasProductoTableOrderingComposer(
            $db: $db,
            $table: $db.familiasProducto,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DemandaPeriodosTableAnnotationComposer
    extends Composer<_$AppDatabase, $DemandaPeriodosTable> {
  $$DemandaPeriodosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get periodo =>
      $composableBuilder(column: $table.periodo, builder: (column) => column);

  GeneratedColumn<double> get demanda =>
      $composableBuilder(column: $table.demanda, builder: (column) => column);

  GeneratedColumn<bool> get esPronostico => $composableBuilder(
    column: $table.esPronostico,
    builder: (column) => column,
  );

  $$FamiliasProductoTableAnnotationComposer get familiaId {
    final $$FamiliasProductoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.familiaId,
      referencedTable: $db.familiasProducto,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FamiliasProductoTableAnnotationComposer(
            $db: $db,
            $table: $db.familiasProducto,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DemandaPeriodosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DemandaPeriodosTable,
          DemandaPeriodo,
          $$DemandaPeriodosTableFilterComposer,
          $$DemandaPeriodosTableOrderingComposer,
          $$DemandaPeriodosTableAnnotationComposer,
          $$DemandaPeriodosTableCreateCompanionBuilder,
          $$DemandaPeriodosTableUpdateCompanionBuilder,
          (DemandaPeriodo, $$DemandaPeriodosTableReferences),
          DemandaPeriodo,
          PrefetchHooks Function({bool familiaId})
        > {
  $$DemandaPeriodosTableTableManager(
    _$AppDatabase db,
    $DemandaPeriodosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DemandaPeriodosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DemandaPeriodosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DemandaPeriodosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> familiaId = const Value.absent(),
                Value<String> periodo = const Value.absent(),
                Value<double> demanda = const Value.absent(),
                Value<bool> esPronostico = const Value.absent(),
              }) => DemandaPeriodosCompanion(
                id: id,
                familiaId: familiaId,
                periodo: periodo,
                demanda: demanda,
                esPronostico: esPronostico,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int familiaId,
                required String periodo,
                required double demanda,
                Value<bool> esPronostico = const Value.absent(),
              }) => DemandaPeriodosCompanion.insert(
                id: id,
                familiaId: familiaId,
                periodo: periodo,
                demanda: demanda,
                esPronostico: esPronostico,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DemandaPeriodosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({familiaId = false}) {
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
                    if (familiaId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.familiaId,
                        referencedTable: $$DemandaPeriodosTableReferences
                            ._familiaIdTable(db),
                        referencedColumn: $$DemandaPeriodosTableReferences
                            ._familiaIdTable(db)
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

typedef $$DemandaPeriodosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DemandaPeriodosTable,
      DemandaPeriodo,
      $$DemandaPeriodosTableFilterComposer,
      $$DemandaPeriodosTableOrderingComposer,
      $$DemandaPeriodosTableAnnotationComposer,
      $$DemandaPeriodosTableCreateCompanionBuilder,
      $$DemandaPeriodosTableUpdateCompanionBuilder,
      (DemandaPeriodo, $$DemandaPeriodosTableReferences),
      DemandaPeriodo,
      PrefetchHooks Function({bool familiaId})
    >;
typedef $$EscenariosTableCreateCompanionBuilder = EscenariosCompanion Function({
  Value<int> id,
  required int proyectoId,
  required String nombre,
  required String tipoSistema,
  required int equipoId,
  Value<int?> bastidorId,
  Value<int?> vigaId,
  Value<int?> tarimasPorNivel,
  Value<String> patronFlujo,
  Value<double> factorHoneycomb,
  Value<bool> esBase,
});
typedef $$EscenariosTableUpdateCompanionBuilder = EscenariosCompanion Function({
  Value<int> id,
  Value<int> proyectoId,
  Value<String> nombre,
  Value<String> tipoSistema,
  Value<int> equipoId,
  Value<int?> bastidorId,
  Value<int?> vigaId,
  Value<int?> tarimasPorNivel,
  Value<String> patronFlujo,
  Value<double> factorHoneycomb,
  Value<bool> esBase,
});

final class $$EscenariosTableReferences
    extends BaseReferences<_$AppDatabase, $EscenariosTable, Escenario> {
  $$EscenariosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProyectosTable _proyectoIdTable(_$AppDatabase db) =>
      db.proyectos.createAlias('escenarios__proyecto_id__proyectos__id');

  $$ProyectosTableProcessedTableManager get proyectoId {
    final $_column = $_itemColumn<int>('proyecto_id')!;

    final manager = $$ProyectosTableTableManager(
      $_db,
      $_db.proyectos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_proyectoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CatalogoEquiposTable _equipoIdTable(_$AppDatabase db) => db
      .catalogoEquipos
      .createAlias('escenarios__equipo_id__catalogo_equipos__id');

  $$CatalogoEquiposTableProcessedTableManager get equipoId {
    final $_column = $_itemColumn<int>('equipo_id')!;

    final manager = $$CatalogoEquiposTableTableManager(
      $_db,
      $_db.catalogoEquipos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_equipoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CatalogoBastidoresTable _bastidorIdTable(_$AppDatabase db) => db
      .catalogoBastidores
      .createAlias('escenarios__bastidor_id__catalogo_bastidores__id');

  $$CatalogoBastidoresTableProcessedTableManager? get bastidorId {
    final $_column = $_itemColumn<int>('bastidor_id');
    if ($_column == null) return null;
    final manager = $$CatalogoBastidoresTableTableManager(
      $_db,
      $_db.catalogoBastidores,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bastidorIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CatalogoVigasTable _vigaIdTable(_$AppDatabase db) =>
      db.catalogoVigas.createAlias('escenarios__viga_id__catalogo_vigas__id');

  $$CatalogoVigasTableProcessedTableManager? get vigaId {
    final $_column = $_itemColumn<int>('viga_id');
    if ($_column == null) return null;
    final manager = $$CatalogoVigasTableTableManager(
      $_db,
      $_db.catalogoVigas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vigaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ResultadosTable, List<Resultado>>
  _resultadosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.resultados,
    aliasName: 'escenarios__id__resultados__escenario_id',
  );

  $$ResultadosTableProcessedTableManager get resultadosRefs {
    final manager = $$ResultadosTableTableManager(
      $_db,
      $_db.resultados,
    ).filter((f) => f.escenarioId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_resultadosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EscenariosTableFilterComposer
    extends Composer<_$AppDatabase, $EscenariosTable> {
  $$EscenariosTableFilterComposer({
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

  ColumnFilters<String> get tipoSistema => $composableBuilder(
    column: $table.tipoSistema,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tarimasPorNivel => $composableBuilder(
    column: $table.tarimasPorNivel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get patronFlujo => $composableBuilder(
    column: $table.patronFlujo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get factorHoneycomb => $composableBuilder(
    column: $table.factorHoneycomb,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get esBase => $composableBuilder(
    column: $table.esBase,
    builder: (column) => ColumnFilters(column),
  );

  $$ProyectosTableFilterComposer get proyectoId {
    final $$ProyectosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proyectoId,
      referencedTable: $db.proyectos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProyectosTableFilterComposer(
            $db: $db,
            $table: $db.proyectos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CatalogoEquiposTableFilterComposer get equipoId {
    final $$CatalogoEquiposTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipoId,
      referencedTable: $db.catalogoEquipos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatalogoEquiposTableFilterComposer(
            $db: $db,
            $table: $db.catalogoEquipos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CatalogoBastidoresTableFilterComposer get bastidorId {
    final $$CatalogoBastidoresTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bastidorId,
      referencedTable: $db.catalogoBastidores,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatalogoBastidoresTableFilterComposer(
            $db: $db,
            $table: $db.catalogoBastidores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CatalogoVigasTableFilterComposer get vigaId {
    final $$CatalogoVigasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vigaId,
      referencedTable: $db.catalogoVigas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatalogoVigasTableFilterComposer(
            $db: $db,
            $table: $db.catalogoVigas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> resultadosRefs(
    Expression<bool> Function($$ResultadosTableFilterComposer f) f,
  ) {
    final $$ResultadosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.resultados,
      getReferencedColumn: (t) => t.escenarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ResultadosTableFilterComposer(
            $db: $db,
            $table: $db.resultados,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EscenariosTableOrderingComposer
    extends Composer<_$AppDatabase, $EscenariosTable> {
  $$EscenariosTableOrderingComposer({
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

  ColumnOrderings<String> get tipoSistema => $composableBuilder(
    column: $table.tipoSistema,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tarimasPorNivel => $composableBuilder(
    column: $table.tarimasPorNivel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get patronFlujo => $composableBuilder(
    column: $table.patronFlujo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get factorHoneycomb => $composableBuilder(
    column: $table.factorHoneycomb,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get esBase => $composableBuilder(
    column: $table.esBase,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProyectosTableOrderingComposer get proyectoId {
    final $$ProyectosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proyectoId,
      referencedTable: $db.proyectos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProyectosTableOrderingComposer(
            $db: $db,
            $table: $db.proyectos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CatalogoEquiposTableOrderingComposer get equipoId {
    final $$CatalogoEquiposTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipoId,
      referencedTable: $db.catalogoEquipos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatalogoEquiposTableOrderingComposer(
            $db: $db,
            $table: $db.catalogoEquipos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CatalogoBastidoresTableOrderingComposer get bastidorId {
    final $$CatalogoBastidoresTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bastidorId,
      referencedTable: $db.catalogoBastidores,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatalogoBastidoresTableOrderingComposer(
            $db: $db,
            $table: $db.catalogoBastidores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CatalogoVigasTableOrderingComposer get vigaId {
    final $$CatalogoVigasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vigaId,
      referencedTable: $db.catalogoVigas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatalogoVigasTableOrderingComposer(
            $db: $db,
            $table: $db.catalogoVigas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EscenariosTableAnnotationComposer
    extends Composer<_$AppDatabase, $EscenariosTable> {
  $$EscenariosTableAnnotationComposer({
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

  GeneratedColumn<String> get tipoSistema => $composableBuilder(
    column: $table.tipoSistema,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tarimasPorNivel => $composableBuilder(
    column: $table.tarimasPorNivel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get patronFlujo => $composableBuilder(
    column: $table.patronFlujo,
    builder: (column) => column,
  );

  GeneratedColumn<double> get factorHoneycomb => $composableBuilder(
    column: $table.factorHoneycomb,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get esBase =>
      $composableBuilder(column: $table.esBase, builder: (column) => column);

  $$ProyectosTableAnnotationComposer get proyectoId {
    final $$ProyectosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proyectoId,
      referencedTable: $db.proyectos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProyectosTableAnnotationComposer(
            $db: $db,
            $table: $db.proyectos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CatalogoEquiposTableAnnotationComposer get equipoId {
    final $$CatalogoEquiposTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipoId,
      referencedTable: $db.catalogoEquipos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatalogoEquiposTableAnnotationComposer(
            $db: $db,
            $table: $db.catalogoEquipos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CatalogoBastidoresTableAnnotationComposer get bastidorId {
    final $$CatalogoBastidoresTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.bastidorId,
          referencedTable: $db.catalogoBastidores,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CatalogoBastidoresTableAnnotationComposer(
                $db: $db,
                $table: $db.catalogoBastidores,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$CatalogoVigasTableAnnotationComposer get vigaId {
    final $$CatalogoVigasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vigaId,
      referencedTable: $db.catalogoVigas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatalogoVigasTableAnnotationComposer(
            $db: $db,
            $table: $db.catalogoVigas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> resultadosRefs<T extends Object>(
    Expression<T> Function($$ResultadosTableAnnotationComposer a) f,
  ) {
    final $$ResultadosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.resultados,
      getReferencedColumn: (t) => t.escenarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ResultadosTableAnnotationComposer(
            $db: $db,
            $table: $db.resultados,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EscenariosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EscenariosTable,
          Escenario,
          $$EscenariosTableFilterComposer,
          $$EscenariosTableOrderingComposer,
          $$EscenariosTableAnnotationComposer,
          $$EscenariosTableCreateCompanionBuilder,
          $$EscenariosTableUpdateCompanionBuilder,
          (Escenario, $$EscenariosTableReferences),
          Escenario,
          PrefetchHooks Function({
            bool proyectoId,
            bool equipoId,
            bool bastidorId,
            bool vigaId,
            bool resultadosRefs,
          })
        > {
  $$EscenariosTableTableManager(_$AppDatabase db, $EscenariosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EscenariosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EscenariosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EscenariosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> proyectoId = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> tipoSistema = const Value.absent(),
                Value<int> equipoId = const Value.absent(),
                Value<int?> bastidorId = const Value.absent(),
                Value<int?> vigaId = const Value.absent(),
                Value<int?> tarimasPorNivel = const Value.absent(),
                Value<String> patronFlujo = const Value.absent(),
                Value<double> factorHoneycomb = const Value.absent(),
                Value<bool> esBase = const Value.absent(),
              }) => EscenariosCompanion(
                id: id,
                proyectoId: proyectoId,
                nombre: nombre,
                tipoSistema: tipoSistema,
                equipoId: equipoId,
                bastidorId: bastidorId,
                vigaId: vigaId,
                tarimasPorNivel: tarimasPorNivel,
                patronFlujo: patronFlujo,
                factorHoneycomb: factorHoneycomb,
                esBase: esBase,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int proyectoId,
                required String nombre,
                required String tipoSistema,
                required int equipoId,
                Value<int?> bastidorId = const Value.absent(),
                Value<int?> vigaId = const Value.absent(),
                Value<int?> tarimasPorNivel = const Value.absent(),
                Value<String> patronFlujo = const Value.absent(),
                Value<double> factorHoneycomb = const Value.absent(),
                Value<bool> esBase = const Value.absent(),
              }) => EscenariosCompanion.insert(
                id: id,
                proyectoId: proyectoId,
                nombre: nombre,
                tipoSistema: tipoSistema,
                equipoId: equipoId,
                bastidorId: bastidorId,
                vigaId: vigaId,
                tarimasPorNivel: tarimasPorNivel,
                patronFlujo: patronFlujo,
                factorHoneycomb: factorHoneycomb,
                esBase: esBase,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EscenariosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                proyectoId = false,
                equipoId = false,
                bastidorId = false,
                vigaId = false,
                resultadosRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (resultadosRefs) db.resultados],
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
                            referencedTable: $$EscenariosTableReferences
                                ._proyectoIdTable(db),
                            referencedColumn: $$EscenariosTableReferences
                                ._proyectoIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (equipoId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.equipoId,
                            referencedTable: $$EscenariosTableReferences
                                ._equipoIdTable(db),
                            referencedColumn: $$EscenariosTableReferences
                                ._equipoIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (bastidorId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.bastidorId,
                            referencedTable: $$EscenariosTableReferences
                                ._bastidorIdTable(db),
                            referencedColumn: $$EscenariosTableReferences
                                ._bastidorIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (vigaId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.vigaId,
                            referencedTable: $$EscenariosTableReferences
                                ._vigaIdTable(db),
                            referencedColumn: $$EscenariosTableReferences
                                ._vigaIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (resultadosRefs)
                        await $_getPrefetchedData<
                          Escenario,
                          $EscenariosTable,
                          Resultado
                        >(
                          currentTable: table,
                          referencedTable: $$EscenariosTableReferences
                              ._resultadosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EscenariosTableReferences(
                                db,
                                table,
                                p0,
                              ).resultadosRefs,
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

typedef $$EscenariosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EscenariosTable,
      Escenario,
      $$EscenariosTableFilterComposer,
      $$EscenariosTableOrderingComposer,
      $$EscenariosTableAnnotationComposer,
      $$EscenariosTableCreateCompanionBuilder,
      $$EscenariosTableUpdateCompanionBuilder,
      (Escenario, $$EscenariosTableReferences),
      Escenario,
      PrefetchHooks Function({
        bool proyectoId,
        bool equipoId,
        bool bastidorId,
        bool vigaId,
        bool resultadosRefs,
      })
    >;
typedef $$ResultadosTableCreateCompanionBuilder = ResultadosCompanion Function({
  Value<int> id,
  required int escenarioId,
  required String calculadoEn,
  required int posicionesRequeridas,
  required int posicionesInstaladas,
  required int modulos,
  required int filas,
  required int niveles,
  required int supAlmacenamientoMm2,
  required int supConstruidaMm2,
  required int puertasAnden,
  required int patioProfundidadMm,
  Value<int?> distanciaEsperadaMm,
  Value<int?> inversionCent,
});
typedef $$ResultadosTableUpdateCompanionBuilder = ResultadosCompanion Function({
  Value<int> id,
  Value<int> escenarioId,
  Value<String> calculadoEn,
  Value<int> posicionesRequeridas,
  Value<int> posicionesInstaladas,
  Value<int> modulos,
  Value<int> filas,
  Value<int> niveles,
  Value<int> supAlmacenamientoMm2,
  Value<int> supConstruidaMm2,
  Value<int> puertasAnden,
  Value<int> patioProfundidadMm,
  Value<int?> distanciaEsperadaMm,
  Value<int?> inversionCent,
});

final class $$ResultadosTableReferences
    extends BaseReferences<_$AppDatabase, $ResultadosTable, Resultado> {
  $$ResultadosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EscenariosTable _escenarioIdTable(_$AppDatabase db) =>
      db.escenarios.createAlias('resultados__escenario_id__escenarios__id');

  $$EscenariosTableProcessedTableManager get escenarioId {
    final $_column = $_itemColumn<int>('escenario_id')!;

    final manager = $$EscenariosTableTableManager(
      $_db,
      $_db.escenarios,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_escenarioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ZonasTable, List<Zona>> _zonasRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.zonas,
    aliasName: 'resultados__id__zonas__resultado_id',
  );

  $$ZonasTableProcessedTableManager get zonasRefs {
    final manager = $$ZonasTableTableManager(
      $_db,
      $_db.zonas,
    ).filter((f) => f.resultadoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_zonasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MemoriaCalculoTable, List<MemoriaCalculoData>>
  _memoriaCalculoRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.memoriaCalculo,
    aliasName: 'resultados__id__memoria_calculo__resultado_id',
  );

  $$MemoriaCalculoTableProcessedTableManager get memoriaCalculoRefs {
    final manager = $$MemoriaCalculoTableTableManager(
      $_db,
      $_db.memoriaCalculo,
    ).filter((f) => f.resultadoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_memoriaCalculoRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ResultadosTableFilterComposer
    extends Composer<_$AppDatabase, $ResultadosTable> {
  $$ResultadosTableFilterComposer({
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

  ColumnFilters<String> get calculadoEn => $composableBuilder(
    column: $table.calculadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get posicionesRequeridas => $composableBuilder(
    column: $table.posicionesRequeridas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get posicionesInstaladas => $composableBuilder(
    column: $table.posicionesInstaladas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get modulos => $composableBuilder(
    column: $table.modulos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get filas => $composableBuilder(
    column: $table.filas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get niveles => $composableBuilder(
    column: $table.niveles,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get supAlmacenamientoMm2 => $composableBuilder(
    column: $table.supAlmacenamientoMm2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get supConstruidaMm2 => $composableBuilder(
    column: $table.supConstruidaMm2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get puertasAnden => $composableBuilder(
    column: $table.puertasAnden,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get patioProfundidadMm => $composableBuilder(
    column: $table.patioProfundidadMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get distanciaEsperadaMm => $composableBuilder(
    column: $table.distanciaEsperadaMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get inversionCent => $composableBuilder(
    column: $table.inversionCent,
    builder: (column) => ColumnFilters(column),
  );

  $$EscenariosTableFilterComposer get escenarioId {
    final $$EscenariosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.escenarioId,
      referencedTable: $db.escenarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EscenariosTableFilterComposer(
            $db: $db,
            $table: $db.escenarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> zonasRefs(
    Expression<bool> Function($$ZonasTableFilterComposer f) f,
  ) {
    final $$ZonasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.zonas,
      getReferencedColumn: (t) => t.resultadoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ZonasTableFilterComposer(
            $db: $db,
            $table: $db.zonas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> memoriaCalculoRefs(
    Expression<bool> Function($$MemoriaCalculoTableFilterComposer f) f,
  ) {
    final $$MemoriaCalculoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.memoriaCalculo,
      getReferencedColumn: (t) => t.resultadoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemoriaCalculoTableFilterComposer(
            $db: $db,
            $table: $db.memoriaCalculo,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ResultadosTableOrderingComposer
    extends Composer<_$AppDatabase, $ResultadosTable> {
  $$ResultadosTableOrderingComposer({
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

  ColumnOrderings<String> get calculadoEn => $composableBuilder(
    column: $table.calculadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get posicionesRequeridas => $composableBuilder(
    column: $table.posicionesRequeridas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get posicionesInstaladas => $composableBuilder(
    column: $table.posicionesInstaladas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get modulos => $composableBuilder(
    column: $table.modulos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get filas => $composableBuilder(
    column: $table.filas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get niveles => $composableBuilder(
    column: $table.niveles,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get supAlmacenamientoMm2 => $composableBuilder(
    column: $table.supAlmacenamientoMm2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get supConstruidaMm2 => $composableBuilder(
    column: $table.supConstruidaMm2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get puertasAnden => $composableBuilder(
    column: $table.puertasAnden,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get patioProfundidadMm => $composableBuilder(
    column: $table.patioProfundidadMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get distanciaEsperadaMm => $composableBuilder(
    column: $table.distanciaEsperadaMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get inversionCent => $composableBuilder(
    column: $table.inversionCent,
    builder: (column) => ColumnOrderings(column),
  );

  $$EscenariosTableOrderingComposer get escenarioId {
    final $$EscenariosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.escenarioId,
      referencedTable: $db.escenarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EscenariosTableOrderingComposer(
            $db: $db,
            $table: $db.escenarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ResultadosTableAnnotationComposer
    extends Composer<_$AppDatabase, $ResultadosTable> {
  $$ResultadosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get calculadoEn => $composableBuilder(
    column: $table.calculadoEn,
    builder: (column) => column,
  );

  GeneratedColumn<int> get posicionesRequeridas => $composableBuilder(
    column: $table.posicionesRequeridas,
    builder: (column) => column,
  );

  GeneratedColumn<int> get posicionesInstaladas => $composableBuilder(
    column: $table.posicionesInstaladas,
    builder: (column) => column,
  );

  GeneratedColumn<int> get modulos =>
      $composableBuilder(column: $table.modulos, builder: (column) => column);

  GeneratedColumn<int> get filas =>
      $composableBuilder(column: $table.filas, builder: (column) => column);

  GeneratedColumn<int> get niveles =>
      $composableBuilder(column: $table.niveles, builder: (column) => column);

  GeneratedColumn<int> get supAlmacenamientoMm2 => $composableBuilder(
    column: $table.supAlmacenamientoMm2,
    builder: (column) => column,
  );

  GeneratedColumn<int> get supConstruidaMm2 => $composableBuilder(
    column: $table.supConstruidaMm2,
    builder: (column) => column,
  );

  GeneratedColumn<int> get puertasAnden => $composableBuilder(
    column: $table.puertasAnden,
    builder: (column) => column,
  );

  GeneratedColumn<int> get patioProfundidadMm => $composableBuilder(
    column: $table.patioProfundidadMm,
    builder: (column) => column,
  );

  GeneratedColumn<int> get distanciaEsperadaMm => $composableBuilder(
    column: $table.distanciaEsperadaMm,
    builder: (column) => column,
  );

  GeneratedColumn<int> get inversionCent => $composableBuilder(
    column: $table.inversionCent,
    builder: (column) => column,
  );

  $$EscenariosTableAnnotationComposer get escenarioId {
    final $$EscenariosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.escenarioId,
      referencedTable: $db.escenarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EscenariosTableAnnotationComposer(
            $db: $db,
            $table: $db.escenarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> zonasRefs<T extends Object>(
    Expression<T> Function($$ZonasTableAnnotationComposer a) f,
  ) {
    final $$ZonasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.zonas,
      getReferencedColumn: (t) => t.resultadoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ZonasTableAnnotationComposer(
            $db: $db,
            $table: $db.zonas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> memoriaCalculoRefs<T extends Object>(
    Expression<T> Function($$MemoriaCalculoTableAnnotationComposer a) f,
  ) {
    final $$MemoriaCalculoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.memoriaCalculo,
      getReferencedColumn: (t) => t.resultadoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemoriaCalculoTableAnnotationComposer(
            $db: $db,
            $table: $db.memoriaCalculo,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ResultadosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ResultadosTable,
          Resultado,
          $$ResultadosTableFilterComposer,
          $$ResultadosTableOrderingComposer,
          $$ResultadosTableAnnotationComposer,
          $$ResultadosTableCreateCompanionBuilder,
          $$ResultadosTableUpdateCompanionBuilder,
          (Resultado, $$ResultadosTableReferences),
          Resultado,
          PrefetchHooks Function({
            bool escenarioId,
            bool zonasRefs,
            bool memoriaCalculoRefs,
          })
        > {
  $$ResultadosTableTableManager(_$AppDatabase db, $ResultadosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ResultadosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ResultadosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ResultadosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> escenarioId = const Value.absent(),
                Value<String> calculadoEn = const Value.absent(),
                Value<int> posicionesRequeridas = const Value.absent(),
                Value<int> posicionesInstaladas = const Value.absent(),
                Value<int> modulos = const Value.absent(),
                Value<int> filas = const Value.absent(),
                Value<int> niveles = const Value.absent(),
                Value<int> supAlmacenamientoMm2 = const Value.absent(),
                Value<int> supConstruidaMm2 = const Value.absent(),
                Value<int> puertasAnden = const Value.absent(),
                Value<int> patioProfundidadMm = const Value.absent(),
                Value<int?> distanciaEsperadaMm = const Value.absent(),
                Value<int?> inversionCent = const Value.absent(),
              }) => ResultadosCompanion(
                id: id,
                escenarioId: escenarioId,
                calculadoEn: calculadoEn,
                posicionesRequeridas: posicionesRequeridas,
                posicionesInstaladas: posicionesInstaladas,
                modulos: modulos,
                filas: filas,
                niveles: niveles,
                supAlmacenamientoMm2: supAlmacenamientoMm2,
                supConstruidaMm2: supConstruidaMm2,
                puertasAnden: puertasAnden,
                patioProfundidadMm: patioProfundidadMm,
                distanciaEsperadaMm: distanciaEsperadaMm,
                inversionCent: inversionCent,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int escenarioId,
                required String calculadoEn,
                required int posicionesRequeridas,
                required int posicionesInstaladas,
                required int modulos,
                required int filas,
                required int niveles,
                required int supAlmacenamientoMm2,
                required int supConstruidaMm2,
                required int puertasAnden,
                required int patioProfundidadMm,
                Value<int?> distanciaEsperadaMm = const Value.absent(),
                Value<int?> inversionCent = const Value.absent(),
              }) => ResultadosCompanion.insert(
                id: id,
                escenarioId: escenarioId,
                calculadoEn: calculadoEn,
                posicionesRequeridas: posicionesRequeridas,
                posicionesInstaladas: posicionesInstaladas,
                modulos: modulos,
                filas: filas,
                niveles: niveles,
                supAlmacenamientoMm2: supAlmacenamientoMm2,
                supConstruidaMm2: supConstruidaMm2,
                puertasAnden: puertasAnden,
                patioProfundidadMm: patioProfundidadMm,
                distanciaEsperadaMm: distanciaEsperadaMm,
                inversionCent: inversionCent,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ResultadosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                escenarioId = false,
                zonasRefs = false,
                memoriaCalculoRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (zonasRefs) db.zonas,
                    if (memoriaCalculoRefs) db.memoriaCalculo,
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
                        if (escenarioId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.escenarioId,
                            referencedTable: $$ResultadosTableReferences
                                ._escenarioIdTable(db),
                            referencedColumn: $$ResultadosTableReferences
                                ._escenarioIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (zonasRefs)
                        await $_getPrefetchedData<
                          Resultado,
                          $ResultadosTable,
                          Zona
                        >(
                          currentTable: table,
                          referencedTable: $$ResultadosTableReferences
                              ._zonasRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ResultadosTableReferences(
                                db,
                                table,
                                p0,
                              ).zonasRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.resultadoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (memoriaCalculoRefs)
                        await $_getPrefetchedData<
                          Resultado,
                          $ResultadosTable,
                          MemoriaCalculoData
                        >(
                          currentTable: table,
                          referencedTable: $$ResultadosTableReferences
                              ._memoriaCalculoRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ResultadosTableReferences(
                                db,
                                table,
                                p0,
                              ).memoriaCalculoRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.resultadoId == item.id,
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

typedef $$ResultadosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ResultadosTable,
      Resultado,
      $$ResultadosTableFilterComposer,
      $$ResultadosTableOrderingComposer,
      $$ResultadosTableAnnotationComposer,
      $$ResultadosTableCreateCompanionBuilder,
      $$ResultadosTableUpdateCompanionBuilder,
      (Resultado, $$ResultadosTableReferences),
      Resultado,
      PrefetchHooks Function({
        bool escenarioId,
        bool zonasRefs,
        bool memoriaCalculoRefs,
      })
    >;
typedef $$ZonasTableCreateCompanionBuilder = ZonasCompanion Function({
  Value<int> id,
  required int resultadoId,
  required String tipo,
  required int xMm,
  required int yMm,
  required int anchoMm,
  required int largoMm,
});
typedef $$ZonasTableUpdateCompanionBuilder = ZonasCompanion Function({
  Value<int> id,
  Value<int> resultadoId,
  Value<String> tipo,
  Value<int> xMm,
  Value<int> yMm,
  Value<int> anchoMm,
  Value<int> largoMm,
});

final class $$ZonasTableReferences
    extends BaseReferences<_$AppDatabase, $ZonasTable, Zona> {
  $$ZonasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ResultadosTable _resultadoIdTable(_$AppDatabase db) =>
      db.resultados.createAlias('zonas__resultado_id__resultados__id');

  $$ResultadosTableProcessedTableManager get resultadoId {
    final $_column = $_itemColumn<int>('resultado_id')!;

    final manager = $$ResultadosTableTableManager(
      $_db,
      $_db.resultados,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_resultadoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ZonasTableFilterComposer extends Composer<_$AppDatabase, $ZonasTable> {
  $$ZonasTableFilterComposer({
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

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get xMm => $composableBuilder(
    column: $table.xMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get yMm => $composableBuilder(
    column: $table.yMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get anchoMm => $composableBuilder(
    column: $table.anchoMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get largoMm => $composableBuilder(
    column: $table.largoMm,
    builder: (column) => ColumnFilters(column),
  );

  $$ResultadosTableFilterComposer get resultadoId {
    final $$ResultadosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.resultadoId,
      referencedTable: $db.resultados,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ResultadosTableFilterComposer(
            $db: $db,
            $table: $db.resultados,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ZonasTableOrderingComposer
    extends Composer<_$AppDatabase, $ZonasTable> {
  $$ZonasTableOrderingComposer({
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

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get xMm => $composableBuilder(
    column: $table.xMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get yMm => $composableBuilder(
    column: $table.yMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get anchoMm => $composableBuilder(
    column: $table.anchoMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get largoMm => $composableBuilder(
    column: $table.largoMm,
    builder: (column) => ColumnOrderings(column),
  );

  $$ResultadosTableOrderingComposer get resultadoId {
    final $$ResultadosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.resultadoId,
      referencedTable: $db.resultados,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ResultadosTableOrderingComposer(
            $db: $db,
            $table: $db.resultados,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ZonasTableAnnotationComposer
    extends Composer<_$AppDatabase, $ZonasTable> {
  $$ZonasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<int> get xMm =>
      $composableBuilder(column: $table.xMm, builder: (column) => column);

  GeneratedColumn<int> get yMm =>
      $composableBuilder(column: $table.yMm, builder: (column) => column);

  GeneratedColumn<int> get anchoMm =>
      $composableBuilder(column: $table.anchoMm, builder: (column) => column);

  GeneratedColumn<int> get largoMm =>
      $composableBuilder(column: $table.largoMm, builder: (column) => column);

  $$ResultadosTableAnnotationComposer get resultadoId {
    final $$ResultadosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.resultadoId,
      referencedTable: $db.resultados,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ResultadosTableAnnotationComposer(
            $db: $db,
            $table: $db.resultados,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ZonasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ZonasTable,
          Zona,
          $$ZonasTableFilterComposer,
          $$ZonasTableOrderingComposer,
          $$ZonasTableAnnotationComposer,
          $$ZonasTableCreateCompanionBuilder,
          $$ZonasTableUpdateCompanionBuilder,
          (Zona, $$ZonasTableReferences),
          Zona,
          PrefetchHooks Function({bool resultadoId})
        > {
  $$ZonasTableTableManager(_$AppDatabase db, $ZonasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ZonasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ZonasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ZonasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> resultadoId = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<int> xMm = const Value.absent(),
                Value<int> yMm = const Value.absent(),
                Value<int> anchoMm = const Value.absent(),
                Value<int> largoMm = const Value.absent(),
              }) => ZonasCompanion(
                id: id,
                resultadoId: resultadoId,
                tipo: tipo,
                xMm: xMm,
                yMm: yMm,
                anchoMm: anchoMm,
                largoMm: largoMm,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int resultadoId,
                required String tipo,
                required int xMm,
                required int yMm,
                required int anchoMm,
                required int largoMm,
              }) => ZonasCompanion.insert(
                id: id,
                resultadoId: resultadoId,
                tipo: tipo,
                xMm: xMm,
                yMm: yMm,
                anchoMm: anchoMm,
                largoMm: largoMm,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$ZonasTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({resultadoId = false}) {
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
                    if (resultadoId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.resultadoId,
                        referencedTable: $$ZonasTableReferences
                            ._resultadoIdTable(db),
                        referencedColumn: $$ZonasTableReferences
                            ._resultadoIdTable(db)
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

typedef $$ZonasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ZonasTable,
      Zona,
      $$ZonasTableFilterComposer,
      $$ZonasTableOrderingComposer,
      $$ZonasTableAnnotationComposer,
      $$ZonasTableCreateCompanionBuilder,
      $$ZonasTableUpdateCompanionBuilder,
      (Zona, $$ZonasTableReferences),
      Zona,
      PrefetchHooks Function({bool resultadoId})
    >;
typedef $$MemoriaCalculoTableCreateCompanionBuilder =
    MemoriaCalculoCompanion Function({
      Value<int> id,
      required int resultadoId,
      required int orden,
      required String modulo,
      required String concepto,
      required String formula,
      required String entradas,
      required String valor,
      required String unidad,
      Value<String?> fuente,
    });
typedef $$MemoriaCalculoTableUpdateCompanionBuilder =
    MemoriaCalculoCompanion Function({
      Value<int> id,
      Value<int> resultadoId,
      Value<int> orden,
      Value<String> modulo,
      Value<String> concepto,
      Value<String> formula,
      Value<String> entradas,
      Value<String> valor,
      Value<String> unidad,
      Value<String?> fuente,
    });

final class $$MemoriaCalculoTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MemoriaCalculoTable,
          MemoriaCalculoData
        > {
  $$MemoriaCalculoTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ResultadosTable _resultadoIdTable(_$AppDatabase db) => db.resultados
      .createAlias('memoria_calculo__resultado_id__resultados__id');

  $$ResultadosTableProcessedTableManager get resultadoId {
    final $_column = $_itemColumn<int>('resultado_id')!;

    final manager = $$ResultadosTableTableManager(
      $_db,
      $_db.resultados,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_resultadoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MemoriaCalculoTableFilterComposer
    extends Composer<_$AppDatabase, $MemoriaCalculoTable> {
  $$MemoriaCalculoTableFilterComposer({
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

  ColumnFilters<String> get concepto => $composableBuilder(
    column: $table.concepto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get formula => $composableBuilder(
    column: $table.formula,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entradas => $composableBuilder(
    column: $table.entradas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unidad => $composableBuilder(
    column: $table.unidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fuente => $composableBuilder(
    column: $table.fuente,
    builder: (column) => ColumnFilters(column),
  );

  $$ResultadosTableFilterComposer get resultadoId {
    final $$ResultadosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.resultadoId,
      referencedTable: $db.resultados,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ResultadosTableFilterComposer(
            $db: $db,
            $table: $db.resultados,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemoriaCalculoTableOrderingComposer
    extends Composer<_$AppDatabase, $MemoriaCalculoTable> {
  $$MemoriaCalculoTableOrderingComposer({
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

  ColumnOrderings<String> get concepto => $composableBuilder(
    column: $table.concepto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get formula => $composableBuilder(
    column: $table.formula,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entradas => $composableBuilder(
    column: $table.entradas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unidad => $composableBuilder(
    column: $table.unidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fuente => $composableBuilder(
    column: $table.fuente,
    builder: (column) => ColumnOrderings(column),
  );

  $$ResultadosTableOrderingComposer get resultadoId {
    final $$ResultadosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.resultadoId,
      referencedTable: $db.resultados,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ResultadosTableOrderingComposer(
            $db: $db,
            $table: $db.resultados,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemoriaCalculoTableAnnotationComposer
    extends Composer<_$AppDatabase, $MemoriaCalculoTable> {
  $$MemoriaCalculoTableAnnotationComposer({
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

  GeneratedColumn<String> get concepto =>
      $composableBuilder(column: $table.concepto, builder: (column) => column);

  GeneratedColumn<String> get formula =>
      $composableBuilder(column: $table.formula, builder: (column) => column);

  GeneratedColumn<String> get entradas =>
      $composableBuilder(column: $table.entradas, builder: (column) => column);

  GeneratedColumn<String> get valor =>
      $composableBuilder(column: $table.valor, builder: (column) => column);

  GeneratedColumn<String> get unidad =>
      $composableBuilder(column: $table.unidad, builder: (column) => column);

  GeneratedColumn<String> get fuente =>
      $composableBuilder(column: $table.fuente, builder: (column) => column);

  $$ResultadosTableAnnotationComposer get resultadoId {
    final $$ResultadosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.resultadoId,
      referencedTable: $db.resultados,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ResultadosTableAnnotationComposer(
            $db: $db,
            $table: $db.resultados,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemoriaCalculoTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MemoriaCalculoTable,
          MemoriaCalculoData,
          $$MemoriaCalculoTableFilterComposer,
          $$MemoriaCalculoTableOrderingComposer,
          $$MemoriaCalculoTableAnnotationComposer,
          $$MemoriaCalculoTableCreateCompanionBuilder,
          $$MemoriaCalculoTableUpdateCompanionBuilder,
          (MemoriaCalculoData, $$MemoriaCalculoTableReferences),
          MemoriaCalculoData,
          PrefetchHooks Function({bool resultadoId})
        > {
  $$MemoriaCalculoTableTableManager(
    _$AppDatabase db,
    $MemoriaCalculoTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MemoriaCalculoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MemoriaCalculoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MemoriaCalculoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> resultadoId = const Value.absent(),
                Value<int> orden = const Value.absent(),
                Value<String> modulo = const Value.absent(),
                Value<String> concepto = const Value.absent(),
                Value<String> formula = const Value.absent(),
                Value<String> entradas = const Value.absent(),
                Value<String> valor = const Value.absent(),
                Value<String> unidad = const Value.absent(),
                Value<String?> fuente = const Value.absent(),
              }) => MemoriaCalculoCompanion(
                id: id,
                resultadoId: resultadoId,
                orden: orden,
                modulo: modulo,
                concepto: concepto,
                formula: formula,
                entradas: entradas,
                valor: valor,
                unidad: unidad,
                fuente: fuente,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int resultadoId,
                required int orden,
                required String modulo,
                required String concepto,
                required String formula,
                required String entradas,
                required String valor,
                required String unidad,
                Value<String?> fuente = const Value.absent(),
              }) => MemoriaCalculoCompanion.insert(
                id: id,
                resultadoId: resultadoId,
                orden: orden,
                modulo: modulo,
                concepto: concepto,
                formula: formula,
                entradas: entradas,
                valor: valor,
                unidad: unidad,
                fuente: fuente,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MemoriaCalculoTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({resultadoId = false}) {
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
                    if (resultadoId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.resultadoId,
                        referencedTable: $$MemoriaCalculoTableReferences
                            ._resultadoIdTable(db),
                        referencedColumn: $$MemoriaCalculoTableReferences
                            ._resultadoIdTable(db)
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

typedef $$MemoriaCalculoTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MemoriaCalculoTable,
      MemoriaCalculoData,
      $$MemoriaCalculoTableFilterComposer,
      $$MemoriaCalculoTableOrderingComposer,
      $$MemoriaCalculoTableAnnotationComposer,
      $$MemoriaCalculoTableCreateCompanionBuilder,
      $$MemoriaCalculoTableUpdateCompanionBuilder,
      (MemoriaCalculoData, $$MemoriaCalculoTableReferences),
      MemoriaCalculoData,
      PrefetchHooks Function({bool resultadoId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CatalogoTarimasTableTableManager get catalogoTarimas =>
      $$CatalogoTarimasTableTableManager(_db, _db.catalogoTarimas);
  $$CatalogoBastidoresTableTableManager get catalogoBastidores =>
      $$CatalogoBastidoresTableTableManager(_db, _db.catalogoBastidores);
  $$CatalogoVigasTableTableManager get catalogoVigas =>
      $$CatalogoVigasTableTableManager(_db, _db.catalogoVigas);
  $$CatalogoEquiposTableTableManager get catalogoEquipos =>
      $$CatalogoEquiposTableTableManager(_db, _db.catalogoEquipos);
  $$CatalogoCamionesTableTableManager get catalogoCamiones =>
      $$CatalogoCamionesTableTableManager(_db, _db.catalogoCamiones);
  $$ParametrosNormaTableTableManager get parametrosNorma =>
      $$ParametrosNormaTableTableManager(_db, _db.parametrosNorma);
  $$ProyectosTableTableManager get proyectos =>
      $$ProyectosTableTableManager(_db, _db.proyectos);
  $$FamiliasProductoTableTableManager get familiasProducto =>
      $$FamiliasProductoTableTableManager(_db, _db.familiasProducto);
  $$DemandaPeriodosTableTableManager get demandaPeriodos =>
      $$DemandaPeriodosTableTableManager(_db, _db.demandaPeriodos);
  $$EscenariosTableTableManager get escenarios =>
      $$EscenariosTableTableManager(_db, _db.escenarios);
  $$ResultadosTableTableManager get resultados =>
      $$ResultadosTableTableManager(_db, _db.resultados);
  $$ZonasTableTableManager get zonas =>
      $$ZonasTableTableManager(_db, _db.zonas);
  $$MemoriaCalculoTableTableManager get memoriaCalculo =>
      $$MemoriaCalculoTableTableManager(_db, _db.memoriaCalculo);
}
