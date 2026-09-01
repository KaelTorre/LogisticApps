import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_control_logistico/data/models/factura_transporte.dart';
import 'package:sistema_control_logistico/domain/motor/m10_auditoria_facturas.dart';

/// Fase 8 (CLAUDE.md): "Test de auditoría de facturas: una factura con
/// tarifa correcta no genera discrepancia; una con tarifa inflada genera
/// discrepancia de tipo tarifa con el monto exacto de diferencia." y
/// "Test de duplicados: dos facturas con el mismo número y transportista
/// se marcan como duplicado."
void main() {
  FacturaTransporte factura({
    required String numero,
    required String transportista,
    required int tarifaAplicadaCent,
    required int tarifaContratadaCent,
  }) {
    return FacturaTransporte(
      organizacionId: 1,
      numero: numero,
      transportista: transportista,
      peso: 1000,
      ruta: 'Lima-Arequipa',
      tarifaAplicadaCent: tarifaAplicadaCent,
      tarifaContratadaCent: tarifaContratadaCent,
    );
  }

  test('una factura con tarifa correcta no genera discrepancia', () {
    final resultado = auditarFacturas([
      factura(numero: 'F-1', transportista: 'Transportes ABC', tarifaAplicadaCent: 50000, tarifaContratadaCent: 50000),
    ]);

    expect(resultado.single.discrepanciaTipo, isNull);
    expect(resultado.single.montoRecuperableCent, 0);
  });

  test('una factura con tarifa inflada genera discrepancia de tipo tarifa con el monto exacto de diferencia', () {
    final resultado = auditarFacturas([
      factura(numero: 'F-2', transportista: 'Transportes ABC', tarifaAplicadaCent: 65000, tarifaContratadaCent: 50000),
    ]);

    expect(resultado.single.discrepanciaTipo, 'tarifa');
    expect(resultado.single.montoRecuperableCent, 15000);
  });

  test('una factura con tarifa por debajo de lo contratado es discrepancia de tarifa pero nada recuperable', () {
    final resultado = auditarFacturas([
      factura(numero: 'F-3', transportista: 'Transportes ABC', tarifaAplicadaCent: 40000, tarifaContratadaCent: 50000),
    ]);

    expect(resultado.single.discrepanciaTipo, 'tarifa');
    expect(resultado.single.montoRecuperableCent, 0);
  });

  test('dos facturas con el mismo número y transportista se marcan como duplicado', () {
    final resultado = auditarFacturas([
      factura(numero: 'F-4', transportista: 'Transportes ABC', tarifaAplicadaCent: 50000, tarifaContratadaCent: 50000),
      factura(numero: 'F-4', transportista: 'Transportes ABC', tarifaAplicadaCent: 50000, tarifaContratadaCent: 50000),
    ]);

    expect(resultado[0].discrepanciaTipo, 'duplicado');
    expect(resultado[1].discrepanciaTipo, 'duplicado');
    expect(resultado[0].montoRecuperableCent, 50000);
  });

  test('mismo número con transportista distinto no es duplicado', () {
    final resultado = auditarFacturas([
      factura(numero: 'F-5', transportista: 'Transportes ABC', tarifaAplicadaCent: 50000, tarifaContratadaCent: 50000),
      factura(numero: 'F-5', transportista: 'Transportes XYZ', tarifaAplicadaCent: 50000, tarifaContratadaCent: 50000),
    ]);

    expect(resultado[0].discrepanciaTipo, isNull);
    expect(resultado[1].discrepanciaTipo, isNull);
  });

  test('duplicado tiene prioridad sobre la comparación de tarifa', () {
    final resultado = auditarFacturas([
      factura(numero: 'F-6', transportista: 'Transportes ABC', tarifaAplicadaCent: 70000, tarifaContratadaCent: 50000),
      factura(numero: 'F-6', transportista: 'Transportes ABC', tarifaAplicadaCent: 70000, tarifaContratadaCent: 50000),
    ]);

    expect(resultado[0].discrepanciaTipo, 'duplicado');
    expect(resultado[1].discrepanciaTipo, 'duplicado');
  });

  test('etiquetasTipoDiscrepancia cubre los seis tipos declarados por el esquema', () {
    expect(etiquetasTipoDiscrepancia.keys.toSet(), {
      'tarifa',
      'peso',
      'ruta',
      'descripcion',
      'duplicado',
      'cargo_accesorio',
    });
  });
}
