import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_diseno_almacenes/domain/motor/m2_posiciones.dart';
import 'package:sistema_diseno_almacenes/domain/motor/m7_anden.dart';
import 'package:sistema_diseno_almacenes/domain/motor/m8_comparador.dart';

EntradaEscenarioM8 _escenario({
  required String nombre,
  required String tipoSistema,
  required int factorFondo,
  required double factorHoneycomb,
}) {
  return EntradaEscenarioM8(
    nombre: nombre,
    tipoSistema: tipoSistema,
    factorFondo: factorFondo,
    factorHoneycomb: factorHoneycomb,
    anchoTarimaMm: 800,
    altoTarimaMm: 144,
    altoCargaMm: 1000,
    largoVigaMm: 1825,
    peralteVigaMm: 120,
    fondoBastidorMm: 1100,
    perfilAnchoBastidorMm: 100,
    holguraXMm: 75,
    holguraXMinimaNormaMm: 75,
    holguraYMm: 100,
    holguraYMinimaNormaMm: 100,
    pasoAjustePuntalMm: 50,
    alturaLibreMm: 10000,
    reservaTechoMm: 450,
    elevacionMaxEquipoMm: 9000,
    largoDisponibleMm: 30000,
    anchoPasilloMm: 2800,
    separacionEspaldaMm: 200,
    holguraMuroMm: 200,
    costoConstruccionPorM2: 500,
    costoEquipos: 50000,
  );
}

const _familias = [
  DemandaFamilia(
    nombre: 'Familia única',
    demandaAnual: 100000,
    rotacionAnual: 12,
    unidadesPorTarima: 40,
  ),
];

const _entradaAnden = EntradaM7(
  camionesHoraPico: 5,
  tiempoMedioServicioHoras: 0.5,
  esperaObjetivoHoras: 0.25,
  espaciamientoPuertaMm: 3600,
  patioMinMm: 18000,
  areaStagingPorPuertaMm2: 20000000,
);

void main() {
  group('M8 — comparador de escenarios', () {
    test('rechaza lista vacía de escenarios', () {
      expect(
        () => compararEscenarios(familias: _familias, escenarios: const [], entradaAnden: _entradaAnden),
        throwsArgumentError,
      );
    });

    test('selectivo vs. doble fondo: la densidad se paga con accesibilidad, nunca gratis', () {
      final resultado = compararEscenarios(
        familias: _familias,
        entradaAnden: _entradaAnden,
        escenarios: [
          _escenario(
            nombre: 'Selectivo',
            tipoSistema: 'selectivo',
            factorFondo: 1,
            factorHoneycomb: 0.20,
          ),
          _escenario(
            nombre: 'Doble fondo',
            tipoSistema: 'doble_fondo',
            factorFondo: 2,
            factorHoneycomb: 0.35,
          ),
        ],
      );

      expect(resultado.escenarios, hasLength(2));
      final selectivo = resultado.escenarios.firstWhere((e) => e.nombre == 'Selectivo');
      final dobleFondo = resultado.escenarios.firstWhere((e) => e.nombre == 'Doble fondo');

      // La accesibilidad siempre va pegada al resultado, nunca se omite.
      expect(selectivo.accesibilidad, 'Total: cada tarima es accesible directamente.');
      expect(dobleFondo.accesibilidad, contains('LIFO'));
      expect(dobleFondo.accesibilidad, isNot(selectivo.accesibilidad));

      // Factor de fondo 2 duplica la capacidad por módulo: para una demanda
      // igual, requiere menos módulos construidos que el selectivo aunque
      // pida más posiciones (más honeycomb).
      expect(dobleFondo.resultadoM3.posicionesModulo, 2 * selectivo.resultadoM3.posicionesModulo);
      expect(dobleFondo.resultadoM3.modulos, lessThan(selectivo.resultadoM3.modulos));

      // Propiedades de M3/layout (sección 12) que deben seguir cumpliéndose
      // también cuando se orquestan varios escenarios desde M8.
      for (final esc in resultado.escenarios) {
        expect(esc.posicionesInstaladas, greaterThanOrEqualTo(esc.resultadoM2.posicionesRequeridas));
        expect(esc.supConstruidaMm2, greaterThan(esc.layout.supRacksMm2));
        expect(esc.costoPorPosicion, greaterThan(0));
        expect(esc.inversionEstimada, greaterThan(0));
        expect(esc.memoria, isNotEmpty);
        expect(esc.memoria.any((f) => f.modulo == 'M8'), isTrue);
      }
    });

    test('ordena los escenarios por costo por posición ascendente', () {
      final resultado = compararEscenarios(
        familias: _familias,
        entradaAnden: _entradaAnden,
        escenarios: [
          _escenario(nombre: 'A', tipoSistema: 'selectivo', factorFondo: 1, factorHoneycomb: 0.20),
          _escenario(nombre: 'B', tipoSistema: 'drive_in', factorFondo: 4, factorHoneycomb: 0.35),
          _escenario(nombre: 'C', tipoSistema: 'doble_fondo', factorFondo: 2, factorHoneycomb: 0.30),
        ],
      );

      for (var i = 1; i < resultado.escenarios.length; i++) {
        expect(
          resultado.escenarios[i].costoPorPosicion,
          greaterThanOrEqualTo(resultado.escenarios[i - 1].costoPorPosicion),
        );
      }
    });

    test('tipo de sistema no documentado no falla, declara la ausencia', () {
      final resultado = compararEscenarios(
        familias: _familias,
        entradaAnden: _entradaAnden,
        escenarios: [
          _escenario(nombre: 'X', tipoSistema: 'inventado', factorFondo: 1, factorHoneycomb: 0.20),
        ],
      );
      expect(resultado.escenarios.single.accesibilidad, contains('no documentada'));
    });

    test('declara en la memoria cuántos escenarios se compararon', () {
      final resultado = compararEscenarios(
        familias: _familias,
        entradaAnden: _entradaAnden,
        escenarios: [
          _escenario(nombre: 'A', tipoSistema: 'selectivo', factorFondo: 1, factorHoneycomb: 0.20),
          _escenario(nombre: 'B', tipoSistema: 'doble_fondo', factorFondo: 2, factorHoneycomb: 0.30),
        ],
      );
      expect(resultado.memoria.single.valor, '2');
    });
  });
}
