import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sistema_diseno_almacenes/domain/export/pdf_builder.dart';
import 'package:sistema_diseno_almacenes/domain/motor/fila_memoria.dart';

void main() {
  // Cargadas directo del archivo (no vía rootBundle: estos son tests de
  // Dart puro, no de widgets) — las mismas DejaVu Sans que usa la app real,
  // para que un regreso a Helvetica (sin soporte Unicode) lo atrape un test
  // y no solo la advertencia en consola al exportar de verdad.
  late final pw.Font fuenteRegular;
  late final pw.Font fuenteNegrita;

  setUpAll(() {
    fuenteRegular = pw.Font.ttf(File('assets/fonts/DejaVuSans.ttf').readAsBytesSync().buffer.asByteData());
    fuenteNegrita = pw.Font.ttf(
      File('assets/fonts/DejaVuSans-Bold.ttf').readAsBytesSync().buffer.asByteData(),
    );
  });

  const filaCompleta = FilaMemoria(
    orden: 1,
    modulo: 'M3',
    concepto: 'Tarimas por nivel',
    formula: 'n = floor((claro_util + holgura_x) / (ancho_tarima + holgura_x))',
    entradas: {'largo_viga_mm': 1825, 'holgura_x_mm': 75, 'ancho_tarima_mm': 800},
    valor: '2',
    unidad: 'tarimas/nivel',
    fuente: 'EN 15620',
  );

  const filaSinFuente = FilaMemoria(
    orden: 2,
    modulo: 'M2',
    concepto: 'Posiciones requeridas',
    formula: 'posiciones = ceil(tarimas / (1 - honeycomb))',
    entradas: {},
    valor: '32',
    unidad: 'posiciones',
  );

  group('generarFichaPdf', () {
    test('produce bytes con la cabecera %PDF', () async {
      final bytes = await generarFichaPdf(
        titulo: 'Ficha técnica — caso de prueba',
        resumen: const [MapEntry('Posiciones requeridas', '32')],
        memoria: const [filaCompleta, filaSinFuente],
        fuenteRegular: fuenteRegular,
        fuenteNegrita: fuenteNegrita,
      );
      expect(bytes, isNotEmpty);
      expect(String.fromCharCodes(bytes.take(4)), '%PDF');
    });

    test('no revienta con memoria vacía', () async {
      final bytes = await generarFichaPdf(
        titulo: 'Ficha vacía',
        resumen: const [],
        memoria: const [],
        fuenteRegular: fuenteRegular,
        fuenteNegrita: fuenteNegrita,
      );
      expect(bytes, isNotEmpty);
    });

    test('no revienta con una fila sin fuente (fuente NULL es válido)', () async {
      final bytes = await generarFichaPdf(
        titulo: 'Ficha',
        resumen: const [],
        memoria: const [filaSinFuente],
        fuenteRegular: fuenteRegular,
        fuenteNegrita: fuenteNegrita,
      );
      expect(bytes, isNotEmpty);
    });

    test('con más filas de memoria produce más contenido (proxy de que sí las incluye)', () async {
      final pocasFilas = await generarFichaPdf(
        titulo: 'Ficha',
        resumen: const [],
        memoria: const [filaCompleta],
        fuenteRegular: fuenteRegular,
        fuenteNegrita: fuenteNegrita,
      );
      final muchasFilas = await generarFichaPdf(
        titulo: 'Ficha',
        resumen: const [],
        memoria: List.generate(
          80,
          (i) => FilaMemoria(
            orden: i,
            modulo: 'M3',
            concepto: 'Concepto $i',
            formula: 'formula($i)',
            entradas: {'x': i},
            valor: '$i',
            unidad: 'mm',
          ),
        ),
        fuenteRegular: fuenteRegular,
        fuenteNegrita: fuenteNegrita,
      );
      expect(muchasFilas.length, greaterThan(pocasFilas.length));
    });

    test('no revienta con texto largo en fórmula/entradas (celda que debe partirse en varias líneas)', () async {
      final formulaLarga = 'x' * 500;
      final bytes = await generarFichaPdf(
        titulo: 'Ficha',
        resumen: const [],
        memoria: [
          FilaMemoria(
            orden: 1,
            modulo: 'M3',
            concepto: 'Concepto',
            formula: formulaLarga,
            entradas: const {'a': 1, 'b': 2, 'c': 3, 'd': 4, 'e': 5},
            valor: '1',
            unidad: 'mm',
          ),
        ],
        fuenteRegular: fuenteRegular,
        fuenteNegrita: fuenteNegrita,
      );
      expect(bytes, isNotEmpty);
    });
  });
}
