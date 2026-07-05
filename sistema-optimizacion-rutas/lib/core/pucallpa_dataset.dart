import '../data/models/deposito.dart';
import '../data/models/punto_entrega.dart';
import '../data/models/vehiculo.dart';

/// Depósito inicial (oficina), coordenada real validada por el usuario.
/// Ver Fase 0 de CLAUDE.md — no se deben inventar coordenadas nuevas.
const Deposito depositoSemillaOficina = Deposito(
  nombre: 'Oficina',
  latitud: -8.375482,
  longitud: -74.556342,
);

/// ~19 puntos de entrega reales de Pucallpa, validados manualmente por el
/// usuario en openstreetmap.org, usados como dataset fijo de prueba para los
/// algoritmos de Ahorros y Barrido y para las consultas a OSRM.
///
/// Coordenadas reales (no inventar). `demanda` en **kilogramos** es un valor
/// genérico pero realista para una empresa pequeña (el usuario no tenía
/// datos reales de demanda) — son "datos de prueba/precargados": se siembran
/// en la base al iniciar y quedan disponibles para editar/eliminar/crear
/// nuevos desde el CRUD de puntos de entrega (sección 8 de CLAUDE.md), igual
/// que cualquier otro registro.
const List<PuntoEntrega> puntosEntregaSemillaPucallpa = [
  PuntoEntrega(
    nombre: 'Universidad Nacional de Ucayali',
    latitud: -8.394832,
    longitud: -74.577328,
    demanda: 45,
  ),
  PuntoEntrega(
    nombre: 'Aeropuerto Internacional Capitán FAP David Abenzur Rengifo',
    latitud: -8.385646,
    longitud: -74.574080,
    demanda: 18,
  ),
  PuntoEntrega(
    nombre: 'Open Plaza Pucallpa',
    latitud: -8.387164,
    longitud: -74.567581,
    demanda: 85,
  ),
  PuntoEntrega(
    nombre: 'Hospital II Pucallpa - EsSalud',
    latitud: -8.391258,
    longitud: -74.547131,
    demanda: 60,
  ),
  PuntoEntrega(
    nombre: 'Puerto de Pucallpa',
    latitud: -8.387673,
    longitud: -74.528546,
    demanda: 140,
  ),
  PuntoEntrega(
    nombre: 'Universidad Alas Peruanas',
    latitud: -8.370582,
    longitud: -74.567438,
    demanda: 38,
  ),
  PuntoEntrega(
    nombre: 'Real Plaza Pucallpa',
    latitud: -8.384834,
    longitud: -74.556256,
    demanda: 95,
  ),
  PuntoEntrega(
    nombre: 'Grifo Yarinacocha Company',
    latitud: -8.3955641,
    longitud: -74.5959372,
    demanda: 25,
  ),
  PuntoEntrega(
    nombre: 'Divina Montaña',
    latitud: -8.403812,
    longitud: -74.628032,
    demanda: 35,
  ),
  PuntoEntrega(
    nombre: 'Manish Hotel',
    latitud: -8.393301,
    longitud: -74.568857,
    demanda: 55,
  ),
  PuntoEntrega(
    nombre: 'Clínica Esmedic E.I.R.L.',
    latitud: -8.3818002,
    longitud: -74.5343827,
    demanda: 28,
  ),
  PuntoEntrega(
    nombre: 'Clínica Juan Pablo II',
    latitud: -8.3815351,
    longitud: -74.5380421,
    demanda: 32,
  ),
  PuntoEntrega(
    nombre: 'Municipalidad Distrital de Manantay',
    latitud: -8.398003,
    longitud: -74.536225,
    demanda: 22,
  ),
  PuntoEntrega(
    nombre: 'Cliente Grifo',
    latitud: -8.418840,
    longitud: -74.559263,
    demanda: 25,
  ),
  PuntoEntrega(
    nombre: 'Centro Cultural de Pucallpa',
    latitud: -8.381852,
    longitud: -74.527971,
    demanda: 15,
  ),
  PuntoEntrega(
    nombre: 'EMAPACOP S.A.',
    latitud: -8.377232,
    longitud: -74.526916,
    demanda: 20,
  ),
  PuntoEntrega(
    nombre: 'Hospital Amazónico de Yarinacocha',
    latitud: -8.356146,
    longitud: -74.572832,
    demanda: 65,
  ),
  PuntoEntrega(
    nombre: 'Restaurantes Flotantes',
    latitud: -8.350583,
    longitud: -74.571548,
    demanda: 42,
  ),
  PuntoEntrega(
    nombre: 'Policía Municipal de Yarinacocha',
    latitud: -8.355079,
    longitud: -74.576381,
    demanda: 15,
  ),
];

/// Flota genérica pero realista para una empresa pequeña de reparto urbano:
/// un camión para volumen alto, una camioneta para el grueso de las entregas
/// y una moto tercerizada para entregas rápidas/livianas. También son "datos
/// de prueba/precargados", editables/eliminables desde el CRUD de vehículos.
const List<Vehiculo> vehiculosSemillaFlotaPequena = [
  Vehiculo(
    nombre: 'Camión Reparto 1',
    capacidadMaxima: 1200,
    costoEstimadoPorKm: 2.20,
    tipoFlota: 'propia',
  ),
  Vehiculo(
    nombre: 'Camioneta Reparto 1',
    capacidadMaxima: 500,
    costoEstimadoPorKm: 1.50,
    tipoFlota: 'propia',
  ),
  Vehiculo(
    nombre: 'Moto Reparto 1',
    capacidadMaxima: 30,
    costoEstimadoPorKm: 0.60,
    tipoFlota: 'tercerizada',
  ),
];
