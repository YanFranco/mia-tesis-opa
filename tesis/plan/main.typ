#import "@preview/lovelace:0.3.1": pseudocode-list
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

// =============================================================================
// Plan de Tesis de Maestría de Especialización / Profesionalizante
// Universidad Nacional de Ingeniería — Escuela de Posgrado
// Basada en: tesis/guias/formato-tesis-plan.md
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
#let titulo-plan = "Estimación anticipada de la probabilidad de paralización de obras públicas por incumplimiento contractual en el Perú mediante TÉCNICAS DE INTELIGENCIA ARTIFICIAL"
#let mencion = "INTELIGENCIA ARTIFICIAL"
#let propósito = "PARA OBTENER EL GRADO ACADÉMICO DE MAESTRO EN CIENCIAS CON MENCIÓN EN: INTELIGENCIA ARTIFICIAL"
#let autores = ("YAN FRANCO CALDERON FELIX", "HILBER ALEXANDER CIEZA DELGADO")
#let asesores = ("SAMUEL OPORTO DIAZ",)
#let lugar = "Lima, Perú"
#let anio = "2026"
#let duracion = "Duración estimada: 3 meses"
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

// Texto de las tablas: dos puntos menos que el texto normal (11pt → 9pt).
#show table: set text(size: 9pt)

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

// Los bloques "sticky" evitan que un título quede aislado al pie de página.
#show heading.where(level: 2): it => block(sticky: true, above: 2.2em, below: 1.4em)[
  #text(weight: "bold", size: 11pt)[#it.body]
]

#show heading.where(level: 3): it => block(sticky: true, above: 1.9em, below: 1.3em)[
  #text(weight: "bold", size: 11pt)[#it.body]
]

#show heading.where(level: 4): it => block(sticky: true, above: 1.7em, below: 1.2em)[
  #text(weight: "bold", size: 11pt)[#it.body]
]

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

=== 1.1.2 Ciclo del fenómeno

Las obras públicas transitan por diferentes estados durante su ciclo de vida @diagrama-estados-inv. El estado de paralización se configura cuando la ejecución física se interrumpe por un periodo prolongado y la obra no se concluye, de acuerdo con los criterios establecidos por los informes de seguimiento de la Contraloría General de la República. En este ciclo intervienen factores técnicos, financieros, contractuales, institucionales y externos que pueden incidir en la continuidad o interrupción de la ejecución. En este contexto el estado objetivo de análisis (Estado 5 en la @diagrama-estados-inv) se alcanza si se dan las siguientes condiciones @contraloria_general_de_la_republica_del_peru_informe_2025
:

- La obra puede ejecutarse bajo modalidades como contrata, administración directa, convenios de Estado a Estado, Asociaciones Público-Privadas con componente de infraestructura, Obras por Impuestos, núcleos ejecutores u otras modalidades previstas por la normativa aplicable.
- La obra debe encontrarse en ejecución física conforme a las condiciones establecidas para su inicio y desarrollo según el marco normativo de la modalidad correspondiente.
- La obra no se ha concluido y no presenta avance en su ejecución física en un periodo mínimo de seis (06) meses; o, provenga de un contrato resuelto o declarado nulo, por causas atribuibles a situaciones de controversia, abandono, deficiencias del expediente técnico, factores climáticos, situaciones imprevisibles posteriores al perfeccionamiento del contrato u otras causas que puedan ocasionar la suspensión prolongada del plazo de ejecución física de la obra.

#figure(
  image("assets/figures/img_diagrama_estados_obra.png", width: 65%),
  caption: [Flujo de actividades en la ejecución de una obra],
) <diagrama-estados-inv>

En el sistema de infobras, de acuerdo al dataset de obras publicas disponibilizado por la CGR, se maneja un estado de ejecución de la obra, la cual cuenta con 4 valores y cuyo diagrama de transicion de estados se muestra en @diagrama-estados-ejecucion-obra.

\
#figure(
  diagram(
    node-stroke: 1pt + black,
    node-fill: rgb("f9f9f9"),
    spacing: (2cm, 2cm), // Aumentado ligeramente para dar aire a los rectángulos
    
    // Configuramos los nodos como rectángulos ("rect") con un margen interno (inset) generoso
    node((0,0), [Sin Ejecución], name: <S>, shape: "rect", inset: 10pt),
    node((1.5,0), [En Ejecución], name: <E>, shape: "rect", inset: 10pt, stroke: 1.5pt + blue.darken(20%)),
    node((1.5,1.5), [Paralizado], name: <P>, shape: "rect", inset: 10pt, stroke: 1pt + red.darken(10%)),
    node((3,0), [Finalizado], name: <F>, shape: "rect", inset: 10pt, stroke: 2pt + green.darken(30%)),
    
    // Conexiones y transiciones
    edge(<S>, <E>, "-|>", label: [Inicio]),
    
    // Controlamos el 'bend' y el lado de la etiqueta para que no colisionen con los rectángulos
    edge(<E>, <P>, "-|>", bend: 25deg, label: [Paralización], label-side: right),
    edge(<P>, <E>, "-|>", bend: 25deg, label: [], label-side: right),
    
    edge(<E>, <F>, "-|>", label: [Recepción]),
  ),
  caption: [Transición de estados en la ejecución de una obra pública según Infobras]
)  <diagrama-estados-ejecucion-obra>

=== 1.1.3 Tipificación del fenómeno

Con el propósito de delimitar el objeto de estudio, resulta pertinente formalizar la tipificación del fenómeno, para ello, se tomará como base las causales de paralización de obra registradas en el sistema INFObras, que posteriormente son reportadas por la Contraloría General de la República, la @tabla-causas-nacional desagrega las causales registradas según su incidencia económica y cuantitativa, permitiendo identificar las causales de mayor impacto y relevancia para la investigación.

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

Como puede apreciarse en la @tabla-causas-nacional, el incumplimiento de contrato (por parte del contratista) destaca simultáneamente como la causal de mayor incidencia en número de obras (25.4 %) y como una de las de mayor impacto económico, al concentrar S/ 15,913.4 millones, equivalentes al 36.9 % del costo total paralizado @contraloria_general_de_la_republica_del_peru_informe_2025. Por otro lado, el incumplimiento contractual también puede manifestarse mediante situaciones asociadas a controversias, abandono de obra, resolución de contrato, incumplimiento de obligaciones, penalidades, problemas de supervisión, modificaciones contractuales o falta de pago de valorizaciones por parte de la entidad contratante, por lo que, con base en la lista de causales proporcionada por la CGR, se definió la categoría "CONTRACTUAL" que agrupa las causales relacionadas al motivo de paralización de obra por incumplimiento contractual, las cuales son imputables tanto al contratista como a la entidad contratante. La @tabla-causales-contractuales detalla la lista de causales seleccionadas que formarán parte de la variable objetivo del estudio.

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

=== 1.1.4 Caracterización del fenómeno

Los sistemas administrativos como Infobras de la CGR, el Banco de Inversiones del MEF y los registros de contratación pública contienen información operativa, contractual y de gestión relevantes de datos maestros, transaccionales, de referencia, metadatos e históricos que pueden emplearse para la identificación de patrones que permita realizar una estimación cuantitativa de la probabilidad de paralización durante la ejecución de obras.

La @diagrama-caracterizacion-obra-publica muestra una representación esquemática de las principales entidades de datos y características relacionadas con el objeto de estudio.

#figure(
  image("assets/figures/img_caracterizacion_obra_publica.png", width: 100%),
  caption: [Caracterización de una obra pública a través de sus diferentes atributos],
) <diagrama-caracterizacion-obra-publica>
\
A partir de un análisis inicial del conjunto de datos de obras públicas, que considera los registros válidos con un estado de ejecución en `finalizado`, `en ejecución` o `paralizadas`, se presenta un diagrama de frecuencia de las paralizaciones por incumplimiento contractual respecto al total de obras no paralizadas (@diagrama-distribucion-clases-general), evidenciando que la proporción de obras paralizadas por incumplimiento contractual es baja en comparación con el total de obras ejecutadas, por lo que la naturaleza de nuestro fenomeno indica abordar un conjunto de datos desbalanceado.

#figure(
  image("assets/figures/img_distribucion_clases_general.png", width: 90%),
  caption: [Frecuencia de paralizaciones por incumplimiento contractual respecto al total de obras no paralizadas, con corte de la información a enero de 2025 @contraloria_general_de_la_republica_del_peru_informe_2025],
) <diagrama-distribucion-clases-general>

== 1.2 Identificación y Descripción del Problema de Estudio

Uno de los mayores desafíos para lograr una gestión efectiva de la inversión pública consiste en concluir las obras desde su inicio hasta su finalización, dentro de los costos previstos y sin interrupciones. Sin embargo, en el Perú, al igual que en muchas otras economías, es común encontrar un número significativo de inversiones paralizadas @calle_desempeno_2024. Esta situación genera sobrecostos en los proyectos de inversión, afecta el cumplimiento de las metas de cierre de brechas de infraestructura, ocasiona la pérdida de recursos públicos e impide el acceso oportuno de la población a servicios básicos, con el consiguiente deterioro de la calidad de vida y del desarrollo del país.

Frente a la magnitud del fenómeno descrita en el diagnóstico, la respuesta institucional del Estado suele ser reactiva: las auditorías, los informes de control y las intervenciones correctivas se ejecutan una vez que el contrato ya ha sido resuelto o los plazos ya han vencido, momento en el cual el margen de maniobra preventivo se ha perdido. Esta dinámica no solo limita la capacidad anticipatoria de la gestión pública, sino que además perpetúa un modelo en el que la información disponible no se transforma en conocimiento útil ni en alertas tempranas para la toma de decisiones. En consecuencia, se configura un vacío de alto impacto: se dispone de información estructurada y relevante como el historial de las entidades y de los contratistas, ubicación de las obras, montos y plazos de ejecución, modificaciones contractuales y acciones de control; pero dicha información no se utiliza de manera sistemática para construir predictores del riesgo.

La falta de una estimación de la probabilidad de paralización de obras públicas en el Perú limita la capacidad de los gestores de las entidades públicas para identificar las obras con alto riesgo de paralización y para disponer de una lista ordenada según dicah medida, que sirva como herramienta de apoyo para priorizar recursos de supervisión y ejecutar acciones preventivas. Por lo tanto, el propósito principal del estudio consiste en implementar y comparar modelos de inteligencia artificial que permitan estimar dicha medida, proporcionando a la vez un entendimiento de los patrones presentes en los datos y de los principales factores asociados.

En términos formales, la probabilidad de paralización de una obra por incumplimiento contractual puede cuantificarse a partir de un conjunto de características, cuantitativas y cualitativas, conocidas al inicio de su ejecución. Para ello, el fenómeno se representa mediante una variable de respuesta binaria $Y^(tau)$, que toma el valor $1$ si la obra experimenta su primera paralización dentro de un horizonte temporal $tau$ contado desde el inicio de la ejecución y dicha paralización obedece a una causal contractual, y el valor $0$ en caso contrario. La cuantificación del riesgo corresponde entonces a la probabilidad condicional $p_(tau)(bold(x)) = Pr(Y^(tau) = 1 mid(|) bold(X) = bold(x))$, mientras que la asignación de una obra a una de las dos clases, mediante una regla del tipo $hat(Y) = bb(1)(hat(p)_(tau)(bold(x)) >= c)$ con un umbral $c$, constituye una decisión posterior y distinta de la estimación; esta formalización se desarrolla en la sección 3.1.1. Adicionalmente, como se evidencia en la @diagrama-distribucion-clases-general, existe un marcado desbalance de clases, lo que exige evaluar la solución con métricas que reflejen tanto la calidad de las probabilidades estimadas como la capacidad del modelo para identificar las obras en riesgo.

=== 1.2.1 Antecedentes Bibliográficos

La revisión de la literatura especializada muestra estudios sobre aplicación de técnicas de aprendizaje automático a la predicción de retrasos y paralizaciones en proyectos de construcción, aunque con distintos niveles de madurez técnica y metodológica. En un primer estudio, se identificaron 59 factores de riesgo mediante revisión bibliográfica y consulta a expertos, y se compiló un conjunto de datos de 51 proyectos de construcción en Egipto, sobre el cual se compararon los algoritmos de Árbol de Decisión y Naive Bayes mediante validación cruzada de diez pliegues; este último superó al primero, resultado atribuido al tamaño reducido de la muestra y a la independencia condicional de las variables @gondia_machine_2020. En una línea similar, pero con algoritmos más recientes de _gradient boosting_, una investigación aplicada al contexto de Arabia Saudita evaluó CatBoost, XGBoost y LightGBM sobre 62 proyectos con retraso, empleando validación cruzada de diez pliegues y optimización de hiperparámetros; los resultados mostraron que LightGBM superó consistentemente a los otros dos algoritmos, alcanzando la mayor precisión de prueba y la menor tasa de clasificación errónea @alsulamy_predicting_2025. De manera complementaria, otro estudio aplicado evaluó distintos algoritmos de aprendizaje automático sobre datos reales del sector infraestructura, encontrando que los modelos basados en árboles —Random Forest y XGBoost— resultaban más adecuados en escenarios donde la interpretabilidad y la capacidad de acción son necesarias para los tomadores de decisiones @nnaemeka_egwim_applied_2021.

