import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'tour_controller.dart';

/// Un paso de la inducción guiada: una parte pequeña y enfocada del
/// sistema, con su explicación y una imagen simple de esa parte, sin
/// necesitar datos propios de una organización real.
class PasoInduccion {
  const PasoInduccion({required this.icono, required this.titulo, required this.descripcion, required this.imagen});

  final IconData icono;
  final String titulo;
  final String descripcion;
  final WidgetBuilder imagen;
}

/// Inducción guiada de la aplicación completa: su propia pantalla (no una
/// superposición sobre la interfaz real), con avance, retroceso y la
/// opción de saltarla, para poder cubrir cada módulo sin depender de que
/// ya exista una organización cargada.
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
        title: Text('Introducción · paso ${_paso + 1} de ${_pasos.length}'),
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
                  paso.imagen(context),
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
                      icon: const Icon(LucideIcons.arrowLeft, size: 18),
                      label: const Text('Atrás'),
                    ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: _siguiente,
                    icon: Icon(esUltimo ? LucideIcons.check : LucideIcons.arrowRight, size: 18),
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
        icono: LucideIcons.building2,
        titulo: 'Bienvenido al Sistema de Control Logístico',
        descripcion:
            'Este sistema recibe las mediciones de tus indicadores logísticos periodo '
            'a periodo, evalúa toda la serie -- no solo el último dato -- para '
            'detectar cuándo una desviación amerita actuar, propone acciones '
            'concretas desde una biblioteca, y verifica en el periodo siguiente si '
            'esa acción realmente funcionó. No reemplaza tu criterio: propone y '
            'documenta, la decisión final siempre es tuya. Este recorrido te '
            'muestra cada parte, paso a paso -- avanza, retrocede o sáltalo cuando '
            'quieras.',
        imagen: (context) => _iconoCentral(context, LucideIcons.building2),
      ),
      PasoInduccion(
        icono: LucideIcons.calendarRange,
        titulo: 'Organización y periodos',
        descripcion:
            'Todo cuelga de una sola organización por instalación: sus datos, moneda '
            'y tipo de empresa. El calendario de periodos lo defines tú -- diario, '
            'semanal, mensual o trimestral, con la etiqueta y las fechas que '
            'prefieras. El periodo activo es el que tú eliges, nunca el que marca '
            'el reloj del dispositivo.',
        imagen: (context) => _listaIconos(context, const [
          (LucideIcons.building2, 'Organización'),
          (LucideIcons.calendarRange, 'Periodos'),
        ]),
      ),
      PasoInduccion(
        icono: LucideIcons.gauge,
        titulo: 'Indicadores',
        descripcion:
            'Cada indicador tiene una meta, una banda de tolerancia, una unidad y un '
            'sentido de mejora (si menor es mejor, como un costo, o si mayor es '
            'mejor, como un nivel de cumplimiento). Se agrupan en tres categorías '
            '-- costo, servicio y productividad -- y en el proceso al que '
            'pertenecen, para poder verlos juntos más adelante.',
        imagen: (context) => _listaIconos(context, const [
          (LucideIcons.target, 'Meta'),
          (LucideIcons.moveVertical, 'Banda'),
          (LucideIcons.arrowUpDown, 'Sentido'),
        ]),
      ),
      PasoInduccion(
        icono: LucideIcons.clipboardList,
        titulo: 'Captura de mediciones',
        descripcion:
            'El valor de cada indicador se registra periodo a periodo, a mano o '
            'importando un archivo con la serie histórica completa. No se puede '
            'cargar dos veces el mismo periodo para un mismo indicador -- si te '
            'equivocas, lo editas en vez de duplicarlo.',
        imagen: (context) => _listaIconos(context, const [
          (LucideIcons.penLine, 'Manual'),
          (LucideIcons.fileUp, 'Importar archivo'),
        ]),
      ),
      PasoInduccion(
        icono: LucideIcons.scanSearch,
        titulo: 'Evaluación de la serie',
        descripcion:
            'Acá está la diferencia con un simple umbral. En vez de mirar solo si el '
            'último valor se salió de la banda, el sistema revisa el patrón de toda '
            'la serie: una racha sostenida del lado adverso, un corrimiento de la '
            'media, una tendencia sostenida, un deterioro brusco o una dispersión '
            'creciente. Eso detecta problemas estructurales que un umbral simple '
            'deja pasar hasta que ya son graves, y evita saltar por un solo dato '
            'atípico.',
        imagen: (context) => _listaIconos(context, const [
          (LucideIcons.zap, 'Punto fuera de banda'),
          (LucideIcons.trendingUp, 'Tendencia sostenida'),
          (LucideIcons.activity, 'Dispersión creciente'),
        ]),
      ),
      PasoInduccion(
        icono: LucideIcons.circleAlert,
        titulo: 'Clasificación de la magnitud',
        descripcion:
            'Detectar una desviación no es lo mismo que decidir qué tan grave es. '
            'Un solo punto fuera de banda queda marcado como "observación" -- '
            'todavía no dispara ninguna acción, es la diferencia central de este '
            'sistema frente a un umbral que reacciona ante cualquier valor '
            'atípico. Solo cuando el patrón se sostiene, el sistema clasifica la '
            'respuesta necesaria en ajuste menor, replaneación mayor o '
            'contingencia.',
        imagen: (context) => _semaforoMockup(context),
      ),
      PasoInduccion(
        icono: LucideIcons.listChecks,
        titulo: 'Acciones correctoras',
        descripcion:
            'Según la clasificación y el tipo de indicador, el sistema propone '
            'acciones concretas desde una biblioteca -- nunca genera una '
            'recomendación nueva por su cuenta, selecciona entre las ya '
            'registradas. Algunas de esas acciones apuntan a otras herramientas de '
            'planeación cuando el problema ya no se corrige ajustando la operación '
            'actual, sino rediseñando la red o el almacén.',
        imagen: (context) => _listaIconos(context, const [
          (LucideIcons.wrench, 'Ajuste menor'),
          (LucideIcons.mapPinned, 'Replaneación mayor'),
          (LucideIcons.siren, 'Contingencia'),
        ]),
      ),
      PasoInduccion(
        icono: LucideIcons.badgeCheck,
        titulo: 'Registro y verificación',
        descripcion:
            'Eliges una acción, le asignas un responsable y una fecha comprometida. '
            'El sistema queda pendiente de verificar: en el periodo siguiente, '
            'propone si la desviación se corrigió, quedó parcial o no se corrigió '
            '-- pero nunca cierra la acción por sí solo. Confirmas tú, con lo que '
            'realmente pasó.',
        imagen: (context) => _listaIconos(context, const [
          (LucideIcons.userCheck, 'Responsable'),
          (LucideIcons.calendarCheck, 'Fecha comprometida'),
          (LucideIcons.badgeCheck, 'Verificación'),
        ]),
      ),
      PasoInduccion(
        icono: LucideIcons.clock,
        titulo: 'Reloj de simulación',
        descripcion:
            'Para ver el sistema en acción sin esperar periodos reales, el reloj de '
            'simulación recorre una serie ya cargada: avanza y retrocede periodo a '
            'periodo, y en cada paso puedes ver el semáforo cambiar de color, la '
            'clasificación aparecer, y qué regla disparó y por qué.',
        imagen: (context) => _semaforoMockup(context),
      ),
      PasoInduccion(
        icono: LucideIcons.flaskConical,
        titulo: 'Laboratorio de escenarios',
        descripcion:
            'Tres herramientas para poner a prueba el sistema: un generador de '
            'series sintéticas con distintos patrones, un contraste que compara '
            'este método contra un umbral simple sobre la misma serie (mostrando '
            'cuántas falsas alarmas evita cada uno y qué tan rápido detecta cada '
            'uno lo real), y un calibrador que propone el ancho de banda que mejor '
            'separa las desviaciones reales del ruido.',
        imagen: (context) => _listaIconos(context, const [
          (LucideIcons.flaskConical, 'Generador'),
          (LucideIcons.gitCompare, 'Contraste'),
          (LucideIcons.slidersHorizontal, 'Calibrador'),
        ]),
      ),
      PasoInduccion(
        icono: LucideIcons.radar,
        titulo: 'Diagnóstico organizacional',
        descripcion:
            'Un cuestionario aparte del control por indicadores: ubica a la '
            'organización en una etapa de desarrollo, una opción organizacional, '
            'su posición en los ejes de centralización y de rol asesor o de línea, '
            'y su orientación dominante. El resultado se ve en un radar contra un '
            'perfil de referencia, con un informe de las brechas entre uno y otro.',
        imagen: (context) => _iconoCentral(context, LucideIcons.radar),
      ),
      PasoInduccion(
        icono: LucideIcons.receipt,
        titulo: 'Auditoría de facturas',
        descripcion:
            'Recalcula cada factura de transporte contra lo contratado: detecta '
            'automáticamente un sobrecobro de tarifa y facturas duplicadas '
            '(mismo número y transportista), y cuantifica el monto recuperable. El '
            'resto de discrepancias que puedas encontrar al revisar el documento '
            'original -- de peso, de ruta, de descripción o cargos no pactados -- '
            'se marcan a mano, sin que una nueva auditoría automática las borre.',
        imagen: (context) => _listaIconos(context, const [
          (LucideIcons.receipt, 'Tarifa'),
          (LucideIcons.copy, 'Duplicado'),
          (LucideIcons.circleDollarSign, 'Recuperable'),
        ]),
      ),
      PasoInduccion(
        icono: LucideIcons.fileJson,
        titulo: 'Exportación',
        descripcion:
            'Cada informe se exporta a PDF desde su propia pantalla, y la '
            'organización completa se exporta en un solo archivo JSON -- para '
            'respaldarla o para llevarla a otra instalación del sistema. Con esto '
            'termina el recorrido: ya puedes crear tu organización, o cargar el '
            'caso de estudio de ejemplo para seguir explorando con datos ya '
            'cargados.',
        imagen: (context) => _iconoCentral(context, LucideIcons.fileJson),
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
              CircleAvatar(
                radius: 24,
                backgroundColor: colores.primaryContainer,
                child: Icon(icono, color: colores.onPrimaryContainer),
              ),
              const SizedBox(height: 6),
              Text(etiqueta, style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
      ],
    ),
  );
}

Widget _semaforoMockup(BuildContext context) {
  final colores = Theme.of(context).colorScheme;
  const estados = [
    (Colors.green, LucideIcons.check, 'Normal'),
    (Colors.amber, LucideIcons.eye, 'Observación'),
    (Colors.red, LucideIcons.circleAlert, 'Desviación'),
  ];
  return Container(
    height: 140,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: colores.surfaceContainerHighest, borderRadius: BorderRadius.circular(16)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (final (color, icono, etiqueta) in estados)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.15),
                  border: Border.all(color: color, width: 2),
                ),
                child: Icon(icono, color: color),
              ),
              const SizedBox(height: 6),
              Text(etiqueta, style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
      ],
    ),
  );
}
