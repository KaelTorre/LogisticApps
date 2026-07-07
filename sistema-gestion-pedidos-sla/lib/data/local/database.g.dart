// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
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
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contactoMeta = const VerificationMeta(
    'contacto',
  );
  @override
  late final GeneratedColumn<String> contacto = GeneratedColumn<String>(
    'contacto',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  List<GeneratedColumn> get $columns => [id, nombre, contacto, notas];
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
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('contacto')) {
      context.handle(
        _contactoMeta,
        contacto.isAcceptableOrUnknown(data['contacto']!, _contactoMeta),
      );
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
  ClienteTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClienteTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      contacto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contacto'],
      ),
      notas: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notas'],
      ),
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
  final String nombre;
  final String? contacto;
  final String? notas;
  const ClienteTableData({
    required this.id,
    required this.nombre,
    this.contacto,
    this.notas,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || contacto != null) {
      map['contacto'] = Variable<String>(contacto);
    }
    if (!nullToAbsent || notas != null) {
      map['notas'] = Variable<String>(notas);
    }
    return map;
  }

  ClienteTableCompanion toCompanion(bool nullToAbsent) {
    return ClienteTableCompanion(
      id: Value(id),
      nombre: Value(nombre),
      contacto: contacto == null && nullToAbsent
          ? const Value.absent()
          : Value(contacto),
      notas: notas == null && nullToAbsent
          ? const Value.absent()
          : Value(notas),
    );
  }

  factory ClienteTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClienteTableData(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      contacto: serializer.fromJson<String?>(json['contacto']),
      notas: serializer.fromJson<String?>(json['notas']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'contacto': serializer.toJson<String?>(contacto),
      'notas': serializer.toJson<String?>(notas),
    };
  }

  ClienteTableData copyWith({
    int? id,
    String? nombre,
    Value<String?> contacto = const Value.absent(),
    Value<String?> notas = const Value.absent(),
  }) => ClienteTableData(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    contacto: contacto.present ? contacto.value : this.contacto,
    notas: notas.present ? notas.value : this.notas,
  );
  ClienteTableData copyWithCompanion(ClienteTableCompanion data) {
    return ClienteTableData(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      contacto: data.contacto.present ? data.contacto.value : this.contacto,
      notas: data.notas.present ? data.notas.value : this.notas,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClienteTableData(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('contacto: $contacto, ')
          ..write('notas: $notas')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, contacto, notas);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClienteTableData &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.contacto == this.contacto &&
          other.notas == this.notas);
}

class ClienteTableCompanion extends UpdateCompanion<ClienteTableData> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String?> contacto;
  final Value<String?> notas;
  const ClienteTableCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.contacto = const Value.absent(),
    this.notas = const Value.absent(),
  });
  ClienteTableCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    this.contacto = const Value.absent(),
    this.notas = const Value.absent(),
  }) : nombre = Value(nombre);
  static Insertable<ClienteTableData> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? contacto,
    Expression<String>? notas,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (contacto != null) 'contacto': contacto,
      if (notas != null) 'notas': notas,
    });
  }

  ClienteTableCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<String?>? contacto,
    Value<String?>? notas,
  }) {
    return ClienteTableCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      contacto: contacto ?? this.contacto,
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
    if (contacto.present) {
      map['contacto'] = Variable<String>(contacto.value);
    }
    if (notas.present) {
      map['notas'] = Variable<String>(notas.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClienteTableCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('contacto: $contacto, ')
          ..write('notas: $notas')
          ..write(')'))
        .toString();
  }
}

class $ProductoTableTable extends ProductoTable
    with TableInfo<$ProductoTableTable, ProductoTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductoTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _pesoMeta = const VerificationMeta('peso');
  @override
  late final GeneratedColumn<double> peso = GeneratedColumn<double>(
    'peso',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _volumenMeta = const VerificationMeta(
    'volumen',
  );
  @override
  late final GeneratedColumn<double> volumen = GeneratedColumn<double>(
    'volumen',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _valorUnitarioMeta = const VerificationMeta(
    'valorUnitario',
  );
  @override
  late final GeneratedColumn<double> valorUnitario = GeneratedColumn<double>(
    'valor_unitario',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _metodoFijacionPrecioMeta =
      const VerificationMeta('metodoFijacionPrecio');
  @override
  late final GeneratedColumn<String> metodoFijacionPrecio =
      GeneratedColumn<String>(
        'metodo_fijacion_precio',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _etapaCicloVidaMeta = const VerificationMeta(
    'etapaCicloVida',
  );
  @override
  late final GeneratedColumn<String> etapaCicloVida = GeneratedColumn<String>(
    'etapa_ciclo_vida',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    categoria,
    peso,
    volumen,
    valorUnitario,
    metodoFijacionPrecio,
    etapaCicloVida,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'producto';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductoTableData> instance, {
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
    if (data.containsKey('categoria')) {
      context.handle(
        _categoriaMeta,
        categoria.isAcceptableOrUnknown(data['categoria']!, _categoriaMeta),
      );
    } else if (isInserting) {
      context.missing(_categoriaMeta);
    }
    if (data.containsKey('peso')) {
      context.handle(
        _pesoMeta,
        peso.isAcceptableOrUnknown(data['peso']!, _pesoMeta),
      );
    }
    if (data.containsKey('volumen')) {
      context.handle(
        _volumenMeta,
        volumen.isAcceptableOrUnknown(data['volumen']!, _volumenMeta),
      );
    }
    if (data.containsKey('valor_unitario')) {
      context.handle(
        _valorUnitarioMeta,
        valorUnitario.isAcceptableOrUnknown(
          data['valor_unitario']!,
          _valorUnitarioMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_valorUnitarioMeta);
    }
    if (data.containsKey('metodo_fijacion_precio')) {
      context.handle(
        _metodoFijacionPrecioMeta,
        metodoFijacionPrecio.isAcceptableOrUnknown(
          data['metodo_fijacion_precio']!,
          _metodoFijacionPrecioMeta,
        ),
      );
    }
    if (data.containsKey('etapa_ciclo_vida')) {
      context.handle(
        _etapaCicloVidaMeta,
        etapaCicloVida.isAcceptableOrUnknown(
          data['etapa_ciclo_vida']!,
          _etapaCicloVidaMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductoTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductoTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      categoria: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}categoria'],
      )!,
      peso: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}peso'],
      ),
      volumen: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}volumen'],
      ),
      valorUnitario: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}valor_unitario'],
      )!,
      metodoFijacionPrecio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metodo_fijacion_precio'],
      ),
      etapaCicloVida: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}etapa_ciclo_vida'],
      ),
    );
  }

  @override
  $ProductoTableTable createAlias(String alias) {
    return $ProductoTableTable(attachedDatabase, alias);
  }
}

