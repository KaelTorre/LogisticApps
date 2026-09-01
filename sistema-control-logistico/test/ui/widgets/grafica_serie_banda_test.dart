import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_control_logistico/data/models/indicador.dart';
import 'package:sistema_control_logistico/data/models/periodo.dart';
import 'package:sistema_control_logistico/ui/widgets/grafica_serie_banda.dart';

/// Fase 2 (CLAUDE.md): "Test de widget: la gráfica dibuja la banda en la
/// posición correcta para `menor_mejor` y para `mayor_mejor`." La posición
/// de la banda en el eje Y es `[bandaInferior, bandaSuperior]` tal cual
/// están guardadas -- el sentido no debe desplazarla ni invertirla, solo
/// cambia qué lado es "adverso" para el motor de evaluación (Fase 3).
void main() {
  final periodos = [
    const Periodo(
      id: 1,
      organizacionId: 1,
      orden: 1,
      etiqueta: 'P1',
      fechaInicio: '2026-01-01',
      fechaFin: '2026-01-31',
      granularidad: 'mensual',
    ),
    const Periodo(
      id: 2,
      organizacionId: 1,
      orden: 2,
      etiqueta: 'P2',
      fechaInicio: '2026-02-01',
      fechaFin: '2026-02-28',
      granularidad: 'mensual',
    ),
  ];

  Future<HorizontalRangeAnnotation> bandaRenderizada(WidgetTester tester, Indicador indicador) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            height: 300,
            child: GraficaSerieBanda(
              indicador: indicador,
              periodos: periodos,
              valoresPorPeriodoId: {1: 100, 2: 105},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final lineChart = tester.widget<LineChart>(find.byType(LineChart));
    return lineChart.data.rangeAnnotations.horizontalRangeAnnotations.single;
  }

  testWidgets('menor_mejor: la banda va de bandaInferior a bandaSuperior', (tester) async {
    final indicador = Indicador(
      id: 1,
      organizacionId: 1,
      codigo: 'IND-1',
      nombre: 'Costo',
      categoria: 'costo',
      unidad: 'S/',
      sentido: 'menor_mejor',
      meta: 100,
      bandaInferior: 90,
      bandaSuperior: 110,
      granularidad: 'mensual',
      proceso: 'Transporte',
    );

    final banda = await bandaRenderizada(tester, indicador);

    expect(banda.y1, 90);
    expect(banda.y2, 110);
  });

  testWidgets('mayor_mejor: la banda va exactamente a la misma posición que menor_mejor', (tester) async {
    final indicador = Indicador(
      id: 2,
      organizacionId: 1,
      codigo: 'IND-2',
      nombre: 'Cumplimiento',
      categoria: 'servicio',
      unidad: '%',
      sentido: 'mayor_mejor',
      meta: 100,
      bandaInferior: 90,
      bandaSuperior: 110,
      granularidad: 'mensual',
      proceso: 'Entregas',
    );

    final banda = await bandaRenderizada(tester, indicador);

    expect(banda.y1, 90);
    expect(banda.y2, 110);
  });
}
