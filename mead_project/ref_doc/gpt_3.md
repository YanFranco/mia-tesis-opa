Sí. He revisado el notebook completo `proyecto_final_modelado.ipynb`. La estructura que has construido **sí puede defenderse muy bien dentro de MEAD**, porque no se limita a probar algoritmos: plantea el problema estadístico, construye variables, respeta la dimensión temporal, compara familias de modelos, incorpora diagnóstico, discriminación, calibración e interpretabilidad. Esto coincide directamente con las competencias del curso: formular modelos, estimarlos, diagnosticarlos, validarlos y analizar críticamente sus supuestos y limitaciones. 

Pero también encontré **algunos puntos metodológicos que conviene corregir antes de presentar el trabajo**, especialmente en la construcción temporal de una variable, en la interpretación de los modelos ponderados, en AIC/BIC de los GAM y en la extrapolación de splines.

Voy a explicarlo como si estuviéramos construyendo la **defensa matemática del notebook ante el profesor**.

---

# 1. El mapa general del notebook

Tu notebook implementa esencialmente este flujo:

```text
                    PROBLEMA REAL
                         │
                         ▼
              ¿Se paralizará la obra?
                         │
                         ▼
                   Y ∈ {0,1}
                         │
                         ▼
               DATOS HISTÓRICOS
                         │
             ┌───────────┴───────────┐
             ▼                       ▼
            EDA                Feature Engineering
             │                       │
             │              ┌────────┼────────┐
             │              ▼        ▼        ▼
             │          temporal   categ.   numéricas
             │              │        │        │
             └──────────────┴────────┴────────┘
                            │
                            ▼
                   TRAIN / TEST TEMPORAL
                            │
                            ▼
                 VALIDACIÓN TEMPORAL
                            │
                            ▼
             ┌──────────────┼──────────────┐
             ▼              ▼              ▼
           GLM/GAM          Logit           RF
             │              │              │
             └──────────────┼──────────────┘
                            ▼
                     p̂ = P(Y=1|X)
                            │
             ┌──────────────┼──────────────┐
             ▼              ▼              ▼
        Discriminación   Calibración    Decisión
         ROC / PR        Brier/curve   F1/F2/Recall
             │              │              │
             └──────────────┼──────────────┘
                            ▼
                   MODELO FINAL DE RIESGO
```

Esta estructura es muy compatible con el enfoque de MEAD, cuyo sílabo incluye modelo lineal, diagnóstico, remuestreo/validación, regularización, GLM y GAM. 

---

# 2. Celdas 0–2: planteamiento, configuración y reproducibilidad

## Celda 0 — Planteamiento

El notebook comienza definiendo:

> estimación del riesgo de paralización de obras públicas.

Y algo conceptualmente muy importante:

$$
\boxed{
R(X)=P(Y=1\mid X)
}
$$

No estás diciendo solamente:

$$
Y=0/1
$$

sino que la salida principal del modelo será:

$$
\hat p_i
$$

como medida cuantitativa de riesgo.

Esto es una excelente decisión conceptual.

La variable:

```python
TARGET = "flg_opa_incumplimiento_contractual"
```

define:

$$
Y_i=
\begin{cases}
1 & \text{si la obra se paralizó}\\
0 & \text{si no se paralizó}
\end{cases}
$$

El notebook además deja explícito que compara ocho modelos: M0, M2, RF, M4, M5, M6, M7 y M8. 

### Cómo defenderlo en MEAD

Puedes decir:

> "El problema se formula como un modelo probabilístico de clasificación binaria, donde la variable respuesta sigue una distribución Bernoulli condicionada a las covariables observadas."

Matemáticamente:

$$
Y_i|X_i\sim Bernoulli(p_i)
$$

y:

$$
p_i=P(Y_i=1|X_i).
$$

---

# 3. Celda 2 — Imports y AIC/BIC

La celda importa:

```python
numpy
pandas
statsmodels
sklearn
BSplines
GLMGam
```

pero lo importante matemáticamente es la función:

```python
calcular_aic_bic(...)
```

que implementa:

$$
AIC=2k-2\ell(\hat\theta)
$$

y:

$$
BIC=k\log(n)-2\ell(\hat\theta)
$$

donde:

* \(k\) = número de parámetros;
* \(n\) = número de observaciones;
* \(\ell(\hat\theta)\) = log-verosimilitud evaluada en el estimador.

