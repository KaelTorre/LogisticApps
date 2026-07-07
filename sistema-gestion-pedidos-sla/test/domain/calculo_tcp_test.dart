import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_gestion_pedidos_sla/core/constants.dart';
import 'package:sistema_gestion_pedidos_sla/data/models/historial_estado.dart';
import 'package:sistema_gestion_pedidos_sla/domain/calculo_tcp.dart';

HistorialEstado _evento(EstadoPedido estado, int minutosDesdeInicio) {
  return HistorialEstado(
    pedidoId: 1,
    estado: estado,
    timestamp: DateTime(2026, 1, 1).add(Duration(minutes: minutosDesdeInicio)),
  );
}

void main() {
  group('calcularTcp', () {
    test('ciclo completo: suma de etapas coincide con el total', () {
      final historial = [
        _evento(EstadoPedido.recibido, 0),
        _evento(EstadoPedido.procesando, 30),
        _evento(EstadoPedido.preparandoEnvio, 90),
        _evento(EstadoPedido.enTransito, 150),
        _evento(EstadoPedido.entregado, 300),
      ];

      final resultado = calcularTcp(historial);

      expect(resultado.enCurso, isFalse);
      expect(resultado.tcpTotal, const Duration(minutes: 300));
      expect(resultado.etapas, hasLength(4));
      final sumaEtapas = resultado.etapas.fold<Duration>(
        Duration.zero,
        (acc, e) => acc + e.duracion,
      );
      expect(sumaEtapas, resultado.tcpTotal);
    });

    test('pedido en curso (sin entregado): total null, solo etapas completadas', () {
      final historial = [
        _evento(EstadoPedido.recibido, 0),
        _evento(EstadoPedido.procesando, 20),
      ];

      final resultado = calcularTcp(historial);

      expect(resultado.enCurso, isTrue);
      expect(resultado.tcpTotal, isNull);
      expect(resultado.etapas, hasLength(1));
    });

    test('pedido cancelado a mitad de camino: no calcula un total falso', () {
      final historial = [
        _evento(EstadoPedido.recibido, 0),
        _evento(EstadoPedido.procesando, 15),
        _evento(EstadoPedido.cancelado, 40),
      ];

      final resultado = calcularTcp(historial);

      expect(resultado.enCurso, isTrue);
      expect(resultado.tcpTotal, isNull);
      expect(resultado.etapas, hasLength(2));
    });

    test('un solo evento: etapas vacías, en curso', () {
      final resultado = calcularTcp([_evento(EstadoPedido.recibido, 0)]);

      expect(resultado.etapas, isEmpty);
      expect(resultado.tcpTotal, isNull);
      expect(resultado.enCurso, isTrue);
    });

    test('historial desordenado se ordena por timestamp antes de calcular', () {
      final historial = [
        _evento(EstadoPedido.entregado, 100),
        _evento(EstadoPedido.recibido, 0),
        _evento(EstadoPedido.procesando, 40),
      ];

      final resultado = calcularTcp(historial);

      expect(resultado.tcpTotal, const Duration(minutes: 100));
      expect(resultado.etapas.first.desde, EstadoPedido.recibido);
      expect(resultado.etapas.first.hasta, EstadoPedido.procesando);
    });
  });
}
