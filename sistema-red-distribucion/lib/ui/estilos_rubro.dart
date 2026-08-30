import 'package:flutter/material.dart';

import '../domain/motor/m4_costo_total.dart';

/// Etiqueta y color por rubro, compartidos por las Pantallas 12 y 13 (ambas
/// grafican el mismo desglose de siete rubros de M4).
const etiquetasRubro = {
  rubroProduccion: 'Producción',
  rubroEntrada: 'Transporte de entrada',
  rubroSalida: 'Transporte de salida',
  rubroFijo: 'Costo fijo',
  rubroManejo: 'Manejo',
  rubroInventario: 'Inventario',
  rubroPedidos: 'Pedidos',
};

const coloresRubro = {
  rubroProduccion: Color(0xFF2563EB),
  rubroEntrada: Color(0xFFDC2626),
  rubroSalida: Color(0xFF16A34A),
  rubroFijo: Color(0xFFCA8A04),
  rubroManejo: Color(0xFF9333EA),
  rubroInventario: Color(0xFFDB2777),
  rubroPedidos: Color(0xFF0891B2),
};
