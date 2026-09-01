import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_control_logistico/domain/motor/m3_emparejador_acciones.dart';

/// Fase 4 (CLAUDE.md): "Test I — acción hacia la Unidad 5: una
/// clasificación replaneacion_mayor sobre un indicador de categoría costo
/// del proceso de transporte incluye entre sus propuestas la acción que
/// apunta al rediseño de red."
void main() {
  const idAccionRedisenarRed = 101;
  const idAccionGenericaCosto = 102;

  const catalogo = [
    MapeoAccion(
      categoriaIndicador: 'costo',
      reglaDisparada: 'R4',
      clasificacion: 'replaneacion_mayor',
      accionId: idAccionRedisenarRed,
      prioridad: 1,
    ),
    MapeoAccion(
      categoriaIndicador: 'costo',
      reglaDisparada: 'R2',
      clasificacion: 'replaneacion_mayor',
      accionId: idAccionRedisenarRed,
      prioridad: 1,
    ),
    MapeoAccion(
      categoriaIndicador: 'costo',
      reglaDisparada: 'R4',
      clasificacion: 'ajuste_menor',
      accionId: idAccionGenericaCosto,
      prioridad: 1,
    ),
    MapeoAccion(
      categoriaIndicador: 'servicio',
      reglaDisparada: 'R4',
      clasificacion: 'replaneacion_mayor',
      accionId: 201,
      prioridad: 1,
    ),
  ];

  test('Test I — replaneación mayor en costo incluye la acción de rediseño de red', () {
    final candidatas = emparejarAcciones(
      categoriaIndicador: 'costo',
      reglasDisparadas: {'R4'},
      clasificacion: 'replaneacion_mayor',
      catalogoMapeos: catalogo,
    );

    expect(candidatas, contains(idAccionRedisenarRed));
  });

  test('el emparejador ordena por prioridad y no duplica una acción mapeada desde dos reglas', () {
    final candidatas = emparejarAcciones(
      categoriaIndicador: 'costo',
      reglasDisparadas: {'R2', 'R4'},
      clasificacion: 'replaneacion_mayor',
      catalogoMapeos: catalogo,
    );

    // idAccionRedisenarRed está mapeada desde R2 Y R4 -- debe aparecer una
    // sola vez.
    expect(candidatas, [idAccionRedisenarRed]);
  });

  test('no mezcla categorías ni clasificaciones distintas', () {
    final candidatas = emparejarAcciones(
      categoriaIndicador: 'servicio',
      reglasDisparadas: {'R4'},
      clasificacion: 'ajuste_menor', // no hay mapeo servicio+ajuste_menor en el catálogo de prueba
      catalogoMapeos: catalogo,
    );

    expect(candidatas, isEmpty);
  });

  test('sin reglas disparadas que coincidan, no hay candidatas', () {
    final candidatas = emparejarAcciones(
      categoriaIndicador: 'costo',
      reglasDisparadas: {'R5'},
      clasificacion: 'replaneacion_mayor',
      catalogoMapeos: catalogo,
    );

    expect(candidatas, isEmpty);
  });
}
