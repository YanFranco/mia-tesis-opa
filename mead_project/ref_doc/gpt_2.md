Sí. Aquí ya podemos pasar de la evaluación de métricas a la **arquitectura estadística completa de tu proyecto**. De hecho, las cinco preguntas están conectadas: primero defines qué significa "riesgo", luego qué variables aportan información, después cómo comparar modelos, y finalmente cómo interpretar y calibrar las probabilidades.

Tu objetivo puede formularse de manera muy precisa como:

$$
\boxed{
\text{Estimar }p(x)=P(Y=1\mid X=x)
}
$$

donde \(Y=1\) significa que la obra se paraliza y \(X\) contiene exclusivamente información disponible al inicio de la obra.

Esto es coherente con el enfoque del curso: formular modelos estadísticos, estimarlos, diagnosticarlos, validarlos y analizar críticamente sus supuestos y limitaciones. 

---

# 1. Desarrollo del modelo funcional y matemático

Yo plantearía tu proyecto en **tres niveles**.

## Nivel 1 — Fenómeno aleatorio

Para cada obra \(i\):

$$
Y_i\in\{0,1\}
$$

con:

$$
Y_i\sim Bernoulli(p_i)
$$

donde:

$$
p_i=P(Y_i=1\mid X_i)
$$

Este es el corazón probabilístico del problema.

---

## Nivel 2 — Modelo estadístico

Para la regresión logística:

$$
\boxed{
\operatorname{logit}(p_i)
=
\log\left(\frac{p_i}{1-p_i}\right)
=
\beta_0+\sum_{j=1}^{k}\beta_jX_{ij}
}
$$

por tanto:

$$
\boxed{
p_i=
\frac{1}{1+\exp[-(\beta_0+X_i^\top\beta)]}
}
$$

El modelo transforma una combinación lineal de las variables \(X\) en una probabilidad entre 0 y 1.

Para el GLM con enlace complementary log-log:

$$
\boxed{
g(p_i)=\log[-\log(1-p_i)]
=X_i^\top\beta
}
$$

y por tanto:

$$
\boxed{
p_i=1-\exp[-\exp(X_i^\top\beta)]
}
$$

Esto es importante porque **logit y complementary log-log no son simplemente dos formas diferentes de calcular odds**; utilizan diferentes funciones de enlace.

El sílabo contempla explícitamente los GLM dentro de los modelos lineales avanzados, incluyendo su ajuste, inferencia y diagnóstico. 

---

## Nivel 3 — Modelo funcional para la aplicación

Finalmente:

$$
\boxed{
R(X)=\hat P(Y=1\mid X)
}
$$

y defines:

$$
\boxed{
R(X)=\text{riesgo estimado de paralización}
}
$$

Por ejemplo:

$$
R(X)=0.27
$$

se interpreta como:

> Para una obra con determinadas características \(X\), el modelo estima una probabilidad de paralización de 27%.

**No significa que "la obra tiene 27% de posibilidades" en un sentido causal**, sino que, bajo el modelo y población de referencia, su probabilidad condicional estimada es 0.27.

---

# 2. ¿Cómo saber qué \(X_i\) es un buen discriminador?

Aquí debemos separar dos conceptos:

### Asociación estadística

> ¿La variable está relacionada con \(Y\)?

de:

### Capacidad predictiva

> ¿La variable ayuda a distinguir obras que se paralizan de las que no?

Y de:

### Interpretación causal

> ¿La variable provoca o contribuye causalmente a la paralización?

**No son lo mismo.**

Para tu proyecto estás haciendo principalmente **predicción**, no inferencia causal.

---

## 2.1. Primer nivel: análisis individual

Puedes comenzar estudiando cada variable \(X_j\) respecto a \(Y\).

Para una variable continua:

$$
X_j\rightarrow Y
$$

puedes comparar distribuciones entre:

$$
Y=0
$$

y

$$
Y=1.
$$

Por ejemplo:

```text
                 X = monto de obra

No paralizadas     █████████████████
Paralizadas        █████████████████████
```

Puedes utilizar:

* boxplots;
* densidades;
* diferencias de medias/medianas;
* transformaciones;
* pruebas estadísticas;
* AUC univariado.

Pero **esto solamente es una primera exploración**.

---

# 2.2. En regresión logística: el coeficiente \(\beta_j\)

Si tienes:

$$
\operatorname{logit}(p)
=
\beta_0+\beta_1X_1+\cdots+\beta_jX_j
$$

