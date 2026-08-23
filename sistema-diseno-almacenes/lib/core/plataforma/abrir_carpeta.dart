import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';

/// Abre la ubicación de `rutaArchivo` en el gestor de archivos del sistema
/// operativo -- nunca el archivo en sí, solo su carpeta contenedora, con el
/// archivo preseleccionado cuando el sistema operativo lo permite.
///
/// Windows y Linux sí dejan el archivo preseleccionado (Explorer con
/// `/select,`, o el gestor de archivos de escritorio vía D-Bus). Android no
/// tiene un equivalente real a "selecciona este archivo en el explorador":
/// su modelo de almacenamiento no expone "la carpeta" como concepto de
/// primera clase entre apps, así que ahí el mejor resultado alcanzable es
/// pedirle al sistema que abra ese archivo con la app que corresponda
/// (que en la práctica suele incluir un gestor de archivos entre las
/// opciones) -- no una limitación de esta función, sino del sistema
/// operativo.
///
/// Devuelve `true` si se pudo lanzar algo; `false` si ningún método
/// disponible funcionó (para que el llamador pueda avisar con un mensaje,
/// en vez de fallar en silencio).
/// El `SnackBar` que muestran las tres pantallas de exportación (DXF, PDF,
/// proyecto portable) tras guardar el archivo: mismo mensaje + botón "Ir a
/// la carpeta" en todas, para no repetir la construcción tres veces.
SnackBar snackBarArchivoExportado({required String mensaje, required String rutaArchivo}) {
  return SnackBar(
    content: Text(mensaje),
    duration: const Duration(seconds: 6),
    action: SnackBarAction(
      label: 'Ir a la carpeta',
      onPressed: () => abrirCarpetaConArchivoSeleccionado(rutaArchivo),
    ),
  );
}

Future<bool> abrirCarpetaConArchivoSeleccionado(String rutaArchivo) async {
  if (Platform.isWindows) {
    return _abrirEnWindows(rutaArchivo);
  }
  if (Platform.isLinux) {
    return _abrirEnLinux(rutaArchivo);
  }
  if (Platform.isAndroid) {
    return _abrirEnAndroid(rutaArchivo);
  }
  return false;
}

Future<bool> _abrirEnWindows(String rutaArchivo) async {
  try {
    // El path de Windows ya viene con backslashes (dart:io los usa nativo
    // en esa plataforma) -- explorer.exe entiende `/select,<ruta>` sin
    // espacio después de la coma.
    await Process.run('explorer.exe', ['/select,$rutaArchivo']);
    // explorer.exe casi siempre devuelve un código de salida distinto de
    // cero incluso cuando sí abrió la ventana (comportamiento documentado,
    // no un error real) -- por eso no se revisa `exitCode` aquí.
    return true;
  } catch (_) {
    return false;
  }
}

Future<bool> _abrirEnLinux(String rutaArchivo) async {
  final uriArchivo = Uri.file(rutaArchivo).toString();
  try {
    // La mayoría de gestores de archivos de escritorio (Nautilus, Dolphin,
    // Nemo, PCManFM...) implementan esta interfaz D-Bus estándar, que sí
    // deja el archivo preseleccionado -- a diferencia de abrir la carpeta
    // a secas, que no distingue cuál archivo era el nuevo.
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
    // dbus-send puede no estar instalado, o no haber ningún gestor de
    // archivos escuchando ese bus (entornos minimalistas) -- se cae al
    // respaldo de abajo en cualquiera de los dos casos.
  }
  try {
    // Respaldo: abre la carpeta contenedora sin preseleccionar el archivo.
    await Process.run('xdg-open', [File(rutaArchivo).parent.path]);
    return true;
  } catch (_) {
    return false;
  }
}

Future<bool> _abrirEnAndroid(String rutaArchivo) async {
  try {
    final autoridad = 'com.logisticapps.sistema_diseno_almacenes.fileprovider';
    final nombreArchivo = rutaArchivo.split('/').last;
    final uriContenido = 'content://$autoridad/documentos/$nombreArchivo';
    final intent = AndroidIntent(
      action: 'action_view',
      data: uriContenido,
      flags: [Flag.FLAG_GRANT_READ_URI_PERMISSION, Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    await intent.launch();
    return true;
  } catch (_) {
    return false;
  }
}
