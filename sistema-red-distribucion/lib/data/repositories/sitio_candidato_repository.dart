import 'package:drift/drift.dart' show Value;

import '../local/database.dart';
import '../models/sitio_candidato.dart';

class SitioCandidatoRepository {
  SitioCandidatoRepository(this._database);

  final AppDatabase _database;

  Future<List<SitioCandidato>> obtenerPorProyecto(int proyectoId) async {
    final filas =
        await (_database.select(_database.sitioCandidatoTable)
              ..where((t) => t.proyectoId.equals(proyectoId)))
            .get();
    return filas.map(_aDominio).toList();
  }

  Future<int> crear(SitioCandidato sitio) {
    return _database
        .into(_database.sitioCandidatoTable)
        .insert(
          SitioCandidatoTableCompanion.insert(
            proyectoId: sitio.proyectoId,
            nombre: sitio.nombre,
            latitud: sitio.latitud,
            longitud: sitio.longitud,
            costoFijoAnualCent: sitio.costoFijoAnualCent,
            capacidadAnual: sitio.capacidadAnual,
            costoVariableManejoCentPorUnidad:
                sitio.costoVariableManejoCentPorUnidad,
            origen: sitio.origen,
            esRedActual: Value(sitio.esRedActual),
          ),
        );
  }

  Future<void> actualizar(SitioCandidato sitio) async {
    await (_database.update(
      _database.sitioCandidatoTable,
    )..where((t) => t.id.equals(sitio.id!))).write(
      SitioCandidatoTableCompanion(
        nombre: Value(sitio.nombre),
        latitud: Value(sitio.latitud),
        longitud: Value(sitio.longitud),
        costoFijoAnualCent: Value(sitio.costoFijoAnualCent),
        capacidadAnual: Value(sitio.capacidadAnual),
        costoVariableManejoCentPorUnidad: Value(
          sitio.costoVariableManejoCentPorUnidad,
        ),
        origen: Value(sitio.origen),
        esRedActual: Value(sitio.esRedActual),
      ),
    );
  }

  Future<void> eliminar(int id) async {
    await (_database.delete(
      _database.sitioCandidatoTable,
    )..where((t) => t.id.equals(id))).go();
  }

  SitioCandidato _aDominio(SitioCandidatoTableData fila) => SitioCandidato(
    id: fila.id,
    proyectoId: fila.proyectoId,
    nombre: fila.nombre,
    latitud: fila.latitud,
    longitud: fila.longitud,
    costoFijoAnualCent: fila.costoFijoAnualCent,
    capacidadAnual: fila.capacidadAnual,
    costoVariableManejoCentPorUnidad: fila.costoVariableManejoCentPorUnidad,
    origen: fila.origen,
    esRedActual: fila.esRedActual,
  );
}
