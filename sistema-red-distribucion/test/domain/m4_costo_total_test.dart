import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_red_distribucion/data/models/celda_matriz.dart';
import 'package:sistema_red_distribucion/data/models/parametros_costo.dart';
import 'package:sistema_red_distribucion/data/models/planta.dart';
import 'package:sistema_red_distribucion/data/models/sitio_candidato.dart';
import 'package:sistema_red_distribucion/data/models/zona_demanda.dart';
import 'package:sistema_red_distribucion/domain/motor/m4_costo_total.dart';

void main() {
  test(
    'Test dorado F — costo a mano: dos zonas y un almacén, comparado céntimo a céntimo',
    () {
      final planta = Planta(
        id: 1,
        proyectoId: 1,
        nombre: 'P1',
        latitud: 0,
        longitud: 0,
        capacidadAnual: 10000,
        costoProduccionCentPorUnidad: 500, // 5.00/tonelada
      );
      final candidato = SitioCandidato(
        id: 1,
        proyectoId: 1,
        nombre: 'C1',
        latitud: 0,
        longitud: 0,
        costoFijoAnualCent: 1000000, // 10 000.00 anual
        capacidadAnual: 1000,
        costoVariableManejoCentPorUnidad: 200, // 2.00/tonelada
        origen: 'manual',
      );
      final zona1 = ZonaDemanda(
        id: 1,
        proyectoId: 1,
        etiqueta: 'Z1',
        latitud: 0,
        longitud: 0,
        demandaAgregada: 100,
        pedidosAgregados: 20,
        numeroClientes: 1,
        errorAgregacionMetros: 0,
      );
      final zona2 = ZonaDemanda(
        id: 2,
        proyectoId: 1,
        etiqueta: 'Z2',
        latitud: 0,
        longitud: 0,
        demandaAgregada: 50,
        pedidosAgregados: 10,
        numeroClientes: 1,
        errorAgregacionMetros: 0,
      );
      const params = ParametrosCosto(
        proyectoId: 1,
        tarifaEntradaFijaCent: 50,
        tarifaEntradaCentPorKmTon: 10,
        tarifaSalidaFijaCent: 30,
        tarifaSalidaCentPorKmTon: 5,
        tasaManejoInventarioAnual: 0.2,
        valorPorUnidadCent: 1000,
        inventarioBaseUnaUbicacion: 50,
        costoPorPedidoCent: 200,
        tipoEstandar: 'distancia',
        estandarServicioValor: 1000000,
      );

      final resultado = calcularCostoTotal(
        abiertos: [1],
        candidatosPorId: {1: candidato},
        plantas: [planta],
        zonas: [zona1, zona2],
        asignacionZonaCandidato: {1: 1, 2: 1},
        distanciaZonaCandidato: {
          (1, 1): const CeldaMatriz(
            proyectoId: 1,
            tipoOrigen: 'candidato',
            origenId: 1,
            tipoDestino: 'zona',
            destinoId: 1,
            distanciaMetros: 10000,
            duracionSegundos: 600,
            fuente: 'osrm',
          ),
          (2, 1): const CeldaMatriz(
            proyectoId: 1,
            tipoOrigen: 'candidato',
            origenId: 1,
            tipoDestino: 'zona',
            destinoId: 2,
            distanciaMetros: 20000,
            duracionSegundos: 1200,
            fuente: 'osrm',
          ),
        },
        distanciaPlantaCandidato: {
          (1, 1): const CeldaMatriz(
            proyectoId: 1,
            tipoOrigen: 'planta',
            origenId: 1,
            tipoDestino: 'candidato',
            destinoId: 1,
            distanciaMetros: 5000,
            duracionSegundos: 300,
            fuente: 'osrm',
          ),
        },
        params: params,
      );

      // Cálculo a mano:
      // volumen_almacén = 100 + 50 = 150
      // c_produccion = 100*500 + 50*500 = 50 000 + 25 000 = 75 000
      // c_entrada = 150 * (50 + 10*(5000/1000)) = 150 * 100 = 15 000
      // c_salida  = 100*(30+5*(10000/1000)) + 50*(30+5*(20000/1000))
      //           = 100*80 + 50*130 = 8 000 + 6 500 = 14 500
      // c_fijo    = 1 000 000
      // c_manejo  = 150 * 200 = 30 000
      // c_inventario = (50*sqrt(1)) * 1000 * 0.2 = 50*1000*0.2 = 10 000
      // c_pedidos = (20+10) * 200 = 6 000
      // total     = 75000+15000+14500+1000000+30000+10000+6000 = 1 150 500
      expect(resultado.porRubro[rubroProduccion], 75000);
      expect(resultado.porRubro[rubroEntrada], 15000);
      expect(resultado.porRubro[rubroSalida], 14500);
      expect(resultado.porRubro[rubroFijo], 1000000);
      expect(resultado.porRubro[rubroManejo], 30000);
      expect(resultado.porRubro[rubroInventario], 10000);
      expect(resultado.porRubro[rubroPedidos], 6000);
      expect(resultado.costoTotalCent, 1150500);
    },
  );

  test('Test K — cada ejecución de M4 produce al menos una fila de memoria por rubro', () {
    final candidato = SitioCandidato(
      id: 1,
      proyectoId: 1,
      nombre: 'C1',
      latitud: 0,
      longitud: 0,
      costoFijoAnualCent: 1000,
      capacidadAnual: 1000,
      costoVariableManejoCentPorUnidad: 10,
      origen: 'manual',
    );
    final zona = ZonaDemanda(
      id: 1,
      proyectoId: 1,
      etiqueta: 'Z1',
      latitud: 0,
      longitud: 0,
      demandaAgregada: 10,
      pedidosAgregados: 5,
      numeroClientes: 1,
      errorAgregacionMetros: 0,
    );
    const params = ParametrosCosto(
      proyectoId: 1,
      tarifaEntradaFijaCent: 10,
      tarifaEntradaCentPorKmTon: 1,
      tarifaSalidaFijaCent: 10,
      tarifaSalidaCentPorKmTon: 1,
      tasaManejoInventarioAnual: 0.1,
      valorPorUnidadCent: 100,
      inventarioBaseUnaUbicacion: 10,
      costoPorPedidoCent: 50,
      tipoEstandar: 'distancia',
      estandarServicioValor: 1000000,
    );

    final resultado = calcularCostoTotal(
      abiertos: [1],
      candidatosPorId: {1: candidato},
      plantas: const [],
      zonas: [zona],
      asignacionZonaCandidato: {1: 1},
      distanciaZonaCandidato: {
        (1, 1): const CeldaMatriz(
          proyectoId: 1,
          tipoOrigen: 'candidato',
          origenId: 1,
          tipoDestino: 'zona',
          destinoId: 1,
          distanciaMetros: 1000,
          duracionSegundos: 60,
          fuente: 'osrm',
        ),
      },
      distanciaPlantaCandidato: const {},
      params: params,
    );

    for (final rubro in [
      rubroProduccion,
      rubroEntrada,
      rubroSalida,
      rubroFijo,
      rubroManejo,
      rubroInventario,
      rubroPedidos,
    ]) {
      final tieneFila = resultado.memoria.any((f) => f.salida == '${resultado.porRubro[rubro]}');
      expect(tieneFila, isTrue, reason: 'sin fila de memoria para el rubro $rubro');
    }
    expect(resultado.memoria.length, greaterThanOrEqualTo(7));
  });

  test('sin plantas cargadas, producción y entrada quedan en cero (no hay de dónde sacarlos)', () {
    final candidato = SitioCandidato(
      id: 1,
      proyectoId: 1,
      nombre: 'C1',
      latitud: 0,
      longitud: 0,
      costoFijoAnualCent: 500,
      capacidadAnual: 1000,
      costoVariableManejoCentPorUnidad: 5,
      origen: 'manual',
    );
    final zona = ZonaDemanda(
      id: 1,
      proyectoId: 1,
      etiqueta: 'Z1',
      latitud: 0,
      longitud: 0,
      demandaAgregada: 10,
      pedidosAgregados: 1,
      numeroClientes: 1,
      errorAgregacionMetros: 0,
    );
    const params = ParametrosCosto(
      proyectoId: 1,
      tarifaEntradaFijaCent: 10,
      tarifaEntradaCentPorKmTon: 1,
      tarifaSalidaFijaCent: 10,
      tarifaSalidaCentPorKmTon: 1,
      tasaManejoInventarioAnual: 0.1,
      valorPorUnidadCent: 100,
      inventarioBaseUnaUbicacion: 10,
      costoPorPedidoCent: 50,
      tipoEstandar: 'distancia',
      estandarServicioValor: 1000000,
    );

    final resultado = calcularCostoTotal(
      abiertos: [1],
      candidatosPorId: {1: candidato},
      plantas: const [],
      zonas: [zona],
      asignacionZonaCandidato: {1: 1},
      distanciaZonaCandidato: {
        (1, 1): const CeldaMatriz(
          proyectoId: 1,
          tipoOrigen: 'candidato',
          origenId: 1,
          tipoDestino: 'zona',
          destinoId: 1,
          distanciaMetros: 1000,
          duracionSegundos: 60,
          fuente: 'osrm',
        ),
      },
      distanciaPlantaCandidato: const {},
      params: params,
    );

    expect(resultado.porRubro[rubroProduccion], 0);
    expect(resultado.porRubro[rubroEntrada], 0);
  });
}
