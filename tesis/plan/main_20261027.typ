#import "@preview/lovelace:0.3.1": pseudocode-list
// =============================================================================
// Plan de Tesis de Maestría de Especialización / Profesionalizante
// Universidad Nacional de Ingeniería — Escuela de Posgrado
// Basada en: tesis/formato/formato-plan-tesis.md
// Contenido elaborado a partir de:
//  - mead_project/ref_doc/1.Tesis-Grupo_4_Tesis.md
//  - mead_project/informe/Informe_Final_MIES.typ
// =============================================================================

// -----------------------------------------------------------------------------
// DATOS DEL PLAN DE TESIS (edita esta sección)
// -----------------------------------------------------------------------------
#let institucion = "UNIVERSIDAD NACIONAL DE INGENIERÍA"
#let unidad = "FACULTAD DE INGENIERÍA INDUSTRIAL Y DE SISTEMAS / ESCUELA DE POSGRADO"
#let area = "Unidad de Posgrado: Escuela de Posgrado"
#let titulo-plan = "Estimación de la probabilidad de paralización de Obras Públicas en el Perú mediante técnicas de Inteligencia Artificial"
#let mencion = "INTELIGENCIA ARTIFICIAL"
#let propósito = "PARA OBTENER EL GRADO ACADÉMICO DE MAESTRO EN CIENCIAS CON MENCIÓN EN: INTELIGENCIA ARTIFICIAL"
#let autores = ("YAN FRANCO CALDERON FELIX", "HILBERT ALEXANDER CIEZA DELGADO")
#let asesores = ("SAMUEL OPORTO DIAZ",)
#let lugar = "Lima, Perú"
#let anio = "2026"
#let duracion = "Duración estimada: 12 meses (marzo 2026 - febrero 2027)"
#let lugar-institucion = "Escuela de Posgrado, Universidad Nacional de Ingeniería, Lima, Perú"

// -----------------------------------------------------------------------------
// CONFIGURACIÓN DEL DOCUMENTO
// -----------------------------------------------------------------------------
#set document(title: titulo-plan, author: autores.at(0))
#set math.equation(numbering: "(1)")
#set page(
  paper: "a4",
  margin: (left: 3.0cm, top: 3.0cm, right: 2.5cm, bottom: 2.5cm),
  numbering: none,
)

// Fuente Arial 11 según formato; se usa Liberation Sans como respaldo
// si Arial no está instalada en el sistema de compilación.
#set text(
  font: ("Arial", "Liberation Sans", "Helvetica"),
  size: 11pt,
  lang: "es",
)

// Espaciado 1.5 líneas (space and a half) y justificado, según formato 3.3
#set par(justify: true, leading: 1em, first-line-indent: 0em)

// -----------------------------------------------------------------------------
// ESTILOS DE ENCABEZADOS
// Los números de capítulo (romanos) y de sección (arábigos) se escriben de
// forma literal en el texto del heading, tal como exige el formato oficial.
// -----------------------------------------------------------------------------
#set heading(numbering: none)

#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  v(0.5em)
  align(center)[
    #text(weight: "bold", size: 13pt, tracking: 0.5pt)[#upper(it.body)]
  ]
  v(1em)
}

#show heading.where(level: 2): it => {
  v(1.1em)
  text(weight: "bold", size: 11pt)[#it.body]
  v(0.5em)
}

#show heading.where(level: 3): it => {
  v(0.8em)
  text(weight: "bold", size: 11pt)[#it.body]
  v(0.4em)
}

#show heading.where(level: 4): it => {
  v(0.6em)
  text(weight: "bold", size: 11pt)[#it.body]
  v(0.3em)
}