class ProductoTableData extends DataClass
    implements Insertable<ProductoTableData> {
  final int id;
  final String nombre;
  final String categoria;
  final double? peso;
  final double? volumen;
  final double valorUnitario;
  final String? metodoFijacionPrecio;
  final String? etapaCicloVida;
  const ProductoTableData({
    required this.id,
    required this.nombre,
    required this.categoria,
    this.peso,
    this.volumen,
    required this.valorUnitario,
    this.metodoFijacionPrecio,
    this.etapaCicloVida,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['categoria'] = Variable<String>(categoria);
    if (!nullToAbsent || peso != null) {
      map['peso'] = Variable<double>(peso);
    }
    if (!nullToAbsent || volumen != null) {
      map['volumen'] = Variable<double>(volumen);
    }
    map['valor_unitario'] = Variable<double>(valorUnitario);
    if (!nullToAbsent || metodoFijacionPrecio != null) {
      map['metodo_fijacion_precio'] = Variable<String>(metodoFijacionPrecio);
    }
    if (!nullToAbsent || etapaCicloVida != null) {
      map['etapa_ciclo_vida'] = Variable<String>(etapaCicloVida);
    }
    return map;
  }

  ProductoTableCompanion toCompanion(bool nullToAbsent) {
    return ProductoTableCompanion(
      id: Value(id),
      nombre: Value(nombre),
      categoria: Value(categoria),
      peso: peso == null && nullToAbsent ? const Value.absent() : Value(peso),
      volumen: volumen == null && nullToAbsent
          ? const Value.absent()
          : Value(volumen),
      valorUnitario: Value(valorUnitario),
      metodoFijacionPrecio: metodoFijacionPrecio == null && nullToAbsent
          ? const Value.absent()
          : Value(metodoFijacionPrecio),
      etapaCicloVida: etapaCicloVida == null && nullToAbsent
          ? const Value.absent()
          : Value(etapaCicloVida),
    );
  }

  factory ProductoTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductoTableData(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      categoria: serializer.fromJson<String>(json['categoria']),
      peso: serializer.fromJson<double?>(json['peso']),
      volumen: serializer.fromJson<double?>(json['volumen']),
      valorUnitario: serializer.fromJson<double>(json['valorUnitario']),
      metodoFijacionPrecio: serializer.fromJson<String?>(
        json['metodoFijacionPrecio'],
      ),
      etapaCicloVida: serializer.fromJson<String?>(json['etapaCicloVida']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'categoria': serializer.toJson<String>(categoria),
      'peso': serializer.toJson<double?>(peso),
      'volumen': serializer.toJson<double?>(volumen),
      'valorUnitario': serializer.toJson<double>(valorUnitario),
      'metodoFijacionPrecio': serializer.toJson<String?>(metodoFijacionPrecio),
      'etapaCicloVida': serializer.toJson<String?>(etapaCicloVida),
    };
  }

  ProductoTableData copyWith({
    int? id,
    String? nombre,
    String? categoria,
    Value<double?> peso = const Value.absent(),
    Value<double?> volumen = const Value.absent(),
    double? valorUnitario,
    Value<String?> metodoFijacionPrecio = const Value.absent(),
    Value<String?> etapaCicloVida = const Value.absent(),
  }) => ProductoTableData(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    categoria: categoria ?? this.categoria,
    peso: peso.present ? peso.value : this.peso,
    volumen: volumen.present ? volumen.value : this.volumen,
    valorUnitario: valorUnitario ?? this.valorUnitario,
    metodoFijacionPrecio: metodoFijacionPrecio.present
        ? metodoFijacionPrecio.value
        : this.metodoFijacionPrecio,
    etapaCicloVida: etapaCicloVida.present
        ? etapaCicloVida.value
        : this.etapaCicloVida,
  );
  ProductoTableData copyWithCompanion(ProductoTableCompanion data) {
    return ProductoTableData(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      categoria: data.categoria.present ? data.categoria.value : this.categoria,
      peso: data.peso.present ? data.peso.value : this.peso,
      volumen: data.volumen.present ? data.volumen.value : this.volumen,
      valorUnitario: data.valorUnitario.present
          ? data.valorUnitario.value
          : this.valorUnitario,
      metodoFijacionPrecio: data.metodoFijacionPrecio.present
          ? data.metodoFijacionPrecio.value
          : this.metodoFijacionPrecio,
      etapaCicloVida: data.etapaCicloVida.present
          ? data.etapaCicloVida.value
          : this.etapaCicloVida,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductoTableData(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('categoria: $categoria, ')
          ..write('peso: $peso, ')
          ..write('volumen: $volumen, ')
          ..write('valorUnitario: $valorUnitario, ')
          ..write('metodoFijacionPrecio: $metodoFijacionPrecio, ')
          ..write('etapaCicloVida: $etapaCicloVida')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    categoria,
    peso,
    volumen,
    valorUnitario,
    metodoFijacionPrecio,
    etapaCicloVida,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductoTableData &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.categoria == this.categoria &&
          other.peso == this.peso &&
          other.volumen == this.volumen &&
          other.valorUnitario == this.valorUnitario &&
          other.metodoFijacionPrecio == this.metodoFijacionPrecio &&
          other.etapaCicloVida == this.etapaCicloVida);
}

class ProductoTableCompanion extends UpdateCompanion<ProductoTableData> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String> categoria;
  final Value<double?> peso;
  final Value<double?> volumen;
  final Value<double> valorUnitario;
  final Value<String?> metodoFijacionPrecio;
  final Value<String?> etapaCicloVida;
  const ProductoTableCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.categoria = const Value.absent(),
    this.peso = const Value.absent(),
    this.volumen = const Value.absent(),
    this.valorUnitario = const Value.absent(),
    this.metodoFijacionPrecio = const Value.absent(),
    this.etapaCicloVida = const Value.absent(),
  });
  ProductoTableCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required String categoria,
    this.peso = const Value.absent(),
    this.volumen = const Value.absent(),
    required double valorUnitario,
    this.metodoFijacionPrecio = const Value.absent(),
    this.etapaCicloVida = const Value.absent(),
  }) : nombre = Value(nombre),
       categoria = Value(categoria),
       valorUnitario = Value(valorUnitario);
  static Insertable<ProductoTableData> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? categoria,
    Expression<double>? peso,
    Expression<double>? volumen,
    Expression<double>? valorUnitario,
    Expression<String>? metodoFijacionPrecio,
    Expression<String>? etapaCicloVida,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (categoria != null) 'categoria': categoria,
      if (peso != null) 'peso': peso,
      if (volumen != null) 'volumen': volumen,
      if (valorUnitario != null) 'valor_unitario': valorUnitario,
      if (metodoFijacionPrecio != null)
        'metodo_fijacion_precio': metodoFijacionPrecio,
      if (etapaCicloVida != null) 'etapa_ciclo_vida': etapaCicloVida,
    });
  }

  ProductoTableCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<String>? categoria,
    Value<double?>? peso,
    Value<double?>? volumen,
    Value<double>? valorUnitario,
    Value<String?>? metodoFijacionPrecio,
    Value<String?>? etapaCicloVida,
  }) {
    return ProductoTableCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      categoria: categoria ?? this.categoria,
      peso: peso ?? this.peso,
      volumen: volumen ?? this.volumen,
      valorUnitario: valorUnitario ?? this.valorUnitario,
      metodoFijacionPrecio: metodoFijacionPrecio ?? this.metodoFijacionPrecio,
      etapaCicloVida: etapaCicloVida ?? this.etapaCicloVida,
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
    if (categoria.present) {
      map['categoria'] = Variable<String>(categoria.value);
    }
    if (peso.present) {
      map['peso'] = Variable<double>(peso.value);
    }
    if (volumen.present) {
      map['volumen'] = Variable<double>(volumen.value);
    }
    if (valorUnitario.present) {
      map['valor_unitario'] = Variable<double>(valorUnitario.value);
    }
    if (metodoFijacionPrecio.present) {
      map['metodo_fijacion_precio'] = Variable<String>(
        metodoFijacionPrecio.value,
      );
    }
    if (etapaCicloVida.present) {
      map['etapa_ciclo_vida'] = Variable<String>(etapaCicloVida.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductoTableCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('categoria: $categoria, ')
          ..write('peso: $peso, ')
          ..write('volumen: $volumen, ')
          ..write('valorUnitario: $valorUnitario, ')
          ..write('metodoFijacionPrecio: $metodoFijacionPrecio, ')
          ..write('etapaCicloVida: $etapaCicloVida')
          ..write(')'))
        .toString();
  }
}

class $PedidoTableTable extends PedidoTable
    with TableInfo<$PedidoTableTable, PedidoTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PedidoTableTable(this.attachedDatabase, [this._alias]);
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
      'REFERENCES cliente (id)',
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
  static const VerificationMeta _estadoActualMeta = const VerificationMeta(
    'estadoActual',
  );
  @override
  late final GeneratedColumn<String> estadoActual = GeneratedColumn<String>(
    'estado_actual',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clienteId,
    fechaCreacion,
    estadoActual,
    prioridad,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pedido';
  @override
  VerificationContext validateIntegrity(
    Insertable<PedidoTableData> instance, {
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
    if (data.containsKey('estado_actual')) {
      context.handle(
        _estadoActualMeta,
        estadoActual.isAcceptableOrUnknown(
          data['estado_actual']!,
          _estadoActualMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_estadoActualMeta);
    }
    if (data.containsKey('prioridad')) {
      context.handle(
        _prioridadMeta,
        prioridad.isAcceptableOrUnknown(data['prioridad']!, _prioridadMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PedidoTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PedidoTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      clienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cliente_id'],
      )!,
      fechaCreacion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fecha_creacion'],
      )!,
      estadoActual: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado_actual'],
      )!,
      prioridad: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prioridad'],
      )!,
    );
  }

  @override
  $PedidoTableTable createAlias(String alias) {
    return $PedidoTableTable(attachedDatabase, alias);
  }
}

