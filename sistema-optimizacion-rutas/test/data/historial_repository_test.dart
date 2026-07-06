import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_optimizacion_rutas/data/local/database.dart';
import 'package:sistema_optimizacion_rutas/data/models/escenario_optimizacion.dart';
import 'package:sistema_optimizacion_rutas/data/models/historial_calculo.dart';
import 'package:sistema_optimizacion_rutas/data/repositories/historial_repository.dart';

HistorialCalculo _calculoDeEjemplo() => HistorialCalculo(
  fechaCalculo: DateTime(2026, 7, 6, 10, 30),
  metodo: MetodoOptimizacion.ahorros,
  depositoNombre: 'Oficina',
  depositoLatitud: -8.375482,
  depositoLongitud: -74.556342,
  vehiculosFaltantes: 1,
  distanciaTotalMetros: 5230.4,
  cantidadRutas: 1,
  rutas: const [
    HistorialRuta(
      orden: 0,
      vehiculoNombre: 'Camión 1',
      vehiculoCapacidadMaxima: 1200,
      vehiculoCostoEstimadoPorKm: 2.2,
      vehiculoTipoFlota: 'propia',
      paradas: [
        ParadaSnapshot(
          nombre: 'Cliente A',
          latitud: -8.394832,
          longitud: -74.577328,
          demanda: 45,
        ),
        ParadaSnapshot(
          nombre: 'Cliente B',
          latitud: -8.385646,
          longitud: -74.574080,
          demanda: 60,
        ),
      ],
      // 3 tramos para 2 paradas: depósito→A, A→B, B→depósito (regreso).
      distanciasPorTramoMetros: [3000.0, 1500.0, 730.4],
      distanciaMetros: 5230.4,
      duracionSegundos: 612.1,
      geometriaPolyline: 'encoded_polyline',
    ),
  ],
);

void main() {
  late AppDatabase database;
  late HistorialRepository repositorio;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repositorio = HistorialRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('guardar + listarResumenes: el resumen no trae rutas', () async {
    await repositorio.guardar(_calculoDeEjemplo());

    final resumenes = await repositorio.listarResumenes();

    expect(resumenes, hasLength(1));
    expect(resumenes.first.depositoNombre, 'Oficina');
    expect(resumenes.first.metodo, MetodoOptimizacion.ahorros);
    expect(resumenes.first.cantidadRutas, 1);
    expect(resumenes.first.rutas, isEmpty);
  });

  test('listarResumenes ordena por fecha descendente', () async {
    final antiguo = _calculoDeEjemplo();
    final reciente = HistorialCalculo(
      fechaCalculo: DateTime(2026, 7, 6, 12),
      metodo: MetodoOptimizacion.barrido,
      depositoNombre: 'Sucursal 2',
      depositoLatitud: 0,
      depositoLongitud: 0,
      vehiculosFaltantes: 0,
      distanciaTotalMetros: 100,
      cantidadRutas: 0,
    );

    await repositorio.guardar(antiguo);
    await repositorio.guardar(reciente);

    final resumenes = await repositorio.listarResumenes();

    expect(resumenes, hasLength(2));
    expect(resumenes.first.depositoNombre, 'Sucursal 2');
  });

  test(
    'obtenerDetalle recupera las rutas con sus paradas y tramos exactos',
    () async {
      final id = await repositorio.guardar(_calculoDeEjemplo());

      final detalle = await repositorio.obtenerDetalle(id);

      expect(detalle, isNotNull);
      expect(detalle!.rutas, hasLength(1));
      final ruta = detalle.rutas.single;
      expect(ruta.vehiculoNombre, 'Camión 1');
      expect(ruta.paradas, hasLength(2));
      expect(ruta.paradas[0].nombre, 'Cliente A');
      expect(ruta.paradas[1].demanda, 60);
      // El tramo de regreso al depósito debe sobrevivir el round-trip.
      expect(ruta.distanciasPorTramoMetros, [3000.0, 1500.0, 730.4]);
      expect(ruta.geometriaPolyline, 'encoded_polyline');
    },
  );

  test('obtenerDetalle con un id inexistente devuelve null', () async {
    final detalle = await repositorio.obtenerDetalle(999);
    expect(detalle, isNull);
  });

  test('eliminar borra el encabezado y sus rutas', () async {
    final id = await repositorio.guardar(_calculoDeEjemplo());

    await repositorio.eliminar(id);

    expect(await repositorio.obtenerDetalle(id), isNull);
    expect(await repositorio.listarResumenes(), isEmpty);
  });
}