// -----------------------------------------------------------------------------
// FUNCIÓN: CARÁTULA
// Réplica del ejemplo oficial de carátula para tesis de maestría de
// especialización (ver tesis/formato/img/img_ejemplo_caratula_plan_tesis.png)
// -----------------------------------------------------------------------------
#let caratula() = {
  set page(numbering: none)
  set align(center)
  set par(justify: false)

  v(0.5cm)
  text(size: 16pt, weight: "bold")[#institucion]
  v(0.3cm)
  text(size: 13pt, weight: "bold")[#unidad]

  v(0.2cm)
  image("./assets/figures/logo-uni.png", width: 4.6cm)
  v(0.2cm)

  text(size: 13pt, weight: "bold")[PLAN DE TESIS]
  v(0.4cm)
  text(size: 13pt, weight: "bold")[“#upper(titulo-plan)”]

  v(0.5cm)
  text(size: 11pt)[#propósito]

  v(0.5cm)
  text(size: 11pt, weight: "bold")[ELABORADA POR:]
  v(0.2cm)
  for a in autores {
    text(size: 11pt, weight: "bold")[#upper(a)]
    v(0.15cm)
  }

  v(0.6cm)
  text(size: 11pt, weight: "bold")[ASESOR:]
  v(0.2cm)
  for a in asesores {
    text(size: 11pt)[#a]
    v(0.15cm)
  }

  v(1.0cm)
  text(size: 13pt, weight: "bold")[#upper(lugar)]
  v(0.2cm)
  text(size: 11pt, weight: "bold")[#anio]

  pagebreak(weak: true)
}

// -----------------------------------------------------------------------------
// FUNCIÓN: DATOS GENERALES
// -----------------------------------------------------------------------------
#let datos-generales() = {
  heading(level: 1)[Datos Generales]

  set par(justify: true)

  enum(
    [*Título del Plan de Tesis.* #titulo-plan],
    [*Nombre (s) de autor (es).* #autores.join(", ")],
    [*Nombre del asesor o asesores.* #asesores.join(", ")],
    [*Área involucrada.* #area],
    [*Lugar o institución donde se desarrolla el proyecto.* #lugar-institucion],
    [*Duración estimada del proyecto.* #duracion],
  )

  pagebreak(weak: true)
}

// =============================================================================
// DOCUMENTO
// =============================================================================

#caratula()

// --- Cuerpo preliminar: paginación en números romanos (formato 3.5) --------
#set page(numbering: "i", number-align: top + right)

//#datos-generales()

#outline(title: "ÍNDICE", indent: auto)

#pagebreak(weak: true)

#set page(numbering: "i", number-align: top + right)

#outline(title: "ÍNDICE DE TABLAS", target: figure.where(kind: table))

#pagebreak(weak: true)

#outline(title: "ÍNDICE DE FIGURAS", target: figure.where(kind: image))

#pagebreak(weak: true)

// --- Cuerpo del plan de tesis: paginación en números arábigos --------------
#counter(page).update(1)
#set page(numbering: "1", number-align: top + right)

= Capítulo I. Planteamiento del Problema

== 1.1 Diagnóstico

En el contexto socioeconómico del Perú, la inversión pública constituye un motor fundamental del desarrollo y del progreso del país. A través de ella, el Estado peruano busca mejorar la calidad de vida de la ciudadanía mediante el impulso de la infraestructura, los servicios básicos y la productividad nacional. Un proyecto de inversión corresponde a una intervención temporal financiada total o parcialmente con recursos públicos, destinada a la formación de capital físico, humano, institucional, intelectual o natural, con el propósito de crear, ampliar, mejorar o recuperar la capacidad de producción de bienes o servicios. Dentro de dicho marco, una obra pública se define como la inversión con componente de infraestructura que comprende la construcción, reconstrucción, remodelación, demolición, renovación, mantenimiento, habilitación y rehabilitación de bienes inmuebles —edificaciones, estructuras, excavaciones, perforaciones, carreteras, puentes, entre otros—, cuya ejecución, operación o mantenimiento requiere la participación del Estado @contraloria_general_de_la_republica_del_peru_informe_2025. La @representacion-obra-publica ilustra esquemáticamente esta noción.

#figure(
  image("assets/figures/img-representacion_obra_publica.png", width: 80%),
  caption: [Representación de una obra pública en el Perú],
) <representacion-obra-publica>

A partir de esta caracterización, resulta pertinente precisar que la paralización de una obra pública en el Perú se entiende como la interrupción indefinida o prolongada de su ejecución física, circunstancia que impide su conclusión y su puesta en funcionamiento. 

La @ejemplo-opa ilustra el reporte de estado de una obra pública en el sistema de seguimiento de las inversiones, evidenciando la paralización de obra.


#figure(
  image("assets/figures/img_ejemplo_opa.png", width: 100%),
  caption: [Reporte de estado en el sistema de seguimiento de las inversiones @mef_portal_seguimiento_2025],
) <ejemplo-opa>

=== 1.1.1 Cuantificación del fenómeno

De acuerdo con el "Informe de Obras Paralizadas en el Territorio Nacional a diciembre de 2024", emitido por la Contraloría General de la República, se registraron 2,476 obras paralizadas en todo el territorio nacional, con un costo actualizado de S/ 43,118.9 millones; de este universo, el 72 % corresponde a obras ejecutadas por gobiernos locales, lo que evidencia que la descentralización de la inversión pública no ha estado acompañada de capacidades técnicas suficientes para su ejecución eficiente.

#figure(
  table(
    columns: 3,
    align: (left, right, right),
    table.header([*Nivel de gobierno*], [*N.° obras paralizadas*], [*% N.° obras*]),
    [G. Local], [1,782], [72.0 %],
    [G. Nacional], [384], [15.5 %],
    [G. Regional], [310], [12.5 %],
    [*TOTAL*], [*2,476*], [*100 %*],
  ),
  caption: [Obras públicas paralizadas según nivel de gobierno, diciembre de 2024],
) <tabla-nivel-gobierno>

Complementariamente, la desagregación por sector (@tabla-sector), muestra el top 5 de sectores con mayor costo actualizado comprometido en obras paralizadas permitiendo dimensionar la heterogeneidad institucional y sectorial del fenómeno.



#figure(
  table(
    columns: 5,
    align: (left, right, right, right, right),
    table.header([*Sector*], [*Costo actualizado (millones S/)*], [*% costo*], [*N.° obras paralizadas*], [*% N.° obras*]),
    [Transportes y comunicaciones], [11,597.9], [26.9 %], [715], [28.9 %],
    [Vivienda, construcción y saneamiento], [7,861.2], [18.2 %], [518], [20.9 %],
    [Educación], [2,274.2], [5.3 %], [364], [14.7 %],
    [Agricultura], [7,699.5], [17.9 %], [322], [13.0 %],
    [Salud], [5,017.7], [11.6 %], [83], [3.4 %],
    [Otros sectores], [8,668.4], [20.1 %], [474], [19.1 %],
    [*TOTAL*], [*43,118.9*], [*100 %*], [*2,476*], [*100 %*],
  ),
  caption: [Obras públicas paralizadas según sector, diciembre de 2024],
) <tabla-sector>

Frente a esta magnitud del problema, cabe señalar que la respuesta institucional del Estado suele ser reactiva: las auditorías, los informes de control y las intervenciones correctivas se ejecutan una vez que el contrato ya ha sido resuelto o los plazos ya han vencido, momento en el cual el margen de maniobra preventivo se ha perdido. Esta dinámica no solo limita la capacidad anticipatoria de la gestión pública, sino que además perpetúa un modelo en el que la información disponible no se transforma en conocimiento útil ni en alertas tempranas para la toma de decisiones. En consecuencia, se configura un vacío de alto impacto: se dispone de información estructurada y relevante como historial de contratistas, ubicación de obras, tiempo de ejecución, modificaciones contractuales, acciones de control; pero dicha información no se transforma ni se utiliza sistemáticamente como variables de predicción. Esta carencia impide anticipar el riesgo de paralización y limita la toma de decisiones basada en datos por parte de los gestores de las entidades públicas, situación que fundamenta la pertinencia de la presente investigación.

== 1.2 Identificación y Descripción del Problema de Estudio

=== 1.2.1 Ciclo del fenómeno

Las obras públicas transitan por diferentes estados durante su ciclo de vida @diagrama-estados-obra. El estado de paralización se configura cuando la ejecución física se interrumpe por un periodo prolongado y la obra no se concluye, de acuerdo con los criterios establecidos por los informes de seguimiento de la Contraloría General de la República. En este ciclo intervienen factores técnicos, financieros, contractuales, institucionales y externos que pueden incidir en la continuidad o interrupción de la ejecución. En este contexto el estado objetivo de análisis (Estado 5 en la @diagrama-estados-obra) se alcanza si se dan las siguientes condiciones @contraloria_general_de_la_republica_del_peru_informe_2025
:

- La obra puede ejecutarse bajo modalidades como contrata, administración directa, convenios de Estado a Estado, Asociaciones Público-Privadas con componente de infraestructura, Obras por Impuestos, núcleos ejecutores u otras modalidades previstas por la normativa aplicable.
- La obra debe encontrarse en ejecución física conforme a las condiciones establecidas para su inicio y desarrollo según el marco normativo de la modalidad correspondiente.
- La obra no se ha concluido y no presenta avance en su ejecución física en un periodo mínimo de seis (06) meses; o, provenga de un contrato resuelto o declarado nulo, por causas atribuibles a situaciones de controversia, abandono, deficiencias del expediente técnico, factores climáticos, situaciones imprevisibles posteriores al perfeccionamiento del contrato u otras causas que puedan ocasionar la suspensión prolongada del plazo de ejecución física de la obra.

#figure(
  image("assets/figures/img_diagrama_estados_obra.png", width: 65%),
  caption: [Diagrama de transición de estados en la ejecución de una obra publica],
) <diagrama-estados-obra>

=== 1.2.2 Tipificación del fenómeno

Con el propósito de delimitar el objeto de estudio, resulta pertinente formalizar la tipificación del fenómeno, para ello, se tomará como base las causales de paralización de obra registradas en el sistema de Infobras, que posteriormente son reportadas por la Contraloría General de la República, la @tabla-causas-nacional desagrega las causales registradas según su incidencia económica y cuantitativa, permitiendo identificar las causales de mayor impacto y relevancia para la investigación.

#figure(
  table(
    columns: (5.4cm, 3.3cm, 1.9cm, 2.5cm, 2.5cm),
    align: (left, right, right, right, right),
    table.header(
      [*Causal de paralización*], [*Costo actualizado (millones S/)*], [*% costo*], [*N.° obras paralizadas*], [*% N.° obras*],
    ),
    [*Incumplimiento de contrato*], [*15,913.4*], [*36.9 %*], [*628*], [*25.4 %*],
    [Falta de recursos financieros y liquidez], [2,140.4], [5.0 %], [526], [21.2 %],
    [Deficiencia en el expediente técnico], [3,217.8], [7.5 %], [271], [10.9 %],
    [Abandono de obra], [699.5], [1.6 %], [247], [10.0 %],
    [Discrepancias, controversias y arbitraje], [14,889.4], [34.5 %], [225], [9.1 %],
    [Incumplimiento del pago de valorizaciones u otros], [951.8], [2.2 %], [71], [2.9 %],
    [Eventos climáticos], [987.0], [2.3 %], [70], [2.8 %],
    [Conflictos sociales], [1,078.1], [2.5 %], [71], [2.9 %],
    [Disponibilidad de terreno], [560.8], [1.3 %], [56], [2.3 %],
    [Falta de permisos, licencias y autorizaciones], [120.2], [0.3 %], [46], [1.9 %],
    [Interferencias], [289.3], [0.7 %], [27], [1.1 %],
    [Desabastecimiento sostenido de materiales], [402.5], [0.9 %], [25], [1.0 %],
    [Otros], [1,592.1], [3.7 %], [214], [8.6 %],
    [*TOTAL*], [*43,118.9*], [*100 %*], [*2,476*], [*100 %*],
  ),
  caption: [Principales causas de paralización de obras públicas a nivel nacional, diciembre de 2024],
) <tabla-causas-nacional>

Como puede apreciarse en la @tabla-causas-nacional, el incumplimiento de contrato (por parte del contratista) destaca simultáneamente como la causal de mayor incidencia en número de obras (25.4 %) y como una de las de mayor impacto económico, al concentrar S/ 15,913.4 millones, equivalentes al 36.9 % del costo total paralizado @contraloria_general_de_la_republica_del_peru_informe_2025. Por otro lado, el incumplimiento contractual tambien puede manifestarse mediante situaciones asociadas a controversias, abandono de obra, resolución de contrato, incumplimiento de obligaciones, penalidades, problemas de supervisión, modificaciones contractuales o falta de pago de valorizaciones por parte de la entidad contratante, por lo que en base a la lista de causales proporcionado por la CGR se definió la categoría "CONTRACTUAL" que agrupa las causales relacionadas al motivo de paralización de obra por incumplimiento contractual, las cuales son imputables tanto al contratista como a la entidad contratante. La @tabla-causales-contractuales detalla la lista de causales seleccionadas que formarán parte de la variable objetivo del estudio.

#figure(
  table(
    columns: (1fr, auto),
    align: (left + horizon, left + horizon),
    table.header([*Causal de paralización*], [*Categoría*]),
    [Incumplimiento de contrato], [CONTRACTUAL],
    [Proceso arbitral], [CONTRACTUAL],
    [Resolución de contrato], [CONTRACTUAL],
    [Discrepancias, controversias y arbitraje], [CONTRACTUAL],
    [Resolución del contrato de supervisión de obra], [CONTRACTUAL],
    [Obra judicializada por la entidad], [CONTRACTUAL],
    [Incumplimiento del pago de valorizaciones u otros], [CONTRACTUAL / FINANCIERA],
  ),
  caption: [Causales de paralización consideradas para la clase positiva],
) <tabla-causales-contractuales>

Para un mejor entendimiento de la complejidad del fenómeno, la @diagrama-grafo-causal-paralizacion sintetiza mediante un grafo jerárquico dirigido la interrelación entre los factores técnicos, contractuales, financieros y externos que subyacen a la paralización de obras, evidenciando que el incumplimiento contractual no constituye una causa aislada sino un nodo articulado con otras dimensiones del riesgo. Esta representación visual permite evaluar los posibles puntos de intervención, siendo una herramienta útil para orientar los análisis posteriores.

#figure(
  image("assets/figures/img_grafo_causal_paralizacion.png", width: 90%),
  caption: [Grafo jerárquico dirigido de factores de paralización de obra],
) <diagrama-grafo-causal-paralizacion>

=== 1.2.3 Caracterización del fenómeno

Los sistemas administrativos como infobras de la CGR, el Banco de Inversiones del MEF y los registros de contratación pública contienen información operativa, contractual y de gestión relevantes de datos maestros, transaccionales, de referencia, metadatos e históricos que pueden emplearse para la identificación de patrones que permita realizar una estimación cuantitativa del riesgo de paralización durante la ejecución de obras.

La @diagrama-caracterizacion-obra-publica muestra una representación esquemática de las principales entidades de datos y características relacionadas a nuestro objeto de estudio.

#figure(
  image("assets/figures/img_caracterizacion_obra_publica.png", width: 90%),
  caption: [Caracterización de una obra pública a través de sus diferentes atributos],
) <diagrama-caracterizacion-obra-publica>

Realizando un análisis inicial al dataset de obras publicas, tomando los registros validos con un estado de ejecución en `finalizado`, `en ejecución` o `paralizadas`, se presenta un diagrama de frecuencia de las paralizaciones por incumplimiento contractual respecto al total de obras no paralizadas (@diagrama-distribucion-clases-general), evidenciando que la proporción de obras paralizadas por incumplimiento contractual es baja en comparación con el total de obras ejecutadas, lo que genera un desbalance de clases para el entrenamiento de modelos.

#figure(
  image("assets/figures/img_distribucion_clases_general.png", width: 90%),
  caption: [Frecuencia de paralizaciones por incumplimineto contractual respecto al total de obras no paralizadas, con corte de la información a enero del 2025 @contraloria_general_de_la_republica_del_peru_informe_2025)],
) <diagrama-distribucion-clases-general>

=== #highlight(fill: green)[1.2.2 Representación del Problema]

Uno de los mayores desafios para lograr una gestión efectiva de la inversión pública es completar las obras desde su inicio hasta su finalización, dentro de los costos previstos y sin interrupciones. Sin embago, en Perú, al igual que en muchas otras economías, es común encontrar un número significativo de inversiones paralizadas @calle_desempeno_2024, esta situción genera sobre costos en los proyectos de inversión, afecta el cumplimiento de metas de cierre de brechas de infraestructura, genera pérdida de recursos públicos e impide el acceso oportuno de la población a servicios básicos, trayendo como consecuencia el deterioro de la calidad de vida y del desarrollo del país.

La falta de una estimación cuantitativa del riesgo de paralización de obras públicas en el Perú limita la capacidad de los interesados del negocio para identificar proyectos con alto riesgo de paralización, y manejar una lista ordenada por valor de riesgo que pueda servir como herramienta de apoyo para priorizar recursos y ejecutar acciones preventivas. Por lo tanto, el objetivo principal de este estudio es implementar y comparar diferentes modelos de inteligencia artificial que permitan estimar el riesgo, proporciando un entendimiento de los patrones en los datos y los principales factores de riesgo para la toma de decisiones.

La cuantificación del riesgo de paralización de una obra por motivo de incumplimento contractual puede estimarse a partir de un conjunto de factores (cuantitativos o cualitativos) relacionados con el ciclo de vida de la obra. Bajo un enfoque de aprendizaje de máquina, dicho fenómeno dicotómico se representa mediante una variable dependiente $Y$ que toma valores binarios ($Y = 1$ si la obra se paraliza por incumplimiento contractual, $Y = 0$ en caso contrario) cuya estimación de la propensión hacia la clase positiva se expresa como una medida de probabilidad $P(Y = 1 | X = x)$ la cual representa la cuantificación del riesgo de paralización y que bajo cierto umbral de decisión $c$ se clasifica a la obra en una de las dos clases mediante $hat(Y) = I(hat(p) >= c)$; esta formalización se desarrolla con mayor detalle en el Marco Teórico. Adicionalmente, como se evidencia en @diagrama-distribucion-clases-general existe un desbalance de clases marcado, lo cual implica que la solución a implementar debe ser evaluada cuidadosamente, priorizando métricas que reflejen la capacidad del modelo para identificar correctamente las obras en riesgo.

== 1.2.1 Antecedentes Bibliográficos

La revisión de la literatura especializada muestra estudios sobre aplicación de técnicas de aprendizaje automático a la predicción de retrasos y paralizaciones en proyectos de construcción, aunque con distintos niveles de madurez técnica y metodológica. En un primer estudio, se identificaron 59 factores de riesgo mediante revisión bibliográfica y consulta a expertos, y se compilo un conjunto de datos de 51 proyectos de construcción en Egipto, sobre el cual se compararon los algoritmos de Árbol de Decisión y Naive Bayes mediante validación cruzada de diez pliegues; este último superó al primero, resultado atribuido al tamaño reducido de la muestra y a la independencia condicional de las variables @gondia_machine_2020. En una línea similar, pero con algoritmos más recientes de _gradient boosting_, una investigación aplicada al contexto de Arabia Saudita evaluó CatBoost, XGBoost y LightGBM sobre 62 proyectos con retraso, empleando validación cruzada de diez pliegues y optimización de hiperparámetros; los resultados mostraron que LightGBM superó consistentemente a los otros dos algoritmos, alcanzando la mayor precisión de prueba y la menor tasa de clasificación errónea @alsulamy_predicting_2025. De manera complementaria, otro estudio aplicado evaluó distintos algoritmos de aprendizaje automático sobre datos reales del sector infraestructura, encontrando que los modelos basados en árboles —Random Forest y XGBoost— resultaban más adecuados en escenarios donde la interpretabilidad y la capacidad de acción son necesarias para los tomadores de decisiones @nnaemeka_egwim_applied_2021.

#highlight[Esta preocupación por la interpretabilidad resulta particularmente relevante para la adopción institucional de modelos predictivos en el sector público, razón por la cual la presente investigación contempla la incorporación de técnicas de inteligencia artificial explicable, como los valores SHAP, que permiten cuantificar la contribución individual de cada característica a las predicciones del modelo @lundberg_unified_2017.]

Finalmente, en el ámbito peruano, un antecedente fundamental lo constituye el trabajo de @solis-villanueva_tecnicas_2018, quien formuló una arquitectura automatizada para optimizar los procedimientos de selección de obras públicas bajo la Ley de Contrataciones del Estado (Ley N.° 30225), orientada a resolver escenarios de empate mediante un sistema híbrido: sorteo criptográfico auditable (SHA-256) en adjudicaciones simplificadas y predicción del comportamiento del contratista en licitaciones públicas. Para este último procedimiento, el autor propuso un modelo basado en redes neuronales artificiales de tipo perceptrón multicapa (_feed-forward backpropagation_) entrenadas mediante el algoritmo de Levenberg-Marquardt sobre una muestra histórica de 209 proyectos de infraestructura ejecutados por un grupo empresarial peruano. Dicho modelo evaluó diez indicadores de riesgo operativo y contractual —entre los que destacan la relación entre el presupuesto ofertado y el valor referencial, los gastos generales, la experiencia del personal clave residente y de gerencia, el plazo contractual y el factor de reajuste polinómico de precios ($K$)— con el fin de estimar un índice de cumplimiento continuo y clasificar la probabilidad de éxito o fracaso del postor ($Y in {0, 1}$) previo al otorgamiento de la buena pro.

=== 1.2.2 Formulación del Problema

==== 1.2.2.1 Formulación del Problema General

¿En qué medida es posible estimar cuantitativamente el riesgo de paralización de obras públicas en el Perú por incumplimiento contractual, mediante la implementación, evaluación y comparación de modelos de inteligencia artificial sobre registros administrativos de fuentes públicas oficiales, bajo condiciones de desbalance de clases y con interpretabilidad para la toma de decisiones preventivas en la gestión de inversiones?.

==== 1.2.2.2 Formulación de los Problemas Específicos

+ Existe una insuficiente identificación sistemática y actualizada de los factores de riesgo asociados a la paralización de obras por incumplimiento contractual que integre de manera coherente la literatura especializada, la normativa vigente y los registros administrativos de fuentes públicas oficiales, lo cual debilita el sustento conceptual y operativo del estudio.
+ Se evidencia dispersión y heterogeneidad en los datos disponibles, así como la ausencia de procesos estandarizados de obtención, limpieza, estandarización, control de calidad e ingeniería de características, lo que impide conformar un conjunto de datos analítico y reproducible, adecuado para el aprendizaje automático.
+ Persiste la indeterminación del modelo de aprendizaje automático más adecuado y de sus configuraciones óptimas, debido a la falta de un marco comparativo de ajuste, entrenamiento y evaluación con métricas homogéneas, lo que dificulta una selección informada y la documentación de hiperparámetros y condiciones de uso.
+ Existe una limitada interpretabilidad de las salidas del modelo, en razón de la ausencia de técnicas de inteligencia artificial explicable que generen interpretaciones a nivel agregado y por obra, identifiquen los factores determinantes del riesgo y establezcan criterios de interpretación claros para la toma de decisiones.

=== 1.2.3 Justificación y Alcances

==== 1.2.3.1 Justificación

La justificación del presente estudio se sostiene en tres planos complementarios. En el plano práctico, la magnitud económica y social del fenómeno —evidenciada en las @tabla-causas-nacional, @tabla-nivel-gobierno y @tabla-sector— demuestra que el incumplimiento contractual no constituye un problema marginal, sino la causal de mayor impacto económico entre todas las reportadas, lo que confiere relevancia inmediata a cualquier esfuerzo orientado a anticiparlo. En el plano teórico, la investigación contribuye a cerrar una brecha de conocimiento evidenciada en la literatura revisada, en la medida en que integra, bajo un marco comparativo homogéneo, familias de modelos estadísticos y algorítmicos que en estudios previos han sido abordadas de manera aislada. Finalmente, en el plano metodológico, la incorporación de técnicas de inteligencia artificial explicable responde a una limitación reiterada en los antecedentes revisados, en los que el desempeño predictivo no siempre viene acompañado de una interpretación sustantiva accesible a los tomadores de decisión @santini_data_2024. En conjunto, estos tres planos justifican una investigación que no se limite a maximizar una métrica de clasificación, sino que produzca un instrumento cuantitativo de apoyo a la gestión del riesgo, susceptible de ser adoptado por las entidades del Estado peruano.

==== 1.2.3.2 Alcances

El presente plan de tesis delimita su alcance a partir de los siguientes criterios funcionales, aplicados sobre los registros administrativos disponibles:

+ Se excluyen del universo inicial las obras que no hayan iniciado su ejecución física, es decir, no se consideran obras con estado "sin ejecución".
+ Se incluyen únicamente obras públicas que cuenten con una fecha de inicio de obra registrada.
+ Dado que el alcance del trabajo se enmarca en el dominio de la inversión pública bajo el Sistema Nacional de Programación Multianual y Gestión de Inversiones (Invierte.pe), solo se consideran obras asociadas a un código de inversión existente en el Banco de Inversiones del Ministerio de Economía y Finanzas.
+ Se circunscribe el estudio al universo de obras públicas cuya modalidad de ejecución es "por contrata".
+ Respecto de la causal de paralización, se adopta la categorización presentada en la @tabla-causales-contractuales, restringiendo la clase positiva a los incumplimientos contractuales atribuibles a la entidad o al contratista.
+ El análisis prioriza obras ejecutadas por el Gobierno Nacional, en la medida en que dicho nivel de gobierno concentra registros más completos y homogéneos en los sistemas de seguimiento oficiales, sin perjuicio de que la extensión del modelo a los niveles regional y local se identifique como línea de trabajo futuro.

En términos temporales, el estudio se circunscribe al periodo para el cual se dispone de registros administrativos consistentes en el Banco de Inversiones, INFObras y las fuentes complementarias descritas en el Capítulo IV, mientras que, en términos temáticos, el alcance se limita a la estimación del riesgo de paralización por incumplimiento contractual, sin abordar de manera exhaustiva otras causales —climáticas, sociales o de disponibilidad de terreno— que, si bien relevantes, exceden el objeto específico de esta investigación.

= Capítulo II. Objetivos

#highlight(fill:green)[== 2.1 Objetivo General]

Implementar, evaluar y comparar modelos de inteligencia artificial para la estimación cuantitativa y anticipada del riesgo de paralización de obras públicas en el Perú por causal de incumplimiento contractual, utilizando registros administrativos de fuentes públicas oficiales bajo un enfoque de clasificación supervisada desbalanceada, con la finalidad de obtener una herramienta predictiva, calibrada e interpretable que permita jerarquizar proyectos por nivel de riesgo y sustentar la toma de decisiones preventivas en la ejecución de inversiones.

== 2.2 Objetivos Específicos

+ Identificar factores de riesgo candidatos asociados a la paralización de obras por incumplimiento contractual a partir de la literatura especializada, la normativa vigente y los registros administrativos de fuentes públicas oficiales.
+ Implementar la recopilación, integración y preparación de los datos, incluyendo la limpieza, la estandarización y el control de calidad correspondientes.
+ Realizar un análisis exploratorio de datos y la ingeniería de características necesaria para la obtención del conjunto de datos de entrenamiento y de prueba.
+ Comparar modelos de aprendizaje automático mediante su ajuste, entrenamiento y evaluación bajo métricas pertinentes, con el propósito de seleccionar el candidato de mejor desempeño y documentar sus hiperparámetros y condiciones de uso.
+ Aplicar técnicas de inteligencia artificial explicable para generar interpretaciones del modelo a nivel agregado y por obra, identificando los factores determinantes del riesgo y estableciendo criterios de interpretación orientados a la toma de decisiones.

= Capítulo III. Marco Teórico

== 3.1 Bases Teóricas

La ejecución contractual constituye una fase crítica dentro del ciclo de vida de las inversiones públicas. De acuerdo con la Ley N.° 32069, Ley General de Contrataciones Públicas, la ejecución contractual comprende el conjunto de actos y obligaciones que deben cumplir tanto la entidad contratante como el contratista, desde la suscripción del contrato hasta su culminación, liquidación y cierre @mef_ley_32069_2024. El incumplimiento de dichas obligaciones puede derivar en la aplicación de penalidades, en la resolución del contrato y, en escenarios críticos, en la paralización de la obra; desde un enfoque de gestión pública, la paralización representa así una falla sistémica en la articulación entre planificación, contratación y ejecución.

Desde un enfoque de la inteligencia artifical podemos realizar tareas de predicción como la clasificación de las obras publicas según su riesgo de paralización o realizar estimaciones de riesgo @kruppa2012RiskEstimationRisk. La estimación de probabilidades es clave en el área de la predicción de riesgos @steyerberg2014RiskPredictionMachine. En el caso de la clasificación esperamos una respuesta dicotómica (sí o no). En la estimación de riesgos, en cambio esperamos una estimación de la probabilidad que nos permita cuantificar el riesgo. 
La estimación de probabilidades proporciona información más detallada que una simple respuesta dicotómica @kruppa2012RiskEstimationRisk.
La clasificación se aborda principalmente mediante enfoques no paramétricos, mientras que la estimación de probabilidades es tradicionalmente abordada por modelos paramétricos, como el modelo de regresión logística @kruppa2012RiskEstimationRisk siendo este modelo el enfoque estandar. 

==== Planteamiento del problema:
Dado un conjunto de datos $D = {(bold(x_i), y_i)}_(i=1)^N$, donde $bold(x_i) in RR^p$ representa el vector de $p$ características de la $i$-ésima obra pública, $y_i in {0,1}$ indica si la obra se paralizó por incumplimiento contractual, y $N$ es el número de observaciones. El objetivo consiste en estimar una función $f: RR^p arrow.r [0,1]$ tal que: $ hat(p)_i = f(bold(x_i)) = P(y_i = 1 | bold(x_i)) $<ec-prob-condicional> La estimación de probabilidad $hat(p)_i$ es más específicamente la estimación de la probabilidad condicional $P(y_i = 1 | x_i)$ de una observación $y_i = 1$ dado el conjunto de variables independientes $bold(x_i)$ @kruppa2014ProbabilityEstimationMachine. Cantidad que se interpreta como una medida cuantitativa de la probabilidad de paralización de una obra.

=== 3.1.1 Modelos estadísticos basados en la Inferencia

Este tipo de modelos de aprendizaje supervisado parten del supuesto de un modelo de datos estocástico téorico, luego los valores de los parámetros del modelo se estiman a partir de los datos, finalmente el modelo se utiliza para comprender las relaciones entre varaibles, la inferencia o realizar predicciones @breiman2001StatisticalModelingTwo.

==== Regresión logística

Gran parte de la investigación reciente en aprendizaje automático se ha centrado en métodos no lineales. Sin embargo, los métodos lineales suelen tener ventajas sobre sus competidores no lineales en términos de interpretabilidad y, a veces, también en precisión @james2023IntroductionStatisticalLearning. Los modelos de regresión logística pueden presentarse de forma transparente, con información explicable sobre los efectos relativos de los predictores, esto mediante odds ratios y en nomogramas, tablas de puntuación y otras representaciones @steyerberg2014RiskPredictionMachine, tales presentaciones no son posibles para las técnicas de aprendizaje automático, aunque se han realizado esfuerzos en este sentido @steyerberg2014RiskPredictionMachine.

Dado un problema de clasificación binaria, la regresión logística modela directamente la probabilidad condicional de pertenencia a un clase mediante funciones lineales en $bold(x)$ al mismo tiempo que garantiza que sumen $1$ y pertenezcan al intervalo $[0,1]$ @james2023IntroductionStatisticalLearning. El modelo tiene la forma:

$ bb(P)(y = 1 | bold(x)) = g(bold(x' beta)), quad "con " g(s) = 1 / (1 + e^(-s)), $ <reg-logistica>

Donde $bold(x)=(1, X_1, X_2, ..., X_p)'$ es el vector de características, $bold(beta)=(beta_0, beta_1, beta_2, ..., beta_p)'$ es el vector de parámetros del modelo y $g(s)$ es la función logística.
La estimación de los parámetros se realiza mediante el método de máxima verosimilitud, buscando los valores de beta que maximicen la probabilidad de observar los datos dados los parámetros del modelo.
Para interpretar los coeficientes estimados se define la cantidad odds como: $  quad "odds" = hat(p)_i/(1-hat(p)_i) $ El odds mide cúantas veces es más probable que ocurra el evento de interés $(y=1)$ que no ocurra $(y=0)$. La razón de probabilidades (odds ratio) se define como la razón entre los odds de dos observaciones diferentes, y se interpreta como el cambio relativo en la probabilidad de ocurrencia del evento de interés asociado a un cambio unitario en una variable independiente, manteniendo constantes las demás variables. 

Para obtener estimaciones consistentes, la regresión logística requiere un modelo especificado de forma completa y correcta. Si el modelo está mal especificado, las estimaciones de probabilidad pueden estar sesgadas. Algunos ejemplos incluyen ignorar las influencias no lineales de las variables independientes, sobre el resultado, o ignorar las interacciones entre variables independientes. Estos son inconvenientes inherentes al uso de modelos de regresión paramétrica @kruppa2014ProbabilityEstimationMachine.

El supuesto de la linealidad en muchos casos no es una buena aproximación @james2023IntroductionStatisticalLearning. Las preferencias para modelar la no linealidad varían, tenemos los splines cúbicos restringidos @steyerberg2014RiskPredictionMachine, la regresión polinómica, las funciones escalonadas, la regresión local y los modelos aditivos generalizados. @james2023IntroductionStatisticalLearning .

==== GAM de Regresión logistica

Los modelos aditivos generalizados (GAM por sus siglas en ingles) proporcionan un marco general para extender un modelo lineal estándar al permitir funciones no lineales de cada una de las variables, manteniendo la aditividad @james2023IntroductionStatisticalLearning. Una forma natural de extender la regresión logística tradicional es utilizando un modelo aditivo generalizado con familia de distribución binomial:

$ log( p(X) / (1 - p(X)) ) = beta_0 + f_1(X_1) + f_2(X_2) + dots + f_p(X_p) $ Donde $f_i$ son funciones de suavizado o splines para cada variable independiente.

La regresión logística seguirá siendo el enfoque de modelado predeterminado para la estimación de probabilidades en la predicción de riesgos @steyerberg2014RiskPredictionMachine por lo que este modelo se considerará como punto de referencia inicial para el presente trabajo. 

=== 3.1.2 Modelos de aprendizaje automático (AA)

Este tipo de modelos de aprendizaje supervisado estan orientados principalmente a la prediccion de observaciones nuevas o futuras. Mientras que la teoría estadística se ha centrado en la estimación de modelos, la inferencia y el ajuste, el aprendizaje automático y la minería de datos se han concentrado en desarrollar algoritmos predictivos 

computacionalmente eficientes y en abordar el equilibrio sesgo varianza para lograr una alta precisión predictiva @shmueli2010ExplainPredict. 
Para evitar los inconvenientes de la estimación de probabilidad basada en modelos paramétricos clásicos, se pueden utilizar enfoques de aprendizaje automático. Los métodos de aprendizaje automático son esencialmente no paramétricos y se utilizan cada vez más para problemas de clasificación @kruppa2014ProbabilityEstimationMachine. La estimación de probabilidad no paramétrica puede reformularse e integrarse en la regresión no paramétrica, de la @ec-prob-condicional para el problema de regresión no parametrica tenemos que $f(x) = bb(E)(y | bold(x))$ por que $bb(P)(y=1|bold(x)) = bb(E)(y | bold(x))$ , donde $bb(E)(y | x)$ es la esperanza condicional de $y$ dado $bold(x)$ lo que significa que la estimación de probabilidad condicional se puede ver como un problema de regresión no paramétrica. Todos los sistemas de aprendizaje que se desempeñan bien en el problema de regresión no paramétrica también se desempeñarán bien en el problema de estimación de probabilidad. Si una función de regresión se puede estimar de manera consistente, esta probabilidad también se puede estimar de manera consistente. @kruppa2014ProbabilityEstimationMachine

==== Métodos basados en árboles 

Los árboles de decisión son simples y buenos en interpretabilidad, son buenos predictores, pero no excelentes. Por otro lado los enfoques basados en árboles como _Bagging_, bosques aleatorios, _boosting_ y árboles de regresión aditivos bayesianos, que implican producir múltiples árboles que luego se combinan para generar una única predicción de consenso,  pueden obtener mejoras significativas en la precisión de la predicción, sin embargo combinar una gran cantidad de árboles puede producir una predicción que es difícil de entender @breiman2001StatisticalModelingTwo @james2023IntroductionStatisticalLearning. Los bosques aleatorios para estimación de probabilidad utilizan árboles de estimación de probabilidad (PET por sus siglas en ingles) para estimar las probabilidades de respuesta a partir de un árbol. El uso de un conjunto de árboles mediante la creación de un bosque conduce a clasificaciones mejoradas para CART (Arboles de clasificación y regresión) y a mejores estimaciones de probabilidad cuando se utilizan PET @kruppa2014ProbabilityEstimationMachine

#figure(
  kind: "algorithm",
  supplement: [Algoritmo],
  pseudocode-list(booktabs: true, 
  line-numbering: "1.",
  stroke: none,
  numbered-title: [Estimación de probabilidad mediante bosques aleatorios.],
  line-number-alignment: top + right)[El punto de partida es un conjunto de datos de entrenamiento con $n$ observaciones, y se construye un total de $"ntree" >= 1$ árboles.
  + Se extrae una muestra _bootstrap_ con reemplazo.
  + Se cultiva un PET utilizando un subconjunto aleatorio de variables con el error cuadrático medio (MSE) como criterio de optimización. Los nodos padres siempre tienen dos nodos hijos. Los PETs no se podan. El tamaño del nodo terminal es fijo o ajustado.
  + Se determina la proporción de $1$ en cada nodo terminal
  + Se hace descender a un sujeto a través de un solo PET, y la estimación de probabilidad específica del PET para dicho sujeto es la proporción de $1$ en el nodo terminal. La estimación de probabilidad del bosque aleatorio (RF) es el promedio de las probabilidades obtenidas de todos los árboles.
],
)<algo-random-forest>

==== K vecinos mas cercanos y vecinos mas cercanos agrupados

El estimador de k vecinos mas cercanos(_k_-NN por sus siglas en ingles) es un estimador de regresión no parametrico y puede combinarse eficazmente con el método bagging para mejorar su rendimiento. Una de las principales ventajas de los procedimientos de vecinos más cercanos es su simplicidad. Para su implementación, solo requieren una medida de distancia en el espacio muestral, junto con muestras de datos de entrenamiento @kruppa2014ProbabilityEstimationMachine:

#figure(
  kind: "algorithm",
  supplement: [Algoritmo],
  pseudocode-list(booktabs: true, 
  line-numbering: "1.",
  stroke: none,
  numbered-title: [Estimación de probabilidad mediante el metodo de vecinos mas cercanos agrupados (_b_-NN)],
  line-number-alignment: top + right)[Considerando un conjunto de datos de entrenamiento con $n$ observaciones, y el número $k$ de vecinos mas cercanos es fijado.
  + Se extrae una muestra _bootstrap_ con reemplazo.
  + La distancia entre pares de muestras se determina utilizando una métrica adecuada.
  + Se determina la proporción de $1$ de los $k$ vecinos más cercanos de un punto de muestra en la muestra bootstrap.
  + La estimación de probabilidad del b-NN es la proporción de $1$ promediada sobre todas las muestras bootstrap.
],
)<algo-bnn>

Se ha demostrado que tanto el algoritmo RF como el b-NN producen estimaciones de probabilidad consistentes @kruppa2014ProbabilityEstimationMachine.

\

Dado que tenemos varias alternativas de maquinas de aprendizaje supervisado para la estimación de probabilidades, la pregunta es qué máquina debería usarse en las aplicaciones. Dado que no existe una mejor, en las aplicaciones se usa un conjunto de máquinas de aprendizaje, y el rendimiento de las máquinas se puede comparar en datos de prueba usando la puntuación de Brier (_Brier score_) @kruppa2014ProbabilityEstimationMachine

Si queremos comparar el rendimiento de modelos parametricos con modelos de aprendizaje automatico, @steyerberg2014RiskPredictionMachine recomienda utilizar enfoques penalizados en lugar de tradicionales para la regresión logística, es decir, el uso de penalización L1 (LASSO) o L2 (ridge), o los enfoques bayesianos. El método LASSO utiliza una penalización L1 para reducir los coeficientes de regresión a cero. Por lo tanto, LASSO combina la selección de variables con la reducción de coeficientes y, al mismo tiempo, proporciona predicciones adecuadas.


=== 3.1.3 Clasificación desbalanceada

Conforme a lo señalado en el diagnóstico, la paralización por incumplimiento contractual afecta a una proporción minoritaria del total de obras públicas (\~7 % del número de obras ejecutadas), se anticipa que la variable objetivo presentará un desbalance de clases considerable. Cualquier conjunto de datos con una distribución desigual de clases se considera técnicamente desequilibrado. Sin embargo, se dice que un conjunto de datos está desequilibrado cuando existe una desproporción significativa, ó en algunos casos extrema, entre el número de ejemplos de cada clase del problema. En los problemas de clasificación binaria, la clase minoritaria (subrepresentada) suele denominarse clase positiva, mientras que la clase mayoritaria se considera la negativa. @fernandez_learning_2018. La mayoría de los algoritmos de aprendizaje automático para modelos predictivos de clasificación están diseñados y demostrados en problemas que asumen una distribución igual de clases @brownlee2020ImbalancedClassificationPython. El desequilibros de clases conduce a costes de error asimetricos: El coste de un prediccion incorrecta en una muestra de la clase positiva podria ser mucho mas alto que una prediccion incorrecta en una muestra de la clase negativa @huyen2022designing, En el contexto de la presente investigación, el costo de no detectar una obra en riesgo (falso negativo) supera al costo de investigar una obra que finalmente no se paraliza (falso positivo).

Existen diversas estrategias para abordar el desbalance de clases, que se pueden clasificar en tres métodos principales @huyen2022designing: 

+ Uso de metricas de evaluación apropiadas
+ Métodos a nivel de datos: remuestreo, sobremuestreo, submuestreo.
+ Métodos a nivel de algoritmo

=== 3.1.4 Particionamiento del conjunto de datos

La evaluación de modelos implica usar el conjunto de datos disponible para ajustar un modelo y estimar su rendimiento al hacer predicciones sobre ejemplos no vistos. Entonces nuestro conjunto de datos global debe ser particionado en 2 sub conjuntos a los cuales denominaremos conjunto de datos de entrenamiento y de pruebas. Los dos enfoques más comunes utilizados para la evaluación de modelos son la división entrenamiento-prueba, y el procedimiento de validación cruzada de $k$ -iteraciones @brownlee2020ImbalancedClassificationPython. La validación cruzada de 10 iteraciones, en particular, es el método de estimación de error más utilizado en el aprendizaje automático, puede fallar fácilmente en el caso de desequilibrios de clases, incluso si el sesgo es menos extremo. En el caso de desequilibrios de clases, se debe usar validación cruzada estratificada de $K$-iteraciones, lo que asegura que la proporción de ejemplos positivos y negativos encontrada en la distribución original se respete en todas las particiones @he2013ImbalancedLearningFoundations.


=== 3.1.5 Metricas de evaluación 

Uno de los principios rectores del aprendizaje automatico es que los buenos modelos deben tener un buen rendimiento con datos no vistos @deisenroth2020MathematicsMachineLearning. Esto requiere que definamos algunas metricas de rendimiento de acuerdo a las caracteristicas de nuestro problema. Para los problemas de clasificación, las métricas implican comparar la etiqueta de clase esperada con la etiqueta de clase predicha o interpretar las probabilidades predichas para las etiquetas de clase del problema. Cuando hay un sesgo en la distribución de clases las métricas estándar se vuelven poco fiables o incluso engañosas cuando las clases están desequilibradas, o severamente desequilibradas @brownlee2020ImbalancedClassificationPython. Es necesario establecer el valor predictivo de la prueba, que indica la capacidad del modelo para diferenciar entre clases y/o la calidad de las estimaciones de probabilidad. Específicamente, la prueba debe demostrar *calibración* y *discriminación* @kruppa2012RiskEstimationRisk. Se puede dividir las metricas para problemas de clasificación en tres grupos @brownlee2020ImbalancedClassificationPython:

/ Métricas de umbral: Son aquellas que cuantifican los errores de predicción de la clasificación, estas métricas se utilizan cuando queremos que un modelo minimice el número de errores. Tenemos las siguiente métricas: _Accurancy_ (Exactitud), _Error_ (Error de clasificación), _Sensitivity-Specificity_ (sensibilidad-especificidad), _Precision-Recall_ (precisión-exhaustividad), _Fbeta-measure_
 (Medida F)

/ Métricas de clasificación: Se centran más en evaluar a los clasificadores según su eficacia para separar clases, estas métricas requieren que un clasificador prediga una puntuación o una probabilidad de pertenencia a una clase. A partir de esta puntuación, se pueden aplicar diferentes umbrales para probar la eficacia de los clasificadores. Tenemos las siguientes métricas: _ROC Curve_, _PR-Curve_, _True positive rate_, _False postive rate_.

/ Métricas de probabilidad: Las métricas probabilísticas están diseñadas específicamente para cuantificar la incertidumbre en las predicciones de un clasificador. Son útiles para problemas en los que estamos más interesados en la incertidumbre que el modelo tiene en las predicciones. Evaluar un modelo basándose en las probabilidades predichas requiere que las probabilidades estén calibradas @brownlee2020ImbalancedClassificationPython. Para una buena calibración, las probabilidades predichas deben coincidir con el riesgo observado real; es decir, el riesgo predicho promedio coincide con la proporción de casos que realmente ocurren para la clase positiva. Idealmente, esto debería cumplirse tanto para la población total del estudio como para todos los subgrupos importantes @kruppa2012RiskEstimationRisk. Tenemos las siguientes métricas: _LogLoss_, _BrierScore_, _BrierSkillScore_.

La @taxonomia-metricas resume la taxonomía de métricas pertinentes para un problema de clasificación desbalanceada como el que ocupa a este estudio.
#figure(
  image("./assets/figures/img_metricas_clasificacion_desbalanceada.png", width: 90%),
  caption: [Taxonomía de métricas para clasificación desbalanceada @brownlee2020ImbalancedClassificationPython],
) <taxonomia-metricas>