Esta preocupación por la interpretabilidad resulta particularmente relevante para la adopción institucional de modelos predictivos en el sector público, razón por la cual la presente investigación contempla la incorporación de técnicas de inteligencia artificial explicable, como los valores SHAP, que permiten cuantificar la contribución individual de cada característica a las predicciones del modelo @lundberg_unified_2017.

Finalmente, en el ámbito peruano, un antecedente fundamental lo constituye el trabajo de #cite(<solis-villanueva_tecnicas_2018>, form: "prose"), quien formuló una arquitectura automatizada para optimizar los procedimientos de selección de obras públicas bajo la Ley de Contrataciones del Estado (Ley N.° 30225), orientada a resolver escenarios de empate mediante un sistema híbrido: sorteo criptográfico auditable (SHA-256) en adjudicaciones simplificadas y predicción del comportamiento del contratista en licitaciones públicas. Para este último procedimiento, el autor propuso un modelo basado en redes neuronales artificiales de tipo perceptrón multicapa (_feed-forward backpropagation_) entrenadas mediante el algoritmo de Levenberg-Marquardt sobre una muestra histórica de 209 proyectos de infraestructura ejecutados por un grupo empresarial peruano. Dicho modelo evaluó diez indicadores de riesgo operativo y contractual —entre los que destacan la relación entre el presupuesto ofertado y el valor referencial, los gastos generales, la experiencia del personal clave residente y de gerencia, el plazo contractual y el factor de reajuste polinómico de precios ($K$)— con el fin de estimar un índice de cumplimiento continuo y clasificar la probabilidad de éxito o fracaso del postor ($Y in {0, 1}$) previo al otorgamiento de la buena pro.

=== 1.2.2 Formulación del Problema

==== 1.2.2.1 Formulación del Problema General

¿En qué medida la implementación, evaluación y comparación de modelos de inteligencia artificial, utilizando registros administrativos de fuentes públicas oficiales bajo un enfoque de estimación probabilística supervisada con clases desbalanceadas, permite estimar cuantitativa y anticipadamente el riesgo de paralización de obras públicas en el Perú por incumplimiento contractual y obtener una herramienta predictiva, calibrada e interpretable que permita jerarquizar proyectos por nivel de riesgo y sustentar la toma de decisiones preventivas en la ejecución de inversiones?

==== 1.2.2.2 Formulación de los Problemas Específicos

+ ¿Qué factores de riesgo candidatos asociados a la paralización de obras por incumplimiento contractual se pueden identificar a partir de la literatura especializada, la normativa vigente y los registros administrativos de fuentes públicas oficiales?
+ ¿Cómo recopilar, integrar y preparar los datos de fuentes públicas oficiales, incluyendo su limpieza, estandarización, control de calidad y la reconstrucción histórica de la variable de respuesta, para el estudio del riesgo de paralización por incumplimiento contractual?
+ ¿Cómo realizar el análisis exploratorio de datos y la ingeniería de características necesarios para obtener los conjuntos de datos de entrenamiento y de prueba destinados a la estimación de la probabilidad de paralización por incumplimiento contractual?
+ ¿Qué modelo estadístico o de aprendizaje automático presenta el mejor desempeño para estimar el riesgo de paralización por incumplimiento contractual, al comparar su ajuste, entrenamiento y evaluación bajo métricas de calibración, discriminación y decisión, y cuáles son sus hiperparámetros y condiciones de uso?
+ ¿Cómo aplicar técnicas de inteligencia artificial explicable para interpretar el modelo a nivel agregado y por obra, identificar los factores determinantes del riesgo y establecer criterios de interpretación orientados a la toma de decisiones?

=== 1.2.3 Justificación y Alcances

==== 1.2.3.1 Justificación

La justificación del presente estudio se sostiene en tres plan complementarios. En el plano práctico, la magnitud económica y social del fenómeno —evidenciada en las @tabla-causas-nacional, @tabla-nivel-gobierno y @tabla-sector— demuestra que el incumplimiento contractual no constituye un problema marginal, sino la causal de mayor impacto económico entre todas las reportadas, lo que confiere relevancia inmediata a cualquier esfuerzo orientado a anticiparlo. En el plano teórico, la investigación contribuye a cerrar una brecha de conocimiento evidenciada en la literatura revisada, en la medida en que integra, bajo un marco comparativo homogéneo, familias de modelos estadísticos y algorítmicos que en estudios previos han sido abordadas de manera aislada. Finalmente, en el plano metodológico, la incorporación de técnicas de inteligencia artificial explicable responde a una limitación reiterada en los antecedentes revisados, en los que el desempeño predictivo no siempre viene acompañado de una interpretación sustantiva accesible a los tomadores de decisión @santini_data_2024. En conjunto, estos tres planos justifican una investigación que no se limite a maximizar una métrica de clasificación, sino que produzca un instrumento cuantitativo de apoyo a la gestión del riesgo, susceptible de ser adoptado por las entidades del Estado peruano.

==== 1.2.3.2 Alcances

El presente plan de tesis delimita su alcance a partir de los siguientes criterios funcionales, aplicados sobre los registros administrativos disponibles:

+ Se excluyen del universo inicial las obras que no hayan iniciado su ejecución física, es decir, no se consideran obras con estado "sin ejecución".
+ Se incluyen únicamente obras públicas que cuenten con una fecha de inicio de obra registrada.
+ Dado que el alcance del trabajo se enmarca en el dominio de la inversión pública bajo el Sistema Nacional de Programación Multianual y Gestión de Inversiones (Invierte.pe), solo se consideran obras asociadas a un código de inversión existente en el Banco de Inversiones del Ministerio de Economía y Finanzas.
+ Se circunscribe el estudio al universo de obras públicas cuya modalidad de ejecución es "por contrata".
+ Respecto de la causal de paralización, se adopta la categorización presentada en la @tabla-causales-contractuales, restringiendo la clase positiva a los incumplimientos contractuales atribuibles a la entidad o al contratista; las paralizaciones por otras causales se tratan como eventos competitivos (sección 3.1.1).
+ Se incluyen en el conjunto de modelado únicamente las obras cuyo horizonte de estimación $tau$ sea plenamente observable a la fecha de corte de la información, criterio que depende solo de la fecha de inicio de cada obra (sección 3.1.1).
+ El análisis prioriza obras ejecutadas por el Gobierno Nacional, en la medida en que dicho nivel de gobierno concentra registros más completos y homogéneos en los sistemas de seguimiento oficiales, sin perjuicio de que la extensión del modelo a los niveles regional y local se identifique como línea de trabajo futuro.

En términos temporales, el estudio se circunscribe al periodo para el cual se dispone de registros administrativos consistentes en el Banco de Inversiones, INFObras y las fuentes complementarias descritas en el Capítulo IV, mientras que, en términos temáticos, el alcance se limita a la estimación del riesgo de paralización por incumplimiento contractual, sin abordar de manera exhaustiva otras causales como referentes al clima, sociales o logisticos, si bien relevantes, exceden el objeto específico de esta investigación.

= Capítulo II. Objetivos

== 2.1 Objetivo General

Implementar, evaluar y comparar modelos de inteligencia artificial para la estimación anticipada de la probabilidad de paralización de obras públicas en el Perú por causal de incumplimiento contractual, utilizando registros administrativos de fuentes públicas oficiales bajo un enfoque de estimación probabilística supervisada con clases desbalanceadas, con la finalidad de obtener una herramienta predictiva, calibrada e interpretable que permita jerarquizar proyectos por nivel de riesgo y sustentar la toma de decisiones preventivas en la ejecución de inversiones.

== 2.2 Objetivos Específicos

+ Identificar factores de riesgo candidatos asociados a la paralización de obras por incumplimiento contractual a partir de la literatura especializada, la normativa vigente y los registros administrativos de fuentes públicas oficiales.
+ Implementar la recopilación, integración y preparación de los datos, incluyendo la limpieza, la estandarización, el control de calidad y la reconstrucción histórica de la variable de respuesta.
+ Realizar un análisis exploratorio de datos y la ingeniería de características necesaria para la obtención del conjunto de datos de entrenamiento y de prueba.
+ Comparar modelos estadísticos y de aprendizaje automático mediante su ajuste, entrenamiento y evaluación bajo métricas de calibración, discriminación y decisión, con el propósito de seleccionar el candidato de mejor desempeño.
+ Aplicar técnicas de inteligencia artificial explicable para generar interpretaciones del modelo a nivel agregado y por obra, identificando los factores determinantes del riesgo y estableciendo criterios de interpretación orientados a la toma de decisiones.

= Capítulo III. Marco Teórico

== 3.1 Bases Teóricas

La ejecución contractual constituye una fase crítica dentro del ciclo de vida de las inversiones públicas. De acuerdo con la Ley N.° 32069, Ley General de Contrataciones Públicas, la ejecución contractual comprende el conjunto de actos y obligaciones que deben cumplir tanto la entidad contratante como el contratista, desde la suscripción del contrato hasta su culminación, liquidación y cierre @mef_ley_32069_2024. El incumplimiento de dichas obligaciones puede derivar en la aplicación de penalidades, en la resolución del contrato y, en escenarios críticos, en la paralización de la obra; desde un enfoque de gestión pública, la paralización representa así una falla sistémica en la articulación entre planificación, contratación y ejecución.

Desde la perspectiva de aprendizaje supervisado, el problema admite dos tareas de predicción distintas: la clasificación de las obras según su condición de riesgo y la estimación del riesgo propiamente dicho @kruppa2012RiskEstimationRisk. En la clasificación se espera una respuesta dicotómica, mientras que en la estimación del riesgo se espera una probabilidad que cuantifique la propensión al evento; esta última proporciona información más detallada que una simple respuesta dicotómica y constituye el elemento central de la predicción de riesgos @kruppa2012RiskEstimationRisk @steyerberg2014RiskPredictionMachine. Tradicionalmente, la clasificación se ha abordado mediante enfoques no paramétricos, mientras que la estimación de probabilidades se ha abordado mediante modelos paramétricos, en particular la regresión logística, que constituye el enfoque estándar @kruppa2012RiskEstimationRisk. La presente investigación se orienta a la estimación del riesgo, por lo que las bases teóricas parten de una formulación probabilística del problema y, a partir de ella, describen las familias de modelos, el tratamiento del desbalance, los esquemas de validación, las métricas de evaluación y las técnicas de interpretación pertinentes.

=== 3.1.1 Formulación matemática y estadística del problema

La paralización de obras públicas constituye un fenómeno de naturaleza incierta cuya ocurrencia puede estar asociada con características institucionales, técnicas, económicas, contractuales y territoriales de las obras. Desde una perspectiva estadística, el problema consiste en estimar la probabilidad de que una obra pública experimente una primera paralización por incumplimiento contractual dentro de un horizonte temporal determinado, dadas las características que se conocen al inicio de su ejecución.

Esta formulación se establece independientemente de la familia de modelos estadísticos o algoritmos de aprendizaje automático que posteriormente se utilicen para efectuar la estimación. Para ello, se distinguen cuatro niveles: el fenómeno de interés, el modelo probabilístico poblacional, su representación mediante una muestra aleatoria y la estimación realizada sobre un conjunto de datos observado.

*Delimitación del fenómeno de interés.*

Sea $cal(U)$ la población objetivo de obras públicas que han iniciado su ejecución y cumplen los criterios de elegibilidad establecidos en la sección 1.2.3.2. La unidad de análisis es la obra pública individual, identificada mediante su código Infobras, aun cuando distintas obras puedan pertenecer a un mismo proyecto de inversión. Para cada obra $i$ se denota por $t_(0 i)$ la fecha de inicio de su ejecución física, instante en el que se sitúa la estimación. Para cada obra se considera un vector aleatorio de características

$
  bold(X) = (X_1, X_2, ..., X_q) in cal(X) = cal(X)_1 times cal(X)_2 times dots.c times cal(X)_q,
$ <ec-espacio-caracteristicas>

donde $q$ es el número de variables explicativas y cada $cal(X)_j$ es el conjunto de valores posibles de la variable $X_j$: un subconjunto de $RR$ para las variables numéricas, como el monto aprobado, o un conjunto finito de categorías para las variables nominales, como la entidad ejecutora, el departamento o la tipología de obra. Dado que la mayoría de los procedimientos de estimación operan sobre vectores reales, se considera además una transformación de ingeniería de características

$
  phi: cal(X) -> RR^d,
$ <ec-transformacion-caracteristicas>

que comprende la imputación de valores faltantes, la codificación de las variables categóricas y el escalado de las variables numéricas. Cuando dicha transformación se ajusta con los datos, como ocurre con la codificación supervisada, forma parte del procedimiento de estimación y no de la definición del fenómeno.

El vector $bold(X)_i$ debe contener exclusivamente información disponible antes del inicio de la ejecución. Si se denota por $cal(H)_t$ la información registrada en los sistemas administrativos estrictamente antes del instante $t$, se exige que $bold(X)_i$ sea una función únicamente de $cal(H)_(t_(0 i))$. Esta condición de disponibilidad temporal excluye, por construcción, las variables que se generan durante la ejecución, como las ampliaciones de plazo, los adicionales de obra o los informes de control posteriores al inicio, y obliga a que las variables agregadas históricas, como la tasa de paralización de la entidad, se calculen solo con obras cuyo resultado ya era conocido en $t_(0 i)$. De este modo, la formulación previene la fuga de información (_data leakage_) desde el futuro hacia las características @kaufman2012LeakageDataMining.

