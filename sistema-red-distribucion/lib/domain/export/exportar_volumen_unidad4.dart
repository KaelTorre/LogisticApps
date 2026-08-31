import 'dart:convert';

/// Exporta el volumen anual de cada almacén abierto en un escenario en el
/// formato exacto que `ImportarProyectoScreen`/`ProyectoPortable` de
/// `sistema-diseno-almacenes` (Unidad 4) espera — releído campo por campo
/// de ese proyecto en vez de inventarlo (CLAUDE.md Fase 9, [REGLA]). Un
/// archivo JSON por almacén, para que el botón "Importar proyecto" de
/// Unidad 4 lo abra directo y arranque el dimensionamiento de ESE centro
/// con la demanda real que le tocó en la red.
///
/// `ProyectoPortable.fromJsonString` de Unidad 4 exige un proyecto
/// COMPLETO de dimensionamiento (norma, rotación, alturas del edificio,
/// perfil de andén, catálogo de tarima/bastidor/viga/equipo/camión) — cosas
/// que este proyecto de red de distribución no calcula. Solo `demandaAnual`
/// viaja con un valor real (el volumen asignado); el resto queda en valores
/// por defecto razonables, documentados en el propio JSON como algo que el
/// usuario debe revisar en Unidad 4 antes de calcular.
///
/// Las filas de catálogo (`tarima`/`bastidor`/`viga`/`equipo`/`camion`) usan
/// códigos reales del catálogo semilla de Unidad 4
/// (`sistema-diseno-almacenes/assets/catalogo_semilla.json`: `EPAL`,
/// `BAST-914`, `VIGA-1825`, `TRANSPALETA-MANUAL`, `C2`) — el importador de
/// Unidad 4 resuelve por `codigo` contra el catálogo semilla local y, si lo
/// encuentra (que en cualquier instalación nueva sí, porque es semilla),
/// **descarta el resto de los campos del objeto** (ver
/// `_resolverTarima`/... en `entrada_calculo_screen.dart`) — así que la
/// única razón para llenarlos con valores reales en vez de ceros es que el
/// archivo se pueda leer a simple vista si alguien lo abre.
class VolumenPorCentroUnidad4 {
  const VolumenPorCentroUnidad4({required this.nombreAlmacen, required this.contenidoJson});

  final String nombreAlmacen;
  final String contenidoJson;
}

const _versionProyectoPortableUnidad4 = 1;

List<VolumenPorCentroUnidad4> exportarVolumenPorCentro({
  required List<({int sitioCandidatoId, String nombre, double volumenAnual})> almacenesAbiertos,
}) {
  return almacenesAbiertos
      .map(
        (a) => VolumenPorCentroUnidad4(
          nombreAlmacen: a.nombre,
          contenidoJson: const JsonEncoder.withIndent('  ').convert({
            'version': _versionProyectoPortableUnidad4,
            'nombre': 'Dimensionamiento — ${a.nombre}',
            'demandaAnual': a.volumenAnual,
            // Valores por defecto conservadores, PENDIENTES de revisión en
            // Unidad 4 — no vienen de este proyecto, que no calcula rotación
            // de inventario, alturas de edificio ni perfil de andén.
            'rotacionAnual': 12.0,
            'unidadesPorTarima': 1,
            'factorHoneycomb': 0.20,
            'altoCargaMm': 1200,
            'alturaLibreMm': 8000,
            'reservaTechoMm': 450,
            'largoDisponibleMm': 30000,
            'camionesHoraPico': 2.0,
            'tiempoServicioMinutos': 30.0,
            'esperaObjetivoMinutos': 15.0,
            'espaciamientoPuertaMm': 3600,
            'areaStagingM2': 40.0,
            'tarima': {
              'id': 0,
              'codigo': 'EPAL',
              'largoMm': 1200,
              'anchoMm': 800,
              'altoMm': 144,
              'taraG': 25000,
              'cargaDinG': 1500000,
              'cargaEstG': 4000000,
              'region': 'EU',
              'fuente': 'ISO 6780 / EN 13698',
              'esSemilla': true,
            },
            'bastidor': {
              'id': 0,
              'codigo': 'BAST-914',
              'fondoMm': 914,
              'alturaMm': 12000,
              'perfilAnchoMm': 80,
              'perfilFondoMm': 50,
              'fuente': 'Fondo comercial 36" (Mecalux)',
              'esSemilla': true,
            },
            'viga': {
              'id': 0,
              'codigo': 'VIGA-1825',
              'largoMm': 1825,
              'peralteMm': 110,
              'capacidadParG': null,
              'fuente': '2 tarimas EPAL + holgura EN 75mm (Mecalux)',
              'esSemilla': true,
            },
            'equipo': {
              'id': 0,
              'codigo': 'TRANSPALETA-MANUAL',
              'tipo': 'transpaleta',
              'claseEn': null,
              'pasilloMinMm': 2000,
              'pasilloMaxMm': 2400,
              'elevacionMaxMm': 200,
              'alturaMastilMm': null,
              'requiereGuiado': false,
              'costoUnitarioCent': null,
              'fuente': 'EN 15620',
              'esSemilla': true,
            },
            'camion': {
              'id': 0,
              'codigo': 'C2',
              'largoMm': 12300,
              'anchoMm': 2600,
              'patioMinMm': 18000,
              'fuente': 'D.S. Nº 058-2003-MTC, Anexo IV',
              'esSemilla': true,
            },
          }),
        ),
      )
      .toList();
}
