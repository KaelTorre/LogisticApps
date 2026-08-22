import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/tour/tour_controller.dart';
import 'data/local/database.dart';
import 'data/seed/catalogo_seed_loader.dart';
import 'ui/pantallas/entrada_calculo/entrada_calculo_screen.dart';

void main() {
  runApp(const _RaizApp());
}

/// Abre la base, siembra el catálogo e inicializa el `TourController` antes
/// de mostrar cualquier pantalla. `CatalogoSeedLoader.cargar()` es
/// idempotente (CLAUDE.md sección 6): se puede llamar en cada arranque sin
/// duplicar filas ni pisar lo que agregó el usuario.
///
/// El `ChangeNotifierProvider` envuelve el propio `MaterialApp`, no solo
/// `home`: un provider colocado adentro de `home` queda encerrado en el
/// contenido de la primera ruta del `Navigator` (cada ruta empujada después
/// vive en una entrada hermana del mismo `Overlay`, no descendiente de la
/// primera), así que `FichaResultadoScreen` y `PlanoScreen` — alcanzadas
/// con `Navigator.push` — no lo verían.
class _RaizApp extends StatefulWidget {
  const _RaizApp();

  @override
  State<_RaizApp> createState() => _RaizAppState();
}

class _RaizAppState extends State<_RaizApp> {
  late final AppDatabase _db;
  late final Future<TourController> _inicializacion;

  @override
  void initState() {
    super.initState();
    _db = AppDatabase();
    _inicializacion = _inicializar();
  }

  Future<TourController> _inicializar() async {
    await CatalogoSeedLoader(_db).cargar();
    final prefs = await SharedPreferences.getInstance();
    return TourController(prefs);
  }

  @override
  void dispose() {
    _db.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TourController>(
      future: _inicializacion,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }
        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(child: Text('No se pudo cargar el catálogo: ${snapshot.error}')),
            ),
          );
        }
        return ChangeNotifierProvider.value(
          value: snapshot.data!,
          child: MaterialApp(
            title: 'Sistema de Diseño de Almacenes',
            theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo)),
            home: EntradaCalculoScreen(db: _db),
          ),
        );
      },
    );
  }
}
