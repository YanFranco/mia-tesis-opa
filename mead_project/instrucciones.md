Entregables del proyecto final:
1. Notebooks de trabajo
2. Informe (elaborado en typst)
3. Una presentación (elaborado en typst)

## 1. Notebooks de trabajo

1. Carga y entendimiento de los datos: Se debe importar el dataset y realizar una exploración inicial. Se
recomienda incluir resúmenes estadísticos y visualizaciones básicas.

2. Preprocesamiento de datos: Tratamiento de valores faltantes, codificación de variables categóricas y
escalamiento. Todas las decisiones deben estar justificadas en el código mediante comentarios.

3. Proceso de Feature Engineering: Se deben construir nuevas variables que puedan mejorar el desempeño
de los modelos. En el caso de datos de series de tiempo, se espera el uso de lags o medias móviles.

4. Definición del esquema experimental: Se debe implementar correctamente la división de los datos para
entrenar y testear los modelos. Se debe aplicar validación cruzada anidada para la selección de modelos e
hiperparámetros.

5. Entrenamiento de modelos: Se deben comparar los modelos mediante un proceso de validación cruzada anidada. Luego, con el modelo finalista se debe realizar la búsqueda de hiperparámetros utilizando técnicas apropiadas y se debe realizar un análisis de importancia de variables.

6. Reproducibilidad: El notebook debe ser completamente reproducible, incluyendo la fijación de semillas
aleatorias, organización clara del código y uso de pipelines cuando corresponda.

## 2. Informe

### Abstract

En el resumen se debe presentar una síntesis completa y auto-contenida del trabajo. Se debe indicar brevemente el problema abordado, describir el conjunto de datos utilizado, mencionar los modelos estadísticos comparados y los criterios de evaluación empleados. Asimismo, se debe incluir el principal resultado del estudio, indicando qué modelo mostró mejor desempeño y bajo qué criterio. El resumen no debe contener citas, ecuaciones ni referencias a secciones del documento.

### Introducción

En esta sección se debe presentar el problema de estudio, describiendo brevemente el contexto en el que surge y su relevancia. Se debe formular claramente el objetivo del trabajo, indicando que se realizará un análisis comparativo utilizando cinco modelos estadísticos vistos en el curso. Asimismo, se debe mencionar de forma general cuáles son los modelos a emplear y qué se espera evaluar de ellos. Finalmente, se debe incluir una breve descripción de la estructura del informe.

### Descripción de los datos

En esta sección se debe describir detalladamente el conjunto de datos utilizado, especificando su origen, número de observaciones y número de variables. Se debe identificar claramente la variable respuesta y las variables explicativas, indicando su naturaleza (continuas, categóricas, discretas, etc.). Además, se debe realizar un análisis exploratorio básico que incluya estadísticas descriptivas y visualizaciones relevantes, así como una breve discusión de posibles problemas en los datos (valores faltantes, outliers, colinealidad, desbalance, entre otros).

### Marco Teórico

En esta sección se deben describir los cinco o más modelos estadísticos utilizados en el análisis. Para cada modelo, se debe presentar una breve descripción teórica, su formulación general, los supuestos principales y el tipo de relación que modela entre las variables. Asimismo, se deben especificar los criterios y métricas que se utilizarán para comparar los modelos (por ejemplo, AIC, BIC, log-verosimilitud, error de predicción, accuracy, ROC, etc.), justificando su elección.

### Metodología

En esta sección se debe explicar el proceso de ajuste de cada uno de los modelos, indicando el método de estimación utilizado y el software o librerías empleadas. Se debe especificar la forma final de cada modelo (variables incluidas, transformaciones realizadas, interacciones, etc.). Asimismo, se debe describir el esquema de validación utilizado (por ejemplo, partición entrenamiento/prueba o validación cruzada), justificando su elección.

### Resultados

En esta sección se deben presentar los resultados obtenidos para cada modelo, incluyendo tablas de parámetros estimados y métricas de desempeño. Los resultados deben presentarse de forma clara mediante tablas y gráficos comparativos que faciliten la lectura. No se requiere aún una interpretación profunda, sino una exposición ordenada y objetiva de los principales resultados numéricos.

### Discusión de resultados

En esta sección se debe realizar una interpretación sustantiva de los resultados obtenidos. Se espera que los estudiantes expliquen el significado de los parámetros estimados, analicen la relación entre las variables y comparen el desempeño de los modelos. Asimismo, se deben discutir las ventajas y limitaciones de cada enfoque, evaluando su coherencia con el problema planteado y con los supuestos teóricos de cada modelo.

### Conclusiones

En esta sección se deben sintetizar los principales hallazgos del trabajo, indicando cuál de los modelos resulta más adecuado para el problema analizado y por qué. Se deben mencionar las principales conclusiones metodológicas y sustantivas, así como las limitaciones del estudio y posibles líneas de trabajo futuro

### Anexo (opcional)

En esta sección se debe incluir el código utilizado para el análisis, así como resultados adicionales, diagnósticos o desarrollos matemáticos que no sean esenciales para la lectura principal del informe, pero que respalden la reproducibilidad y el rigor del trabajo.En esta sección se debe incluir el código utilizado para el análisis, así como resultados adicionales, diagnósticos o desarrollos matemáticos que no sean esenciales para la lectura principal del informe, pero que respalden la reproducibilidad y el rigor del trabajo.


## 3. Presentación (estructura)

1. Entendimiento de la problemática: Se debe explicar el problema a resolver, su contexto y relevancia,
identificando claramente la variable objetivo y el tipo de tarea (predicción, clasificación, inferencia, etc.).

2. Preprocesamiento de datos: Se debe describir cómo se prepararon los datos para el análisis, incluyendo
limpieza, tratamiento de valores faltantes, transformación de variables y cualquier decisión relevante tomada antes del modelado.

3. Proceso de experimentación: Se debe explicar el esquema experimental utilizado, detallando cómo se
dividieron los datos (training, validation y test), cómo se entrenaron los modelos y cómo se seleccionaron los hiperparámetros o configuraciones finales.

4. Medidas de calidad escogidas: Se deben justificar las métricas empleadas para evaluar los modelos,
explicando qué mide cada una y por qué es adecuada para el problema planteado.

5. Interpretación de resultados: Se deben presentar gráficos y tablas comparativas que permitan analizar el desempeño de los modelos, interpretando los resultados de forma sustantiva y no solo numérica.

6. Conclusiones: Se deben sintetizar los principales hallazgos, indicando qué modelo resulta más adecuado,
qué se aprendió del proceso y cuáles son las principales limitaciones del estudio.

## Indicaciones adicionales

- De estos 3 entregables, se obtendrán las notas de la PC2 y Examen Final del curso. La nota de la
PC2 será la evaluación del notebook con el código trabajado (debe seguir la misma estructura que los
análisis mostrados en la presentación, si presentan diferencias se descontará puntaje). La evaluación
del informe y la presentación final formarán parte de la nota del Examen Final.

- Para la exposición, no se evaluará la cantidad de modelos implementados, sino la calidad del análisis,
la interpretación estadística y la capacidad de comparación crítica entre enfoques.

- Se dara enfasis en la interpretación de los resultados de los modelos (como los pesos de coeficientes, odds, etc para los modelos de aprendizaje estadisticos)