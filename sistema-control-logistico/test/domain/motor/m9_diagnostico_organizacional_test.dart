import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_control_logistico/domain/motor/m9_diagnostico_organizacional.dart';

/// Fase 8 (CLAUDE.md): "Test del diagnóstico: un conjunto de respuestas
/// fijado produce una etapa y una orientación deterministas."
void main() {
  test('preguntasDiagnostico cubre los cinco bloques con las cantidades declaradas', () {
    final porBloque = <String, int>{};
    for (final p in preguntasDiagnostico) {
      porBloque[p.bloque] = (porBloque[p.bloque] ?? 0) + 1;
    }
    expect(porBloque['etapa'], 4);
    expect(porBloque['centralizacion'], 3);
    expect(porBloque['asesorLinea'], 3);
    expect(porBloque['orientacion'], 3);
    expect(porBloque['opcion'], 2);
  });

  test('un conjunto de respuestas fijado produce una etapa y una orientación deterministas', () {
    const respuestas = {
      'etapa-1': '4',
      'etapa-2': '4',
      'etapa-3': '3',
      'etapa-4': '4',
      'central-1': '75',
      'central-2': '50',
      'central-3': '25',
      'asesor-1': '100',
      'asesor-2': '75',
      'asesor-3': '50',
      'orient-1': 'proceso',
      'orient-2': 'proceso',
      'orient-3': 'mercado',
      'opcion-1': 'por_procesos',
      'opcion-2': 'matricial',
    };

    final resultado = evaluarDiagnostico(respuestas);

    expect(resultado.etapaResultante, 4); // moda: 4 aparece tres veces
    expect(resultado.orientacionDominante, 'proceso'); // 2 de 3 votos
    expect(resultado.opcionOrganizacional, 'matricial'); // empate 1-1, desempate alfabético
    expect(resultado.ejes.centralizacion, closeTo(50, 0.001)); // (75+50+25)/3
    expect(resultado.ejes.asesorLinea, closeTo(75, 0.001)); // (100+75+50)/3
    expect(resultado.ejes.orientacionProceso, closeTo(200 / 3, 0.001));
    expect(resultado.ejes.orientacionMercado, closeTo(100 / 3, 0.001));
    expect(resultado.ejes.orientacionInformacion, 0);

    // Determinismo: evaluar dos veces las mismas respuestas da el mismo resultado.
    final resultadoOtraVez = evaluarDiagnostico(respuestas);
    expect(resultadoOtraVez.etapaResultante, resultado.etapaResultante);
    expect(resultadoOtraVez.opcionOrganizacional, resultado.opcionOrganizacional);
    expect(resultadoOtraVez.orientacionDominante, resultado.orientacionDominante);
    expect(resultadoOtraVez.ejes.centralizacion, resultado.ejes.centralizacion);
  });

  test('empate en etapa se resuelve hacia la etapa más baja', () {
    final resultado = evaluarDiagnostico({'etapa-1': '2', 'etapa-2': '2', 'etapa-3': '3', 'etapa-4': '3'});
    expect(resultado.etapaResultante, 2);
  });

  test('empate a tres bandas en orientación se resuelve alfabéticamente (información primero)', () {
    final resultado = evaluarDiagnostico({'orient-1': 'proceso', 'orient-2': 'mercado', 'orient-3': 'informacion'});
    expect(resultado.orientacionDominante, 'informacion');
  });

  test('sin respuestas de un bloque, el eje numérico correspondiente queda en 0', () {
    final resultado = evaluarDiagnostico(const {'etapa-1': '1'});
    expect(resultado.ejes.centralizacion, 0);
    expect(resultado.ejes.asesorLinea, 0);
  });

  test('calcularBrechas compara cada eje contra el perfil objetivo', () {
    const respuestas = {
      'etapa-1': '1',
      'etapa-2': '1',
      'etapa-3': '1',
      'etapa-4': '1',
      'central-1': '100',
      'central-2': '100',
      'central-3': '100',
      'asesor-1': '0',
      'asesor-2': '0',
      'asesor-3': '0',
    };
    final resultado = evaluarDiagnostico(respuestas);
    final brechas = calcularBrechas(resultado);

    expect(brechas.length, 6);
    final etapaBrecha = brechas.firstWhere((b) => b.eje == 'etapa');
    expect(etapaBrecha.actual, 1);
    expect(etapaBrecha.objetivo, 4);
    expect(etapaBrecha.brecha, 3); // le falta camino: objetivo - actual

    final centralBrecha = brechas.firstWhere((b) => b.eje == 'centralizacion');
    expect(centralBrecha.actual, 100);
    expect(centralBrecha.objetivo, 40);
    expect(centralBrecha.brecha, -60); // ya está más centralizada que el objetivo
  });
}
