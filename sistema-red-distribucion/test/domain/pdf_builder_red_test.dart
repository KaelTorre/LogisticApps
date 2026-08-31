import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sistema_red_distribucion/domain/export/pdf_builder_red.dart';
import 'package:sistema_red_distribucion/domain/motor/fila_memoria.dart';

/// Test Y (CLAUDE.md Fase 9): "el archivo se genera, tiene más de una
/// página y contiene el nombre del proyecto".
void main() {
  late final pw.Font fuenteRegular;
  late final pw.Font fuenteNegrita;

  setUpAll(() {
    fuenteRegular = pw.Font.ttf(File('assets/fonts/DejaVuSans.ttf').readAsBytesSync().buffer.asByteData());
    fuenteNegrita = pw.Font.ttf(File('assets/fonts/DejaVuSans-Bold.ttf').readAsBytesSync().buffer.asByteData());
  });

  const filaMemoria = FilaMemoria(
    modulo: 'M4',
    formula: 'c_fijo = suma(costo_fijo_anual)',
    entradasJson: '{"candidatos_abiertos": 2}',
    salida: '900000',
    unidad: 'centavos',
  );

  group('generarFichaPdfRed', () {
    test('produce bytes con la cabecera %PDF', () async {
      final bytes = await generarFichaPdfRed(
        titulo: 'Ficha técnica — Proyecto de prueba',
        resumen: const [MapEntry('Costo total', 'S/ 9000.00')],
        memoria: const [filaMemoria],
        fuenteRegular: fuenteRegular,
        fuenteNegrita: fuenteNegrita,
      );
      expect(bytes, isNotEmpty);
      expect(String.fromCharCodes(bytes.take(4)), '%PDF');
    });

    test('no revienta con memoria y resumen vacíos', () async {
      final bytes = await generarFichaPdfRed(
        titulo: 'Ficha vacía',
        resumen: const [],
        memoria: const [],
        fuenteRegular: fuenteRegular,
        fuenteNegrita: fuenteNegrita,
      );
      expect(bytes, isNotEmpty);
    });

    test('contiene el nombre del proyecto (metadato /Title del PDF)', () async {
      final bytes = await generarFichaPdfRed(
        // Sin em-dash ni otro carácter fuera de Latin-1: `PdfString` codifica
        // /Title como Latin-1 cuando puede, y solo cae a UTF-16BE con BOM (un
        // byte nulo intercalado entre cada carácter) si no puede — eso
        // rompería la búsqueda de subcadena ASCII de abajo sin aportar nada
        // al propósito del test.
        titulo: 'Ficha tecnica - Red PucallpaDemo',
        resumen: const [],
        memoria: const [filaMemoria],
        fuenteRegular: fuenteRegular,
        fuenteNegrita: fuenteNegrita,
        // Sin comprimir: con compress:true (el default real de la app) el
        // paquete `pdf` puede empaquetar el diccionario /Info dentro de un
        // object stream (ObjStm) comprimido junto con otros objetos, y la
        // cadena deja de ser un `String.fromCharCodes` directo sobre los
        // bytes. compress:false es solo para que este test pueda verificar
        // el título por búsqueda de bytes sin tener que inflar FlateDecode.
        compress: false,
      );
      // El título se escribe en el diccionario /Info como texto plano
      // (`(Ficha tecnica - Red PucallpaDemo)` o su forma escapada), no
      // dentro de un stream de contenido con glifos embebidos — por eso es
      // el único texto del documento que se puede verificar por búsqueda
      // directa de bytes sin descomprimir ni decodificar el font.
      final contenido = String.fromCharCodes(bytes);
      expect(contenido, contains('PucallpaDemo'));
    });

    test('con más de una página de memoria, el PDF trae más de un objeto /Type /Page', () async {
      final memoriaLarga = List.generate(
        120,
        (i) => FilaMemoria(
          modulo: 'M4',
          formula: 'formula($i)',
          entradasJson: '{"x": $i}',
          salida: '$i',
          unidad: 'centavos',
        ),
      );
      final bytes = await generarFichaPdfRed(
        titulo: 'Ficha con muchas filas',
        resumen: const [],
        memoria: memoriaLarga,
        fuenteRegular: fuenteRegular,
        fuenteNegrita: fuenteNegrita,
        compress: false,
      );
      final contenido = String.fromCharCodes(bytes);
      final ocurrencias = RegExp(r'/Type\s*/Page[^s]').allMatches(contenido).length;
      expect(ocurrencias, greaterThan(1));
    });

    test('con más filas de memoria produce más contenido (proxy de que sí las incluye)', () async {
      final pocasFilas = await generarFichaPdfRed(
        titulo: 'Ficha',
        resumen: const [],
        memoria: const [filaMemoria],
        fuenteRegular: fuenteRegular,
        fuenteNegrita: fuenteNegrita,
      );
      final muchasFilas = await generarFichaPdfRed(
        titulo: 'Ficha',
        resumen: const [],
        memoria: List.generate(
          80,
          (i) => FilaMemoria(modulo: 'M4', formula: 'f($i)', entradasJson: '{"x":$i}', salida: '$i', unidad: 'cent'),
        ),
        fuenteRegular: fuenteRegular,
        fuenteNegrita: fuenteNegrita,
      );
      expect(muchasFilas.length, greaterThan(pocasFilas.length));
    });
  });
}
