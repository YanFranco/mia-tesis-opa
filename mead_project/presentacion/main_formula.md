# Lectura y significado de fórmulas — Presentación PROSPECT

**Caso 1: inversión amortizada de PROSPECT · Curso MCPI, UNI**

> Guía completa: pronunciación, significado conceptual y justificación de cada fórmula matemática. Orden de aparición en diapositivas.

---

## Diapositiva 3: El modelo directo PROSPECT

### Fórmula 1: Coeficiente de absorción en una capa elemental

**Escritura:**
$$k(\lambda) = \frac{1}{N} \left( C_{\text{ab}} k_{\text{ab}}(\lambda) + C_{\text{ar}} k_{\text{ar}}(\lambda) + C_{\text{ant}} k_{\text{ant}}(\lambda) + C_w k_w(\lambda) + C_m k_m(\lambda) + k_0(\lambda) \right)$$

**Lectura:**
"Kea de lambda es igual a uno partido por ene, multiplicado por: cee sub ab por kea sub ab de lambda, más cee sub ar por kea sub ar de lambda, más cee sub ant por kea sub ant de lambda, más cee sub w por kea sub w de lambda, más cee sub m por kea sub m de lambda, más kea sub cero de lambda."

**Significado:**
Este es el coeficiente de absorción espectral de una sola capa dentro de la hoja. **k(λ)** representa cuánto luz se absorbe en la longitud de onda λ en una capa elemental. Es una **combinación lineal** de cinco pigmentos y componentes:
- **C_ab** (clorofila a+b) con su coeficiente de absorción específico k_ab(λ)
- **C_ar** (carotenoides) con k_ar(λ)
- **C_ant** (antocianinas) con k_ant(λ)
- **C_w** (agua) con k_w(λ)
- **C_m** (materia seca) con k_m(λ)
- **k_0(λ)** es el fondo de absorción sin pigmentos

**Por qué es así:**
Se divide entre **N** (número de capas) porque PROSPECT modela la hoja como una pila de N capas idénticas. Cada capa contribuye 1/N de la absorción total. La suma es lineal porque la absorción de cada pigmento es **aditiva e independiente** —los pigmentos no interactúan entre sí en el modelo simplificado—. Los coeficientes k_i(λ) se miden una vez en laboratorio y se tabulan (no dependen de θ).

---

### Fórmula 2: Transmitancia de una capa y función exponencial integral

**Escritura:**
$$\tau(\lambda) = (1 - k(\lambda)) e^{-k(\lambda)} + k(\lambda)^2 E_1(k(\lambda)), \quad E_1(z) = \int_1^\infty \frac{e^{-z t}}{t} dt$$

**Lectura:**
"Tau de lambda es igual a abierto paréntesis uno menos kea de lambda cierre paréntesis por e elevado a menos kea de lambda, más kea de lambda al cuadrado por E sub uno de kea de lambda. Donde E sub uno de zeta es la integral desde uno hasta infinito de e elevado a menos zeta t, partido por te, diferencial de te."

**Significado:**
**τ(λ)** es la transmitancia (fracción de luz que pasa a través) de una sola capa de la hoja en la longitud de onda λ. Es un cálculo exacto derivado de la **teoría de Kubelka-Munk**, que modela cómo la luz interactúa con una capa que absorbe y dispersa. La fórmula tiene dos términos:
- Primera parte: $(1 - k(\lambda)) e^{-k(\lambda)}$ — luz que se transmite sin dispersión
- Segunda parte: $k(\lambda)^2 E_1(k(\lambda))$ — corrección por dispersión múltiple, donde **E₁** es la función exponencial integral

**Por qué es así:**
La transmitancia debe obedecer la **teoría de Kubelka-Munk** de la óptica de capas. No es simplemente e^(-k) porque el modelo considera tanto absorción como dispersión dentro de la capa. La integral exponencial E₁ aparece cuando se resuelven exactamente las ecuaciones de transporte radiativo en una capa absorbente-dispersora. PROSPECT usa esta solución tabularizada (calculada de antemano) para cada valor de k(λ).

---

### Fórmula 3: Respuesta radiativa del modelo y vector de parámetros

**Escritura:**
$$\left( R(\lambda), T(\lambda) \right) = F(\theta), \quad \theta = (N, C_{\text{ab}}, C_{\text{ar}}, C_{\text{ant}}, C_w, C_m)$$

