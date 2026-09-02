"""
Manual de Usuario — Sistema de Control Logístico (Word).

Genera docs/word/salida/Manual_de_Usuario.docx usando el motor de
documentación compartido (perfil manual_usuario). Contenido real del
proyecto (no placeholders) + capturas reales de la app corriendo contra el
caso de estudio "Distribuidora Ejemplo S.A.C.", algunas anotadas con
callouts numerados (ver annotate.py).

Ejecutar con el venv del motor:
    /home/kael/Escritorio/documentacion/word/.venv/bin/python generar_manual_usuario.py
"""

import os
import sys

sys.path.insert(0, "/home/kael/Escritorio/documentacion/word")

from engine import doc_engine
from engine.profiles import get_profile

PERFIL = "manual_usuario"
IMG = os.path.join(os.path.dirname(__file__), "img")


def img(nombre):
    return os.path.join(IMG, nombre)


def main():
    profile = get_profile(PERFIL)
    doc = doc_engine.crear_documento(PERFIL)

    seccion_cuerpo = doc_engine.agregar_caratula(
        doc, profile,
        nombre_proyecto="Sistema de Control Logístico",
        descripcion_breve="Recibe las mediciones de tus indicadores periodo a periodo, detecta cuándo una desviación amerita actuar, propone una acción correctora y verifica si funcionó",
        titulo_documento="Manual de Usuario",
        subtitulo_documento="Versión 1.1",
        metadatos={
            "Sistema": "Sistema de Control Logístico v1.1",
            "Documento": "Manual de Usuario",
            "Autor": "Kael Torre",
            "Fecha": "Setiembre 2026",
        },
    )

    if profile.toc_obligatorio:
        doc_engine.insertar_indice(doc, profile)
        doc_engine.agregar_salto_pagina(doc)

    doc_engine.configurar_header_footer(
        doc, "Manual de Usuario — Sistema de Control Logístico v1.1", profile, seccion_cuerpo
    )

    # ------------------------------------------------------------------
    # 1. Introducción
    # ------------------------------------------------------------------
    doc_engine.agregar_titulo(doc, "Introducción", nivel=1, profile=profile)

    doc_engine.agregar_titulo(doc, "Propósito del documento", nivel=2, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "Este Manual de Usuario explica cómo instalar el Sistema de Control Logístico "
        "en Windows, Linux y Android, y cómo usarlo de principio a fin: cómo registrar "
        "tus indicadores, cargar mediciones periodo a periodo, entender por qué el "
        "sistema marca una desviación, registrar la acción que tomaste y confirmar si "
        "realmente funcionó.",
    )

    doc_engine.agregar_titulo(doc, "Alcance", nivel=2, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "El sistema recibe indicadores logísticos ya calculados (costos, niveles de "
        "servicio, productividad) periodo a periodo, revisa la serie completa -- no "
        "solo el último valor -- para detectar cuándo una desviación amerita actuar, "
        "clasifica qué tan grave es, propone una acción correctora concreta desde una "
        "biblioteca, y verifica en el periodo siguiente si esa acción funcionó de "
        "verdad. Todo funciona sin conexión a internet y sin cuenta de usuario: la "
        "información vive en tu propio equipo.",
    )
    doc_engine.agregar_nota(
        doc,
        "El sistema NO es un ERP ni un WMS (no maneja pedidos, existencias ni "
        "movimientos de almacén -- recibe indicadores ya calculados), NO opera en "
        "tiempo real (no hay eventos ni notificaciones automáticas), NO tiene "
        "inteligencia artificial (las reglas que detectan una desviación son "
        "estadística de control de procesos, determinista y auditable, no un modelo "
        "de IA) y NO genera acciones nuevas por su cuenta: las propone desde una "
        "biblioteca que tú mismo puedes ampliar.",
        profile, tipo="advertencia",
    )

    doc_engine.agregar_titulo(doc, "Versión del sistema", nivel=2, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "Este manual corresponde a la versión 1.1, que cubre el ciclo completo de "
        "control (captura, evaluación, acciones, verificación), los informes de "
        "costo, servicio, productividad y presupuesto, el laboratorio de escenarios "
        "para practicar con datos sintéticos, el diagnóstico organizacional, la "
        "auditoría de facturas de transporte, el catálogo de acciones editable y la "
        "exportación de toda la información.",
    )

    # ------------------------------------------------------------------
    # 2. Requisitos del sistema
    # ------------------------------------------------------------------
    doc_engine.agregar_titulo(doc, "Requisitos del Sistema", nivel=1, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "El sistema corre de forma completamente local: los datos que ingresas y los "
        "archivos que exportas se quedan en tu propio equipo, sin ninguna cuenta ni "
        "servicio en la nube de por medio. No necesitas conexión a internet en "
        "ningún momento de su uso normal.",
    )
    doc_engine.agregar_tabla(
        doc,
        headers=["Plataforma", "Requisito mínimo"],
        filas=[
            ["Windows", "Windows 10 de 64 bits o superior"],
            ["Linux", "Distribución de escritorio con GTK 3 (Ubuntu, Fedora, Debian, Arch, etc.)"],
            ["Android", "Android 7.0 o superior, con permiso para instalar desde \"orígenes desconocidos\""],
        ],
        profile=profile,
        caption="Requisitos mínimos por plataforma",
    )

    # ------------------------------------------------------------------
    # 3. Instalación
    # ------------------------------------------------------------------
    doc_engine.agregar_titulo(doc, "Instalación", nivel=1, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "El sistema se distribuye como un archivo independiente por cada plataforma. "
        "En ninguno de los tres casos hace falta un instalador tradicional ni "
        "permisos de administrador.",
    )

    doc_engine.agregar_titulo(doc, "Instalación en Windows", nivel=2, profile=profile)
    doc_engine.agregar_lista(doc, [
        "Descarga el archivo ControlLogistico-portable.exe.",
        "Haz doble clic sobre el archivo descargado.",
        "El programa se autoextrae a una carpeta temporal y arranca solo -- no hay pasos de instalación ni ventanas de configuración que llenar.",
        "Windows puede mostrar una advertencia de \"Editor desconocido\" (SmartScreen), porque el archivo no tiene un certificado de firma comercial pagado. Elige \"Más información\" y luego \"Ejecutar de todas formas\" para continuar.",
    ], tipo="numbered")
    doc_engine.agregar_nota(
        doc,
        "El archivo .exe ya incluye todo lo que la aplicación necesita para correr "
        "(las librerías de Visual C++ de Windows) -- no hace falta instalar nada "
        "aparte, incluso en un Windows recién instalado.",
        profile, tipo="nota",
    )

    doc_engine.agregar_titulo(doc, "Instalación en Linux", nivel=2, profile=profile)
    doc_engine.agregar_lista(doc, [
        "Descarga el archivo ControlLogistico-x86_64.AppImage.",
        "Dale permiso de ejecución al archivo.",
        "Ejecútalo directamente -- no hace falta descomprimir nada ni instalar dependencias adicionales.",
    ], tipo="numbered")
    doc_engine.agregar_parrafo(doc, "Para dar el permiso de ejecución, desde una terminal:")
    doc_engine.agregar_codigo(doc, "chmod +x ControlLogistico-x86_64.AppImage\n./ControlLogistico-x86_64.AppImage", profile)
    doc_engine.agregar_nota(
        doc,
        "AppImage es un formato portable: no modifica el resto del sistema ni "
        "necesita privilegios de administrador (sudo). Puedes mover el archivo a "
        "cualquier carpeta, o incluso a una memoria USB, y va a seguir funcionando "
        "igual.",
        profile, tipo="nota",
    )

    doc_engine.agregar_titulo(doc, "Instalación en Android", nivel=2, profile=profile)
    doc_engine.agregar_lista(doc, [
        "Descarga el archivo .apk al teléfono o tableta.",
        "Ábrelo desde el gestor de archivos o desde las notificaciones de descarga.",
        "Si es la primera vez que instalas una aplicación fuera de Google Play, Android va a pedir habilitar \"Instalar apps desconocidas\" para la aplicación que estás usando para abrirlo (el navegador o el gestor de archivos). Acepta ese permiso.",
        "Confirma la instalación. El ícono \"Control Logístico\" queda disponible en el cajón de aplicaciones.",
    ], tipo="numbered")
    doc_engine.agregar_nota(
        doc,
        "Instalar un .apk fuera de Google Play no es inseguro por sí solo, pero sí "
        "hay que confiar en la fuente del archivo -- descárgalo solo de un canal en "
        "el que confíes. Una vez instalado, el sistema funciona completamente sin "
        "conexión a internet: no necesita red ni siquiera la primera vez que se "
        "abre.",
        profile, tipo="advertencia",
    )

    doc_engine.agregar_titulo(doc, "Primer inicio: la inducción guiada", nivel=2, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "La primera vez que abres el sistema aparece una inducción guiada de 13 "
        "pasos que recorre cada parte del ciclo de control explicando para qué "
        "sirve. Puedes volver a verla cuando quieras desde el ícono de interrogación "
        "(?) de la esquina superior derecha de la pantalla Inicio, y avanzar, "
        "retroceder o saltarla en cualquier momento.",
    )
    doc_engine.agregar_imagen(doc, img("00_induccion.png"), "Pantalla de bienvenida de la inducción guiada, paso 1 de 13", profile)

    doc_engine.agregar_salto_pagina(doc)

    # ------------------------------------------------------------------
    # 4. Interfaz principal
    # ------------------------------------------------------------------
    doc_engine.agregar_titulo(doc, "Interfaz Principal", nivel=1, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "Al abrir el sistema por primera vez, sin ninguna organización cargada, "
        "tienes tres caminos: crear tu propia organización desde cero, cargar el "
        "caso de estudio de ejemplo para explorar el sistema con datos ya listos, o "
        "importar una organización que ya exportaste antes desde este mismo sistema.",
    )
    doc_engine.agregar_imagen(
        doc, img("00b_sin_organizacion_anotada.png"),
        "Pantalla inicial sin ninguna organización cargada. (1) Crear tu propia "
        "organización. (2) Cargar el caso de estudio de ejemplo, con datos "
        "sintéticos ya listos para explorar. (3) Importar una organización ya "
        "exportada desde otra instalación.",
        profile,
    )
    doc_engine.agregar_nota(
        doc,
        "El sistema trabaja con una sola organización por instalación -- no es una "
        "lista de proyectos. Si quieres empezar de nuevo, borra la organización "
        "actual (ícono de papelera en la esquina superior derecha del panel) antes "
        "de crear o cargar otra.",
        profile, tipo="nota",
    )
    doc_engine.agregar_parrafo(
        doc,
        "Una vez que hay una organización cargada, el panel de Inicio se organiza "
        "en el orden real en que se usa el sistema, no como una lista de botones "
        "sueltos: primero la configuración que haces una sola vez, luego el ciclo "
        "de cuatro pasos que repites cada periodo, y después los informes y "
        "herramientas que consultas cuando los necesitas.",
    )
    doc_engine.agregar_imagen(
        doc, img("01_inicio.png"),
        "Panel de Inicio con el caso de estudio \"Distribuidora Ejemplo S.A.C.\" cargado",
        profile,
    )

    doc_engine.agregar_salto_pagina(doc)

    # ------------------------------------------------------------------
    # 5. Flujo principal de uso
    # ------------------------------------------------------------------
    doc_engine.agregar_titulo(doc, "Flujo Principal de Uso", nivel=1, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "Las capturas de esta sección corresponden al caso de estudio "
        "\"Distribuidora Ejemplo S.A.C.\", precargado con nueve indicadores y "
        "treinta y seis periodos mensuales de datos sintéticos, para que cada "
        "pantalla se vea con información real en vez de formularios vacíos. Todo "
        "dato de este caso queda etiquetado como \"Sintético\" en la propia "
        "interfaz -- nunca se presenta como si fuera de una empresa real.",
    )

    doc_engine.agregar_titulo(doc, "Paso 1 — Configura tu organización", nivel=2, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "El primer dato es tu organización: nombre, moneda (un código de tres "
        "letras, como PEN o USD), el tipo de empresa como referencia, y notas "
        "opcionales. Se edita en cualquier momento con el ícono de lápiz de la "
        "esquina superior derecha del panel.",
    )
    doc_engine.agregar_imagen(doc, img("02_organizacion.png"), "Datos de la organización", profile)

    doc_engine.agregar_titulo(doc, "Paso 2 — Crea tus periodos", nivel=2, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "Un periodo es una posición en la secuencia de medición: enero, febrero, "
        "una semana, un trimestre -- el sistema no lee la fecha del calendario, "
        "usa el orden que tú defines. Esto es lo que hace posible el laboratorio de "
        "simulación (Paso 14): puedes cargar treinta y seis periodos de historia y "
        "recorrerla en segundos.",
    )
    doc_engine.agregar_imagen(doc, img("03_periodos.png"), "Calendario de periodos del caso de estudio", profile)
    doc_engine.agregar_imagen(doc, img("03b_periodo_form.png"), "Formulario de un periodo nuevo", profile)

    doc_engine.agregar_titulo(doc, "Paso 3 — Define tus indicadores", nivel=2, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "Un indicador es lo que vas a medir cada periodo: su categoría (costo, "
        "servicio o productividad), a qué proceso pertenece, su unidad, su meta "
        "(el valor esperado en condiciones normales) y su banda de tolerancia -- el "
        "rango alrededor de la meta que todavía se considera normal. También "
        "defines el \"sentido de mejora\": si un valor alto es un problema (como un "
        "costo) o si es bueno (como un porcentaje de cumplimiento).",
    )
    doc_engine.agregar_imagen(doc, img("04_indicadores.png"), "Catálogo de indicadores del caso de estudio", profile)
    doc_engine.agregar_imagen(
        doc, img("04b_indicador_form.png"),
        "Formulario de un indicador nuevo, con texto de ayuda en cada campo técnico",
        profile,
    )
    doc_engine.agregar_nota(
        doc,
        "El campo \"Sentido de mejora\" es el más importante de este formulario: "
        "decide qué lado de la banda es el lado adverso para todo el sistema. Si un "
        "costo se elige por error como \"Mayor es mejor\", el sistema va a vigilar "
        "el lado contrario al que realmente importa.",
        profile, tipo="advertencia",
    )

    doc_engine.agregar_titulo(doc, "Paso 4 — Captura las mediciones de cada periodo", nivel=2, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "Elige un indicador y registra su valor en cada periodo, uno por uno, o "
        "importa varios de un jalón pegando texto separado por comas (formato "
        "\"orden,valor,nota\"). El origen de cada medición queda registrado -- "
        "manual, importado, derivado o sintético -- y se muestra siempre junto al "
        "valor.",
    )
    doc_engine.agregar_imagen(doc, img("06_captura.png"), "Captura de mediciones del indicador \"Costo de almacenamiento por unidad despachada\"", profile)
    doc_engine.agregar_imagen(doc, img("06b_captura_editar.png"), "Registro manual de una medición", profile)

    doc_engine.agregar_titulo(doc, "Paso 5 — Revisa la serie de un indicador", nivel=2, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "Cada indicador tiene su propia gráfica: la serie completa de valores "
        "contra la meta (línea punteada) y la banda de tolerancia (área "
        "sombreada), con una leyenda que identifica cada elemento. Se abre con el "
        "ícono de gráfica junto a cada indicador en el catálogo.",
    )
    doc_engine.agregar_imagen(
        doc, img("05_detalle_indicador_anotada.png"),
        "Serie completa del indicador \"Productividad de preparación de pedidos\". "
        "(1) Valor medido en cada periodo. (2) La meta. (3) La banda de tolerancia.",
        profile,
    )

    doc_engine.agregar_titulo(doc, "Paso 6 — Evalúa el periodo", nivel=2, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "Al pulsar \"Evaluar\" sobre un periodo, el sistema revisa la serie "
        "completa de cada indicador activo -- no solo el último valor -- contra "
        "seis reglas de patrón, y clasifica el resultado en cuatro niveles: "
        "normal, en observación, o una desviación con una de tres magnitudes "
        "(ajuste menor, replaneación mayor o contingencia). Cada indicador se "
        "puede expandir para ver exactamente qué regla disparó y por qué, en "
        "español llano.",
    )
    doc_engine.agregar_imagen(doc, img("07_evaluacion.png"), "Evaluación del periodo Diciembre 2025 -- semáforo por indicador", profile)
    doc_engine.agregar_imagen(
        doc, img("07b_evaluacion_detalle.png"),
        "Detalle de la evaluación de \"Costo de transporte\": clasificó como "
        "Contingencia, con la explicación de cada regla que disparó y cuál no",
        profile,
    )
    doc_engine.agregar_nota(
        doc,
        "Si un indicador dispara únicamente la regla \"Punto fuera de banda\" (R1), "
        "sin ninguna otra regla, el sistema lo marca como \"En observación\" pero "
        "no propone ninguna acción todavía. Es la diferencia central de este "
        "sistema frente a mirar solo si el último valor se salió del rango: un "
        "solo punto aislado no alcanza para actuar.",
        profile, tipo="nota",
    )

    doc_engine.agregar_titulo(doc, "Paso 7 — Registra la acción tomada", nivel=2, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "Cuando un indicador clasifica con una desviación real, la pantalla "
        "Acciones te deja elegir una acción propuesta desde el catálogo (Paso 13) "
        "y registrarla con un responsable y una fecha de compromiso. El sistema "
        "propone; la decisión final siempre es tuya.",
    )
    doc_engine.agregar_imagen(doc, img("08_acciones.png"), "Pantalla Acciones: pendientes de proponer y ya registradas", profile)
    doc_engine.agregar_imagen(doc, img("08b_proponer.png"), "Acciones propuestas para \"Costo de transporte\" en Contingencia", profile)
    doc_engine.agregar_imagen(doc, img("08c_registrar_accion.png"), "Registro de la acción elegida, con responsable y fecha de compromiso", profile)
    doc_engine.agregar_imagen(doc, img("08d_accion_tomada.png"), "La acción ya registrada, visible en \"Acciones tomadas\"", profile)

    doc_engine.agregar_titulo(doc, "Paso 8 — Verifica si la acción funcionó", nivel=2, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "En el periodo siguiente al de una acción abierta, esta pantalla propone "
        "un resultado de verificación (corrigió, no corrigió o parcial) comparando "
        "el nuevo valor contra la meta y contra el valor del periodo de la "
        "desviación. El sistema propone, tú confirmas -- una acción nunca se "
        "cierra sola.",
    )
    doc_engine.agregar_imagen(doc, img("09_verificacion.png"), "Verificación pendiente de la acción sobre \"Costo de transporte\"", profile)

    doc_engine.agregar_salto_pagina(doc)

    # ------------------------------------------------------------------
    # 6. Informes y análisis
    # ------------------------------------------------------------------
    doc_engine.agregar_titulo(doc, "Informes y Análisis", nivel=1, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "Estas pantallas se consultan cuando hace falta revisar el desempeño "
        "acumulado, no cada periodo -- están agrupadas aparte del ciclo de control "
        "en el panel de Inicio.",
    )

    doc_engine.agregar_titulo(doc, "Tabla de desempeño", nivel=2, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "Una matriz de todos los indicadores contra todos los periodos, con el "
        "semáforo de cada evaluación ya guardada. La columna de nombres queda fija "
        "mientras te desplazas horizontalmente por los periodos, para nunca perder "
        "de vista qué indicador es cada fila.",
    )
    doc_engine.agregar_imagen(
        doc, img("10_tabla_desempeno_anotada.png"),
        "Tabla de desempeño desplazada hasta Diciembre 2025. (1) La columna de "
        "nombres se queda fija aunque te desplaces a la derecha. (2) El semáforo "
        "de cada indicador en ese periodo: verde normal, ámbar en observación, "
        "rojo en desviación.",
        profile,
    )

    doc_engine.agregar_titulo(doc, "Costo y servicio, y Productividad", nivel=2, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "Dos informes con el mismo criterio: el costo logístico total desglosado "
        "por proceso con su peso relativo, y los índices de productividad contra "
        "su meta, para el periodo que elijas.",
    )
    doc_engine.agregar_imagen(doc, img("11_costo_servicio.png"), "Informe de costo y servicio de Diciembre 2025", profile)
    doc_engine.agregar_imagen(doc, img("14_productividad.png"), "Informe de productividad de Diciembre 2025", profile)

    doc_engine.agregar_titulo(doc, "Presupuesto", nivel=2, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "Compara lo presupuestado contra lo real, rubro por rubro, con las "
        "variaciones ya calculadas. Los montos se ingresan en la moneda de tu "
        "organización -- el campo trae el símbolo correspondiente.",
    )
    doc_engine.agregar_imagen(doc, img("12b_presupuesto_form.png"), "Formulario de un nuevo rubro presupuestal", profile)

    doc_engine.agregar_salto_pagina(doc)

    # ------------------------------------------------------------------
    # 7. Laboratorio de escenarios
    # ------------------------------------------------------------------
    doc_engine.agregar_titulo(doc, "Laboratorio de Escenarios", nivel=1, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "Cuatro herramientas opcionales para practicar y calibrar el sistema con "
        "datos sintéticos, sin tocar ninguna medición real.",
    )

    doc_engine.agregar_titulo(doc, "Generador", nivel=2, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "Genera una serie sintética eligiendo un patrón (estable, punto aislado, "
        "tendencia, corrimiento, estacional o deterioro brusco), una semilla -- el "
        "mismo número siempre produce la misma serie -- y qué tanto ruido "
        "aleatorio agregar. Sirve para ver, con un ejemplo controlado, cómo "
        "reacciona el sistema ante cada tipo de problema antes de que ocurra de "
        "verdad.",
    )
    doc_engine.agregar_imagen(doc, img("13_lab_generador.png"), "Serie sintética generada con el patrón \"Deterioro brusco\"", profile)

    doc_engine.agregar_titulo(doc, "Simulación", nivel=2, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "Un reloj que avanza y retrocede periodo por periodo sobre la historia "
        "real de un indicador, recalculando el estado en cada paso -- ideal para "
        "mostrar, en vivo, el momento exacto en que una serie pasa de normal a "
        "una desviación real.",
    )
    doc_engine.agregar_imagen(
        doc, img("14_lab_simulacion.png"),
        "Reloj de simulación en el periodo 31 de \"Costo de transporte\": el "
        "semáforo pasó a rojo y el sistema clasificó Contingencia",
        profile,
    )

    doc_engine.agregar_titulo(doc, "Contraste", nivel=2, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "Compara, sobre la misma serie real, cuándo hubiera detectado el problema "
        "un umbral simple (solo mirar si el último valor se sale del rango) contra "
        "el reconocimiento de patrones de este sistema -- el argumento central de "
        "por qué vale la pena mirar la serie completa.",
    )
    doc_engine.agregar_imagen(
        doc, img("15_lab_contraste.png"),
        "Contraste sobre \"Costo de transporte\": el reconocimiento de patrones "
        "detectó el problema un periodo antes que el umbral simple, con cero "
        "falsas alarmas en los dos métodos",
        profile,
    )

    doc_engine.agregar_titulo(doc, "Calibrador", nivel=2, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "Marca qué periodos de la historia fueron, a tu criterio, un problema "
        "real, y el sistema propone el ancho de banda más angosto que detecta "
        "todos esos periodos con la menor cantidad de falsas alarmas posible.",
    )
    doc_engine.agregar_imagen(
        doc, img("17_lab_calibrador_anotada.png"),
        "Calibrador sobre \"Costo de transporte\" con cinco periodos marcados. "
        "(1) La banda que el indicador tiene configurada hoy. (2) La banda que el "
        "sistema propone. (3) Cuántos de los periodos marcados detecta, y con "
        "cuántas falsas alarmas.",
        profile,
    )

    doc_engine.agregar_salto_pagina(doc)

    # ------------------------------------------------------------------
    # 8. Otros módulos
    # ------------------------------------------------------------------
    doc_engine.agregar_titulo(doc, "Otros Módulos", nivel=1, profile=profile)

    doc_engine.agregar_titulo(doc, "Diagnóstico organizacional", nivel=2, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "Un cuestionario de dieciséis preguntas que ubica a tu organización en una "
        "etapa de desarrollo logístico, un eje de centralización, un rol de "
        "asesor o de línea, y una orientación dominante (por proceso, por mercado "
        "o por información). El resultado se muestra en un radar contra un perfil "
        "de referencia, con un informe de brechas.",
    )
    doc_engine.agregar_imagen(doc, img("18b_diagnostico_cuestionario.png"), "Cuestionario del diagnóstico organizacional", profile)
    doc_engine.agregar_imagen(
        doc, img("18d_diagnostico_radar_anotada.png"),
        "Resultado del diagnóstico. (1) Radar comparando tu organización contra "
        "el perfil de referencia en cada eje. (2) Informe de brechas, eje por eje.",
        profile,
    )

    doc_engine.agregar_titulo(doc, "Auditoría de facturas", nivel=2, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "Carga las facturas de transporte con la tarifa cobrada y la tarifa "
        "contratada, y el botón \"Auditar todas\" recalcula la discrepancia y el "
        "monto recuperable de cada una automáticamente. Las discrepancias que el "
        "sistema no puede calcular solo (peso, ruta, descripción, cargo "
        "accesorio) se marcan a mano, y esa marca nunca se pisa en una auditoría "
        "posterior.",
    )
    doc_engine.agregar_imagen(doc, img("19b_factura_form.png"), "Formulario de una factura nueva", profile)
    doc_engine.agregar_imagen(
        doc, img("19_auditoria_anotada.png"),
        "Resultado de la auditoría: una tarifa inflada de S/ 950.00 contra "
        "S/ 800.00 contratados. (1) Monto recuperable total pendiente. (2) Tipo "
        "de discrepancia detectado. (3) Monto recuperable de esa factura.",
        profile,
    )

    doc_engine.agregar_titulo(doc, "Catálogo de acciones", nivel=2, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "Aquí se define qué acción proponer para cada combinación de categoría de "
        "indicador y magnitud de respuesta, y qué reglas la disparan -- es lo que "
        "consulta la pantalla Acciones (Paso 7) para armar sus propuestas. El "
        "sistema trae nueve acciones ya cargadas (una por cada categoría y "
        "magnitud), y puedes crear, editar o eliminar las tuyas propias, marcadas "
        "siempre con la etiqueta \"Propia\".",
    )
    doc_engine.agregar_imagen(
        doc, img("20_catalogo_acciones_anotada.png"),
        "Catálogo de acciones, categoría Costo. (1) La magnitud de respuesta. "
        "(2) Las reglas de patrón que disparan esta acción. (3) Agregar una "
        "acción propia para este mismo escenario.",
        profile,
    )
    doc_engine.agregar_nota(
        doc,
        "La magnitud que elijas al crear una acción propia debe coincidir "
        "exactamente con la que el sistema calcule para el periodo -- no se "
        "adivina por el nombre. Si no estás seguro, la pantalla \"Cómo clasifica "
        "el sistema\" (ícono de ayuda, arriba a la derecha) explica en lenguaje "
        "simple las seis reglas y cómo se combinan en una clasificación.",
        profile, tipo="advertencia",
    )
    doc_engine.agregar_imagen(
        doc, img("21_guia_clasificacion.png"),
        "Guía \"Cómo clasifica el sistema\", con las seis reglas explicadas en "
        "lenguaje llano",
        profile,
    )

    doc_engine.agregar_salto_pagina(doc)

    # ------------------------------------------------------------------
    # 9. Exportación
    # ------------------------------------------------------------------
    doc_engine.agregar_titulo(doc, "Exportación", nivel=1, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "Genera un archivo JSON con toda la información de tu organización: "
        "periodos, indicadores, mediciones, evaluaciones, acciones registradas y "
        "su verificación, presupuesto, diagnóstico organizacional y facturas "
        "auditadas. Sirve como respaldo, o para llevar tu organización a otra "
        "instalación del sistema en otro equipo.",
    )
    doc_engine.agregar_imagen(doc, img("22_exportacion.png"), "Pantalla de Exportación", profile)
    doc_engine.agregar_nota(
        doc,
        "Para importar un archivo exportado, elimina primero la organización "
        "actual desde la pantalla inicial (ícono de papelera) y elige \"Importar "
        "una organización ya exportada\" -- el sistema trabaja con una sola "
        "organización por instalación.",
        profile, tipo="nota",
    )

    doc_engine.agregar_salto_pagina(doc)

    # ------------------------------------------------------------------
    # 10. Preguntas frecuentes
    # ------------------------------------------------------------------
    doc_engine.agregar_titulo(doc, "Preguntas Frecuentes", nivel=1, profile=profile)

    doc_engine.agregar_titulo(doc, "¿Necesito internet para usar el sistema?", nivel=3, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "No, en ningún momento. Todo el cálculo -- las reglas de patrón, la "
        "clasificación, los informes -- corre en tu propio equipo. La única "
        "excepción es la descarga inicial del instalador.",
    )

    doc_engine.agregar_titulo(doc, "¿Por qué una desviación no aparece en Acciones para proponer nada?", nivel=3, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "Si el indicador quedó marcado como \"En observación\" (solo disparó la "
        "regla de punto fuera de banda, sin ninguna otra), el sistema no propone "
        "ninguna acción todavía -- un solo punto aislado no alcanza. Es la "
        "diferencia central frente a un umbral simple: revisa la sección "
        "\"Evaluación del periodo\" para confirmar en qué estado quedó realmente.",
    )

    doc_engine.agregar_titulo(doc, "¿Por qué la acción que configuré no aparece como propuesta?", nivel=3, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "Casi siempre es un desajuste entre la magnitud que le diste a tu acción "
        "en el Catálogo de acciones y la magnitud que realmente calculó el "
        "sistema para ese periodo -- las cuatro clasificaciones (ninguna, ajuste "
        "menor, replaneación mayor, contingencia) son una cascada de prioridad, no "
        "algo que se adivine por el nombre. Revisa \"Cómo clasifica el sistema\" "
        "y compara contra el detalle real en Evaluación del periodo.",
    )

    doc_engine.agregar_titulo(doc, "¿Los datos del caso de estudio son de una empresa real?", nivel=3, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "No. \"Distribuidora Ejemplo S.A.C.\" es un caso sintético construido "
        "para explorar el sistema con información ya cargada. Todas sus "
        "mediciones quedan etiquetadas como \"Sintético\" en la pantalla de "
        "Captura, nunca se presentan como datos reales.",
    )

    doc_engine.agregar_titulo(doc, "¿Se puede cerrar una acción automáticamente?", nivel=3, profile=profile)
    doc_engine.agregar_parrafo(
        doc,
        "No, nunca. El sistema propone un resultado de verificación en la "
        "pantalla Verificación, pero la decisión de marcar una acción como "
        "cerrada siempre la confirma la persona que usa el sistema.",
    )

    salida_dir = os.path.join(os.path.dirname(__file__), "salida")
    os.makedirs(salida_dir, exist_ok=True)
    salida = os.path.join(salida_dir, "Manual_de_Usuario.docx")
    doc_engine.guardar(doc, salida)
    print(f"Generado: {salida}")


if __name__ == "__main__":
    main()
