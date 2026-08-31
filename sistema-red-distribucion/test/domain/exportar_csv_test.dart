import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_red_distribucion/data/models/cliente.dart';
import 'package:sistema_red_distribucion/data/models/escenario_asignacion.dart';
import 'package:sistema_red_distribucion/data/models/planta.dart';
import 'package:sistema_red_distribucion/data/models/sitio_candidato.dart';
import 'package:sistema_red_distribucion/data/models/zona_demanda.dart';
import 'package:sistema_red_distribucion/domain/export/exportar_csv.dart';
import 'package:sistema_red_distribucion/domain/importacion/importador_csv_clientes.dart';

void main() {
  test('exportarClientesCsv produce encabezados que el propio importador reconoce', () {
    // Sin comas en el nombre: el importador hace un split ingenuo por
    // separador (documentado en su propio archivo), así que un campo entre
    // comillas con coma interna no es un caso de ida y vuelta soportado —
    // la comilla la agrega `exportarClientesCsv` solo para que el CSV abra
    // bien en una hoja de cálculo, no para reimportar ese caso particular.
    final csv = exportarClientesCsv([
      const Cliente(proyectoId: 1, nombre: 'Cliente A', latitud: -8.1, longitud: -74.1, demandaAnual: 10, pedidosAnuales: 2),
      const Cliente(proyectoId: 1, nombre: 'Cliente B', latitud: -8.2, longitud: -74.2, demandaAnual: 20, pedidosAnuales: 4),
    ]);

    final resultado = parsearCsvClientes(csv);
    expect(resultado.errores, isEmpty);
    expect(resultado.filas, hasLength(2));
    expect(resultado.filas[0].nombre, 'Cliente A');
    expect(resultado.filas[1].nombre, 'Cliente B');
    expect(resultado.filas[1].demandaAnual, 20);
  });

  test('un nombre con coma queda entre comillas en el CSV exportado', () {
    final csv = exportarClientesCsv([
      const Cliente(proyectoId: 1, nombre: 'Cliente, S.A.', latitud: -8.1, longitud: -74.1, demandaAnual: 10, pedidosAnuales: 2),
    ]);
    expect(csv, contains('"Cliente, S.A."'));
  });

  test('exportarZonasCsv incluye una fila por zona con sus columnas', () {
    final csv = exportarZonasCsv([
      const ZonaDemanda(
        proyectoId: 1,
        etiqueta: 'Zona 1',
        latitud: -8.1,
        longitud: -74.1,
        demandaAgregada: 50,
        pedidosAgregados: 10,
        numeroClientes: 3,
        errorAgregacionMetros: 120,
      ),
    ]);
    final lineas = csv.trim().split('\n');
    expect(lineas, hasLength(2));
    expect(lineas[0], 'etiqueta,latitud,longitud,demanda_agregada,pedidos_agregados,numero_clientes,error_agregacion_metros');
    expect(lineas[1], 'Zona 1,-8.1,-74.1,50.0,10,3,120');
  });

  test('exportarCandidatosCsv y exportarPlantasCsv incluyen sus columnas', () {
    final csvCandidatos = exportarCandidatosCsv([
      const SitioCandidato(
        proyectoId: 1,
        nombre: 'Candidato 1',
        latitud: -8.1,
        longitud: -74.1,
        costoFijoAnualCent: 100000,
        capacidadAnual: 500,
        costoVariableManejoCentPorUnidad: 50,
        origen: 'manual',
        esRedActual: true,
      ),
    ]);
    expect(csvCandidatos, contains('Candidato 1'));
    expect(csvCandidatos, contains('true'));

    final csvPlantas = exportarPlantasCsv([
      const Planta(
        proyectoId: 1,
        nombre: 'Planta 1',
        latitud: -8.1,
        longitud: -74.1,
        capacidadAnual: 1000,
        costoProduccionCentPorUnidad: 100,
      ),
    ]);
    expect(csvPlantas, contains('Planta 1'));
  });

  test('exportarAsignacionesEscenarioCsv resuelve nombres por id', () {
    final csv = exportarAsignacionesEscenarioCsv(
      asignaciones: [
        const EscenarioAsignacion(
          escenarioId: 1,
          zonaId: 10,
          sitioCandidatoId: 20,
          distanciaMetros: 5000,
          duracionSegundos: 600,
          costoSalidaCent: 1500,
        ),
      ],
      nombreZonaPorId: {10: 'Zona 1'},
      nombreCandidatoPorId: {20: 'Candidato 1'},
    );
    expect(csv, contains('Zona 1,Candidato 1,5000,600,1500'));
  });
}
