import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Carpeta donde deben guardarse los archivos exportados (DXF, PDF,
/// proyecto). En Windows y Linux es la carpeta de documentos de la app. En
/// Android es el almacenamiento externo específico de la app
/// (`/storage/emulated/0/Android/data/<paquete>/files`) y NO el
/// almacenamiento interno privado (`getApplicationDocumentsDirectory()`,
/// bajo `/data/user/0/...`): ese último es invisible para cualquier
/// gestor de archivos, así que "Ir a la carpeta" no tiene nada que
/// mostrar. El externo específico de la app no requiere ningún permiso
/// adicional en ninguna versión de Android (es una carpeta propia de la
/// app, no almacenamiento compartido) y sí tiene un content:// URI de
/// carpeta que un gestor de archivos puede navegar -- ver
/// `_abrirCarpetaEnAndroid` más abajo.
Future<Directory> directorioExportacion() async {
  if (Platform.isAndroid) {
    final directorio = await getExternalStorageDirectory();
    if (directorio != null) return directorio;
  }
  return getApplicationDocumentsDirectory();
}

/// Abre la ubicación de `rutaArchivo` en el gestor de archivos del sistema
/// operativo -- nunca el archivo en sí, solo su carpeta contenedora, con el
/// archivo preseleccionado cuando el sistema operativo lo permite.
///
/// Windows y Linux sí dejan el archivo preseleccionado (Explorer con
/// `/select,`, o el gestor de archivos de escritorio vía D-Bus). Android no
/// tiene un equivalente real a "selecciona este archivo en el explorador":
/// su modelo de almacenamiento no expone "la carpeta" como concepto de
/// primera clase entre apps. Ahí el mejor resultado alcanzable es abrir el
/// gestor de archivos del sistema navegado a la carpeta contenedora (sin
/// seleccionar el archivo dentro, pero sin abrirlo tampoco); si ningún
/// gestor de archivos del dispositivo soporta eso, se cae al respaldo de
/// abrir el archivo con la app que corresponda -- no una limitación de
/// esta función, sino del sistema operativo.
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
  if (await _abrirCarpetaEnAndroid(rutaArchivo)) return true;
  return _abrirArchivoEnAndroid(rutaArchivo);
}

/// Intenta mostrar la carpeta contenedora en el gestor de archivos del
/// sistema (sin abrir el archivo) usando el content:// URI que expone el
/// proveedor de almacenamiento externo de Android para el volumen
/// primario. Solo es posible cuando el archivo vive en el almacenamiento
/// externo específico de la app (ver `directorioExportacion`); el
/// almacenamiento interno privado no tiene un URI de carpeta de este tipo.
Future<bool> _abrirCarpetaEnAndroid(String rutaArchivo) async {
  final carpeta = File(rutaArchivo).parent.path;
  final marcador = carpeta.indexOf('/Android/');
  if (marcador == -1) return false;
  final relativo = carpeta.substring(marcador + 1);
  final uriCarpeta =
      'content://com.android.externalstorage.documents/document/'
      '${Uri.encodeComponent('primary:$relativo')}';
  try {
    final intent = AndroidIntent(
      action: 'action_view',
      data: uriCarpeta,
      type: 'vnd.android.document/directory',
      flags: [Flag.FLAG_ACTIVITY_NEW_TASK, Flag.FLAG_GRANT_READ_URI_PERMISSION],
    );
    await intent.launch();
    return true;
  } catch (_) {
    return false;
  }
}

/// Respaldo si ningún gestor de archivos del dispositivo entiende el URI
/// de carpeta: abre el archivo con la app que corresponda. Es peor que
/// dejarlo seleccionado sin abrir, pero mejor que no hacer nada.
Future<bool> _abrirArchivoEnAndroid(String rutaArchivo) async {
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