entonces \(\beta_j\) representa el cambio en el **log-odds** asociado a una unidad adicional de \(X_j\), manteniendo constantes las demás variables.

Pero no debes mirar únicamente:

$$
p\text{-value}<0.05
$$

para decidir si una variable es "buen discriminador".

Una variable puede ser estadísticamente significativa pero aportar muy poco poder predictivo.

Por eso es mejor mirar:

$$
\boxed{
\text{efecto}+
\text{incertidumbre}+
\text{aporte predictivo}+
\text{estabilidad}
}
$$

---

# 2.3. Una prueba mucho más interesante: modelo reducido vs modelo completo

Supongamos:

$$
M_0:
Y\sim X_1+X_2+X_3
$$

y:

$$
M_1:
Y\sim X_1+X_2+X_3+X_4
$$

Puedes preguntar:

> ¿\(X_4\) aporta información adicional una vez que ya conozco \(X_1,X_2,X_3\)?

Eso es mucho más interesante que preguntar simplemente si \(X_4\) está asociada con \(Y\).

Puedes evaluar:

* cambio en deviance;
* likelihood ratio test;
* AIC;
* validación fuera de muestra;
* cambio en ROC AUC;
* cambio en PR AUC;
* cambio en Brier Score.

La última parte es especialmente importante:

> **Una variable predictiva es realmente interesante si mejora el desempeño fuera de muestra.**

---

# 2.4. Para Random Forest la lógica cambia

En RF no tienes:

$$
\beta_j
$$

como en una regresión.

Por tanto, no puedes utilizar directamente odds ratios.

Puedes estudiar:

* permutation importance;
* importancia por disminución de impureza;
* partial dependence;
* SHAP;
* curvas de dependencia;
* importancia fuera de muestra.

Pero nuevamente:

> importancia ≠ causalidad.

---

# 3. ¿Qué métrica debería pesar más para escoger un solo modelo?

Aquí haría una modificación importante respecto a una evaluación convencional de clasificación.

Tu objetivo es:

$$
\boxed{\text{estimar riesgo}}
$$

no simplemente:

$$
\boxed{\text{clasificar}}
$$

Por tanto, **yo no elegiría el modelo únicamente por F1, F2 o ROC AUC.**

La jerarquía que utilizaría sería:

```text
                 OBJETIVO
                    │
                    ▼
        Probabilidad de riesgo
                    │
          ┌─────────┴─────────┐
          ▼                   ▼
     Discriminación       Calibración
          │                   │
       PR AUC             Brier Score
       ROC AUC            Calibration
          │                   │
          └─────────┬─────────┘
                    ▼
             Decisión operativa
                    │
             Precision / Recall
                    │
                    ▼
                  F2
```

### Si me obligaras a elegir una sola métrica

Para **tu objetivo concreto**, yo no escogería F1.

Tendría como candidato principal el:

$$
\boxed{\text{Brier Score}}
$$

**siempre que la probabilidad estimada sea el producto principal del modelo.**

Pero tampoco usaría Brier aisladamente.

La decisión final debería considerar:

$$
\boxed{
\text{Brier + PR AUC + calibración + discriminación + costo de decisión}
}
$$

---

# 4. ¿Por qué Brier Score?

Porque tú quieres que:

$$
\hat p
$$

sea una buena estimación de:

$$
P(Y=1\mid X).
$$

El Brier Score es:

$$
\boxed{
BS=
\frac{1}{n}
\sum_{i=1}^{n}
(\hat p_i-y_i)^2
}
$$

Por ejemplo:

| Real \(y\) | Predicción \(\hat p\) | Error² |
| ---------: | --------------------: | -----: |
|          1 |                  0.80 |   0.04 |
|          1 |                  0.30 |   0.49 |
|          0 |                  0.10 |   0.01 |
|          0 |                  0.70 |   0.49 |

El modelo es penalizado cuando entrega probabilidades muy alejadas del resultado observado.

$$
\boxed{\text{menor Brier = mejor}}
$$

---

# 5. Brier Score y curva de calibración están relacionados, pero no son lo mismo

Esta distinción es importante.

### Brier Score

Es un **número**:

$$
BS=0.XX
$$

Resume el error cuadrático de las probabilidades.

### Curva de calibración

Es una **representación gráfica** de:

$$
\text{probabilidad predicha}
$$

frente a:

