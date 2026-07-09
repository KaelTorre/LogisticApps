import 'package:drift/drift.dart' show Value;

import '../../core/constants.dart';
import '../local/database.dart';
import '../models/configuracion_sla.dart';

/// `configuracion_sla` se trata como singleton lógico: siempre hay como
/// máximo una fila, gestionada íntegramente por este repositorio.
class ConfiguracionRepository {
  ConfiguracionRepository(this._database);

  final AppDatabase _database;

  /// Envuelto en una transacción a propósito: `OptimizacionServicioScreen`
  /// dispara `OptimizacionServicioProvider.cargarConfiguracion()` y
  /// `TaguchiProvider.cargarConfiguracion()` en paralelo desde
  /// `initState`, y ambos llaman este método. Sin la transacción, las dos
  /// llamadas pueden intercalarse: ambas ven la tabla vacía antes de que
  /// cualquiera inserte, y las dos terminan insertando una fila default
  /// ("check-then-act" clásico) — se vio en producción como un crash
  /// ("Bad state: Too many elements") en `getSingleOrNull()` al haber más
  /// de una fila. `transaction()` serializa esta llamada respecto a
  /// cualquier otra transacción concurrente en la misma conexión.
  /// `limit(1)` además hace la lectura tolerante a duplicados que ya
  /// hayan quedado insertados por este bug antes del fix.
  Future<ConfiguracionSla> obtenerOCrearPorDefecto() async {
    return _database.transaction(() async {
      final existente = await (_database.select(
        _database.configuracionSlaTable,
      )..limit(1)).getSingleOrNull();
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
    });
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
