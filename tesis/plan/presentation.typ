#import "@preview/touying:0.6.1": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "lib.typ": *

// =============================================================================
// Presentación del Plan de Tesis ante el asesor
// Contenido basado en: tesis/plan/main.typ
// Plantilla de formato: mead_project/presentacion/main.typ (tema tub-theme)
// =============================================================================

#set text(lang: "es")

#show: tub-theme.with(
  aspect-ratio: "16-9",
  department: [FIIS · Escuela de Posgrado · Maestría en Ciencias con Mención en Inteligencia Artificial],
  logo: image("assets/figures/logo-uni.png"),
  progress-bar: true,
  config-info(
    title: [Estimación anticipada de la probabilidad de paralización de obras públicas por incumplimiento contractual en el Perú mediante técnicas de Inteligencia Artificial],
    short-title: [Plan de Tesis · Riesgo de paralización de obras públicas],
    subtitle: [Presentación del Plan de Tesis al asesor — Samuel Oporto Díaz],
    author: [Yan Franco Calderón Félix · Hilber Alexander Cieza Delgado],
    date: datetime.today(),
    institution: [Universidad Nacional de Ingeniería],
  ),
  footer-a: [Calderón · Cieza],
)

// Tamaño base reducido: el plan es denso en tablas y fórmulas (el tema usa 20 pt).
#set text(size: 15pt)

// --- helpers para tablas --------------------------------------------------
// rt: primera columna a la izquierda, resto a la derecha (datos numéricos)
#let rt(cols, ..cells) = table(
  columns: cols,
  align: (col, row) => if col == 0 { left } else { right },
  inset: 6pt,
  stroke: 0.4pt + tub-gray,
  fill: (_, row) => if row == 0 { tub-light-gray },
  ..cells,
)

// lt: todo a la izquierda (texto)
#let lt(cols, inset: 6pt, ..cells) = table(
  columns: cols,
  align: left + horizon,
  inset: inset,
  stroke: 0.4pt + tub-gray,
  fill: (_, row) => if row == 0 { tub-light-gray },
  ..cells,
)

#title-slide()

#outline-slide()

// =========================================================================
= 1. Planteamiento del problema

== Diagnóstico: magnitud de las obras paralizadas

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [
    - A diciembre de 2024, la CGR registró *2,476 obras paralizadas* con un costo actualizado de *S/ 43,118.9 millones*.
    - El *72.0 %* en número corresponde a gobiernos locales; el impacto económico atraviesa todos los niveles y sectores.
    - La respuesta del Estado es *reactiva*: auditorías e intervenciones ocurren cuando el contrato ya se resolvió o el plazo venció.

    #v(0.2cm)
    #text(size: 0.78em)[
      #rt(
        (1fr, auto, auto),
        [*Nivel de gobierno*],
        [*N.° obras*],
        [*% N.° obras*],
        [Gobierno Local],
        [1,782],
        [72.0 %],
        [Gobierno Nacional],
        [384],
        [15.5 %],
        [Gobierno Regional],
        [310],
        [12.5 %],
        [*TOTAL*],
        [*2,476*],
        [*100 %*],
      )
    ]
  ],
  [
    #text(size: 0.72em)[
      #rt(
        (1fr, auto, auto, auto),
        [*Sector*],
        [*Costo (M S/)*],
        [*% costo*],
        [*N.° obras*],
        [Transportes y Comunic.],
        [11,597.9],
        [26.9 %],
        [715],
        [Vivienda, Const. y San.],
        [7,861.2],
        [18.2 %],
        [518],
        [Agricultura],
        [7,699.5],
        [17.9 %],
        [322],
        [Salud],
        [5,017.7],
        [11.6 %],
        [83],
        [Educación],
        [2,274.2],
        [5.3 %],
        [364],
        [Otros sectores],
        [8,668.4],
        [20.1 %],
        [474],
        [*TOTAL*],
        [*43,118.9*],
        [*100 %*],
        [*2,476*],
      )
    ]
  ],
)

#speaker-note[
  Iniciamos con el diagnóstico. Según el Informe de Obras Paralizadas de la Contraloría a diciembre de 2024, hay 2,476 obras paralizadas con un costo actualizado de más de 43 mil millones de soles. En cantidad predominan los gobiernos locales (72 %), pero en monto pesan los sectores de infraestructura pesada: Transportes, Vivienda y Agricultura. El vacío central es que la respuesta institucional es reactiva: se interviene después de que la paralización ya ocurrió.
]

== Representación y ciclo de estados de una obra

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [
    #align(center)[
      #image("assets/figures/img-representacion_obra_publica.png", width: 90%)
    ]
    #text(
      size: 0.72em,
    )[Inversión con componente de infraestructura ejecutada con participación del Estado (Invierte.pe / INFObras).]
  ],
  [
    #align(center)[
      #image("assets/figures/img_diagrama_estados_obra.png", width: 80%)
    ]
    #v(0.2cm)
    #align(center)[
      #text(size: 0.68em)[
        #diagram(
          node-stroke: 1pt + black,
          node-fill: rgb("f9f9f9"),
          spacing: (1.2cm, 1.0cm),
          node((0, 0), [Sin Ejecución], name: <S>, shape: "rect", inset: 6pt),
          node((1.4, 0), [En Ejecución], name: <E>, shape: "rect", inset: 6pt, stroke: 1.5pt + blue.darken(20%)),
          node((1.4, 1.2), [Paralizado], name: <P>, shape: "rect", inset: 6pt, stroke: 1pt + red.darken(10%)),
          node((2.8, 0), [Finalizado], name: <F>, shape: "rect", inset: 6pt, stroke: 2pt + green.darken(30%)),
          edge(<S>, <E>, "-|>", label: [Inicio]),
          edge(<E>, <P>, "-|>", bend: 25deg, label: [Paralización], label-side: right),
          edge(<P>, <E>, "-|>", bend: 25deg, label: [], label-side: right),
          edge(<E>, <F>, "-|>", label: [Recepción]),
        )
      ]
    ]
  ],
)

