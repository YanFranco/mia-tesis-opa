El análisis comparativo entre familias de modelos (GLM, GAM y Random Forest) para estimar el riesgo de paralización de obras públicas por incumplimiento contractual se estructura en cuatro dimensiones fundamentales: discriminación, calibración, decisión operativa e interpretabilidad.

---

**1. Interpretación de Métricas de Evaluación**

* **ROC AUC:** Mide la probabilidad de que el modelo asigne mayor riesgo a una obra paralizada que a una no paralizada tomada al azar. Alrededor de $0.68$ en modelos como $M0$ y $M4$, refleja un ordenamiento global moderado, aunque tiende a ser optimista debido a la enorme masa de verdaderos negativos en datos desbalanceados.


* **PR AUC:** Evalúa la precisión en función de la exhaustividad focalizándose en la clase minoritaria. Valores de $0.16 - 0.20$ triplican la línea base aleatoria del test ($5.91\%$), reflejando una concentración efectiva de proyectos conflictivos en los percentiles altos del ranking de riesgo.


* **$F_2$-Score:** Pondera el Recall el doble que la Precisión, alineándose con la asimetría del costo del negocio: dejar escapar una obra que se paraliza (falso negativo) congela millones de soles en inversión pública, mientras que inspeccionar una obra sana (falso positivo) solo cuesta horas de auditoría preventiva.


* **Brier Score y Calibración:** Mide la discrepancia cuadrática entre la probabilidad estimada $\hat{p}_i$ y el desenlace real $y_i$. Es el criterio que determina si la probabilidad puede usarse como una métrica cuantitativa y financiera real (p. ej., reservas de contingencia) o solo como un puntaje de ordenamiento relativo.



---

**2. La Disyuntiva Técnica: Ponderación vs. Calibración**

| Familia de Modelos | Discriminación (ROC / PR AUC) | Decisión Operativa (Recall / $F_2$ a corte 0.5) | Calibración (Brier Score) | Rol de Negocio Recomendado |
| --- | --- | --- | --- | --- |
| **$M0$ (Logística Base no ponderada)** | Moderada ($0.689$ / $0.180$)

 | Pésima ($Recall = 0.085$, $F_2 = 0.095$)

 | **Excelente** ($BS = 0.061$)

 | Estimación presupuestal y cálculo de reservas de contingencia.

 |
| **$M2, M4, M5$ (GLM Lineales Ponderados)** | Moderada ($0.66 - 0.68$)

 | **Alta** ($Recall \approx 0.61$, $F_2 \approx 0.35$)

 | **Degradada** ($BS \approx 0.19 - 0.20$)

 | Cribado operativo y alertas tempranas para priorización de auditorías.

 |
| **$M6, M7, M8$ (GAM Aditivos Ponderados)** | Moderada ($0.65 - 0.66$)

 | Pobre al umbral fijo ($Recall \approx 0.10$)

 | **Excelente** ($BS \approx 0.066 - 0.067$)

 | Calibración robusta que absorbe la no-linealidad mediante splines.

 |
| **Random Forest (Benchmark ML)** | Regular ($0.633$ / $0.139$)

 | Intermedia ($Recall = 0.441$, $F_2 = 0.309$)

 | Intermedia ($BS = 0.135$)

 | Ordenamiento sin interpretabilidad directa de coeficientes ni estabilidad fuera de muestra.

 |

---

**3. Interpretación de Odds, Coeficientes y Enlaces**

* **Aislamiento algebraico (*Ceteris Paribus*):** En el enlace Logit, el momio total se formula como $\text{Odd}(X) = e^{\beta_0} \prod_{j=1}^k e^{\beta_j X_j}$. Al incrementar un predictor en una unidad ($\Delta X_1 = 1$), todos los demás términos aditivos y la constante se cancelan exactamente en el cociente, deduciendo que $\text{OR}_1 = e^{\beta_1}$ con total independencia de las demás covariables.


* **Hallazgos empíricos clave en los coeficientes ($M0$ y $M4$):**
* **Historial de la entidad (`codigo_entidad` WOE):** Factor de mayor riesgo relativo ($OR = 4.17$, $p < 0.001$); un historial deficiente multiplica por más de cuatro las probabilidades relativas de conflicto contractual.


* **Presupuesto (`monto_aprobado_soles` en log):** Duplica los momios de litigio ($OR = 2.04$); proyectos de gran escala añaden complejidad técnica y contractual que detona arbitrajes.


* **Naturaleza de la obra (`Instalación`):** Factor protector significativo ($OR = 0.047$, reducción del $95.3\%$ en las odds), atribuible a su menor incertidumbre constructiva frente a obras de construcción desde cero.




* **Diferenciación estricta por función de enlace:**
* **Logit ($M0, M2, M6$):** Modela log-odds; $e^\beta$ se interpreta estrictamente como **Odds Ratio**.


* **Complementary log-log ($M4, M7$):** Modela log-riesgo acumulado asimétrico; $e^\beta$ es una **Razón de Riesgo (*Hazard Ratio*)** en tiempo discreto, no una razón de momios.


* **Probit ($M5, M8$):** Modela cuantiles normales $\Phi^{-1}(p)$; carece de expresión multiplicativa cerrada y sólo admite interpretación cualitativa de signo y comparación de probabilidades predichas en escenarios marginales.