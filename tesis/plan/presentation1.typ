#import "@preview/touying:0.6.1": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "lib.typ": *

#set text(lang: "es")

#show: tub-theme.with(
  aspect-ratio: "16-9",
  department: [FIIS · Escuela de Posgrado · Maestría en Ciencias con Mención en Inteligencia Artificial],
  logo: image("assets/figures/logo-uni.png"),
  progress-bar: true,
  config-info(
    title: [Estimación anticipada de la probabilidad de paralización de obras públicas por incumplimiento contractual en el Perú mediante técnicas de Inteligencia Artificial],
    short-title: [Plan de Tesis · Riesgo de paralización de obras públicas],
    subtitle: [Presentación del Plan de Tesis — Asesor: Samuel Oporto Díaz],
    author: [Yan Franco Calderón Félix · Hilber Alexander Cieza Delgado],
    date: datetime.today(),
    institution: [Universidad Nacional de Ingeniería],
  ),
)

// --- helper para tablas de resultados y datos -----------------------------
#let rt(cols, ..cells) = table(
  columns: cols,
  align: (col, row) => if col == 0 { left } else { right },
  inset: 6pt,
  stroke: 0.4pt + tub-gray,
  fill: (_, row) => if row == 0 { tub-light-gray },
  ..cells,
)

#let lt(cols, ..cells) = table(
  columns: cols,
  align: left + horizon,
  inset: 6pt,
  stroke: 0.4pt + tub-gray,
  fill: (_, row) => if row == 0 { tub-light-gray },
  ..cells,
)

#title-slide()

#outline-slide()

// =========================================================================
= 1. Planteamiento del Problema

== Diagnóstico: magnitud de las obras paralizadas en el Perú

#grid(columns: (1.05fr, 1fr), gutter: 1em,
  [
    - A diciembre de 2024, la CGR registró *2,476 obras paralizadas* por un costo actualizado de *S/ 43,118.9 millones*.
    - El *72.0 %* en número corresponde a gobiernos locales, pero el impacto económico atraviesa todos los niveles y sectores críticos.
    - La gestión actual es *reactiva*: auditorías e intervenciones ocurren cuando el contrato ya se resolvió o venció el plazo.

    #v(0.2cm)
    #text(size: 0.78em)[
      #rt((1fr, auto, auto),
        [*Nivel de gobierno*], [*N.° obras*], [*% N.° obras*],
        [Gobierno Local], [1,782], [72.0 %],
        [Gobierno Nacional], [384], [15.5 %],
        [Gobierno Regional], [310], [12.5 %],
        [*TOTAL*], [*2,476*], [*100.0 %*],
      )
    ]
  ],
  [
    #text(size: 0.72em)[
      #rt((1fr, auto, auto, auto),
        [*Sector*], [*Costo (M S/)*], [*% costo*], [*N.° obras*],
        [Transportes y Comunic.], [11,597.9], [26.9 %], [715],
        [Vivienda, Const. y San.], [7,861.2], [18.2 %], [518],
        [Agricultura], [7,699.5], [17.9 %], [322],
        [Salud], [5,017.7], [11.6 %], [83],
        [Educación], [2,274.2], [5.3 %], [364],
        [Otros sectores], [8,668.4], [20.1 %], [474],
        [*TOTAL*], [*43,118.9*], [*100 %*], [*2,476*],
      )
    ]
  ],
)

#speaker-note[
Profesor Oporto, iniciamos presentando el diagnóstico del Plan de Tesis. El fenómeno de obras paralizadas inmoviliza más de 43 mil millones de soles en 2,476 obras a diciembre de 2024 según la Contraloría. Mientras que en cantidad predominan los gobiernos locales (72%), en monto destacan sectores de infraestructura pesada como Transportes, Vivienda y Agricultura. El vacío central en la gestión pública es que las intervenciones de control son reactivas, una vez materializada la paralización.
]

== Representación y ciclo de estados de una obra pública

#grid(columns: (1fr, 1fr), gutter: 1em,
  [
    #align(center)[
      #image("assets/figures/img-representacion_obra_publica.png", width: 92%)
    ]
    #text(size: 0.72em)[Inversión con componente de infraestructura ejecutada por el Estado (Invierte.pe / INFObras).]
  ],
  [
    #align(center)[
      #image("assets/figures/img_diagrama_estados_obra.png", width: 82%)
    ]
    #v(0.2cm)
    #align(center)[
      #text(size: 0.68em)[
        #diagram(
          node-stroke: 1pt + black,
          node-fill: rgb("f9f9f9"),
          spacing: (1.2cm, 1.0cm),
          node((0,0), [Sin Ejecución], name: <S>, shape: "rect", inset: 6pt),
          node((1.4,0), [En Ejecución], name: <E>, shape: "rect", inset: 6pt, stroke: 1.5pt + blue.darken(20%)),
          node((1.4,1.2), [Paralizado], name: <P>, shape: "rect", inset: 6pt, stroke: 1pt + red.darken(10%)),
          node((2.8,0), [Finalizado], name: <F>, shape: "rect", inset: 6pt, stroke: 2pt + green.darken(30%)),
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
En la sección 1.1.2 del plan caracterizamos el ciclo de vida de la obra. Según el criterio de la CGR, una obra en ejecución física pasa al estado de paralización (Estado 5) cuando no presenta avance físico por un mínimo de 6 meses o proviene de un contrato resuelto/nulo por controversias, abandono o deficiencias técnicas. En INFObras esto se refleja en la transición entre "En Ejecución" y "Paralizado".
]

