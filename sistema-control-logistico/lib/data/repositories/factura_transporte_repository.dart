import 'package:drift/drift.dart' show Value;

import '../local/database.dart';
import '../models/factura_transporte.dart';

class FacturaTransporteRepository {
  FacturaTransporteRepository(this._database);

  final AppDatabase _database;

  Future<List<FacturaTransporte>> obtenerPorOrganizacion(int organizacionId) async {
    final filas =
        await (_database.select(_database.facturaTransporteTable)
              ..where((t) => t.organizacionId.equals(organizacionId)))
            .get();
    return filas.map(_aDominio).toList();
  }

  Future<int> crear(FacturaTransporte factura) {
    return _database
        .into(_database.facturaTransporteTable)
        .insert(
          FacturaTransporteTableCompanion.insert(
            organizacionId: factura.organizacionId,
            numero: factura.numero,
            transportista: factura.transportista,
            peso: factura.peso,
            ruta: factura.ruta,
            tarifaAplicadaCent: factura.tarifaAplicadaCent,
            tarifaContratadaCent: factura.tarifaContratadaCent,
            discrepanciaTipo: Value(factura.discrepanciaTipo),
            montoRecuperableCent: Value(factura.montoRecuperableCent),
            estado: Value(factura.estado),
          ),
        );
  }

  Future<void> actualizar(FacturaTransporte factura) async {
    await (_database.update(
      _database.facturaTransporteTable,
    )..where((t) => t.id.equals(factura.id!))).write(
      FacturaTransporteTableCompanion(
        transportista: Value(factura.transportista),
        peso: Value(factura.peso),
        ruta: Value(factura.ruta),
        tarifaAplicadaCent: Value(factura.tarifaAplicadaCent),
        tarifaContratadaCent: Value(factura.tarifaContratadaCent),
        discrepanciaTipo: Value(factura.discrepanciaTipo),
        montoRecuperableCent: Value(factura.montoRecuperableCent),
        estado: Value(factura.estado),
      ),
    );
  }

  Future<void> eliminar(int id) async {
    await (_database.delete(
      _database.facturaTransporteTable,
    )..where((t) => t.id.equals(id))).go();
  }

  FacturaTransporte _aDominio(FacturaTransporteTableData fila) => FacturaTransporte(
    id: fila.id,
    organizacionId: fila.organizacionId,
    numero: fila.numero,
    transportista: fila.transportista,
    peso: fila.peso,
    ruta: fila.ruta,
    tarifaAplicadaCent: fila.tarifaAplicadaCent,
    tarifaContratadaCent: fila.tarifaContratadaCent,
    discrepanciaTipo: fila.discrepanciaTipo,
    montoRecuperableCent: fila.montoRecuperableCent,
    estado: fila.estado,
  );
}
