import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/estado/organizacion_activa.dart';
import 'core/theme.dart';
import 'data/local/database.dart';
import 'data/repositories/accion_catalogo_repository.dart';
import 'data/repositories/accion_tomada_repository.dart';
import 'data/repositories/diagnostico_organizacional_repository.dart';
import 'data/repositories/escenario_sintetico_repository.dart';
import 'data/repositories/evaluacion_repository.dart';
import 'data/repositories/factura_transporte_repository.dart';
import 'data/repositories/indicador_repository.dart';
import 'data/repositories/medicion_repository.dart';
import 'data/repositories/memoria_evaluacion_repository.dart';
import 'data/repositories/organizacion_repository.dart';
import 'data/repositories/periodo_repository.dart';
import 'data/repositories/presupuesto_repository.dart';
import 'data/repositories/regla_accion_repository.dart';
import 'data/repositories/regla_patron_repository.dart';
import 'data/repositories/verificacion_accion_repository.dart';
import 'ui/pantallas/inicio/inicio_screen.dart';

void main() {
  final database = AppDatabase();

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: database),
        Provider<OrganizacionRepository>(create: (_) => OrganizacionRepository(database)),
        Provider<PeriodoRepository>(create: (_) => PeriodoRepository(database)),
        Provider<IndicadorRepository>(create: (_) => IndicadorRepository(database)),
        Provider<MedicionRepository>(create: (_) => MedicionRepository(database)),
        Provider<ReglaPatronRepository>(create: (_) => ReglaPatronRepository(database)),
        Provider<EvaluacionRepository>(create: (_) => EvaluacionRepository(database)),
        Provider<MemoriaEvaluacionRepository>(create: (_) => MemoriaEvaluacionRepository(database)),
        Provider<AccionCatalogoRepository>(create: (_) => AccionCatalogoRepository(database)),
        Provider<ReglaAccionRepository>(create: (_) => ReglaAccionRepository(database)),
        Provider<AccionTomadaRepository>(create: (_) => AccionTomadaRepository(database)),
        Provider<VerificacionAccionRepository>(create: (_) => VerificacionAccionRepository(database)),
        Provider<PresupuestoRepository>(create: (_) => PresupuestoRepository(database)),
        Provider<EscenarioSinteticoRepository>(create: (_) => EscenarioSinteticoRepository(database)),
        Provider<DiagnosticoOrganizacionalRepository>(
          create: (_) => DiagnosticoOrganizacionalRepository(database),
        ),
        Provider<FacturaTransporteRepository>(create: (_) => FacturaTransporteRepository(database)),
        ChangeNotifierProvider<OrganizacionActiva>(create: (_) => OrganizacionActiva()),
      ],
      child: const SistemaControlLogisticoApp(),
    ),
  );
}

class SistemaControlLogisticoApp extends StatelessWidget {
  const SistemaControlLogisticoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema de Control Logístico',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: ThemeMode.system,
      home: const InicioScreen(),
    );
  }
}