== Tipificación: el incumplimiento contractual como causal crítica

#grid(columns: (1.15fr, 0.85fr), gutter: 1em,
  [
    #text(size: 0.68em)[
      #rt((1fr, auto, auto, auto, auto),
        [*Causal de paralización (CGR)*], [*Costo (M S/)*], [*% costo*], [*Obras*], [*% obras*],
        [*Incumplimiento de contrato*], [*15,913.4*], [*36.9 %*], [*628*], [*25.4 %*],
        [Discrepancias, controv. y arbitraje], [14,889.4], [34.5 %], [225], [9.1 %],
        [Deficiencia en expediente técnico], [3,217.8], [7.5 %], [271], [10.9 %],
        [Falta de recursos financ. y liquidez], [2,140.4], [5.0 %], [526], [21.2 %],
        [Conflictos sociales], [1,078.1], [2.5 %], [71], [2.9 %],
        [Eventos climáticos], [987.0], [2.3 %], [70], [2.8 %],
        [Incumpl. pago de valorizaciones], [951.8], [2.2 %], [71], [2.9 %],
        [Abandono de obra], [699.5], [1.6 %], [247], [10.0 %],
        [Otras causales], [3,241.5], [7.5 %], [367], [14.8 %],
        [*TOTAL*], [*43,118.9*], [*100 %*], [*2,476*], [*100 %*],
      )
    ]
  ],
  [
    *Categoría `CONTRACTUAL` (clase positiva $C = 1$):*
    #v(0.15cm)
    #text(size: 0.66em)[
      #lt((1fr, auto),
        [*Causal homologada*], [*Categoría*],
        [Incumplimiento de contrato], [CONTRACTUAL],
        [Proceso arbitral], [CONTRACTUAL],
        [Resolución de contrato], [CONTRACTUAL],
        [Discrepancias, controv. y arbitraje], [CONTRACTUAL],
        [Resolución contrato supervisión], [CONTRACTUAL],
        [Obra judicializada por la entidad], [CONTRACTUAL],
        [Incumpl. pago de valorizaciones], [CONTR. / FIN.],
      )
    ]
  ],
)

#speaker-note[
El incumplimiento de contrato es simultáneamente la primera causal en número de obras (25.4%) y la primera en costo inmovilizado (36.9%, casi S/ 16 mil millones), seguida de cerca por controversias y arbitrajes (34.5% del costo). Por ello delimitamos nuestra variable objetivo agrupando las 7 causales de naturaleza contractual imputables al contratista o a la entidad.
]

== Grafo causal y caracterización de datos

#grid(columns: (1fr, 1fr), gutter: 1em,
  [
    #align(center)[
      #image("assets/figures/img_grafo_causal_paralizacion.png", width: 92%)
    ]
    #text(size: 0.72em)[El incumplimiento contractual actúa como nodo articulador de riesgos técnicos, financieros y de gestión.]
  ],
  [
    #align(center)[
      #image("assets/figures/img_caracterizacion_obra_publica.png", width: 95%)
    ]
    #v(0.1cm)
    #align(center)[
      #image("assets/figures/img_distribucion_clases_general.png", width: 82%)
    ]
  ],
)

#speaker-note[
El grafo jerárquico dirigido muestra que el incumplimiento contractual sintetiza fallas previas de planificación y selección. A la derecha mostramos las entidades de datos que caracterizan la obra al inicio de su ejecución y la distribución general de clases, donde se aprecia el marcado desbalance que exige un enfoque probabilístico especializado.
]

== Antecedentes bibliográficos y brecha de investigación

#text(size: 0.78em)[
  #lt((auto, auto, 1fr, 1fr),
    [*Autor (Año)*], [*Contexto*], [*Enfoque / Modelos*], [*Hallazgo y relación con la tesis*],
    [Gondia et al. (2020)], [Egipto (51 proy., 59 factores)], [Árbol de Decisión vs. Naive Bayes (CV 10-fold)], [Factores de riesgo contractuales y técnicos permiten anticipar retrasos.],
    [Egwim et al. (2021)], [Infraestructura real], [Comparación ML; Random Forest y XGBoost], [Ensambles de árboles destacan cuando se requiere capacidad de acción.],
    [Alsulamy (2025)], [Arabia Saudita (62 proy.)], [CatBoost, XGBoost y LightGBM con tuning], [LightGBM logra la mayor precisión en predicción de retrasos.],
    [Solís-Villanueva (2018)], [Perú — Ley N.° 30225 (209 obras)], [ Perceptrón multicapa (Levenberg-Marquardt), 10 indicadores], [Antecedente nacional en etapa de selección; no aborda paralización en ejecución ni calibración.],
    [Kruppa et al. (2012, 2014); Steyerberg (2014); Lundberg (2017)], [Estimación de riesgo y XAI], [Probabilidad condicional, Brier score, GLM/GAM, PET/b-NN, SHAP], [Marco teórico para estimar probabilidades calibradas e interpretables.],
  )
]

#v(0.2cm)
#highlight-box[
  *Brecha identificada:* Los estudios previos en construcción se enfocan en exactitud clasificatoria sobre muestras pequeñas, sin evaluar *calibración de probabilidades*, *censura temporal / riesgos competitivos* ni *explicabilidad (XAI)* a escala de registros administrativos nacionales.
]

