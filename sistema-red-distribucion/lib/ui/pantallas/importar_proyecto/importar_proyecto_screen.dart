import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/plataforma/abrir_carpeta.dart';

/// Lista los `.json` de la carpeta donde `ExportacionScreen` deja los
/// proyectos exportados (`directorioExportacion()` — la misma carpeta que
/// usan las demás exportaciones, así los archivos que llegan de otra
/// máquina también se ven si se copian ahí). Sin selector de archivos
/// nativo (`file_picker`) — copiar el archivo exportado de otra máquina a
/// esta misma carpeta (USB, red local) es una operación de usuario normal;
/// mismo criterio que `sistema-diseno-almacenes`.
class ImportarProyectoScreen extends StatefulWidget {
  const ImportarProyectoScreen({super.key});

  @override
  State<ImportarProyectoScreen> createState() => _ImportarProyectoScreenState();
}

class _ImportarProyectoScreenState extends State<ImportarProyectoScreen> {
  bool _cargando = true;
  List<File> _archivos = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _listarArchivos();
  }

  Future<void> _listarArchivos() async {
    try {
      final directorio = await directorioExportacion();
      final archivos = directorio
          .listSync()
          .whereType<File>()
          .where((f) => f.path.toLowerCase().endsWith('.json'))
          .toList()
        ..sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
      setState(() {
        _archivos = archivos;
        _cargando = false;
      });
    } catch (e) {
      setState(() {
        _error = 'No se pudo leer la carpeta de documentos: $e';
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Importar proyecto')),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? _bannerError(context, _error!)
          : _archivos.isEmpty
          ? _sinArchivos(context)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _archivos.length,
              itemBuilder: (context, i) {
                final archivo = _archivos[i];
                final nombre = archivo.path.split(Platform.pathSeparator).last;
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.description_outlined),
                    title: Text(nombre),
                    subtitle: Text(archivo.statSync().modified.toString()),
                    onTap: () => Navigator.of(context).pop(archivo),
                  ),
                );
              },
            ),
    );
  }

  Widget _sinArchivos(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.folder_open_outlined, size: 40, color: Colors.grey.shade500),
            const SizedBox(height: 12),
            const Text(
              'No hay archivos .json en la carpeta de Documentos de la app. '
              'Exportá un proyecto primero, o copiá uno de otra máquina a esa '
              'misma carpeta.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _bannerError(BuildContext context, String mensaje) {
    final colores = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: colores.errorContainer, borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, color: colores.onErrorContainer, size: 20),
              const SizedBox(width: 8),
              Flexible(child: Text(mensaje, style: TextStyle(color: colores.onErrorContainer))),
            ],
          ),
        ),
      ),
    );
  }
}
