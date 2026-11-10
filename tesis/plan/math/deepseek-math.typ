// =============================================================================
// PROPUESTA DE REEMPLAZO — Sección "Representación formal del problema"
// Plan de tesis: paralización de obras públicas (UNI — Mención IA)
//
// Uso: reemplaza el párrafo actual de la sección 1.2.2 "Representación del
// Problema" de main copy.typ (línea ~330-336). El texto está escrito con los
// mismos recursos tipográficos del documento (Typst, numeración de ecuaciones).
//
// Cambios respecto de la versión "Formulación NEW":
//   1. El evento se define como paralización POR CAUSAL CONTRACTUAL (no "cualquier
//      paralización"), con eventos competitivos explícitos.
//   2. Se elimina la convención T = +infinity como atajo y se introduce el
//      seguimiento disponible C_i y el indicador R_i, ligados a la fecha de corte.
//   3. Se define la cohorte elegible (C_i >= tau), que resuelve la censura
//      administrativa sin imputar Y = 0.
//   4. Se exige que X sea medible respecto de la información disponible al inicio
//      (regla "as-of"), lo que prohíbe la fuga temporal en las tasas históricas.
//   5. El estimador se define como minimizador de una regla de puntuación propia
//      (log-loss / Brier) sobre una clase de hipótesis, y no como un operador
//      abstracto sin restricciones.
//   6. Se formaliza la calibración y se vincula el riesgo del estimador con el
//      Brier score.
//   7. Se declaran los supuestos de identificación (A1-A6) y sus consecuencias
//      metodológicas (C1-C5).
// =============================================================================

=== 1.2.2 Representación formal del problema

La paralización de obras públicas constituye un fenómeno de naturaleza incierta
cuya ocurrencia puede estar asociada con características institucionales,
técnicas, económicas, contractuales y territoriales de las obras. Desde una
perspectiva estadística, el problema consiste en estimar la probabilidad de que
una obra pública experimente una primera paralización por causal contractual
dentro de un horizonte temporal fijado, condicionada a las características
conocidas al inicio de su ejecución.

Esta formulación es independiente de la familia de modelos estadísticos o de los
algoritmos de aprendizaje automático que se empleen para la estimación. Para
ello se distinguen el fenómeno de interés, el modelo probabilístico poblacional,
su representación muestral y la estimación obtenida a partir de los datos
observados.

*Delimitación del fenómeno y de la población objetivo.*

Sea $(Omega, cal(F), PP_0)$ un espacio de probabilidad que representa el proceso
generador de datos. La población objetivo $cal(U)$ está constituida por las obras
públicas que (i) iniciaron su ejecución física; (ii) cuentan con fecha de inicio
registrada; (iii) se ejecutan por la modalidad de contrata; (iv) están vinculadas
a un código de inversión del Banco de Inversiones; y (v) satisfacen los criterios
de elegibilidad de la sección 1.2.3.2. La unidad de análisis es la obra
individual, identificada mediante un código único, aun cuando distintas obras
puedan pertenecer a un mismo proyecto de inversión.

Para cada obra se considera el vector aleatorio de características

$ bold(X) = (X_1, X_2, ..., X_p)' in RR^p, $ <ec-vector-caracteristicas>

cuyas componentes son medibles respecto de la información disponible al inicio
de la ejecución. Formalmente, si $cal(F)_(i,0)$ denota la filtración de
información observable hasta la fecha de inicio de la obra $i$, se exige que
$bold(X)_i in cal(F)_(i,0)$. Esta condición excluye el uso de información
posterior al inicio y, en particular, de variables construidas con desenlaces de
obras que aún no habían ocurrido en la fecha de inicio considerada.

Sea $T_i in (0, infinity]$ el tiempo transcurrido desde el inicio de la
ejecución hasta la primera paralización de la obra $i$ cuya causal pertenezca al
conjunto $cal(C)$ de causales contractuales definidas en la. Si la obra no experimenta dicho evento se adopta
$T_i = infinity$. Sea $J_i in {1, ..., K}$ la causal de la primera paralización,
de modo que el evento de interés es ${T_i <= tau, J_i in cal(C)}$. Las
paralizaciones por causales ajenas a $cal(C)$ se tratan como eventos
competitivos y no como ausencia de riesgo.

Para un horizonte de predicción $tau > 0$ se define la variable de respuesta

$ Y_i^(tau) = cases(
  1 & "si" T_i <= tau "y" J_i in cal(C),
  0 & "si" T_i > tau "o" J_i in.not cal(C),
) $ <ec-variable-respuesta>