La idea estadística es:

```text
ajuste
  │
  │ mejor log-verosimilitud
  ▼
pero...
  │
  ▼
penalizar complejidad
```

Por eso:

$$
\boxed{\text{menor AIC/BIC = preferible}}
$$

dentro de modelos comparables.

El notebook explícitamente evita el AIC/BIC nativo de `GLMGam` porque encontró inestabilidad en los grados de libertad efectivos penalizados. 

### ⚠️ Primera observación metodológica

Aquí debes ser cuidadoso en la defensa:

> El AIC/BIC que calculas es una aproximación mediante conteo simple de parámetros y no el criterio exacto para un GAM penalizado.

Por tanto, yo **no usaría AIC/BIC como criterio principal para elegir entre M4–M8**.

Lo usaría como:

> criterio auxiliar de comparación dentro de la familia paramétrica.

---

# 4. Celdas 3–13: EDA y comprensión del fenómeno

## Celda 4 — Selección del universo

Filtras:

```python
nivel_gobierno == "GOBIERNO NACIONAL"
marco == "INVIERTE"
```

Esto tiene una interpretación estadística importante:

estás definiendo la **población objetivo**.

No quieres que el modelo mezcle poblaciones heterogéneas.

Formalmente:

$$
\mathcal P=
\{i:
Gobierno_i=GN,\ Marco_i=Invierte
\}
$$

Por tanto, tu modelo estima:

$$
P(Y=1|X,\ i\in\mathcal P).
$$

Esto es muy importante para la validez externa:

> el modelo no debería presentarse como predictor universal de cualquier obra pública, sino como modelo para el universo definido.

---

# 5. Celda 6 — Desbalance

El notebook encuentra:

$$
P(Y=0)=0.925548
$$

y:

$$
P(Y=1)=0.074452.
$$

Es decir:

$$
\boxed{7.45\%}
$$

de las obras son positivas en el universo filtrado. 

Esto explica por qué accuracy es una métrica secundaria.

Un clasificador que siempre diga:

$$
\hat Y=0
$$

tendría aproximadamente:

$$
Accuracy=92.55\%.
$$

Pero:

$$
Recall_1=0.
$$

Por eso tu problema requiere métricas específicas para la clase minoritaria.

---

# 6. Celda 8–9 — Valores faltantes

Analizas:

```python
describe()
isna().mean()
```

y encuentras, por ejemplo, aproximadamente:

$$
19.31\%
$$

de faltantes en IGEIP. 

Esto no es simplemente "limpieza".

Es parte del análisis estadístico porque:

$$
X_j\text{ faltante}
$$

puede afectar:

* estimación;
* sesgo;
* varianza;
* calibración;
* interpretabilidad.

El pipeline posteriormente utiliza imputación por mediana.

La mediana:

$$
\tilde X
$$

es robusta frente a valores extremos.

---

# 7. Celda 10 — Transformación del monto

El monto tiene:

$$
\text{media}\approx9.21\times10^6
$$

pero:

$$
\max\approx685.4\times10^6.
$$

Esto indica una fuerte asimetría positiva. 

Por eso posteriormente utilizas:

$$
\boxed{
X^*=\log(1+X)
}
$$

El `+1` permite transformar valores cero:

$$
\log(1+0)=0.
$$

Después aplicas winsorización y estandarización.

Conceptualmente:

```text
monto original
      │
      ▼
   winsorizar
      │
      ▼
   log(1+x)
      │
      ▼
 estandarizar
      │
      ▼
 predictor
```

Esto tiene fundamento estadístico:

* reducir influencia de valores extremos;
* reducir asimetría;
* mejorar comportamiento numérico;
* facilitar estimación.

---

# 8. Celda 11 — Tasa de paralización por departamento

Calculas:

```python
groupby("departamento")[TARGET].agg(["mean","count"])
```

Como \(Y\in\{0,1\}\):

$$
E(Y|Departamento=d)
=
P(Y=1|Departamento=d).
$$

Por eso la media de una variable binaria es una **proporción**.

Esto permite explorar heterogeneidad espacial.

Pero hay que distinguir:

$$
P(Y=1|Departamento)
$$

de:

$$
P(Y=1|X).
$$

La primera es análisis descriptivo; la segunda es el modelo multivariado.

---

# 9. Celdas 12–13 — Correlación

Calculas Pearson:

$$
\rho_{XY}
=
\frac{Cov(X,Y)}
{\sigma_X\sigma_Y}.
$$

Cuando \(Y\) es binaria, esta correlación coincide con la **correlación punto-biserial**.

Es útil como diagnóstico exploratorio, pero:

> **no determina si una variable es un buen predictor multivariado.**

Por ejemplo, podrías tener:

$$
Corr(X_1,Y)\approx0
$$

pero \(X_1\) ser importante una vez controlas \(X_2\).

Por eso esta celda está bien como **EDA**, no como mecanismo de selección definitiva.

---

# 10. Celdas 14–15 — limpieza

Aquí haces tres operaciones importantes:

### 1. Eliminar monto faltante

```python
dropna(subset=["monto_aprobado_soles"])
```

### 2. Corregir:

$$
monto=0
$$

usando:

$$
monto\_aprobacion\_et.
$$

### 3. Eliminar:

$$
monto=1
$$

como registro inválido.

Esto es una parte que debes defender como **tratamiento de calidad de datos**, no como modelado.

---

# 11. Celdas 16–18 — Feature Engineering temporal

Esta es una de las partes **más interesantes estadísticamente** del notebook.

Construyes:

```python
serie.expanding().mean().shift(1)
```

Esto produce:

$$
H_{i}
=
\frac{\sum_{j<i}Y_j}{i-1}.
$$

Es decir:

> tasa histórica de paralización observada antes de la obra actual.

Para una entidad:

```text
Obra 1 → sin historia
Obra 2 → tasa obra 1
Obra 3 → tasa obras 1-2
Obra 4 → tasa obras 1-3
...
```

Matemáticamente:

$$
\boxed{
H_{it}
=
\frac{\sum_{s<t}Y_{is}}
{N_{it}^{previas}}
}
$$

Es una variable histórica y temporalmente causal.

---

# 12. ⚠️ Pero encontré una pequeña fuga de información

Esta línea:

```python
.fillna(df_reducido[TARGET].mean())
```

utiliza la media del target de **todo el dataset**.

Para la primera observación absoluta, eso incluye información futura.

Es una fuga minúscula —probablemente solo afecta a una observación—, pero metodológicamente existe.

Yo cambiaría esa lógica.

En lugar de:

```python
df_reducido[TARGET].mean()
```

deberías utilizar una tasa base definida sin mirar el futuro.

Por ejemplo, una tasa histórica inicial fijada previamente o la prevalencia del conjunto de entrenamiento.

Esto es importante porque tu principio debe ser:

$$
\boxed{
X_t\text{ solamente puede depender de información disponible antes de }t
}
$$

---

# 13. Celdas 19–20 — Train/Test temporal

Esta es probablemente una de las decisiones metodológicas más fuertes del proyecto.

Ordenas:

$$
fecha\_inicio\_obra
$$

y haces:

```python
df_train = df_reducido.iloc[:split_idx]
df_test = df_reducido.iloc[split_idx:]
```

Por tanto:

```text
PASADO                                      FUTURO
──────────────────────────┬──────────────────────►
                          │
                       cutoff
                          │
             TRAIN        │       TEST
```

Esto representa el verdadero escenario de uso:

$$
\boxed{
\text{entrenar con obras históricas}
\rightarrow
\text{predecir obras futuras}
}
$$

Mucho mejor que un `train_test_split` aleatorio.

---

# 14. ⚠️ Una inconsistencia que debes corregir

La celda markdown dice:

> "65% más antiguo y 35% más reciente".

Pero el código dice:

```python
split_idx = int(len(df_reducido) * 0.62)
```

Es decir:

$$
62\%/38\%.
$$

Esto debe corregirse en el notebook.

En una defensa, un profesor puede detectar inmediatamente esta inconsistencia.

---

# 15. Celdas 21–27 — M0: regresión logística base

Aquí aparece el modelo estadístico clásico:

$$
Y_i\sim Bernoulli(p_i)
$$

con:

$$
\boxed{
\log\frac{p_i}{1-p_i}
=
\beta_0+\beta_1X_{i1}+\cdots+\beta_kX_{ik}
}
$$

La probabilidad queda:

$$
\boxed{
p_i=
\frac{1}{1+e^{-X_i^\top\beta}}
}
$$

---

# 16. ¿Qué está haciendo `sm.Logit`?

```python
sm.Logit(y, X)
```