**Lectura:**
"La pareja reflectancia de lambda y transmitancia de lambda es igual a efe de theta. Donde theta es el vector: ene, cee sub ab, cee sub ar, cee sub ant, cee sub w, cee sub m."

**Significado:**
**F(θ)** es la función forward (hacia adelante) del modelo PROSPECT: toma seis parámetros biofísicos y devuelve dos espectros (reflectancia **R** y transmitancia **T**). En este proyecto nos enfocamos solo en **R(λ)** (reflectancia). El vector **θ** agrupa los seis parámetros de la hoja:
- **N**: número efectivo de capas (estructura)
- **C_ab**: concentración de clorofila (µg/cm²)
- **C_ar**: concentración de carotenoides (µg/cm²)
- **C_ant**: concentración de antocianinas (µg/cm²)
- **C_w**: contenido equivalente de agua (cm)
- **C_m**: contenido de materia seca (g/cm²)

**Por qué es así:**
Es la forma compacta de decir: el modelo PROSPECT es una función determinista que mapea los parámetros bioquímicos de la hoja a sus propiedades ópticas medibles. F es **diferenciable** (cálculos exactos en cada paso), **barato de evaluar** (~2.5 ms), y sus coeficientes base (k_i, n) están tabulados de antemano. Esto lo hace ideal para simulación e inversión.

---

## Diapositiva 4: El problema inverso

### Fórmula 4: Modelo de observación con ruido gaussiano

**Escritura:**
$$x_{\text{obs}} = F(\theta) + \epsilon, \quad \epsilon \sim \mathcal{N}(0, \Sigma_\epsilon)$$

**Lectura:**
"Equis observado es igual a efe de theta más épsilon, donde épsilon se distribuye normalmente con media cero y matriz de covarianza Sigma sub épsilon."

**Significado:**
Este es el **modelo de error de medición**. Dice que el espectro que observamos en laboratorio (**x_obs**) es el espectro verdadero predicho por PROSPECT (**F(θ)**) más un ruido **ε** de medición. El ruido se asume **gaussiano** (normal, de media cero) con covarianza **Σ_ε**. Este es un supuesto estándar en estadística: lo que medimos ≠ lo que es realmente, hay error instrumental.

**Por qué es así:**
- Los espectrómetros reales tienen **error de medición** (ruido electrónico, calibración imperfecta).
- Asumir **gaussiano** es el supuesto más débil con máxima entropía: es realista y matemáticamente tratable.
- **Media cero** significa el instrumento no está sesgado sistemáticamente.
- Σ_ε puede ser diagonal (bandas independientes) o general (bandas correlacionadas); aquí se usa diagonal por simplicidad.

---

### Fórmula 5: Verosimilitud logarítmica de los datos dado los parámetros

**Escritura:**
$$\log p(x_{\text{obs}} \mid \theta) = -\frac{1}{2} \left\| x_{\text{obs}} - F(\theta) \right\|_{\Sigma_\epsilon^{-1}}^2 + \text{cte.}$$

**Lectura:**
"El logaritmo de pe de equis observado dado theta es igual a menos un medio por la norma al cuadrado ponderada por Sigma sub épsilon inversa de equis observado menos efe de theta, más una constante."

**Significado:**
La **verosimilitud** es p(x_obs | θ): **¿cuánto de probable es que observemos este espectro si los parámetros verdaderos son θ?**. En logaritmo, se ve como una suma de errores al cuadrado ponderados. La norma ponderada **||·||²_Σ** es la distancia de Mahalanobis: si Σ_ε es diagonal, es simplemente suma de errores normalizados por banda.

**Por qué es así:**
Si **ε ~ N(0, Σ_ε)**, entonces **x_obs ~ N(F(θ), Σ_ε)**, y la densidad gaussiana multivariante en logaritmo es exactamente esta forma. La constante se ignora porque solo nos importan los θ que maximizan la verosimilitud; sumar/restar constantes no cambia el máximo.

---

### Fórmula 6: Teorema de Bayes — Posterior

**Escritura:**
$$p(\theta \mid x) \propto p(x \mid \theta) \, p(\theta)$$

**Lectura:**
"Pe de theta dado equis es proporcional a pe de equis dado theta multiplicado por pe de theta."

