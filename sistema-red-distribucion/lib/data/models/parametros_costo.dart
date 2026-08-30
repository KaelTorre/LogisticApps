class ParametrosCosto {
  const ParametrosCosto({
    this.id,
    required this.proyectoId,
    required this.tarifaEntradaFijaCent,
    required this.tarifaEntradaCentPorKmTon,
    required this.tarifaSalidaFijaCent,
    required this.tarifaSalidaCentPorKmTon,
    required this.tasaManejoInventarioAnual,
    required this.valorPorUnidadCent,
    required this.inventarioBaseUnaUbicacion,
    required this.costoPorPedidoCent,
    required this.tipoEstandar,
    required this.estandarServicioValor,
  });

  final int? id;
  final int proyectoId;
  final int tarifaEntradaFijaCent;
  final int tarifaEntradaCentPorKmTon;
  final int tarifaSalidaFijaCent;
  final int tarifaSalidaCentPorKmTon;
  final double tasaManejoInventarioAnual; // fracción, ej. 0.25
  final int valorPorUnidadCent;
  final double inventarioBaseUnaUbicacion;
  final int costoPorPedidoCent;
  final String tipoEstandar; // distancia | tiempo
  final int estandarServicioValor; // metros si distancia, segundos si tiempo

  ParametrosCosto copyWith({
    int? id,
    int? proyectoId,
    int? tarifaEntradaFijaCent,
    int? tarifaEntradaCentPorKmTon,
    int? tarifaSalidaFijaCent,
    int? tarifaSalidaCentPorKmTon,
    double? tasaManejoInventarioAnual,
    int? valorPorUnidadCent,
    double? inventarioBaseUnaUbicacion,
    int? costoPorPedidoCent,
    String? tipoEstandar,
    int? estandarServicioValor,
  }) {
    return ParametrosCosto(
      id: id ?? this.id,
      proyectoId: proyectoId ?? this.proyectoId,
      tarifaEntradaFijaCent:
          tarifaEntradaFijaCent ?? this.tarifaEntradaFijaCent,
      tarifaEntradaCentPorKmTon:
          tarifaEntradaCentPorKmTon ?? this.tarifaEntradaCentPorKmTon,
      tarifaSalidaFijaCent: tarifaSalidaFijaCent ?? this.tarifaSalidaFijaCent,
      tarifaSalidaCentPorKmTon:
          tarifaSalidaCentPorKmTon ?? this.tarifaSalidaCentPorKmTon,
      tasaManejoInventarioAnual:
          tasaManejoInventarioAnual ?? this.tasaManejoInventarioAnual,
      valorPorUnidadCent: valorPorUnidadCent ?? this.valorPorUnidadCent,
      inventarioBaseUnaUbicacion:
          inventarioBaseUnaUbicacion ?? this.inventarioBaseUnaUbicacion,
      costoPorPedidoCent: costoPorPedidoCent ?? this.costoPorPedidoCent,
      tipoEstandar: tipoEstandar ?? this.tipoEstandar,
      estandarServicioValor:
          estandarServicioValor ?? this.estandarServicioValor,
    );
  }
}