estima:

$$
\hat\beta
=
\arg\max_\beta
\ell(\beta)
$$

donde:

$$
\ell(\beta)
=
\sum_{i=1}^{n}
[
y_i\log p_i+
(1-y_i)\log(1-p_i)
].
$$

Es decir:

$$
\boxed{\text{máxima verosimilitud}}
$$

que es uno de los fundamentos centrales del GLM.

---

# 17. ¿Por qué BFGS?

Utilizas:

```python
method="bfgs"
```

porque observaste problemas de convergencia con Newton-Raphson.

La razón matemática es que Newton necesita trabajar con:

$$
H(\beta)=
\frac{\partial^2\ell}
{\partial\beta\partial\beta^\top}
$$

y si existe cuasi-separación o mala condición numérica, el Hessiano puede ser problemático.

BFGS aproxima el Hessiano inverso mediante actualizaciones sucesivas.

Esto es una decisión computacional que puedes defender perfectamente:

> "La elección del optimizador se realizó considerando la estabilidad numérica del problema de máxima verosimilitud."

El notebook documenta precisamente ese problema y la solución mediante BFGS. 

---

# 18. Celda 25 — Odds Ratio

Calculas:

```python
np.exp(params)
```

porque:

$$
OR_j=e^{\beta_j}.
$$

Por ejemplo, el notebook obtiene para algunas variables valores como:

$$
OR=2.043
$$

para la variable transformada del monto. 

Interpretación:

> manteniendo constantes las demás variables, un incremento de una unidad en esa variable transformada multiplica los odds de paralización por aproximadamente 2.04.

### Importante

Como algunas variables están:

* estandarizadas;
* transformadas;
* target encoded;
* WOE;

la interpretación de "una unidad" **no necesariamente corresponde a una unidad natural de la variable original**.

Esto debe explicarse en el informe.

---

# 19. Celdas 26–27 — probabilidad y umbral

Calculas:

```python
y_proba_m0
```

que representa:

$$
\hat p_i.
$$

Luego:

```python
y_pred_m0 = (y_proba_m0 >= 0.5).astype(int)
```

implementa:

$$
\boxed{
\hat Y_i=I(\hat p_i\ge0.5)
}
$$

Aquí aparece una distinción fundamental:

```text
modelo
  │
  ▼
probabilidad
  │
  ▼
umbral
  │
  ▼
clasificación
```

El modelo genera una probabilidad.

El umbral genera la decisión.

**No son la misma cosa.**

La función `analizar_umbrales()` explora diferentes valores de \(c\).

---

# 20. Celdas 28–35 — M2 y Random Forest

Aquí tu metodología mejora sustancialmente.

Usas:

```python
Pipeline(
    preprocesador,
    clasificador
)
```

Esto evita una fuga de información durante CV.

Por ejemplo:

```text
Fold 1
TRAIN ──► aprende target encoding
TEST  ──► solamente transforma

Fold 2
TRAIN ──► aprende target encoding
TEST  ──► solamente transforma
```

Eso es correcto.

El propio notebook identifica esto como una mejora respecto a la versión anterior. 

---

# 21. ¿Por qué validación cruzada anidada?

Utilizas:

```python
cv_interno = TimeSeriesSplit(n_splits=3)
cv_externo = TimeSeriesSplit(n_splits=5)
```

y:

```text
              TRAIN
                 │
        ┌────────┴────────┐
        │                 │
    CV EXTERNA        CV EXTERNA
        │
        ▼
   ┌──────────────┐
   │ CV INTERNA   │
   │              │
   │ seleccionar  │
   │ hiperparámetros
   └──────────────┘
```

La idea matemática es evitar:

$$
\boxed{
\text{optimismo por selección de hiperparámetros}
}
$$

Si utilizas el mismo conjunto para:

1. escoger hiperparámetros;
2. evaluar desempeño;

la evaluación queda contaminada.

La validación anidada evita eso.

---

# 22. M2 — Elastic Net

Tu modelo:

```python
penalty="elasticnet"
```

minimiza conceptualmente:

$$
-\ell(\beta)
+
\lambda
\left[
\alpha\|\beta\|_1+
(1-\alpha)\|\beta\|_2^2
\right].
$$

Esto combina:

### LASSO

$$
\|\beta\|_1
$$

con:

### Ridge

$$
\|\beta\|_2^2.
$$

