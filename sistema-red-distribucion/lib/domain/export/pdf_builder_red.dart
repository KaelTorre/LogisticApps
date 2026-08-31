import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../motor/fila_memoria.dart';
import 'legibilidad_memoria.dart';

/// Ficha técnica en PDF (CLAUDE.md Fase 9): mismo patrón que
/// `pdf_builder.dart` de la Unidad 4 — función pura, `pw.MultiPage` A4,
/// resumen (pares concepto→valor en el orden en que la pantalla los arma) +
/// memoria de cálculo completa. `fuenteRegular`/`fuenteNegrita` deben venir
/// de DejaVu Sans, recibidas como parámetro (no cargadas acá con
/// `rootBundle`) para poder testear con `dart:io` puro.
///
/// **Diferencia real con el hermano:** la tabla `memoria_calculo` de este
/// proyecto no tiene `concepto` ni `fuente` (5 campos, no 7 — ver
/// `fila_memoria.dart`), así que la tabla de memoria usa las 5 columnas
/// reales en vez de calcar las 7 del hermano.
///
/// `titulo` se escribe también como metadato `/Title` del PDF (no solo
/// como texto de la primera página) para que el nombre del proyecto quede
/// verificable sin depender de extraer texto de un stream de contenido con
/// glifos embebidos (Test Y).
Future<Uint8List> generarFichaPdfRed({
  required String titulo,
  required List<MapEntry<String, String>> resumen,
  required List<FilaMemoria> memoria,
  required pw.Font fuenteRegular,
  required pw.Font fuenteNegrita,
  bool compress = true,
}) async {
  final doc = pw.Document(
    title: titulo,
    compress: compress,
    theme: pw.ThemeData.withFont(base: fuenteRegular, bold: fuenteNegrita),
  );

  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(28),
      header: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(titulo, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.Divider(),
        ],
      ),
      footer: (context) => pw.Align(
        alignment: pw.Alignment.centerRight,
        child: pw.Text(
          'Página ${context.pageNumber} de ${context.pagesCount}',
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
        ),
      ),
      build: (context) => [
        pw.Text('Resumen', style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 6),
        pw.TableHelper.fromTextArray(
          headers: const ['Concepto', 'Valor'],
          data: [for (final e in resumen) [e.key, e.value]],
          cellStyle: const pw.TextStyle(fontSize: 10),
          headerStyle: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          cellAlignment: pw.Alignment.centerLeft,
          columnWidths: {0: const pw.FlexColumnWidth(2), 1: const pw.FlexColumnWidth(1)},
        ),
        pw.SizedBox(height: 20),
        pw.Text(
          'Memoria de cálculo (${memoria.length} pasos)',
          style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 6),
        pw.TableHelper.fromTextArray(
          headers: const ['Módulo', 'Fórmula', 'Entradas', 'Salida', 'Unidad'],
          data: [
            for (final f in memoria)
              [
                moduloLegible(f.modulo),
                f.formula,
                entradasLegibles(f.entradasJson),
                salidaLegible(f.salida, f.unidad),
                unidadLegible(f.unidad),
              ],
          ],
          cellStyle: const pw.TextStyle(fontSize: 8),
          headerStyle: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
          cellAlignment: pw.Alignment.topLeft,
          columnWidths: {
            0: const pw.FlexColumnWidth(1.6),
            1: const pw.FlexColumnWidth(2.4),
            2: const pw.FlexColumnWidth(2.2),
            3: const pw.FlexColumnWidth(1.2),
            4: const pw.FlexColumnWidth(0.8),
          },
        ),
      ],
    ),
  );

  return doc.save();
}