**Significado:**
Esta es la **regla de Bayes** en su forma de proporcionalidad. La **posterior** p(θ | x)—nuestra creencia sobre θ después de ver los datos—es proporcional al **likelihood** (verosimilitud, qué tan bien explica θ a x) por el **prior** (creencia previa sobre θ). En palabras: *lo que aprendemos de los datos se calibra por lo que ya creíamos antes*.

**Por qué es así:**
Matemáticamente, Bayes dice:
$$p(\theta \mid x) = \frac{p(x \mid \theta) p(\theta)}{p(x)}$$
El denominador p(x) es una constante (no depende de θ), así que se ignora en optimización. El "proporcional a" captura exactamente la idea: la posterior suma verosimilitud y prior, pero **no es una verdadera distribución de probabilidad hasta que se normaliza** (la constante omitida lo hace). En inferencia amortizada, la red neuronal aprende a aproximar esta posterior sin escribirla explícitamente.

---

## Diapositiva 11: Muestreo del prior

### Fórmula 7: Prior factorizado sobre los parámetros

**Escritura:**
$$p(\theta) = \prod_j p(\theta_j), \quad N \sim \mathcal{U}(1, 3)$$

**Lectura:**
"Pe de theta es igual al producto sobre jota de pe de theta sub jota. Y ene se distribuye uniformemente entre uno y tres."

**Significado:**
El **prior** p(θ) es la **distribución de probabilidad que asignamos a los parámetros antes de ver ningún dato**. Representa nuestra creencia sobre qué valores son razonables. Se asume **factorizado** (producto): esto significa que creemos que los seis parámetros son **independientes en el prior**. Cada uno tiene su propia marginal:
- **C_ab, C_ar, C_ant, C_w, C_m**: uniformes sobre los rangos observados en ANGERS (+ 20%)
- **N**: uniforme entre 1 y 3 capas

**Por qué es así:**
La factorización es el supuesto de **independencia a priori**: sin datos, no hay razón para creer que la clorofila esté correlacionada con el agua, etc. Es un supuesto conservador (máxima entropía). Uniforme es el supuesto más débil: "todos los valores en el rango plausible son igualmente probables". Los rangos se fijan en ANGERS porque es la base de datos de referencia —usamos su rango empírico como 'creencia razonable' de lo que esperar en hojas verdaderas. N ∈ [1,3] es físico (hojas reales tienen 1–3 capas equivalentes).

---

## Diapositiva 12: Simulación con ruido realista

### Fórmula 8: Modelo de observación simulada — ruido + deriva

**Escritura:**
$$x = F(\theta) + \underbrace{\eta}_{\mathcal{N}(0, \sigma^2 I)} + \underbrace{a \mathbf{1} + b \, \overline{\lambda}}_{\text{drift}}, \quad \sigma \sim \mathcal{U}(0.003, 0.02), \quad a, b \sim \mathcal{N}(0, 0.01)$$

**Lectura:**
"Equis es igual a efe de theta más eta, distribuido normal con media cero y varianza sigma cuadrado identidad, más la deriva: a por uno más be por lambda promedio. Donde sigma se distribuye uniformemente entre cero punto cero tres y cero punto cero dos, y a y be se distribuyen normalmente con media cero y varianza cero punto cero uno."

**Significado:**
Este es el **modelo de ruido de simulación** para hacer los datos de entrenamiento más realistas. Toma el espectro ideal **F(θ)** y le añade dos fuentes de error:

1. **η ~ N(0, σ²I)**: ruido blanco gaussiano independiente por banda. σ es aleatorio (uniforme 0.003–0.02) por cada espectro para representar variabilidad de calibración.

2. **a·1 + b·λ̄**: una **corrección lineal de línea base** (deriva). Es lo que sucede cuando el espectrómetro no está perfectamente calibrado en nivel. **a** es un sesgo constante, **b** es una pendiente dependiente de λ. Se muestrean normales para cada espectro (a,b ~ N(0, 0.01)) para simular descalibración.