$$
\text{frecuencia observada}.
$$

Idealmente:

$$
\boxed{observado=predicho}
$$

por lo que queremos acercarnos a:

$$
y=x.
$$

Visualmente:

```text
frecuencia
observada
   │
1  │                 /
   │              /
   │           /
   │        /
   │     /
   │  /
0  └────────────────────
   0                  1
       probabilidad
        predicha
```

La diagonal representa **calibración perfecta**.

---

# 6. ¿Cómo implementarlo?

Supongamos que tienes:

```python
y_test
p_test_m2
p_test_m4
p_test_m6
p_test_m7
p_test_rf
```

Puedes calcular:

```python
from sklearn.metrics import brier_score_loss

brier_score_loss(y_test, p_test_rf)
```

y repetir para cada modelo.

Obtendrías:

```text
M2       0.xxx
M4       0.xxx
M6       0.xxx
M7       0.xxx
RF       0.xxx
```

Recuerda:

$$
\boxed{\text{menor es mejor}}
$$

---

# 7. Curva de calibración

En Python:

```python
from sklearn.calibration import calibration_curve
import matplotlib.pyplot as plt

prob_true, prob_pred = calibration_curve(
    y_test,
    p_test_rf,
    n_bins=10,
    strategy="quantile"
)

plt.plot(prob_pred, prob_true, marker="o")
plt.plot([0, 1], [0, 1], linestyle="--")

plt.xlabel("Probabilidad predicha")
plt.ylabel("Frecuencia observada")
plt.title("Curva de calibración - Random Forest")
plt.show()
```

La interpretación:

```text
             observado
                  │
                  │      /
                  │    /
                  │  /
                  │ /
                  │/________ predicho
```

Si la curva está aproximadamente sobre la diagonal:

$$
\boxed{\text{buena calibración}}
$$

---

# 8. Un ejemplo de interpretación

Supongamos que agrupamos proyectos a los que el modelo asignó:

$$
\hat p\approx0.20
$$

y encontramos:

$$
\text{frecuencia observada}=0.18.
$$

Entonces:

$$
0.18\approx0.20
$$

y el modelo está razonablemente calibrado.

Pero si:

$$
\hat p=0.20
$$

y:

$$
\text{observado}=0.05,
$$

el modelo está **sobreestimando el riesgo**.

Si:

$$
\hat p=0.20
$$

pero:

$$
\text{observado}=0.40,
$$

lo está **subestimando**.

Esto es muchísimo más relevante para tu proyecto que simplemente decir:

> "el modelo obtuvo F1 = 0.27".

---

# 9. ¿Y si el Random Forest discrimina bien pero está mal calibrado?

Esto puede ocurrir perfectamente.

Imagina:

$$
RF:
ROC\ AUC=0.726
$$

pero:

$$
BS=0.10
$$

mientras:

$$
M7:
ROC\ AUC=0.692
$$

pero:

$$
BS=0.04.
$$

Entonces tendrías:

```text
RF
  │
  ├── Excelente ordenando riesgo
  └── Mala estimación absoluta de probabilidades

M7
  │
  ├── Menor capacidad de discriminación
  └── Mejores probabilidades
```

La pregunta sería:

> ¿Quieres un modelo que ordene correctamente las obras por riesgo o uno cuyas probabilidades puedan interpretarse cuantitativamente?

En tu caso:

$$
\boxed{\text{ambas}}
$$

pero como tu producto final es una **medida cuantitativa de riesgo**, la calibración adquiere un peso especial.

---

# 10. Ahora vamos a los GLM: ¿cómo interpretar los coeficientes?

Para logística:

$$
\log\left(\frac{p}{1-p}\right)
=
\beta_0+\beta_1X_1+\cdots+\beta_kX_k
$$

tenemos:

$$
\boxed{
OR_j=e^{\beta_j}
}
$$

El **odds ratio** es la interpretación natural del coeficiente logístico.

---

## Ejemplo

Supongamos:

$$
\beta_{costo}=0.40
$$

entonces:

$$
OR=e^{0.40}=1.49
$$

Interpretación:

> Manteniendo constantes las demás variables, un incremento de una unidad en \(X\) multiplica los odds de paralización por aproximadamente 1.49.

Es decir:

$$
\boxed{+49\%\text{ en los odds}}
$$

por cada unidad adicional.

---

# 11. Cuidado: odds NO es probabilidad

Esto es una fuente frecuente de errores.

