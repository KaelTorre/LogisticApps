import 'package:flutter_test/flutter_test.dart';
import 'package:paquete_geo_logistica/paquete_geo_logistica.dart';
import 'package:sistema_red_distribucion/data/models/celda_matriz.dart';
import 'package:sistema_red_distribucion/data/models/parametros_costo.dart';
import 'package:sistema_red_distribucion/data/models/sitio_candidato.dart';
import 'package:sistema_red_distribucion/data/models/zona_demanda.dart';
import 'package:sistema_red_distribucion/domain/motor/evaluador_costo.dart';
import 'package:sistema_red_distribucion/domain/motor/m4_costo_total.dart';
import 'package:sistema_red_distribucion/domain/motor/m8_barrido.dart';

/// Instancia construida a propósito para tener mínimo interior (CLAUDE.md,
/// Fase 7, Test Q): tres clústeres de zonas bien separados, con varios
/// candidatos redundantes cerca de cada uno. La mejora de transporte de
/// salida se agota después de abrir un almacén por clúster (p=3) — abrir
/// más no acerca ninguna zona, así que de ahí en más solo suma costo fijo.
EvaluadorCosto _instanciaConMinimoInterior() {
  final posCandidatos = [
    (0.1, 0.1), (0.12, 0.08), (0.08, 0.12), // cerca del clúster A
    (0.9, 0.1), (0.88, 0.12), (0.92, 0.08), // cerca del clúster B
    (0.5, 0.9), (0.48, 0.88), (0.52, 0.92), // cerca del clúster C
  ];
  final posZonas = [
    (0.1, 0.1), (0.11, 0.09), (0.09, 0.11), // clúster A
    (0.9, 0.1), (0.89, 0.11), (0.91, 0.09), // clúster B
    (0.5, 0.9), (0.49, 0.89), (0.51, 0.91), // clúster C
  ];

  final candidatosPorId = <int, SitioCandidato>{
    for (var i = 0; i < posCandidatos.length; i++)
      i + 1: SitioCandidato(
        id: i + 1,
        proyectoId: 1,
        nombre: 'C${i + 1}',
        latitud: posCandidatos[i].$1,
        longitud: posCandidatos[i].$2,
        costoFijoAnualCent: 400000,
        capacidadAnual: 1e9,
        costoVariableManejoCentPorUnidad: 20,
        origen: 'manual',
      ),
  };

  final zonas = <ZonaDemanda>[
    for (var j = 0; j < posZonas.length; j++)
      ZonaDemanda(
        id: j + 1,
        proyectoId: 1,
        etiqueta: 'Z${j + 1}',
        latitud: posZonas[j].$1,
        longitud: posZonas[j].$2,
        demandaAgregada: 80,
        pedidosAgregados: 10,
        numeroClientes: 1,
        errorAgregacionMetros: 0,
      ),
  ];

  final distanciaZonaCandidato = <(int, int), CeldaMatriz>{};
  for (var j = 0; j < posZonas.length; j++) {
    for (var i = 0; i < posCandidatos.length; i++) {
      final distanciaMetros = (distanciaHaversineKm(
                lat1: posCandidatos[i].$1,
                lon1: posCandidatos[i].$2,
                lat2: posZonas[j].$1,
                lon2: posZonas[j].$2,
              ) *
              1000)
          .round();
      distanciaZonaCandidato[(j + 1, i + 1)] = CeldaMatriz(
        proyectoId: 1,
        tipoOrigen: 'candidato',
        origenId: i + 1,
        tipoDestino: 'zona',
        destinoId: j + 1,
        distanciaMetros: distanciaMetros,
        duracionSegundos: distanciaMetros ~/ 10,
        fuente: 'osrm',
      );
    }
  }

  const params = ParametrosCosto(
    proyectoId: 1,
    tarifaEntradaFijaCent: 0,
    tarifaEntradaCentPorKmTon: 0,
    tarifaSalidaFijaCent: 0,
    tarifaSalidaCentPorKmTon: 600,
    tasaManejoInventarioAnual: 0.15,
    valorPorUnidadCent: 500,
    inventarioBaseUnaUbicacion: 20,
    costoPorPedidoCent: 30,
    tipoEstandar: 'distancia',
    estandarServicioValor: 1000000000,
  );

  return EvaluadorCosto(
    zonas: zonas,
    candidatosPorId: candidatosPorId,
    plantas: const [],
    distanciaZonaCandidato: distanciaZonaCandidato,
    distanciaPlantaCandidato: const {},
    params: params,
    conRestriccionCapacidad: false,
  );
}

