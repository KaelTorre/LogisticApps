import '../../core/constants.dart';

class Producto {
  final int? id;
  final String nombre;
  final CategoriaProducto categoria;
  final double? peso;
  final double? volumen;
  final double valorUnitario;
  final String? metodoFijacionPrecio;
  final EtapaCicloVida? etapaCicloVida;

  const Producto({
    this.id,
    required this.nombre,
    required this.categoria,
    this.peso,
    this.volumen,
    required this.valorUnitario,
    this.metodoFijacionPrecio,
    this.etapaCicloVida,
  });

  Producto copyWith({
    int? id,
    String? nombre,
    CategoriaProducto? categoria,
    double? peso,
    double? volumen,
    double? valorUnitario,
    String? metodoFijacionPrecio,
    EtapaCicloVida? etapaCicloVida,
  }) {
    return Producto(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      categoria: categoria ?? this.categoria,
      peso: peso ?? this.peso,
      volumen: volumen ?? this.volumen,
      valorUnitario: valorUnitario ?? this.valorUnitario,
      metodoFijacionPrecio: metodoFijacionPrecio ?? this.metodoFijacionPrecio,
      etapaCicloVida: etapaCicloVida ?? this.etapaCicloVida,
    );
  }
}