#speaker-note[
En la revisión de literatura destacamos trabajos internacionales recientes con ensambles de árboles y el antecedente peruano de Solís-Villanueva (2018) sobre selección de postores. La brecha que nuestra tesis aborda es pasar de una clasificación binaria simple a una estimación rigurosa de probabilidades condicionales calibradas e interpretables al inicio de la ejecución física.
]

== Justificación y delimitación del alcance

#grid(columns: (1fr, 1.15fr), gutter: 1.2em,
  [
    *Justificación en tres planos:*
    - *Práctica:* Atiende la causal de mayor impacto económico (S/ 15,913.4 M), generando un ranking preventivo para priorizar supervisión.
    - *Teórica:* Compara bajo un marco probabilístico homogéneo modelos estadísticos inferenciales (GLM penalizado, GAM) y algoritmos no paramétricos de ML (RF, b-NN, Boosting).
    - *Metodológica:* Previene *data leakage* temporal, incorpora observabilidad del horizonte $tau$ y exige calibración + explicabilidad (SHAP).
  ],
  [
    *Criterios funcionales de alcance (7 reglas):*
    + Exclusión de obras en estado `"sin ejecución"`.
    + Fecha de inicio de obra registrada ($t_(0 i)$).
    + Vínculo válido con el Banco de Inversiones (*Invierte.pe*).
    + Modalidad de ejecución *por contrata*.
    + Clase positiva restringida a causales *contractuales* ($C = 1$); otras causales tratadas como *eventos competitivos* ($C = 2$).
    + Horizonte $tau$ *plenamente observable* a la fecha de corte ($R_i^(tau) = 1$).
    + Priorización inicial en *Gobierno Nacional* (registros más completos y homogéneos).
  ],
)

#speaker-note[
Estos siete criterios delimitan operacionalmente nuestra población objetivo. Es importante resaltar ante usted el quinto y sexto criterio: las paralizaciones no contractuales no se eliminan ni se tratan como simples faltantes, sino como riesgos competitivos; y solo entran al modelado las obras cuya ventana de observación tau más el tiempo de reconocimiento delta ya se completó antes de la fecha de corte.
]

// =========================================================================
= 2. Problemas, Objetivos e Hipótesis

== Problema, Objetivo e Hipótesis General

#tub-block(title: [Problema General])[
  #text(size: 0.82em)[
    ¿En qué medida la implementación, evaluación y comparación de modelos de inteligencia artificial, utilizando registros administrativos de fuentes públicas oficiales bajo un enfoque de *estimación probabilística supervisada con clases desbalanceadas*, permite estimar cuantitativa y anticipadamente el riesgo de paralización de obras públicas en el Perú por incumplimiento contractual y obtener una *herramienta predictiva, calibrada e interpretable* que permita jerarquizar proyectos por nivel de riesgo y sustentar la toma de decisiones preventivas?
  ]
]

#v(0.15cm)
#grid(columns: (1fr, 1fr), gutter: 0.8em,
  alert-box[
    #text(size: 0.78em)[
      *Objetivo General:* Implementar, evaluar y comparar modelos de IA para la estimación anticipada de la probabilidad de paralización por incumplimiento contractual, obteniendo una herramienta predictiva, calibrada e interpretable.
    ]
  ],
  highlight-box[
    #text(size: 0.78em)[
      *Hipótesis General:* Al menos un modelo de IA estima la probabilidad de paralización con un *Brier Score inferior* al estimador de referencia (prevalencia histórica) y una *discriminación superior* al azar.
    ]
  ],
)

#speaker-note[
Aquí presentamos la alineación del Problema General, Objetivo General e Hipótesis General de la Matriz de Consistencia (Anexo 1). Nótese que la hipótesis general se formula directamente en términos de la calidad de la probabilidad estimada (puntuación de Brier respecto al estimador ingenuo) y de la capacidad discriminativa.
]

== Matriz de Consistencia: Objetivos e Hipótesis Específicas

#text(size: 0.72em)[
  #lt((auto, 1fr, 1fr),
    [*Cód.*], [*Objetivos Específicos (OE1–OE5)*], [*Hipótesis Específicas (H1–H5)*],
    [*OE1*], [Identificar factores de riesgo candidatos asociados a la paralización contractual desde la literatura, normativa y registros oficiales.], [*H1:* Existen factores observables al inicio de la ejecución ($t_(0 i)$) que se asocian significativamente con la paralización contractual.],
    [*OE2*], [Implementar la recopilación, integración y preparación de datos, incluyendo limpieza, estandarización y reconstrucción histórica de la variable de respuesta.], [*H2:* La integración de fuentes oficiales permite reconstruir la fecha y causal de la primera paralización y obtener un dataset consistente en el horizonte $tau$.],
    [*OE3*], [Realizar el análisis exploratorio (EDA) y la ingeniería de características para obtener los conjuntos de entrenamiento y prueba.], [*H3:* Las características históricas calculadas exclusivamente con información previa a $t_(0 i)$ aportan capacidad predictiva sin introducir *data leakage*.],
    [*OE4*], [Comparar modelos estadísticos y de ML mediante su ajuste, entrenamiento y evaluación bajo métricas de calibración, discriminación y decisión.], [*H4:* Al menos un modelo presenta desempeño superior a los demás en la estimación de la probabilidad, medido principalmente por Brier Score y calibración.],
    [*OE5*], [Aplicar técnicas de IA explicable (XAI) para interpretar el modelo a nivel agregado y por obra, estableciendo criterios para la toma de decisiones.], [*H5:* Las técnicas XAI generan interpretaciones consistentes entre modelos y permiten establecer criterios claros para decisiones preventivas.],
  )
]

