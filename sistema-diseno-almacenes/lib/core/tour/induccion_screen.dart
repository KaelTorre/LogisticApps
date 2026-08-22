import 'package:flutter/material.dart';

import '../../ui/widgets/grafica_pronostico.dart';
import '../../ui/widgets/grafica_requerimiento_mensual.dart';
import '../../ui/widgets/plano_2d.dart';
import '../../ui/widgets/vista_isometrica.dart';
import 'induccion_datos_demo.dart';
import 'tour_controller.dart';

/// Un paso de la inducción guiada: una parte pequeña y enfocada del
/// sistema, con su explicación (qué es, para qué es, cómo se usa) y un
/// "snapshot" — un render de esa parte, sin necesitar datos reales del
/// usuario. Cuando el snapshot es de algo que ya existe como función pura o
/// widget del sistema (el plano, la vista isométrica, las gráficas), se usa
/// el widget real con datos de ejemplo (`DatosDemoInduccion`) en vez de una
/// imagen o una maqueta — es el mismo render que vería el usuario con un
/// caso propio.
class PasoInduccion {
  const PasoInduccion({
    required this.icono,
    required this.titulo,
    required this.descripcion,
    required this.snapshot,
  });

  final IconData icono;
  final String titulo;
  final String descripcion;
  final WidgetBuilder snapshot;
}