**Por qué es así:**
Los espectrómetros reales no solo tienen ruido aleatorio: tienen **errores de calibración** que cambian entre mediciones (sesgo y pendiente en la línea base). Simulamos esto para que el entrenador vea variabilidad que refleje la realidad. σ aleatorio significa "cada medición tiene un nivel de ruido diferente" (robusto). Si solo usáramos ruido white puro, la red aprendería a esperar ese ruido exacto, y fallaría en datos reales con descalibración diferente. Esta variedad en el ruido hace que la red sea **más robusta a la brecha simulación–realidad**.

---

### Fórmula 9: Transformación de los parámetros — log + estandarización

**Escritura:**
$$z = \frac{\log_1p(\theta) - \mu}{\sigma}$$

**Lectura:**
"Zeta es igual a log1p de theta menos mu, dividido por sigma."

**Significado:**
Esta es la **transformación de los parámetros** antes de entrenar. Convierte los parámetros brutos θ (que son positivos y sesgados) en parámetros transformados z (que son aproximadamente normales y escalados a media 0, varianza 1).

- **log1p(θ)**: applica log1p = log(1 + θ) a cada parámetro. Reduce la asimetría (skewness) de distributions como Cab, que van de 0.78 a 106.7. En escala log, la distribución es más simétrica.
- **μ, σ**: media y desviación estándar de log1p(θ), estimadas solo con los datos de entrenamiento.

**Por qué es así:**
Las redes neuronales entrenan mejor cuando los **inputs y targets tienen media ≈ 0 y varianza ≈ 1** (datos normalizados). Sin esto, los gradientes pueden volverse muy grandes o muy pequeños. El **log es importante** porque los parámetros de hojas son positivos y tienen rangos asimétricos (ej. Cab de 0.78 a 106.7 no es lineal en importancia). En escala logarítmica, el rango es [log(0.78), log(106.7)] ≈ [-0.25, 4.67], que se puede normalizar uniformemente. Así la red aprende proporciones relativas, no valores absolutos.

---

## Diapositiva 19: Pérdida NPE (Parte 1) — Negative Log Likelihood

### Fórmula 10: Pérdida NLL esperada — forma poblacional y estimador empírico

**Escritura:**
$$\mathcal{L}(\phi) = \mathbb{E}_{p(\theta)} \mathbb{E}_{p(x \mid \theta)} \left[ -\log q_\phi (z \mid x) \right] \approx -\frac{1}{M} \sum_{m=1}^M \log q_\phi (z^{(m)} \mid x^{(m)})$$

**Lectura:**
"Ele de phi es igual a la esperanza bajo pe de theta de la esperanza bajo pe de equis dado theta del negativo logaritmo de que sub phi de zeta dado equis, aproximadamente igual a menos uno partido por eme, sumatoria desde eme igual a uno hasta eme capital de logaritmo de que sub phi de zeta a la eme entre equis a la eme."

**Significado:**
Esta es la **función de pérdida** (cost function) que minimizamos para entrenar la red. Dice:
- Muestrea pares (θ, x) del *joint* p(θ)p(x|θ) (el simulador)
- Para cada par, evalúa cuánto la red q_φ cree en ese (θ|x)
- La pérdida es el **negativo del log-likelihood**: si q_φ es alta (red confiada), la pérdida es baja; si es baja (red dudosa), la pérdida es alta
- Promedias sobre todos los pares

El símbolo **≈** dice: la verdadera pérdida (esperanza sobre infinitas muestras) se aproxima por el **promedio empírico** sobre M muestras (40,000 en nuestro caso).

**Por qué es así:**
En **maximum likelihood**, queremos que la red asigne probabilidad alta a los pares que vemos en el simulador. El negativo del log es una forma estándar de escribir esto. La esperanza doble significa: "en promedio sobre todos los valores posibles de θ y sus espectros correspondientes". Sin el simulador, nunca tendríamos suficientes datos reales para entrenar, así que creamos datos sintéticos con estos dos pasos.

---

## Diapositiva 19: Pérdida NPE (Parte 2) — Descomposición bayesiana

### Fórmula 11: Reescritura de la pérdida — Entropía + KL divergence

**Escritura:**
$$\mathcal{L}(\phi) = \mathbb{E}_{p(x)} \left[ \underbrace{H(p(\theta \mid x))}_{\text{indep. de } \phi} + \text{KL}\left( p(\theta \mid x) \parallel q_\phi (\theta \mid x) \right) \right]$$