En la medida en que el producto de interés no es únicamente una etiqueta de clasificación sino una medida cuantitativa de riesgo, resulta pertinente contrastar la capacidad predictiva de los algoritmos de aprendizaje automático con la calibración y la interpretabilidad que ofrecen los modelos estadísticos clásicos, de modo que la selección final del modelo responda a un criterio explícito y justificado, y no exclusivamente al desempeño en una única métrica.
Dado nuestro problema en particular, donde es de crucial importancia la identificación de las obras con alto riesgo de paralización (clase positiva) en donde el costo de no supervisar una obra que llega a paralizarse (*Falso negativo*) es mayor que supervisar una obra que no se paraliza (*Falso positivo*), se seleccionan métricas de evaluación orientadas a las predicción de probabilidades y que le dan más importancia a la clase positiva @brownlee2020ImbalancedClassificationPython:

/ Precision-Recall: La precisión resume la fracción de ejemplos asignados a la clase positiva que realmente pertenecen a la clase positiva. La exhaustividad resume qué tan bien se predijo la clase positiva y es el mismo cálculo que la sensibilidad. El uso de _Recall_ es adecuada cuando el objetivo es minimizar los falsos negativos.

$ "Precision" = "TruePositive" / ("TruePositive" + "FalsePositive") $

$ "Recall" = "TruePositive" / ("TruePositive" + "FalseNegative") $