/// Inducción guiada de la app completa. No navega las pantallas reales
/// (CLAUDE.md no la pide; es un agregado por usabilidad pedido tras probar
/// la app) — es su propia pantalla, con su propio avance/retroceso, para
/// poder cubrir TODO el sistema sin depender de que exista un cálculo real
/// ni de que la navegación en vivo permita retroceder limpiamente.
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
                      Expanded(
                        child: Text(paso.titulo, style: Theme.of(context).textTheme.headlineSmall),
                      ),
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
        icono: Icons.warehouse_outlined,
        titulo: 'Bienvenido al Sistema de Diseño de Almacenes',
        descripcion:
            'Esta aplicación predimensiona y configura un almacén a partir de la '
            'demanda proyectada: convierte demanda en posiciones de tarima, '
            'posiciones en superficie construida, decide cuánto espacio conviene '
            'poseer y cuánto rentar, y genera el plano 2D, la vista isométrica y '
            'la ficha técnica — todo exportable a DXF, PDF y un archivo de '
            'proyecto portable. No es un WMS (no gestiona la operación diaria), '
            'no certifica estructuras, no es un CAD de dibujo libre y no simula '
            'eventos. Este recorrido te muestra, paso a paso, cada pantalla y '
            'para qué sirve — avanza, retrocede o sáltalo cuando quieras.',
        snapshot: (context) => _iconoCentral(context, Icons.warehouse_outlined),
      ),
      PasoInduccion(
        icono: Icons.edit_note_outlined,
        titulo: 'La pantalla de entrada',
        descripcion:
            'Es el punto de partida: un formulario con 4 secciones (Demanda, '
            'Catálogo, Instalación, Andén) que alimentan el cálculo. Los campos '
            'ya traen valores de ejemplo para que puedas probar el sistema de '
            'inmediato — los reemplazas por los tuyos cuando tengas un caso '
            'real. Debajo del formulario hay accesos directos a pronosticar '
            'demanda, comparar escenarios de racking, y exportar/importar el '
            'proyecto completo.',
        snapshot: (context) => _listaIconos(context, const [
          (Icons.trending_up, 'Demanda'),
          (Icons.inventory_2_outlined, 'Catálogo'),
          (Icons.warehouse_outlined, 'Instalación'),
          (Icons.local_shipping_outlined, 'Andén'),
        ]),
      ),
      PasoInduccion(
        icono: Icons.trending_up,
        titulo: 'Sección Demanda',
        descripcion:
            'Convierte tu demanda en tarimas: demanda anual (el volumen que '
            'vas a mover en el periodo), rotación anual (cuántas veces se '
            'renueva tu inventario al año), unidades por tarima (cuántas '
            'unidades caben en una tarima ya paletizada) y factor honeycomb '
            '(capacidad perdida por huecos de acomodo, normalmente entre '
            '15% y 30%). Con esto el sistema calcula cuántas posiciones de '
            'tarima vas a necesitar.',
        snapshot: (context) => _tarjetaCampos(context, icono: Icons.trending_up, titulo: 'Demanda', campos: const [
          (Icons.calendar_today_outlined, 'Demanda anual', '12000'),
          (Icons.autorenew, 'Rotación anual', '12'),
          (Icons.inventory_2_outlined, 'Unidades por tarima', '40'),
          (Icons.grid_view_outlined, 'Factor honeycomb', '0.20'),
        ]),
      ),
      PasoInduccion(
        icono: Icons.timeline_outlined,
        titulo: 'Pronóstico de demanda (M1) — opcional',
        descripcion:
            'Si no conoces tu demanda futura pero sí tienes historial, este '
            'módulo la proyecta automáticamente y elige, entre varias '
            'alternativas, la más precisa para tus datos — no necesitas '
            'saber estadística para confiar en el resultado. El almacén se '
            'dimensiona sobre demanda FUTURA, no la actual: si proyectas a '
            '5 años, es el año 5 el que manda. "Usar en el cálculo" manda '
            'ese número directo al campo Demanda anual de la pantalla de '
            'entrada.',
        snapshot: (context) => SizedBox(
          height: 190,
          child: GraficaPronostico(
            historico: DatosDemoInduccion.historicoPronosticoDemo,
            pronostico: DatosDemoInduccion.pronosticoDemo,
          ),
        ),
      ),
      PasoInduccion(
        icono: Icons.inventory_2_outlined,
        titulo: 'Sección Catálogo',
        descripcion:
            'Eliges 4 piezas reales de catálogo: la tarima que usas, el '
            'bastidor y la viga de tu sistema de racks (el largo de viga se '
            'mide entre caras internas de puntales, no de extremo a '
            'extremo — es el error más común al medir en campo), y el '
            'equipo de manutención que vas a operar (su elevación limita '
            'los niveles, su pasillo entra en la superficie construida). Si '
            'algo no está en la lista, se agrega en la pantalla de Catálogo '
            'con sus medidas reales.',
        snapshot: (context) => _tarjetaCampos(context, icono: Icons.inventory_2_outlined, titulo: 'Catálogo', campos: const [
          (Icons.inventory_2_outlined, 'Tarima', 'EPAL · 1200×800 mm'),
          (Icons.view_column_outlined, 'Bastidor', 'BAST-914 · fondo 914 mm'),
          (Icons.straighten, 'Viga', 'VIGA-1825 · 1825 mm'),
          (Icons.precision_manufacturing_outlined, 'Equipo', 'TRILATERAL-VNA-300'),
        ]),
      ),
      PasoInduccion(
        icono: Icons.warehouse_outlined,
        titulo: 'Sección Instalación',
        descripcion:
            'Los límites físicos del edificio: alto de carga (tu producto ya '
            'paletizado, sin la tarima), altura libre (del piso a lo más bajo '
            'del techo, no al domo), reserva de techo (espacio para '
            'rociadores y luminarias, se resta antes de calcular niveles) y '
            'largo disponible (el terreno real para colocar filas, '
            'descontando oficinas u otras zonas fijas). El motor M3 usa estos '
            'datos para calcular cuántos niveles y módulos caben.',
        snapshot: (context) => _tarjetaCampos(context, icono: Icons.warehouse_outlined, titulo: 'Instalación', campos: const [
          (Icons.height, 'Alto de carga', '1200 mm'),
          (Icons.vertical_align_top, 'Altura libre', '8000 mm'),
          (Icons.water_drop_outlined, 'Reserva de techo', '450 mm'),
          (Icons.straighten, 'Largo disponible', '30000 mm'),
        ]),
      ),
      PasoInduccion(
        icono: Icons.local_shipping_outlined,
        titulo: 'Sección Andén',
        descripcion:
            'Dimensiona las puertas de carga y descarga a partir de: el '
            'camión de diseño (el más grande que atiendes, no el '
            'promedio), camiones en hora pico (la hora con más llegadas — '
            'un almacén con 40 camiones en 8 horas pero 15 entre las 7 y las '
            '9 necesita puertas para las 7, no el promedio del día), tiempo '
            'de servicio, espera objetivo (una decisión de servicio, no un '
            'dato medido) y espaciamiento/área de preparación por puerta.',
        snapshot: (context) => _tarjetaCampos(context, icono: Icons.local_shipping_outlined, titulo: 'Andén', campos: const [
          (Icons.local_shipping_outlined, 'Camión de diseño', 'C2 · patio 18000 mm'),
          (Icons.schedule, 'Camiones en hora pico', '4'),
          (Icons.timer_outlined, 'Tiempo de servicio', '30 min'),
          (Icons.hourglass_bottom_outlined, 'Espera objetivo', '15 min'),
        ]),
      ),
      PasoInduccion(
        icono: Icons.calculate_outlined,
        titulo: 'Botón "Calcular"',
        descripcion:
            'Corre todo el cálculo de una vez: convierte tu demanda en '
            'posiciones y superficie, arma el layout de filas y pasillos, '
            'encuentra la mejor configuración según distancia de recorrido '
            'y dimensiona el andén. Si alguna holgura está por debajo del '
            'mínimo normativo, el sistema RECHAZA el cálculo en vez de '
            'ajustarla en silencio — así el resultado es siempre uno del '
            'que te puedes fiar. El resultado te lleva a la Ficha técnica.',
        snapshot: (context) => Column(
          children: [
            _botonMockup(context, icono: Icons.calculate_outlined, texto: 'Calcular'),
            _flechaHacia(context, 'Lleva a la Ficha técnica'),
          ],
        ),
      ),
      PasoInduccion(
        icono: Icons.compare_arrows_outlined,
        titulo: '"Comparar escenarios de racking (M8)"',
        descripcion:
            'No necesitas calcular primero: este botón abre una pantalla '
            'aparte donde comparas 3 formas de guardar la misma demanda — '
            'selectivo (cada tarima accesible), doble fondo y drive-in (más '
            'densos, pero con menos acceso directo). El sistema SIEMPRE '
            'muestra el costo oculto de la densidad junto al ahorro: un '
            'drive-in que gana 50% de posiciones no es necesariamente buena '
            'idea si tu producto tiene rotación mixta.',
        snapshot: (context) => _botonMockup(
          context,
          icono: Icons.compare_arrows_outlined,
          texto: 'Comparar escenarios de racking (M8)',
          relleno: false,
        ),
      ),
      PasoInduccion(
        icono: Icons.swap_horiz,
        titulo: 'Exportar / Importar proyecto',
        descripcion:
            'El proyecto completo (demanda, catálogo elegido, instalación, '
            'andén) se exporta a un archivo JSON portable, incluyendo las '
            'filas de catálogo que usó — no solo sus IDs — para que abra en '
            'otra máquina aunque su catálogo semilla sea distinto. Al '
            'importar, cada pieza de catálogo se busca por código y si no '
            'existe se agrega como fila nueva. Los archivos se guardan y se '
            'leen desde la carpeta de Documentos de la app.',
        snapshot: (context) => Row(
          children: [
            Expanded(
              child: _botonMockup(context, icono: Icons.upload_file_outlined, texto: 'Exportar', relleno: false),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _botonMockup(context, icono: Icons.download_outlined, texto: 'Importar', relleno: false),
            ),
          ],
        ),
      ),
      PasoInduccion(
        icono: Icons.summarize_outlined,
        titulo: 'Ficha técnica — Resumen',
        descripcion:
            'El resultado del cálculo: posiciones requeridas vs. instaladas '
            '(siempre instaladas ≥ requeridas), tarimas por nivel, paso de '
            'nivel, niveles, módulos y filas, y la superficie de '
            'almacenamiento vs. construida. Es el resumen ejecutivo del '
            'diseño.',
        snapshot: (context) => _tarjetaCampos(context, icono: Icons.summarize_outlined, titulo: 'Resumen', campos: const [
          (Icons.inventory_2_outlined, 'Posiciones requeridas', '32'),
          (Icons.layers_outlined, 'Niveles', '4'),
          (Icons.grid_view_outlined, 'Módulos', '4'),
          (Icons.crop_free, 'Superficie construida', '38.1 m²'),
        ]),
      ),
      PasoInduccion(
        icono: Icons.percent,
        titulo: 'Relación almacenamiento / construida',
        descripcion:
            'El indicador de calidad del diseño y la "prueba de humo" del '
            'sistema: en selectivo con retráctil, debe caer entre 45% y 60%. '
            'Si sale muy por encima, hay un error de cálculo; si sale muy '
            'por debajo, el diseño está mal configurado. El sistema lo marca '
            'visualmente cuando sale fuera de ese rango típico.',
        snapshot: (context) => _filaDestacada(
          context,
          icono: Icons.percent,
          etiqueta: 'Relación almacenamiento/construida',
          valor: '68.6 %',
          iconoEstado: Icons.check_circle_outline,
          colorEstado: Colors.green,
        ),
      ),
      PasoInduccion(
        icono: Icons.local_shipping_outlined,
        titulo: 'Ficha técnica — Andén',
        descripcion:
            'Puertas necesarias, frente de andén (puertas × espaciamiento), '
            'profundidad del patio de maniobras (del catálogo del camión de '
            'diseño) y el tiempo de espera real en cola.',
        snapshot: (context) => _tarjetaCampos(context, icono: Icons.local_shipping_outlined, titulo: 'Andén', campos: const [
          (Icons.door_sliding_outlined, 'Puertas', '3'),
          (Icons.straighten, 'Frente de andén', '10800 mm'),
          (Icons.hourglass_bottom_outlined, 'Espera en cola', '13.3 min'),
        ]),
      ),
      PasoInduccion(
        icono: Icons.receipt_long_outlined,
        titulo: 'Memoria de cálculo',
        descripcion:
            'Cada número de la ficha técnica tiene aquí su fórmula, sus '
            'entradas y su fuente normativa o de catálogo. Es lo que separa '
            'un número que tienes que creer de uno que puedes defender frente '
            'a tu jefe o tu banco: si un valor sale distinto al esperado, '
            'puedes rastrear exactamente de dónde salió.',
        snapshot: (context) => _filaMemoriaMockup(context),
      ),
      PasoInduccion(
        icono: Icons.picture_as_pdf_outlined,
        titulo: 'Exportar PDF',
        descripcion:
            'Genera un documento con la ficha técnica y la memoria de '
            'cálculo COMPLETA — fórmula, entradas, valor y fuente de cada '
            'fila, paginado automáticamente. Es el entregable que sostiene la '
            'decisión frente a gerencia o un banco.',
        snapshot: (context) => _botonMockup(context, icono: Icons.picture_as_pdf_outlined, texto: 'Exportar PDF'),
      ),
      PasoInduccion(
        icono: Icons.map_outlined,
        titulo: 'Plano 2D',
        descripcion:
            'Vista desde arriba, a escala real, generada directamente del '
            'cálculo (nunca dibujada a mano). Cada zona lleva borde, nombre y '
            'medidas; los racks muestran las líneas divisorias de cada '
            'módulo. El andén se representa con su ancho real pero '
            'profundidad esquemática — su patio real es mucho más grande que '
            'el racking y lo aplastaría visualmente si se dibujara a escala. '
            'Acerca con la rueda del mouse o pellizcando.',
        snapshot: (context) => SizedBox(
          height: 260,
          child: Plano2D(
            layout: DatosDemoInduccion.layout,
            modulosPorFila: DatosDemoInduccion.modulosPorFila,
            frenteAndenMm: DatosDemoInduccion.frenteAndenMm,
            patioProfundidadMm: DatosDemoInduccion.patioProfundidadMm,
          ),
        ),
      ),
      PasoInduccion(
        icono: Icons.file_download_outlined,
        titulo: 'Exportar DXF',
        descripcion:
            'El mismo plano, escrito como archivo DXF de texto plano (sin '
            'librerías externas) en milímetros, con 6 capas separadas '
            '(RACKS, PASILLOS, ZONAS, ANDEN, COTAS, TEXTO) para abrir en un '
            'CAD real como LibreCAD o AutoCAD y medir con precisión.',
        snapshot: (context) => _botonMockup(context, icono: Icons.file_download_outlined, texto: 'Exportar DXF'),
      ),
      PasoInduccion(
        icono: Icons.view_in_ar_outlined,
        titulo: 'Vista isométrica',
        descripcion:
            'Los mismos racks del plano, ahora en 3D — generados como '
            'prismas paramétricos desde las dimensiones del catálogo, nunca '
            'con mallas 3D descargadas (eso congelaría la geometría y '
            'contradiría el cálculo). Rota en 4 ángulos de 90° (sin cámara '
            'libre) y corta la vista por nivel para revisar un piso a la '
            'vez. Prueba el botón de rotar y el control de nivel debajo.',
        snapshot: (context) => const _DemoIsometrico(),
      ),
      PasoInduccion(
        icono: Icons.table_chart_outlined,
        titulo: 'Comparador de configuraciones (M6)',
        descripcion:
            'Para la superficie ya calculada, prueba distintas geometrías '
            '(relación largo/ancho entre 1:1 y 3:1) y patrones de flujo — U '
            '(recepción y despacho comparten lado), pasante (flujo limpio, '
            'duplica fachada de andén) y L — y las ordena por distancia '
            'esperada de recorrido, no por estética. Es una tabla, no un '
            'dibujo.',
        snapshot: (context) => _tablaMockup(
          context,
          columnas: const ['Filas', 'Patrón', 'Distancia'],
          filas: const [
            ['2', 'Pasante', '1314 mm'],
            ['3', 'U', '1620 mm'],
            ['1', 'L', '2140 mm'],
          ],
          filaDestacada: 0,
        ),
      ),
      PasoInduccion(
        icono: Icons.show_chart,
        titulo: 'Dimensionamiento sin tendencia (M4)',
        descripcion:
            'Para demanda estable pero estacional: decide cuánta capacidad '
            'propia construir y cuánto cubrir con almacén público, mes a '
            'mes, comparando el costo anual propio contra la tarifa de un '
            'operador externo (por manejo, por espacio ocupado, o '
            'arrendamiento fijo). La salida es la gráfica que se lleva a '
            'gerencia: requerimiento mensual, línea de capacidad propia, y '
            'el área de desbordamiento sombreada.',
        snapshot: (context) => SizedBox(
          height: 210,
          child: GraficaRequerimientoMensual(
            requerimientosMensuales: DatosDemoInduccion.requerimientosMensuales,
            capacidadPropia: DatosDemoInduccion.capacidadPropiaDemo,
          ),
        ),
      ),
      PasoInduccion(
        icono: Icons.trending_up,
        titulo: 'Dimensionamiento con tendencia (M5)',
        descripcion:
            'Para demanda que crece año a año: compara 3 estrategias de '
            'construcción — todo ahora (capacidad del año final desde el '
            'año 1, con espacio ocioso al inicio), por etapas (construir '
            'para un año intermedio y ampliar después) y base + público '
            '(construir lo mínimo y desbordar siempre) — evaluadas por valor '
            'presente neto sobre el horizonte completo.',
        snapshot: (context) => _listaEscenariosMockup(context, [
          (Icons.compress_outlined, 'Base + público', 'VPN 48200', true),
          (Icons.stairs_outlined, 'Por etapas', 'VPN 52100', false),
          (Icons.rocket_launch_outlined, 'Todo ahora', 'VPN 61800', false),
        ]),
      ),
      PasoInduccion(
        icono: Icons.compare_arrows_outlined,
        titulo: 'Comparador de escenarios (M8)',
        descripcion:
            'Aplica el cálculo completo a 3 configuraciones de racking — '
            'selectivo, doble fondo, drive-in — con el mismo catálogo, '
            'terreno y andén. Tabula posiciones, superficie construida, '
            'relación de superficie, distancia esperada, inversión, costo '
            'por posición y accesibilidad. La columna de accesibilidad va '
            'SIEMPRE pegada al costo: más densidad no es gratis, y el '
            'sistema nunca separa el ahorro del costo oculto.',
        snapshot: (context) => _tablaMockup(
          context,
          columnas: const ['Escenario', 'Costo/posición', 'Accesibilidad'],
          filas: const [
            ['Drive-in', '1293.72', 'Limitada: LIFO'],
            ['Doble fondo', '1329.86', 'Parcial: 2 de fondo'],
            ['Selectivo', '2659.72', 'Total'],
          ],
          filaDestacada: 0,
        ),
      ),
      PasoInduccion(
        icono: Icons.folder_open_outlined,
        titulo: 'Importar proyecto',
        descripcion:
            'Lista los archivos .json de la carpeta de Documentos de la app '
            '— ahí caen los proyectos que tú mismo exportaste, o los que '
            'copies de otra máquina (USB o red). Tocas uno para cargarlo: el '
            'sistema restaura todos los campos del formulario y resuelve el '
            'catálogo automáticamente.',
        snapshot: (context) => _listaArchivosMockup(context),
      ),
      PasoInduccion(
        icono: Icons.check_circle_outline,
        titulo: 'Listo',
        descripcion:
            'Eso es todo el sistema: demanda → posiciones → superficie → '
            'plano, vista isométrica y ficha técnica, con comparadores de '
            'configuración y de escenarios, dimensionamiento propio vs. '
            'público, pronóstico de demanda, y exportación a DXF, PDF y '
            'proyecto portable. Puedes volver a ver este recorrido cuando '
            'quieras con el botón (?) de la pantalla de entrada.',
        snapshot: (context) => _iconoCentral(context, Icons.check_circle_outline),
      ),
    ];
  }
}