Si:

$$
p=0.20
$$

entonces:

$$
odds=\frac{0.20}{0.80}=0.25.
$$

Si:

$$
OR=1.5
$$

los nuevos odds serían:

$$
0.25(1.5)=0.375.
$$

La nueva probabilidad sería:

$$
p=\frac{0.375}{1+0.375}
\approx0.273.
$$

Por tanto:

$$
20\%\rightarrow27.3\%
$$

no significa que el riesgo aumentó "50 puntos porcentuales".

Aumentó los **odds** 50%.

---

# 12. Para variables categóricas

Supongamos:

$$
X=
\begin{cases}
0 & \text{modalidad A}\\
1 & \text{modalidad B}
\end{cases}
$$

y:

$$
\beta=0.80.
$$

Entonces:

$$
OR=e^{0.80}=2.23.
$$

Interpretación:

> Las obras de la modalidad B presentan aproximadamente 2.23 veces los odds de paralización respecto a las de modalidad A, manteniendo constantes las demás variables.

---

# 13. ¿Y qué pasa con el GLM complementary log-log?

Aquí tenemos que tener cuidado.

Para:

$$
g(p)=\log[-\log(1-p)]
$$

el modelo es:

$$
\log[-\log(1-p)]
=
X\beta.
$$

Por tanto:

$$
\beta_j
$$

**no tiene la misma interpretación directa como log-odds que en el modelo logit.**

En consecuencia:

$$
e^{\beta_j}
$$

**no debe interpretarse automáticamente como odds ratio**.

Esta es una distinción importante entre tu M2 y M4.

Para el complementary log-log es mucho mejor interpretar:

1. signo del coeficiente;
2. efecto sobre la probabilidad;
3. probabilidades predichas;
4. diferencias de riesgo;
5. cambios marginales.

Por ejemplo:

> Al pasar una variable de \(x\) a \(x+1\), manteniendo constantes las demás variables, la probabilidad estimada de paralización pasa de 0.12 a 0.18.

Eso es mucho más interpretable para tu aplicación.

---

# 14. ¿Y los GAM?

Aquí está una de las partes más interesantes de tus modelos.

Un GAM logit puede escribirse:

$$
\boxed{
\operatorname{logit}(p)
=
\beta_0+
f_1(X_1)+
f_2(X_2)+
\cdots+
f_k(X_k)
}
$$

donde:

$$
f_j(X_j)
$$

es una función suave estimada a partir de los datos.

A diferencia de la logística:

$$
\beta_jX_j
$$

no estás obligando al efecto a ser lineal.

---

# 15. ¿Qué significa eso intuitivamente?

La logística dice:

```text
efecto
  │
  │        /
  │      /
  │    /
  │  /
  │/
  └──────────── X
```

El GAM permite:

```text
efecto
  │
  │        ______
  │      /
  │    /
  │___/
  │
  └──────────── X
```

o:

```text
efecto
  │
  │     /\
  │    /  \
  │___/    \____
  │
  └──────────── X
```

Esto permite descubrir **no linealidades**.

---

# 16. ¿Se pueden interpretar los GAM mediante odds ratio?

**No de la misma manera que una regresión logística tradicional.**

Si tienes:

$$
\operatorname{logit}(p)
=
\beta_0+f(X)
$$

el efecto de \(X\) depende de dónde estés en el dominio.

Para comparar dos valores:

$$
x_a
$$

y:

$$
x_b,
$$

puedes calcular:

$$
\Delta f=f(x_b)-f(x_a)
$$

y entonces:

$$
\boxed{
OR(x_a\rightarrow x_b)
=
e^{f(x_b)-f(x_a)}
}
$$

Esto sí puede interpretarse como un **odds ratio entre dos valores concretos**.

---

# 17. Ejemplo conceptual de GAM

Supongamos que:

$$
f(\text{monto})
$$

crece mucho para montos pequeños, luego se estabiliza.

Podrías obtener:

```text
efecto
  │
  │              _________
  │           __/
  │        __/
  │     __/
  │____/
  └──────────────────────
       monto
```

Esto significa:

> El efecto del monto sobre el riesgo no es constante.

Una diferencia de:

$$
100k\rightarrow200k
$$

puede tener un efecto muy diferente de:

$$
900k\rightarrow1M.
$$

Ese es precisamente uno de los motivos para utilizar un GAM.

---

# 18. ¿Cómo interpretar un GAM en tu proyecto?

