import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_gestion_pedidos_sla/core/constants.dart';

void main() {
  group('EstadoPedido.siguienteEstado', () {
    test('sigue la secuencia normal', () {
      expect(EstadoPedido.recibido.siguienteEstado, EstadoPedido.procesando);
      expect(
        EstadoPedido.procesando.siguienteEstado,
        EstadoPedido.preparandoEnvio,
      );
      expect(
        EstadoPedido.preparandoEnvio.siguienteEstado,
        EstadoPedido.enTransito,
      );
      expect(EstadoPedido.enTransito.siguienteEstado, EstadoPedido.entregado);
    });

    test('entregado y cancelado son terminales: sin siguiente estado', () {
      expect(EstadoPedido.entregado.siguienteEstado, isNull);
      expect(EstadoPedido.cancelado.siguienteEstado, isNull);
    });
  });

  group('EstadoPedido.puedeAvanzar', () {
    test('true para todos los estados no terminales', () {
      for (final estado in [
        EstadoPedido.recibido,
        EstadoPedido.procesando,
        EstadoPedido.preparandoEnvio,
        EstadoPedido.enTransito,
      ]) {
        expect(estado.puedeAvanzar, isTrue, reason: estado.name);
      }
    });

    test('false para entregado y cancelado', () {
      expect(EstadoPedido.entregado.puedeAvanzar, isFalse);
      expect(EstadoPedido.cancelado.puedeAvanzar, isFalse);
    });
  });

  group('EstadoPedido.puedeCancelar', () {
    test('cancelado es alcanzable desde cualquier estado excepto entregado', () {
      for (final estado in [
        EstadoPedido.recibido,
        EstadoPedido.procesando,
        EstadoPedido.preparandoEnvio,
        EstadoPedido.enTransito,
        EstadoPedido.cancelado,
      ]) {
        expect(estado.puedeCancelar, isTrue, reason: estado.name);
      }
      expect(EstadoPedido.entregado.puedeCancelar, isFalse);
    });
  });

  group('EstadoPedido serialización DB', () {
    test('round-trip valorDb <-> desdeDb para todos los estados', () {
      for (final estado in EstadoPedido.values) {
        expect(EstadoPedido.desdeDb(estado.valorDb), estado);
      }
    });

    test('preparandoEnvio y enTransito usan snake_case en la BD', () {
      expect(EstadoPedido.preparandoEnvio.valorDb, 'preparando_envio');
      expect(EstadoPedido.enTransito.valorDb, 'en_transito');
    });
  });
}