#speaker-note[
  Según el criterio de la CGR, una obra en ejecución física pasa a paralizada cuando no presenta avance físico por un mínimo de seis meses, o proviene de un contrato resuelto o declarado nulo. En INFObras esto se refleja en la transición «En Ejecución» → «Paralizado». Este umbral de seis meses reaparece después como el parámetro δ de la formulación matemática.
]

== Tipificación: el incumplimiento contractual como causal crítica

#grid(
  columns: (1.15fr, 0.85fr),
  gutter: 1em,
  [
    #text(size: 0.68em)[
      #rt(
        (1fr, auto, auto, auto, auto),
        [*Causal de paralización (CGR)*],
        [*Costo (M S/)*],
        [*% costo*],
        [*Obras*],
        [*% obras*],
        [*Incumplimiento de contrato*],
        [*15,913.4*],
        [*36.9 %*],
        [*628*],
        [*25.4 %*],
        [Discrepancias, controv. y arbitraje],
        [14,889.4],
        [34.5 %],
        [225],
        [9.1 %],
        [Deficiencia en expediente técnico],
        [3,217.8],
        [7.5 %],
        [271],
        [10.9 %],
        [Falta de recursos financ. y liquidez],
        [2,140.4],
        [5.0 %],
        [526],
        [21.2 %],
        [Conflictos sociales],
        [1,078.1],
        [2.5 %],
        [71],
        [2.9 %],
        [Eventos climáticos],
        [987.0],
        [2.3 %],
        [70],
        [2.8 %],
        [Incumpl. pago de valorizaciones],
        [951.8],
        [2.2 %],
        [71],
        [2.9 %],
        [Abandono de obra],
        [699.5],
        [1.6 %],
        [247],
        [10.0 %],
        [Otras causales],
        [3,241.5],
        [7.5 %],
        [367],
        [14.8 %],
        [*TOTAL*],
        [*43,118.9*],
        [*100 %*],
        [*2,476*],
        [*100 %*],
      )
    ]
  ],
  [
    *Categoría `CONTRACTUAL` (clase positiva, $C = 1$):*
    #v(0.15cm)
    #text(size: 0.66em)[
      #lt(
        (1fr, auto),
        [*Causal homologada*],
        [*Categoría*],
        [Incumplimiento de contrato],
        [CONTRACTUAL],
        [Proceso arbitral],
        [CONTRACTUAL],
        [Resolución de contrato],
        [CONTRACTUAL],
        [Discrepancias, controv. y arbitraje],
        [CONTRACTUAL],
        [Resolución contrato supervisión],
        [CONTRACTUAL],
        [Obra judicializada por la entidad],
        [CONTRACTUAL],
        [Incumpl. pago de valorizaciones],
        [CONTR. / FIN.],
      )
    ]
  ],
)

#speaker-note[
  El incumplimiento de contrato es simultáneamente la primera causal en número de obras (25.4 %) y la primera en costo inmovilizado (36.9 %, casi 16 mil millones de soles), seguida de controversias y arbitrajes (34.5 % del costo). Por eso delimitamos la variable objetivo agrupando siete causales de naturaleza contractual, imputables al contratista o a la entidad.
]

== Fenómeno multicausal y caracterización de los datos

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [
    #align(center)[
      #image("assets/figures/img_grafo_causal_paralizacion.png", width: 92%)
    ]
    #text(
      size: 0.72em,
    )[El incumplimiento contractual es un nodo articulado con otros factores técnicos, financieros y externos, no una causa aislada.]
  ],
  [
    #align(center)[
      #image("assets/figures/img_caracterizacion_obra_publica.png", width: 95%)
    ]
    #v(0.1cm)
    #align(center)[
      #image("assets/figures/img_distribucion_clases_general.png", width: 80%)
    ]
  ],
)

#speaker-note[
  El grafo jerárquico muestra que el incumplimiento contractual no es una causa aislada sino un nodo articulado con otras dimensiones del riesgo. A la derecha, las entidades de datos que caracterizan una obra y la distribución de clases, donde se aprecia el marcado desbalance: la paralización por incumplimiento es una fracción pequeña del total de obras.
]

== Problema de estudio

#highlight-box[
  La información administrativa disponible (historial de entidades y contratistas, ubicación, montos, plazos, modificaciones, acciones de control) *no se utiliza de forma sistemática* para construir predictores del riesgo de paralización.
]

#v(0.3cm)

- *Faltan alertas tempranas*: los gestores no cuentan con una lista priorizada de obras según su riesgo para orientar la supervisión y las acciones preventivas.
- *Estimar riesgo ≠ clasificar*: se busca una *probabilidad* condicional, no solo una etiqueta; la asignación a una clase es una decisión posterior con un umbral $c$:
  $ p_(tau)(bold(x)) = "Pr"(Y^(tau) = 1 mid(|) bold(X) = bold(x)), quad hat(Y) = bb(1)(hat(p)_(tau)(bold(x)) >= c) $
- *Desbalance de clases* (≈ 7 % positivos): exige métricas que midan calidad de las probabilidades *y* capacidad de identificar obras en riesgo.

#speaker-note[
  El problema no es la falta de datos sino su falta de uso sistemático. Lo que proponemos es estimar una probabilidad de paralización contractual dada la información disponible al inicio de la ejecución. Hacemos énfasis en la distinción entre estimar riesgo y clasificar: la clasificación es solo una regla derivada con un umbral que depende del costo relativo de los errores.
]

