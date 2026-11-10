# Revisión Bibliográfica: Solís Villanueva (2018)

**Referencia (APA):**  
Solís Villanueva, R. (2018). Técnicas de inteligencia artificial para optimizar la eficiencia del procedimiento de selección para la contratación de obras públicas. *Interfases*, (11), 13–42. https://doi.org/10.26439/interfases2018.n011.2951

---

## 1. Ficha Técnica del Artículo

| Dimensión | Detalle |
| :--- | :--- |
| **Autor** | Reiner Solís Villanueva (Universidad de Lima) |
| **Revista** | *Interfases* (Facultad de Ingeniería y Arquitectura, Universidad de Lima), N.° 11, 2018 |
| **Ámbito de aplicación** | Contratación de obras públicas en el Estado Peruano (Ley N.° 30225 y RLCE) |
| **Problema abordado** | Mecanismos de desempate ineficientes y aleatorios (sorteo) en los procedimientos de selección de Adjudicación Simplificada y Licitación Pública de obras |
| **Propuesta de solución** | Arquitectura dual: (1) Sorteo electrónico criptográfico auditable (SHA-256) para Adjudicación Simplificada; (2) Predicción del Índice de Cumplimiento ($IC$) y de la probabilidad de éxito/fracaso de postores mediante Redes Neuronales Artificiales (RNA) para Licitaciones Públicas |
| **Fuente de datos** | Registros históricos de 209 proyectos de infraestructura ejecutados por un grupo empresarial peruano (5 empresas constructoras) desde 1988 (2,299 observaciones/indicadores) |
| **Modelos de IA** | Perceptrón Multicapa (*Feed-Forward Backpropagation*) con optimización Levenberg-Marquardt (16 arquitecturas evaluadas en MATLAB Neural Network Toolbox) |
| **Variables de entrada** | 10 indicadores de riesgo: RPP (precio ofertado/base), RGP (gastos generales/costo directo), RUP (utilidad/costo directo), TP (tipo de proyecto), PE (plazo de ejecución), EIR/EIS/EIC/EGA (experiencia del residente, seguridad, calidad y gerencia), K (factor de reajuste polinómico) |
| **Métrica de salida** | Índice de Cumplimiento ($IC$) continuo (regresión no lineal) y clasificación dicotómica de éxito ($1$) vs. fracaso ($0$) con umbral de corte $0.5$ |

---

## 2. Aportes Clave y Relevancia para el Plan de Tesis

1. **Precedente pionero nacional:** Constituye uno de los escasos antecedentes formales en la literatura peruana que propone la incorporación de técnicas de aprendizaje automático e inteligencia artificial al marco de las contrataciones del Estado reguladas por el OSCE.
2. **Identificación de factores de riesgo contractuales y operativos:** Valida la pertinencia de variables predictoras clave en el contexto constructivo nacional, tales como la relación entre oferta económica y presupuesto base, la experiencia técnica del personal clave, el plazo programado y el factor de reajuste de precios por inflación (fórmula polinómica $K$).
3. **Formulación del riesgo como variable dicotómica y probabilística:** Concibe la evaluación del contratista en términos de probabilidad de éxito o fracaso ($Y \in \{0, 1\}$) previa a la suscripción del vínculo contractual, formalizando la toma de decisiones asistida por modelos analíticos.

---

## 3. Limitaciones del Estudio y Brechas que Cubre la Presente Tesis

A pesar de su valor conceptual y pionero, el trabajo de Solís Villanueva (2018) presenta limitaciones metodológicas sustantivas que diferencian y justifican la presente investigación de maestría:

* **Fase del ciclo de vida:** El estudio se restringe a la **fase pre-contractual** (selección y otorgamiento de la buena pro en caso de empate), dejando desatendida la **fase de ejecución contractual**, donde verdaderamente se materializan las controversias, los incumplimientos y la paralización física de la obra.
* **Escala y representatividad de los datos:** Se sustentó en una muestra reducida y privada de 209 proyectos de un único grupo empresarial (5 empresas), lo que compromete la generalización de los resultados. La presente tesis analiza el **universo nacional de obras públicas** a partir de registros administrativos oficiales abiertos (INFObras de CGR, Banco de Inversiones Invierte.pe del MEF y SEACE).
* **Definición del fenómeno objetivo:** Evaluó un índice interno de cumplimiento proyectado, mientras que nuestra investigación aborda de forma explícita el problema de **paralización de obras por causal de incumplimiento contractual** (responsabilidad de la entidad y/o contratista), causal que concentra más del 36.9 % del costo paralizado nacional.
* **Enfoque algorítmico y limitaciones técnicas:** Solo evaluó redes neuronales multicapa clásicas, sin contrastar con ensambles de árboles de decisión de última generación (XGBoost, LightGBM, CatBoost) ni modelos estadísticos interpretables (GLM, GAM).
* **Desbalance de clases no abordado:** Asumió escenarios balanceados artificiales o simétricos, omitiendo el severo desbalance de clases que caracteriza a los eventos de paralización en registros públicos reales, así como el uso de métricas de precisión-recall ($F_2$-score, PR-AUC) y calibración de probabilidades (Brier score).
* **Ausencia de Inteligencia Artificial Explicable (XAI):** La arquitectura de red neuronal operó como "caja negra", sin mecanismos de atribución local o global (como valores SHAP), aspecto indispensable para la toma de decisiones justificada y transparente en el sector público.

