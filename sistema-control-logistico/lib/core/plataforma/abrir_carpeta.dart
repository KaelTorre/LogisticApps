import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Carpeta donde deben guardarse los archivos exportados (PDF, CSV, JSON).
/// En Windows y Linux es la carpeta de documentos de la app. En Android es
/// el almacenamiento externo específico de la app
/// (`/storage/emulated/0/Android/data/<paquete>/files`); en la práctica da
/// igual para "Abrir archivo"/"Compartir" (ver más abajo, ambos pasan por
/// un content:// URI de todos modos).
Future<Directory> directorioExportacion() async {
  if (Platform.isAndroid) {
    final directorio = await getExternalStorageDirectory();
    if (directorio != null) return directorio;
  }
  return getApplicationDocumentsDirectory();
}

/// Abre la ubicación de `rutaArchivo` en el gestor de archivos del sistema
/// operativo -- nunca el archivo en sí, solo su carpeta contenedora, con el
/// archivo preseleccionado. Solo tiene sentido en Windows y Linux (Explorer
/// con `/select,`, o el gestor de archivos de escritorio vía D-Bus): ambos
/// exponen "la carpeta" como concepto de primera clase entre apps. Android
/// no -- ahí se usan en su lugar los botones "Abrir archivo" y "Compartir"
/// (ver `snackBarArchivoExportado` más abajo).
///
/// Devuelve `true` si se pudo lanzar algo; `false` si ningún método
/// disponible funcionó (para que el llamador pueda avisar con un mensaje,
/// en vez de fallar en silencio).
Future<bool> abrirCarpetaConArchivoSeleccionado(String rutaArchivo) async {
  if (Platform.isWindows) {
    return _abrirEnWindows(rutaArchivo);
  }
  if (Platform.isLinux) {
    return _abrirEnLinux(rutaArchivo);
  }
  return false;
}

/// El `SnackBar` que muestran las pantallas de exportación tras guardar el
/// archivo, para no repetir la construcción cada vez. En Windows/Linux es
/// mensaje + botón "Ir a la carpeta". En Android, donde no existe un
/// equivalente real a "carpeta navegable entre apps", son dos acciones en
/// su lugar: un botón de ícono "Abrir archivo" (`ACTION_VIEW`) y el botón
/// de acción "Compartir", que invoca el share sheet nativo del sistema.
SnackBar snackBarArchivoExportado({required String mensaje, required String rutaArchivo}) {
  if (Platform.isAndroid) {
    return SnackBar(
      content: Row(
        children: [
          Expanded(
            child: Text(mensaje, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          IconButton(
            icon: const Icon(Icons.open_in_new, color: Colors.white),
            tooltip: 'Abrir archivo',
            onPressed: () => _abrirArchivoEnAndroid(rutaArchivo),
          ),
        ],
      ),
      duration: const Duration(seconds: 6),
      action: SnackBarAction(
        label: 'Compartir',
        onPressed: () => _compartirArchivoEnAndroid(rutaArchivo),
      ),
    );
  }
  return SnackBar(
    content: Text(mensaje),
    duration: const Duration(seconds: 6),
    action: SnackBarAction(
      label: 'Ir a la carpeta',
      onPressed: () => abrirCarpetaConArchivoSeleccionado(rutaArchivo),
    ),
  );
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

/// Abre el archivo con la app que corresponda (`ACTION_VIEW` sobre el
/// content:// URI que expone el `FileProvider` propio de la app -- Android
/// exige eso para compartir un archivo con otra app desde Android 7 en
/// adelante, un `file://` URI directo lanza `FileUriExposedException`).
Future<void> _abrirArchivoEnAndroid(String rutaArchivo) async {
  final autoridad = 'com.logisticapps.sistema_control_logistico.fileprovider';
  final nombreArchivo = rutaArchivo.split('/').last;
  final uriContenido = 'content://$autoridad/documentos/$nombreArchivo';
  final intent = AndroidIntent(
    action: 'action_view',
    data: uriContenido,
    flags: [Flag.FLAG_GRANT_READ_URI_PERMISSION, Flag.FLAG_ACTIVITY_NEW_TASK],
  );
  await intent.launch();
}

/// Invoca el share sheet nativo de Android (`ACTION_SEND`) vía `share_plus`
/// -- a diferencia de `_abrirArchivoEnAndroid`, acá conviene un paquete en
/// vez de un `AndroidIntent` a mano porque `ACTION_SEND` necesita un extra
/// `EXTRA_STREAM` de tipo `Uri`/Parcelable, que el mapa de argumentos de
/// `android_intent_plus` no soporta. `share_plus` ya copia el archivo a su
/// propio `FileProvider` internamente, así que no depende de la carpeta
/// donde se haya guardado el export.
Future<void> _compartirArchivoEnAndroid(String rutaArchivo) async {
  await SharePlus.instance.share(ShareParams(files: [XFile(rutaArchivo)]));
}