Por eso es útil cuando existen:

* muchas variables;
* correlación;
* dummies;
* riesgo de sobreajuste.

El curso contempla explícitamente Ridge, Lasso y Elastic Net. 

---

# 23. Random Forest

Aquí cambia completamente la estructura matemática.

Un árbol divide el espacio:

$$
X\rightarrow regiones
$$

y el Random Forest construye:

$$
B
$$

árboles.

La predicción probabilística es aproximadamente:

$$
\hat p(x)
=
\frac{1}{B}
\sum_{b=1}^{B}
\hat p_b(x).
$$

Su ventaja:

$$
\boxed{\text{captura no linealidades e interacciones automáticamente}}
$$

sin especificarlas explícitamente.

Por eso es razonable que RF tenga mayor AUC que los modelos lineales/GAM en tus resultados.

---

# 24. Celdas 36–42 — GLM c-loglog y probit

Aquí estás haciendo algo muy interesante desde el punto de vista de MEAD:

no solamente comparas algoritmos de ML, sino **diferentes especificaciones estadísticas**.

Para un GLM binomial:

$$
Y_i\sim Bernoulli(p_i)
$$

y:

$$
g(p_i)=X_i^\top\beta.
$$

Cambias \(g\).

---

## M4 — complementary log-log

$$
\boxed{
g(p)=\log[-\log(1-p)]
}
$$

por tanto:

$$
\boxed{
p=1-\exp[-\exp(X\beta)]
}
$$

Es útil cuando la relación entre predictor y probabilidad no tiene la simetría propia del logit.

---

# 25. M5 — probit

Utilizas:

$$
\boxed{
\Phi^{-1}(p)=X\beta
}
$$

donde \(\Phi\) es la CDF normal estándar.

Entonces:

$$
p=\Phi(X\beta).
$$

El probit tiene una interpretación mediante una variable latente:

$$
Y^*=X\beta+\epsilon,
$$

con:

$$
\epsilon\sim N(0,1),
$$

y:

$$
Y=1
\iff
Y^*>0.
$$

Esto permite una defensa matemática muy bonita del modelo.

---

# 26. ⚠️ No interpretes `exp(beta)` del probit como odds ratio

Correctamente, el notebook ya advierte esto.

En logit:

$$
e^\beta=OR.
$$

En probit:

$$
e^\beta
$$

**no es un odds ratio**.

Por tanto, para probit debes interpretar:

* signo;
* magnitud relativa;
* efecto marginal;
* cambio en probabilidad.

---

# 27. ⚠️ Y cuidado con "hazard ratio" para c-loglog

Aquí haría una revisión de la redacción del notebook.

El `complementary log-log` puede tener interpretaciones relacionadas con riesgos/tasas en ciertos modelos de supervivencia o discretización de hazard, pero **no es correcto llamar automáticamente a \(e^\beta\) "hazard ratio" en cualquier GLM binomial c-loglog**.

En tu modelo estás estimando:

$$
P(Y=1|X),
$$

no necesariamente:

$$
P(T=t|T\ge t,X)
$$

de un modelo de supervivencia.

Por eso para tu proyecto yo recomendaría:

> **"razón multiplicativa en la escala del enlace complementary log-log"**

o simplemente interpretar mediante **probabilidades predichas y efectos marginales**.

---

# 28. Celdas 43–45 — GAM

Aquí aparece una extensión estadística mucho más rica.

Tu GAM tiene la forma:

$$
\boxed{
g(p_i)
=
\beta_0+
\sum_{j=1}^{q}\beta_jZ_{ij}
+
\sum_{k=1}^{m}f_k(X_{ik})
}
$$

donde:

* \(Z\): variables lineales;
* \(X\): variables suaves;
* \(f_k\): funciones no paramétricas.

Esto permite:

$$
\text{efecto}(X)\neq\beta X.
$$

---

# 29. ¿Qué hace un spline?

Una función:

$$
f(x)
$$

se aproxima mediante una combinación de bases:

$$
\boxed{
f(x)=\sum_{r=1}^{K}\theta_rB_r(x)
}
$$

donde \(B_r(x)\) son funciones spline.

Tu código:

```python
BSplines(
    X_smooth_train,
    df=[5]*len(columnas_suaves),
    degree=[3]*len(columnas_suaves)
)
```

construye bases cúbicas:

$$
degree=3.
$$

El `df=5` controla la complejidad de la representación.

