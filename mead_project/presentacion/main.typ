#import "@preview/touying:0.6.1": *
#import "lib.typ": *

#set text(lang: "es")

#show: tub-theme.with(
  aspect-ratio: "16-9",
  department: [Maestría en Ciencias e Ingeniería Estadística · Modelos Estadísticos para el Análisis de Datos (MEAD)],
  logo: image("assets/logos/logo-uni.png"),
  progress-bar: true,
  config-info(
    title: [Estimación del riesgo de paralización de obras públicas en el Perú],
    short-title: [Riesgo de paralización de obras públicas],
    subtitle: [Un análisis comparativo de modelos estadísticos (GLM, GAM y Random Forest)],
    author: [Yan Franco Calderon Felix],
    date: datetime.today(),
    institution: [Universidad Nacional de Ingeniería],
  ),
)

// --- helper para tablas de resultados -------------------------------------
#let rt(cols, ..cells) = table(
  columns: cols,
  align: (col, row) => if col == 0 { left } else { right },
  inset: 6pt,
  stroke: 0.4pt + tub-gray,
  fill: (_, row) => if row == 0 { tub-light-gray },
  ..cells,
)

#title-slide()

#outline-slide()

// =========================================================================
= 1. Entendimiento de la problemática

== El problema de negocio

- La paralización de obras públicas es un problema persistente en el Perú: *2,476 obras paralizadas* a diciembre de 2024, costo total *S/ 43,118 millones*.
- El *incumplimiento contractual* es la causal más relevante: 628 obras (25.4 %), equivalente a S/ 15,913 millones (36.9 % del costo total).
- La respuesta del Estado suele ser *reactiva*: se interviene cuando el contrato ya se resolvió y el margen preventivo se perdió.

#v(0.3cm)
#highlight-box[
Se necesita una medida *cuantitativa y anticipada* de riesgo, disponible desde el inicio de la obra, que permita priorizar recursos de supervisión.
]

#speaker-note[
El punto de partida es un problema real de gestión pública: miles de millones de soles inmovilizados en obras paralizadas, y una gestión que reacciona en vez de anticipar. El incumplimiento contractual es la causal más costosa y, a diferencia de otras causales (clima, conflictos sociales), depende de comportamientos y señales observables durante la ejecución -lo que la hace potencialmente predecible.
]

== Representación de una obra pública

#align(center)[
  #image("assets/figures/imagen1.png", width: 55%)
]

#speaker-note[
Una obra pública nace de un proyecto de inversión y transita por etapas -expediente técnico, contratación, ejecución física y financiera, liquidación- antes de su cierre. Cualquiera de esas etapas puede verse interrumpida; el foco de este estudio es la interrupción por incumplimiento contractual.
]

== Un fenómeno multicausal

#align(center)[
  #image("assets/figures/img_grafo_causales_paralizacion_obras.png", width: 45%)
]

#speaker-note[
Este grafo -construido a partir de la tipificación de causales de la Contraloría- muestra que la paralización no tiene una causa única: hay una red de factores técnicos, contractuales, financieros y externos que confluyen. El incumplimiento de contrato es el nodo con más conexiones de entrada, es decir, el que mejor resume el resto de señales de riesgo.
]

== Formulación estadística del problema

Cada obra pública $i$ se representa como un evento dicotómico:
$ Y_i in {0,1}, quad Y_i = 1 "si la obra se paralizó por incumplimiento contractual" $

El objetivo no es solo clasificar, sino *estimar una probabilidad*:
$ R(X) = hat(p) = P(Y=1 | X = x) $

#pause
- $R(X)$ es la *medida cuantitativa de riesgo*.
- La clasificación binaria $hat(Y) = I(hat(p) >= c)$ es solo una *regla de decisión derivada*, para un umbral $c$ elegido según el costo relativo de falsos negativos y falsos positivos.
- Tarea: *clasificación binaria supervisada*, con fuerte desbalance de clases (7-8 % positivos).

#speaker-note[
Esta distinción es central en todo el trabajo: no se construye "un clasificador de obras paralizadas", sino un modelo probabilístico de riesgo. La clasificación 0/1 es una decisión posterior, con un umbral que se elige según el costo de negocio -no necesariamente 0.5-.
]

== Por qué modelos estadísticos y no solo Machine Learning