#speaker-note[
Los cinco objetivos específicos recorren el ciclo completo de investigación: desde la identificación teórica y normativa de factores (OE1), la ingeniería de datos y reconstrucción histórica de la variable respuesta (OE2), el EDA e ingeniería de características causales en el tiempo (OE3), la experimentación factorial de modelos (OE4) y la explicabilidad con SHAP e importancia por permutación (OE5).
]

// =========================================================================
= 3. Marco Teórico y Formulación Matemática

== Delimitación matemática del fenómeno (Sección 3.1.1)

- *Unidad de análisis:* Obra pública $i in cal(U)$ con fecha de inicio físico $t_(0 i)$ y vector de características $bold(X)_i = (X_(i 1), ..., X_(i q)) in cal(X)$, transformado mediante $phi: cal(X) -> RR^d$.
- *Condición de disponibilidad temporal (prevención de _data leakage_):*
  $ bold(X)_i = f(cal(H)_(t_(0 i))) $
  donde $cal(H)_(t_(0 i))$ es la información administrativa registrada *estrictamente antes* de $t_(0 i)$.
- *Variable de respuesta en horizonte $tau > 0$ con riesgos competitivos:*
  Sea $T$ el tiempo hasta la *primera paralización* y $C in {1, 2}$ su causal ($C = 1$: contractual; $C = 2$: otra causal; $T = +infinity$ si no se paraliza):
  $ Y^(tau) = bb(1)(T <= tau) dot bb(1)(C = 1) = cases(
    1 & "si" T <= tau "y" C = 1,
    0 & "si" T > tau "o" (T <= tau "y" C = 2)
  ) $

#speaker-note[
En la sección 3.1.1 formalizamos matemáticamente el problema en cuatro niveles. Primero, en la delimitación del fenómeno imponemos que todo predictor X_i sea función exclusiva de la historia H disponible antes del inicio de la obra t_0i. Segundo, definimos la respuesta Y^(tau) sobre un horizonte fijo tau e incorporamos riesgos competitivos: las obras que se paralizan por clima o causas sociales antes de tau toman Y^(tau)=0 para estimar la incidencia acumulada real (riesgo absoluto) y no un riesgo hipotético irreal.
]

== Formulación poblacional, muestral y descomposición de Brier

#grid(columns: (1fr, 1fr), gutter: 1em,
  [
    *Nivel poblacional:*
    Objeto de estimación (función de incidencia acumulada en $tau$):
    $ p_(tau)(bold(x)) = "Pr"_0(Y^(tau) = 1 mid(|) bold(X) = bold(x)) = E_0(Y^(tau) mid(|) bold(X) = bold(x)) $
    con $Y^(tau) mid(|) bold(X) = bold(x) ~ "Bernoulli"(p_(tau)(bold(x)))$ y prevalencia marginal $pi_tau = E_0(p_(tau)(bold(X)))$.

    #v(0.2cm)
    *Nivel muestral ($cal(D)_n$):*
    Procedimiento de estimación $hat(p)_(n, tau) = cal(A)_n (cal(D)_n): cal(X) -> [0, 1]$, por riesgo empírico penalizado:
    $ hat(p)_(n, tau) = op("arg min", limits: #true)_(f in cal(F)) { 1/n sum_(i=1)^n L(f(bold(X)_i), Y_i^(tau)) + lambda J(f) } $
  ],
  [
    *Fundamento teórico del Brier Score:*
    El error cuadrático esperado sobre una obra nueva se descompone como:
    $ E_0[(hat(p)(bold(X)) - Y^(tau))^2] = underbrace(E_0[(hat(p)(bold(X)) - p_(tau)(bold(X)))^2], "Error de estimación " e(hat(p))) + underbrace(E_0[p_(tau)(bold(X))(1 - p_(tau)(bold(X)))], "Varianza irreducible") $

    #v(0.2cm)
    #highlight-box[
      #text(size: 0.78em)[
        Comparar modelos según su *Brier Score* en prueba equivale exactamente a compararlos según su *error cuadrático de estimación* de la probabilidad verdadera $p_(tau)(bold(x))$ (Gneiting & Raftery, 2007; Kruppa et al., 2014).
      ]
    ]
  ],
)

#speaker-note[
Como Y^(tau) es binaria, la probabilidad condicional p_tau(x) coincide con la esperanza condicional E_0[Y^(tau)|X=x]. Por tanto, estimar probabilidades es un problema de regresión sobre [0,1]. Además, demostramos mediante la descomposición cuadrática que minimizar el Brier Score esperado equivale a minimizar el error cuadrático de estimación e(p_hat) respecto a la verdadera función poblacional p_tau(x).
]

== Observabilidad del horizonte y censura a la derecha

- Sea $t_c$ la fecha de corte de los datos y $delta = 6$ meses el periodo mínimo sin avance físico exigido por la CGR para reconocer una paralización.
- *Indicador de observabilidad completa:*
  $ R_i^(tau) = bb(1)(t_(0 i) + tau + delta <= t_c) $
- *Muestra efectiva de aprendizaje supervisado:*
  $ d_n^"obs" = {(bold(x)_i, y_i^(tau)) : R_i^(tau) = 1} $
