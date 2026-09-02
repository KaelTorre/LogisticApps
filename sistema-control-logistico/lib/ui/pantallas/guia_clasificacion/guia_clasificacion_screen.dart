import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class _DescripcionRegla {
  const _DescripcionRegla({required this.codigo, required this.nombre, required this.descripcion});

  final String codigo;
  final String nombre;
  final String descripcion;
}

const _reglas = [
  _DescripcionRegla(
    codigo: 'R1',
    nombre: 'Punto fuera de banda',
    descripcion: 'El último valor está fuera de la banda de tolerancia.',
  ),
  _DescripcionRegla(
    codigo: 'R2',
    nombre: 'Racha en el lado adverso',
    descripcion: '7 valores consecutivos del lado adverso de la meta.',
  ),
  _DescripcionRegla(
    codigo: 'R3',
    nombre: 'Corrimiento de media',
    descripcion: '8 de los últimos 8 valores del lado adverso de la meta.',
  ),
  _DescripcionRegla(
    codigo: 'R4',
    nombre: 'Tendencia sostenida',
    descripcion: '5 valores consecutivos que empeoran sin parar, todos del lado adverso de la meta.',
  ),
  _DescripcionRegla(
    codigo: 'R5',
    nombre: 'Deterioro brusco',
    descripcion: 'El valor cambió, de un periodo a otro, más de lo que mide el ancho completo de la banda.',
  ),
  _DescripcionRegla(
    codigo: 'R6',
    nombre: 'Dispersión creciente',
    descripcion:
        'Los últimos 10 valores varían 1.5 veces más que los 10 anteriores -- la serie se volvió más '
        'errática, no necesariamente peor.',
  ),
];

/// Referencia de consulta para M1/M2 (CLAUDE.md sección 8), en lenguaje
/// llano y con los umbrales reales que usa `m2_clasificador.dart` --
/// nunca los de la prosa del contrato técnico si alguna vez difieren
/// (ver el ajuste real de R5 documentado en ese archivo). Pantalla
/// puramente informativa, sin datos de ninguna organización: existe
/// porque un usuario real intentó mapear una acción a "Ajuste menor"
/// para un escenario que en realidad clasificó "Contingencia" -- las
/// cuatro clasificaciones no son independientes, son una cascada de
/// prioridad, y eso no se adivina mirando solo los nombres.
class GuiaClasificacionScreen extends StatelessWidget {
  const GuiaClasificacionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cómo clasifica el sistema')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Reglas que vigilan cada serie', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Cada periodo, el sistema revisa la serie completa del indicador -- no solo el último '
            'valor -- contra estas seis reglas. Pueden disparar varias a la vez.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          for (final regla in _reglas)
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  radius: 16,
                  child: Text(regla.codigo, style: const TextStyle(fontSize: 12)),
                ),
                title: Text(regla.nombre),
                subtitle: Text(regla.descripcion),
              ),
            ),
          const SizedBox(height: 24),
          Text('De las reglas disparadas a una clasificación', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            'El sistema revisa estas condiciones en el orden de abajo hacia arriba en gravedad -- la '
            'primera que se cumple gana, no se suman entre sí. Por eso una acción configurada para '
            '"Ajuste menor" nunca aparece si el periodo clasificó "Contingencia", aunque las mismas '
            'reglas hayan disparado en los dos casos.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          _TarjetaClasificacion(
            color: Theme.of(context).colorScheme.outline,
            titulo: 'Ninguna · estado normal',
            explicacion: 'No disparó ninguna regla.',
          ),
          _TarjetaClasificacion(
            color: Colors.amber.shade700,
            titulo: 'Ninguna · en observación',
            explicacion:
                'Disparó solo R1, sin ninguna otra regla. Un solo punto fuera de banda, aislado, no '
                'alcanza para proponer una acción -- es la diferencia central de este sistema frente a '
                'un umbral simple. Queda marcado para vigilar, no para actuar.',
          ),
          _TarjetaClasificacion(
            color: Theme.of(context).colorScheme.error,
            titulo: 'Contingencia',
            explicacion:
                'Se dispara si tres o más indicadores del mismo proceso están en desviación en este '
                'mismo periodo, o si R6 (dispersión creciente) dispara junto con R2 o R3. Es la más '
                'grave: sugiere una causa común, no un problema aislado de este indicador.',
          ),
          _TarjetaClasificacion(
            color: Colors.deepOrange,
            titulo: 'Replaneación mayor',
            explicacion:
                'Se dispara si R2, R3 o R4 dispararon, y además el valor actual se desvió de la meta '
                'más que el ancho completo de la banda, o el indicador ya lleva 4 o más periodos '
                'seguidos en desviación. Es una desviación que ya no se corrige con un ajuste puntual.',
          ),
          _TarjetaClasificacion(
            color: Colors.amber.shade700,
            titulo: 'Ajuste menor',
            explicacion:
                'Se dispara si R2, R3, R4 o R5 dispararon, sin llegar a las condiciones de replaneación '
                'mayor ni de contingencia.',
          ),
          const SizedBox(height: 24),
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(LucideIcons.lightbulb, color: Theme.of(context).colorScheme.onPrimaryContainer),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Antes de crear o editar una acción para un escenario específico, revisa qué '
                      'clasificación resultó realmente en Evaluación del periodo -- ahí se explica qué '
                      'regla disparó y por qué, para ese periodo exacto.',
                      style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaClasificacion extends StatelessWidget {
  const _TarjetaClasificacion({required this.color, required this.titulo, required this.explicacion});

  final Color color;
  final String titulo;
  final String explicacion;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 4,
                height: 48,
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(titulo, style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 4),
                    Text(explicacion, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
