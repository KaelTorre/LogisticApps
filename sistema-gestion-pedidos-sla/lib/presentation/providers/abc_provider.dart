// ignore_for_file: prefer_initializing_formals (campos privados, parámetros
// públicos con nombre propio; ver mismo caso en el proyecto de Unidad 3)
import 'package:flutter/foundation.dart';

import '../../data/models/producto.dart';
import '../../data/repositories/pedido_repository.dart';
import '../../data/repositories/producto_repository.dart';
import '../../domain/clasificacion_abc.dart';

enum EstadoAbc { inactivo, cargando, listo, error }

/// Estado y lógica de la pantalla de Clasificación ABC (M3): agrega el
/// valor generado por producto a partir de todos los `pedido_item`
/// históricos y aplica la regla 20/30/50 de CLAUDE.md §6.3.
class AbcProvider extends ChangeNotifier {
  AbcProvider({
    required PedidoRepository pedidoRepository,
    required ProductoRepository productoRepository,
  }) : _pedidoRepository = pedidoRepository,
       _productoRepository = productoRepository;

  final PedidoRepository _pedidoRepository;
  final ProductoRepository _productoRepository;

  EstadoAbc estado = EstadoAbc.inactivo;
  String? mensajeError;
  List<ProductoClasificado> clasificados = [];
  Map<int, Producto> productosPorId = {};

  Future<void> cargar() async {
    estado = EstadoAbc.cargando;
    notifyListeners();

    try {
      final valores = await _pedidoRepository.valorTotalGeneradoPorProducto();
      final productos = await _productoRepository.obtenerTodos();
      productosPorId = {for (final p in productos) p.id!: p};
      clasificados = clasificarAbc(valores);
      estado = EstadoAbc.listo;
      notifyListeners();
    } catch (e) {
      estado = EstadoAbc.error;
      mensajeError = e.toString();
      notifyListeners();
    }
  }
}
