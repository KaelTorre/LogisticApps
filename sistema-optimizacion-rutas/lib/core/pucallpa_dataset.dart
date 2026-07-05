import '../data/models/deposito.dart';
import '../data/models/punto_entrega.dart';

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
/// `demanda` queda en 0 por defecto: el usuario no proveyó volúmenes reales,
/// se edita desde el CRUD de puntos de entrega (sección 8 de CLAUDE.md).
const List<PuntoEntrega> puntosEntregaSemillaPucallpa = [
  PuntoEntrega(
    nombre: 'Universidad Nacional de Ucayali',
    latitud: -8.394832,
    longitud: -74.577328,
  ),
  PuntoEntrega(
    nombre: 'Aeropuerto Internacional Capitán FAP David Abenzur Rengifo',
    latitud: -8.385646,
    longitud: -74.574080,
  ),
  PuntoEntrega(
    nombre: 'Open Plaza Pucallpa',
    latitud: -8.387164,
    longitud: -74.567581,
  ),
  PuntoEntrega(
    nombre: 'Hospital II Pucallpa - EsSalud',
    latitud: -8.391258,
    longitud: -74.547131,
  ),
  PuntoEntrega(
    nombre: 'Puerto de Pucallpa',
    latitud: -8.387673,
    longitud: -74.528546,
  ),
  PuntoEntrega(
    nombre: 'Universidad Alas Peruanas',
    latitud: -8.370582,
    longitud: -74.567438,
  ),
  PuntoEntrega(
    nombre: 'Real Plaza Pucallpa',
    latitud: -8.384834,
    longitud: -74.556256,
  ),
  PuntoEntrega(
    nombre: 'Grifo Yarinacocha Company',
    latitud: -8.3955641,
    longitud: -74.5959372,
  ),
  PuntoEntrega(
    nombre: 'Divina Montaña',
    latitud: -8.403812,
    longitud: -74.628032,
  ),
  PuntoEntrega(
    nombre: 'Manish Hotel',
    latitud: -8.393301,
    longitud: -74.568857,
  ),
  PuntoEntrega(
    nombre: 'Clínica Esmedic E.I.R.L.',
    latitud: -8.3818002,
    longitud: -74.5343827,
  ),
  PuntoEntrega(
    nombre: 'Clínica Juan Pablo II',
    latitud: -8.3815351,
    longitud: -74.5380421,
  ),
  PuntoEntrega(
    nombre: 'Municipalidad Distrital de Manantay',
    latitud: -8.398003,
    longitud: -74.536225,
  ),
  PuntoEntrega(
    nombre: 'Cliente Grifo',
    latitud: -8.418840,
    longitud: -74.559263,
  ),
  PuntoEntrega(
    nombre: 'Centro Cultural de Pucallpa',
    latitud: -8.381852,
    longitud: -74.527971,
  ),
  PuntoEntrega(
    nombre: 'EMAPACOP S.A.',
    latitud: -8.377232,
    longitud: -74.526916,
  ),
  PuntoEntrega(
    nombre: 'Hospital Amazónico de Yarinacocha',
    latitud: -8.356146,
    longitud: -74.572832,
  ),
  PuntoEntrega(
    nombre: 'Restaurantes Flotantes',
    latitud: -8.350583,
    longitud: -74.571548,
  ),
  PuntoEntrega(
    nombre: 'Policía Municipal de Yarinacocha',
    latitud: -8.355079,
    longitud: -74.576381,
  ),
];