- Estudios previos (Gondia et al. 2020; Alsulamy 2025; Egwim et al. 2021) muestran que *Random Forest / XGBoost / LightGBM / CatBoost* superan a un modelo lineal base en la predicción de retrasos de construcción.
- Pero esa superioridad en métricas de clasificación *no garantiza*:
  - que las probabilidades sean una estimación *confiable* del riesgo real (calibración);
  - que el modelo sea *interpretable* para los tomadores de decisión.

#v(0.3cm)
#alert-box[
Y es aquí donde los *modelos estadísticos* (como GLM con distintos enlaces, GAM) ofrecen ventajas en términos de interpretabilidad y calibración, incorporando *Random Forest solo como benchmark de contraste*, y evaluando explícitamente estos modelos.
]

#speaker-note[
Aquí se justifica el enfoque del curso: en vez de saltar directo a un algoritmo de caja negra, se prioriza la familia GLM/GAM por su interpretabilidad y se usa Random Forest como referencia de contraste, no como el modelo por defecto.
]

// =========================================================================
= 2. Preprocesamiento de datos

== Modelo de datos del negocio

#align(center)[
  #image("assets/figures/img_modelo_datos_obra_publica.png", width: 50%)
]

#speaker-note[
Este es el diagrama entidad-relación del dominio de negocio: una inversión da lugar a una obra, que se ejecuta bajo un contrato con un contratista y un supervisor, y que puede terminar en un estado de obra vinculado a una causal de paralización. Este modelo es la base para entender de dónde sale cada variable candidata a predictor.
]

== Fuente de datos y filtros funcionales

#rt((auto, auto, auto, auto),
  [*Fuente*], [*Institución*], [*Descripción*], [*Formato*],
  [Banco de Inversiones], [MEF], [Proyectos de inversión pública], [csv],
  [INFObras], [CGR], [Obras públicas / paralizadas], [xls],
  [INCO 2024], [CGR], [Índice de corrupción de la entidad], [xls],
  [IGEIP], [MEF], [Índice de gestión de inversión pública del sector], [html],
)

#v(0.2cm)
Tabla integrada: *69,952 registros × 128 columnas*. Filtros: `nivel_gobierno = "GOBIERNO NACIONAL"`, `marco = "INVIERTE"`, modalidad *por contrata* $arrow.r$ *2,646 observaciones*.

#speaker-note[
El dataset integra InfObras con dos índices adicionales trabajados aparte: INCO (capacidad de gestión de la entidad) e IGEIP (gestión de inversión del sector). Se filtra a Gobierno Nacional y al marco Invierte.pe para trabajar un universo homogéneo.
]

== Causales de paralización consideradas para la clase positiva

#rt((1fr, auto),
  [*Causal de paralización*], [*Categoría*],
  [Incumplimiento de contrato], [CONTRACTUAL],
  [Proceso arbitral], [CONTRACTUAL],
  [Resolución de contrato], [CONTRACTUAL],
  [Discrepancias, controversias y arbitraje], [CONTRACTUAL],
  [Resolución del contrato de supervisión de obra], [CONTRACTUAL],
  [Obra judicializada por la entidad], [CONTRACTUAL],
  [Incumplimiento del pago de valorizaciones u otros], [CONTRACTUAL / FINANCIERA],
)

Esta lista final de causales fue resultado de un trabajo de homologación y filtrado de la información proporcionada por CGR y MEF.

#speaker-note[
La variable objetivo no se limita a la etiqueta "incumplimiento de contrato" reportada literalmente: se agrupan siete causales de INFObras bajo la categoría contractual, ya sea que el incumplimiento sea atribuible al contratista o a la propia entidad.
]

== Variables candidatas a predictores

#text(size: 0.62em)[
#grid(columns: (1fr, 1fr), gutter: 1em,
  rt((auto, auto, auto),
    [*Dominio*], [*Columna*], [*Tipo*],
    [entidad], [`codigo_entidad`], [varchar],
    [entidad], [`nivel_gobierno`], [varchar],
    [entidad], [`sector_entidad`], [varchar],
    [proyecto], [`marco`], [varchar],
    [proyecto], [`codigo_unico`], [varchar],
    [proyecto], [`tipo_formato`], [varchar],
    [proyecto], [`n_obras_relacionadas_proyecto`], [numeric],
    [obra], [`codigo_infobras`], [varchar],
    [obra], [`modalidad_ejecucion_obra`], [varchar],
    [obra], [`estado_ejecucion`], [varchar],
    [obra], [`naturaleza_obra`], [varchar],
    [obra], [`tipo_obra_nivel_1/2/3`], [varchar],
    [obra], [`fecha_inicio_obra`], [date],
  ),
  rt((auto, auto, auto),
    [*Dominio*], [*Columna*], [*Tipo*],
    [ubigeo], [`departamento`], [varchar],
    [ubigeo], [`provincia`], [varchar],
    [ubigeo], [`distrito`], [varchar],
    [ET], [`fecha_aprobacion_expediente`], [date],
    [ET], [`monto_aprobacion_et`], [numeric],
    [ET], [`monto_aprobado_soles`], [numeric],
    [personal], [`colegiatura_1/2`], [varchar],
    [-], [`indice_igeip`], [numeric],
    [-], [`indice_inco`], [numeric],
    [-], [`indice_iri`], [numeric],
  ),
)
]