- *Supuesto de validez (Missing at Random / Censura no informativa):*
  $ Y^(tau) perp R^(tau) mid(|) bold(X) $

#v(0.2cm)
#alert-box[
  #text(size: 0.82em)[
    *Evita sesgo de selección por desenlace temprano:* $R_i^(tau)$ depende únicamente de $t_(0 i)$ y $t_c$, nunca del resultado $Y_i^(tau)$. Incluir obras recientes solo porque ya se paralizaron o finalizaron sesgaría hacia arriba el riesgo estimado.
  ]
]

#speaker-note[
Esta sección responde a una pregunta crítica de diseño: ¿qué hacemos con las obras que iniciaron hace poco y siguen "en ejecución"? Si las etiquetamos como Y=0 cometeríamos un error porque su horizonte tau aún no concluye; y si incluimos solo las recientes que ya se paralizaron, sesgaríamos la muestra hacia desenlaces rápidos. Por eso definimos el indicador R_i^(tau) que depende solo de la fecha de inicio t_0i, garantizando censura no informativa condicional en X.
]

== Familias de modelos a comparar (Secciones 3.1.2 y 3.1.3)

#grid(columns: (1fr, 1fr), gutter: 1em,
  [
    *1. Modelos estadísticos (inferencia):*
    - *Regresión Logística Penalizada (A1 — Línea base):*
      $ p_(tau)(bold(x)) = (1 + e^(-bold(z)' bold(beta)))^(-1) $
      con penalización L1 (LASSO), L2 (Ridge) o *Elastic Net* (Steyerberg et al., 2014). Interpretación directa vía *Odds Ratios* ($e^(beta_j)$).
    - *GAM Logístico (A2):*
      $ log((p_(tau)(bold(x))) / (1 - p_(tau)(bold(x)))) = beta_0 + sum_(j=1)^d f_j (z_j) $
      donde $f_j$ son *splines penalizados* (Wood, 2017) que capturan no linealidades manteniendo aditividad.
  ],
  [
    *2. Modelos de Aprendizaje Automático (no paramétricos):*
    - *Bosques Aleatorios de Estimación de Probabilidad — PET / RF (A3):* promedio de proporciones terminales en árboles sin podar optimizados por MSE (Kruppa et al., 2014).
    - *Vecinos más Cercanos Agrupados — b-NN (A4):* promedio _bootstrap_ de la proporción positiva en los $k$ vecinos más cercanos.
    - *Potenciación del Gradiente — Gradient Boosting (A5–A7):*
      $ F_M (bold(x)) = sum_(m=1)^M nu h_m (bold(x)), quad hat(p)(bold(x)) = g(F_M (bold(x))) $
      Evaluando *XGBoost* (A5), *LightGBM* (A6) y *CatBoost* (A7).
  ],
)

#speaker-note[
En las secciones 3.1.2 y 3.1.3 justificamos las siete familias de modelos que entran al diseño experimental. Por el lado estadístico tenemos la Regresión Logística Penalizada (recomendada por Steyerberg como baseline moderno) y el GAM logístico. Por el lado no paramétrico tenemos los Probability Estimation Trees en Random Forest, Bagged k-NN (ambos con consistencia teórica demostrada por Kruppa et al.) y los tres algoritmos estado del arte de Gradient Boosting.
]

== Tratamiento del desbalance, calibración y umbral (3.1.4 – 3.1.8)

#grid(columns: (1fr, 1fr), gutter: 1em,
  [
    *Ponderación y Corrección Previa (_Prior Correction_):*
    - Pesos balanceados $w_c = n \/ (2 n_c)$ desplazan la probabilidad estimada a:
      $ p_(tau)^(w)(bold(x)) = (w_1 p_(tau)(bold(x))) / (w_1 p_(tau)(bold(x)) + w_0 (1 - p_(tau)(bold(x)))) $
    - Con $tilde.op 7 %$ de positivos ($w_1 \/ w_0 > 13$), se requiere *invertir analíticamente* el sesgo antes de evaluar calibración (King & Zeng, 2001):
      $ hat(p)(bold(x)) = (w_0 hat(p)^(w)(bold(x))) / (w_0 hat(p)^(w)(bold(x)) + w_1 (1 - hat(p)^(w)(bold(x)))) $
    - Complementado con recalibración post-hoc (*Platt* / *Isotónica*).
  ],
  [
    *Regla de decisión y Explicabilidad (XAI):*
    - Umbral óptimo bajo costos asimétricos ($c_"FN" > c_"FP"$):
      $ hat(Y)_c = bb(1)(hat(p)_star >= c^*), quad c^* = op("arg max")_c F_2(c) $
      separando la *estimación probabilística* de la *decisión operativa*.
    - *Explicabilidad global y local:*
      - Global: Coeficientes ($e^(beta_j)$), curvas suaves $f_j (z_j)$ e *Importancia por Permutación*.
      - Local y agregada: *Valores SHAP* (Lundberg & Lee, 2017):
        $ f(bold(x)) = phi_0 + sum_(j=1)^q phi_j (bold(x)) $
  ],
)

#speaker-note[
Un aporte metodológico clave del plan está en la sección 3.1.4: en nuestro estudio previo (MEAD) observamos empíricamente que ponderar clases mejoraba el Recall pero deterioraba fuertemente el Brier Score. Aquí lo resolvemos teóricamente: demostramos que ponderar por w_1 y w_0 multiplica los momios por w_1/w_0 (más de 13 veces), por lo que incorporamos la fórmula de corrección analítica de probabilidades (prior correction) además de la optimización del umbral F2 y la descomposición aditiva con SHAP.
]

