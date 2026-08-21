/// Las 3 formas de cotización de almacén público del capítulo 11 de Ballou
/// (CLAUDE.md sección 7, M4). `costoMensual` recibe el desborde de ese mes
/// (posiciones que no caben en la capacidad propia) y devuelve el costo de
/// cubrirlo con espacio público.
sealed class TarifaPublica {
  const TarifaPublica();

  double costoMensual(int desbordePosiciones);
}

/// Cargo por manejo de entrada y salida, por unidad. Asume que cada
/// posición desbordada entra y sale una vez en el mes.
class TarifaPorManejo extends TarifaPublica {
  const TarifaPorManejo({required this.cargoEntradaPorUnidad, required this.cargoSalidaPorUnidad});

  final double cargoEntradaPorUnidad;
  final double cargoSalidaPorUnidad;

  @override
  double costoMensual(int desbordePosiciones) {
    return desbordePosiciones * (cargoEntradaPorUnidad + cargoSalidaPorUnidad);
  }
}

/// Tarifa por espacio ocupado (por posición-mes).
class TarifaPorEspacio extends TarifaPublica {
  const TarifaPorEspacio({required this.tarifaPorPosicionMes});

  final double tarifaPorPosicionMes;

  @override
  double costoMensual(int desbordePosiciones) {
    return desbordePosiciones * tarifaPorPosicionMes;
  }
}

/// Arrendamiento de espacio + contrato de personal: costo fijo mensual que
/// aplica completo en cualquier mes con desborde, sin importar cuánto
/// (es un compromiso de arriendo, no una tarifa variable).
class TarifaPorArrendamiento extends TarifaPublica {
  const TarifaPorArrendamiento({required this.costoFijoMensual});

  final double costoFijoMensual;

  @override
  double costoMensual(int desbordePosiciones) {
    return desbordePosiciones > 0 ? costoFijoMensual : 0;
  }
}
