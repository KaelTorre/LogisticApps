import 'package:flutter/material.dart';

import '../../ui/paleta_territorios.dart';
import 'tour_controller.dart';

/// Un paso de la inducción guiada: una parte pequeña y enfocada del
/// sistema, con su explicación y un "snapshot" — un render simple de esa
/// parte, sin necesitar datos propios del usuario.
class PasoInduccion {
  const PasoInduccion({required this.icono, required this.titulo, required this.descripcion, required this.snapshot});

  final IconData icono;
  final String titulo;
  final String descripcion;
  final WidgetBuilder snapshot;
}

/// Inducción guiada de la app completa (Fase 9) — mismo patrón que
/// `sistema-diseno-almacenes`: su propia pantalla (no un overlay sobre la
/// UI real), con avance/retroceso y "Saltar", para poder cubrir cada
/// módulo sin depender de que ya exista un proyecto cargado.
class InduccionScreen extends StatefulWidget {
  const InduccionScreen({super.key, required this.tour});

  final TourController tour;

  @override
  State<InduccionScreen> createState() => _InduccionScreenState();
}

class _InduccionScreenState extends State<InduccionScreen> {
  late final List<PasoInduccion> _pasos = _construirPasos();
  int _paso = 0;

  void _siguiente() {
    if (_paso < _pasos.length - 1) {
      setState(() => _paso++);
    } else {
      _cerrar();
    }
  }

  void _anterior() {
    if (_paso > 0) setState(() => _paso--);
  }

