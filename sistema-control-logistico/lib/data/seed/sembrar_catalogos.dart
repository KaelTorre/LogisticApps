import '../models/accion_catalogo.dart';
import '../models/regla_accion.dart';
import '../repositories/accion_catalogo_repository.dart';
import '../repositories/regla_accion_repository.dart';
import '../repositories/regla_patron_repository.dart';
import 'acciones_semilla.dart';
import 'reglas_semilla.dart';

/// Siembra las seis reglas de sistema (`regla_patron`, globales) si la
/// tabla está vacía. Sin esto, `memoria_evaluacion.reglaId` no tendría a
/// qué apuntar -- ver `reglas_semilla.dart`.
Future<void> sembrarReglasDeSistemaSiVacio(ReglaPatronRepository repositorio) async {
  final existentes = await repositorio.obtenerTodas();
  if (existentes.isNotEmpty) return;

  for (final regla in reglasDeSistemaSemilla) {
    await repositorio.crear(regla);
  }
}

/// Siembra la biblioteca de acciones correctoras (`accion_catalogo` +
/// `regla_accion`) si el catálogo está vacío -- ver `acciones_semilla.dart`.
Future<void> sembrarBibliotecaAccionesSiVacio(
  AccionCatalogoRepository accionRepo,
  ReglaAccionRepository reglaAccionRepo,
) async {
  final existentes = await accionRepo.obtenerTodas();
  if (existentes.isNotEmpty) return;

  for (final semilla in accionesDeSistemaSemilla) {
    final accionId = await accionRepo.crear(
      AccionCatalogo(
        codigo: semilla.codigo,
        titulo: semilla.titulo,
        descripcion: semilla.descripcion,
        categoriaIndicador: semilla.categoriaIndicador,
        magnitudTipica: semilla.magnitudTipica,
        aplicacionExternaSugerida: semilla.aplicacionExternaSugerida,
      ),
    );
    for (final mapeo in semilla.mapeos) {
      await reglaAccionRepo.crear(
        ReglaAccion(
          categoriaIndicador: semilla.categoriaIndicador,
          reglaDisparada: mapeo.reglaDisparada,
          clasificacion: semilla.magnitudTipica,
          accionId: accionId,
          prioridad: mapeo.prioridad,
        ),
      );
    }
  }
}