#speaker-note[
Este es el listado completo de variables candidatas identificadas por juicio de experto y contraste con la literatura, agrupadas por dominio de negocio (entidad, proyecto, obra, ubigeo, expediente técnico, personal). No todas terminan en el modelo final: el análisis de valores faltantes y de cardinalidad que sigue determina cuáles se descartan.
]

== Distribución de la clase positiva por nivel de gobierno y marco

#grid(columns: (1fr, 1fr), gutter: 1em,
  image("assets/figures/img_eda_opa_nivel_gobierno.png", width: 100%),
  image("assets/figures/img_eda_opa_marco.png", width: 100%),
)

#text(size: 0.8em)[Gobierno Nacional concentra la mayor tasa de incumplimiento (7.6 %) frente a Regional (6.4 %) y Local (1.5 %); la tasa es similar entre SNIP e Invierte.pe dentro de cada nivel de gobierno.]

#speaker-note[
Esta comparación justifica el filtro a Gobierno Nacional: no solo es el nivel con mayor tasa de incumplimiento contractual, sino que además concentra mejor calidad y completitud de registro. El marco (SNIP vs. Invierte.pe) no muestra diferencias tan marcadas en la tasa, por lo que el filtro por marco responde más a la vigencia normativa que a un efecto sobre el riesgo.
]

== Valores faltantes

#grid(columns: (1.1fr, 1fr), gutter: 1em,
  image("assets/figures/img_valores_nulos_inicial.png", width: 100%),
  image("assets/figures/img_correlacion_valores_nulos.png", width: 100%),
)

#text(size: 0.8em)[Los faltantes no son independientes entre sí: `tipo_formato`/`des_tipo_formato`, las tres columnas de ubigeo, y las dos de `igeip_sector` están perfectamente correlacionados (co-ocurren siempre juntos).]

#speaker-note[
El bloque izquierdo muestra cuántos registros no nulos tiene cada columna candidata; el derecho, la correlación entre los indicadores de "es nulo" de cada par de columnas. La correlación perfecta entre ciertos pares confirma que el faltante viene de la misma fuente (por ejemplo, un registro sin ubigeo completo típicamente carece de las tres columnas geográficas a la vez), lo que simplifica la estrategia de imputación/descarte.
]

== Limpieza y desbalance de clases

*Limpieza de `monto_aprobado_soles`* (variable clave, con valores inválidos):
- 18 registros con monto nulo $arrow.r$ eliminados (solo afecta la clase mayoritaria).
- 22 registros con monto = 0 $arrow.r$ reemplazados por `monto_aprobacion_et`.
- 1 registro con monto = 1 $arrow.r$ descartado (valor residual inválido).

$arrow.r$ Conjunto final: *2,627 observaciones*.

#v(0.3cm)
#alert-box[
*Desbalance fuerte*: 92.6 % no paralizadas vs. 7.4 % paralizadas por incumplimiento contractual (antes de particionar).
]

#speaker-note[
La limpieza se concentra en el monto porque es un predictor clave y presentaba valores inválidos claros y corregibles con reglas simples. El desbalance de clases es el desafío central que atraviesa todo el resto de decisiones metodológicas.
]

== Efecto de la limpieza sobre `monto_aprobado_soles` (antes)

#align(center)[
  #image("assets/figures/img_monto_soles_analisis.png", width: 88%)
]

#text(size: 0.75em)[Antes de la limpieza: la escala original está dominada por valores extremos y por los montos inválidos (nulos, cero, uno); log1p(monto) ya distingue mejor la distribución por clase.]

