==== Formulación matemática y estadística del problema

La paralización de obras públicas por incumplimiento contractual constituye un fenómeno de naturaleza estocástica cuya ocurrencia está asociada con características institucionales, técnicas, económicas, contractuales y territoriales. Desde la perspectiva del aprendizaje estadístico, el problema consiste en estimar la probabilidad condicional de que una obra pública experimente su primera paralización por causal contractual dentro de un horizonte temporal definido, dada la información disponible al inicio de su ejecución física.

Esta formulación se establece de manera agnóstica a la familia de modelos paramétricos o algoritmos de aprendizaje automático empleados posteriormente. Para ello, se articulan cuatro niveles formales: la delimitación del fenómeno, el modelo probabilístico poblacional, la representación muestral y la estimación empírica bajo restricciones de observabilidad temporal.

*Delimitación del fenómeno de interés.*

Sea $cal(U)$ la población objetivo de obras públicas por contrata que han iniciado su ejecución física y cumplen los criterios de elegibilidad del estudio. La unidad de análisis es la obra pública individual $i in cal(U)$, con fecha de inicio de ejecución $t_i$.

Para cada obra se considera un vector aleatorio de características medidas al instante $t_i$:
$
  bold(X) = (X_1, X_2, ..., X_p) in cal(X) subset.eq RR^p,
$
donde $cal(X)$ denota el espacio de características (incluyendo variables continuas y categóricas codificadas) medibles respecto al conjunto de información histórica disponible hasta el inicio de la obra, previniendo así la filtración de información futura (_data leakage_).

Sea $T > 0$ el tiempo transcurrido desde el inicio de la ejecución física hasta la ocurrencia de una primera paralización imputable a causales de incumplimiento contractual. Si la obra culmina su ejecución física sin experimentar dicho evento, o nunca se paraliza por dicha causal en su trayectoria, se establece convencionalmente que $T = +infinity$.

Fijado un horizonte de predicción $tau > 0$, se define la variable aleatoria de respuesta binaria:
$
  Y^(tau) = cases(
    1 & "si" T <= tau,
    0 & "si" T > tau.
  )
$ <ec-variable-respuesta>
De este modo, $Y^(tau) = 1$ indica la ocurrencia de una primera paralización contractual dentro del horizonte $tau$, mientras que $Y^(tau) = 0$ denota la ausencia de dicho evento durante el intervalo $[0, tau]$.

*Formulación probabilística a nivel poblacional.*

A nivel poblacional, el par aleatorio $(bold(X), Y^(tau))$ sigue una distribución de probabilidad conjunta desconocida $P_0$ sobre $cal(X) times {0, 1}$. El objeto matemático central de la investigación es la función de probabilidad condicional (o función de riesgo en el horizonte $tau$):
$
  p_(tau)(bold(x))
  = Pr_(0)(
    Y^(tau) = 1 mid(|) bold(X) = bold(x)
  ),
$<ec-proba-condicional>
donde $bold(x) in cal(X)$ representa el perfil de características de una obra y $p_(tau)(bold(x)) in [0,1]$ cuantifica su probabilidad poblacional de paralización contractual. Dada la naturaleza dicotómica de $Y^(tau)$, esta función coincide con la esperanza condicional:
$
  p_(tau)(bold(x))
  = bb(E)_0(
    Y^(tau) mid(|) bold(X) = bold(x)
  ),
  quad "con" quad
  Y^(tau) mid(|) bold(X) = bold(x) ~ "Bernoulli"(p_(tau)(bold(x))).
$ <ec-esperanza-condicional>

De manera complementaria, la probabilidad marginal (prevalencia poblacional del evento en el horizonte $tau$) queda definida por la ley de esperanzas iteradas como:
$
  pi_tau
  = Pr_0(Y^(tau) = 1)
  = bb(E)_0(p_(tau)(bold(X))).
$ <ec-prob-marginal>
Mientras que $pi_tau$ refleja la tasa base de paralización (asociada al desbalance de clases del problema), la función $p_(tau)(bold(x))$ permite individualizar y jerarquizar el riesgo condicional de cada obra.

