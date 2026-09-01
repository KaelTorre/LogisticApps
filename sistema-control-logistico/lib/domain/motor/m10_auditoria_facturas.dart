import '../../data/models/factura_transporte.dart';

/// M10 — Auditoría de facturas de transporte (CLAUDE.md sección 8).
/// Función pura sobre la lista completa de facturas de una organización:
/// recalcula cada una contra el tarifario contratado y clasifica la
/// discrepancia. `duplicado` se detecta comparando cada factura contra el
/// resto de la lista, así que esto no puede ser una función
/// factura-por-factura como M1-M4 -- necesita ver el conjunto completo.
///
/// El esquema (CLAUDE.md sección 7) declara seis tipos de discrepancia:
/// `tarifa`, `peso`, `ruta`, `descripcion`, `duplicado` y
/// `cargo_accesorio`. Este motor detecta automáticamente `tarifa`
/// (comparando `tarifaAplicadaCent` contra `tarifaContratadaCent`) y
/// `duplicado` (mismo `numero` y `transportista` repetidos) -- son los
/// dos únicos tipos que se pueden recalcular con los campos que la
/// factura realmente guarda. `peso`, `ruta`, `descripcion` y
/// `cargo_accesorio` exigirían un valor de referencia contratado (un
/// "peso esperado", una "ruta pactada") que este esquema no captura y que
/// esta fase no agrega -- [REGLA] no se inventan datos ni se amplía el
/// esquema sin que el `CLAUDE.md` lo pida. Esos cuatro tipos quedan
/// disponibles para que el usuario los marque a mano en la Pantalla 21
/// tras revisar el documento original de la factura.
List<FacturaTransporte> auditarFacturas(List<FacturaTransporte> facturas) {
  final conteoPorClave = <String, int>{};
  for (final f in facturas) {
    final clave = _clave(f);
    conteoPorClave[clave] = (conteoPorClave[clave] ?? 0) + 1;
  }

  return [
    for (final f in facturas) _auditarUna(f, esDuplicada: conteoPorClave[_clave(f)]! > 1),
  ];
}

String _clave(FacturaTransporte f) => '${f.numero}|${f.transportista}';

FacturaTransporte _auditarUna(FacturaTransporte f, {required bool esDuplicada}) {
  String? tipo;
  var montoRecuperableCent = 0;

  if (esDuplicada) {
    // Se marca la factura completa como potencial pago duplicado; el
    // usuario decide cuál de las dos copias es la legítima antes de
    // recuperar el monto (Pantalla 21).
    tipo = 'duplicado';
    montoRecuperableCent = f.tarifaAplicadaCent;
  } else if (f.tarifaAplicadaCent != f.tarifaContratadaCent) {
    tipo = 'tarifa';
    // Solo el sobrecobro es "recuperable" -- un cobro por debajo de lo
    // contratado sigue siendo una discrepancia que revisar, pero no hay
    // nada que recuperar a favor de la organización.
    montoRecuperableCent = f.tarifaAplicadaCent > f.tarifaContratadaCent
        ? f.tarifaAplicadaCent - f.tarifaContratadaCent
        : 0;
  }

  return FacturaTransporte(
    id: f.id,
    organizacionId: f.organizacionId,
    numero: f.numero,
    transportista: f.transportista,
    peso: f.peso,
    ruta: f.ruta,
    tarifaAplicadaCent: f.tarifaAplicadaCent,
    tarifaContratadaCent: f.tarifaContratadaCent,
    discrepanciaTipo: tipo,
    montoRecuperableCent: montoRecuperableCent,
    estado: f.estado,
  );
}

/// Los seis tipos de discrepancia declarados por el esquema (CLAUDE.md
/// sección 7), con etiqueta legible -- usado por la Pantalla 21 tanto
/// para mostrar el resultado automático como para el selector manual.
const etiquetasTipoDiscrepancia = {
  'tarifa': 'Tarifa',
  'peso': 'Peso',
  'ruta': 'Ruta',
  'descripcion': 'Descripción',
  'duplicado': 'Duplicado',
  'cargo_accesorio': 'Cargo accesorio no pactado',
};
