import '../../data/models/cliente.dart';
import '../../data/models/parametros_costo.dart';
import '../../data/models/sitio_candidato.dart';
import 'hallazgo.dart';

/// Pantalla 4 (CLAUDE.md sección 8): las seis reglas de auditoría de datos
/// de la Fase 2. Función pura — recibe los datos ya cargados del proyecto y
/// devuelve la lista de hallazgos, sin tocar la base de datos.
List<Hallazgo> auditarDatos({
  required List<Cliente> clientes,
  required List<SitioCandidato> candidatos,
  required ParametrosCosto? parametrosCosto,
}) {
  final hallazgos = <Hallazgo>[];

  hallazgos.addAll(_coordenadaFueraDeRango(clientes, candidatos));
  hallazgos.addAll(_coordenadaDuplicada(clientes, candidatos));
  hallazgos.addAll(_demandaNoPositiva(clientes));
  hallazgos.addAll(_clienteSinPedidos(clientes));
  hallazgos.addAll(_candidatoSinCostoFijo(candidatos));
  hallazgos.addAll(_tarifaFaltante(parametrosCosto));

  return hallazgos;
}

bool _fueraDeRango(double lat, double lon) =>
    lat < -90 || lat > 90 || lon < -180 || lon > 180;

List<Hallazgo> _coordenadaFueraDeRango(
  List<Cliente> clientes,
  List<SitioCandidato> candidatos,
) {
  final hallazgos = <Hallazgo>[];
  for (final c in clientes) {
    if (_fueraDeRango(c.latitud, c.longitud)) {
      hallazgos.add(
        Hallazgo(
          severidad: SeveridadHallazgo.error,
          regla: 'coordenada_fuera_de_rango',
          mensaje: 'El cliente "${c.nombre}" tiene una coordenada fuera de rango '
              '(${c.latitud}, ${c.longitud}).',
          accionSugerida: 'Corregir la latitud/longitud del cliente.',
          entidadId: c.id,
        ),
      );
    }
  }
  for (final s in candidatos) {
    if (_fueraDeRango(s.latitud, s.longitud)) {
      hallazgos.add(
        Hallazgo(
          severidad: SeveridadHallazgo.error,
          regla: 'coordenada_fuera_de_rango',
          mensaje: 'El sitio candidato "${s.nombre}" tiene una coordenada fuera '
              'de rango (${s.latitud}, ${s.longitud}).',
          accionSugerida: 'Corregir la latitud/longitud del sitio candidato.',
          entidadId: s.id,
        ),
      );
    }
  }
  return hallazgos;
}

List<Hallazgo> _coordenadaDuplicada(
  List<Cliente> clientes,
  List<SitioCandidato> candidatos,
) {
  final hallazgos = <Hallazgo>[];

  final vistosClientes = <String, Cliente>{};
  for (final c in clientes) {
    final clave = '${c.latitud},${c.longitud}';
    final anterior = vistosClientes[clave];
    if (anterior != null) {
      hallazgos.add(
        Hallazgo(
          severidad: SeveridadHallazgo.advertencia,
          regla: 'coordenada_duplicada',
          mensaje: 'Los clientes "${anterior.nombre}" y "${c.nombre}" comparten '
              'exactamente la misma coordenada.',
          accionSugerida: 'Verificar si son el mismo cliente cargado dos veces, '
              'o si a alguno le falta la coordenada real.',
          entidadId: c.id,
        ),
      );
    } else {
      vistosClientes[clave] = c;
    }
  }

  final vistosCandidatos = <String, SitioCandidato>{};
  for (final s in candidatos) {
    final clave = '${s.latitud},${s.longitud}';
    final anterior = vistosCandidatos[clave];
    if (anterior != null) {
      hallazgos.add(
        Hallazgo(
          severidad: SeveridadHallazgo.advertencia,
          regla: 'coordenada_duplicada',
          mensaje: 'Los sitios candidatos "${anterior.nombre}" y "${s.nombre}" '
              'comparten exactamente la misma coordenada.',
          accionSugerida: 'Verificar si son el mismo sitio cargado dos veces.',
          entidadId: s.id,
        ),
      );
    } else {
      vistosCandidatos[clave] = s;
    }
  }

  return hallazgos;
}

List<Hallazgo> _demandaNoPositiva(List<Cliente> clientes) {
  return clientes
      .where((c) => c.demandaAnual <= 0)
      .map(
        (c) => Hallazgo(
          severidad: SeveridadHallazgo.error,
          regla: 'demanda_no_positiva',
          mensaje: 'El cliente "${c.nombre}" tiene demanda anual ${c.demandaAnual}, '
              'no positiva.',
          accionSugerida: 'Cargar la demanda anual real del cliente.',
          entidadId: c.id,
        ),
      )
      .toList();
}

List<Hallazgo> _clienteSinPedidos(List<Cliente> clientes) {
  return clientes
      .where((c) => c.pedidosAnuales <= 0)
      .map(
        (c) => Hallazgo(
          severidad: SeveridadHallazgo.advertencia,
          regla: 'cliente_sin_pedidos',
          mensaje: 'El cliente "${c.nombre}" no tiene pedidos anuales cargados.',
          accionSugerida: 'Cargar el número de pedidos anuales (afecta el costo '
              'de procesamiento de pedidos, M4).',
          entidadId: c.id,
        ),
      )
      .toList();
}

List<Hallazgo> _candidatoSinCostoFijo(List<SitioCandidato> candidatos) {
  return candidatos
      .where((s) => s.costoFijoAnualCent <= 0)
      .map(
        (s) => Hallazgo(
          severidad: SeveridadHallazgo.error,
          regla: 'candidato_sin_costo_fijo',
          mensaje: 'El sitio candidato "${s.nombre}" no tiene costo fijo anual '
              'cargado.',
          accionSugerida: 'Cargar el costo fijo anual del sitio (renta, '
              'amortización, mantenimiento).',
          entidadId: s.id,
        ),
      )
      .toList();
}

List<Hallazgo> _tarifaFaltante(ParametrosCosto? parametros) {
  if (parametros == null) {
    return const [
      Hallazgo(
        severidad: SeveridadHallazgo.error,
        regla: 'tarifa_faltante',
        mensaje: 'El proyecto todavía no tiene parámetros de costo configurados.',
        accionSugerida: 'Completar la pantalla de Parámetros de costo.',
      ),
    ];
  }

  final campos = <String, int>{
    'tarifa de entrada fija': parametros.tarifaEntradaFijaCent,
    'tarifa de entrada por km-tonelada': parametros.tarifaEntradaCentPorKmTon,
    'tarifa de salida fija': parametros.tarifaSalidaFijaCent,
    'tarifa de salida por km-tonelada': parametros.tarifaSalidaCentPorKmTon,
    'valor por unidad': parametros.valorPorUnidadCent,
    'costo por pedido': parametros.costoPorPedidoCent,
  };

  return campos.entries
      .where((e) => e.value <= 0)
      .map(
        (e) => Hallazgo(
          severidad: SeveridadHallazgo.error,
          regla: 'tarifa_faltante',
          mensaje: 'Falta cargar la ${e.key} en Parámetros de costo.',
          accionSugerida: 'Completar ese campo en la pantalla de Parámetros de '
              'costo.',
        ),
      )
      .toList();
}