Sea $T$ el tiempo transcurrido desde el inicio de la ejecución hasta la primera paralización de la obra, cualquiera sea su causa, y sea $C in {1, 2}$ la causal de dicha paralización, donde $C = 1$ corresponde a las causales contractuales de la @tabla-causales-contractuales y $C = 2$ agrupa las demás causales. Si la obra no experimenta ninguna paralización durante su trayectoria, por ejemplo porque concluye su ejecución con normalidad, se establece convencionalmente que $T = +infinity$, en cuyo caso $C$ no está definida. Conforme al criterio de la Contraloría General de la República, el instante de paralización corresponde al inicio del periodo sin avance físico que da lugar al reconocimiento de la paralización.

Para un horizonte de observación $tau > 0$, se define la variable aleatoria de respuesta

$
  Y^(tau) = bb(1)(T <= tau) dot bb(1)(C = 1) = cases(
    1 & "si" T <= tau "y" C = 1,
    0 & "si" T > tau "o" (T <= tau "y" C = 2)
  )
$ <ec-variable-respuesta>

De esta manera, $Y^(tau) = 1$ representa la ocurrencia de una primera paralización por incumplimiento contractual dentro del horizonte considerado. El valor $Y^(tau) = 0$ comprende tres situaciones bien definidas: la obra concluye dentro del horizonte sin haberse paralizado; la obra permanece en ejecución activa durante todo el horizonte sin paralizarse; o la obra se paraliza dentro del horizonte por una causal no contractual. La variable constituye una respuesta binaria, sin que ello implique que la probabilidad del evento sea constante entre las obras.

La última situación refleja que el problema presenta riesgos competitivos (_competing risks_): una paralización por causas climáticas, sociales o de disponibilidad de terreno modifica o impide la ocurrencia posterior de una paralización contractual. Por ello, no corresponde tratar dichas obras como censuradas, pues ello conduciría a estimar una probabilidad hipotética en ausencia de las demás causales @fine1999ProportionalHazardsModel. La definición adoptada conduce, en cambio, a estimar el riesgo absoluto de paralización contractual en presencia de las demás causales, que es la cantidad relevante para la priorización preventiva. Asimismo, la definición del horizonte $tau$ permite establecer con precisión el periodo al que se refiere la estimación y distingue la ausencia de una paralización observada de la afirmación de que una obra nunca llegará a paralizarse. La elección de $tau$ supone un equilibrio: un horizonte mayor incrementa el número de casos positivos y el alcance de la alerta, pero reduce el número de obras cuyo horizonte completo puede observarse; por ello, su valor se fijará en la etapa metodológica a partir de la distribución empírica de los tiempos de paralización y de los plazos contractuales.

*Formulación probabilística a nivel poblacional.*

En el nivel poblacional, se considera que el vector aleatorio $(bold(X), T, C)$, y por tanto el par $(bold(X), Y^(tau))$, sigue una distribución de probabilidad conjunta desconocida $P_0$. El objeto de interés es la función de probabilidad condicional

$
  p_(tau)(bold(x))
  = "Pr"_0(Y^(tau) = 1 mid(|) bold(X) = bold(x))
  = "Pr"_0(T <= tau, C = 1 mid(|) bold(X) = bold(x)),
$ <ec-proba-condicional>

donde $bold(x) in cal(X)$ representa una configuración particular de las características de una obra y $p_(tau)(bold(x)) in [0, 1]$ es la probabilidad poblacional de que dicha obra experimente su primera paralización, por causal contractual, dentro del horizonte $tau$. En la terminología del análisis de supervivencia, $p_(tau)(bold(x))$ corresponde a la función de incidencia acumulada de la causal contractual evaluada en $tau$, y no al complemento de la función de supervivencia global, $1 - S(tau mid(|) bold(x))$, que acumularía todas las causales @fine1999ProportionalHazardsModel.

Esta función puede expresarse, de forma equivalente, mediante la esperanza condicional de la variable de respuesta:

$
  p_(tau)(bold(x)) = E_0(Y^(tau) mid(|) bold(X) = bold(x)).
$ <ec-esperanza-condicional>

La equivalencia anterior se deriva de la naturaleza binaria de $Y^(tau)$ y tiene una consecuencia metodológica relevante: la estimación de $p_(tau)$ es un problema de regresión, por lo que cualquier procedimiento que estime de manera consistente una función de regresión estima también de manera consistente la probabilidad condicional @kruppa2014ProbabilityEstimationMachine. En consecuencia, la distribución condicional de la respuesta puede representarse como

$
  Y^(tau) mid(|) bold(X) = bold(x) ~ "Bernoulli"(p_(tau)(bold(x))).
$ <ec-distribucion-bernoulli>

La función $p_(tau)$ representa una propiedad desconocida de la distribución poblacional y constituye la cantidad que se busca estimar. No se supone, en esta formulación general, una expresión funcional específica para dicha probabilidad.

De manera complementaria, se define la probabilidad marginal de paralización como

$
  pi_tau = "Pr"_0(Y^(tau) = 1) = E_0(p_(tau)(bold(X))),
$ <ec-prob-marginal>

igualdad que se sigue de la ley de la esperanza total. El parámetro $pi_tau$ expresa la proporción esperada de obras que experimentarían una primera paralización contractual dentro del horizonte considerado, mientras que $p_(tau)(bold(x))$ permite diferenciar el riesgo según las características de cada obra. Esta distinción resulta fundamental para el problema de investigación, debido a que el objetivo no consiste únicamente en conocer la frecuencia general de paralización, sino en obtener estimaciones individualizadas de su probabilidad condicional @kruppa2014ProbabilityEstimationMachine.

Dado que el marco normativo, la capacidad de gestión de las entidades y el contexto económico cambian con el tiempo —por ejemplo, con la sustitución de la Ley N.° 30225 por la Ley N.° 32069 @mef_ley_32069_2024—, la distribución $P_0$ puede variar según la cohorte de inicio de las obras. Por ello, la población de referencia se entiende como la de las obras que inician su ejecución en el periodo en que el modelo se aplicaría, y la estabilidad de la relación entre características y respuesta deberá examinarse empíricamente mediante una partición temporal de los datos.

*Formulación a nivel muestral.*

Dado que la distribución poblacional $P_0$ es desconocida, la función $p_(tau)$ debe estimarse a partir de información observada. En una representación estadística ideal, se considera una muestra aleatoria de tamaño $n$:

$
  cal(D)_n = (Z_1, Z_2, ..., Z_n), quad Z_i = (bold(X)_i, Y_i^(tau)), quad i = 1, ..., n.
$ <ec-unidad-muestral>

Bajo un supuesto inicial de muestreo aleatorio, las observaciones se consideran realizaciones independientes de una misma distribución poblacional:

$ Z_1, ..., Z_n limits(tilde.op)^"iid" P_0 . $ <ec-muestra-aleatoria>

Este supuesto proporciona un marco conceptual para definir los estimadores; sin embargo, su adecuación deberá examinarse en la investigación empírica por tres razones. En primer lugar, INFObras registra prácticamente la totalidad de las obras públicas del país, por lo que los datos no provienen de un muestreo probabilístico, sino que se interpretan como realizaciones de un proceso generador común, conforme a una perspectiva de superpoblación. En segundo lugar, distintas obras pueden compartir un mismo proyecto de inversión, entidad ejecutora o contratista, lo que induce dependencia entre las observaciones de un mismo grupo y afecta la estimación de la variabilidad de las métricas y de los coeficientes. En tercer lugar, la posible variación de $P_0$ entre cohortes, señalada anteriormente, compromete el supuesto de distribución idéntica.

La distribución empírica asociada con la muestra se representa mediante

$
  hat(P)_n (A) = 1/n sum_(i=1)^n bb(1)(Z_i in A),
$ <ec-distribucion-empirica>

donde $A$ es un conjunto medible de posibles observaciones y $bb(1)(dot)$ es la función indicadora, que toma el valor uno cuando se cumple la condición y cero en caso contrario. Si las respuestas se encuentran completamente observadas, la probabilidad marginal de paralización puede estimarse mediante la proporción muestral, que corresponde a la media de $Y^(tau)$ bajo $hat(P)_n$:

$
  hat(pi)_(n, tau) = 1/n sum_(i=1)^n Y_i^(tau).
$ <ec-estimador-proporcion>

No obstante, el objetivo principal de este trabajo requiere estimar una función de probabilidad condicional y no solamente un parámetro marginal. Para ello, se introduce un procedimiento de estimación general, denotado por $cal(A)_n$, que transforma la información muestral en una función estimada:

$
  hat(p)_(n, tau) = cal(A)_n (cal(D)_n), quad hat(p)_(n, tau): cal(X) -> [0, 1].
$ <ec-estimador-funcional>

La notación $cal(A)_n$ representa de manera abstracta el procedimiento completo de construcción del estimador, incluida la transformación $phi$ cuando esta se ajusta con los datos, sin restringirlo a una familia particular de modelos. Por tanto, la formulación comprende procedimientos estadísticos y algoritmos de aprendizaje automático que permitan producir estimaciones de probabilidad. Una parte importante de dichos procedimientos, como la regresión logística penalizada, los modelos aditivos generalizados y los métodos de potenciación del gradiente; puede expresarse como la minimización de un riesgo empírico penalizado sobre una clase de funciones $cal(F)$:

$
  hat(p)_(n, tau) = op("arg min", limits: #true)_(f in cal(F)) { 1/n sum_(i=1)^n L(f(bold(X)_i), Y_i^(tau)) + lambda J(f) },
$ <ec-riesgo-empirico>

donde el primer término es el riesgo empírico, es decir, la esperanza de la pérdida $L$ bajo la distribución empírica $hat(P)_n$; $L$ es una función de pérdida, como la pérdida logarítmica $L(s, y) = -y log s - (1 - y) log(1 - s)$; $J$ es un término que penaliza la complejidad de $f$, y $lambda >= 0$ es un hiperparámetro. Otros procedimientos, como los bosques aleatorios y los vecinos más cercanos agrupados, estiman $p_(tau)$ mediante promedios locales de la respuesta y se enmarcan en la regresión no paramétrica @kruppa2014ProbabilityEstimationMachine.

Debe distinguirse entre la función poblacional $p_(tau)$, que representa la probabilidad condicional verdadera, y su estimador $hat(p)_(n, tau)$, que es una función aleatoria porque depende de la muestra utilizada; para simplificar la notación, en lo que sigue se escribe $hat(p)$ en lugar de $hat(p)_(n, tau)$. La discrepancia entre ambas funciones se cuantifica mediante el error cuadrático de estimación

$
  e(hat(p)) = E_0[(hat(p) (bold(X)) - p_(tau)(bold(X)))^2],
$ <ec-error-estimacion>

donde $bold(X)$ corresponde a una obra nueva, independiente de la muestra empleada en la estimación. Un procedimiento se denomina consistente cuando dicho error tiende a cero a medida que $n$ crece ($n-> infinity$) @kruppa2014ProbabilityEstimationMachine. Dado que $p_(tau)$ es desconocida, este error no puede calcularse directamente; sin embargo, para una obra nueva con respuesta $Y^(tau)$, el desarrollo del cuadrado y la igualdad $E_0(Y^(tau) - p_(tau)(bold(X)) mid(|) bold(X)) = 0$ conducen a la descomposición

$
  E_0[(hat(p) (bold(X)) - Y^(tau))^2]
  = E_0[(hat(p) (bold(X)) - p_(tau)(bold(X)))^2]
  + E_0[p_(tau)(bold(X))(1 - p_(tau)(bold(X)))],
$ <ec-descomposicion-brier>

en la que el primer miembro es el valor esperado de la puntuación de Brier, el primer sumando es el error de estimación y el segundo es una varianza irreducible que no depende del estimador. En consecuencia, comparar procedimientos según su puntuación de Brier en datos no utilizados para el ajuste equivale a compararlos según su error de estimación de $p_(tau)$, lo que fundamenta el uso de dicha métrica como criterio principal de evaluación @gneiting2007StrictlyProperScoring @kruppa2014ProbabilityEstimationMachine.

*Formulación a nivel de datos observados.*

En la aplicación empírica, la muestra aleatoria se materializa en un conjunto específico de registros administrativos, denotado por

$
  d_n = {(bold(x)_i, y_i^(tau))}_(i=1)^n,
$ <ec-dataset-observado>

donde $bold(x)_i$ contiene los valores observados de las características de la obra $i$ y $y_i^(tau)$ representa el valor registrado de la variable de respuesta. En este nivel, $d_n$ representa una realización particular de la muestra aleatoria $cal(D)_n$, y el procedimiento de estimación produce una función específica a partir de los datos disponibles, $hat(p)_(n, tau) = cal(A)_n (d_n)$. Para una obra con características observadas $bold(x)_star$, la probabilidad estimada de experimentar una primera paralización contractual dentro del horizonte $tau$ se expresa como

$
  hat(p)_star = hat(p)_(n, tau)(bold(x)_star).
$ <ec-prediccion-individual>

El resultado $hat(p)_star in [0, 1]$ constituye una estimación individual del riesgo de paralización. Su interpretación es probabilística: expresa el valor estimado de la probabilidad condicional del evento para una obra con las características especificadas. Esta cantidad no debe confundirse con una clasificación dicotómica; la transformación de probabilidades estimadas en decisiones, mediante una regla $hat(Y)_c = bb(1)(hat(p)_star >= c)$ con un umbral $c in (0, 1)$, requiere criterios adicionales sobre los costos de los errores, los cuales corresponden a una etapa posterior de la investigación (sección 3.1.7).

*Consideraciones sobre la observación de la variable de respuesta.*

La construcción del conjunto de datos requiere distinguir entre la ausencia de una paralización registrada y la observación completa del horizonte definido. Sea $t_c$ la fecha de corte de la información y sea $delta$ el periodo mínimo sin avance físico que exige el criterio de la Contraloría General de la República para reconocer una paralización, igual a seis meses. Una paralización iniciada antes de $t_(0 i) + tau$ solo puede reconocerse con certeza hasta $t_(0 i) + tau + delta$; por consiguiente, el resultado de la obra $i$ en el horizonte $tau$ es plenamente observable cuando se dispone de seguimiento hasta dicho instante. Se define así la variable indicadora de observabilidad

$
  R_i^(tau) = bb(1)(t_(0 i) + tau + delta <= t_c),
$ <ec-indicador-observacion>

que toma el valor uno cuando el horizonte $tau$ de la obra $i$ es plenamente observable y cero en caso contrario.

Cuando $R_i^(tau) = 1$, la respuesta $Y_i^(tau)$ puede determinarse sin ambigüedad a partir de la trayectoria registrada de la obra. Cuando $R_i^(tau) = 0$, no corresponde asignar automáticamente el valor cero a la variable de respuesta: una obra que continúa en ejecución sin paralizaciones registradas no constituye necesariamente una observación negativa, pues su horizonte aún no ha transcurrido por completo. En términos del análisis de supervivencia, dichas obras están censuradas por la derecha en $t_c$.

Cabe destacar que $R_i^(tau)$ depende únicamente de la fecha de inicio de la obra y de la fecha de corte, y no del resultado. Si, en cambio, se incorporaran las obras recientes cuyo resultado ya se conoce —por haberse paralizado o concluido antes de completar el horizonte— y se excluyeran las que aún se encuentran en ejecución, la selección dependería del propio resultado: entre las cohortes recientes solo se incorporarían las obras con desenlace temprano, lo que sesgaría la estimación. Por ello, la muestra efectivamente utilizada para el aprendizaje supervisado es

$
  d_n^"obs" = {(bold(x)_i, y_i^(tau)) : R_i^(tau) = 1},
$ <ec-dataset-observable>

y la validez de los estimadores construidos sobre ella descansa en el supuesto de independencia condicional

$
  Y^(tau) perp R^(tau) mid(|) bold(X),
$ <ec-supuesto-mar>

según el cual, dadas las características, la observabilidad no aporta información sobre la respuesta. Este supuesto corresponde a una censura no informativa o, en la terminología de datos faltantes, a un mecanismo de pérdida aleatoria (_missing at random_) @little2019StatisticalAnalysisMissing. Dado que $R^(tau)$ depende solo de la fecha de inicio, el supuesto se cumple cuando la relación entre características y respuesta es estable entre cohortes, condición que la partición temporal permitirá examinar. Como extensión, los métodos de supervivencia con riesgos competitivos o la ponderación por la probabilidad inversa de censura permitirían aprovechar también la información parcial de las obras con $R_i^(tau) = 0$ @fine1999ProportionalHazardsModel @vock2016AdaptingMachineLearning; no obstante, dichos métodos exceden el diseño principal del presente plan.

Esta distinción adquiere especial importancia debido a que los registros históricos de INFObras contienen información sobre el estado de las obras y sus eventos de paralización en distintas fechas de corte. Además, la fecha de paralización registrada en una fotografía puede corresponder al evento más reciente y no necesariamente a la primera paralización ocurrida. Por consiguiente, la identificación de $T$, $C$ y $Y^(tau)$ deberá fundamentarse en reglas explícitas de reconstrucción histórica, elegibilidad y seguimiento, cuya definición operativa se desarrolla en el capítulo metodológico.

*Síntesis del problema de estimación.*

A partir de las definiciones anteriores, el problema fundamental de investigación consiste en construir, a partir de los datos observables $d_n^"obs"$, una función estimada

$
  hat(p)_(n, tau): cal(X) -> [0, 1]
$

que aproxime, con el menor error de estimación posible, la función poblacional desconocida

$
  p_(tau)(bold(x)) = "Pr"_0(T <= tau, C = 1 mid(|) bold(X) = bold(x)).
$ <ec-objetivo-fundamental>

Esta formulación establece el objeto matemático de la investigación sin imponer una metodología particular de estimación ni una arquitectura de modelo. En consecuencia, proporciona un fundamento común para la posterior comparación de modelos estadísticos y de aprendizaje automático, cuyo desempeño se valorará en primer término por la calidad de las probabilidades estimadas, así como para el análisis de los factores asociados a las estimaciones del riesgo de paralización.

=== 3.1.2 Modelos estadísticos basados en la inferencia

Este tipo de modelos de aprendizaje supervisado parte del supuesto de un modelo estocástico teórico de generación de los datos; los valores de sus parámetros se estiman a partir de los datos y el modelo resultante se utiliza para comprender las relaciones entre variables, realizar inferencias o efectuar predicciones @breiman2001StatisticalModelingTwo.

==== Regresión logística

Gran parte de la investigación reciente en aprendizaje automático se ha centrado en métodos no lineales; sin embargo, los métodos lineales suelen tener ventajas sobre sus competidores no lineales en términos de interpretabilidad y, en ocasiones, también de precisión @james2023IntroductionStatisticalLearning. Los modelos de regresión logística pueden presentarse de forma transparente, con información explicable sobre los efectos relativos de los predictores mediante razones de momios, nomogramas, tablas de puntuación y otras representaciones; tales presentaciones no son posibles para las técnicas de aprendizaje automático, aunque se han realizado esfuerzos en ese sentido @steyerberg2014RiskPredictionMachine.

Dado un problema con respuesta binaria, la regresión logística modela directamente la probabilidad condicional de pertenencia a una clase mediante una función lineal de las características, al mismo tiempo que garantiza que las probabilidades pertenezcan al intervalo $[0, 1]$ @james2023IntroductionStatisticalLearning. En términos de la formulación de la sección 3.1.1, el modelo tiene la forma

$ p_(tau)(bold(x)) = g(bold(z)' bold(beta)), quad "con" g(s) = 1 / (1 + e^(-s)), $ <reg-logistica>

donde $bold(z) = (1, z_1, z_2, ..., z_d)'$ es el vector de características transformadas $phi(bold(x))$ al que se antepone un término constante, $bold(beta) = (beta_0, beta_1, ..., beta_d)'$ es el vector de parámetros y $g$ es la función logística. Los parámetros se estiman por máxima verosimilitud, es decir, buscando los valores de $bold(beta)$ que maximizan la probabilidad de observar los datos, lo que equivale a minimizar la pérdida logarítmica de la @ec-riesgo-empirico con $lambda = 0$.

Para interpretar los coeficientes estimados se definen los momios (_odds_) como el cociente $hat(p) \/ (1 - hat(p))$, que mide cuántas veces es más probable que ocurra el evento de interés ($y = 1$) que no ocurra ($y = 0$). La razón de momios (_odds ratio_) se define como el cociente entre los momios de dos observaciones que difieren en una unidad de una característica, manteniendo constantes las demás; bajo el modelo logístico, dicho cociente es igual a $e^(beta_j)$ y se interpreta como el cambio relativo en los momios del evento asociado a un incremento unitario de la característica $z_j$.

Para obtener estimaciones consistentes, la regresión logística requiere un modelo especificado de forma completa y correcta; si el modelo está mal especificado, las estimaciones de probabilidad pueden estar sesgadas. Algunos ejemplos de especificación incorrecta consisten en ignorar las influencias no lineales de las variables independientes sobre el resultado o las interacciones entre ellas, inconvenientes inherentes al uso de modelos de regresión paramétricos @kruppa2014ProbabilityEstimationMachine.

==== Regresión logística penalizada

Para comparar el desempeño de los modelos paramétricos con el de los modelos de aprendizaje automático, #cite(<steyerberg2014RiskPredictionMachine>, form: "prose") recomiendan emplear enfoques penalizados de la regresión logística en lugar del ajuste tradicional, es decir, penalizaciones L1 (LASSO) o L2 (_ridge_), o bien enfoques bayesianos. En términos de la @ec-riesgo-empirico, la penalización corresponde a $J(f) = norm(bold(beta))_1$ en el caso de LASSO y a $J(f) = norm(bold(beta))_2^2$ en el caso de _ridge_; su combinación convexa se denomina red elástica (_elastic net_). La penalización L1 reduce los coeficientes y lleva algunos de ellos exactamente a cero, por lo que combina la selección de variables con la contracción de coeficientes y, al mismo tiempo, proporciona predicciones adecuadas @steyerberg2014RiskPredictionMachine. Dado que la regresión logística continúa siendo el enfoque de modelado predeterminado para la estimación de probabilidades en la predicción de riesgos @steyerberg2014RiskPredictionMachine, su versión penalizada se considera el modelo de referencia (línea base) del presente trabajo.

==== Modelo aditivo generalizado logístico

El supuesto de linealidad, en muchos casos, no constituye una buena aproximación @james2023IntroductionStatisticalLearning. Entre las alternativas para modelar la no linealidad se encuentran los _splines_ cúbicos restringidos @steyerberg2014RiskPredictionMachine, la regresión polinómica, las funciones escalonadas, la regresión local y los modelos aditivos generalizados @james2023IntroductionStatisticalLearning.

Los modelos aditivos generalizados (GAM, por sus siglas en inglés) proporcionan un marco general para extender un modelo lineal estándar al permitir funciones no lineales de cada una de las variables, manteniendo la aditividad @james2023IntroductionStatisticalLearning. Una forma natural de extender la regresión logística consiste en emplear un GAM con distribución binomial y enlace logit:

$ log( (p_(tau)(bold(x))) / (1 - p_(tau)(bold(x))) ) = beta_0 + f_1(z_1) + f_2(z_2) + dots + f_d (z_d), $ <ec-gam>

donde las $f_j$ son funciones suaves, representadas habitualmente mediante bases de _splines_ penalizados, en el caso de las variables numéricas, y términos lineales en el caso de las variables binarias resultantes de la codificación. La suavidad de cada $f_j$ se controla mediante un parámetro de penalización que se estima a partir de los datos @wood2017GeneralizedAdditiveModels. De este modo, el GAM conserva la interpretabilidad de la regresión logística —el efecto de cada variable puede visualizarse por separado— y, al mismo tiempo, relaja el supuesto de linealidad que puede sesgar las estimaciones de probabilidad.

=== 3.1.3 Modelos de aprendizaje automático

Este tipo de modelos de aprendizaje supervisado está orientado principalmente a la predicción de observaciones nuevas o futuras. Mientras que la teoría estadística se ha centrado en la estimación de modelos, la inferencia y el ajuste, el aprendizaje automático y la minería de datos se han concentrado en desarrollar algoritmos predictivos computacionalmente eficientes y en abordar el equilibrio entre sesgo y varianza para lograr una alta precisión predictiva @shmueli2010ExplainPredict. Para evitar los inconvenientes de la estimación de probabilidades basada en modelos paramétricos clásicos, pueden utilizarse enfoques de aprendizaje automático, que son esencialmente no paramétricos @kruppa2014ProbabilityEstimationMachine. Según la @ec-esperanza-condicional, la probabilidad condicional $p_(tau)(bold(x))$ coincide con la esperanza condicional $E_0(Y^(tau) mid(|) bold(X) = bold(x))$, de modo que su estimación constituye un problema de regresión no paramétrica con respuesta binaria. En consecuencia, toda máquina de aprendizaje que estime de manera consistente una función de regresión estima también de manera consistente la probabilidad condicional @kruppa2014ProbabilityEstimationMachine.

==== Métodos basados en árboles

Los árboles de decisión son simples y fáciles de interpretar, y constituyen buenos predictores, aunque no excelentes. Por otro lado, los enfoques basados en conjuntos de árboles, como el empaquetado (_bagging_), los bosques aleatorios, la potenciación (_boosting_) y los árboles de regresión aditivos bayesianos, combinan múltiples árboles para generar una única predicción de consenso y pueden obtener mejoras significativas en la precisión predictiva, a costa de producir un modelo difícil de interpretar @breiman2001StatisticalModelingTwo @james2023IntroductionStatisticalLearning. Los bosques aleatorios para la estimación de probabilidades utilizan árboles de estimación de probabilidad (PET, por sus siglas en inglés), que estiman la probabilidad de respuesta a partir de la proporción de casos positivos en cada nodo terminal; el uso de un conjunto de tales árboles conduce a mejores estimaciones de probabilidad que las de un único árbol de clasificación y regresión (CART) @kruppa2014ProbabilityEstimationMachine. El @algo-random-forest resume el procedimiento.

#figure(
  kind: "algorithm",
  supplement: [Algoritmo],
  pseudocode-list(booktabs: true,
  line-numbering: "1.",
  stroke: none,
  numbered-title: [Estimación de probabilidad mediante bosques aleatorios.],
  line-number-alignment: top + right)[El punto de partida es un conjunto de datos de entrenamiento con $n$ observaciones, y se construye un total de $"ntree" >= 1$ árboles.
  + Se extrae una muestra _bootstrap_ con reemplazo.
  + Se cultiva un PET utilizando un subconjunto aleatorio de variables con el error cuadrático medio (MSE) como criterio de optimización. Los nodos padres siempre tienen dos nodos hijos. Los PET no se podan. El tamaño del nodo terminal es fijo o ajustado.
  + Se determina la proporción de $1$ en cada nodo terminal.
  + Se hace descender a un sujeto a través de un solo PET, y la estimación de probabilidad específica del PET para dicho sujeto es la proporción de $1$ en el nodo terminal. La estimación de probabilidad del bosque aleatorio (RF) es el promedio de las probabilidades obtenidas de todos los árboles.
],
)<algo-random-forest>

==== Vecinos más cercanos agrupados

El estimador de los $k$ vecinos más cercanos ($k$-NN, por sus siglas en inglés) es un estimador de regresión no paramétrico que aproxima $p_(tau)(bold(x))$ mediante la proporción de casos positivos entre las $k$ observaciones de entrenamiento más próximas a $bold(x)$, y puede combinarse eficazmente con el empaquetado para mejorar su rendimiento, lo que da lugar a los vecinos más cercanos agrupados (b-NN). Una de las principales ventajas de estos procedimientos es su simplicidad, dado que solo requieren una medida de distancia en el espacio muestral y los datos de entrenamiento @kruppa2014ProbabilityEstimationMachine. El @algo-bnn resume el procedimiento.

#figure(
  kind: "algorithm",
  supplement: [Algoritmo],
  pseudocode-list(booktabs: true,
  line-numbering: "1.",
  stroke: none,
  numbered-title: [Estimación de probabilidad mediante el método de vecinos más cercanos agrupados (b-NN)],
  line-number-alignment: top + right)[Se considera un conjunto de datos de entrenamiento con $n$ observaciones y un número fijo $k$ de vecinos más cercanos.
  + Se extrae una muestra _bootstrap_ con reemplazo.
  + La distancia entre pares de observaciones se determina utilizando una métrica adecuada.
  + Se determina la proporción de $1$ entre los $k$ vecinos más cercanos de un punto en la muestra _bootstrap_.
  + La estimación de probabilidad del b-NN es la proporción de $1$ promediada sobre todas las muestras _bootstrap_.
],
)<algo-bnn>