// ─── Snapshots reutilizables ───

Widget _iconoCentral(BuildContext context, IconData icono) {
  return Container(
    height: 140,
    alignment: Alignment.center,
    child: Icon(icono, size: 72, color: Theme.of(context).colorScheme.primary),
  );
}

Widget _listaIconos(BuildContext context, List<(IconData, String)> items) {
  final colores = Theme.of(context).colorScheme;
  return Card(
    elevation: 0,
    color: colores.surfaceContainerHighest,
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          for (final (icono, texto) in items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Icon(icono, size: 20, color: colores.primary),
                  const SizedBox(width: 12),
                  Text(texto, style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
        ],
      ),
    ),
  );
}

Widget _tarjetaCampos(
  BuildContext context, {
  required IconData icono,
  required String titulo,
  required List<(IconData, String, String)> campos,
}) {
  final colores = Theme.of(context).colorScheme;
  return Card(
    elevation: 0,
    color: colores.surfaceContainerHighest,
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icono, size: 18, color: colores.primary),
              const SizedBox(width: 8),
              Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          for (final (ic, etiqueta, valor) in campos)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(ic, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Expanded(child: Text(etiqueta, style: const TextStyle(fontSize: 13))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colores.surface,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: colores.outlineVariant),
                    ),
                    child: Text(valor, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
        ],
      ),
    ),
  );
}