#speaker-note[
Este panel de tres gráficos -boxplot en escala original, boxplot en escala log1p, e histograma superpuesto por clase- se genera antes de aplicar las reglas de limpieza. La escala original hace casi imposible comparar clases por la dispersión extrema; la transformación logarítmica ya adelanta que las obras paralizadas tienden a tener montos algo distintos de las no paralizadas.
]

== Efecto de la limpieza sobre `monto_aprobado_soles` (después)

#align(center)[
  #image("assets/figures/img_monto_soles_analisis_limpio.png", width: 88%)
]

#text(size: 0.75em)[Después de la limpieza: se eliminan los registros con monto inválido; la comparación entre clases en escala log1p es más estable y es la que finalmente entra al modelo.]

#speaker-note[
Una vez aplicadas las tres reglas de limpieza (eliminar nulos, imputar ceros con el monto del expediente técnico, descartar el valor residual de 1 sol), la distribución de log1p(monto) queda libre de los artefactos que antes distorsionaban la comparación entre clases. Esta es la versión de la variable que efectivamente se usa como predictor.
]

== Naturaleza de las variables

#rt((auto, auto),
  [*Tipo*], [*Variables*],
  [Categóricas (8)], [`tipo_obra_nivel_1/2/3`, `departamento`, `provincia`, `codigo_entidad`, `sector_entidad`, `naturaleza_obra`, `tipo_formato`],
  [Numéricas continuas], [`monto_aprobado_soles` (log), `n_obras_relacionadas_proyecto`, `inco_2024_entidad`, `igeip_sector`, `igeip_sector_ejecucion`],
  [Derivada (temporal)], [`tasa_historica_movil_entidad`: media expandida y causal de la tasa de paralización de la entidad],
)

#v(0.2cm)
*Valores faltantes:* `igeip_sector`/`igeip_sector_ejecucion` 19.3 % cada una (el índice IGEIP no cubre todos los sectores); `tipo_formato` 3.6 %; resto prácticamente completas.

#speaker-note[
Se distinguen tres naturalezas de variable. La variable derivada -la tasa histórica móvil- es la pieza de ingeniería de características más particular del proyecto: un análogo de un lag o media móvil de series de tiempo, aplicado a datos de panel donde cada fila es un proyecto distinto pero varias comparten la misma entidad ejecutora a través del tiempo.
]

== Análisis categórico: colegiatura del residente de obra

#align(center)[
  #image("assets/figures/img_analisis_categotico_colegiatura_2.png", width: 78%)
]

#text(size: 0.78em)[Izquierda: frecuencia por categoría. Derecha: tasa de incumplimiento por categoría, con línea de referencia en la tasa global (7.5 %).]

#speaker-note[
Este es el primero de seis análisis categóricos con el mismo formato: un panel de frecuencias y un panel de tasa de incumplimiento por categoría frente a la tasa global. La colegiatura del residente de obra se evalúa como proxy de la calidad de supervisión técnica.
]

== Análisis categórico: departamento

#align(center)[
  #image("assets/figures/img_analisis_categotico_departamento.png", width: 78%)
]

#text(size: 0.78em)[La tasa de incumplimiento varía notoriamente entre departamentos, lo que motiva usar target encoding en vez de one-hot (alta cardinalidad, 25 categorías).]

#speaker-note[
El departamento muestra heterogeneidad relevante en la tasa de incumplimiento, y al ser una variable de alta cardinalidad es una candidata natural para target encoding en vez de one-hot, para no explotar la dimensionalidad del modelo.
]

== Análisis categórico: tipo de formato de inversión

#align(center)[
  #image("assets/figures/img_analisis_categotico_des_tipo_formato.png", width: 78%)
]

#text(size: 0.78em)[El tipo de formato (ficha técnica simplificada, estándar, estudio de preinversión, etc.) refleja la complejidad del ciclo de inversión del proyecto.]

#speaker-note[
El tipo de formato de inversión distingue el nivel de complejidad exigido en el ciclo Invierte.pe: formatos más simples suelen usarse en proyectos de menor envergadura, lo que puede correlacionarse con distinta exposición al riesgo de incumplimiento.
]

== Análisis categórico: naturaleza de la obra

#align(center)[
  #image("assets/figures/img_analisis_categotico_naturaleza_obra.png", width: 78%)
]

#text(size: 0.78em)[Categorías como "Ampliación" o "Mejoramiento" muestran tasas de incumplimiento distintas de "Construcción" o "Rehabilitación".]

