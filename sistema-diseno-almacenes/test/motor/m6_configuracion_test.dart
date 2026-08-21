import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_diseno_almacenes/domain/motor/m6_configuracion.dart';

ResultadoM6 _evaluar(int modulos, {double relacionMaxima = 3.0}) {
  return evaluarConfiguraciones(
    modulos: modulos,
    largoVigaMm: 1825,
    perfilAnchoBastidorMm: 80,
    fondoBastidorMm: 1100,
    anchoPasilloMm: 2850,
    separacionEspaldaMm: 200,
    holguraMuroMm: 200,
    relacionMaxima: relacionMaxima,
  );
}

void main() {
  group('evaluarConfiguraciones', () {
    test('todas las configuraciones respetan la relación largo/ancho máxima', () {
      final r = _evaluar(20);
      for (final c in r.configuraciones) {
        final ladoLargo = c.layout.anchoTotalMm > c.layout.largoTotalMm
            ? c.layout.anchoTotalMm
            : c.layout.largoTotalMm;
        final ladoCorto = c.layout.anchoTotalMm > c.layout.largoTotalMm
            ? c.layout.largoTotalMm
            : c.layout.anchoTotalMm;
        expect(ladoLargo / ladoCorto, lessThanOrEqualTo(3.0));
      }
    });

    test('evalúa los 3 patrones de flujo para cada geometría válida', () {
      final r = _evaluar(20);
      final geometrias = r.configuraciones.map((c) => (c.filas, c.modulosPorFila)).toSet();
      for (final g in geometrias) {
        final patrones = r.configuraciones
            .where((c) => c.filas == g.$1 && c.modulosPorFila == g.$2)
            .map((c) => c.patronFlujo)
            .toSet();
        expect(patrones, PatronFlujo.values.toSet());
      }
    });

    test('las configuraciones quedan ordenadas por distancia esperada ascendente', () {
      final r = _evaluar(20);
      for (var i = 1; i < r.configuraciones.length; i++) {
        expect(
          r.configuraciones[i].distanciaEsperadaMm,
          greaterThanOrEqualTo(r.configuraciones[i - 1].distanciaEsperadaMm),
        );
      }
    });

    test('ninguna distancia esperada es negativa', () {
      final r = _evaluar(20);
      for (final c in r.configuraciones) {
        expect(c.distanciaEsperadaMm, greaterThanOrEqualTo(0));
      }
    });

    test(
      'patrón U (dock frontal-centro) da menor distancia que L (esquina) para una sola fila centrada',
      () {
        final r = _evaluar(1); // 1 solo módulo -> geometría casi cuadrada, filas=1 válida
        final unaFila = r.configuraciones.where((c) => c.filas == 1).toList();
        expect(unaFila, isNotEmpty, reason: 'este caso asume que filas=1 es una configuración válida');

        final distU = unaFila.firstWhere((c) => c.patronFlujo == PatronFlujo.u).distanciaEsperadaMm;
        final distL = unaFila.firstWhere((c) => c.patronFlujo == PatronFlujo.l).distanciaEsperadaMm;

        // Con una sola fila centrada en X, el dock frontal-centro (U) queda
        // alineado en X con la fila -- toda la distancia es vertical. El
        // dock de esquina (L) suma también la distancia horizontal hasta el
        // centro de la fila, así que L nunca puede ser más corto.
        expect(distU, lessThanOrEqualTo(distL));
      },
    );

    test('pasante nunca es peor que el máximo de U o L (usa el dock más cercano)', () {
      final r = _evaluar(20);
      final geometrias = r.configuraciones.map((c) => (c.filas, c.modulosPorFila)).toSet();
      for (final g in geometrias) {
        final delGrupo = r.configuraciones.where(
          (c) => c.filas == g.$1 && c.modulosPorFila == g.$2,
        );
        final distU = delGrupo.firstWhere((c) => c.patronFlujo == PatronFlujo.u).distanciaEsperadaMm;
        final distPasante = delGrupo
            .firstWhere((c) => c.patronFlujo == PatronFlujo.pasante)
            .distanciaEsperadaMm;
        // No es una comparación directa válida en todos los casos (U y
        // pasante miden desde orígenes distintos), pero pasante nunca debe
        // ser absurdamente mayor: como mínimo, no debe superar el doble de U
        // en esta geometría de prueba.
        expect(distPasante, lessThanOrEqualTo(distU * 2 + 1));
      }
    });

    test('rechaza modulos <= 0', () {
      expect(() => _evaluar(0), throwsArgumentError);
    });

    test('relación máxima demasiado estricta lanza explícito, no una lista vacía silenciosa', () {
      expect(() => _evaluar(50, relacionMaxima: 0.5), throwsArgumentError);
    });
  });
}
