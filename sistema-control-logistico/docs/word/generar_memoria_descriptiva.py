"""
Memoria Descriptiva — Sistema de Control Logístico (Word).

Genera docs/word/salida/Memoria_Descriptiva.docx usando el motor de
documentación compartido (perfil memoria_descriptiva). Contenido técnico
real del proyecto: arquitectura, los diez módulos del motor, modelo de
datos y empaquetado.

Ejecutar con el venv del motor:
    /home/kael/Escritorio/documentacion/word/.venv/bin/python generar_memoria_descriptiva.py
"""

import os
import sys

sys.path.insert(0, "/home/kael/Escritorio/documentacion/word")

from engine import doc_engine
from engine.profiles import get_profile

PERFIL = "memoria_descriptiva"
IMG = os.path.join(os.path.dirname(__file__), "img")


def img(nombre):
    return os.path.join(IMG, nombre)


def main():
    profile = get_profile(PERFIL)
    doc = doc_engine.crear_documento(PERFIL)

    seccion_cuerpo = doc_engine.agregar_caratula(
        doc, profile,
        nombre_proyecto="Sistema de Control Logístico",
        descripcion_breve="Control administrativo de lazo cerrado: define estándares, evalúa la serie con reglas de patrón, clasifica la magnitud de la respuesta, propone una acción correctora y verifica su efecto",
        titulo_documento="Memoria Descriptiva",
        subtitulo_documento="Documentación Técnica del Sistema — Versión 1.1",
        metadatos={
            "Sistema": "Sistema de Control Logístico v1.1",
            "Documento": "Memoria Descriptiva",
            "Autor": "Kael Torre",
            "Fecha": "Setiembre 2026",
        },
    )

    if profile.toc_obligatorio:
        doc_engine.insertar_indice(doc, profile)
        doc_engine.agregar_salto_pagina(doc)

    doc_engine.configurar_header_footer(
        doc, "Memoria Descriptiva — Sistema de Control Logístico v1.1", profile, seccion_cuerpo
    )

    # ------------------------------------------------------------------
    # 1. Introducción
    # ------------------------------------------------------------------
    doc_engine.agregar_titulo(doc, "Introducción", nivel=1, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "El presente documento describe el desarrollo e implementación del "
        "Sistema de Control Logístico v1.1: una aplicación de escritorio y móvil "
        "que implementa el modelo de control administrativo como un lazo "
        "cerrado -- define estándares con banda de tolerancia, recibe mediciones "
        "por periodo, evalúa la serie mediante reglas de patrón, clasifica la "
        "magnitud de la respuesta requerida, propone una acción correctora, "
        "registra la decisión tomada y verifica su efecto en el periodo "
        "siguiente.",
    )
    doc_engine.agregar_parrafo(
        doc,
        "El sistema cubre el ciclo completo de control: de la definición de "
        "indicadores con su meta y su banda, a la captura periodo a periodo, la "
        "detección de patrones sobre la serie completa -- no solo el último "
        "dato --, la clasificación en cuatro niveles de gravedad, el "
        "emparejamiento con una biblioteca de acciones editable, y el cierre del "
        "lazo con la verificación del efecto real de cada acción tomada.",
    )

    # ------------------------------------------------------------------
    # 2. Objetivos
    # ------------------------------------------------------------------
    doc_engine.agregar_titulo(doc, "Objetivos", nivel=1, profile=profile)
    doc_engine.agregar_titulo(doc, "Objetivo general", nivel=2, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "Desarrollar un sistema de escritorio y móvil, multiplataforma (Windows, "
        "Linux y Android) y completamente local, que implemente un lazo cerrado "
        "de control administrativo sobre indicadores logísticos, detectando "
        "desviaciones reales mediante reglas de patrón -- no un umbral simple -- "
        "y documentando cada decisión tomada y su efecto verificado.",
    )
    doc_engine.agregar_titulo(doc, "Objetivos específicos", nivel=2, profile=profile)
    doc_engine.agregar_lista(doc, [
        "Evaluar la serie completa de cada indicador, periodo a periodo, contra "
        "seis reglas de patrón de control estadístico de procesos, evitando que "
        "un solo punto aislado fuera de banda dispare una acción por sí solo.",
        "Clasificar la magnitud de cada desviación real en una de tres "
        "categorías (ajuste menor, replaneación mayor, contingencia) mediante "
        "una cascada de prioridad con umbrales configurables, nunca escritos "
        "directamente dentro de una condición.",
        "Emparejar cada desviación clasificada con una o más acciones "
        "correctoras concretas desde un catálogo, y permitir que el propio "
        "usuario amplíe ese catálogo con sus acciones y sus reglas disparadoras.",
        "Registrar cada acción tomada con su responsable y su fecha de "
        "compromiso, y proponer -- nunca imponer -- un resultado de "
        "verificación en el periodo siguiente, comparando el valor observado "
        "contra la meta y contra el valor de la desviación original.",
        "Ofrecer un laboratorio de escenarios que genere series sintéticas "
        "reproducibles, contraste el reconocimiento de patrones contra un "
        "umbral simple sobre la misma serie real, y calibre el ancho de banda "
        "óptimo a partir de eventos que el usuario marca como reales.",
        "Complementar el ciclo de control con un diagnóstico de madurez "
        "organizacional, una auditoría automática de facturas de transporte "
        "contra el tarifario contratado, y la exportación completa de la "
        "información para respaldo o traslado a otra instalación.",
    ], tipo="numbered")

    # ------------------------------------------------------------------
    # 3. Marco teórico
    # ------------------------------------------------------------------
    doc_engine.agregar_titulo(doc, "Marco Teórico", nivel=1, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "El control administrativo de la función logística parte de una idea "
        "simple pero fácil de implementar mal: un estándar sin margen de "
        "tolerancia genera una alarma por cada fluctuación normal del proceso, y "
        "termina ignorado. Un estándar con una banda de tolerancia alrededor de "
        "la meta, en cambio, distingue la variación aleatoria propia de "
        "cualquier proceso real de una desviación que de verdad amerita "
        "intervención.",
    )
    doc_engine.agregar_parrafo(
        doc,
        "El control estadístico de procesos aporta el siguiente nivel de "
        "sofisticación: un único punto fuera de la banda puede ser ruido, pero "
        "un patrón sostenido en la serie -- una racha de varios periodos "
        "seguidos del lado adverso de la meta, un corrimiento de la media, una "
        "tendencia que no se detiene, un salto brusco entre un periodo y el "
        "siguiente, o una dispersión que crece con el tiempo -- ya no es ruido, "
        "es una señal real. Este sistema traduce esa idea en seis reglas "
        "deterministas y auditables, sin ningún componente de aprendizaje "
        "automático ni caja negra: cada regla que dispara queda registrada con "
        "su explicación en texto, siempre disponible para revisión.",
    )
    doc_engine.agregar_parrafo(
        doc,
        "La regla más importante del sistema, en términos conceptuales, es "
        "precisamente una que NO clasifica: un punto fuera de banda aislado, sin "
        "ningún otro patrón que lo acompañe, queda marcado como \"en "
        "observación\" pero nunca dispara una acción correctora por sí solo. Es "
        "la diferencia central frente a un umbral simple, que reaccionaría a "
        "cada fluctuación por igual -- y es, además, el escenario que valida el "
        "laboratorio de contraste del sistema (M6): sobre la misma serie real, "
        "el reconocimiento de patrones detecta la desviación genuina más tarde "
        "que un umbral simple, pero con menos falsas alarmas en el camino.",
    )
    doc_engine.agregar_parrafo(
        doc,
        "Una vez identificada una desviación real, la magnitud de la respuesta "
        "no es binaria: un ajuste operativo puntual no es lo mismo que una "
        "decisión que exige replantear la operación completa, y esta última no "
        "es lo mismo que una contingencia que sugiere una causa común afectando "
        "a varios indicadores del mismo proceso a la vez. El sistema resuelve "
        "esa gradación con una cascada de prioridad -- la primera condición que "
        "se cumple gana, no se suman entre sí -- basada en cuántos indicadores "
        "del mismo proceso están afectados simultáneamente, qué tan lejos de la "
        "meta está el valor en relación al ancho de la banda, y cuántos periodos "
        "consecutivos lleva la desviación sostenida.",
    )
    doc_engine.agregar_parrafo(
        doc,
        "Por último, ninguna acción correctora tiene valor si su efecto nunca se "
        "confirma. El cierre del lazo de control exige volver a mirar el "
        "indicador en el periodo siguiente a la acción tomada, y comparar el "
        "nuevo valor contra la meta y contra el valor que motivó la "
        "intervención -- sin que el sistema cierre la acción por su cuenta: "
        "propone un veredicto, pero la confirmación final es siempre una "
        "decisión humana.",
    )

    # ------------------------------------------------------------------
    # 4. Descripción del sistema
    # ------------------------------------------------------------------
    doc_engine.agregar_titulo(doc, "Descripción del Sistema", nivel=1, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "El sistema recibe indicadores logísticos ya calculados, con su meta y "
        "su banda de tolerancia, y las mediciones periodo a periodo. Evalúa la "
        "serie completa de cada indicador activo contra seis reglas de patrón, "
        "clasifica la magnitud de cada desviación real, propone una acción "
        "correctora desde un catálogo editable, registra la decisión tomada y "
        "verifica su efecto en el periodo siguiente. Expone además informes de "
        "costo, servicio, productividad y presupuesto, un laboratorio de "
        "escenarios, un diagnóstico de madurez organizacional y una auditoría de "
        "facturas de transporte.",
    )
    doc_engine.agregar_nota(
        doc,
        "El alcance del sistema está deliberadamente cerrado: no es un ERP ni un "
        "WMS (no gestiona pedidos, existencias ni movimientos -- recibe "
        "indicadores ya calculados), no opera en tiempo real (sin eventos, sin "
        "sockets, sin notificaciones push), no tiene ningún componente de "
        "inteligencia artificial (el reconocimiento de patrones es control "
        "estadístico de procesos con reglas deterministas, cero llamadas a "
        "modelos) y no genera acciones correctoras nuevas por su cuenta: las "
        "selecciona de una biblioteca mediante reglas -- el sistema es experto, "
        "no generativo.",
        profile, tipo="nota",
    )
    doc_engine.agregar_imagen(
        doc, img("01_inicio.png"),
        "Panel de Inicio del sistema en ejecución, con el caso de estudio "
        "\"Distribuidora Ejemplo S.A.C.\" cargado",
        profile,
    )

    # ------------------------------------------------------------------
    # 5. Arquitectura técnica
    # ------------------------------------------------------------------
    doc_engine.agregar_titulo(doc, "Arquitectura Técnica", nivel=1, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "La aplicación está organizada en tres capas, siguiendo el árbol de "
        "carpetas de lib/: presentación, dominio y datos. El motor de "
        "evaluación (dominio) no tiene acceso a la base de datos ni a ningún "
        "estado externo -- son funciones puras que reciben una serie de valores "
        "y devuelven un resultado más su propia explicación en texto, lo que las "
        "hace testeables una por una de forma aislada.",
    )
    doc_engine.agregar_tabla(
        doc,
        headers=["Capa", "Responsabilidad"],
        filas=[
            ["ui/ (Presentación)", "Veintitrés pantallas (Flutter widgets), agrupadas en el panel de Inicio según el flujo real de uso: configuración, ciclo de control, informes, laboratorio de escenarios y otros módulos. Las gráficas de serie con banda y el radar del diagnóstico se construyen con fl_chart."],
            ["domain/ (Dominio)", "motor/: los diez módulos M1 a M10, funciones puras. export/: escritor de PDF y de la organización portable en JSON."],
            ["data/ (Datos)", "Esquema de base de datos local (drift sobre SQLite, quince tablas) y los repositorios de alta, baja, modificación y consulta."],
        ],
        profile=profile,
        caption="Capas de la arquitectura",
    )
    doc_engine.agregar_parrafo(
        doc,
        "Todo importe monetario se guarda en céntimos como entero -- los "
        "double solo aparecen en los valores de indicador, que pueden ser "
        "porcentajes, ratios o tiempos, siempre acompañados de su unidad y su "
        "cantidad de decimales de presentación. La regla fundamental del "
        "sistema, verificada por un test que analiza el propio código fuente en "
        "cada corrida, es que el motor de evaluación (lib/domain/motor/) jamás "
        "invoca al reloj del sistema para decidir en qué periodo está: el "
        "periodo es un dato que se recibe, nunca el reloj del equipo. Esto es lo "
        "que hace posible el laboratorio de simulación -- cargar treinta y seis "
        "periodos de historia y recorrerla en segundos, avanzando y "
        "retrocediendo sin volver a consultar la base de datos en cada paso.",
    )

    # ------------------------------------------------------------------
    # 6. Módulos del sistema
    # ------------------------------------------------------------------
    doc_engine.agregar_titulo(doc, "Módulos del Sistema", nivel=1, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "El motor de evaluación está compuesto por diez módulos independientes, "
        "cada uno una función pura en lib/domain/motor/. La tabla resume el "
        "propósito de cada uno.",
    )
    doc_engine.agregar_tabla(
        doc,
        headers=["Módulo", "Propósito"],
        filas=[
            ["M1 — Reglas de patrón", "Evalúa el último punto de la serie truncada contra seis reglas: punto fuera de banda, racha en el lado adverso, corrimiento de media, tendencia sostenida, deterioro brusco y dispersión creciente. Devuelve \"no evaluable\" -- nunca \"normal\" -- cuando la serie no alcanza los periodos mínimos de una regla."],
            ["M2 — Clasificador de magnitud", "Cascada de prioridad que decide, a partir de las reglas disparadas y el contexto (procesos afectados, persistencia), una de cuatro clasificaciones: ninguna, ajuste menor, replaneación mayor o contingencia. Los tres umbrales del clasificador son configurables, nunca literales dentro de una condición."],
            ["M3 — Emparejador de acciones", "Consulta el catálogo de acciones y sus reglas disparadoras, y devuelve las candidatas ordenadas por prioridad para la categoría, la clasificación y las reglas disparadas de un caso concreto."],
            ["M4 — Verificador de acciones", "Compara el valor observado en el periodo siguiente a una acción abierta contra la meta y contra el valor de la desviación original, y propone un resultado de verificación que el usuario confirma o corrige."],
            ["M5 — Generador de series sintéticas", "Genera una serie determinista con semilla explícita, según seis patrones (estable, punto aislado, tendencia, corrimiento, estacional, deterioro brusco), con ruido aleatorio configurable."],
            ["M6 — Contraste retrospectivo", "Compara, sobre la misma serie, en qué periodo detecta primero un umbral simple contra el reconocimiento de patrones, y cuántas falsas alarmas produce cada uno -- mirando en cada paso solo el pasado, nunca el futuro de la serie."],
            ["M7 — Calibrador de banda", "Busca por barrido el ancho de banda más angosto que detecta todos los eventos que el usuario marcó como reales, minimizando las falsas alarmas."],
            ["M8 — Informes", "Costo y servicio, productividad, tabla de desempeño y presupuesto contra real."],
            ["M9 — Diagnóstico organizacional", "Cuestionario ponderado de dieciséis preguntas que ubica la organización en una etapa de desarrollo, una opción organizacional, los ejes de centralización y de rol asesor o de línea, y una orientación dominante, comparada contra un perfil de referencia."],
            ["M10 — Auditoría de facturas", "Recalcula cada factura de transporte contra el tarifario contratado y clasifica la discrepancia por tipo, cuantificando el monto recuperable."],
        ],
        profile=profile,
        caption="Módulos del motor de evaluación (M1 a M10)",
    )
    doc_engine.agregar_imagen(
        doc, img("17_lab_calibrador_anotada.png"),
        "Salida real de M7 sobre \"Costo de transporte\": banda actual "
        "1.10 – 1.30, banda propuesta 1.13 – 1.27, detectando los 5 periodos "
        "marcados como reales con solo 1 falsa alarma",
        profile,
    )

    # ------------------------------------------------------------------
    # 7. Algoritmo principal
    # ------------------------------------------------------------------
    doc_engine.agregar_titulo(doc, "Algoritmo Principal — M1 (Reglas de Patrón) y M2 (Clasificador)", nivel=1, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "M1 evalúa cada regla contra el último punto de la serie truncada, "
        "siempre en términos del \"lado adverso\" -- que depende del sentido del "
        "indicador -- nunca en términos absolutos de \"mayor\" o \"menor\":",
    )
    doc_engine.agregar_codigo(
        doc,
        "R1  Punto fuera de banda        -- el último valor está fuera de [banda_inf, banda_sup]\n"
        "R2  Racha en el lado adverso    -- 7 valores consecutivos del lado adverso de la meta\n"
        "R3  Corrimiento de media        -- 8 de los últimos 8 valores del lado adverso\n"
        "R4  Tendencia sostenida         -- 5 valores consecutivos que empeoran sin parar\n"
        "R5  Deterioro brusco            -- variación entre periodos > ancho completo de banda\n"
        "R6  Dispersión creciente        -- desviación de los últimos 10 periodos > 1.5x la de los 10 anteriores",
        profile,
    )
    doc_engine.agregar_parrafo(
        doc,
        "M2 toma el conjunto de reglas disparadas y decide la clasificación "
        "mediante una cascada de prioridad -- la primera condición que se "
        "cumple gana, nunca se suman entre sí:",
    )
    doc_engine.agregar_codigo(
        doc,
        "funcion clasificar(disparadas, indicador, contexto):\n"
        "    si disparadas está vacío: retornar ninguna\n"
        "    si disparadas == solo {R1}: retornar ninguna, estado observacion\n"
        "\n"
        "    si procesos_afectados >= umbral_contingencia\n"
        "       o (R6 disparada junto con R2 o R3):\n"
        "        retornar contingencia\n"
        "\n"
        "    si (R2 o R3 o R4) y (desviacion_relativa > 1.0\n"
        "                          o persistencia >= 4 periodos):\n"
        "        retornar replaneacion_mayor\n"
        "\n"
        "    si (R2 o R3 o R4 o R5):\n"
        "        retornar ajuste_menor\n"
        "\n"
        "    retornar ninguna",
        profile,
    )
    doc_engine.agregar_parrafo(
        doc,
        "El chequeo de \"R1 aislada no clasifica\" va deliberadamente antes que "
        "cualquier otra condición, incluida la de contingencia: ni la peor racha "
        "de otros indicadores hace que un R1 solitario se convierta en una "
        "acción. Este comportamiento está protegido por un test dorado -- la "
        "prueba más importante del sistema -- que verifica exactamente este "
        "caso sobre una serie de referencia documentada.",
    )
    doc_engine.agregar_nota(
        doc,
        "La severidad calculada de una clasificación no es una escala de uno a "
        "diez inventada: es una función explícita de la desviación relativa al "
        "ancho de banda y de la persistencia de la desviación, auditable en la "
        "memoria de evaluación de cada regla disparada.",
        profile, tipo="nota",
    )
    doc_engine.agregar_imagen(
        doc, img("07b_evaluacion_detalle.png"),
        "Salida real de M1 y M2 sobre el indicador \"Costo de transporte\": tres "
        "reglas disparadas (R1, R2, R6) llevaron a la clasificación Contingencia, "
        "cada una con su explicación en texto",
        profile,
    )

    # ------------------------------------------------------------------
    # 8. Modelo de datos
    # ------------------------------------------------------------------
    doc_engine.agregar_titulo(doc, "Modelo de Datos", nivel=1, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "La base de datos local (drift sobre SQLite) separa con claridad los "
        "datos de entrada de la organización, el resultado de cada evaluación "
        "con su memoria de explicación, y el catálogo de acciones -- que es "
        "compartido a nivel de instalación, no propio de cada organización, "
        "igual que las seis reglas de sistema:",
    )
    doc_engine.agregar_tabla(
        doc,
        headers=["Tabla", "Contenido"],
        filas=[
            ["organizacion / periodo / indicador", "Los datos de entrada: la organización, su calendario de periodos (ordenados por posición, nunca por fecha) y el catálogo de indicadores con meta, banda y sentido."],
            ["medicion", "El valor de cada indicador en cada periodo, con su origen (manual, importado, derivado o sintético)."],
            ["regla_patron", "Las seis reglas de sistema (M1), globales o con parámetros propios por indicador."],
            ["evaluacion / memoria_evaluacion", "El resultado de cada evaluación (estado, clasificación, reglas disparadas) y una fila de memoria por cada regla disparada, con sus valores de entrada y su explicación en texto."],
            ["accion_catalogo / regla_accion", "La biblioteca de acciones correctoras y su mapeo hacia (categoría + regla disparada + clasificación), consultada por M3. Compartida por toda la instalación, editable desde la pantalla Catálogo de acciones -- el campo esDeSistema distingue las nueve acciones originales de las que agrega el propio usuario."],
            ["accion_tomada / verificacion_accion", "Cada acción registrada, con su responsable, fecha de compromiso y estado, y el resultado de verificación propuesto y confirmado en el periodo siguiente."],
            ["presupuesto / escenario_sintetico / diagnostico_organizacional / factura_transporte", "El presupuesto por rubro y periodo, los escenarios guardados del laboratorio de generación, cada diagnóstico organizacional respondido, y las facturas de transporte con su discrepancia auditada."],
        ],
        profile=profile,
        caption="Tablas principales del modelo de datos",
    )
    doc_engine.agregar_nota(
        doc,
        "El borrado de un indicador elimina en cascada sus mediciones, "
        "evaluaciones y memoria asociadas; el borrado de una acción del catálogo "
        "está protegido si ya fue usada en una acción tomada -- el sistema "
        "responde con un mensaje claro en vez de fallar en silencio, ya que la "
        "restricción de llave foránea de la base de datos rechaza ese borrado.",
        profile, tipo="nota",
    )

    # ------------------------------------------------------------------
    # 9. Tecnologías utilizadas
    # ------------------------------------------------------------------
    doc_engine.agregar_titulo(doc, "Tecnologías Utilizadas", nivel=1, profile=profile)
    doc_engine.agregar_tabla(
        doc,
        headers=["Tecnología", "Uso en el sistema"],
        filas=[
            ["Flutter / Dart", "Aplicación multiplataforma única (Windows, Linux, Android) desde un solo árbol de widgets."],
            ["drift + drift_flutter", "Persistencia local de la organización, sus mediciones, evaluaciones y el catálogo de acciones, embebida, sin servidor."],
            ["provider", "Estado de la aplicación."],
            ["fl_chart", "Serie temporal con banda de tolerancia sombreada y leyenda, y el radar del diagnóstico organizacional."],
            ["pdf + printing", "Informes exportables a PDF."],
            ["path_provider, share_plus, android_intent_plus, url_launcher", "Exportación de archivos y apertura de la carpeta de exportados en cada sistema operativo."],
            ["flex_color_scheme, google_fonts, lucide_icons_flutter, flutter_animate", "Identidad visual, compartida con el resto de las aplicaciones del repositorio."],
            ["shared_preferences", "Únicamente la bandera de si la inducción guiada ya se mostró."],
        ],
        profile=profile,
        caption="Tecnologías utilizadas y su uso en el sistema",
    )
    doc_engine.agregar_nota(
        doc,
        "Ninguna dependencia del proyecto requiere pago, cuenta ni servicio en la "
        "nube. No se agregó http ni ningún paquete de red -- el sistema no "
        "consulta ninguna red, nunca -- ni ningún paquete de estadística: las "
        "reglas de patrón son aritmética elemental escrita en Dart puro, "
        "auditable línea por línea.",
        profile, tipo="nota",
    )

    # ------------------------------------------------------------------
    # 10. Requisitos del sistema
    # ------------------------------------------------------------------
    doc_engine.agregar_titulo(doc, "Requisitos del Sistema", nivel=1, profile=profile)
    doc_engine.agregar_tabla(
        doc,
        headers=["Plataforma", "Requisito"],
        filas=[
            ["Windows", "Windows 10 de 64 bits o superior. Distribuido como ejecutable portable (sin instalador)."],
            ["Linux", "Distribución de escritorio con GTK 3. Distribuido como AppImage de un solo archivo."],
            ["Android", "Android 7.0 o superior. Distribuido como APK firmado. No requiere conexión a internet en ningún momento de su uso."],
        ],
        profile=profile,
        caption="Requisitos mínimos por plataforma",
    )

    # ------------------------------------------------------------------
    # 11. Empaquetado y distribución
    # ------------------------------------------------------------------
    doc_engine.agregar_titulo(doc, "Empaquetado y Distribución", nivel=1, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "El sistema se compila de forma nativa para cada una de las tres "
        "plataformas objetivo desde el mismo código fuente. El release de "
        "Android se firma con una key de release propia -- no la key de "
        "depuración -- a través de un secret de repositorio con nombre propio "
        "para este proyecto, necesario porque el repositorio aloja otras "
        "aplicaciones hermanas que también firman su propio release de Android, "
        "y los secrets de GitHub son globales al repositorio, no por carpeta. El "
        "release de Linux se empaqueta como AppImage, un único archivo "
        "ejecutable que no requiere instalación ni dependencias adicionales en "
        "el equipo destino. El release de Windows se compila y empaqueta de "
        "forma automatizada mediante integración continua (GitHub Actions), "
        "incluyendo el runtime de Visual C++ que la aplicación necesita.",
    )
    doc_engine.agregar_nota(
        doc,
        "El ícono adaptativo de Android se genera rasterizando un SVG de fondo "
        "transparente; hacerlo sin fijar explícitamente un fondo transparente en "
        "el comando de rasterización puede producir silenciosamente una imagen "
        "en blanco -- sin ningún error visible durante la compilación -- que "
        "solo se nota al instalar la aplicación en un dispositivo real y ver el "
        "ícono vacío.",
        profile, tipo="nota",
    )

    # ------------------------------------------------------------------
    # 12. Conclusiones
    # ------------------------------------------------------------------
    doc_engine.agregar_titulo(doc, "Conclusiones", nivel=1, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "El Sistema de Control Logístico v1.1 cumple el objetivo general "
        "planteado: implementa un lazo cerrado de control administrativo "
        "completo, desde la definición de estándares con banda de tolerancia "
        "hasta la verificación del efecto real de cada acción tomada, con la "
        "detección de patrones sobre la serie completa como diferencia central "
        "frente a un umbral simple -- diferencia que el propio sistema permite "
        "comprobar de forma cuantitativa en su laboratorio de contraste. Los "
        "diez módulos del motor (M1 a M10) se implementaron como funciones "
        "puras independientes, lo que permitió validar cada uno por separado, "
        "incluyendo el caso dorado más importante del sistema: que un punto "
        "aislado fuera de banda nunca dispara una acción por sí solo.",
    )
    doc_engine.agregar_parrafo(
        doc,
        "El sistema corre de forma idéntica en Windows, Linux y Android desde un "
        "único árbol de código, sin backend, sin cuenta de usuario y sin "
        "ninguna dependencia de pago -- cumpliendo la restricción de "
        "presupuesto cero establecida desde el inicio del proyecto. La "
        "verificación completa como usuario real, pantalla por pantalla, "
        "encontró y corrigió defectos reales de usabilidad -- desde textos poco "
        "claros hasta una columna de tabla que se perdía de vista al "
        "desplazarse -- y llevó a agregar dos capacidades que no estaban en el "
        "alcance original: un catálogo de acciones editable por el propio "
        "usuario, y una guía de referencia que documenta en lenguaje llano cómo "
        "clasifica el sistema, confirmando que el sistema está listo para su "
        "uso en un entorno real de control logístico.",
    )

    salida_dir = os.path.join(os.path.dirname(__file__), "salida")
    os.makedirs(salida_dir, exist_ok=True)
    salida = os.path.join(salida_dir, "Memoria_Descriptiva.docx")
    doc_engine.guardar(doc, salida)
    print(f"Generado: {salida}")


if __name__ == "__main__":
    main()