/ Fbeta-measure: La medida F proporciona una forma de combinar tanto la precisión como la exhaustividad en una sola medida que captura ambas propiedades. La medida F es una métrica muy usada para la clasificación desequilibrada. La medida $F_beta$ es una abstracción de la medida F donde el equilibrio entre precisión y exhaustividad en el cálculo de la media armónica está controlado por un coeficiente llamado beta. Cuando  los falsos negativos son más importantes los se prefiere utilizar la medida $F$ con $beta = 2$, criterio apropiado cuando el costo de no detectar una obra en riesgo (falso negativo) supera al costo de investigar una obra que finalmente no se paraliza (falso positivo)

$ F_beta = (1+beta^2)("Precision" dot "Recall") / (beta^2 "Precision" + "Recall") $

/ Brier score: Para evaluar las probabilidades predichas, se prefiere utilizar la puntuación de Brier (BS por sus siglas en ingles), que se obtiene promediando las diferencias al cuadrado entre su probabilidad predicha y los valores esperados  @kruppa2012RiskEstimationRisk. Esta metrica se centra en evaluar las probabilidades de la clase positiva. La puntuación de Brier es una puntuación propia, se puede estimar si la probabilidad se estima de forma consistente y su varianza se puede estimar y utilizar para construir intervalos de confianza  @kruppa2012RiskEstimationRisk

