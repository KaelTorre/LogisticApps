import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/cliente.dart';
import '../../../data/repositories/cliente_repository.dart';
import '../../../domain/importacion/importador_csv_clientes.dart';

/// Importador de clientes por CSV (Pantalla 3 de CLAUDE.md). Pega el
/// contenido del archivo en vez de abrirlo con un selector nativo: el
/// proyecto no tiene `file_picker` como dependencia (sin justificación
/// clara todavía — ver CLAUDE.md sección 3, "Dependencias justificadas") y
/// copiar/pegar desde el Excel/Sheets de origen es una operación de usuario
/// normal, igual que `ImportarProyectoScreen` de la Unidad 4 evita un
/// selector nativo para su propio import.
class ImportarClientesCsvScreen extends StatefulWidget {
  const ImportarClientesCsvScreen({super.key, required this.proyectoId});

  final int proyectoId;

  @override
  State<ImportarClientesCsvScreen> createState() => _ImportarClientesCsvScreenState();
}

class _ImportarClientesCsvScreenState extends State<ImportarClientesCsvScreen> {
  final _contenidoCtrl = TextEditingController();
  ResultadoImportacionCsv? _resultado;
  bool _importando = false;

  @override
  void dispose() {
    _contenidoCtrl.dispose();
    super.dispose();
  }

  void _previsualizar() {
    setState(() => _resultado = parsearCsvClientes(_contenidoCtrl.text));
  }

  Future<void> _confirmarImportacion() async {
    final resultado = _resultado;
    if (resultado == null || resultado.filas.isEmpty) return;

    setState(() => _importando = true);
    final repositorio = context.read<ClienteRepository>();
    for (final fila in resultado.filas) {
      await repositorio.crear(
        Cliente(
          proyectoId: widget.proyectoId,
          nombre: fila.nombre,
          latitud: fila.latitud,
          longitud: fila.longitud,
          demandaAnual: fila.demandaAnual,
          pedidosAnuales: fila.pedidosAnuales,
        ),
      );
    }

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final resultado = _resultado;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Importar clientes por CSV')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Pegá el contenido del CSV (con o sin encabezado; separado '
                    'por coma, punto y coma o tabulador). Columnas: nombre, '
                    'latitud, longitud, demanda_anual, pedidos_anuales.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _contenidoCtrl,
                    maxLines: 10,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'nombre,latitud,longitud,demanda_anual,pedidos_anuales\n'
                          'Cliente A,-8.37,-74.55,120.5,52',
                    ),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: _previsualizar,
                    child: const Text('Previsualizar'),
                  ),
                  if (resultado != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      '${resultado.filas.length} fila(s) válida(s), '
                      '${resultado.errores.length} rechazada(s).',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    if (resultado.errores.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        constraints: const BoxConstraints(maxHeight: 140),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: resultado.errores
                                .map(
                                  (e) => Text(
                                    e,
                                    style: TextStyle(color: colorScheme.onErrorContainer),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: (resultado.filas.isEmpty || _importando)
                          ? null
                          : _confirmarImportacion,
                      child: Text(
                        _importando
                            ? 'Importando...'
                            : 'Importar ${resultado.filas.length} cliente(s)',
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
