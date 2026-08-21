import 'package:flutter/material.dart';

import 'data/local/database.dart';
import 'data/seed/catalogo_seed_loader.dart';
import 'ui/pantallas/entrada_calculo/entrada_calculo_screen.dart';

void main() {
  runApp(const SistemaDisenoAlmacenesApp());
}

class SistemaDisenoAlmacenesApp extends StatelessWidget {
  const SistemaDisenoAlmacenesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema de Diseño de Almacenes',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo)),
      home: const _RaizApp(),
    );
  }
}

/// Abre la base y siembra el catálogo antes de mostrar cualquier pantalla.
/// `CatalogoSeedLoader.cargar()` es idempotente (CLAUDE.md sección 6): se
/// puede llamar en cada arranque sin duplicar filas ni pisar lo que agregó
/// el usuario.
class _RaizApp extends StatefulWidget {
  const _RaizApp();

  @override
  State<_RaizApp> createState() => _RaizAppState();
}

class _RaizAppState extends State<_RaizApp> {
  late final AppDatabase _db;
  late final Future<void> _inicializacion;

  @override
  void initState() {
    super.initState();
    _db = AppDatabase();
    _inicializacion = CatalogoSeedLoader(_db).cargar();
  }

  @override
  void dispose() {
    _db.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _inicializacion,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('No se pudo cargar el catálogo: ${snapshot.error}')),
          );
        }
        return EntradaCalculoScreen(db: _db);
      },
    );
  }
}
