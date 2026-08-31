import 'dart:convert';

import '../../data/models/celda_matriz.dart';
import '../../data/models/parametros_costo.dart';
import '../../data/models/planta.dart';
import '../../data/models/sitio_candidato.dart';
import '../../data/models/zona_demanda.dart';
import 'fila_memoria.dart';
import 'm7_agrupacion_riesgos.dart';
import 'tarifas.dart';

const rubroProduccion = 'produccion';
const rubroEntrada = 'entrada';
const rubroSalida = 'salida';
const rubroFijo = 'fijo';
const rubroManejo = 'manejo';
const rubroInventario = 'inventario';
const rubroPedidos = 'pedidos';

/// Costo total y desglose por rubro (CLAUDE.md sección 7, M4), más la
/// memoria de cálculo — al menos una fila por rubro (`[REGLA]`, Fase 5).
class ResultadoCosto {
  const ResultadoCosto({required this.costoTotalCent, required this.porRubro, required this.memoria});

  final int costoTotalCent;
  final Map<String, int> porRubro;
  final List<FilaMemoria> memoria;
}

/// M4 — modelo de costo de siete rubros. Cada rubro se redondea a céntimos
/// individualmente (no el total) y el costo total es la suma de esos
/// enteros, para que el desglose siempre sume exacto al total, sin
/// diferencia de redondeo (mismo criterio que un estado de resultados
/// contable: se redondea cada línea, no el acumulado).
///
/// El transporte de entrada y el costo de producción necesitan la planta
/// que abastece a cada almacén abierto — se asigna la planta con menor
/// distancia real a ese almacén (`distanciaPlantaCandidato`, extensión de
/// la matriz de la Fase 4 agregada en esta fase: ver
/// `lib/ui/pantallas/matriz/matriz_screen.dart`). Sin plantas cargadas,
/// esos dos rubros quedan en cero — el modelo no tiene de dónde sacar un
/// costo de producción ni una distancia de abastecimiento.
ResultadoCosto calcularCostoTotal({
  required List<int> abiertos,
  required Map<int, SitioCandidato> candidatosPorId,
  required List<Planta> plantas,
  required List<ZonaDemanda> zonas,
  required Map<int, int> asignacionZonaCandidato,
  required Map<(int, int), CeldaMatriz> distanciaZonaCandidato,
  required Map<(int, int), CeldaMatriz> distanciaPlantaCandidato,
  required ParametrosCosto params,
}) {
  final memoria = <FilaMemoria>[];
  final zonasPorId = {for (final z in zonas) z.id!: z};

  final volumenAlmacen = <int, double>{for (final id in abiertos) id: 0};
  for (final entrada in asignacionZonaCandidato.entries) {
    final zona = zonasPorId[entrada.key];
    if (zona == null) continue;
    volumenAlmacen[entrada.value] = (volumenAlmacen[entrada.value] ?? 0) + zona.demandaAgregada;
  }

  // Planta con menor distancia real a cada almacén abierto.
  final plantaAsignada = <int, Planta>{};
  for (final candidatoId in abiertos) {
    Planta? mejor;
    var mejorDistancia = double.infinity;
    for (final planta in plantas) {
      final celda = distanciaPlantaCandidato[(planta.id!, candidatoId)];
      if (celda == null) continue;
      if (celda.distanciaMetros < mejorDistancia) {
        mejorDistancia = celda.distanciaMetros.toDouble();
        mejor = planta;
      }
    }
    if (mejor != null) plantaAsignada[candidatoId] = mejor;
  }

  double produccion = 0;
  for (final entrada in asignacionZonaCandidato.entries) {
    final zona = zonasPorId[entrada.key];
    final planta = plantaAsignada[entrada.value];
    if (zona == null || planta == null) continue;
    produccion += zona.demandaAgregada * planta.costoProduccionCentPorUnidad;
  }

  double entradaCosto = 0;
  for (final candidatoId in abiertos) {
    final planta = plantaAsignada[candidatoId];
    if (planta == null) continue;
    final celda = distanciaPlantaCandidato[(planta.id!, candidatoId)]!;
    entradaCosto += volumenAlmacen[candidatoId]! *
        tarifaTransporte(
          distanciaMetros: celda.distanciaMetros,
          tarifaFijaCent: params.tarifaEntradaFijaCent,
          tarifaCentPorKmTon: params.tarifaEntradaCentPorKmTon,
        );
  }

  double salida = 0;
  double pedidos = 0;
  for (final entrada in asignacionZonaCandidato.entries) {
    final zona = zonasPorId[entrada.key];
    if (zona == null) continue;
    final celda = distanciaZonaCandidato[(entrada.key, entrada.value)]!;
    salida += zona.demandaAgregada *
        tarifaTransporte(
          distanciaMetros: celda.distanciaMetros,
          tarifaFijaCent: params.tarifaSalidaFijaCent,
          tarifaCentPorKmTon: params.tarifaSalidaCentPorKmTon,
        );
    pedidos += zona.pedidosAgregados * params.costoPorPedidoCent;
  }

  final fijo = abiertos.fold<int>(0, (s, id) => s + candidatosPorId[id]!.costoFijoAnualCent);

  double manejo = 0;
  for (final candidatoId in abiertos) {
    manejo += volumenAlmacen[candidatoId]! * candidatosPorId[candidatoId]!.costoVariableManejoCentPorUnidad;
  }

  final inventario = inventarioTotal(abiertos.length, params.inventarioBaseUnaUbicacion) *
      params.valorPorUnidadCent *
      params.tasaManejoInventarioAnual;

  final porRubro = <String, int>{
    rubroProduccion: produccion.round(),
    rubroEntrada: entradaCosto.round(),
    rubroSalida: salida.round(),
    rubroFijo: fijo,
    rubroManejo: manejo.round(),
    rubroInventario: inventario.round(),
    rubroPedidos: pedidos.round(),
  };
  final total = porRubro.values.fold<int>(0, (s, v) => s + v);

  memoria.addAll([
    FilaMemoria(
      modulo: 'M4',
      formula: 'Σ_zonas demanda × costo_produccion_tonelada(planta que abastece el almacén asignado)',
      entradasJson: jsonEncode({'zonas_asignadas': asignacionZonaCandidato.length}),
      salida: '${porRubro[rubroProduccion]}',
      unidad: 'centavos',
    ),
    FilaMemoria(
      modulo: 'M4',
      formula: 'Σ_abiertos volumen_almacén × (tarifa_entrada_fija + tarifa_entrada_km_ton × distancia_planta_almacen/1000)',
      entradasJson: jsonEncode({'almacenes_abiertos': abiertos.length}),
      salida: '${porRubro[rubroEntrada]}',
      unidad: 'centavos',
    ),
    FilaMemoria(
      modulo: 'M4',
      formula: 'Σ_zonas demanda × (tarifa_salida_fija + tarifa_salida_km_ton × distancia_zona_almacen/1000)',
      entradasJson: jsonEncode({'zonas_asignadas': asignacionZonaCandidato.length}),
      salida: '${porRubro[rubroSalida]}',
      unidad: 'centavos',
    ),
    FilaMemoria(
      modulo: 'M4',
      formula: 'Σ_abiertos costo_fijo_anual',
      entradasJson: jsonEncode({'almacenes_abiertos': abiertos.length}),
      salida: '${porRubro[rubroFijo]}',
      unidad: 'centavos',
    ),
    FilaMemoria(
      modulo: 'M4',
      formula: 'Σ_abiertos volumen_almacén × costo_variable_manejo',
      entradasJson: jsonEncode({'almacenes_abiertos': abiertos.length}),
      salida: '${porRubro[rubroManejo]}',
      unidad: 'centavos',
    ),
    FilaMemoria(
      modulo: 'M4',
      formula: 'inventario(n_abiertos) × valor_por_unidad × tasa_manejo_inventario_anual, donde '
          'inventario(n) = inventario_base × √n (efecto de agrupación de riesgos)',
      entradasJson: jsonEncode({
        'n_abiertos': abiertos.length,
        'inventario_base': params.inventarioBaseUnaUbicacion,
        'valor_por_unidad_cent': params.valorPorUnidadCent,
        'tasa_manejo_inventario_anual': params.tasaManejoInventarioAnual,
      }),
      salida: '${porRubro[rubroInventario]}',
      unidad: 'centavos',
    ),
    FilaMemoria(
      modulo: 'M4',
      formula: 'Σ_zonas pedidos_anuales × costo_por_pedido',
      entradasJson: jsonEncode({'zonas_asignadas': asignacionZonaCandidato.length}),
      salida: '${porRubro[rubroPedidos]}',
      unidad: 'centavos',
    ),
    FilaMemoria(
      modulo: 'M4',
      formula: 'costo_total = Σ (producción + entrada + salida + fijo + manejo + inventario + pedidos)',
      entradasJson: jsonEncode(porRubro),
      salida: '$total',
      unidad: 'centavos',
    ),
  ]);

  return ResultadoCosto(costoTotalCent: total, porRubro: porRubro, memoria: memoria);
}
