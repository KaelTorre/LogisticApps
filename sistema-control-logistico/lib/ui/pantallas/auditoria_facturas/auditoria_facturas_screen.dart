import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/formato_moneda.dart';
import '../../../data/models/factura_transporte.dart';
import '../../../data/models/organizacion.dart';
import '../../../data/repositories/factura_transporte_repository.dart';
import '../../../domain/motor/m10_auditoria_facturas.dart';

/// Discrepancias que el usuario clasifica a mano tras revisar el
/// documento original -- M10 nunca las asigna, así que "Auditar todas"
/// (`_AuditoriaFacturasScreenState._auditar`) nunca las pisa.
const _tiposManuales = {'peso', 'ruta', 'descripcion', 'cargo_accesorio'};
const _etiquetasEstado = {'pendiente': 'Pendiente', 'recuperado': 'Recuperado', 'descartado': 'Descartado'};

/// Pantalla 21 (CLAUDE.md sección 9): carga de facturas, auditoría
/// automática de M10 (tarifa y duplicado) y clasificación manual del
/// resto de discrepancias declaradas por el esquema.
class AuditoriaFacturasScreen extends StatefulWidget {
  const AuditoriaFacturasScreen({super.key, required this.organizacion});

  final Organizacion organizacion;

  @override
  State<AuditoriaFacturasScreen> createState() => _AuditoriaFacturasScreenState();
}