// =========================================================================
= 4. Metodología y Diseño Experimental

== Enfoque metodológico y arquitectura del pipeline

- *Tipo y nivel de investigación:* Aplicada, de enfoque cuantitativo y nivel *explicativo-predictivo*.
- *Población y muestra:* Universo de obras públicas en el Banco de Inversiones (~250,000 proyectos) e INFObras, filtrado por los 7 criterios de elegibilidad y observabilidad ($R_i^(tau) = 1$).
- *Método de trabajo en 7 módulos reproducibles:*

#v(0.2cm)
#align(center)[
  #text(size: 0.72em)[
    #diagram(
      node-stroke: 0.8pt + tub-red,
      node-fill: rgb("#fdf0f0"),
      spacing: (0.45cm, 0.8cm),
      node((0,0), [*1. Adquisición*\ Fuentes oficiales], shape: "rect", inset: 6pt),
      node((1,0), [*2. Staging*\ Carga BD / ETL], shape: "rect", inset: 6pt),
      node((2,0), [*3. Preparación*\ Respuesta $Y^(tau)$], shape: "rect", inset: 6pt),
      node((3,0), [*4. EDA*\ Univariado/Biv.], shape: "rect", inset: 6pt),
      node((4,0), [*5. Ing. Caract.*\ Históricas $cal(H)_(t_0)$], shape: "rect", inset: 6pt),
      node((5,0), [*6. Modelado*\ Matriz $21 times 2$], shape: "rect", inset: 6pt),
      node((6,0), [*7. Evaluación*\ Brier + SHAP], shape: "rect", inset: 6pt),
      edge((0,0), (1,0), "-|>"),
      edge((1,0), (2,0), "-|>"),
      edge((2,0), (3,0), "-|>"),
      edge((3,0), (4,0), "-|>"),
      edge((4,0), (5,0), "-|>"),
      edge((5,0), (6,0), "-|>"),
    )
  ]
]

#speaker-note[
En el Capítulo IV definimos una arquitectura modular de siete etapas desde la ingesta cruda (raw) con metadatos de auditoría, pasando por una capa relacional de staging en PostgreSQL/Python, hasta la reconstrucción histórica de la primera paralización y la ejecución del diseño experimental.
]

== Fuentes de datos y Modelo de Datos del Negocio

#grid(columns: (1.05fr, 0.95fr), gutter: 1em,
  [
    #text(size: 0.72em)[
      #lt((auto, auto, 1fr, auto),
        [*Fuente*], [*Inst.*], [*Descripción*], [*Formato*],
        [Banco de Inversiones], [MEF], [Proyectos de inversión pública registrados], [CSV],
        [INFObras], [CGR], [Base de obras públicas y paralizadas], [XLS],
        [INCO], [CGR], [Índice de corrupción por entidad ejecutora], [XLS],
        [IGEIP], [MEF], [Índice de Gestión de la Inversión Pública], [HTML],
        [Contrataciones], [OECE], [Contrataciones del Estado (proveedores/contratos)], [CSV],
      )
    ]
    #v(0.2cm)
    #text(size: 0.76em)[
      - Cruce relacional mediante llaves maestras: *Código Único de Inversión (CUI)* y *Código INFObras*.
      - Incorporación de datos de contratistas desde el portal *OECE*.
    ]
  ],
  [
    #align(center)[
      #image("assets/figures/img_modelo_datos_obra_publica.png", width: 98%)
    ]
  ],
)

#speaker-note[
Respecto al trabajo previo, en este Plan de Tesis ampliamos las fuentes de datos incorporando los registros de Contrataciones del Estado (OECE) junto con el Banco de Inversiones del MEF, INFObras, el índice INCO de la Contraloría y el IGEIP. El diagrama entidad-relación muestra cómo se articulan proyecto, obra, contrato, entidad, contratista y eventos de estado.
]

== Ingeniería de características históricas y validación temporal

#grid(columns: (1.1fr, 0.9fr), gutter: 1em,
  [
    *Variables agregadas históricas con suavizado bayesiano:*
    Para cada actor/dimensión $e$ (entidad, departamento, distrito, tipo de obra), solo se usan obras $j$ cuyo desenlace ya era observable al inicio $t_(0 i)$:
    $ "tasa"_(e, i) = (sum_(j in cal(J)_(e, i)) y_j^(tau) + alpha hat(pi)_i) / (|cal(J)_(e, i)| + alpha) $
    donde $cal(J)_(e, i) = {j : e_j = e, thin t_(0 j) + tau + delta <= t_(0 i)}$.

    #v(0.15cm)
    #text(size: 0.68em)[
      #lt((auto, 1fr),
        [*Característica calculada*], [*Definición sin fuga temporal*],
        [`tasa_paralizacion_entidad`], [Tasa histórica suavizada de paralización contractual de la entidad],
        [`n_obras_x_entidad`], [N.° de obras iniciadas por la entidad antes de $t_(0 i)$],
        [`monto_viable_promedio_entidad`], [Monto viable promedio de proyectos previos de la entidad],
        [`tasa_paralizacion_dpto/dist/tipo`], [Tasas históricas suavizadas por ubicación y tipología],
      )
    ]
  ],
  [
    #align(center)[
      #image("assets/figures/img_particion_temporal_train_test.png", width: 95%)
    ]
    #text(size: 0.75em)[
      - *Partición temporal* por fecha de inicio $t_(0 i)$.
      - *Validación cruzada anidada* (`TimeSeriesSplit`): bucle externo (5 pliegues) + interno (3 pliegues).
      - Codificación supervisada (*Target Encoding* / *WOE*) encapsulada dentro de `Pipeline`.
      - *Bootstrap por conglomerados* de entidad ejecutora en test.
    ]
  ],
)

