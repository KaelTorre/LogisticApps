import 'dart:math';

import 'package:paquete_geo_logistica/paquete_geo_logistica.dart';

import '../../data/models/cliente.dart';

/// Una zona de demanda ya calculada por [agregarEnZonas] — todavía no tiene
/// `id`/`proyectoId` (los asigna el repositorio al guardarla).
class ZonaAgregada {
  const ZonaAgregada({
    required this.latitud,
    required this.longitud,
    required this.demandaAgregada,
    required this.pedidosAgregados,
    required this.clienteIds,
    required this.errorAgregacionMetros,
  });

  final double latitud;
  final double longitud;
  final double demandaAgregada;
  final int pedidosAgregados;
  final List<int> clienteIds;
  final int errorAgregacionMetros;

  int get numeroClientes => clienteIds.length;
}

/// M1 — agregación de clientes en zonas de demanda (CLAUDE.md sección 7).
/// k-means geográfico ponderado por demanda, con inicialización
/// k-means++ (semilla explícita y reproducible, [semilla]). Usa siempre
/// haversine — nunca el servicio de ruteo (`[REGLA]`, sección 7: agrupar
/// clientes no requiere distancia por carretera).
///
/// Si `clientes.length <= k`, cada cliente es su propia zona (con error de
/// agregación exactamente cero) y no corre el algoritmo.
List<ZonaAgregada> agregarEnZonas({
  required List<Cliente> clientes,
  required int k,
  int semilla = 42,
  int maxIteraciones = 100,
}) {
  if (clientes.isEmpty) return const [];

  if (clientes.length <= k) {
    return clientes
        .map(
          (c) => ZonaAgregada(
            latitud: c.latitud,
            longitud: c.longitud,
            demandaAgregada: c.demandaAnual,
            pedidosAgregados: c.pedidosAnuales,
            clienteIds: [c.id!],
            errorAgregacionMetros: 0,
          ),
        )
        .toList();
  }

  final random = Random(semilla);
  var centroides = _inicializarKMeansPlusPlus(clientes, k, random);

  var asignacionAnterior = List<int>.filled(clientes.length, -1);
  var asignacion = List<int>.filled(clientes.length, -1);

  for (var iteracion = 0; iteracion < maxIteraciones; iteracion++) {
    for (var i = 0; i < clientes.length; i++) {
      asignacion[i] = _centroideMasCercano(clientes[i], centroides);
    }

    if (iteracion > 0 && _listasIguales(asignacion, asignacionAnterior)) {
      break;
    }
    asignacionAnterior = List.of(asignacion);

    centroides = _recalcularCentroides(
      clientes: clientes,
      asignacion: asignacion,
      k: k,
      centroidesAnteriores: centroides,
    );
  }

  final zonas = <ZonaAgregada>[];
  for (var c = 0; c < k; c++) {
    final indicesMiembros = [
      for (var i = 0; i < clientes.length; i++)
        if (asignacion[i] == c) i,
    ];
    if (indicesMiembros.isEmpty) continue;

    final miembros = indicesMiembros.map((i) => clientes[i]).toList();
    final demandaTotal = miembros.fold(0.0, (s, c) => s + c.demandaAnual);
    final pedidosTotal = miembros.fold(0, (s, c) => s + c.pedidosAnuales);

    final centroide = centroides[c];
    final errorMetros = _errorAgregacionMetros(miembros, centroide, demandaTotal);

    zonas.add(
      ZonaAgregada(
        latitud: centroide.$1,
        longitud: centroide.$2,
        demandaAgregada: demandaTotal,
        pedidosAgregados: pedidosTotal,
        clienteIds: miembros.map((c) => c.id!).toList(),
        errorAgregacionMetros: errorMetros,
      ),
    );
  }

  return zonas;
}

/// Propone automáticamente cuántas zonas pedir, sin exceder el límite de
/// una sola consulta a la matriz una vez reservado espacio para los sitios
/// candidatos y plantas ya cargados (CLAUDE.md sección 7, `[REGLA]`). El
/// usuario puede bajarlo desde la pantalla; nunca se permite subirlo más
/// allá de lo que devuelve esta función.
int proponerK({
  required int nClientes,
  required int maxCoordenadasPorConsulta,
  required int reservaCandidatos,
}) {
  final limite = (maxCoordenadasPorConsulta - reservaCandidatos).clamp(1, maxCoordenadasPorConsulta);
  return min(limite, nClientes);
}

int _centroideMasCercano(Cliente cliente, List<(double, double)> centroides) {
  var mejorIndice = 0;
  var mejorDistancia = double.infinity;
  for (var i = 0; i < centroides.length; i++) {
    final d = distanciaHaversineKm(
      lat1: cliente.latitud,
      lon1: cliente.longitud,
      lat2: centroides[i].$1,
      lon2: centroides[i].$2,
    );
    if (d < mejorDistancia) {
      mejorDistancia = d;
      mejorIndice = i;
    }
  }
  return mejorIndice;
}

