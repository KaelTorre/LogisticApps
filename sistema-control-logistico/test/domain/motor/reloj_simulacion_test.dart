import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_control_logistico/data/local/database.dart';
import 'package:sistema_control_logistico/data/models/indicador.dart';
import 'package:sistema_control_logistico/data/models/medicion.dart';
import 'package:sistema_control_logistico/data/models/organizacion.dart';
import 'package:sistema_control_logistico/data/models/periodo.dart';
import 'package:sistema_control_logistico/data/repositories/indicador_repository.dart';
import 'package:sistema_control_logistico/data/repositories/medicion_repository.dart';
import 'package:sistema_control_logistico/data/repositories/organizacion_repository.dart';
import 'package:sistema_control_logistico/data/repositories/periodo_repository.dart';
import 'package:sistema_control_logistico/domain/motor/evaluador_serie.dart';
import 'package:sistema_control_logistico/domain/motor/m1_reglas_patron.dart';
import 'package:sistema_control_logistico/domain/motor/reloj_simulacion.dart';

/// Fase 7 (CLAUDE.md): Test P (reversibilidad), Test Q (coherencia) y
/// Test R (el reloj no toca los datos) -- sobre la serie de referencia.
void main() {
  const meta = 1.20;
  const bandaInferior = 1.104;
  const bandaSuperior = 1.296;
  const serieReferencia = [1.18, 1.33, 1.21, 1.24, 1.26, 1.28, 1.29, 1.29, 1.28, 1.29, 1.31, 1.34];

  const indicador = ConfigIndicadorMotor(
    meta: meta,
    bandaInferior: bandaInferior,
    bandaSuperior: bandaSuperior,
    sentido: 'menor_mejor',
  );

  final serie = [
    for (var i = 0; i < serieReferencia.length; i++) PuntoSerieMotor(orden: i + 1, valor: serieReferencia[i]),
  ];

  test('Test P — avanzar n y retroceder n deja el estado exactamente igual al inicial', () {
    final reloj = RelojSimulacion(serie: serie, indicador: indicador);
    final estadoInicial = reloj.estadoActual;
    final indiceInicial = reloj.indiceActual;

    for (var i = 0; i < 6; i++) {
      reloj.avanzar();
    }
    for (var i = 0; i < 6; i++) {
      reloj.retroceder();
    }

    expect(reloj.indiceActual, indiceInicial);
    expect(reloj.estadoActual.periodo, estadoInicial.periodo);
    expect(reloj.estadoActual.clasificacion.clasificacion, estadoInicial.clasificacion.clasificacion);
    expect(reloj.estadoActual.clasificacion.estado, estadoInicial.clasificacion.estado);
    expect(
      reloj.estadoActual.reglas.map((r) => '${r.codigo}:${r.resultado}').toList(),
      estadoInicial.reglas.map((r) => '${r.codigo}:${r.resultado}').toList(),
    );
  });

  test('Test P (variante) — avanzar hasta el final y retroceder hasta el principio es reversible en cada paso', () {
    final reloj = RelojSimulacion(serie: serie, indicador: indicador);
    final estadosDeIda = <String>[];
    while (reloj.puedeAvanzar) {
      estadosDeIda.add(reloj.estadoActual.clasificacion.clasificacion);
      reloj.avanzar();
    }
    estadosDeIda.add(reloj.estadoActual.clasificacion.clasificacion);

    final estadosDeVuelta = <String>[reloj.estadoActual.clasificacion.clasificacion];
    while (reloj.puedeRetroceder) {
      reloj.retroceder();
      estadosDeVuelta.insert(0, reloj.estadoActual.clasificacion.clasificacion);
    }

    expect(estadosDeVuelta, estadosDeIda);
  });

  test('Test Q — el estado en el periodo t coincide con evaluar hasta t de forma aislada', () {
    final reloj = RelojSimulacion(serie: serie, indicador: indicador);
    for (var i = 0; i < 6; i++) {
      reloj.avanzar();
    }
    expect(reloj.indiceActual, 7);

    final aislado = evaluarHastaIndice(serie, indicador, 7);

    expect(reloj.estadoActual.clasificacion.clasificacion, aislado.clasificacion.clasificacion);
    expect(reloj.estadoActual.clasificacion.estado, aislado.clasificacion.estado);
    expect(reloj.estadoActual.periodo, 7);

    // Y coincide con lo ya confirmado en la Fase 4 (Test G) a mano: en el
    // periodo 7, R4 dispara sola y clasifica ajuste_menor / desviación.
    expect(reloj.estadoActual.clasificacion.clasificacion, 'ajuste_menor');
    expect(reloj.estadoActual.clasificacion.estado, 'desviacion');
    final disparadas = reloj.estadoActual.reglas.where((r) => r.disparada).map((r) => r.codigo).toSet();
    expect(disparadas, {'R4'});
  });

  test('reiniciar vuelve exactamente al primer periodo', () {
    final reloj = RelojSimulacion(serie: serie, indicador: indicador);
    for (var i = 0; i < 8; i++) {
      reloj.avanzar();
    }
    reloj.reiniciar();

    expect(reloj.indiceActual, 1);
    expect(reloj.estadoActual.periodo, 1);
    expect(reloj.puedeRetroceder, isFalse);
  });

  test('no se puede avanzar más allá del último periodo ni retroceder antes del primero', () {
    final reloj = RelojSimulacion(serie: serie, indicador: indicador);
    expect(reloj.puedeRetroceder, isFalse);
    reloj.retroceder(); // no-op
    expect(reloj.indiceActual, 1);

    for (var i = 0; i < 100; i++) {
      reloj.avanzar();
    }
    expect(reloj.indiceActual, serie.length);
    expect(reloj.puedeAvanzar, isFalse);
  });

  test('Test R — avanzar y retroceder el reloj no crea, modifica ni borra mediciones', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final organizacionId = await OrganizacionRepository(
      database,
    ).crear(const Organizacion(nombre: 'Org', tipoEmpresa: 'manufacturera'));
    final indicadorId = await IndicadorRepository(database).crear(
      Indicador(
        organizacionId: organizacionId,
        codigo: 'IND-1',
        nombre: 'Indicador 1',
        categoria: 'costo',
        unidad: 'S/',
        sentido: 'menor_mejor',
        meta: meta,
        bandaInferior: bandaInferior,
        bandaSuperior: bandaSuperior,
        granularidad: 'mensual',
        proceso: 'Transporte',
      ),
    );

    final periodoRepo = PeriodoRepository(database);
    final medicionRepo = MedicionRepository(database);
    for (var i = 0; i < serieReferencia.length; i++) {
      final periodoId = await periodoRepo.crear(
        Periodo(
          organizacionId: organizacionId,
          orden: i + 1,
          etiqueta: 'Periodo ${i + 1}',
          fechaInicio: '2026-01-01',
          fechaFin: '2026-01-31',
          granularidad: 'mensual',
        ),
      );
      await medicionRepo.crear(
        Medicion(indicadorId: indicadorId, periodoId: periodoId, valor: serieReferencia[i], origen: 'manual'),
      );
    }

    final medicionesAntes = await medicionRepo.obtenerPorIndicador(indicadorId);
    final valoresAntes = medicionesAntes.map((m) => '${m.periodoId}:${m.valor}:${m.origen}').toSet();

    // La pantalla carga la serie una sola vez (como exige CLAUDE.md sección
    // 11) y de ahí en adelante el reloj solo trabaja en memoria.
    final serieCargada = [
      for (final m in medicionesAntes) PuntoSerieMotor(orden: m.periodoId, valor: m.valor),
    ]..sort((a, b) => a.orden.compareTo(b.orden));
    final reloj = RelojSimulacion(serie: serieCargada, indicador: indicador);

    for (var i = 0; i < 20; i++) {
      reloj.avanzar();
      reloj.estadoActual; // fuerza el recálculo, como haría la pantalla
    }
    for (var i = 0; i < 20; i++) {
      reloj.retroceder();
      reloj.estadoActual;
    }
    reloj.reiniciar();

    final medicionesDespues = await medicionRepo.obtenerPorIndicador(indicadorId);
    final valoresDespues = medicionesDespues.map((m) => '${m.periodoId}:${m.valor}:${m.origen}').toSet();

    expect(medicionesDespues.length, medicionesAntes.length);
    expect(valoresDespues, valoresAntes);

    await database.close();
  });
}
