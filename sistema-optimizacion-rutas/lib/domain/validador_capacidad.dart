import '../data/models/punto_entrega.dart';

bool rutaExcedeCapacidad(List<PuntoEntrega> puntos, double capacidadMaxima) {
  final demandaTotal = puntos.fold(0.0, (sum, p) => sum + p.demanda);
  return demandaTotal > capacidadMaxima;
}
