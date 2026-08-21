import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

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
    required this.frenteAndenMm,
    required this.patioProfundidadMm,
  });

  final ResultadoLayout layout;
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
        SnackBar(
          content: Text('DXF exportado en ${archivo.path}'),
          duration: const Duration(seconds: 6),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _leyenda(Plano2D.colorRacks, 'Racks'),
                const SizedBox(width: 16),
                _leyenda(Plano2D.colorPasillo, 'Pasillo', bordeado: true),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Plano2D(layout: layout),
            ),
          ),
        ],
      ),
    );
  }

  Widget _leyenda(Color color, String etiqueta, {bool bordeado = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            border: bordeado ? Border.all(color: Colors.black26) : null,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(etiqueta, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
