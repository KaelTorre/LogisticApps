import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../data/models/deposito.dart';
import '../../../data/repositories/deposito_repository.dart';
import 'deposito_form_screen.dart';

/// Pantalla de Depósitos (sección 8 de CLAUDE.md, extendida): CRUD completo
/// sobre el catálogo de depósitos — la app admite varios, cada cálculo
/// elige de cuál sale la mercadería.
class DepositosScreen extends StatefulWidget {
  const DepositosScreen({super.key});

  @override
  State<DepositosScreen> createState() => _DepositosScreenState();
}

class _DepositosScreenState extends State<DepositosScreen> {
  List<Deposito> _depositos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _cargando = true);
    final depositos = await context.read<DepositoRepository>().obtenerTodos();
    if (!mounted) return;
    setState(() {
      _depositos = depositos;
      _cargando = false;
    });
  }

  Future<void> _abrirFormulario({Deposito? existente}) async {
    final guardado = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => DepositoFormScreen(existente: existente),
      ),
    );
    if (guardado == true) await _cargar();
  }

  Future<void> _confirmarEliminar(Deposito deposito) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar depósito'),
        content: Text(
          '¿Eliminar "${deposito.nombre}"? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmado != true || !mounted) return;

    await context.read<DepositoRepository>().eliminar(deposito.id!);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          showCloseIcon: true,
          content: Text('"${deposito.nombre}" eliminado.'),
        ),
      );
    await _cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Depósitos')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        icon: const Icon(LucideIcons.plus),
        label: const Text('Agregar'),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _depositos.isEmpty
          ? _EstadoVacio(alAgregar: () => _abrirFormulario())
          : SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final columnas = (constraints.maxWidth / 340)
                      .floor()
                      .clamp(1, 3);
                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columnas,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      mainAxisExtent: 108,
                    ),
                    itemCount: _depositos.length,
                    itemBuilder: (context, index) {
                      final deposito = _depositos[index];
                      return _TarjetaDeposito(
                        deposito: deposito,
                        alEditar: () => _abrirFormulario(existente: deposito),
                        alEliminar: () => _confirmarEliminar(deposito),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}

class _TarjetaDeposito extends StatelessWidget {
  const _TarjetaDeposito({
    required this.deposito,
    required this.alEditar,
    required this.alEliminar,
  });

  final Deposito deposito;
  final VoidCallback alEditar;
  final VoidCallback alEliminar;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: alEditar,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  LucideIcons.warehouse,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      deposito.nombre,
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${deposito.latitud.toStringAsFixed(3)}, '
                      '${deposito.longitud.toStringAsFixed(3)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: alEliminar,
                icon: const Icon(LucideIcons.trash2),
                tooltip: 'Eliminar',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EstadoVacio extends StatelessWidget {
  const _EstadoVacio({required this.alAgregar});

  final VoidCallback alAgregar;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.warehouse,
              size: 40,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              'Todavía no hay depósitos.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: alAgregar,
              icon: const Icon(LucideIcons.plus),
              label: const Text('Agregar el primero'),
            ),
          ],
        ),
      ),
    );
  }
}
