import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sistema_control_logistico/domain/export/pdf_builder_informes.dart';

/// Fase 5 (CLAUDE.md): "Test de PDF: el archivo se genera y contiene el
/// nombre de la organización y el periodo."
void main() {
  late final pw.Font fuenteRegular;
  late final pw.Font fuenteNegrita;

  setUpAll(() {
    fuenteRegular = pw.Font.ttf(File('assets/fonts/DejaVuSans.ttf').readAsBytesSync().buffer.asByteData());
    fuenteNegrita = pw.Font.ttf(
      File('assets/fonts/DejaVuSans-Bold.ttf').readAsBytesSync().buffer.asByteData(),
    );
  });

  const seccion = SeccionInformePdf(
    titulo: 'Costo por proceso',
    encabezados: ['Proceso', 'Monto'],
    filas: [
      ['Transporte', '1200.00'],
      ['Almacenamiento', '800.00'],
    ],
  );

  test('produce bytes con la cabecera %PDF', () async {
    final bytes = await generarInformePdf(
      titulo: 'Informe de prueba',
      resumen: const [MapEntry('Costo total', 'S/ 2000.00')],
      secciones: const [seccion],
      fuenteRegular: fuenteRegular,
      fuenteNegrita: fuenteNegrita,
    );
    expect(bytes, isNotEmpty);
    expect(String.fromCharCodes(bytes.take(4)), '%PDF');
  });

  test('no revienta con resumen y secciones vacías', () async {
    final bytes = await generarInformePdf(
      titulo: 'Informe vacío',
      resumen: const [],
      secciones: const [],
      fuenteRegular: fuenteRegular,
      fuenteNegrita: fuenteNegrita,
    );
    expect(bytes, isNotEmpty);
  });

  test('contiene el nombre de la organización y el periodo (metadato /Title)', () async {
    final bytes = await generarInformePdf(
      // Sin em-dash ni otro carácter fuera de Latin-1 -- ver la nota en
      // pdf_builder_red_test.dart del proyecto hermano: /Title se codifica
      // en Latin-1 cuando puede, y con compress:false queda buscable como
      // subcadena ASCII directa.
      titulo: 'Informe de costo y servicio - Distribuidora Andina S.A.C. - Periodo 7',
      resumen: const [],
      secciones: const [seccion],
      fuenteRegular: fuenteRegular,
      fuenteNegrita: fuenteNegrita,
      compress: false,
    );
    final contenido = String.fromCharCodes(bytes);
    expect(contenido, contains('Distribuidora Andina'));
    expect(contenido, contains('Periodo 7'));
  });

  test('con más secciones, el PDF trae más de un objeto /Type /Page', () async {
    final seccionesLargas = List.generate(
      30,
      (i) => SeccionInformePdf(
        titulo: 'Sección $i',
        encabezados: const ['A', 'B'],
        filas: List.generate(20, (j) => ['fila $j', 'valor $j']),
      ),
    );
    final bytes = await generarInformePdf(
      titulo: 'Informe largo',
      resumen: const [],
      secciones: seccionesLargas,
      fuenteRegular: fuenteRegular,
      fuenteNegrita: fuenteNegrita,
      compress: false,
    );
    final contenido = String.fromCharCodes(bytes);
    final ocurrencias = RegExp(r'/Type\s*/Page[^s]').allMatches(contenido).length;
    expect(ocurrencias, greaterThan(1));
  });
}
