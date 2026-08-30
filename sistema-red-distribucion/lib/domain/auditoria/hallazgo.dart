enum SeveridadHallazgo { advertencia, error }

/// Un problema de calidad de datos detectado por `auditarDatos`, con
/// suficiente contexto para que la pantalla de auditoría (Pantalla 4) lo
/// muestre con severidad y una acción concreta que el usuario puede tomar
/// (CLAUDE.md sección 8: "Hallazgos de calidad con severidad y acción
/// sugerida").
class Hallazgo {
  const Hallazgo({
    required this.severidad,
    required this.regla,
    required this.mensaje,
    required this.accionSugerida,
    this.entidadId,
  });

  final SeveridadHallazgo severidad;

  /// Slug estable de la regla que lo generó (coordenada_fuera_de_rango,
  /// coordenada_duplicada, demanda_no_positiva, cliente_sin_pedidos,
  /// candidato_sin_costo_fijo, tarifa_faltante) — identifica la regla en
  /// los tests sin depender del texto exacto del mensaje.
  final String regla;

  final String mensaje;
  final String accionSugerida;

  /// Id del cliente o sitio candidato afectado, si el hallazgo señala uno
  /// en particular (nulo para hallazgos a nivel de proyecto, ej. tarifas).
  final int? entidadId;
}
