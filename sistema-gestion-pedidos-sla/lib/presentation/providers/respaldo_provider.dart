import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../../data/local/respaldo_service.dart';

enum EstadoRespaldo { inactivo, exportando, importando, listo, error }

/// Orquesta exportar/importar el respaldo local (M7) con `file_picker`.
class RespaldoProvider extends ChangeNotifier {
  RespaldoProvider(this._service);

  final RespaldoService _service;

  EstadoRespaldo estado = EstadoRespaldo.inactivo;
  String? mensaje;

  Future<void> exportar() async {
    estado = EstadoRespaldo.exportando;
    mensaje = null;
    notifyListeners();

    try {
      final json = await _service.exportarComoJson();
      final nombreArchivo =
          'respaldo_${DateTime.now().toIso8601String().split('T').first}.json';

      final ruta = await FilePicker.platform.saveFile(
        dialogTitle: 'Guardar respaldo',
        fileName: nombreArchivo,
        type: FileType.custom,
        allowedExtensions: ['json'],
        bytes: Uint8List.fromList(utf8.encode(json)),
      );
      if (ruta == null) {
        estado = EstadoRespaldo.inactivo;
        notifyListeners();
        return;
      }

      // En desktop, `saveFile` solo devuelve la ruta elegida (no escribe el
      // archivo); en mobile ya lo escribe porque se pasó `bytes`. Escribir
      // siempre acá cubre ambos casos sin lógica separada por plataforma.
      await File(ruta).writeAsString(json);

      estado = EstadoRespaldo.listo;
      mensaje = 'Respaldo guardado en $ruta';
      notifyListeners();
    } catch (e) {
      _fallarCon('No se pudo exportar el respaldo: $e');
    }
  }

  Future<void> importar() async {
    estado = EstadoRespaldo.importando;
    mensaje = null;
    notifyListeners();

    try {
      final resultado = await FilePicker.platform.pickFiles(
        dialogTitle: 'Elegir respaldo',
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      final ruta = resultado?.files.single.path;
      if (ruta == null) {
        estado = EstadoRespaldo.inactivo;
        notifyListeners();
        return;
      }

      final contenido = await File(ruta).readAsString();
      await _service.importarDesdeJson(contenido);

      estado = EstadoRespaldo.listo;
      mensaje = 'Datos restaurados correctamente.';
      notifyListeners();
    } on RespaldoInvalido catch (e) {
      _fallarCon(e.toString());
    } catch (e) {
      _fallarCon('No se pudo importar el respaldo: $e');
    }
  }

  void _fallarCon(String mensajeError) {
    estado = EstadoRespaldo.error;
    mensaje = mensajeError;
    notifyListeners();
  }
}