Se ha demostrado que tanto el algoritmo RF como el b-NN producen estimaciones de probabilidad consistentes @kruppa2014ProbabilityEstimationMachine. Dado que el b-NN depende de una medida de distancia, sus resultados son sensibles a la escala de las variables, por lo que estas deben estandarizarse previamente.

==== Potenciación del gradiente

La potenciación del gradiente (_gradient boosting_) construye de manera secuencial un ensamble aditivo de árboles de decisión poco profundos: en cada iteración se ajusta un nuevo árbol al gradiente negativo de la función de pérdida evaluada en las predicciones vigentes, de modo que el ensamble desciende progresivamente sobre el riesgo empírico @friedman2001GreedyFunctionApproximation. Para la estimación de probabilidades, el ensamble produce una puntuación $F_(M)(bold(x)) = sum_(m=1)^M nu h_(m)(bold(x))$, donde $h_m$ es el árbol de la iteración $m$ y $nu in (0, 1]$ es la tasa de aprendizaje; dicha puntuación se transforma en probabilidad mediante la función logística, $hat(p) (bold(x)) = g(F_(M)(bold(x)))$, y el ensamble se ajusta minimizando la pérdida logarítmica de la @ec-riesgo-empirico. Las implementaciones XGBoost @chen2016XGBoostScalableTree, LightGBM @ke2017LightGBMHighlyEfficient y CatBoost @prokhorenkova2018CatBoostUnbiasedBoosting incorporan regularización explícita, estrategias eficientes de construcción de árboles y, en el caso de CatBoost, un tratamiento nativo de las variables categóricas que reduce el sesgo de la codificación supervisada. Estos algoritmos han mostrado un desempeño destacado en la predicción de retrasos de proyectos de construcción @alsulamy_predicting_2025; sin embargo, las probabilidades que producen los ensambles de árboles pueden apartarse de las frecuencias observadas, por lo que su calibración debe verificarse explícitamente @niculescu-mizil2005PredictingGoodProbabilities.

Dado que existen varias alternativas de máquinas de aprendizaje supervisado para la estimación de probabilidades y que ninguna resulta uniformemente superior, en las aplicaciones se emplea un conjunto de ellas y su rendimiento se compara en datos de prueba mediante la puntuación de Brier (_Brier score_) @kruppa2014ProbabilityEstimationMachine, criterio coherente con la descomposición de la @ec-descomposicion-brier.

=== 3.1.4 Clasificación desbalanceada

Conforme a lo señalado en el diagnóstico, la paralización por incumplimiento contractual afecta a una proporción minoritaria de las obras públicas (cerca del 7 % de las obras ejecutadas), por lo que se anticipa que la variable de respuesta presentará un desbalance de clases considerable. Cualquier conjunto de datos con una distribución desigual de clases se considera técnicamente desbalanceado; sin embargo, se dice que un conjunto de datos está desbalanceado cuando existe una desproporción significativa, o en algunos casos extrema, entre el número de ejemplos de cada clase. En los problemas de clasificación binaria, la clase minoritaria suele denominarse clase positiva, mientras que la clase mayoritaria se considera la negativa @fernandez_learning_2018. La mayoría de los algoritmos de aprendizaje automático para clasificación han sido diseñados y evaluados en problemas que asumen una distribución equilibrada de clases @brownlee2020ImbalancedClassificationPython. Además, el desbalance suele ir acompañado de costos de error asimétricos: el costo de una predicción incorrecta en un ejemplo de la clase positiva puede ser mucho mayor que el de una predicción incorrecta en un ejemplo de la clase negativa @huyen2022designing. En el contexto de la presente investigación, el costo de no detectar una obra en riesgo (falso negativo) supera al costo de supervisar una obra que finalmente no se paraliza (falso positivo).

Existen diversas estrategias para abordar el desbalance de clases, que pueden agruparse en tres categorías @huyen2022designing:

+ El uso de métricas de evaluación apropiadas.
+ Los métodos a nivel de datos, como el remuestreo mediante sobremuestreo o submuestreo.
+ Los métodos a nivel de algoritmo, como el aprendizaje sensible al costo mediante la ponderación de clases.

En un problema de estimación de riesgo, la elección entre estas estrategias no es neutral. Tanto el remuestreo como la ponderación de clases modifican la distribución con la que se ajusta el modelo y, en consecuencia, la función que este estima. En particular, si las observaciones positivas y negativas se ponderan con pesos $w_1$ y $w_0$, un procedimiento consistente no estima $p_(tau)(bold(x))$, sino la probabilidad ponderada

$ p_(tau)^(w)(bold(x)) = (w_1 p_(tau)(bold(x))) / (w_1 p_(tau)(bold(x)) + w_0 (1 - p_(tau)(bold(x)))), $ <ec-prob-ponderada>

cuyos momios son $w_1 \/ w_0$ veces los momios verdaderos. Con la ponderación balanceada usual, $w_c = n \/ (2 n_c)$, donde $n_c$ es el número de observaciones de la clase $c$, dicho factor es igual a $n_0 \/ n_1$, que en un problema con 7 % de casos positivos supera a 13. Por ello, las probabilidades obtenidas con ponderación deben corregirse antes de interpretarse como riesgo, invirtiendo la relación anterior:

$ hat(p) (bold(x)) = (w_0 hat(p)^(w)(bold(x))) / (w_0 hat(p)^(w)(bold(x)) + w_1 (1 - hat(p)^(w)(bold(x)))). $ <ec-correccion-prior>

En el caso de la regresión logística, esta corrección equivale a restar $ln(w_1 \/ w_0)$ del intercepto estimado, de manera análoga a la corrección previa (_prior correction_) propuesta para muestras con sobrerrepresentación de eventos raros @king2001LogisticRegressionRare. Alternativamente, la recalibración posterior descrita en la sección 3.1.7 permite corregir esta distorsión de forma empírica.

=== 3.1.5 Particionamiento y validación de modelos

La evaluación de modelos implica utilizar el conjunto de datos disponible para ajustar un modelo y estimar su rendimiento al realizar predicciones sobre ejemplos no vistos. Para ello, el conjunto de datos global se particiona en dos subconjuntos, denominados conjunto de entrenamiento y conjunto de prueba. Los dos enfoques más comunes para la evaluación de modelos son la división entrenamiento-prueba y el procedimiento de validación cruzada de $k$ iteraciones @brownlee2020ImbalancedClassificationPython. La validación cruzada de diez iteraciones, en particular, es el método de estimación del error más utilizado en el aprendizaje automático; sin embargo, puede fallar en presencia de desbalance de clases, incluso si este no es extremo, por lo que en tales casos se recomienda la validación cruzada estratificada, que preserva en cada partición la proporción de ejemplos positivos y negativos de la distribución original @he2013ImbalancedLearningFoundations.

Ambos procedimientos suponen, no obstante, que las observaciones son intercambiables, es decir, que su orden carece de relevancia. Esta condición no se cumple cuando la distribución de los datos cambia en el tiempo o cuando las características se construyen a partir de la historia previa de cada observación, como ocurre en el presente estudio según la sección 3.1.1. En tales casos, una partición aleatoria permite que el modelo se ajuste con observaciones posteriores a las que se evalúan, lo que produce estimaciones optimistas del desempeño. La alternativa consiste en la validación temporal, en la que el conjunto de prueba está formado por las observaciones más recientes y la validación cruzada se realiza con orígenes sucesivos: en cada pliegue, el modelo se ajusta con las observaciones anteriores a un instante de corte y se evalúa con las inmediatamente posteriores @hyndman2021ForecastingPrinciplesPractice. Dado que esta modalidad no permite estratificar libremente, el tamaño de cada bloque de validación debe garantizar un número suficiente de casos positivos. Cuando, además, se seleccionan hiperparámetros, la validación cruzada anidada separa un bucle interno, destinado a la selección, de un bucle externo, destinado a estimar el desempeño, de modo que ninguna observación se utilice simultáneamente para ambos fines.

=== 3.1.6 Métricas de evaluación

Uno de los principios rectores del aprendizaje automático establece que los buenos modelos deben tener un buen rendimiento con datos no vistos @deisenroth2020MathematicsMachineLearning, lo que exige definir métricas de rendimiento acordes con las características del problema. En los problemas de clasificación, las métricas implican comparar la etiqueta de clase esperada con la etiqueta predicha o interpretar las probabilidades predichas para cada clase. Cuando la distribución de clases está sesgada, las métricas estándar se vuelven poco fiables o incluso engañosas @brownlee2020ImbalancedClassificationPython. En la predicción de riesgos, la evaluación debe demostrar dos propiedades: la calibración, entendida como la concordancia entre las probabilidades estimadas y las frecuencias observadas, y la discriminación, entendida como la capacidad del modelo para diferenciar entre clases @kruppa2012RiskEstimationRisk. Las métricas para problemas de clasificación pueden dividirse en tres grupos @brownlee2020ImbalancedClassificationPython:

/ Métricas de umbral: cuantifican los errores de la clasificación una vez fijado un umbral de decisión y se utilizan cuando se busca minimizar el número de errores. Comprenden la exactitud (_accuracy_), el error de clasificación, la sensibilidad y la especificidad, la precisión y la exhaustividad (_precision_ y _recall_) y la medida $F_beta$.

/ Métricas de ordenamiento: evalúan la eficacia de un modelo para separar las clases a partir de una puntuación o probabilidad, considerando todos los umbrales posibles. Comprenden la curva ROC, construida a partir de las tasas de verdaderos y falsos positivos, y la curva de precisión-exhaustividad (curva PR), junto con las áreas bajo dichas curvas.

/ Métricas probabilísticas: cuantifican la calidad de las probabilidades estimadas y son útiles cuando el interés recae en la incertidumbre de las predicciones. Su uso requiere que las probabilidades estén calibradas @brownlee2020ImbalancedClassificationPython: el riesgo estimado promedio debe coincidir con la proporción de casos que efectivamente presentan el evento, idealmente tanto en la población total como en los subgrupos relevantes @kruppa2012RiskEstimationRisk. Comprenden la pérdida logarítmica (_log loss_), la puntuación de Brier y la puntuación de habilidad de Brier (_Brier skill score_).

La @taxonomia-metricas resume la taxonomía de métricas pertinentes para un problema de clasificación desbalanceada como el que ocupa a este estudio.

#figure(
  image("./assets/figures/img_metricas_clasificacion_desbalanceada.png", width: 90%),
  caption: [Taxonomía de métricas para clasificación desbalanceada @brownlee2020ImbalancedClassificationPython],
) <taxonomia-metricas>

Dado que el producto de interés es una estimación del riesgo y no únicamente una etiqueta, las métricas probabilísticas constituyen el criterio principal de evaluación, complementadas por las métricas de ordenamiento y de umbral. Para un conjunto de evaluación de $m$ obras con probabilidades estimadas $hat(p)_i$ y resultados observados $y_i$, se emplearán las siguientes métricas:

/ Puntuación de Brier: promedio de las diferencias al cuadrado entre la probabilidad estimada y el resultado observado @kruppa2012RiskEstimationRisk. Es una regla de puntuación propia, es decir, su valor esperado se minimiza cuando las probabilidades estimadas coinciden con las verdaderas @gneiting2007StrictlyProperScoring, y, según la @ec-descomposicion-brier, sus diferencias entre modelos reflejan diferencias en el error de estimación de $p_(tau)$. Su versión relativa, la puntuación de habilidad de Brier, compara el modelo con un estimador de referencia que asigna a todas las obras la proporción observada $hat(pi)$, mediante $"BSS" = 1 - "BS" \/ "BS"_"ref"$, de modo que los valores positivos indican una mejora respecto de dicha referencia.

$ "BS" = 1/m sum_(i=1)^m (hat(p)_i - y_i)^2 $ <ec-brier>

/ Pérdida logarítmica: regla de puntuación propia que penaliza con mayor severidad las probabilidades cercanas a cero asignadas a eventos que finalmente ocurren @gneiting2007StrictlyProperScoring.

$ "LL" = -1/m sum_(i=1)^m [y_i log hat(p)_i + (1 - y_i) log(1 - hat(p)_i)] $ <ec-logloss>

/ Calibración: un estimador está perfectamente calibrado cuando $"Pr"_0(Y^(tau) = 1 mid(|) hat(p) (bold(X)) = s) = s$ para todo $s in [0, 1]$. La calibración se evaluará gráficamente mediante la curva de calibración, que contrasta la probabilidad estimada media con la frecuencia observada en grupos de obras, y numéricamente mediante el modelo de recalibración logística $op("logit") Pr(Y^(tau) = 1) = a + b op("logit")(hat(p))$, cuyo intercepto ideal es $a = 0$ y cuya pendiente ideal es $b = 1$; una pendiente menor que uno indica probabilidades excesivamente extremas, propias del sobreajuste @vancalster2019CalibrationAchillesHeel @steyerberg2019ClinicalPredictionModels.

/ Áreas bajo las curvas ROC y PR: el área bajo la curva ROC equivale a la probabilidad de que una obra positiva elegida al azar reciba una probabilidad estimada mayor que una obra negativa elegida al azar, $"AUC" = Pr(hat(p) (bold(X)_1) > hat(p) (bold(X)_0))$; su valor es $0.5$ para un ordenamiento aleatorio y se relaciona con el coeficiente de Gini mediante $G = 2 "AUC" - 1$. Bajo un desbalance marcado, el área bajo la curva PR resulta más informativa, dado que se centra en la clase positiva y su valor de referencia para un ordenamiento aleatorio es igual a la prevalencia $pi_tau$ @brownlee2020ImbalancedClassificationPython.

Adicionalmente, dado que en el presente problema el costo de no supervisar una obra que llega a paralizarse (falso negativo) es mayor que el de supervisar una obra que no se paraliza (falso positivo), la regla de decisión derivada de las probabilidades se evaluará con métricas de umbral que otorgan mayor importancia a la clase positiva @brownlee2020ImbalancedClassificationPython:

/ Precisión y exhaustividad: la precisión resume la fracción de ejemplos asignados a la clase positiva que realmente pertenecen a ella, mientras que la exhaustividad (_recall_) resume qué tan bien se identifica la clase positiva y coincide con la sensibilidad. El uso de la exhaustividad es adecuado cuando el objetivo es minimizar los falsos negativos. Si VP, FP y FN denotan el número de verdaderos positivos, falsos positivos y falsos negativos, respectivamente, se tiene:

$ "Precisión" = "VP" / ("VP" + "FP") $

$ "Exhaustividad" = "VP" / ("VP" + "FN") $

/ Medida $F_beta$: combina la precisión y la exhaustividad en una sola medida, mediante una media armónica cuyo equilibrio está controlado por un coeficiente $beta$, y constituye una métrica muy utilizada en la clasificación desbalanceada. Cuando los falsos negativos son más importantes, se prefiere la medida $F$ con $beta = 2$, criterio apropiado cuando el costo de no detectar una obra en riesgo supera al costo de supervisar una obra que finalmente no se paraliza.

$ F_beta = ((1 + beta^2) dot "Precisión" dot "Exhaustividad") / (beta^2 dot "Precisión" + "Exhaustividad") $

=== 3.1.7 Calibración de probabilidades y umbral de decisión

El enfoque en la estimación de probabilidades puede requerir que las probabilidades producidas por algunos modelos se calibren antes de utilizarse o evaluarse. Algunos modelos aprenden probabilidades calibradas como parte de su entrenamiento, como la regresión logística ajustada por máxima verosimilitud sin ponderación @brownlee2020ImbalancedClassificationPython, mientras que otros, como los ensambles de árboles o los modelos ajustados con ponderación de clases, pueden producir probabilidades distorsionadas @niculescu-mizil2005PredictingGoodProbabilities. La recalibración posterior consiste en ajustar, sobre datos no utilizados en el entrenamiento, una función monótona $h: [0, 1] -> [0, 1]$ tal que $h(hat(p) (bold(x)))$ se aproxime a $p_(tau)(bold(x))$. Los dos métodos más empleados son el escalado de Platt, que ajusta una regresión logística sobre la puntuación del modelo, y la regresión isotónica, que estima una función escalonada no decreciente sin supuestos paramétricos y requiere un mayor volumen de datos @niculescu-mizil2005PredictingGoodProbabilities. Dado que la recalibración se ajusta con datos, forma parte del procedimiento de estimación $cal(A)_n$ y debe realizarse sobre un bloque temporal de validación distinto del conjunto de prueba.

Una vez obtenidas probabilidades adecuadas, la decisión de convertir una probabilidad en una etiqueta de clase se rige por un parámetro denominado umbral de decisión, umbral de discriminación o, simplemente, umbral. Casi todos los clasificadores generan predicciones positivas o negativas aplicando un umbral a una puntuación, y la elección de este umbral incide directamente en las clases predichas @fernandez_learning_2018. En los problemas con un desbalance de clases grave, el umbral predeterminado de 0.5 puede dar lugar a un rendimiento deficiente, dado que no necesariamente representa una interpretación óptima de las probabilidades estimadas; por ello, un enfoque simple y directo para mejorar el desempeño de la regla de decisión consiste en ajustar el umbral utilizado para asignar las probabilidades a las etiquetas de clase @brownlee2020ImbalancedClassificationPython. Si se denotan por $c_"FN"$ y $c_"FP"$ los costos de un falso negativo y de un falso positivo, respectivamente, y las probabilidades están bien calibradas, la regla que minimiza el costo esperado clasifica una obra como positiva cuando $hat(p) >= c^* = c_"FP" \/ (c_"FP" + c_"FN")$; en ausencia de una cuantificación explícita de dichos costos, el umbral puede seleccionarse maximizando una métrica como $F_2$ en un bloque de validación. Cabe subrayar que el ajuste del umbral modifica únicamente las métricas de decisión y no altera las probabilidades estimadas ni, por tanto, la puntuación de Brier, la pérdida logarítmica o las áreas bajo las curvas ROC y PR.

=== 3.1.8 Interpretabilidad e inteligencia artificial explicable

La adopción institucional de un modelo de estimación de riesgo requiere que sus resultados puedan explicarse a los tomadores de decisión. En los modelos estadísticos, la interpretación se obtiene directamente de los coeficientes, expresados como razones de momios, o de las funciones suaves del GAM. En los modelos de aprendizaje automático, en cambio, la interpretación requiere técnicas posteriores al ajuste, que pueden ser globales, cuando describen el comportamiento del modelo en su conjunto, o locales, cuando explican una estimación individual.

Entre las técnicas globales, la importancia por permutación mide el deterioro de una métrica de desempeño cuando se permutan aleatoriamente los valores de una característica en datos no utilizados para el ajuste, lo que rompe su asociación con la respuesta @breiman2001RandomForests. Entre las técnicas locales, los valores SHAP (_SHapley Additive exPlanations_) asignan a cada característica una contribución $phi_(j)(bold(x))$ basada en los valores de Shapley de la teoría de juegos cooperativos, de modo que la estimación de una obra se descompone de forma aditiva como

$ f(bold(x)) = phi_0 + sum_(j=1)^q phi_(j)(bold(x)), $ <ec-shap>

donde $f$ es la salida del modelo, expresada en escala de probabilidad o de logaritmo de los momios, y $phi_0 = E[f(bold(X))]$ es su valor medio @lundberg_unified_2017. Esta propiedad permite explicar, para cada obra, qué características incrementan o reducen su riesgo estimado respecto del promedio; asimismo, la agregación de los valores absolutos de $phi_j$ sobre el conjunto de obras proporciona una medida global de importancia.

En síntesis, para operacionalizar el procedimiento de estimación $cal(A)_n$, el plan de tesis contempla la comparación de dos familias de modelos complementarias, cuya pertinencia se sustenta en la revisión de la literatura expuesta en los antecedentes bibliográficos. Por un lado, se consideran modelos estadísticos interpretables como la regresión logística penalizada y el modelo aditivo generalizado logístico; cuyos coeficientes o funciones suaves admiten una lectura directa en términos de razones de momios. Por otro lado, se incorporan algoritmos de aprendizaje automático no paramétricos como los bosques aleatorios, vecinos más cercanos agrupados y ensambles de potenciación del gradiente; que han evidenciado en la literatura una capacidad discriminativa superior a la de un modelo lineal base en la predicción de retrasos y paralizaciones @gondia_machine_2020 @alsulamy_predicting_2025 @nnaemeka_egwim_applied_2021. La comparación entre ambas familias no se restringe a una única métrica de clasificación, sino que se estructura en cuatro dimensiones: calibración, discriminación, decisión a un umbral operativo e interpretabilidad.

== 3.2 Definición de Términos

/ Inversión pública: Aplicación de recursos públicos destinada a la creación, ampliación, mejoramiento o recuperación de la capacidad productora de bienes y servicios, orientada al cierre de brechas de infraestructura o de acceso a servicios públicos (Ministerio de Economía y Finanzas, Invierte.pe).
/ Proyecto de inversión: Intervención temporal que utiliza recursos públicos para crear, ampliar, mejorar o recuperar la capacidad de producción de bienes o servicios públicos, cuyos beneficios se generan durante su vida útil (Ministerio de Economía y Finanzas, Invierte.pe).
/ Obra pública: Toda construcción, reconstrucción, remodelación, demolición o mantenimiento ejecutado con recursos públicos, destinada a la prestación de servicios públicos o al cumplimiento de fines del Estado (Contraloría General de la República).
/ Ejecución contractual: Etapa del proceso de contratación que se inicia con la suscripción del contrato y culmina con su liquidación, en la cual las partes cumplen las obligaciones y prestaciones pactadas @mef_ley_32069_2024.
/ Incumplimiento contractual: Se configura cuando el contratista no ejecuta, total o parcialmente, las obligaciones asumidas en el contrato, conforme a las condiciones, plazos y especificaciones establecidas @mef_reglamento_32069_2024.
/ Resolución de contrato: Acto mediante el cual la entidad o el contratista pone fin al vínculo contractual por la ocurrencia de causales expresamente previstas en la normativa vigente @mef_reglamento_32069_2024.
/ Paralización de obra: Obra pública que ha interrumpido su ejecución física por un periodo determinado, debido a causas técnicas, contractuales, legales, económicas o administrativas (Contraloría General de la República).
/ Expediente técnico: Conjunto de documentos que contienen la descripción técnica, económica y financiera necesaria para la ejecución de una obra pública (Ministerio de Economía y Finanzas, Invierte.pe).
/ Avance físico: Porcentaje de ejecución de una obra respecto del total programado, medido en función de las partidas ejecutadas (Contraloría General de la República, INFObras).
/ Avance financiero: Nivel de ejecución del gasto asociado a una obra pública en relación con el presupuesto asignado (Contraloría General de la República, INFObras).
/ Riesgo: Efecto de la incertidumbre sobre los objetivos (ISO 31000:2018).
/ Riesgo de paralización: Definición operativa de riesgo adoptada en el estudio; corresponde a la probabilidad condicional $p_(tau)(bold(x))$ de que una obra experimente su primera paralización por incumplimiento contractual dentro del horizonte $tau$, dadas las características conocidas al inicio de su ejecución (@ec-proba-condicional).
/ Horizonte de estimación: Intervalo de tiempo $tau$, contado desde el inicio de la ejecución de la obra, al que se refiere la estimación del riesgo de paralización.
/ Calibración: Concordancia entre las probabilidades estimadas por un modelo y las frecuencias observadas del evento.
/ Discriminación: Capacidad de un modelo para asignar probabilidades mayores a las obras que se paralizan que a las obras que no se paralizan.
/ Fuga de información: Incorporación, en el ajuste de un modelo, de información que no estaría disponible en el momento de la predicción, lo que produce estimaciones optimistas del desempeño (_data leakage_).
/ INFOBRAS (Aplicativo): Es un sistema de información que integra la información registrada por las entidades públicas de los tres niveles de gobierno: nacional, regional y local; y la información extraída de los sistemas de información tales como el Banco de Proyectos (INVIERTE.pe), el Sistema Integrado de Administración Financiera (SIAF) y el Sistema Electrónico de Contrataciones del Estado (SEACE) en la ejecución de las obras públicas, a través del registro, articulación y publicación de información por parte de las entidades que las gestionan @SistemaInformacionObras.