Yo evitaría llenar el informe con una tabla gigantesca de coeficientes.

Para cada variable importante mostraría:

### Variable

$$
X_j
$$

### Curva estimada

$$
f_j(X_j)
$$

### Probabilidad predicha

$$
P(Y=1\mid X)
$$

y, cuando sea útil:

### Comparación de escenarios

$$
P(Y=1\mid X=x_1)
$$

vs.

$$
P(Y=1\mid X=x_2).
$$

Por ejemplo:

> Manteniendo constantes las demás características, una obra con duración prevista de 24 meses presenta una probabilidad estimada de paralización de 18%, frente a 9% para una obra de 12 meses.

Esto es muchísimo más comprensible para un stakeholder.

---

# 19. Hay una estructura que te recomiendo para presentar tus modelos

No presentes simplemente:

```text
M2 → AUC
M4 → AUC
M6 → AUC
M7 → AUC
RF → AUC
```

Hazlo en cuatro dimensiones:

```text
                     MODELOS
                        │
       ┌────────────────┼─────────────────┐
       │                │                 │
       ▼                ▼                 ▼
 DISCRIMINACIÓN     CALIBRACIÓN       DECISIÓN
       │                │                 │
   ROC AUC          Brier Score       Precision
   PR AUC           Calibration       Recall
       │                Curve          F1/F2
       │                │                 │
       └────────────────┼─────────────────┘
                        ▼
                  MODELO FINAL
                        │
                        ▼
               RIESGO CUANTITATIVO
```

---

# 20. Y yo agregaría una quinta dimensión

### **Interpretabilidad**

Porque estás comparando:

* regresión logística;
* GLM c-loglog;
* GAM;
* Random Forest.

Entonces tienes un trade-off:

$$
\boxed{
\text{performance}
\quad\leftrightarrow\quad
\text{interpretabilidad}
}
$$

Por ejemplo, podrías terminar con algo como:

| Modelo       | Discriminación | Calibración | Decisión       | Interpretabilidad |
| ------------ | -------------- | ----------- | -------------- | ----------------- |
| M2 Logística | Baja           | ?           | Alto recall    | ⭐⭐⭐⭐⭐             |
| M4 GLM       | Media          | ?           | Selectivo      | ⭐⭐⭐⭐              |
| M6 GAM       | Media          | ?           | Bajo recall    | ⭐⭐⭐⭐              |
| M7 GAM       | Media-alta     | ?           | Alta precision | ⭐⭐⭐⭐              |
| RF           | **Alta**       | ?           | **Mejor F2**   | ⭐⭐                |

Esto sería mucho más sólido que decir simplemente:

> "Random Forest ganó."

---

# 21. Mi recomendación concreta para tu proyecto

Yo continuaría exactamente en este orden:

### **Paso 1 — Auditoría de variables**

Para cada \(X_j\):

$$
X_j\rightarrow Y
$$

y luego:

$$
X_j\rightarrow Y\mid X_{-j}.
$$

Buscar:

* asociación;
* no linealidad;
* colinealidad;
* estabilidad;
* leakage;
* aporte predictivo.

### **Paso 2 — Evaluar todos los modelos**

Para cada modelo:

$$
\boxed{
ROC\ AUC,\ PR\ AUC,\ Brier
}
$$

más curva de calibración.

### **Paso 3 — Evaluar calibración**

Determinar:

$$
\hat p\approx P(Y=1\mid X)?
$$

### **Paso 4 — Elegir umbral**

Solo después:

$$
\hat Y=I(\hat p>c)
$$

y analizar:

* precision;
* recall;
* F1;
* F2;
* matriz de confusión.

### **Paso 5 — Interpretar el modelo final**

Para GLM:

$$
\beta_j,\quad e^{\beta_j}
$$

cuando corresponda.

Para GAM:

$$
f_j(X_j)
$$

y probabilidades marginales/escenarios.

Para RF:

* importancia;
* permutation importance;
* SHAP/PDP;
* comportamiento de las probabilidades.

---

## Y hay una cuestión especialmente importante que debemos resolver ahora

Con tus resultados actuales, **yo todavía no elegiría RF como modelo final**, aunque sea el ganador en ROC AUC, PR AUC, F1 y F2.

Nos falta saber:

$$
\boxed{\text{¿Cuál de M2, M4, M6, M7 y RF produce probabilidades mejor calibradas?}}
$$