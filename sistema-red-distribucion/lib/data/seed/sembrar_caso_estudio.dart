import 'package:flutter/services.dart' show rootBundle;

import '../../domain/export/exportar_importar_proyecto.dart';
import '../../domain/export/proyecto_red_portable.dart';
import '../local/database.dart';
import '../repositories/proyecto_repository.dart';

/// Siembra el caso de estudio de Pucallpa (Fase 9) solo si la base está
/// completamente vacía — mismo patrón que `main.dart` de
/// `sistema-optimizacion-rutas` (`sembrarSiVacio`), pero acá no hay
/// consts Dart con los datos: el archivo `assets/seed/semilla_pucallpa.json`
/// ya trae el proyecto completo (clientes, zonas, candidatos, planta,
/// parámetros de costo y la matriz de distancias) generado una sola vez con
/// `tool/generar_semilla_pucallpa.dart` contra OSRM real — sembrarlo acá
/// solo lee ese archivo estático del bundle, **cero peticiones de red**
/// (Test Z, CLAUDE.md Fase 9).
///
/// No se llama "sembrar" a secas porque no es semilla de catálogo (como
/// `sistema-diseno-almacenes`): es un proyecto de ejemplo completo, que el
/// usuario puede editar o borrar como cualquier otro una vez que ya vio
/// cómo funciona el sistema con datos reales.
Future<void> sembrarCasoEstudioSiVacio(AppDatabase database) async {
  final proyectos = await ProyectoRepository(database).obtenerTodos();
  if (proyectos.isNotEmpty) return;

  final json = await rootBundle.loadString('assets/seed/semilla_pucallpa.json');
  final portable = ProyectoRedPortable.fromJsonString(json);
  await importarProyecto(portable, database);
}
