/// Los nueve indicadores del caso de estudio precargado, tres por
/// proceso y tres por categoría -- cubre con margen el mínimo de ocho
/// indicadores repartidos entre costo, servicio y productividad,
/// agrupados en al menos tres procesos.
class IndicadorCasoEstudio {
  const IndicadorCasoEstudio({
    required this.codigo,
    required this.nombre,
    required this.categoria,
    required this.unidad,
    required this.decimales,
    required this.sentido,
    required this.meta,
    required this.bandaInferior,
    required this.bandaSuperior,
    required this.proceso,
  });

  final String codigo;
  final String nombre;

  /// 'costo' | 'servicio' | 'productividad'.
  final String categoria;
  final String unidad;
  final int decimales;

  /// 'menor_mejor' | 'mayor_mejor'.
  final String sentido;
  final double meta;
  final double bandaInferior;
  final double bandaSuperior;
  final String proceso;
}

const indicadoresCasoEstudio = [
  // ─── Transporte ───
  IndicadorCasoEstudio(
    codigo: 'CE-T1',
    nombre: 'Costo de transporte',
    categoria: 'costo',
    unidad: 'S/ por tonelada-kilómetro',
    decimales: 2,
    sentido: 'menor_mejor',
    meta: 1.20,
    bandaInferior: 1.10,
    bandaSuperior: 1.30,
    proceso: 'Transporte',
  ),
  IndicadorCasoEstudio(
    codigo: 'CE-T2',
    nombre: 'Utilización de la flota',
    categoria: 'productividad',
    unidad: '%',
    decimales: 1,
    sentido: 'mayor_mejor',
    meta: 82,
    bandaInferior: 74,
    bandaSuperior: 90,
    proceso: 'Transporte',
  ),
  IndicadorCasoEstudio(
    codigo: 'CE-T3',
    nombre: 'Tiempo de tránsito promedio',
    categoria: 'servicio',
    unidad: 'horas',
    decimales: 1,
    sentido: 'menor_mejor',
    meta: 18,
    bandaInferior: 15,
    bandaSuperior: 21,
    proceso: 'Transporte',
  ),

  // ─── Almacenamiento ───
  IndicadorCasoEstudio(
    codigo: 'CE-A1',
    nombre: 'Costo de almacenamiento por unidad despachada',
    categoria: 'costo',
    unidad: 'S/ por unidad',
    decimales: 2,
    sentido: 'menor_mejor',
    meta: 0.85,
    bandaInferior: 0.72,
    bandaSuperior: 0.98,
    proceso: 'Almacenamiento',
  ),
  IndicadorCasoEstudio(
    codigo: 'CE-A2',
    nombre: 'Productividad de preparación de pedidos',
    categoria: 'productividad',
    unidad: 'líneas por hora-hombre',
    decimales: 1,
    sentido: 'mayor_mejor',
    meta: 45,
    bandaInferior: 38,
    bandaSuperior: 52,
    proceso: 'Almacenamiento',
  ),
  IndicadorCasoEstudio(
    codigo: 'CE-A3',
    nombre: 'Exactitud de inventario',
    categoria: 'servicio',
    unidad: '%',
    decimales: 1,
    sentido: 'mayor_mejor',
    meta: 97,
    bandaInferior: 94,
    bandaSuperior: 100,
    proceso: 'Almacenamiento',
  ),

  // ─── Atención de pedidos ───
  IndicadorCasoEstudio(
    codigo: 'CE-E1',
    nombre: 'Costo de atención por pedido',
    categoria: 'costo',
    unidad: 'S/ por pedido',
    decimales: 2,
    sentido: 'menor_mejor',
    meta: 6.50,
    bandaInferior: 5.60,
    bandaSuperior: 7.40,
    proceso: 'Atención de pedidos',
  ),
  IndicadorCasoEstudio(
    codigo: 'CE-E2',
    nombre: 'Cumplimiento de entregas a tiempo',
    categoria: 'servicio',
    unidad: '%',
    decimales: 1,
    sentido: 'mayor_mejor',
    meta: 93,
    bandaInferior: 88,
    bandaSuperior: 98,
    proceso: 'Atención de pedidos',
  ),
  IndicadorCasoEstudio(
    codigo: 'CE-E3',
    nombre: 'Productividad de gestión de pedidos',
    categoria: 'productividad',
    unidad: 'pedidos por hora-hombre',
    decimales: 1,
    sentido: 'mayor_mejor',
    meta: 14,
    bandaInferior: 11,
    bandaSuperior: 17,
    proceso: 'Atención de pedidos',
  ),
];
