/// Un punto real del caso de estudio de Pucallpa, sin `proyectoId` — quien
/// siembra el caso (`lib/data/seed/semilla_pucallpa.dart`) le asigna el id
/// del proyecto recién creado al insertar.
class PuntoPucallpa {
  const PuntoPucallpa({required this.nombre, required this.latitud, required this.longitud, required this.demandaKgSemana});

  final String nombre;
  final double latitud;
  final double longitud;
  // Kilogramos por semana — mismo valor genérico (no medido) que ya usaba
  // `sistema-optimizacion-rutas/lib/core/pucallpa_dataset.dart` para este
  // mismo punto, reinterpretado acá como demanda semanal para poder
  // escalarlo a una demanda ANUAL explícita en `semilla_pucallpa.dart` (ver
  // ese archivo y `docs/fuentes_datos.md` para la asunción de escalado).
  final double demandaKgSemana;
}

/// Origen de abastecimiento del caso de estudio — la misma coordenada real
/// que `sistema-optimizacion-rutas` valida como el depósito/oficina de
/// Pucallpa (`-8.375482, -74.556342`, verificada a mano en
/// openstreetmap.org, ver Fase 0 del CLAUDE.md de ese proyecto). Acá se
/// reinterpreta como `Planta` (origen de producción/abastecimiento de la
/// red) en vez de depósito de reparto — mismo punto real, otro rol, ningún
/// dato inventado.
const plantaPucallpa = (nombre: 'Planta Pucallpa', latitud: -8.375482, longitud: -74.556342);

/// Los mismos ~19 puntos de entrega reales de Pucallpa que
/// `sistema-optimizacion-rutas/lib/core/pucallpa_dataset.dart` ya usa como
/// caso de estudio de esa Unidad — coordenadas validadas manualmente por el
/// usuario en OpenStreetMap, reusadas acá tal cual (CLAUDE.md, sección 0:
/// "no se inventan datos"; sección 10: coordenadas del caso de estudio
/// vienen de fuente verificable). Se siembran como `Cliente` y de ahí M1
/// (Fase 3) los agrega en zonas de demanda reales, no triviales.
const List<PuntoPucallpa> puntosPucallpa = [
  PuntoPucallpa(nombre: 'Universidad Nacional de Ucayali', latitud: -8.394832, longitud: -74.577328, demandaKgSemana: 45),
  PuntoPucallpa(
    nombre: 'Aeropuerto Internacional Capitán FAP David Abenzur Rengifo',
    latitud: -8.385646,
    longitud: -74.574080,
    demandaKgSemana: 18,
  ),
  PuntoPucallpa(nombre: 'Open Plaza Pucallpa', latitud: -8.387164, longitud: -74.567581, demandaKgSemana: 85),
  PuntoPucallpa(nombre: 'Hospital II Pucallpa - EsSalud', latitud: -8.391258, longitud: -74.547131, demandaKgSemana: 60),
  PuntoPucallpa(nombre: 'Puerto de Pucallpa', latitud: -8.387673, longitud: -74.528546, demandaKgSemana: 140),
  PuntoPucallpa(nombre: 'Universidad Alas Peruanas', latitud: -8.370582, longitud: -74.567438, demandaKgSemana: 38),
  PuntoPucallpa(nombre: 'Real Plaza Pucallpa', latitud: -8.384834, longitud: -74.556256, demandaKgSemana: 95),
  PuntoPucallpa(nombre: 'Grifo Yarinacocha Company', latitud: -8.3955641, longitud: -74.5959372, demandaKgSemana: 25),
  PuntoPucallpa(nombre: 'Divina Montaña', latitud: -8.403812, longitud: -74.628032, demandaKgSemana: 35),
  PuntoPucallpa(nombre: 'Manish Hotel', latitud: -8.393301, longitud: -74.568857, demandaKgSemana: 55),
  PuntoPucallpa(nombre: 'Clínica Esmedic E.I.R.L.', latitud: -8.3818002, longitud: -74.5343827, demandaKgSemana: 28),
  PuntoPucallpa(nombre: 'Clínica Juan Pablo II', latitud: -8.3815351, longitud: -74.5380421, demandaKgSemana: 32),
  PuntoPucallpa(
    nombre: 'Municipalidad Distrital de Manantay',
    latitud: -8.398003,
    longitud: -74.536225,
    demandaKgSemana: 22,
  ),
  PuntoPucallpa(nombre: 'Cliente Grifo', latitud: -8.418840, longitud: -74.559263, demandaKgSemana: 25),
  PuntoPucallpa(nombre: 'Centro Cultural de Pucallpa', latitud: -8.381852, longitud: -74.527971, demandaKgSemana: 15),
  PuntoPucallpa(nombre: 'EMAPACOP S.A.', latitud: -8.377232, longitud: -74.526916, demandaKgSemana: 20),
  PuntoPucallpa(
    nombre: 'Hospital Amazónico de Yarinacocha',
    latitud: -8.356146,
    longitud: -74.572832,
    demandaKgSemana: 65,
  ),
  PuntoPucallpa(nombre: 'Restaurantes Flotantes', latitud: -8.350583, longitud: -74.571548, demandaKgSemana: 42),
  PuntoPucallpa(nombre: 'Policía Municipal de Yarinacocha', latitud: -8.355079, longitud: -74.576381, demandaKgSemana: 15),
];
