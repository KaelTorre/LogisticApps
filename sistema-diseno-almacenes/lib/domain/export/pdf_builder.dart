import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../motor/fila_memoria.dart';

/// Ficha técnica en PDF (CLAUDE.md sección 9): resumen + **memoria de
/// cálculo completa**, con fórmula, entradas y fuente por cada línea — "es
/// el entregable que sostiene la decisión", no un resumen recortado.
///
/// `resumen` es una lista de pares concepto→valor, en el orden en que deben
/// imprimirse (la pantalla `FichaResultadoScreen` ya construye ese mismo
/// orden; este builder solo lo traduce a PDF, no decide qué mostrar).
/// `fuenteRegular`/`fuenteNegrita` deben venir de DejaVu Sans (ver
/// `assets/CREDITS.md`) — la Helvetica base del paquete `pdf` no tiene
/// glifos para las letras griegas y símbolos matemáticos que usan las
/// fórmulas de la memoria de cálculo (Σ, ρ, λ, μ, ×, ≤, −). Se reciben como
/// parámetro en vez de cargarse aquí adentro porque cargar assets requiere
/// `rootBundle` (Flutter), y esta función se mantiene independiente de eso
/// para poder probarla con `dart:io` directo en los tests.
Future<Uint8List> generarFichaPdf({
  required String titulo,
  required List<MapEntry<String, String>> resumen,
  required List<FilaMemoria> memoria,
  required pw.Font fuenteRegular,
  required pw.Font fuenteNegrita,
}) async {
  final doc = pw.Document(
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
          headers: const ['Módulo', 'Concepto', 'Fórmula', 'Entradas', 'Valor', 'Unidad', 'Fuente'],
          data: [
            for (final f in memoria)
              [
                f.modulo,
                f.concepto,
                f.formula,
                f.entradas.entries.map((e) => '${e.key}=${e.value}').join(', '),
                f.valor,
                f.unidad,
                f.fuente ?? '—',
              ],
          ],
          cellStyle: const pw.TextStyle(fontSize: 8),
          headerStyle: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
          cellAlignment: pw.Alignment.topLeft,
          columnWidths: {
            0: const pw.FlexColumnWidth(0.7),
            1: const pw.FlexColumnWidth(1.6),
            2: const pw.FlexColumnWidth(2.2),
            3: const pw.FlexColumnWidth(2.2),
            4: const pw.FlexColumnWidth(1.2),
            5: const pw.FlexColumnWidth(0.9),
            6: const pw.FlexColumnWidth(1.4),
          },
        ),
      ],
    ),
  );

  return doc.save();
}