#speaker-note[
La naturaleza de la obra (construcción, ampliación, mejoramiento, rehabilitación, entre otras) tiene baja cardinalidad, por lo que se codifica con one-hot; aun así se observan diferencias visibles en la tasa de incumplimiento entre categorías.
]

== Análisis categórico: sector de la entidad

#align(center)[
  #image("assets/figures/img_analisis_categotico_sector.png", width: 78%)
]

#text(size: 0.78em)[La alta cardinalidad y dispersión de tasas por sector motiva el uso de Weight of Evidence en lugar de target encoding simple.]

#speaker-note[
El sector de la entidad ejecutora tiene cardinalidad alta y una relación no trivial con la tasa de incumplimiento, por lo que se prefiere WOE: además de codificar, permite calcular el Information Value de la variable.
]

== Análisis categórico: tipo de obra (nivel 1)

#align(center)[
  #image("assets/figures/img_analisis_categotico_tipo_obra_1.png", width: 78%)
]

#text(size: 0.78em)[El nivel 1 de la jerarquía de tipo de obra (la más agregada) se codifica con one-hot por su baja cardinalidad.]

#speaker-note[
Tipo de obra tiene tres niveles jerárquicos de detalle; el nivel 1, al ser el más agregado y de baja cardinalidad, se codifica con one-hot, mientras que los niveles 2 y 3 -de mayor cardinalidad- usan target encoding.
]

== Codificación de variables categóricas

Tres estrategias, según cardinalidad, ajustadas *solo con el conjunto de entrenamiento*:

+ *Target encoding bayesiano* (`tipo_obra_nivel_2/3`, `departamento`, `provincia`): media ponderada entre la tasa observada y la tasa global, $n_c \/ (n_c + s)$.
+ *Weight of Evidence (WOE)* (`codigo_entidad`, `sector_entidad`): variables de cardinalidad muy alta; permite además cuantificar el Information Value.
+ *One-hot encoding* (`naturaleza_obra`, `tipo_formato`, `tipo_obra_nivel_1`): baja cardinalidad.

#v(0.2cm)
#highlight-box[
Los encoders supervisados se ajustan *dentro* de un único `Pipeline`, refit en cada partición de validación cruzada $arrow.r$ evita fuga de información del test hacia el entrenamiento.
]

#speaker-note[
Esta es una de las mejoras metodológicas más importantes frente a versiones previas del trabajo: los encoders supervisados viven dentro del mismo pipeline que el clasificador, así que se reajustan de forma independiente en cada fold de la validación cruzada, no una sola vez sobre todo el train.
]

// =========================================================================
= 3. Proceso de experimentación

== Partición temporal (no aleatoria)

#align(center)[
  #image("assets/figures/img_particion_temporal_train_test.png", width: 70%)
]

- *Train*: 1,628 obras · 2010-12-18 a 2022-10-22 · tasa positiva *8.48 %*
- *Test*: 999 obras · 2022-10-22 a 2025-12-20 · tasa positiva *5.91 %*

En pruebas antes de esta partición se detecto deriva de datos

#speaker-note[
Se ordena por fecha de inicio de obra y se separa el 62% más antiguo para train, 38% más reciente para test. Esto simula el uso real del modelo: entrenar con la historia para estimar el riesgo de obras que todavía no se han observado. La propia diferencia en la tasa base entre ambos periodos es evidencia de que el fenómeno no es estacionario.
]

== Validación cruzada anidada (M2 y RF)

- Bucle *externo* (`TimeSeriesSplit`, 5 particiones): estima el desempeño honesto de cada familia.
- Bucle *interno* (`TimeSeriesSplit`, 3 particiones): búsqueda de hiperparámetros (`GridSearchCV`, optimiza PR-AUC).
- Ningún dato usado para elegir hiperparámetros en un pliegue se usa para evaluar ese mismo pliegue.

#v(0.2cm)
`M4`, `M5`, `M6`, `M7`, `M8` (`statsmodels`) no tienen una interfaz de hiperparámetros compatible con `scikit-learn`: se tratan como *especificaciones teóricas alternativas*, comparadas directamente en test y por AIC/BIC.

#speaker-note[
La validación cruzada anidada aplica solo a las dos familias compatibles con scikit-learn, M2 y RF. Los modelos GLM/GAM se comparan de otra forma: como especificaciones estadísticas alternativas evaluadas directamente.
]

== Los ocho modelos comparados