List<(double, double)> _recalcularCentroides({
  required List<Cliente> clientes,
  required List<int> asignacion,
  required int k,
  required List<(double, double)> centroidesAnteriores,
}) {
  final nuevos = <(double, double)>[];
  for (var c = 0; c < k; c++) {
    final indicesMiembros = [
      for (var i = 0; i < clientes.length; i++)
        if (asignacion[i] == c) i,
    ];

    if (indicesMiembros.isEmpty) {
      // Clúster vacío: en vez de dejar un centroide huérfano (que rompería
      // el promedio con NaN), se reubica en el cliente actualmente más
      // lejos de su propio centroide asignado — arreglo estándar de
      // k-means para clústeres vacíos.
      nuevos.add(_puntoMasLejano(clientes, asignacion, centroidesAnteriores));
      continue;
    }

    var sumaPesoLat = 0.0;
    var sumaPesoLon = 0.0;
    var sumaPeso = 0.0;
    for (final i in indicesMiembros) {
      final peso = clientes[i].demandaAnual > 0 ? clientes[i].demandaAnual : 1.0;
      sumaPesoLat += clientes[i].latitud * peso;
      sumaPesoLon += clientes[i].longitud * peso;
      sumaPeso += peso;
    }
    nuevos.add((sumaPesoLat / sumaPeso, sumaPesoLon / sumaPeso));
  }
  return nuevos;
}

(double, double) _puntoMasLejano(
  List<Cliente> clientes,
  List<int> asignacion,
  List<(double, double)> centroides,
) {
  var mejorIndice = 0;
  var mejorDistancia = -1.0;
  for (var i = 0; i < clientes.length; i++) {
    final centroide = centroides[asignacion[i]];
    final d = distanciaHaversineKm(
      lat1: clientes[i].latitud,
      lon1: clientes[i].longitud,
      lat2: centroide.$1,
      lon2: centroide.$2,
    );
    if (d > mejorDistancia) {
      mejorDistancia = d;
      mejorIndice = i;
    }
  }
  return (clientes[mejorIndice].latitud, clientes[mejorIndice].longitud);
}

int _errorAgregacionMetros(
  List<Cliente> miembros,
  (double, double) centroide,
  double demandaTotal,
) {
  if (miembros.length == 1) return 0;

  var sumaPonderada = 0.0;
  for (final cliente in miembros) {
    final distanciaMetros =
        distanciaHaversineKm(
          lat1: cliente.latitud,
          lon1: cliente.longitud,
          lat2: centroide.$1,
          lon2: centroide.$2,
        ) *
        1000;
    final peso = demandaTotal > 0 ? cliente.demandaAnual : 1.0;
    sumaPonderada += distanciaMetros * peso;
  }
  final pesoTotal = demandaTotal > 0 ? demandaTotal : miembros.length;
  return (sumaPonderada / pesoTotal).round();
}

List<(double, double)> _inicializarKMeansPlusPlus(
  List<Cliente> clientes,
  int k,
  Random random,
) {
  final centroides = <(double, double)>[];

  final primero = clientes[random.nextInt(clientes.length)];
  centroides.add((primero.latitud, primero.longitud));

  while (centroides.length < k) {
    final distanciasCuadrado = clientes.map((cliente) {
      var minima = double.infinity;
      for (final centroide in centroides) {
        final d = distanciaHaversineKm(
          lat1: cliente.latitud,
          lon1: cliente.longitud,
          lat2: centroide.$1,
          lon2: centroide.$2,
        );
        if (d < minima) minima = d;
      }
      return minima * minima;
    }).toList();

    final sumaTotal = distanciasCuadrado.fold(0.0, (s, d) => s + d);
    if (sumaTotal <= 0) {
      // Todos los clientes restantes coinciden con un centroide ya
      // elegido — no hay forma de diferenciar, se elige uno al azar.
      final elegido = clientes[random.nextInt(clientes.length)];
      centroides.add((elegido.latitud, elegido.longitud));
      continue;
    }

    var objetivo = random.nextDouble() * sumaTotal;
    var elegidoIndice = clientes.length - 1;
    for (var i = 0; i < distanciasCuadrado.length; i++) {
      objetivo -= distanciasCuadrado[i];
      if (objetivo <= 0) {
        elegidoIndice = i;
        break;
      }
    }
    centroides.add((clientes[elegidoIndice].latitud, clientes[elegidoIndice].longitud));
  }

  return centroides;
}

bool _listasIguales(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
