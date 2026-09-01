import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../data/local/database.dart';
import '../../../domain/export/organizacion_portable.dart';

/// Importa una organización desde el contenido de un archivo JSON ya
/// exportado (Pantalla 22). Sin selector de archivos: se pega el
/// contenido del archivo en el campo de texto -- evita agregar una
/// dependencia nueva solo para esto, y en Windows/Linux es tan simple
/// como abrir el archivo exportado y copiarlo.
class ImportarOrganizacionScreen extends StatefulWidget {
  const ImportarOrganizacionScreen({super.key});

  @override
  State<ImportarOrganizacionScreen> createState() => _ImportarOrganizacionScreenState();
}

class _ImportarOrganizacionScreenState extends State<ImportarOrganizacionScreen> {
  final _controlador = TextEditingController();
  bool _importando = false;
  String? _error;

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  Future<void> _importar() async {
    setState(() {
      _importando = true;
      _error = null;
    });

    try {
      final portable = OrganizacionPortable.fromJsonString(_controlador.text.trim());
      final database = context.read<AppDatabase>();
      await importarOrganizacion(portable, database);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on FormatException catch (e) {
      setState(() {
        _importando = false;
        _error = e.message;
      });
    } catch (_) {
      setState(() {
        _importando = false;
        _error = 'El texto pegado no tiene el formato de un archivo exportado por este sistema.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Importar organización')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Abre el archivo JSON que exportaste desde este sistema, copia todo su '
              'contenido y pégalo acá.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _controlador,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                decoration: const InputDecoration(
                  alignLabelWithHint: true,
                  hintText: '{"version": 1, "organizacion": {...}, ...}',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ],
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: _importando ? null : _importar,
                icon: _importando
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(LucideIcons.fileUp),
                label: const Text('Importar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
