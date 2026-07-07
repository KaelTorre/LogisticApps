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
/// entregados, distribución ABC (conteo y valor por categoría) y el `SL*`
/// recalculado on-the-fly desde los coeficientes guardados — no se
/// persiste un "último resultado" aparte, siempre se deriva de
/// `configuracion_sla`.
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
  Map<CategoriaAbc, int> conteoAbc = {};
  Map<CategoriaAbc, double> valorAbc = {};
  ResultadoOptimizacionServicio? optimoActual;

  Future<void> cargar() async {
    estado = EstadoDashboard.cargando;
    notifyListeners();

    final pedidos = await _pedidoRepository.obtenerTodos();
    cantidadPedidosTotal = pedidos.length;

    final duraciones = <Duration>[];
    for (final pedido in pedidos) {
      final historial = await _pedidoRepository.obtenerHistorial(pedido.id!);
      final tcp = calcularTcp(historial);
      if (tcp.tcpTotal != null) duraciones.add(tcp.tcpTotal!);
    }
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
