import '../core/constants.dart';

/// Un producto ya clasificado, con su valor total generado y el porcentaje
/// acumulado de valor hasta su posición (insumo del gráfico de Pareto).
class ProductoClasificado {
  final int productoId;
  final double valorTotalGenerado;
  final CategoriaAbc categoria;
  final double porcentajeAcumulado;

  const ProductoClasificado({
    required this.productoId,
    required this.valorTotalGenerado,
    required this.categoria,
    required this.porcentajeAcumulado,
  });
}

/// Clasifica productos en A/B/C según CLAUDE.md §6.3: ordenados de mayor a
/// menor valor generado, A son el primer 20% de los productos **por
/// cantidad de SKUs** (no por porcentaje de valor), B el siguiente 30%, C
/// el 50% restante. Con pocos productos los redondeos pueden dejar
/// categorías vacías — es un comportamiento esperado, no se fuerza a que
/// las 3 tengan al menos un elemento.
List<ProductoClasificado> clasificarAbc(Map<int, double> valorPorProducto) {
  final entradas = valorPorProducto.entries.toList();

  // Orden estable por valor descendente: `List.sort` de Dart no garantiza
  // estabilidad, así que se desempata por posición original para que los
  // empates de valor mantengan siempre el mismo orden.
  final indices = List<int>.generate(entradas.length, (i) => i)
    ..sort((a, b) {
      final cmp = entradas[b].value.compareTo(entradas[a].value);
      return cmp != 0 ? cmp : a.compareTo(b);
    });
  final ordenado = [for (final i in indices) entradas[i]];

  final n = ordenado.length;
  final corteA = (n * 0.2).round();
  final corteB = corteA + (n * 0.3).round();
  final total = ordenado.fold<double>(0, (suma, e) => suma + e.value);

  double acumulado = 0;
  final resultado = <ProductoClasificado>[];
  for (var i = 0; i < n; i++) {
    acumulado += ordenado[i].value;
    final categoria = i < corteA
        ? CategoriaAbc.a
        : (i < corteB ? CategoriaAbc.b : CategoriaAbc.c);
    resultado.add(
      ProductoClasificado(
        productoId: ordenado[i].key,
        valorTotalGenerado: ordenado[i].value,
        categoria: categoria,
        porcentajeAcumulado: total == 0 ? 0 : acumulado / total,
      ),
    );
  }
  return resultado;
}