---

# 30. ¿Por qué GAM es estadísticamente interesante?

La logística impone:

$$
f(x)=\beta x.
$$

El GAM permite:

$$
f(x)
$$

estimado desde los datos.

Por tanto:

```text
LOGIT

riesgo
 │
 │       /
 │     /
 │   /
 └──────── X
```

versus:

```text
GAM

riesgo
 │
 │     ______
 │   /
 │ _/
 └──────── X
```

Esto permite descubrir:

* umbrales;
* saturación;
* relaciones U;
* efectos decrecientes;
* regiones de fuerte sensibilidad.

---

# 31. Celdas 45–54 — M6, M7, M8

Los tres GAM comparten:

$$
\{X_{\text{smooth}},X_{\text{linear}}\}
$$

y solamente cambian:

$$
g(p).
$$

Por tanto puedes estudiar:

> ¿La mejora proviene de permitir no linealidad o de cambiar la función de enlace?

Esto es muy bueno para el marco teórico.

Tienes:

$$
M6:\quad logit
$$

$$
M7:\quad cloglog
$$

$$
M8:\quad probit.
$$

---

# 32. El problema de extrapolación de splines

El notebook detecta que algunas observaciones de test pueden estar fuera del rango de train:

```python
np.clip(...)
```

Esto evita que `statsmodels` falle.

Pero metodológicamente hay que explicarlo con cuidado.

Estás haciendo:

$$
X_{test}<\min(X_{train})
\Rightarrow
X_{test}=\min(X_{train})
$$

y:

$$
X_{test}>\max(X_{train})
\Rightarrow
X_{test}=\max(X_{train}).
$$

Esto significa que estás **truncando el dominio futuro al dominio histórico**.

Puede ser razonable desde el punto de vista operativo:

> "No extrapolamos una relación no paramétrica fuera del soporte observado."

Pero debes cuantificar cuántos valores fueron recortados.

El notebook precisamente lo reporta. 

Si fueran muchos, sería una limitación importante del GAM.

---

# 33. Ponderación por desbalance

Tus pesos:

$$
w_c=
\frac{n}{K n_c}.
$$

Para dos clases:

$$
w_1=\frac{n}{2n_1}
$$

y:

$$
w_0=\frac{n}{2n_0}.
$$

Esto hace que la clase minoritaria tenga mayor influencia en:

$$
\ell_w(\beta)
=
\sum_iw_i\ell_i(\beta).
$$

Es decir:

$$
\boxed{
\text{no modificas los datos; modificas su contribución a la función objetivo}
}
$$

Esto es mejor defendible que SMOTE si quieres conservar las observaciones originales.

---

# 34. Pero aquí hay una cuestión crucial para tu proyecto

El modelo ponderado **ya no estima directamente la probabilidad poblacional original** de la misma manera que el modelo no ponderado.

Esto es exactamente lo que el notebook reconoce en la sección 5.4–5.5. 

Conceptualmente:

```text
datos reales
   │
   ▼
P(Y=1) ≈ 0.075
   │
   │
ponderación
   ▼
función de pérdida artificial
   │
   ▼
más importancia a Y=1
```

Esto ayuda a **clasificar**.

Pero puede perjudicar la **calibración absoluta**.

Y esto es fundamental porque tu producto final es:

$$
P(Y=1|X).
$$

---

# 35. Entonces hay dos objetivos distintos

### Objetivo A — discriminación

$$
\hat p_{riesgo}>\hat p_{no\ riesgo}
$$

Aquí quieres:

$$
ROC\ AUC,\ PR\ AUC
$$

altos.

### Objetivo B — probabilidad correcta

Quieres:

$$
P(Y=1|\hat p\approx0.20)\approx0.20.
$$

Aquí quieres:

$$
Brier
$$

bajo y buena calibración.

Esto es exactamente la distinción que estás intentando incorporar en las celdas 55–63. 

---

# 36. Celdas 55–60 — evaluación final

Tu tabla integra:

### Discriminación

$$
ROC\ AUC
$$

$$
PR\ AUC
$$

$$
Gini=2AUC-1.
$$

### Calibración

$$
BS=
\frac1n
\sum_i(\hat p_i-y_i)^2.
$$

### Decisión

$$
Precision,\ Recall,\ F1,\ F2.
$$

Esta es probablemente la mejor parte conceptual del notebook.