== Antecedentes bibliográficos y brecha de investigación

#text(size: 0.74em)[
  #lt(
    (auto, auto, 1fr, 1fr),
    [*Autor (Año)*],
    [*Contexto*],
    [*Enfoque / Modelos*],
    [*Hallazgo y relación con la tesis*],
    [Gondia et al. (2020)],
    [Egipto (51 proy., 59 factores)],
    [Árbol de Decisión vs. Naive Bayes (CV 10-fold)],
    [Los factores de riesgo permiten anticipar retrasos; Naive Bayes supera al árbol en muestra pequeña.],
    [Egwim et al. (2021)],
    [Infraestructura (datos reales)],
    [Comparación de ML; Random Forest y XGBoost],
    [Los ensambles de árboles resultan adecuados cuando se requiere interpretabilidad y capacidad de acción.],
    [Alsulamy (2025)],
    [Arabia Saudita (62 proy.)],
    [CatBoost, XGBoost y LightGBM con _tuning_],
    [LightGBM logra la mayor precisión en la predicción de retrasos.],
    [Solís-Villanueva (2018)],
    [Perú — Ley N.° 30225 (209 obras)],
    [Perceptrón multicapa (Levenberg-Marquardt), 10 indicadores],
    [Antecedente nacional en la etapa de selección del postor; no aborda la paralización durante la ejecución.],
    [Kruppa et al. (2012, 2014); Steyerberg (2014); Lundberg (2017)],
    [Estimación de riesgo y XAI],
    [Probabilidad condicional, Brier, GLM/GAM, PET/b-NN, SHAP],
    [Marco teórico para estimar probabilidades calibradas e interpretables.],
  )
]

#v(0.2cm)
#highlight-box[
  *Brecha:* los estudios previos se centran en exactitud clasificatoria sobre muestras pequeñas; no evalúan *calibración*, *censura / riesgos competitivos* ni *explicabilidad* sobre registros administrativos nacionales.
]

#speaker-note[
  Los antecedentes internacionales aplican ensambles de árboles sobre muestras muy pequeñas, de 51 a 62 proyectos, y miden exactitud. El antecedente peruano de Solís-Villanueva se ubica en la selección del postor, no en la ejecución. Esa es la brecha: pasar de clasificar a estimar probabilidades calibradas e interpretables, sobre registros administrativos nacionales.
]

== Justificación y alcances

#grid(
  columns: (1fr, 1.15fr),
  gutter: 1.2em,
  [
    *Justificación en tres planos:*
    - *Práctico:* atiende la causal de mayor impacto económico (S/ 15,913.4 M) y produce un ranking preventivo para priorizar supervisión.
    - *Teórico:* compara, bajo un marco probabilístico homogéneo, modelos estadísticos (logística penalizada, GAM) y algoritmos de ML (RF, b-NN, _boosting_).
    - *Metodológico:* previene _data leakage_ temporal, considera la observabilidad del horizonte $tau$ y exige calibración y explicabilidad (SHAP).
  ],
  [
    *Criterios de alcance:*
    + Se excluyen obras en estado «sin ejecución».
    + Se exige fecha de inicio de obra registrada ($t_(0 i)$).
    + Se exige código de inversión válido en el Banco de Inversiones (*Invierte.pe*).
    + Modalidad de ejecución *por contrata*.
    + Clase positiva solo con causales *contractuales* ($C = 1$); las demás son *eventos competitivos* ($C = 2$).
    + Solo obras con horizonte $tau$ *plenamente observable* a la fecha de corte ($R_i^(tau) = 1$).
    + Prioridad inicial en *Gobierno Nacional* (registros más completos y homogéneos).
  ],
)

#speaker-note[
  Siete criterios delimitan la población objetivo. Resalto el quinto y el sexto: las paralizaciones por otras causales no se eliminan ni se tratan como faltantes, sino como riesgos competitivos; y solo entran al modelado las obras cuyo horizonte completo ya es observable a la fecha de corte.
]

// =========================================================================
= 2. Objetivos e hipótesis

== Problema, objetivo e hipótesis general

#tub-block(title: [Problema general])[
  #text(size: 0.82em)[
    ¿En qué medida la implementación, evaluación y comparación de modelos de inteligencia artificial, con registros administrativos de fuentes públicas oficiales y bajo un enfoque de *estimación probabilística supervisada con clases desbalanceadas*, permite estimar cuantitativa y anticipadamente el riesgo de paralización de obras públicas por incumplimiento contractual y obtener una *herramienta predictiva, calibrada e interpretable* que jerarquice proyectos por nivel de riesgo y sustente decisiones preventivas?
  ]
]

#v(0.15cm)
#grid(
  columns: (1fr, 1fr),
  gutter: 0.8em,
  alert-box[
    #text(size: 0.78em)[
      *Objetivo general:* implementar, evaluar y comparar modelos de IA para la estimación anticipada de la probabilidad de paralización por incumplimiento contractual, obteniendo una herramienta predictiva, calibrada e interpretable.
    ]
  ],
  highlight-box[
    #text(size: 0.78em)[
      *Hipótesis general:* al menos un modelo de IA estima la probabilidad con una *puntuación de Brier inferior* a la del estimador de referencia (proporción histórica) y con *discriminación superior* a un ordenamiento aleatorio.
    ]
  ],
)

#speaker-note[
  Problema, objetivo e hipótesis general están alineados en la Matriz de Consistencia (Anexo 1). La hipótesis se formula en términos de la calidad de la probabilidad estimada, medida con la puntuación de Brier frente a un estimador ingenuo, y de la capacidad discriminativa.
]

== Matriz de consistencia: objetivos e hipótesis específicos