class PedidoTableData extends DataClass implements Insertable<PedidoTableData> {
  final int id;
  final int clienteId;
  final String fechaCreacion;
  final String estadoActual;
  final int prioridad;
  const PedidoTableData({
    required this.id,
    required this.clienteId,
    required this.fechaCreacion,
    required this.estadoActual,
    required this.prioridad,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cliente_id'] = Variable<int>(clienteId);
    map['fecha_creacion'] = Variable<String>(fechaCreacion);
    map['estado_actual'] = Variable<String>(estadoActual);
    map['prioridad'] = Variable<int>(prioridad);
    return map;
  }

  PedidoTableCompanion toCompanion(bool nullToAbsent) {
    return PedidoTableCompanion(
      id: Value(id),
      clienteId: Value(clienteId),
      fechaCreacion: Value(fechaCreacion),
      estadoActual: Value(estadoActual),
      prioridad: Value(prioridad),
    );
  }

  factory PedidoTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PedidoTableData(
      id: serializer.fromJson<int>(json['id']),
      clienteId: serializer.fromJson<int>(json['clienteId']),
      fechaCreacion: serializer.fromJson<String>(json['fechaCreacion']),
      estadoActual: serializer.fromJson<String>(json['estadoActual']),
      prioridad: serializer.fromJson<int>(json['prioridad']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'clienteId': serializer.toJson<int>(clienteId),
      'fechaCreacion': serializer.toJson<String>(fechaCreacion),
      'estadoActual': serializer.toJson<String>(estadoActual),
      'prioridad': serializer.toJson<int>(prioridad),
    };
  }

  PedidoTableData copyWith({
    int? id,
    int? clienteId,
    String? fechaCreacion,
    String? estadoActual,
    int? prioridad,
  }) => PedidoTableData(
    id: id ?? this.id,
    clienteId: clienteId ?? this.clienteId,
    fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    estadoActual: estadoActual ?? this.estadoActual,
    prioridad: prioridad ?? this.prioridad,
  );
  PedidoTableData copyWithCompanion(PedidoTableCompanion data) {
    return PedidoTableData(
      id: data.id.present ? data.id.value : this.id,
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
      fechaCreacion: data.fechaCreacion.present
          ? data.fechaCreacion.value
          : this.fechaCreacion,
      estadoActual: data.estadoActual.present
          ? data.estadoActual.value
          : this.estadoActual,
      prioridad: data.prioridad.present ? data.prioridad.value : this.prioridad,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PedidoTableData(')
          ..write('id: $id, ')
          ..write('clienteId: $clienteId, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('estadoActual: $estadoActual, ')
          ..write('prioridad: $prioridad')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, clienteId, fechaCreacion, estadoActual, prioridad);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PedidoTableData &&
          other.id == this.id &&
          other.clienteId == this.clienteId &&
          other.fechaCreacion == this.fechaCreacion &&
          other.estadoActual == this.estadoActual &&
          other.prioridad == this.prioridad);
}

class PedidoTableCompanion extends UpdateCompanion<PedidoTableData> {
  final Value<int> id;
  final Value<int> clienteId;
  final Value<String> fechaCreacion;
  final Value<String> estadoActual;
  final Value<int> prioridad;
  const PedidoTableCompanion({
    this.id = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.estadoActual = const Value.absent(),
    this.prioridad = const Value.absent(),
  });
  PedidoTableCompanion.insert({
    this.id = const Value.absent(),
    required int clienteId,
    required String fechaCreacion,
    required String estadoActual,
    this.prioridad = const Value.absent(),
  }) : clienteId = Value(clienteId),
       fechaCreacion = Value(fechaCreacion),
       estadoActual = Value(estadoActual);
  static Insertable<PedidoTableData> custom({
    Expression<int>? id,
    Expression<int>? clienteId,
    Expression<String>? fechaCreacion,
    Expression<String>? estadoActual,
    Expression<int>? prioridad,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clienteId != null) 'cliente_id': clienteId,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
      if (estadoActual != null) 'estado_actual': estadoActual,
      if (prioridad != null) 'prioridad': prioridad,
    });
  }

  PedidoTableCompanion copyWith({
    Value<int>? id,
    Value<int>? clienteId,
    Value<String>? fechaCreacion,
    Value<String>? estadoActual,
    Value<int>? prioridad,
  }) {
    return PedidoTableCompanion(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      estadoActual: estadoActual ?? this.estadoActual,
      prioridad: prioridad ?? this.prioridad,
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
    if (fechaCreacion.present) {
      map['fecha_creacion'] = Variable<String>(fechaCreacion.value);
    }
    if (estadoActual.present) {
      map['estado_actual'] = Variable<String>(estadoActual.value);
    }
    if (prioridad.present) {
      map['prioridad'] = Variable<int>(prioridad.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PedidoTableCompanion(')
          ..write('id: $id, ')
          ..write('clienteId: $clienteId, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('estadoActual: $estadoActual, ')
          ..write('prioridad: $prioridad')
          ..write(')'))
        .toString();
  }
}

class $PedidoItemTableTable extends PedidoItemTable
    with TableInfo<$PedidoItemTableTable, PedidoItemTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PedidoItemTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _pedidoIdMeta = const VerificationMeta(
    'pedidoId',
  );
  @override
  late final GeneratedColumn<int> pedidoId = GeneratedColumn<int>(
    'pedido_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pedido (id)',
    ),
  );
  static const VerificationMeta _productoIdMeta = const VerificationMeta(
    'productoId',
  );
  @override
  late final GeneratedColumn<int> productoId = GeneratedColumn<int>(
    'producto_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES producto (id)',
    ),
  );
  static const VerificationMeta _cantidadMeta = const VerificationMeta(
    'cantidad',
  );
  @override
  late final GeneratedColumn<int> cantidad = GeneratedColumn<int>(
    'cantidad',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _precioAplicadoMeta = const VerificationMeta(
    'precioAplicado',
  );
  @override
  late final GeneratedColumn<double> precioAplicado = GeneratedColumn<double>(
    'precio_aplicado',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    pedidoId,
    productoId,
    cantidad,
    precioAplicado,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pedido_item';
  @override
  VerificationContext validateIntegrity(
    Insertable<PedidoItemTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pedido_id')) {
      context.handle(
        _pedidoIdMeta,
        pedidoId.isAcceptableOrUnknown(data['pedido_id']!, _pedidoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_pedidoIdMeta);
    }
    if (data.containsKey('producto_id')) {
      context.handle(
        _productoIdMeta,
        productoId.isAcceptableOrUnknown(data['producto_id']!, _productoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productoIdMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(
        _cantidadMeta,
        cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta),
      );
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('precio_aplicado')) {
      context.handle(
        _precioAplicadoMeta,
        precioAplicado.isAcceptableOrUnknown(
          data['precio_aplicado']!,
          _precioAplicadoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_precioAplicadoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PedidoItemTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PedidoItemTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      pedidoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pedido_id'],
      )!,
      productoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}producto_id'],
      )!,
      cantidad: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidad'],
      )!,
      precioAplicado: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio_aplicado'],
      )!,
    );
  }

  @override
  $PedidoItemTableTable createAlias(String alias) {
    return $PedidoItemTableTable(attachedDatabase, alias);
  }
}

class PedidoItemTableData extends DataClass
    implements Insertable<PedidoItemTableData> {
  final int id;
  final int pedidoId;
  final int productoId;
  final int cantidad;
  final double precioAplicado;
  const PedidoItemTableData({
    required this.id,
    required this.pedidoId,
    required this.productoId,
    required this.cantidad,
    required this.precioAplicado,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pedido_id'] = Variable<int>(pedidoId);
    map['producto_id'] = Variable<int>(productoId);
    map['cantidad'] = Variable<int>(cantidad);
    map['precio_aplicado'] = Variable<double>(precioAplicado);
    return map;
  }

  PedidoItemTableCompanion toCompanion(bool nullToAbsent) {
    return PedidoItemTableCompanion(
      id: Value(id),
      pedidoId: Value(pedidoId),
      productoId: Value(productoId),
      cantidad: Value(cantidad),
      precioAplicado: Value(precioAplicado),
    );
  }

  factory PedidoItemTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PedidoItemTableData(
      id: serializer.fromJson<int>(json['id']),
      pedidoId: serializer.fromJson<int>(json['pedidoId']),
      productoId: serializer.fromJson<int>(json['productoId']),
      cantidad: serializer.fromJson<int>(json['cantidad']),
      precioAplicado: serializer.fromJson<double>(json['precioAplicado']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pedidoId': serializer.toJson<int>(pedidoId),
      'productoId': serializer.toJson<int>(productoId),
      'cantidad': serializer.toJson<int>(cantidad),
      'precioAplicado': serializer.toJson<double>(precioAplicado),
    };
  }

  PedidoItemTableData copyWith({
    int? id,
    int? pedidoId,
    int? productoId,
    int? cantidad,
    double? precioAplicado,
  }) => PedidoItemTableData(
    id: id ?? this.id,
    pedidoId: pedidoId ?? this.pedidoId,
    productoId: productoId ?? this.productoId,
    cantidad: cantidad ?? this.cantidad,
    precioAplicado: precioAplicado ?? this.precioAplicado,
  );
  PedidoItemTableData copyWithCompanion(PedidoItemTableCompanion data) {
    return PedidoItemTableData(
      id: data.id.present ? data.id.value : this.id,
      pedidoId: data.pedidoId.present ? data.pedidoId.value : this.pedidoId,
      productoId: data.productoId.present
          ? data.productoId.value
          : this.productoId,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      precioAplicado: data.precioAplicado.present
          ? data.precioAplicado.value
          : this.precioAplicado,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PedidoItemTableData(')
          ..write('id: $id, ')
          ..write('pedidoId: $pedidoId, ')
          ..write('productoId: $productoId, ')
          ..write('cantidad: $cantidad, ')
          ..write('precioAplicado: $precioAplicado')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, pedidoId, productoId, cantidad, precioAplicado);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PedidoItemTableData &&
          other.id == this.id &&
          other.pedidoId == this.pedidoId &&
          other.productoId == this.productoId &&
          other.cantidad == this.cantidad &&
          other.precioAplicado == this.precioAplicado);
}

class PedidoItemTableCompanion extends UpdateCompanion<PedidoItemTableData> {
  final Value<int> id;
  final Value<int> pedidoId;
  final Value<int> productoId;
  final Value<int> cantidad;
  final Value<double> precioAplicado;
  const PedidoItemTableCompanion({
    this.id = const Value.absent(),
    this.pedidoId = const Value.absent(),
    this.productoId = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.precioAplicado = const Value.absent(),
  });
  PedidoItemTableCompanion.insert({
    this.id = const Value.absent(),
    required int pedidoId,
    required int productoId,
    required int cantidad,
    required double precioAplicado,
  }) : pedidoId = Value(pedidoId),
       productoId = Value(productoId),
       cantidad = Value(cantidad),
       precioAplicado = Value(precioAplicado);
  static Insertable<PedidoItemTableData> custom({
    Expression<int>? id,
    Expression<int>? pedidoId,
    Expression<int>? productoId,
    Expression<int>? cantidad,
    Expression<double>? precioAplicado,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pedidoId != null) 'pedido_id': pedidoId,
      if (productoId != null) 'producto_id': productoId,
      if (cantidad != null) 'cantidad': cantidad,
      if (precioAplicado != null) 'precio_aplicado': precioAplicado,
    });
  }

  PedidoItemTableCompanion copyWith({
    Value<int>? id,
    Value<int>? pedidoId,
    Value<int>? productoId,
    Value<int>? cantidad,
    Value<double>? precioAplicado,
  }) {
    return PedidoItemTableCompanion(
      id: id ?? this.id,
      pedidoId: pedidoId ?? this.pedidoId,
      productoId: productoId ?? this.productoId,
      cantidad: cantidad ?? this.cantidad,
      precioAplicado: precioAplicado ?? this.precioAplicado,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pedidoId.present) {
      map['pedido_id'] = Variable<int>(pedidoId.value);
    }
    if (productoId.present) {
      map['producto_id'] = Variable<int>(productoId.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<int>(cantidad.value);
    }
    if (precioAplicado.present) {
      map['precio_aplicado'] = Variable<double>(precioAplicado.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PedidoItemTableCompanion(')
          ..write('id: $id, ')
          ..write('pedidoId: $pedidoId, ')
          ..write('productoId: $productoId, ')
          ..write('cantidad: $cantidad, ')
          ..write('precioAplicado: $precioAplicado')
          ..write(')'))
        .toString();
  }
}

class $HistorialEstadoTableTable extends HistorialEstadoTable
    with TableInfo<$HistorialEstadoTableTable, HistorialEstadoTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HistorialEstadoTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _pedidoIdMeta = const VerificationMeta(
    'pedidoId',
  );
  @override
  late final GeneratedColumn<int> pedidoId = GeneratedColumn<int>(
    'pedido_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pedido (id)',
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
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<String> timestamp = GeneratedColumn<String>(
    'timestamp',
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
  List<GeneratedColumn> get $columns => [id, pedidoId, estado, timestamp, nota];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'historial_estado';
  @override
  VerificationContext validateIntegrity(
    Insertable<HistorialEstadoTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pedido_id')) {
      context.handle(
        _pedidoIdMeta,
        pedidoId.isAcceptableOrUnknown(data['pedido_id']!, _pedidoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_pedidoIdMeta);
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    } else if (isInserting) {
      context.missing(_estadoMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
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
  HistorialEstadoTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HistorialEstadoTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      pedidoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pedido_id'],
      )!,
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timestamp'],
      )!,
      nota: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nota'],
      ),
    );
  }

  @override
  $HistorialEstadoTableTable createAlias(String alias) {
    return $HistorialEstadoTableTable(attachedDatabase, alias);
  }
}

class HistorialEstadoTableData extends DataClass
    implements Insertable<HistorialEstadoTableData> {
  final int id;
  final int pedidoId;
  final String estado;
  final String timestamp;
  final String? nota;
  const HistorialEstadoTableData({
    required this.id,
    required this.pedidoId,
    required this.estado,
    required this.timestamp,
    this.nota,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pedido_id'] = Variable<int>(pedidoId);
    map['estado'] = Variable<String>(estado);
    map['timestamp'] = Variable<String>(timestamp);
    if (!nullToAbsent || nota != null) {
      map['nota'] = Variable<String>(nota);
    }
    return map;
  }

  HistorialEstadoTableCompanion toCompanion(bool nullToAbsent) {
    return HistorialEstadoTableCompanion(
      id: Value(id),
      pedidoId: Value(pedidoId),
      estado: Value(estado),
      timestamp: Value(timestamp),
      nota: nota == null && nullToAbsent ? const Value.absent() : Value(nota),
    );
  }

  factory HistorialEstadoTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HistorialEstadoTableData(
      id: serializer.fromJson<int>(json['id']),
      pedidoId: serializer.fromJson<int>(json['pedidoId']),
      estado: serializer.fromJson<String>(json['estado']),
      timestamp: serializer.fromJson<String>(json['timestamp']),
      nota: serializer.fromJson<String?>(json['nota']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pedidoId': serializer.toJson<int>(pedidoId),
      'estado': serializer.toJson<String>(estado),
      'timestamp': serializer.toJson<String>(timestamp),
      'nota': serializer.toJson<String?>(nota),
    };
  }

  HistorialEstadoTableData copyWith({
    int? id,
    int? pedidoId,
    String? estado,
    String? timestamp,
    Value<String?> nota = const Value.absent(),
  }) => HistorialEstadoTableData(
    id: id ?? this.id,
    pedidoId: pedidoId ?? this.pedidoId,
    estado: estado ?? this.estado,
    timestamp: timestamp ?? this.timestamp,
    nota: nota.present ? nota.value : this.nota,
  );
  HistorialEstadoTableData copyWithCompanion(
    HistorialEstadoTableCompanion data,
  ) {
    return HistorialEstadoTableData(
      id: data.id.present ? data.id.value : this.id,
      pedidoId: data.pedidoId.present ? data.pedidoId.value : this.pedidoId,
      estado: data.estado.present ? data.estado.value : this.estado,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      nota: data.nota.present ? data.nota.value : this.nota,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HistorialEstadoTableData(')
          ..write('id: $id, ')
          ..write('pedidoId: $pedidoId, ')
          ..write('estado: $estado, ')
          ..write('timestamp: $timestamp, ')
          ..write('nota: $nota')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, pedidoId, estado, timestamp, nota);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HistorialEstadoTableData &&
          other.id == this.id &&
          other.pedidoId == this.pedidoId &&
          other.estado == this.estado &&
          other.timestamp == this.timestamp &&
          other.nota == this.nota);
}

class HistorialEstadoTableCompanion
    extends UpdateCompanion<HistorialEstadoTableData> {
  final Value<int> id;
  final Value<int> pedidoId;
  final Value<String> estado;
  final Value<String> timestamp;
  final Value<String?> nota;
  const HistorialEstadoTableCompanion({
    this.id = const Value.absent(),
    this.pedidoId = const Value.absent(),
    this.estado = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.nota = const Value.absent(),
  });
  HistorialEstadoTableCompanion.insert({
    this.id = const Value.absent(),
    required int pedidoId,
    required String estado,
    required String timestamp,
    this.nota = const Value.absent(),
  }) : pedidoId = Value(pedidoId),
       estado = Value(estado),
       timestamp = Value(timestamp);
  static Insertable<HistorialEstadoTableData> custom({
    Expression<int>? id,
    Expression<int>? pedidoId,
    Expression<String>? estado,
    Expression<String>? timestamp,
    Expression<String>? nota,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pedidoId != null) 'pedido_id': pedidoId,
      if (estado != null) 'estado': estado,
      if (timestamp != null) 'timestamp': timestamp,
      if (nota != null) 'nota': nota,
    });
  }

  HistorialEstadoTableCompanion copyWith({
    Value<int>? id,
    Value<int>? pedidoId,
    Value<String>? estado,
    Value<String>? timestamp,
    Value<String?>? nota,
  }) {
    return HistorialEstadoTableCompanion(
      id: id ?? this.id,
      pedidoId: pedidoId ?? this.pedidoId,
      estado: estado ?? this.estado,
      timestamp: timestamp ?? this.timestamp,
      nota: nota ?? this.nota,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pedidoId.present) {
      map['pedido_id'] = Variable<int>(pedidoId.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<String>(timestamp.value);
    }
    if (nota.present) {
      map['nota'] = Variable<String>(nota.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HistorialEstadoTableCompanion(')
          ..write('id: $id, ')
          ..write('pedidoId: $pedidoId, ')
          ..write('estado: $estado, ')
          ..write('timestamp: $timestamp, ')
          ..write('nota: $nota')
          ..write(')'))
        .toString();
  }
}

class $ConfiguracionSlaTableTable extends ConfiguracionSlaTable
    with TableInfo<$ConfiguracionSlaTableTable, ConfiguracionSlaTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConfiguracionSlaTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _coeficienteIngresoMeta =
      const VerificationMeta('coeficienteIngreso');
  @override
  late final GeneratedColumn<double> coeficienteIngreso =
      GeneratedColumn<double>(
        'coeficiente_ingreso',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.5),
      );
  static const VerificationMeta _coeficienteCostoMeta = const VerificationMeta(
    'coeficienteCosto',
  );
  @override
  late final GeneratedColumn<double> coeficienteCosto = GeneratedColumn<double>(
    'coeficiente_costo',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.00055),
  );
  static const VerificationMeta _valorObjetivoMMeta = const VerificationMeta(
    'valorObjetivoM',
  );
  @override
  late final GeneratedColumn<double> valorObjetivoM = GeneratedColumn<double>(
    'valor_objetivo_m',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _constanteKMeta = const VerificationMeta(
    'constanteK',
  );
  @override
  late final GeneratedColumn<double> constanteK = GeneratedColumn<double>(
    'constante_k',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    coeficienteIngreso,
    coeficienteCosto,
    valorObjetivoM,
    constanteK,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'configuracion_sla';
  @override
  VerificationContext validateIntegrity(
    Insertable<ConfiguracionSlaTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('coeficiente_ingreso')) {
      context.handle(
        _coeficienteIngresoMeta,
        coeficienteIngreso.isAcceptableOrUnknown(
          data['coeficiente_ingreso']!,
          _coeficienteIngresoMeta,
        ),
      );
    }
    if (data.containsKey('coeficiente_costo')) {
      context.handle(
        _coeficienteCostoMeta,
        coeficienteCosto.isAcceptableOrUnknown(
          data['coeficiente_costo']!,
          _coeficienteCostoMeta,
        ),
      );
    }
    if (data.containsKey('valor_objetivo_m')) {
      context.handle(
        _valorObjetivoMMeta,
        valorObjetivoM.isAcceptableOrUnknown(
          data['valor_objetivo_m']!,
          _valorObjetivoMMeta,
        ),
      );
    }
    if (data.containsKey('constante_k')) {
      context.handle(
        _constanteKMeta,
        constanteK.isAcceptableOrUnknown(data['constante_k']!, _constanteKMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConfiguracionSlaTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConfiguracionSlaTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      coeficienteIngreso: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}coeficiente_ingreso'],
      )!,
      coeficienteCosto: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}coeficiente_costo'],
      )!,
      valorObjetivoM: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}valor_objetivo_m'],
      ),
      constanteK: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}constante_k'],
      ),
    );
  }

  @override
  $ConfiguracionSlaTableTable createAlias(String alias) {
    return $ConfiguracionSlaTableTable(attachedDatabase, alias);
  }
}

