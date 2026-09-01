import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Una tabla dentro del PDF de informe -- una sección por informe
/// (costo y servicio, productividad, presupuesto...), CLAUDE.md sección 6:
/// "se copia y se adapta a los tres informes" el patrón de
/// `pdf_builder.dart` de la Unidad 4.
class SeccionInformePdf {
  const SeccionInformePdf({required this.titulo, required this.encabezados, required this.filas});

  final String titulo;
  final List<String> encabezados;
  final List<List<String>> filas;
}

/// Construye el PDF de un informe: función pura, `pw.MultiPage` A4, un
/// resumen (pares concepto→valor) más una o más tablas por sección.
/// `fuenteRegular`/`fuenteNegrita` deben venir de DejaVu Sans, recibidas
/// como parámetro (no cargadas acá con `rootBundle`) para poder testear
/// con `dart:io` puro -- mismo patrón que `sistema-red-distribucion`.
///
/// `titulo` se escribe también como metadato `/Title` del PDF (no solo
/// como texto de la primera página), para que el nombre de la
/// organización y el periodo queden verificables por búsqueda de bytes
/// sin depender de extraer texto de un stream con glifos embebidos
/// (Fase 5, "Test de PDF").
Future<Uint8List> generarInformePdf({
  required String titulo,
  required List<MapEntry<String, String>> resumen,
  required List<SeccionInformePdf> secciones,
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
        if (resumen.isNotEmpty) ...[
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
        ],
        for (final seccion in secciones) ...[
          pw.Text(seccion.titulo, style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 6),
          pw.TableHelper.fromTextArray(
            headers: seccion.encabezados,
            data: seccion.filas,
            cellStyle: const pw.TextStyle(fontSize: 9),
            headerStyle: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
            cellAlignment: pw.Alignment.centerLeft,
          ),
          pw.SizedBox(height: 20),
        ],
      ],
    ),
  );

  return doc.save();
}