Widget _botonMockup(
  BuildContext context, {
  required IconData icono,
  required String texto,
  bool relleno = true,
}) {
  final colores = Theme.of(context).colorScheme;
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 14),
    decoration: BoxDecoration(
      color: relleno ? colores.primary : Colors.transparent,
      border: relleno ? null : Border.all(color: colores.outline),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icono, size: 18, color: relleno ? colores.onPrimary : colores.primary),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            texto,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: relleno ? colores.onPrimary : colores.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _flechaHacia(BuildContext context, String texto) {
  return Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.arrow_downward, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 6),
        Text(texto, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontStyle: FontStyle.italic)),
      ],
    ),
  );
}

Widget _filaDestacada(
  BuildContext context, {
  required IconData icono,
  required String etiqueta,
  required String valor,
  required IconData iconoEstado,
  required Color colorEstado,
}) {
  final colores = Theme.of(context).colorScheme;
  return Card(
    elevation: 0,
    color: colores.surfaceContainerHighest,
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Icon(icono, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Expanded(child: Text(etiqueta)),
          Text(valor, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 6),
          Icon(iconoEstado, size: 18, color: colorEstado),
        ],
      ),
    ),
  );
}

Widget _filaMemoriaMockup(BuildContext context) {
  final colores = Theme.of(context).colorScheme;
  return Card(
    elevation: 0,
    color: colores.surfaceContainerHighest,
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Chip(
                label: const Text('M3', style: TextStyle(fontSize: 11)),
                padding: EdgeInsets.zero,
                labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text('Tarimas por nivel', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'n = floor((claro_util + holgura_x) / (ancho_tarima + holgura_x))',
            style: TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
          const SizedBox(height: 4),
          const Text('2 tarimas/nivel'),
          const SizedBox(height: 2),
          Text('Fuente: EN 15620', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
        ],
      ),
    ),
  );
}

