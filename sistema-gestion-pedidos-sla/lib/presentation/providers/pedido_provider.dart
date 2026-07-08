import 'package:flutter/foundation.dart';

import '../../data/models/historial_estado.dart';
import '../../data/models/pedido.dart';
import '../../data/models/pedido_item.dart';
import '../../data/repositories/pedido_repository.dart';
import '../../domain/calculo_tcp.dart';

enum EstadoPedidoProvider { inactivo, cargando, listo, error }

/// Detalle completo de un pedido: items, historial de estados y el TCP ya
/// calculado a partir de ese historial.
class DetallePedido {
  const DetallePedido({
    required this.pedido,
    required this.items,
    required this.historial,
    required this.tcp,
  });

  final Pedido pedido;
  final List<PedidoItem> items;
  final List<HistorialEstado> historial;
  final ResultadoTcp tcp;
}

/// Estado y lógica del flujo de pedidos: creación transaccional y máquina
/// de estados (M1), con el TCP del detalle recalculado en cada carga (M2).
class PedidoProvider extends ChangeNotifier {
  PedidoProvider(this._repository);

  final PedidoRepository _repository;

  EstadoPedidoProvider estado = EstadoPedidoProvider.inactivo;
  String? mensajeError;
  List<Pedido> pedidos = [];
  DetallePedido? detalle;

  Future<void> cargarTodos() async {
    // No se notifica esta transición a `cargando`: notificar antes del
    // primer `await` de un método invocado desde `initState` ocurre en
    // pleno build del widget y Flutter lo rechaza ("setState() called
    // during build" — ver cargarDetalle más abajo). El estado `inactivo`
    // ya muestra el mismo spinner que `cargando` en las pantallas que lo
    // consumen, así que no hace falta notificar esta transición en sí.
    estado = EstadoPedidoProvider.cargando;

    pedidos = await _repository.obtenerTodos();
    estado = EstadoPedidoProvider.listo;
    notifyListeners();
  }

  Future<bool> crear({
    required int clienteId,
    required int prioridad,
    required List<PedidoItem> items,
  }) async {
    try {
      await _repository.crear(
        clienteId: clienteId,
        prioridad: prioridad,
        items: items,
      );
      await cargarTodos();
      return true;
    } on PedidoSinItems catch (e) {
      _fallarCon(e.toString());
      return false;
    }
  }

  Future<void> cargarDetalle(int pedidoId) async {
    // Se invoca desde `initState` de PedidoDetalleScreen — no notificar acá
    // (ver comentario de cargarTodos). La pantalla ya muestra un spinner
    // mientras `detalle` es null, sin depender de este estado intermedio.
    estado = EstadoPedidoProvider.cargando;

    final pedido = await _repository.obtenerPorId(pedidoId);
    if (pedido == null) {
      _fallarCon('El pedido no existe.');
      return;
    }
    final items = await _repository.obtenerItems(pedidoId);
    final historial = await _repository.obtenerHistorial(pedidoId);

    detalle = DetallePedido(
      pedido: pedido,
      items: items,
      historial: historial,
      tcp: calcularTcp(historial),
    );
    estado = EstadoPedidoProvider.listo;
    notifyListeners();
  }

  Future<bool> avanzarEstado(int pedidoId) async {
    try {
      await _repository.avanzarEstado(pedidoId);
      await cargarDetalle(pedidoId);
      await cargarTodos();
      return true;
    } on TransicionEstadoInvalida catch (e) {
      _fallarCon(e.toString());
      return false;
    }
  }

  Future<bool> cancelar(int pedidoId) async {
    try {
      await _repository.cancelar(pedidoId);
      await cargarDetalle(pedidoId);
      await cargarTodos();
      return true;
    } on TransicionEstadoInvalida catch (e) {
      _fallarCon(e.toString());
      return false;
    }
  }

  void _fallarCon(String mensaje) {
    estado = EstadoPedidoProvider.error;
    mensajeError = mensaje;
    notifyListeners();
  }
}