#speaker-note[
Observe la ecuación de la tasa histórica suavizada: el conjunto J_(e,i) exige que t_0j + tau + delta <= t_0i. Es decir, cuando una obra i inicia en la fecha t_0i, solo computamos en la tasa histórica de su entidad aquellas obras anteriores cuyo horizonte completo de observación ya había concluido en t_0i. Además, al existir correlación entre obras de una misma entidad, los intervalos de confianza en el conjunto de prueba se calcularán con bootstrap por conglomerados (cluster bootstrap) a nivel de entidad ejecutora.
]

== Diseño Factorial Experimental (Sección 4.5)

#grid(columns: (0.95fr, 1.05fr), gutter: 1em,
  [
    *Factores independientes manipulados:*
    #v(0.1cm)
    #text(size: 0.68em)[
      #lt((auto, auto, 1fr),
        [*Factor*], [*Niveles*], [*Detalle*],
        [*A: Algoritmo*], [A1–A7], [Logística Pen., GAM, RF, b-NN, XGBoost, LightGBM, CatBoost],
        [*W: Desbalance*], [W0, W1], [Sin ponderar vs. Ponderado con corrección de prior],
        [*T: Tuning*], [T0, T1], [Por defecto vs. Búsqueda aleatoria (50 iter., CV temporal, min Brier)],
        [*U: Umbral*], [U0, U1], [Fijo ($0.50$) vs. Óptimo que maximiza $F_2$ en validación],
      )
    ]
    #v(0.15cm)
    #highlight-box[
      #text(size: 0.74em)[
        *Diseño factorial fraccionado:*
        - E1–E2 (W0-T0 vs. W0-T1) aísla el efecto del *Tuning (T)*.
        - E2–E3 (W0-T1 vs. W1-T1) aísla el efecto de la *Ponderación corregida (W)*.
        - Total: *21 modelos ajustados × 2 umbrales = 42 evaluaciones*.
      ]
    ]
  ],
  [
    *Matriz de experimentos ($7 times 3 = 21$ ajustes):*
    #v(0.1cm)
    #text(size: 0.68em)[
      #rt((1fr, auto, auto, auto),
        [*Algoritmo (A)*], [*Base (W0-T0)*], [*Optim. (W0-T1)*], [*Pond. (W1-T1)*],
        [A1: Reg. Logística Pen.], [E1: A1-W0-T0], [E2: A1-W0-T1], [E3: A1-W1-T1],
        [A2: GAM Logístico], [E4: A2-W0-T0], [E5: A2-W0-T1], [E6: A2-W1-T1],
        [A3: Bosques Aleatorios], [E7: A3-W0-T0], [E8: A3-W0-T1], [E9: A3-W1-T1],
        [A4: b-NN], [E10: A4-W0-T0], [E11: A4-W0-T1], [E12: A4-W1-T1],
        [A5: XGBoost], [E13: A5-W0-T0], [E14: A5-W0-T1], [E15: A5-W1-T1],
        [A6: LightGBM], [E16: A6-W0-T0], [E17: A6-W0-T1], [E18: A6-W1-T1],
        [A7: CatBoost], [E19: A7-W0-T0], [E20: A7-W0-T1], [E21: A7-W1-T1],
      )
    ]
  ],
)

#speaker-note[
En la sección 4.5 estructuramos un diseño factorial fraccionado muy limpio. Evaluamos 7 algoritmos en tres configuraciones progresivas: base sin ponderar ni tunear (W0-T0), optimizada sin ponderar (W0-T1) y optimizada con ponderación y corrección de probabilidades (W1-T1). Cada una de las 21 configuraciones se evalúa bajo el umbral estándar U0 (0.50) y el umbral U1 optimizado para F2, totalizando 42 combinaciones experimentales.
]

== Variables dependientes: Métricas de evaluación

#grid(columns: (1.15fr, 0.85fr), gutter: 1em,
  [
    #text(size: 0.66em)[
      #lt((auto, auto, auto, 1fr, auto),
        [*Métrica*], [*Cód.*], [*Dimensión*], [*Descripción*], [*Prioridad*],
        [Puntuación de Brier], [`BS`], [Probabilística], [Error cuadrático medio entre $hat(p)_i$ y $y_i$ (+ Brier Skill Score)], [*Alta*],
        [Intercepto y pend. calibración], [`CAL`], [Probabilística], [Recalibración logística $op("logit") Pr(Y=1) = a + b thin op("logit")(hat(p))$ ($a=0, b=1$)], [*Alta*],
        [Pérdida logarítmica], [`LL`], [Probabilística], [Log-loss sobre probabilidades estimadas], [Media],
        [PR-AUC], [`PRA`], [Ordenamiento], [Área bajo la curva Precisión–Exhaustividad], [*Alta*],
        [ROC-AUC / Gini], [`ROC`], [Ordenamiento], [Área bajo la curva ROC ($G = 2 thin "AUC" - 1$)], [Media],
        [Exhaustividad (_Recall_)], [`REC`], [Umbral], [Proporción de paralizaciones contractuales detectadas], [*Alta*],
        [Medida $F_2$], [`F2`], [Umbral], [Media armónica ponderada ($beta = 2$, prioriza Recall)], [*Alta*],
        [Precisión y $F_1$], [`PRE`/`F1`], [Umbral], [Fracción de alertas verdaderas y media armónica equilibrada], [Media/Baja],
      )
    ]
  ],
  [
    #align(center)[
      #image("assets/figures/img_metricas_clasificacion_desbalanceada.png", width: 95%)
    ]
    #text(size: 0.7em)[Taxonomía de métricas (adaptado de Brownlee, 2020): jerarquía encabezada por métricas probabilísticas (`BS`, `CAL`), de ordenamiento (`PRA`) y de decisión (`F2`, `REC`).]
  ],
)

