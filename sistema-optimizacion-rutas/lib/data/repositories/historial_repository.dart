import 'dart:convert';

import 'package:drift/drift.dart';

import '../local/database.dart';
import '../models/escenario_optimizacion.dart';
import '../models/historial_calculo.dart';

/// Repositorio del historial de cálculos: cada entrada es un snapshot
/// inmutable (ver comentario en `database.dart` sobre `HistorialCalculoTable`)
/// — nunca depende de datos en vivo de depósito/punto de entrega/vehículo.
class HistorialRepository {
  HistorialRepository(this._database);

  final AppDatabase _database;

  Future<int> guardar(HistorialCalculo calculo) {
    return _database.transaction(() async {
      final idCalculo = await _database
          .into(_database.historialCalculoTable)
          .insert(
            HistorialCalculoTableCompanion.insert(
              fechaCalculo: calculo.fechaCalculo.toIso8601String(),
              metodo: calculo.metodo.valor,
              depositoNombre: calculo.depositoNombre,
              depositoLatitud: calculo.depositoLatitud,
              depositoLongitud: calculo.depositoLongitud,
              vehiculosFaltantes: Value(calculo.vehiculosFaltantes),
              distanciaTotalMetros: Value(calculo.distanciaTotalMetros),
              cantidadRutas: Value(calculo.cantidadRutas),
            ),
          );

      for (final ruta in calculo.rutas) {
        await _database
            .into(_database.historialRutaTable)
            .insert(
              HistorialRutaTableCompanion.insert(
                historialId: idCalculo,
                orden: ruta.orden,
                vehiculoNombre: Value(ruta.vehiculoNombre),
                vehiculoCapacidadMaxima: Value(ruta.vehiculoCapacidadMaxima),
                vehiculoCostoEstimadoPorKm: Value(
                  ruta.vehiculoCostoEstimadoPorKm,
                ),
                vehiculoTipoFlota: Value(ruta.vehiculoTipoFlota),
                paradasJson: jsonEncode(
                  ruta.paradas.map((p) => p.toJson()).toList(),
                ),
                distanciaMetros: Value(ruta.distanciaMetros),
                duracionSegundos: Value(ruta.duracionSegundos),
                distanciasPorTramoMetros: jsonEncode(
                  ruta.distanciasPorTramoMetros,
                ),
                geometriaPolyline: Value(ruta.geometriaPolyline),
              ),
            );
      }

      return idCalculo;
    });
  }

  Future<List<HistorialCalculo>> listarResumenes() async {
    final filas =
        await (_database.select(_database.historialCalculoTable)..orderBy([
              (t) => OrderingTerm.desc(t.fechaCalculo),
            ]))
            .get();
    return filas.map(_encabezadoADominio).toList();
  }

  Future<HistorialCalculo?> obtenerDetalle(int id) async {
    final encabezado = await (_database.select(
      _database.historialCalculoTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (encabezado == null) return null;

    final filasRutas =
        await (_database.select(_database.historialRutaTable)
              ..where((t) => t.historialId.equals(id))
              ..orderBy([(t) => OrderingTerm.asc(t.orden)]))
            .get();

    return _encabezadoADominio(
      encabezado,
      rutas: filasRutas.map(_rutaADominio).toList(),
    );
  }

  Future<void> eliminar(int id) async {
    await _database.transaction(() async {
      await (_database.delete(
        _database.historialRutaTable,
      )..where((t) => t.historialId.equals(id))).go();
      await (_database.delete(
        _database.historialCalculoTable,
      )..where((t) => t.id.equals(id))).go();
    });
  }

  HistorialCalculo _encabezadoADominio(
    HistorialCalculoTableData fila, {
    List<HistorialRuta> rutas = const [],
  }) => HistorialCalculo(
    id: fila.id,
    fechaCalculo: DateTime.parse(fila.fechaCalculo),
    metodo: MetodoOptimizacionValor.desdeValor(fila.metodo),
    depositoNombre: fila.depositoNombre,
    depositoLatitud: fila.depositoLatitud,
    depositoLongitud: fila.depositoLongitud,
    vehiculosFaltantes: fila.vehiculosFaltantes,
    distanciaTotalMetros: fila.distanciaTotalMetros,
    cantidadRutas: fila.cantidadRutas,
    rutas: rutas,
  );

  HistorialRuta _rutaADominio(HistorialRutaTableData fila) => HistorialRuta(
    id: fila.id,
    orden: fila.orden,
    vehiculoNombre: fila.vehiculoNombre,
    vehiculoCapacidadMaxima: fila.vehiculoCapacidadMaxima,
    vehiculoCostoEstimadoPorKm: fila.vehiculoCostoEstimadoPorKm,
    vehiculoTipoFlota: fila.vehiculoTipoFlota,
    paradas: (jsonDecode(fila.paradasJson) as List)
        .map((p) => ParadaSnapshot.fromJson(p as Map<String, dynamic>))
        .toList(),
    distanciaMetros: fila.distanciaMetros,
    duracionSegundos: fila.duracionSegundos,
    distanciasPorTramoMetros: (jsonDecode(fila.distanciasPorTramoMetros) as List)
        .map((d) => (d as num).toDouble())
        .toList(),
    geometriaPolyline: fila.geometriaPolyline,
  );
}