$ "BrierScore" = (1/N) dot sum_(i=1)^N (hat(y)_i - y_i)^2 $

El enfoque en la estimación de probabilidades también puede requerir que las probabilidades predichas por algunos modelos no lineales se calibren antes de usarse o evaluarse. Algunos modelos aprenderán probabilidades calibradas como parte del proceso de entrenamiento, por ejemplo, la regresión logística @brownlee2020ImbalancedClassificationPython.

=== 3.2.6 Calibración del modelo

La decisión de convertir una probabilidad o puntuación predicha en una etiqueta de clase se rige por un parámetro denominado umbral de decisión, umbral de discriminación, o simplemente el umbral. Casi todos los clasificadores generan predicciones positivas o negativas aplicando un umbral a una puntuación, la elección de este umbral tendrá un impacto en la determinación de las clases predichas @fernandez_learning_2018. 
Para aquellos problemas de clasificación que presentan un desequilibrio de clases grave, el umbral predeterminado puede dar lugar a un rendimiento deficiente. El problema es que el umbral predeterminado puede no representar una interpretación óptima de las probabilidades predichas. Esto puede ocurrir por varias razones. Por ello, un enfoque simple y directo para mejorar el rendimiento de un clasificador que predice probabilidades en un problema de clasificación desbalanceada consiste en ajustar el umbral utilizado para asignar probabilidades a etiquetas de clase @brownlee2020ImbalancedClassificationPython.