---

# 37. ¿Por qué PR AUC es especialmente importante?

Porque:

$$
P(Y=1)=0.0745.
$$

Con una clase positiva tan poco frecuente, ROC puede dar una imagen relativamente favorable aunque existan muchos falsos positivos.

PR AUC se concentra en:

$$
Precision
$$

y:

$$
Recall.
$$

Por eso tu elección es estadísticamente razonable.

---

# 38. F2 y el costo del falso negativo

Tu:

$$
F_2=
5\frac{PR}{4P+R}.
$$

Da mayor peso a Recall.

Eso se puede justificar mediante:

$$
C(FN)>C(FP).
$$

En tu aplicación:

```text
NO detectar una obra que se paralizará
                 ↓
       potencialmente alto costo

investigar una obra que finalmente
no se paraliza
                 ↓
       costo de supervisión
```

Por eso F2 puede utilizarse como métrica **operativa**, aunque no necesariamente como criterio único para escoger el modelo probabilístico.

---

# 39. Celdas 59–60 — calibración

La curva compara:

$$
\hat p
$$

contra:

$$
\hat P(Y=1|\hat p).
$$

La calibración perfecta es:

$$
\boxed{y=x}.
$$

Y Brier:

$$
\boxed{
BS=\frac1n\sum(\hat p-y)^2
}
$$

mide el error cuadrático.

Por tanto:

```text
ROC/PR
   ↓
¿ordena correctamente?

Brier/calibration
   ↓
¿las probabilidades tienen significado absoluto?
```

Para tu proyecto esto es fundamental.

---

# 40. Celdas 61–63 — interpretabilidad

Aquí construyes una dimensión cualitativa:

```text
Logit      → alta
GLM        → media
GAM        → media-baja
RF         → baja
```

La idea es válida, pero yo la expresaría como:

$$
\boxed{
\text{trade-off entre flexibilidad predictiva e interpretabilidad}
}
$$

No necesariamente:

> "RF es poco interpretable."

Más exactamente:

> "RF no proporciona una interpretación paramétrica global mediante coeficientes y odds ratios; requiere métodos de interpretación post-hoc."

Esto es más riguroso.

---

# 41. Celda 65 — interpretación del GAM

Esta celda está muy bien conceptualmente.

No intentas hacer:

$$
e^\beta
$$

porque no existe un único \(\beta\) para:

$$
f(X).
$$

En cambio comparas:

$$
X=P10
$$

versus:

$$
X=P90.
$$

Y calculas:

$$
\hat p_{10}
$$

y:

$$
\hat p_{90}.
$$

Por ejemplo:

$$
P_{10}=0.08
$$

$$
P_{90}=0.23.
$$

La interpretación sería:

> Manteniendo las demás variables en el perfil de referencia, pasar del percentil 10 al percentil 90 de esta variable incrementa la probabilidad estimada de paralización de 8% a 23%.

Eso es excelente para comunicar el GAM.

El notebook implementa exactamente esta lógica. 

---

# 42. Celda 67 — permutation importance

Esta parte también es metodológicamente interesante.

Permutas:

$$
X_j
$$

y observas cuánto cae:

$$
PR\ AUC.
$$

Conceptualmente:

$$
Importance(X_j)
=
Score_{original}
-
Score_{permutado}.
$$

Si:

$$
PR_{original}=0.30
$$

y:

$$
PR_{permutado}=0.18,
$$

entonces:

$$
Importance=0.12.
$$

Interpretación:

> La información contenida en \(X_j\) aporta aproximadamente 0.12 unidades de PR-AUC bajo esta evaluación de permutación.

Pero:

$$
\boxed{\text{importancia predictiva}\neq\text{efecto causal}}
$$

---

# 43. Celda 68 — reproducibilidad

La parte de reproducibilidad está muy bien.

Tienes:

$$
RANDOM\_STATE=42
$$

y pipelines que encapsulan:

```text
imputación
winsorización
log
estandarización
target encoding
WOE
one-hot
modelo
```

Esto permite que:

$$
fit(X_{train})
$$

aprenda transformaciones exclusivamente del entrenamiento.

Eso es crucial para evitar:

$$
\boxed{\text{data leakage}}
$$

y está alineado con la competencia de MEAD de validación computacional de modelos. 

---

# 44. Lo más importante: ¿cómo defender matemáticamente todo el notebook?