#text(size: 0.72em)[
  #lt(
    (auto, 1fr, 1fr),
    [*Cód.*],
    [*Objetivos específicos*],
    [*Hipótesis específicas*],
    [*OE1*],
    [Identificar factores de riesgo candidatos a partir de la literatura, la normativa y los registros oficiales.],
    [*H1:* existen factores observables al inicio de la ejecución que se asocian con la paralización contractual.],
    [*OE2*],
    [Implementar la recopilación, integración y preparación de datos: limpieza, estandarización, control de calidad y reconstrucción histórica de la respuesta.],
    [*H2:* la integración de fuentes permite reconstruir la fecha y la causal de la primera paralización y obtener un conjunto de datos consistente.],
    [*OE3*],
    [Realizar el análisis exploratorio y la ingeniería de características para obtener los conjuntos de entrenamiento y prueba.],
    [*H3:* las características históricas calculadas solo con información previa al inicio de la obra aportan capacidad predictiva sin _data leakage_.],
    [*OE4*],
    [Comparar modelos estadísticos y de ML bajo métricas de calibración, discriminación y decisión; seleccionar el de mejor desempeño.],
    [*H4:* al menos un modelo supera a los demás en la estimación de la probabilidad (Brier y calibración).],
    [*OE5*],
    [Aplicar IA explicable (XAI) para interpretar el modelo a nivel agregado y por obra, y establecer criterios de decisión.],
    [*H5:* las técnicas XAI generan interpretaciones consistentes entre modelos y permiten criterios claros de decisión preventiva.],
  )
]

#speaker-note[
  Los cinco objetivos específicos recorren el ciclo completo: identificación de factores (OE1), ingeniería de datos y reconstrucción de la respuesta (OE2), EDA y características sin fuga temporal (OE3), experimentación y comparación de modelos (OE4) y explicabilidad (OE5). Cada uno tiene una hipótesis asociada en la matriz de consistencia.
]

// =========================================================================
= 3. Marco teórico y formulación matemática

== Formulación del fenómeno (sección 3.1.1)

- *Unidad de análisis:* obra pública $i$, con inicio de ejecución $t_(0 i)$ y vector de características $bold(X)_i in cal(X)$, transformado mediante $phi: cal(X) -> RR^d$.
- *Disponibilidad temporal (prevención de _data leakage_):* $bold(X)_i$ es función solo de $cal(H)_(t_(0 i))$, la información registrada *estrictamente antes* de $t_(0 i)$.
- *Respuesta con riesgos competitivos:* sea $T$ el tiempo hasta la *primera paralización* y $C in {1, 2}$ su causal ($C = 1$: contractual; $C = 2$: otra; $T = +infinity$ si nunca se paraliza):

$
  Y^(tau) = bb(1)(T <= tau) dot bb(1)(C = 1) = cases(
    1 & "si" T <= tau "y" C = 1,
    0 & "si" T > tau "o" (T <= tau "y" C = 2)
  )
$

#speaker-note[
  La formulación se establece en cuatro niveles: fenómeno, modelo poblacional, muestra y datos observados. Dos decisiones clave: todo predictor es función exclusiva de la información disponible antes del inicio de la obra, y la respuesta incorpora riesgos competitivos. Una obra paralizada por clima o conflicto social antes del horizonte tau toma Y = 0 porque estimamos el riesgo absoluto de paralización contractual en presencia de las demás causales, que es la cantidad relevante para priorizar.
]

== Formulación poblacional, muestral y descomposición del Brier

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [
    *Nivel poblacional:* objeto de estimación (incidencia acumulada de la causal contractual):
    $ p_(tau)(bold(x)) = "Pr"_0(Y^(tau) = 1 mid(|) bold(X) = bold(x)) = E_0(Y^(tau) mid(|) bold(X) = bold(x)) $
    con $Y^(tau) mid(|) bold(X) = bold(x) ~ "Bernoulli"(p_(tau)(bold(x)))$ y prevalencia $pi_tau = E_0(p_(tau)(bold(X)))$.

    #v(0.2cm)
    *Nivel muestral:* procedimiento de estimación $hat(p)_(n, tau) = cal(A)_n (cal(D)_n)$ por riesgo empírico penalizado:
    $
      hat(p)_(n, tau) = op("arg min", limits: #true)_(f in cal(F)) { 1/n sum_(i=1)^n L(f(bold(X)_i), Y_i^(tau)) + lambda J(f) }
    $
  ],
  [
    *Fundamento del Brier Score:*
    $
      E_0[(hat(p)(bold(X)) - Y^(tau))^2] = underbrace(E_0[(hat(p)(bold(X)) - p_(tau)(bold(X)))^2], "error de estimación") + underbrace(E_0[p_(tau)(1 - p_(tau))], "varianza irreducible")
    $

    #v(0.2cm)
    #highlight-box[
      #text(size: 0.78em)[
        Comparar modelos por su *Brier Score* en prueba equivale a compararlos por su *error cuadrático de estimación* de $p_(tau)(bold(x))$ (Gneiting & Raftery, 2007; Kruppa et al., 2014). Por eso es el criterio principal de evaluación.
      ]
    ]
  ],
)

#speaker-note[
  Como Y es binaria, la probabilidad condicional coincide con la esperanza condicional, así que estimar probabilidades es un problema de regresión sobre el intervalo cero–uno. La descomposición cuadrática muestra que minimizar el Brier esperado es equivalente a minimizar el error de estimación respecto de la función poblacional, porque el segundo término es una varianza irreducible que no depende del estimador.
]

== Observabilidad del horizonte y censura a la derecha

- Sea $t_c$ la fecha de corte de los datos y $delta = 6$ meses el periodo mínimo sin avance físico exigido por la CGR para reconocer una paralización.
- *Indicador de observabilidad completa:*
  $ R_i^(tau) = bb(1)(t_(0 i) + tau + delta <= t_c) $