\
Para operacionalizar la función $f$, el plan de tesis contempla la comparación de dos familias de modelos complementarias, cuya pertinencia se sustenta en la revisión de la literatura especializada expuesta en los Antecedentes Bibliográficos. Por un lado, se consideran algoritmos de aprendizaje automático de tipo ensamble de árboles, los cuales han evidenciado en la literatura una capacidad discriminativa superior a la de un modelo lineal base en la predicción de retrasos y paralizaciones @gondia_machine_2020 @alsulamy_predicting_2025 @nnaemeka_egwim_applied_2021. Por otro lado, se incorporan modelos estadísticos clásicos e interpretables como la regresión logística, los Modelos Lineales Generalizados (GLM) y los Modelos Aditivos Generalizados (GAM), cuyos coeficientes admiten una lectura directa en términos de razones de momios (_odds ratio_) o razones de riesgo (_hazard ratio_). La comparación entre ambas familias no se restringe a una única métrica de clasificación, sino que se estructura en cuatro dimensiones: discriminación, calibración, decisión a un umbral operativo (precisión, recall, Fbeta-score) e interpretabilidad. 

== 3.2 Definición de Términos

/ Inversión pública: Aplicación de recursos públicos destinada a la creación, ampliación, mejoramiento o recuperación de la capacidad productora de bienes y servicios, orientada al cierre de brechas de infraestructura o de acceso a servicios públicos (Ministerio de Economía y Finanzas, Invierte.pe).
/ Proyecto de inversión: Intervención temporal que utiliza recursos públicos para crear, ampliar, mejorar o recuperar la capacidad de producción de bienes o servicios públicos, cuyos beneficios se generan durante su vida útil (Ministerio de Economía y Finanzas, Invierte.pe).
/ Obra pública: Toda construcción, reconstrucción, remodelación, demolición o mantenimiento ejecutado con recursos públicos, destinada a la prestación de servicios públicos o al cumplimiento de fines del Estado (Contraloría General de la República).
/ Ejecución contractual: Etapa del proceso de contratación que se inicia con la suscripción del contrato y culmina con su liquidación, en la cual las partes cumplen las obligaciones y prestaciones pactadas @mef_ley_32069_2024.
/ Incumplimiento contractual: Se configura cuando el contratista no ejecuta, total o parcialmente, las obligaciones asumidas en el contrato, conforme a las condiciones, plazos y especificaciones establecidas @mef_reglamento_32069_2024.
/ Resolución de contrato: Acto mediante el cual la entidad o el contratista pone fin al vínculo contractual por la ocurrencia de causales expresamente previstas en la normativa vigente @mef_reglamento_32069_2024.
/ Paralización de obra: Obra pública que ha interrumpido su ejecución física por un periodo determinado, debido a causas técnicas, contractuales, legales, económicas o administrativas (Contraloría General de la República).
/ Expediente técnico: Conjunto de documentos que contienen la descripción técnica, económica y financiera necesaria para la ejecución de una obra pública (Ministerio de Economía y Finanzas, Invierte.pe).
/ Avance físico: Porcentaje de ejecución de una obra respecto del total programado, medido en función de las partidas ejecutadas (Contraloría General de la República - Infobras).
/ Avance financiero: Nivel de ejecución del gasto asociado a una obra pública en relación con el presupuesto asignado (Contraloría General de la República - Infobras).
/ Riesgo: Efecto de la incertidumbre sobre los objetivos (ISO 31000:2018).

= Capítulo IV. Metodología

== 4.1 Tipo de Investigación

La investigación se clasifica como aplicada, en la medida en que se orienta a la solución de un problema concreto de gestión pública —la anticipación del riesgo de paralización de obras— mediante la utilización y adaptación de técnicas existentes de aprendizaje estadístico y automático, antes que a la generación de conocimiento teórico per se. Asimismo, adopta un enfoque cuantitativo, dado que se sustenta en el análisis sistemático de datos numéricos y categóricos extraídos de registros administrativos oficiales.

== 4.2 Nivel de Investigación

El estudio se sitúa en un nivel explicativo-predictivo. Es explicativo en tanto busca identificar y comprender los factores institucionales, geográficos, presupuestales y contractuales asociados a la paralización de obras; y es predictivo en la medida en que dicha comprensión se traduce en un modelo capaz de estimar, de manera anticipada, la probabilidad de paralización de una obra a partir de información disponible al inicio de su ejecución.

== 4.3 Métodos de Trabajo

La propuesta de solución se organiza en siete módulos secuenciales, articulados en una canalización (_pipeline_) reproducible: (i) adquisición de datos desde fuentes oficiales; (ii) carga a una capa de almacenamiento intermedio (_staging_); (iii) preparación y limpieza de los datos; (iv) análisis exploratorio; (v) ingeniería de características; (vi) entrenamiento de modelos; y (vii) comparación y selección del modelo de mejor desempeño. Esta estructura modular garantiza la trazabilidad completa del proceso, desde los datos crudos hasta el modelo final, y facilita tanto la reproducibilidad de los experimentos como el versionamiento de los artefactos generados en cada etapa.