= Capítulo IV. Metodología

== 4.1 Tipo de Investigación

La investigación se clasifica como aplicada, en la medida en que se orienta a la solución de un problema concreto de gestión pública el cual es la anticipación del riesgo de paralización de obras; mediante la utilización y adaptación de técnicas existentes de aprendizaje estadístico y automático, antes que a la generación de conocimiento teórico como tal. Asimismo, adopta un enfoque cuantitativo, dado que se sustenta en el análisis sistemático de datos numéricos y categóricos extraídos de registros administrativos oficiales.

== 4.2 Nivel de Investigación

El estudio se sitúa en un nivel explicativo-predictivo. Es explicativo en tanto busca identificar y comprender los factores institucionales, geográficos, presupuestales y contractuales asociados a la paralización de obras; y es predictivo en la medida en que dicha comprensión se traduce en un modelo capaz de estimar, de manera anticipada, la probabilidad de paralización de una obra a partir de información disponible al inicio de su ejecución.

== 4.3 Métodos de Trabajo

La propuesta de solución se organiza en siete módulos secuenciales, articulados en una canalización (_pipeline_) reproducible: (i) adquisición de datos desde fuentes oficiales; (ii) carga a una capa de almacenamiento intermedio (_staging_); (iii) preparación y limpieza de los datos; (iv) análisis exploratorio; (v) ingeniería de características; (vi) entrenamiento de modelos; y (vii) comparación y selección del modelo de mejor desempeño. Esta estructura modular garantiza la trazabilidad completa del proceso, desde los datos crudos hasta el modelo final, y facilita tanto la reproducibilidad de los experimentos como el versionamiento de los artefactos generados en cada etapa.

== 4.4 Población y Muestra

La población de estudio está constituida por el universo de obras públicas registradas en los sistemas administrativos oficiales del Estado peruano, en particular el Banco de Inversiones del Ministerio de Economía y Finanzas (registra aproximadamente 250,000 proyectos de inversión) y el sistema INFObras de la Contraloría General de la República. Sobre dicha población se aplicarán los criterios de delimitación descritos en la sección 1.2.3.2, referidos a la modalidad de ejecución por contrata, la existencia de una fecha de inicio de obra registrada y la vinculación a un código de inversión válido. La muestra definitiva de trabajo se determinará como resultado de la aplicación sucesiva de dichos filtros durante la etapa de adquisición e integración de datos (sección 4.8), por lo que su tamaño exacto constituye un resultado del estudio y no un dato de partida. Asimismo, conforme a la @ec-indicador-observacion, solo integrarán el conjunto de modelado las obras cuyo horizonte de estimación sea plenamente observable a la fecha de corte de la información, criterio que depende únicamente de la fecha de inicio de cada obra y no de su resultado. No obstante, en atención a la magnitud del fenómeno reportada en el Diagnóstico, se anticipa que la variable objetivo mantendrá un desbalance de clases considerable, lo que orienta desde ya la necesidad de las estrategias específicas de tratamiento que se detallan en la sección 4.7.

== 4.5 Tipo de Diseño

Se adopta un diseño factorial experimental, orientado a evaluar de manera sistemática el efecto de distintos factores sobre la calidad de las probabilidades estimadas y sobre el desempeño de la regla de decisión derivada de ellas. La @tabla-factores-independientes y la @tabla-factores-dependientes presentan, respectivamente, los factores independientes manipulados y las métricas dependientes observadas.

#figure(
  table(
    columns: 3,
    align: (left + horizon, center + horizon, left + horizon),
    table.header([*Factor*], [*Código*], [*Descripción*]),
    [Algoritmo de estimación], [A], [Familia de modelo estadístico o de aprendizaje automático],
    [Tratamiento del desbalance], [W], [Ponderación de clases con corrección de las probabilidades],
    [Optimización de hiperparámetros], [T], [Búsqueda sistemática de hiperparámetros con validación temporal],
    [Optimización de umbral], [U], [Ajuste del umbral de decisión sobre las probabilidades estimadas],
  ),
  caption: [Variables independientes del diseño factorial],
) <tabla-factores-independientes>

#figure(
  table(
    columns: (3.4cm, auto, auto, 1fr, auto),
    align: (left + horizon, center + horizon, left + horizon, left + horizon, center + horizon),
    table.header([*Métrica*], [*Código*], [*Dimensión*], [*Descripción*], [*Prioridad*]),
    [Puntuación de Brier], [BS], [Probabilística], [Error cuadrático medio entre la probabilidad estimada y el resultado observado], [Alta],
    [Intercepto y pendiente de calibración], [CAL], [Probabilística], [Desviación entre las probabilidades estimadas y las frecuencias observadas], [Alta],
    [Pérdida logarítmica], [LL], [Probabilística], [Penalización logarítmica de la probabilidad asignada al resultado observado], [Media],
    [PR-AUC], [PRA], [Ordenamiento], [Área bajo la curva de precisión-exhaustividad], [Alta],
    [ROC-AUC], [ROC], [Ordenamiento], [Área bajo la curva ROC], [Media],
    [Exhaustividad (_recall_)], [REC], [Umbral], [Proporción de positivos correctamente detectados], [Alta],
    [Medida $F_2$], [F2], [Umbral], [Media armónica ponderada de precisión y exhaustividad ($beta = 2$)], [Alta],
    [Precisión], [PRE], [Umbral], [Proporción de predicciones positivas correctas], [Media],
    [Medida $F_1$], [F1], [Umbral], [Media armónica equilibrada de precisión y exhaustividad], [Baja],
  ),
  caption: [Variables dependientes (métricas) del diseño factorial],
) <tabla-factores-dependientes>

Las métricas probabilísticas evalúan directamente el objeto de estimación definido en la sección 3.1.1 y constituyen, por ello, el criterio principal de comparación; las métricas de ordenamiento evalúan la capacidad del modelo para jerarquizar las obras según su riesgo, y las métricas de umbral evalúan la regla de decisión derivada, por lo que son las únicas que dependen del factor U.

Cada factor experimental toma un conjunto discreto de niveles, detallados en la @tabla-niveles-factores. El escalado de las variables numéricas no se considera un factor experimental, dado que los modelos basados en árboles son invariantes ante transformaciones monótonas de las variables; en su lugar, se aplica de forma obligatoria en los algoritmos sensibles a la escala (A1 y A4).

#figure(
  table(
    columns: 4,
    align: (left, center, center, left),
    table.header([*Factor*], [*Nivel*], [*Código*], [*Descripción*]),
    [A: Algoritmo], [1], [A1], [Regresión logística penalizada (línea base)],
    [A: Algoritmo], [2], [A2], [Modelo aditivo generalizado (GAM) logístico],
    [A: Algoritmo], [3], [A3], [Bosques aleatorios (_random forest_)],
    [A: Algoritmo], [4], [A4], [Vecinos más cercanos agrupados (b-NN)],
    [A: Algoritmo], [5], [A5], [XGBoost],
    [A: Algoritmo], [6], [A6], [LightGBM],
    [A: Algoritmo], [7], [A7], [CatBoost],
    [W: Desbalance], [0], [W0], [Sin ponderación de clases],
    [W: Desbalance], [1], [W1], [Ponderación balanceada con corrección de probabilidades (@ec-correccion-prior)],
    [T: _Tuning_], [0], [T0], [Hiperparámetros por defecto],
    [T: _Tuning_], [1], [T1], [Búsqueda aleatoria (50 iteraciones) con validación cruzada temporal, minimizando la puntuación de Brier],
    [U: Umbral], [0], [U0], [Umbral fijo (0.50)],
    [U: Umbral], [1], [U1], [Umbral que maximiza $F_2$ en la validación temporal],
  ),
  caption: [Niveles de los factores del diseño factorial],
) <tabla-niveles-factores>

Dado que el factor U no requiere reajustar el modelo, ambos niveles del umbral se evalúan sobre cada configuración ajustada. Con el propósito de mantener la viabilidad computacional del estudio, se define un diseño factorial fraccionado que, para cada algoritmo, considera tres configuraciones de ajuste: la configuración base (W0-T0), la configuración optimizada sin ponderación (W0-T1) y la configuración optimizada con ponderación (W1-T1). La comparación entre las dos primeras aísla el efecto de la optimización de hiperparámetros, y la comparación entre las dos últimas aísla el efecto de la ponderación de clases. La @tabla-matriz-experimentos presenta la matriz resultante, que comprende 21 configuraciones ajustadas y 42 combinaciones evaluadas.

#figure(
  table(
    columns: (1fr, auto, auto, auto),
    align: (left + horizon, center + horizon, center + horizon, center + horizon),
    table.header([*Algoritmo (A)*], [*Base (W0-T0)*], [*Optimizada (W0-T1)*], [*Ponderada (W1-T1)*]),
    [A1: Regresión logística penalizada], [E1: A1-W0-T0], [E2: A1-W0-T1], [E3: A1-W1-T1],
    [A2: GAM logístico], [E4: A2-W0-T0], [E5: A2-W0-T1], [E6: A2-W1-T1],
    [A3: Bosques aleatorios], [E7: A3-W0-T0], [E8: A3-W0-T1], [E9: A3-W1-T1],
    [A4: b-NN], [E10: A4-W0-T0], [E11: A4-W0-T1], [E12: A4-W1-T1],
    [A5: XGBoost], [E13: A5-W0-T0], [E14: A5-W0-T1], [E15: A5-W1-T1],
    [A6: LightGBM], [E16: A6-W0-T0], [E17: A6-W0-T1], [E18: A6-W1-T1],
    [A7: CatBoost], [E19: A7-W0-T0], [E20: A7-W0-T1], [E21: A7-W1-T1],
  ),
  caption: [Matriz de experimentos del diseño factorial fraccionado; cada configuración se evalúa con los umbrales U0 y U1],
) <tabla-matriz-experimentos>

//A partir de este diseño se derivan cuatro hipótesis experimentales que orientarán el análisis estadístico de los resultados. La primera (HE1) postula que el factor Algoritmo tiene un efecto significativo sobre la puntuación de Brier, de modo que existe al menos un algoritmo cuyo desempeño difiere del resto:
//H_0: mu_(A1) = mu_(A2) = ... = mu_(A7)
//frente a $H_1: exists i, j "tal que" mu_(A i) != mu_(A j)$. La segunda (HE2) postula que la ponderación de clases con corrección de probabilidades mejora las métricas de umbral sin deteriorar la puntuación de Brier ($H_0: mu_(W0) = mu_(W1)$ frente a $H_1: mu_(W0) != mu_(W1)$). La tercera (HE3) sostiene que la optimización de hiperparámetros mejora significativamente el desempeño respecto de los parámetros por defecto ($H_0: mu_(T0) = mu_(T1)$ frente a $H_1: mu_(T1) > mu_(T0)$). La cuarta (HE4) sostiene que la optimización del umbral de decisión mejora las métricas orientadas a la exhaustividad ($H_0: mu_(U0) = mu_(U1)$ frente a $H_1: mu_(U1) > mu_(U0)$). El contraste de estas hipótesis permitirá sustentar, con evidencia estadística y no solo descriptiva, las decisiones de diseño adoptadas en la configuración final del modelo.

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

El procedimiento de extracción se ejecutará mediante scripts semiautomatizados que descargan los archivos desde las fuentes oficiales, validan su integridad y los almacenan en una capa de datos crudos (_raw_) con su respectiva metadata de auditoría (fecha de descarga, fuente, versión). Posteriormente, un proceso de extracción, transformación y carga (ETL), desarrollado en Python con las bibliotecas `pandas` y `psycopg2`, migra los datos validados hacia una capa de almacenamiento intermedio (_staging_) en una base de datos relacional, preservando los registros tal como fueron recibidos y con mínimas transformaciones de formato. La integración final entre las tablas de _staging_ se realiza mediante operaciones de cruce que emplean como llaves el código único de inversión y el código Infobras, lo que permite consolidar un conjunto de datos único a partir de fuentes originalmente independientes.

== 4.7 Técnicas e Instrumentos de Análisis y Procesamiento de Datos

El procesamiento de los datos integrados comienza con la construcción de la variable de respuesta definida en la @ec-variable-respuesta. Para ello, se reconstruirá, a partir de las fotografías sucesivas de INFObras, la fecha y la causal de la primera paralización de cada obra, y se aplicará el criterio de observabilidad de la @ec-indicador-observacion; cuando para alguna obra solo se disponga de la fotografía más reciente, se documentará el supuesto adoptado y su posible efecto sobre la asignación de la respuesta. El horizonte $tau$ se fijará a partir de la distribución empírica de los tiempos hasta la primera paralización y de los plazos contractuales; como análisis de sensibilidad, el modelo seleccionado se reestimará con horizontes alternativos (por ejemplo, 12, 24 y 36 meses).

A continuación, se realizará el tratamiento de valores faltantes, mediante la exclusión de las variables con una proporción de nulos superior al umbral definido y la imputación de las variables restantes, con parámetros de imputación ajustados exclusivamente sobre el conjunto de entrenamiento. Asimismo, se aplicará un proceso de estandarización de catálogos que reduzca la cardinalidad de las variables categóricas de alta dispersión, como el departamento o la tipología de obra, mediante la construcción de catálogos maestros normalizados.