---

## 4. Texto Propuesto para la Sección `== 1.2.1 Antecedentes Bibliográficos` en `main.typ`

A continuación se presenta la redacción académica lista para ser incorporada y sustituir la viñeta preliminar en la sección correspondiente de [`tesis/plan/main.typ`](file:///c:/ws/formacion/uni-mia/mia-tesis-opa/tesis/plan/main.typ):

```typst
En el contexto peruano, la literatura sobre la aplicación de técnicas de inteligencia artificial a la gestión de contrataciones y obras públicas es sumamente incipiente y de carácter mayoritariamente exploratorio. Un antecedente fundamental lo constituye el trabajo de @solis-villanueva_tecnicas_2018, quien formuló una arquitectura automatizada para optimizar los procedimientos de selección de obras públicas bajo la Ley de Contrataciones del Estado (Ley N.° 30225), orientada a resolver escenarios de empate mediante un sistema híbrido: sorteo criptográfico auditable (SHA-256) en adjudicaciones simplificadas y predicción del comportamiento del contratista en licitaciones públicas. Para este último procedimiento, el autor propuso un modelo basado en redes neuronales artificiales de tipo perceptrón multicapa (_feed-forward backpropagation_) entrenadas mediante el algoritmo de Levenberg-Marquardt sobre una muestra histórica de 209 proyectos de infraestructura ejecutados por un grupo empresarial peruano. Dicho modelo evaluó diez indicadores de riesgo operativo y contractual —entre los que destacan la relación entre el presupuesto ofertado y el valor referencial, los gastos generales, la experiencia del personal clave residente y de gerencia, el plazo contractual y el factor de reajuste polinómico de precios ($K$)— con el fin de estimar un índice de cumplimiento continuo y clasificar la probabilidad de éxito o fracaso del postor ($Y in {0, 1}$) previo al otorgamiento de la buena pro.

Si bien la contribución de @solis-villanueva_tecnicas_2018 resulta pionera al demostrar la viabilidad de cuantificar el riesgo de los contratistas a partir de atributos técnicos y económicos en el marco normativo peruano, su alcance se limitó estrictamente a la fase pre-contractual de selección de proveedores y dependió de una muestra privada reducida de proyectos de un solo consorcio empresarial. En consecuencia, dicho enfoque no trascendió hacia la fase de ejecución contractual ni abordó el universo masivo y heterogéneo de obras registradas en los sistemas administrativos oficiales del Estado (como INFObras, el Banco de Inversiones del MEF y el SEACE). Asimismo, la aproximación se circunscribió a redes neuronales de tipo "caja negra" con arquitecturas evaluadas bajo error cuadrático medio estándar, omitiendo el tratamiento del severo desbalance de clases inherente a las paralizaciones contractuales, la calibración probabilística de las salidas y la interpretabilidad de las predicciones; vacíos que la presente investigación se propone resolver mediante una formulación rigurosa de aprendizaje automático e inteligencia artificial explicable orientada a la fase contractual.
```

---

## 5. Tabla Comparativa: Solís Villanueva (2018) vs. Presente Investigación

| Criterio | Solís Villanueva (2018) | Presente Tesis de Maestría |
| :--- | :--- | :--- |
| **Objeto de estudio** | Selección de proveedores en caso de empate en licitaciones públicas | Estimación anticipada del riesgo de paralización de obras públicas por incumplimiento contractual |
| **Fase analizada** | Pre-contractual (selección y adjudicación de la buena pro) | Contractual (ejecución física e incidencias contractuales de la obra) |
| **Fuente de datos** | Privada (209 proyectos históricos de 1 consorcio de 5 empresas constructoras) | Pública oficial (Registros masivos abiertos de INFObras - CGR, Invierte.pe - MEF, SEACE) |
| **Variable dependiente** | Éxito/Fracaso según Índice de Cumplimiento interno derivado | Binaria $Y \in \{0, 1\}$: Paralización formal por causal contractual según clasificación de CGR |
| **Desbalance de clases** | No considerado (evaluación con error absoluto/cuadrático en muestra reducida) | Central: Tratamiento explícito de evento minoritario mediante remuestreo/cost-sensitive |
| **Familias de modelos** | Redes Neuronales Artificiales (MLP multicapa con Levenberg-Marquardt) | Comparación factorial: Ensambles basados en árboles (Random Forest, XGBoost, LightGBM, CatBoost) vs. Modelos estadísticos (GLM, GAM, Regresión Logística) |
| **Métricas de evaluación** | MSE, Error Absoluto Medio (Mean), Desviación estándar del error | Recall, $F_2$-score, PR-AUC, ROC-AUC, Brier score (calibración) y optimización de umbrales |
| **Interpretabilidad** | Ninguna (modelo de caja negra) | Inteligencia Artificial Explicable (XAI) mediante valores SHAP a nivel global y local por obra |