== 4.4 Población y Muestra

La población de estudio está constituida por el universo de obras públicas registradas en los sistemas administrativos oficiales del Estado peruano, en particular el Banco de Inversiones del Ministerio de Economía y Finanzas —que registra aproximadamente 200,000 proyectos de inversión— y el sistema INFObras de la Contraloría General de la República. Sobre dicha población se aplicarán los criterios de delimitación descritos en la sección 1.2.3.2, referidos a la modalidad de ejecución por contrata, la existencia de una fecha de inicio de obra registrada y la vinculación a un código de inversión válido. La muestra definitiva de trabajo se determinará como resultado de la aplicación sucesiva de dichos filtros durante la etapa de adquisición e integración de datos (sección 4.8), por lo que su tamaño exacto constituye un resultado del estudio y no un dato de partida; no obstante, en atención a la magnitud del fenómeno reportada en el Diagnóstico, se anticipa que la variable objetivo mantendrá un desbalance de clases considerable, lo que orienta desde ya la necesidad de las estrategias específicas de tratamiento que se detallan en la sección 4.7.

== 4.5 Tipo de Diseño

Se adopta un diseño factorial experimental, orientado a evaluar de manera sistemática el efecto de distintos factores sobre el desempeño del modelo de clasificación. La @tabla-factores-independientes y la @tabla-factores-dependientes presentan, respectivamente, los factores independientes manipulados y las métricas dependientes observadas.

#figure(
  table(
    columns: 3,
    align: (left + horizon, center + horizon, left + horizon),
    table.header([*Factor*], [*Código*], [*Descripción*]),
    [Algoritmo de clasificación], [A], [Familia de modelo de aprendizaje automático],
    [Preprocesamiento], [P], [Aplicación de escalado a variables numéricas],
    [Optimización de hiperparámetros], [T], [Búsqueda sistemática de hiperparámetros],
    [Optimización de umbral], [U], [Ajuste del umbral de decisión],
  ),
  caption: [Variables independientes del diseño factorial],
) <tabla-factores-independientes>

#figure(
  table(
    columns: 4,
    align: (left + horizon, center + horizon, left + horizon, center + horizon),
    table.header([*Métrica*], [*Código*], [*Descripción*], [*Prioridad*]),
    [Recall], [REC], [Proporción de positivos correctamente detectados], [Alta],
    [PR-AUC], [PRA], [Área bajo la curva Precisión-Recall], [Alta],
    [F2-Score], [F2], [Media armónica ponderada (β = 2)], [Alta],
    [F1-Score], [F1], [Media armónica equilibrada], [Media],
    [Precisión], [PRE], [Proporción de predicciones positivas correctas], [Media],
  ),
  caption: [Variables dependientes (métricas) del diseño factorial],
) <tabla-factores-dependientes>

Cada factor experimental toma un conjunto discreto de niveles, detallados en la @tabla-niveles-factores, cuya combinación conforma la matriz de experimentos presentada en la @tabla-matriz-experimentos. Con el propósito de mantener la viabilidad computacional del estudio, se define un diseño factorial fraccionado que prioriza las combinaciones de mayor interés, en lugar de ejecutar la totalidad de la combinatoria factorial completa.

#figure(
  table(
    columns: 4,
    align: (left, center, center, left),
    table.header([*Factor*], [*Nivel*], [*Código*], [*Descripción*]),
    [A: Algoritmo], [1], [A1], [Logistic Regression (línea base)],
    [A: Algoritmo], [2], [A2], [Random Forest],
    [A: Algoritmo], [3], [A3], [XGBoost],
    [A: Algoritmo], [4], [A4], [LightGBM],
    [A: Algoritmo], [5], [A5], [CatBoost],
    [P: Preprocesamiento], [0], [P0], [Sin escalado],
    [P: Preprocesamiento], [1], [P1], [StandardScaler],
    [T: Tuning], [0], [T0], [Parámetros por defecto],
    [T: Tuning], [1], [T1], [RandomizedSearchCV (50 iter., 5-fold CV)],
    [U: Umbral], [0], [U0], [Umbral fijo (0.50)],
    [U: Umbral], [1], [U1], [Umbral optimizado en validación],
  ),
  caption: [Niveles de los factores del diseño factorial],
) <tabla-niveles-factores>

#figure(
  table(
    columns: 6,
    align: (center, left, center, center, center, left),
    table.header([*Exp.*], [*Algoritmo (A)*], [*Escalado (P)*], [*Tuning (T)*], [*Umbral (U)*], [*Código*]),
    [1], [Logistic Regression], [Sí], [No], [Fijo], [A1-P1-T0-U0],
    [2], [Logistic Regression], [Sí], [Sí], [Optimizado], [A1-P1-T1-U1],
    [3], [Random Forest], [No], [No], [Fijo], [A2-P0-T0-U0],
    [4], [Random Forest], [No], [Sí], [Optimizado], [A2-P0-T1-U1],
    [5], [Random Forest], [Sí], [Sí], [Optimizado], [A2-P1-T1-U1],
    [6], [XGBoost], [No], [No], [Fijo], [A3-P0-T0-U0],
    [7], [XGBoost], [No], [Sí], [Optimizado], [A3-P0-T1-U1],
    [8], [XGBoost], [Sí], [Sí], [Optimizado], [A3-P1-T1-U1],
    [9], [LightGBM], [No], [No], [Fijo], [A4-P0-T0-U0],
    [10], [LightGBM], [No], [Sí], [Optimizado], [A4-P0-T1-U1],
    [11], [LightGBM], [Sí], [Sí], [Optimizado], [A4-P1-T1-U1],
    [12], [CatBoost], [No], [No], [Fijo], [A5-P0-T0-U0],
    [13], [CatBoost], [No], [Sí], [Optimizado], [A5-P0-T1-U1],
    [14], [CatBoost], [Sí], [Sí], [Optimizado], [A5-P1-T1-U1],
  ),
  caption: [Matriz de experimentos del diseño factorial],
) <tabla-matriz-experimentos>

//A partir de este diseño se derivan cuatro hipótesis experimentales que orientarán el análisis estadístico de los resultados. La primera (HE1) postula que el factor Algoritmo tiene un efecto significativo sobre las métricas de desempeño, de modo que existe al menos un algoritmo cuyo desempeño difiere del resto: 
//H_0: mu_(A1) = mu_(A2) = mu_(A3) = mu_(A4) = mu_(A5)
//frente a $H_1: exists i, j "tal que" mu_(A i) != mu_(A j)$. La segunda (HE2) postula que el factor Preprocesamiento afecta significativamente el desempeño ($H_0: mu_(P0) = mu_(P1)$ frente a $H_1: mu_(P0) != mu_(P1)$). La tercera (HE3) sostiene que la optimización de hiperparámetros mejora significativamente el desempeño respecto de los parámetros por defecto ($H_0: mu_(T0) = mu_(T1)$ frente a $H_1: mu_(T1) > mu_(T0)$). La cuarta (HE4) sostiene que la optimización del umbral de decisión mejora las métricas orientadas al recall ($H_0: mu_(U0) = mu_(U1)$ frente a $H_1: mu_(U1) > mu_(U0)$). El contraste de estas hipótesis permitirá sustentar, con evidencia estadística y no solo descriptiva, las decisiones de diseño adoptadas en la configuración final del modelo.

== 4.6 Técnicas e Instrumentos de Recolección de Datos

La recolección de datos se sustenta en el acceso a fuentes administrativas oficiales, cuya integración permite enriquecer la caracterización de cada obra pública con información institucional, presupuestal y de riesgo reputacional. La @tabla-fuentes-datos consolida las fuentes identificadas.

#figure(
  table(
    columns: 4,
    align: (left, left, left, center),
    table.header([*Fuente*], [*Institución*], [*Descripción*], [*Formato*]),
    [Banco de Inversiones], [MEF], [Proyectos de inversión pública registrados], [CSV],
    [INFObras], [CGR], [Base de obras públicas y obras paralizadas], [XLS],
    [INCO], [CGR], [Índice de corrupción por entidad ejecutora], [XLS],
    [IGEIP], [MEF], [Índice de Gestión de la Inversión Pública], [HTML],
    [Portal de Contrataciones], [OECE], [Contrataciones del Estado], [CSV],
  ),
  caption: [Fuentes de datos utilizadas en el estudio],
) <tabla-fuentes-datos>

La integración de estas fuentes se sustenta en un modelo de datos del negocio que identifica las entidades, relaciones y atributos relevantes para el problema de estudio, tal como se ilustra en la @modelo-datos-negocio. Dicho modelo constituye, a su vez, el instrumento conceptual que orienta el diseño de las llaves de cruce entre el Banco de Inversiones y el sistema INFObras.

#figure(
  image("./assets/figures/img_modelo_datos_obra_publica.png", width: 80%),
  caption: [Diagrama entidad-relación de las principales entidades de datos del negocio],
) <modelo-datos-negocio>

El procedimiento de extracción se ejecutará mediante scripts semiautomatizados que descargan los archivos desde las fuentes oficiales, validan su integridad y los almacenan en una capa de datos crudos (_raw_) con su respectiva metadata de auditoría (fecha de descarga, fuente, versión). Posteriormente, un proceso de extracción, transformación y carga (ETL), desarrollado en Python con las bibliotecas `pandas` y `psycopg2`, migra los datos validados hacia una capa de almacenamiento intermedio (_staging_) en una base de datos relacional, preservando los registros tal como fueron recibidos y con mínimas transformaciones de formato. La integración final entre las tablas de _staging_ se realiza mediante operaciones de cruce que emplean como llaves el código único de inversión y el código INFObras, lo que permite consolidar un conjunto de datos único a partir de fuentes originalmente independientes.

== 4.7 Técnicas e Instrumentos de Análisis y Procesamiento de Datos

