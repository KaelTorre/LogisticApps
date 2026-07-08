// ignore_for_file: prefer_initializing_formals (campos privados, parámetros
// públicos con nombre propio; ver mismo caso en el proyecto de Unidad 3)
import 'package:flutter/foundation.dart';

import '../../core/constants.dart';
import '../../data/repositories/configuracion_repository.dart';
import '../../data/repositories/pedido_repository.dart';
import '../../domain/calculo_tcp.dart';
import '../../domain/clasificacion_abc.dart';
import '../../domain/optimizacion_nivel_servicio.dart';

enum EstadoDashboard { inactivo, cargando, listo, error }

/// Agrega los indicadores del dashboard (M6): TCP promedio de pedidos
/// entregados, valor total en pedidos, conteo por estado, distribución ABC
/// (conteo y valor por categoría) y el `SL*` recalculado on-the-fly desde
/// los coeficientes guardados — no se persiste un "último resultado"
/// aparte, siempre se deriva de `configuracion_sla`.
class DashboardProvider extends ChangeNotifier {
  DashboardProvider({
    required PedidoRepository pedidoRepository,
    required ConfiguracionRepository configuracionRepository,
  }) : _pedidoRepository = pedidoRepository,
       _configuracionRepository = configuracionRepository;

  final PedidoRepository _pedidoRepository;
  final ConfiguracionRepository _configuracionRepository;

  EstadoDashboard estado = EstadoDashboard.inactivo;

  Duration? tcpPromedio;
  int cantidadPedidosEntregados = 0;
  int cantidadPedidosTotal = 0;
  double valorTotalPedidos = 0;
  Map<EstadoPedido, int> conteoPorEstado = {};
  Map<CategoriaAbc, int> conteoAbc = {};
  Map<CategoriaAbc, double> valorAbc = {};
  ResultadoOptimizacionServicio? optimoActual;

  int get pedidosCancelados => conteoPorEstado[EstadoPedido.cancelado] ?? 0;

  int get pedidosActivos =>
      cantidadPedidosTotal - cantidadPedidosEntregados - pedidosCancelados;

  Future<void> cargar() async {
    // Se invoca desde `initState` de DashboardScreen — no notificar esta
    // transición (mismo motivo que en PedidoProvider/AbcProvider:
    // notificar antes del primer `await` ocurre en pleno build y Flutter
    // lo rechaza). El estado `inactivo` ya muestra el mismo spinner que
    // `cargando`.
    estado = EstadoDashboard.cargando;

    final pedidos = await _pedidoRepository.obtenerTodos();
    cantidadPedidosTotal = pedidos.length;

    final duraciones = <Duration>[];
    final conteo = {for (final e in EstadoPedido.values) e: 0};
    var valorTotal = 0.0;

    for (final pedido in pedidos) {
      conteo[pedido.estadoActual] = (conteo[pedido.estadoActual] ?? 0) + 1;

      final historial = await _pedidoRepository.obtenerHistorial(pedido.id!);
      final tcp = calcularTcp(historial);
      if (tcp.tcpTotal != null) duraciones.add(tcp.tcpTotal!);

      final items = await _pedidoRepository.obtenerItems(pedido.id!);
      valorTotal += items.fold(0.0, (suma, item) => suma + item.subtotal);
    }

    conteoPorEstado = conteo;
    valorTotalPedidos = valorTotal;
    cantidadPedidosEntregados = duraciones.length;
    tcpPromedio = duraciones.isEmpty
        ? null
        : Duration(
            microseconds:
                (duraciones.fold<int>(0, (s, d) => s + d.inMicroseconds) /
                        duraciones.length)
                    .round(),
          );

    final valores = await _pedidoRepository.valorTotalGeneradoPorProducto();
    final clasificados = clasificarAbc(valores);
    conteoAbc = {
      for (final c in CategoriaAbc.values)
        c: clasificados.where((p) => p.categoria == c).length,
    };
    valorAbc = {
      for (final c in CategoriaAbc.values)
        c: clasificados
            .where((p) => p.categoria == c)
            .fold(0.0, (s, p) => s + p.valorTotalGenerado),
    };

    final config = await _configuracionRepository.obtenerOCrearPorDefecto();
    try {
      optimoActual = calcularNivelServicioOptimo(
        a: config.coeficienteIngreso,
        b: config.coeficienteCosto,
      );
    } on CoeficienteCostoInvalido {
      optimoActual = null;
    }

    estado = EstadoDashboard.listo;
    notifyListeners();
  }
}
