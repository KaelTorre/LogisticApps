import '../local/database.dart';
import '../models/indicador.dart';
import '../models/medicion.dart';
import '../models/organizacion.dart';
import '../models/periodo.dart';
import '../repositories/indicador_repository.dart';
import '../repositories/medicion_repository.dart';
import '../repositories/organizacion_repository.dart';
import '../repositories/periodo_repository.dart';
import 'caso_estudio_generador.dart';
import 'caso_estudio_indicadores.dart';

/// Nombre de la organización del caso de estudio precargado. No
/// corresponde a ninguna empresa real -- se usa "Ejemplo" en el propio
/// nombre para que sea evidente desde la lista de organizaciones.
const nombreOrganizacionCasoEstudio = 'Distribuidora Ejemplo S.A.C.';

const _mesesEnOrden = [
  'enero',
  'febrero',
  'marzo',
  'abril',
  'mayo',
  'junio',
  'julio',
  'agosto',
  'septiembre',
  'octubre',
  'noviembre',
  'diciembre',
];

/// Siembra la organización completa del caso de estudio: 36 periodos
/// mensuales (fechas fijas, no derivadas del reloj del sistema, para que
/// la siembra sea tan determinista como las series que la alimentan),
/// nueve indicadores y sus 36 mediciones cada uno, todas con
/// `origen = 'sintetico'`.
///
/// [REGLA] "Todo dato del caso se muestra en la interfaz con la etiqueta
/// de origen sintético" -- el origen queda grabado en cada medición, y la
/// interfaz (Pantalla 6/7 y cualquier otra que liste mediciones) ya
/// distingue `origen` visualmente para toda la app, no solo para este
/// caso.
///
/// No se llama de forma automática al arrancar: a diferencia del
/// catálogo de reglas y acciones (globales, se siembran una sola vez sin
/// pedirlo nadie), este caso crea una organización completa y visible, así
/// que es una elección explícita de quien usa la app -- se ofrece como
/// botón alternativo a "Crear organización" cuando todavía no hay ninguna.
Future<int> sembrarCasoEstudio(AppDatabase database) async {
  final organizacionRepo = OrganizacionRepository(database);
  final periodoRepo = PeriodoRepository(database);
  final indicadorRepo = IndicadorRepository(database);
  final medicionRepo = MedicionRepository(database);

  final organizacionId = await organizacionRepo.crear(
    const Organizacion(
      nombre: nombreOrganizacionCasoEstudio,
      moneda: 'PEN',
      tipoEmpresa: 'servicios',
      notas:
          'Caso de estudio de ejemplo, con datos sintéticos. Sirve para '
          'recorrer el sistema con información ya cargada antes de '
          'ingresar los datos reales de una organización propia.',
    ),
  );

  final periodoIds = <int>[];
  for (var i = 0; i < numeroPeriodosCasoEstudio; i++) {
    final anio = 2023 + (i ~/ 12);
    final mes = i % 12;
    final diaFin = i % 12 == 1 ? 28 : 30;
    final id = await periodoRepo.crear(
      Periodo(
        organizacionId: organizacionId,
        orden: i + 1,
        etiqueta: '${_mesesEnOrden[mes][0].toUpperCase()}${_mesesEnOrden[mes].substring(1)} $anio',
        fechaInicio: '$anio-${(mes + 1).toString().padLeft(2, '0')}-01',
        fechaFin: '$anio-${(mes + 1).toString().padLeft(2, '0')}-$diaFin',
        granularidad: 'mensual',
      ),
    );
    periodoIds.add(id);
  }

  final series = generarSeriesCasoEstudio();

  for (final def in indicadoresCasoEstudio) {
    final indicadorId = await indicadorRepo.crear(
      Indicador(
        organizacionId: organizacionId,
        codigo: def.codigo,
        nombre: def.nombre,
        categoria: def.categoria,
        unidad: def.unidad,
        decimales: def.decimales,
        sentido: def.sentido,
        meta: def.meta,
        bandaInferior: def.bandaInferior,
        bandaSuperior: def.bandaSuperior,
        granularidad: 'mensual',
        proceso: def.proceso,
      ),
    );

    final valores = series[def.codigo]!;
    for (var i = 0; i < numeroPeriodosCasoEstudio; i++) {
      await medicionRepo.crear(
        Medicion(
          indicadorId: indicadorId,
          periodoId: periodoIds[i],
          valor: double.parse(valores[i].toStringAsFixed(def.decimales)),
          origen: 'sintetico',
        ),
      );
    }
  }

  return organizacionId;
}
