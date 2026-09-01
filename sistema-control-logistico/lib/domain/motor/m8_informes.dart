// M8 — Informes (CLAUDE.md sección 8): costo y servicio, presupuesto
// contra real, y centro de utilidades con precios de transferencia. Sin
// Flutter, sin drift -- tipos y cálculos puros que las pantallas 16 y 19
// arman con datos ya cargados.
//
// La productividad (Pantalla 17) y la tabla de desempeño (Pantalla 18) no
// necesitan un cálculo propio -- son los índices y los veredictos ya
// existentes (`indicador`, `evaluacion`), solo reordenados para mostrarse;
// esas pantallas los arman directo, sin pasar por este módulo.

/// Un rubro de costo dentro del informe: el proceso al que pertenece, el
/// indicador que lo mide y su monto en el periodo. `proceso` es lo más
/// cercano que tiene este esquema a "actividad logística" (CLAUDE.md
/// sección 9, Pantalla 16: "desglose por actividad").
class ComponenteCosto {
  const ComponenteCosto({required this.proceso, required this.indicadorNombre, required this.monto});

  final String proceso;
  final String indicadorNombre;
  final double monto;
}

/// Un indicador de categoría `servicio` mostrado junto al desglose de
/// costo -- no se suma (unidades distintas entre indicadores de servicio),
/// solo se lista contra su meta.
class ResumenServicio {
  const ResumenServicio({
    required this.indicadorNombre,
    required this.valor,
    required this.meta,
    required this.unidad,
  });

  final String indicadorNombre;
  final double valor;
  final double meta;
  final String unidad;
}

/// Informe de costo y servicio (Pantalla 16). `costoTotal` es **siempre**
/// la suma de [componentes] -- nunca un cálculo independiente -- para que
/// la cifra grande y el desglose jamás puedan desincronizarse (CLAUDE.md
/// Fase 5: "el costo logístico total del informe es exactamente la suma
/// de sus actividades").
class InformeCostoServicio {
  const InformeCostoServicio({required this.componentes, required this.servicio});

  final List<ComponenteCosto> componentes;
  final List<ResumenServicio> servicio;

  double get costoTotal => componentes.fold(0.0, (acumulado, c) => acumulado + c.monto);

  double pesoRelativo(ComponenteCosto componente) =>
      costoTotal == 0 ? 0 : componente.monto / costoTotal;

  /// Centro de utilidades con precios de transferencia (CLAUDE.md sección
  /// 8, M8): el costo total de cada proceso en el periodo, tal cual lo que
  /// ese proceso tendría que cobrarle internamente al resto de la empresa
  /// para cubrir su propio costo -- el precio de transferencia sugerido.
  Map<String, double> get precioTransferenciaPorProceso {
    final resultado = <String, double>{};
    for (final componente in componentes) {
      resultado[componente.proceso] = (resultado[componente.proceso] ?? 0) + componente.monto;
    }
    return resultado;
  }
}

/// Presupuestado contra real de un rubro (Pantalla 19), en céntimos
/// enteros -- a diferencia de `medicion.valor`, `presupuesto` sí guarda
/// dinero real (CLAUDE.md sección 7, [REGLA]).
class VariacionPresupuestal {
  const VariacionPresupuestal({
    required this.rubro,
    required this.presupuestadoCent,
    required this.realCent,
  });

  final String rubro;
  final int presupuestadoCent;
  final int realCent;

  int get diferenciaCent => realCent - presupuestadoCent;

  /// Positivo = sobregasto (se gastó más de lo presupuestado). Negativo =
  /// ahorro. `null` cuando no había presupuesto asignado (dividir entre
  /// cero no produce un porcentaje con sentido).
  double? get porcentajeVariacion {
    if (presupuestadoCent == 0) return null;
    return diferenciaCent / presupuestadoCent * 100;
  }
}