**Lectura:**
"Ele de phi es igual a la esperanza bajo pe de equis del bracket: la entropía de pe de theta dado equis, que es independiente de phi, más la divergencia de Kullback-Leibler entre pe de theta dado equis y que sub phi de theta dado equis."

**Significado:**
Este es un resultado teórico central: la misma pérdida NLL **se reescribe como dos términos**:

1. **H(p(θ|x))**: entropía de la posterior verdadera — mide cuánta "sorpresa" hay en la verdadera distribución. Es un número fijo que NO depende de φ (no depende de nuestra red).

2. **KL(p || q_φ)**: divergencia de Kullback-Leibler — mide la **distancia probabilística** entre la posterior verdadera p y nuestra aproximación q_φ. Es siempre ≥ 0, y = 0 solo si q_φ = p exactamente.

**Por qué es así:**
Matemáticamente, si descompones la esperanza del log usando propiedades de la información, obtienes exactamente esta forma. La utilidad es **conceptual**: muestra que **minimizar la NLL es equivalente a minimizar la KL divergence** (el primer término es constante y se ignora). Así el algoritmo intenta encontrar la red que mejor aproxime la posterior verdadera en el sentido de divergencia de KL.

---

### Fórmula 12: Implicación — Garantía teórica del óptimo

**Escritura:**
$$\text{minimizar } \mathcal{L} \Rightarrow \text{minimizar } \mathbb{E}_x \text{KL}(p \parallel q_\phi) \Rightarrow \text{óptimo } q_\phi = p(\theta \mid x)$$

**Lectura:**
"Minimizar ele implica minimizar la esperanza sobre equis de la divergencia de Kullback-Leibler entre pe y que sub phi, lo que implica que el óptimo es cuando que sub phi es igual a pe de theta dado equis."

**Significado:**
Esta es la **garantía teórica**: si la red tiene **capacidad suficiente** (capas, parámetros) y entrenamos hasta convergencia, entonces q_φ converge a la verdadera posterior p(θ|x). En otras palabras, la red **aprende la distribución correcta**. No es solo un ajuste (regresión punto a punto), sino la **distribución completa con su incertidumbre**.

**Por qué es así:**
La divergencia de KL tiene mínimo global en 0, que ocurre cuando las dos distribuciones son idénticas. Por tanto, si minimizas KL sobre cualquier x muestreado, y tu red es flexible, converge a la verdadera posterior. En la práctica, capacidad finita y datos finitos hacen que no sea exacto, pero es el "objetivo" al que apunta el aprendizaje.

---

## Diapositiva 20: Arquitectura MDN — Mixture Density Network

### Fórmula 13: Mezcla de gaussianas de la posterior aproximada

**Escritura:**
$$q_\phi (z \mid x) = \sum_{k=1}^5 \pi_k (x) \, \mathcal{N}\left( z; \mu_k (x), \text{diag}\left( \sigma_k (x)^2 \right) \right)$$

**Lectura:**
"Que sub phi de zeta dado equis es igual a sumatoria desde ka igual a uno hasta cinco de pi sub ka de equis por la distribución normal de zeta con media mu sub ka de equis y matriz de covarianza diagonal con varianzas sigma sub ka de equis al cuadrado."

**Significado:**
Esta es la **arquitectura específica** que la red neuronal produce. No es solo una predicción de un único valor; es una **mezcla de 5 gaussianas** (distribuciones normales). La red toma un espectro x (comprimido a 64 dimensiones por PCA) y genera:
- **5 pesos π_k(x)**: la importancia relativa de cada gaussiana. Todos sumán 1 (probabilidades).
- **5 medias μ_k(x)**: cada gaussiana tiene su propio centro en el espacio de parámetros (ℝ⁶).
- **5 escalas σ_k(x)**: cada gaussiana tiene su propia incertidumbre por cada parámetro (diagonal = independencia entre parámetros dentro de cada componente).

**Por qué es así:**
Una **mezcla de 5 gaussianas** es flexible: puede aproximar distribuciones multimodales (no unimodales). Por qué 5 y no 10 o 100? Es un balance:
- Más componentes = más flexible = mejor ajuste a posteriores complejas
- Menos componentes = más simple = menos parámetros = menos overfitting
- 5 es empírico: funciona bien para este problema