De este modo, $Y_i^(tau) = 1$ indica la ocurrencia de una primera paralización
contractual dentro del horizonte, mientras que $Y_i^(tau) = 0$ indica que la obra
no experimentó dicho evento en ese intervalo, sea porque continuó su ejecución,
porque concluyó, o porque se paralizó por una causal distinta. Esta última
distinción es relevante para la interpretación: $1 - p_tau (bold(x))$ no es la
probabilidad de concluir la obra, sino la de no experimentar una paralización
contractual dentro del horizonte $tau$.

*Formulación probabilística a nivel poblacional.*

El par aleatorio $(bold(X), Y^(tau))$ induce una distribución de probabilidad
desconocida $P_0^(tau)$ sobre $RR^p times {0,1}$. El objeto de interés es la
función de riesgo (probabilidad) absoluto

$ p_tau (bold(x)) = PP_0 (Y^(tau) = 1 mid(|) bold(X) = bold(x)), quad bold(x) in "supp"(P_X), $ <ec-proba-condicional>

donde se asume la existencia de una versión regular de la probabilidad
condicional. La función $p_tau$ representa una propiedad desconocida de la
distribución poblacional y constituye la cantidad que se busca estimar; en esta
formulación general no se supone una expresión funcional específica para ella.

Dada la naturaleza binaria de $Y^(tau)$, la probabilidad condicional coincide con
la esperanza condicional,

$ p_tau (bold(x)) = EE_0 (Y^(tau) mid(|) bold(X) = bold(x)), $ <ec-esperanza-condicional>

y la distribución condicional de la respuesta se representa como

$ Y^(tau) mid(|) bold(X) = bold(x) tilde.op "Bernoulli"(p_tau (bold(x))). $ <ec-distribucion-bernoulli>

De manera complementaria, se define la probabilidad marginal de paralización
contractual como

$ pi_tau = PP_0 (Y^(tau) = 1) = EE_0 (p_tau (bold(X))), $ <ec-prob-marginal>

donde la segunda igualdad se obtiene por la propiedad de la esperanza iterada. El
parámetro $pi_tau$ expresa la proporción esperada de obras que experimentarían
una primera paralización contractual dentro del horizonte considerado, mientras
que $p_tau (bold(x))$ permite diferenciar el riesgo según las características de
cada obra. Esta distinción es fundamental para el problema de investigación,
puesto que el objetivo no consiste únicamente en determinar la frecuencia general
del fenómeno, sino en obtener estimaciones individualizadas de su probabilidad
condicional.

*Formulación a nivel muestral.*

Dado que $P_0^(tau)$ es desconocida, $p_tau$ debe estimarse a partir de
información observada. En una representación estadística ideal se considera una
muestra aleatoria de tamaño $n$,

$ cal(D)_n = (Z_1, Z_2, ..., Z_n), quad Z_i = (bold(X)_i, Y_i^(tau)), quad i = 1, ..., n, $ <ec-unidad-muestral>

bajo el supuesto inicial de que las observaciones son realizaciones
independientes de una misma distribución poblacional:

$ Z_1, ..., Z_n limits(tilde.op)^"iid" P_0^(tau). $ <ec-muestra-aleatoria>

Este supuesto proporciona un marco conceptual para definir los estimadores y su
error; su adecuación empírica se examina en la sección 4.7, donde se reconoce que
los registros proceden de fuentes administrativas, que distintas obras comparten
proyecto de inversión o entidad ejecutora y que la evaluación se realiza bajo un
esquema temporal. La distribución empírica asociada a la muestra es

$ hat(PP)_n (A) = 1/n sum_(i=1)^n bb(1)(Z_i in A), $ <ec-distribucion-empirica>

donde $A$ es un conjunto medible de posibles observaciones y $bb(1)(dot)$ es la
función indicadora. Cabe precisar que $hat(PP)_n$ no constituye por sí misma un
estimador de $p_tau (bold(x))$: cuando $bold(X)$ es continuo, el evento
${bold(X) = bold(x)}$ tiene probabilidad nula y la medida empírica no proporciona
información local en $bold(x)$. Por ello, la estimación de la probabilidad
condicional requiere restringir la búsqueda a una clase de funciones
$cal(H) subset {f: RR^p -> [0,1]}$ y definir un criterio de riesgo.

Si las respuestas se encuentran completamente observadas y la muestra es
representativa de la población objetivo, la probabilidad marginal puede
estimarse mediante la proporción muestral