El procesamiento de los datos integrados comprende, en primer lugar, el tratamiento de valores faltantes, mediante la exclusión de variables con una proporción de nulos superior al umbral definido y la imputación de las variables restantes —por mediana en el caso de variables numéricas, y por moda o categoría "sin información" en el caso de variables categóricas—. En segundo lugar, se aplicará un proceso de estandarización de catálogos que reduzca la cardinalidad de variables categóricas de alta dispersión, como el departamento o la tipología de obra, mediante la construcción de catálogos maestros normalizados.

Sobre el conjunto de datos depurado, la ingeniería de características incorporará variables agregadas de naturaleza histórica, orientadas a capturar el desempeño previo de los actores institucionales involucrados, tal como se resume en la @tabla-caracteristicas-calculadas. Esta decisión se sustenta en la literatura de gestión de riesgos contractuales, en la que el historial de desempeño constituye un predictor relevante del comportamiento futuro.

#figure(
  table(
    columns: 2,
    align: (left, left),
    table.header([*Característica*], [*Descripción*]),
    [`tasa_paralizacion_entidad`], [Proporción histórica de obras paralizadas de la entidad contratante],
    [`n_obras_x_entidad`], [Cantidad total de obras ejecutadas por la entidad],
    [`monto_viable_promedio_entidad`], [Monto viable promedio de los proyectos de inversión de la entidad],
    [`tasa_paralizacion_departamento`], [Proporción histórica de obras paralizadas en el departamento],
    [`tasa_paralizacion_distrito`], [Proporción histórica de obras paralizadas en el distrito],
    [`tasa_paralizacion_tipo_obra`], [Proporción histórica de obras paralizadas según tipología de obra],
  ),
  caption: [Características calculadas incorporadas mediante ingeniería de variables],
) <tabla-caracteristicas-calculadas>

Todas las variables categóricas restantes se codificarán según su cardinalidad: codificación _one-hot_ para variables de baja cardinalidad; codificación por frecuencia y codificación supervisada (_target encoding_ con suavizado bayesiano y _Weight of Evidence_) para variables de cardinalidad media o alta, ajustadas exclusivamente sobre el conjunto de entrenamiento para prevenir la fuga de información hacia el conjunto de prueba. Con el propósito de reproducir el escenario de uso real del modelo, la partición de los datos en entrenamiento y prueba se realizará de forma temporal —y no aleatoria—, ordenando las observaciones según su fecha de inicio de obra, tal como se ilustra en la @particion-temporal; esta estrategia evita que información del futuro se filtre hacia el pasado y permite estimar el desempeño del modelo bajo condiciones más cercanas a su uso prospectivo.

#figure(
  image("./assets/figures/img_particion_temporal_train_test.png", width: 55%),
  caption: [Partición temporal de los datos en entrenamiento y prueba],
) <particion-temporal>

Respecto del desbalance de clases, se evaluará tanto la ponderación de clase (_class weight_) como la optimización del umbral de decisión en el conjunto de validación, en lugar de recurrir a técnicas de sobremuestreo o submuestreo que alteren artificialmente la proporción de clases observada; esta decisión responde a la necesidad de preservar la interpretación probabilística de los modelos estadísticos considerados. Para la selección de modelos e hiperparámetros se empleará validación cruzada anidada, respetando el orden temporal de las observaciones mediante particiones de tipo `TimeSeriesSplit`, de modo que ninguna observación utilizada para seleccionar hiperparámetros en un pliegue sea también empleada para evaluar ese mismo pliegue. Finalmente, la comparación entre modelos se realizará bajo las métricas priorizadas en la @tabla-factores-dependientes, complementadas con el Área Bajo la Curva ROC, el coeficiente de Gini y la exactitud (_accuracy_) como métricas de referencia adicional, y la interpretación de los modelos seleccionados se apoyará en la importancia por permutación, los valores SHAP y, en el caso de los modelos estadísticos paramétricos, en la lectura directa de sus coeficientes como razones de momios o razones de riesgo.

== 4.8 Etapas de Intervención del Estudio

+ *Revisión bibliográfica y marco normativo*: consolidación del estado del arte y de la normativa vigente en materia de contrataciones públicas.
+ *Adquisición e integración de datos*: extracción y consolidación de las fuentes oficiales descritas en la @tabla-fuentes-datos.
+ *Limpieza y estandarización*: tratamiento de valores faltantes, normalización de catálogos y definición de la variable objetivo.
+ *Análisis exploratorio de datos*: caracterización estadística univariada y bivariada del conjunto de datos integrado.
+ *Ingeniería de características*: construcción de variables agregadas históricas y codificación de variables categóricas.
+ *Entrenamiento y validación de modelos*: ejecución de la matriz de experimentos definida en el diseño factorial.
+ *Comparación e interpretación de modelos*: selección del modelo de mejor desempeño y aplicación de técnicas de inteligencia artificial explicable.
+ *Redacción del informe final*: consolidación de resultados, discusión y elaboración de conclusiones y recomendaciones.

= Capítulo V. Administración del Plan de Tesis

== 5.1 Cronograma

La ejecución del plan de tesis se proyecta sobre un horizonte de doce meses, distribuidos según las etapas de intervención descritas en la sección 4.8, tal como se detalla en la @cronograma.

#figure(
  table(
    columns: 9,
    align: (left,) + (center,) * 8,
    table.header(
      [*Etapa*], [*M1*], [*M2*], [*M3*], [*M4*], [*M5*], [*M6*], [*M7-M9*], [*M10-M12*],
    ),
    [1. Revisión bibliográfica y marco normativo], [X], [X], [], [], [], [], [], [],
    [2. Adquisición e integración de datos], [], [X], [X], [], [], [], [], [],
    [3. Limpieza y estandarización], [], [], [X], [X], [], [], [], [],
    [4. Análisis exploratorio de datos], [], [], [], [X], [X], [], [], [],
    [5. Ingeniería de características], [], [], [], [], [X], [X], [], [],
    [6. Entrenamiento y validación de modelos], [], [], [], [], [], [X], [X], [],
    [7. Comparación e interpretación de modelos], [], [], [], [], [], [], [X], [X],
    [8. Redacción del informe final], [], [], [], [], [], [], [], [X],
  ),
  caption: [Cronograma de actividades del plan de tesis],
) <cronograma>

== 5.2 Presupuesto

#figure(
  table(
    columns: 3,
    align: (left, center, right),
    table.header([*Rubro*], [*Unidad / cantidad*], [*Costo estimado (S/)*]),
    [Recursos humanos (asesoría especializada)], [12 meses], [6,000.00],
    [Bienes: equipo de cómputo y licencias de software estadístico], [2 equipos], [3,500.00],
    [Servicios: cómputo en la nube y acceso a bases de datos], [12 meses], [1,800.00],
    [Servicios: revisión de estilo, impresión y empastado], [Global], [700.00],
    [*Total*], [], [*12,000.00*],
  ),
  caption: [Presupuesto estimado del plan de tesis],
) <presupuesto>

== 5.3 Financiamiento

El desarrollo del presente plan de tesis será autofinanciado por los tesistas, sin perjuicio del uso de la infraestructura académica y del acceso a bases de datos institucionales que la Escuela de Posgrado de la Universidad Nacional de Ingeniería pone a disposición de sus estudiantes de maestría.

= Referencias

#bibliography("ref.bib", title: none, style: "apa")

= Anexos

== Anexo 1: Matriz de Consistencia


La @matriz-consistencia sintetiza la correspondencia entre los problemas identificados, los objetivos formulados y las hipótesis que orientarán la investigación, en coherencia con lo desarrollado a lo largo de los Capítulos I y II.

#figure(
  table(
    columns: 3,
    align: (left, left, left),
    table.header([*Problemas*], [*Objetivos*], [*Hipótesis*]),
    [
      *Problema General.* En la gestión de obras públicas en el Perú se presenta una insuficiente identificación y articulación de los factores asociados a la paralización de obras por incumplimiento contractual, a partir de la información disponible en la normativa vigente, la literatura especializada y los registros administrativos de fuentes públicas.
    ],
    [
      *Objetivo General.* Analizar la incidencia y articulación de los factores de riesgo asociados a la paralización de obras públicas por incumplimiento contractual, mediante el examen de la normativa vigente, la literatura especializada y la evidencia contenida en los registros administrativos de fuentes públicas oficiales.
    ],
    [
      *Hipótesis General.* La identificación y el análisis articulado de los factores de riesgo derivados de la normativa vigente, la literatura especializada y los registros administrativos permiten explicar de manera significativa la paralización de obras públicas por incumplimiento contractual.
    ],
    [P1. Insuficiente identificación sistemática de los factores de riesgo asociados a la paralización por incumplimiento contractual.],
    [OE1. Identificar los factores de riesgo asociados a la paralización de obras por incumplimiento contractual.],
    [H1. Existen factores observables en la literatura, la normativa y los registros administrativos que se asocian con la paralización de obras por incumplimiento contractual.],
    [P2. Dispersión y heterogeneidad de los datos disponibles, sin procesos estandarizados de obtención, limpieza e ingeniería de características.],
    [OE2. Implementar la obtención y preparación de datos, incluyendo limpieza, estandarización, control de calidad e ingeniería de características.],
    [H2. La obtención y preparación de datos mejora el desempeño del modelo de aprendizaje automático respecto del uso de datos sin preprocesamiento.],
    [P3. Indeterminación del modelo de aprendizaje automático más adecuado, ante la falta de un marco comparativo homogéneo.],
    [OE3. Comparar modelos de aprendizaje automático mediante su ajuste, entrenamiento y evaluación con métricas pertinentes.],
    [H3. Entre los modelos considerados, al menos uno presenta un desempeño superior a los demás para estimar el riesgo de paralización.],
    [P4. Limitada interpretabilidad de las salidas del modelo, por ausencia de técnicas de inteligencia artificial explicable.],
    [OE4. Aplicar técnicas de inteligencia artificial explicable para generar interpretaciones del modelo a nivel agregado y por obra.],
    [H4. Las técnicas de inteligencia artificial explicable generan interpretaciones consistentes y permiten establecer criterios claros para la toma de decisiones.],
  ),
  caption: [Matriz de consistencia del plan de tesis],
) <matriz-consistencia>