Yo resumiría el fundamento en cinco capas.

## Capa 1 — Probabilidad

$$
\boxed{
Y|X\sim Bernoulli(p(X))
}
$$

---

## Capa 2 — Inferencia

$$
\boxed{
\hat\theta
=
\arg\max_\theta L(\theta;D)
}
$$

o, con penalización:

$$
\boxed{
\hat\theta
=
\arg\min_\theta
[-\ell(\theta)+\lambda P(\theta)]
}
$$

---

## Capa 3 — Estructura del modelo

Logit:

$$
logit(p)=X\beta
$$

c-loglog:

$$
log[-log(1-p)]=X\beta
$$

probit:

$$
\Phi^{-1}(p)=X\beta
$$

GAM:

$$
g(p)=
\beta_0+
\sum_j\beta_jX_j+
\sum_kf_k(X_k).
$$

RF:

$$
\hat p(x)=
\frac1B\sum_b\hat p_b(x).
$$

---

# 45. Capa 4 — Generalización

Tu pregunta estadística no es:

> "¿qué tan bien ajusta el modelo?"

sino:

$$
\boxed{
E_{nuevo}[\mathcal L(Y,\hat f(X))]
}
$$

¿Cómo se comportará sobre obras futuras?

Por eso:

$$
Train\rightarrow CV\ temporal\rightarrow Test\ temporal.
$$

---

# 46. Capa 5 — Riesgo

Finalmente:

$$
\boxed{
R(X)=P(Y=1|X)
}
$$

y:

$$
\hat Y=I(R(X)\ge c).
$$

Es decir:

```text
PROBABILIDAD
     │
     │  modelo estadístico
     ▼
RIESGO
     │
     │  umbral / costo
     ▼
DECISIÓN
```

Esta es la verdadera arquitectura matemática de tu proyecto.

---

# 47. Los 5 puntos que yo corregiría antes de cerrar el notebook

### 1. Corregir el 65% vs 62%

El texto dice 65%, el código usa 62%.

---

### 2. Corregir el fallback temporal

Evitar:

```python
df_reducido[TARGET].mean()
```

para la primera observación.

Debe ser una información disponible antes de esa fecha.

---

### 3. Revisar la interpretación de c-loglog

No llamaría automáticamente:

$$
e^\beta
$$

"hazard ratio".

Mejor utilizar efectos sobre probabilidad o interpretar la escala del enlace.

---

### 4. Tratar AIC/BIC como criterio auxiliar

Especialmente para GAM penalizado y modelos ponderados.

No elegiría el modelo final por AIC/BIC.

---

### 5. Calibración de modelos ponderados

Este es el punto más importante.

Si el producto final es:

$$
\boxed{P(Y=1|X)}
$$

debes decidir entre:

```text
modelo ponderado
       ↓
mejor discriminación
       ↓
calibración post-hoc
```

o:

```text
modelo no ponderado
       ↓
mejor probabilidad base
       ↓
ajuste del umbral
```

Esto merece una sección metodológica específica.

---

# 48. Y una conclusión importante sobre tu trabajo

Tu proyecto **ya dejó de ser simplemente un problema de clasificación**.

La arquitectura que realmente estás construyendo es:

$$
\boxed{
\text{Modelo estadístico de estimación de riesgo}
}
$$

con cuatro propiedades:

$$
\boxed{
\begin{array}{c}
\text{Discriminación}\\
\text{Calibración}\\
\text{Interpretabilidad}\\
\text{Validez temporal}
\end{array}
}
$$

Y esto es precisamente lo que hace que el trabajo sea defendible desde **Modelos Estadísticos para el Análisis de Datos**, en lugar de ser solamente un ejercicio de Machine Learning. El curso busca que el estudiante formule modelos, aplique estimación/validación computacional y analice críticamente supuestos, limitaciones y estrategias de robustecimiento. 

**Mi recomendación es no añadir más modelos todavía.** El siguiente paso debería ser convertir este notebook en una **defensa estadística formal**, celda por celda: para cada bloque estableceremos **(1) qué problema estadístico resuelve, (2) qué fundamento matemático lo sustenta, (3) qué hace exactamente cada línea de código, (4) qué supuesto está involucrado, (5) qué resultado esperamos y (6) cómo se redactaría en el informe MEAD**. Eso además permitirá detectar y corregir las inconsistencias metodológicas antes de presentar el proyecto.
