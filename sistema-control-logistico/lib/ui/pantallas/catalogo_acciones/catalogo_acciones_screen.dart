import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../data/models/accion_catalogo.dart';
import '../../../data/models/regla_accion.dart';
import '../../../data/repositories/accion_catalogo_repository.dart';
import '../../../data/repositories/regla_accion_repository.dart';
import '../guia_clasificacion/guia_clasificacion_screen.dart';
import 'accion_catalogo_form_screen.dart';

const _categorias = ['costo', 'servicio', 'productividad'];
const _etiquetasCategoria = {
  'costo': 'Costo',
  'servicio': 'Servicio',
  'productividad': 'Productividad',
};

const _magnitudes = ['ajuste_menor', 'replaneacion_mayor', 'contingencia'];
const _etiquetasMagnitud = {
  'ajuste_menor': 'Ajuste menor',
  'replaneacion_mayor': 'Replaneación mayor',
  'contingencia': 'Contingencia',
};

/// Catálogo de acciones correctoras y su mapeo a reglas de patrón
/// (`accion_catalogo` + `regla_accion`, CLAUDE.md sección 8, M3). No
/// depende de una organización -- es una biblioteca compartida por toda
/// la instalación, igual que `regla_patron`, así que esta pantalla no
/// recibe `organizacionId`.
class CatalogoAccionesScreen extends StatefulWidget {
  const CatalogoAccionesScreen({super.key, this.categoriaInicial, this.magnitudInicial});

  /// Si se llega desde "Acciones" porque un escenario no tenía ninguna
  /// candidata, se abre directo el formulario de alta con ese escenario
  /// ya elegido, en vez de dejar que el usuario lo busque de nuevo.
  final String? categoriaInicial;
  final String? magnitudInicial;

  @override
  State<CatalogoAccionesScreen> createState() => _CatalogoAccionesScreenState();
}

class _CatalogoAccionesScreenState extends State<CatalogoAccionesScreen> {
  bool _cargando = true;
  bool _abrioFormularioInicial = false;
  List<AccionCatalogo> _acciones = [];
  List<ReglaAccion> _mapeos = [];

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _cargando = true);
    final acciones = await context.read<AccionCatalogoRepository>().obtenerTodas();
    if (!mounted) return;
    final mapeos = await context.read<ReglaAccionRepository>().obtenerTodas();
    if (!mounted) return;
    setState(() {
      _acciones = acciones;
      _mapeos = mapeos;
      _cargando = false;
    });
    if (!_abrioFormularioInicial && widget.categoriaInicial != null && widget.magnitudInicial != null) {
      _abrioFormularioInicial = true;
      await _abrirFormulario(categoria: widget.categoriaInicial, magnitud: widget.magnitudInicial);
    }
  }

  int _prioridadDe(int accionId) {
    final propias = _mapeos.where((m) => m.accionId == accionId).map((m) => m.prioridad).toList();
    if (propias.isEmpty) return 999;
    return propias.reduce((a, b) => a < b ? a : b);
  }

  Future<void> _abrirFormulario({AccionCatalogo? existente, String? categoria, String? magnitud}) async {
    final guardado = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AccionCatalogoFormScreen(
          existente: existente,
          categoriaInicial: existente?.categoriaIndicador ?? categoria,
          magnitudInicial: existente?.magnitudTipica ?? magnitud,
          prioridadInicial: existente == null ? 1 : _prioridadDe(existente.id!),
          reglasIniciales: existente == null
              ? const {}
              : _mapeos.where((m) => m.accionId == existente.id).map((m) => m.reglaDisparada).toSet(),
        ),
      ),
    );
    if (guardado == true) await _cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de acciones'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.circleHelp),
            tooltip: 'Cómo clasifica el sistema',
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const GuiaClasificacionScreen())),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        icon: const Icon(LucideIcons.plus),
        label: const Text('Nueva acción'),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
              children: [
                Text(
                  'Qué acción proponer para cada combinación de categoría y magnitud de respuesta, '
                  'según qué regla de patrón haya disparado. Esto es lo que ofrece la pantalla '
                  'Acciones cuando una evaluación clasifica.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                for (final categoria in _categorias) ...[
                  Text(_etiquetasCategoria[categoria]!, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  for (final magnitud in _magnitudes)
                    _GrupoEscenario(
                      etiquetaMagnitud: _etiquetasMagnitud[magnitud]!,
                      acciones:
                          _acciones
                              .where((a) => a.categoriaIndicador == categoria && a.magnitudTipica == magnitud)
                              .toList()
                            ..sort((a, b) => _prioridadDe(a.id!).compareTo(_prioridadDe(b.id!))),
                      mapeos: _mapeos,
                      onTapAccion: (a) => _abrirFormulario(existente: a),
                      onAgregar: () => _abrirFormulario(categoria: categoria, magnitud: magnitud),
                    ),
                  const SizedBox(height: 16),
                ],
              ],
            ),
    );
  }
}

class _GrupoEscenario extends StatelessWidget {
  const _GrupoEscenario({
    required this.etiquetaMagnitud,
    required this.acciones,
    required this.mapeos,
    required this.onTapAccion,
    required this.onAgregar,
  });

  final String etiquetaMagnitud;
  final List<AccionCatalogo> acciones;
  final List<ReglaAccion> mapeos;
  final ValueChanged<AccionCatalogo> onTapAccion;
  final VoidCallback onAgregar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(etiquetaMagnitud, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 6),
          if (acciones.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                'Sin ninguna acción configurada todavía.',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
              ),
            )
          else
            for (final accion in acciones)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: _TarjetaAccion(
                  accion: accion,
                  reglas:
                      mapeos.where((m) => m.accionId == accion.id).map((m) => m.reglaDisparada).toList()
                        ..sort(),
                  onTap: () => onTapAccion(accion),
                ),
              ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: onAgregar,
              icon: const Icon(LucideIcons.plus, size: 16),
              label: const Text('Agregar acción para este escenario'),
              style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 32)),
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaAccion extends StatelessWidget {
  const _TarjetaAccion({required this.accion, required this.reglas, required this.onTap});

  final AccionCatalogo accion;
  final List<String> reglas;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      accion.titulo,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  if (!accion.esDeSistema)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Propia',
                        style: Theme.of(
                          context,
                        ).textTheme.labelSmall?.copyWith(color: colorScheme.onSecondaryContainer),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                accion.descripcion,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (reglas.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    for (final r in reglas)
                      Chip(
                        label: Text(r, style: const TextStyle(fontSize: 11)),
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
