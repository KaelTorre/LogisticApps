import '../local/database.dart';
import '../models/parametros_costo.dart';

/// Un registro por proyecto (constraint `uniqueKeys` en la tabla) — de ahí
/// `obtenerPorProyecto`/`guardar` en vez de un CRUD por id.
class ParametrosCostoRepository {
  ParametrosCostoRepository(this._database);

  final AppDatabase _database;

  Future<ParametrosCosto?> obtenerPorProyecto(int proyectoId) async {
    final fila =
        await (_database.select(_database.parametrosCostoTable)
              ..where((t) => t.proyectoId.equals(proyectoId)))
            .getSingleOrNull();
    return fila == null ? null : _aDominio(fila);
  }

  /// Inserta o reemplaza los parámetros de costo del proyecto. `id` es
  /// autoincrement y `proyectoId` solo tiene un constraint UNIQUE (no es la
  /// primary key), así que `insertOnConflictUpdate` no sirve acá — resuelve
  /// conflictos contra la primary key, no contra un UNIQUE secundario.
  Future<void> guardar(ParametrosCosto parametros) async {
    final companion = ParametrosCostoTableCompanion.insert(
      proyectoId: parametros.proyectoId,
      tarifaEntradaFijaCent: parametros.tarifaEntradaFijaCent,
      tarifaEntradaCentPorKmTon: parametros.tarifaEntradaCentPorKmTon,
      tarifaSalidaFijaCent: parametros.tarifaSalidaFijaCent,
      tarifaSalidaCentPorKmTon: parametros.tarifaSalidaCentPorKmTon,
      tasaManejoInventarioAnual: parametros.tasaManejoInventarioAnual,
      valorPorUnidadCent: parametros.valorPorUnidadCent,
      inventarioBaseUnaUbicacion: parametros.inventarioBaseUnaUbicacion,
      costoPorPedidoCent: parametros.costoPorPedidoCent,
      tipoEstandar: parametros.tipoEstandar,
      estandarServicioValor: parametros.estandarServicioValor,
    );

    final existente = await obtenerPorProyecto(parametros.proyectoId);
    if (existente == null) {
      await _database.into(_database.parametrosCostoTable).insert(companion);
    } else {
      await (_database.update(
        _database.parametrosCostoTable,
      )..where((t) => t.id.equals(existente.id!))).write(companion);
    }
  }

  Future<void> eliminarPorProyecto(int proyectoId) async {
    await (_database.delete(
      _database.parametrosCostoTable,
    )..where((t) => t.proyectoId.equals(proyectoId))).go();
  }

  ParametrosCosto _aDominio(ParametrosCostoTableData fila) => ParametrosCosto(
    id: fila.id,
    proyectoId: fila.proyectoId,
    tarifaEntradaFijaCent: fila.tarifaEntradaFijaCent,
    tarifaEntradaCentPorKmTon: fila.tarifaEntradaCentPorKmTon,
    tarifaSalidaFijaCent: fila.tarifaSalidaFijaCent,
    tarifaSalidaCentPorKmTon: fila.tarifaSalidaCentPorKmTon,
    tasaManejoInventarioAnual: fila.tasaManejoInventarioAnual,
    valorPorUnidadCent: fila.valorPorUnidadCent,
    inventarioBaseUnaUbicacion: fila.inventarioBaseUnaUbicacion,
    costoPorPedidoCent: fila.costoPorPedidoCent,
    tipoEstandar: fila.tipoEstandar,
    estandarServicioValor: fila.estandarServicioValor,
  );
}
