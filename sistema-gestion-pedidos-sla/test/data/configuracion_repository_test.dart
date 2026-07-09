import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_gestion_pedidos_sla/data/local/database.dart';
import 'package:sistema_gestion_pedidos_sla/data/repositories/configuracion_repository.dart';

void main() {
  late AppDatabase database;
  late ConfiguracionRepository repositorio;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repositorio = ConfiguracionRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('obtenerOCrearPorDefecto devuelve los mismos valores default en cada llamada', () async {
    final primera = await repositorio.obtenerOCrearPorDefecto();
    final segunda = await repositorio.obtenerOCrearPorDefecto();

    expect(primera.id, segunda.id);
    expect(segunda.coeficienteIngreso, 0.5);
    expect(segunda.coeficienteCosto, 0.00055);
  });

  test(
    'llamadas concurrentes (dos providers en el mismo initState) no duplican la fila',
    () async {
      // Reproduce la condición de carrera real: OptimizacionServicioScreen
      // dispara cargarConfiguracion() en dos providers sin esperar uno a
      // otro, y ambos llaman obtenerOCrearPorDefecto() casi al mismo tiempo.
      final resultados = await Future.wait([
        repositorio.obtenerOCrearPorDefecto(),
        repositorio.obtenerOCrearPorDefecto(),
      ]);

      expect(resultados[0].id, resultados[1].id);

      final filas = await database.select(database.configuracionSlaTable).get();
      expect(filas, hasLength(1));
    },
  );
}