class ConfiguracionSlaTableData extends DataClass
    implements Insertable<ConfiguracionSlaTableData> {
  final int id;
  final double coeficienteIngreso;
  final double coeficienteCosto;
  final double? valorObjetivoM;
  final double? constanteK;
  const ConfiguracionSlaTableData({
    required this.id,
    required this.coeficienteIngreso,
    required this.coeficienteCosto,
    this.valorObjetivoM,
    this.constanteK,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['coeficiente_ingreso'] = Variable<double>(coeficienteIngreso);
    map['coeficiente_costo'] = Variable<double>(coeficienteCosto);
    if (!nullToAbsent || valorObjetivoM != null) {
      map['valor_objetivo_m'] = Variable<double>(valorObjetivoM);
    }
    if (!nullToAbsent || constanteK != null) {
      map['constante_k'] = Variable<double>(constanteK);
    }
    return map;
  }

  ConfiguracionSlaTableCompanion toCompanion(bool nullToAbsent) {
    return ConfiguracionSlaTableCompanion(
      id: Value(id),
      coeficienteIngreso: Value(coeficienteIngreso),
      coeficienteCosto: Value(coeficienteCosto),
      valorObjetivoM: valorObjetivoM == null && nullToAbsent
          ? const Value.absent()
          : Value(valorObjetivoM),
      constanteK: constanteK == null && nullToAbsent
          ? const Value.absent()
          : Value(constanteK),
    );
  }

  factory ConfiguracionSlaTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConfiguracionSlaTableData(
      id: serializer.fromJson<int>(json['id']),
      coeficienteIngreso: serializer.fromJson<double>(
        json['coeficienteIngreso'],
      ),
      coeficienteCosto: serializer.fromJson<double>(json['coeficienteCosto']),
      valorObjetivoM: serializer.fromJson<double?>(json['valorObjetivoM']),
      constanteK: serializer.fromJson<double?>(json['constanteK']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'coeficienteIngreso': serializer.toJson<double>(coeficienteIngreso),
      'coeficienteCosto': serializer.toJson<double>(coeficienteCosto),
      'valorObjetivoM': serializer.toJson<double?>(valorObjetivoM),
      'constanteK': serializer.toJson<double?>(constanteK),
    };
  }

  ConfiguracionSlaTableData copyWith({
    int? id,
    double? coeficienteIngreso,
    double? coeficienteCosto,
    Value<double?> valorObjetivoM = const Value.absent(),
    Value<double?> constanteK = const Value.absent(),
  }) => ConfiguracionSlaTableData(
    id: id ?? this.id,
    coeficienteIngreso: coeficienteIngreso ?? this.coeficienteIngreso,
    coeficienteCosto: coeficienteCosto ?? this.coeficienteCosto,
    valorObjetivoM: valorObjetivoM.present
        ? valorObjetivoM.value
        : this.valorObjetivoM,
    constanteK: constanteK.present ? constanteK.value : this.constanteK,
  );
  ConfiguracionSlaTableData copyWithCompanion(
    ConfiguracionSlaTableCompanion data,
  ) {
    return ConfiguracionSlaTableData(
      id: data.id.present ? data.id.value : this.id,
      coeficienteIngreso: data.coeficienteIngreso.present
          ? data.coeficienteIngreso.value
          : this.coeficienteIngreso,
      coeficienteCosto: data.coeficienteCosto.present
          ? data.coeficienteCosto.value
          : this.coeficienteCosto,
      valorObjetivoM: data.valorObjetivoM.present
          ? data.valorObjetivoM.value
          : this.valorObjetivoM,
      constanteK: data.constanteK.present
          ? data.constanteK.value
          : this.constanteK,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConfiguracionSlaTableData(')
          ..write('id: $id, ')
          ..write('coeficienteIngreso: $coeficienteIngreso, ')
          ..write('coeficienteCosto: $coeficienteCosto, ')
          ..write('valorObjetivoM: $valorObjetivoM, ')
          ..write('constanteK: $constanteK')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    coeficienteIngreso,
    coeficienteCosto,
    valorObjetivoM,
    constanteK,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConfiguracionSlaTableData &&
          other.id == this.id &&
          other.coeficienteIngreso == this.coeficienteIngreso &&
          other.coeficienteCosto == this.coeficienteCosto &&
          other.valorObjetivoM == this.valorObjetivoM &&
          other.constanteK == this.constanteK);
}

class ConfiguracionSlaTableCompanion
    extends UpdateCompanion<ConfiguracionSlaTableData> {
  final Value<int> id;
  final Value<double> coeficienteIngreso;
  final Value<double> coeficienteCosto;
  final Value<double?> valorObjetivoM;
  final Value<double?> constanteK;
  const ConfiguracionSlaTableCompanion({
    this.id = const Value.absent(),
    this.coeficienteIngreso = const Value.absent(),
    this.coeficienteCosto = const Value.absent(),
    this.valorObjetivoM = const Value.absent(),
    this.constanteK = const Value.absent(),
  });
  ConfiguracionSlaTableCompanion.insert({
    this.id = const Value.absent(),
    this.coeficienteIngreso = const Value.absent(),
    this.coeficienteCosto = const Value.absent(),
    this.valorObjetivoM = const Value.absent(),
    this.constanteK = const Value.absent(),
  });
  static Insertable<ConfiguracionSlaTableData> custom({
    Expression<int>? id,
    Expression<double>? coeficienteIngreso,
    Expression<double>? coeficienteCosto,
    Expression<double>? valorObjetivoM,
    Expression<double>? constanteK,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (coeficienteIngreso != null) 'coeficiente_ingreso': coeficienteIngreso,
      if (coeficienteCosto != null) 'coeficiente_costo': coeficienteCosto,
      if (valorObjetivoM != null) 'valor_objetivo_m': valorObjetivoM,
      if (constanteK != null) 'constante_k': constanteK,
    });
  }

  ConfiguracionSlaTableCompanion copyWith({
    Value<int>? id,
    Value<double>? coeficienteIngreso,
    Value<double>? coeficienteCosto,
    Value<double?>? valorObjetivoM,
    Value<double?>? constanteK,
  }) {
    return ConfiguracionSlaTableCompanion(
      id: id ?? this.id,
      coeficienteIngreso: coeficienteIngreso ?? this.coeficienteIngreso,
      coeficienteCosto: coeficienteCosto ?? this.coeficienteCosto,
      valorObjetivoM: valorObjetivoM ?? this.valorObjetivoM,
      constanteK: constanteK ?? this.constanteK,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (coeficienteIngreso.present) {
      map['coeficiente_ingreso'] = Variable<double>(coeficienteIngreso.value);
    }
    if (coeficienteCosto.present) {
      map['coeficiente_costo'] = Variable<double>(coeficienteCosto.value);
    }
    if (valorObjetivoM.present) {
      map['valor_objetivo_m'] = Variable<double>(valorObjetivoM.value);
    }
    if (constanteK.present) {
      map['constante_k'] = Variable<double>(constanteK.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConfiguracionSlaTableCompanion(')
          ..write('id: $id, ')
          ..write('coeficienteIngreso: $coeficienteIngreso, ')
          ..write('coeficienteCosto: $coeficienteCosto, ')
          ..write('valorObjetivoM: $valorObjetivoM, ')
          ..write('constanteK: $constanteK')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ClienteTableTable clienteTable = $ClienteTableTable(this);
  late final $ProductoTableTable productoTable = $ProductoTableTable(this);
  late final $PedidoTableTable pedidoTable = $PedidoTableTable(this);
  late final $PedidoItemTableTable pedidoItemTable = $PedidoItemTableTable(
    this,
  );
  late final $HistorialEstadoTableTable historialEstadoTable =
      $HistorialEstadoTableTable(this);
  late final $ConfiguracionSlaTableTable configuracionSlaTable =
      $ConfiguracionSlaTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    clienteTable,
    productoTable,
    pedidoTable,
    pedidoItemTable,
    historialEstadoTable,
    configuracionSlaTable,
  ];
}

typedef $$ClienteTableTableCreateCompanionBuilder =
    ClienteTableCompanion Function({
      Value<int> id,
      required String nombre,
      Value<String?> contacto,
      Value<String?> notas,
    });
typedef $$ClienteTableTableUpdateCompanionBuilder =
    ClienteTableCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<String?> contacto,
      Value<String?> notas,
    });

final class $$ClienteTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $ClienteTableTable, ClienteTableData> {
  $$ClienteTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PedidoTableTable, List<PedidoTableData>>
  _pedidoTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.pedidoTable,
    aliasName: 'cliente__id__pedido__cliente_id',
  );

  $$PedidoTableTableProcessedTableManager get pedidoTableRefs {
    final manager = $$PedidoTableTableTableManager(
      $_db,
      $_db.pedidoTable,
    ).filter((f) => f.clienteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_pedidoTableRefsTable($_db));
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

  ColumnFilters<String> get contacto => $composableBuilder(
    column: $table.contacto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notas => $composableBuilder(
    column: $table.notas,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> pedidoTableRefs(
    Expression<bool> Function($$PedidoTableTableFilterComposer f) f,
  ) {
    final $$PedidoTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pedidoTable,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PedidoTableTableFilterComposer(
            $db: $db,
            $table: $db.pedidoTable,
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

  ColumnOrderings<String> get contacto => $composableBuilder(
    column: $table.contacto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notas => $composableBuilder(
    column: $table.notas,
    builder: (column) => ColumnOrderings(column),
  );
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

  GeneratedColumn<String> get contacto =>
      $composableBuilder(column: $table.contacto, builder: (column) => column);

  GeneratedColumn<String> get notas =>
      $composableBuilder(column: $table.notas, builder: (column) => column);

  Expression<T> pedidoTableRefs<T extends Object>(
    Expression<T> Function($$PedidoTableTableAnnotationComposer a) f,
  ) {
    final $$PedidoTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pedidoTable,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PedidoTableTableAnnotationComposer(
            $db: $db,
            $table: $db.pedidoTable,
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
          PrefetchHooks Function({bool pedidoTableRefs})
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
                Value<String> nombre = const Value.absent(),
                Value<String?> contacto = const Value.absent(),
                Value<String?> notas = const Value.absent(),
              }) => ClienteTableCompanion(
                id: id,
                nombre: nombre,
                contacto: contacto,
                notas: notas,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                Value<String?> contacto = const Value.absent(),
                Value<String?> notas = const Value.absent(),
              }) => ClienteTableCompanion.insert(
                id: id,
                nombre: nombre,
                contacto: contacto,
                notas: notas,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ClienteTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({pedidoTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (pedidoTableRefs) db.pedidoTable],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (pedidoTableRefs)
                    await $_getPrefetchedData<
                      ClienteTableData,
                      $ClienteTableTable,
                      PedidoTableData
                    >(
                      currentTable: table,
                      referencedTable: $$ClienteTableTableReferences
                          ._pedidoTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ClienteTableTableReferences(
                            db,
                            table,
                            p0,
                          ).pedidoTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.clienteId == item.id),
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
      PrefetchHooks Function({bool pedidoTableRefs})
    >;
typedef $$ProductoTableTableCreateCompanionBuilder =
    ProductoTableCompanion Function({
      Value<int> id,
      required String nombre,
      required String categoria,
      Value<double?> peso,
      Value<double?> volumen,
      required double valorUnitario,
      Value<String?> metodoFijacionPrecio,
      Value<String?> etapaCicloVida,
    });
typedef $$ProductoTableTableUpdateCompanionBuilder =
    ProductoTableCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<String> categoria,
      Value<double?> peso,
      Value<double?> volumen,
      Value<double> valorUnitario,
      Value<String?> metodoFijacionPrecio,
      Value<String?> etapaCicloVida,
    });

final class $$ProductoTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $ProductoTableTable, ProductoTableData> {
  $$ProductoTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$PedidoItemTableTable, List<PedidoItemTableData>>
  _pedidoItemTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.pedidoItemTable,
    aliasName: 'producto__id__pedido_item__producto_id',
  );

  $$PedidoItemTableTableProcessedTableManager get pedidoItemTableRefs {
    final manager = $$PedidoItemTableTableTableManager(
      $_db,
      $_db.pedidoItemTable,
    ).filter((f) => f.productoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _pedidoItemTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductoTableTableFilterComposer
    extends Composer<_$AppDatabase, $ProductoTableTable> {
  $$ProductoTableTableFilterComposer({
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

  ColumnFilters<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get peso => $composableBuilder(
    column: $table.peso,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get volumen => $composableBuilder(
    column: $table.volumen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get valorUnitario => $composableBuilder(
    column: $table.valorUnitario,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metodoFijacionPrecio => $composableBuilder(
    column: $table.metodoFijacionPrecio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get etapaCicloVida => $composableBuilder(
    column: $table.etapaCicloVida,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> pedidoItemTableRefs(
    Expression<bool> Function($$PedidoItemTableTableFilterComposer f) f,
  ) {
    final $$PedidoItemTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pedidoItemTable,
      getReferencedColumn: (t) => t.productoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PedidoItemTableTableFilterComposer(
            $db: $db,
            $table: $db.pedidoItemTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductoTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductoTableTable> {
  $$ProductoTableTableOrderingComposer({
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

  ColumnOrderings<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get peso => $composableBuilder(
    column: $table.peso,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get volumen => $composableBuilder(
    column: $table.volumen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get valorUnitario => $composableBuilder(
    column: $table.valorUnitario,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metodoFijacionPrecio => $composableBuilder(
    column: $table.metodoFijacionPrecio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get etapaCicloVida => $composableBuilder(
    column: $table.etapaCicloVida,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductoTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductoTableTable> {
  $$ProductoTableTableAnnotationComposer({
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

  GeneratedColumn<String> get categoria =>
      $composableBuilder(column: $table.categoria, builder: (column) => column);

  GeneratedColumn<double> get peso =>
      $composableBuilder(column: $table.peso, builder: (column) => column);

  GeneratedColumn<double> get volumen =>
      $composableBuilder(column: $table.volumen, builder: (column) => column);

  GeneratedColumn<double> get valorUnitario => $composableBuilder(
    column: $table.valorUnitario,
    builder: (column) => column,
  );

  GeneratedColumn<String> get metodoFijacionPrecio => $composableBuilder(
    column: $table.metodoFijacionPrecio,
    builder: (column) => column,
  );

  GeneratedColumn<String> get etapaCicloVida => $composableBuilder(
    column: $table.etapaCicloVida,
    builder: (column) => column,
  );

  Expression<T> pedidoItemTableRefs<T extends Object>(
    Expression<T> Function($$PedidoItemTableTableAnnotationComposer a) f,
  ) {
    final $$PedidoItemTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pedidoItemTable,
      getReferencedColumn: (t) => t.productoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PedidoItemTableTableAnnotationComposer(
            $db: $db,
            $table: $db.pedidoItemTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductoTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductoTableTable,
          ProductoTableData,
          $$ProductoTableTableFilterComposer,
          $$ProductoTableTableOrderingComposer,
          $$ProductoTableTableAnnotationComposer,
          $$ProductoTableTableCreateCompanionBuilder,
          $$ProductoTableTableUpdateCompanionBuilder,
          (ProductoTableData, $$ProductoTableTableReferences),
          ProductoTableData,
          PrefetchHooks Function({bool pedidoItemTableRefs})
        > {
  $$ProductoTableTableTableManager(_$AppDatabase db, $ProductoTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductoTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductoTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductoTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> categoria = const Value.absent(),
                Value<double?> peso = const Value.absent(),
                Value<double?> volumen = const Value.absent(),
                Value<double> valorUnitario = const Value.absent(),
                Value<String?> metodoFijacionPrecio = const Value.absent(),
                Value<String?> etapaCicloVida = const Value.absent(),
              }) => ProductoTableCompanion(
                id: id,
                nombre: nombre,
                categoria: categoria,
                peso: peso,
                volumen: volumen,
                valorUnitario: valorUnitario,
                metodoFijacionPrecio: metodoFijacionPrecio,
                etapaCicloVida: etapaCicloVida,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                required String categoria,
                Value<double?> peso = const Value.absent(),
                Value<double?> volumen = const Value.absent(),
                required double valorUnitario,
                Value<String?> metodoFijacionPrecio = const Value.absent(),
                Value<String?> etapaCicloVida = const Value.absent(),
              }) => ProductoTableCompanion.insert(
                id: id,
                nombre: nombre,
                categoria: categoria,
                peso: peso,
                volumen: volumen,
                valorUnitario: valorUnitario,
                metodoFijacionPrecio: metodoFijacionPrecio,
                etapaCicloVida: etapaCicloVida,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductoTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({pedidoItemTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (pedidoItemTableRefs) db.pedidoItemTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (pedidoItemTableRefs)
                    await $_getPrefetchedData<
                      ProductoTableData,
                      $ProductoTableTable,
                      PedidoItemTableData
                    >(
                      currentTable: table,
                      referencedTable: $$ProductoTableTableReferences
                          ._pedidoItemTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ProductoTableTableReferences(
                            db,
                            table,
                            p0,
                          ).pedidoItemTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.productoId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProductoTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductoTableTable,
      ProductoTableData,
      $$ProductoTableTableFilterComposer,
      $$ProductoTableTableOrderingComposer,
      $$ProductoTableTableAnnotationComposer,
      $$ProductoTableTableCreateCompanionBuilder,
      $$ProductoTableTableUpdateCompanionBuilder,
      (ProductoTableData, $$ProductoTableTableReferences),
      ProductoTableData,
      PrefetchHooks Function({bool pedidoItemTableRefs})
    >;
typedef $$PedidoTableTableCreateCompanionBuilder =
    PedidoTableCompanion Function({
      Value<int> id,
      required int clienteId,
      required String fechaCreacion,
      required String estadoActual,
      Value<int> prioridad,
    });
typedef $$PedidoTableTableUpdateCompanionBuilder =
    PedidoTableCompanion Function({
      Value<int> id,
      Value<int> clienteId,
      Value<String> fechaCreacion,
      Value<String> estadoActual,
      Value<int> prioridad,
    });

final class $$PedidoTableTableReferences
    extends BaseReferences<_$AppDatabase, $PedidoTableTable, PedidoTableData> {
  $$PedidoTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ClienteTableTable _clienteIdTable(_$AppDatabase db) =>
      db.clienteTable.createAlias('pedido__cliente_id__cliente__id');

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

  static MultiTypedResultKey<$PedidoItemTableTable, List<PedidoItemTableData>>
  _pedidoItemTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.pedidoItemTable,
    aliasName: 'pedido__id__pedido_item__pedido_id',
  );

  $$PedidoItemTableTableProcessedTableManager get pedidoItemTableRefs {
    final manager = $$PedidoItemTableTableTableManager(
      $_db,
      $_db.pedidoItemTable,
    ).filter((f) => f.pedidoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _pedidoItemTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $HistorialEstadoTableTable,
    List<HistorialEstadoTableData>
  >
  _historialEstadoTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.historialEstadoTable,
        aliasName: 'pedido__id__historial_estado__pedido_id',
      );

  $$HistorialEstadoTableTableProcessedTableManager
  get historialEstadoTableRefs {
    final manager = $$HistorialEstadoTableTableTableManager(
      $_db,
      $_db.historialEstadoTable,
    ).filter((f) => f.pedidoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _historialEstadoTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PedidoTableTableFilterComposer
    extends Composer<_$AppDatabase, $PedidoTableTable> {
  $$PedidoTableTableFilterComposer({
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

  ColumnFilters<String> get estadoActual => $composableBuilder(
    column: $table.estadoActual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get prioridad => $composableBuilder(
    column: $table.prioridad,
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

  Expression<bool> pedidoItemTableRefs(
    Expression<bool> Function($$PedidoItemTableTableFilterComposer f) f,
  ) {
    final $$PedidoItemTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pedidoItemTable,
      getReferencedColumn: (t) => t.pedidoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PedidoItemTableTableFilterComposer(
            $db: $db,
            $table: $db.pedidoItemTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> historialEstadoTableRefs(
    Expression<bool> Function($$HistorialEstadoTableTableFilterComposer f) f,
  ) {
    final $$HistorialEstadoTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.historialEstadoTable,
      getReferencedColumn: (t) => t.pedidoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HistorialEstadoTableTableFilterComposer(
            $db: $db,
            $table: $db.historialEstadoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PedidoTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PedidoTableTable> {
  $$PedidoTableTableOrderingComposer({
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

  ColumnOrderings<String> get estadoActual => $composableBuilder(
    column: $table.estadoActual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get prioridad => $composableBuilder(
    column: $table.prioridad,
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
}

class $$PedidoTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PedidoTableTable> {
  $$PedidoTableTableAnnotationComposer({
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

  GeneratedColumn<String> get estadoActual => $composableBuilder(
    column: $table.estadoActual,
    builder: (column) => column,
  );

  GeneratedColumn<int> get prioridad =>
      $composableBuilder(column: $table.prioridad, builder: (column) => column);

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

  Expression<T> pedidoItemTableRefs<T extends Object>(
    Expression<T> Function($$PedidoItemTableTableAnnotationComposer a) f,
  ) {
    final $$PedidoItemTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pedidoItemTable,
      getReferencedColumn: (t) => t.pedidoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PedidoItemTableTableAnnotationComposer(
            $db: $db,
            $table: $db.pedidoItemTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> historialEstadoTableRefs<T extends Object>(
    Expression<T> Function($$HistorialEstadoTableTableAnnotationComposer a) f,
  ) {
    final $$HistorialEstadoTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.historialEstadoTable,
          getReferencedColumn: (t) => t.pedidoId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$HistorialEstadoTableTableAnnotationComposer(
                $db: $db,
                $table: $db.historialEstadoTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$PedidoTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PedidoTableTable,
          PedidoTableData,
          $$PedidoTableTableFilterComposer,
          $$PedidoTableTableOrderingComposer,
          $$PedidoTableTableAnnotationComposer,
          $$PedidoTableTableCreateCompanionBuilder,
          $$PedidoTableTableUpdateCompanionBuilder,
          (PedidoTableData, $$PedidoTableTableReferences),
          PedidoTableData,
          PrefetchHooks Function({
            bool clienteId,
            bool pedidoItemTableRefs,
            bool historialEstadoTableRefs,
          })
        > {
  $$PedidoTableTableTableManager(_$AppDatabase db, $PedidoTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PedidoTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PedidoTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PedidoTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> clienteId = const Value.absent(),
                Value<String> fechaCreacion = const Value.absent(),
                Value<String> estadoActual = const Value.absent(),
                Value<int> prioridad = const Value.absent(),
              }) => PedidoTableCompanion(
                id: id,
                clienteId: clienteId,
                fechaCreacion: fechaCreacion,
                estadoActual: estadoActual,
                prioridad: prioridad,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int clienteId,
                required String fechaCreacion,
                required String estadoActual,
                Value<int> prioridad = const Value.absent(),
              }) => PedidoTableCompanion.insert(
                id: id,
                clienteId: clienteId,
                fechaCreacion: fechaCreacion,
                estadoActual: estadoActual,
                prioridad: prioridad,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PedidoTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                clienteId = false,
                pedidoItemTableRefs = false,
                historialEstadoTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (pedidoItemTableRefs) db.pedidoItemTable,
                    if (historialEstadoTableRefs) db.historialEstadoTable,
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
                        if (clienteId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.clienteId,
                                    referencedTable:
                                        $$PedidoTableTableReferences
                                            ._clienteIdTable(db),
                                    referencedColumn:
                                        $$PedidoTableTableReferences
                                            ._clienteIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (pedidoItemTableRefs)
                        await $_getPrefetchedData<
                          PedidoTableData,
                          $PedidoTableTable,
                          PedidoItemTableData
                        >(
                          currentTable: table,
                          referencedTable: $$PedidoTableTableReferences
                              ._pedidoItemTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PedidoTableTableReferences(
                                db,
                                table,
                                p0,
                              ).pedidoItemTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.pedidoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (historialEstadoTableRefs)
                        await $_getPrefetchedData<
                          PedidoTableData,
                          $PedidoTableTable,
                          HistorialEstadoTableData
                        >(
                          currentTable: table,
                          referencedTable: $$PedidoTableTableReferences
                              ._historialEstadoTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PedidoTableTableReferences(
                                db,
                                table,
                                p0,
                              ).historialEstadoTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.pedidoId == item.id,
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

typedef $$PedidoTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PedidoTableTable,
      PedidoTableData,
      $$PedidoTableTableFilterComposer,
      $$PedidoTableTableOrderingComposer,
      $$PedidoTableTableAnnotationComposer,
      $$PedidoTableTableCreateCompanionBuilder,
      $$PedidoTableTableUpdateCompanionBuilder,
      (PedidoTableData, $$PedidoTableTableReferences),
      PedidoTableData,
      PrefetchHooks Function({
        bool clienteId,
        bool pedidoItemTableRefs,
        bool historialEstadoTableRefs,
      })
    >;
typedef $$PedidoItemTableTableCreateCompanionBuilder =
    PedidoItemTableCompanion Function({
      Value<int> id,
      required int pedidoId,
      required int productoId,
      required int cantidad,
      required double precioAplicado,
    });
typedef $$PedidoItemTableTableUpdateCompanionBuilder =
    PedidoItemTableCompanion Function({
      Value<int> id,
      Value<int> pedidoId,
      Value<int> productoId,
      Value<int> cantidad,
      Value<double> precioAplicado,
    });

final class $$PedidoItemTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PedidoItemTableTable,
          PedidoItemTableData
        > {
  $$PedidoItemTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PedidoTableTable _pedidoIdTable(_$AppDatabase db) =>
      db.pedidoTable.createAlias('pedido_item__pedido_id__pedido__id');

  $$PedidoTableTableProcessedTableManager get pedidoId {
    final $_column = $_itemColumn<int>('pedido_id')!;

    final manager = $$PedidoTableTableTableManager(
      $_db,
      $_db.pedidoTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pedidoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductoTableTable _productoIdTable(_$AppDatabase db) =>
      db.productoTable.createAlias('pedido_item__producto_id__producto__id');

  $$ProductoTableTableProcessedTableManager get productoId {
    final $_column = $_itemColumn<int>('producto_id')!;

    final manager = $$ProductoTableTableTableManager(
      $_db,
      $_db.productoTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PedidoItemTableTableFilterComposer
    extends Composer<_$AppDatabase, $PedidoItemTableTable> {
  $$PedidoItemTableTableFilterComposer({
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

  ColumnFilters<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precioAplicado => $composableBuilder(
    column: $table.precioAplicado,
    builder: (column) => ColumnFilters(column),
  );

  $$PedidoTableTableFilterComposer get pedidoId {
    final $$PedidoTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pedidoId,
      referencedTable: $db.pedidoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PedidoTableTableFilterComposer(
            $db: $db,
            $table: $db.pedidoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductoTableTableFilterComposer get productoId {
    final $$ProductoTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.productoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductoTableTableFilterComposer(
            $db: $db,
            $table: $db.productoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PedidoItemTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PedidoItemTableTable> {
  $$PedidoItemTableTableOrderingComposer({
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

  ColumnOrderings<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precioAplicado => $composableBuilder(
    column: $table.precioAplicado,
    builder: (column) => ColumnOrderings(column),
  );

  $$PedidoTableTableOrderingComposer get pedidoId {
    final $$PedidoTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pedidoId,
      referencedTable: $db.pedidoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PedidoTableTableOrderingComposer(
            $db: $db,
            $table: $db.pedidoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductoTableTableOrderingComposer get productoId {
    final $$ProductoTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.productoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductoTableTableOrderingComposer(
            $db: $db,
            $table: $db.productoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PedidoItemTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PedidoItemTableTable> {
  $$PedidoItemTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<double> get precioAplicado => $composableBuilder(
    column: $table.precioAplicado,
    builder: (column) => column,
  );

  $$PedidoTableTableAnnotationComposer get pedidoId {
    final $$PedidoTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pedidoId,
      referencedTable: $db.pedidoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PedidoTableTableAnnotationComposer(
            $db: $db,
            $table: $db.pedidoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductoTableTableAnnotationComposer get productoId {
    final $$ProductoTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.productoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductoTableTableAnnotationComposer(
            $db: $db,
            $table: $db.productoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PedidoItemTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PedidoItemTableTable,
          PedidoItemTableData,
          $$PedidoItemTableTableFilterComposer,
          $$PedidoItemTableTableOrderingComposer,
          $$PedidoItemTableTableAnnotationComposer,
          $$PedidoItemTableTableCreateCompanionBuilder,
          $$PedidoItemTableTableUpdateCompanionBuilder,
          (PedidoItemTableData, $$PedidoItemTableTableReferences),
          PedidoItemTableData,
          PrefetchHooks Function({bool pedidoId, bool productoId})
        > {
  $$PedidoItemTableTableTableManager(
    _$AppDatabase db,
    $PedidoItemTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PedidoItemTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PedidoItemTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PedidoItemTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> pedidoId = const Value.absent(),
                Value<int> productoId = const Value.absent(),
                Value<int> cantidad = const Value.absent(),
                Value<double> precioAplicado = const Value.absent(),
              }) => PedidoItemTableCompanion(
                id: id,
                pedidoId: pedidoId,
                productoId: productoId,
                cantidad: cantidad,
                precioAplicado: precioAplicado,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int pedidoId,
                required int productoId,
                required int cantidad,
                required double precioAplicado,
              }) => PedidoItemTableCompanion.insert(
                id: id,
                pedidoId: pedidoId,
                productoId: productoId,
                cantidad: cantidad,
                precioAplicado: precioAplicado,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PedidoItemTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({pedidoId = false, productoId = false}) {
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
                    if (pedidoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.pedidoId,
                                referencedTable:
                                    $$PedidoItemTableTableReferences
                                        ._pedidoIdTable(db),
                                referencedColumn:
                                    $$PedidoItemTableTableReferences
                                        ._pedidoIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (productoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.productoId,
                                referencedTable:
                                    $$PedidoItemTableTableReferences
                                        ._productoIdTable(db),
                                referencedColumn:
                                    $$PedidoItemTableTableReferences
                                        ._productoIdTable(db)
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

typedef $$PedidoItemTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PedidoItemTableTable,
      PedidoItemTableData,
      $$PedidoItemTableTableFilterComposer,
      $$PedidoItemTableTableOrderingComposer,
      $$PedidoItemTableTableAnnotationComposer,
      $$PedidoItemTableTableCreateCompanionBuilder,
      $$PedidoItemTableTableUpdateCompanionBuilder,
      (PedidoItemTableData, $$PedidoItemTableTableReferences),
      PedidoItemTableData,
      PrefetchHooks Function({bool pedidoId, bool productoId})
    >;
typedef $$HistorialEstadoTableTableCreateCompanionBuilder =
    HistorialEstadoTableCompanion Function({
      Value<int> id,
      required int pedidoId,
      required String estado,
      required String timestamp,
      Value<String?> nota,
    });
typedef $$HistorialEstadoTableTableUpdateCompanionBuilder =
    HistorialEstadoTableCompanion Function({
      Value<int> id,
      Value<int> pedidoId,
      Value<String> estado,
      Value<String> timestamp,
      Value<String?> nota,
    });

final class $$HistorialEstadoTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $HistorialEstadoTableTable,
          HistorialEstadoTableData
        > {
  $$HistorialEstadoTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PedidoTableTable _pedidoIdTable(_$AppDatabase db) =>
      db.pedidoTable.createAlias('historial_estado__pedido_id__pedido__id');

  $$PedidoTableTableProcessedTableManager get pedidoId {
    final $_column = $_itemColumn<int>('pedido_id')!;

    final manager = $$PedidoTableTableTableManager(
      $_db,
      $_db.pedidoTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pedidoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$HistorialEstadoTableTableFilterComposer
    extends Composer<_$AppDatabase, $HistorialEstadoTableTable> {
  $$HistorialEstadoTableTableFilterComposer({
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

  ColumnFilters<String> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nota => $composableBuilder(
    column: $table.nota,
    builder: (column) => ColumnFilters(column),
  );

  $$PedidoTableTableFilterComposer get pedidoId {
    final $$PedidoTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pedidoId,
      referencedTable: $db.pedidoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PedidoTableTableFilterComposer(
            $db: $db,
            $table: $db.pedidoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HistorialEstadoTableTableOrderingComposer
    extends Composer<_$AppDatabase, $HistorialEstadoTableTable> {
  $$HistorialEstadoTableTableOrderingComposer({
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

  ColumnOrderings<String> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nota => $composableBuilder(
    column: $table.nota,
    builder: (column) => ColumnOrderings(column),
  );

  $$PedidoTableTableOrderingComposer get pedidoId {
    final $$PedidoTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pedidoId,
      referencedTable: $db.pedidoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PedidoTableTableOrderingComposer(
            $db: $db,
            $table: $db.pedidoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HistorialEstadoTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $HistorialEstadoTableTable> {
  $$HistorialEstadoTableTableAnnotationComposer({
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

  GeneratedColumn<String> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get nota =>
      $composableBuilder(column: $table.nota, builder: (column) => column);

  $$PedidoTableTableAnnotationComposer get pedidoId {
    final $$PedidoTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pedidoId,
      referencedTable: $db.pedidoTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PedidoTableTableAnnotationComposer(
            $db: $db,
            $table: $db.pedidoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HistorialEstadoTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HistorialEstadoTableTable,
          HistorialEstadoTableData,
          $$HistorialEstadoTableTableFilterComposer,
          $$HistorialEstadoTableTableOrderingComposer,
          $$HistorialEstadoTableTableAnnotationComposer,
          $$HistorialEstadoTableTableCreateCompanionBuilder,
          $$HistorialEstadoTableTableUpdateCompanionBuilder,
          (HistorialEstadoTableData, $$HistorialEstadoTableTableReferences),
          HistorialEstadoTableData,
          PrefetchHooks Function({bool pedidoId})
        > {
  $$HistorialEstadoTableTableTableManager(
    _$AppDatabase db,
    $HistorialEstadoTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HistorialEstadoTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HistorialEstadoTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$HistorialEstadoTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> pedidoId = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<String> timestamp = const Value.absent(),
                Value<String?> nota = const Value.absent(),
              }) => HistorialEstadoTableCompanion(
                id: id,
                pedidoId: pedidoId,
                estado: estado,
                timestamp: timestamp,
                nota: nota,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int pedidoId,
                required String estado,
                required String timestamp,
                Value<String?> nota = const Value.absent(),
              }) => HistorialEstadoTableCompanion.insert(
                id: id,
                pedidoId: pedidoId,
                estado: estado,
                timestamp: timestamp,
                nota: nota,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HistorialEstadoTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({pedidoId = false}) {
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
                    if (pedidoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.pedidoId,
                                referencedTable:
                                    $$HistorialEstadoTableTableReferences
                                        ._pedidoIdTable(db),
                                referencedColumn:
                                    $$HistorialEstadoTableTableReferences
                                        ._pedidoIdTable(db)
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

typedef $$HistorialEstadoTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HistorialEstadoTableTable,
      HistorialEstadoTableData,
      $$HistorialEstadoTableTableFilterComposer,
      $$HistorialEstadoTableTableOrderingComposer,
      $$HistorialEstadoTableTableAnnotationComposer,
      $$HistorialEstadoTableTableCreateCompanionBuilder,
      $$HistorialEstadoTableTableUpdateCompanionBuilder,
      (HistorialEstadoTableData, $$HistorialEstadoTableTableReferences),
      HistorialEstadoTableData,
      PrefetchHooks Function({bool pedidoId})
    >;
typedef $$ConfiguracionSlaTableTableCreateCompanionBuilder =
    ConfiguracionSlaTableCompanion Function({
      Value<int> id,
      Value<double> coeficienteIngreso,
      Value<double> coeficienteCosto,
      Value<double?> valorObjetivoM,
      Value<double?> constanteK,
    });
typedef $$ConfiguracionSlaTableTableUpdateCompanionBuilder =
    ConfiguracionSlaTableCompanion Function({
      Value<int> id,
      Value<double> coeficienteIngreso,
      Value<double> coeficienteCosto,
      Value<double?> valorObjetivoM,
      Value<double?> constanteK,
    });

class $$ConfiguracionSlaTableTableFilterComposer
    extends Composer<_$AppDatabase, $ConfiguracionSlaTableTable> {
  $$ConfiguracionSlaTableTableFilterComposer({
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

  ColumnFilters<double> get coeficienteIngreso => $composableBuilder(
    column: $table.coeficienteIngreso,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get coeficienteCosto => $composableBuilder(
    column: $table.coeficienteCosto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get valorObjetivoM => $composableBuilder(
    column: $table.valorObjetivoM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get constanteK => $composableBuilder(
    column: $table.constanteK,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ConfiguracionSlaTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ConfiguracionSlaTableTable> {
  $$ConfiguracionSlaTableTableOrderingComposer({
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

  ColumnOrderings<double> get coeficienteIngreso => $composableBuilder(
    column: $table.coeficienteIngreso,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get coeficienteCosto => $composableBuilder(
    column: $table.coeficienteCosto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get valorObjetivoM => $composableBuilder(
    column: $table.valorObjetivoM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get constanteK => $composableBuilder(
    column: $table.constanteK,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ConfiguracionSlaTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConfiguracionSlaTableTable> {
  $$ConfiguracionSlaTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get coeficienteIngreso => $composableBuilder(
    column: $table.coeficienteIngreso,
    builder: (column) => column,
  );

  GeneratedColumn<double> get coeficienteCosto => $composableBuilder(
    column: $table.coeficienteCosto,
    builder: (column) => column,
  );

  GeneratedColumn<double> get valorObjetivoM => $composableBuilder(
    column: $table.valorObjetivoM,
    builder: (column) => column,
  );

  GeneratedColumn<double> get constanteK => $composableBuilder(
    column: $table.constanteK,
    builder: (column) => column,
  );
}

class $$ConfiguracionSlaTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConfiguracionSlaTableTable,
          ConfiguracionSlaTableData,
          $$ConfiguracionSlaTableTableFilterComposer,
          $$ConfiguracionSlaTableTableOrderingComposer,
          $$ConfiguracionSlaTableTableAnnotationComposer,
          $$ConfiguracionSlaTableTableCreateCompanionBuilder,
          $$ConfiguracionSlaTableTableUpdateCompanionBuilder,
          (
            ConfiguracionSlaTableData,
            BaseReferences<
              _$AppDatabase,
              $ConfiguracionSlaTableTable,
              ConfiguracionSlaTableData
            >,
          ),
          ConfiguracionSlaTableData,
          PrefetchHooks Function()
        > {
  $$ConfiguracionSlaTableTableTableManager(
    _$AppDatabase db,
    $ConfiguracionSlaTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConfiguracionSlaTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ConfiguracionSlaTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ConfiguracionSlaTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> coeficienteIngreso = const Value.absent(),
                Value<double> coeficienteCosto = const Value.absent(),
                Value<double?> valorObjetivoM = const Value.absent(),
                Value<double?> constanteK = const Value.absent(),
              }) => ConfiguracionSlaTableCompanion(
                id: id,
                coeficienteIngreso: coeficienteIngreso,
                coeficienteCosto: coeficienteCosto,
                valorObjetivoM: valorObjetivoM,
                constanteK: constanteK,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> coeficienteIngreso = const Value.absent(),
                Value<double> coeficienteCosto = const Value.absent(),
                Value<double?> valorObjetivoM = const Value.absent(),
                Value<double?> constanteK = const Value.absent(),
              }) => ConfiguracionSlaTableCompanion.insert(
                id: id,
                coeficienteIngreso: coeficienteIngreso,
                coeficienteCosto: coeficienteCosto,
                valorObjetivoM: valorObjetivoM,
                constanteK: constanteK,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ConfiguracionSlaTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConfiguracionSlaTableTable,
      ConfiguracionSlaTableData,
      $$ConfiguracionSlaTableTableFilterComposer,
      $$ConfiguracionSlaTableTableOrderingComposer,
      $$ConfiguracionSlaTableTableAnnotationComposer,
      $$ConfiguracionSlaTableTableCreateCompanionBuilder,
      $$ConfiguracionSlaTableTableUpdateCompanionBuilder,
      (
        ConfiguracionSlaTableData,
        BaseReferences<
          _$AppDatabase,
          $ConfiguracionSlaTableTable,
          ConfiguracionSlaTableData
        >,
      ),
      ConfiguracionSlaTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ClienteTableTableTableManager get clienteTable =>
      $$ClienteTableTableTableManager(_db, _db.clienteTable);
  $$ProductoTableTableTableManager get productoTable =>
      $$ProductoTableTableTableManager(_db, _db.productoTable);
  $$PedidoTableTableTableManager get pedidoTable =>
      $$PedidoTableTableTableManager(_db, _db.pedidoTable);
  $$PedidoItemTableTableTableManager get pedidoItemTable =>
      $$PedidoItemTableTableTableManager(_db, _db.pedidoItemTable);
  $$HistorialEstadoTableTableTableManager get historialEstadoTable =>
      $$HistorialEstadoTableTableTableManager(_db, _db.historialEstadoTable);
  $$ConfiguracionSlaTableTableTableManager get configuracionSlaTable =>
      $$ConfiguracionSlaTableTableTableManager(_db, _db.configuracionSlaTable);
}
