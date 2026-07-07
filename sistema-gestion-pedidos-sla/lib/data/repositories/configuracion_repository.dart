import 'package:drift/drift.dart' show Value;

import '../../core/constants.dart';
import '../local/database.dart';
import '../models/configuracion_sla.dart';

/// `configuracion_sla` se trata como singleton lógico: siempre hay como
/// máximo una fila, gestionada íntegramente por este repositorio.
class ConfiguracionRepository {
  ConfiguracionRepository(this._database);

  final AppDatabase _database;

  Future<ConfiguracionSla> obtenerOCrearPorDefecto() async {
    final existente = await _database
        .select(_database.configuracionSlaTable)
        .getSingleOrNull();
    if (existente != null) return _aDominio(existente);

    final id = await _database.into(_database.configuracionSlaTable).insert(
          ConfiguracionSlaTableCompanion.insert(
            coeficienteIngreso: const Value(DefaultsSla.coeficienteIngreso),
            coeficienteCosto: const Value(DefaultsSla.coeficienteCosto),
          ),
        );

    return ConfiguracionSla(
      id: id,
      coeficienteIngreso: DefaultsSla.coeficienteIngreso,
      coeficienteCosto: DefaultsSla.coeficienteCosto,
    );
  }

  Future<void> actualizarCoeficientesSl(int id, double a, double b) async {
    await (_database.update(
      _database.configuracionSlaTable,
    )..where((t) => t.id.equals(id))).write(
      ConfiguracionSlaTableCompanion(
        coeficienteIngreso: Value(a),
        coeficienteCosto: Value(b),
      ),
    );
  }

  Future<void> actualizarParametrosTaguchi(int id, double k, double m) async {
    await (_database.update(
      _database.configuracionSlaTable,
    )..where((t) => t.id.equals(id))).write(
      ConfiguracionSlaTableCompanion(
        constanteK: Value(k),
        valorObjetivoM: Value(m),
      ),
    );
  }

  ConfiguracionSla _aDominio(ConfiguracionSlaTableData fila) => ConfiguracionSla(
        id: fila.id,
        coeficienteIngreso: fila.coeficienteIngreso,
        coeficienteCosto: fila.coeficienteCosto,
        valorObjetivoM: fila.valorObjetivoM,
        constanteK: fila.constanteK,
      );
}
