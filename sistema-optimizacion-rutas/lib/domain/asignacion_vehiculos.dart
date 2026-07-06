import '../data/models/punto_entrega.dart';
import '../data/models/vehiculo.dart';

/// Una ruta ya calculada (secuencia ordenada de paradas) con el vehículo que
/// la atenderá, si la flota alcanzó para cubrirla.
class RutaAsignada {
  const RutaAsignada({required this.paradas, this.vehiculo});

  final List<PuntoEntrega> paradas;
  final Vehiculo? vehiculo;

  double get demandaTotal => paradas.fold(0.0, (s, p) => s + p.demanda);
}

/// Resultado de un algoritmo de optimización (Ahorros o Barrido): las rutas
/// formadas, cada una con su vehículo asignado (o sin asignar si la flota no
/// alcanzó), y cuántos vehículos adicionales harían falta.
///
/// Ver CLAUDE.md sección 7.1, paso 6: "flota insuficiente" se reporta, no se
/// falla silenciosamente.
class ResultadoOptimizacion {
  const ResultadoOptimizacion({
    required this.rutas,
    required this.vehiculosFaltantes,
  });

  final List<RutaAsignada> rutas;
  final int vehiculosFaltantes;

  bool get flotaInsuficiente => vehiculosFaltantes > 0;
}

/// Asigna cada ruta formada a un vehículo disponible: la ruta de mayor
/// demanda toma el vehículo de menor capacidad que aún le alcance (evita
/// "gastar" de más un vehículo grande en una ruta chica), de forma greedy.
/// Las rutas que no consiguen vehículo quedan sin asignar y cuentan como
/// déficit de flota.
ResultadoOptimizacion asignarVehiculos(
  List<List<PuntoEntrega>> rutas,
  List<Vehiculo> vehiculosDisponibles,
) {
  double demandaDe(List<PuntoEntrega> ruta) =>
      ruta.fold(0.0, (s, p) => s + p.demanda);

  final indicesRutasOrdenados = List<int>.generate(rutas.length, (i) => i)
    ..sort((a, b) => demandaDe(rutas[b]).compareTo(demandaDe(rutas[a])));

  final indicesVehiculosOrdenados =
      List<int>.generate(vehiculosDisponibles.length, (i) => i)..sort(
        (a, b) => vehiculosDisponibles[a].capacidadMaxima.compareTo(
          vehiculosDisponibles[b].capacidadMaxima,
        ),
      );

  final vehiculoUsado = List<bool>.filled(vehiculosDisponibles.length, false);
  final asignacionPorRuta = <int, Vehiculo>{};
  var vehiculosFaltantes = 0;

  for (final idxRuta in indicesRutasOrdenados) {
    final demandaRuta = demandaDe(rutas[idxRuta]);
    int? elegido;
    for (final idxVehiculo in indicesVehiculosOrdenados) {
      if (vehiculoUsado[idxVehiculo]) continue;
      if (vehiculosDisponibles[idxVehiculo].capacidadMaxima >= demandaRuta) {
        elegido = idxVehiculo;
        break;
      }
    }
    if (elegido == null) {
      vehiculosFaltantes++;
    } else {
      vehiculoUsado[elegido] = true;
      asignacionPorRuta[idxRuta] = vehiculosDisponibles[elegido];
    }
  }

  final rutasAsignadas = List<RutaAsignada>.generate(
    rutas.length,
    (i) => RutaAsignada(paradas: rutas[i], vehiculo: asignacionPorRuta[i]),
  );

  return ResultadoOptimizacion(
    rutas: rutasAsignadas,
    vehiculosFaltantes: vehiculosFaltantes,
  );
}