#rt((auto, auto, auto),
  [*Modelo*], [*Familia*], [*Enlace / naturaleza*],
  [M0], [Regresión logística (base)], [logit, sin ponderar ni penalizar],
  [M2], [Regresión logística], [logit, Elastic Net, ponderada],
  [RF], [Random Forest], [benchmark ML, ponderado],
  [M4], [GLM binomial], [complementary log-log, ponderado],
  [M5], [GLM binomial], [probit, ponderado],
  [M6], [GAM], [logit, ponderado],
  [M7], [GAM], [complementary log-log, ponderado],
  [M8], [GAM], [probit, ponderado],
)

#speaker-note[
En total, ocho especificaciones: una línea base sin ponderar, una logística penalizada y un Random Forest seleccionados por validación cruzada anidada, dos GLM con enlaces alternativos, y tres GAM -uno por cada función de enlace-.
]

== Desbalance de clases: pesos, no remuestreo

#alert-box[
*No se usa* SMOTE ni sobre/sub-muestreo: alterar la proporción de clases distorsiona la probabilidad base que un GLM/GAM estima por máxima verosimilitud, y complica la interpretación de sus coeficientes como odds ratio o razón de riesgo.
]

En su lugar, *pesos de caso*: $w_c = n \/ (2 dot n_c)$ -misma fórmula que `class_weight="balanced"` de scikit-learn-. Aplicado a `M2`, `RF`, `M4`-`M8`; `M0` se deja sin ponderar como referencia.

#v(0.2cm)
#text(size: 0.85em)[*Nota de implementación:* el ajuste ponderado bajo el enlace c-loglog divergía con los optimizadores por defecto de `statsmodels` (IRLS/PIRLS); se reemplazaron por *BFGS*, lo que estabilizó los ocho modelos.]

#speaker-note[
Este fue un hallazgo real durante la implementación, no anticipado: el optimizador por defecto de statsmodels producía coeficientes de magnitud extrema para el enlace c-loglog ponderado. Cambiar a BFGS -un optimizador de propósito general- resolvió el problema de forma consistente para todos los modelos.
]

// =========================================================================
= 4. Medidas de calidad escogidas

== Cuatro dimensiones de comparación

El objetivo es una *probabilidad de riesgo*, no solo una etiqueta $arrow.r$ una única métrica de clasificación es insuficiente.

#grid(columns: (1fr, 1fr), gutter: 1em,
  [
    *Discriminación*
    - ROC AUC, PR AUC (más informativa bajo desbalance)
    - Gini $= 2 dot "AUC" - 1$

    *Calibración*
    - Brier score $= (1\/n) sum (hat(p)_i - y_i)^2$
    - Curva de calibración
  ],
  [
    *Decisión (umbral = 0.5)*
    - Precisión, Recall, F1
    - *F2-score* (pondera 2× el recall)

    *Interpretabilidad*
    - Odds ratio / razón de riesgo
    - Importancia (impureza y permutación)
  ],
)

#speaker-note[
Se prioriza F2 sobre F1 porque, en este problema, un falso negativo -no detectar una obra que sí se va a paralizar- se considera más costoso que un falso positivo -investigar una obra que finalmente no se paraliza-. La calibración se incorpora como una dimensión de primer nivel, no como una verificación posterior, porque el producto final es una probabilidad de riesgo.
]

== Taxonomía de métricas para clasificación desbalanceada

#align(center)[
  #image("assets/figures/img_metricas_clasificacion_desbalanceada.png", width: 50%)
]

#text(size: 0.75em)[Adaptado de Brownlee (2020). La elección de métrica depende de si el interés está en etiquetas de clase o en probabilidades.]

#speaker-note[
Este árbol de decisión resume el criterio para elegir métricas bajo desbalance de clases: si interesa la etiqueta, se desciende hacia accuracy, F-scores o G-mean; si interesa la probabilidad -que es el caso de este estudio, dado que el objetivo es una estimación de riesgo-, se desciende hacia PR AUC, ROC AUC o Brier score. Esto justifica por qué el marco de evaluación adoptado combina varias de estas familias en vez de optimizar una sola métrica.
]

== Por qué la calibración es tan importante como la discriminación

#highlight-box[
Dos modelos con el mismo ROC AUC pueden tener probabilidades muy distintas de confiables. El Brier score y la curva de calibración distinguen un *modelo de clasificación* de un *modelo de estimación de riesgo*.
]