Sobre el conjunto de datos depurado, la ingeniería de características incorporará variables agregadas de naturaleza histórica, orientadas a capturar el desempeño previo de los actores institucionales involucrados, tal como se resume en la @tabla-caracteristicas-calculadas. Esta decisión se sustenta en la literatura de gestión de riesgos contractuales, en la que el historial de desempeño constituye un predictor relevante del comportamiento futuro. Para respetar la condición de disponibilidad temporal de la sección 3.1.1, cada característica histórica de la obra $i$ se calculará únicamente con las obras $j$ cuyo resultado ya era conocido al inicio de la obra $i$. Por ejemplo, la tasa de paralización de la entidad $e$ se define como

$ "tasa"_(e, i) = (sum_(j in cal(J)_(e, i)) y_j^(tau) + alpha hat(pi)_i) / (|cal(J)_(e, i)| + alpha), quad cal(J)_(e, i) = {j : e_j = e, thin t_(0 j) + tau + delta <= t_(0 i)}, $ <ec-tasa-historica>

donde $e_j$ es la entidad ejecutora de la obra $j$, $hat(pi)_i$ es la proporción global de paralización calculada con el mismo criterio temporal y $alpha > 0$ es un parámetro de suavizado que contrae la tasa hacia dicha proporción cuando la entidad registra pocas obras previas.

#figure(
  table(
    columns: 2,
    align: (left, left),
    table.header([*Característica*], [*Descripción*]),
    [`tasa_paralizacion_entidad`], [Proporción histórica suavizada de obras de la entidad contratante con paralización contractual (@ec-tasa-historica)],
    [`n_obras_x_entidad`], [Cantidad de obras iniciadas por la entidad antes del inicio de la obra],
    [`monto_viable_promedio_entidad`], [Monto viable promedio de los proyectos de inversión de la entidad registrados antes del inicio de la obra],
    [`tasa_paralizacion_departamento`], [Proporción histórica suavizada de obras con paralización contractual en el departamento, con el mismo criterio temporal],
    [`tasa_paralizacion_distrito`], [Proporción histórica suavizada de obras con paralización contractual en el distrito, con el mismo criterio temporal],
    [`tasa_paralizacion_tipo_obra`], [Proporción histórica suavizada de obras con paralización contractual según tipología de obra, con el mismo criterio temporal],
  ),
  caption: [Características calculadas incorporadas mediante ingeniería de variables],
) <tabla-caracteristicas-calculadas>

Todas las variables categóricas restantes se codificarán según su cardinalidad: codificación _one-hot_ para las variables de baja cardinalidad, y codificación por frecuencia y codificación supervisada (_target encoding_ con suavizado bayesiano y _Weight of Evidence_) para las variables de cardinalidad media o alta. Las transformaciones que se ajustan con los datos se integrarán en una única canalización (`Pipeline`) junto con el estimador, de modo que se reajusten en cada pliegue de validación y solo con el conjunto de entrenamiento correspondiente, lo que previene la fuga de información hacia los datos de evaluación. Con el propósito de reproducir el escenario de uso real del modelo, la partición de los datos en entrenamiento y prueba se realizará de forma temporal, ordenando las observaciones según su fecha de inicio de obra, tal como se ilustra en la @particion-temporal; esta estrategia evita que información del futuro se filtre hacia el pasado y permite estimar el desempeño del modelo bajo condiciones cercanas a su uso prospectivo.

#figure(
  image("./assets/figures/img_particion_temporal_train_test.png", width: 55%),
  caption: [Partición temporal de los datos en entrenamiento y prueba],
) <particion-temporal>

Respecto del desbalance de clases, se evaluará la ponderación de clases (factor W) en lugar de recurrir a técnicas de sobremuestreo o submuestreo que alteren artificialmente la proporción de clases observada. Dado que la ponderación modifica la función estimada (@ec-prob-ponderada), las probabilidades de los modelos ponderados se corregirán mediante la @ec-correccion-prior antes de su evaluación; además, para el modelo seleccionado se evaluará la recalibración posterior mediante el escalado de Platt o la regresión isotónica. Para la selección de modelos e hiperparámetros se empleará validación cruzada anidada que respete el orden temporal de las observaciones mediante particiones de tipo `TimeSeriesSplit`: un bucle externo de cinco pliegues, destinado a estimar el desempeño y su variabilidad, y un bucle interno de tres pliegues, destinado a la búsqueda de hiperparámetros, de modo que ninguna observación utilizada para seleccionar hiperparámetros en un pliegue sea empleada para evaluar ese mismo pliegue. El umbral U1 se seleccionará con las predicciones fuera de muestra de la validación temporal y se aplicará sin modificaciones al conjunto de prueba.

La comparación final entre modelos se realizará en el conjunto de prueba bajo las métricas de la @tabla-factores-dependientes, con prioridad para la puntuación de Brier y la calibración, y con el coeficiente de Gini como referencia adicional de discriminación. En atención a la dependencia entre obras de una misma entidad, la incertidumbre de las métricas se estimará mediante remuestreo _bootstrap_ por conglomerados de entidad ejecutora. Finalmente, la interpretación de los modelos seleccionados se apoyará en la importancia por permutación, los valores SHAP y, en el caso de los modelos estadísticos, en la lectura directa de sus coeficientes como razones de momios y en la visualización de las funciones suaves del GAM.

== 4.8 Etapas de Intervención del Estudio

+ *Revisión bibliográfica y marco normativo*: consolidación del estado del arte y de la normativa vigente en materia de contrataciones públicas.
+ *Adquisición e integración de datos*: extracción y consolidación de las fuentes oficiales descritas en la @tabla-fuentes-datos.
+ *Limpieza y estandarización*: tratamiento de valores faltantes, normalización de catálogos, reconstrucción histórica de la primera paralización y definición de la variable de respuesta.
+ *Análisis exploratorio de datos*: caracterización estadística univariada y bivariada del conjunto de datos integrado.
+ *Ingeniería de características*: construcción de variables agregadas históricas y codificación de variables categóricas.
+ *Entrenamiento y validación de modelos*: ejecución de la matriz de experimentos definida en el diseño factorial.
+ *Comparación e interpretación de modelos*: selección del modelo de mejor desempeño y aplicación de técnicas de inteligencia artificial explicable.
+ *Redacción del informe final*: consolidación de resultados, discusión y elaboración de conclusiones y recomendaciones.

= Capítulo V. Administración del Plan de Tesis

== 5.1 Cronograma

La ejecución del plan de tesis se proyecta sobre un horizonte de tres meses, desde la revisión bibliográfica y el marco normativo hasta la redacción del informe final. Las ocho etapas de intervención descritas en la sección 4.8 se distribuyen con actividades parcialmente superpuestas, tal como se detalla en la @cronograma.

#figure(
  table(
    columns: (1fr, auto, auto, auto),
    align: (left,) + (center,) * 3,
    table.header(
      [*Etapa*], [*Mes 1*], [*Mes 2*], [*Mes 3*],
    ),
    [1. Revisión bibliográfica y marco normativo], [X], [], [],
    [2. Adquisición e integración de datos], [X], [], [],
    [3. Limpieza y estandarización], [X], [X], [],
    [4. Análisis exploratorio de datos], [], [X], [],
    [5. Ingeniería de características], [], [X], [],
    [6. Entrenamiento y validación de modelos], [], [X], [X],
    [7. Comparación e interpretación de modelos], [], [], [X],
    [8. Redacción del informe final], [], [], [X],
  ),
  caption: [Cronograma de actividades del plan de tesis],
) <cronograma>

== 5.2 Presupuesto

#figure(
  table(
    columns: 3,
    align: (left, center, right),
    table.header([*Rubro*], [*Unidad / cantidad*], [*Costo estimado (S/)*]),
    [Recursos humanos (asesoría especializada)], [3 meses], [6,000.00],
    [Bienes: equipo de cómputo y licencias de software estadístico], [2 equipos], [3,500.00],
    [Servicios: cómputo en la nube y acceso a bases de datos], [3 meses], [1,800.00],
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

La @matriz-consistencia sintetiza la correspondencia entre los problemas identificados, los objetivos formulados y las hipótesis de trabajo que orientarán la investigación, en coherencia con lo desarrollado en los Capítulos I, II y IV.

// La matriz ocupa más de una página: se permite el corte del bloque y se usa
// interlineado simple, admitido en los anexos (formato 3.3).
#[
#show figure: set block(breakable: true)
#set par(leading: 0.5em, justify: false)
#figure(
  table(
    columns: (1fr, 1fr, 1fr),
    align: (left, left, left),
    table.header([*Problemas*], [*Objetivos*], [*Hipótesis*]),
    [
      *Problema General.* ¿En qué medida la implementación, evaluación y comparación de modelos de inteligencia artificial, utilizando registros administrativos de fuentes públicas oficiales bajo un enfoque de estimación probabilística supervisada con clases desbalanceadas, permite estimar cuantitativa y anticipadamente el riesgo de paralización de obras públicas en el Perú por incumplimiento contractual y obtener una herramienta predictiva, calibrada e interpretable que permita jerarquizar proyectos por nivel de riesgo y sustentar la toma de decisiones preventivas en la ejecución de inversiones?
    ],
    [
      *Objetivo General.* Implementar, evaluar y comparar modelos de inteligencia artificial para la estimación cuantitativa y anticipada de la probabilidad de paralización de obras públicas en el Perú por causal de incumplimiento contractual, utilizando registros administrativos de fuentes públicas oficiales bajo un enfoque de estimación probabilística supervisada con clases desbalanceadas, con la finalidad de obtener una herramienta predictiva, calibrada e interpretable que permita jerarquizar proyectos por nivel de riesgo y sustentar la toma de decisiones preventivas en la ejecución de inversiones.
    ],
    [
      *Hipótesis General.* Al menos uno de los modelos de inteligencia artificial considerados, ajustado con información disponible al inicio de la ejecución de las obras, estima la probabilidad de paralización por incumplimiento contractual con una puntuación de Brier inferior a la de un estimador de referencia que asigna a todas las obras la proporción histórica de paralización, y con una capacidad discriminativa superior a la de un ordenamiento aleatorio.
    ],
    [P1. ¿Qué factores de riesgo candidatos asociados a la paralización de obras por incumplimiento contractual se pueden identificar a partir de la literatura especializada, la normativa vigente y los registros administrativos de fuentes públicas oficiales?],
    [OE1. Identificar factores de riesgo candidatos asociados a la paralización de obras por incumplimiento contractual a partir de la literatura especializada, la normativa vigente y los registros administrativos de fuentes públicas oficiales.],
    [H1. Existen factores observables al inicio de la ejecución, identificables en la literatura, la normativa y los registros administrativos, que se asocian con la paralización de obras por incumplimiento contractual.],
    [P2. ¿Cómo recopilar, integrar y preparar los datos de fuentes públicas oficiales, incluyendo su limpieza, estandarización, control de calidad y la reconstrucción histórica de la variable de respuesta, para el estudio del riesgo de paralización por incumplimiento contractual?],
    [OE2. Implementar la recopilación, integración y preparación de los datos, incluyendo la limpieza, la estandarización, el control de calidad y la reconstrucción histórica de la variable de respuesta.],
    [H2. La integración de las fuentes oficiales permite reconstruir, para cada obra, la fecha y la causal de su primera paralización y obtener un conjunto de datos consistente para el horizonte de estimación definido.],
    [P3. ¿Cómo realizar el análisis exploratorio de datos y la ingeniería de características necesarios para obtener los conjuntos de datos de entrenamiento y de prueba destinados a la estimación del riesgo de paralización por incumplimiento contractual?],
    [OE3. Realizar un análisis exploratorio de datos y la ingeniería de características necesaria para la obtención del conjunto de datos de entrenamiento y de prueba.],
    [H3. Las características históricas calculadas exclusivamente con información anterior al inicio de cada obra aportan capacidad predictiva sin introducir fuga de información.],
    [P4. ¿Qué modelo estadístico o de aprendizaje automático presenta el mejor desempeño para estimar el riesgo de paralización por incumplimiento contractual, al comparar su ajuste, entrenamiento y evaluación bajo métricas de calibración, discriminación y decisión, y cuáles son sus hiperparámetros y condiciones de uso?],
    [OE4. Comparar modelos estadísticos y de aprendizaje automático mediante su ajuste, entrenamiento y evaluación bajo métricas de calibración, discriminación y decisión, con el propósito de seleccionar el candidato de mejor desempeño y documentar sus hiperparámetros y condiciones de uso.],
    [H4. Entre los modelos considerados, al menos uno presenta un desempeño superior a los demás en la estimación de la probabilidad de paralización, medido principalmente por la puntuación de Brier y la calibración.],
    [P5. ¿Cómo aplicar técnicas de inteligencia artificial explicable para interpretar el modelo a nivel agregado y por obra, identificar los factores determinantes del riesgo y establecer criterios de interpretación orientados a la toma de decisiones?],
    [OE5. Aplicar técnicas de inteligencia artificial explicable para generar interpretaciones del modelo a nivel agregado y por obra, identificando los factores determinantes del riesgo y estableciendo criterios de interpretación orientados a la toma de decisiones.],
    [H5. Las técnicas de inteligencia artificial explicable generan interpretaciones consistentes entre modelos y permiten establecer criterios claros para la toma de decisiones.],
  ),
  caption: [Matriz de consistencia del plan de tesis],
) <matriz-consistencia>
]