$ hat(pi)_(n,tau) = 1/n sum_(i=1)^n Y_i^(tau). $ <ec-estimador-proporcion>

No obstante, el objetivo principal de la investigación requiere estimar una
función de probabilidad condicional y no solamente un parámetro marginal. Con
este fin se introduce un procedimiento de estimación $cal(A)_n$ que transforma
la información muestral en una función estimada:

$ hat(p)_(n,tau) = cal(A)_n (cal(D)_n), quad hat(p)_(n,tau): RR^p -> [0,1]. $ <ec-estimador-funcional>

De manera explícita, se considera la familia de estimadores definida por la
minimización del riesgo empírico respecto de una regla de puntuación estrictamente
propia $ell$ (pérdida logarítmica o pérdida de Brier):

$ hat(p)_(n,tau) = op("arg min")_(f in cal(H)) 1/n sum_(i=1)^n ell(Y_i^(tau), f(bold(X)_i)). $ <ec-estimador-erm>

La notación $cal(A)_n$ resume, así, el par (clase de hipótesis, regla de
estimación) e incluye la selección de hiperparámetros cuando corresponda. La
elección de una regla de puntuación propia garantiza que el criterio de ajuste y
el criterio de evaluación sean el mismo objeto matemático, lo que permite
comparar modelos estadísticos y algoritmos de aprendizaje automático bajo un
marco común y justifica que la evaluación se centre en la calidad de las
probabilidades y no solo en la discriminación.

El error de estimación se cuantifica mediante el riesgo cuadrático poblacional

$ cal(R)(hat(p)_tau) = EE_(P_X) [(hat(p)_tau (bold(X)) - p_tau (bold(X)))^2], $ <ec-error-estimacion>

que es la componente reducible del Brier score, ya que
$PP (Y^(tau) = 1 mid(|) bold(X)) = p_tau (bold(X))$ implica
$"BS" = cal(R)(hat(p)_tau) + EE [p_tau (bold(X))(1 - p_tau (bold(X)))]$. El segundo
término es irreducible y depende de la heterogeneidad del fenómeno, no del modelo.
Se distingue, por tanto, entre la función poblacional $p_tau$ y su estimador
$hat(p)_(n,tau)$: el primero es un parámetro, el segundo una función aleatoria que
depende de la muestra, de modo que en general
$hat(p)_(n,tau)(bold(x)) != p_tau (bold(x))$ para todo $bold(x)$.

Una propiedad adicional relevante para la aplicación es la calibración. Se dice
que $hat(p)_(n,tau)$ está calibrado si

$ EE [Y^(tau) mid(|) hat(p)_(n,tau)(bold(X)) = p] = p, quad "para todo " p in [0,1]. $ <ec-calibracion>

La calibración es la condición que autoriza a interpretar el valor estimado como
una probabilidad y, por tanto, la que sustenta el uso del modelo como medida
cuantitativa de riesgo.

*Formulación a nivel de datos observados.*

En la aplicación empírica, la muestra aleatoria se materializa en un conjunto
específico de registros administrativos,

$ d_n = {(bold(x_i), y_i^(tau))}_(i=1)^n, $ <ec-dataset-observado>

que constituye una realización particular de $cal(D)_n$. El procedimiento de
estimación produce entonces una función específica

$ hat(p)_(n,tau) (dot; d_n) = cal(A)_n (d_n), $ <ec-estimacion-datos>

y, para una obra con características observadas $bold(x)^star$, la probabilidad
estimada de experimentar una primera paralización contractual dentro del
horizonte $tau$ es

$ hat(p)^star = hat(p)_(n,tau) (bold(x)^star; d_n) in [0,1]. $ <ec-prediccion-individual>

Su interpretación es probabilística y no constituye una clasificación
dicotómica; la transformación de probabilidades en decisiones requiere un umbral
de decisión y una función de pérdida explícitos, los cuales corresponden a una
etapa posterior de la investigación (sección 3.2.6).

*Observación de la variable de respuesta: seguimiento y censura.*

La construcción del conjunto de datos exige distinguir entre la ausencia de una
paralización registrada y la observación completa del horizonte definido. Sea

$ C_i = min(t_i^"corte", t_i^"fin") - t_i^"inicio", quad R_i^(tau) = bb(1)(C_i >= tau), $ <ec-indicador-observacion>

