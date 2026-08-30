import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/estado/proyecto_activo.dart';
import '../../../data/repositories/cliente_repository.dart';
import '../../../data/repositories/parametros_costo_repository.dart';
import '../../../data/repositories/sitio_candidato_repository.dart';
import '../../../domain/auditoria/auditor_datos.dart';
import '../../../domain/auditoria/hallazgo.dart';

/// Pantalla 4 (CLAUDE.md sección 8): hallazgos de calidad de datos del
/// proyecto activo, con severidad y acción sugerida.
class AuditoriaDatosScreen extends StatefulWidget {
  const AuditoriaDatosScreen({super.key});

  @override
  State<AuditoriaDatosScreen> createState() => _AuditoriaDatosScreenState();
}

class _AuditoriaDatosScreenState extends State<AuditoriaDatosScreen> {
  List<Hallazgo>? _hallazgos;

  int get _proyectoId => context.read<ProyectoActivo>().proyecto!.id!;

  @override
  void initState() {
    super.initState();
    _auditar();
  }

  Future<void> _auditar() async {
    setState(() => _hallazgos = null);
    final proyectoId = _proyectoId;
    final clienteRepository = context.read<ClienteRepository>();
    final candidatoRepository = context.read<SitioCandidatoRepository>();
    final parametrosRepository = context.read<ParametrosCostoRepository>();

    final clientes = await clienteRepository.obtenerPorProyecto(proyectoId);
    final candidatos = await candidatoRepository.obtenerPorProyecto(proyectoId);
    final parametros = await parametrosRepository.obtenerPorProyecto(proyectoId);

    final hallazgos = auditarDatos(
      clientes: clientes,
      candidatos: candidatos,
      parametrosCosto: parametros,
    );

    if (!mounted) return;
    setState(() => _hallazgos = hallazgos);
  }

  @override
  Widget build(BuildContext context) {
    final hallazgos = _hallazgos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Auditoría de datos'),
        actions: [
          IconButton(onPressed: _auditar, icon: const Icon(LucideIcons.refreshCw), tooltip: 'Volver a revisar'),
        ],
      ),
      body: SafeArea(
        child: hallazgos == null
            ? const Center(child: CircularProgressIndicator())
            : hallazgos.isEmpty
            ? _SinHallazgos()
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: hallazgos.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) => _TarjetaHallazgo(hallazgo: hallazgos[index]),
              ),
      ),
    );
  }
}

class _TarjetaHallazgo extends StatelessWidget {
  const _TarjetaHallazgo({required this.hallazgo});

  final Hallazgo hallazgo;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final esError = hallazgo.severidad == SeveridadHallazgo.error;
    final colorFondo = esError ? colorScheme.errorContainer : colorScheme.secondaryContainer;
    final colorTexto = esError ? colorScheme.onErrorContainer : colorScheme.onSecondaryContainer;

    return Card(
      color: colorFondo,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              esError ? LucideIcons.circleAlert : LucideIcons.triangleAlert,
              color: colorTexto,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hallazgo.mensaje,
                    style: TextStyle(color: colorTexto, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(hallazgo.accionSugerida, style: TextStyle(color: colorTexto)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SinHallazgos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.circleCheck, size: 40, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 12),
            Text(
              'Sin hallazgos de calidad — los datos cargados pasan las seis '
              'reglas de auditoría.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
