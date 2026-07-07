import '../core/constants.dart';
import '../data/models/historial_estado.dart';

/// Duración entre dos transiciones consecutivas del historial de un pedido.
class EtapaTcp {
  final EstadoPedido desde;
  final EstadoPedido hasta;
  final Duration duracion;

  const EtapaTcp({
    required this.desde,
    required this.hasta,
    required this.duracion,
  });
}

/// Resultado del cálculo de Tiempo de Ciclo del Pedido (CLAUDE.md §6.2).
///
/// [tcpTotal] es `null` mientras el pedido no llegue a `entregado` — nunca
/// se calcula un total falso a partir de un ciclo incompleto.
class ResultadoTcp {
  final List<EtapaTcp> etapas;
  final Duration? tcpTotal;
  final bool enCurso;

  const ResultadoTcp({
    required this.etapas,
    required this.tcpTotal,
    required this.enCurso,
  });
}

/// Calcula la duración de cada etapa y el TCP total a partir del historial
/// de estados de un pedido. [historial] no necesita venir ordenado.
ResultadoTcp calcularTcp(List<HistorialEstado> historial) {
  final ordenado = [...historial]
    ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

  final etapas = <EtapaTcp>[
    for (var i = 0; i < ordenado.length - 1; i++)
      EtapaTcp(
        desde: ordenado[i].estado,
        hasta: ordenado[i + 1].estado,
        duracion: ordenado[i + 1].timestamp.difference(ordenado[i].timestamp),
      ),
  ];

  final indiceEntregado = ordenado.indexWhere(
    (h) => h.estado == EstadoPedido.entregado,
  );
  if (indiceEntregado == -1 || ordenado.isEmpty) {
    return ResultadoTcp(etapas: etapas, tcpTotal: null, enCurso: true);
  }

  final tcpTotal = ordenado[indiceEntregado].timestamp.difference(
    ordenado.first.timestamp,
  );
  return ResultadoTcp(etapas: etapas, tcpTotal: tcpTotal, enCurso: false);
}
