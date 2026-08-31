import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_red_distribucion/data/models/cliente.dart';
import 'package:sistema_red_distribucion/data/models/parametros_costo.dart';
import 'package:sistema_red_distribucion/data/models/sitio_candidato.dart';
import 'package:sistema_red_distribucion/domain/auditoria/auditor_datos.dart';
import 'package:sistema_red_distribucion/domain/auditoria/hallazgo.dart';

Cliente _cliente({
  int id = 1,
  double latitud = -8.37,
  double longitud = -74.55,
  double demandaAnual = 100,
  int pedidosAnuales = 12,
}) => Cliente(
  id: id,
  proyectoId: 1,
  nombre: 'Cliente $id',
  latitud: latitud,
  longitud: longitud,
  demandaAnual: demandaAnual,
  pedidosAnuales: pedidosAnuales,
);

SitioCandidato _candidato({
  int id = 1,
  double latitud = -8.37,
  double longitud = -74.55,
  int costoFijoAnualCent = 100000,
}) => SitioCandidato(
  id: id,
  proyectoId: 1,
  nombre: 'Candidato $id',
  latitud: latitud,
  longitud: longitud,
  costoFijoAnualCent: costoFijoAnualCent,
  capacidadAnual: 1000,
  costoVariableManejoCentPorUnidad: 100,
  origen: 'manual',
);

ParametrosCosto _parametrosCompletos() => const ParametrosCosto(
  proyectoId: 1,
  tarifaEntradaFijaCent: 100,
  tarifaEntradaCentPorKmTon: 10,
  tarifaSalidaFijaCent: 100,
  tarifaSalidaCentPorKmTon: 10,
  tasaManejoInventarioAnual: 0.2,
  valorPorUnidadCent: 100000,
  inventarioBaseUnaUbicacion: 10,
  costoPorPedidoCent: 50,
  tipoEstandar: 'distancia',
  estandarServicioValor: 50000,
);

List<String> _reglas(List<Hallazgo> hallazgos) =>
    hallazgos.map((h) => h.regla).toList();

void main() {
  group('coordenada_fuera_de_rango', () {
    test('caso positivo: cliente con latitud fuera de rango se marca', () {
      final hallazgos = auditarDatos(
        clientes: [_cliente(latitud: 91)],
        candidatos: [],
        parametrosCosto: _parametrosCompletos(),
      );
      expect(_reglas(hallazgos), contains('coordenada_fuera_de_rango'));
    });

    test('caso negativo: coordenadas válidas no generan el hallazgo', () {
      final hallazgos = auditarDatos(
        clientes: [_cliente()],
        candidatos: [_candidato()],
        parametrosCosto: _parametrosCompletos(),
      );
      expect(_reglas(hallazgos), isNot(contains('coordenada_fuera_de_rango')));
    });
  });

  group('coordenada_duplicada', () {
    test('caso positivo: dos clientes con la misma coordenada exacta', () {
      final hallazgos = auditarDatos(
        clientes: [
          _cliente(id: 1, latitud: 1, longitud: 1),
          _cliente(id: 2, latitud: 1, longitud: 1),
        ],
        candidatos: [],
        parametrosCosto: _parametrosCompletos(),
      );
      expect(_reglas(hallazgos), contains('coordenada_duplicada'));
    });

    test('caso negativo: coordenadas distintas no generan el hallazgo', () {
      final hallazgos = auditarDatos(
        clientes: [
          _cliente(id: 1, latitud: 1, longitud: 1),
          _cliente(id: 2, latitud: 2, longitud: 2),
        ],
        candidatos: [],
        parametrosCosto: _parametrosCompletos(),
      );
      expect(_reglas(hallazgos), isNot(contains('coordenada_duplicada')));
    });
  });

  group('demanda_no_positiva', () {
    test('caso positivo: demanda cero se marca', () {
      final hallazgos = auditarDatos(
        clientes: [_cliente(demandaAnual: 0)],
        candidatos: [],
        parametrosCosto: _parametrosCompletos(),
      );
      expect(_reglas(hallazgos), contains('demanda_no_positiva'));
    });

    test('caso negativo: demanda positiva no genera el hallazgo', () {
      final hallazgos = auditarDatos(
        clientes: [_cliente(demandaAnual: 50)],
        candidatos: [],
        parametrosCosto: _parametrosCompletos(),
      );
      expect(_reglas(hallazgos), isNot(contains('demanda_no_positiva')));
    });
  });

  group('cliente_sin_pedidos', () {
    test('caso positivo: cero pedidos anuales se marca', () {
      final hallazgos = auditarDatos(
        clientes: [_cliente(pedidosAnuales: 0)],
        candidatos: [],
        parametrosCosto: _parametrosCompletos(),
      );
      expect(_reglas(hallazgos), contains('cliente_sin_pedidos'));
    });

    test('caso negativo: con pedidos no genera el hallazgo', () {
      final hallazgos = auditarDatos(
        clientes: [_cliente(pedidosAnuales: 5)],
        candidatos: [],
        parametrosCosto: _parametrosCompletos(),
      );
      expect(_reglas(hallazgos), isNot(contains('cliente_sin_pedidos')));
    });
  });

  group('candidato_sin_costo_fijo', () {
    test('caso positivo: costo fijo cero se marca', () {
      final hallazgos = auditarDatos(
        clientes: [],
        candidatos: [_candidato(costoFijoAnualCent: 0)],
        parametrosCosto: _parametrosCompletos(),
      );
      expect(_reglas(hallazgos), contains('candidato_sin_costo_fijo'));
    });

    test('caso negativo: con costo fijo no genera el hallazgo', () {
      final hallazgos = auditarDatos(
        clientes: [],
        candidatos: [_candidato(costoFijoAnualCent: 5000)],
        parametrosCosto: _parametrosCompletos(),
      );
      expect(_reglas(hallazgos), isNot(contains('candidato_sin_costo_fijo')));
    });
  });

  group('tarifa_faltante', () {
    test('caso positivo: sin parámetros de costo configurados', () {
      final hallazgos = auditarDatos(
        clientes: [],
        candidatos: [],
        parametrosCosto: null,
      );
      expect(_reglas(hallazgos), contains('tarifa_faltante'));
    });

    test('caso positivo: una tarifa en cero se marca aunque el resto esté completo', () {
      final incompletos = _parametrosCompletos().copyWith(
        tarifaSalidaFijaCent: 0,
      );
      final hallazgos = auditarDatos(
        clientes: [],
        candidatos: [],
        parametrosCosto: incompletos,
      );
      expect(_reglas(hallazgos), contains('tarifa_faltante'));
    });

    test('caso negativo: todas las tarifas cargadas no genera el hallazgo', () {
      final hallazgos = auditarDatos(
        clientes: [],
        candidatos: [],
        parametrosCosto: _parametrosCompletos(),
      );
      expect(_reglas(hallazgos), isNot(contains('tarifa_faltante')));
    });
  });
}