- *Muestra efectiva de aprendizaje supervisado:*
  $ d_n^"obs" = {(bold(x)_i, y_i^(tau)) : R_i^(tau) = 1} $
- *Supuesto de validez (censura no informativa / MAR):*
  $ Y^(tau) perp R^(tau) mid(|) bold(X) $

#v(0.2cm)
#alert-box[
  #text(size: 0.82em)[
    *Evita el sesgo de selección por desenlace temprano:* $R_i^(tau)$ depende solo de $t_(0 i)$ y $t_c$, nunca del resultado. Incluir obras recientes solo porque ya se paralizaron o finalizaron sesgaría hacia arriba el riesgo estimado.
  ]
]

#speaker-note[
  ¿Qué hacemos con las obras que iniciaron hace poco y siguen en ejecución? Etiquetarlas como cero sería un error porque su horizonte aún no concluye, y quedarnos solo con las recientes que ya se paralizaron sesgaría la muestra hacia desenlaces rápidos. Por eso el indicador de observabilidad depende solo de la fecha de inicio. Como extensión futura se podrían usar métodos de supervivencia con riesgos competitivos para aprovechar la información parcial.
]

== Familias de modelos a comparar (secciones 3.1.2 y 3.1.3)

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [
    *1. Modelos estadísticos (inferencia):*
    - *Regresión logística penalizada (A1, línea base):*
      $ p_(tau)(bold(x)) = (1 + e^(-bold(z)' bold(beta)))^(-1) $
      con penalización L1, L2 o _Elastic Net_ (Steyerberg et al., 2014); interpretación vía _odds ratio_ $e^(beta_j)$.
    - *GAM logístico (A2):*
      $ log((p_(tau)(bold(x))) / (1 - p_(tau)(bold(x)))) = beta_0 + sum_(j=1)^d f_j (z_j) $
      con $f_j$ _splines_ penalizados (Wood, 2017): capturan no linealidades manteniendo aditividad.
  ],
  [
    *2. Aprendizaje automático (no paramétricos):*
    - *Bosques aleatorios de estimación de probabilidad (A3):* promedio de proporciones en nodos terminales de árboles sin podar (Kruppa et al., 2014).
    - *Vecinos más cercanos agrupados, b-NN (A4):* promedio _bootstrap_ de la proporción positiva entre los $k$ vecinos.
    - *Potenciación del gradiente (A5–A7):*
      $ F_M (bold(x)) = sum_(m=1)^M nu h_m (bold(x)), quad hat(p)(bold(x)) = g(F_M (bold(x))) $
      con *XGBoost* (A5), *LightGBM* (A6) y *CatBoost* (A7).
  ],
)

#speaker-note[
  Siete algoritmos entran al diseño experimental. Por el lado estadístico, la regresión logística penalizada, que Steyerberg recomienda como línea base moderna, y el GAM logístico. Por el lado no paramétrico, bosques aleatorios y b-NN, ambos con consistencia demostrada por Kruppa, y tres implementaciones de potenciación del gradiente. La comparación se estructura en cuatro dimensiones: calibración, discriminación, decisión e interpretabilidad.
]

== Desbalance, calibración, umbral y explicabilidad (3.1.4 – 3.1.8)

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [
    *Ponderación y corrección previa (_prior correction_):*
    - Los pesos $w_c = n \/ (2 n_c)$ desplazan la probabilidad estimada:
      $ p_(tau)^(w)(bold(x)) = (w_1 p_(tau)(bold(x))) / (w_1 p_(tau)(bold(x)) + w_0 (1 - p_(tau)(bold(x)))) $
    - Con ≈ 7 % de positivos ($w_1 \/ w_0 > 13$) hay que *invertir* el sesgo antes de evaluar calibración (King & Zeng, 2001):
      $ hat(p)(bold(x)) = (w_0 hat(p)^(w)(bold(x))) / (w_0 hat(p)^(w)(bold(x)) + w_1 (1 - hat(p)^(w)(bold(x)))) $
    - Complemento: recalibración _post-hoc_ (Platt / isotónica).
  ],
  [
    *Decisión y explicabilidad (XAI):*
    - Con costos asimétricos ($c_"FN" > c_"FP"$), el umbral se elige aparte de la estimación:
      $ hat(Y)_c = bb(1)(hat(p)_star >= c^*), quad c^* = op("arg max")_c F_2(c) $
    - *Global:* coeficientes ($e^(beta_j)$), curvas suaves $f_j (z_j)$ e importancia por permutación.
    - *Local y agregada:* valores SHAP (Lundberg & Lee, 2017):
      $ f(bold(x)) = phi_0 + sum_(j=1)^q phi_j (bold(x)) $
  ],
)

#speaker-note[
  Un aporte metodológico del plan está en la sección 3.1.4. En el prototipo previo observamos que ponderar clases mejoraba el recall pero deterioraba mucho el Brier. Aquí lo explicamos teóricamente: ponderar multiplica los momios por w1 sobre w0, más de trece veces, y por eso incorporamos la corrección analítica de la probabilidad antes de evaluar. Además, el umbral se optimiza como decisión separada, y SHAP da la descomposición aditiva por obra.
]

// =========================================================================
= 4. Metodología y diseño experimental

== Enfoque metodológico y arquitectura del pipeline

- *Tipo y nivel:* investigación aplicada, enfoque cuantitativo, nivel *explicativo-predictivo*.
- *Población:* obras públicas del Banco de Inversiones (≈ 250,000 proyectos) e INFObras, filtradas por los criterios de elegibilidad y por observabilidad ($R_i^(tau) = 1$). El tamaño final de la muestra es un *resultado* del estudio.
- *Método de trabajo:* siete módulos reproducibles.