Widget _tablaMockup(
  BuildContext context, {
  required List<String> columnas,
  required List<List<String>> filas,
  int? filaDestacada,
}) {
  final colores = Theme.of(context).colorScheme;
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: DataTable(
      headingRowHeight: 36,
      dataRowMinHeight: 36,
      dataRowMaxHeight: 44,
      columns: [for (final c in columnas) DataColumn(label: Text(c))],
      rows: [
        for (var i = 0; i < filas.length; i++)
          DataRow(
            color: i == filaDestacada
                ? WidgetStateProperty.all(colores.primaryContainer.withValues(alpha: 0.4))
                : null,
            cells: [for (final valor in filas[i]) DataCell(Text(valor))],
          ),
      ],
    ),
  );
}

Widget _listaEscenariosMockup(BuildContext context, List<(IconData, String, String, bool)> escenarios) {
  final colores = Theme.of(context).colorScheme;
  return Column(
    children: [
      for (final (icono, nombre, valor, esGanador) in escenarios)
        Container(
          margin: const EdgeInsets.symmetric(vertical: 3),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: esGanador ? Colors.green.withValues(alpha: 0.08) : colores.surfaceContainerHighest,
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(icono, size: 18, color: colores.primary),
              const SizedBox(width: 8),
              Expanded(child: Text(nombre, style: const TextStyle(fontWeight: FontWeight.w600))),
              if (esGanador) ...[
                const Icon(Icons.star, size: 14, color: Colors.amber),
                const SizedBox(width: 4),
              ],
              Text(valor),
            ],
          ),
        ),
    ],
  );
}

