/// Servidor demo público de OSRM (sin registro, ver CLAUDE.md sección 2).
const String osrmBaseUrl = 'https://router.project-osrm.org';

/// Intervalo mínimo entre peticiones al servidor demo de OSRM (~1 req/seg).
const Duration osrmThrottleInterval = Duration(seconds: 1);