**Diagonal** significa: dentro de cada gaussiana, los parámetros se asumen independientes. Esto simplifica el cálculo y es razonable porque el ruido de medición es por banda (espectral), no entre parámetros.

La red aprende **π_k, μ_k, σ_k como funciones del espectro**, es decir, cada espectro x diferente genera pesos/medias/escalas diferentes — eso es la amortización.

---

## Diapositiva 21: Entrenamiento

### Fórmula 14: Gradiente del estimador — Optimización estocástica

**Escritura:**
$$\nabla_\phi \mathcal{L} = \text{estimador MC insesgado}$$

**Lectura:**
"El gradiente de ele respecto a phi es un estimador Monte Carlo insesgado."

**Significado:**
Durante el entrenamiento, el optimizador (Adam) calcula el **gradiente de la pérdida con respecto a todos los parámetros φ de la red**. Ese gradiente se estima por **Monte Carlo** sobre un **minibatch** (512 pares simulados en cada iteración). "Insesgado" significa que el promedio del gradiente sobre muchos minibatches es el gradiente verdadero de la población.

**Por qué es así:**
No tenemos acceso al gradiente exacto (la verdadera esperanza sobre infinitas muestras); solo podemos estimar. Pero si promediamos muchos minibatches, el estimador converge al verdadero gradiente (por la ley de los grandes números). Esto es **Stochastic Gradient Descent (SGD)**: muy eficiente porque actualiza después de cada minibatch, no después de todo el dataset.

---

## Diapositiva 21: Baseline clásico — Optimización iterativa

### Fórmula 15: Inversión por mínimos cuadrados — per espectro

**Escritura:**
$$\hat{\theta}_{\text{clásico}} (x) = \arg \min_\theta \left\| x - F(\theta) \right\|^2$$

**Lectura:**
"Theta estimado clásico de equis es el argumento que minimiza: la norma al cuadrado de equis menos efe de theta."

**Significado:**
Este es el **método clásico** que comparamos. Para cada espectro x, resuelve un **problema de optimización independiente**: busca el vector θ que hace que el espectro predicho F(θ) sea lo más cercano posible al observado x (en distancia euclídea). No usa probabilidades ni Bayes; es un ajuste directo por mínimos cuadrados.

**Por qué es así:**
Históricamente, es el estándar en teledetección: si PROSPECT es determinista y x es una medición, el parámetro "correcto" debería ser el que mejor ajuste. Ventaja: **usa la física exacta de PROSPECT** (no simulada). Desventaja: **caro por espectro** (optimización iterativa ≈ 1.2 s), **no da incertidumbre** (solo un punto), **mal condicionado** (equifinalidad: múltiples θ dan x similar). El amortizado compite aquí: ¿podemos algo comparable de rápido pero con incertidumbre calibrada?

---

## Tabla de Resultados en Simulación (Diapositiva 25)

> Nota: No son fórmulas, pero se mencionan en la presentación:

- **R² = 0.997** para Cab: "Erre cuadrado igual a cero punto novecientos noventa y siete"
- **R² = 0.998** para Cw: "Erre cuadrado igual a cero punto novecientos noventa y ocho"
- **R² = 0.986** para Cm: "Erre cuadrado igual a cero punto novecientos ochenta y seis"
- **R² = 0.720** para Car: "Erre cuadrado igual a cero punto setecientos veinte"

---

## Tabla de Resultados sobre ANGERS (Diapositiva 26)

**Comparación de RMSE y R² (clásico vs amortizado):**

- Cab: RMSE cl. 7.28, am. 7.67; R² cl. 0.889, am. 0.876
- Cw: RMSE cl. 0.00371, am. 0.00413; R² cl. 0.375, am. 0.223
- Cm: RMSE cl. 0.00194, am. 0.00263; R² cl. 0.699, am. 0.442
- Car: RMSE cl. 2.86, am. 2.73; R² cl. 0.689, am. 0.716

> Lectura: "Para Cab clásico, RMSE de siete punto veintiocho y R² de cero punto ochocientos ochenta y nueve; amortizado, RMSE de siete punto sesenta y siete y R² de cero punto ochocientos setenta y seis." (y así sucesivamente)

---

## Tabla de Cobertura de Intervalos (Diapositiva 27)

**Simulación vs ANGERS (cobertura IC 90%):**