#v(0.2cm)
#align(center)[
  #text(size: 0.72em)[
    #diagram(
      node-stroke: 0.8pt + tub-red,
      node-fill: rgb("#fdf0f0"),
      spacing: (0.45cm, 0.8cm),
      node((0, 0), [*1. Adquisición*\ Fuentes oficiales], shape: "rect", inset: 6pt),
      node((1, 0), [*2. Staging*\ Carga BD / ETL], shape: "rect", inset: 6pt),
      node((2, 0), [*3. Preparación*\ Respuesta $Y^(tau)$], shape: "rect", inset: 6pt),
      node((3, 0), [*4. EDA*\ Univariado/Biv.], shape: "rect", inset: 6pt),
      node((4, 0), [*5. Ing. Caract.*\ Históricas $cal(H)_(t_0)$], shape: "rect", inset: 6pt),
      node((5, 0), [*6. Modelado*\ Matriz $7 times 3$], shape: "rect", inset: 6pt),
      node((6, 0), [*7. Evaluación*\ Brier + SHAP], shape: "rect", inset: 6pt),
      edge((0, 0), (1, 0), "-|>"),
      edge((1, 0), (2, 0), "-|>"),
      edge((2, 0), (3, 0), "-|>"),
      edge((3, 0), (4, 0), "-|>"),
      edge((4, 0), (5, 0), "-|>"),
      edge((5, 0), (6, 0), "-|>"),
    )
  ]
]

#speaker-note[
  La metodología es una arquitectura modular de siete etapas: ingesta cruda con metadatos de auditoría, capa de staging relacional en Python y base de datos, preparación y reconstrucción histórica de la primera paralización, EDA, ingeniería de características, modelado y evaluación. La trazabilidad completa garantiza reproducibilidad de los experimentos.
]

== Fuentes de datos y modelo de datos del negocio

#grid(
  columns: (1.05fr, 0.95fr),
  gutter: 1em,
  [
    #text(size: 0.72em)[
      #lt(
        (auto, auto, 1fr, auto),
        [*Fuente*],
        [*Inst.*],
        [*Descripción*],
        [*Formato*],
        [Banco de Inversiones],
        [MEF],
        [Proyectos de inversión pública registrados],
        [CSV],
        [INFObras],
        [CGR],
        [Base de obras públicas y paralizadas],
        [XLS],
        [INCO],
        [CGR],
        [Índice de corrupción por entidad ejecutora],
        [XLS],
        [IGEIP],
        [MEF],
        [Índice de Gestión de la Inversión Pública],
        [HTML],
        [Contrataciones],
        [OECE],
        [Contrataciones del Estado],
        [CSV],
      )
    ]
    #v(0.2cm)
    #text(size: 0.76em)[
      - Cruce mediante llaves maestras: *Código Único de Inversión* y *Código INFObras*.
      - Extracción semiautomatizada hacia capa _raw_ con metadatos de auditoría y ETL a _staging_ (`pandas`, `psycopg2`).
    ]
  ],
  [
    #align(center)[
      #image("assets/figures/img_modelo_datos_obra_publica.png", width: 98%)
    ]
  ],
)

#speaker-note[
  Las fuentes son el Banco de Inversiones del MEF, INFObras e INCO de la Contraloría, el IGEIP del MEF y los datos de contrataciones del OECE, que son la novedad respecto del prototipo previo. El diagrama entidad-relación muestra cómo se articulan proyecto, obra, contrato, entidad y contratista.
]

== Ingeniería de características históricas y validación temporal

#grid(
  columns: (1.1fr, 0.9fr),
  gutter: 1em,
  [
    *Variables históricas con suavizado bayesiano.* Para cada actor $e$ (entidad, departamento, distrito, tipo de obra) solo se usan obras $j$ cuyo desenlace ya era conocido en $t_(0 i)$:
    $ "tasa"_(e, i) = (sum_(j in cal(J)_(e, i)) y_j^(tau) + alpha hat(pi)_i) / (|cal(J)_(e, i)| + alpha) $
    con $cal(J)_(e, i) = {j : e_j = e, thin t_(0 j) + tau + delta <= t_(0 i)}$.

    #v(0.15cm)
    #text(size: 0.68em)[
      #lt(
        (auto, 1fr),
        [*Característica*],
        [*Definición sin fuga temporal*],
        [`tasa_paralizacion_entidad`],
        [Tasa histórica suavizada de la entidad],
        [`n_obras_x_entidad`],
        [Obras iniciadas por la entidad antes de $t_(0 i)$],
        [`monto_viable_promedio_entidad`],
        [Monto viable promedio de proyectos previos de la entidad],
        [`tasa_paralizacion_dpto/dist/tipo`],
        [Tasas suavizadas por ubicación y tipología],
      )
    ]
  ],
  [
    #align(center)[
      #image("assets/figures/img_particion_temporal_train_test.png", width: 95%)
    ]
    #text(size: 0.75em)[
      - *Partición temporal* por fecha de inicio de obra.
      - *Validación cruzada anidada* (`TimeSeriesSplit`): bucle externo de 5 pliegues, interno de 3.
      - Codificación supervisada (_target encoding_ / WOE) dentro del `Pipeline`.
      - _Bootstrap_ por conglomerados de entidad ejecutora en la evaluación.
    ]
  ],
)

#speaker-note[
  Observe el conjunto J de la tasa histórica: exige que el horizonte completo de las obras previas ya hubiera concluido en la fecha de inicio de la obra i. Así evitamos fuga temporal. La partición es temporal, no aleatoria, porque la distribución cambia en el tiempo; y como hay dependencia entre obras de una misma entidad, la incertidumbre de las métricas se estimará con bootstrap por conglomerados.
]

== Diseño factorial experimental (sección 4.5)

