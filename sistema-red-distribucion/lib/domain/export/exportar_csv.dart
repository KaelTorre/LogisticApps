import '../../data/models/cliente.dart';
import '../../data/models/escenario_asignacion.dart';
import '../../data/models/planta.dart';
import '../../data/models/sitio_candidato.dart';
import '../../data/models/zona_demanda.dart';

/// Exportadores CSV puros — un archivo por tabla, mismo criterio de
/// encabezado que ya usa `importador_csv_clientes.dart` en sentido inverso
/// (para clientes, literalmente los mismos encabezados que ese importador
/// reconoce, así un archivo exportado por acá se puede reimportar sin
/// fricción). Separador coma, sin campos entre comillas — mismo alcance que
/// el importador (ninguno de los valores exportados trae comas propias:
/// nombres de cliente/zona/candidato/planta son texto simple).

String exportarClientesCsv(List<Cliente> clientes) {
  final buffer = StringBuffer('nombre,latitud,longitud,demanda_anual,pedidos_anuales\n');
  for (final c in clientes) {
    buffer.writeln('${_csv(c.nombre)},${c.latitud},${c.longitud},${c.demandaAnual},${c.pedidosAnuales}');
  }
  return buffer.toString();
}

String exportarZonasCsv(List<ZonaDemanda> zonas) {
  final buffer = StringBuffer('etiqueta,latitud,longitud,demanda_agregada,pedidos_agregados,numero_clientes,error_agregacion_metros\n');
  for (final z in zonas) {
    buffer.writeln(
      '${_csv(z.etiqueta)},${z.latitud},${z.longitud},${z.demandaAgregada},'
      '${z.pedidosAgregados},${z.numeroClientes},${z.errorAgregacionMetros}',
    );
  }
  return buffer.toString();
}

String exportarCandidatosCsv(List<SitioCandidato> candidatos) {
  final buffer = StringBuffer(
    'nombre,latitud,longitud,costo_fijo_anual_cent,capacidad_anual,'
    'costo_variable_manejo_cent_por_unidad,origen,es_red_actual\n',
  );
  for (final c in candidatos) {
    buffer.writeln(
      '${_csv(c.nombre)},${c.latitud},${c.longitud},${c.costoFijoAnualCent},'
      '${c.capacidadAnual},${c.costoVariableManejoCentPorUnidad},${c.origen},${c.esRedActual}',
    );
  }
  return buffer.toString();
}

String exportarPlantasCsv(List<Planta> plantas) {
  final buffer = StringBuffer('nombre,latitud,longitud,capacidad_anual,costo_produccion_cent_por_unidad\n');
  for (final p in plantas) {
    buffer.writeln(
      '${_csv(p.nombre)},${p.latitud},${p.longitud},${p.capacidadAnual},${p.costoProduccionCentPorUnidad}',
    );
  }
  return buffer.toString();
}

/// Del escenario activo: qué zona quedó asignada a qué candidato, con
/// nombre en vez de id — pensado para abrir directo en una hoja de cálculo,
/// no para reimportar (por eso no lleva índices como el JSON portable).
String exportarAsignacionesEscenarioCsv({
  required List<EscenarioAsignacion> asignaciones,
  required Map<int, String> nombreZonaPorId,
  required Map<int, String> nombreCandidatoPorId,
}) {
  final buffer = StringBuffer('zona,candidato,distancia_metros,duracion_segundos,costo_salida_cent\n');
  for (final a in asignaciones) {
    final zona = nombreZonaPorId[a.zonaId] ?? 'zona ${a.zonaId}';
    final candidato = nombreCandidatoPorId[a.sitioCandidatoId] ?? 'candidato ${a.sitioCandidatoId}';
    buffer.writeln('${_csv(zona)},${_csv(candidato)},${a.distanciaMetros},${a.duracionSegundos},${a.costoSalidaCent}');
  }
  return buffer.toString();
}

/// Envuelve entre comillas y escapa comillas internas solo si el campo trae
/// el separador, comillas o salto de línea — igual que cualquier CSV RFC
/// 4180, para no romper la fila si algún nombre real trae una coma.
String _csv(String campo) {
  if (campo.contains(',') || campo.contains('"') || campo.contains('\n')) {
    return '"${campo.replaceAll('"', '""')}"';
  }
  return campo;
}