void main() {
  test(
    'Test Q — forma de la curva: decreciente antes del mínimo, creciente después, '
    'y el óptimo marcado coincide con el mínimo real',
    () async {
      final evaluador = _instanciaConMinimoInterior();
      final resultado = await barrerNumeroAlmacenes(
        candidatosDisponibles: evaluador.candidatosPorId.keys.toList(),
        candidatosPorId: evaluador.candidatosPorId,
        evaluador: evaluador,
      );

      final costos = resultado.curva.map((p) => p.costoTotalCent).toList();

      // El mínimo real del vector.
      var indiceMinimoReal = 0;
      for (var i = 1; i < costos.length; i++) {
        if (costos[i] < costos[indiceMinimoReal]) indiceMinimoReal = i;
      }
      expect(indiceMinimoReal, greaterThan(0), reason: 'la instancia debe tener mínimo interior, no en p=1');
      expect(
        indiceMinimoReal,
        lessThan(costos.length - 1),
        reason: 'la instancia debe tener mínimo interior, no en p=pMax',
      );

      // Decreciente antes del mínimo.
      for (var i = 1; i <= indiceMinimoReal; i++) {
        expect(costos[i], lessThan(costos[i - 1]), reason: 'debe decrecer antes del mínimo (i=$i)');
      }
      // Creciente después del mínimo.
      for (var i = indiceMinimoReal + 1; i < costos.length; i++) {
        expect(costos[i], greaterThan(costos[i - 1]), reason: 'debe crecer después del mínimo (i=$i)');
      }

      // El punto marcado como óptimo coincide con el mínimo real.
      expect(resultado.indiceOptimo, indiceMinimoReal);
      expect(resultado.optimo.numeroAlmacenes, indiceMinimoReal + 1);
    },
  );

  test(
    'Test R — en cada punto de la curva, la suma de los siete rubros es exactamente '
    'igual al costo total, sin diferencia por redondeo',
    () async {
      final evaluador = _instanciaConMinimoInterior();
      final resultado = await barrerNumeroAlmacenes(
        candidatosDisponibles: evaluador.candidatosPorId.keys.toList(),
        candidatosPorId: evaluador.candidatosPorId,
        evaluador: evaluador,
      );

      for (final punto in resultado.curva) {
        final sumaRubros = punto.porRubro.values.fold<int>(0, (s, v) => s + v);
        expect(sumaRubros, punto.costoTotalCent, reason: 'p=${punto.numeroAlmacenes}');
      }
    },
  );

  test(
    'Test S — al aumentar el número de almacenes, el rubro de salida no crece '
    'y el de inventario no decrece',
    () async {
      final evaluador = _instanciaConMinimoInterior();
      final resultado = await barrerNumeroAlmacenes(
        candidatosDisponibles: evaluador.candidatosPorId.keys.toList(),
        candidatosPorId: evaluador.candidatosPorId,
        evaluador: evaluador,
      );

      for (var i = 1; i < resultado.curva.length; i++) {
        final anterior = resultado.curva[i - 1];
        final actual = resultado.curva[i];
        expect(
          actual.porRubro[rubroSalida]!,
          lessThanOrEqualTo(anterior.porRubro[rubroSalida]!),
          reason: 'salida no debe crecer de p=${anterior.numeroAlmacenes} a p=${actual.numeroAlmacenes}',
        );
        expect(
          actual.porRubro[rubroInventario]!,
          greaterThanOrEqualTo(anterior.porRubro[rubroInventario]!),
          reason: 'inventario no debe bajar de p=${anterior.numeroAlmacenes} a p=${actual.numeroAlmacenes}',
        );
      }
    },
  );
}