- Si $hat(p) = 0.30$ para 100 proyectos y el modelo está bien calibrado, *~30* de ellos deberían terminar paralizados.
- Ponderar por clase (necesario para mejorar el recall) puede *distorsionar* esta propiedad: el intercepto deja de reflejar el riesgo real de la población.

#speaker-note[
Esta es la idea que se termina confirmando empíricamente en los resultados: ponderar mejora el recall pero, en los modelos lineales, empeora sustancialmente la calibración.
]

// =========================================================================
= 5. Interpretación de resultados

== Comparativa final (conjunto de prueba, umbral = 0.5)

#text(size: 0.90em)[
#rt((auto, auto, auto, auto, auto, auto, auto),
  [*Modelo*], [*ROC AUC*], [*PR AUC*], [*Brier*], [*Recall*], [*F1*], [*F2*],
  [M0 – Logística base], [0.689], [0.180], [0.061], [0.085], [0.118], [0.095],
  [M2 – Logística E.N.], [0.661], [0.150], [0.205], [0.559], [0.179], [0.302],
  [RF – Random Forest], [0.633], [0.139], [0.135], [0.441], [0.213], [0.309],
  [M4 – GLM c-loglog], [0.686], [0.169], [0.187], [0.610], [0.216], [*0.353*],
  [M5 – GLM probit], [0.669], [0.154], [0.203], [0.627], [0.207], [0.346],
  [M6 – GAM logit], [0.659], [0.163], [*0.066*], [0.102], [0.129], [0.111],
  [M7 – GAM c-loglog], [0.660], [0.169], [0.067], [0.102], [0.126], [0.110],
  [M8 – GAM probit], [0.653], [0.156], [0.067], [0.068], [0.087], [0.074],
)
]

#speaker-note[
La tabla central de resultados. M4 tiene el mejor F2. Los tres GAM ponderados tienen el mejor Brier score, muy por debajo del resto de modelos ponderados. Esta disociación entre las dos columnas es el hallazgo que se profundiza a continuación.
]

== El hallazgo central: ponderar mejora recall, empeora calibración

#grid(columns: (1fr, 1fr), gutter: 1em,
  [
    #highlight-box[
    *M2, M4, M5* (ponderados, lineales): mejor recall/F2, *peor Brier* (0.19-0.21).
    ]
    #v(0.2cm)
    #alert-box[
    *M0* (sin ponderar): mejor Brier (0.061), recall casi nulo al umbral 0.5.
    ]
  ],
  [
    #v(0.2cm)
    *M6, M7, M8* (GAM ponderados): Brier 0.066-0.067 -casi igual a M0- *pese* a estar ponderados.

    #v(0.3cm)
    #text(size: 0.85em)[La flexibilidad de los términos suaves parece absorber parte de la distorsión que la ponderación introduce en un modelo puramente lineal.]
  ],
)

#pause
#v(0.2cm)
 M0 responde "¿qué tan probable es, en términos absolutos, que se paralice?"; M2/M4/M5 responden mejor "¿pertenece al grupo de mayor riesgo relativo?".

#speaker-note[
Este es el resultado más importante de todo el estudio, y es el aporte directo de haber incorporado calibración como criterio de comparación en vez de limitarse a F1/F2/AUC. Los modelos aditivos muestran que es posible, al menos parcialmente, tener ambas cosas.
]

== Validación cruzada anidada y especificación GLM/GAM

#grid(columns: (1fr, 1fr), gutter: 1.5em,
  [
    *M2 vs. RF (train, anidada)*
    #rt((auto, auto, auto),
      [*Familia*], [*PR AUC*], [*F2*],
      [M2], [0.236 ± 0.097], [0.326 ± 0.133],
      [RF], [0.269 ± 0.145], [0.177 ± 0.140],
    )
    #text(size: 0.75em)[RF gana en CV interna, pero *no* se sostiene en test (ver tabla anterior).]
  ],
  [
    *AIC/BIC (GLM/GAM)*
    #rt((auto, auto, auto),
      [*Modelo*], [*AIC*], [*log-vero.*],
      [M4], [1302.1], [-619.0],
      [M5], [1308.9], [-622.4],
      [M6], [690.7], [-277.3],
      [M7], [682.6], [-273.3],
      [M8], [683.3], [-273.7],
    )
  ],
)

#speaker-note[
Dos observaciones adicionales. RF gana la validación cruzada anidada en entrenamiento pero pierde consistencia en el test final -un recordatorio de no confiar en una sola instancia de validación-. Los GAM logran una log-verosimilitud mucho mejor que los GLM lineales gracias a su flexibilidad, aunque a costa de más parámetros efectivos (mayor BIC).
]