- Cab: simulación 89.7%, ANGERS 27.6%
- Cw: simulación 91.2%, ANGERS 17.9%
- Cm: simulación 87.5%, ANGERS 44.5%
- Car: simulación 88.9%, ANGERS 74.0%

> Lectura: "Para Cab, cobertura del intervalo de credibilidad al noventa por ciento: en simulación ochenta y nueve punto siete por ciento, en ANGERS veintisiete punto seis por ciento." (y así sucesivamente)

---

## Tabla de Tiempos (Diapositiva 28) — Análisis de velocidad

### Fórmula 16: Speedup en la fase de inferencia

**Escritura:**
$$\text{speedup} \approx 2400\times \quad \text{(inferencia)}$$

**Lectura:**
"El speedup en inferencia es aproximadamente dos mil cuatrocientos veces más rápido."

**Significado:**
Una vez entrenada la red (offline, una sola vez), la **inferencia** (evaluar la red en un nuevo espectro) tarda **0.5 milisegundos**. El método clásico tarda **1215 milisegundos** por espectro. La razón: 1215 / 0.5 = 2430 ≈ 2400×. Es un speedup **cualitativo** en tiempo de cómputo.

**Por qué es así:**
La red es solo **forward passes** (evaluación de pesos y activaciones), muy rápido. El método clásico es un **loop iterativo de optimización** (Levenberg-Marquardt, ~100 iteraciones, cada una evalúa F y calcula gradientes numéricos). La física exacta de F no lo salva de ser lento: el problema es que hay que resolver una optimización por cada espectro.

---

### Fórmula 17: Speedup total — incluyendo costo de entrenamiento

**Escritura:**
$$\text{speedup total} \approx 5\times \quad \text{(procesando 308 hojas)}$$

**Lectura:**
"El speedup total, incluyendo el entrenamiento y procesando trescientas ocho hojas, es aproximadamente cinco veces más rápido."

**Significado:**
Si incluyes el tiempo de **entrenamiento** (72.5 s, offline), la ganancia neta se reduce:
- Clásico: 308 × 1215 ms = 374 s
- Amortizado: 72.5 s (train) + 308 × 0.5 ms (infer) = 72.5 + 0.16 = 72.66 s
- Ratio: 374 / 72.66 ≈ 5.1×

Así que aunque la inferencia es 2400× más rápido, el entrenamiento es caro, y con solo 308 espectros, el speedup total es "solo" 5×.

**Por qué es así:**
Este es un cálculo **justo**: el entrenamiento es un costo fijo, la inferencia es un costo variable. Si tuvieras 10,000 espectros en lugar de 308, el entrenamiento seguiría siendo 72.5 s, pero el tiempo clásico sería ≈ 3400 s, y el speedup total sería ≈ 47×. El punto de equilibrio te da perspectiva.

---

### Fórmula 18: Punto de equilibrio — cuándo amortizado "gana"

**Escritura:**
$$\text{equilibrio} \approx 60 \text{ espectros} = \frac{72.5 \text{ s}}{1.215 \text{ s/espectro} - 0.5 \text{ ms/espectro}}$$

**Lectura:**
"El punto de equilibrio es aproximadamente sesenta espectros, la cantidad a partir de la cual el tiempo amortizado (entrenamiento + inferencia) es igual al tiempo clásico."

**Significado:**
Este número responde: **¿cuántos espectros necesito procesar para que el costo de entrenamiento valga la pena?** Después de 60 espectros, el amortizado es más rápido que el clásico. Para 308 (nuestro caso), claramente conviene. Para una imagen hiperespectral (10,000+ píxeles), es imprescindible.

**Por qué es así:**
Matemáticamente: Tiempo clásico = Tiempo amortizado
$$n \times t_{\text{clásico}} = t_{\text{train}} + n \times t_{\text{amort}}$$
$$n \times 1.215 = 72.5 + n \times 0.0005$$
$$n (1.215 - 0.0005) = 72.5$$
$$n \approx \frac{72.5}{1.2145} \approx 60$$

Es una economía de escala: el método amortizado es bueno para múltiples espectros, malo si solo tienes uno.

---

## Diapositiva 31: Correspondencia con el sílabo

**Sesión 1. Generación de números aleatorios:**
- Prior por transformada inversa
- Latin Hypercube