#grid(
  columns: (0.95fr, 1.05fr),
  gutter: 1em,
  [
    *Factores manipulados:*
    #v(0.1cm)
    #text(size: 0.68em)[
      #lt(
        (auto, auto, 1fr),
        [*Factor*],
        [*Niveles*],
        [*Detalle*],
        [*A: Algoritmo*],
        [A1–A7],
        [Logística pen., GAM, RF, b-NN, XGBoost, LightGBM, CatBoost],
        [*W: Desbalance*],
        [W0, W1],
        [Sin ponderar vs. ponderado con corrección de prior],
        [*T: Tuning*],
        [T0, T1],
        [Por defecto vs. búsqueda aleatoria (50 iter., CV temporal, min. Brier)],
        [*U: Umbral*],
        [U0, U1],
        [Fijo (0.50) vs. óptimo que maximiza $F_2$ en validación],
      )
    ]
    #v(0.15cm)
    #highlight-box[
      #text(size: 0.74em)[
        *Diseño fraccionado:* para cada algoritmo, W0-T0, W0-T1 y W1-T1.
        - W0-T0 vs. W0-T1 aísla el efecto del *tuning*.
        - W0-T1 vs. W1-T1 aísla el efecto de la *ponderación*.
        - Total: *21 ajustes × 2 umbrales = 42 evaluaciones*.
      ]
    ]
  ],
  [
    *Matriz de experimentos ($7 times 3 = 21$ ajustes):*
    #v(0.1cm)
    #text(size: 0.68em)[
      #rt(
        (1fr, auto, auto, auto),
        [*Algoritmo (A)*],
        [*Base (W0-T0)*],
        [*Optim. (W0-T1)*],
        [*Pond. (W1-T1)*],
        [A1: Reg. logística pen.],
        [E1],
        [E2],
        [E3],
        [A2: GAM logístico],
        [E4],
        [E5],
        [E6],
        [A3: Bosques aleatorios],
        [E7],
        [E8],
        [E9],
        [A4: b-NN],
        [E10],
        [E11],
        [E12],
        [A5: XGBoost],
        [E13],
        [E14],
        [E15],
        [A6: LightGBM],
        [E16],
        [E17],
        [E18],
        [A7: CatBoost],
        [E19],
        [E20],
        [E21],
      )
    ]
  ],
)

#speaker-note[
  El umbral no requiere reajustar el modelo, por lo que ambos niveles se evalúan sobre cada configuración ajustada. Para mantener la viabilidad computacional se usa un diseño factorial fraccionado: tres configuraciones por algoritmo, 21 ajustes y 42 evaluaciones. Las comparaciones entre configuraciones aíslan el efecto del tuning y el de la ponderación.
]

== Métricas de evaluación

#grid(
  columns: (1.15fr, 0.85fr),
  gutter: 1em,
  [
    #text(size: 0.66em)[
      #lt(
        (auto, auto, auto, 1fr, auto),
        [*Métrica*],
        [*Cód.*],
        [*Dimensión*],
        [*Descripción*],
        [*Prioridad*],
        [Puntuación de Brier],
        [`BS`],
        [Probabilística],
        [Error cuadrático medio entre $hat(p)_i$ y $y_i$ (y _Brier Skill Score_)],
        [*Alta*],
        [Intercepto y pendiente de calibración],
        [`CAL`],
        [Probabilística],
        [$op("logit") Pr(Y=1) = a + b thin op("logit")(hat(p))$, ideal $a=0$, $b=1$],
        [*Alta*],
        [Pérdida logarítmica],
        [`LL`],
        [Probabilística],
        [_Log-loss_ de las probabilidades estimadas],
        [Media],
        [PR-AUC],
        [`PRA`],
        [Ordenamiento],
        [Área bajo la curva precisión–exhaustividad],
        [*Alta*],
        [ROC-AUC / Gini],
        [`ROC`],
        [Ordenamiento],
        [Área bajo la curva ROC ($G = 2 thin "AUC" - 1$)],
        [Media],
        [Exhaustividad],
        [`REC`],
        [Umbral],
        [Proporción de paralizaciones contractuales detectadas],
        [*Alta*],
        [Medida $F_2$],
        [`F2`],
        [Umbral],
        [Media armónica ponderada ($beta = 2$, prioriza el _recall_)],
        [*Alta*],
        [Precisión y $F_1$],
        [`PRE`/`F1`],
        [Umbral],
        [Fracción de alertas correctas; media armónica equilibrada],
        [Media/Baja],
      )
    ]
  ],
  [
    #align(center)[
      #image("assets/figures/img_metricas_clasificacion_desbalanceada.png", width: 95%)
    ]
    #text(
      size: 0.7em,
    )[Taxonomía de métricas (adaptado de Brownlee, 2020): las probabilísticas son el criterio principal, complementadas por las de ordenamiento y de umbral.]
  ],
)

#speaker-note[
  Nueve métricas agrupadas en tres dimensiones. Prioridad alta para Brier y calibración, que evalúan directamente el objeto de estimación; PR-AUC, que mide la capacidad de jerarquizar obras bajo desbalance; y recall y F2, que evalúan la regla de decisión derivada, donde un falso negativo es más costoso que un falso positivo.
]

// =========================================================================
= 5. Avance y administración del plan

== Evidencia preliminar del prototipo (informe MEAD)