  void _cerrar() {
    widget.tour.marcarVisto();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final paso = _pasos[_paso];
    final esUltimo = _paso == _pasos.length - 1;
    final colores = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Inducción · paso ${_paso + 1} de ${_pasos.length}'),
        actions: [
          TextButton(onPressed: _cerrar, child: const Text('Saltar')),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(value: (_paso + 1) / _pasos.length),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(paso.icono, size: 28, color: colores.primary),
                      const SizedBox(width: 12),
                      Expanded(child: Text(paso.titulo, style: Theme.of(context).textTheme.headlineSmall)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  paso.snapshot(context),
                  const SizedBox(height: 16),
                  Text(paso.descripcion, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  if (_paso > 0)
                    OutlinedButton.icon(
                      onPressed: _anterior,
                      icon: const Icon(Icons.arrow_back, size: 18),
                      label: const Text('Atrás'),
                    ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: _siguiente,
                    icon: Icon(esUltimo ? Icons.check : Icons.arrow_forward, size: 18),
                    label: Text(esUltimo ? 'Terminar' : 'Siguiente'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PasoInduccion> _construirPasos() {
    return [
      PasoInduccion(
        icono: Icons.hub_outlined,
        titulo: 'Bienvenido al Sistema de Red de Distribución',
        descripcion:
            'Esta aplicación decide cuántos centros de distribución conviene abrir, '
            'en cuáles ubicaciones, y qué zona de demanda atiende cada uno — '
            'minimizando el costo logístico total sujeto a un estándar de '
            'servicio. No es un ruteador de vehículos (no ordena visitas ni '
            'ventanas horarias), no es un WMS, y no dimensiona el almacén en sí. '
            'Este recorrido te muestra, paso a paso, cada pantalla y para qué sirve — '
            'avanza, retrocede o sáltalo cuando quieras.',
        snapshot: (context) => _iconoCentral(context, Icons.hub_outlined),
      ),
      PasoInduccion(
        icono: Icons.folder_outlined,
        titulo: 'Proyecto',
        descripcion:
            'Cada análisis vive dentro de un proyecto: le das un nombre, eliges '
            'la moneda y la unidad en la que trabajas (toneladas, kilogramos o '
            'unidades — sin conversión automática entre proyectos, así que no '
            'conviene mezclarlas dentro de uno) y un horizonte en años. El '
            'factor de circuidad es un ajuste para cuando no hay una ruta real '
            'disponible: multiplica la distancia en línea recta para acercarla a '
            'una distancia por carretera realista.',
        snapshot: (context) => _listaIconos(context, const [
          (Icons.badge_outlined, 'Nombre'),
          (Icons.payments_outlined, 'Moneda'),
          (Icons.scale_outlined, 'Unidad'),
          (Icons.calendar_month_outlined, 'Horizonte'),
        ]),
      ),
      PasoInduccion(
        icono: Icons.people_outline,
        titulo: 'Clientes',
        descripcion:
            'La lista de puntos que generan demanda: nombre, coordenadas y '
            'cuánto piden al año. Se cargan a mano, seleccionando el punto en '
            'un mapa, o importando un archivo CSV completo de una sola vez. Con '
            'muchos clientes dispersos, el siguiente paso los agrupa en zonas '
            'manejables antes de seguir.',
        snapshot: (context) => _listaIconos(context, const [
          (Icons.person_pin_circle_outlined, 'Coordenadas'),
          (Icons.shopping_cart_outlined, 'Demanda'),
          (Icons.upload_file_outlined, 'Importar CSV'),
        ]),
      ),
      PasoInduccion(
        icono: Icons.shield_outlined,
        titulo: 'Auditoría de datos',
        descripcion:
            'Antes de calcular nada, esta pantalla revisa la calidad de lo '
            'cargado: coordenadas fuera de rango o duplicadas, demanda en cero, '
            'clientes sin pedidos, candidatos sin costo fijo, tarifas '
            'faltantes. Cada hallazgo trae su severidad y qué acción tomar — '
            'nada de esto bloquea el cálculo, pero ignorarlo produce resultados '
            'poco confiables.',
        snapshot: (context) => _listaIconos(context, const [
          (Icons.error_outline, 'Coordenada inválida'),
          (Icons.remove_circle_outline, 'Demanda en cero'),
          (Icons.price_change_outlined, 'Tarifa faltante'),
        ]),
      ),
      PasoInduccion(
        icono: Icons.blur_circular,
        titulo: 'Agregación en zonas',
        descripcion:
            'Agrupa los clientes cercanos en zonas de demanda: en vez de '
            'evaluar cada cliente individualmente (lo que vuelve la matriz de '
            'distancias enorme e innecesaria), el sistema los junta en un '
            'número de zonas que elijas, cada una con su propio centro y su '
            'demanda total sumada. Cuantas menos zonas, más rápido el cálculo — '
            'pero también menos preciso el resultado.',
        snapshot: (context) => _mapaMockup(context, puntos: 19, agrupados: true),
      ),
      PasoInduccion(
        icono: Icons.location_on_outlined,
        titulo: 'Sitios candidatos',
        descripcion:
            'Los lugares donde podrías abrir un centro de distribución, cada '
            'uno con su costo fijo anual, capacidad y costo de manejo. Los '
            'cargas a mano, o le pides al sistema que sugiera ubicaciones por '
            'centro de gravedad — el punto que minimiza la distancia ponderada '
            'a tus zonas de demanda. Esa sugerencia no es una decisión final: es '
            'un punto de partida que tienes que confirmar (puede caer en un '
            'lugar no edificable).',
        snapshot: (context) => _listaIconos(context, const [
          (Icons.add_location_alt_outlined, 'Manual'),
          (Icons.auto_awesome_outlined, 'Sugerido'),
        ]),
      ),
      PasoInduccion(
        icono: Icons.factory_outlined,
        titulo: 'Plantas',
        descripcion:
            'Los orígenes de abastecimiento de la red: de dónde sale la '
            'mercadería antes de llegar a un centro de distribución abierto. '
            'Cada planta tiene su capacidad anual y su costo de producción por '
            'unidad.',
        snapshot: (context) => _iconoCentral(context, Icons.factory_outlined),
      ),
      PasoInduccion(
        icono: Icons.payments_outlined,
        titulo: 'Parámetros de costo',
        descripcion:
            'Las tarifas que alimentan el cálculo de costo total: transporte '
            'de entrada (planta → centro) y de salida (centro → zona), el '
            'costo de mantener inventario, el costo por pedido, y el estándar '
            'de servicio — la distancia o el tiempo máximo que una zona puede '
            'estar de su centro asignado antes de considerarse mal atendida.',
        snapshot: (context) => _listaIconos(context, const [
          (Icons.local_shipping_outlined, 'Entrada / salida'),
          (Icons.inventory_2_outlined, 'Inventario'),
          (Icons.timer_outlined, 'Estándar de servicio'),
        ]),
      ),
      PasoInduccion(
        icono: Icons.route_outlined,
        titulo: 'Matriz de distancias',
        descripcion:
            'Antes de decidir nada, el sistema necesita saber qué tan lejos '
            'está cada candidato de cada zona (y cada planta de cada '
            'candidato) por carretera real, no en línea recta. Esta pantalla '
            'muestra el progreso de esa consulta y qué proporción de la '
            'matriz salió de una ruta real contra un cálculo aproximado (si no '
            'hay conexión disponible).',
        snapshot: (context) => _barraProgresoMockup(context),
      ),
      PasoInduccion(
        icono: Icons.play_circle_outline,
        titulo: 'Optimización',
        descripcion:
            'El corazón del sistema: decide qué candidatos abrir. Puedes fijar '
            'el número de centros o dejar que el sistema lo decida solo '
            '(comparando la curva de costo completa), y eliges entre varios '
            'métodos de búsqueda — desde uno rápido y directo hasta uno que '
            'explora más el espacio de soluciones a cambio de tardar más. Con '
            'pocos candidatos, el sistema puede incluso probar todas las '
            'combinaciones posibles y garantizar el óptimo exacto.',
        snapshot: (context) => _iconoCentral(context, Icons.play_circle_outline),
      ),
      PasoInduccion(
        icono: Icons.map_outlined,
        titulo: 'Resultado — mapa',
        descripcion:
            'El resultado visual: cada centro abierto con su territorio '
            'coloreado (colores elegidos para que territorios vecinos nunca se '
            'confundan entre sí), las zonas que atiende, y en rojo las que '
            'quedaron fuera del estándar de servicio. Desde acá también puedes '
            'compartir un enlace que muestra este mismo mapa en un navegador, '
            'sin que la otra persona necesite instalar la app.',
        snapshot: (context) => _paletaMockup(context),
      ),
      PasoInduccion(
        icono: Icons.bar_chart_outlined,
        titulo: 'Resultado — costos',
        descripcion:
            'El desglose del costo total por rubro (producción, transporte de '
            'entrada y salida, costo fijo, manejo, inventario, pedidos), y una '
            'comparación contra la red actual si marcaste cuáles de tus '
            'candidatos ya están operando hoy — para ver de un vistazo cuánto '
            'ahorrarías con el cambio.',
        snapshot: (context) => _barrasMockup(context),
      ),
      PasoInduccion(
        icono: Icons.show_chart_outlined,
        titulo: 'Curva',
        descripcion:
            'Cuando le pides al sistema que barra distintos números de '
            'centros, esta pantalla grafica el costo total contra esa '
            'cantidad, con el mínimo marcado — la recomendación del sistema, '
            'nunca escrita a mano.',
        snapshot: (context) => _curvaMockup(context),
      ),
      PasoInduccion(
        icono: Icons.compare_arrows_outlined,
        titulo: 'Comparador de escenarios',
        descripcion:
            'Puedes comparar dos escenarios lado a lado: qué centros abren y cuáles '
            'cierran, qué zonas cambian de asignación, el ahorro anual, y si '
            'el cumplimiento del estándar de servicio mejora o empeora.',
        snapshot: (context) => _listaIconos(context, const [
          (Icons.arrow_back, 'Escenario A'),
          (Icons.compare_arrows, ''),
          (Icons.arrow_forward, 'Escenario B'),
        ]),
      ),
      PasoInduccion(
        icono: Icons.ios_share_outlined,
        titulo: 'Exportación',
        descripcion:
            'Reúne todo en una ficha técnica en PDF, exporta las tablas en '
            'CSV o el proyecto completo en JSON (para reabrirlo en otra '
            'máquina), o genera el volumen anual que le tocó a cada centro '
            'abierto en el formato que espera la aplicación de diseño de '
            'almacenes — para arrancar el dimensionamiento de ese centro con '
            'un solo clic.',
        snapshot: (context) => _listaIconos(context, const [
          (Icons.picture_as_pdf_outlined, 'PDF'),
          (Icons.table_chart_outlined, 'CSV'),
          (Icons.data_object_outlined, 'JSON'),
        ]),
      ),
    ];
  }
}

Widget _iconoCentral(BuildContext context, IconData icono) {
  final colores = Theme.of(context).colorScheme;
  return Container(
    height: 140,
    alignment: Alignment.center,
    decoration: BoxDecoration(color: colores.primaryContainer, borderRadius: BorderRadius.circular(16)),
    child: Icon(icono, size: 56, color: colores.onPrimaryContainer),
  );
}

Widget _listaIconos(BuildContext context, List<(IconData, String)> items) {
  final colores = Theme.of(context).colorScheme;
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: colores.surfaceContainerHighest, borderRadius: BorderRadius.circular(16)),
    child: Wrap(
      spacing: 20,
      runSpacing: 16,
      children: [
        for (final (icono, etiqueta) in items)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(radius: 24, backgroundColor: colores.primaryContainer, child: Icon(icono, color: colores.onPrimaryContainer)),
              if (etiqueta.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(etiqueta, style: Theme.of(context).textTheme.labelMedium),
              ],
            ],
          ),
      ],
    ),
  );
}

Widget _mapaMockup(BuildContext context, {required int puntos, required bool agrupados}) {
  final colores = Theme.of(context).colorScheme;
  return Container(
    height: 160,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: colores.surfaceContainerHighest, borderRadius: BorderRadius.circular(16)),
    child: Center(
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: List.generate(
          puntos,
          (i) => CircleAvatar(
            radius: agrupados ? 6 : 5,
            backgroundColor: agrupados ? colorParaTerritorio(i % 4) : colores.primary,
          ),
        ),
      ),
    ),
  );
}

