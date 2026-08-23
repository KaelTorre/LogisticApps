import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_diseno_almacenes/domain/motor/m3_superficie.dart';

/// Entrada base reutilizada entre tests: escenario selectivo típico, EPAL
/// sobre viga de 2 tarimas, holguras EN 15620, contrabalanceado sin límite
/// de altura.
EntradaM3 _entradaBase({
  int posicionesRequeridas = 100,
  int alturaLibreMm = 8000,
  int elevacionMaxEquipoMm = 9000,
  int holguraXMm = 75,
  int holguraYMm = 75,
  int largoDisponibleMm = 30000,
}) {
  return EntradaM3(
    posicionesRequeridas: posicionesRequeridas,
    anchoTarimaMm: 800,
    altoTarimaMm: 144,
    altoCargaMm: 1200,
    largoVigaMm: 1825,
    peralteVigaMm: 110,
    fondoBastidorMm: 1100,
    perfilAnchoBastidorMm: 80,
    holguraXMm: holguraXMm,
    holguraXMinimaNormaMm: 75,
    holguraYMm: holguraYMm,
    holguraYMinimaNormaMm: 75,
    pasoAjustePuntalMm: 50,
    alturaLibreMm: alturaLibreMm,
    reservaTechoMm: 450,
    elevacionMaxEquipoMm: elevacionMaxEquipoMm,
    largoDisponibleMm: largoDisponibleMm,
  );
}

void main() {
  group('casos dorados — CLAUDE.md sección 12', () {
    test('viga de 2 EPAL: largo_viga_min = 1825mm', () {
      final largoMin = calcularLargoVigaMinimo(
        tarimasPorNivel: 2,
        anchoTarimaMm: 800,
        holguraXMm: 75,
      );
      expect(largoMin, 1825);
    });

    test('bastidor GMA: fondo ≈ 1067mm (42″)', () {
      final fondoCalculado = calcularFondoBastidor(fondoTarimaMm: 1219, voladizoMm: 75);
      final fondoComercial = seleccionarBastidorComercial(
        fondoCalculado,
        [914, 1067, 1100, 1219],
      );
      expect(fondoComercial, 1067);
    });

    test('holgura mínima EN: holgura_x=50 con norma EN → rechazo explícito', () {
      final entrada = _entradaBase(holguraXMm: 50);
      expect(
        () => calcularSuperficie(entrada),
        throwsA(isA<HolguraInvalidaException>()),
      );
    });

    test('equipo limitante: altura libre 12m, contrabalanceado 6m → el equipo limita y se declara', () {
      final entrada = _entradaBase(alturaLibreMm: 12000, elevacionMaxEquipoMm: 6000);
      final r = calcularSuperficie(entrada);

      // paso = 144 + 1200 + 75 + 110 = 1529 -> redondeado a 50 = 1550
      // niveles_por_altura = floor((12000-450)/1550) = 7
      // niveles_por_equipo  = floor(6000/1550) = 3
      expect(r.pasoNivelMm, 1550);
      expect(r.niveles, 3);

      final filaNiveles = r.memoria.firstWhere((f) => f.concepto == 'Niveles');
      expect(filaNiveles.formula, contains('EQUIPO es la restricción activa'));
    });
  });

  group('propiedades', () {
    test('posiciones_instaladas siempre ≥ posiciones_requeridas', () {
      for (final requeridas in [1, 10, 47, 100, 999]) {
        final r = calcularSuperficie(_entradaBase(posicionesRequeridas: requeridas));
        expect(
          r.posicionesInstaladas,
          greaterThanOrEqualTo(requeridas),
          reason: 'con posicionesRequeridas=$requeridas',
        );
      }
    });

    test('más posiciones requeridas nunca reduce la superficie de almacenamiento', () {
      final sup1 = calcularSuperficie(_entradaBase(posicionesRequeridas: 50)).supAlmacenamientoMm2;
      final sup2 = calcularSuperficie(_entradaBase(posicionesRequeridas: 200)).supAlmacenamientoMm2;
      expect(sup2, greaterThanOrEqualTo(sup1));
    });

    test('ningún resultado válido tiene niveles <= 0 — o lanza explícito en vez de devolver basura', () {
      // Altura libre apenas mayor que la reserva de techo: no cabe ni un nivel.
      expect(
        () => calcularSuperficie(_entradaBase(alturaLibreMm: 500, elevacionMaxEquipoMm: 9000)),
        throwsA(isA<NivelesInsuficientesException>()),
      );
    });

    test('largo disponible insuficiente para un módulo lanza explícito, no un resultado con 0 filas', () {
      expect(
        () => calcularSuperficie(_entradaBase(largoDisponibleMm: 100)),
        throwsA(isA<LayoutInvalidoException>()),
      );
    });
  });

  group('memoria de cálculo', () {
    test('cada resultado trae una fila de memoria por paso del pseudocódigo', () {
      final r = calcularSuperficie(_entradaBase());
      final conceptos = r.memoria.map((f) => f.concepto).toList();
      expect(conceptos, [
        'Tarimas por nivel',
        'Paso de nivel',
        'Niveles',
        'Capacidad del módulo',
        'Módulos y filas',
        'Superficie de almacenamiento (huella de racks)',
      ]);
      expect(r.memoria.map((f) => f.orden), [1, 2, 3, 4, 5, 6]);
    });
  });
}