== Interpretabilidad: ¿qué variables explican el riesgo?

*Odds ratio significativos (M0, p < 0.05):*
- `codigo_entidad` (WOE): $beta=1.43$, *OR = 4.17* -- historial de la entidad ejecutora
- `provincia` (target enc.): $beta=0.92$, *OR = 2.50* -- ubicación geográfica
- monto aprobado (log): $beta=0.71$, *OR = 2.04*
- `naturaleza_obra = Instalación`: $beta=-3.05$, *OR = 0.047* (protector)

#v(0.2cm)
*Importancia por permutación (RF, PR-AUC test):* `naturaleza_obra` (0.040) > `tipo_formato` (0.020) > `monto_aprobado_soles` (0.018) > `codigo_entidad` (0.017)

#v(0.2cm)
#highlight-box[
El mismo patrón -historial de la entidad, ubicación y monto- se repite en M0, M2, M4 y en la importancia de RF: una señal *consistente* entre especificaciones muy distintas.
]

#speaker-note[
La consistencia del patrón entre modelos tan distintos -una regresión logística penalizada, un GLM con enlace asimétrico y un ensamble de árboles- es en sí misma una forma de validación cruzada conceptual del hallazgo: no depende de la especificación elegida.
]

// =========================================================================
= 6. Conclusiones

== ¿Cuál es el mejor modelo?

#alert-box[
No hay un único mejor modelo cuando el objetivo es estimar riesgo, no solo clasificar.
]

- Por *F2-score* (mayor peso al recall): *M4* (GLM c-loglog ponderado) — F2 = 0.353, recall = 0.610.
- Por *calibración* (Brier score): *M0* y los *GAM ponderados* (M6-M8).

#v(0.3cm)
#highlight-box[
Recomendación: M4 como mejor compromiso operativo (detección + calibración razonable + coeficientes interpretables como razón de riesgo), con la salvedad explícita de que sus probabilidades deben leerse como riesgo relativo, no como frecuencia esperada literal.
]

#speaker-note[
La recomendación final no es un número aislado, sino una decisión que depende del criterio priorizado -exactamente el mensaje central del enfoque de cuatro dimensiones presentado en la sección de métricas-.
]

== Principales hallazgos

+ Existen factores observables (historial de la entidad, ubicación geográfica, monto del proyecto) asociados de forma consistente al riesgo, independientemente de la especificación estadística.
+ Ponderar por clase mejora el recall de los modelos lineales a costa de su calibración; los GAM ponderados atenúan ese costo.
+ El benchmark de Machine Learning (RF) no ofreció una ventaja consistente en test, pese a ganar en la validación cruzada de entrenamiento.

#speaker-note[
Estos cuatro puntos resumen tanto los hallazgos sustantivos -sobre el fenómeno de negocio- como los metodológicos -sobre cómo comparar modelos y sobre la implementación numérica-.
]

== Limitaciones y trabajo futuro

*Limitaciones*
- Tamaño de muestra reducido (2,627 obs., 138-190 positivos) frente al número de categorías.
- `igeip_sector`/`igeip_sector_ejecucion`: 19.3 % de nulos y dispersión reducida $arrow.r$ aporte limitado.
- Inestabilidad numérica bajo c-loglog (sm): resultados deberían replicarse con otro software como R.

#v(0.2cm)
*Líneas futuras*
- Recalibración post-hoc (Platt / isotónica) sobre los modelos ponderados.
- Validación cruzada temporal de origen móvil (_rolling origin_).
- Enriquecer variables del contratista (datos del OECE); interpretabilidad complementaria (SHAP) si se prioriza un modelo de ML.

#speaker-note[
Las limitaciones no son solo formales: cada una sugiere directamente una línea de trabajo futuro concreta, ya sea de datos, de modelamiento o de validación.
]

#ending-slide(title: [¡Gracias!])[
  #text(size: 0.9em)[Yan Franco Calderon Felix]

  #v(0.3cm)
  #text(size: 0.72em, fill: tub-gray)[
    Maestría en Ciencias e Ingeniería Estadística \
    Universidad Nacional de Ingeniería \
    Curso: Modelos Estadísticos para el Análisis de Datos (MEAD)
  ]

  #v(0.5cm)
  #text(size: 0.7em)[_¿Preguntas?_]
]
