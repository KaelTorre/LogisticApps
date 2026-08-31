import 'package:paquete_geo_logistica/paquete_geo_logistica.dart';

import 'database.dart';

/// Implementación de [CacheRuteo] (paquete_geo_logistica) contra la tabla
/// `cache_ruteo` de esta app — lo que permite a [OsrmClient] cachear sin
/// conocer drift.
class CacheRuteoDrift implements CacheRuteo {
  CacheRuteoDrift(this._database);

  final AppDatabase _database;

  @override
  Future<String?> leer(String hashConsulta) async {
    final fila =
        await (_database.select(_database.cacheRuteoTable)
              ..where((t) => t.hashConsulta.equals(hashConsulta)))
            .getSingleOrNull();
    return fila?.respuestaJson;
  }

  @override
  Future<void> guardar(
    String hashConsulta,
    String tipo,
    String respuestaJson,
  ) async {
    await _database
        .into(_database.cacheRuteoTable)
        .insertOnConflictUpdate(
          CacheRuteoTableCompanion.insert(
            hashConsulta: hashConsulta,
            tipo: tipo,
            respuestaJson: respuestaJson,
            fechaConsulta: DateTime.now().toIso8601String(),
          ),
        );
  }
}