#grid(
  columns: (1.15fr, 0.85fr),
  gutter: 1em,
  [
    #text(size: 0.82em)[
      #rt(
        (auto, auto, auto, auto, auto),
        [*Modelo (prueba, umbral 0.5)*],
        [*PR AUC*],
        [*Brier*],
        [*Recall*],
        [*F2*],
        [M0 – Logística base (sin ponderar)],
        [0.180],
        [*0.061*],
        [0.085],
        [0.095],
        [M4 – GLM c-loglog ponderado],
        [0.169],
        [0.187],
        [0.610],
        [*0.353*],
        [M6 – GAM logit ponderado],
        [0.163],
        [0.066],
        [0.102],
        [0.111],
        [RF – Random Forest ponderado],
        [0.139],
        [0.135],
        [0.441],
        [0.309],
      )
    ]
    #v(0.2cm)
    #text(size: 0.78em)[Gobierno Nacional, 2,627 obras, ≈ 7.4 % de positivos; partición temporal.]
  ],
  [
    #highlight-box[
      #text(size: 0.8em)[
        *Ponderar mejora el _recall_ pero empeora la calibración* de los modelos lineales (Brier 0.19–0.21 frente a 0.061 sin ponderar).
      ]
    ]
    #v(0.2cm)
    #alert-box[
      #text(size: 0.8em)[
        El Random Forest *no* mostró ventaja consistente en prueba. Esto motiva la *corrección de prior*, la *recalibración* y el *diseño factorial* del plan.
      ]
    ]
  ],
)

#speaker-note[
  Como respaldo de viabilidad, el plan parte de un prototipo desarrollado en el curso MEAD sobre Gobierno Nacional, con ocho especificaciones. El hallazgo central: ponderar por clase sube el recall pero deteriora la calibración de los modelos lineales; sin ponderar, el Brier es mejor pero el recall casi nulo. El Random Forest no mostró ventaja consistente en prueba. Esos resultados motivaron tres decisiones del plan: corregir el prior, evaluar recalibración, y estructurar los factores W y T como un diseño factorial.
]

== Cronograma y presupuesto (capítulo V)

#grid(
  columns: (1.1fr, 0.9fr),
  gutter: 1em,
  [
    *Cronograma (3 meses, 8 etapas):*
    #v(0.1cm)
    #text(size: 0.68em)[
      #lt(
        (1fr, auto, auto, auto),
        [*Etapa*],
        [*Mes 1*],
        [*Mes 2*],
        [*Mes 3*],
        [1. Revisión bibliográfica y marco normativo],
        [*X*],
        [],
        [],
        [2. Adquisición e integración de datos],
        [*X*],
        [],
        [],
        [3. Limpieza, estandarización y respuesta $Y^(tau)$],
        [*X*],
        [*X*],
        [],
        [4. Análisis exploratorio de datos],
        [],
        [*X*],
        [],
        [5. Ingeniería de características históricas],
        [],
        [*X*],
        [],
        [6. Entrenamiento y validación],
        [],
        [*X*],
        [*X*],
        [7. Comparación e interpretación (XAI / SHAP)],
        [],
        [],
        [*X*],
        [8. Redacción del informe final],
        [],
        [],
        [*X*],
      )
    ]
  ],
  [
    *Presupuesto estimado (autofinanciado):*
    #v(0.1cm)
    #text(size: 0.68em)[
      #rt(
        (1fr, auto, auto),
        [*Rubro*],
        [*Cantidad*],
        [*Costo (S/)*],
        [Asesoría especializada],
        [3 meses],
        [6,000.00],
        [Equipos de cómputo y software],
        [2 equipos],
        [3,500.00],
        [Cómputo en la nube y bases de datos],
        [3 meses],
        [1,800.00],
        [Revisión de estilo e impresión],
        [Global],
        [700.00],
        [*TOTAL*],
        [],
        [*12,000.00*],
      )
    ]
  ],
)

#speaker-note[
  El plan se proyecta a tres meses en ocho etapas con actividades parcialmente superpuestas. El presupuesto total es de 12 mil soles, autofinanciado por los tesistas, sin perjuicio del uso de la infraestructura académica de la Escuela de Posgrado.
]

== Puntos para validar con el asesor

+ *Horizonte $tau$ y sensibilidad:* fijarlo según la distribución empírica de los tiempos hasta la primera paralización y los plazos contractuales; reportar sensibilidad con $tau in {12, 24, 36}$ meses.
+ *Alcance institucional:* ¿mantener el foco en *Gobierno Nacional* (registros más completos) o añadir una evaluación estratificada en Gobiernos Regionales?
+ *Datos del contratista (OECE):* validar las variables de desempeño previo del contratista y del supervisor, construidas bajo la condición temporal $cal(H)_(t_(0 i))$.
+ *Reconstrucción de la primera paralización:* confirmar el tratamiento de las obras para las que solo se dispone de la fotografía más reciente de INFObras.
+ *Estructura formal:* revisión de la formulación (sección 3.1.1), del diseño factorial $7 times 3 times 2$ (sección 4.5) y de la matriz de consistencia (Anexo 1) para el trámite en la Escuela de Posgrado.

#speaker-note[
  Para cerrar, cinco puntos sobre los que queremos su orientación: el horizonte tau y su análisis de sensibilidad; el alcance en Gobierno Nacional frente a una extensión regional; el uso de datos del OECE para el historial del contratista; el supuesto sobre las obras de las que solo se dispone de la fotografía más reciente; y su visto bueno a la estructura formal del plan.
]

#ending-slide(title: [¡Gracias!])[
  #text(size: 0.9em, weight: "bold")[Yan Franco Calderón Félix · Hilber Alexander Cieza Delgado]

  #v(0.25cm)
  #text(size: 0.8em)[*Asesor:* Samuel Oporto Díaz]

  #v(0.3cm)
  #text(size: 0.72em, fill: tub-gray)[
    Maestría en Ciencias con Mención en Inteligencia Artificial \
    Facultad de Ingeniería Industrial y de Sistemas · Escuela de Posgrado \
    Universidad Nacional de Ingeniería
  ]

  #v(0.4cm)
  #text(size: 0.7em)[_Atentos a sus comentarios y sugerencias_]
]
