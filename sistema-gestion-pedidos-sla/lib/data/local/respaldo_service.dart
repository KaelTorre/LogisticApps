import 'dart:convert';

import 'package:drift/drift.dart';

import 'database.dart';

class RespaldoInvalido implements Exception {
  final String mensaje;
  const RespaldoInvalido(this.mensaje);
  @override
  String toString() => mensaje;
}

/// Exporta/restaura la base completa como un archivo `.json` versionado
/// (CLAUDE.md §6.7 / M7). No es sincronización en la nube: es un mecanismo
/// de portabilidad de archivo local, elegido a mano por el usuario vía
/// `file_picker`.
class RespaldoService {
  RespaldoService(this._database);

  final AppDatabase _database;

  static const int version = 1;

  Future<String> exportarComoJson() async {
    final datos = <String, Object?>{
      'version': version,
      'exportadoEn': DateTime.now().toIso8601String(),
      'cliente': (await _database.select(_database.clienteTable).get())
          .map((f) => f.toJson())
          .toList(),
      'producto': (await _database.select(_database.productoTable).get())
          .map((f) => f.toJson())
          .toList(),
      'pedido': (await _database.select(_database.pedidoTable).get())
          .map((f) => f.toJson())
          .toList(),
      'pedido_item': (await _database.select(_database.pedidoItemTable).get())
          .map((f) => f.toJson())
          .toList(),
      'historial_estado':
          (await _database.select(_database.historialEstadoTable).get())
              .map((f) => f.toJson())
              .toList(),
      'configuracion_sla':
          (await _database.select(_database.configuracionSlaTable).get())
              .map((f) => f.toJson())
              .toList(),
    };
    return const JsonEncoder.withIndent('  ').convert(datos);
  }

  /// Reemplaza todos los datos actuales por los del respaldo, dentro de una
  /// única transacción. Borra en orden hijo→padre y vuelve a insertar en
  /// orden padre→hijo para respetar las FKs reales del esquema.
  Future<void> importarDesdeJson(String contenido) async {
    final Map<String, dynamic> datos;
    try {
      datos = jsonDecode(contenido) as Map<String, dynamic>;
    } on FormatException {
      throw const RespaldoInvalido('El archivo no tiene un formato JSON válido.');
    }

    if (datos['version'] != version) {
      throw RespaldoInvalido(
        'Versión de respaldo no compatible: ${datos['version']}.',
      );
    }

    await _database.transaction(() async {
      await _database.delete(_database.historialEstadoTable).go();
      await _database.delete(_database.pedidoItemTable).go();
      await _database.delete(_database.pedidoTable).go();
      await _database.delete(_database.configuracionSlaTable).go();
      await _database.delete(_database.productoTable).go();
      await _database.delete(_database.clienteTable).go();

      for (final fila in _lista(datos, 'cliente')) {
        await _database
            .into(_database.clienteTable)
            .insert(ClienteTableData.fromJson(fila), mode: InsertMode.insertOrReplace);
      }
      for (final fila in _lista(datos, 'producto')) {
        await _database.into(_database.productoTable).insert(
              ProductoTableData.fromJson(fila),
              mode: InsertMode.insertOrReplace,
            );
      }
      for (final fila in _lista(datos, 'pedido')) {
        await _database
            .into(_database.pedidoTable)
            .insert(PedidoTableData.fromJson(fila), mode: InsertMode.insertOrReplace);
      }
      for (final fila in _lista(datos, 'pedido_item')) {
        await _database.into(_database.pedidoItemTable).insert(
              PedidoItemTableData.fromJson(fila),
              mode: InsertMode.insertOrReplace,
            );
      }
      for (final fila in _lista(datos, 'historial_estado')) {
        await _database.into(_database.historialEstadoTable).insert(
              HistorialEstadoTableData.fromJson(fila),
              mode: InsertMode.insertOrReplace,
            );
      }
      for (final fila in _lista(datos, 'configuracion_sla')) {
        await _database.into(_database.configuracionSlaTable).insert(
              ConfiguracionSlaTableData.fromJson(fila),
              mode: InsertMode.insertOrReplace,
            );
      }
    });
  }

  List<Map<String, dynamic>> _lista(Map<String, dynamic> datos, String clave) {
    final valor = datos[clave];
    if (valor is! List) {
      throw RespaldoInvalido('Falta la sección "$clave" en el respaldo.');
    }
    return valor.cast<Map<String, dynamic>>();
  }
}