Widget _paletaMockup(BuildContext context) {
  return Container(
    height: 140,
    padding: const EdgeInsets.all(16),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: List.generate(
        5,
        (i) => Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: colorParaTerritorio(i), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
        ),
      ),
    ),
  );
}

Widget _barraProgresoMockup(BuildContext context) {
  final colores = Theme.of(context).colorScheme;
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: colores.surfaceContainerHighest, borderRadius: BorderRadius.circular(16)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Bloque 7 de 10', style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(value: 0.7, minHeight: 10),
        ),
        const SizedBox(height: 8),
        Text('82% de las celdas con distancia real por carretera', style: Theme.of(context).textTheme.bodySmall),
      ],
    ),
  );
}

Widget _barrasMockup(BuildContext context) {
  final colores = Theme.of(context).colorScheme;
  const alturas = [0.9, 0.5, 0.7, 0.3, 0.4, 0.2, 0.25];
  return Container(
    height: 140,
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
    decoration: BoxDecoration(color: colores.surfaceContainerHighest, borderRadius: BorderRadius.circular(16)),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (final h in alturas)
          Container(
            width: 18,
            height: 90 * h,
            decoration: BoxDecoration(color: colores.primary, borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
          ),
      ],
    ),
  );
}

Widget _curvaMockup(BuildContext context) {
  final colores = Theme.of(context).colorScheme;
  return Container(
    height: 140,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: colores.surfaceContainerHighest, borderRadius: BorderRadius.circular(16)),
    child: CustomPaint(painter: _CurvaPainter(color: colores.primary), size: const Size(double.infinity, double.infinity)),
  );
}

class _CurvaPainter extends CustomPainter {
  const _CurvaPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final path = Path()..moveTo(0, size.height * 0.85);
    path.quadraticBezierTo(size.width * 0.35, size.height * 0.05, size.width * 0.55, size.height * 0.1);
    path.quadraticBezierTo(size.width * 0.8, size.height * 0.2, size.width, size.height * 0.55);
    canvas.drawPath(path, paint);

    final minimo = Offset(size.width * 0.5, size.height * 0.09);
    canvas.drawCircle(minimo, 5, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _CurvaPainter oldDelegate) => oldDelegate.color != color;
}