#speaker-note[
Para evaluar los 42 experimentos definimos nueve métricas agrupadas en tres dimensiones, jerarquizadas por prioridad. La prioridad Alta recae en el Brier Score y la pendiente/intercepto de calibración (dimensión probabilística), el PR-AUC (dimensión de ordenamiento para jerarquizar obras) y el Recall junto con F2 (dimensión de decisión operativa).
]

// =========================================================================
= 5. Administración del Plan y Acuerdos con el Asesor

== Cronograma de ejecución y presupuesto (Capítulo V)

#grid(columns: (1.1fr, 0.9fr), gutter: 1em,
  [
    *Cronograma proyectado (3 meses — 8 etapas):*
    #v(0.1cm)
    #text(size: 0.68em)[
      #lt((1fr, auto, auto, auto),
        [*Etapa de intervención*], [*Mes 1*], [*Mes 2*], [*Mes 3*],
        [1. Revisión bibliográfica y marco normativo], [*X*], [], [],
        [2. Adquisición e integración de datos], [*X*], [], [],
        [3. Limpieza, estandarización y resp. $Y^(tau)$], [*X*], [*X*], [],
        [4. Análisis exploratorio de datos (EDA)], [], [*X*], [],
        [5. Ingeniería de características históricas], [], [*X*], [],
        [6. Entrenamiento y validación ($21 times 2$)], [], [*X*], [*X*],
        [7. Comparación e interpretación (XAI / SHAP)], [], [], [*X*],
        [8. Redacción y revisión del informe final], [], [], [*X*],
      )
    ]
  ],
  [
    *Presupuesto estimado (autofinanciado):*
    #v(0.1cm)
    #text(size: 0.68em)[
      #rt((1fr, auto, auto),
        [*Rubro*], [*Cantidad*], [*Costo (S/)*],
        [Asesoría especializada], [3 meses], [6,000.00],
        [Equipos de cómputo y software], [2 equipos], [3,500.00],
        [Cómputo cloud y bases de datos], [3 meses], [1,800.00],
        [Revisión de estilo e impresión], [Global], [700.00],
        [*TOTAL*], [], [*12,000.00*],
      )
    ]
    #v(0.2cm)
    #highlight-box[
      #text(size: 0.74em)[
        *Avance actual:* Se cuenta con un prototipo funcional previo (Gobierno Nacional, modelos GLM/GAM/RF) que sirve como base directa para escalar el pipeline completo del Plan de Tesis.
      ]
    ]
  ],
)

#speaker-note[
En cuanto a la administración del plan, proyectamos un cronograma de 3 meses dividido en 8 etapas. Contamos ya con una base importante avanzada en la integración inicial de MEF/INFObras/INCO/IGEIP y en la programación del pipeline base, lo que hace plenamente viable cumplir con los plazos propuestos.
]

== Puntos clave para validación con el Asesor

+ *Definición empírica del horizonte $tau$ y análisis de sensibilidad:*
  - Fijar $tau$ principal según la distribución empírica del tiempo hasta la primera paralización y plazos contractuales, reportando sensibilidad en $tau in {12, 24, 36}$ meses.
+ *Alcance institucional (Gobierno Nacional vs. Gobiernos Regionales/Locales):*
  - Confirmar si mantenemos el foco principal en *Gobierno Nacional* (por completitud de registros en INFObras/MEF) o si incorporamos una evaluación estratificada en Gobiernos Regionales.
+ *Cruces adicionales con datos del OECE (historial del contratista):*
  - Validar las variables de desempeño previo del contratista/supervisor a construir desde los datos abiertos del OECE bajo la condición temporal $cal(H)_(t_(0 i))$.
+ *Conformidad con la estructura formal del Plan de Tesis (formato FII-UNI):*
  - Revisión de la formulación matemática (Sección 3.1.1), el diseño factorial $7 times 3 times 2$ (Sección 4.5) y la Matriz de Consistencia (Anexo 1) para su presentación oficial.

#speaker-note[
Finalmente, profesor Oporto, hemos sintetizado cuatro puntos clave sobre los cuales quisiéramos recibir sus comentarios y validación hoy: (1) los horizontes tau de evaluación y sensibilidad, (2) el alcance en Gobierno Nacional o su extensión a Gobiernos Regionales, (3) el alcance de las variables históricas del contratista provenientes del OECE, y (4) su visto bueno a la estructura formal del documento para el trámite en la Escuela de Posgrado.
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