Widget _listaArchivosMockup(BuildContext context) {
  final colores = Theme.of(context).colorScheme;
  return Card(
    elevation: 0,
    color: colores.surfaceContainerHighest,
    child: Column(
      children: const [
        ListTile(
          leading: Icon(Icons.description_outlined),
          title: Text('proyecto_2026-08-21T15-42-34.json'),
          subtitle: Text('21 ago 2026, 15:42'),
          dense: true,
        ),
        Divider(height: 1),
        ListTile(
          leading: Icon(Icons.description_outlined),
          title: Text('proyecto_2026-08-19T09-10-02.json'),
          subtitle: Text('19 ago 2026, 09:10'),
          dense: true,
        ),
      ],
    ),
  );
}

/// Único snapshot con estado propio: deja rotar y cortar por nivel la
/// vista isométrica de ejemplo, para que ese control (el punto central de
/// esa pantalla) se explique probándolo, no solo describiéndolo.
class _DemoIsometrico extends StatefulWidget {
  const _DemoIsometrico();

  @override
  State<_DemoIsometrico> createState() => _DemoIsometricoState();
}

class _DemoIsometricoState extends State<_DemoIsometrico> {
  int _angulo = 0;
  int _nivelCorte = DatosDemoInduccion.niveles;

  static const _nombresAngulo = ['0°', '90°', '180°', '270°'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Tooltip(
              message: 'Rotar 90°',
              child: IconButton(
                icon: const Icon(Icons.rotate_right_outlined),
                onPressed: () => setState(() => _angulo = (_angulo + 1) % 4),
              ),
            ),
            Text('Ángulo: ${_nombresAngulo[_angulo]}'),
            const SizedBox(width: 16),
            Icon(Icons.layers_outlined, size: 16, color: Colors.grey.shade600),
            const SizedBox(width: 6),
            Text('Nivel $_nivelCorte de ${DatosDemoInduccion.niveles}'),
            Expanded(
              child: Slider(
                value: _nivelCorte.toDouble(),
                min: 1,
                max: DatosDemoInduccion.niveles.toDouble(),
                divisions: DatosDemoInduccion.niveles - 1,
                onChanged: (v) => setState(() => _nivelCorte = v.round()),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 220,
          child: VistaIsometrica(
            prismas: DatosDemoInduccion.prismas,
            angulo: _angulo,
            nivelCorte: _nivelCorte,
            pasoNivelMm: DatosDemoInduccion.pasoNivelMm,
          ),
        ),
      ],
    );
  }
}
