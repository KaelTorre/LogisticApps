import 'package:flutter/material.dart';

/// Recuadro de la inducción guiada, para insertar arriba del contenido de
/// cada pantalla que participa del recorrido (ver `TourController`). Mismo
/// estilo visual que los banners informativos ya usados en Plano2D y
/// Pronóstico, pero con acento de color distinto (`primaryContainer`) para
/// que se note que es parte de un recorrido, no una nota de la pantalla.
class TourBanner extends StatelessWidget {
  const TourBanner({
    super.key,
    required this.titulo,
    required this.mensaje,
    required this.esUltimoPaso,
    required this.onContinuar,
    required this.onSaltar,
  });

  final String titulo;
  final String mensaje;
  final bool esUltimoPaso;
  final VoidCallback onContinuar;
  final VoidCallback onSaltar;

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colores.primaryContainer,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colores.primary, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.explore_outlined, size: 18, color: colores.onPrimaryContainer),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  titulo,
                  style: TextStyle(fontWeight: FontWeight.bold, color: colores.onPrimaryContainer),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(mensaje, style: TextStyle(fontSize: 13, color: colores.onPrimaryContainer)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: onSaltar, child: const Text('Saltar recorrido')),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: onContinuar,
                icon: Icon(esUltimoPaso ? Icons.check : Icons.arrow_forward, size: 16),
                label: Text(esUltimoPaso ? 'Entendido, terminar' : 'Entendido, continuar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