class _AuditoriaFacturasScreenState extends State<AuditoriaFacturasScreen> {
  bool _cargando = true;
  bool _auditando = false;
  List<FacturaTransporte> _facturas = [];

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _cargando = true);
    final todas = await context.read<FacturaTransporteRepository>().obtenerPorOrganizacion(widget.organizacion.id!);
    if (!mounted) return;
    setState(() {
      _facturas = todas;
      _cargando = false;
    });
  }

  Future<void> _auditar() async {
    if (_facturas.isEmpty) return;
    setState(() => _auditando = true);

    final auditadas = auditarFacturas(_facturas);
    final repo = context.read<FacturaTransporteRepository>();
    for (var i = 0; i < _facturas.length; i++) {
      final original = _facturas[i];
      // No se pisa una clasificación manual (peso/ruta/descripción/cargo
      // accesorio) -- M10 solo recalcula lo que sabe recalcular.
      if (_tiposManuales.contains(original.discrepanciaTipo)) continue;
      final recalculada = auditadas[i];
      if (recalculada.discrepanciaTipo != original.discrepanciaTipo ||
          recalculada.montoRecuperableCent != original.montoRecuperableCent) {
        await repo.actualizar(recalculada);
      }
    }

    if (!mounted) return;
    setState(() => _auditando = false);
    await _cargar();
  }

  Future<void> _abrirFormulario({FacturaTransporte? existente}) async {
    final guardado = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => _FormularioFactura(
          organizacionId: widget.organizacion.id!,
          moneda: widget.organizacion.moneda,
          existente: existente,
        ),
      ),
    );
    if (guardado == true) await _cargar();
  }

  Future<void> _eliminar(FacturaTransporte factura) async {
    await context.read<FacturaTransporteRepository>().eliminar(factura.id!);
    await _cargar();
  }

  @override
  Widget build(BuildContext context) {
    final totalRecuperablePendienteCent = _facturas
        .where((f) => f.estado == 'pendiente')
        .fold<int>(0, (suma, f) => suma + f.montoRecuperableCent);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Auditoría de facturas'),
        actions: [
          if (_facturas.isNotEmpty)
            IconButton(
              icon: _auditando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(LucideIcons.searchCheck),
              tooltip: 'Auditar todas',
              onPressed: _auditando ? null : _auditar,
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        icon: const Icon(LucideIcons.plus),
        label: const Text('Nueva factura'),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _facturas.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Todavía no hay facturas cargadas. Agrega una y usa "Auditar todas" para '
                  'recalcularla contra el tarifario contratado.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.only(bottom: 88),
              children: [
                Card(
                  margin: const EdgeInsets.all(16),
                  child: ListTile(
                    leading: const Icon(LucideIcons.circleDollarSign),
                    title: const Text('Monto recuperable pendiente'),
                    trailing: Text(
                      formatearMoneda(totalRecuperablePendienteCent / 100, widget.organizacion.moneda),
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                for (final f in _facturas)
                  _TarjetaFactura(
                    factura: f,
                    moneda: widget.organizacion.moneda,
                    onTap: () => _abrirFormulario(existente: f),
                    onEliminar: () => _eliminar(f),
                  ),
              ],
            ),
    );
  }
}

class _TarjetaFactura extends StatelessWidget {
  const _TarjetaFactura({required this.factura, required this.moneda, required this.onTap, required this.onEliminar});

  final FacturaTransporte factura;
  final String moneda;
  final VoidCallback onTap;
  final VoidCallback onEliminar;

  @override
  Widget build(BuildContext context) {
    final tipo = factura.discrepanciaTipo;
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        onTap: onTap,
        title: Text('${factura.numero} · ${factura.transportista}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${factura.ruta} · ${factura.peso.toStringAsFixed(1)} kg'),
            Text(
              'Aplicada ${formatearMoneda(factura.tarifaAplicadaCent / 100, moneda)} · '
              'Contratada ${formatearMoneda(factura.tarifaContratadaCent / 100, moneda)}',
            ),
            if (tipo != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Wrap(
                  spacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Chip(
                      label: Text(etiquetasTipoDiscrepancia[tipo] ?? tipo),
                      backgroundColor: colorScheme.errorContainer,
                      labelStyle: TextStyle(color: colorScheme.onErrorContainer),
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                    ),
                    if (factura.montoRecuperableCent > 0)
                      Text('Recuperable ${formatearMoneda(factura.montoRecuperableCent / 100, moneda)}'),
                    Text(
                      _etiquetasEstado[factura.estado] ?? factura.estado,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
          ],
        ),
        isThreeLine: true,
        trailing: IconButton(icon: const Icon(LucideIcons.trash2, size: 18), onPressed: onEliminar),
      ),
    );
  }
}

class _FormularioFactura extends StatefulWidget {
  const _FormularioFactura({required this.organizacionId, required this.moneda, this.existente});

  final int organizacionId;
  final String moneda;
  final FacturaTransporte? existente;

  @override
  State<_FormularioFactura> createState() => _FormularioFacturaState();
}

class _FormularioFacturaState extends State<_FormularioFactura> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _numeroCtrl;
  late final TextEditingController _transportistaCtrl;
  late final TextEditingController _pesoCtrl;
  late final TextEditingController _rutaCtrl;
  late final TextEditingController _tarifaAplicadaCtrl;
  late final TextEditingController _tarifaContratadaCtrl;
  String? _discrepanciaTipo;
  late String _estado;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    final existente = widget.existente;
    _numeroCtrl = TextEditingController(text: existente?.numero ?? '');
    _transportistaCtrl = TextEditingController(text: existente?.transportista ?? '');
    _pesoCtrl = TextEditingController(text: existente == null ? '' : existente.peso.toString());
    _rutaCtrl = TextEditingController(text: existente?.ruta ?? '');
    _tarifaAplicadaCtrl = TextEditingController(
      text: existente == null ? '' : (existente.tarifaAplicadaCent / 100).toStringAsFixed(2),
    );
    _tarifaContratadaCtrl = TextEditingController(
      text: existente == null ? '' : (existente.tarifaContratadaCent / 100).toStringAsFixed(2),
    );
    _discrepanciaTipo = existente?.discrepanciaTipo;
    _estado = existente?.estado ?? 'pendiente';
  }

  @override
  void dispose() {
    _numeroCtrl.dispose();
    _transportistaCtrl.dispose();
    _pesoCtrl.dispose();
    _rutaCtrl.dispose();
    _tarifaAplicadaCtrl.dispose();
    _tarifaContratadaCtrl.dispose();
    super.dispose();
  }

  int? _aCentimos(String texto) {
    final valor = double.tryParse(texto.trim().replaceAll(',', '.'));
    if (valor == null) return null;
    return (valor * 100).round();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    final tarifaAplicadaCent = _aCentimos(_tarifaAplicadaCtrl.text)!;
    final tarifaContratadaCent = _aCentimos(_tarifaContratadaCtrl.text)!;
    setState(() => _guardando = true);

    final repo = context.read<FacturaTransporteRepository>();
    final esManual = _tiposManuales.contains(_discrepanciaTipo);
    final factura = FacturaTransporte(
      id: widget.existente?.id,
      organizacionId: widget.organizacionId,
      numero: _numeroCtrl.text.trim(),
      transportista: _transportistaCtrl.text.trim(),
      peso: double.parse(_pesoCtrl.text.trim().replaceAll(',', '.')),
      ruta: _rutaCtrl.text.trim(),
      tarifaAplicadaCent: tarifaAplicadaCent,
      tarifaContratadaCent: tarifaContratadaCent,
      discrepanciaTipo: _discrepanciaTipo,
      // Una clasificación manual no trae un monto recalculado por M10; el
      // sobrecobro sobre lo contratado es la única cifra objetiva
      // disponible para esos tipos, así que se usa como estimado inicial
      // y el usuario la ajusta si corresponde.
      montoRecuperableCent: esManual
          ? (tarifaAplicadaCent > tarifaContratadaCent ? tarifaAplicadaCent - tarifaContratadaCent : 0)
          : (widget.existente?.montoRecuperableCent ?? 0),
      estado: _estado,
    );

    if (factura.id == null) {
      await repo.crear(factura);
    } else {
      await repo.actualizar(factura);
    }

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final esNuevo = widget.existente == null;
    return Scaffold(
      appBar: AppBar(title: Text(esNuevo ? 'Nueva factura' : 'Editar factura')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _numeroCtrl,
              enabled: esNuevo,
              decoration: const InputDecoration(labelText: 'Número de factura'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa el número' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _transportistaCtrl,
              decoration: const InputDecoration(labelText: 'Transportista'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa el transportista' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _pesoCtrl,
              decoration: const InputDecoration(labelText: 'Peso (kg)'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => double.tryParse((v ?? '').trim().replaceAll(',', '.')) == null
                  ? 'Ingresa un peso válido'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _rutaCtrl,
              decoration: const InputDecoration(labelText: 'Ruta', helperText: 'Ej. "Lima-Arequipa"'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa la ruta' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _tarifaAplicadaCtrl,
              decoration: InputDecoration(
                labelText: 'Tarifa aplicada (cobrada)',
                prefixText: simboloMoneda(widget.moneda),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => _aCentimos(v ?? '') == null ? 'Ingresa un monto válido' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _tarifaContratadaCtrl,
              decoration: InputDecoration(labelText: 'Tarifa contratada', prefixText: simboloMoneda(widget.moneda)),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => _aCentimos(v ?? '') == null ? 'Ingresa un monto válido' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String?>(
              initialValue: _discrepanciaTipo,
              decoration: const InputDecoration(
                labelText: 'Discrepancia',
                helperText: '"Auditar todas" solo recalcula tarifa y duplicado; el resto se marca a mano.',
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text('Sin discrepancia')),
                for (final entry in etiquetasTipoDiscrepancia.entries)
                  DropdownMenuItem(value: entry.key, child: Text(entry.value)),
              ],
              onChanged: (v) => setState(() => _discrepanciaTipo = v),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _estado,
              decoration: const InputDecoration(labelText: 'Estado'),
              items: [
                for (final entry in _etiquetasEstado.entries)
                  DropdownMenuItem(value: entry.key, child: Text(entry.value)),
              ],
              onChanged: (v) => setState(() => _estado = v!),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _guardando ? null : _guardar,
              child: _guardando
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