*Formulación a nivel muestral.*

Dado que la medida poblacional $P_0$ es desconocida, la función objetivo $p_tau$ se aproxima mediante una muestra teórica de tamaño $n$:
$
  cal(D)_n = (Z_1, Z_2, ..., Z_n),
  quad "donde" quad
  Z_i = (bold(X)_i, Y_i^(tau)), quad i = 1, ..., n.
$ <ec-unidad-muestral>

Como marco de referencia inicial, se considera que las observaciones constituyen realizaciones identicamente distribuidas de $P_0$:
$
  Z_1, ..., Z_n limits(tilde.op)^"iid" P_0.
$ <ec-muestra-aleatoria>
No obstante, dado que los registros provienen de sistemas administrativos con estructura jerárquica y temporal (obras vinculadas a entidades ejecutoras y periodos presupuestales), el diseño de validación empírica incorporará particionamiento temporal para mitigar posibles desviaciones del supuesto de independencia.

Sea $cal(A)_n$ un algoritmo de aprendizaje estadístico o automático que mapea la muestra aleatoria hacia un espacio de funciones medibles:
$
  hat(p)_(n,tau) = cal(A)_(n)(cal(D)_n),
  quad "tal que" quad
  hat(p)_(n,tau): cal(X) -> [0,1].
$ <ec-estimador-funcional>
El estimador funcional $hat(p)_(n,tau)$ busca aproximar la función poblacional verdadera $p_tau$, minimizando el riesgo esperado bajo una función de pérdida estrictamente propia (como la pérdida logarítmica o el puntaje de Brier), reconociendo que en muestras finitas existe un error de estimación $hat(p)_(n,tau)(bold(x)) != p_tau(bold(x))$.

*Observabilidad, censura administrativa y datos observados.*

En los registros administrativos con fecha de corte $t_"corte"$, la determinación exacta de $Y_i^(tau)$ requiere distinguir entre la ausencia efectiva del evento y el seguimiento incompleto (censura administrativa a la derecha). Se define la variable indicadora de observabilidad:
$
  R_i^(tau) = cases(
    1 & "si" T_i <= tau "o la obra registra seguimiento completo hasta" min(tau, t_"fin"),
    0 & "si la obra sigue en ejecución sin evento pero" t_"corte" - t_i < tau.
  )
$ <ec-indicador-observacion>
Cuando $R_i^(tau) = 0$, el estado de $Y_i^(tau)$ al término del horizonte $tau$ es latente, por lo que imputarle el valor cero induciría un sesgo de atenuación en el riesgo estimado. En consecuencia, el conjunto de datos empírico efectivo de tamaño $n_"obs" = sum_(i=1)^n R_i^(tau)$ se define sobre las unidades completamente observadas:
$
  d_n = { (bold(x)_i, y_i^(tau)) : R_i^(tau) = 1 }.
$ <ec-dataset-observado>
Al aplicar el procedimiento de aprendizaje sobre la realización empírica, se obtiene el modelo ajustado $hat(p)_(n,tau) = cal(A)_n(d_n)$. Para una nueva obra con vector de características $bold(x)_star$, la predicción:
$
  hat(p)_star = hat(p)_(n,tau)(bold(x)_star) in [0,1]
$ <ec-prediccion-individual>
constituye su probabilidad estimada de paralización. La conversión posterior de $hat(p)_star$ en una alerta binaria $hat(y)_star = bb(1)(hat(p)_star >= c)$ se efectúa en una fase separada mediante la optimización del umbral operativo $c in (0,1)$ acorde a la asimetría de costos entre falsos negativos y falsos positivos.

*Síntesis del problema de estimación.*

En síntesis, el problema fundamental consiste en aprender, a partir de los registros administrativos observados $d_n$, un estimador funcional calibrado e interpretable $hat(p)_(n,tau): cal(X) -> [0,1]$ que aproxime de forma consistente la probabilidad condicional poblacional:
$
  p_tau(bold(x))
  = Pr_0(
    Y^(tau) = 1 mid(|) bold(X) = bold(x)
  ).
$ <ec-objetivo-fundamental>