donde $t_i^"inicio"$, $t_i^"fin"$ y $t_i^"corte"$ denotan las fechas de inicio,
de conclusión —si existe— y de corte de la fuente, respectivamente. $C_i$ es el
seguimiento efectivamente disponible y $R_i^(tau) = 1$ indica que la respuesta
$Y_i^(tau)$ es identificable.

La estimación principal se restringe a la cohorte elegible
$cal(D)_(n,tau) = {i in 1, ..., n : R_i^(tau) = 1}$, de modo que toda obra
incluida posee seguimiento completo durante el horizonte. Las obras con
$R_i^(tau) = 0$ no se codifican como $Y_i^(tau) = 0$; se excluyen del estimando
principal y se reservan para análisis de sensibilidad, o bien se incorporan
mediante ponderación por el inverso de la probabilidad de observación bajo un
supuesto de observación MAR. Adicionalmente, la fecha de paralización registrada
en una fotografía de INFOBRAS puede corresponder al evento más reciente y no a la
primera paralización; por ello, la construcción de $T_i$ y $J_i$ debe
fundamentarse en reglas explícitas de reconstrucción histórica, cuya definición
operativa se desarrolla en el capítulo metodológico.

*Supuestos de identificación.*

El estimando $p_tau (bold(x))$ es identificable a partir de los datos bajo los
siguientes supuestos.

+ *A1. Cohorte completa.* Todas las obras de la cohorte elegible cuentan con
  seguimiento igual o superior a $tau$ desde su fecha de inicio.
+ *A2. Consistencia del evento.* La regla de reconstrucción histórica recupera la
  primera paralización contractual y su fecha; si ello no fuera posible, el
  estimando se redefine como la prevalencia de paralización contractual al corte
  y se explicita el cambio de interpretación.
+ *A3. Información as-of.* Todas las componentes de $bold(X)_i$ son medibles
  respecto de $cal(F)_(i,0)$; las tasas históricas por entidad, departamento o
  tipología se calculan únicamente con obras cuyo desenlace era conocido antes de
  $t_i^"inicio"$.
+ *A4. Muestreo.* Las obras se conciben como realizaciones de una superpoblación;
  se admite dependencia intra-entidad e intra-proyecto, que se aborda mediante
  validación agrupada y, eventualmente, modelos con efectos aleatorios.
+ *A5. Observación.* El mecanismo que determina $R_i^(tau) = 0$ es independiente
  del desenlace no observado (MCAR) o, al menos, condicionalmente independiente
  dado $bold(X)_i$ (MAR).
+ *A6. Estabilidad temporal.* La distribución $P_0^(tau)$ se mantiene estable en
  la ventana de estudio, o su evolución se modela explícitamente mediante
  covariables temporales.

*Consecuencias metodológicas.*

+ *C1. Horizonte.* $tau$ debe fijarse ex ante y justificarse empíricamente
  (por ejemplo, a partir de la curva de incidencia acumulada estimada por
  Kaplan-Meier), y no seleccionarse después de observar el desempeño de los
  modelos.
+ *C2. Cohorte.* Con un corte en $t^"corte"$, la cohorte elegible comprende las
  obras iniciadas antes de $t^"corte" - tau$; el tamaño muestral es, por tanto,
  un resultado de esa restricción y condiciona la viabilidad del análisis.
+ *C3. Ponderación de clases.* La ponderación por clase modifica la distribución
  efectiva de entrenamiento y, con ella, la probabilidad estimada; si se emplea,
  debe corregirse el intercepto del modelo o recalibrarse la salida antes de
  interpretar los valores como probabilidades.
+ *C4. Evaluación.* La comparación entre modelos debe reportar, además de las
  métricas de discriminación, el Brier score, su descomposición y medidas de
  calibración; el análisis de curvas de decisión permite vincular el umbral con
  las consecuencias operativas de la decisión.
+ *C5. Dependencia.* La validación debe respetar la estructura temporal y de
  agrupamiento (particiones por entidad o proyecto), ya que la independencia
  entre observaciones no es defendible en registros administrativos.

*Síntesis del problema de estimación.*

A partir de las definiciones anteriores, el problema fundamental de investigación
consiste en construir, a partir de los datos disponibles, una función estimada

$ hat(p)_(n,tau): RR^p -> [0,1] $ <ec-objetivo-fundamental>

que aproxime la función poblacional desconocida $p_tau (bold(x))$, con un error
de estimación medido por  y bajo los supuestos A1-A6. Esta
formulación establece el objeto matemático de la investigación sin imponer una
metodología particular de estimación, una arquitectura de modelo ni una métrica
específica de evaluación.