**Sesiones 2. Simulación de sistemas:**
- Forward Monte Carlo con PROSPECT + ruido

**Sesiones 4–6. Métodos de Monte Carlo:**
- SGD como optimización Monte Carlo
- Resumen de la posterior por muestreo

**Sesiones 11–12. Laplace / Variational Bayes:**
- NPE = Inferencia variacional amortizada

**Sesiones 7–8. Bootstrap**
**Sesiones 9–10. MCMC:**
- Extensiones (fuera del MVP)

---

---

## Notas generales para pronunciación de símbolos

### Símbolos griegos y sus nombres en español

| Símbolo | Nombre español | Lectura típica |
|---|---|---|
| λ (lambda) | lambda | "lambda" |
| θ (theta) | theta | "theta" |
| φ (phi) | phi | "phi" o "fi" |
| ε (epsilon) | épsilon | "épsilon" |
| σ (sigma) | sigma | "sigma" |
| μ (mu) | mu | "mu" |
| π (pi) | pi | "pi" |
| Σ (Sigma mayúscula) | Sigma | "sigma" (context: sumatoria) |

### Operadores matemáticos

- **∝** → "proporcional a" (relación sin igualdad)
- **~** → "se distribuye" o "distribuido como" (ej. x ~ N(0,1) = "x distribuido como normal estándar")
- **||** (entre distribuciones) → "divergencia de" (ej. KL(p || q) = "divergencia KL de p con respecto a q")
- **≈** → "aproximadamente igual a"
- **×** → "por" o "multiplicado por"
- **|** (en probabilidades) → "dado" (ej. p(x|θ) = "pe de equis dado theta")

### Estructuras y funciones especiales

- **𝒩, 𝒩()** → "distribución normal" o "la normal de" (ej. 𝒩(0,1) = "normal estándar")
- **𝒰, 𝒰()** → "distribución uniforme" o "la uniforme en"
- **𝔼[]** → "esperanza de" (ej. 𝔼[x] = "esperanza de equis")
- **log** → "logaritmo" o "log" (normalmente log natural, ln)
- **log₁p** → "log uno más pe de" (la función log1p(x) = log(1+x), usada para valores pequeños)
- **∫** → "integral de" ... "diferencial de"
- **∑** → "sumatoria desde" ... "hasta"
- **∏** → "producto desde" ... "hasta"
- **E₁()** → "función exponencial integral" (integral especial que aparece en óptica)

### Subíndices y superíndices

- **sub**: se lee "sub" (debajo) cuando es un índice de variable (ej. C_ab = "cee sub ab", N = "ene")
- **elevado a**: se lee "elevado a" para potencias (ej. σ² = "sigma al cuadrado", z⁴ = "zeta a la cuarta")
- **paréntesis superiores**: índice de muestra, ej. z^(m) = "zeta superíndice eme" o "zeta a la eme" (distinguir de potencia)

### Ejemplos de lectura completa

- **k_ab(λ)** → "kea sub ab de lambda"
- **C_w** → "cee sub w" o "concentración de agua"
- **R(λ), T(λ)** → "reflectancia de lambda, transmitancia de lambda"
- **θ = (N, C_ab, ...)** → "theta igual al vector: ene, cee sub ab, ..."
- **x_obs ~ 𝒩(F(θ), Σ)** → "equis observado distribuido como normal de media efe de theta y covarianza sigma"
- **p(θ|x) ∝ p(x|θ)p(θ)** → "pe de theta dado equis es proporcional a pe de equis dado theta por pe de theta"

---

## Resumen conceptual — Por qué el documento tiene 18 fórmulas

Cada fórmula representa un **concepto clave**:

1. **Fórmulas 1–3**: La física de PROSPECT — cómo construir un modelo directo
2. **Fórmulas 4–6**: Estadística bayesiana — pasar de física a probabilidad
3. **Fórmulas 7–9**: Preparación de datos — prior, simulación, transformación
4. **Fórmulas 10–13**: Aprendizaje amortizado — la red neuronal que aproxima la posterior
5. **Fórmulas 14–15**: Comparación — nuestro método vs. el clásico
6. **Fórmulas 16–18**: Análisis de costo — por qué el amortizado vale la pena

Si entiendes el "por qué" de cada una, tienes la arquitectura completa del método.
