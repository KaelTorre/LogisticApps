/// Servidor demo público de OSRM (sin registro, ver CLAUDE.md sección 2).
const String osrmBaseUrl = 'https://router.project-osrm.org';

/// Intervalo mínimo entre peticiones al servidor demo de OSRM (~1 req/seg).
const Duration osrmThrottleInterval = Duration(seconds: 1);

/// URL base del visor de rutas alojado en GitHub Pages (`visor-web/`, ver su
/// README). Sin límite de paradas, a diferencia de un link de Google Maps.
/// Ajustar si cambia el usuario/nombre del repositorio de GitHub.
const String visorWebBaseUrl =
    'https://kaeltorre.github.io/LogisticApps/sistema-optimizacion-rutas/visor-web/';
