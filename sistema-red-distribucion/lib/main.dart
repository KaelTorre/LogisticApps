import 'dart:io';

import 'package:flutter/material.dart';
import 'package:paquete_geo_logistica/paquete_geo_logistica.dart';
import 'package:provider/provider.dart';

import 'core/estado/proyecto_activo.dart';
import 'core/theme.dart';
import 'data/local/cache_ruteo_drift.dart';
import 'data/local/database.dart';
import 'data/repositories/celda_matriz_repository.dart';
import 'data/repositories/cliente_repository.dart';
import 'data/repositories/cliente_zona_repository.dart';
import 'data/repositories/escenario_almacen_repository.dart';
import 'data/repositories/escenario_asignacion_repository.dart';
import 'data/repositories/escenario_costo_repository.dart';
import 'data/repositories/escenario_repository.dart';
import 'data/repositories/memoria_calculo_repository.dart';
import 'data/repositories/parametros_costo_repository.dart';
import 'data/repositories/planta_repository.dart';
import 'data/repositories/proyecto_repository.dart';
import 'data/repositories/punto_curva_repository.dart';
import 'data/repositories/sitio_candidato_repository.dart';
import 'data/repositories/zona_demanda_repository.dart';
import 'ui/pantallas/proyectos/proyectos_screen.dart';

void main() {
  // Agrega raíces de CA explícitas (ver trusted_certs_http_overrides.dart en
  // el paquete compartido) a todo HttpClient que se cree en la app — sin
  // esto, un equipo Windows con el almacén de certificados del sistema
  // incompleto ve fallar M3 (Fase 4, consultas reales a OSRM) aunque el
  // navegador funcione bien. Mismo fix que sistema-optimizacion-rutas.
  HttpOverrides.global = TrustedRootsHttpOverrides();

  final database = AppDatabase();

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: database),
        Provider<OsrmClient>(
          create: (_) => OsrmClient(cache: CacheRuteoDrift(database)),
          dispose: (_, cliente) => cliente.dispose(),
        ),
        Provider<ProyectoRepository>(create: (_) => ProyectoRepository(database)),
        Provider<ClienteRepository>(create: (_) => ClienteRepository(database)),
        Provider<ZonaDemandaRepository>(create: (_) => ZonaDemandaRepository(database)),
        Provider<ClienteZonaRepository>(create: (_) => ClienteZonaRepository(database)),
        Provider<SitioCandidatoRepository>(create: (_) => SitioCandidatoRepository(database)),
        Provider<PlantaRepository>(create: (_) => PlantaRepository(database)),
        Provider<ParametrosCostoRepository>(create: (_) => ParametrosCostoRepository(database)),
        Provider<CeldaMatrizRepository>(create: (_) => CeldaMatrizRepository(database)),
        Provider<EscenarioRepository>(create: (_) => EscenarioRepository(database)),
        Provider<EscenarioAlmacenRepository>(create: (_) => EscenarioAlmacenRepository(database)),
        Provider<EscenarioAsignacionRepository>(
          create: (_) => EscenarioAsignacionRepository(database),
        ),
        Provider<EscenarioCostoRepository>(create: (_) => EscenarioCostoRepository(database)),
        Provider<PuntoCurvaRepository>(create: (_) => PuntoCurvaRepository(database)),
        Provider<MemoriaCalculoRepository>(create: (_) => MemoriaCalculoRepository(database)),
        ChangeNotifierProvider<ProyectoActivo>(create: (_) => ProyectoActivo()),
      ],
      child: const SistemaRedDistribucionApp(),
    ),
  );
}

class SistemaRedDistribucionApp extends StatelessWidget {
  const SistemaRedDistribucionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema de Red de Distribución',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: ThemeMode.system,
      home: const ProyectosScreen(),
    );
  }
}
