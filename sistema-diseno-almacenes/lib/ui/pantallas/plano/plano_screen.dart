import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/plataforma/abrir_carpeta.dart';
import '../../../domain/export/dxf_writer.dart';
import '../../../domain/geometria/generador_layout.dart';
import '../../widgets/plano_2d.dart';

/// Pantalla 07 de CLAUDE.md sección 10 (versión inicial, Fase 2): vista
/// cenital acotada, con zonas coloreadas. Cotas de superficie total y de
/// pasillo; zonas funcionales (recepción, despacho, etc.) llegan en una
/// fase posterior, cuando el usuario pueda declararlas.
class PlanoScreen extends StatefulWidget {
  const PlanoScreen({
    super.key,
    required this.layout,
    required this.modulosPorFila,
    required this.frenteAndenMm,
    required this.patioProfundidadMm,
  });

  final ResultadoLayout layout;
  final int modulosPorFila;
  final int frenteAndenMm;
  final int patioProfundidadMm;

  @override
  State<PlanoScreen> createState() => _PlanoScreenState();
}

class _PlanoScreenState extends State<PlanoScreen> {
  bool _exportando = false;

  Future<void> _exportarDxf() async {
    setState(() => _exportando = true);
    try {
      final dxf = generarDxf(
        layout: widget.layout,
        frenteAndenMm: widget.frenteAndenMm,
        patioProfundidadMm: widget.patioProfundidadMm,
      );
      final directorio = await getApplicationDocumentsDirectory();
      final marca = DateTime.now().toIso8601String().replaceAll(RegExp(r'[:.]'), '-');
      final archivo = File('${directorio.path}/almacen_$marca.dxf');
      await archivo.writeAsString(dxf);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarArchivoExportado(
          mensaje: 'DXF exportado en ${archivo.path}',
          rutaArchivo: archivo.path,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No se pudo exportar: $e')));
    } finally {
      if (mounted) setState(() => _exportando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final layout = widget.layout;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plano 2D'),
        actions: [
          Tooltip(
            message: 'Pellizca o usa la rueda del mouse para acercar. Arrastra para mover.',
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Icon(Icons.pinch_outlined, color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _exportando
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : Tooltip(
                    message:
                        'Exporta el plano a DXF (milímetros, capas RACKS/'
                        'PASILLOS/ZONAS/ANDEN/COTAS/TEXTO) para abrirlo en un CAD.',
                    child: IconButton(
                      onPressed: _exportarDxf,
                      icon: const Icon(Icons.file_download_outlined),
                    ),
                  ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Vista desde arriba, en milímetros, con el plano completo (racks y '
                    'andén) a la vista de entrada. El ancho está siempre a escala; el alto '
                    'de cada franja (fila, pasillo, separación) tiene un mínimo para que su '
                    'nombre y medidas se alcancen a leer, así que una franja muy delgada '
                    'puede verse un poco más grande de lo real — la medida en DXF y en la '
                    'ficha técnica siempre son las exactas. Acerca (rueda del mouse o '
                    'pellizco) para leer el detalle de cada módulo.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Wrap(
              spacing: 16,
              runSpacing: 4,
              children: [
                _leyenda(Plano2D.colorRacks, Plano2D.colorRacksBorde, 'Racks'),
                _leyenda(Plano2D.colorPasillo, Plano2D.colorPasilloBorde, 'Pasillo'),
                _leyenda(
                  Plano2D.colorSeparacion,
                  Plano2D.colorSeparacionBorde,
                  'Separación de espalda (no transitable)',
                ),
                _leyenda(Plano2D.colorAnden, Plano2D.colorAndenBorde, 'Andén'),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Plano2D(
                layout: layout,
                modulosPorFila: widget.modulosPorFila,
                frenteAndenMm: widget.frenteAndenMm,
                patioProfundidadMm: widget.patioProfundidadMm,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _leyenda(Color relleno, Color borde, String etiqueta) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: relleno,
            border: Border.all(color: borde),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(etiqueta, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
