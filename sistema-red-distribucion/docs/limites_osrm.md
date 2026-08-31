# Límite de coordenadas del servicio /table de OSRM

**maxCoordenadasPorConsulta = 100**

- Fuente: verificado empíricamente contra https://router.project-osrm.org.
- Servidor probado: `https://router.project-osrm.org`.
- Método: búsqueda exponencial + binaria sobre el número de coordenadas
  enviadas a `GET /table/v1/driving/...`, hasta encontrar el punto exacto
  donde el servicio deja de responder `code: "Ok"`.
- Verificado el: 2026-08-30T15:51:17.220400.
- Peticiones realizadas en la verificación: 11.

Este valor es del servicio demo **público** de OSRM, sin acuerdo de nivel de
servicio — puede cambiar si el operador ajusta sus límites. Si se vuelve a
correr `dart run tool/verificar_limite_osrm.dart` y el número sale distinto,
actualizar `maxCoordenadasPorConsulta` en `lib/core/constantes.dart` y este
archivo juntos.

## Bitácora de la verificación

```
Verificando el límite de coordenadas del servicio /table de OSRM...
Servidor: https://router.project-osrm.org

  n=10: code=Ok -> aceptado.
  n=20: code=Ok -> aceptado.
  n=40: code=Ok -> aceptado.
  n=80: code=Ok -> aceptado.
  n=160: HTTP 400 -> rechazado.
  n=120: HTTP 400 -> rechazado.
  n=100: code=Ok -> aceptado.
  n=110: HTTP 400 -> rechazado.
  n=105: HTTP 400 -> rechazado.
  n=102: HTTP 400 -> rechazado.
  n=101: HTTP 400 -> rechazado.

Peticiones realizadas: 11
Máximo de coordenadas aceptado en una sola consulta: 100
```
