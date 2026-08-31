import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Carpeta donde deben guardarse los archivos exportados (PDF, CSV, JSON).
/// En Windows y Linux es la carpeta de documentos de la app. En Android es
/// el almacenamiento externo específico de la app — mismo patrón que
/// `sistema-diseno-almacenes/lib/core/plataforma/abrir_carpeta.dart`.
Future<Directory> directorioExportacion() async {
  if (Platform.isAndroid) {
    final directorio = await getExternalStorageDirectory();
    if (directorio != null) return directorio;
  }
  return getApplicationDocumentsDirectory();
}

/// Abre la ubicación de `rutaArchivo` en el gestor de archivos del sistema
/// operativo (Windows/Linux) — en Android no hay equivalente, ahí se usan
/// los botones "Abrir archivo"/"Compartir" de [snackBarArchivoExportado].
Future<bool> abrirCarpetaConArchivoSeleccionado(String rutaArchivo) async {
  if (Platform.isWindows) return _abrirEnWindows(rutaArchivo);
  if (Platform.isLinux) return _abrirEnLinux(rutaArchivo);
  return false;
}

/// El `SnackBar` que muestran las pantallas de exportación tras guardar un
/// archivo — mensaje + "Ir a la carpeta" en Windows/Linux; en Android,
/// "Abrir archivo" y "Compartir" (mismo patrón que el proyecto hermano).
SnackBar snackBarArchivoExportado({required String mensaje, required String rutaArchivo}) {
  if (Platform.isAndroid) {
    return SnackBar(
      content: Row(
        children: [
          Expanded(child: Text(mensaje, maxLines: 1, overflow: TextOverflow.ellipsis)),
          IconButton(
            icon: const Icon(Icons.open_in_new, color: Colors.white),
            tooltip: 'Abrir archivo',
            onPressed: () => _abrirArchivoEnAndroid(rutaArchivo),
          ),
        ],
      ),
      duration: const Duration(seconds: 6),
      action: SnackBarAction(label: 'Compartir', onPressed: () => _compartirArchivoEnAndroid(rutaArchivo)),
    );
  }
  return SnackBar(
    content: Text(mensaje),
    duration: const Duration(seconds: 6),
    action: SnackBarAction(label: 'Ir a la carpeta', onPressed: () => abrirCarpetaConArchivoSeleccionado(rutaArchivo)),
  );
}

Future<bool> _abrirEnWindows(String rutaArchivo) async {
  try {
    await Process.run('explorer.exe', ['/select,$rutaArchivo']);
    return true;
  } catch (_) {
    return false;
  }
}

Future<bool> _abrirEnLinux(String rutaArchivo) async {
  final uriArchivo = Uri.file(rutaArchivo).toString();
  try {
    final resultado = await Process.run('dbus-send', [
      '--session',
      '--dest=org.freedesktop.FileManager1',
      '--type=method_call',
      '/org/freedesktop/FileManager1',
      'org.freedesktop.FileManager1.ShowItems',
      'array:string:$uriArchivo',
      'string:',
    ]);
    if (resultado.exitCode == 0) return true;
  } catch (_) {
    // Sin dbus-send o sin gestor escuchando — se cae al respaldo de abajo.
  }
  try {
    await Process.run('xdg-open', [File(rutaArchivo).parent.path]);
    return true;
  } catch (_) {
    return false;
  }
}

Future<void> _abrirArchivoEnAndroid(String rutaArchivo) async {
  const autoridad = 'com.logisticapps.sistema_red_distribucion.fileprovider';
  final nombreArchivo = rutaArchivo.split('/').last;
  final uriContenido = 'content://$autoridad/documentos/$nombreArchivo';
  final intent = AndroidIntent(
    action: 'action_view',
    data: uriContenido,
    flags: [Flag.FLAG_GRANT_READ_URI_PERMISSION, Flag.FLAG_ACTIVITY_NEW_TASK],
  );
  await intent.launch();
}

Future<void> _compartirArchivoEnAndroid(String rutaArchivo) async {
  await SharePlus.instance.share(ShareParams(files: [XFile(rutaArchivo)]));
}
