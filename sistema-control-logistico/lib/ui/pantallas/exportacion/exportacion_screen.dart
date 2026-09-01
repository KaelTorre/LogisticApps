import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/plataforma/abrir_carpeta.dart';
import '../../../data/local/database.dart';
import '../../../data/models/organizacion.dart';
import '../../../domain/export/organizacion_portable.dart';

/// Pantalla 22: exporta la organización completa (periodos, indicadores,
/// mediciones, evaluaciones, memoria de evaluación, acciones tomadas y su
/// verificación, presupuesto, escenarios sintéticos, diagnóstico
/// organizacional y facturas auditadas) a un único archivo JSON -- sirve
/// como respaldo y para llevar la organización a otra instalación.
///
/// Solo exporta: este sistema trabaja con una sola organización por
/// instalación, así que no hay una pantalla para elegir cuál importar
/// sobre otra ya activa. Importar un archivo exportado desde acá se hace
/// al arrancar sin ninguna organización todavía, junto a "Crear
/// organización" y "Cargar caso de estudio".
class ExportacionScreen extends StatefulWidget {
  const ExportacionScreen({super.key, required this.organizacion});

  final Organizacion organizacion;

  @override
  State<ExportacionScreen> createState() => _ExportacionScreenState();
}

class _ExportacionScreenState extends State<ExportacionScreen> {
  bool _exportando = false;

  Future<void> _exportar() async {
    setState(() => _exportando = true);

    final database = context.read<AppDatabase>();
    final portable = await exportarOrganizacion(database, widget.organizacion.id!);
    final texto = portable.toJsonString();

    final directorio = await directorioExportacion();
    final nombreBase = widget.organizacion.nombre.replaceAll(RegExp('[^A-Za-z0-9]+'), '_');
    final nombreArchivo = 'organizacion_$nombreBase.json';
    final archivo = File('${directorio.path}${Platform.pathSeparator}$nombreArchivo');
    await archivo.writeAsString(texto);

    if (!mounted) return;
    setState(() => _exportando = false);
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        snackBarArchivoExportado(mensaje: 'Organización exportada: $nombreArchivo', rutaArchivo: archivo.path),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exportación')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  Row(
                    children: [
                      Icon(LucideIcons.fileJson, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text('Exportar organización completa', style: Theme.of(context).textTheme.titleMedium),
                      ),
                    ],
                  ),
                  Text(
                    'Genera un archivo con toda la información de '
                    '"${widget.organizacion.nombre}": periodos, indicadores, '
                    'mediciones, evaluaciones, acciones registradas y su '
                    'verificación, presupuesto, diagnóstico organizacional y '
                    'facturas auditadas. Sirve como respaldo o para llevar '
                    'esta organización a otra instalación del sistema.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.icon(
                      onPressed: _exportando ? null : _exportar,
                      icon: _exportando
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(LucideIcons.download),
                      label: const Text('Exportar como JSON'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Para importar un archivo exportado desde acá, elimina esta '
              'organización (ícono de la papelera en la pantalla inicial) y '
              'elige "Importar una organización ya exportada" -- este '
              'sistema trabaja con una sola organización por instalación.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
