import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/optimizacion_servicio_provider.dart';
import '../../providers/taguchi_provider.dart';
import 'nivel_servicio_tab.dart';
import 'taguchi_tab.dart';

/// Contenedor de las calculadoras de nivel de servicio óptimo (M4) y
/// función de pérdida de Taguchi (M5), cada una en su propia pestaña.
class OptimizacionServicioScreen extends StatefulWidget {
  const OptimizacionServicioScreen({super.key});

  @override
  State<OptimizacionServicioScreen> createState() =>
      _OptimizacionServicioScreenState();
}

class _OptimizacionServicioScreenState
    extends State<OptimizacionServicioScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OptimizacionServicioProvider>().cargarConfiguracion();
    context.read<TaguchiProvider>().cargarConfiguracion();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Optimización del servicio'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Nivel de servicio'),
              Tab(text: 'Taguchi'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [NivelServicioTab(), TaguchiTab()],
        ),
      ),
    );
  }
}
